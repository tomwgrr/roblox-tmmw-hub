-- ========================================
-- COIN FARMER - SMOOTH + IGNORE SERVER
-- ========================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local CoinFarmer = {}

-- ===== Variables =====
local autoFarm = false
local speed = 40 -- studs/sec
local cooldown = 0.08 -- temps mini après chaque coin pour éviter lag

-- ===== Utilitaires =====
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

-- ===== Boucle principale =====
local function farmLoop()
	local hrp = getHRP()
	while autoFarm do
		local coin = findNearestCoin()
		if coin then
			-- Déplacer frame par frame vers la coin
			while coin and (hrp.Position - coin.Position).Magnitude > 3 and autoFarm do
				local dir = (coin.Position - hrp.Position).Unit
				hrp.CFrame = hrp.CFrame + dir * speed * RunService.Heartbeat:Wait()
			end
			-- Dès qu'on “touche” la coin, mini cooldown avant de passer à la suivante
			if autoFarm then
				task.wait(cooldown)
			end
		else
			RunService.Heartbeat:Wait() -- pas de coin dispo
		end
	end
end

-- ===== API =====
function CoinFarmer.setAutoFarm(state)
	autoFarm = state
	if state then
		task.spawn(farmLoop)
	end
end

function CoinFarmer.setSpeed(value)
	speed = math.clamp(value, 10, 200)
end

function CoinFarmer.setCooldown(value)
	cooldown = math.clamp(value, 0, 0.3) -- limite pour éviter lag
end

return CoinFarmer
