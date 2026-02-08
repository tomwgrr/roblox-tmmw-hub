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
	
	-- Fond avec gradient animé
	local background = Instance.new("Frame")
	background.Parent = loadingGui
	background.Size = UDim2.new(1, 0, 1, 0)
	background.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
	background.BorderSizePixel = 0
	
	local bgGradient = Instance.new("UIGradient")
	bgGradient.Parent = background
	bgGradient.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 30)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(30, 10, 50)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 20))
	}
	bgGradient.Rotation = 45
	
	-- Animation du gradient de fond
	spawn(function()
		while loadingGui.Parent do
			local tween = TweenService:Create(bgGradient, TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
				Rotation = bgGradient.Rotation + 360
			})
			tween:Play()
			tween.Completed:Wait()
		end
	end)
	
	-- Particules d'arrière-plan
	for i = 1, 15 do
		local particle = Instance.new("Frame")
		particle.Parent = background
		particle.Size = UDim2.new(0, math.random(2, 6), 0, math.random(2, 6))
		particle.Position = UDim2.new(math.random(0, 100) / 100, 0, math.random(0, 100) / 100, 0)
		particle.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
		particle.BackgroundTransparency = math.random(50, 80) / 100
		particle.BorderSizePixel = 0
		
		local particleCorner = Instance.new("UICorner")
		particleCorner.CornerRadius = UDim.new(1, 0)
		particleCorner.Parent = particle
		
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
	centerContainer.Size = UDim2.new(0, 500, 0, 300)
	centerContainer.Position = UDim2.new(0.5, 0, 0.5, 0)
	centerContainer.AnchorPoint = Vector2.new(0.5, 0.5)
	centerContainer.BackgroundTransparency = 1
	
	-- Logo/Icône avec glow
	local logoContainer = Instance.new("Frame")
	logoContainer.Parent = centerContainer
	logoContainer.Size = UDim2.new(0, 120, 0, 120)
	logoContainer.Position = UDim2.new(0.5, 0, 0, 0)
	logoContainer.AnchorPoint = Vector2.new(0.5, 0)
	logoContainer.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
	logoContainer.BorderSizePixel = 0
	
	local logoCorner = Instance.new("UICorner")
	logoCorner.CornerRadius = UDim.new(0, 20)
	logoCorner.Parent = logoContainer
	
	-- Glow autour du logo
	local logoGlow = Instance.new("ImageLabel")
	logoGlow.Parent = logoContainer
	logoGlow.Size = UDim2.new(1, 40, 1, 40)
	logoGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
	logoGlow.AnchorPoint = Vector2.new(0.5, 0.5)
	logoGlow.BackgroundTransparency = 1
	logoGlow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
	logoGlow.ImageColor3 = Color3.fromRGB(138, 43, 226)
	logoGlow.ImageTransparency = 0.3
	logoGlow.ScaleType = Enum.ScaleType.Slice
	logoGlow.SliceCenter = Rect.new(10, 10, 118, 118)
	logoGlow.ZIndex = 0
	
	-- Animation de pulsation du glow
	local glowTween = TweenService:Create(logoGlow, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
		ImageTransparency = 0.7,
		Size = UDim2.new(1, 60, 1, 60)
	})
	glowTween:Play()
	
	-- Texte du logo
	local logoText = Instance.new("TextLabel")
	logoText.Parent = logoContainer
	logoText.Size = UDim2.new(1, 0, 1, 0)
	logoText.BackgroundTransparency = 1
	logoText.Text = "TM"
	logoText.TextColor3 = Color3.fromRGB(255, 255, 255)
	logoText.Font = Enum.Font.GothamBlack
	logoText.TextScaled = true
	logoText.ZIndex = 2
	
	local logoPadding = Instance.new("UIPadding")
	logoPadding.PaddingLeft = UDim.new(0, 20)
	logoPadding.PaddingRight = UDim.new(0, 20)
	logoPadding.PaddingTop = UDim.new(0, 20)
	logoPadding.PaddingBottom = UDim.new(0, 20)
	logoPadding.Parent = logoText
	
	-- Animation de rotation du logo
	spawn(function()
		while logoContainer.Parent do
			local rotateTween = TweenService:Create(logoContainer, TweenInfo.new(3, Enum.EasingStyle.Linear), {
				Rotation = logoContainer.Rotation + 360
			})
			rotateTween:Play()
			rotateTween.Completed:Wait()
		end
	end)
	
	-- Titre principal
	local title = Instance.new("TextLabel")
	title.Parent = centerContainer
	title.Size = UDim2.new(1, 0, 0, 80)
	title.Position = UDim2.new(0.5, 0, 0, 140)
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
	subtitle.Position = UDim2.new(0.5, 0, 0, 230)
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
	progressBarBg.Position = UDim2.new(0.5, 0, 1, -20)
	progressBarBg.AnchorPoint = Vector2.new(0.5, 0)
	progressBarBg.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
	progressBarBg.BorderSizePixel = 0
	
	local progressBarCorner = Instance.new("UICorner")
	progressBarCorner.CornerRadius = UDim.new(1, 0)
	progressBarCorner.Parent = progressBarBg
	
	local progressBar = Instance.new("Frame")
	progressBar.Parent = progressBarBg
	progressBar.Size = UDim2.new(0, 0, 1, 0)
	progressBar.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
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
	percentText.Position = UDim2.new(0.5, 0, 1, 0)
	percentText.AnchorPoint = Vector2.new(0.5, 0)
	percentText.BackgroundTransparency = 1
	percentText.TextColor3 = Color3.fromRGB(138, 43, 226)
	percentText.Font = Enum.Font.GothamBold
	percentText.TextSize = 18
	percentText.Text = "0%"
	percentText.TextTransparency = 1
	
	-- ANIMATIONS D'ENTRÉE
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
	
	subtitle.Text = "Advanced Script Hub"
	
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
	
	-- ANIMATIONS DE SORTIE
	local fadeInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	
	local fadeTitle = TweenService:Create(title, fadeInfo, {TextTransparency = 1})
	local fadeSubtitle = TweenService:Create(subtitle, fadeInfo, {TextTransparency = 1})
	local fadePercent = TweenService:Create(percentText, fadeInfo, {TextTransparency = 1})
	local fadeProgressBg = TweenService:Create(progressBarBg, fadeInfo, {BackgroundTransparency = 1})
	local fadeProgressBar = TweenService:Create(progressBar, fadeInfo, {BackgroundTransparency = 1})
	local fadeLogo = TweenService:Create(logoContainer, fadeInfo, {BackgroundTransparency = 1})
	local fadeLogoText = TweenService:Create(logoText, fadeInfo, {TextTransparency = 1})
	local fadeBackground = TweenService:Create(background, fadeInfo, {BackgroundTransparency = 1})
	
	fadeTitle:Play()
	fadeSubtitle:Play()
	fadePercent:Play()
	fadeProgressBg:Play()
	fadeProgressBar:Play()
	fadeLogo:Play()
	fadeLogoText:Play()
	fadeBackground:Play()
	
	fadeBackground.Completed:Wait()
	
	loadingGui:Destroy()
end

return LoadingScreen
