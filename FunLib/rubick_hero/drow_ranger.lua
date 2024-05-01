local bot
local X = {}
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')

local FrostArrows
local Gust
local Multishot
local Glacier

local nMP, nHP, nLV, hEnemyList, hAllyList

local botTarget

function X.ConsiderStolenSpell(ability)
    bot = GetBot()

    if J.CanNotUseAbility(bot) then return end

    botTarget = J.GetProperTarget(bot)
    local abilityName = ability:GetName()

	nMP = bot:GetMana()/bot:GetMaxMana()
	nHP = bot:GetHealth()/bot:GetMaxHealth()
	nLV = bot:GetLevel()
	hEnemyList = bot:GetNearbyHeroes( 1600, true, BOT_MODE_NONE )
	hAllyList = J.GetAlliesNearLoc( bot:GetLocation(), 1600 )

    if abilityName == 'drow_ranger_glacier'
    then
        Glacier = ability
        GlacierDesire = X.ConsiderGlacier()
        if GlacierDesire > 0
        then
            bot:Action_UseAbility(Glacier)
            return
        end
    end

    if abilityName == 'drow_ranger_multishot'
    then
        Multishot = ability
        MultishotDesire, MultishotLocation = X.ConsiderMultishot()
        if Multishot > 0
        then
            bot:Action_UseAbilityOnLocation(Multishot, MultishotLocation)
            return
        end
    end

    if abilityName == 'drow_ranger_wave_of_silence'
    then
        Gust = ability
        GustDesire, GustLocation = X.ConsiderGust()
        if GustDesire > 0
        then
            bot:Action_UseAbilityOnLocation(Gust, GustLocation)
            return
        end
    end

    if abilityName == 'drow_ranger_frost_arrows'
    then
        FrostArrows = ability
        FrostArrowsDesire, FrostArrowsTarget = X.ConsiderFrostArrows()
        if FrostArrowsDesire > 0
        then
            bot:Action_UseAbilityOnEntity(FrostArrows , FrostArrowsTarget )
            return
        end
    end
end

