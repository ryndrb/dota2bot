local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local BloodRite

function X.Cast()
    bot = GetBot()
    BloodRite = bot:GetAbilityByName('bloodseeker_blood_bath')

    Desire, Location = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(BloodRite, Location)
        return
    end
end

function X.Consider()
    if not BloodRite:IsFullyCastable()  then return 0 end

	local nCastRange = J.GetProperCastRange(false, bot, BloodRite:GetCastRange())
	local nRadius = BloodRite:GetSpecialValueInt('radius')
	local nCastPoint = BloodRite:GetCastPoint()
	local nDelay = BloodRite:GetSpecialValueFloat( 'delay' )
	local nManaCost = BloodRite:GetManaCost()
	local nDamage = BloodRite:GetSpecialValueInt( 'damage' )

    local botTarget = J.GetProperTarget(bot)

	local nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
	local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
    local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(1600, true)

	for _, enemyHero in pairs(nEnemyHeroes)
	do
		if J.IsValidHero(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange + nRadius)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_PURE)
		then
            if not J.IsInRange(bot, enemyHero, nCastRange)
            then
                return J.Site.GetXUnitsTowardsLocation(bot, enemyHero:GetLocation(), nCastRange)
            else
                return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(enemyHero, nDelay + nCastPoint)
            end
		end
	end

	if J.IsLaning(bot) and J.IsAllowedToSpam(bot, nManaCost)
	then
		if nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 4
        and J.CanBeAttacked(nEnemyLaneCreeps[1])
        and not J.IsRunning(nEnemyLaneCreeps[1])
		then
			return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nEnemyLaneCreeps)
		end
	end

	if (J.IsPushing(bot) or J.IsDefending(bot)) and J.IsAllowedToSpam(bot, nManaCost)
	and nEnemyHeroes == nil and #nEnemyHeroes == 0
	and nAllyHeroes ~= nil and #nAllyHeroes <= 2
	then
		if nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 4
        and J.CanBeAttacked(nEnemyLaneCreeps[1])
        and not J.IsRunning(nEnemyLaneCreeps[1])
		then
			return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nEnemyLaneCreeps)
		end
	end

	if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
    and nEnemyHeroes == nil and #nEnemyHeroes >= 1
	then
		for _, enemyHero in pairs(nEnemyHeroes)
		do
			if J.IsValidHero(enemyHero)
            and bot:WasRecentlyDamagedByHero(enemyHero, 1.0)
            and J.CanCastOnNonMagicImmune(enemyHero)
			then
                local nInRangeEnemy = J.GetEnemiesNearLoc(enemyHero:GetLocation(), nRadius)
                if #nInRangeEnemy >= 2
                then
                    return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nInRangeEnemy)
                else
                    return BOT_ACTION_DESIRE_HIGH, (bot:GetLocation() + enemyHero:GetLocation()) / 2
                end
			end
		end
	end

	if J.IsInTeamFight( bot, 1200 )
	then
		local nLocationAoE = bot:FindAoELocation( true, true, bot:GetLocation(), nCastRange - 200, nRadius/2, nCastPoint, 0 )
		if nLocationAoE.count >= 2
		then
			local nInvUnit = J.GetInvUnitInLocCount( bot, nCastRange, nRadius/2, nLocationAoE.targetloc, false )
			if nInvUnit >= nLocationAoE.count
            then
				return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
			end
		end
	end

	if J.IsGoingOnSomeone( bot )
	then
		if J.IsValidHero(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange + nRadius)
		then
			local nCastLoc = J.GetDelayCastLocation(bot, botTarget, nCastRange, nRadius, 2.0)
			if nCastLoc ~= nil
			then
				return BOT_ACTION_DESIRE_HIGH, nCastLoc
			end
		end
	end

    if J.IsDoingRoshan(bot)
	then
		if J.IsRoshan(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

    if J.IsDoingTormentor(bot)
	then
		if J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

	local skThere, skLoc = J.IsSandKingThere( bot, nCastRange, 2.0 )
	if skThere then
		return BOT_ACTION_DESIRE_MODERATE, skLoc
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

return X