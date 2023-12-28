local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )

local AverageCoreNetworth = 10001

local killTime = 0.0
local shouldKillRoshan = false
local DoingRoshanMessage = DotaTime()

local roshanRadiantLoc  = Vector(7625, -7511, 1092)
local roshanDireLoc     = Vector(-7549, 7562, 1107)

function GetDesire()
    local aliveAlly = J.GetNumOfAliveHeroes(false)

    shouldKillRoshan = IsRoshanAlive()

    if shouldKillRoshan
    and (J.GetCoresTotalNetworth() / 3) >= AverageCoreNetworth
    and aliveAlly >= 4
    then
        if (bot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT or bot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_MID or bot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP)
        and bot:GetActiveModeDesire() > 0.75
        then
            return BOT_ACTION_DESIRE_MODERATE
        end

        return BOT_ACTION_DESIRE_HIGH
    end

    return BOT_ACTION_DESIRE_NONE
end

function Think()
    local timeOfDay, time = CheckTimeOfDay()

    if timeOfDay == "day" and time > 240
    then
        bot:ActionPush_MoveToLocation(roshanDireLoc)
    else
        bot:ActionPush_MoveToLocation(roshanRadiantLoc)
    end

    if timeOfDay == "night" and time > 540
    then
        bot:ActionPush_MoveToLocation(roshanRadiantLoc)
    else
        bot:ActionPush_MoveToLocation(roshanDireLoc)
    end

    local enemies = bot:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
    if enemies ~= nil and #enemies > 0 and J.WeAreStronger(bot, 1200)
    then
        return bot:ActionPush_AttackUnit(enemies[1], false)
    end

    local creeps = bot:GetNearbyLaneCreeps(1200, true)
    if creeps ~= nil and #creeps > 0 then
        return bot:ActionPush_AttackUnit(creeps[1], false)
    end

    local nCreeps = bot:GetNearbyNeutralCreeps(800)
    for _, c in pairs(nCreeps) do
        if string.find(c:GetUnitName(), "roshan")
        and IsEnoughAllies()
        then
            bot:ActionPush_AttackUnit(c, false)
        end

        if (DotaTime() - DoingRoshanMessage) > 15 then
            DoingRoshanMessage = DotaTime()
            bot:ActionImmediate_Chat("Let's kill Roshan!", false)
            if timeOfDay == "day" then
                bot:ActionImmediate_Ping(7625, -7511, true)
            else
                bot:ActionImmediate_Ping(-7549, 7562, true)
            end
        end

        return
    end

end

function IsRoshanAlive()
    if GetRoshanKillTime() > killTime
    then
        killTime = GetRoshanKillTime()
    end

    if DotaTime() - GetRoshanKillTime() >= (J.IsModeTurbo() and (6 * 60) or (11 * 60))
    and not (GetRoshanKillTime() == killTime and killTime > 0.0)
    then
        return true
    end

    return false
end

function CheckTimeOfDay()
    local cycle = 600
    local time = DotaTime() % cycle
    local night = 300

    if time < night then return "day", time
    else return "night", time
    end
end

function IsEnoughAllies()
    local allies = bot:GetNearbyHeroes(1600, false, BOT_MODE_ROSHAN)
    if allies ~= nil then
        return #allies > 3
    end

    return false
end