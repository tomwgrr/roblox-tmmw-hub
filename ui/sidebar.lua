-- ========================================
-- SIDEBAR MODULE (Navigation)
-- ========================================

local Sidebar = {}

local categories = {
	{name = "Home", icon = ""},
	{name = "MM2", icon = ""},
	{name = "Universal", icon = ""},
	{name = "Scripts", icon = ""},
	{name = "Premium", icon = ""},
	{name = "Settings", icon = ""}
}

function Sidebar.create(mainFrame)
	local categoryFrame = Instance.new("Frame")
	categoryFrame.Parent = mainFrame
	categoryFrame.Size = UDim2.new(0, 100, 1, -30)
	categoryFrame.Position = UDim2.new(0, 0, 0, 30)
	categoryFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
	categoryFrame.BorderSizePixel = 0

	local buttons = {}

	for index, categoryData in ipairs(categories) do
		local button = Sidebar.createCategoryButton(categoryFrame, categoryData, index)
		buttons[categoryData.name] = button
	end

	return {
		frame = categoryFrame,
		buttons = buttons,
		selectedCategory = nil
	}
end

function Sidebar.createCategoryButton(categoryFrame, categoryData, index)
	local button = Instance.new("TextButton")
	button.Parent = categoryFrame
	button.Size = UDim2.new(1, 0, 0, 35)
	button.Position = UDim2.new(0, 0, 0, (index - 1) * 35)
	button.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
	button.BorderSizePixel = 0
	button.Text = "  " .. categoryData.icon .. " " .. categoryData.name
	button.TextColor3 = Color3.fromRGB(180, 180, 180)
	button.Font = Enum.Font.Gotham
	button.TextSize = 12
	button.TextXAlignment = Enum.TextXAlignment.Left
	
	button.MouseEnter:Connect(function()
		if not button:GetAttribute("Selected") then
			button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
		end
	end)
	
	button.MouseLeave:Connect(function()
		if not button:GetAttribute("Selected") then
			button.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
		end
	end)
	
	return button
end

function Sidebar.setupNavigation(sidebar, contentManager)
	for categoryName, button in pairs(sidebar.buttons) do
		button.MouseButton1Click:Connect(function()
			Sidebar.selectCategory(sidebar, categoryName, contentManager)
		end)
	end
	
	-- Sélectionner Home par défaut
	Sidebar.selectCategory(sidebar, "Home", contentManager)
end

function Sidebar.selectCategory(sidebar, categoryName, contentManager)
	-- Désélectionner tous les boutons
	for _, btn in pairs(sidebar.buttons) do
		btn:SetAttribute("Selected", false)
		btn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
		btn.TextColor3 = Color3.fromRGB(180, 180, 180)
	end
	
	-- Sélectionner le bouton cliqué
	local selectedButton = sidebar.buttons[categoryName]
	if selectedButton then
		selectedButton:SetAttribute("Selected", true)
		selectedButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
		selectedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	end
	
	sidebar.selectedCategory = categoryName
	
	-- Changer la page
	if contentManager then
		contentManager:showPage(categoryName)
	end
end

return Sidebar
