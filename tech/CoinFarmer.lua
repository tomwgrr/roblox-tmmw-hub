-- ========================================
-- COIN FARMER - ULTRA FLUID
-- ========================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local CoinFarmer = {}

-- ===== Variables internes =====
local autoFarm = false
local speed = 40 -- studs/sec

-- ===== Fonctions utilitaires =====
local function getHRP()
	local char = player.Character or player.CharacterAdded:Wait()
	return char:WaitForChild("HumanoidRootPart")
end

local function findCoins()
	local coins = {}
	for _, obj in pairs(Workspace:GetDescendants()) do
		if obj:IsA("BasePart") and obj.Name == "Coin_Server" then
			table.insert(coins, obj)
		end
	end
	return coins
end

local function findNearestCoin()
	local hrp = getHRP()
	local nearest = nil
	local minDist = math.huge
	for _, coin in pairs(findCoins()) do
		local dist = (coin.Position - hrp.Position).Magnitude
		if dist < minDist then
			minDist = dist
			nearest = coin
		end
	end
	return nearest
end

-- ===== Boucle principale ultra réactive =====
local function farmLoop()
	local hrp = getHRP()
	while autoFarm do
		local coin = findNearestCoin()
		if coin and coin.Parent then
			RunService.Heartbeat:Wait()
			while coin and coin.Parent and (hrp.Position - coin.Position).Magnitude > 2 and autoFarm do
				local dir = (coin.Position - hrp.Position).Unit
				hrp.CFrame = hrp.CFrame + dir * speed * RunService.Heartbeat:Wait()
			end
		else
			RunService.Heartbeat:Wait()
		end
	end
end

-- ===== API publique =====
function CoinFarmer.setAutoFarm(state)
	autoFarm = state
	if state then
		task.spawn(farmLoop)
	end
end

function CoinFarmer.setSpeed(value)
	speed = math.clamp(value, 10, 200)
end

return CoinFarmer
