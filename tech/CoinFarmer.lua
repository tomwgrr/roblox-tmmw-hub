local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local PREMIUM_PASS_ID = 9696634781

local CoinFarmer = {}
local autoFarm = false
local speed = 25
local cooldown = 0.05
local currentTween = nil

-- ========================================
-- PREMIUM VERIFICATION
-- ========================================

local function hasPremium()
	local success, result = pcall(function()
		return MarketplaceService:UserOwnsGamePassAsync(player.UserId, PREMIUM_PASS_ID)
	end)
	return success and result
end

-- ========================================
-- CORE FUNCTIONS
-- ========================================

local function getHRP()
	local char = player.Character or player.CharacterAdded:Wait()
	return char:WaitForChild("HumanoidRootPart")
end

local function findNearestCoin()
	local hrp = getHRP()
	local nearest = nil
	local minDist = math.huge
	
	for _, obj in pairs(Workspace:GetDescendants()) do
		if obj:IsA("BasePart") and obj.Name == "Coin_Server" then
			local dist = (obj.Position - hrp.Position).Magnitude
			if dist < minDist then
				minDist = dist
				nearest = obj
			end
		end
	end
	
	return nearest
end

local function farmStep()
	if not autoFarm then return end
	
	local hrp = getHRP()
	local coin = findNearestCoin()
	
	if coin then
		if currentTween then
			currentTween:Cancel()
			currentTween = nil
		end
		
		local distance = (coin.Position - hrp.Position).Magnitude
		if distance < 3 then
			coin.Parent = nil
			task.wait(cooldown)
			task.spawn(farmStep)
			return
		end
		
		local tweenTime = distance / speed
		local tweenInfo = TweenInfo.new(tweenTime, Enum.EasingStyle.Linear)
		currentTween = TweenService:Create(hrp, tweenInfo, {CFrame = coin.CFrame})
		
		currentTween.Completed:Connect(function()
			currentTween = nil
			task.wait(cooldown)
			task.spawn(farmStep)
		end)
		
		currentTween:Play()
	else
		task.wait(0.1)
		task.spawn(farmStep)
	end
end

-- ========================================
-- PUBLIC FUNCTIONS (PREMIUM PROTECTED)
-- ========================================

function CoinFarmer.setAutoFarm(state)
	if not hasPremium() then
		warn("[TMMW] Premium required for Auto Farm Coins")
		return false
	end
	
	autoFarm = state
	if state then
		task.spawn(farmStep)
	else
		if currentTween then
			currentTween:Cancel()
			currentTween = nil
		end
	end
	return true
end

function CoinFarmer.setSpeed(value)
	if not hasPremium() then
		warn("[TMMW] Premium required")
		return false
	end
	
	speed = math.clamp(value, 10, 200)
	return true
end

function CoinFarmer.setCooldown(value)
	if not hasPremium() then
		warn("[TMMW] Premium required")
		return false
	end
	
	cooldown = math.clamp(value, 0, 0.3)
	return true
end

function CoinFarmer.hasPremium()
	return hasPremium()
end

function CoinFarmer.initialize()
	print("[TMMW] CoinFarmer initialized")
end

return CoinFarmer
