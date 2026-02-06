-- ========================================
-- GUN GRABBER MODULE
-- Récupère automatiquement le gun lorsqu'il apparaît
-- ========================================

local player = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")

local GunGrabber = {}

local autoGrabEnabled = false
local lastGunGrabTime = 0

function GunGrabber.initialize()
	-- Surveiller l'apparition de nouveaux guns pour l'auto-grab
	game.Workspace.DescendantAdded:Connect(function(obj)
		if autoGrabEnabled and obj.Name == "GunDrop" and obj:IsA("BasePart") then
			local currentTime = tick()
			
			-- Cooldown de 0.5 secondes pour éviter le spam
			if currentTime - lastGunGrabTime >= 0.5 then
				lastGunGrabTime = currentTime
				task.wait(0.1) -- Petit délai pour s'assurer que le gun est bien chargé
				
				GunGrabber.grabOnce()
			end
		end
	end)
end

-- Fonction pour récupérer le gun une fois
function GunGrabber.grabOnce()
	local character = player.Character
	if not character or not character:FindFirstChild("HumanoidRootPart") then 
		return false
	end
	
	local hrp = character.HumanoidRootPart
	local originalPosition = hrp.CFrame -- Sauvegarder la position originale
	
	-- Chercher le gun dans le Workspace
	local gunFound = nil
	
	for _, obj in pairs(game.Workspace:GetChildren()) do
		if obj.Name == "GunDrop" and obj:IsA("BasePart") then
			gunFound = obj
			break
		end
	end
	
	-- Si pas trouvé dans les enfants directs, chercher plus profond
	if not gunFound then
		for _, obj in pairs(game.Workspace:GetDescendants()) do
			if obj.Name == "GunDrop" and obj:IsA("BasePart") then
				gunFound = obj
				break
			end
		end
	end
	
	if gunFound then
		-- TP au gun
		hrp.CFrame = gunFound.CFrame
		task.wait(0.05) -- Petit délai pour que le gun soit ramassé
		
		-- Retourner à la position d'origine
		hrp.CFrame = originalPosition
		
		print("Gun récupéré!")
		return true
	end
	
	return false
end

-- API publique
function GunGrabber.setAutoGrab(enabled)
	autoGrabEnabled = enabled
	print("Auto Grab Gun:", enabled and "ON" or "OFF")
end

return GunGrabber
