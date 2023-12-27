local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )

local killTime = 0.0

function GetDesire()
    
    local allyNearby = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    local enemyNearby = bot:GetNearbyHeroes(1000, true, BOT_MODE_NONE)
    local target = bot:GetTarget()

    if GetRoshanKillTime() > killTime
    then
        killTime = GetRoshanKillTime()
    end

    if enemyNearby ~= nil and #enemyNearby > 0 
    then
        return BOT_ACTION_DESIRE_LOW
    end

    if allyNearby ~= nil
    and not J.IsCore(bot)
    and #allyNearby < 2
    then
        return BOT_ACTION_DESIRE_NONE
    end

    if J.IsCore(bot) 
    and bot:GetNetWorth() >= 12000
    and #allyNearby >= 2
    and DotaTime() - GetRoshanKillTime() >= (J.IsModeTurbo() and (6 * 60) or (11 * 60))
    and (bot:GetActiveMode() ~= BOT_MODE_DEFEND_TOWER_BOT or bot:GetActiveMode() ~= BOT_MODE_DEFEND_TOWER_MID or bot:GetActiveMode() ~= BOT_MODE_DEFEND_TOWER_TOP)
    and (bot:GetActiveMode() ~= BOT_MODE_PUSH_TOWER_BOT or bot:GetActiveMode() ~= BOT_MODE_PUSH_TOWER_MID or bot:GetActiveMode() ~= BOT_MODE_PUSH_TOWER_TOP)
    then
        if GetRoshanKillTime() == killTime and killTime > 0.0
        then
            return BOT_MODE_DESIRE_NONE
        else
            if J.IsRoshan(target) and (target:GetHealth() / target:GetMaxHealth()) <= 0.5
            then
                return BOT_ACTION_DESIRE_VERYHIGH
            end
            
            return BOT_ACTION_DESIRE_HIGH
        end
    end
    
    return BOT_ACTION_DESIRE_NONE
end