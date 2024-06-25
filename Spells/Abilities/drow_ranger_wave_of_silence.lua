local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local Gust

function X.Cast()
    bot = GetBot()
    Gust = bot:GetAbilityByName('drow_ranger_wave_of_silence')

    Desire, Location = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(Gust, Location)
        return
    end
end

function X.Consider()
    if not Gust:IsFullyCastable()
	then
		return BOT_ACTION_DESIRE_NONE
	end

	local nCastRange = J.GetProperCastRange(false, bot, Gust:GetCastRange())
	local nRadius = Gust:GetAOERadius()
	local nCastPoint = Gust:GetCastPoint()
	local nTargetLocation = nil

	local nEnemyHeroes = bot:GetNearbyHeroes( 1600, true, BOT_MODE_NONE )

	for _, npcEnemy in pairs( nEnemyHeroes )
	do
		if J.IsValidHero( npcEnemy )
        and J.IsInRange(bot, npcEnemy, nCastRange + 150)
        and npcEnemy:IsChanneling()
        and not npcEnemy:HasModifier( "modifier_teleporting" )
		then
			nTargetLocation = npcEnemy:GetLocation()
			return BOT_ACTION_DESIRE_HIGH, nTargetLocation
		end
	end


	if bot:GetActiveMode() == BOT_MODE_RETREAT
    and not J.IsRealInvisible(bot)
	then
		local locationAoE = bot:FindAoELocation( true, true, bot:GetLocation(), nCastRange-100, nRadius, nCastPoint, 0 )
		if locationAoE.count >= 2
			or ( locationAoE.count >= 1 and J.GetHP(bot) < 0.5 )
		then
			nTargetLocation = locationAoE.targetloc
			return BOT_ACTION_DESIRE_HIGH, nTargetLocation
		end

		for _, npcEnemy in pairs( nEnemyHeroes )
		do
			if J.IsValidHero( npcEnemy )
            and J.IsInRange(bot, npcEnemy, nCastRange + 150)
            and bot:WasRecentlyDamagedByHero( npcEnemy, 5.0 )
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

return X