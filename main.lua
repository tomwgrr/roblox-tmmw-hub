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

print("[TMMW] === DÉBUT CHARGEMENT LOADING SCREEN ===")
local finishLoading = LoadingScreen.show(playerGui)
print("[TMMW] Type de finishLoading:", type(finishLoading))

-- ========================================
-- INIT TECH SYSTEMS
-- ========================================

print("[TMMW] === INITIALISATION SYSTÈMES ===")

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

print("[TMMW] === CRÉATION INTERFACE ===")

-- ========================================
-- CRÉER L'INTERFACE PRINCIPALE
-- ========================================

-- ======= MAIN GUI =======
local gui = Instance.new("ScreenGui")
gui.Name = "TMMWHubUI"
gui.ResetOnSpawn = false
gui.Parent = playerGui
print("[TMMW] ✓ ScreenGui créé")

local mainFrame = Instance.new("Frame")
mainFrame.Parent = gui
mainFrame.Size = UDim2.new(0, 600, 0, 400)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
print("[TMMW] ✓ MainFrame créé")

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

-- ========================================
-- UI SETUP
-- ========================================

print("[TMMW] === SETUP INTERFACE ===")

if Header then
    pcall(function()
        Header.create(mainFrame, gui)
        print("[TMMW] ✓ Header créé")
    end)
else
    print("[TMMW] ⚠ Header non disponible")
end

if Sidebar and ContentManager then
    print("[TMMW] Création Sidebar...")
    local sidebar = Sidebar.create(mainFrame)
    print("[TMMW] ✓ Sidebar créé")
    
    print("[TMMW] Création ContentManager...")
    local contentManager = ContentManager.new(mainFrame)
    print("[TMMW] ✓ ContentManager créé")
    
    print("[TMMW] === ENREGISTREMENT PAGES ===")

    -- Pages universelles (toujours)
    if HomePage then
        local success = contentManager:registerPage("Home", HomePage)
        if success then
            print("[TMMW] ✓ Page Home enregistrée")
        else
            warn("[TMMW] ✗ Échec page Home")
        end
    else
        warn("[TMMW] ⚠ HomePage non disponible")
    end
    
    if UniversalPage then
        local success = contentManager:registerPage("Universal", UniversalPage)
        if success then
            print("[TMMW] ✓ Page Universal enregistrée")
        else
            warn("[TMMW] ✗ Échec page Universal")
        end
    else
        warn("[TMMW] ⚠ UniversalPage non disponible")
    end
    
    -- Page spécifique (seulement si vraiment disponible)
    if isRecognizedGame and GameSpecificPage then
        local success = contentManager:registerPage(gameConfig.name, GameSpecificPage)
        if success then
            print("[TMMW] ✓ Page", gameConfig.name, "enregistrée")
        else
            warn("[TMMW] ✗ Impossible d'enregistrer la page", gameConfig.name)
        end
    end

    print("[TMMW] === SETUP NAVIGATION ===")
    Sidebar.setupNavigation(sidebar, contentManager)
    print("[TMMW] ✓ Navigation configurée")
    
    -- Vérifier que la page Home existe avant de l'afficher
    if contentManager:pageExists("Home") then
        contentManager:showPage("Home")
        print("[TMMW] ✓ Page Home affichée")
    else
        warn("[TMMW] ⚠ Page Home introuvable!")
    end
else
    warn("[TMMW] ⚠ Sidebar ou ContentManager non disponible")
end

-- ========================================
-- FERMETURE DU LOADING
-- ========================================

print("[TMMW] === FERMETURE LOADING SCREEN ===")
print("[TMMW] Attente 1 seconde avant fermeture...")
task.wait(1)

if finishLoading then
    if type(finishLoading) == "function" then
        print("[TMMW] Appel de finishLoading()...")
        local success, err = pcall(function()
            finishLoading()
        end)
        if success then
            print("[TMMW] ✓ finishLoading() exécuté avec succès")
        else
            warn("[TMMW] ✗ Erreur dans finishLoading():", err)
        end
    else
        warn("[TMMW] ✗ finishLoading n'est pas une fonction! Type:", type(finishLoading))
    end
else
    warn("[TMMW] ✗ finishLoading est nil!")
end

print("[TMMW] === ATTENTE 2 SECONDES ===")
task.wait(2)

-- Force close en cas de problème
print("[TMMW] Vérification du loading screen...")
if playerGui:FindFirstChild("TMMWHubLoading") then
    warn("[TMMW] ⚠ Loading screen encore présent! Force close...")
    playerGui.TMMWHubLoading:Destroy()
    print("[TMMW] ✓ Loading fermé de force")
end

-- ========================================
-- FINAL STATUS
-- ========================================

print("=====================================")
print("[TMMW] ✓ HUB COMPLÈTEMENT CHARGÉ")
if isRecognizedGame then
    print("[TMMW] Mode:", gameConfig.name)
else
    print("[TMMW] Mode: Universel")
end
print("[TMMW] Game PlaceId:", currentGameId)
print("=====================================")
