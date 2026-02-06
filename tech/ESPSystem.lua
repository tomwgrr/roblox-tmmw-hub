-- ========================================
-- ESP SYSTEM MODULE
-- Gère tous les ESP (visuel des joueurs et objets)
-- ========================================

local GameDetection = getgenv().TMMW.Modules.GameDetection

local ESPSystem = {}

-- État des ESP
local espEnabled = {
	Murderer = false,
	Sheriff = false,
	Innocent = false,
	Zombie = false,
	Survivor = false,
	Freezer = false,
	Runner = false,
	Assassin = false,
	Dead = true,
	NoRole = false,
	Gun = false
}

-- Couleurs selon le rôle
local roleColors = {
	Murderer = Color3.fromRGB(255, 0, 0),
	Sheriff = Color3.fromRGB(0, 0, 255),
	Innocent = Color3.fromRGB(0, 255, 0),
	Zombie = Color3.fromRGB(25, 172, 0),
	Survivor = Color3.fromRGB(43, 154, 238),
	Freezer = Color3.fromRGB(150, 220, 250),
	Runner = Color3.fromRGB(0, 200, 100),
	Assassin = Color3.fromRGB(255, 165, 0),
	Dead = Color3.fromRGB(200, 200, 200),
	NoRole = Color3.fromRGB(255, 255, 255),
	Gun = Color3.fromRGB(255, 165, 0)
}

local espObjects = {}
local gunESPObjects = {}
local playerInfoEnabled = false

function ESPSystem.initialize()
	if not GameDetection then
		warn("[ESP] GameDetection module not loaded")
		return
	end
	
	-- Surveillance périodique
	task.spawn(function()
		while task.wait(2) do
			ESPSystem.updateESP()
			ESPSystem.updateGunESP()
		end
	end)
	
	-- Écouter les changements de rôle
	if GameDetection.onRoleChange then
		GameDetection.onRoleChange(function(playerName, role)
			task.wait(0.5)
			ESPSystem.updateESP()
		end)
	end
	
	-- Événements joueurs
	game.Players.PlayerAdded:Connect(function(newPlayer)
		newPlayer.CharacterAdded:Connect(function()
			task.wait(1)
			ESPSystem.updateESP()
		end)
	end)
	
	for _, existingPlayer in pairs(game.Players:GetPlayers()) do
		existingPlayer.CharacterAdded:Connect(function()
			task.wait(1)
			ESPSystem.updateESP()
		end)
	end
	
	-- Surveiller l'apparition de nouveaux guns
	game.Workspace.DescendantAdded:Connect(function(obj)
		if espEnabled.Gun and obj.Name == "GunDrop" and obj:IsA("BasePart") then
			task.wait(0.1)
			ESPSystem.createGunESP(obj)
		end
	end)
	
	game.Workspace.DescendantRemoving:Connect(function(obj)
		if obj.Name == "GunDrop" and obj:IsA("BasePart") then
			ESPSystem.removeGunESP(obj)
		end
	end)
end