function X.ConsiderMultishot()

	if not Multishot:IsFullyCastable()
	then
		return BOT_ACTION_DESIRE_NONE
	end

	local nCastRange = 850
	local nRadius = 200
	local nDamage = 0
	local nCastPoint = Multishot:GetCastPoint()
	local nSkillLV = Multishot:GetLevel()
	local nManaCost = Multishot:GetManaCost()
	local nTargetLocation = nil

	local nEnemyHeroes = bot:GetNearbyHeroes( nCastRange + 100, true, BOT_MODE_NONE )


	if J.IsGoingOnSomeone( bot )
	then
		local npcTarget = J.GetProperTarget( bot )
		if J.IsValidHero( npcTarget )
			and J.CanCastOnNonMagicImmune( npcTarget )
			and J.IsInRange( npcTarget, bot, nCastRange )
			and ( npcTarget:IsFacingLocation( bot:GetLocation(), 120 )
				  or npcTarget:GetAttackTarget() ~= nil )
		then
			nTargetLocation = npcTarget:GetExtrapolatedLocation( nCastPoint )
			return BOT_ACTION_DESIRE_HIGH, nTargetLocation
		end

		local locationAoE = bot:FindAoELocation( true, true, bot:GetLocation(), 780, nRadius, nCastPoint, 0 )
		if ( locationAoE.count >= 2 )
		then
			nTargetLocation = locationAoE.targetloc
			return BOT_ACTION_DESIRE_HIGH, nTargetLocation
		end

	end

	if ( J.IsPushing( bot ) or J.IsDefending( bot ) or J.IsFarming( bot ) )
		and J.IsAllowedToSpam( bot, 90 )
		and DotaTime() > 8 * 60
		and #hAllyList <= 2 and #hEnemyList == 0
	then
		local laneCreepList = bot:GetNearbyLaneCreeps( 1400, true )
		if #laneCreepList >= 4
			and J.IsValid( laneCreepList[1] )
			and not laneCreepList[1]:HasModifier( "modifier_fountain_glyph" )
		then
			local locationAoEHurt = bot:FindAoELocation( true, false, bot:GetLocation(), 700, nRadius + 50, 0, 0 )
			if locationAoEHurt.count >= 3
			then
				nTargetLocation = locationAoEHurt.targetloc
				return BOT_ACTION_DESIRE_HIGH, nTargetLocation
			end
		end
	end

	if J.IsFarming( bot )
		and J.IsAllowedToSpam( bot, nManaCost )
	then
		if J.IsValid( botTarget )
			and botTarget:GetTeam() == TEAM_NEUTRAL
			and J.IsInRange( bot, botTarget, 1000 )
		then
			local nShouldHurtCount = nMP > 0.6 and 2 or 3
			local locationAoE = bot:FindAoELocation( true, false, bot:GetLocation(), 750, 300, 0, 0 )
			if ( locationAoE.count >= nShouldHurtCount )
			then
				nTargetLocation = locationAoE.targetloc
				return BOT_ACTION_DESIRE_HIGH, nTargetLocation
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderGust()

	if not Gust:IsFullyCastable()
	then
		return BOT_ACTION_DESIRE_NONE
	end

	local nCastRange = Gust:GetCastRange()
	local nRadius = Gust:GetAOERadius()
	local nDamage = 0
	local nCastPoint = Gust:GetCastPoint()
	local nTargetLocation = nil

	local nEnemyHeroes = bot:GetNearbyHeroes( nCastRange + 100, true, BOT_MODE_NONE )


	for _, npcEnemy in pairs( nEnemyHeroes )
	do
		if J.IsValid( npcEnemy )
			and npcEnemy:IsChanneling()
			and not npcEnemy:HasModifier( "modifier_teleporting" )
			--and not npcEnemy:HasModifier( "modifier_boots_of_travel_incoming" )
		then
			nTargetLocation = npcEnemy:GetLocation()
			return BOT_ACTION_DESIRE_HIGH, nTargetLocation
		end
	end


	if bot:GetActiveMode() == BOT_MODE_RETREAT
	then

		local locationAoE = bot:FindAoELocation( true, true, bot:GetLocation(), nCastRange-100, nRadius, nCastPoint, 0 )
		if locationAoE.count >= 2
			or ( locationAoE.count >= 1 and bot:GetHealth()/bot:GetMaxHealth() < 0.5 )
		then
			nTargetLocation = locationAoE.targetloc
			return BOT_ACTION_DESIRE_HIGH, nTargetLocation
		end


		for _, npcEnemy in pairs( nEnemyHeroes )
		do
			if J.IsValid( npcEnemy )
				and bot:WasRecentlyDamagedByHero( npcEnemy, 5.0 )
				and GetUnitToUnitDistance( bot, npcEnemy ) <= 510
			then
				nTargetLocation = npcEnemy:GetExtrapolatedLocation( nCastPoint )
				return BOT_ACTION_DESIRE_HIGH, nTargetLocation
			end
		end
	end


	if J.IsGoingOnSomeone( bot )
	then
		local npcTarget = J.GetProperTarget( bot )
		if J.IsValidHero( npcTarget )
			and J.CanCastOnNonMagicImmune( npcTarget )
			and J.IsInRange( npcTarget, bot, nCastRange )
			and not npcTarget:IsSilenced()
			and not J.IsDisabled( npcTarget )
			and ( npcTarget:IsFacingLocation( bot:GetLocation(), 120 )
				  or npcTarget:GetAttackTarget() ~= nil )
		then
			nTargetLocation = npcTarget:GetExtrapolatedLocation( nCastPoint )
			return BOT_ACTION_DESIRE_HIGH, nTargetLocation
		end

		local locationAoE = bot:FindAoELocation( true, true, bot:GetLocation(), nCastRange, nRadius, nCastPoint, 0 )
		if ( locationAoE.count >= 2 )
		then
			nTargetLocation = locationAoE.targetloc
			return BOT_ACTION_DESIRE_HIGH, nTargetLocation
		end

	end

	return BOT_ACTION_DESIRE_NONE, nil
end

