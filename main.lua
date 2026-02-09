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
-- GLOBAL ENV
-- ========================================

getgenv().TMMW = {
    Modules = {},
    Services = {
        TweenService = TweenService,
        UserInputService = UserInputService,
        Players = Players,
    },
    CurrentGame = nil,
    IsUniversalMode = true
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
-- GAME DETECTION
-- ========================================

local currentGameId = game.PlaceId
local gameConfig = GAME_CONFIGS[currentGameId]

if gameConfig then
    getgenv().TMMW.CurrentGame = gameConfig
    getgenv().TMMW.IsUniversalMode = false
    print("[TMMW] Jeu détecté:", gameConfig.name, "| PlaceId:", currentGameId)
else
    print("[TMMW] Mode universel - PlaceId:", currentGameId)
end

-- ========================================
-- LOAD CORE TECH MODULES (UNIVERSAL)
-- ========================================

local GameDetection     = loadModule("tech/GameDetection.lua", "GameDetection")
local UniversalFeatures = loadModule("tech/UniversalFeatures.lua", "UniversalFeatures")

-- ========================================
-- LOAD GAME-SPECIFIC TECH MODULES
-- ========================================

local gameSpecificModules = {}

if gameConfig and gameConfig.techModules then
    print("[TMMW] Chargement des modules spécifiques pour:", gameConfig.name)
    for _, moduleName in ipairs(gameConfig.techModules) do
        local modulePath = "tech/" .. moduleName .. ".lua"
        print("[TMMW] Tentative de chargement:", moduleName)
        local loadedModule = loadModule(modulePath, moduleName)
        if loadedModule then
            table.insert(gameSpecificModules, loadedModule)
            print("[TMMW] ✓", moduleName, "chargé")
        else
            warn("[TMMW] ✗", moduleName, "échec")
        end
    end
else
    print("[TMMW] Aucun module spécifique - Mode universel uniquement")
end

-- ========================================
-- LOAD UI MODULES
-- ========================================

local LoadingScreen  = loadModule("ui/loading.lua", "LoadingScreen")
local Header         = loadModule("ui/header.lua", "Header")
local Sidebar        = loadModule("ui/sidebar.lua", "Sidebar")
local Components     = loadModule("ui/components.lua", "Components")
local ContentManager = loadModule("ui/content.lua", "ContentManager")

-- Pages universelles
local HomePage       = loadModule("ui/pages/home.lua", "HomePage")
local UniversalPage  = loadModule("ui/pages/universal.lua", "UniversalPage")

-- Page spécifique au jeu (si disponible)
local GameSpecificPage = nil
if gameConfig and gameConfig.page then
    print("[TMMW] Chargement de la page:", gameConfig.page)
    GameSpecificPage = loadModule("ui/pages/" .. gameConfig.page, gameConfig.name .. "Page")
    if GameSpecificPage then
        print("[TMMW] ✓ Page", gameConfig.name, "chargée")
    else
        warn("[TMMW] ✗ Échec chargement page", gameConfig.name)
    end
end

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

local finishLoading = LoadingScreen.show(playerGui)

-- ========================================
-- INIT TECH SYSTEMS
-- ========================================

pcall(function()
    -- Core universal systems
    print("[TMMW] Initialisation des systèmes universels...")
    if GameDetection then 
        GameDetection.initialize() 
        print("[TMMW] ✓ GameDetection initialisé")
    end
    if UniversalFeatures then 
        UniversalFeatures.initialize() 
        print("[TMMW] ✓ UniversalFeatures initialisé")
    end
    
    -- Game-specific systems (only if game is recognized)
    if #gameSpecificModules > 0 then
        print("[TMMW] Initialisation des systèmes spécifiques...")
        for _, module in ipairs(gameSpecificModules) do
            if module and module.initialize then
                pcall(function()
                    module.initialize()
                    print("[TMMW] ✓ Module spécifique initialisé")
                end)
            end
        end
    end
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

    if Header then
        Header.create(mainFrame, gui)
    end

    if Sidebar and ContentManager then
        local sidebar = Sidebar.create(mainFrame)
        local contentManager = ContentManager.new(mainFrame)

        -- Register universal pages (always available)
        if HomePage then 
            contentManager:registerPage("Home", HomePage)
            print("[TMMW] ✓ Page Home enregistrée")
        end
        if UniversalPage then 
            contentManager:registerPage("Universal", UniversalPage)
            print("[TMMW] ✓ Page Universal enregistrée")
        end
        
        -- Register game-specific page ONLY if game is recognized
        if GameSpecificPage and gameConfig then
            contentManager:registerPage(gameConfig.name, GameSpecificPage)
            print("[TMMW] ✓ Page", gameConfig.name, "enregistrée")
        end

        Sidebar.setupNavigation(sidebar, contentManager)
        contentManager:showPage("Home")
    end

    -- ========================================
    -- FINAL STATUS
    -- ========================================
    
    print("=====================================")
    print("[TMMW] Hub chargé avec succès ✓")
    if gameConfig then
        print("[TMMW] Mode:", gameConfig.name)
        print("[TMMW] Fonctionnalités:", "Universal + " .. gameConfig.name)
    else
        print("[TMMW] Mode: Universel seulement")
        print("[TMMW] Fonctionnalités: Universal uniquement")
    end
    print("[TMMW] Game PlaceId:", currentGameId)
    print("=====================================")
end)
