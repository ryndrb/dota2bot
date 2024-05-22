dofile('bots/Buff/Helper')

if GPM == nil
then
    GPM = {}
end

-- Reasonable GPM (XPM later)
function GPM.TargetGPM(time)
    if time <= 10 * 60 then
        return 450
    elseif time <= 20 * 60 then
        return 600
    elseif time <= 30 * 60 then
        return 750
    else
        return RandomInt(900, 1000)
    end
end

function GPM.UpdateBotGold(bot, nTeam)
    local isCore = Helper.IsCore(bot, nTeam)
    local gameTime = Helper.DotaTime() / 60
    local targetGPM = GPM.TargetGPM(gameTime)

    local currentGPM = PlayerResource:GetGoldPerMin(bot:GetPlayerID())
    local expected = targetGPM * (gameTime / 60)
    local actual = currentGPM * (gameTime / 60)
    local missing = expected - actual
    local goldPerTick = math.max(1, missing / (60 * 2))

    -- Give Supports "passive" Philosopher's stone
    -- Juice up cores more
    local nAdd = 2.5
    if not isCore
    then
        nAdd = 75 / 60
        goldPerTick = 0
    end

    if  bot:IsAlive()
    and gameTime > 0
    then
        bot:ModifyGold(nAdd + math.ceil(goldPerTick), true, 0)
    end
end

return GPM