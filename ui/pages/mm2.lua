-- ========================================
-- MURDER MYSTERY 2 PAGE
-- ========================================

local Components = getgenv().TMMW.Modules.Components
local ESPSystem = getgenv().TMMW.Modules.ESPSystem
local GunGrabber = getgenv().TMMW.Modules.GunGrabber
local CoinFarmer = getgenv().TMMW.Modules.CoinFarmer

local MM2Page = {}

function MM2Page.create(scrollFrame)
	local yOffset = 10
	
	-- ===== VISUAL SECTION =====
	Components.createSectionTitle(scrollFrame, yOffset, "Visual")
	yOffset = yOffset + 35
	Components.createSeparator(scrollFrame, yOffset)
	yOffset = yOffset + 10
	
	-- Player Info Toggle
	if ESPSystem then
		Components.createToggle(scrollFrame, yOffset, "Player Info (Name & Role)", function(enabled)
			ESPSystem.setPlayerInfoEnabled(enabled)
		end)
		yOffset = yOffset + 50
	end
	
	-- ===== CLASSIC MODE =====
	local classicTitle = Instance.new("TextLabel")
	classicTitle.Parent = scrollFrame
	classicTitle.Size = UDim2.new(1, -20, 0, 25)
	classicTitle.Position = UDim2.new(0, 10, 0, yOffset)
	classicTitle.BackgroundTransparency = 1
	classicTitle.Text = "Classic Mode"
	classicTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
	classicTitle.Font = Enum.Font.GothamBold
	classicTitle.TextSize = 14
	classicTitle.TextXAlignment = Enum.TextXAlignment.Left
	yOffset = yOffset + 30
	
	-- ESP Toggles pour Classic Mode
	if ESPSystem then
		Components.createToggle(scrollFrame, yOffset, "Murderer ESP", function(enabled)
			ESPSystem.toggleESP("Murderer", enabled)
		end)
		yOffset = yOffset + 50
		
		Components.createToggle(scrollFrame, yOffset, "Sheriff ESP", function(enabled)
			ESPSystem.toggleESP("Sheriff", enabled)
		end)
		yOffset = yOffset + 50
		
		Components.createToggle(scrollFrame, yOffset, "Innocent ESP", function(enabled)
			ESPSystem.toggleESP("Innocent", enabled)
		end)
		yOffset = yOffset + 50
		
		Components.createToggle(scrollFrame, yOffset, "Gun (Dropped) ESP", function(enabled)
			ESPSystem.toggleESP("Gun", enabled)
		end)
		yOffset = yOffset + 50
	end
	
	-- Grab Gun Once Button
	if GunGrabber then
		Components.createButton(scrollFrame, yOffset, "Grab Gun Once", "GRAB", function(button)
			local success = GunGrabber.grabOnce()
			if success then
				button.Text = "✓ GRABBED"
				button.BackgroundColor3 = Color3.fromRGB(40, 200, 40)
				task.wait(1)
				button.Text = "GRAB"
				button.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
			else
				button.Text = "NO GUN"
				button.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
				task.wait(1)
				button.Text = "GRAB"
				button.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
			end
		end)
		yOffset = yOffset + 50
		
		-- Auto Grab Gun Toggle
		Components.createToggle(scrollFrame, yOffset, "Auto Grab Gun", function(enabled)
			GunGrabber.setAutoGrab(enabled)
		end)
		yOffset = yOffset + 50
	end
	
	-- ===== INFECTION MODE =====
	local infectionTitle = Instance.new("TextLabel")
	infectionTitle.Parent = scrollFrame
	infectionTitle.Size = UDim2.new(1, -20, 0, 25)
	infectionTitle.Position = UDim2.new(0, 10, 0, yOffset)
	infectionTitle.BackgroundTransparency = 1
	infectionTitle.Text = "Infection Mode"
	infectionTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
	infectionTitle.Font = Enum.Font.GothamBold
	infectionTitle.TextSize = 14
	infectionTitle.TextXAlignment = Enum.TextXAlignment.Left
	yOffset = yOffset + 30
	
	if ESPSystem then
		Components.createToggle(scrollFrame, yOffset, "Zombie ESP", function(enabled)
			ESPSystem.toggleESP("Zombie", enabled)
		end)
		yOffset = yOffset + 50
		
		Components.createToggle(scrollFrame, yOffset, "Survivor ESP", function(enabled)
			ESPSystem.toggleESP("Survivor", enabled)
		end)
		yOffset = yOffset + 50
	end
	
	-- ===== FREEZE TAG =====
	local freezeTitle = Instance.new("TextLabel")
	freezeTitle.Parent = scrollFrame
	freezeTitle.Size = UDim2.new(1, -20, 0, 25)
	freezeTitle.Position = UDim2.new(0, 10, 0, yOffset)
	freezeTitle.BackgroundTransparency = 1
	freezeTitle.Text = "Freeze Tag"
	freezeTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
	freezeTitle.Font = Enum.Font.GothamBold
	freezeTitle.TextSize = 14
	freezeTitle.TextXAlignment = Enum.TextXAlignment.Left
	yOffset = yOffset + 30
	
	if ESPSystem then
		Components.createToggle(scrollFrame, yOffset, "Freezer ESP", function(enabled)
			ESPSystem.toggleESP("Freezer", enabled)
		end)
		yOffset = yOffset + 50
		
		Components.createToggle(scrollFrame, yOffset, "Runner ESP", function(enabled)
			ESPSystem.toggleESP("Runner", enabled)
		end)
		yOffset = yOffset + 50
	end
	
	-- ===== ASSASSIN MODE =====
	local assassinTitle = Instance.new("TextLabel")
	assassinTitle.Parent = scrollFrame
	assassinTitle.Size = UDim2.new(1, -20, 0, 25)
	assassinTitle.Position = UDim2.new(0, 10, 0, yOffset)
	assassinTitle.BackgroundTransparency = 1
	assassinTitle.Text = "Assassin Mode"
	assassinTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
	assassinTitle.Font = Enum.Font.GothamBold
	assassinTitle.TextSize = 14
	assassinTitle.TextXAlignment = Enum.TextXAlignment.Left
	yOffset = yOffset + 30
	
	if ESPSystem then
		Components.createToggle(scrollFrame, yOffset, "Assassin ESP", function(enabled)
			ESPSystem.toggleESP("Assassin", enabled)
		end)
		yOffset = yOffset + 50
	end
	
	-- ===== COMBAT SECTION =====
	Components.createSectionTitle(scrollFrame, yOffset, "Combat")
	yOffset = yOffset + 35
	Components.createSeparator(scrollFrame, yOffset)
	yOffset = yOffset + 10
	
	-- ===== SHERIFF =====
	local sheriffTitle = Instance.new("TextLabel")
	sheriffTitle.Parent = scrollFrame
	sheriffTitle.Size = UDim2.new(1, -20, 0, 25)
	sheriffTitle.Position = UDim2.new(0, 10, 0, yOffset)
	sheriffTitle.BackgroundTransparency = 1
	sheriffTitle.Text = "Sheriff"
	sheriffTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
	sheriffTitle.Font = Enum.Font.GothamBold
	sheriffTitle.TextSize = 14
	sheriffTitle.TextXAlignment = Enum.TextXAlignment.Left
	yOffset = yOffset + 30
	
	Components.createToggle(scrollFrame, yOffset, "Silent Aim", function(enabled)
		print("Silent Aim:", enabled)
	end)
	yOffset = yOffset + 50
	
	Components.createToggle(scrollFrame, yOffset, "Aimbot", function(enabled)
		print("Aimbot:", enabled)
	end)
	yOffset = yOffset + 50
	
	Components.createToggle(scrollFrame, yOffset, "Auto Shoot Murderer", function(enabled)
		print("Auto Shoot:", enabled)
	end)
	yOffset = yOffset + 50
	
	-- ===== MURDERER =====
	local murdererTitle = Instance.new("TextLabel")
	murdererTitle.Parent = scrollFrame
	murdererTitle.Size = UDim2.new(1, -20, 0, 25)
	murdererTitle.Position = UDim2.new(0, 10, 0, yOffset)
	murdererTitle.BackgroundTransparency = 1
	murdererTitle.Text = "Murderer"
	murdererTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
	murdererTitle.Font = Enum.Font.GothamBold
	murdererTitle.TextSize = 14
	murdererTitle.TextXAlignment = Enum.TextXAlignment.Left
	yOffset = yOffset + 30
	
	Components.createToggle(scrollFrame, yOffset, "Kill Aura", function(enabled)
		print("Kill Aura:", enabled)
	end)
	yOffset = yOffset + 50
	
	-- Kill All Players Button
	Components.createButton(scrollFrame, yOffset, "Kill All Players", "KILL ALL", function(button)
		button.Text = "KILLING..."
		button.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
		
		-- Simuler une action
		task.wait(1)
		
		button.Text = "✓ KILLED 5"
		button.BackgroundColor3 = Color3.fromRGB(40, 200, 40)
		task.wait(2)
		button.Text = "KILL ALL"
		button.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
	end)
	yOffset = yOffset + 50
	
	-- Kill Specific Player (avec dropdown des joueurs)
	local killPlayerFrame = Instance.new("Frame")
	killPlayerFrame.Parent = scrollFrame
	killPlayerFrame.Size = UDim2.new(1, -20, 0, 100)
	killPlayerFrame.Position = UDim2.new(0, 10, 0, yOffset)
	killPlayerFrame.BackgroundTransparency = 1
	
	local killPlayerLabel = Instance.new("TextLabel")
	killPlayerLabel.Parent = killPlayerFrame
	killPlayerLabel.Size = UDim2.new(1, 0, 0, 20)
	killPlayerLabel.Position = UDim2.new(0, 0, 0, 0)
	killPlayerLabel.BackgroundTransparency = 1
	killPlayerLabel.Text = "Kill Specific Player:"
	killPlayerLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
	killPlayerLabel.Font = Enum.Font.Gotham
	killPlayerLabel.TextSize = 13
	killPlayerLabel.TextXAlignment = Enum.TextXAlignment.Left
	
	-- Liste déroulante des joueurs
	local playerDropdown = Instance.new("ScrollingFrame")
	playerDropdown.Parent = killPlayerFrame
	playerDropdown.Size = UDim2.new(1, 0, 0, 50)
	playerDropdown.Position = UDim2.new(0, 0, 0, 25)
	playerDropdown.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
	playerDropdown.BorderSizePixel = 0
	playerDropdown.ScrollBarThickness = 4
	playerDropdown.CanvasSize = UDim2.new(0, 0, 0, 0)
	
	local dropdownCorner = Instance.new("UICorner")
	dropdownCorner.CornerRadius = UDim.new(0, 6)
	dropdownCorner.Parent = playerDropdown
	
	local selectedPlayer = nil
	
	-- Fonction pour rafraîchir la liste des joueurs
	local function refreshPlayerList()
		for _, child in pairs(playerDropdown:GetChildren()) do
			if child:IsA("TextButton") then
				child:Destroy()
			end
		end
		
		local Players = game:GetService("Players")
		local LocalPlayer = Players.LocalPlayer
		local yPos = 0
		
		for _, player in pairs(Players:GetPlayers()) do
			if player ~= LocalPlayer then
				local playerButton = Instance.new("TextButton")
				playerButton.Parent = playerDropdown
				playerButton.Size = UDim2.new(1, -8, 0, 25)
				playerButton.Position = UDim2.new(0, 4, 0, yPos)
				playerButton.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
				playerButton.BorderSizePixel = 0
				playerButton.Text = player.Name
				playerButton.TextColor3 = Color3.fromRGB(200, 200, 200)
				playerButton.Font = Enum.Font.Gotham
				playerButton.TextSize = 12
				playerButton.AutoButtonColor = false
				
				local btnCorner = Instance.new("UICorner")
				btnCorner.CornerRadius = UDim.new(0, 4)
				btnCorner.Parent = playerButton
				
				playerButton.MouseButton1Click:Connect(function()
					selectedPlayer = player
					
					-- Mettre à jour l'apparence des boutons
					for _, btn in pairs(playerDropdown:GetChildren()) do
						if btn:IsA("TextButton") then
							btn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
						end
					end
					playerButton.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
				end)
				
				yPos = yPos + 28
			end
		end
		
		playerDropdown.CanvasSize = UDim2.new(0, 0, 0, yPos)
	end
	
	-- Rafraîchir la liste au départ
	refreshPlayerList()
	
	-- Rafraîchir la liste quand un joueur rejoint/quitte
	game:GetService("Players").PlayerAdded:Connect(refreshPlayerList)
	game:GetService("Players").PlayerRemoving:Connect(refreshPlayerList)
	
	-- Bouton pour kill le joueur sélectionné
	local killSelectedButton = Instance.new("TextButton")
	killSelectedButton.Parent = killPlayerFrame
	killSelectedButton.Size = UDim2.new(1, 0, 0, 20)
	killSelectedButton.Position = UDim2.new(0, 0, 0, 80)
	killSelectedButton.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
	killSelectedButton.BorderSizePixel = 0
	killSelectedButton.Text = "KILL SELECTED"
	killSelectedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	killSelectedButton.Font = Enum.Font.GothamBold
	killSelectedButton.TextSize = 12
	killSelectedButton.AutoButtonColor = false
	
	local killBtnCorner = Instance.new("UICorner")
	killBtnCorner.CornerRadius = UDim.new(0, 6)
	killBtnCorner.Parent = killSelectedButton
	
	killSelectedButton.MouseEnter:Connect(function()
		killSelectedButton.BackgroundColor3 = Color3.fromRGB(158, 63, 246)
	end)
	
	killSelectedButton.MouseLeave:Connect(function()
		killSelectedButton.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
	end)
	
	killSelectedButton.MouseButton1Click:Connect(function()
		if not selectedPlayer then
			killSelectedButton.Text = "SELECT PLAYER"
			killSelectedButton.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
			task.wait(1.5)
			killSelectedButton.Text = "KILL SELECTED"
			killSelectedButton.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
			return
		end
		
		killSelectedButton.Text = "KILLING..."
		killSelectedButton.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
		
		-- Simuler une action
		task.wait(1)
		print("Killing:", selectedPlayer.Name)
		
		killSelectedButton.Text = "✓ KILLED"
		killSelectedButton.BackgroundColor3 = Color3.fromRGB(40, 200, 40)
		task.wait(1.5)
		killSelectedButton.Text = "KILL SELECTED"
		killSelectedButton.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
	end)
	
	yOffset = yOffset + 110
	
	-- ===== MISCELLANEOUS =====
	Components.createSectionTitle(scrollFrame, yOffset, "Miscellaneous")
	yOffset = yOffset + 35
	Components.createSeparator(scrollFrame, yOffset)
	yOffset = yOffset + 10
	
	if CoinFarmer then
		Components.createToggle(scrollFrame, yOffset, "Auto Farm Coins", function(enabled)
			CoinFarmer.setAutoFarm(enabled)
		end)
		yOffset = yOffset + 50
	end
	
	-- Ajuster la taille du canvas
	scrollFrame.CanvasSize = UDim2.new(0, 0, 0, yOffset + 20)
end

return MM2Page
