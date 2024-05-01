local bot
local X = {}
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')

local BreathFire
local DragonTail
local Fireball
local ElderDragonForm

local botTarget

function X.ConsiderStolenSpell(ability)
    bot = GetBot()

    if J.CanNotUseAbility(bot) then return end

    botTarget = J.GetProperTarget(bot)
    local abilityName = ability:GetName()

    if abilityName == 'dragon_knight_elder_dragon_form'
    then
        ElderDragonForm = ability
        ElderDragonFormDesire = X.ConsiderElderDragonForm()
        if ElderDragonFormDesire > 0
        then
            bot:Action_UseAbility(ElderDragonForm)
            return
        end
    end

    if abilityName == 'dragon_knight_breathe_fire'
    then
        BreathFire = ability
        BreathFireDesire, BreathFireLocation = X.ConsiderBreathFire()
        if BreathFireDesire > 0
        then
            bot:Action_UseAbilityOnLocation(BreathFire, BreathFireLocation)
            return
        end
    end

    if abilityName == 'dragon_knight_dragon_tail'
    then
        DragonTail = ability
        DragonTailDesire, DragonTailTarget = X.ConsiderDragonTail()
        if DragonTailDesire > 0
        then
            bot:Action_UseAbilityOnEntity(DragonTail, DragonTailTarget)
            return
        end
    end

    if abilityName == 'ragon_knight_fireball'
    then
        Fireball = ability
        FireballDesire, FireballTarget = X.ConsiderFireball()
        if FireballDesire > 0
        then
            bot:Action_UseAbilityOnLocation(Fireball, FireballTarget)
            return
        end
    end
end

