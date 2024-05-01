local bot
local X = {}
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')

local PoisonTouch
local ShallowGrave
local ShadowWave

local nMP, nHP, hEnemyList, hAllyList

local botTarget

function X.ConsiderStolenSpell(ability)
    bot = GetBot()

    if J.CanNotUseAbility(bot) then return end

    botTarget = J.GetProperTarget(bot)
    local abilityName = ability:GetName()

	nMP = bot:GetMana() / bot:GetMaxMana()
	nHP = bot:GetHealth() / bot:GetMaxHealth()
	hEnemyList = bot:GetNearbyHeroes( 1600, true, BOT_MODE_NONE )
	hAllyList = J.GetAlliesNearLoc( bot:GetLocation(), 1600 )

    if abilityName == 'dazzle_shallow_grave'
    then
		ShallowGrave = ability
        ShallowGraveDesire, ShallowGraveTarget = X.ConsiderShallowGrave()
        if ShallowGraveDesire > 0
        then
            bot:Action_UseAbilityOnEntity(ShallowGrave, ShallowGraveTarget)
            return
        end
    end

    if abilityName == 'dazzle_poison_touch'
    then
		PoisonTouch = ability
        PoisonTouchDesire, PoisonTouchTarget = X.ConsiderPoisonTouch()
        if PoisonTouchDesire > 0
        then
            bot:Action_UseAbilityOnEntity(PoisonTouch, PoisonTouchTarget )
            return
        end
    end

    if abilityName == 'dazzle_shadow_wave'
    then
		ShadowWave = ability
        ShadowWaveDesire, ShadowWaveTarget = X.ConsiderShadowWave()
        if ShadowWaveDesire > 0
        then
            bot:Action_UseAbilityOnEntity(ShadowWave, ShadowWaveTarget)
            return
        end
    end
end

