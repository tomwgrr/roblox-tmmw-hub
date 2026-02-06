-- ========================================
-- UNIVERSAL FEATURES MODULE - EXTENDED
-- Fonctionnalités universelles (marche dans tous les jeux)
-- ========================================

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

local UniversalFeatures = {}

-- Variables d'état
local flyEnabled = false
local flySpeed = 50
local flyConnection = nil

local noclipEnabled = false
local noclipConnection = nil

local infiniteJumpEnabled = false
local infiniteJumpConnection = nil

local xrayEnabled = false
local originalTransparencies = {}

local fullbrightEnabled = false
local originalAmbient, originalOutdoorAmbient, originalBrightness

local removeFogEnabled = false
local originalFogEnd

local antiAFKEnabled = false
local antiAFKConnection = nil

local spinbotEnabled = false
local spinbotConnection = nil
local spinbotSpeed = 20

local platformEnabled = false
local platformPart = nil

local autoFarmConnection = nil

local gravityEnabled = true
local originalGravity = workspace.Gravity

local clickTPEnabled = false
local clickTPConnection = nil

local loopKillTarget = nil
local loopKillConnection = nil

local orbitEnabled = false
local orbitConnection = nil
local orbitRadius = 10
local orbitSpeed = 2

local vibrationEnabled = false
local vibrationConnection = nil

local flingEnabled = false
local flingConnection = nil

local chatSpamEnabled = false
local chatSpamConnection = nil
local chatSpamMessages = {"Hello!", "GG", "Nice game!"}

local rapidPunchEnabled = false
local rapidPunchConnection = nil

local autoRespawnEnabled = false
local autoRespawnConnection = nil

local cameraShakeEnabled = false
local cameraShakeConnection = nil

local headlessEnabled = false
local originalHeadTransparency = 1

local autoJumpEnabled = false
local autoJumpConnection = nil

local freezeCharEnabled = false

local carpetEnabled = false
local carpetPart = nil

local autoBlockEnabled = false
local autoBlockConnection = nil

local lagSwitchEnabled = false
local lagSwitchValue = nil

local nametagSpoofEnabled = false
local originalDisplayName = ""

function UniversalFeatures.initialize()
	-- Rien à initialiser pour l'instant
end

-- ===== FLY =====
function UniversalFeatures.setFly(enabled)
	flyEnabled = enabled
	
	if enabled then
		local character = player.Character
		if not character then return end
		
		local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
		if not humanoidRootPart then return end
		
		local bodyVelocity = Instance.new("BodyVelocity")
		bodyVelocity.Name = "FlyVelocity"
		bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
		bodyVelocity.Velocity = Vector3.new(0, 0, 0)
		bodyVelocity.Parent = humanoidRootPart
		
		flyConnection = RunService.RenderStepped:Connect(function()
			if not flyEnabled or not character or not humanoidRootPart then
				if bodyVelocity then bodyVelocity:Destroy() end
				if flyConnection then flyConnection:Disconnect() end
				return
			end
			
			local camera = workspace.CurrentCamera
			local direction = Vector3.new(0, 0, 0)
			
			if UserInputService:IsKeyDown(Enum.KeyCode.W) then
				direction = direction + camera.CFrame.LookVector
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.S) then
				direction = direction - camera.CFrame.LookVector
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.A) then
				direction = direction - camera.CFrame.RightVector
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.D) then
				direction = direction + camera.CFrame.RightVector
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
				direction = direction + Vector3.new(0, 1, 0)
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
				direction = direction - Vector3.new(0, 1, 0)
			end
			
			bodyVelocity.Velocity = direction.Unit * flySpeed
		end)
	else
		local character = player.Character
		if character then
			local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
			if humanoidRootPart then
				local bodyVelocity = humanoidRootPart:FindFirstChild("FlyVelocity")
				if bodyVelocity then
					bodyVelocity:Destroy()
				end
			end
		end
		
		if flyConnection then
			flyConnection:Disconnect()
		end
	end
end

function UniversalFeatures.setFlySpeed(speed)
	flySpeed = speed
end

