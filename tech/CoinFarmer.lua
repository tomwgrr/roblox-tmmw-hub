-- ========================================
-- COIN FARMER MODULE
-- Farm automatiquement les coins dans MM2
-- ========================================

local player = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")

local CoinFarmer = {}

local autoFarmEnabled = false
local currentTween = nil
local farmConnection = nil

function CoinFarmer.initialize()
	-- Rien à faire à l'initialisation
end

-- Trouver la coin la plus proche
local function findNearestCoin()
	local character = player.Character
	if not character or not character:FindFirstChild("HumanoidRootPart") then 
		return nil 
	end
	
	local hrp = character.HumanoidRootPart
	local nearestCoin = nil
	local shortestDistance = math.huge
	
	-- Chercher toutes les coins dans le Workspace
	for _, obj in pairs(game.Workspace:GetDescendants()) do
		if obj.Name == "Coin_Server" and obj:IsA("BasePart") then
			local distance = (obj.Position - hrp.Position).Magnitude
			
			if distance < shortestDistance then
				shortestDistance = distance
				nearestCoin = obj
			end
		end
	end
	
	return nearestCoin
end

-- Fonction de farm
local function farmCoins()
	if not autoFarmEnabled then return end
	
	local character = player.Character
	if not character or not character:FindFirstChild("HumanoidRootPart") then return end
	
	local hrp = character.HumanoidRootPart
	local nearestCoin = findNearestCoin()
	
	if nearestCoin then
		-- Annuler le tween précédent s'il existe
		if currentTween then
			currentTween:Cancel()
			currentTween = nil
		end
		
		local distance = (nearestCoin.Position - hrp.Position).Magnitude
		
		-- Si la coin est très proche (moins de 5 studs), TP direct
		if distance < 5 then
			hrp.CFrame = nearestCoin.CFrame
			task.wait(0.1)
			return
		end
		
		-- Créer un tween vers la coin
		local speed = 25 -- Vitesse en studs/seconde
		local tweenTime = distance / speed
		
		local tweenInfo = TweenInfo.new(
			tweenTime,
			Enum.EasingStyle.Linear,
			Enum.EasingDirection.Out,
			0,
			false,
			0
		)
		
		currentTween = TweenService:Create(hrp, tweenInfo, {CFrame = nearestCoin.CFrame})
		
		-- Détecter quand la coin est touchée/détruite
		local coinTouched = false
		local touchConnection
		
		if nearestCoin:IsA("BasePart") then
			touchConnection = nearestCoin.Touched:Connect(function(hit)
				if hit.Parent == character then
					coinTouched = true
					if currentTween then
						currentTween:Cancel()
					end
					if touchConnection then
						touchConnection:Disconnect()
					end
				end
			end)
		end
		
		-- Détecter si la coin est détruite
		local ancestryConnection
		ancestryConnection = nearestCoin.AncestryChanged:Connect(function(_, parent)
			if not parent then
				coinTouched = true
				if currentTween then
					currentTween:Cancel()
				end
				if touchConnection then
					touchConnection:Disconnect()
				end
				if ancestryConnection then
					ancestryConnection:Disconnect()
				end
			end
		end)
		
		currentTween:Play()
		
		-- Boucle de vérification pendant le tween
		local startTime = tick()
		while currentTween and currentTween.PlaybackState == Enum.PlaybackState.Playing and not coinTouched do
			task.wait(0.1)
			
			if nearestCoin and nearestCoin.Parent then
				local currentDistance = (nearestCoin.Position - hrp.Position).Magnitude
				if currentDistance < 3 then
					coinTouched = true
					break
				end
			else
				coinTouched = true
				break
			end
			
			-- Timeout de sécurité
			if tick() - startTime > 15 then
				break
			end
		end
		
		-- Nettoyer
		if currentTween then
			currentTween:Cancel()
			currentTween = nil
		end
		if touchConnection then
			touchConnection:Disconnect()
		end
		if ancestryConnection then
			ancestryConnection:Disconnect()
		end
		
		task.wait(0.1)
	else
		task.wait(0.3)
	end
end

-- API publique
function CoinFarmer.setAutoFarm(enabled)
	autoFarmEnabled = enabled
	
	if enabled then
		print("Auto Farm Coins: ON")
		
		-- Démarrer la boucle de farm
		farmConnection = task.spawn(function()
			while autoFarmEnabled do
				pcall(farmCoins)
			end
		end)
	else
		print("Auto Farm Coins: OFF")
		
		-- Arrêter le tween en cours
		if currentTween then
			currentTween:Cancel()
			currentTween = nil
		end
	end
end

return CoinFarmer
