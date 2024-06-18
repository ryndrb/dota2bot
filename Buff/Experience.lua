dofile('bots/Buff/Helper')

if XP == nil
then
    XP = {}
end

local XPNeeded = {
    [1]  = 240,
    [2]  = 400,
    [3]  = 520,
    [4]  = 600,
    [5]  = 680,
    [6]  = 760,
    [7]  = 800,
    [8]  = 900,
    [9]  = 1000,
    [10] = 1100,
    [11] = 1200,
    [12] = 1300,
    [13] = 1400,
    [14] = 1500,
    [15] = 1600,
    [16] = 1700,
    [17] = 1800,
    [18] = 1900,
    [19] = 2000,
    [20] = 2200,
    [21] = 2400,
    [22] = 2600,
    [23] = 2800,
    [24] = 3000,
    [25] = 4000,
    [26] = 5000,
    [27] = 6000,
    [28] = 7000,
    [29] = 7500,
    [30] = 0,
}

function XP.UpdateXP(bot, nTeam)
    local gameTime = Helper.DotaTime() / 60

    local botLevel = bot:GetLevel()
    local needXP = XPNeeded[botLevel]
    local mul2XP = needXP / 2

    local xp = (mul2XP / 60) / 2

    if not Helper.IsCore(bot, nTeam)
    then
        xp = xp * 0.5
    end

    local timeMul = math.max(1, 1 - (gameTime / 60))

    xp = xp * timeMul

    if  bot:IsAlive()
    and gameTime > 0
    then
        bot:AddExperience(math.floor(xp), 0, false, true)
    end
end

return XP