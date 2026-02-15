local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

local CoinFarmer = {}
local autoFarm = false
local speed = 25
local cooldown = 0.1
local currentTween = nil
local isBagFull = false
local MAX_DISTANCE = 100
local isProcessing = false

-- Cache optimisé
local coinCache = {}
local cacheUpdateInterval = 1
local lastCacheUpdate = 0
local coinsFolder = nil

local function getHRP()
    local char = player.Character or player.CharacterAdded:Wait()
    return char:WaitForChild("HumanoidRootPart")
end

local function findCoinsFolder()
    if not coinsFolder or not coinsFolder.Parent then
        for _, obj in pairs(Workspace:GetChildren()) do
            if obj:FindFirstChild("Coin_Server") then
                coinsFolder = obj
                break
            end
        end
    end
    return coinsFolder
end

local function updateCoinCache()
    local currentTime = tick()
    if currentTime - lastCacheUpdate < cacheUpdateInterval then
        return
    end
    
    lastCacheUpdate = currentTime
    table.clear(coinCache)
    
    local folder = findCoinsFolder()
    if folder then
        for _, obj in pairs(folder:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Name == "Coin_Server" then
                table.insert(coinCache, obj)
            end
        end
    else
        -- Fallback si pas de folder trouvé
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Name == "Coin_Server" then
                table.insert(coinCache, obj)
                if #coinCache >= 50 then break end -- Limite pour éviter le lag
            end
        end
    end
end

local function findNearestCoin()
    updateCoinCache()
    
    local hrp = getHRP()
    local hrpPos = hrp.Position
    local nearest = nil
    local minDist = math.huge
    
    -- Parcourir seulement les 20 premiers coins pour optimiser
    local maxCheck = math.min(#coinCache, 20)
    
    for i = 1, maxCheck do
        local coin = coinCache[i]
        if coin and coin.Parent then
            local dist = (coin.Position - hrpPos).Magnitude
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
    
    local success, result = pcall(function()
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
                task.defer(farmStep)
                return
            end
            
            local tweenTime = distance / speed
            local tweenInfo = TweenInfo.new(tweenTime, Enum.EasingStyle.Linear)
            currentTween = TweenService:Create(hrp, tweenInfo, {CFrame = coin.CFrame})
            
            local connection
            connection = currentTween.Completed:Connect(function()
                connection:Disconnect()
                currentTween = nil
                task.wait(cooldown)
                isProcessing = false
                task.defer(farmStep)
            end)
            
            currentTween:Play()
        else
            isProcessing = false
            task.wait(1)
            task.defer(farmStep)
        end
    end)
    
    if not success then
        warn("[TMMW] Farm error:", result)
        isProcessing = false
        task.wait(1)
        task.defer(farmStep)
    end
end

function CoinFarmer.setAutoFarm(state)
    autoFarm = state
    if state then
        isBagFull = false
        isProcessing = false
        table.clear(coinCache)
        lastCacheUpdate = 0
        task.defer(farmStep)
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
    cooldown = math.clamp(value, 0, 0.5)
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
