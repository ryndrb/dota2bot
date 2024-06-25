local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local ChaosBolt

function X.Cast()
    bot = GetBot()
    ChaosBolt = bot:GetAbilityByName('chaos_knight_chaos_bolt')

    Desire, Target = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(ChaosBolt, Target)
        return
    end
end

function X.Consider()
    if not ChaosBolt:IsFullyCastable() then return BOT_ACTION_DESIRE_NONE, nil end

	local nCastRange = J.GetProperCastRange(false, bot, ChaosBolt:GetCastRange())
	local nSkillLV = ChaosBolt:GetLevel()
	local nDamage = 30 + nSkillLV * 30 + 120 * 0.38

	local nEnemysHeroesInCastRange = bot:GetNearbyHeroes( nCastRange + 99, true, BOT_MODE_NONE )
	local nEnemysHeroesInView = bot:GetNearbyHeroes( 880, true, BOT_MODE_NONE )

    local botTarget = J.GetProperTarget( bot )

	if nEnemysHeroesInCastRange ~= nil and #nEnemysHeroesInCastRange > 0 then
		for i=1, #nEnemysHeroesInCastRange do
			if J.IsValidHero( nEnemysHeroesInCastRange[i] )
            and J.CanCastOnNonMagicImmune( nEnemysHeroesInCastRange[i] )
            and J.CanCastOnTargetAdvanced( nEnemysHeroesInCastRange[i] )
            and nEnemysHeroesInCastRange[i]:GetHealth() < nEnemysHeroesInCastRange[i]:GetActualIncomingDamage( nDamage, DAMAGE_TYPE_MAGICAL )
            and not ( GetUnitToUnitDistance( nEnemysHeroesInCastRange[i], bot ) <= bot:GetAttackRange() + 60 )
            and not J.IsDisabled( nEnemysHeroesInCastRange[i] )
            and not nEnemysHeroesInCastRange[i]:HasModifier('modifier_necrolyte_reapers_scythe')
			then
				return BOT_ACTION_DESIRE_HIGH, nEnemysHeroesInCastRange[i]
			end
		end
	end

	if nEnemysHeroesInView ~= nil and #nEnemysHeroesInView > 0 then
		for i=1, #nEnemysHeroesInView do
			if J.IsValidHero( nEnemysHeroesInView[i] )
            and J.CanCastOnNonMagicImmune( nEnemysHeroesInView[i] )
            and J.CanCastOnTargetAdvanced( nEnemysHeroesInView[i] )
            and nEnemysHeroesInView[i]:IsChanneling()
			then
				return BOT_ACTION_DESIRE_HIGH, nEnemysHeroesInView[i]
			end
		end
	end

	if J.IsInTeamFight( bot, 1200 )
		and DotaTime() > 4 * 60
	then
		local npcMostDangerousEnemy = nil
		local nMostDangerousDamage = 0

		for _, npcEnemy in pairs( nEnemysHeroesInCastRange )
		do
			if J.IsValidHero( npcEnemy )
            and J.CanCastOnNonMagicImmune( npcEnemy )
            and J.CanCastOnTargetAdvanced( npcEnemy )
            and not J.IsDisabled( npcEnemy )
            and not npcEnemy:IsDisarmed()
            and not npcEnemy:HasModifier('modifier_necrolyte_reapers_scythe')
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

	if J.IsGoingOnSomeone( bot )
	then
		if J.IsValidHero( botTarget )
        and J.CanCastOnNonMagicImmune( botTarget )
        and J.CanCastOnTargetAdvanced( botTarget )
        and J.IsInRange( botTarget, bot, nCastRange )
        and not J.IsDisabled( botTarget )
        and not botTarget:IsDisarmed()
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	if J.IsRetreating( bot )
    and not J.IsRealInvisible(bot)
	then
		if J.IsValidHero( nEnemysHeroesInCastRange[1] )
        and GetUnitToUnitDistance( bot, nEnemysHeroesInCastRange[1] ) <= nCastRange - 60
        and J.CanCastOnNonMagicImmune( nEnemysHeroesInCastRange[1] )
        and J.CanCastOnTargetAdvanced( nEnemysHeroesInCastRange[1] )
        and not J.IsDisabled( nEnemysHeroesInCastRange[1] )
        and not nEnemysHeroesInCastRange[1]:IsDisarmed()
		then
			return BOT_ACTION_DESIRE_HIGH, nEnemysHeroesInCastRange[1]
		end
	end

	if J.IsDoingRoshan(bot)
	then
		if J.IsRoshan(botTarget)
        and not J.IsDisabled( botTarget )
        and J.GetHP( botTarget ) > 0.2
        and not botTarget:IsDisarmed()
        and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

return X