local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local CryptSwarm

function X.Cast()
    bot = GetBot()
    CryptSwarm = bot:GetAbilityByName('death_prophet_carrion_swarm')

    Desire, Location = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(CryptSwarm, Location)
        return
    end
end

function X.Consider()
    if not CryptSwarm:IsFullyCastable() then return 0 end

	local nSkillLV = CryptSwarm:GetLevel()
	local nCastRange = J.GetProperCastRange(false, bot, CryptSwarm:GetCastRange())
	local nCastPoint = CryptSwarm:GetCastPoint()
	local nManaCost = CryptSwarm:GetManaCost()
	local nDamage = CryptSwarm:GetAbilityDamage()
	local nRadius = CryptSwarm:GetSpecialValueInt( "end_radius" )
    local botTarget = J.GetProperTarget(bot)

    local nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	for _, npcEnemy in pairs( nEnemyHeroes )
	do
		if J.IsValidHero( npcEnemy )
        and J.CanCastOnNonMagicImmune( npcEnemy )
        and J.CanBeAttacked(npcEnemy)
        and J.IsInRange(bot, npcEnemy, nCastRange - 50)
        and J.WillMagicKillTarget( bot, npcEnemy, nDamage, nCastPoint )
		then
			return BOT_ACTION_DESIRE_HIGH, npcEnemy:GetLocation()
		end
	end

	local nCanHurtEnemyAoE = bot:FindAoELocation( true, true, bot:GetLocation(), nCastRange, nRadius + 50, 0, 0 )
	if nCanHurtEnemyAoE.count >= 3 and bot:GetActiveMode() ~= BOT_MODE_RETREAT
	then
		return BOT_ACTION_DESIRE_HIGH, nCanHurtEnemyAoE.targetloc
	end

	if J.IsLaning( bot )
	then
		local nAoeLoc = J.GetAoeEnemyHeroLocation( bot, nCastRange - 80, nRadius, 2 )
		if nAoeLoc ~= nil and J.GetMP(bot) > 0.58
		then
			return BOT_ACTION_DESIRE_HIGH, nAoeLoc
		end

		if nAllyHeroes ~= nil and #nAllyHeroes == 1 and J.GetMP(bot) > 0.38
		then
			local locationAoEKill = bot:FindAoELocation( true, false, bot:GetLocation(), nCastRange, nRadius + 50, 0, nDamage )
			if locationAoEKill.count >= 3
			then
				return BOT_ACTION_DESIRE_HIGH, locationAoEKill.targetloc
			end
		end
	end

	if J.IsInTeamFight( bot, 1200 )
	then
		local nAoeLoc = J.GetAoeEnemyHeroLocation( bot, nCastRange, nRadius, 2 )
		if nAoeLoc ~= nil
		then
			return BOT_ACTION_DESIRE_HIGH, nAoeLoc
		end
	end

	if J.IsGoingOnSomeone( bot )
	then
		if J.IsValidHero( botTarget )
        and J.CanCastOnNonMagicImmune( botTarget )
        and J.IsInRange( botTarget, bot, nCastRange -80 )
		then
			if nSkillLV >= 2 or J.GetMP(bot) > 0.68 or J.GetHP( botTarget ) < 0.38
			then
				local nTargetLocation = J.GetCorrectLoc(botTarget, nCastPoint)
				if J.IsInLocRange( bot, nTargetLocation, nCastRange )
				then
					return BOT_ACTION_DESIRE_HIGH, nTargetLocation
				end
			end
		end
	end

	if J.IsRetreating( bot )
    and not J.IsRealInvisible(bot)
	then
		for _, npcEnemy in pairs( nEnemyHeroes )
		do
			if J.IsValidHero( npcEnemy )
            and J.IsInRange(bot, npcEnemy, nCastRange)
            and bot:WasRecentlyDamagedByHero( npcEnemy, 5.0 )
            and J.CanCastOnNonMagicImmune( npcEnemy )
            and bot:IsFacingLocation( npcEnemy:GetLocation(), 30 )
			then
				return BOT_ACTION_DESIRE_HIGH, npcEnemy:GetLocation()
			end
		end
	end

	if J.IsFarming( bot )
    and nSkillLV >= 3
    and J.IsAllowedToSpam( bot, nManaCost * 0.25 )
	then
		if J.IsValid( botTarget )
        and botTarget:GetTeam() == TEAM_NEUTRAL
        and J.IsInRange( bot, botTarget, 1000 )
        and bot:IsFacingLocation( botTarget:GetLocation(), 45 )
        and ( botTarget:GetMagicResist() < 0.4 or J.GetMP(bot) > 0.9 )
		then
			local nShouldHurtCount = J.GetMP(bot) > 0.6 and 2 or 3
			local locationAoE = bot:FindAoELocation( true, false, bot:GetLocation(), nCastRange, nRadius, 0, 0 )
			if ( locationAoE.count >= nShouldHurtCount )
			then
				return BOT_ACTION_DESIRE_HIGH, locationAoE.targetloc
			end
		end
	end

	if ( J.IsPushing( bot ) or J.IsDefending( bot ) or J.IsFarming( bot ) )
    and J.IsAllowedToSpam( bot, nManaCost * 0.32 )
    and nSkillLV >= 2 and DotaTime() > 8 * 60
    and (J.IsCore(bot) or not J.IsCore(bot) and nAllyHeroes ~= nil and #nAllyHeroes <= 3 and nEnemyHeroes ~= nil and #nEnemyHeroes == 0)
	then
		local laneCreepList = bot:GetNearbyLaneCreeps( nCastRange + 400, true )
		if #laneCreepList >= 3
        and J.CanBeAttacked( laneCreepList[1] )
		then
			local locationAoEKill = bot:FindAoELocation( true, false, bot:GetLocation(), nCastRange, nRadius, 0, nDamage )
			if locationAoEKill.count >= 2
			then
				return BOT_ACTION_DESIRE_HIGH, locationAoEKill.targetloc
			end

			local locationAoEHurt = bot:FindAoELocation( true, false, bot:GetLocation(), nCastRange, nRadius + 50, 0, 0 )
			if ( locationAoEHurt.count >= 3 and #laneCreepList >= 4 )
			then
				return BOT_ACTION_DESIRE_HIGH, locationAoEHurt.targetloc
			end
		end
	end

	if J.IsDoingRoshan(bot)
	then
		if J.IsRoshan( botTarget )
        and J.GetHP( botTarget ) > 0.15
		and J.IsInRange( botTarget, bot, nCastRange )
        and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

    if J.IsDoingTormentor(bot)
	then
		if J.IsTormentor( botTarget )
		and J.IsInRange( botTarget, bot, nCastRange )
        and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

	if ( nEnemyHeroes ~= nil and #nEnemyHeroes > 0 or bot:WasRecentlyDamagedByAnyHero( 3.0 ) )
    and ( not J.IsRetreating(bot) or nAllyHeroes ~= nil and #nAllyHeroes >= 2)
    and J.IsValidHero(nEnemyHeroes[1])
    and bot:GetLevel() > 15
	then
		for _, npcEnemy in pairs( nEnemyHeroes )
		do
			if J.IsValidHero( npcEnemy )
            and J.IsInRange(bot, npcEnemy, nCastRange)
            and J.CanCastOnNonMagicImmune( npcEnemy )
			then
				return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(npcEnemy, nCastPoint)
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

return X