-- ===== NOCLIP =====
function UniversalFeatures.setNoclip(enabled)
	noclipEnabled = enabled
	
	if enabled then
		noclipConnection = RunService.Stepped:Connect(function()
			if not noclipEnabled then
				if noclipConnection then noclipConnection:Disconnect() end
				return
			end
			
			local character = player.Character
			if character then
				for _, part in pairs(character:GetDescendants()) do
					if part:IsA("BasePart") then
						part.CanCollide = false
					end
				end
			end
		end)
	else
		if noclipConnection then
			noclipConnection:Disconnect()
		end
		
		local character = player.Character
		if character then
			for _, part in pairs(character:GetDescendants()) do
				if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
					part.CanCollide = true
				end
			end
		end
	end
end

-- ===== WALKSPEED =====
function UniversalFeatures.setWalkSpeed(speed)
	local character = player.Character
	if character then
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid.WalkSpeed = speed
		end
	end
end

-- ===== JUMPPOWER =====
function UniversalFeatures.setJumpPower(power)
	local character = player.Character
	if character then
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid.JumpPower = power
			humanoid.UseJumpPower = true
		end
	end
end

-- ===== INFINITE JUMP =====
function UniversalFeatures.setInfiniteJump(enabled)
	infiniteJumpEnabled = enabled
	
	if enabled then
		infiniteJumpConnection = UserInputService.JumpRequest:Connect(function()
			if infiniteJumpEnabled then
				local character = player.Character
				if character then
					local humanoid = character:FindFirstChildOfClass("Humanoid")
					if humanoid then
						humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
					end
				end
			end
		end)
	else
		if infiniteJumpConnection then
			infiniteJumpConnection:Disconnect()
		end
	end
end

-- ===== X-RAY =====
function UniversalFeatures.setXRay(enabled)
	xrayEnabled = enabled
	
	if enabled then
		for _, obj in pairs(game.Workspace:GetDescendants()) do
			if obj:IsA("BasePart") then
				local isPlayer = false
				local parent = obj.Parent
				while parent do
					if parent:IsA("Model") and game.Players:GetPlayerFromCharacter(parent) then
						isPlayer = true
						break
					end
					parent = parent.Parent
				end
				
				if not isPlayer then
					originalTransparencies[obj] = obj.Transparency
					obj.Transparency = 0.5
				end
			end
		end
	else
		for obj, transparency in pairs(originalTransparencies) do
			if obj and obj.Parent then
				obj.Transparency = transparency
			end
		end
		originalTransparencies = {}
	end
end

-- ===== FULLBRIGHT =====
function UniversalFeatures.setFullbright(enabled)
	fullbrightEnabled = enabled
	local lighting = game:GetService("Lighting")
	
	if enabled then
		originalAmbient = lighting.Ambient
		originalOutdoorAmbient = lighting.OutdoorAmbient
		originalBrightness = lighting.Brightness
		
		lighting.Ambient = Color3.fromRGB(255, 255, 255)
		lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
		lighting.Brightness = 2
	else
		lighting.Ambient = originalAmbient or Color3.fromRGB(0, 0, 0)
		lighting.OutdoorAmbient = originalOutdoorAmbient or Color3.fromRGB(0, 0, 0)
		lighting.Brightness = originalBrightness or 1
	end
end

-- ===== REMOVE FOG =====
function UniversalFeatures.setRemoveFog(enabled)
	removeFogEnabled = enabled
	local lighting = game:GetService("Lighting")
	
	if enabled then
		originalFogEnd = lighting.FogEnd
		lighting.FogEnd = 100000
	else
		lighting.FogEnd = originalFogEnd or 100000
	end
end

-- ===== FOV =====
function UniversalFeatures.setFOV(fov)
	local camera = workspace.CurrentCamera
	if camera then
		camera.FieldOfView = fov
	end
end

-- ===== ESP DISTANCE =====
function UniversalFeatures.setESPDistance(distance)
	_G.ESPDistance = distance
end

-- ===== TELEPORT TO PLAYER =====
function UniversalFeatures.teleportToPlayer(targetPlayer)
	if targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
		local character = player.Character
		if character and character:FindFirstChild("HumanoidRootPart") then
			character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame
		end
	end
end

-- ===== REMOVE DEATH BARRIERS =====
function UniversalFeatures.setRemoveDeathBarriers(enabled)
	if enabled then
		for _, obj in pairs(game.Workspace:GetDescendants()) do
			if obj:IsA("Part") and (obj.Name:lower():find("kill") or obj.Name:lower():find("death")) then
				obj:Destroy()
			end
		end
	end
end

