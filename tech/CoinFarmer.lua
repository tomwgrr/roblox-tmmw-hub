local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local CoinFarmer = {}
local autoFarm = false
local speed = 25
local cooldown = 0.05
local currentTween = nil
local isBagFull = false
local MAX_DISTANCE = 100
local isProcessing = false

-- Cache pour les coins
local coinCache = {}
local cacheUpdateInterval = 0.5
local lastCacheUpdate = 0

local function getHRP()
    local char = player.Character or player.CharacterAdded:Wait()
    return char:WaitForChild("HumanoidRootPart")
end

local function updateCoinCache()
    local currentTime = tick()
    if currentTime - lastCacheUpdate < cacheUpdateInterval then
        return
    end
    
    lastCacheUpdate = currentTime
    table.clear(coinCache)
    
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name == "Coin_Server" then
            table.insert(coinCache, obj)
        end
    end
end

local function findNearestCoin()
    updateCoinCache()
    
    local hrp = getHRP()
    local nearest = nil
    local minDist = math.huge
    
    for i = #coinCache, 1, -1 do
        local coin = coinCache[i]
        if not coin or not coin.Parent then
            table.remove(coinCache, i)
        else
            local dist = (coin.Position - hrp.Position).Magnitude
            if dist <= MAX_DISTANCE and dist < minDist then
                minDist = dist
                nearest = coin
            end
        end
    end
    
    return nearest
end

local function farmStep()
    if not autoFarm or isBagFull or isProcessing then 
        return 
    end
    
    isProcessing = true
    
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
            isProcessing = false
            task.spawn(farmStep)
            return
        end
        
        local tweenTime = distance / speed
        local tweenInfo = TweenInfo.new(tweenTime, Enum.EasingStyle.Linear)
        currentTween = TweenService:Create(hrp, tweenInfo, {CFrame = coin.CFrame})
        
        currentTween.Completed:Connect(function()
            currentTween = nil
            task.wait(cooldown)
            isProcessing = false
            task.spawn(farmStep)
        end)
        
        currentTween:Play()
    else
        isProcessing = false
        task.wait(0.5)
        task.spawn(farmStep)
    end
end

function CoinFarmer.setAutoFarm(state)
    autoFarm = state
    if state then
        isBagFull = false
        isProcessing = false
        task.spawn(farmStep)
    else
        if currentTween then
            currentTween:Cancel()
            currentTween = nil
        end
        isProcessing = false
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
                isProcessing = false
            end
        else
            isBagFull = false
        end
    end)
end

return CoinFarmer
