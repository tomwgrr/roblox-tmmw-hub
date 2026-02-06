-- ========================================
-- UNIVERSAL PAGE
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
		
		-- Headless
		Components.createToggle(scrollFrame, yOffset, "Headless", function(enabled)
			UniversalFeatures.setHeadless(enabled)
		end)
		yOffset = yOffset + 50
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
				local p
