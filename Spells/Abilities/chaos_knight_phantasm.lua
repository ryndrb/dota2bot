local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local Phantasm

function X.Cast()
    bot = GetBot()
    Phantasm = bot:GetAbilityByName('chaos_knight_phantasm')

    local Armlet = J.IsItemAvailable( "item_armlet" )

    Desire = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)

        if Armlet ~= nil and Armlet:IsFullyCastable() and Armlet:GetToggleState() == false
        then
            bot:ActionQueue_UseAbility(Armlet)
        end

        bot:ActionQueue_UseAbility(Phantasm)
        return
    end
end

function X.Consider()
    if not Phantasm:IsFullyCastable() or bot:DistanceFromFountain() < 500 then return BOT_ACTION_DESIRE_NONE end

	local nNearbyEnemyHeroes = J.GetEnemyList( bot, 1600 )
	local nNearbyEnemyTowers = bot:GetNearbyTowers( 700, true )
	local nNearbyEnemyBarracks = bot:GetNearbyBarracks( 400, true )
	local nNearbyAlliedCreeps = bot:GetNearbyLaneCreeps( 1000, false )
	local nCastRange = 900

    local hasAbility = J.HasAbility(bot, 'chaos_knight_reality_rift')
    if hasAbility
    then
        nCastRange = 1200
    end

    local botTarget = J.GetProperTarget( bot )

	if J.IsGoingOnSomeone( bot )
	then
		if J.IsValidHero( botTarget )
        and not botTarget:IsAttackImmune()
        and J.IsInRange( bot, botTarget, nCastRange )
        and J.CanCastOnMagicImmune( botTarget )
        and ( J.GetHP( botTarget ) > 0.5
            or J.GetHP(bot) < 0.7
            or nNearbyEnemyHeroes ~= nil and #nNearbyEnemyHeroes >= 2 )
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsInTeamFight( bot, 1200 )
	then
		if nNearbyEnemyHeroes ~= nil and #nNearbyEnemyHeroes >= 2
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsPushing( bot )
	and DotaTime() > 8 * 30
	then
		if ( (nNearbyEnemyTowers ~= nil and #nNearbyEnemyTowers >= 1) or (nNearbyEnemyBarracks ~= nil and #nNearbyEnemyBarracks >= 1 ))
			and (nNearbyAlliedCreeps ~= nil and #nNearbyAlliedCreeps >= 2)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
    and J.GetHP(bot) >= 0.5
    and J.IsValidHero( nNearbyEnemyHeroes[1] )
    and GetUnitToUnitDistance( bot, nNearbyEnemyHeroes[1] ) <= 700
    and J.IsChasingTarget(nNearbyEnemyHeroes[1], bot)
	then
		return BOT_ACTION_DESIRE_HIGH
	end

	return BOT_ACTION_DESIRE_NONE
end

return X