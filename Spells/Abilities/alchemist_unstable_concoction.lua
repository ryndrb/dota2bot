local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local UnstableConcoction

function X.Cast()
	bot = GetBot()
	UnstableConcoction = bot:GetAbilityByName('alchemist_unstable_concoction')

	if bot.ConcoctionThrowTime == nil then bot.ConcoctionThrowTime = 0 end

	Desire = X.Consider()
    if Desire > 0
	then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbility(UnstableConcoction)
		bot.ConcoctionThrowTime = DotaTime()
		return
	end
end

function X.Consider()
    if not UnstableConcoction:IsFullyCastable()
	then
		return BOT_ACTION_DESIRE_NONE
	end

	local nCastRange = UnstableConcoction:GetCastRange()
	local nDamage = UnstableConcoction:GetSpecialValueInt('max_damage')

	local nEnemyHeroes = bot:GetNearbyHeroes(nCastRange, true, BOT_MODE_NONE)
	for _, enemyHero in pairs(nEnemyHeroes)
	do
		if  J.IsValidHero(enemyHero)
		and J.CanCastOnNonMagicImmune(enemyHero)
		and J.IsInRange(bot, enemyHero, nCastRange - 200)
		then
			if enemyHero:IsChanneling()
			then
				return BOT_ACTION_DESIRE_HIGH
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
				return BOT_ACTION_DESIRE_HIGH
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
			and not J.IsDisabled(enemyHero)
			and not enemyHero:HasModifier('modifier_enigma_black_hole_pull')
			and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
			and not enemyHero:HasModifier('modifier_legion_commander_duel')
			and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
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
		local nInRangeAlly = bot:GetNearbyHeroes(nCastRange + 175, false, BOT_MODE_NONE)
		local nInRangeEnemy = bot:GetNearbyHeroes(nCastRange, true, BOT_MODE_NONE)

		if  nInRangeAlly ~= nil and nInRangeEnemy ~= nil
		and J.IsValidHero(nInRangeEnemy[1])
		and J.CanCastOnNonMagicImmune(nInRangeEnemy[1])
		and J.IsInRange(bot, nInRangeEnemy[1], nCastRange - 175)
		and J.IsRunning(nInRangeEnemy[1])
        and nInRangeEnemy[1]:IsFacingLocation(bot:GetLocation(), 30)
		and not J.IsDisabled(nInRangeEnemy[1])
		and not nInRangeEnemy[1]:HasModifier('modifier_enigma_black_hole_pull')
		and not nInRangeEnemy[1]:HasModifier('modifier_faceless_void_chronosphere_freeze')
		and not nInRangeEnemy[1]:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			local nTargetInRangeAlly = nInRangeEnemy[1]:GetNearbyHeroes(800, false, BOT_MODE_NONE)

            if  nTargetInRangeAlly ~= nil
            and ((#nTargetInRangeAlly > #nInRangeAlly)
                or (J.GetHP(bot) < 0.6 and bot:WasRecentlyDamagedByAnyHero(2.2)))
            then
                return BOT_ACTION_DESIRE_HIGH
            end
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

return X