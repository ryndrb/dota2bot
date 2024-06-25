local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local StaticStorm

function X.Cast()
    bot = GetBot()
    StaticStorm = bot:GetAbilityByName('disruptor_static_storm')

    Desire, Location = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(StaticStorm, Location)
        return
    end
end

function X.Consider()
    if not StaticStorm:IsFullyCastable()
	then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nRadius = StaticStorm:GetSpecialValueInt('radius')
	local nCastRange = J.GetProperCastRange(false, bot, StaticStorm:GetCastRange())

	if J.IsInTeamFight(bot, 1200)
	then
		local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
        local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius - 75)

		if  nInRangeEnemy ~= nil and #nInRangeEnemy >= 2
        and not J.IsLocationInChrono(nLocationAoE.targetloc)
        and not J.IsLocationInBlackHole(nLocationAoE.targetloc)
        then
            return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nInRangeEnemy)
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

return X