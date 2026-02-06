-- ========================================
-- TMMW HUB - MAIN ENTRY POINT
-- ========================================

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ========================================
-- SÉCURITÉ : DÉTRUIRE LES GUI EXISTANTS
-- ========================================

if playerGui:FindFirstChild("TMMWHubLoading") then
	playerGui.TMMWHubLoading:Destroy()
end

if playerGui:FindFirstChild("TMMWHubUI") then
	playerGui.TMMWHubUI:Destroy()
end

task.wait(0.1)

-- ========================================
-- CHARGER LES MODULES
-- ========================================

-- Module technique (logique métier)
local GameDetection = require(script.Parent.tech.GameDetection)
local ESPSystem = require(script.Parent.tech.ESPSystem)
local GunGrabber = require(script.Parent.tech.GunGrabber)
local CoinFarmer = require(script.Parent.tech.CoinFarmer)
local UniversalFeatures = require(script.Parent.tech.UniversalFeatures)

-- Modules UI
local LoadingScreen = require(script.Parent.ui.loading)
local Header = require(script.Parent.ui.header)
local Sidebar = require(script.Parent.ui.sidebar)
local Components = require(script.Parent.ui.components)
local ContentManager = require(script.Parent.ui.content)

-- Pages
local HomePage = require(script.Parent.ui.pages.home)
local MM2Page = require(script.Parent.ui.pages.mm2)
local UniversalPage = require(script.Parent.ui.pages.universal)

-- ========================================
-- INITIALISATION
-- ========================================

-- Afficher l'écran de chargement
LoadingScreen.show(playerGui)

-- Initialiser les systèmes techniques
GameDetection.initialize()
ESPSystem.initialize()
GunGrabber.initialize()
CoinFarmer.initialize()
UniversalFeatures.initialize()

-- Créer l'interface principale
local gui = Instance.new("ScreenGui")
gui.Name = "TMMWHubUI"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Parent = gui
mainFrame.Size = UDim2.new(0, 600, 0, 400)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.AnchorPoint = Vector2.new(0.5, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = mainFrame

-- Créer le header avec contrôles
Header.create(mainFrame, gui)

-- Créer la sidebar
local sidebar = Sidebar.create(mainFrame)

-- Créer le gestionnaire de contenu
local contentManager = ContentManager.new(mainFrame)

-- Enregistrer les pages
contentManager:registerPage("Home", HomePage)
contentManager:registerPage("MM2", MM2Page)
contentManager:registerPage("Universal", UniversalPage)

-- Configurer la navigation de la sidebar
Sidebar.setupNavigation(sidebar, contentManager)

-- Afficher la page par défaut
contentManager:showPage("Home")

print("TMMW Hub chargé avec succès!")
print("Mode de jeu détecté:", GameDetection.getCurrentGameMode())
