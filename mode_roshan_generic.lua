local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )

local bEnoughDPS = false
local bRoshanAlive = false
local bRoshanTime = false
local fRoshanAliveTime = 0

function GetDesire()
    local aliveAlly = J.GetNumOfAliveHeroes(false)
    local aliveEnemy = J.GetNumOfAliveHeroes(true)
    local hasSameOrMoreHero = aliveAlly >= aliveEnemy
    local botTarget = J.GetProperTarget(bot)

    local nAllyHeroes_Alive = {}
    for i = 1, 5 do
        local member = GetTeamMember(i)
        if J.IsValidHero(member) then
            table.insert(nAllyHeroes_Alive, member)
        end
    end

    bRoshanAlive = J.IsRoshanAlive()

    if bRoshanAlive then
        if not bRoshanTime then
            fRoshanAliveTime = DotaTime()
            bRoshanTime = true
        end
    else
        fRoshanAliveTime = 0
        bRoshanTime = false
    end

    if J.HasEnoughDPSForRoshan(nAllyHeroes_Alive) then
        bEnoughDPS = true
    end

    if bRoshanAlive and bEnoughDPS then
        local vRoshanLocation = J.GetCurrentRoshanLocation()
        local mul = RemapValClamped(DotaTime(), fRoshanAliveTime, fRoshanAliveTime + (2.5 * 60), 1, 2)
        local nRoshanDesire = RemapValClamped(GetRoshanDesire() * mul, 0, 1, 0, BOT_MODE_DESIRE_ABSOLUTE)

        local human, humanPing = J.GetHumanPing()
        if human ~= nil and DotaTime() > 5.0 then
            if humanPing ~= nil
            and humanPing.normal_ping
            and GetUnitToLocationDistance(human, vRoshanLocation) <= 1200
            and J.GetDistance(humanPing.location, vRoshanLocation) <= 600
            and GameTime() < humanPing.time + 5.0
            then
                return BOT_MODE_DESIRE_VERYHIGH
            end
        end

        local nInRangeAlly = J.GetAlliesNearLoc(vRoshanLocation, 1000)
        if #nInRangeAlly >= 4 then
            nRoshanDesire = 0.9
        end

        return Clamp(nRoshanDesire, 0, BOT_MODE_DESIRE_VERYHIGH)
    end

    return BOT_MODE_DESIRE_NONE
end

local function IsStrongEnough(nUnitList, hRoshan)
    local damage = 0
    for _, hero in pairs(nUnitList) do
        if J.IsValidHero(hero) then
            damage = damage + hero:GetEstimatedDamageToTarget(true, hRoshan, 30, DAMAGE_TYPE_PHYSICAL)
        end
    end

    return damage > hRoshan:GetHealth() + 300
end

local vMid = (J.GetTeamFountain() + J.GetEnemyFountain()) / 2
local fNextMovementTime = -math.huge
function Think()
    if J.CanNotUseAction(bot) then return end

    local vLocation = J.GetCurrentRoshanLocation()
    local nNeutralCreeps = bot:GetNearbyNeutralCreeps(800)

    for _, creep in pairs(nNeutralCreeps) do
        if J.IsValid(creep) and J.IsRoshan(creep) then
            if creep:GetAttackTarget() == bot and creep:GetAttackDamage() * 4 > bot:GetHealth() then
                bot:Action_MoveToLocation(vMid)
                return
            end

            if J.CanBeAttacked(creep) then
                local nInRangeAlly = J.GetAlliesNearLoc(vLocation, 1400)
                if IsStrongEnough(nInRangeAlly, creep)
                or #nInRangeAlly >= 4
                then
                    if GetUnitToLocationDistance(bot, vLocation) <= 175 then
                        bot:Action_AttackUnit(creep, true)
                        return
                    end
                else
                    if creep:GetAttackTarget() == bot then
                        bot:Action_MoveToLocation(vMid)
                        return
                    end
                end
            end
        end
    end

    if DotaTime() >= fNextMovementTime then
        bot:Action_MoveToLocation(vLocation + RandomVector(50))
        fNextMovementTime = DotaTime() + RandomFloat(1, 3)
        return
    end
end
