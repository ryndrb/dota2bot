local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local Firefly

function X.Cast()
    bot = GetBot()
    Firefly = bot:GetAbilityByName('batrider_firefly')

    Desire, Location = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(Firefly)
        return
    end
end

function X.Consider()
    if not Firefly:IsFullyCastable()
    then
        return BOT_ACTION_DESIRE_NONE
    end

    local botTarget = J.GetProperTarget(bot)
    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    if J.IsStuck(bot)
    then
        return BOT_ACTION_DESIRE_HIGH
    end

    if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, 800)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
            if J.IsInRange(bot, botTarget, 200)
            or (J.IsValidHero(nEnemyHeroes[1]) and J.IsInRange(bot, nEnemyHeroes[1], 200))
            then
                return BOT_ACTION_DESIRE_HIGH
            end
		end

        if J.IsInTeamFight(bot, 1200)
        then
            return BOT_ACTION_DESIRE_HIGH
        end
	end

    if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
    then
        if (bot:GetActiveModeDesire() > 0.85 or bot:WasRecentlyDamagedByAnyHero(1))
        and J.IsValidHero(nEnemyHeroes[1])
        and J.CanCastOnNonMagicImmune(nEnemyHeroes[1])
        and J.IsInRange(bot, nEnemyHeroes[1], 400)
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

return X