-- ========================================
-- HEADER MODULE (Drag, Minimize, Close)
-- ========================================

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Header = {}

function Header.create(mainFrame, gui)
	-- HEADER
	local header = Instance.new("Frame")
	header.Parent = mainFrame
	header.Size = UDim2.new(1, 0, 0, 30)
	header.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	header.BorderSizePixel = 0
	header.ClipsDescendants = false

	local headerCorner = Instance.new("UICorner")
	headerCorner.CornerRadius = UDim.new(0, 8)
	headerCorner.Parent = header

	local headerText = Instance.new("TextLabel")
	headerText.Parent = header
	headerText.Size = UDim2.new(1, -80, 1, 0)
	headerText.Position = UDim2.new(0, 10, 0, 0)
	headerText.BackgroundTransparency = 1
	headerText.Text = "TMMW Hub - MM2"
	headerText.TextColor3 = Color3.fromRGB(255, 255, 255)
	headerText.TextSize = 14
	headerText.Font = Enum.Font.GothamBold
	headerText.TextXAlignment = Enum.TextXAlignment.Left

	-- BOUTON RÉDUIRE
	local minimizeButton = Instance.new("TextButton")
	minimizeButton.Parent = header
	minimizeButton.Size = UDim2.new(0, 25, 0, 25)
	minimizeButton.Position = UDim2.new(1, -53, 0, 2.5)
	minimizeButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	minimizeButton.BorderSizePixel = 0
	minimizeButton.Text = "-"
	minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	minimizeButton.Font = Enum.Font.GothamBold
	minimizeButton.TextSize = 16

	local minCorner = Instance.new("UICorner")
	minCorner.CornerRadius = UDim.new(0, 4)
	minCorner.Parent = minimizeButton

	-- BOUTON FERMER
	local closeButton = Instance.new("TextButton")
	closeButton.Parent = header
	closeButton.Size = UDim2.new(0, 25, 0, 25)
	closeButton.Position = UDim2.new(1, -27, 0, 2.5)
	closeButton.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
	closeButton.BorderSizePixel = 0
	closeButton.Text = "X"
	closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	closeButton.Font = Enum.Font.GothamBold
	closeButton.TextSize = 14

	local closeCorner = Instance.new("UICorner")
	closeCorner.CornerRadius = UDim.new(0, 4)
	closeCorner.Parent = closeButton

	-- BORDURE VIOLETTE
	local headerBorder = Instance.new("Frame")
	headerBorder.Parent = mainFrame
	headerBorder.Size = UDim2.new(1, 0, 0, 2)
	headerBorder.Position = UDim2.new(0, 0, 0, 30)
	headerBorder.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
	headerBorder.BorderSizePixel = 0
	headerBorder.ZIndex = 10

	-- LOGIQUE MINIMISATION
	local isMinimized = false
	local originalSize = mainFrame.Size

	minimizeButton.MouseButton1Click:Connect(function()
		if not isMinimized then
			isMinimized = true
			originalSize = mainFrame.Size
			
			local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
			local tween = TweenService:Create(mainFrame, tweenInfo, {
				Size = UDim2.new(originalSize.X.Scale, originalSize.X.Offset, 0, 30)
			})
			tween:Play()
			minimizeButton.Text = "+"
		else
			isMinimized = false
			local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
			local tween = TweenService:Create(mainFrame, tweenInfo, {Size = originalSize})
			tween:Play()
			minimizeButton.Text = "-"
		end
	end)

	-- LOGIQUE FERMETURE
	closeButton.MouseButton1Click:Connect(function()
		local fadeInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		local fadeTween = TweenService:Create(mainFrame, fadeInfo, {BackgroundTransparency = 1})
		
		for _, child in pairs(mainFrame:GetDescendants()) do
			if child:IsA("TextLabel") or child:IsA("TextButton") then
				TweenService:Create(child, fadeInfo, {TextTransparency = 1}):Play()
			elseif child:IsA("Frame") and child ~= mainFrame then
				TweenService:Create(child, fadeInfo, {BackgroundTransparency = 1}):Play()
			end
		end
		
		fadeTween:Play()
		fadeTween.Completed:Wait()
		gui:Destroy()
	end)

	-- EFFETS HOVER
	minimizeButton.MouseEnter:Connect(function()
		minimizeButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	end)

	minimizeButton.MouseLeave:Connect(function()
		minimizeButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	end)

	closeButton.MouseEnter:Connect(function()
		closeButton.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
	end)

	closeButton.MouseLeave:Connect(function()
		closeButton.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
	end)

	-- DRAG GUI
	Header.setupDrag(header, mainFrame)
	
	return header
end

function Header.setupDrag(header, mainFrame)
	local dragging = false
	local dragInput, mousePos, framePos

	local function update(input)
		local delta = input.Position - mousePos
		mainFrame.Position = UDim2.new(
			framePos.X.Scale,
			framePos.X.Offset + delta.X,
			framePos.Y.Scale,
			framePos.Y.Offset + delta.Y
		)
	end

	header.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			mousePos = input.Position
			framePos = mainFrame.Position
			
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	header.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			update(input)
		end
	end)
end

return Header
