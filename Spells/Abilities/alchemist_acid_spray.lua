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

	local nCastRange = J.GetProperCastRange(false, bot, AcidSpray:GetCastRange())
	local nCastPoint = AcidSpray:GetCastPoint()
	local nRadius = AcidSpray:GetSpecialValueInt('radius')
	local botTarget = J.GetProperTarget(bot)

	local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
	local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(800, true)
	local nEnemyTowers = bot:GetNearbyTowers(1600, true)

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
		and J.IsInRange(bot, botTarget, nCastRange + nRadius)
		and J.IsAttacking(botTarget)
		and botTarget:IsFacingLocation(bot:GetLocation(), 45)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
		then
			local nInRangeEnemy = J.GetEnemiesNearLoc(botTarget:GetLocation(), nCastRange + nRadius)
            if nInRangeEnemy ~= nil and #nInRangeEnemy >= 1
            then
                if GetUnitToLocationDistance(bot, J.GetCenterOfUnits(nInRangeEnemy)) > nCastRange
                then
                    return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, J.GetCenterOfUnits(nInRangeEnemy), nCastRange)
                else
                    return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nInRangeEnemy)
                end
            end

            if not J.IsInRange(bot, botTarget, nCastRange)
            then
                return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, botTarget:GetLocation(), nCastRange)
            else
                return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
            end
		end
	end

	if J.IsRetreating(bot)
	and not J.IsRealInvisible(bot)
	then
		for _, enemyHero in pairs(nEnemyHeroes)
		do
			if bot:GetActiveModeDesire() > 0.85
			and J.IsValidHero(enemyHero)
			and not J.IsDisabled(enemyHero)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and J.IsInRange(bot, enemyHero, 600)
			and J.IsChasingTarget(enemyHero, bot)
			then
				return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
			end
		end
	end

	if (J.IsDefending(bot) or J.IsPushing(bot))
	then
		if  nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 5
		and J.CanBeAttacked(nEnemyLaneCreeps[1])
		and not J.IsRunning(nEnemyLaneCreeps[1])
		and J.GetMP(bot) > 0.48
		then
			return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nEnemyLaneCreeps)
		end
	end

	if J.IsFarming(bot)
	then
		if  J.IsAttacking(bot)
		and J.GetMP(bot) > 0.35
		then
			local nNeutralCreeps = bot:GetNearbyNeutralCreeps(600)
			if  J.IsValid(nNeutralCreeps[1])
			and ((#nNeutralCreeps >= 3)
				or (#nNeutralCreeps >= 2 and nNeutralCreeps[1]:IsAncientCreep()))
			then
				return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nNeutralCreeps)
			end

			if  nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 4
			and J.CanBeAttacked(nEnemyLaneCreeps[1])
			and not J.IsRunning(nEnemyLaneCreeps[1])
			then
				return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nEnemyLaneCreeps)
			end
		end
	end

	if J.IsLaning(bot)
	then
		if  J.IsAttacking(bot)
		and J.GetMP(bot) > 0.65
		then
			if nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 4
			and J.CanBeAttacked(nEnemyLaneCreeps[1])
			and not J.IsRunning(nEnemyLaneCreeps[1])
			and J.IsValidBuilding(nEnemyTowers[1])
			and GetUnitToLocationDistance(nEnemyTowers[1], J.GetCenterOfUnits(nEnemyLaneCreeps)) > 800
			then
				return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nEnemyLaneCreeps)
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