-- ===== ANTI-AFK =====
function UniversalFeatures.setAntiAFK(enabled)
	antiAFKEnabled = enabled
	
	if enabled then
		local vu = game:GetService("VirtualUser")
		antiAFKConnection = player.Idled:Connect(function()
			if antiAFKEnabled then
				vu:CaptureController()
				vu:ClickButton2(Vector2.new())
			end
		end)
	else
		if antiAFKConnection then
			antiAFKConnection:Disconnect()
		end
	end
end

-- ===== REMOVE TEXTURES =====
function UniversalFeatures.setRemoveTextures(enabled)
	if enabled then
		for _, obj in pairs(game.Workspace:GetDescendants()) do
			if obj:IsA("Decal") or obj:IsA("Texture") then
				obj.Transparency = 1
			end
			if obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
				obj.Enabled = false
			end
		end
	else
		for _, obj in pairs(game.Workspace:GetDescendants()) do
			if obj:IsA("Decal") or obj:IsA("Texture") then
				obj.Transparency = 0
			end
			if obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
				obj.Enabled = true
			end
		end
	end
end

-- ===== SPINBOT =====
function UniversalFeatures.setSpinbot(enabled)
	spinbotEnabled = enabled
	
	if enabled then
		spinbotConnection = RunService.RenderStepped:Connect(function()
			if not spinbotEnabled then
				if spinbotConnection then spinbotConnection:Disconnect() end
				return
			end
			
			local character = player.Character
			if character and character:FindFirstChild("HumanoidRootPart") then
				character.HumanoidRootPart.CFrame = character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(spinbotSpeed), 0)
			end
		end)
	else
		if spinbotConnection then
			spinbotConnection:Disconnect()
		end
	end
end

function UniversalFeatures.setSpinbotSpeed(speed)
	spinbotSpeed = speed
end

-- ===== PLATFORM =====
function UniversalFeatures.setPlatform(enabled)
	platformEnabled = enabled
	
	if enabled then
		local character = player.Character
		if character and character:FindFirstChild("HumanoidRootPart") then
			platformPart = Instance.new("Part")
			platformPart.Size = Vector3.new(10, 1, 10)
			platformPart.Anchored = true
			platformPart.Transparency = 0.5
			platformPart.Material = Enum.Material.Neon
			platformPart.BrickColor = BrickColor.new("Bright blue")
			platformPart.CanCollide = true
			platformPart.Parent = workspace
			
			RunService.RenderStepped:Connect(function()
				if platformEnabled and character and character:FindFirstChild("HumanoidRootPart") then
					platformPart.CFrame = character.HumanoidRootPart.CFrame * CFrame.new(0, -4, 0)
				end
			end)
		end
	else
		if platformPart then
			platformPart:Destroy()
			platformPart = nil
		end
	end
end

-- ===== GRAVITY =====
function UniversalFeatures.setGravity(value)
	workspace.Gravity = value
end

function UniversalFeatures.toggleGravity()
	gravityEnabled = not gravityEnabled
	if gravityEnabled then
		workspace.Gravity = originalGravity
	else
		workspace.Gravity = 0
	end
end

-- ===== CLICK TP =====
function UniversalFeatures.setClickTP(enabled)
	clickTPEnabled = enabled
	
	if enabled then
		local mouse = player:GetMouse()
		clickTPConnection = mouse.Button1Down:Connect(function()
			if clickTPEnabled and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
				local character = player.Character
				if character and character:FindFirstChild("HumanoidRootPart") then
					character.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.Position)
				end
			end
		end)
	else
		if clickTPConnection then
			clickTPConnection:Disconnect()
		end
	end
end

-- ===== FLING PLAYER (HARD) =====
function UniversalFeatures.flingPlayer(targetPlayer)
	local character = player.Character
	local targetCharacter = targetPlayer.Character
	
	if character and targetCharacter then
		local hrp = character:FindFirstChild("HumanoidRootPart")
		local targetHrp = targetCharacter:FindFirstChild("HumanoidRootPart")
		
		if hrp and targetHrp then
			-- Sauvegarde position
			local originalCFrame = hrp.CFrame
			
			-- Désactive CanCollide
			for _, part in pairs(character:GetDescendants()) do
				if part:IsA("BasePart") then
					part.CanCollide = false
				end
			end
			
			-- Créé un BodyVelocity pour le fling
			local bodyVelocity = Instance.new("BodyVelocity")
			bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
			bodyVelocity.Velocity = Vector3.new(0, 0, 0)
			bodyVelocity.Parent = hrp
			
			-- Animation de rotation rapide
			for i = 1, 200 do
				hrp.CFrame = targetHrp.CFrame
				hrp.Velocity = Vector3.new(math.random(-100, 100), math.random(-100, 100), math.random(-100, 100))
				RunService.RenderStepped:Wait()
			end
			
			-- Nettoyage
			bodyVelocity:Destroy()
			hrp.CFrame = originalCFrame
			
			for _, part in pairs(character:GetDescendants()) do
				if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
					part.CanCollide = true
				end
			end
		end
	end
