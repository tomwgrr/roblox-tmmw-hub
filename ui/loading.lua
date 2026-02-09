-- ========================================
-- LOADING SCREEN MODULE - ULTRA STYLE
-- ========================================
local TweenService = game:GetService("TweenService")
local LoadingScreen = {}

function LoadingScreen.show(playerGui)
	local loadingGui = Instance.new("ScreenGui")
	loadingGui.Name = "TMMWHubLoading"
	loadingGui.ResetOnSpawn = false
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
		
		-- Fade in des particules
		spawn(function()
			task.wait(i * 0.05)
			local fadeIn = TweenService:Create(particle, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				BackgroundTransparency = math.random(50, 80) / 100
			})
			fadeIn:Play()
		end)
		
		-- Animation flottante
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
	
	-- Container central
	local centerContainer = Instance.new("Frame")
	centerContainer.Parent = loadingGui
	centerContainer.Size = UDim2.new(0, 500, 0, 200)
	centerContainer.Position = UDim2.new(0.2, 0, 0.5, 0)
	centerContainer.AnchorPoint = Vector2.new(0.5, 0.5)
	centerContainer.BackgroundTransparency = 1
	
	-- Titre principal
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
	
	-- Gradient sur le titre
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
	
	-- Barre de progression stylée
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
	
	-- Gradient sur la barre de progression
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
	
	-- Pourcentage
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
	
	-- ANIMATIONS D'ENTRÉE (FADE IN)
	task.wait(0.2)
	
	-- Fade in du titre
	local titleFadeIn = TweenService:Create(title, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		TextTransparency = 0
	})
	titleFadeIn:Play()
	
	-- Animation du texte
	local text = "TMMW HUB"
	for i = 1, #text do
		title.Text = string.sub(text, 1, i)
		task.wait(0.1)
	end
	
	task.wait(0.3)
	
	-- Fade in du sous-titre
	local subtitleFadeIn = TweenService:Create(subtitle, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		TextTransparency = 0
	})
	subtitleFadeIn:Play()
	
	subtitle.Text = "Murder Mystery 2"
	
	-- Fade in de la barre de progression
	local progressBgFadeIn = TweenService:Create(progressBarBg, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		BackgroundTransparency = 0.3
	})
	progressBgFadeIn:Play()
	
	local progressBarFadeIn = TweenService:Create(progressBar, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		BackgroundTransparency = 0
	})
	progressBarFadeIn:Play()
	
	-- Fade in du pourcentage
	local percentFadeIn = TweenService:Create(percentText, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		TextTransparency = 0
	})
	percentFadeIn:Play()
	
	-- Animation de la barre de progression
	local progressDuration = 2.5
	local steps = 100
	local stepTime = progressDuration / steps
	
	for i = 0, steps do
		local progress = i / steps
		progressBar.Size = UDim2.new(progress, 0, 1, 0)
		percentText.Text = math.floor(progress * 100) .. "%"
		task.wait(stepTime)
	end
	
	task.wait(0.3)
	
	-- ANIMATIONS DE SORTIE (FADE OUT)
	local fadeInfo = TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	
	local fadeTitle = TweenService:Create(title, fadeInfo, {TextTransparency = 1})
	local fadeSubtitle = TweenService:Create(subtitle, fadeInfo, {TextTransparency = 1})
	local fadePercent = TweenService:Create(percentText, fadeInfo, {TextTransparency = 1})
	local fadeProgressBg = TweenService:Create(progressBarBg, fadeInfo, {BackgroundTransparency = 1})
	local fadeProgressBar = TweenService:Create(progressBar, fadeInfo, {BackgroundTransparency = 1})
	
	fadeTitle:Play()
	fadeSubtitle:Play()
	fadePercent:Play()
	fadeProgressBg:Play()
	fadeProgressBar:Play()
	
	-- Fade out des particules
	for _, child in pairs(particlesContainer:GetChildren()) do
		if child:IsA("Frame") then
			local particleFade = TweenService:Create(child, fadeInfo, {BackgroundTransparency = 1})
			particleFade:Play()
		end
	end
	
	fadeTitle.Completed:Wait()
	
	loadingGui:Destroy()
end

return LoadingScreen
