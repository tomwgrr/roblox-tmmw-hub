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
	-- Validation du module
	if not pageModule then
		warn("[ContentManager] Module nil pour la page:", pageName)
		return false
	end
	
	if type(pageModule) ~= "table" then
		warn("[ContentManager] Module invalide (pas une table) pour la page:", pageName)
		return false
	end
	
	if not pageModule.create then
		warn("[ContentManager] Module sans fonction 'create' pour la page:", pageName)
		return false
	end
	
	if type(pageModule.create) ~= "function" then
		warn("[ContentManager] 'create' n'est pas une fonction pour la page:", pageName)
		return false
	end
	
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
	
	-- Initialiser la page avec son module (protégé)
	local success, err = pcall(function()
		pageModule.create(scrollFrame)
	end)
	
	if not success then
		warn("[ContentManager] Erreur lors de la création de la page:", pageName)
		warn("[ContentManager] Erreur détaillée:", tostring(err))
		scrollFrame:Destroy()
		return false
	end
	
	-- Enregistrer la page
	self.pages[pageName] = {
		frame = scrollFrame,
		module = pageModule
	}
	
	print("[ContentManager] ✓ Page enregistrée:", pageName)
	return true
end

function ContentManager:showPage(pageName)
	-- Vérifier si la page existe
	if not self.pages[pageName] then
		warn("[ContentManager] Page introuvable:", pageName)
		warn("[ContentManager] Pages disponibles:", table.concat(self:getAvailablePages(), ", "))
		return false
	end
	
	-- Cacher toutes les pages
	for name, pageData in pairs(self.pages) do
		if pageData and pageData.frame then
			pageData.frame.Visible = false
		end
	end
	
	-- Afficher la page demandée
	if self.pages[pageName] and self.pages[pageName].frame then
		self.pages[pageName].frame.Visible = true
		self.currentPage = pageName
		print("[ContentManager] ✓ Page affichée:", pageName)
		return true
	end
	
	return false
end

function ContentManager:getCurrentPage()
	return self.currentPage
end

function ContentManager:getAvailablePages()
	local pageList = {}
	for name, _ in pairs(self.pages) do
		table.insert(pageList, name)
	end
	table.sort(pageList) -- Tri alphabétique pour plus de lisibilité
	return pageList
end

function ContentManager:pageExists(pageName)
	return self.pages[pageName] ~= nil
end

function ContentManager:getPageCount()
	local count = 0
	for _ in pairs(self.pages) do
		count = count + 1
	end
	return count
end

function ContentManager:removePage(pageName)
	if not self.pages[pageName] then
		warn("[ContentManager] Impossible de supprimer, page introuvable:", pageName)
		return false
	end
	
	-- Détruire le frame
	if self.pages[pageName].frame then
		self.pages[pageName].frame:Destroy()
	end
	
	-- Supprimer de la table
	self.pages[pageName] = nil
	
	-- Si c'était la page active, réinitialiser
	if self.currentPage == pageName then
		self.currentPage = nil
	end
	
	print("[ContentManager] ✓ Page supprimée:", pageName)
	return true
end

return ContentManager
