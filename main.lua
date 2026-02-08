-- ========================================
-- TMMW HUB - MAIN HTTP ENTRY POINT
-- ========================================

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ========================================
-- CONFIG GITHUB
-- ========================================

local BASE_URL = "https://raw.githubusercontent.com/tomwgrr/roblox-tmmw-hub/main/"

-- ========================================
-- PREMIUM CONFIG
-- ========================================

local PREMIUM_PASS_ID = 9696634781

-- ========================================
-- GLOBAL ENV
-- ========================================

getgenv().TMMW = {
    Modules = {},
    Services = {
        TweenService = TweenService,
        UserInputService = UserInputService,
        Players = Players,
        MarketplaceService = MarketplaceService,
    },
    Config = {
        PremiumPassID = PREMIUM_PASS_ID,
    }
}

local Modules = getgenv().TMMW.Modules

-- ========================================
-- PREMIUM SYSTEM
-- ========================================

local PremiumSystem = {
    isPremium = false,
    checked = false
}

function PremiumSystem.check()
    if PremiumSystem.checked then
        return PremiumSystem.isPremium
    end
    
    local success, result = pcall(function()
        return MarketplaceService:UserOwnsGamePassAsync(player.UserId, PREMIUM_PASS_ID)
    end)
    
    PremiumSystem.isPremium = success and result
    PremiumSystem.checked = true
    
    if PremiumSystem.isPremium then
        print("[TMMW] ✅ Premium access granted")
    else
        print("[TMMW] ❌ Free version - Premium features locked")
    end
    
    return PremiumSystem.isPremium
end

function PremiumSystem.hasPremium()
    return PremiumSystem.check()
end

-- Expose le système premium globalement
getgenv().TMMW.PremiumSystem = PremiumSystem

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
-- CHECK PREMIUM BEFORE LOADING
-- ========================================

PremiumSystem.check()

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
    if GameDetection then GameDetection.initialize() end
    if ESPSystem then ESPSystem.initialize() end
    if GunGrabber then GunGrabber.initialize() end
    if CoinFarmer then CoinFarmer.initialize() end
    if UniversalFeatures then UniversalFeatures.initialize() end
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

if Header then
    Header.create(mainFrame, gui)
end

if Sidebar and ContentManager then
    local sidebar = Sidebar.create(mainFrame)
    local contentManager = ContentManager.new(mainFrame)

    if HomePage then contentManager:registerPage("Home", HomePage) end
    if MM2Page then contentManager:registerPage("MM2", MM2Page) end
    if UniversalPage then contentManager:registerPage("Universal", UniversalPage) end

    Sidebar.setupNavigation(sidebar, contentManager)
    contentManager:showPage("Home")
end

-- ========================================
-- DONE
-- ========================================

print("[TMMW] Hub chargé avec succès")
print("[TMMW] Premium Status:", PremiumSystem.hasPremium() and "✅ ACTIVE" or "❌ INACTIVE")
if GameDetection then
    print("[TMMW] Mode détecté:", GameDetection.getCurrentGameMode())
end
