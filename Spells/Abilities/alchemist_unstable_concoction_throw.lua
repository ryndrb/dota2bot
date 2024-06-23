local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local UnstableConcoctionThrow

function X.Cast()
	bot = GetBot()
	UnstableConcoctionThrow = bot:GetAbilityByName('alchemist_unstable_concoction_throw')

	Desire, Target = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(UnstableConcoctionThrow, Target)
		return
    end
end

local defDuration = 2
local offDuration = 4.25

function X.Consider()
    if UnstableConcoctionThrow:IsHidden()
	or not UnstableConcoctionThrow:IsFullyCastable()
	then
		return BOT_ACTION_DESIRE_NONE, nil
	end

    local _, UnstableConcoction = J.HasAbility(bot, 'alchemist_unstable_concoction')
	local nCastRange = J.GetProperCastRange(false, bot, UnstableConcoctionThrow:GetCastRange())
	local nDamage = 150
    if UnstableConcoction ~= nil
    then
        nDamage = UnstableConcoction:GetSpecialValueInt("max_damage")
    end

	local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	for _, enemyHero in pairs(nEnemyHeroes)
	do
		if  J.IsValidHero(enemyHero)
		and J.IsInRange(bot, enemyHero, nCastRange)
		and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanCastOnTargetAdvanced(enemyHero)
		and DotaTime() >= bot.ConcoctionThrowTime + offDuration
		then
			if enemyHero:IsChanneling()
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
			end

			if  J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_PHYSICAL)
			and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
			and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
			and not enemyHero:HasModifier('modifier_enigma_black_hole_pull')
			and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
			and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
			and not enemyHero:HasModifier('modifier_item_solar_crest_armor_addition')
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
			end
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		for _, enemyHero in pairs(nEnemyHeroes)
		do
			if  J.IsValidTarget(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange - 150)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and J.CanCastOnTargetAdvanced(enemyHero)
			and not J.IsDisabled(enemyHero)
			and not enemyHero:HasModifier('modifier_enigma_black_hole_pull')
			and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
			and not enemyHero:HasModifier('modifier_legion_commander_duel')
			and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			and DotaTime() >= bot.ConcoctionThrowTime + offDuration
			then
				if bot:GetLevel() < 6
				then
					if enemyHero:GetHealth() <= bot:GetEstimatedDamageToTarget(true, enemyHero, 3.5, DAMAGE_TYPE_ALL)
					then
						return BOT_ACTION_DESIRE_HIGH, enemyHero
					end
				else
					return BOT_ACTION_DESIRE_HIGH, enemyHero
				end
			end
		end
	end

	if J.IsRetreating(bot)
	and not J.IsRealInvisible(bot)
	then
		for _, enemyHero in pairs(nEnemyHeroes)
		do
			if J.IsValidHero(enemyHero)
			and (bot:GetActiveModeDesire() > 0.7 and bot:WasRecentlyDamagedByHero(enemyHero, 1.5))
			and J.IsInRange(bot, enemyHero, nCastRange - 175)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and J.CanCastOnTargetAdvanced(enemyHero)
			and J.IsChasingTarget(enemyHero, bot)
			and not J.IsDisabled(enemyHero)
			and not enemyHero:HasModifier('modifier_enigma_black_hole_pull')
			and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
			and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			and DotaTime() >= bot.ConcoctionThrowTime + defDuration
			then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if  nEnemyHeroes ~= nil and #nEnemyHeroes >= 1
	and J.IsValidHero(nEnemyHeroes[1])
	and DotaTime() >= bot.ConcoctionThrowTime + defDuration
	then
		return BOT_ACTION_DESIRE_HIGH, nEnemyHeroes[1]
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

return X