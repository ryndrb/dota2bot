local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local CallOfTheWildHawk

function X.Cast()
    bot = GetBot()
    CallOfTheWildHawk = bot:GetAbilityByName('beastmaster_call_of_the_wild_hawk')

    Desire = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(CallOfTheWildHawk)
        return
    end
end

function X.Consider()
    if not CallOfTheWildHawk:IsFullyCastable()
    then
		return BOT_ACTION_DESIRE_NONE
	end

    local botTarget = J.GetProperTarget(bot)

    local nInRangeEnemy = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    if J.IsInTeamFight(bot, 1200)
    then
        local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), 500, 500, 0, 0)
        if nLocationAoE.count >= 2
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, 450)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
        and botTarget:GetHealth() <= bot:GetEstimatedDamageToTarget(true, botTarget, 5.0, DAMAGE_TYPE_ALL)
		then
            return BOT_ACTION_DESIRE_HIGH
		end
	end

    if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
    then
        for _, enemyHero in pairs(nInRangeEnemy)
        do
            if (bot:GetActiveModeDesire() > 0.58 or bot:WasRecentlyDamagedByAnyHero(1))
            and J.IsValidHero(enemyHero)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.IsInRange(bot, enemyHero, 450)
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    end

	return BOT_ACTION_DESIRE_NONE
end

return X