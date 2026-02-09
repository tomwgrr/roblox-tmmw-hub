-- ========================================
-- TMMW HUB - LOADING SCREEN CINEMATIC NEON
-- Minimum display 5 seconds
-- ========================================

local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")

local LoadingScreen = {}

local THEME_COLOR = Color3.fromRGB(170, 80, 255)
local MIN_LOADING_TIME = 5 -- secondes

local function tween(obj, info, props)
    local t = TweenService:Create(obj, info, props)
    t:Play()
    return t
end

function LoadingScreen.show(playerGui)
    local startTime = tick()

    -- =====================
    -- SCREEN GUI
    -- =====================
    local gui = Instance.new("ScreenGui")
    gui.Name = "TMMWHubLoading"
    gui.IgnoreGuiInset = true
    gui.ResetOnSpawn = false
    gui.Parent = playerGui

    -- =====================
    -- SOUNDS (OPTIONAL - Protected)
    -- =====================
    local whoosh = nil
    local doneSound = nil
    
    pcall(function()
        whoosh = Instance.new("Sound")
        whoosh.SoundId = "rbxassetid://9118823101"
        whoosh.Volume = 0.6
        whoosh.Parent = SoundService
    end)

    pcall(function()
        doneSound = Instance.new("Sound")
        doneSound.SoundId = "rbxassetid://9118828562"
        doneSound.Volume = 0.5
        doneSound.Parent = SoundService
    end)

    -- =====================
    -- BLUR
    -- =====================
    local blur = nil
    pcall(function()
        blur = Instance.new("BlurEffect")
        blur.Size = 0
        blur.Parent = Lighting
        tween(blur, TweenInfo.new(0.8), { Size = 18 })
    end)

    -- =====================
    -- NEON PARTICLES
    -- =====================
    local particles = Instance.new("Frame")
    particles.Size = UDim2.fromScale(1, 1)
    particles.BackgroundTransparency = 1
    particles.Parent = gui

    for i = 1, 32 do
        local p = Instance.new("Frame")
        p.Size = UDim2.fromOffset(math.random(5, 9), math.random(5, 9))
        p.Position = UDim2.fromScale(math.random(), math.random())
        p.BackgroundColor3 = THEME_COLOR
        p.BackgroundTransparency = 0.15
        p.BorderSizePixel = 0
        p.Parent = particles

        Instance.new("UICorner", p).CornerRadius = UDim.new(1, 0)

        local stroke = Instance.new("UIStroke")
        stroke.Color = THEME_COLOR
        stroke.Thickness = 2
        stroke.Transparency = 0.15
        stroke.Parent = p

        task.spawn(function()
            while p.Parent do
                tween(
                    p,
                    TweenInfo.new(math.random(10, 18), Enum.EasingStyle.Sine),
                    { Position = UDim2.fromScale(math.random(), math.random()) }
                ).Completed:Wait()
            end
        end)
    end

    -- =====================
    -- CONTAINER
    -- =====================
    local container = Instance.new("Frame")
    container.Size = UDim2.fromOffset(520, 240)
    container.Position = UDim2.fromScale(0.5, 0.25)
    container.AnchorPoint = Vector2.new(0.5, 0.5)
    container.BackgroundTransparency = 1
    container.Parent = gui

    -- =====================
    -- TITLE + GLOW
    -- =====================
    local glow = Instance.new("Frame")
    glow.Size = UDim2.new(1, 0, 0, 80)
    glow.BackgroundTransparency = 1
    glow.Parent = container

    local glowGradient = Instance.new("UIGradient", glow)
    glowGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, THEME_COLOR),
        ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)),
        ColorSequenceKeypoint.new(1, THEME_COLOR),
    })

    task.spawn(function()
        while glow.Parent do
            glowGradient.Offset = Vector2.new(-1, 0)
            tween(
                glowGradient,
                TweenInfo.new(3, Enum.EasingStyle.Linear),
                { Offset = Vector2.new(1, 0) }
            ).Completed:Wait()
        end
    end)

    local mask = Instance.new("Frame")
    mask.Size = UDim2.new(0, 0, 0, 70)
    mask.ClipsDescendants = true
    mask.BackgroundTransparency = 1
    mask.Parent = container

    local title = Instance.new("TextLabel")
    title.Size = UDim2.fromScale(1, 1)
    title.BackgroundTransparency = 1
    title.Text = "TMMW HUB"
    title.Font = Enum.Font.GothamBlack
    title.TextScaled = true
    title.TextColor3 = Color3.new(1, 1, 1)
    title.TextTransparency = 1
    title.Parent = mask

    -- Play whoosh sound if available
    pcall(function()
        if whoosh then
            whoosh:Play()
        end
    end)
    
    tween(mask, TweenInfo.new(1.1, Enum.EasingStyle.Quint), { Size = UDim2.new(1, 0, 0, 70) })
    tween(title, TweenInfo.new(0.8), { TextTransparency = 0 })

    -- =====================
    -- SUBTITLE
    -- =====================
    local subtitle = Instance.new("TextLabel")
    subtitle.Size = UDim2.new(1, 0, 0, 24)
    subtitle.Position = UDim2.fromOffset(0, 80)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "Loading..."
    subtitle.Font = Enum.Font.Gotham
    subtitle.TextScaled = true
    subtitle.TextColor3 = Color3.fromRGB(200, 200, 220)
    subtitle.Parent = container

    -- =====================
    -- LOADING BAR
    -- =====================
    local barBg = Instance.new("Frame")
    barBg.Size = UDim2.new(0.7, 0, 0, 5)
    barBg.Position = UDim2.fromOffset(container.AbsoluteSize.X / 2, 135)
    barBg.AnchorPoint = Vector2.new(0.5, 0)
    barBg.BackgroundColor3 = Color3.new(1, 1, 1)
    barBg.BackgroundTransparency = 0.85
    barBg.BorderSizePixel = 0
    barBg.Parent = container
    Instance.new("UICorner", barBg).CornerRadius = UDim.new(1, 0)

    local bar = Instance.new("Frame")
    bar.Size = UDim2.fromScale(0.25, 1)
    bar.BackgroundColor3 = THEME_COLOR
    bar.BorderSizePixel = 0
    bar.Parent = barBg
    Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)

    task.spawn(function()
        while bar.Parent do
            tween(bar, TweenInfo.new(1.2, Enum.EasingStyle.Sine), { Position = UDim2.fromScale(0.75, 0) }).Completed:Wait()
            bar.Position = UDim2.fromScale(0, 0)
        end
    end)

    -- =====================
    -- FINISH LOADING
    -- =====================
    local finished = false
    local function finish()
        if finished then 
            print("[LoadingScreen] Déjà fermé")
            return 
        end
        finished = true

        local elapsed = tick() - startTime
        print("[LoadingScreen] Temps écoulé:", elapsed, "secondes")
        
        if elapsed < MIN_LOADING_TIME then
            local waitTime = MIN_LOADING_TIME - elapsed
            print("[LoadingScreen] Attente de", waitTime, "secondes supplémentaires...")
            task.wait(waitTime)
        end

        print("[LoadingScreen] Fermeture en cours...")
        
        -- Play done sound if available
        pcall(function()
            if doneSound then
                doneSound:Play()
            end
        end)
        
        subtitle.Text = "Ready"

        -- Fade out tous les éléments
        for _, v in ipairs(gui:GetDescendants()) do
            pcall(function()
                if v:IsA("TextLabel") then
                    tween(v, TweenInfo.new(0.6), { TextTransparency = 1 })
                elseif v:IsA("Frame") and v.BackgroundTransparency < 1 then
                    tween(v, TweenInfo.new(0.6), { BackgroundTransparency = 1 })
                elseif v:IsA("UIStroke") then
                    tween(v, TweenInfo.new(0.6), { Transparency = 1 })
                end
            end)
        end

        if blur then
            tween(blur, TweenInfo.new(0.6), { Size = 0 })
        end
        
        task.wait(0.7)

        -- Cleanup
        pcall(function()
            gui:Destroy()
        end)
        
        if blur then
            pcall(function()
                blur:Destroy()
            end)
        end
        
        if whoosh then
            pcall(function()
                whoosh:Destroy()
            end)
        end
        
        if doneSound then
            pcall(function()
                doneSound:Destroy()
            end)
        end
        
        print("[LoadingScreen] ✓ Fermé complètement")
    end

    print("[LoadingScreen] Loading screen affiché")
    return finish
end

return LoadingScreen
