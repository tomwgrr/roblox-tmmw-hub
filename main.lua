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
-- GAME-SPECIFIC CONFIGURATION
-- ========================================

local GAME_CONFIGS = {
    [142823291] = { -- Murder Mystery 2
        name = "MM2",
        techModules = {"ESPSystem", "GunGrabber", "CoinFarmer"},
        page = "mm2.lua"
    },
    -- Ajoutez facilement d'autres jeux ici :
    -- [game_id] = {
    --     name = "NomDuJeu",
    --     techModules = {"Module1", "Module2"},
    --     page = "nompage.lua"
    -- },
}

-- ========================================
-- GAME DETECTION (FAIT EN PREMIER)
-- ========================================

local currentGameId = game.PlaceId
local gameConfig = GAME_CONFIGS[currentGameId]
local isRecognizedGame = gameConfig ~= nil

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
    CurrentGame = gameConfig,
    IsUniversalMode = not isRecognizedGame,
    PlaceId = currentGameId
}

local Modules = getgenv().TMMW.Modules

print("=====================================")
print("[TMMW] Démarrage du Hub")
print("[TMMW] PlaceId:", currentGameId)
if isRecognizedGame then
    print("[TMMW] Jeu reconnu:", gameConfig.name)
else
    print("[TMMW] Mode universel uniquement")
end
print("=====================================")

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

local function loadModule(path, name, required)
    required = required or false
    
    local success, result = pcall(function()
        local src = game:HttpGet(BASE_URL .. path)
        local module = loadstring(src)()
        Modules[name] = module
        return module
    end)

    if not success then
        if required then
            warn("[TMMW] ✗ CRITIQUE - Échec:", name)
        else
            warn("[TMMW] ✗ Échec:", name)
        end
        return nil
    end

    print("[TMMW] ✓ Chargé:", name)
    return result
end

-- ========================================
-- LOAD CORE TECH MODULES (UNIVERSAL ONLY)
-- ========================================

print("[TMMW] Chargement modules universels...")
local GameDetection     = loadModule("tech/GameDetection.lua", "GameDetection", false)
local UniversalFeatures = loadModule("tech/UniversalFeatures.lua", "UniversalFeatures", false)

-- ========================================
-- LOAD GAME-SPECIFIC TECH MODULES (CONDITIONALLY)
-- ========================================

local gameSpecificModules = {}

if isRecognizedGame then
    print("[TMMW] Chargement modules pour:", gameConfig.name)
    for _, moduleName in ipairs(gameConfig.techModules) do
        local modulePath = "tech/" .. moduleName .. ".lua"
        local loadedModule = loadModule(modulePath, moduleName, false)
        if loadedModule then
            table.insert(gameSpecificModules, {
                name = moduleName,
                module = loadedModule
            })
        end
    end
    print("[TMMW]", #gameSpecificModules, "module(s) spécifique(s) chargé(s)")
else
    print("[TMMW] Pas de modules spécifiques (mode universel)")
end

-- ========================================
-- LOAD UI MODULES
-- ========================================

print("[TMMW] Chargement interface...")
local LoadingScreen  = loadModule("ui/loading.lua", "LoadingScreen", true)
local Header         = loadModule("ui/header.lua", "Header", false)
local Sidebar        = loadModule("ui/sidebar.lua", "Sidebar", true)
local Components     = loadModule("ui/components.lua", "Components", false)
local ContentManager = loadModule("ui/content.lua", "ContentManager", true)

-- Pages universelles (toujours disponibles)
local HomePage       = loadModule("ui/pages/home.lua", "HomePage", true)
local UniversalPage  = loadModule("ui/pages/universal.lua", "UniversalPage", true)

-- Page spécifique (seulement si jeu reconnu)
local GameSpecificPage = nil
if isRecognizedGame and gameConfig.page then
    print("[TMMW] Chargement page spécifique:", gameConfig.name)
    GameSpecificPage = loadModule("ui/pages/" .. gameConfig.page, gameConfig.name .. "Page", false)
end

-- ========================================
-- BASIC VALIDATION
-- ========================================

if not LoadingScreen or not ContentManager or not HomePage or not UniversalPage then
    warn("[TMMW] Modules critiques manquants, arrêt.")
    return
end

-- ========================================
-- LOADING SCREEN
-- ========================================

local finishLoading = LoadingScreen.show(playerGui)

-- ========================================
-- INIT TECH SYSTEMS
-- ========================================

print("[TMMW] Initialisation systèmes...")

-- Universal systems (always safe)
pcall(function()
    if GameDetection and GameDetection.initialize then 
        GameDetection.initialize() 
        print("[TMMW] ✓ GameDetection initialisé")
    end
end)

pcall(function()
    if UniversalFeatures and UniversalFeatures.initialize then 
        UniversalFeatures.initialize() 
        print("[TMMW] ✓ UniversalFeatures initialisé")
    end
end)

-- Game-specific systems (only for recognized games)
if isRecognizedGame and #gameSpecificModules > 0 then
    print("[TMMW] Initialisation modules", gameConfig.name .. "...")
    for _, moduleData in ipairs(gameSpecificModules) do
        pcall(function()
            if moduleData.module and moduleData.module.initialize then
                moduleData.module.initialize()
                print("[TMMW] ✓", moduleData.name, "initialisé")
            end
        end)
    end
end

-- ========================================
-- SPAWN GUI
-- ========================================

task.spawn(function()
    finishLoading()

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

    if Header then
        pcall(function()
            Header.create(mainFrame, gui)
        end)
    end

    if Sidebar and ContentManager then
        local sidebar = Sidebar.create(mainFrame)
        local contentManager = ContentManager.new(mainFrame)

        -- Pages universelles (toujours)
        contentManager:registerPage("Home", HomePage)
        contentManager:registerPage("Universal", UniversalPage)
        
        -- Page spécifique (conditionnelle)
        if isRecognizedGame and GameSpecificPage then
            contentManager:registerPage(gameConfig.name, GameSpecificPage)
            print("[TMMW] ✓ Page", gameConfig.name, "disponible")
        end

        Sidebar.setupNavigation(sidebar, contentManager)
        contentManager:showPage("Home")
    end

    -- ========================================
    -- FINAL STATUS
    -- ========================================
    
    print("=====================================")
    print("[TMMW] ✓ HUB PRÊT")
    if isRecognizedGame then
        print("[TMMW] Mode:", gameConfig.name)
        print("[TMMW] Pages: Home, Universal,", gameConfig.name)
    else
        print("[TMMW] Mode: Universel")
        print("[TMMW] Pages: Home, Universal")
    end
    print("=====================================")
end)
