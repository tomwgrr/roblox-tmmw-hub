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
    },
    Components = {} -- Ajout pour stocker les composants UI
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

    print("[TMMW] Loaded:", name)
    return result
end

-- ========================================
-- LOAD TECH MODULES
-- ========================================

print("[TMMW] Loading tech modules...")
local GameDetection     = loadModule("tech/GameDetection.lua", "GameDetection")
local ESPSystem         = loadModule("tech/ESPSystem.lua", "ESPSystem")
local GunGrabber        = loadModule("tech/GunGrabber.lua", "GunGrabber")
local CoinFarmer        = loadModule("tech/CoinFarmer.lua", "CoinFarmer")
local UniversalFeatures = loadModule("tech/UniversalFeatures.lua", "UniversalFeatures")

-- ========================================
-- LOAD UI MODULES (Components FIRST!)
-- ========================================

print("[TMMW] Loading UI modules...")
local Components     = loadModule("ui/components.lua", "Components")
getgenv().TMMW.Components = Components -- Rendre accessible globalement

local LoadingScreen  = loadModule("ui/loading.lua", "LoadingScreen")
local Header         = loadModule("ui/header.lua", "Header")
local Sidebar        = loadModule("ui/sidebar.lua", "Sidebar")
local ContentManager = loadModule("ui/content.lua", "ContentManager")

-- ========================================
-- LOAD PAGES (après Components!)
-- ========================================

print("[TMMW] Loading pages...")
local HomePage      = loadModule("ui/pages/home.lua", "HomePage")
local UniversalPage = loadModule("ui/pages/universal.lua", "UniversalPage")

-- ========================================
-- GAME PAGES CONFIGURATION (extensible)
-- ========================================
local GamePages = {
    [601479430] = { -- Murder Mystery 2
        name = "MM2",
        modulePath = "ui/pages/mm2.lua"
    },
    -- exemple d'ajout futur
    -- [123456789] = { name = "GameX", modulePath = "ui/pages/gamex.lua" },
}

-- ========================================
-- BASIC VALIDATION
-- ========================================

if not LoadingScreen or not ContentManager then
    warn("[TMMW] Critical modules missing, abort.")
    return
end

if not Components then
    warn("[TMMW] Components module missing - pages will be empty!")
    return
end

-- ========================================
-- LOADING SCREEN
-- ========================================

local finishLoading = LoadingScreen.show(playerGui)

-- ========================================
-- INIT TECH SYSTEMS
-- ========================================

print("[TMMW] Initializing tech systems...")
pcall(function()
    if GameDetection then GameDetection.initialize() end
    if ESPSystem then ESPSystem.initialize() end
    if GunGrabber then GunGrabber.initialize() end
    if CoinFarmer then CoinFarmer.initialize() end
    if UniversalFeatures then UniversalFeatures.initialize() end
end)

-- ========================================
-- ATTENDRE LA FIN DU LOADING AVANT DE SPAWN LE GUI
-- ========================================

task.spawn(function()
    finishLoading() -- minimum 5s + Main ready

    -- ======= MAIN GUI =======
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

    print("[TMMW] Creating header...")
    if Header then
        Header.create(mainFrame, gui)
    end

    print("[TMMW] Creating sidebar and content manager...")
    if Sidebar and ContentManager then
        local sidebar = Sidebar.create(mainFrame)
        local contentManager = ContentManager.new(mainFrame)

        -- Vérifier que les pages sont bien chargées
        print("[TMMW] Registering pages...")
        
        if HomePage then 
            contentManager:registerPage("Home", HomePage)
            print("[TMMW] HomePage registered")
        else
            warn("[TMMW] HomePage is nil!")
        end
        
        if UniversalPage then 
            contentManager:registerPage("Universal", UniversalPage)
            print("[TMMW] UniversalPage registered")
        else
            warn("[TMMW] UniversalPage is nil!")
        end

        -- Pages spécifiques au jeu actuel
        local currentGameId = GameDetection and GameDetection.getCurrentGameId() or nil
        print("[TMMW] Current game ID:", currentGameId)
        
        if currentGameId and GamePages[currentGameId] then
            print("[TMMW] Loading game-specific page:", GamePages[currentGameId].name)
            local gamePageModule = loadModule(GamePages[currentGameId].modulePath, GamePages[currentGameId].name)
            if gamePageModule then
                contentManager:registerPage(GamePages[currentGameId].name, gamePageModule)
                print("[TMMW] Game page registered:", GamePages[currentGameId].name)
            else
                warn("[TMMW] Failed to load game page!")
            end
        end

        print("[TMMW] Setting up navigation...")
        Sidebar.setupNavigation(sidebar, contentManager)
        
        print("[TMMW] Showing home page...")
        contentManager:showPage("Home")
    end

    print("[TMMW] Hub chargé avec succès")
    if GameDetection then
        print("[TMMW] Mode détecté:", GameDetection.getCurrentGameId())
    end
end)
