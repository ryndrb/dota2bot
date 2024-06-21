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
	local nCastRange = UnstableConcoctionThrow:GetCastRange()
	local nDamage = 150
    if UnstableConcoction ~= nil
    then
        nDamage = UnstableConcoction:GetSpecialValueInt("max_damage")
    end

	local nEnemyHeroes = bot:GetNearbyHeroes(nCastRange, true, BOT_MODE_NONE)
	for _, enemyHero in pairs(nEnemyHeroes)
	do
		if  J.IsValidHero(enemyHero)
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
			and not enemyHero:HasModifier('modifier_abaddon_aphotic_shield')
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
		local nInRangeAlly = bot:GetNearbyHeroes(1000, false, BOT_MODE_NONE)
		local nInRangeEnemy = bot:GetNearbyHeroes(nCastRange - 175, true, BOT_MODE_NONE)

		for _, enemyHero in pairs(nInRangeEnemy)
		do
			if  J.IsValidTarget(enemyHero)
			and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
			and not J.IsDisabled(enemyHero)
			and not enemyHero:HasModifier('modifier_enigma_black_hole_pull')
			and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
			and not enemyHero:HasModifier('modifier_legion_commander_duel')
			and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			and DotaTime() >= bot.ConcoctionThrowTime + offDuration
			then
				local nTargetInRangeAlly = enemyHero:GetNearbyHeroes(1000, false, BOT_MODE_NONE)

				if  nInRangeAlly ~= nil and nTargetInRangeAlly ~= nil
				and #nInRangeAlly >= #nTargetInRangeAlly
				then
					return BOT_ACTION_DESIRE_HIGH, enemyHero
				end
			end
		end
	end

	if J.IsRetreating(bot)
	then
		local nInRangeAlly = bot:GetNearbyHeroes(800, false, BOT_MODE_NONE)
		local nInRangeEnemy = bot:GetNearbyHeroes(1000, true, BOT_MODE_NONE)

		if  nInRangeAlly ~= nil and nInRangeEnemy ~= nil
		and J.IsValidHero(nInRangeEnemy[1])
		and J.CanCastOnNonMagicImmune(nInRangeEnemy[1])
        and J.CanCastOnTargetAdvanced(nInRangeEnemy[1])
		and J.IsInRange(bot, nInRangeEnemy[1], nCastRange)
		and not nInRangeEnemy[1]:HasModifier('modifier_enigma_black_hole_pull')
		and not nInRangeEnemy[1]:HasModifier('modifier_faceless_void_chronosphere_freeze')
		and not nInRangeEnemy[1]:HasModifier('modifier_necrolyte_reapers_scythe')
		and DotaTime() >= bot.ConcoctionThrowTime + defDuration
		then
			local nTargetInRangeAlly = nInRangeEnemy[1]:GetNearbyHeroes(800, false, BOT_MODE_NONE)

            if  nTargetInRangeAlly ~= nil
            and ((#nTargetInRangeAlly > #nInRangeAlly)
                or (J.GetHP(bot) < 0.6 and bot:WasRecentlyDamagedByAnyHero(2.2)))
            then
                return BOT_ACTION_DESIRE_HIGH, nInRangeEnemy[1]
            end
		end
	end

	if  nEnemyHeroes ~= nil and #nEnemyHeroes >= 1
	and DotaTime() >= bot.ConcoctionThrowTime + defDuration
	then
		return BOT_ACTION_DESIRE_HIGH, nEnemyHeroes[1]
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

return X