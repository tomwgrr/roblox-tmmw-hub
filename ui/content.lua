-- ========================================
-- CONTENT MANAGER (Page System)
-- ========================================

local ContentManager = {}
ContentManager.__index = ContentManager

function ContentManager.new(mainFrame)
	local self = setmetatable({}, ContentManager)
	
	-- Zone de contenu principale
	self.mainContentFrame = Instance.new("Frame")
	self.mainContentFrame.Parent = mainFrame
	self.mainContentFrame.Size = UDim2.new(1, -100, 1, -30)
	self.mainContentFrame.Position = UDim2.new(0, 100, 0, 30)
	self.mainContentFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	self.mainContentFrame.BorderSizePixel = 0
	
	self.pages = {}
	self.currentPage = nil
	
	return self
end

function ContentManager:registerPage(pageName, pageModule)
	-- Créer le ScrollingFrame pour la page
	local scrollFrame = Instance.new("ScrollingFrame")
	scrollFrame.Name = pageName .. "Content"
	scrollFrame.Parent = self.mainContentFrame
	scrollFrame.Size = UDim2.new(1, 0, 1, 0)
	scrollFrame.Position = UDim2.new(0, 0, 0, 0)
	scrollFrame.BackgroundTransparency = 1
	scrollFrame.BorderSizePixel = 0
	scrollFrame.CanvasSize = UDim2.new(0, 0, 3, 0)
	scrollFrame.ScrollBarThickness = 6
	scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 60)
	scrollFrame.Visible = false
	
	-- Initialiser la page avec son module
	if pageModule and pageModule.create then
		pageModule.create(scrollFrame)
	end
	
	self.pages[pageName] = {
		frame = scrollFrame,
		module = pageModule
	}
end

function ContentManager:showPage(pageName)
	-- Cacher toutes les pages
	for name, pageData in pairs(self.pages) do
		pageData.frame.Visible = false
	end
	
	-- Afficher la page demandée
	if self.pages[pageName] then
		self.pages[pageName].frame.Visible = true
		self.currentPage = pageName
	end
end

function ContentManager:getCurrentPage()
	return self.currentPage
end

return ContentManager
