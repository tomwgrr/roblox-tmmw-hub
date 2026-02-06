-- ========================================
-- COIN FARMER STABLE VERSION (MM2)
-- ========================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local CoinFarmer = {}

-- ========== Variables internes ==========
local autoFarm = false
local coinFolder = nil

-- ========== Fonctions utilitaires ==========
local function getCharacter()
	return player.Character or player.CharacterAdded:Wait()
end

local function getHRP()
	local char = getCharacter()
	return char:WaitForChild("HumanoidRootPart")
end

local function findCoinFolder()
	if coinFolder and coinFolder.Parent then
		return coinFolder
	end

	-- Cherche le parent des coins
	for _, obj in pairs(workspace:GetChildren()) do
		if obj.Name:lower():find("coin") then
			coinFolder = obj
			return obj
		end
	end

	return workspace
end

local function findNearestCoin()
	local hrp = getHRP()
	local nearest = nil
	local shortestDist = math.huge

	for _, coin in pairs(findCoinFolder():GetDescendants()) do
		if coin:IsA("BasePart") and coin.Name == "Coin_Server" then
			local dist = (coin.Position - hrp.Position).Magnitude
			if dist < shortestDist then
				shortestDist = dist
				nearest = coin
			end
		end
	end

	return nearest
end

-- ========== Fonction de mouvement fluide ==========
local function moveToCoin(coin)
	local hrp = getHRP()
	if not coin or not coin.Parent then return end

	local speed = 40 -- studs/sec
	while coin and coin.Parent and (hrp.Position - coin.Position).Magnitude > 2 do
		local direction = (coin.Position - hrp.Position).Unit
		hrp.CFrame = hrp.CFrame + direction * speed * RunService.RenderStepped:Wait()
	end
end

-- ========== Boucle principale ==========
task.spawn(function()
	while true do
		if autoFarm then
			local coin = findNearestCoin()
			if coin then
				pcall(function()
					moveToCoin(coin)
				end)
				-- Attendre un petit peu après la collecte
				task.wait(0.05)
			else
				-- Pas de coin disponible
				task.wait(0.2)
			end
		else
			task.wait(0.5)
		end
	end
end)

-- ========== API publique ==========
function CoinFarmer.setAutoFarm(state)
	autoFarm = state
end

return CoinFarmer
