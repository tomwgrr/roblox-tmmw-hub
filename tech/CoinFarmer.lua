local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

local CoinFarmer = {}
local autoFarm = false
local speed = 25
local cooldown = 0.05
local currentTween = nil
local isBagFull = false

local function getHRP()
    local char = player.Character or player.CharacterAdded:Wait()
    return char:WaitForChild("HumanoidRootPart")
end

local function findNearestCoin()
    local hrp = getHRP()
    local nearest = nil
    local minDist = math.huge
    
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name == "Coin_Server" then
            local dist = (obj.Position - hrp.Position).Magnitude
            if dist < minDist then
                minDist = dist
                nearest = obj
            end
        end
    end
    
    return nearest
end

local function farmStep()
    if not autoFarm or isBagFull then return end
    
    local hrp = getHRP()
    local coin = findNearestCoin()
    
    if coin then
        if currentTween then
            currentTween:Cancel()
            currentTween = nil
        end
        
        local distance = (coin.Position - hrp.Position).Magnitude
        if distance < 3 then
            coin.Parent = nil
            task.wait(cooldown)
            task.spawn(farmStep)
            return
        end
        
        local tweenTime = distance / speed
        local tweenInfo = TweenInfo.new(tweenTime, Enum.EasingStyle.Linear)
        currentTween = TweenService:Create(hrp, tweenInfo, {CFrame = coin.CFrame})
        
        currentTween.Completed:Connect(function()
            currentTween = nil
            task.wait(cooldown)
            task.spawn(farmStep)
        end)
        
        currentTween:Play()
    else
        task.wait(0.1)
        task.spawn(farmStep)
    end
end

function CoinFarmer.setAutoFarm(state)
    autoFarm = state
    if state then
        isBagFull = false
        task.spawn(farmStep)
    else
        if currentTween then
            currentTween:Cancel()
            currentTween = nil
        end
    end
    return true
end

function CoinFarmer.setSpeed(value)
    speed = math.clamp(value, 10, 200)
    return true
end

function CoinFarmer.setCooldown(value)
    cooldown = math.clamp(value, 0, 0.3)
    return true
end

function CoinFarmer.initialize()
    print("[TMMW] CoinFarmer initialized")
    
    -- Écouter l'événement CoinCollected pour détecter si le bag est plein
    local remotes = ReplicatedStorage:WaitForChild("Remotes")
    local gameplay = remotes:WaitForChild("Gameplay")
    local coinCollected = gameplay:WaitForChild("CoinCollected")
    
    coinCollected.OnClientEvent:Connect(function(bagName, currentCoins, maxCoins, _)
        if currentCoins >= maxCoins then
            isBagFull = true
            if autoFarm then
                warn("[TMMW] Coin bag is full! Auto farm stopped.")
                if currentTween then
                    currentTween:Cancel()
                    currentTween = nil
                end
            end
        else
            isBagFull = false
        end
    end)
end

return CoinFarmer
