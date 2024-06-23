local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local ChemicalRage

function X.Cast()
	bot = GetBot()
	ChemicalRage = bot:GetAbilityByName('alchemist_chemical_rage')

	Desire = X.Consider()
	if Desire > 0
	then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbility(ChemicalRage)
		return
	end
end

function X.Consider()
    if not ChemicalRage:IsFullyCastable()
	then
		return BOT_ACTION_DESIRE_NONE
	end

	local botTarget = J.GetProperTarget(bot)

	local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
		and J.IsInRange(bot, botTarget, 800)
		and not J.IsSuspiciousIllusion(botTarget)
		and not botTarget:HasModifier('modifier_enigma_black_hole_pull')
		and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
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
			if (bot:GetActiveModeDesire() > 0.5 and J.GetHP(bot) < 0.35)
			and J.IsValidHero(enemyHero)
			and not J.IsSuspiciousIllusion(enemyHero)
			and not J.IsDisabled(enemyHero)
			and not enemyHero:HasModifier('modifier_enigma_black_hole_pull')
			and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
			and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if J.IsFarming(bot)
	then
		if  J.IsAttacking(bot)
		and J.IsValid(botTarget)
		and botTarget:IsCreep()
		and J.GetHP(bot) < 0.3
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsDoingRoshan(bot)
    then
        if  J.IsRoshan(botTarget)
        and J.IsInRange(bot, botTarget, 500)
        and J.IsAttacking(bot)
		and (J.IsModeTurbo() and DotaTime() < 15 * 60 or DotaTime() < 30 * 60)
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsDoingTormentor(bot)
    then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, 400)
        and J.IsAttacking(bot)
		and (J.IsModeTurbo() and DotaTime() < 16 * 60 or DotaTime() < 32 * 60)
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

	return BOT_ACTION_DESIRE_NONE
end

return X