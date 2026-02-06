local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local CoinFarmer = {}

local GameDetection = getgenv().TMMW and getgenv().TMMW.Modules.GameDetection

local autoFarm = false
local speed = 18 -- ralenti pour éviter kick
local cooldown = 0.05
local currentTween = nil

local function getHRP()
	local char = player.Character or player.CharacterAdded:Wait()
	return char:WaitForChild("HumanoidRootPart")
end

local function isInGame()
	-- Vérifie s'il y a au moins un joueur avec un rôle actif (hors Innocent)
	if not GameDetection or not GameDetection.getPlayerRole then
		return false
	end
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= player and p.Character then
			local role = GameDetection.getPlayerRole(p)
			if role and role ~= "Innocent" and role ~= "NoRole" and role ~= "Dead" then
				return true
			end
		end
	end
	return false
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
	if not autoFarm or not isInGame() then 
		task.wait(1)
		task.spawn(farmStep)
		return 
	end

	local hrp = getHRP()
	local coin = findNearestCoin()
	if coin then
		-- Annuler le tween précédent
		if currentTween then
			currentTween:Cancel()
			currentTween = nil
		end

		-- Si trop proche, simuler la collecte et passer à la suivante
		local distance = (coin.Position - hrp.Position).Magnitude
		if distance < 3 then
			task.wait(cooldown)
			task.spawn(farmStep)
			return
		end

		local tweenTime = distance / speed
		local tweenInfo = TweenInfo.new(tweenTime, Enum.EasingStyle.Linear)
		currentTween = TweenService:Create(hrp, tweenInfo, {CFrame = coin.CFrame - Vector3.new(0,1,0)})
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

function CoinFarmer.setAutoFarm(state)
	autoFarm = state
	if state then
		task.spawn(farmStep)
	else
		if currentTween then
			currentTween:Cancel()
			currentTween = nil
		end
	end
end

function CoinFarmer.setSpeed(value)
	speed = math.clamp(value, 10, 200)
end

function CoinFarmer.setCooldown(value)
	cooldown = math.clamp(value, 0, 0.3)
end

return CoinFarmer
