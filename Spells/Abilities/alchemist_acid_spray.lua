local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local AcidSpray

function X.Cast()
	bot = GetBot()
	AcidSpray = bot:GetAbilityByName('alchemist_acid_spray')

	Desire, Location = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(AcidSpray, Location)
		return
    end
end

function X.Consider()
    if not AcidSpray:IsFullyCastable()
	then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastRange = AcidSpray:GetCastRange()
	local nCastPoint = AcidSpray:GetCastPoint()
	local nRadius = AcidSpray:GetSpecialValueInt('radius')
	local botTarget = J.GetProperTarget(bot)

	if J.IsInTeamFight(bot, 1200)
	then
		local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, nCastPoint, 0)
		if nLocationAoE.count >= 2
		then
			local realEnemyCount = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)
            if realEnemyCount ~= nil and #realEnemyCount >= 2
            then
                return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
            end
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and J.IsAttacking(botTarget)
		and botTarget:IsFacingLocation(bot:GetLocation(), 45)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
		then
            local nInRangeAlly = botTarget:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
			local nInRangeEnemy = botTarget:GetNearbyHeroes(1600, false, BOT_MODE_NONE)

            if  nInRangeAlly ~= nil and nInRangeEnemy ~= nil
            and #nInRangeAlly >= #nInRangeEnemy
            then
                return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
            end
		end
	end

	if J.IsRetreating(bot)
	then
		local nInRangeAlly = bot:GetNearbyHeroes(1000, false, BOT_MODE_NONE)
        local nInRangeEnemy = bot:GetNearbyHeroes(1000, true, BOT_MODE_NONE)

        if  nInRangeAlly ~= nil and nInRangeEnemy
        and J.IsValidHero(nInRangeEnemy[1])
        and J.CanCastOnNonMagicImmune(nInRangeEnemy[1])
        and J.IsInRange(bot, nInRangeEnemy[1], 600)
        and J.IsRunning(nInRangeEnemy[1])
        and nInRangeEnemy[1]:IsFacingLocation(bot:GetLocation(), 30)
		and not J.IsDisabled(nInRangeEnemy[1])
        then
            local nTargetInRangeAlly = nInRangeEnemy[1]:GetNearbyHeroes(800, false, BOT_MODE_NONE)

            if  nTargetInRangeAlly ~= nil
            and ((#nTargetInRangeAlly > #nInRangeAlly)
                or (J.GetHP(bot) < 0.45 and bot:WasRecentlyDamagedByAnyHero(2.5)))
            then
                return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
            end
        end
	end

	if (J.IsDefending(bot) or J.IsPushing(bot))
	then
		local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(nCastRange, true)
		local nLocationAoE = bot:FindAoELocation(true, false, bot:GetLocation(), nCastRange, nRadius, 0, 0)
		local nTeamLaneFrontLoc = GetLaneFrontLocation(GetTeam(), bot:GetAssignedLane(), 0)
		local nEnemyLaneFrontLoc = GetLaneFrontLocation(GetOpposingTeam(), bot:GetAssignedLane(), 0)

		if  nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 5
		and nLocationAoE.count >= 5
		and J.GetLocationToLocationDistance(nTeamLaneFrontLoc, nEnemyLaneFrontLoc) < 150
		then
			return BOT_ACTION_DESIRE_MODERATE, nLocationAoE.targetloc
		end
	end

	if J.IsFarming(bot)
	then
		local nLocationAoE = bot:FindAoELocation(true, false, bot:GetLocation(), nCastRange, nRadius, 0, 0)
		local nNeutralCreeps = bot:GetNearbyNeutralCreeps(600)
		local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(600, true)

		if  J.IsAttacking(bot)
		and J.GetMP(bot) > 0.33
		then
			if  nNeutralCreeps ~= nil
			and ((#nNeutralCreeps >= 3 and nLocationAoE.count >= 3)
				or (#nNeutralCreeps >= 2 and nLocationAoE.count >= 2 and nNeutralCreeps[1]:IsAncientCreep()))
			then
				return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
			end

			if  nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 4
			and nLocationAoE.count >= 4
			then
				return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
			end
		end
	end

	if J.IsLaning(bot)
	then
		local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(600, true)
		local nLocationAoE = bot:FindAoELocation(true, false, bot:GetLocation(), nCastRange, nRadius, 0, 0)

		if  J.IsAttacking(bot)
		and J.GetMP(bot) > 0.65
		then
			if nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 4
			and nLocationAoE.count >= 4
			then
				return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
			end
		end
	end

    if J.IsDoingRoshan(bot)
    then
        if  J.IsRoshan(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, 500)
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
    end

    if J.IsDoingTormentor(bot)
    then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, 400)
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
    end

	return BOT_ACTION_DESIRE_NONE, 0
end

return X