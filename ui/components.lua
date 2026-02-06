-- ========================================
-- COMPONENTS MODULE (Reusable UI Elements)
-- ========================================

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local Components = {}

-- ========================================
-- TOGGLE BUTTON
-- ========================================
-- Dans votre fichier Components.lua, ajoutez cette fonction :

function Components.createButton(parent, yOffset, text, callback)
	local button = Instance.new("TextButton")
	button.Parent = parent
	button.Size = UDim2.new(1, -20, 0, 40)
	button.Position = UDim2.new(0, 10, 0, yOffset)
	button.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
	button.BorderSizePixel = 0
	button.Text = text
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.Font = Enum.Font.GothamBold
	button.TextSize = 14
	button.AutoButtonColor = false
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = button
	
	-- Animation hover
	button.MouseEnter:Connect(function()
		button.BackgroundColor3 = Color3.fromRGB(160, 60, 240)
	end)
	
	button.MouseLeave:Connect(function()
		button.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
	end)
	
	-- Callback au clic
	button.MouseButton1Click:Connect(function()
		-- Animation de clic
		button.BackgroundColor3 = Color3.fromRGB(100, 30, 180)
		wait(0.1)
		button.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
		
		if callback then
			callback()
		end
	end)
	
	return button
end
function Components.createToggle(parent, yPos, labelText, callback)
	local container = Instance.new("Frame")
	container.Parent = parent
	container.Size = UDim2.new(1, -20, 0, 40)
	container.Position = UDim2.new(0, 10, 0, yPos)
	container.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	container.BorderSizePixel = 0
	
	local containerCorner = Instance.new("UICorner")
	containerCorner.CornerRadius = UDim.new(0, 6)
	containerCorner.Parent = container
	
	local label = Instance.new("TextLabel")
	label.Parent = container
	label.Size = UDim2.new(0.7, 0, 1, 0)
	label.Position = UDim2.new(0, 10, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = labelText
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.Font = Enum.Font.Gotham
	label.TextSize = 14
	label.TextXAlignment = Enum.TextXAlignment.Left
	
	local toggle = Instance.new("TextButton")
	toggle.Parent = container
	toggle.Size = UDim2.new(0, 60, 0, 25)
	toggle.Position = UDim2.new(1, -70, 0.5, -12.5)
	toggle.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
	toggle.BorderSizePixel = 0
	toggle.Text = "OFF"
	toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
	toggle.Font = Enum.Font.GothamBold
	toggle.TextSize = 12
	
	local toggleCorner = Instance.new("UICorner")
	toggleCorner.CornerRadius = UDim.new(0, 5)
	toggleCorner.Parent = toggle
	
	local isEnabled = false
	
	toggle.MouseButton1Click:Connect(function()
		isEnabled = not isEnabled
		
		if isEnabled then
			toggle.Text = "ON"
			toggle.BackgroundColor3 = Color3.fromRGB(40, 200, 40)
		else
			toggle.Text = "OFF"
			toggle.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
		end
		
		if callback then
			callback(isEnabled)
		end
	end)
	
	toggle.MouseEnter:Connect(function()
		if isEnabled then
			toggle.BackgroundColor3 = Color3.fromRGB(50, 220, 50)
		else
			toggle.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
		end
	end)
	
	toggle.MouseLeave:Connect(function()
		if isEnabled then
			toggle.BackgroundColor3 = Color3.fromRGB(40, 200, 40)
		else
			toggle.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
		end
	end)
	
	return {container = container, toggle = toggle, label = label}
end

-- ========================================
-- SLIDER
-- ========================================

function Components.createSlider(parent, yPos, labelText, minValue, maxValue, defaultValue, callback)
	local container = Instance.new("Frame")
	container.Parent = parent
	container.Size = UDim2.new(1, -20, 0, 60)
	container.Position = UDim2.new(0, 10, 0, yPos)
	container.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	container.BorderSizePixel = 0
	
	local containerCorner = Instance.new("UICorner")
	containerCorner.CornerRadius = UDim.new(0, 6)
	containerCorner.Parent = container
	
	local label = Instance.new("TextLabel")
	label.Parent = container
	label.Size = UDim2.new(0.6, 0, 0, 20)
	label.Position = UDim2.new(0, 10, 0, 5)
	label.BackgroundTransparency = 1
	label.Text = labelText
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.Font = Enum.Font.Gotham
	label.TextSize = 14
	label.TextXAlignment = Enum.TextXAlignment.Left
	
	local valueLabel = Instance.new("TextLabel")
	valueLabel.Parent = container
	valueLabel.Size = UDim2.new(0.3, 0, 0, 20)
	valueLabel.Position = UDim2.new(0.7, 0, 0, 5)
	valueLabel.BackgroundTransparency = 1
	valueLabel.Text = tostring(defaultValue)
	valueLabel.TextColor3 = Color3.fromRGB(138, 43, 226)
	valueLabel.Font = Enum.Font.GothamBold
	valueLabel.TextSize = 14
	valueLabel.TextXAlignment = Enum.TextXAlignment.Right
	
	local sliderBar = Instance.new("Frame")
	sliderBar.Parent = container
	sliderBar.Size = UDim2.new(1, -20, 0, 6)
	sliderBar.Position = UDim2.new(0, 10, 0, 35)
	sliderBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	sliderBar.BorderSizePixel = 0
	
	local sliderBarCorner = Instance.new("UICorner")
	sliderBarCorner.CornerRadius = UDim.new(1, 0)
	sliderBarCorner.Parent = sliderBar
	
	local sliderFill = Instance.new("Frame")
	sliderFill.Parent = sliderBar
	sliderFill.Size = UDim2.new((defaultValue - minValue) / (maxValue - minValue), 0, 1, 0)
	sliderFill.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
	sliderFill.BorderSizePixel = 0
	
	local sliderFillCorner = Instance.new("UICorner")
	sliderFillCorner.CornerRadius = UDim.new(1, 0)
	sliderFillCorner.Parent = sliderFill
	
	local sliderButton = Instance.new("TextButton")
	sliderButton.Parent = sliderBar
	sliderButton.Size = UDim2.new(0, 16, 0, 16)
	sliderButton.Position = UDim2.new((defaultValue - minValue) / (maxValue - minValue), -8, 0.5, -8)
	sliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	sliderButton.BorderSizePixel = 0
	sliderButton.Text = ""
	
	local buttonCorner = Instance.new("UICorner")
	buttonCorner.CornerRadius = UDim.new(1, 0)
	buttonCorner.Parent = sliderButton
	
	local dragging = false
	
	sliderButton.MouseButton1Down:Connect(function()
		dragging = true
	end)
	
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)
	
	UserInputService.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local mousePos = UserInputService:GetMouseLocation().X
			local sliderPos = sliderBar.AbsolutePosition.X
			local sliderSize = sliderBar.AbsoluteSize.X
			
			local relativePos = math.clamp((mousePos - sliderPos) / sliderSize, 0, 1)
			local value = math.floor(minValue + (maxValue - minValue) * relativePos)
			
			sliderFill.Size = UDim2.new(relativePos, 0, 1, 0)
			sliderButton.Position = UDim2.new(relativePos, -8, 0.5, -8)
			valueLabel.Text = tostring(value)
			
			if callback then
				callback(value)
			end
		end
	end)
	
	return {container = container, sliderBar = sliderBar, valueLabel = valueLabel}
