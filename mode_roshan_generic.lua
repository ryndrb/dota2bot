local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )

local killTime = 0.0
local shouldKillRoshan = false
local DoingRoshanMessage = DotaTime()

local roshanRadiantLoc  = Vector(7625, -7511, 1092)
local roshanDireLoc     = Vector(-7549, 7562, 1107)

-- local rTwinGate = nil
-- local dTwinGate = nil
-- local rTwinGateLoc = Vector(5888, -7168, 256)
-- local dTwinGateLoc = Vector(6144, 7552, 256)

local initDPSFlag = false

function GetDesire()
    local aliveAlly = J.GetNumOfAliveHeroes(false)
    local aliveEnemy = J.GetNumOfAliveHeroes(true)
    local healthPercentage = bot:GetHealth() / bot:GetMaxHealth()

    local aliveHeroesList = {}
    for _, h in pairs(GetUnitList(UNIT_LIST_ALLIED_HEROES)) do
        if h:IsAlive()
        then
            table.insert(aliveHeroesList, h)
        end
    end

    shouldKillRoshan = J.IsRoshanAlive()

    if J.HasEnoughDPSForRoshan(aliveHeroesList)
    then
        initDPSFlag = true
    end

    local enemies = bot:GetNearbyHeroes(700 + bot:GetAttackRange(), true, BOT_MODE_NONE)
    if enemies ~= nil
    and #enemies > 0
    then
        return BOT_ACTION_DESIRE_LOW
    end

    if shouldKillRoshan
    and initDPSFlag
    then
        if healthPercentage < 0.3
        then
            return BOT_ACTION_DESIRE_LOW
        end

        if IsEnoughAllies()
        then
            return BOT_ACTION_DESIRE_ABSOLUTE
        end

        return Clamp(GetRoshanDesire(), 0.1, 0.9) * 2
    end

    return BOT_ACTION_DESIRE_NONE
end

-- function Think()
--     local timeOfDay, time = J.CheckTimeOfDay()
--     -- local isInPlace, twinGate = IsInTwinGates(timeOfDay, time)

--     if timeOfDay == "day" and time > 270
--     then
--         -- if ConsiderTwinGates(timeOfDay, time) then
--         --     bot:ActionPush_MoveToLocation(rTwinGateLoc)
--         -- end

--         -- if isInPlace then
--         --     bot:ActionPush_AttackUnit(twinGate, false)
--         -- end

--         bot:ActionPush_MoveToLocation(roshanDireLoc)
--     elseif timeOfDay == "day" then
--         bot:ActionPush_MoveToLocation(roshanRadiantLoc)
--     end

--     if timeOfDay == "night" and time > 570
--     then
--         -- if ConsiderTwinGates(timeOfDay, time) then
--         --     bot:ActionPush_MoveToLocation(dTwinGateLoc)
--         -- end

--         -- if isInPlace then
--         --     bot:ActionPush_AttackUnit(twinGate, false)
--         -- end

--         bot:ActionPush_MoveToLocation(roshanRadiantLoc)
--     elseif timeOfDay == "night" then
--         bot:ActionPush_MoveToLocation(roshanDireLoc)
--     end

--     local nRange = bot:GetAttackRange() + 700

--     local enemies = bot:GetNearbyHeroes(nRange, true, BOT_MODE_NONE)
--     if enemies ~= nil and #enemies > 0 and J.WeAreStronger(bot, nRange)
--     then
--         return bot:ActionPush_AttackUnit(enemies[1], false)
--     end

--     local creeps = bot:GetNearbyLaneCreeps(nRange, true)
--     if creeps ~= nil and #creeps > 0 then
--         bot:ActionPush_AttackUnit(creeps[1], false)
--     end

--     local nCreeps = bot:GetNearbyNeutralCreeps(nRange)
--     for _, c in pairs(nCreeps) do
--         if string.find(c:GetUnitName(), "roshan")
--         and (IsEnoughAllies() or (J.IsCore(bot) and c:GetHealth() / c:GetMaxHealth() < 0.3))
--         then
--             return bot:ActionPush_AttackUnit(c, false)
--         end

--         if (DotaTime() - DoingRoshanMessage) > 15 then
--             DoingRoshanMessage = DotaTime()
--             bot:ActionImmediate_Chat("Let's kill Roshan!", false)
--             if timeOfDay == "day" then
--                 bot:ActionImmediate_Ping(7625, -7511, true)
--             else
--                 bot:ActionImmediate_Ping(-7549, 7562, true)
--             end
--         end
--     end
-- end

function IsEnoughAllies()
    local timeOfDay = J.CheckTimeOfDay()
    local roshLoc = nil

    if timeOfDay == "day" then
        roshLoc = roshanRadiantLoc
    else
        roshLoc = roshanDireLoc
    end

    local allyList = {}
    for _, h in pairs(GetUnitList(UNIT_LIST_ALLIED_HEROES)) do
        if GetUnitToLocationDistance(h, roshLoc) < 2000
        then
            table.insert(allyList, h)
        end
    end

    return J.HasEnoughDPSForRoshan(allyList)
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