function X.ConsiderPoisonTouch()
	if not PoisonTouch:IsFullyCastable() then return 0 end

	local nSkillLV = PoisonTouch:GetLevel()
	local nCastRange = PoisonTouch:GetCastRange()
	local nRadius = 600
	local nCastPoint = PoisonTouch:GetCastPoint()
	local nManaCost = PoisonTouch:GetManaCost()
	local nPerDamage = PoisonTouch:GetSpecialValueInt( "damage" )

	local nDuration = PoisonTouch:GetSpecialValueInt( "duration" )

	local nDamage = nPerDamage * nDuration

	local nDamageType = DAMAGE_TYPE_PHYSICAL
	local nInRangeEnemyList = J.GetAroundEnemyHeroList( nCastRange )
	local nInBonusEnemyList = J.GetAroundEnemyHeroList( nCastRange + 200 )
	local hCastTarget = nil
	local sCastMotive = nil

	for _, npcEnemy in pairs( nInBonusEnemyList )
	do
		if J.IsValid( npcEnemy )
			and J.CanCastOnNonMagicImmune( npcEnemy )
			and J.CanCastOnTargetAdvanced( npcEnemy )
			and J.CanKillTarget( npcEnemy, nDamage, nDamageType )
		then
			return BOT_ACTION_DESIRE_HIGH, npcEnemy
		end
	end

	if J.IsInTeamFight( bot, 1200 )
	then
		local npcWeakestEnemy = nil
		local npcWeakestEnemyHealth = 10000

		for _, npcEnemy in pairs( hEnemyList )
		do
			if J.IsValid( npcEnemy )
				and J.CanCastOnNonMagicImmune( npcEnemy )
				and J.CanCastOnTargetAdvanced( npcEnemy )
			then
				local npcEnemyHealth = npcEnemy:GetHealth()
				if ( npcEnemyHealth < npcWeakestEnemyHealth )
				then
					npcWeakestEnemyHealth = npcEnemyHealth
					npcWeakestEnemy = npcEnemy
				end
			end
		end

		if npcWeakestEnemy ~= nil
			and J.IsInRange( bot, npcWeakestEnemy, nCastRange + 100 )
		then
			return BOT_ACTION_DESIRE_HIGH, npcWeakestEnemy
		end
	end

	if J.IsGoingOnSomeone( bot )
	then
		if J.IsValidHero( botTarget )
			and J.CanCastOnNonMagicImmune( botTarget )
			and J.IsInRange( botTarget, bot, nCastRange + 50 )
			and J.CanCastOnTargetAdvanced( botTarget )
		then
			if nSkillLV >= 2 or nMP > 0.68 or J.GetHP( botTarget ) < 0.43 or nHP <= 0.4
			then
				hCastTarget = botTarget
				sCastMotive = 'Q-进攻:'..J.Chat.GetNormName( hCastTarget )
				return BOT_ACTION_DESIRE_HIGH, hCastTarget, sCastMotive
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
				and J.CanCastOnTargetAdvanced( npcEnemy )
			then
				return BOT_ACTION_DESIRE_HIGH, npcEnemy
			end
		end
	end

	if J.IsFarming( bot )
		and nSkillLV >= 3
		and #hAllyList <= 1
		and J.IsAllowedToSpam( bot, nManaCost * 0.25 )
	then
		local nCreeps = bot:GetNearbyNeutralCreeps( nCastRange + 200 )

		local targetCreep = J.GetMostHpUnit( nCreeps )

		if J.IsValid( targetCreep )
			and not J.IsRoshan( targetCreep )
			and #nCreeps >= 3
			and bot:IsFacingLocation( targetCreep:GetLocation(), 40 )
			and ( targetCreep:GetMagicResist() < 0.3 or nMP > 0.9 )
			and not J.CanKillTarget( targetCreep, bot:GetAttackDamage() * 1.88, DAMAGE_TYPE_PHYSICAL )
		then
			return BOT_ACTION_DESIRE_HIGH, targetCreep
		end
	end

	if ( J.IsPushing( bot ) or J.IsDefending( bot ) or J.IsFarming( bot ) )
		and J.IsAllowedToSpam( bot, nManaCost )
		and nSkillLV >= 3 and DotaTime() > 6 * 60
		and #hAllyList <= 2 and #hEnemyList == 0
	then
		local nLaneCreeps = bot:GetNearbyLaneCreeps( nCastRange + 300, true )
		local targetCreep = nLaneCreeps[3]

		if #nLaneCreeps >= 4
			and J.IsValid( targetCreep )
			and not targetCreep:HasModifier( "modifier_fountain_glyph" )
			and not J.CanKillTarget( targetCreep, bot:GetAttackDamage() * 1.88, DAMAGE_TYPE_PHYSICAL )
		then
			return BOT_ACTION_DESIRE_HIGH, targetCreep
		end
	end

	if bot:GetActiveMode() == BOT_MODE_ROSHAN
		and bot:GetMana() >= 400
	then
		if J.IsRoshan( botTarget )
			and J.IsInRange( botTarget, bot, nCastRange - 200 )
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	if ( #hEnemyList > 0 or bot:WasRecentlyDamagedByAnyHero( 3.0 ) )
		and ( bot:GetActiveMode() ~= BOT_MODE_RETREAT or #hAllyList >= 2 )
		and #nInRangeEnemyList >= 1
		and nSkillLV >= 4
	then
		for _, npcEnemy in pairs( nInRangeEnemyList )
		do
			if J.IsValid( npcEnemy )
				and J.CanCastOnNonMagicImmune( npcEnemy )
				and J.CanCastOnTargetAdvanced( npcEnemy )
			then
				return BOT_ACTION_DESIRE_HIGH, npcEnemy
			end
		end
	end



	return BOT_ACTION_DESIRE_NONE


end


function X.ConsiderShallowGrave()


	if not ShallowGrave:IsFullyCastable() then return 0 end

	local nSkillLV = ShallowGrave:GetLevel()
	local nCastRange = ShallowGrave:GetCastRange()
	local nRadius = 600
	local nCastPoint = ShallowGrave:GetCastPoint()
	local nManaCost = ShallowGrave:GetManaCost()
	local nDamage = ShallowGrave:GetAbilityDamage()
	local nDamageType = DAMAGE_TYPE_PHYSICAL
	local nInRangeEnemyList = J.GetAroundEnemyHeroList( nCastRange )
	local nInBonusEnemyList = J.GetAroundEnemyHeroList( nCastRange + 200 )
	local hCastTarget = nil
	local sCastMotive = nil


	for _, npcAlly in pairs( hAllyList )
	do
		if J.IsValidHero( npcAlly )
			and J.IsInRange( bot, npcAlly, nCastRange + 600 )
			and not npcAlly:HasModifier( 'modifier_dazzle_shallow_grave' )
			and J.GetHP( npcAlly ) < 0.4
			and npcAlly:WasRecentlyDamagedByAnyHero( 3.5 )
		then
			local nCastDelay = X.GetCastShallowGraveDelay( npcAlly, nCastRange ) * 1.1
			if X.GetEnemyFacingAllyDamage( npcAlly, 1100, nCastDelay ) > npcAlly:GetHealth()
			then
				return BOT_ACTION_DESIRE_HIGH, npcAlly
			end

			if npcAlly:GetHealth() < 200
			then

				if npcAlly:HasModifier( 'modifier_sniper_assassinate' )
				then
					hCastTarget = npcAlly
					sCastMotive = "W-保护被暗杀的队友:"..J.Chat.GetNormName( hCastTarget )
					return BOT_ACTION_DESIRE_HIGH, hCastTarget, sCastMotive
				end

				if npcAlly:HasModifier( 'modifier_huskar_burning_spear_counter' )
					or npcAlly:HasModifier( 'modifier_jakiro_macropyre_burn' )
					or npcAlly:HasModifier( 'modifier_necrolyte_reapers_scythe' )
					or npcAlly:HasModifier( 'modifier_viper_viper_strike_slow' )
					or npcAlly:HasModifier( 'modifier_viper_nethertoxin' )
					or npcAlly:HasModifier( 'modifier_viper_poison_attack_slow' )
					or npcAlly:HasModifier( 'modifier_maledict' )
				then
					return BOT_ACTION_DESIRE_HIGH, npcAlly
				end

			end

			if J.GetHP( npcAlly ) < 0.13
				and J.IsInRange( bot, npcAlly, nCastRange + 200 )
				and J.GetEnemyCount( npcAlly, 600 ) >= 1
			then
				return BOT_ACTION_DESIRE_HIGH, npcAlly
			end

		end
	end


	return BOT_ACTION_DESIRE_NONE


end


function X.ConsiderShadowWave()


	if not ShadowWave:IsFullyCastable() then return 0 end

	local nSkillLV = ShadowWave:GetLevel()
	local nCastRange = ShadowWave:GetCastRange()
	local nRadius = ShadowWave:GetSpecialValueInt( 'damage_radius' )
	local nCastPoint = ShadowWave:GetCastPoint()
	local nManaCost = ShadowWave:GetManaCost()
	local nDamage = ShadowWave:GetSpecialValueInt( 'damage' )
	local nMaxHealCount = ShadowWave:GetSpecialValueInt( 'tooltip_max_targets_inc_dazzle' )
	local nDamageType = DAMAGE_TYPE_PHYSICAL
	local nInRangeAllyList = J.GetAlliesNearLoc( bot:GetLocation(), nCastRange + 300 )
	local hCastTarget = nil
	local sCastMotive = nil

	local nWeakestAlly = J.GetLeastHpUnit( nInRangeAllyList )

	local nNeedHealHeroCount = 0
	for _, npcAlly in pairs( hAllyList )
	do
		if npcAlly:GetMaxHealth() - npcAlly:GetHealth() > nDamage
		then
			nNeedHealHeroCount = nNeedHealHeroCount + 1
		end
	end
	if nWeakestAlly ~= nil
	then
		if J.GetHP( nWeakestAlly ) < 0.8
			and ( nNeedHealHeroCount >= nMaxHealCount - 2 or nNeedHealHeroCount >= 4 )
		then
			return 	BOT_ACTION_DESIRE_HIGH, nWeakestAlly
		end

		if J.GetHP( nWeakestAlly ) < 0.6
			and ( nMP > 0.9
					or nNeedHealHeroCount >= nMaxHealCount - 3
					or nNeedHealHeroCount >= 3 )
		then
			return 	BOT_ACTION_DESIRE_HIGH, nWeakestAlly
		end

		if J.GetHP( nWeakestAlly ) < 0.35
			or ( J.GetHP( nWeakestAlly ) < 0.5 and nNeedHealHeroCount >= 2 )
		then
			return 	BOT_ACTION_DESIRE_HIGH, nWeakestAlly
		end

	end

	if #hAllyList <= 2
		and #hEnemyList == 0
		and nSkillLV >= 3
		and J.IsAllowedToSpam( bot, 90 )
	then
		local allyCreepList = bot:GetNearbyLaneCreeps( 1400, false )
		local needHealCreepCount = 0
		for _, creep in pairs( allyCreepList )
		do
			if creep:GetMaxHealth() - creep:GetHealth() > nDamage
			then
				needHealCreepCount = needHealCreepCount + 1
			elseif creep:GetMaxHealth() - creep:GetHealth() > nDamage * 0.6
			then
				needHealCreepCount = needHealCreepCount + 0.6
			end
		end
		if needHealCreepCount >= nMaxHealCount - 1
		then
			local nWeakestCreep = J.GetLeastHpUnit( allyCreepList )
			if nWeakestCreep ~= nil
			then
				return 	BOT_ACTION_DESIRE_HIGH, nWeakestCreep
			end
		end
	end

	local ShadowWaveTotalDamage = 0
	for _, npcEnemy in pairs( hEnemyList )
	do
		if J.IsValidHero( npcEnemy )
			and J.IsInRange( bot, npcEnemy, nCastRange + 300 )
			and J.CanCastOnMagicImmune( npcEnemy )
		then
			local allyUnitCount = J.GetUnitAllyCountAroundEnemyTarget( npcEnemy, nRadius )
			if J.CanKillTarget( npcEnemy, allyUnitCount * nDamage, nDamageType )
			then
				hCastTarget = X.GetBestHealTarget( npcEnemy, nRadius )
				if hCastTarget ~= nil
				then
					return BOT_ACTION_DESIRE_HIGH, hCastTarget
				end
			end

			if allyUnitCount >= 1 and nSkillLV >= 3
			then
				ShadowWaveTotalDamage = ShadowWaveTotalDamage + allyUnitCount * nDamage
			end
			if ShadowWaveTotalDamage >= 800
				and nWeakestAlly ~= nil
				and J.IsInRange( bot, nWeakestAlly, nCastRange + 50 )
			then
				return BOT_ACTION_DESIRE_HIGH, nWeakestAlly
			end
		end
	end

	if J.IsGoingOnSomeone( bot )
	then
		if J.IsValidHero( botTarget )
			and J.IsInRange( bot, botTarget, nCastRange + 200 )
			and J.CanCastOnMagicImmune( botTarget )
		then
			local allyUnitCount = J.GetUnitAllyCountAroundEnemyTarget( botTarget, nRadius )
			if allyUnitCount >= nMaxHealCount - 2
				or allyUnitCount >= 4
			then
				hCastTarget = X.GetBestHealTarget( botTarget, nRadius )
				if hCastTarget ~= nil
				then
					return 	BOT_ACTION_DESIRE_HIGH, hCastTarget
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE


end

function X.GetBestHealTarget( npcEnemy, nRadius )

	local bestTarget = nil
	local maxLostHealth = -1

	local allyCreepList = bot:GetNearbyCreeps( 1600, false )
	local allyHeroList = bot:GetNearbyHeroes( 1600, false, BOT_MODE_NONE )
	local allyUnit = J.CombineTwoTable( allyCreepList, allyHeroList )


	for _, unit in pairs( allyUnit )
	do 
		if J.IsInRange( npcEnemy, unit, nRadius + 9 )
			and unit:GetMaxHealth() - unit:GetHealth() > maxLostHealth
		then
			maxLostHealth = unit:GetMaxHealth() - unit:GetHealth()
			bestTarget = unit
		end
	end

	return bestTarget

end


function X.GetCastShallowGraveDelay( npcAlly, nCastRange )

	if not J.IsInRange( bot, npcAlly, nCastRange )
	then
		local nDistance = GetUnitToUnitDistance( bot, npcAlly ) - nCastRange
		local moveDelay = nDistance/bot:GetCurrentMovementSpeed()

		return 0.4 + moveDelay + 1.3
	end

	return 0.4 + 1.1

end


function X.GetShadowWaveMaxDamage( npcEnemy )

	local nRadius = ShadowWave:GetSpecialValueInt( 'damage_radius' )

	local allyUnitCount = J.GetUnitAllyCountAroundEnemyTarget( npcEnemy, nRadius )

	local ShadowWaveDamge = ShadowWave:GetSpecialValueInt( 'damage' )

	return allyUnitCount * nDamage

end


function X.GetEnemyFacingAllyDamage( npcAlly, nRadius, nDelay )

	local enemyList = J.GetEnemyList( npcAlly, nRadius )
	local totalDamage = 0

	for _, npcEnemy in pairs( enemyList )
	do
		if npcEnemy:IsFacingLocation( npcAlly:GetLocation(), 15 )
			or npcEnemy:GetAttackTarget() == npcAlly
		then
			local enemyDamage = npcEnemy:GetEstimatedDamageToTarget( false, npcAlly, nDelay, DAMAGE_TYPE_ALL )
			totalDamage = totalDamage + enemyDamage
		end
	end

	return totalDamage

end

return X