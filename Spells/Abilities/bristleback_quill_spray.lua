local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local QuillSpray

function X.Cast()
    bot = GetBot()
    QuillSpray = bot:GetAbilityByName('bristleback_quill_spray')

    Desire = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(QuillSpray)
        return
    end
end

function X.Consider()
    if not QuillSpray:IsFullyCastable() then
		return BOT_ACTION_DESIRE_NONE
	end

	local nRadius = QuillSpray:GetSpecialValueInt( "radius" )
	local nManaCost = QuillSpray:GetManaCost()

    local botTarget = J.GetProperTarget(bot)

	local nInRangeEnemy = bot:GetNearbyHeroes( nRadius, true, BOT_MODE_NONE )
    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE )
    local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps( nRadius, true )

	if J.IsRetreating( bot )
    and not J.IsRealInvisible(bot)
	then
		for _, enemyHero in pairs( nEnemyHeroes )
		do
			if J.IsValidHero(enemyHero)
            and J.IsInRange(bot, enemyHero, nRadius)
            and (bot:WasRecentlyDamagedByHero( enemyHero, 4.0 )
				or enemyHero:HasModifier( "modifier_bristleback_quill_spray" ))
			then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if J.IsPushing( bot )
    or J.IsDefending( bot )
    or J.IsGoingOnSomeone( bot )
    or J.IsFarming(bot)
	then
		if nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 1 and J.IsAllowedToSpam( bot, nManaCost )
        and J.CanBeAttacked(nEnemyLaneCreeps[1])
        then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsFarming( bot )
    and J.IsAllowedToSpam( bot, nManaCost )
	then
		if J.IsValid( botTarget )
		and botTarget:GetTeam() == TEAM_NEUTRAL
		then
			if botTarget:GetHealth() > bot:GetAttackDamage() * 2.28
			then
				return BOT_ACTION_DESIRE_HIGH
			end

			local nCreeps = bot:GetNearbyCreeps( nRadius, true )
			if ( #nCreeps >= 2 )
			then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if J.IsInTeamFight( bot, 1200 )
	then
		if nInRangeEnemy ~= nil and #nInRangeEnemy >= 1
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsGoingOnSomeone( bot )
	then
		if J.IsValidHero( botTarget )
        and J.IsInRange( botTarget, bot, nRadius-100 )
        and J.CanCastOnMagicImmune( botTarget )
		then
			return BOT_ACTION_DESIRE_HIGH
		end

		if J.IsValidHero( botTarget )
        and J.IsInRange( botTarget, bot, nRadius )
        and J.IsAllowedToSpam( bot, nManaCost )
        and J.CanCastOnNonMagicImmune( botTarget )
		then
			local nCreeps = bot:GetNearbyCreeps( 800, true )
			if nCreeps ~= nil and #nCreeps >= 1
			then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if J.IsDoingRoshan(bot)
	then
		if J.IsRoshan( botTarget )
        and J.CanCastOnMagicImmune( botTarget )
        and J.IsInRange( bot, botTarget, nRadius )
        and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

    if J.IsDoingTormentor(bot)
	then
		if J.IsTormentor( botTarget )
        and J.IsInRange( bot, botTarget, nRadius )
        and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.GetMP(bot) > 0.95
		and bot:GetLevel() >= 6
		and bot:DistanceFromFountain() > 2400
		and J.IsAllowedToSpam( bot, nManaCost )
	then
		return BOT_ACTION_DESIRE_HIGH
	end

	return BOT_ACTION_DESIRE_NONE
end

return X