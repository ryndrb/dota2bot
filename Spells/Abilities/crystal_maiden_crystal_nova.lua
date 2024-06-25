local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local CrystalNova

function X.Cast()
    bot = GetBot()
    CrystalNova = bot:GetAbilityByName('crystal_maiden_crystal_nova')

    Desire, Location = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(CrystalNova, Location)
        return
    end
end

function X.Consider()
    if not CrystalNova:IsFullyCastable() then return BOT_ACTION_DESIRE_NONE, 0 end

	local nRadius = CrystalNova:GetSpecialValueInt( 'radius' )
	local nCastRange = J.GetProperCastRange(false, bot, CrystalNova:GetCastRange())
	local nDamage = CrystalNova:GetSpecialValueInt( 'nova_damage' )
	local nSkillLV = CrystalNova:GetLevel()

	local nAllys =  bot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE )

	local nEnemysHeroesInRange = bot:GetNearbyHeroes( math.min(nCastRange + nRadius, 1600), true, BOT_MODE_NONE )
	local nEnemysHeroesInBonus = bot:GetNearbyHeroes( math.min(nCastRange + nRadius + 150, 1600), true, BOT_MODE_NONE )
	local nEnemysHeroesInView = bot:GetNearbyHeroes( 1600, true, BOT_MODE_NONE )
	local nWeakestEnemyHeroInRange, nWeakestEnemyHeroHealth1 = X.cm_GetWeakestUnit( nEnemysHeroesInRange )
	local nWeakestEnemyHeroInBonus, nWeakestEnemyHeroHealth2 = X.cm_GetWeakestUnit( nEnemysHeroesInBonus )

	local nEnemysLaneCreeps1 = bot:GetNearbyLaneCreeps( math.min(nCastRange + nRadius, 1600), true )
	local nEnemysLaneCreeps2 = bot:GetNearbyLaneCreeps( math.min(nCastRange + nRadius + 200, 1600), true )
	local nEnemysWeakestLaneCreeps1, nEnemysWeakestLaneCreepsHealth1 = X.cm_GetWeakestUnit( nEnemysLaneCreeps1 )
	local nEnemysWeakestLaneCreeps2, nEnemysWeakestLaneCreepsHealth2 = X.cm_GetWeakestUnit( nEnemysLaneCreeps2 )

	local nTowers = bot:GetNearbyTowers( 1000, true )

	local nCanKillHeroLocationAoE = bot:FindAoELocation( true, true, bot:GetLocation(), nCastRange, nRadius , 0.8, nDamage )
	local nCanHurtHeroLocationAoE = bot:FindAoELocation( true, true, bot:GetLocation(), nCastRange, nRadius , 0.8, 0 )
	local nCanKillCreepsLocationAoE = bot:FindAoELocation( true, false, bot:GetLocation(), nCastRange + nRadius, nRadius, 0.5, nDamage )
	local nCanHurtCreepsLocationAoE = bot:FindAoELocation( true, false, bot:GetLocation(), nCastRange + nRadius, nRadius, 0.5, 0 )

    local botTarget = J.GetProperTarget( bot )

	if nCanKillHeroLocationAoE.count ~= nil
		and nCanKillHeroLocationAoE.count >= 1
	then
		if J.IsValidHero( nWeakestEnemyHeroInBonus )
		then
			local nTargetLocation = J.GetCastLocation( bot, nWeakestEnemyHeroInBonus, nCastRange, nRadius )
			if nTargetLocation ~= nil
			then
				return BOT_ACTION_DESIRE_HIGH, nTargetLocation
			end
		end
	end

	if J.IsLaning(bot)
		and nTowers ~= nil and #nTowers <= 0
		and J.GetHP(bot) >= 0.4
	then
		if nCanHurtHeroLocationAoE.count >= 2
			and GetUnitToLocationDistance( bot, nCanHurtHeroLocationAoE.targetloc ) <= nCastRange + 50
		then
			return BOT_ACTION_DESIRE_HIGH, nCanHurtHeroLocationAoE.targetloc
		end
	end

	if J.IsRetreating(bot)
		and bot:WasRecentlyDamagedByAnyHero( 2.5 )
        and not J.IsRealInvisible(bot)
	then
		local nCanHurtHeroLocationAoENearby = bot:FindAoELocation( true, true, bot:GetLocation(), nCastRange - 300, nRadius, 0.8, 0 )
		if nCanHurtHeroLocationAoENearby.count >= 1
		then
			return BOT_ACTION_DESIRE_HIGH, nCanHurtHeroLocationAoENearby.targetloc
		end
	end

	if J.IsGoingOnSomeone( bot )
	then
		if J.IsValidHero( nWeakestEnemyHeroInBonus )
			and nCanHurtHeroLocationAoE.count >= 2
			and GetUnitToLocationDistance( bot, nCanHurtHeroLocationAoE.targetloc ) <= nCastRange
		then
			return BOT_ACTION_DESIRE_HIGH, nCanHurtHeroLocationAoE.targetloc
		end

		if J.IsValidHero( botTarget )
			and J.CanCastOnNonMagicImmune( botTarget )
		then

			--蓝很多随意用
			if J.GetMP(bot) > 0.75
				or bot:GetMana() > 400
			then
				local nTargetLocation = J.GetCastLocation( bot, botTarget, nCastRange, nRadius )
				if nTargetLocation ~= nil
				then
					return BOT_ACTION_DESIRE_HIGH, nTargetLocation
				end
			end

			if ( J.GetHP(botTarget) < 0.4 )
				and GetUnitToUnitDistance( botTarget, bot ) <= nRadius + nCastRange
			then
				local nTargetLocation = J.GetCastLocation( bot, botTarget, nCastRange, nRadius )
				if nTargetLocation ~= nil
				then
					return BOT_ACTION_DESIRE_HIGH, nTargetLocation
				end
			end

		end

		botTarget = nWeakestEnemyHeroInRange
		if J.IsValidHero(botTarget)
			and ( J.GetHP(botTarget) < 0.4 )
			and GetUnitToUnitDistance( botTarget, bot ) <= nRadius + nCastRange
		then
			local nTargetLocation = J.GetCastLocation( bot, botTarget, nCastRange, nRadius )
			if nTargetLocation ~= nil
			then
				return BOT_ACTION_DESIRE_HIGH, nTargetLocation
			end
		end

		if 	J.IsValid( nEnemysWeakestLaneCreeps2 )
			and nCanHurtCreepsLocationAoE.count >= 5
			and #nEnemysHeroesInBonus <= 0
			and bot:GetActiveMode() ~= BOT_MODE_ATTACK
			and nSkillLV >= 3
		then
			return BOT_ACTION_DESIRE_HIGH, nCanHurtCreepsLocationAoE.targetloc
		end

		if nCanKillCreepsLocationAoE.count >= 3
			and ( J.IsValid( nEnemysWeakestLaneCreeps1 ) or bot:GetLevel() >= 25 )
			and #nEnemysHeroesInBonus <= 0
			and bot:GetActiveMode() ~= BOT_MODE_ATTACK
			and nSkillLV >= 3
		then
			return BOT_ACTION_DESIRE_HIGH, nCanKillCreepsLocationAoE.targetloc
		end
	end

	if not J.IsRetreating(bot)
	then
		if J.IsValidHero( nWeakestEnemyHeroInBonus )
		then

			if nCanHurtHeroLocationAoE.count >= 3
				and GetUnitToLocationDistance( bot, nCanHurtHeroLocationAoE.targetloc ) <= nCastRange
			then
				return BOT_ACTION_DESIRE_VERYHIGH, nCanHurtHeroLocationAoE.targetloc
			end

			if nCanHurtHeroLocationAoE.count >= 2
				and GetUnitToLocationDistance( bot, nCanHurtHeroLocationAoE.targetloc ) <= nCastRange
				and bot:GetMana() > 250
			then
				return BOT_ACTION_DESIRE_HIGH, nCanHurtHeroLocationAoE.targetloc
			end

			if J.IsValidHero( nWeakestEnemyHeroInBonus )
			then
				if J.GetMP(bot) > 0.8
					or bot:GetMana() > 400
				then
					local nTargetLocation = J.GetCastLocation( bot, nWeakestEnemyHeroInBonus, nCastRange, nRadius )
					if nTargetLocation ~= nil
					then
						return BOT_ACTION_DESIRE_HIGH, nTargetLocation
					end
				end

				if ( J.GetHP(nWeakestEnemyHeroInBonus) < 0.4 )
					and GetUnitToUnitDistance( nWeakestEnemyHeroInBonus, bot ) <= nRadius + nCastRange
				then
					local nTargetLocation = J.GetCastLocation( bot, nWeakestEnemyHeroInBonus, nCastRange, nRadius )
					if nTargetLocation ~= nil
					then
						return BOT_ACTION_DESIRE_HIGH, nTargetLocation
					end
				end
			end
		end
	end

	if J.IsFarming( bot )
		and nSkillLV >= 3
	then

		if nCanKillCreepsLocationAoE.count >= 2
			and J.IsValid( nEnemysWeakestLaneCreeps1 )
            and J.CanBeAttacked(nEnemysWeakestLaneCreeps1)
		then
			return BOT_ACTION_DESIRE_HIGH, nCanKillCreepsLocationAoE.targetloc
		end

		if nCanHurtCreepsLocationAoE.count >= 4
			and J.IsValid( nEnemysWeakestLaneCreeps1 )
            and J.CanBeAttacked(nEnemysWeakestLaneCreeps1)
		then
			return BOT_ACTION_DESIRE_HIGH, nCanHurtCreepsLocationAoE.targetloc
		end

	end

	if #nAllys <= 2 and nSkillLV >= 3
		and ( J.IsPushing( bot ) or J.IsDefending( bot ) )
	then

		if nCanHurtCreepsLocationAoE.count >= 4
			and  J.IsValid( nEnemysWeakestLaneCreeps1 )
            and J.CanBeAttacked(nEnemysWeakestLaneCreeps1)
		then
			return BOT_ACTION_DESIRE_HIGH, nCanHurtCreepsLocationAoE.targetloc
		end

		if nCanKillCreepsLocationAoE.count >= 2
			and J.IsValid( nEnemysWeakestLaneCreeps1 )
            and J.CanBeAttacked(nEnemysWeakestLaneCreeps1)
		then
			return BOT_ACTION_DESIRE_HIGH, nCanKillCreepsLocationAoE.targetloc
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
		if J.IsTormentor( botTarget )
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

	local nNeutarlCreeps = bot:GetNearbyNeutralCreeps( math.min(nCastRange + nRadius, 1600) )
	if J.IsValid( nNeutarlCreeps[1] )
	then
		for _, creep in pairs( nNeutarlCreeps )
		do
			if J.IsValid( creep )
				and creep:HasModifier( 'modifier_crystal_maiden_frostbite' )
				and J.GetHP(creep) > 0.3
				and ( creep:GetUnitName() == 'npc_dota_neutral_dark_troll_warlord'
					or creep:GetUnitName() == 'npc_dota_neutral_satyr_hellcaller'
					or creep:GetUnitName() == 'npc_dota_neutral_polar_furbolg_ursa_warrior' )
			then
				local nTargetLocation = J.GetCastLocation( bot, creep, nCastRange, nRadius )
				if nTargetLocation ~= nil
				then
					return BOT_ACTION_DESIRE_HIGH, nTargetLocation
				end
			end
		end
	end

	if #nEnemysHeroesInView == 0
		and not J.IsGoingOnSomeone( bot )
		and nSkillLV > 2
	then

		if nCanKillCreepsLocationAoE.count >= 2
			and ( nEnemysWeakestLaneCreeps2 ~= nil or bot:GetLevel() == 25 )
		then
			return BOT_ACTION_DESIRE_HIGH, nCanKillCreepsLocationAoE.targetloc
		end

		if nCanHurtCreepsLocationAoE.count >= 4
			and nEnemysWeakestLaneCreeps2 ~= nil
		then
			return BOT_ACTION_DESIRE_HIGH, nCanHurtCreepsLocationAoE.targetloc
		end

	end

	return BOT_ACTION_DESIRE_NONE, 0
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

return X