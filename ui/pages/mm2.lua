-- ========================================
-- MURDER MYSTERY 2 PAGE
-- ========================================

local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")

local player = Players.LocalPlayer
local PREMIUM_PASS_ID = 9696634781

local Components = getgenv().TMMW.Modules.Components
local ESPSystem = getgenv().TMMW.Modules.ESPSystem
local GunGrabber = getgenv().TMMW.Modules.GunGrabber
local CoinFarmer = getgenv().TMMW.Modules.CoinFarmer

local MM2Page = {}

-- ========================================
-- PREMIUM VERIFICATION
-- ========================================

local function hasPremium()
	local success, result = pcall(function()
		return MarketplaceService:UserOwnsGamePassAsync(player.UserId, PREMIUM_PASS_ID)
	end)
	return success and result
end

local function disableToggleComponent(toggleData)
	if toggleData and toggleData.container then
		-- Rend le container transparent
		toggleData.container.BackgroundTransparency = 0.8
		
		-- Rend le label transparent
		if toggleData.label then
			toggleData.label.TextTransparency = 0.7
		end
		
		-- Désactive et rend le toggle transparent
		if toggleData.toggle then
			toggleData.toggle.BackgroundTransparency = 0.7
			toggleData.toggle.TextTransparency = 0.7
			toggleData.toggle.Active = false
			toggleData.toggle.AutoButtonColor = false
		end
	end
end

local function disableButtonComponent(buttonData)
	if buttonData and buttonData.container then
		-- Rend le container transparent
		buttonData.container.BackgroundTransparency = 0.8
		
		-- Rend le label transparent
		if buttonData.label then
			buttonData.label.TextTransparency = 0.7
		end
		
		-- Désactive et rend le bouton transparent
		if buttonData.button then
			buttonData.button.BackgroundTransparency = 0.7
			buttonData.button.TextTransparency = 0.7
			buttonData.button.Active = false
			buttonData.button.AutoButtonColor = false
		end
	end
end

-- ========================================
-- CREATE PAGE
-- ========================================

function MM2Page.create(scrollFrame)
	local yOffset = 10
	local isPremium = hasPremium()
	
	-- ===== VISUAL SECTION =====
	Components.createSectionTitle(scrollFrame, yOffset, "Visual")
	yOffset = yOffset + 35
	Components.createSeparator(scrollFrame, yOffset)
	yOffset = yOffset + 10
	
	-- Player Info Toggle (PREMIUM)
	if ESPSystem then
		local toggleData = Components.createToggle(scrollFrame, yOffset, "Player Info (Name & Role)", function(enabled)
			if not isPremium then
				return
			end
			ESPSystem.setPlayerInfoEnabled(enabled)
		end)
		
		if not isPremium then
			disableToggleComponent(toggleData)
		end
		
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
	
	-- ESP Toggles pour Classic Mode (PREMIUM)
	if ESPSystem then
		local toggle1 = Components.createToggle(scrollFrame, yOffset, "Murderer ESP", function(enabled)
			if not isPremium then return end
			ESPSystem.toggleESP("Murderer", enabled)
		end)
		if not isPremium then disableToggleComponent(toggle1) end
		yOffset = yOffset + 50
		
		local toggle2 = Components.createToggle(scrollFrame, yOffset, "Sheriff ESP", function(enabled)
			if not isPremium then return end
			ESPSystem.toggleESP("Sheriff", enabled)
		end)
		if not isPremium then disableToggleComponent(toggle2) end
		yOffset = yOffset + 50
		
		local toggle3 = Components.createToggle(scrollFrame, yOffset, "Innocent ESP", function(enabled)
			if not isPremium then return end
			ESPSystem.toggleESP("Innocent", enabled)
		end)
		if not isPremium then disableToggleComponent(toggle3) end
		yOffset = yOffset + 50
		
		local toggle4 = Components.createToggle(scrollFrame, yOffset, "Gun (Dropped) ESP", function(enabled)
			if not isPremium then return end
			ESPSystem.toggleESP("Gun", enabled)
		end)
		if not isPremium then disableToggleComponent(toggle4) end
		yOffset = yOffset + 50
	end
	
	-- Grab Gun Once Button (PREMIUM)
	if GunGrabber then
		local buttonData = Components.createButton(scrollFrame, yOffset, "Grab Gun Once", "GRAB", function(btn)
			if not isPremium then
				return
			end
			
			local success = GunGrabber.grabOnce()
			if success then
				btn.Text = "✓ GRABBED"
				btn.BackgroundColor3 = Color3.fromRGB(40, 200, 40)
				task.wait(1)
				btn.Text = "GRAB"
				btn.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
			else
				btn.Text = "NO GUN"
				btn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
				task.wait(1)
				btn.Text = "GRAB"
				btn.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
			end
		end)
		
		if not isPremium then disableButtonComponent(buttonData) end
		yOffset = yOffset + 50
		
		-- Auto Grab Gun Toggle (PREMIUM)
		local toggle5 = Components.createToggle(scrollFrame, yOffset, "Auto Grab Gun", function(enabled)
			if not isPremium then return end
			GunGrabber.setAutoGrab(enabled)
		end)
		if not isPremium then disableToggleComponent(toggle5) end
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
		local toggle6 = Components.createToggle(scrollFrame, yOffset, "Zombie ESP", function(enabled)
			if not isPremium then return end
			ESPSystem.toggleESP("Zombie", enabled)
		end)
		if not isPremium then disableToggleComponent(toggle6) end
		yOffset = yOffset + 50
		
		local toggle7 = Components.createToggle(scrollFrame, yOffset, "Survivor ESP", function(enabled)
			if not isPremium then return end
			ESPSystem.toggleESP("Survivor", enabled)
		end)
		if not isPremium then disableToggleComponent(toggle7) end
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
		local toggle8 = Components.createToggle(scrollFrame, yOffset, "Freezer ESP", function(enabled)
			if not isPremium then return end
			ESPSystem.toggleESP("Freezer", enabled)
		end)
		if not isPremium then disableToggleComponent(toggle8) end
		yOffset = yOffset + 50
		
		local toggle9 = Components.createToggle(scrollFrame, yOffset, "Runner ESP", function(enabled)
			if not isPremium then return end
			ESPSystem.toggleESP("Runner", enabled)
		end)
		if not isPremium then disableToggleComponent(toggle9) end
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
		local toggle10 = Components.createToggle(scrollFrame, yOffset, "Assassin ESP", function(enabled)
			if not isPremium then return end
			ESPSystem.toggleESP("Assassin", enabled)
		end)
		if not isPremium then disableToggleComponent(toggle10) end
		yOffset = yOffset + 50
	end
	
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
	
	if CoinFarmer then
		local toggle11 = Components.createToggle(scrollFrame, yOffset, "Auto Farm Coins", function(enabled)
			if not isPremium then return end
			CoinFarmer.setAutoFarm(enabled)
		end)
		if not isPremium then disableToggleComponent(toggle11) end
		yOffset = yOffset + 50
	end
	
	-- Ajuster la taille du canvas
	scrollFrame.CanvasSize = UDim2.new(0, 0, 0, yOffset + 20)
end

return MM2Page
