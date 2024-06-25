local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local Frostbite

function X.Cast()
    bot = GetBot()
    Frostbite = bot:GetAbilityByName('crystal_maiden_frostbite')

    Desire, Target = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(Frostbite, Target)
        return
    end
end

function X.Consider()
    if not Frostbite:IsFullyCastable() then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = J.GetProperCastRange(false, bot, Frostbite:GetCastRange() + 30)
	local nCastPoint = Frostbite:GetCastPoint()
    local nDPS = Frostbite:GetSpecialValueInt('damage_per_second')
    local nDuration = Frostbite:GetSpecialValueFloat('duration')
	local nDamage = ( nDPS * nDuration )

	local nAllies =  bot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE )

	local nEnemysHeroesInView = bot:GetNearbyHeroes( 1600, true, BOT_MODE_NONE )
	if nEnemysHeroesInView ~= nil and #nEnemysHeroesInView <= 1 and nCastRange < bot:GetAttackRange() then nCastRange = bot:GetAttackRange() + 60 end
	local nEnemysHeroesInRange = bot:GetNearbyHeroes( nCastRange, true, BOT_MODE_NONE )
	local nEnemysHeroesInBonus = bot:GetNearbyHeroes( nCastRange + 200, true, BOT_MODE_NONE )

	local nWeakestEnemyHeroInRange, nWeakestEnemyHeroHealth1 = X.cm_GetWeakestUnit( nEnemysHeroesInRange )
	local nWeakestEnemyHeroInBonus, nWeakestEnemyHeroHealth2 = X.cm_GetWeakestUnit( nEnemysHeroesInBonus )

	local nEnemysCreeps1 = bot:GetNearbyCreeps( nCastRange + 100, true )
	local nEnemysCreeps2 = bot:GetNearbyCreeps( 1400, true )

	local nEnemysStrongestCreeps1, nEnemysStrongestCreepsHealth1 = X.cm_GetStrongestUnit( nEnemysCreeps1 )
	local nEnemysStrongestCreeps2, nEnemysStrongestCreepsHealth2 = X.cm_GetStrongestUnit( nEnemysCreeps2 )

	local nTowers = bot:GetNearbyTowers( 900, true )

	if J.IsValidHero( nWeakestEnemyHeroInRange )
		and J.CanCastOnTargetAdvanced( nWeakestEnemyHeroInRange )
	then
		if J.WillMagicKillTarget( bot, nWeakestEnemyHeroInRange, nDamage, nCastPoint )
		then
			return BOT_ACTION_DESIRE_HIGH, nWeakestEnemyHeroInRange
		end
	end

	for _, npcEnemy in pairs( nEnemysHeroesInBonus )
	do
		if J.IsValidHero( npcEnemy )
			and npcEnemy:IsChanneling()
			and npcEnemy:HasModifier( 'modifier_teleporting' )
			and J.CanCastOnNonMagicImmune( npcEnemy )
			and J.CanCastOnTargetAdvanced( npcEnemy )
		then
			return BOT_ACTION_DESIRE_HIGH, npcEnemy
		end
	end

	if J.IsInTeamFight( bot, 1200 )
		and  DotaTime() > 6 * 60
	then
		local npcMostDangerousEnemy = nil
		local nMostDangerousDamage = 0

		for _, npcEnemy in pairs( nEnemysHeroesInRange )
		do
			if J.IsValidHero( npcEnemy )
				and J.CanCastOnNonMagicImmune( npcEnemy )
				and J.CanCastOnTargetAdvanced( npcEnemy )
				and not J.IsDisabled( npcEnemy )
				and not npcEnemy:IsDisarmed()
			then
				local npcEnemyDamage = npcEnemy:GetEstimatedDamageToTarget( false, bot, 3.0, DAMAGE_TYPE_ALL )
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

	if bot:WasRecentlyDamagedByAnyHero( 3.0 )
		and #nEnemysHeroesInRange >= 1
	then
		for _, npcEnemy in pairs( nEnemysHeroesInRange )
		do
			if J.IsValidHero( npcEnemy )
				and J.CanCastOnNonMagicImmune( npcEnemy )
				and J.CanCastOnTargetAdvanced( npcEnemy )
				and not J.IsDisabled( npcEnemy )
				and not npcEnemy:IsDisarmed()
				and bot:IsFacingLocation( npcEnemy:GetLocation(), 45 )
			then
				return BOT_ACTION_DESIRE_HIGH, npcEnemy
			end
		end
	end

	if J.IsLaning(bot) and nTowers ~= nil and #nTowers == 0
	then
		if( J.GetMP(bot) > 0.5 or bot:GetMana()> 250 )
		then
			if J.IsValidHero( nWeakestEnemyHeroInRange )
				and not J.IsDisabled( nWeakestEnemyHeroInRange )
			then
				return BOT_ACTION_DESIRE_HIGH, nWeakestEnemyHeroInRange
			end
		end

		if( J.GetMP(bot) > 0.78 or bot:GetMana()> 250 )
		then
			if J.IsValidHero( nWeakestEnemyHeroInBonus )
				and J.GetHP(bot) > 0.6
				and nTowers ~= nil and #nTowers == 0
				and (nEnemysCreeps2 ~= nil and #nEnemysCreeps2 + #nEnemysHeroesInBonus <= 5)
				and not J.IsDisabled( nWeakestEnemyHeroInBonus )
				and nWeakestEnemyHeroInBonus:GetCurrentMovementSpeed() < bot:GetCurrentMovementSpeed()
			then
				return BOT_ACTION_DESIRE_HIGH, nWeakestEnemyHeroInBonus
			end
		end


		if J.IsValidHero( nEnemysHeroesInView[1] )
		then
			if J.GetAllyUnitCountAroundEnemyTarget( bot, nEnemysHeroesInView[1], 350 ) >= 5
				and not J.IsDisabled( nEnemysHeroesInView[1] )
				and not nEnemysHeroesInView[1]:IsMagicImmune()
				and J.GetHP(bot) > 0.7
				and bot:GetMana()> 250
				and nEnemysCreeps2 ~= nil and #nEnemysCreeps2 + #nEnemysHeroesInBonus <= 3
				and nTowers ~= nil and #nTowers == 0
			then
				return BOT_ACTION_DESIRE_HIGH, nEnemysHeroesInView[1]
			end
		end

		if J.IsValidHero( nWeakestEnemyHeroInRange )
		then
			if J.GetHP(nWeakestEnemyHeroInRange) < 0.5
			then
				return BOT_ACTION_DESIRE_HIGH, nWeakestEnemyHeroInRange
			end
		end
	end

	if nEnemysHeroesInRange[1] == nil
		and nEnemysCreeps1[1] ~= nil
	then
		for _, EnemyplayerCreep in pairs( nEnemysCreeps1 )
		do
			if J.IsValid( EnemyplayerCreep )
				and EnemyplayerCreep:GetTeam() == GetOpposingTeam()
				and EnemyplayerCreep:GetHealth() > 460
				and not EnemyplayerCreep:IsMagicImmune()
				and not EnemyplayerCreep:IsInvulnerable()
				and ( EnemyplayerCreep:IsDominated()  --[[or EnemyplayerCreep:IsMinion()]] )
			then
				return BOT_ACTION_DESIRE_HIGH, EnemyplayerCreep
			end
		end
	end

	if bot:GetActiveMode() ~= BOT_MODE_LANING
		and  bot:GetActiveMode() ~= BOT_MODE_RETREAT
		and  bot:GetActiveMode() ~= BOT_MODE_ATTACK
		and  nEnemysHeroesInView ~= nil and #nEnemysHeroesInView == 0
		and  nAllies ~= nil and #nAllies < 3
		and  bot:GetLevel() >= 5
	then
		if J.IsValid( nEnemysStrongestCreeps2 )
			and ( DotaTime() > 10 * 60
				or ( nEnemysStrongestCreeps2:GetUnitName() ~= 'npc_dota_creep_badguys_melee'
					and nEnemysStrongestCreeps2:GetUnitName() ~= 'npc_dota_creep_badguys_ranged'
					and nEnemysStrongestCreeps2:GetUnitName() ~= 'npc_dota_creep_goodguys_melee'
					and nEnemysStrongestCreeps2:GetUnitName() ~= 'npc_dota_creep_goodguys_ranged' ) )
		then
			if ( nEnemysStrongestCreepsHealth2 > 460 or ( nEnemysStrongestCreepsHealth1 > 390 and J.GetMP(bot) > 0.45 ) )
				and nEnemysStrongestCreepsHealth2 <= 1200
			then
				return BOT_ACTION_DESIRE_LOW, nEnemysStrongestCreeps2
			end
		end

		if J.IsValid( nEnemysStrongestCreeps1 )
			and ( DotaTime() > 10 * 60
				or ( nEnemysStrongestCreeps1:GetUnitName() ~= 'npc_dota_creep_badguys_melee'
					and nEnemysStrongestCreeps1:GetUnitName() ~= 'npc_dota_creep_badguys_ranged'
					and nEnemysStrongestCreeps1:GetUnitName() ~= 'npc_dota_creep_goodguys_melee'
					and nEnemysStrongestCreeps1:GetUnitName() ~= 'npc_dota_creep_goodguys_ranged' ) )
		then
			if ( nEnemysStrongestCreepsHealth1 > 410 or ( nEnemysStrongestCreepsHealth1 > 360 and J.GetMP(bot) > 0.45 ) )
				and nEnemysStrongestCreepsHealth1 <= 1200
			then
				return BOT_ACTION_DESIRE_LOW, nEnemysStrongestCreeps1
			end
		end

	end

	if J.IsGoingOnSomeone( bot )
	then
		local npcTarget = J.GetProperTarget( bot )
		if J.IsValidHero( npcTarget )
			and J.CanCastOnNonMagicImmune( npcTarget )
			and J.CanCastOnTargetAdvanced( npcTarget )
			and J.IsInRange( npcTarget, bot, nCastRange + 50 )
			and not J.IsDisabled( npcTarget )
			and not npcTarget:IsDisarmed()
		then
			return BOT_ACTION_DESIRE_HIGH, npcTarget
		end
	end

	if J.IsRetreating( bot )
    and not J.IsRealInvisible(bot)
	then
		for _, npcEnemy in pairs( nEnemysHeroesInRange )
		do
			if J.IsValidHero( npcEnemy )
				and bot:WasRecentlyDamagedByHero( npcEnemy, 5.0 )
				and J.CanCastOnNonMagicImmune( npcEnemy )
				and J.CanCastOnTargetAdvanced( npcEnemy )
				and not J.IsDisabled( npcEnemy )
				and J.IsInRange( npcEnemy, bot, nCastRange - 80 )
			then
				return BOT_ACTION_DESIRE_HIGH, npcEnemy
			end
		end
	end


	if J.IsDoingRoshan(bot)
	then
		local npcTarget = bot:GetAttackTarget()
		if J.IsRoshan( npcTarget )
			and not J.IsDisabled( npcTarget )
			and not npcTarget:IsDisarmed()
			and J.IsInRange( npcTarget, bot, nCastRange )
            and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH, npcTarget
		end
	end


	return BOT_ACTION_DESIRE_NONE, nil
end

function X.cm_GetWeakestUnit( nEnemyUnits )

	local nWeakestUnit = nil
	local nWeakestUnitLowestHealth = 10000
	for _, unit in pairs( nEnemyUnits )
	do
		if J.IsValid(unit)
        and J.CanCastOnNonMagicImmune( unit )
		then
			if unit:GetHealth() < nWeakestUnitLowestHealth
			then
				nWeakestUnitLowestHealth = unit:GetHealth()
				nWeakestUnit = unit
			end
		end
	end

	return nWeakestUnit, nWeakestUnitLowestHealth
end

function X.cm_GetStrongestUnit( nEnemyUnits )

	local nStrongestUnit = nil
	local nStrongestUnitHealth = GetBot():GetAttackDamage()

	for _, unit in pairs( nEnemyUnits )
	do
		if 	J.IsValid(unit)
			and not unit:HasModifier( 'modifier_fountain_glyph' )
			-- and not unit:IsIllusion()
			and not unit:IsMagicImmune()
			and not unit:IsInvulnerable()
			and unit:GetHealth() <= 1100
			and not unit:IsAncientCreep()
			and unit:GetMagicResist() < 1.05 - unit:GetHealth()/1100
			-- and not unit:WasRecentlyDamagedByAnyHero( 2.5 )
			and not J.IsOtherAllysTarget( unit )
			and string.find( unit:GetUnitName(), 'siege' ) == nil
			and ( bot:GetLevel() < 25 or unit:GetTeam() == TEAM_NEUTRAL )
		then
			if string.find( unit:GetUnitName(), 'ranged' ) ~= nil
				and unit:GetHealth() > GetBot():GetAttackDamage() * 2
			then
				return unit, 500
			end

			if unit:GetHealth() > nStrongestUnitHealth
			then
				nStrongestUnitHealth = unit:GetHealth()
				nStrongestUnit = unit
			end
		end
	end

	return nStrongestUnit, nStrongestUnitHealth
end

return X