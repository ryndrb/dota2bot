local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local Silence

function X.Cast()
    bot = GetBot()
    Silence = bot:GetAbilityByName('death_prophet_silence')

    Desire, Location = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(Silence, Location)
        return
    end
end

function X.Consider()
    if not Silence:IsFullyCastable() then return 0 end

	local nCastRange = J.GetProperCastRange(false, bot, Silence:GetCastRange())
	local nRadius	 = Silence:GetSpecialValueInt( 'radius' )
	local nTargetLocation = nil
    local botTarget = J.GetProperTarget(bot)

    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	for _, npcEnemy in pairs( nEnemyHeroes )
	do
		if J.IsValidHero(npcEnemy)
        and npcEnemy:IsChanneling()
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
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
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

return X