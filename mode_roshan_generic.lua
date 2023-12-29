local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )

local AverageCoreNetworth = 10001

local killTime = 0.0
local shouldKillRoshan = false
local DoingRoshanMessage = DotaTime()

local roshan = nil
local roshanRadiantLoc  = Vector(7625, -7511, 1092)
local roshanDireLoc     = Vector(-7549, 7562, 1107)

-- local rTwinGate = nil
-- local dTwinGate = nil
-- local rTwinGateLoc = Vector(5888, -7168, 256)
-- local dTwinGateLoc = Vector(6144, 7552, 256)

function GetDesire()
    local aliveAlly = J.GetNumOfAliveHeroes(false)
    local aliveEnemy = J.GetNumOfAliveHeroes(true)
    local aCount = bot:GetNearbyHeroes(1200, false, BOT_MODE_NONE)
    local eCount = bot:GetNearbyHeroes(1200, true, BOT_MODE_NONE)

    shouldKillRoshan = IsRoshanAlive()

    if shouldKillRoshan
    and (J.GetCoresTotalNetworth() / 3) >= AverageCoreNetworth
    and aliveAlly >= aliveEnemy
    then
        local desire = BOT_ACTION_DESIRE_VERYHIGH
        local nearbyAlly, nearbyAllyCore = IsNearRoshan()

        if (nearbyAlly > 2 and nearbyAllyCore >= 2)
        or (roshan ~= nil and (roshan:GetHealth() / roshan:GetMaxHealth()) < 0.3)
        then
           return desire
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

function Think()
    local timeOfDay, time = CheckTimeOfDay()
    local nearbyAlly, nearbyAllyCore = IsNearRoshan()
    -- local isInPlace, twinGate = IsInTwinGates(timeOfDay, time)

    if timeOfDay == "day" and time > 240
    then
        -- if ConsiderTwinGates(timeOfDay, time) then
        --     bot:ActionPush_MoveToLocation(rTwinGateLoc)
        -- end

        -- if isInPlace then
        --     bot:ActionPush_AttackUnit(twinGate, false)
        -- end

        bot:ActionPush_MoveToLocation(roshanDireLoc)
    elseif timeOfDay == "day" then
        bot:ActionPush_MoveToLocation(roshanRadiantLoc)
    end

    if timeOfDay == "night" and time > 540
    then
        -- if ConsiderTwinGates(timeOfDay, time) then
        --     bot:ActionPush_MoveToLocation(dTwinGateLoc)
        -- end

        -- if isInPlace then
        --     bot:ActionPush_AttackUnit(twinGate, false)
        -- end

        bot:ActionPush_MoveToLocation(roshanRadiantLoc)
    elseif timeOfDay == "night" then
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
        and (IsEnoughAllies()
        or (J.IsCore(bot) and c:GetHealth() / c:GetMaxHealth() < 0.3)
        or nearbyAlly >= 2 and nearbyAllyCore > 0)
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
    then
        return true
    end

    roshan = nil
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
        return #allies > 2
    end

    return false
end

function IsNearRoshan()
    local nearbyAlly = 0
    local nearbyAllyCore = 0
    local unitList = GetUnitList(UNIT_LIST_ALL)

    for _, u in pairs(unitList) do
        if rTwinGate == nil then
            if u:GetUnitName() == "npc_dota_roshan" then
                roshan = u
            end
        end
    end

    if roshan ~= nil
    and GetUnitToLocationDistance(bot, roshan:GetLocation()) < 2000
    then
        nearbyAlly = nearbyAlly + 1
        if J.IsCore(bot) then
            nearbyAllyCore = nearbyAllyCore + 1
        end
    end

    return nearbyAlly, nearbyAllyCore
end

-- No functionality yet from API
-- function ConsiderTwinGates(timeOfDay, time)
--     if timeOfDay == "day" and time > 240
--     then
--         if GetUnitToLocationDistance(bot, dTwinGateLoc) < 6000
--         and bot:GetMana() >= 75
--         then
--             return true
--         end
--     end

--     if timeOfDay == "night" and time > 540
--     then
--         if GetUnitToLocationDistance(bot, rTwinGateLoc) < 6000 then
--             return true
--         end
--     end

--     return false
-- end

-- function IsInTwinGates(timeOfDay, time)
--     local twinGate = nil
--     local unitList = GetUnitList(UNIT_LIST_ALL)
--     for _, u in pairs(unitList) do
--         if rTwinGate == nil then
--             if u:GetUnitName() == "npc_dota_unit_twin_gate" then
--                 rTwinGate = u
--             else
--                 dTwinGate = u
--             end
--         end
--     end

--     if rTwinGate ~= nil and dTwinGate ~= nil
--     and GetUnitToUnitDistance(bot, rTwinGate) < GetUnitToUnitDistance(bot, dTwinGate)
--     then
--         twinGate = rTwinGate
--     else
--         twinGate = dTwinGate
--     end

--     if timeOfDay == "day" and time > 240
--     then
--         if GetUnitToLocationDistance(bot, dTwinGateLoc) < 100
--         then
--             return true, twinGate
--         end
--     end

--     if timeOfDay == "night" and time > 540
--     then
--         if GetUnitToLocationDistance(bot, rTwinGateLoc) < 100 then
--             return true, twinGate
--         end
--     end

--     return false, twinGate
-- end