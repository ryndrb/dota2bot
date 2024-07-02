local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local Magnetize

function X.Cast()
    bot = GetBot()
    Magnetize = bot:GetAbilityByName('earth_spirit_magnetize')

    Desire = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(Magnetize)
		return
    end
end

function X.Consider()
    if not Magnetize:IsFullyCastable()
	then
		return BOT_ACTION_DESIRE_NONE
	end

	local nRadius = Magnetize:GetSpecialValueInt('cast_radius')
	local botTarget = J.GetProperTarget(bot)

    local nEnemyHeroes = J.GetEnemiesNearLoc(bot:GetLocation(), nRadius)


	if J.IsInTeamFight(bot, 1200)
	then
		if #nEnemyHeroes >= 2
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.IsInRange(bot, botTarget, nRadius)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
	then
        for _, enemyHero in pairs(nEnemyHeroes)
        do
            if #nEnemyHeroes >= 2
            and bot:WasRecentlyDamagedByAnyHero(3)
            and bot:GetActiveModeDesire() > 0.8
            and J.GetHP(bot) < 0.4
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanBeAttacked(enemyHero)
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
	end

	return BOT_ACTION_DESIRE_NONE
end

return X