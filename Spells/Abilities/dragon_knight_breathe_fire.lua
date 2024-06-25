local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local BreathFire

function X.Cast()
    bot = GetBot()
    BreathFire = bot:GetAbilityByName('dragon_knight_breathe_fire')

    Desire, Location = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(BreathFire, Location)
        return
    end
end

function X.Consider()
    if ( not BreathFire:IsFullyCastable() ) then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nRadius = BreathFire:GetSpecialValueInt( 'end_radius' )
	local nCastRange = BreathFire:GetSpecialValueInt( 'range' )
	local nCastPoint = BreathFire:GetCastPoint()
	local nManaCost = BreathFire:GetManaCost()
	local nDamage = BreathFire:GetAbilityDamage()

    local nAllyHeroes = bot:GetNearbyHeroes( 1600, false, BOT_MODE_NONE )
	local nEnemyHeroes = bot:GetNearbyHeroes( 1600, true, BOT_MODE_NONE )
    local nCreeps = bot:GetNearbyHeroes( nCastRange, true, BOT_MODE_NONE)
    local laneCreepList = bot:GetNearbyLaneCreeps( nCastRange + 200, true )

	for _, npcEnemy in pairs( nEnemyHeroes )
	do
		if J.IsValidHero(npcEnemy)
        and J.IsInRange(bot, npcEnemy, nCastRange + 150)
        and J.CanCastOnNonMagicImmune( npcEnemy )
        and J.CanKillTarget( npcEnemy, nDamage, DAMAGE_TYPE_MAGICAL )
        and not npcEnemy:HasModifier('modifier_abaddon_borrowed_time')
        and not npcEnemy:HasModifier('modifier_dazzle_shallow_grave')
        and not npcEnemy:HasModifier('modifier_oracle_false_promise_timer')
		then
			return BOT_ACTION_DESIRE_HIGH, npcEnemy:GetLocation()
		end
	end

	if J.IsFarming( bot ) and J.GetManaAfter(BreathFire:GetManaCost()) > 0.25
	then
        if nCreeps ~= nil and #nCreeps >= 2
        and J.IsValid(nCreeps[1])
        and nCreeps[1]:GetMagicResist() < 0.4
        then
            return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nCreeps)
        end
	end

	if J.IsRetreating( bot )
    and not J.IsRealInvisible(bot)
	then
		local locationAoE = bot:FindAoELocation( true, true, bot:GetLocation(), nCastRange - 100, nRadius, 0, 0 )
		if ( locationAoE.count >= 2 )
		then
			return BOT_ACTION_DESIRE_LOW, locationAoE.targetloc
		end

		if J.IsValidHero( nEnemyHeroes[1] )
        and J.IsInRange( bot, nEnemyHeroes[1], nCastRange - 100 )
        and J.CanCastOnNonMagicImmune( nEnemyHeroes[1] )
		then
			return BOT_ACTION_DESIRE_HIGH, nEnemyHeroes[1]:GetLocation()
		end
	end

	if J.IsDoingRoshan(bot)
	then
		local npcTarget = bot:GetAttackTarget()
		if ( J.IsRoshan( npcTarget ) and J.IsInRange( npcTarget, bot, nCastRange ) )
        and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH, npcTarget:GetLocation()
		end
	end

    if J.IsDoingTormentor(bot)
	then
		local npcTarget = bot:GetAttackTarget()
		if ( J.IsTormentor( npcTarget ) and J.IsInRange( npcTarget, bot, nCastRange ) )
        and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH, npcTarget:GetLocation()
		end
	end

	if ( J.IsPushing( bot ) or J.IsDefending( bot ) or J.IsFarming( bot ) )
    and J.IsAllowedToSpam( bot, nManaCost * 0.3 )
    and bot:GetLevel() >= 6
    and nEnemyHeroes ~= nil and #nEnemyHeroes == 0
	then
		if laneCreepList ~= nil and #laneCreepList >= 2
        and nAllyHeroes ~= nil and #nAllyHeroes <= 2
        and J.CanBeAttacked( laneCreepList[1] )
		then
			local locationAoE = bot:FindAoELocation( true, false, bot:GetLocation(), nCastRange, nRadius, 0, nDamage )
			if ( locationAoE.count >= 2 and #laneCreepList >= 2  and bot:GetLevel() < 25 and #nAllyHeroes == 1 )
			then
				return BOT_ACTION_DESIRE_HIGH, locationAoE.targetloc
			end

			locationAoE = bot:FindAoELocation( true, false, bot:GetLocation(), nCastRange, nRadius, 0, 0 )
			if ( locationAoE.count >= 4 and #laneCreepList >= 4 )
			then
				return BOT_ACTION_DESIRE_HIGH, locationAoE.targetloc
			end
		end
	end

	if J.IsInTeamFight( bot, 1200 )
	then
		local locationAoE = bot:FindAoELocation( true, true, bot:GetLocation(), nCastRange, nRadius - 30, 0, 0 )
		if ( locationAoE.count >= 2 )
		then
			return BOT_ACTION_DESIRE_HIGH, locationAoE.targetloc
		end

		local npcMostDangerousEnemy = nil
		local nMostDangerousDamage = 0
		for _, npcEnemy in pairs( nEnemyHeroes )
		do
			if J.IsValidHero( npcEnemy )
            and J.IsInRange( npcEnemy, bot, nCastRange )
            and J.CanCastOnNonMagicImmune( npcEnemy )
            and not npcEnemy:HasModifier('modifier_abaddon_borrowed_time')
            and not npcEnemy:HasModifier('modifier_dazzle_shallow_grave')
            and not npcEnemy:HasModifier('modifier_necrolyte_reapers_scythe')
            and not npcEnemy:HasModifier('modifier_oracle_false_promise_timer')
			then
				local npcEnemyDamage = npcEnemy:GetEstimatedDamageToTarget( false, bot, 3.0, DAMAGE_TYPE_PHYSICAL )
				if ( npcEnemyDamage > nMostDangerousDamage )
				then
					nMostDangerousDamage = npcEnemyDamage
					npcMostDangerousEnemy = npcEnemy
				end
			end
		end

		if ( npcMostDangerousEnemy ~= nil )
		then
			return BOT_ACTION_DESIRE_HIGH, npcMostDangerousEnemy:GetExtrapolatedLocation( nCastPoint )
		end
	end


	if J.IsGoingOnSomeone( bot )
	then
		local npcTarget = J.GetProperTarget( bot )
		if J.IsValidHero( npcTarget )
        and J.CanCastOnNonMagicImmune( npcTarget )
        and J.IsInRange( npcTarget, bot, nCastRange - 100 )
        and not npcTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not npcTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not npcTarget:HasModifier('modifier_oracle_false_promise_timer')
		then
			return BOT_ACTION_DESIRE_HIGH, npcTarget:GetExtrapolatedLocation( nCastPoint )
		end
	end

	if bot:GetLevel() < 18
	then
		if laneCreepList ~= nil and #laneCreepList >= 3
        and nAllyHeroes ~= nil and #nAllyHeroes < 3
        and J.CanBeAttacked(laneCreepList[1])
		then
			local locationAoE = bot:FindAoELocation( true, false, bot:GetLocation(), nCastRange, nRadius, 0, nDamage )
			if ( locationAoE.count >= 3 )
			then
				return BOT_ACTION_DESIRE_HIGH, locationAoE.targetloc
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

return X