local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local Multishot

function X.Cast()
    bot = GetBot()
    Multishot = bot:GetAbilityByName('drow_ranger_multishot')

    Desire, Location = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(Multishot, Location)
        return
    end
end

function X.Consider()
    if not Multishot:IsFullyCastable()
	then
		return BOT_ACTION_DESIRE_NONE
	end

	local nCastRange = 850
	local nRadius = 200
	local nCastPoint = Multishot:GetCastPoint()
	local nManaCost = Multishot:GetManaCost()
	local nTargetLocation = nil

    local nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE )
	local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE )


	if J.IsGoingOnSomeone( bot )
	then
		local npcTarget = J.GetProperTarget( bot )
		if J.IsValidHero( npcTarget )
        and not npcTarget:IsAttackImmune()
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
    and nAllyHeroes ~= nil and nEnemyHeroes ~= nil
    and #nAllyHeroes <= 2 and #nEnemyHeroes == 0
	then
		local laneCreepList = bot:GetNearbyLaneCreeps( 1400, true )
		if #laneCreepList >= 4
        and J.CanBeAttacked( laneCreepList[1] )
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
        local botTarget = J.GetProperTarget(bot)
		if J.IsValid( botTarget )
        and botTarget:GetTeam() == TEAM_NEUTRAL
        and J.IsInRange( bot, botTarget, 1000 )
		then
			local nShouldHurtCount = J.GetMP(bot) > 0.6 and 2 or 3
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

return X