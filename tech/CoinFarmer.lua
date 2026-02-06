-- ========================================
-- COIN FARMER - STABLE & DYNAMIC
-- ========================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local CoinFarmer = {}

-- ===== Variables internes =====
local autoFarm = false
local farmTask = nil
local speed = 40 -- studs/sec

-- ===== Fonctions utilitaires =====
local function getCharacter()
	return player.Character or player.CharacterAdded:Wait()
end

local function getHRP()
	local char = getCharacter()
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

-- ===== Mouvement fluide vers la coin =====
local function moveToCoin(coin)
	local hrp = getHRP()
	if not coin or not coin.Parent then return end

	while coin and coin.Parent and (hrp.Position - coin.Position).Magnitude > 2 and autoFarm do
		local dir = (coin.Position - hrp.Position).Unit
		hrp.CFrame = hrp.CFrame + dir * speed * RunService.RenderStepped:Wait()
	end
end

-- ===== Boucle principale =====
local function farmLoop()
	while autoFarm do
		local coin = findNearestCoin()
		if coin then
			pcall(function()
				moveToCoin(coin)
			end)
			task.wait(0.05) -- petite pause après la collecte
		else
			task.wait(0.2) -- pas de coin dispo
		end
	end
end

-- ===== API publique =====
function CoinFarmer.setAutoFarm(state)
	autoFarm = state
	if state and (not farmTask or not farmTask.Running) then
		farmTask = task.spawn(farmLoop)
	end
end

-- Optionnel : ajuster la vitesse dynamiquement
function CoinFarmer.setSpeed(value)
	speed = math.clamp(value, 10, 200)
end

return CoinFarmer
