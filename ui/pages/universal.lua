-- ========================================
-- UNIVERSAL PAGE
-- ========================================

local UniversalPage = {}

function UniversalPage.create(scrollFrame)
	-- Vérification du scrollFrame
	if not scrollFrame then
		warn("[TMMW] scrollFrame is nil in UniversalPage.create!")
		return
	end
	
	-- Attendre que les modules soient chargés
	local maxAttempts = 10
	local attempts = 0
	
	while attempts < maxAttempts do
		if getgenv().TMMW and getgenv().TMMW.Modules and getgenv().TMMW.Modules.Components and getgenv().TMMW.Modules.UniversalFeatures then
			break
		end
		attempts = attempts + 1
		wait(0.1)
	end
	
	-- Vérifier que les modules existent
	if not getgenv().TMMW or not getgenv().TMMW.Modules then
		warn("[TMMW] TMMW.Modules not found!")
		return
	end
	
	local Components = getgenv().TMMW.Modules.Components
	local UniversalFeatures = getgenv().TMMW.Modules.UniversalFeatures
	
	-- Vérifier que les modules sont bien chargés
	if not Components then
		warn("[TMMW] Components module not found!")
		return
	end
	
	if not UniversalFeatures then
		warn("[TMMW] UniversalFeatures module not found!")
		return
	end
	
	-- Vérifier que les fonctions existent
	if not Components.createSectionTitle then
		warn("[TMMW] Components.createSectionTitle not found!")
		return
	end
	
	print("[TMMW] Creating Universal Page...")
	
	local yOffset = 10
	
	-- ===== MOVEMENT SECTION =====
	local success, err = pcall(function()
		Components.createSectionTitle(scrollFrame, yOffset, "Movement")
		yOffset = yOffset + 35
		Components.createSeparator(scrollFrame, yOffset)
		yOffset = yOffset + 10
		
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
	end)
	
	if not success then
		warn("[TMMW] Error in Movement section: " .. tostring(err))
		return
	end
	
	-- ===== VISUAL SECTION =====
	success, err = pcall(function()
		yOffset = yOffset + 10
		Components.createSectionTitle(scrollFrame, yOffset, "Visual")
		yOffset = yOffset + 35
		Components.createSeparator(scrollFrame, yOffset)
		yOffset = yOffset + 10
		
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
		
		-- Headless
		Components.createToggle(scrollFrame, yOffset, "Headless", function(enabled)
			UniversalFeatures.setHeadless(enabled)
		end)
		yOffset = yOffset + 50
	end)
	
	if not success then
		warn("[TMMW] Error in Visual section: " .. tostring(err))
		return
	end
	
	-- ===== TELEPORT SECTION =====
	success, err = pcall(function()
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
						UniversalFeatures.teleportToPlayer(targetPlayer)
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
	end)
	
	if not success then
		warn("[TMMW] Error in Teleport section: " .. tostring(err))
		return
	end
	
	-- ===== COMBAT SECTION =====
	success, err = pcall(function()
		yOffset = yOffset + 10
		Components.createSectionTitle(scrollFrame, yOffset, "Combat")
		yOffset = yOffset + 35
		Components.createSeparator(scrollFrame, yOffset)
		yOffset = yOffset + 10
		
		-- Fling
		Components.createToggle(scrollFrame, yOffset, "Fling", function(enabled)
			UniversalFeatures.setFling(enabled)
		end)
		yOffset = yOffset + 50
		
		-- Spinbot
		Components.createToggle(scrollFrame, yOffset, "Spinbot", function(enabled)
			UniversalFeatures.setSpinbot(enabled)
		end)
		yOffset = yOffset + 50
		
		-- Spin Speed
		Components.createSlider(scrollFrame, yOffset, "Spin Speed", 5, 50, 20, function(value)
			UniversalFeatures.setSpinSpeed(value)
		end)
		yOffset = yOffset + 70
		
		-- God Mode (Client)
		Components.createToggle(scrollFrame, yOffset, "God Mode (Client)", function(enabled)
			UniversalFeatures.setGodMode(enabled)
		end)
		yOffset = yOffset + 50
		
		-- Auto Click
		Components.createToggle(scrollFrame, yOffset, "Auto Click", function(enabled)
			UniversalFeatures.setAutoClick(enabled)
		end)
		yOffset = yOffset + 50
		
		-- Auto Click Delay
		Components.createSlider(scrollFrame, yOffset, "Click Delay (s)", 0.01, 1, 0.1, function(value)
			UniversalFeatures.setAutoClickDelay(value)
		end)
		yOffset = yOffset + 70
	end)
	
	if not success then
		warn("[TMMW] Error in Combat section: " .. tostring(err))
		return
	end
	
	-- ===== PLAYER ACTIONS SECTION =====
	success, err = pcall(function()
		yOffset = yOffset + 10
		Components.createSectionTitle(scrollFrame, yOffset, "Player Actions")
		yOffset = yOffset + 35
		Components.createSeparator(scrollFrame, yOffset)
		yOffset = yOffset + 10
		
		-- Kick Player Section (liste)
		local kickContainer = Instance.new("Frame")
		kickContainer.Parent = scrollFrame
		kickContainer.Size = UDim2.new(1, -20, 0, 200)
		kickContainer.Position = UDim2.new(0, 10, 0, yOffset)
		kickContainer.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
		kickContainer.BorderSizePixel = 0
		
		local kickCorner = Instance.new("UICorner")
		kickCorner.CornerRadius = UDim.new(0, 6)
		kickCorner.Parent = kickContainer
		
		local kickLabel = Instance.new("TextLabel")
		kickLabel.Parent = kickContainer
		kickLabel.Size = UDim2.new(1, -20, 0, 25)
		kickLabel.Position = UDim2.new(0, 10, 0, 5)
		kickLabel.BackgroundTransparency = 1
		kickLabel.Text = "Kick Player (Client-Side)"
		kickLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		kickLabel.Font = Enum.Font.GothamBold
		kickLabel.TextSize = 14
		kickLabel.TextXAlignment = Enum.TextXAlignment.Left
		
		local kickScrollFrame = Instance.new("ScrollingFrame")
		kickScrollFrame.Parent = kickContainer
		kickScrollFrame.Size = UDim2.new(1, -20, 1, -40)
		kickScrollFrame.Position = UDim2.new(0, 10, 0, 30)
		kickScrollFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
		kickScrollFrame.BorderSizePixel = 0
		kickScrollFrame.ScrollBarThickness = 4
		kickScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(138, 43, 226)
		
		local kickScrollCorner = Instance.new("UICorner")
		kickScrollCorner.CornerRadius = UDim.new(0, 4)
		kickScrollCorner.Parent = kickScrollFrame
		
		local kickListLayout = Instance.new("UIListLayout")
		kickListLayout.Parent = kickScrollFrame
		kickListLayout.SortOrder = Enum.SortOrder.Name
		kickListLayout.Padding = UDim.new(0, 2)
		
		-- Fonction pour mettre à jour la liste pour kick
		local function updateKickList()
			for _, child in pairs(kickScrollFrame:GetChildren()) do
				if child:IsA("TextButton") then
					child:Destroy()
				end
			end
			
			local player = game.Players.LocalPlayer
			
			for _, targetPlayer in pairs(game.Players:GetPlayers()) do
				if targetPlayer ~= player then
					local kickButton = Instance.new("TextButton")
					kickButton.Parent = kickScrollFrame
					kickButton.Size = UDim2.new(1, -10, 0, 30)
					kickButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
					kickButton.BorderSizePixel = 0
					kickButton.Text = targetPlayer.Name
					kickButton.TextColor3 = Color3.fromRGB(255, 255, 255)
					kickButton.Font = Enum.Font.Gotham
					kickButton.TextSize = 12
					kickButton.TextXAlignment = Enum.TextXAlignment.Left
					
					local kickPadding = Instance.new("UIPadding")
					kickPadding.PaddingLeft = UDim.new(0, 10)
					kickPadding.Parent = kickButton
					
					local kickBtnCorner = Instance.new("UICorner")
					kickBtnCorner.CornerRadius = UDim.new(0, 4)
					kickBtnCorner.Parent = kickButton
					
					kickButton.MouseButton1Click:Connect(function()
						UniversalFeatures.kickPlayer(targetPlayer)
					end)
					
					kickButton.MouseEnter:Connect(function()
						kickButton.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
					end)
					
					kickButton.MouseLeave:Connect(function()
						kickButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
					end)
				end
			end
			
			kickScrollFrame.CanvasSize = UDim2.new(0, 0, 0, kickListLayout.AbsoluteContentSize.Y)
		end
		
		updateKickList()
		game.Players.PlayerAdded:Connect(updateKickList)
		game.Players.PlayerRemoving:Connect(updateKickList)
		
		yOffset = yOffset + 210
		
		-- Bring All Players
		Components.createButton(scrollFrame, yOffset, "Bring All Players", "Bring", function()
			UniversalFeatures.bringAllPlayers()
		end)
		yOffset = yOffset + 50
		
		-- Freeze Character
		Components.createToggle(scrollFrame, yOffset, "Freeze Character", function(enabled)
			UniversalFeatures.setFreeze(enabled)
		end)
		yOffset = yOffset + 50
	end)
	
	if not success then
		warn("[TMMW] Error in Player Actions section: " .. tostring(err))
		return
	end
	
	-- ===== MISC SECTION =====
	success, err = pcall(function()
		yOffset = yOffset + 10
		Components.createSectionTitle(scrollFrame, yOffset, "Miscellaneous")
		yOffset = yOffset + 35
		Components.createSeparator(scrollFrame, yOffset)
		yOffset = yOffset + 10
		
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
		
		-- Ajuster la taille du canvas
		scrollFrame.CanvasSize = UDim2.new(0, 0, 0, yOffset + 20)
	end)
	
	if not success then
		warn("[TMMW] Error in Misc section: " .. tostring(err))
	end
	
	print("[TMMW] Universal Page created successfully!")
end

return UniversalPage
