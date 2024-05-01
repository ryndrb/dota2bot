local bot
local X = {}
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')

local CryptSwarm
local Silence
local SpiritSiphon
local Exorcism

local botTarget

local nMP, nLV, hEnemyList, hAllyList

function X.ConsiderStolenSpell(ability)
    bot = GetBot()

    if J.CanNotUseAbility(bot) then return end

    botTarget = J.GetProperTarget(bot)
    local abilityName = ability:GetName()

	nLV = bot:GetLevel()
	nMP = bot:GetMana()/bot:GetMaxMana()
	hEnemyList = bot:GetNearbyHeroes( 1600, true, BOT_MODE_NONE )
	hAllyList = J.GetAlliesNearLoc( bot:GetLocation(), 1600 )

    if abilityName == 'death_prophet_silence'
    then
        Silence = ability
        SilenceDesire, SilenceLocation = X.ConsiderSilence()
        if SilenceDesire > 0
        then
            bot:Action_UseAbilityOnLocation(Silence, SilenceLocation)
            return
        end
    end

    if abilityName == 'death_prophet_exorcism'
    then
        Exorcism = ability
        ExorcismDesire = X.ConsiderExorcism()
        if ExorcismDesire > 0
        then
            bot:Action_UseAbility(Exorcism)
            return
        end
    end

    if abilityName == 'death_prophet_spirit_siphon'
    then
        SpiritSiphon = ability
        SpiritSiphonDesire, SpiritSiphonTarget = X.ConsiderSpiritSiphon()
        if SpiritSiphonDesire > 0
        then
            bot:Action_UseAbilityOnEntity(SpiritSiphon, SpiritSiphonTarget )
            return
        end
    end

    if abilityName == 'death_prophet_carrion_swarm'
    then
        CryptSwarm = ability
        CryptSwarmDesire, CryptSwarmLocation = X.ConsiderCryptSwarm()
        if CryptSwarmDesire > 0
        then
            bot:Action_UseAbilityOnLocation(CryptSwarm, CryptSwarmLocation )
            return
        end
    end
end

