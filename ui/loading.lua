-- ========================================
-- LOADING SCREEN MODULE
-- ========================================

local TweenService = game:GetService("TweenService")

local LoadingScreen = {}

function LoadingScreen.show(playerGui)
	local loadingGui = Instance.new("ScreenGui")
	loadingGui.Name = "TMMWHubLoading"
	loadingGui.ResetOnSpawn = false
	loadingGui.Parent = playerGui

	local title = Instance.new("TextLabel")
	title.Parent = loadingGui
	title.Size = UDim2.new(0, 400, 0, 80)
	title.Position = UDim2.new(0.5, 0, 0.2, 0)
	title.AnchorPoint = Vector2.new(0.5, 0.5)
	title.BackgroundTransparency = 1
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.TextScaled = true
	title.Font = Enum.Font.GothamBlack
	title.Text = ""
	title.BorderSizePixel = 0
	title.TextXAlignment = Enum.TextXAlignment.Left

	local padding = Instance.new("UIPadding")
	padding.PaddingLeft = UDim.new(0, 20)
	padding.Parent = title

	local loading = Instance.new("TextLabel")
	loading.Parent = loadingGui
	loading.Size = UDim2.new(0, 200, 0, 30)
	loading.Position = UDim2.new(0.5, 0, 0.25, 0)
	loading.AnchorPoint = Vector2.new(0.5, 0.5)
	loading.BackgroundTransparency = 1
	loading.TextColor3 = Color3.fromRGB(255, 255, 255)
	loading.TextScaled = true
	loading.Font = Enum.Font.Gotham
	loading.Text = ""

	-- Animation du titre
	local text = "TMMW HUB"
	for i = 1, #text do
		title.Text = string.sub(text, 1, i)
		task.wait(0.25)
	end

	-- Animation des points de chargement
	local loadingThread = task.spawn(function()
		local dots = {"", ".", "..", "..."}
		local i = 1
		while true do
			loading.Text = "Loading" .. dots[i]
			i = i % #dots + 1
			task.wait(0.4)
		end
	end)

	task.wait(3)
	task.cancel(loadingThread)

	-- Fade out
	local fadeInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local fadeTitle = TweenService:Create(title, fadeInfo, {TextTransparency = 1})
	local fadeLoading = TweenService:Create(loading, fadeInfo, {TextTransparency = 1})

	fadeTitle:Play()
	fadeLoading:Play()
	fadeLoading.Completed:Wait()
	loadingGui:Destroy()
end

return LoadingScreen
