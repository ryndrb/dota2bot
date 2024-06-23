local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local Blink

function X.Cast()
	bot = GetBot()
	Blink = bot:GetAbilityByName('antimage_blink')

	Desire, Location = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(Blink, Location)
		return
    end
end

function X.Consider()
    if not Blink:IsFullyCastable()
	or bot:IsRooted()
	or bot:HasModifier('modifier_bloodseeker_rupture')
	then return BOT_ACTION_DESIRE_NONE end

    local _, CounterSpell = J.HasAbility(bot, 'antimage_counterspell')
	local nCastRange = Blink:GetSpecialValueInt('AbilityCastRange') - 1
	local nCastPoint = Blink:GetCastPoint()
	local nAttackPoint = bot:GetAttackPoint()
    local botTarget = J.GetProperTarget(bot)

	local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
	local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(1600, true)

	if J.IsStuck(bot)
	then
		local loc = J.GetEscapeLoc()
		return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, loc, nCastRange)
	end

	if (J.IsStunProjectileIncoming(bot, 600) or J.IsUnitTargetProjectileIncoming(bot, 400))
	and CounterSpell ~= nil and not CounterSpell:IsFullyCastable()
    then
        return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, J.GetTeamFountain(), nCastRange)
    end

	if  not bot:HasModifier('modifier_sniper_assassinate')
	and not bot:IsMagicImmune()
	and CounterSpell ~= nil and not CounterSpell:IsFullyCastable()
	then
		if J.IsWillBeCastUnitTargetSpell(bot, 400)
		then
			return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, J.GetTeamFountain(), nCastRange)
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
		and J.CanCastOnMagicImmune(botTarget)
		and not J.IsInRange(bot, botTarget, 400)
		and not botTarget:IsAttackImmune()
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			local nInRangeAlly = botTarget:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
			local nInRangeEnemy = botTarget:GetNearbyHeroes(1600, false, BOT_MODE_NONE)

			if  nInRangeAlly ~= nil and nInRangeEnemy ~= nil
			and #nInRangeAlly >= #nInRangeEnemy
			then
				local targetLoc = botTarget:GetExtrapolatedLocation(nCastPoint + 0.53)

				if GetUnitToUnitDistance(bot, botTarget) > nCastRange
				then
					targetLoc = J.Site.GetXUnitsTowardsLocation(bot, botTarget:GetLocation(), nCastRange)
				end

				if J.IsInLaningPhase()
				then
					local nEnemysTowers = botTarget:GetNearbyTowers(700, false)
					if nEnemysTowers ~= nil and #nEnemysTowers == 0
					or (bot:GetHealth() > J.GetTotalEstimatedDamageToTarget(nInRangeEnemy, bot)
						and J.WillKillTarget(botTarget, bot:GetAttackDamage() * 3, DAMAGE_TYPE_PHYSICAL, 2))
					then
						bot:SetTarget(botTarget)
						return BOT_ACTION_DESIRE_HIGH, targetLoc
					end
				else
					bot:SetTarget(botTarget)
					return BOT_ACTION_DESIRE_HIGH, targetLoc
				end
			end
		end
	end

	if J.IsRetreating(bot)
	and not J.IsRealInvisible(bot)
	then
		for _, enemyHero in pairs(nEnemyHeroes)
        do
			if  J.IsValidHero(enemyHero)
			and bot:GetActiveModeDesire() > 0.5
			and bot:DistanceFromFountain() > 600
			and not J.IsSuspiciousIllusion(enemyHero)
			and not J.IsDisabled(enemyHero)
			and (bot:WasRecentlyDamagedByHero(enemyHero, 1.5) or (J.GetHP(bot) < 0.5 and J.IsChasingTarget(enemyHero, bot)))
			then
				return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, J.GetTeamFountain(), nCastRange)
			end
        end
	end

	if J.IsLaning(bot)
	then
		for _, creep in pairs(nEnemyLaneCreeps)
		do
			if  J.IsValid(creep)
			and J.CanBeAttacked(creep)
			and (J.IsKeyWordUnit('ranged', creep) or J.IsKeyWordUnit('siege', creep) or J.IsKeyWordUnit('flagbearer', creep))
			and GetUnitToUnitDistance(bot, creep) > 500
			then
				local nCreepInRangeHero = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
				local nCreepInRangeTower = bot:GetNearbyTowers(700, true)
				local nDamage = bot:GetAttackDamage()

				if  J.WillKillTarget(creep, nDamage, DAMAGE_TYPE_PHYSICAL, nCastPoint + nAttackPoint + 0.53)
				and nCreepInRangeHero ~= nil and #nCreepInRangeHero == 0
				and nCreepInRangeTower ~= nil and #nCreepInRangeTower == 0
				and botTarget ~= creep
				then
					bot:SetTarget(creep)
					return BOT_ACTION_DESIRE_HIGH, creep:GetLocation()
				end
			end
		end

		local nInRangeTower = bot:GetNearbyTowers(1600, true)
		if  J.GetManaAfter(Blink:GetManaCost()) > 0.85
		and J.IsInLaningPhase()
		and bot:DistanceFromFountain() > 300
		and bot:DistanceFromFountain() < 6000
		and nEnemyHeroes ~= nil and #nEnemyHeroes == 0
		and nInRangeTower ~= nil and #nInRangeTower == 0
		then
			local nLane = bot:GetAssignedLane()
			local nLaneFrontLocation = GetLaneFrontLocation(GetTeam(), nLane, 0)
			local nDistFromLane = GetUnitToLocationDistance(bot, nLaneFrontLocation)

			if nDistFromLane > nCastRange
			then
				local nLocation = J.Site.GetXUnitsTowardsLocation(bot, nLaneFrontLocation, nCastRange)
				if IsLocationPassable(nLocation)
				then
					return BOT_ACTION_DESIRE_HIGH, nLocation
				end
			end
		end
	end

	if  J.IsPushing(bot)
	and bot:GetActiveModeDesire() > BOT_MODE_DESIRE_HIGH
	then
        local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), 600)
        local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1200)
		local nEnemyTowers = bot:GetNearbyTowers(1600, true)

		if  nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 3
        and nInRangeEnemy ~= nil and #nInRangeEnemy == 0
        and nInRangeAlly ~= nil and #nInRangeAlly <= 1
		and GetUnitToLocationDistance(bot, J.GetCenterOfUnits(nEnemyLaneCreeps)) > bot:GetAttackRange()
        and J.CanBeAttacked(nEnemyLaneCreeps[1])
		and nEnemyTowers ~= nil
		and (#nEnemyTowers == 0 or (J.IsValidBuilding(nEnemyTowers[1]) and J.IsValid(nEnemyLaneCreeps[#nEnemyLaneCreeps]) and GetUnitToUnitDistance(nEnemyTowers[1], nEnemyLaneCreeps[#nEnemyLaneCreeps]) > 700))
		then
			return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nEnemyLaneCreeps)
		end

        nInRangeEnemy = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
		if bot.laneToPush ~= nil
		then
			if  J.GetManaAfter(Blink:GetManaCost()) > 0.5
			and nInRangeEnemy ~= nil and #nInRangeEnemy == 0
			and nEnemyTowers ~= nil and #nEnemyTowers == 0
			and GetUnitToLocationDistance(bot, GetLaneFrontLocation(GetTeam(), bot.laneToPush, 0)) > nCastRange
			and bot:IsFacingLocation(GetLaneFrontLocation(GetTeam(), bot.laneToPush, 0), 30)
			then
				return  BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, GetLaneFrontLocation(GetTeam(), bot.laneToPush, 0), nCastRange)
			end
		end
	end

	if  J.IsDefending(bot)
	and bot:GetActiveModeDesire() > BOT_MODE_DESIRE_HIGH
	then
        local nInRangeEnemy = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
		if bot.laneToDefend ~= nil
		then
			if  J.GetManaAfter(Blink:GetManaCost()) > 0.5
			and nInRangeEnemy ~= nil and #nInRangeEnemy == 0
			and GetUnitToLocationDistance(bot, GetLaneFrontLocation(GetTeam(), bot.laneToDefend, 0)) > nCastRange
			and bot:IsFacingLocation(GetLaneFrontLocation(GetTeam(), bot.laneToDefend, 0), 30)
			then
				return  BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, GetLaneFrontLocation(GetTeam(), bot.laneToDefend, 0), nCastRange)
			end
		end
	end

	if J.IsDoingRoshan(bot)
    then
		local RoshanLocation = J.GetCurrentRoshanLocation()
        if GetUnitToLocationDistance(bot, RoshanLocation) > nCastRange
        then
			local targetLoc = J.Site.GetXUnitsTowardsLocation(bot, RoshanLocation, nCastRange)
			local nInRangeEnemy = J.GetEnemiesNearLoc(RoshanLocation, 1600)

			if  nInRangeEnemy ~= nil and #nInRangeEnemy == 0
			and IsLocationPassable(targetLoc)
			then
				return BOT_ACTION_DESIRE_HIGH, targetLoc
			end
        end
    end

    if J.IsDoingTormentor(bot)
    then
		local TormentorLocation = J.GetTormentorLocation(GetTeam())
        if GetUnitToLocationDistance(bot, TormentorLocation) > nCastRange
        then
			local targetLoc = J.Site.GetXUnitsTowardsLocation(bot, TormentorLocation, nCastRange)
			local nInRangeEnemy = J.GetEnemiesNearLoc(targetLoc, 1600)

			if  nInRangeEnemy ~= nil and #nInRangeEnemy == 0
			and IsLocationPassable(targetLoc)
			then
				return BOT_ACTION_DESIRE_HIGH, targetLoc
			end

        end
    end

	return BOT_ACTION_DESIRE_NONE
end

return X