function X.ConsiderCryptSwarm()


	if not CryptSwarm:IsFullyCastable() then return 0 end

	local nSkillLV = CryptSwarm:GetLevel()
	local nCastRange = CryptSwarm:GetCastRange()
	local nCastPoint = CryptSwarm:GetCastPoint()
	local nManaCost = CryptSwarm:GetManaCost()
	local nDamage = CryptSwarm:GetAbilityDamage()
	local nDamageType = DAMAGE_TYPE_MAGICAL
	local nRadius = CryptSwarm:GetSpecialValueInt( "end_radius" )
	local nInRangeEnemyList = bot:GetNearbyHeroes( nCastRange - 50, true, BOT_MODE_NONE )
	local nTargetLocation = nil

	for _, npcEnemy in pairs( nInRangeEnemyList )
	do
		if J.IsValidHero( npcEnemy )
			and J.CanCastOnNonMagicImmune( npcEnemy )
			and J.WillMagicKillTarget( bot, npcEnemy, nDamage, nCastPoint )
		then
			nTargetLocation = npcEnemy:GetLocation()
			return BOT_ACTION_DESIRE_HIGH, nTargetLocation
		end
	end

	local nCanHurtEnemyAoE = bot:FindAoELocation( true, true, bot:GetLocation(), nCastRange, nRadius + 50, 0, 0 )
	if nCanHurtEnemyAoE.count >= 3 and bot:GetActiveMode() ~= BOT_MODE_RETREAT
	then
		nTargetLocation = nCanHurtEnemyAoE.targetloc
		return BOT_ACTION_DESIRE_HIGH, nTargetLocation
	end

	if J.IsLaning( bot )
	then
		local nAoeLoc = J.GetAoeEnemyHeroLocation( bot, nCastRange - 80, nRadius, 2 )
		if nAoeLoc ~= nil and nMP > 0.58
		then
			nTargetLocation = nAoeLoc
			return BOT_ACTION_DESIRE_HIGH, nTargetLocation
		end

		if #hAllyList == 1 and nMP > 0.38
		then
			local locationAoEKill = bot:FindAoELocation( true, false, bot:GetLocation(), nCastRange, nRadius + 50, 0, nDamage )
			if locationAoEKill.count >= 3
			then
				nTargetLocation = locationAoEKill.targetloc
				return BOT_ACTION_DESIRE_HIGH, nTargetLocation
			end
		end
	end

	if J.IsInTeamFight( bot, 1200 )
	then
		local nAoeLoc = J.GetAoeEnemyHeroLocation( bot, nCastRange, nRadius, 2 )
		if nAoeLoc ~= nil
		then
			nTargetLocation = nAoeLoc
			return BOT_ACTION_DESIRE_HIGH, nTargetLocation
		end
	end

	if J.IsGoingOnSomeone( bot )
	then
		if J.IsValidHero( botTarget )
			and J.CanCastOnNonMagicImmune( botTarget )
			and J.IsInRange( botTarget, bot, nCastRange -80 )
		then
			if nSkillLV >= 2 or nMP > 0.68 or J.GetHP( botTarget ) < 0.38
			then
				nTargetLocation = botTarget:GetExtrapolatedLocation( nCastPoint )
				if J.IsInLocRange( bot, nTargetLocation, nCastRange )
				then
					return BOT_ACTION_DESIRE_HIGH, nTargetLocation
				end
			end
		end
	end

	if J.IsRetreating( bot )
	then
		for _, npcEnemy in pairs( nInRangeEnemyList )
		do
			if J.IsValid( npcEnemy )
				and bot:WasRecentlyDamagedByHero( npcEnemy, 5.0 )
				and J.CanCastOnNonMagicImmune( npcEnemy )
				and bot:IsFacingLocation( npcEnemy:GetLocation(), 30 )
			then
				nTargetLocation = npcEnemy:GetLocation()
				return BOT_ACTION_DESIRE_HIGH, nTargetLocation
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
			and ( botTarget:GetMagicResist() < 0.4 or nMP > 0.9 )
		then
			local nShouldHurtCount = nMP > 0.6 and 2 or 3
			local locationAoE = bot:FindAoELocation( true, false, bot:GetLocation(), nCastRange, nRadius, 0, 0 )
			if ( locationAoE.count >= nShouldHurtCount )
			then
				nTargetLocation = locationAoE.targetloc
				return BOT_ACTION_DESIRE_HIGH, nTargetLocation
			end
		end
	end

	if ( J.IsPushing( bot ) or J.IsDefending( bot ) or J.IsFarming( bot ) )
		and J.IsAllowedToSpam( bot, nManaCost * 0.32 )
		and nSkillLV >= 2 and DotaTime() > 8 * 60
		and #hAllyList <= 3 and #hEnemyList == 0
	then
		local laneCreepList = bot:GetNearbyLaneCreeps( nCastRange + 400, true )
		if #laneCreepList >= 3
			and J.IsValid( laneCreepList[1] )
			and not laneCreepList[1]:HasModifier( "modifier_fountain_glyph" )
		then
			local locationAoEKill = bot:FindAoELocation( true, false, bot:GetLocation(), nCastRange, nRadius, 0, nDamage )
			if locationAoEKill.count >= 2
	 			and #hAllyList == 1
			then
				nTargetLocation = locationAoEKill.targetloc
				return BOT_ACTION_DESIRE_HIGH, nTargetLocation
			end

			local locationAoEHurt = bot:FindAoELocation( true, false, bot:GetLocation(), nCastRange, nRadius + 50, 0, 0 )
			if ( locationAoEHurt.count >= 3 and #laneCreepList >= 4 )
			then
				nTargetLocation = locationAoEHurt.targetloc
				return BOT_ACTION_DESIRE_HIGH, nTargetLocation
			end
		end
	end

	if bot:GetActiveMode() == BOT_MODE_ROSHAN
		and bot:GetMana() >= 900
	then
		if J.IsRoshan( botTarget ) and J.GetHP( botTarget ) > 0.15
			and J.IsInRange( botTarget, bot, nCastRange )
		then
			nTargetLocation = botTarget:GetLocation()
			return BOT_ACTION_DESIRE_HIGH, nTargetLocation
		end
	end

	if ( #hEnemyList > 0 or bot:WasRecentlyDamagedByAnyHero( 3.0 ) )
		and ( bot:GetActiveMode() ~= BOT_MODE_RETREAT or #hAllyList >= 2 )
		and #nInRangeEnemyList >= 1
		and nLV >= 15 and false --there be bug
	then
		for _, npcEnemy in pairs( nInRangeEnemyList )
		do
			if J.IsValid( npcEnemy )
				and J.CanCastOnNonMagicImmune( npcEnemy ) 
				and J.IsInRange( bot, npcEnemy, nCastRange - 200 )
			then
				nTargetLocation = npcEnemy:GetLocation()
				return BOT_ACTION_DESIRE_HIGH, nTargetLocation
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE


end

function X.ConsiderSilence()


	if not Silence:IsFullyCastable() then return 0 end

	local nSkillLV = Silence:GetLevel()
	local nCastRange = Silence:GetCastRange()
	local nRadius	 = Silence:GetSpecialValueInt( 'radius' )
	local nCastPoint = Silence:GetCastPoint()
	local nManaCost = Silence:GetManaCost()
	local nDamage = Silence:GetAbilityDamage()
	local nDamageType = DAMAGE_TYPE_MAGICAL
	local nInRangeEnemyList = bot:GetNearbyHeroes( nCastRange, true, BOT_MODE_NONE )
	local nTargetLocation = nil

	for _, npcEnemy in pairs( hEnemyList )
	do
		if npcEnemy:IsChanneling()
			and not npcEnemy:HasModifier( 'modifier_teleporting' )
			and J.IsInRange( bot, npcEnemy, nCastRange + nRadius )
			and J.CanCastOnNonMagicImmune( npcEnemy )
		then
			nTargetLocation = J.GetCastLocation( bot, npcEnemy, nCastRange, nRadius )
			if nTargetLocation ~= nil
			then
				return BOT_ACTION_DESIRE_HIGH, nTargetLocation
			end
		end
	end


	if J.IsGoingOnSomeone( bot )
	then
		local nAoeLoc = J.GetAoeEnemyHeroLocation( bot, nCastRange, nRadius, 2 )
		if nAoeLoc ~= nil
		then
			nTargetLocation = nAoeLoc
			return BOT_ACTION_DESIRE_HIGH, nTargetLocation
		end


		if J.IsValidHero( botTarget )
			and J.IsInRange( bot, botTarget, nCastRange + nRadius - 200 )
			and J.CanCastOnNonMagicImmune( botTarget )
			and ( J.IsInRange( bot, botTarget, 700 ) or botTarget:IsFacingLocation( bot:GetLocation(), 40 ) )
			and not J.IsDisabled( botTarget )
		then
			nTargetLocation = J.GetCastLocation( bot, botTarget, nCastRange, nRadius )
			if nTargetLocation ~= nil
			then
				return BOT_ACTION_DESIRE_HIGH, nTargetLocation
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE

end

function X.ConsiderSpiritSiphon()


	if not SpiritSiphon:IsFullyCastable() then return 0 end

	local nSkillLV = SpiritSiphon:GetLevel()
	local nCastRange = SpiritSiphon:GetCastRange()
	local nCastPoint = SpiritSiphon:GetCastPoint()
	local nManaCost = SpiritSiphon:GetManaCost()
	local nDamage = SpiritSiphon:GetAbilityDamage()
	local nDamageType = DAMAGE_TYPE_MAGICAL
	local nInRangeEnemyList = bot:GetNearbyHeroes( nCastRange, true, BOT_MODE_NONE )

	if J.IsGoingOnSomeone( bot )
	then
		if J.IsValidHero( botTarget )
			and J.IsInRange( bot, botTarget, nCastRange )
			and J.CanCastOnNonMagicImmune( botTarget )
			and J.CanCastOnTargetAdvanced( botTarget )
			and not botTarget:HasModifier( "modifier_death_prophet_spirit_siphon_slow" )
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end


	if J.IsInTeamFight( bot, 1200 )
	then
		for _, npcEnemy in pairs( nInRangeEnemyList )
		do
			if J.IsValidHero( npcEnemy )
				and J.CanCastOnNonMagicImmune( npcEnemy )
				and J.CanCastOnTargetAdvanced( npcEnemy )
				and not npcEnemy:HasModifier( "modifier_death_prophet_spirit_siphon_slow" )
			then
				return BOT_ACTION_DESIRE_HIGH, npcEnemy
			end
		end
	end


	if J.IsRetreating( bot )
	then
		for _, npcEnemy in pairs( nInRangeEnemyList )
		do
			if J.IsValidHero( npcEnemy )
				and J.CanCastOnNonMagicImmune( npcEnemy )
				and J.CanCastOnTargetAdvanced( npcEnemy )
				and not npcEnemy:HasModifier( "modifier_death_prophet_spirit_siphon_slow" )
			then
				return BOT_ACTION_DESIRE_HIGH, npcEnemy
			end
		end
	end


	return BOT_ACTION_DESIRE_NONE


end

function X.ConsiderExorcism()

	if not Exorcism:IsFullyCastable()
		or bot:HasModifier( 'modifier_death_prophet_exorcism' )
	then return 0 end

	local nSkillLV = Exorcism:GetLevel()
	local nCastRange = Exorcism:GetCastRange()
	local nCastPoint = Exorcism:GetCastPoint()
	local nManaCost = Exorcism:GetManaCost()
	local nDamage = Exorcism:GetAbilityDamage()
	local nDamageType = DAMAGE_TYPE_MAGICAL
	local nInRangeEnemyList = bot:GetNearbyHeroes( nCastRange, true, BOT_MODE_NONE )


	if J.IsGoingOnSomeone( bot )
	then
		if J.IsValidHero( botTarget )
			and ( J.IsInRange( bot, botTarget, 700 )
					or ( #hEnemyList >= 3 and J.IsInRange( bot, botTarget, 1200 ) ) )
			and J.CanCastOnMagicImmune( botTarget )
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	local nAllyCreepList = bot:GetNearbyLaneCreeps( 1000, false )
	if J.IsPushing( bot ) and #nAllyCreepList >= 1
	then
		if J.IsValidBuilding( botTarget )
			and J.IsInRange( bot, botTarget, 800 )
			and not botTarget:HasModifier( 'modifier_fountain_glyph' )
			and not botTarget:HasModifier( 'modifier_backdoor_protection' )
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	return BOT_ACTION_DESIRE_NONE


end

return X