local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local WallOfReplica

function X.Cast()
    bot = GetBot()
    WallOfReplica = bot:GetAbilityByName('dark_seer_wall_of_replica')

    Desire, Location = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(WallOfReplica, Location)
        return
    end
end

function X.Consider()
	if not WallOfReplica:IsFullyCastable()
	then
		return BOT_ACTION_DESIRE_NONE, 0
	end

    local _, Vacuum = J.HasAbility(bot, 'dark_seer_vacuum')
	local nCastRange = J.GetProperCastRange(false, bot, WallOfReplica:GetCastRange())
	local nCastPoint = WallOfReplica:GetCastPoint() + 0.73
	local nRadius = nCastRange / 2

    if Vacuum ~= nil then nRadius = Vacuum:GetSpecialValueInt('radius') end

	if J.IsInTeamFight(bot, 1200)
	then
        local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, nCastPoint, 0)
        local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)

        if nInRangeEnemy ~= nil and #nInRangeEnemy >= 2
        then
            return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nInRangeEnemy)
        end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

return X