-- ========================================
-- GAME DETECTION MODULE
-- Détecte le mode de jeu et les rôles des joueurs
-- ========================================

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = game.Players.LocalPlayer

local GameDetection = {}

-- Variables d'état
local playerRoles = {} -- Stocke les rôles de chaque joueur
local currentGameMode = "Classic" -- Classic, Infection, FreezeTag, Assassin, etc.

-- Callbacks pour notifier les changements
local roleChangeCallbacks = {}
local gameModeChangeCallbacks = {}

function GameDetection.initialize()
	-- Écouter les événements de rôle du jeu
	local Remotes = ReplicatedStorage:WaitForChild("Remotes")
	local GameplayRemotes = Remotes:WaitForChild("Gameplay")
	
	-- Capturer l'attribution des rôles
	GameplayRemotes:WaitForChild("RoleSelect").OnClientEvent:Connect(function(role, teamData, codeImage, hasCode, gameMode, ...)
		-- Sauvegarder notre propre rôle
		playerRoles[player.Name] = role
		currentGameMode = gameMode
		
		print("TMMW Hub - Rôle reçu:", role, "| Mode:", gameMode)
		
		-- Notifier les callbacks
		GameDetection.notifyRoleChange(player.Name, role)
		GameDetection.notifyGameModeChange(gameMode)
		
		-- Mettre à jour après réception du rôle
		task.wait(1)
		GameDetection.notifyRoleChange(player.Name, role)
	end)
	
	-- Capturer les changements de cible pour Assassin
	GameplayRemotes:WaitForChild("ChangeTarget").OnClientEvent:Connect(function(targetName, knifeId, gunId, userId)
		print("Nouvelle cible Assassin:", targetName)
	end)
end

-- Détection améliorée des rôles
function GameDetection.getPlayerRole(targetPlayer)
	if not targetPlayer or not targetPlayer.Character then return nil end
	
	-- Si on a déjà le rôle stocké, l'utiliser
	if playerRoles[targetPlayer.Name] then
		return playerRoles[targetPlayer.Name]
	end
	
	local character = targetPlayer.Character
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	local backpack = targetPlayer:FindFirstChild("Backpack")
	
	-- Vérifier si le joueur est mort
	if humanoid and humanoid.Health <= 0 then
		return "Dead"
	end
	
	-- Vérifier dans le Backpack et le Character
	local function hasKnife()
		if backpack and backpack:FindFirstChild("Knife") then return true end
		if character and character:FindFirstChild("Knife") then return true end
		return false
	end
	
	local function hasGun()
		if backpack and backpack:FindFirstChild("Gun") then return true end
		if character and character:FindFirstChild("Gun") then return true end
		return false
	end
	
	-- Déterminer le rôle selon le mode de jeu
	if currentGameMode == "Classic" then
		if hasKnife() then
			return "Murderer"
		elseif hasGun() then
			return "Sheriff"
		else
			-- Si pas d'arme en Classic, c'est soit Innocent soit pas de rôle encore
			local gameStarted = false
			for _, otherPlayer in pairs(game.Players:GetPlayers()) do
				if otherPlayer ~= targetPlayer and otherPlayer.Character then
					local otherBackpack = otherPlayer:FindFirstChild("Backpack")
					local otherChar = otherPlayer.Character
					if (otherBackpack and (otherBackpack:FindFirstChild("Knife") or otherBackpack:FindFirstChild("Gun"))) or
					   (otherChar and (otherChar:FindFirstChild("Knife") or otherChar:FindFirstChild("Gun"))) then
						gameStarted = true
						break
					end
				end
			end
			
			if gameStarted then
				return "Innocent"
			else
				return "NoRole"
			end
		end
	elseif currentGameMode == "Infection" then
		if hasKnife() then
			return "Zombie"
		else
			return "Survivor"
		end
	elseif currentGameMode == "FreezeTag" then
		if hasGun() then
			return "Freezer"
		else
			return "Runner"
		end
	elseif currentGameMode == "Assassin" then
		return "Assassin"
	end
	
	-- Fallback
	if hasKnife() then
		return "Murderer"
	elseif hasGun() then
		return "Sheriff"
	else
		return "NoRole"
	end
end

function GameDetection.getCurrentGameMode()
	return currentGameMode
end

function GameDetection.getPlayerRoles()
	return playerRoles
end

-- Système de callbacks
function GameDetection.onRoleChange(callback)
	table.insert(roleChangeCallbacks, callback)
end

function GameDetection.onGameModeChange(callback)
	table.insert(gameModeChangeCallbacks, callback)
end

function GameDetection.notifyRoleChange(playerName, role)
	for _, callback in ipairs(roleChangeCallbacks) do
		callback(playerName, role)
	end
end

function GameDetection.notifyGameModeChange(gameMode)
	for _, callback in ipairs(gameModeChangeCallbacks) do
		callback(gameMode)
	end
end

return GameDetection
