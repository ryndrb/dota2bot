local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )

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
    local healthPercentage = bot:GetHealth() / bot:GetMaxHealth()
    
    local aliveHeroesList = {}
    for _, h in pairs(GetUnitList(UNIT_LIST_ALLIED_HEROES)) do
        if h:IsAlive()
        then
            table.insert(aliveHeroesList, h)
        end
    end

    shouldKillRoshan = IsRoshanAlive()

    if shouldKillRoshan
    and aliveAlly >= aliveEnemy
    and healthPercentage > 0.3
    and HasEnoughDPSForRoshan(aliveHeroesList)
    then
        if (roshan ~= nil and (roshan:GetHealth() / roshan:GetMaxHealth()) < 0.3)
        or (#eCount >= #aCount and J.WeAreStronger(bot, 1600))
        then
           return 0.94
        end

        if (#aCount > #eCount and not J.WeAreStronger(bot, 1200)) then
            return 0.27
        end

        return 0.85
    end

    return BOT_ACTION_DESIRE_NONE
end

function Think()
    local timeOfDay, time = J.CheckTimeOfDay()
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
        or (J.IsCore(bot) and c:GetHealth() / c:GetMaxHealth() < 0.3))
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
        and h:GetActiveMode() == BOT_MODE_ROSHAN
        then
            table.insert(allyList, h)
        end
    end

    return HasEnoughDPSForRoshan(allyList)
end

function HasEnoughDPSForRoshan(heroes)
    local DPS = 0
    local DPSThreshold = 0
    local plannedTimeToKill = 60

    -- Roshan Stats
    local baseHealth = 6000
    local baseArmor = 30
    local armorPerInterval = 0.375
    local maxHealthBonusPerInterval = 130 * 2

    local roshanHealth = baseHealth + maxHealthBonusPerInterval * math.floor(DotaTime() / 60)

    for _, h in pairs(heroes) do
        local roshanArmor = baseArmor + armorPerInterval * math.floor(DotaTime() / 60) - J.GetArmorReducers(h)

        -- Only right click damage for now
        local attackDamage = h:GetAttackDamage()
        local attackSpeed = h:GetAttackSpeed()

        local dps = attackDamage * attackSpeed * (1 - roshanArmor / (roshanArmor + 20))
        DPS = DPS + dps
    end

    DPS =  DPS / #heroes

    DPSThreshold = roshanHealth / plannedTimeToKill
    -- print(bot:GetUnitName().." => DPS: ", DPS)
    -- print(bot:GetUnitName().." => DPSThreshold: ", DPSThreshold)
    return DPS >= DPSThreshold
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