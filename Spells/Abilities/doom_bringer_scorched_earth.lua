local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local ScorchedEarth

function X.Cast()
    bot = GetBot()
    ScorchedEarth = bot:GetAbilityByName('doom_bringer_scorched_earth')

    Desire = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(ScorchedEarth)
        return
    end
end

function X.Consider()
    if not ScorchedEarth:IsFullyCastable()
    then
        return BOT_ACTION_DESIRE_NONE
    end

    local nRadius = ScorchedEarth:GetSpecialValueInt('radius')
    local botTarget = J.GetProperTarget(bot)

    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
    local nCreeps = bot:GetNearbyCreeps(nRadius, true)

    if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nRadius + 150)
        and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
		then
            return BOT_ACTION_DESIRE_HIGH
		end
	end

    if  J.IsRetreating(bot)
    and bot:GetActiveModeDesire() >= 0.75
    and not J.IsRealInvisible(bot)
	then
        if  J.IsValidHero(nEnemyHeroes[1])
        and J.IsInRange(bot, nEnemyHeroes[1], nRadius + 150)
        and J.IsChasingTarget(nEnemyHeroes[1], bot)
        and not J.IsSuspiciousIllusion(nEnemyHeroes[1])
        then
            return BOT_ACTION_DESIRE_HIGH
        end
	end

    if J.IsFarming(bot)
	then
        if  nCreeps ~= nil
        and J.CanBeAttacked(nCreeps[1])
        and (#nCreeps >= 3 or (#nCreeps >= 2 and nCreeps[1]:IsAncientCreep()))
        and J.IsAttacking(bot)
        and J.GetManaAfter(ScorchedEarth:GetManaCost()) > 0.4
        then
            return BOT_ACTION_DESIRE_HIGH
        end
	end

    if J.IsDoingRoshan(bot)
	then
		if  J.IsRoshan(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        and J.GetHP(bot) > 0.2
        and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

    if J.IsDoingTormentor(bot)
    then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

return X