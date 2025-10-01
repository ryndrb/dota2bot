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
        local nRoshanDesire = GetRoshanDesire() * mul

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

        return Clamp(nRoshanDesire, 0, 0.9)
    end

    return BOT_MODE_DESIRE_NONE
end

function IsEnoughAllies()
    return J.HasEnoughDPSForRoshan(J.GetAlliesNearLoc(J.GetCurrentRoshanLocation(), 1600))
end