local lastAutoTime = 0
function X.ConsiderFrostArrows()

	if not FrostArrows:IsFullyCastable()
		or bot:IsDisarmed()
		or J.GetDistanceFromEnemyFountain( bot ) < 800
	then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nAttackRange = bot:GetAttackRange() + 40
	local nAttackDamage = bot:GetAttackDamage() + FrostArrows:GetSpecialValueInt( "damage" )
	local nDamageType = DAMAGE_TYPE_PHYSICAL
	local nTowers = bot:GetNearbyTowers( 900, true )
	local nEnemysLaneCreepsInRange = bot:GetNearbyLaneCreeps( nAttackRange + 30, true )
	local nEnemysLaneCreepsNearby = bot:GetNearbyLaneCreeps( 400, true )
	local nEnemysWeakestLaneCreepsInRange = J.GetAttackableWeakestUnit( bot, nAttackRange + 30, false, true )
	local nEnemysWeakestLaneCreepsInRangeHealth = 10000
	if( nEnemysWeakestLaneCreepsInRange ~= nil )
	then
		nEnemysWeakestLaneCreepsInRangeHealth = nEnemysWeakestLaneCreepsInRange:GetHealth()
	end

	local nEnemysHeroesInAttackRange = bot:GetNearbyHeroes( nAttackRange, true, BOT_MODE_NONE )
	local nInAttackRangeWeakestEnemyHero = J.GetAttackableWeakestUnit( bot, nAttackRange, true, true )
	local nInViewWeakestEnemyHero = J.GetAttackableWeakestUnit( bot, 800, true, true )

	local nAllyLaneCreeps = bot:GetNearbyLaneCreeps( 330, false )
	local npcTarget = J.GetProperTarget( bot )
	local nTargetUint = nil
	local npcMode = bot:GetActiveMode()


	if nLV >= 8
	then
		if ( hEnemyList[1] ~= nil or nMP > 0.76 )
			and not FrostArrows:GetAutoCastState()
		then
			lastAutoTime = DotaTime()
			FrostArrows:ToggleAutoCast()
		elseif ( hEnemyList[1] == nil and nMP < 0.7 )
				and lastAutoTime + 3.0 < DotaTime()
				and FrostArrows:GetAutoCastState()
			then
				FrostArrows:ToggleAutoCast()
		end
	else
		if FrostArrows:GetAutoCastState()
		then
			FrostArrows:ToggleAutoCast()
		end
	end

	if nLV <= 7 and nHP > 0.55
		and J.IsValidHero( npcTarget )
		and ( not J.IsRunning( bot ) or J.IsInRange( bot, npcTarget, nAttackRange + 18 ) )
	then
		if not npcTarget:IsAttackImmune()
			and J.IsInRange( bot, npcTarget, nAttackRange + 99 )
		then
			nTargetUint = npcTarget
			return BOT_ACTION_DESIRE_HIGH, nTargetUint
		end
	end


	if npcMode == BOT_MODE_LANING
		and #nTowers == 0
	then

		if J.IsValid( nInAttackRangeWeakestEnemyHero )
		then
			if nEnemysWeakestLaneCreepsInRangeHealth > 130
				and nHP >= 0.6
				and #nEnemysLaneCreepsNearby <= 3
				and #nAllyLaneCreeps >= 2
				and not bot:WasRecentlyDamagedByCreep( 1.5 )
				and not bot:WasRecentlyDamagedByAnyHero( 1.5 )
			then
				nTargetUint = nInAttackRangeWeakestEnemyHero
				return BOT_ACTION_DESIRE_HIGH, nTargetUint
			end
		end


		if J.IsValid( nInViewWeakestEnemyHero )
		then
			if nEnemysWeakestLaneCreepsInRangeHealth > 180
				and nHP >= 0.7
				and #nEnemysLaneCreepsNearby <= 2
				and #nAllyLaneCreeps >= 3
				and not bot:WasRecentlyDamagedByCreep( 1.5 )
				and not bot:WasRecentlyDamagedByAnyHero( 1.5 )
				and not bot:WasRecentlyDamagedByTower( 1.5 )
			then
				nTargetUint = nInViewWeakestEnemyHero
				return BOT_ACTION_DESIRE_HIGH, nTargetUint
			end

			if J.GetUnitAllyCountAroundEnemyTarget( nInViewWeakestEnemyHero , 500 ) >= 4
				and not bot:WasRecentlyDamagedByCreep( 1.5 )
				and not bot:WasRecentlyDamagedByAnyHero( 1.5 )
				and not bot:WasRecentlyDamagedByTower( 1.5 )
				and nHP >= 0.6
			then
				nTargetUint = nInViewWeakestEnemyHero
				return BOT_ACTION_DESIRE_HIGH, nTargetUint
			end
		end

		if J.IsWithoutTarget( bot )
			and not J.IsAttacking( bot )
		then
			local nLaneCreepList = bot:GetNearbyLaneCreeps( 1100, true )
			for _, creep in pairs( nLaneCreepList )
			do
				if J.IsValid( creep )
					and not creep:HasModifier( "modifier_fountain_glyph" )
					and creep:GetHealth() < nAttackDamage + 180
					and not J.IsAllysTarget( creep )
				then
					local nAttackProDelayTime = J.GetAttackProDelayTime( bot, nCreep ) * 1.08 + 0.08
					local nAD = nAttackDamage * 1.0
					if J.WillKillTarget( creep, nAD, nDamageType, nAttackProDelayTime )
					then
						return BOT_ACTION_DESIRE_HIGH, creep
					end
				end
			end

		end
	end


	if npcTarget ~= nil
		and npcTarget:IsHero()
		and GetUnitToUnitDistance( npcTarget, bot ) > nAttackRange + 160
		and J.IsValid( nInAttackRangeWeakestEnemyHero )
		and not nInAttackRangeWeakestEnemyHero:IsAttackImmune()
	then
		nTargetUint = nInAttackRangeWeakestEnemyHero
		bot:SetTarget( nTargetUint )
		return BOT_ACTION_DESIRE_HIGH, nTargetUint
	end


	if bot:HasModifier( "modifier_item_hurricane_pike_range" )
		and J.IsValid( npcTarget )
	then
		nTargetUint = npcTarget
		return BOT_ACTION_DESIRE_HIGH, nTargetUint
	end


	if bot:GetAttackTarget() == nil
		and  bot:GetTarget() == nil
		and  #hEnemyList == 0
		and  npcMode ~= BOT_MODE_RETREAT
		and  npcMode ~= BOT_MODE_ATTACK
		and  npcMode ~= BOT_MODE_ASSEMBLE
		and  npcMode ~= BOT_MODE_FARM
		and  npcMode ~= BOT_MODE_TEAM_ROAM
		and  J.GetTeamFightAlliesCount( bot ) < 3
		and  bot:GetMana() >= 180
		and  not bot:WasRecentlyDamagedByAnyHero( 3.0 )
	then

		if bot:HasScepter()
		then
			local nEnemysCreeps = bot:GetNearbyCreeps( 1600, true )
			if J.IsValid( nEnemysCreeps[1] )
			then
				nTargetUint = nEnemysCreeps[1]
				return BOT_ACTION_DESIRE_HIGH, nTargetUint
			end
		end

		local nNeutralCreeps = bot:GetNearbyNeutralCreeps( 1600 )
		if npcMode ~= BOT_MODE_LANING
			and nLV >= 6
			and nHP > 0.25
			and J.IsValid( nNeutralCreeps[1] )
			and not J.IsRoshan( nNeutralCreeps[1] )
			and ( nNeutralCreeps[1]:IsAncientCreep() == false or nLV >= 12 )
		then
			nTargetUint = nNeutralCreeps[1]
			return BOT_ACTION_DESIRE_HIGH, nTargetUint
		end


		local nLaneCreeps = bot:GetNearbyLaneCreeps( 1600, true )
		if npcMode ~= BOT_MODE_LANING
			and nLV >= 6
			and nHP > 0.25
			and J.IsValid( nLaneCreeps[1] )
			and bot:GetAttackDamage() > 130
		then
			nTargetUint = nLaneCreeps[1]
			return BOT_ACTION_DESIRE_HIGH, nTargetUint
		end
	end


	if npcMode == BOT_MODE_RETREAT
	then

		nDistance = 999
		local nTargetUint = nil
		for _, npcEnemy in pairs( nEnemysHeroesInAttackRange )
		do
			if J.IsValid( npcEnemy )
				and npcEnemy:HasModifier( "modifier_drowranger_wave_of_silence_knockback" )
				and GetUnitToUnitDistance( npcEnemy, bot ) < nDistance
			then
				nTargetUint = npcEnemy
				nDistance = GetUnitToUnitDistance( npcEnemy, bot )
			end
		end

		if nTargetUint ~= nil
			and not nTargetUint:HasModifier( "modifier_drow_ranger_frost_arrows_slow" )
		then
			return BOT_ACTION_DESIRE_HIGH, nTargetUint
		end
	end

	if J.IsFarming( bot )
		and nMP > 0.55
		and not FrostArrows:GetAutoCastState()
	then
		if J.IsValid( botTarget )
			and botTarget:GetTeam() == TEAM_NEUTRAL
			and J.IsInRange( bot, botTarget, 1000 )
			and botTarget:GetHealth() > nAttackDamage
		then
			return BOT_ACTION_DESIRE_LOW, botTarget, "Q-打野"
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderGlacier()
	if not Glacier:IsTrained()
	or not Glacier:IsFullyCastable()
	then
		return BOT_ACTION_DESIRE_NONE
	end

	local nAttackRange = bot:GetAttackRange()
	local nEnemyHeroes = bot:GetNearbyHeroes(nAttackRange, true, BOT_MODE_NONE)
	local nAllyHeroes = bot:GetNearbyHeroes(nAttackRange, true, BOT_MODE_ATTACK)
	botTarget = J.GetProperTarget(bot)

	local alliesAroundLoc = J.GetAlliesNearLoc(bot:GetLocation(), 500)

	if #alliesAroundLoc > 1
	then
		return BOT_ACTION_DESIRE_LOW
	end

	if J.IsRetreating(bot)
	and ((#nEnemyHeroes ~= nil and #nEnemyHeroes >= 2) or J.GetHP(bot) < 0.3)
	then
		if nAllyHeroes ~= nil
		and #nAllyHeroes >= 1
		then
			return BOT_ACTION_DESIRE_LOW
		end

		return BOT_ACTION_DESIRE_HIGH
	end

	if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
		and (Multishot:IsFullyCastable() and J.CanCastOnNonMagicImmune(botTarget))
		and J.IsInRange(bot, botTarget, Multishot:GetCastRange() + 200)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

return X