-- ========================================
-- LOADING SCREEN MODULE - ULTRA STYLE (CENTER-TOP)
-- ========================================
local TweenService = game:GetService("TweenService")
local LoadingScreen = {}

function LoadingScreen.show(playerGui)
	local loadingGui = Instance.new("ScreenGui")
	loadingGui.Name = "TMMWHubLoading"
	loadingGui.ResetOnSpawn = false
	loadingGui.IgnoreGuiInset = true -- Permet d'utiliser tout l'écran, même derrière la barre Roblox
	loadingGui.Parent = playerGui
	
	-- Particules flottantes
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
		
		spawn(function()
			task.wait(i * 0.05)
			local fadeIn = TweenService:Create(particle, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				BackgroundTransparency = math.random(50, 80) / 100
			})
			fadeIn:Play()
		end)
		
		spawn(function()
			while particle.Parent do
				local randomY = UDim2.new(particle.Position.X.Scale, 0, math.random(-10, 110) / 100, 0)
				local tween = TweenService:Create(particle, TweenInfo.new(math.random(8, 15), Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
					Position = randomY
				})
				tween:Play()
				tween.Completed:Wait()
			end
		end)
	end
	
	-- ========================================
	-- MODIFICATION ICI : POSITIONNEMENT
	-- ========================================
	local centerContainer = Instance.new("Frame")
	centerContainer.Parent = loadingGui
	centerContainer.Size = UDim2.new(0, 500, 0, 200)
	-- Positionné à 50% horizontal (milieu) et 30% vertical (entre le haut et le centre)
	centerContainer.Position = UDim2.new(0.5, 0, 0.3, 0) 
	centerContainer.AnchorPoint = Vector2.new(0.5, 0.5)
	centerContainer.BackgroundTransparency = 1
	
	-- Titre principal (Centré dans le container)
	local title = Instance.new("TextLabel")
	title.Parent = centerContainer
	title.Size = UDim2.new(1, 0, 0, 80)
	title.Position = UDim2.new(0.5, 0, 0, 0)
	title.AnchorPoint = Vector2.new(0.5, 0)
	title.BackgroundTransparency = 1
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.TextScaled = true
	title.Font = Enum.Font.GothamBlack
	title.Text = ""
	title.TextTransparency = 1
	
	local titlePadding = Instance.new("UIPadding")
	titlePadding.PaddingLeft = UDim.new(0, 40)
	titlePadding.PaddingRight = UDim.new(0, 40)
	titlePadding.Parent = title
	
	local titleGradient = Instance.new("UIGradient")
	titleGradient.Parent = title
	titleGradient.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(138, 43, 226)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
	}
	
	spawn(function()
		while title.Parent do
			local tween = TweenService:Create(titleGradient, TweenInfo.new(2, Enum.EasingStyle.Linear), {
				Offset = Vector2.new(1, 0)
			})
			tween:Play()
			tween.Completed:Wait()
			titleGradient.Offset = Vector2.new(-1, 0)
		end
	end)
	
	-- Sous-titre
	local subtitle = Instance.new("TextLabel")
	subtitle.Parent = centerContainer
	subtitle.Size = UDim2.new(1, 0, 0, 30)
	subtitle.Position = UDim2.new(0.5, 0, 0, 90)
	subtitle.AnchorPoint = Vector2.new(0.5, 0)
	subtitle.BackgroundTransparency = 1
	subtitle.TextColor3 = Color3.fromRGB(180, 180, 200)
	subtitle.TextScaled = true
	subtitle.Font = Enum.Font.Gotham
	subtitle.Text = ""
	subtitle.TextTransparency = 1
	
	-- Barre de progression
	local progressBarBg = Instance.new("Frame")
	progressBarBg.Parent = centerContainer
	progressBarBg.Size = UDim2.new(0.8, 0, 0, 6)
	progressBarBg.Position = UDim2.new(0.5, 0, 1, -50)
	progressBarBg.AnchorPoint = Vector2.new(0.5, 0)
	progressBarBg.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
	progressBarBg.BackgroundTransparency = 1
	progressBarBg.BorderSizePixel = 0
	
	local progressBarCorner = Instance.new("UICorner")
	progressBarCorner.CornerRadius = UDim.new(1, 0)
	progressBarCorner.Parent = progressBarBg
	
	local progressBar = Instance.new("Frame")
	progressBar.Parent = progressBarBg
	progressBar.Size = UDim2.new(0, 0, 1, 0)
	progressBar.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
	progressBar.BackgroundTransparency = 1
	progressBar.BorderSizePixel = 0
	
	local progressCorner = Instance.new("UICorner")
	progressCorner.CornerRadius = UDim.new(1, 0)
	progressCorner.Parent = progressBar
	
	local progressGradient = Instance.new("UIGradient")
	progressGradient.Parent = progressBar
	progressGradient.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(138, 43, 226)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(180, 80, 255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(138, 43, 226))
	}
	
	spawn(function()
		while progressBar.Parent do
			local tween = TweenService:Create(progressGradient, TweenInfo.new(1.5, Enum.EasingStyle.Linear), {
				Offset = Vector2.new(1, 0)
			})
			tween:Play()
			tween.Completed:Wait()
			progressGradient.Offset = Vector2.new(-1, 0)
		end
	end)
	
	-- Pourcentage..
	local percentText = Instance.new("TextLabel")
	percentText.Parent = centerContainer
	percentText.Size = UDim2.new(0, 100, 0, 25)
	percentText.Position = UDim2.new(0.5, 0, 1, -20)
	percentText.AnchorPoint = Vector2.new(0.5, 0)
	percentText.BackgroundTransparency = 1
	percentText.TextColor3 = Color3.fromRGB(138, 43, 226)
	percentText.Font = Enum.Font.GothamBold
	percentText.TextSize = 18
	percentText.Text = "0%"
	percentText.TextTransparency = 1
	
	-- LOGIQUE D'ANIMATION
	task.wait(0.2)
	
	TweenService:Create(title, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
	local text = "TMMW HUB"
	for i = 1, #text do
		title.Text = string.sub(text, 1, i)
		task.wait(0.1)
	end
	
	task.wait(0.3)
	TweenService:Create(subtitle, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
	subtitle.Text = "Murder Mystery 2"
	
	TweenService:Create(progressBarBg, TweenInfo.new(0.5), {BackgroundTransparency = 0.3}):Play()
	TweenService:Create(progressBar, TweenInfo.new(0.5), {BackgroundTransparency = 0}):Play()
	TweenService:Create(percentText, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
	
	local progressDuration = 2.5
	for i = 0, 100 do
		local progress = i / 100
		progressBar.Size = UDim2.new(progress, 0, 1, 0)
		percentText.Text = i .. "%"
		task.wait(progressDuration / 100)
	end
	
	task.wait(0.3)
	
	-- FADE OUT COMPLET
	local fadeInfo = TweenInfo.new(0.6)
	local components = {title, subtitle, percentText, progressBarBg, progressBar}
	for _, comp in pairs(components) do
		TweenService:Create(comp, fadeInfo, {
			[comp:IsA("Frame") and "BackgroundTransparency" or "TextTransparency"] = 1
		}):Play()
	end
	
	for _, child in pairs(particlesContainer:GetChildren()) do
		if child:IsA("Frame") then
			TweenService:Create(child, fadeInfo, {BackgroundTransparency = 1}):Play()
		end
	end
	
	task.wait(0.6)
	loadingGui:Destroy()
end

return LoadingScreen
