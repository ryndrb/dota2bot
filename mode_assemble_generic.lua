-- was defaulting to this with the 7.41 patch
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')

local bot = GetBot()

local nLingerInterval = 5
local assemble = { location = nil, timeLinger = 0 }

function GetDesire()
    if not bot:IsAlive() then return BOT_MODE_DESIRE_NONE end

    local human, humanPing = J.GetHumanPing()
    if human ~= nil then
        if  humanPing ~= nil
        and humanPing.normal_ping
        and GetUnitToLocationDistance(bot, humanPing.location) > 500
        and GameTime() < humanPing.time + 5
        then
            local fTimeToReach = GetUnitToLocationDistance(bot, humanPing.location) / bot:GetCurrentMovementSpeed()
            if fTimeToReach <= 10 then
                assemble.location = humanPing.location
                assemble.timeLinger = GameTime()
                return BOT_MODE_DESIRE_VERYHIGH + 0.01
            end
        end
    end

    if assemble.location and GameTime() < assemble.timeLinger + nLingerInterval then
        return BOT_MODE_DESIRE_VERYHIGH + 0.01
    end

    return BOT_MODE_DESIRE_NONE
end

function OnEnd()
    assemble.location = nil
    assemble.timeLinger = 0
end

local fNextMovementTime = -math.huge
function Think()
    if J.CanNotUseAction(bot) then return end

    if assemble.location then
        if DotaTime() >= fNextMovementTime then
            bot:Action_MoveToLocation(assemble.location + RandomVector(100))
            fNextMovementTime = DotaTime() + RandomFloat(0.3, 0.9)
            return
        end
    end
end
