-- ========================================
-- LOADING SCREEN MODULE - ULTRA STYLE (TOP-CENTER FIXED)
-- ========================================
local TweenService = game:GetService("TweenService")
local LoadingScreen = {}

function LoadingScreen.show(playerGui)
	-- Création du ScreenGui principal
	local loadingGui = Instance.new("ScreenGui")
	loadingGui.Name = "TMMWHubLoading"
	loadingGui.ResetOnSpawn = false
	loadingGui.IgnoreGuiInset = true -- Crucial pour que le "Top" soit vraiment en haut
	loadingGui.Parent = playerGui
	
	-- Particules flottantes en arrière-plan
	local particlesContainer = Instance.new("Frame")
	particlesContainer.Parent = loadingGui
	particlesContainer.Size = UDim2.new(1, 0, 1, 0)
	particlesContainer.BackgroundTransparency = 1
	particlesContainer.BorderSizePixel = 0
	
	for i = 1, 15 do
		local particle = Instance.new("Frame")
		particle.Parent = particlesContainer
		particle.Size = UDim2.new(0, math.random(2, 6), 0, math.random(2, 6))
		particle.Position = UDim2.new(math.random(0, 100) / 100, 0, math.random(0, 100) / 100, 0)
		particle.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
		particle.BackgroundTransparency = 1
		particle.BorderSizePixel = 0
		
		local particleCorner = Instance.new("UICorner")
		particleCorner.CornerRadius = UDim.new(1, 0)
		particleCorner.Parent = particle
		
		task.spawn(function()
			task.wait(i * 0.05)
			TweenService:Create(particle, TweenInfo.new(0.5), {BackgroundTransparency = math.random(50, 80) / 100}):Play()
			while particle.Parent do
				local targetPos = UDim2.new(particle.Position.X.Scale, 0, math.random(-10, 110) / 100, 0)
				local t = TweenService:Create(particle, TweenInfo.new(math.random(8, 15), Enum.EasingStyle.Sine), {Position = targetPos})
				t:Play()
				t.Completed:Wait()
			end
		end)
	end
	
	-- ========================================
	-- CONTENEUR CENTRAL (POSITIONNÉ TOP-CENTER)
	-- ========================================
	local centerContainer = Instance.new("Frame")
	centerContainer.Parent = loadingGui
	centerContainer.Size = UDim2.new(0, 500, 0, 200)
	centerContainer.Position = UDim2.new(0.5, 0, 0.25, 0) -- 25% de la hauteur de l'écran
	centerContainer.AnchorPoint = Vector2.new(0.5, 0.5)
	centerContainer.BackgroundTransparency = 1
	
	-- Titre principal (TMMW HUB)
	local title = Instance.new("TextLabel")
	title.Parent = centerContainer
	title.Size = UDim2.new(1, 0, 0, 70)
	title.Position = UDim2.new(0.5, 0, 0, 0) -- Centré X
	title.AnchorPoint = Vector2.new(0.5, 0)
	title.BackgroundTransparency = 1
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.TextScaled = true
	title.Font = Enum.Font.GothamBlack
	title.Text = ""
	title.TextTransparency = 1
	
	local titleGradient = Instance.new("UIGradient")
	titleGradient.Parent = title
	titleGradient.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(138, 43, 226)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
	}
	
	task.spawn(function()
		while title.Parent do
			titleGradient.Offset = Vector2.new(-1, 0)
			local t = TweenService:Create(titleGradient, TweenInfo.new(2, Enum.EasingStyle.Linear), {Offset = Vector2.new(1, 0)})
			t:Play()
			t.Completed:Wait()
		end
	end)
	
	-- Sous-titre
	local subtitle = Instance.new("TextLabel")
	subtitle.Parent = centerContainer
	subtitle.Size = UDim2.new(1, 0, 0, 25)
	subtitle.Position = UDim2.new(0.5, 0, 0, 75) -- Centré X
	subtitle.AnchorPoint = Vector2.new(0.5, 0)
	subtitle.BackgroundTransparency = 1
	subtitle.TextColor3 = Color3.fromRGB(180, 180, 200)
	subtitle.TextScaled = true
	subtitle.Font = Enum.Font.Gotham
	subtitle.Text = "Murder Mystery 2"
	subtitle.TextTransparency = 1
	
	-- Barre de progression (Fond)
	local progressBarBg = Instance.new("Frame")
	progressBarBg.Parent = centerContainer
	progressBarBg.Size = UDim2.new(0.7, 0, 0, 4)
	progressBarBg.Position = UDim2.new(0.5, 0, 0, 120) -- Centré X
	progressBarBg.AnchorPoint = Vector2.new(0.5, 0)
	progressBarBg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	progressBarBg.BackgroundTransparency = 1 -- Animé plus tard
	progressBarBg.BorderSizePixel = 0
	
	local uiCornerBg = Instance.new("UICorner")
	uiCornerBg.CornerRadius = UDim.new(1, 0)
	uiCornerBg.Parent = progressBarBg
	
	-- Barre de progression (Remplissage)
	local progressBar = Instance.new("Frame")
	progressBar.Parent = progressBarBg
	progressBar.Size = UDim2.new(0, 0, 1, 0)
	progressBar.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
	progressBar.BorderSizePixel = 0
	
	local uiCornerFill = Instance.new("UICorner")
	uiCornerFill.CornerRadius = UDim.new(1, 0)
	uiCornerFill.Parent = progressBar
	
	local progressGradient = Instance.new("UIGradient")
	progressGradient.Parent = progressBar
	progressGradient.Color = ColorSequence.new(Color3.fromRGB(138, 43, 226), Color3.fromRGB(200, 100, 255))
	
	-- Texte de pourcentage
	local percentText = Instance.new("TextLabel")
	percentText.Parent = centerContainer
	percentText.Size = UDim2.new(0, 100, 0, 20)
	percentText.Position = UDim2.new(0.5, 0, 0, 135) -- Centré X
	percentText.AnchorPoint = Vector2.new(0.5, 0)
	percentText.BackgroundTransparency = 1
	percentText.TextColor3 = Color3.fromRGB(255, 255, 255)
	percentText.Font = Enum.Font.GothamBold
	percentText.TextSize = 14
	percentText.Text = "0%"
	percentText.TextTransparency = 1

	-- ========================================
	-- SÉQUENCE D'ANIMATION
	-- ========================================
	task.wait(0.5)
	
	-- 1. Apparition progressive du titre (effet machine à écrire)
	TweenService:Create(title, TweenInfo.new(0.8), {TextTransparency = 0}):Play()
	local fullText = "TMMW HUB"
	for i = 1, #fullText do
		title.Text = string.sub(fullText, 1, i)
		task.wait(0.08)
	end
	
	-- 2. Apparition du reste des éléments
	TweenService:Create(subtitle, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
	TweenService:Create(progressBarBg, TweenInfo.new(0.5), {BackgroundTransparency = 0.8}):Play()
	TweenService:Create(percentText, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
	
	-- 3. Animation de la barre de progression
	local duration = 2.5
	for i = 0, 100 do
		local progress = i / 100
		progressBar.Size = UDim2.new(progress, 0, 1, 0)
		percentText.Text = i .. "%"
		task.wait(duration / 100)
	end
	
	task.wait(0.5)
	
	-- 4. Disparition (Fade Out)
	local fadeInfo = TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
	for _, v in pairs(centerContainer:GetChildren()) do
		if v:IsA("TextLabel") then
			TweenService:Create(v, fadeInfo, {TextTransparency = 1}):Play()
		elseif v:IsA("Frame") then
			TweenService:Create(v, fadeInfo, {BackgroundTransparency = 1}):Play()
			if v:FindFirstChild("Frame") then -- Gère la barre de progression intérieure
				TweenService:Create(v.Frame, fadeInfo, {BackgroundTransparency = 1}):Play()
			end
		end
	end
	
	-- Fade out des particules
	for _, p in pairs(particlesContainer:GetChildren()) do
		if p:IsA("Frame") then
			TweenService:Create(p, fadeInfo, {BackgroundTransparency = 1}):Play()
		end
	end
	
	task.wait(0.7)
	loadingGui:Destroy()
end

return LoadingScreen
