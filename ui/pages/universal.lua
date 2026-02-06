-- ========================================
-- UNIVERSAL PAGE - EXTENDED
-- ========================================

local Components = getgenv().TMMW.Modules.Components
local UniversalFeatures = getgenv().TMMW.Modules.UniversalFeatures

local UniversalPage = {}

function UniversalPage.create(scrollFrame)
	local yOffset = 10
	
	-- ===== MOVEMENT SECTION =====
	Components.createSectionTitle(scrollFrame, yOffset, "Movement")
	yOffset = yOffset + 35
	Components.createSeparator(scrollFrame, yOffset)
	yOffset = yOffset + 10
	
	if UniversalFeatures then
		-- Fly Toggle
		Components.createToggle(scrollFrame, yOffset, "Fly", function(enabled)
			UniversalFeatures.setFly(enabled)
		end)
		yOffset = yOffset + 50
		
		-- Fly Speed Slider
		Components.createSlider(scrollFrame, yOffset, "Fly Speed", 10, 200, 50, function(value)
			UniversalFeatures.setFlySpeed(value)
		end)
		yOffset = yOffset + 70
		
		-- Noclip
		Components.createToggle(scrollFrame, yOffset, "Noclip", function(enabled)
			UniversalFeatures.setNoclip(enabled)
		end)
		yOffset = yOffset + 50
		
		-- WalkSpeed
		Components.createSlider(scrollFrame, yOffset, "Walk Speed", 16, 200, 16, function(value)
			UniversalFeatures.setWalkSpeed(value)
		end)
		yOffset = yOffset + 70
		
		-- JumpPower
		Components.createSlider(scrollFrame, yOffset, "Jump Power", 50, 300, 50, function(value)
			UniversalFeatures.setJumpPower(value)
		end)
		yOffset = yOffset + 70
		
		-- Infinite Jump
		Components.createToggle(scrollFrame, yOffset, "Infinite Jump", function(enabled)
			UniversalFeatures.setInfiniteJump(enabled)
		end)
		yOffset = yOffset + 50
		
		-- Platform
		Components.createToggle(scrollFrame, yOffset, "Platform", function(enabled)
			UniversalFeatures.setPlatform(enabled)
		end)
		yOffset = yOffset + 50
		
		-- Carpet Ride
		Components.createToggle(scrollFrame, yOffset, "Carpet Ride", function(enabled)
			UniversalFeatures.setCarpet(enabled)
		end)
		yOffset = yOffset + 50
		
		-- Click TP
		Components.createToggle(scrollFrame, yOffset, "Click TP (CTRL + Click)", function(enabled)
			UniversalFeatures.setClickTP(enabled)
		end)
		yOffset = yOffset + 50
		
		-- Auto Jump
		Components.createToggle(scrollFrame, yOffset, "Auto Jump", function(enabled)
			UniversalFeatures.setAutoJump(enabled)
		end)
		yOffset = yOffset + 50
		
		-- Walk on Walls
		Components.createToggle(scrollFrame, yOffset, "Walk on Walls", function(enabled)
			UniversalFeatures.setWalkOnWalls(enabled)
		end)
		yOffset = yOffset + 50
		
		-- Walk Backwards
		Components.createToggle(scrollFrame, yOffset, "Walk Backwards", function(enabled)
			UniversalFeatures.setWalkBackwards(enabled)
		end)
		yOffset = yOffset + 50
		
		-- Freeze Character
		Components.createToggle(scrollFrame, yOffset, "Freeze Character", function(enabled)
			UniversalFeatures.setFreezeCharacter(enabled)
		end)
		yOffset = yOffset + 50
		
		-- Gravity Control
		Components.createToggle(scrollFrame, yOffset, "Zero Gravity", function(enabled)
			UniversalFeatures.toggleGravity()
		end)
		yOffset = yOffset + 50
		
		Components.createSlider(scrollFrame, yOffset, "Custom Gravity", 0, 196, 196, function(value)
			UniversalFeatures.setGravity(value)
		end)
		yOffset = yOffset + 70
	end
	
	-- ===== VISUAL SECTION =====
	yOffset = yOffset + 10
	Components.createSectionTitle(scrollFrame, yOffset, "Visual")
	yOffset = yOffset + 35
	Components.createSeparator(scrollFrame, yOffset)
	yOffset = yOffset + 10
	
	if UniversalFeatures then
		-- X-Ray
		Components.createToggle(scrollFrame, yOffset, "X-Ray", function(enabled)
			UniversalFeatures.setXRay(enabled)
		end)
		yOffset = yOffset + 50
		
		-- Fullbright
		Components.createToggle(scrollFrame, yOffset, "Fullbright", function(enabled)
			UniversalFeatures.setFullbright(enabled)
		end)
		yOffset = yOffset + 50
		
		-- Remove Fog
		Components.createToggle(scrollFrame, yOffset, "Remove Fog", function(enabled)
			UniversalFeatures.setRemoveFog(enabled)
		end)
		yOffset = yOffset + 50
		
		-- FOV Changer
		Components.createSlider(scrollFrame, yOffset, "Field of View", 70, 120, 70, function(value)
			UniversalFeatures.setFOV(value)
		end)
		yOffset = yOffset + 70
		
		-- ESP Distance
		Components.createSlider(scrollFrame, yOffset, "ESP Distance", 100, 5000, 5000, function(value)
			UniversalFeatures.setESPDistance(value)
		end)
		yOffset = yOffset + 70
		
		-- Invisible
		Components.createToggle(scrollFrame, yOffset, "Invisible", function(enabled)
			UniversalFeatures.setInvisible(enabled)
		end)
		yOffset = yOffset + 50
		
		-- Headless
		Components.createToggle(scrollFrame, yOffset, "Headless", function(enabled)
			UniversalFeatures.setHeadless(enabled)
		end)
		yOffset = yOffset + 50
		
		-- Big Head
		Components.createToggle(scrollFrame, yOffset, "Big Head", function(enabled)
			UniversalFeatures.setBigHead(enabled, 10)
		end)
		yOffset = yOffset + 50
		
		-- Long Neck
		Components.createToggle(scrollFrame, yOffset, "Long Neck", function(enabled)
			UniversalFeatures.setLongNeck(enabled)
		end)
		yOffset = yOffset + 50
		
		-- Camera Shake (Troll)
		Components.createToggle(scrollFrame, yOffset, "Camera Shake", function(enabled)
			UniversalFeatures.setCameraShake(enabled)
		end)
		yOffset = yOffset + 50
	end
	
	-- ===== COMBAT SECTION =====
	yOffset = yOffset + 10
	Components.createSectionTitle(scrollFrame, yOffset, "Combat")
	yOffset = yOffset + 35
	Components.createSeparator(scrollFrame, yOffset)
	yOffset = yOffset + 10
	
	if UniversalFeatures then
		-- Rapid Punch
		Components.createToggle(scrollFrame, yOffset, "Rapid Punch", function(enabled)
			UniversalFeatures.setRapidPunch(enabled)
		end)
		yOffset = yOffset + 50
		
		-- Spinbot
		Components.createToggle(scrollFrame, yOffset, "Spinbot", function(enabled)
			UniversalFeatures.setSpinbot(enabled)
		end)
		yOffset = yOffset + 50
		
		Components.createSlider(scrollFrame, yOffset, "Spinbot Speed", 1, 50, 20, function(value)
			UniversalFeatures.setSpinbotSpeed(value)
		end)
		yOffset = yOffset + 70
	end
	
	-- ===== TELEPORT SECTION =====
	yOffset = yOffset + 10
	Components.createSectionTitle(scrollFrame, yOffset, "Teleport")
	yOffset = yOffset + 35
	Components.createSeparator(scrollFrame, yOffset)
	yOffset = yOffset + 10
	
	-- Teleport to Players (liste)
	local tpContainer = Instance.new("Frame")
	tpContainer.Parent = scrollFrame
	tpContainer.Size = UDim2.new(1, -20, 0, 200)
	tpContainer.Position = UDim2.new(0, 10, 0, yOffset)
	tpContainer.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	tpContainer.BorderSizePixel = 0
	
	local tpCorner = Instance.new("UICorner")
	tpCorner.CornerRadius = UDim.new(0, 6)
	tpCorner.Parent = tpContainer
	
	local tpLabel = Instance.new("TextLabel")
	tpLabel.Parent = tpContainer
	tpLabel.Size = UDim2.new(1, -20, 0, 25)
	tpLabel.Position = UDim2.new(0, 10, 0, 5)
	tpLabel.BackgroundTransparency = 1
	tpLabel.Text = "Teleport to Player"
	tpLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	tpLabel.Font = Enum.Font.GothamBold
	tpLabel.TextSize = 14
	tpLabel.TextXAlignment = Enum.TextXAlignment.Left
	
	local playerScrollFrame = Instance.new("ScrollingFrame")
	playerScrollFrame.Parent = tpContainer
	playerScrollFrame.Size = UDim2.new(1, -20, 1, -40)
	playerScrollFrame.Position = UDim2.new(0, 10, 0, 30)
	playerScrollFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	playerScrollFrame.BorderSizePixel = 0
	playerScrollFrame.ScrollBarThickness = 4
	playerScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(138, 43, 226)
	
	local playerScrollCorner = Instance.new("UICorner")
	playerScrollCorner.CornerRadius = UDim.new(0, 4)
	playerScrollCorner.Parent = playerScrollFrame
	
	local playerListLayout = Instance.new("UIListLayout")
	playerListLayout.Parent = playerScrollFrame
	playerListLayout.SortOrder = Enum.SortOrder.Name
	playerListLayout.Padding = UDim.new(0, 2)
	
	-- Fonction pour mettre à jour la liste des joueurs
	local function updatePlayerList()
		for _, child in pairs(playerScrollFrame:GetChildren()) do
			if child:IsA("TextButton") then
				child:Destroy()
			end
		end
		
		local player = game.Players.LocalPlayer
		
		for _, targetPlayer in pairs(game.Players:GetPlayers()) do
			if targetPlayer ~= player then
				local playerButton = Instance.new("TextButton")
				playerButton.Parent = playerScrollFrame
				playerButton.Size = UDim2.new(1, -10, 0, 30)
				playerButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
				playerButton.BorderSizePixel = 0
				playerButton.Text = targetPlayer.Name
				playerButton.TextColor3 = Color3.fromRGB(255, 255, 255)
				playerButton.Font = Enum.Font.Gotham
				playerButton.TextSize = 12
				playerButton.TextXAlignment = Enum.TextXAlignment.Left
				
				local buttonPadding = Instance.new("UIPadding")
				buttonPadding.PaddingLeft = UDim.new(0, 10)
				buttonPadding.Parent = playerButton
				
				local buttonCorner = Instance.new("UICorner")
				buttonCorner.CornerRadius = UDim.new(0, 4)
				buttonCorner.Parent = playerButton
				
				playerButton.MouseButton1Click:Connect(function()
					if UniversalFeatures then
						UniversalFeatures.teleportToPlayer(targetPlayer)
					end
				end)
				
				playerButton.MouseEnter:Connect(function()
					playerButton.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
				end)
				
				playerButton.MouseLeave:Connect(function()
					playerButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
				end)
			end
		end
		
		playerScrollFrame.CanvasSize = UDim2.new(0, 0, 0, playerListLayout.AbsoluteContentSize.Y)
	end
	
	updatePlayerList()
	game.Players.PlayerAdded:Connect(updatePlayerList)
	game.Players.PlayerRemoving:Connect(updatePlayerList)
	
	yOffset = yOffset + 210
	
	-- ===== PLAYER TROLLING SECTION =====
	yOffset = yOffset + 10
	Components.createSectionTitle(scrollFrame, yOffset, "Player Trolling")
	yOffset = yOffset + 35
	Components.createSeparator(scrollFrame, yOffset)
	yOffset = yOffset + 10
	
	-- Fling Player (liste de joueurs)
	local flingContainer = Instance.new("Frame")
	flingContainer.Parent = scrollFrame
	flingContainer.Size = UDim2.new(1, -20, 0, 200)
	flingContainer.Position = UDim2.new(0, 10, 0, yOffset)
	flingContainer.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	flingContainer.BorderSizePixel = 0
	
	local flingCorner = Instance.new("UICorner")
	flingCorner.CornerRadius = UDim.new(0, 6)
	flingCorner.Parent = flingContainer
	
	local flingLabel = Instance.new("TextLabel")
	flingLabel.Parent = flingContainer
	flingLabel.Size = UDim2.new(1, -20, 0, 25)
	flingLabel.Position = UDim2.new(0, 10, 0, 5)
	flingLabel.BackgroundTransparency = 1
	flingLabel.Text = "Fling Player"
	flingLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	flingLabel.Font = Enum.Font.GothamBold
	flingLabel.TextSize = 14
	flingLabel.TextXAlignment = Enum.TextXAlignment.Left
	
	local flingScrollFrame = Instance.new("ScrollingFrame")
	flingScrollFrame.Parent = flingContainer
	flingScrollFrame.Size = UDim2.new(1, -20, 1, -40)
	flingScrollFrame.Position = UDim2.new(0, 10, 0, 30)
	flingScrollFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	flingScrollFrame.BorderSizePixel = 0
	flingScrollFrame.ScrollBarThickness = 4
	flingScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(138, 43, 226)
	
	local flingScrollCorner = Instance.new("UICorner")
	flingScrollCorner.CornerRadius = UDim.new(0, 4)
	flingScrollCorner.Parent = flingScrollFrame
	
	local flingListLayout = Instance.new("UIListLayout")
	flingListLayout.Parent = flingScrollFrame
	flingListLayout.SortOrder = Enum.SortOrder.Name
	flingListLayout.Padding = UDim.new(0, 2)
	
	local function updateFlingList()
		for _, child in pairs(flingScrollFrame:GetChildren()) do
			if child:IsA("TextButton") then
				child:Destroy()
			end
		end
		
		local player = game.Players.LocalPlayer
		
		for _, targetPlayer in pairs(game.Players:GetPlayers()) do
			if targetPlayer ~= player then
				local flingButton = Instance.new("TextButton")
				flingButton.Parent = flingScrollFrame
				flingButton.Size = UDim2.new(1, -10, 0, 30)
				flingButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
				flingButton.BorderSizePixel = 0
				flingButton.Text = targetPlayer.Name
				flingButton.TextColor3 = Color3.fromRGB(255, 255, 255)
				flingButton.Font = Enum.Font.Gotham
				flingButton.TextSize = 12
				flingButton.TextXAlignment = Enum.TextXAlignment.Left
				
				local buttonPadding = Instance.new("UIPadding")
				buttonPadding.PaddingLeft = UDim.new(0, 10)
				buttonPadding.Parent = flingButton
				
				local buttonCorner = Instance.new("UICorner")
				buttonCorner.CornerRadius = UDim.new(0, 4)
				buttonCorner.Parent = flingButton
				
				flingButton.MouseButton1Click:Connect(function()
					if UniversalFeatures then
						UniversalFeatures.flingPlayer(targetPlayer)
					end
				end)
				
				flingButton.MouseEnter:Connect(function()
					flingButton.BackgroundColor3 = Color3.fromRGB(220, 20, 60)
				end)
				
				flingButton.MouseLeave:Connect(function()
					flingButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
				end)
			end
		end
		
		flingScrollFrame.CanvasSize = UDim2.new(0, 0, 0, flingListLayout.AbsoluteContentSize.Y)
	end
	
	updateFlingList()
	game.Players.PlayerAdded:Connect(updateFlingList)
	game.Players.PlayerRemoving:Connect(updateFlingList)
	
	yOffset = yOffset + 210
	
	-- Bring Player (liste)
	local bringContainer = Instance.new("Frame")
	bringContainer.Parent = scrollFrame
	bringContainer.Size = UDim2.new(1, -20, 0, 200)
	bringContainer.Position = UDim2.new(0, 10, 0, yOffset)
	bringContainer.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	bringContainer.BorderSizePixel = 0
	
	local bringCorner = Instance.new("UICorner")
	bringCorner.CornerRadius = UDim.new(0, 6)
	bringCorner.Parent = bringContainer
	
	local bringLabel = Instance.new("TextLabel")
	bringLabel.Parent = bringContainer
	bringLabel.Size = UDim2.new(1, -20, 0, 25)
	bringLabel.Position = UDim2.new(0, 10, 0, 5)
	bringLabel.BackgroundTransparency = 1
	bringLabel.Text = "Bring Player"
	bringLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	bringLabel.Font = Enum.Font.GothamBold
	bringLabel.TextSize = 14
	bringLabel.TextXAlignment = Enum.TextXAlignment.Left
	
	local bringScrollFrame = Instance.new("ScrollingFrame")
	bringScrollFrame.Parent = bringContainer
	bringScrollFrame.Size = UDim2.new(1, -20, 1, -40)
	bringScrollFrame.Position = UDim2.new(0, 10, 0, 30)
	bringScrollFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	bringScrollFrame.BorderSizePixel = 0
	bringScrollFrame.ScrollBarThickness = 4
	bringScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(138, 43, 226)
	
	local bringScrollCorner = Instance.new("UICorner")
	bringScrollCorner.CornerRadius = UDim.new(0, 4)
	bringScrollCorner.Parent = bringScrollFrame
	
	local bringListLayout = Instance.new("UIListLayout")
	bringListLayout.Parent = bringScrollFrame
	bringListLayout.SortOrder = Enum.SortOrder.Name
	bringListLayout.Padding = UDim.new(0, 2)
	
	local function updateBringList()
		for _, child in pairs(bringScrollFrame:GetChildren()) do
			if child:IsA("TextButton") then
				child:Destroy()
			end
		end
		
		local player = game.Players.LocalPlayer
		
		for _, targetPlayer in pairs(game.Players:GetPlayers()) do
			if targetPlayer ~= player then
				local bringButton = Instance.new("TextButton")
				bringButton.Parent = bringScrollFrame
				bringButton.Size = UDim2.new(1, -10, 0, 30)
				bringButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
				bringButton.BorderSizePixel = 0
				bringButton.Text = targetPlayer.Name
				bringButton.TextColor3 = Color3.fromRGB(255, 255, 255)
				bringButton.Font = Enum.Font.Gotham
				bringButton.TextSize = 12
				bringButton.TextXAlignment = Enum.TextXAlignment.Left
				
				local buttonPadding = Instance.new("UIPadding")
				buttonPadding.PaddingLeft = UDim.new(0, 10)
				buttonPadding.Parent = bringButton
				
				local buttonCorner = Instance.new("UICorner")
				buttonCorner.CornerRadius = UDim.new(0, 4)
				buttonCorner.Parent = bringButton
				
				bringButton.MouseButton1Click:Connect(function()
					if UniversalFeatures then
						UniversalFeatures.bringPlayer(targetPlayer)
					end
				end)
				
				bringButton.MouseEnter:Connect(function()
					bringButton.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
				end)
				
				bringButton.MouseLeave:Connect(function()
					bringButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
				end)
			end
		end
		
		bringScrollFrame.CanvasSize = UDim2.new(0, 0, 0, bringListLayout.AbsoluteContentSize.Y)
	end
	
	updateBringList()
	game.Players.PlayerAdded:Connect(updateBringList)
	game.Players.PlayerRemoving:Connect(updateBringList)
	
	yOffset = yOffset + 210
	
	if UniversalFeatures then
		-- Vibration Mode
		Components.createToggle(scrollFrame, yOffset, "Vibration Mode", function(enabled)
			UniversalFeatures.setVibration(enabled)
		end)
		yOffset = yOffset + 50
	end
	
	-- ===== CHAOS SECTION =====
	yOffset = yOffset + 10
	Components.createSectionTitle(scrollFrame, yOffset, "Chaos & Exploits")
	yOffset = yOffset + 35
	Components.createSeparator(scrollFrame, yOffset)
	yOffset = yOffset + 10
	
	if UniversalFeatures then
		-- Spam Jump Trigger
		Components.createButton(scrollFrame, yOffset, "Spam Jump (Anti-Kick Trigger)", function()
			UniversalFeatures.spamJumpTrigger()
		end)
		yOffset = yOffset + 50
		
		-- Spam Reset Trigger
		Components.createButton(scrollFrame, yOffset, "Spam Reset (Anti-Kick Trigger)", function()
			UniversalFeatures.spamResetTrigger()
		end)
		yOffset = yOffset + 50
		
		-- Rocket Launch
		Components.createButton(scrollFrame, yOffset, "Rocket Launch", function()
			UniversalFeatures.rocketLaunch()
		end)
		yOffset = yOffset + 50
		
		-- Lag Switch
		Components.createToggle(scrollFrame, yOffset, "Lag Switch", function(enabled)
			UniversalFeatures.setLagSwitch(enabled)
		end)
		yOffset = yOffset + 50
	end
	
	-- ===== MISC SECTION =====
	yOffset = yOffset + 10
	Components.createSectionTitle(scrollFrame, yOffset, "Miscellaneous")
	yOffset = yOffset + 35
	Components.createSeparator(scrollFrame, yOffset)
	yOffset = yOffset + 10
	
	if UniversalFeatures then
		-- Remove Death Barriers
		Components.createToggle(scrollFrame, yOffset, "Remove Death Barriers", function(enabled)
			UniversalFeatures.setRemoveDeathBarriers(enabled)
		end)
		yOffset = yOffset + 50
		
		-- Anti-AFK
		Components.createToggle(scrollFrame, yOffset, "Anti-AFK", function(enabled)
			UniversalFeatures.setAntiAFK(enabled)
		end)
		yOffset = yOffset + 50
		
		-- Remove Textures (FPS Boost)
		Components.createToggle(scrollFrame, yOffset, "Remove Textures (FPS Boost)", function(enabled)
			UniversalFeatures.setRemoveTextures(enabled)
		end)
		yOffset = yOffset + 50
		
		-- Auto Respawn
		Components.createToggle(scrollFrame, yOffset, "Auto Respawn", function(enabled)
			UniversalFeatures.setAutoRespawn(enabled)
		end)
		yOffset = yOffset + 50
		
		-- Remove Accessories
		Components.createButton(scrollFrame, yOffset, "Remove Accessories", function()
			UniversalFeatures.removeAccessories()
		end)
		yOffset = yOffset + 50
	end
	
	-- Ajuster la taille du canvas
	scrollFrame.CanvasSize = UDim2.new(0, 0, 0, yOffset + 20)
end

return UniversalPage