end

-- ========================================
-- BUTTON
-- ========================================

function Components.createButton(parent, yPos, labelText, buttonText, callback)
	local container = Instance.new("Frame")
	container.Parent = parent
	container.Size = UDim2.new(1, -20, 0, 40)
	container.Position = UDim2.new(0, 10, 0, yPos)
	container.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	container.BorderSizePixel = 0
	
	local containerCorner = Instance.new("UICorner")
	containerCorner.CornerRadius = UDim.new(0, 6)
	containerCorner.Parent = container
	
	local label = Instance.new("TextLabel")
	label.Parent = container
	label.Size = UDim2.new(0.6, 0, 1, 0)
	label.Position = UDim2.new(0, 10, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = labelText
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.Font = Enum.Font.Gotham
	label.TextSize = 14
	label.TextXAlignment = Enum.TextXAlignment.Left
	
	local button = Instance.new("TextButton")
	button.Parent = container
	button.Size = UDim2.new(0, 80, 0, 25)
	button.Position = UDim2.new(1, -90, 0.5, -12.5)
	button.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
	button.BorderSizePixel = 0
	button.Text = buttonText
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.Font = Enum.Font.GothamBold
	button.TextSize = 12
	
	local buttonCorner = Instance.new("UICorner")
	buttonCorner.CornerRadius = UDim.new(0, 5)
	buttonCorner.Parent = button
	
	button.MouseButton1Click:Connect(function()
		if callback then
			callback(button)
		end
	end)
	
	button.MouseEnter:Connect(function()
		button.BackgroundColor3 = Color3.fromRGB(158, 63, 246)
	end)
	
	button.MouseLeave:Connect(function()
		button.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
	end)
	
	return {container = container, button = button, label = label}
end

-- ========================================
-- SECTION TITLE
-- ========================================

function Components.createSectionTitle(parent, yPos, titleText)
	local title = Instance.new("TextLabel")
	title.Parent = parent
	title.Size = UDim2.new(1, -20, 0, 30)
	title.Position = UDim2.new(0, 10, 0, yPos)
	title.BackgroundTransparency = 1
	title.Text = titleText
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.Font = Enum.Font.GothamBold
	title.TextSize = 18
	title.TextXAlignment = Enum.TextXAlignment.Left
	
	return title
end

function Components.createSeparator(parent, yPos)
	local separator = Instance.new("Frame")
	separator.Parent = parent
	separator.Size = UDim2.new(1, -20, 0, 2)
	separator.Position = UDim2.new(0, 10, 0, yPos)
	separator.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
	separator.BorderSizePixel = 0
	
	return separator
end

return Components