function X.ConsiderBreathFire()

	if ( not BreathFire:IsFullyCastable() ) then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nRadius = BreathFire:GetSpecialValueInt( 'end_radius' )
	local nCastRange = BreathFire:GetSpecialValueInt( 'range' )
	local nCastPoint = BreathFire:GetCastPoint()
	local nManaCost = BreathFire:GetManaCost()
	local nDamage = BreathFire:GetAbilityDamage()

	local tableNearbyEnemyHeroes = bot:GetNearbyHeroes( nCastRange + 150, true, BOT_MODE_NONE )
	local nEnemysHeroesInView = bot:GetNearbyHeroes( 1600, true, BOT_MODE_NONE )


	for _, npcEnemy in pairs( tableNearbyEnemyHeroes )
	do
		if J.CanCastOnNonMagicImmune( npcEnemy )
			and J.CanKillTarget( npcEnemy, nDamage, DAMAGE_TYPE_MAGICAL )
		then
			return BOT_ACTION_DESIRE_HIGH, npcEnemy:GetLocation()
		end
	end

	if J.IsFarming( bot ) and bot:GetMana() > 150
	then
		local npcTarget = J.GetProperTarget( bot )
		if J.IsValid( npcTarget )
			and npcTarget:GetTeam() == TEAM_NEUTRAL
			and npcTarget:GetMagicResist() < 0.4
		then
			local locationAoE = bot:FindAoELocation( true, false, bot:GetLocation(), nCastRange, nRadius, 0, 0 )
			if ( locationAoE.count >= 2 )
			then
				return BOT_ACTION_DESIRE_HIGH, locationAoE.targetloc
			end
		end
	end


	if J.IsRetreating( bot )
	then
		local locationAoE = bot:FindAoELocation( true, true, bot:GetLocation(), nCastRange - 100, nRadius, 0, 0 )
		if ( locationAoE.count >= 2 )
		then
			return BOT_ACTION_DESIRE_LOW, locationAoE.targetloc
		end
		if J.IsValidHero( tableNearbyEnemyHeroes[1] )
			and J.CanCastOnNonMagicImmune( tableNearbyEnemyHeroes[1] )
			and J.IsInRange( bot, tableNearbyEnemyHeroes[1], nCastRange - 100 )
		then
			return BOT_ACTION_DESIRE_HIGH, tableNearbyEnemyHeroes[1]:GetLocation()
		end
	end

	if ( bot:GetActiveMode() == BOT_MODE_ROSHAN )
	then
		local npcTarget = bot:GetAttackTarget()
		if ( J.IsRoshan( npcTarget ) and J.IsInRange( npcTarget, bot, nCastRange ) )
		then
			return BOT_ACTION_DESIRE_HIGH, npcTarget:GetLocation()
		end
	end

	if ( J.IsPushing( bot ) or J.IsDefending( bot ) or J.IsFarming( bot ) )
		and J.IsAllowedToSpam( bot, nManaCost * 0.3 )
		and bot:GetLevel() >= 6
		and #nEnemysHeroesInView == 0
	then
		local laneCreepList = bot:GetNearbyLaneCreeps( nCastRange + 200, true )
		local allyHeroes = bot:GetNearbyHeroes( 1000, true, BOT_MODE_NONE )
		if #laneCreepList >= 2
			and #allyHeroes <= 2
			and J.IsValid( laneCreepList[1] )
			and not laneCreepList[1]:HasModifier( "modifier_fountain_glyph" )
		then
			local locationAoE = bot:FindAoELocation( true, false, bot:GetLocation(), nCastRange, nRadius, 0, nDamage )
			if ( locationAoE.count >= 2 and #laneCreepList >= 2  and bot:GetLevel() < 25 and #allyHeroes == 1 )
			then
				return BOT_ACTION_DESIRE_HIGH, locationAoE.targetloc
			end
			local locationAoE = bot:FindAoELocation( true, false, bot:GetLocation(), nCastRange, nRadius, 0, 0 )
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
		for _, npcEnemy in pairs( tableNearbyEnemyHeroes )
		do
			if J.IsValid( npcEnemy )
				and J.IsInRange( npcTarget, bot, nCastRange )
				and J.CanCastOnNonMagicImmune( npcEnemy )
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
		then
			return BOT_ACTION_DESIRE_HIGH, npcTarget:GetExtrapolatedLocation( nCastPoint )
		end
	end

	if bot:GetLevel() < 18
	then
		local laneCreepList = bot:GetNearbyLaneCreeps( nCastRange + 200, true )
		local allyHeroes = bot:GetNearbyHeroes( 1000, true, BOT_MODE_NONE )
		if #laneCreepList >= 3
			and #allyHeroes < 3
			and J.IsValid( laneCreepList[1] )
			and not laneCreepList[1]:HasModifier( "modifier_fountain_glyph" )
		then
			local locationAoE = bot:FindAoELocation( true, false, bot:GetLocation(), nCastRange, nRadius, 0, nDamage )
			if ( locationAoE.count >= 3 and #laneCreepList >= 3 )
			then
				return BOT_ACTION_DESIRE_HIGH, locationAoE.targetloc
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0

end

function X.ConsiderDragonTail()

	if ( not DragonTail:IsFullyCastable() ) then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastRange = DragonTail:GetCastRange()
	local nCastPoint = DragonTail:GetCastPoint()
	local nManaCost = DragonTail:GetManaCost()
	local nDamage = DragonTail:GetAbilityDamage()

	if bot:GetAttackRange() > 300
	then
		nCastRange = 400
	end

	local tableNearbyEnemyHeroes = bot:GetNearbyHeroes( nCastRange + 240, true, BOT_MODE_NONE )

	for _, npcEnemy in pairs( tableNearbyEnemyHeroes )
	do
		if J.CanCastOnNonMagicImmune( npcEnemy )
			and J.CanCastOnTargetAdvanced( npcEnemy )
			and ( J.CanKillTarget( npcEnemy, nDamage, DAMAGE_TYPE_MAGICAL ) or npcEnemy:IsChanneling() )
		then
			return BOT_ACTION_DESIRE_HIGH, npcEnemy
		end
	end


	local nEnemysHeroesInView = bot:GetNearbyHeroes( 800, true, BOT_MODE_NONE )
	if #nEnemysHeroesInView > 0 then
		for i=1, #nEnemysHeroesInView do
			if J.IsValid( nEnemysHeroesInView[i] )
				and J.CanCastOnNonMagicImmune( nEnemysHeroesInView[i] )
				and J.CanCastOnTargetAdvanced( nEnemysHeroesInView[i] )
				and nEnemysHeroesInView[i]:IsChanneling()
			then
				return BOT_ACTION_DESIRE_HIGH, nEnemysHeroesInView[i]
			end
		end
	end

	if J.IsInTeamFight( bot, 1200 )
	then
		local npcMostDangerousEnemy = nil
		local nMostDangerousDamage = 0

		for _, npcEnemy in pairs( tableNearbyEnemyHeroes )
		do
			if J.IsValid( npcEnemy )
				and J.CanCastOnNonMagicImmune( npcEnemy )
				and J.CanCastOnTargetAdvanced( npcEnemy )
				and not J.IsDisabled( npcEnemy )
				and not npcEnemy:IsDisarmed()
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
			return BOT_ACTION_DESIRE_HIGH, npcMostDangerousEnemy
		end
	end


	if J.IsRetreating( bot )
	then
		if tableNearbyEnemyHeroes ~= nil
			and #tableNearbyEnemyHeroes >= 1
			and J.CanCastOnNonMagicImmune( tableNearbyEnemyHeroes[1] )
			and J.CanCastOnTargetAdvanced( tableNearbyEnemyHeroes[1] )
			and not J.IsDisabled( tableNearbyEnemyHeroes[1] )
		then
			return BOT_ACTION_DESIRE_HIGH, tableNearbyEnemyHeroes[1]
		end
	end

	if ( bot:GetActiveMode() == BOT_MODE_ROSHAN )
	then
		local npcTarget = bot:GetAttackTarget()
		if ( J.IsRoshan( npcTarget )
			and J.IsInRange( npcTarget, bot, nCastRange + 150 )
			and not J.IsDisabled( npcTarget ) )
		then
			return BOT_ACTION_DESIRE_LOW, npcTarget
		end
	end

	if J.IsGoingOnSomeone( bot )
	then
		local npcTarget = J.GetProperTarget( bot )
		if J.IsValidHero( npcTarget )
			and J.CanCastOnNonMagicImmune( npcTarget )
			and J.CanCastOnTargetAdvanced( npcTarget )
			and J.IsInRange( npcTarget, bot, nCastRange + 240 )
			and not J.IsDisabled( npcTarget ) 
		then
			return BOT_ACTION_DESIRE_HIGH, npcTarget
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0

end

function X.ConsiderElderDragonForm()


	if ( not ElderDragonForm:IsFullyCastable() or J.GetHP( bot ) < 0.25 ) then
		return BOT_ACTION_DESIRE_NONE
	end


	local nCastPoint = ElderDragonForm:GetCastPoint()
	local nManaCost = ElderDragonForm:GetManaCost()

	if ( J.IsPushing( bot ) or J.IsFarming( bot ) or J.IsDefending( bot ) )
	then
		local tableNearbyEnemyCreeps = bot:GetNearbyCreeps( 800, true )
		local tableNearbyTowers = bot:GetNearbyTowers( 800, true )
		if #tableNearbyEnemyCreeps >= 2 or #tableNearbyTowers >= 1
		then
			return BOT_ACTION_DESIRE_MODERATE
		end
	end

	if J.IsGoingOnSomeone( bot )
	then
		local npcTarget = J.GetProperTarget( bot )
		if J.IsValidHero( npcTarget )
			and J.IsInRange( npcTarget, bot, 800 )
		then
			return BOT_ACTION_DESIRE_MODERATE
		end
	end

	return BOT_ACTION_DESIRE_NONE

end


function X.ConsiderFireball()

	if not Fireball:IsTrained()
		or not Fireball:IsFullyCastable() 
		or Fireball:IsHidden()
	then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nRadius = 450
	local nCastRange = Fireball:GetCastRange()
	local nCastPoint = Fireball:GetCastPoint()
	local nManaCost = Fireball:GetManaCost()

	if J.IsRetreating( bot )
	then
		local enemyHeroList = bot:GetNearbyHeroes( nRadius, true, BOT_MODE_NONE )
		local targetHero = enemyHeroList[1]
		if J.IsValidHero( targetHero )
			and J.CanCastOnNonMagicImmune( targetHero )
		then
			return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
		end		
	end
	

	if J.IsInTeamFight( bot, 1400 )
	then
		local nAoeLoc = J.GetAoeEnemyHeroLocation( bot, nCastRange, nRadius, 2 )
		if nAoeLoc ~= nil
		then
			return BOT_ACTION_DESIRE_HIGH, nAoeLoc
		end		
	end
	

	if J.IsGoingOnSomeone( bot )
	then
		local targetHero = J.GetProperTarget( bot )
		if J.IsValidHero( targetHero )
			and J.IsInRange( bot, targetHero, nCastRange )
			and J.CanCastOnNonMagicImmune( targetHero )
		then
			return BOT_ACTION_DESIRE_HIGH, targetHero:GetLocation()
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0

end

return X