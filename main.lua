-- ========================================
-- TMMW HUB - MAIN HTTP ENTRY POINT
-- ========================================

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ========================================
-- CONFIG GITHUB
-- ========================================

local BASE_URL = "https://raw.githubusercontent.com/tomwgrr/roblox-tmmw-hub/main/"

-- ========================================
-- GLOBAL ENV
-- ========================================

getgenv().TMMW = {
    Modules = {},
    Services = {
        TweenService = TweenService,
        UserInputService = UserInputService,
        Players = Players,
    }
}

local Modules = getgenv().TMMW.Modules

-- ========================================
-- SAFE GUI CLEANUP
-- ========================================

pcall(function()
    if playerGui:FindFirstChild("TMMWHubLoading") then
        playerGui.TMMWHubLoading:Destroy()
    end
    if playerGui:FindFirstChild("TMMWHubUI") then
        playerGui.TMMWHubUI:Destroy()
    end
end)

task.wait(0.1)

-- ========================================
-- MODULE LOADER
-- ========================================

local function loadModule(path, name)
    local success, result = pcall(function()
        local src = game:HttpGet(BASE_URL .. path)
        local module = loadstring(src)()
        Modules[name] = module
        return module
    end)

    if not success then
        warn("[TMMW] Failed to load:", path)
        warn(result)
        return nil
    end

    return result
end

-- ========================================
-- LOAD TECH MODULES
-- ========================================

local GameDetection     = loadModule("tech/GameDetection.lua", "GameDetection")
local ESPSystem         = loadModule("tech/ESPSystem.lua", "ESPSystem")
local GunGrabber        = loadModule("tech/GunGrabber.lua", "GunGrabber")
local CoinFarmer        = loadModule("tech/CoinFarmer.lua", "CoinFarmer")
local UniversalFeatures = loadModule("tech/UniversalFeatures.lua", "UniversalFeatures")

-- ========================================
-- LOAD UI MODULES
-- ========================================

local LoadingScreen  = loadModule("ui/loading.lua", "LoadingScreen")
local Header         = loadModule("ui/header.lua", "Header")
local Sidebar        = loadModule("ui/sidebar.lua", "Sidebar")
local Components     = loadModule("ui/components.lua", "Components")
local ContentManager = loadModule("ui/content.lua", "ContentManager")

-- Pages
local HomePage       = loadModule("ui/pages/home.lua", "HomePage")
local MM2Page        = loadModule("ui/pages/mm2.lua", "MM2Page")
local UniversalPage  = loadModule("ui/pages/universal.lua", "UniversalPage")

-- ========================================
-- BASIC VALIDATION
-- ========================================

if not LoadingScreen or not ContentManager then
    warn("[TMMW] Critical modules missing, abort.")
    return
end

-- ========================================
-- LOADING SCREEN
-- ========================================

LoadingScreen.show(playerGui)

-- ========================================
-- INIT TECH SYSTEMS
-- ========================================

pcall(function()
    GameDetection.initialize()
    ESPSystem.initialize()
    GunGrabber.initialize()
    CoinFarmer.initialize()
    UniversalFeatures.initialize()
end)

-- ========================================
-- MAIN GUI
-- ========================================

local gui = Instance.new("ScreenGui")
gui.Name = "TMMWHubUI"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Parent = gui
mainFrame.Size = UDim2.new(0, 600, 0, 400)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

-- ========================================
-- UI SETUP
-- ========================================

Header.create(mainFrame, gui)

local sidebar = Sidebar.create(mainFrame)
local contentManager = ContentManager.new(mainFrame)

contentManager:registerPage("Home", HomePage)
contentManager:registerPage("MM2", MM2Page)
contentManager:registerPage("Universal", UniversalPage)

Sidebar.setupNavigation(sidebar, contentManager)
contentManager:showPage("Home")

-- ========================================
-- DONE
-- ========================================

print("[TMMW] Hub chargé avec succès")
print("[TMMW] Mode détecté:", GameDetection.getCurrentGameMode())
