-- ========================================
-- COIN FARMER (STABLE VERSION)
-- ========================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local CoinFarmer = {}

local autoFarm = false
local currentTween = nil

-- Cache des coins
local coinFolder

local function getCharacter()
	return player.Character or player.CharacterAdded:Wait()
end

local function getHRP()
	local char = getCharacter()
	return char:WaitForChild("HumanoidRootPart")
end

local function getCoinFolder()
	if coinFolder and coinFolder.Parent then
		return coinFolder
	end

	for _, v in pairs(workspace:GetChildren()) do
		if v.Name:lower():find("coin") then
			coinFolder = v
			return v
		end
	end

	return workspace
end

local function findNearestCoin()
	local hrp = getHRP()
	local nearest, dist = nil, math.huge

	for _, coin in pairs(getCoinFolder():GetDescendants()) do
		if coin:IsA("BasePart") and coin.Name == "Coin_Server" then
			local d = (coin.Position - hrp.Position).Magnitude
			if d < dist then
				dist = d
				nearest = coin
			end
		end
	end

	return nearest, dist
end

local function moveToCoin(coin)
	local hrp = getHRP()
	if not coin or not coin.Parent then return end

	if currentTween then
		currentTween:Cancel()
		currentTween = nil
	end

	local dist = (coin.Position - hrp.Position).Magnitude
	if dist < 4 then
		hrp.CFrame = coin.CFrame
		return
	end

	local tweenTime = dist / 30
	currentTween = TweenService:Create(
		hrp,
		TweenInfo.new(tweenTime, Enum.EasingStyle.Linear),
		{ CFrame = coin.CFrame }
	)

	currentTween:Play()
	currentTween.Completed:Wait()
	currentTween = nil
end

-- Boucle principale
task.spawn(function()
	while true do
		if autoFarm then
			local coin = findNearestCoin()
			if coin then
				moveToCoin(coin)
			end
		end
		task.wait(0.15)
	end
end)

-- API
function CoinFarmer.setAutoFarm(state)
	autoFarm = state

	if not state and currentTween then
		currentTween:Cancel()
		currentTween = nil
	end
end

return CoinFarmer
