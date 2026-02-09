-- File: LoadingScreen.lua
-- Ultra Dynamic Cinematic Loading Screen

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local LoadingScreen = {}

local THEME_COLOR = Color3.fromRGB(138, 43, 226)

local function tween(obj, info, props)
	local t = TweenService:Create(obj, info, props)
	t:Play()
	return t
end

function LoadingScreen.show(playerGui)
	-- ScreenGui
	local gui = Instance.new("ScreenGui")
	gui.Name = "TMMWHubLoading"
	gui.IgnoreGuiInset = true
	gui.ResetOnSpawn = false
	gui.Parent = playerGui

	-- =====================
	-- BACKGROUND PARTICLES
	-- =====================
	local particles = Instance.new("Frame")
	particles.Size = UDim2.fromScale(1, 1)
	particles.BackgroundTransparency = 1
	particles.Parent = gui

	for i = 1, 22 do
		local p = Instance.new("Frame")
		p.Size = UDim2.fromOffset(math.random(3, 6), math.random(3, 6))
		p.Position = UDim2.fromScale(math.random(), math.random())
		p.BackgroundColor3 = THEME_COLOR
		p.BackgroundTransparency = 1
		p.BorderSizePixel = 0
		p.Parent = particles

		Instance.new("UICorner", p).CornerRadius = UDim.new(1, 0)

		task.spawn(function()
			task.wait(i * 0.1)
			tween(p, TweenInfo.new(1.2), {BackgroundTransparency = 0.7})

			while p.Parent do
				tween(
					p,
					TweenInfo.new(math.random(12, 18), Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
					{Position = UDim2.fromScale(math.random(), math.random())}
				).Completed:Wait()
			end
		end)
	end

	-- =====================
	-- CONTAINER
	-- =====================
	local container = Instance.new("Frame")
	container.Size = UDim2.fromOffset(520, 220)
	container.Position = UDim2.fromScale(0.5, 0.25)
	container.AnchorPoint = Vector2.new(0.5, 0.5)
	container.BackgroundTransparency = 1
	container.Parent = gui

	-- subtle breathing
	task.spawn(function()
		while container.Parent do
			tween(container, TweenInfo.new(3, Enum.EasingStyle.Sine), {Position = container.Position + UDim2.fromOffset(0, -6)}).Completed:Wait()
			tween(container, TweenInfo.new(3, Enum.EasingStyle.Sine), {Position = container.Position}):Wait()
		end
	end)

	-- =====================
	-- TITLE
	-- =====================
	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, 0, 0, 70)
	title.BackgroundTransparency = 1
	title.Text = ""
	title.Font = Enum.Font.GothamBlack
	title.TextScaled = true
	title.TextColor3 = Color3.new(1, 1, 1)
	title.TextTransparency = 1
	title.Parent = container

	local grad = Instance.new("UIGradient", title)
	grad.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
		ColorSequenceKeypoint.new(0.5, THEME_COLOR),
		ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1)),
	})

	task.spawn(function()
		while title.Parent do
			grad.Offset = Vector2.new(-1, 0)
			tween(grad, TweenInfo.new(2.8, Enum.EasingStyle.Linear), {Offset = Vector2.new(1, 0)}).Completed:Wait()
		end
	end)

	-- Typewriter slow
	local text = "TMMW HUB"
	tween(title, TweenInfo.new(0.8), {TextTransparency = 0})
	for i = 1, #text do
		title.Text = text:sub(1, i)
		task.wait(0.12)
	end

	-- =====================
	-- SUBTITLE
	-- =====================
	local subtitle = Instance.new("TextLabel")
	subtitle.Size = UDim2.new(1, 0, 0, 24)
	subtitle.Position = UDim2.fromOffset(0, 78)
	subtitle.BackgroundTransparency = 1
	subtitle.Text = "Murder Mystery 2"
	subtitle.Font = Enum.Font.Gotham
	subtitle.TextScaled = true
	subtitle.TextColor3 = Color3.fromRGB(190, 190, 210)
	subtitle.TextTransparency = 1
	subtitle.Parent = container

	tween(subtitle, TweenInfo.new(0.8, Enum.EasingStyle.Quad), {
		TextTransparency = 0,
		Position = subtitle.Position + UDim2.fromOffset(0, -4)
	})

	-- =====================
	-- PROGRESS BAR
	-- =====================
	local barBg = Instance.new("Frame")
	barBg.Size = UDim2.fromScale(0.7, 0)
	barBg.Size = UDim2.new(0.7, 0, 0, 5)
	barBg.Position = UDim2.fromOffset(container.AbsoluteSize.X / 2, 125)
	barBg.AnchorPoint = Vector2.new(0.5, 0)
	barBg.BackgroundColor3 = Color3.new(1, 1, 1)
	barBg.BackgroundTransparency = 0.85
	barBg.BorderSizePixel = 0
	barBg.Parent = container
	Instance.new("UICorner", barBg).CornerRadius = UDim.new(1, 0)

	local bar = Instance.new("Frame")
	bar.Size = UDim2.fromScale(0, 1)
	bar.BackgroundColor3 = THEME_COLOR
	bar.BorderSizePixel = 0
	bar.Parent = barBg
	Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)

	local pct = Instance.new("TextLabel")
	pct.Size = UDim2.fromOffset(100, 20)
	pct.Position = UDim2.fromOffset(container.AbsoluteSize.X / 2, 140)
	pct.AnchorPoint = Vector2.new(0.5, 0)
	pct.BackgroundTransparency = 1
	pct.Text = "0%"
	pct.Font = Enum.Font.GothamBold
	pct.TextSize = 14
	pct.TextColor3 = Color3.new(1, 1, 1)
	pct.TextTransparency = 1
	pct.Parent = container

	tween(pct, TweenInfo.new(0.5), {TextTransparency = 0})

	-- =====================
	-- ORGANIC LOADING
	-- =====================
	local progress = 0
	while progress < 100 do
		local step = math.random(2, 6)
		progress = math.clamp(progress + step, 0, 100)

		tween(bar, TweenInfo.new(math.random(3, 5) / 10, Enum.EasingStyle.Quint), {
			Size = UDim2.fromScale(progress / 100, 1)
		})

		pct.Text = progress .. "%"
		task.wait(math.random(15, 35) / 100)
	end

	task.wait(0.6)

	-- =====================
	-- OUTRO
	-- =====================
	for _, v in ipairs(gui:GetDescendants()) do
		if v:IsA("TextLabel") then
			tween(v, TweenInfo.new(0.6), {TextTransparency = 1})
		elseif v:IsA("Frame") then
			tween(v, TweenInfo.new(0.6), {BackgroundTransparency = 1})
		end
	end

	task.wait(0.7)
	gui:Destroy()
end

return LoadingScreen
