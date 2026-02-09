-- ========================================
-- TMMW HUB - MAIN ENTRY
-- ========================================

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local BASE_URL = "https://raw.githubusercontent.com/tomwgrr/roblox-tmmw-hub/main/"

getgenv().TMMW = {
	Modules = {},
	Services = {
		TweenService = TweenService,
		UserInputService = UserInputService,
		Players = Players,
	}
}

local Modules = getgenv().TMMW.Modules

pcall(function()
	if playerGui:FindFirstChild("TMMWHubLoading") then
		playerGui.TMMWHubLoading:Destroy()
	end
	if playerGui:FindFirstChild("TMMWHubUI") then
		playerGui.TMMWHubUI:Destroy()
	end
end)

task.wait(0.1)

local function loadModule(path, name)
	local src = game:HttpGet(BASE_URL .. path)
	local module = loadstring(src)()
	Modules[name] = module
	return module
end

-- =====================
-- LOAD MODULES
-- =====================
local LoadingScreen = loadModule("ui/loading.lua", "LoadingScreen")

local GameDetection     = loadModule("tech/GameDetection.lua", "GameDetection")
local ESPSystem         = loadModule("tech/ESPSystem.lua", "ESPSystem")
local GunGrabber        = loadModule("tech/GunGrabber.lua", "GunGrabber")
local CoinFarmer        = loadModule("tech/CoinFarmer.lua", "CoinFarmer")
local UniversalFeatures = loadModule("tech/UniversalFeatures.lua", "UniversalFeatures")

local Header         = loadModule("ui/header.lua", "Header")
local Sidebar        = loadModule("ui/sidebar.lua", "Sidebar")
local Components     = loadModule("ui/components.lua", "Components")
local ContentManager = loadModule("ui/content.lua", "ContentManager")

local HomePage       = loadModule("ui/pages/home.lua", "HomePage")
local MM2Page        = loadModule("ui/pages/mm2.lua", "MM2Page")
local UniversalPage  = loadModule("ui/pages/universal.lua", "UniversalPage")

-- =====================
-- SHOW LOADING
-- =====================
local finishLoading = LoadingScreen.show(playerGui)

-- =====================
-- INIT SYSTEMS
-- =====================
pcall(function()
	if GameDetection then GameDetection.initialize() end
	if ESPSystem then ESPSystem.initialize() end
	if GunGrabber then GunGrabber.initialize() end
	if CoinFarmer then CoinFarmer.initialize() end
	if UniversalFeatures then UniversalFeatures.initialize() end
end)

-- =====================
-- MAIN UI
-- =====================
local gui = Instance.new("ScreenGui")
gui.Name = "TMMWHubUI"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 600, 0, 400)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = gui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)

if Header then Header.create(mainFrame, gui) end

if Sidebar and ContentManager then
	local sidebar = Sidebar.create(mainFrame)
	local contentManager = ContentManager.new(mainFrame)

	if HomePage then contentManager:registerPage("Home", HomePage) end
	if MM2Page then contentManager:registerPage("MM2", MM2Page) end
	if UniversalPage then contentManager:registerPage("Universal", UniversalPage) end

	Sidebar.setupNavigation(sidebar, contentManager)
	contentManager:showPage("Home")
end

-- =====================
-- DONE
-- =====================
task.wait(0.2)
finishLoading()

print("[TMMW] Hub loaded successfully")
