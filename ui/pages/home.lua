-- ========================================
-- HOME PAGE
-- ========================================

local HomePage = {}

function HomePage.create(scrollFrame)
	local yOffset = 20
	
	-- Titre de bienvenue
	local welcomeTitle = Instance.new("TextLabel")
	welcomeTitle.Parent = scrollFrame
	welcomeTitle.Size = UDim2.new(1, -40, 0, 60)
	welcomeTitle.Position = UDim2.new(0, 20, 0, yOffset)
	welcomeTitle.BackgroundTransparency = 1
	welcomeTitle.Text = "Welcome to TMMW Hub"
	welcomeTitle.TextColor3 = Color3.fromRGB(138, 43, 226)
	welcomeTitle.Font = Enum.Font.GothamBlack
	welcomeTitle.TextSize = 24
	welcomeTitle.TextXAlignment = Enum.TextXAlignment.Left
	yOffset = yOffset + 70
	
	-- Description
	local description = Instance.new("TextLabel")
	description.Parent = scrollFrame
	description.Size = UDim2.new(1, -40, 0, 100)
	description.Position = UDim2.new(0, 20, 0, yOffset)
	description.BackgroundTransparency = 1
	description.Text = "TMMW Hub is a powerful script hub designed for Murder Mystery 2 and universal Roblox games.\n\nFeatures:\n• Advanced ESP System\n• Auto Coin Farming\n• Gun Grabber\n• Universal Movement Hacks\n• And much more!"
	description.TextColor3 = Color3.fromRGB(200, 200, 200)
	description.Font = Enum.Font.Gotham
	description.TextSize = 14
	description.TextXAlignment = Enum.TextXAlignment.Left
	description.TextYAlignment = Enum.TextYAlignment.Top
	description.TextWrapped = true
	yOffset = yOffset + 110
	
	-- Carte d'information
	local infoCard = Instance.new("Frame")
	infoCard.Parent = scrollFrame
	infoCard.Size = UDim2.new(1, -40, 0, 120)
	infoCard.Position = UDim2.new(0, 20, 0, yOffset)
	infoCard.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	infoCard.BorderSizePixel = 0
	
	local cardCorner = Instance.new("UICorner")
	cardCorner.CornerRadius = UDim.new(0, 8)
	cardCorner.Parent = infoCard
	
	local cardTitle = Instance.new("TextLabel")
	cardTitle.Parent = infoCard
	cardTitle.Size = UDim2.new(1, -20, 0, 30)
	cardTitle.Position = UDim2.new(0, 10, 0, 10)
	cardTitle.BackgroundTransparency = 1
	cardTitle.Text = "📊 Current Status"
	cardTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
	cardTitle.Font = Enum.Font.GothamBold
	cardTitle.TextSize = 16
	cardTitle.TextXAlignment = Enum.TextXAlignment.Left
	
	local cardInfo = Instance.new("TextLabel")
	cardInfo.Parent = infoCard
	cardInfo.Size = UDim2.new(1, -20, 0, 70)
	cardInfo.Position = UDim2.new(0, 10, 0, 40)
	cardInfo.BackgroundTransparency = 1
	cardInfo.Text = "Version: 1.0.0\nGame: Murder Mystery 2\nStatus: Active\nFeatures Loaded: All Systems Operational"
	cardInfo.TextColor3 = Color3.fromRGB(180, 180, 180)
	cardInfo.Font = Enum.Font.Gotham
	cardInfo.TextSize = 13
	cardInfo.TextXAlignment = Enum.TextXAlignment.Left
	cardInfo.TextYAlignment = Enum.TextYAlignment.Top
	cardInfo.TextWrapped = true
	yOffset = yOffset + 130
	
	-- Instructions
	local instructionsTitle = Instance.new("TextLabel")
	instructionsTitle.Parent = scrollFrame
	instructionsTitle.Size = UDim2.new(1, -40, 0, 30)
	instructionsTitle.Position = UDim2.new(0, 20, 0, yOffset)
	instructionsTitle.BackgroundTransparency = 1
	instructionsTitle.Text = "Quick Start Guide"
	instructionsTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
	instructionsTitle.Font = Enum.Font.GothamBold
	instructionsTitle.TextSize = 18
	instructionsTitle.TextXAlignment = Enum.TextXAlignment.Left
	yOffset = yOffset + 35
	
	local instructions = Instance.new("TextLabel")
	instructions.Parent = scrollFrame
	instructions.Size = UDim2.new(1, -40, 0, 150)
	instructions.Position = UDim2.new(0, 20, 0, yOffset)
	instructions.BackgroundTransparency = 1
	instructions.Text = [[1. Navigate to the MM2 tab for game-specific features
2. Use Universal tab for features that work in any game
3. Toggle features ON/OFF with the buttons
4. Adjust sliders for speed and power settings
5. Use Settings tab to customize your experience

Need help? Join our Discord community!]]
	instructions.TextColor3 = Color3.fromRGB(200, 200, 200)
	instructions.Font = Enum.Font.Gotham
	instructions.TextSize = 13
	instructions.TextXAlignment = Enum.TextXAlignment.Left
	instructions.TextYAlignment = Enum.TextYAlignment.Top
	instructions.TextWrapped = true
	
	scrollFrame.CanvasSize = UDim2.new(0, 0, 0, yOffset + 170)
end

return HomePage
