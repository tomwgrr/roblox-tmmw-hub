-- ========================================
-- MURDER MYSTERY 2 PAGE
-- ========================================

local Components = require(script.Parent.Parent.components)
local ESPSystem = require(script.Parent.Parent.Parent.tech.ESPSystem)
local GunGrabber = require(script.Parent.Parent.Parent.tech.GunGrabber)
local CoinFarmer = require(script.Parent.Parent.Parent.tech.CoinFarmer)

local MM2Page = {}

function MM2Page.create(scrollFrame)
	local yOffset = 10
	
	-- ===== VISUAL SECTION =====
	Components.createSectionTitle(scrollFrame, yOffset, "Visual")
	yOffset = yOffset + 35
	Components.createSeparator(scrollFrame, yOffset)
	yOffset = yOffset + 10
	
	-- Player Info Toggle
	Components.createToggle(scrollFrame, yOffset, "Player Info (Name & Role)", function(enabled)
		ESPSystem.setPlayerInfoEnabled(enabled)
	end)
	yOffset = yOffset + 50
	
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
	
	-- Grab Gun Once Button
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
	
	Components.createToggle(scrollFrame, yOffset, "Zombie ESP", function(enabled)
		ESPSystem.toggleESP("Zombie", enabled)
	end)
	yOffset = yOffset + 50
	
	Components.createToggle(scrollFrame, yOffset, "Survivor ESP", function(enabled)
		ESPSystem.toggleESP("Survivor", enabled)
	end)
	yOffset = yOffset + 50
	
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
	
	Components.createToggle(scrollFrame, yOffset, "Freezer ESP", function(enabled)
		ESPSystem.toggleESP("Freezer", enabled)
	end)
	yOffset = yOffset + 50
	
	Components.createToggle(scrollFrame, yOffset, "Runner ESP", function(enabled)
		ESPSystem.toggleESP("Runner", enabled)
	end)
	yOffset = yOffset + 50
	
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
	
	Components.createToggle(scrollFrame, yOffset, "Assassin ESP", function(enabled)
		ESPSystem.toggleESP("Assassin", enabled)
	end)
	yOffset = yOffset + 50
	
	-- ===== MISCELLANEOUS =====
	local miscTitle = Instance.new("TextLabel")
	miscTitle.Parent = scrollFrame
	miscTitle.Size = UDim2.new(1, -20, 0, 25)
	miscTitle.Position = UDim2.new(0, 10, 0, yOffset)
	miscTitle.BackgroundTransparency = 1
	miscTitle.Text = "Miscellaneous"
	miscTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
	miscTitle.Font = Enum.Font.GothamBold
	miscTitle.TextSize = 14
	miscTitle.TextXAlignment = Enum.TextXAlignment.Left
	yOffset = yOffset + 30
	
	Components.createToggle(scrollFrame, yOffset, "Auto Farm Coins", function(enabled)
		CoinFarmer.setAutoFarm(enabled)
	end)
	yOffset = yOffset + 50
	
	-- Ajuster la taille du canvas
	scrollFrame.CanvasSize = UDim2.new(0, 0, 0, yOffset + 20)
end

return MM2Page
