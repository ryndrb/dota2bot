local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local SparkWraith

function X.Cast()
    bot = GetBot()
    SparkWraith = bot:GetAbilityByName('arc_warden_spark_wraith')

    Desire, Location = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(SparkWraith, Location)
        return
    end
end

function X.Consider()
    if not SparkWraith:IsFullyCastable() then return BOT_ACTION_DESIRE_NONE, 0 end

	local nCastRange = J.GetProperCastRange(false, bot, SparkWraith:GetCastRange())
	local nRadius = SparkWraith:GetSpecialValueInt('radius')
	local nDamage = SparkWraith:GetSpecialValueInt('spark_damage')
	local nCastPoint = SparkWraith:GetCastPoint()
	local nDelay = SparkWraith:GetSpecialValueInt('activation_delay') + nCastPoint
    local botTarget = J.GetProperTarget(bot)

	local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
	local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(1600, true)

	for _, enemyHero in pairs(nEnemyHeroes)
	do
		if  J.IsValidHero(enemyHero)
		and J.IsInRange(bot, enemyHero, nCastRange)
		and J.CanCastOnNonMagicImmune(enemyHero)
		and J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
		and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
        and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
		then
			return BOT_ACTION_DESIRE_HIGH, enemyHero:GetExtrapolatedLocation(nDelay)
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidHero(botTarget)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
		and not botTarget:HasModifier('modifier_item_aeon_disk_buff')
		then
			if J.IsRunning(botTarget)
			then
				return BOT_ACTION_DESIRE_MODERATE, botTarget:GetExtrapolatedLocation(nDelay)
			else
				return BOT_ACTION_DESIRE_MODERATE, botTarget:GetLocation()
			end
		end

		local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), 1400, nRadius, 2, 0)
		local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)

		if  nInRangeEnemy ~= nil and #nInRangeEnemy >= 1
		and J.GetManaAfter(SparkWraith:GetManaCost()) > 0.68
		and not bot:HasModifier('modifier_silencer_curse_of_the_silent')
		then
			local nCreep = J.GetVulnerableUnitNearLoc( bot, false, true, 1600, nRadius, nLocationAoE.targetloc )
			if nCreep == nil
			or bot:HasModifier('modifier_arc_warden_tempest_double')
			then
				return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
			end
		end
	end

	if  J.IsRetreating(bot)
	and bot:GetActiveModeDesire() > BOT_ACTION_DESIRE_HIGH
	and not J.IsRealInvisible(bot)
	and not bot:HasModifier('modifier_silencer_curse_of_the_silent')
	then
		for _, enemyHero in pairs(nEnemyHeroes)
		do
			if  J.IsValid(enemyHero)
			and J.IsInRange(bot, enemyHero, 800)
			and bot:WasRecentlyDamagedByHero(enemyHero, 1)
			and J.CanCastOnNonMagicImmune(enemyHero)
			then
				return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
			end
		end
	end

	if J.IsFarming(bot)
	or J.IsPushing(bot)
	or J.IsDefending(bot)
	then
		if nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 2
		and J.CanBeAttacked(nEnemyLaneCreeps[1])
		and not J.IsRunning(nEnemyLaneCreeps[1])
		and not bot:HasModifier('modifier_silencer_curse_of_the_silent')
		then
			if bot:HasModifier('modifier_arc_warden_tempest_double')
			then
				return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nEnemyLaneCreeps)
			end

			if J.GetMP(bot) > 0.62
			then
				return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nEnemyLaneCreeps)
			end
		end
	end

	if  J.IsLaning(bot)
	and J.IsInLaningPhase()
    and bot:GetLevel() < 7
	then
		for _, creep in pairs(nEnemyLaneCreeps)
		do
			if  J.IsValid(creep)
            and J.CanBeAttacked(creep)
			and J.IsKeyWordUnit('ranged', creep)
			and creep:GetHealth() <= nDamage
			and botTarget ~= creep
			and not J.IsRunning(creep)
			then
				return BOT_ACTION_DESIRE_HIGH, creep:GetLocation()
			end
		end
	end

	if  SparkWraith:GetLevel() >= 3
	and J.GetManaAfter(SparkWraith:GetManaCost()) > 0.66
	and not J.IsLaning(bot)
	then
		local nLocationAoE = bot:FindAoELocation( true, true, bot:GetLocation(), 1400, nRadius, 2, 0)
		local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)
		if nInRangeEnemy ~= nil and #nInRangeEnemy >= 2
		then
			return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nInRangeEnemy)
		end
	end

	if  bot:GetLevel() >= 10
	and ((J.GetManaAfter(SparkWraith:GetManaCost()) > 0.65)
		or bot:HasModifier('modifier_arc_warden_tempest_double'))
	and DotaTime() > 8 * 60
	then
		local nEnemysHerosCanSeen = GetUnitList(UNIT_LIST_ENEMY_HEROES)
		local nTargetHero = nil
		local nTargetHeroHealth = 99999
		for _, enemyHero in pairs( nEnemysHerosCanSeen )
		do
			if  J.IsValidHero(enemyHero)
			and GetUnitToUnitDistance(bot, enemyHero) <= nCastRange
			and enemyHero:GetHealth() < nTargetHeroHealth
			then
				nTargetHero = enemyHero
				nTargetHeroHealth = enemyHero:GetHealth()
			end
		end

		if nTargetHero ~= nil
		then
			for i = 0, 350, 50
			do
				local nCastLocation = J.GetLocationTowardDistanceLocation(nTargetHero, J.GetEnemyFountain(), 350 - i)
				if GetUnitToLocationDistance(bot, nCastLocation) <= nCastRange
				then
					return BOT_ACTION_DESIRE_HIGH, nCastLocation
				end
			end
		end

		if nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 3
		then
			local targetCreep = nEnemyLaneCreeps[#nEnemyLaneCreeps]
			if  J.IsValid(targetCreep)
			and J.CanBeAttacked(targetCreep)
			and not J.IsRunning(targetCreep)
			then
				local nCastLocation = J.GetFaceTowardDistanceLocation(targetCreep, 375)
				return BOT_ACTION_DESIRE_HIGH, nCastLocation
			end
		end

		local nEnemyLaneFront = J.GetNearestLaneFrontLocation(bot:GetLocation(), true, nRadius / 2)

		if  nEnemyHeroes ~= nil and #nEnemyHeroes == 0 and nEnemyLaneFront ~= nil
		and GetUnitToLocationDistance(bot, nEnemyLaneFront) <= nCastRange + nRadius
		and GetUnitToLocationDistance(bot, nEnemyLaneFront) >= 800
		then
			local nCastLocation = J.GetLocationTowardDistanceLocation( bot, nEnemyLaneFront, nCastRange )
			if GetUnitToLocationDistance(bot, nEnemyLaneFront) < nCastRange
			then
				nCastLocation = nEnemyLaneFront
			end

			return BOT_ACTION_DESIRE_HIGH, nCastLocation
		end
	end

	local nCastLocation = J.GetLocationTowardDistanceLocation(bot, J.GetEnemyFountain(), nCastRange)
	if bot:HasModifier('modifier_arc_warden_tempest_double')
	or (J.GetMP(bot) > 0.92 and bot:GetLevel() > 11 and not IsLocationVisible(nCastLocation))
	or (J.GetMP(bot) > 0.38 and J.GetDistanceFromEnemyFountain(bot) < 4300)
	then
		if  IsLocationPassable(nCastLocation)
		and not bot:HasModifier('modifier_silencer_curse_of_the_silent')
		then
			return BOT_ACTION_DESIRE_HIGH, nCastLocation
		end
	end

	if J.IsDoingRoshan(bot)
	then
		if  J.IsRoshan(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and J.GetHP(botTarget) > 0.2
		and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

	if J.IsDoingTormentor(bot)
	then
		if  J.IsTormentor(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and J.GetHP(botTarget) > 0.2
		and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

return X