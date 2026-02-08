-- PremiumConfig.lua
local PremiumConfig = {
    -- Si une option est ici avec 'true', elle nécessite le Premium
    LockedFeatures = {
        -- MM2 Page
        ["Murderer ESP"] = true,
        ["Sheriff ESP"] = true,
        ["Innocent ESP"] = true,
        ["Assassin ESP"] = true,
        ["Show Player Info"] = true,
        ["Auto Grab Gun"] = true,
        ["Grab Gun Once"] = true,
        ["Auto Farm Coins"] = true,
        
        -- Universal Page
        ["Fly"] = true,
        ["Noclip"] = true,
        ["Infinite Jump"] = true,
        ["X-Ray"] = true,
        ["Fullbright"] = true,
        ["Speed Hack"] = true,
        ["Jump Power"] = true,
        ["Spinbot"] = true,
        ["Fling All"] = true,
        ["Anti-AFK"] = true,
    }
}

function PremiumConfig.isLocked(featureName)
    local isPremium = getgenv().TMMW.PremiumSystem.hasPremium()
    -- Verrouillé si présent dans la table ET utilisateur non premium
    return PremiumConfig.LockedFeatures[featureName] == true and not isPremium
end

return PremiumConfig