end

-- ===== AUTO FLING =====
function UniversalFeatures.setAutoFling(enabled, targetPlayer)
	if enabled and targetPlayer then
		flingConnection = RunService.Heartbeat:Connect(function()
			UniversalFeatures.flingPlayer(targetPlayer)
			wait(0.1)
		end)
	else
		if flingConnection then
			flingConnection:Disconnect()
		end
	end
end

-- ===== BRING PLAYER =====
function UniversalFeatures.bringPlayer(targetPlayer)
	if targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
		local character = player.Character
		if character and character:FindFirstChild("HumanoidRootPart") then
			local targetHrp = targetPlayer.Character.HumanoidRootPart
			local originalCFrame = targetHrp.CFrame
			
			-- Téléporte le joueur cible vers nous
			targetHrp.CFrame = character.HumanoidRootPart.CFrame
		end
	end
end

-- ===== ORBIT PLAYER =====
function UniversalFeatures.setOrbitPlayer(enabled, targetPlayer)
	orbitEnabled = enabled
	
	if enabled and targetPlayer then
		local angle = 0
		orbitConnection = RunService.RenderStepped:Connect(function()
			if not orbitEnabled or not targetPlayer.Character then
				if orbitConnection then orbitConnection:Disconnect() end
				return
			end
			
			local character = player.Character
			local targetCharacter = targetPlayer.Character
			
			if character and character:FindFirstChild("HumanoidRootPart") and targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart") then
				angle = angle + orbitSpeed
				local x = math.cos(math.rad(angle)) * orbitRadius
				local z = math.sin(math.rad(angle)) * orbitRadius
				
				character.HumanoidRootPart.CFrame = targetCharacter.HumanoidRootPart.CFrame * CFrame.new(x, 0, z)
			end
		end)
	else
		if orbitConnection then
			orbitConnection:Disconnect()
		end
	end
end

function UniversalFeatures.setOrbitRadius(radius)
	orbitRadius = radius
end

function UniversalFeatures.setOrbitSpeed(speed)
	orbitSpeed = speed
end

-- ===== VIBRATION MODE (ANTI-KICK TROLL) =====
function UniversalFeatures.setVibration(enabled)
	vibrationEnabled = enabled
	
	if enabled then
		vibrationConnection = RunService.RenderStepped:Connect(function()
			if not vibrationEnabled then
				if vibrationConnection then vibrationConnection:Disconnect() end
				return
			end
			
			local character = player.Character
			if character and character:FindFirstChild("HumanoidRootPart") then
				local hrp = character.HumanoidRootPart
				hrp.CFrame = hrp.CFrame * CFrame.new(
					math.random(-5, 5) / 10,
					math.random(-5, 5) / 10,
					math.random(-5, 5) / 10
				)
			end
		end)
	else
		if vibrationConnection then
			vibrationConnection:Disconnect()
		end
	end
end

-- ===== LOOP KILL PLAYER =====
function UniversalFeatures.setLoopKill(enabled, targetPlayer)
	loopKillTarget = targetPlayer
	
	if enabled and targetPlayer then
		loopKillConnection = RunService.Heartbeat:Connect(function()
			if loopKillTarget and loopKillTarget.Character then
				local targetCharacter = loopKillTarget.Character
				local targetHumanoid = targetCharacter:FindFirstChildOfClass("Humanoid")
				
				if targetHumanoid then
					targetHumanoid.Health = 0
				end
			end
		end)
	else
		if loopKillConnection then
			loopKillConnection:Disconnect()
			loopKillTarget = nil
		end
	end
end

