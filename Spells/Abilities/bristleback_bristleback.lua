local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local Bristleback

function X.Cast()
    bot = GetBot()
    Bristleback = bot:GetAbilityByName('bristleback_bristleback')

    Desire, Location = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(Bristleback, Location)
        return
    end
end

function X.Consider()
    if Bristleback:IsPassive()
    or not Bristleback:IsTrained()
	or not Bristleback:IsFullyCastable()
	then
		return BOT_ACTION_DESIRE_NONE, 0
	end

    local botTarget = J.GetProperTarget( bot )

    local nEnemyHeroes = bot:GetNearbyHeroes(350, true, BOT_MODE_NONE)

	if J.IsGoingOnSomeone( bot )
	then
		if J.IsValidHero( botTarget )
        and J.CanBeAttacked(botTarget)
		and J.IsInRange( bot, botTarget, 350 )
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

	if J.IsRetreating( bot )
    and not J.IsRealInvisible(bot)
	then
        if J.IsValidHero(nEnemyHeroes[1])
        and (bot:GetActiveModeDesire() > 0.7 and bot:WasRecentlyDamagedByAnyHero(2))
        and J.CanBeAttacked(nEnemyHeroes[1])
		and J.IsInRange( bot, nEnemyHeroes[1], 350 )
        and not nEnemyHeroes[1]:HasModifier('modifier_abaddon_borrowed_time')
        and not nEnemyHeroes[1]:HasModifier('modifier_dazzle_shallow_grave')
        and not nEnemyHeroes[1]:HasModifier('modifier_necrolyte_reapers_scythe')
        then
            return BOT_ACTION_DESIRE_HIGH, nEnemyHeroes[1]:GetLocation()
        end
	end

    if J.IsDoingRoshan(bot)
	then
		if J.IsRoshan( botTarget )
        and not botTarget:IsInvulnerable()
        and J.IsInRange( bot, botTarget, 350 )
        and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

    if J.IsDoingTormentor(bot)
	then
		if J.IsTormentor( botTarget )
        and J.IsInRange( bot, botTarget, 350 )
        and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

return X