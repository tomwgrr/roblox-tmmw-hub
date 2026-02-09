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
    CurrentGame = nil
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
    print("[TMMW] Jeu détecté:", gameConfig.name)
else
    print("[TMMW] Mode universel - Jeu non reconnu")
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
    for _, moduleName in ipairs(gameConfig.techModules) do
        local modulePath = "tech/" .. moduleName .. ".lua"
        local loadedModule = loadModule(modulePath, moduleName)
        if loadedModule then
            table.insert(gameSpecificModules, loadedModule)
        end
    end
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
    GameSpecificPage = loadModule("ui/pages/" .. gameConfig.page, gameConfig.name .. "Page")
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
    if GameDetection then GameDetection.initialize() end
    if UniversalFeatures then UniversalFeatures.initialize() end
    
    -- Game-specific systems
    for _, module in ipairs(gameSpecificModules) do
        if module and module.initialize then
            module.initialize()
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

        -- Register universal pages
        if HomePage then 
            contentManager:registerPage("Home", HomePage) 
        end
        if UniversalPage then 
            contentManager:registerPage("Universal", UniversalPage) 
        end
        
        -- Register game-specific page if available
        if GameSpecificPage and gameConfig then
            contentManager:registerPage(gameConfig.name, GameSpecificPage)
        end

        Sidebar.setupNavigation(sidebar, contentManager)
        contentManager:showPage("Home")
    end

    print("[TMMW] Hub chargé avec succès")
    if gameConfig then
        print("[TMMW] Mode:", gameConfig.name)
    else
        print("[TMMW] Mode: Universel")
    end
    if GameDetection then
        print("[TMMW] Game ID:", currentGameId)
    end
end)
