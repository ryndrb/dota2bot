local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local NasalGoo

function X.Cast()
    bot = GetBot()
    NasalGoo = bot:GetAbilityByName('bristleback_viscous_nasal_goo')

    Desire, Target = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(NasalGoo, Target)
        return
    end
end

function X.Consider()
    if ( not NasalGoo:IsFullyCastable() )
    then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = J.GetProperCastRange(false, bot, NasalGoo:GetCastRange())
	local nManaCost = NasalGoo:GetManaCost()

    local botTarget = J.GetProperTarget(bot)

	local nInRangeEnemy = bot:GetNearbyHeroes( nCastRange, true, BOT_MODE_NONE )
    local nEnemyHeroes = bot:GetNearbyHeroes(800, true, BOT_MODE_NONE)

	if J.IsRetreating( bot )
    and not J.IsRealInvisible(bot)
	then
		if J.IsValidHero( nInRangeEnemy[1] )
		then
            local enemyHero = nInRangeEnemy[1]
			if bot:HasScepter()
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
			end

			if J.CanCastOnNonMagicImmune( enemyHero )
            and J.CanCastOnTargetAdvanced( enemyHero )
            and ( bot:IsFacingLocation( enemyHero:GetLocation(), 15 ) or #nEnemyHeroes <= 1 )
            and ( bot:WasRecentlyDamagedByHero( enemyHero, 2.0 ) or bot:GetLevel() >= 10 )
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
			end
		end
	end

	if J.IsInTeamFight( bot, 1400 ) and bot:HasScepter()
	then
		if nInRangeEnemy ~= nil and #nInRangeEnemy >= 1
        and J.IsValidHero( nInRangeEnemy[1] )
        and J.CanCastOnNonMagicImmune( nInRangeEnemy[1] )
		then
			return BOT_ACTION_DESIRE_HIGH, nInRangeEnemy[1]
		end
	end

	if J.IsGoingOnSomeone( bot )
	then
		if J.IsValidHero( botTarget )
        and J.IsInRange( botTarget, bot, nCastRange )
        and J.CanCastOnNonMagicImmune( botTarget )
        and J.CanCastOnTargetAdvanced( botTarget )
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end

		if J.IsValid( botTarget )
		and nEnemyHeroes ~= nil and #nEnemyHeroes == 0
        and J.IsInRange( botTarget, bot, nCastRange )
        and J.IsAllowedToSpam( bot, nManaCost )
        and J.CanCastOnNonMagicImmune( botTarget )
        and J.CanCastOnTargetAdvanced( botTarget )
        and not J.CanKillTarget( botTarget, bot:GetAttackDamage() * 1.68, DAMAGE_TYPE_PHYSICAL )
		then
			local nCreeps = bot:GetNearbyCreeps( 800, true )
			if #nCreeps >= 1
			then
				return BOT_ACTION_DESIRE_HIGH, botTarget
			end
		end
	end

    if J.IsDoingRoshan(bot)
	then
		if J.IsRoshan( botTarget )
        and not J.IsDisabled(botTarget)
        and J.CanCastOnMagicImmune( botTarget )
        and J.IsInRange( botTarget, bot, nCastRange )
        and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

    if J.IsDoingTormentor(bot)
	then
		if J.IsTormentor( botTarget )
        and J.CanCastOnMagicImmune( botTarget )
        and J.IsInRange( botTarget, bot, nCastRange )
        and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

return X