-- Créer un ESP sur un joueur
function ESPSystem.createESP(character, role, color, onlyInfo)
	if not character or not character:FindFirstChild("HumanoidRootPart") then return end
	
	-- Supprimer l'ancien ESP
	local oldESP = character:FindFirstChild("ESP_" .. role)
	if oldESP then oldESP:Destroy() end
	
	local oldInfo = character:FindFirstChild("PlayerInfo_Billboard")
	if oldInfo then oldInfo:Destroy() end
	
	local espFolder = Instance.new("Folder")
	espFolder.Name = "ESP_" .. role
	espFolder.Parent = character
	
	-- Highlight (si ce n'est pas que les infos)
	local highlight = nil
	if not onlyInfo then
		highlight = Instance.new("Highlight")
		highlight.Parent = character
		highlight.FillColor = color
		highlight.FillTransparency = 0.5
		highlight.OutlineColor = color
		highlight.OutlineTransparency = 0
		highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	end
	
	-- BillboardGui (si playerInfoEnabled)
	local billboard = nil
	if playerInfoEnabled then
		billboard = Instance.new("BillboardGui")
		billboard.Name = onlyInfo and "PlayerInfo_Billboard" or "ESP_Billboard"
		billboard.Parent = character.HumanoidRootPart
		billboard.AlwaysOnTop = true
		billboard.Size = UDim2.new(0, 200, 0, 50)
		billboard.StudsOffset = Vector3.new(0, 4.5, 0)
		
		local textLabel = Instance.new("TextLabel")
		textLabel.Parent = billboard
		textLabel.Size = UDim2.new(1, 0, 1, 0)
		textLabel.BackgroundTransparency = 1
		textLabel.Text = character.Name .. "\n[" .. role .. "]"
		textLabel.TextColor3 = onlyInfo and Color3.fromRGB(255, 255, 255) or color
		textLabel.TextStrokeTransparency = 0.5
		textLabel.TextScaled = true
		textLabel.Font = Enum.Font.GothamBold
	end
	
	table.insert(espObjects, {highlight = highlight, billboard = billboard, role = role, character = character, onlyInfo = onlyInfo})
end

-- Créer un ESP pour le gun
function ESPSystem.createGunESP(gunPart)
	if not gunPart or not gunPart:IsA("BasePart") then return end
	if gunPart:FindFirstChild("GunESP_Highlight") then return end
	
	local highlight = Instance.new("Highlight")
	highlight.Name = "GunESP_Highlight"
	highlight.Parent = gunPart
	highlight.FillColor = Color3.fromRGB(255, 165, 0)
	highlight.FillTransparency = 0.3
	highlight.OutlineColor = Color3.fromRGB(255, 165, 0)
	highlight.OutlineTransparency = 0
	highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	
	local billboard = Instance.new("BillboardGui")
	billboard.Name = "GunESP_Billboard"
	billboard.Parent = gunPart
	billboard.AlwaysOnTop = true
	billboard.Size = UDim2.new(0, 100, 0, 30)
	billboard.StudsOffset = Vector3.new(0, 2, 0)
	
	local textLabel = Instance.new("TextLabel")
	textLabel.Parent = billboard
	textLabel.Size = UDim2.new(1, 0, 1, 0)
	textLabel.BackgroundTransparency = 1
	textLabel.Text = "Gun"
	textLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
	textLabel.TextStrokeTransparency = 0.5
	textLabel.TextScaled = true
	textLabel.Font = Enum.Font.GothamBold
	
	table.insert(gunESPObjects, {part = gunPart, highlight = highlight, billboard = billboard})
end

function ESPSystem.removeGunESP(gunPart)
	for i = #gunESPObjects, 1, -1 do
		if gunESPObjects[i].part == gunPart then
			if gunESPObjects[i].highlight then gunESPObjects[i].highlight:Destroy() end
			if gunESPObjects[i].billboard then gunESPObjects[i].billboard:Destroy() end
			table.remove(gunESPObjects, i)
		end
	end
end

function ESPSystem.updateGunESP()
	-- Nettoyer
	for _, gunData in pairs(gunESPObjects) do
		if gunData.highlight then gunData.highlight:Destroy() end
		if gunData.billboard then gunData.billboard:Destroy() end
	end
	gunESPObjects = {}
	
	if not espEnabled.Gun then return end
	
	for _, obj in pairs(game.Workspace:GetDescendants()) do
		if obj.Name == "GunDrop" and obj:IsA("BasePart") then
			ESPSystem.createGunESP(obj)
		end
	end
end

function ESPSystem.updateESP()
	if not GameDetection then return end
	
	-- Nettoyer
	for _, espData in pairs(espObjects) do
		if espData.highlight then espData.highlight:Destroy() end
		if espData.billboard then espData.billboard:Destroy() end
	end
	espObjects = {}
	
	local player = game.Players.LocalPlayer
	
	for _, targetPlayer in pairs(game.Players:GetPlayers()) do
		if targetPlayer ~= player and targetPlayer.Character then
			local role = GameDetection.getPlayerRole and GameDetection.getPlayerRole(targetPlayer) or "NoRole"
			local hasActiveESP = false
			
			if role == "NoRole" then
				hasActiveESP = espEnabled.Innocent
			elseif role and espEnabled[role] then
				hasActiveESP = true
			end
			
			if hasActiveESP and role and roleColors[role] then
				ESPSystem.createESP(targetPlayer.Character, role, roleColors[role], false)
			elseif playerInfoEnabled and role then
				ESPSystem.createESP(targetPlayer.Character, role, Color3.fromRGB(255, 255, 255), true)
			end
		end
	end
end

-- API publique
function ESPSystem.toggleESP(role, enabled)
	espEnabled[role] = enabled
	
	if role == "Gun" then
		ESPSystem.updateGunESP()
	else
		if not enabled then
			-- Supprimer seulement les ESP de ce rôle
			for i = #espObjects, 1, -1 do
				if espObjects[i].role == role then
					if espObjects[i].highlight then espObjects[i].highlight:Destroy() end
					if espObjects[i].billboard then espObjects[i].billboard:Destroy() end
					table.remove(espObjects, i)
				end
			end
		else
			ESPSystem.updateESP()
		end
	end
end

function ESPSystem.setPlayerInfoEnabled(enabled)
	playerInfoEnabled = enabled
	ESPSystem.updateESP()
end

return ESPSystem
