-- ========================================
-- UNIVERSAL FEATURES MODULE
-- Fonctionnalités universelles (marche dans tous les jeux)
-- ========================================

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = game.Players.LocalPlayer

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

return UniversalFeatures