-- ===== SPAM CHAT =====
function UniversalFeatures.setChatSpam(enabled, messages)
	chatSpamEnabled = enabled
	if messages and #messages > 0 then
		chatSpamMessages = messages
	end
	
	if enabled then
		chatSpamConnection = RunService.Heartbeat:Connect(function()
			if chatSpamEnabled then
				local message = chatSpamMessages[math.random(1, #chatSpamMessages)]
				game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(message, "All")
				wait(1) -- Anti-spam délai
			end
		end)
	else
		if chatSpamConnection then
			chatSpamConnection:Disconnect()
		end
	end
end

-- ===== RAPID PUNCH =====
function UniversalFeatures.setRapidPunch(enabled)
	rapidPunchEnabled = enabled
	
	if enabled then
		rapidPunchConnection = RunService.Heartbeat:Connect(function()
			if rapidPunchEnabled then
				local character = player.Character
				if character then
					local tool = character:FindFirstChildOfClass("Tool")
					if tool then
						tool:Activate()
					end
				end
			end
		end)
	else
		if rapidPunchConnection then
			rapidPunchConnection:Disconnect()
		end
	end
end

-- ===== AUTO RESPAWN =====
function UniversalFeatures.setAutoRespawn(enabled)
	autoRespawnEnabled = enabled
	
	if enabled then
		autoRespawnConnection = player.CharacterAdded:Connect(function(character)
			if autoRespawnEnabled then
				local humanoid = character:WaitForChild("Humanoid")
				humanoid.Died:Connect(function()
					wait(0.1)
					player:LoadCharacter()
				end)
			end
		end)
	else
		if autoRespawnConnection then
			autoRespawnConnection:Disconnect()
		end
	end
end

-- ===== CAMERA SHAKE (TROLL) =====
function UniversalFeatures.setCameraShake(enabled)
	cameraShakeEnabled = enabled
	
	if enabled then
		cameraShakeConnection = RunService.RenderStepped:Connect(function()
			if cameraShakeEnabled then
				local camera = workspace.CurrentCamera
				camera.CFrame = camera.CFrame * CFrame.Angles(
					math.rad(math.random(-5, 5)),
					math.rad(math.random(-5, 5)),
					math.rad(math.random(-5, 5))
				)
			end
		end)
	else
		if cameraShakeConnection then
			cameraShakeConnection:Disconnect()
		end
	end
end

-- ===== HEADLESS =====
function UniversalFeatures.setHeadless(enabled)
	headlessEnabled = enabled
	local character = player.Character
	
	if character then
		local head = character:FindFirstChild("Head")
		if head then
			if enabled then
				originalHeadTransparency = head.Transparency
				head.Transparency = 1
				
				local face = head:FindFirstChildOfClass("Decal")
				if face then
					face.Transparency = 1
				end
			else
				head.Transparency = originalHeadTransparency
				
				local face = head:FindFirstChildOfClass("Decal")
				if face then
					face.Transparency = 0
				end
			end
		end
	end
end

-- ===== AUTO JUMP =====
function UniversalFeatures.setAutoJump(enabled)
	autoJumpEnabled = enabled
	
	if enabled then
		autoJumpConnection = RunService.Heartbeat:Connect(function()
			if autoJumpEnabled then
				local character = player.Character
				if character then
					local humanoid = character:FindFirstChildOfClass("Humanoid")
					if humanoid then
						humanoid.Jump = true
					end
				end
			end
		end)
	else
		if autoJumpConnection then
			autoJumpConnection:Disconnect()
		end
	end
end

-- ===== FREEZE CHARACTER =====
function UniversalFeatures.setFreezeCharacter(enabled)
	freezeCharEnabled = enabled
	local character = player.Character
	
	if character then
		for _, part in pairs(character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.Anchored = enabled
			end
		end
	end
end

-- ===== CARPET RIDE =====
function UniversalFeatures.setCarpet(enabled)
	carpetEnabled = enabled
	
	if enabled then
		local character = player.Character
		if character and character:FindFirstChild("HumanoidRootPart") then
			carpetPart = Instance.new("Part")
			carpetPart.Size = Vector3.new(6, 0.5, 8)
			carpetPart.Anchored = true
			carpetPart.Transparency = 0.3
			carpetPart.Material = Enum.Material.Fabric
			carpetPart.BrickColor = BrickColor.new("Bright red")
			carpetPart.CanCollide = false
			carpetPart.Parent = workspace
			
			RunService.RenderStepped:Connect(function()
				if carpetEnabled and character and character:FindFirstChild("HumanoidRootPart") then
					carpetPart.CFrame = character.HumanoidRootPart.CFrame * CFrame.new(0, -3, 0) * CFrame.Angles(0, 0, math.rad(5))
				end
			end)
		end
	else
		if carpetPart then
			carpetPart:Destroy()
			carpetPart = nil
		end
	end
end

-- ===== INVISIBLE CHARACTER =====
function UniversalFeatures.setInvisible(enabled)
	local character = player.Character
	if character then
		for _, part in pairs(character:GetDescendants()) do
			if part:IsA("BasePart") or part:IsA("Decal") then
				if enabled then
					part.Transparency = 1
				else
					part.Transparency = 0
				end
			end
		end
	end
end

-- ===== REMOVE ACCESSORIES =====
function UniversalFeatures.removeAccessories()
	local character = player.Character
	if character then
		for _, accessory in pairs(character:GetChildren()) do
			if accessory:IsA("Accessory") then
				accessory:Destroy()
			end
		end
	end
end

-- ===== SPAM JUMP (ANTI-KICK TRIGGER) =====
function UniversalFeatures.spamJumpTrigger()
	spawn(function()
		for i = 1, 1000 do
			local character = player.Character
			if character then
				local humanoid = character:FindFirstChildOfClass("Humanoid")
				if humanoid then
					humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
				end
			end
			wait(0.01)
		end
	end)
end

-- ===== LAG SWITCH (CLIENT FREEZE) =====
function UniversalFeatures.setLagSwitch(enabled)
	lagSwitchEnabled = enabled
	
	if enabled then
		lagSwitchValue = true
		spawn(function()
			while lagSwitchEnabled do
				wait(9e9) -- Freeze le client
			end
		end)
	else
		lagSwitchValue = false
	end
end

-- ===== WALK ON WALLS =====
function UniversalFeatures.setWalkOnWalls(enabled)
	local character = player.Character
	if character then
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			if enabled then
				humanoid.PlatformStand = true
			else
				humanoid.PlatformStand = false
			end
		end
	end
end

-- ===== BIG HEAD MODE =====
function UniversalFeatures.setBigHead(enabled, size)
	local character = player.Character
	if character then
		local head = character:FindFirstChild("Head")
		if head then
			if enabled then
				head.Size = Vector3.new(size or 10, size or 10, size or 10)
			else
				head.Size = Vector3.new(2, 1, 1)
			end
		end
	end
end

-- ===== LONG NECK MODE =====
function UniversalFeatures.setLongNeck(enabled)
	local character = player.Character
	if character then
		local head = character:FindFirstChild("Head")
		if head and enabled then
			head.Size = Vector3.new(1, 10, 1)
		elseif head then
			head.Size = Vector3.new(2, 1, 1)
		end
	end
end

-- ===== NAMETAG SPOOF =====
function UniversalFeatures.setNametagSpoof(enabled, fakeName)
	nametagSpoofEnabled = enabled
	
	if enabled and fakeName then
		originalDisplayName = player.DisplayName
		player.DisplayName = fakeName
	else
		player.DisplayName = originalDisplayName
	end
end

-- ===== SPAM RESET (ANTI-KICK TRIGGER) =====
function UniversalFeatures.spamResetTrigger()
	spawn(function()
		for i = 1, 50 do
			local character = player.Character
			if character then
				local humanoid = character:FindFirstChildOfClass("Humanoid")
				if humanoid then
					humanoid.Health = 0
				end
			end
			wait(0.1)
			player:LoadCharacter()
		end
	end)
end

-- ===== ROCKET LAUNCH =====
function UniversalFeatures.rocketLaunch()
	local character = player.Character
	if character and character:FindFirstChild("HumanoidRootPart") then
		local hrp = character.HumanoidRootPart
		local bodyVelocity = Instance.new("BodyVelocity")
		bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
		bodyVelocity.Velocity = Vector3.new(0, 500, 0)
		bodyVelocity.Parent = hrp
		
		wait(2)
		bodyVelocity:Destroy()
	end
end

-- ===== WALK BACKWARDS =====
function UniversalFeatures.setWalkBackwards(enabled)
	local character = player.Character
	if character then
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if humanoid and enabled then
			-- Inverse les contrôles
			humanoid.WalkSpeed = -humanoid.WalkSpeed
		elseif humanoid then
			humanoid.WalkSpeed = math.abs(humanoid.WalkSpeed)
		end
	end
end

return UniversalFeatures
