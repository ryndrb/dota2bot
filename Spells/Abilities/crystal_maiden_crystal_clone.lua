local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local CrystalClone

function X.Cast()
    bot = GetBot()
    CrystalClone = bot:GetAbilityByName('crystal_maiden_crystal_clone')

    Desire, Location = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(CrystalClone, Location)
        return
    end
end

function X.Consider()
    if not CrystalClone:IsTrained()
	or not CrystalClone:IsFullyCastable()
	then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nRadius = 450
	local botTarget = J.GetProperTarget(bot)

	if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
        and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nRadius)
		and J.CanCastOnNonMagicImmune(botTarget)
		then
            return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, J.GetTeamFountain(), nRadius)
		end
	end

    if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
    then
        local nInRangeEnemy = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

        if J.IsValidHero(nInRangeEnemy[1])
        and bot:WasRecentlyDamagedByAnyHero(4)
        and J.IsInRange(bot, nInRangeEnemy[1], nRadius)
        and not J.IsSuspiciousIllusion(nInRangeEnemy[1])
        then
            return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, J.GetTeamFountain(), nRadius)
        end
    end

	return BOT_ACTION_DESIRE_NONE, 0
end

return X