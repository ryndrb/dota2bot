local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local SpiritSiphon

function X.Cast()
    bot = GetBot()
    SpiritSiphon = bot:GetAbilityByName('death_prophet_spirit_siphon')

    Desire, Target = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(SpiritSiphon, Target)
        return
    end
end

function X.Consider()
    if not SpiritSiphon:IsFullyCastable() then return 0 end

	local nCastRange = J.GetProperCastRange(false, bot, SpiritSiphon:GetCastRange())
    local botTarget = J.GetProperTarget(bot)

    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	if J.IsGoingOnSomeone( bot )
	then
		if J.IsValidHero( botTarget )
        and J.IsInRange( bot, botTarget, nCastRange )
        and J.CanCastOnNonMagicImmune( botTarget )
        and J.CanCastOnTargetAdvanced( botTarget )
        and not botTarget:HasModifier( "modifier_abaddon_borrowed_time" )
        and not botTarget:HasModifier( "modifier_death_prophet_spirit_siphon_slow" )
        and not botTarget:HasModifier( "modifier_necrolyte_reapers_scythe" )
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end


	if J.IsInTeamFight( bot, 1200 )
	then
		for _, npcEnemy in pairs( nEnemyHeroes )
		do
			if J.IsValidHero( npcEnemy )
            and J.IsInRange(bot, npcEnemy, nCastRange)
            and J.CanCastOnNonMagicImmune( npcEnemy )
            and J.CanCastOnTargetAdvanced( npcEnemy )
            and not npcEnemy:HasModifier( "modifier_abaddon_borrowed_time" )
            and not npcEnemy:HasModifier( "modifier_death_prophet_spirit_siphon_slow" )
            and not npcEnemy:HasModifier( "modifier_necrolyte_reapers_scythe" )
			then
				return BOT_ACTION_DESIRE_HIGH, npcEnemy
			end
		end
	end

	if J.IsRetreating( bot )
    and not J.IsRealInvisible(bot)
	then
		for _, npcEnemy in pairs( nEnemyHeroes )
		do
			if J.IsValidHero( npcEnemy )
            and J.IsInRange(bot, npcEnemy, nCastRange)
            and J.CanCastOnNonMagicImmune( npcEnemy )
            and J.CanCastOnTargetAdvanced( npcEnemy )
            and not npcEnemy:HasModifier( "modifier_abaddon_borrowed_time" )
            and not npcEnemy:HasModifier( "modifier_death_prophet_spirit_siphon_slow" )
            and not npcEnemy:HasModifier( "modifier_necrolyte_reapers_scythe" )
			then
				return BOT_ACTION_DESIRE_HIGH, npcEnemy
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

return X