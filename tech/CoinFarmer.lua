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
local MAX_COINS_IN_CACHE = 15

-- Cache optimisé
local coinCache = {}
local cacheUpdateInterval = 0.8
local lastCacheUpdate = 0
local coinsFolder = nil

-- Monitoring du bag
local bagMonitorRunning = false

local function getHRP()
    local char = player.Character or player.CharacterAdded:Wait()
    return char:WaitForChild("HumanoidRootPart")
end

local function makeCharacterLieDown(state)
    local char = player.Character
    if not char then return end
    
    local humanoid = char:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    if state then
        -- Mettre le personnage couché
        humanoid:ChangeState(Enum.HumanoidStateType.Physics)
        humanoid.PlatformStand = true
        
        -- Incliner le personnage pour qu'il soit au sol
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = hrp.CFrame * CFrame.Angles(math.rad(90), 0, 0)
        end
    else
        -- Remettre le personnage debout
        humanoid.PlatformStand = false
        humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
        
        -- Réorienter correctement
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local pos = hrp.Position
            hrp.CFrame = CFrame.new(pos) * CFrame.Angles(0, 0, 0)
        end
    end
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

local function checkBagStatus()
    local playerGui = player:WaitForChild("PlayerGui")
    local mainGui = playerGui:FindFirstChild("MainGUI")
    if not mainGui then return false end
    
    local coinBags = mainGui:FindFirstChild("CoinBags")
    if not coinBags then return false end
    
    local container = coinBags:FindFirstChild("Container")
    if not container then return false end
    
    -- Vérifier si au moins un bag a de la place
    for _, bag in pairs(container:GetChildren()) do
        if bag:IsA("Frame") and bag.Visible then
            local fullIcon = bag:FindFirstChild("Full")
            if fullIcon and not fullIcon.Visible then
                return false -- Au moins un bag a de la place
            end
        end
    end
    
    return true -- Tous les bags visibles sont pleins
end

local function monitorBag()
    while autoFarm and bagMonitorRunning do
        local bagIsFull = checkBagStatus()
        
        if bagIsFull and not isBagFull then
            isBagFull = true
            warn("[TMMW] Coin bag is full! Waiting for space...")
            if currentTween then
                currentTween:Cancel()
                currentTween = nil
            end
            isProcessing = false
        elseif not bagIsFull and isBagFull then
            isBagFull = false
            print("[TMMW] Coin bag has space! Resuming auto farm...")
            if autoFarm and not isProcessing then
                task.defer(farmStep)
            end
        end
        
        task.wait(3) -- Vérifier toutes les 3 secondes
    end
end

local function updateCoinCache()
    local currentTime = tick()
    if currentTime - lastCacheUpdate < cacheUpdateInterval then
        return
    end
    
    lastCacheUpdate = currentTime
    table.clear(coinCache)
    
    local hrp = getHRP()
    local hrpPos = hrp.Position
    local tempCoins = {}
    
    local folder = findCoinsFolder()
    if folder then
        for _, obj in pairs(folder:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Name == "Coin_Server" then
                local dist = (obj.Position - hrpPos).Magnitude
                if dist <= MAX_DISTANCE then
                    table.insert(tempCoins, {coin = obj, distance = dist})
                end
            end
        end
    else
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Name == "Coin_Server" then
                local dist = (obj.Position - hrpPos).Magnitude
                if dist <= MAX_DISTANCE then
                    table.insert(tempCoins, {coin = obj, distance = dist})
                    if #tempCoins >= 50 then break end
                end
            end
        end
    end
    
    -- Si aucune pièce trouvée, pas besoin de trier
    if #tempCoins == 0 then
        return
    end
    
    -- Trier par distance et garder seulement les 15 plus proches
    table.sort(tempCoins, function(a, b) return a.distance < b.distance end)
    
    for i = 1, math.min(#tempCoins, MAX_COINS_IN_CACHE) do
        table.insert(coinCache, tempCoins[i].coin)
    end
end

local function findNearestCoin()
    updateCoinCache()
    
    -- Si le cache est vide, pas la peine de chercher
    if #coinCache == 0 then
        return nil
    end
    
    local hrp = getHRP()
    local hrpPos = hrp.Position
    local nearest = nil
    local minDist = math.huge
    
    -- Parcourir seulement les coins du cache (max 15)
    for i = #coinCache, 1, -1 do
        local coin = coinCache[i]
        if not coin or not coin.Parent then
            table.remove(coinCache, i)
        else
            local dist = (coin.Position - hrpPos).Magnitude
            if dist < minDist then
                minDist = dist
                nearest = coin
            end
        end
    end
    
    return nearest
end

local function farmStep()
    if not autoFarm or isProcessing then 
        return 
    end
    
    -- Si le bag est plein, attendre qu'il se vide
    if isBagFull then
        task.wait(2)
        task.defer(farmStep)
        return
    end
    
    isProcessing = true
    
    local success, result = pcall(function()
        local coin = findNearestCoin()
        
        -- Si aucune pièce dans la zone, attendre plus longtemps avant de revérifier
        if not coin then
            isProcessing = false
            task.wait(2)
            task.defer(farmStep)
            return
        end
        
        local hrp = getHRP()
        
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
        
        -- Déplacer le personnage couché vers la pièce
        local targetCFrame = coin.CFrame * CFrame.Angles(math.rad(90), 0, 0)
        
        local tweenTime = distance / speed
        local tweenInfo = TweenInfo.new(tweenTime, Enum.EasingStyle.Linear)
        currentTween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
        
        local connection
        connection = currentTween.Completed:Connect(function()
            connection:Disconnect()
            currentTween = nil
            task.wait(cooldown)
            isProcessing = false
            task.defer(farmStep)
        end)
        
        currentTween:Play()
    end)
    
    if not success then
        warn("[TMMW] Farm error:", result)
        isProcessing = false
        task.wait(2)
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
        
        -- Mettre le personnage couché
        makeCharacterLieDown(true)
        
        -- Démarrer le monitoring du bag
        if not bagMonitorRunning then
            bagMonitorRunning = true
            task.spawn(monitorBag)
        end
        
        task.defer(farmStep)
    else
        if currentTween then
            currentTween:Cancel()
            currentTween = nil
        end
        isProcessing = false
        bagMonitorRunning = false
        
        -- Remettre le personnage debout
        makeCharacterLieDown(false)
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
            if not isBagFull then
                isBagFull = true
                warn("[TMMW] Coin bag is full! Waiting for space...")
                if currentTween then
                    currentTween:Cancel()
                    currentTween = nil
                end
                isProcessing = false
            end
        else
            if isBagFull then
                isBagFull = false
                print("[TMMW] Coin bag has space! Resuming auto farm...")
                if autoFarm and not isProcessing then
                    task.defer(farmStep)
                end
            end
        end
    end)
    
    -- Remettre debout si le personnage meurt
    player.CharacterAdded:Connect(function(char)
        if autoFarm then
            task.wait(1)
            makeCharacterLieDown(true)
        end
    end)
end

return CoinFarmer
