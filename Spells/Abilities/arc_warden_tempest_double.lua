local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local TempestDouble

function X.Cast()
    bot = GetBot()
    TempestDouble = bot:GetAbilityByName('arc_warden_tempest_double')

    Desire, Location = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(TempestDouble, Location)
        return
    end
end

function X.Consider()
    X.UpdateDoubleStatus()

	if not TempestDouble:IsFullyCastable()
	then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastRange = J.GetProperCastRange(false, bot, TempestDouble:GetCastRange())
    local botTarget = J.GetProperTarget(bot)

	if J.IsDefending(bot) or J.IsPushing(bot) or J.IsFarming(bot)
	then
		local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps( 800, true )
		local nEnemyTowers = bot:GetNearbyTowers( 800, true )
		local nCreeps = bot:GetNearbyCreeps( 800, true )

		if J.IsAttacking(bot)
		then
			if (nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 2)
			or (nEnemyTowers ~= nil and #nEnemyTowers >= 1)
			or (nCreeps ~= nil and #nCreeps >= 2)
			then
				return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
			end
		end
	end

	if J.IsInTeamFight(bot, 1200)
	then
		local target = nil
		local hp = 0
		local nInRangeEnemy = bot:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
		for _, enemyHero in pairs(nInRangeEnemy)
		do
			if  J.IsValidHero(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange)
			and not J.IsSuspiciousIllusion(enemyHero)
			and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
			then
				local currHP = enemyHero:GetHealth()
				if hp < currHP
				then
					hp = currHP
					target = enemyHero
				end
			end
		end

		if target ~= nil
		then
			if J.IsRunning(target)
			then
				return BOT_ACTION_DESIRE_HIGH, target:GetLocation()
			else
				return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
			end
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidHero(botTarget)
		and J.IsInRange(bot, botTarget, 1600)
		and not J.IsSuspiciousIllusion(botTarget)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			local nInRangeAlly = botTarget:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
			local nInRangeEnemy = botTarget:GetNearbyHeroes(1600, false, BOT_MODE_NONE)

			if  nInRangeAlly ~= nil and nInRangeEnemy ~= nil
			and #nInRangeAlly + 1 >= #nInRangeEnemy
			then
				if botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
				then
					return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
				end

				if J.IsInRange(bot, botTarget, bot:GetAttackRange())
				then
					if J.IsRunning(botTarget)
					then
						return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
					else
						return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
					end
				end

				if not J.IsInRange(bot, botTarget, bot:GetAttackRange())
				then
					return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, botTarget:GetLocation(), nCastRange)
				end
			end
		end
	end

	local Midas = J.GetComboItem(bot, 'item_hand_of_midas')
	if  Midas ~= nil
	and X.IsDoubleMidasCooldown()
	and bot:DistanceFromFountain() > 600
	then
		local nCreeps = bot:GetNearbyCreeps(1600, true)
		if #nCreeps >= 1
		then
			return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
		end
	end

	if J.IsDoingRoshan(bot)
	then
		if  J.IsRoshan(botTarget)
		and J.IsInRange(bot, botTarget, bot:GetAttackRange())
		and J.GetHP(botTarget) > 0.5
		and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
		end
	end

	if J.IsDoingTormentor(bot)
	then
		if  J.IsTormentor(botTarget)
		and J.IsInRange(bot, botTarget, bot:GetAttackRange())
		and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

function X.IsDoubleMidasCooldown()
	if bot.TempestDouble == nil then X.UpdateDoubleStatus() end

	if bot.TempestDouble ~= nil
	then
		local Midas = J.GetComboItem(bot.TempestDouble, 'item_hand_of_midas')
		if  Midas ~= nil
		and (Midas:IsFullyCastable() or Midas:GetCooldownTimeRemaining() <= 3)
		then
			return true
		end
	end

	return false
end

function X.UpdateDoubleStatus()
	if  bot.TempestDouble == nil
	and bot:GetLevel() >= 6
	then
		for _, allyHero in pairs(GetUnitList(UNIT_LIST_ALLIED_HEROES))
		do
			if  allyHero ~= nil
			and allyHero:IsAlive()
			and allyHero:HasModifier('modifier_arc_warden_tempest_double')
			then
				bot.TempestDouble = allyHero
			end
		end
	end
end

return X