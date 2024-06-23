local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local ShadowWalk

function X.Cast()
    bot = GetBot()
    ShadowWalk = bot:GetAbilityByName('bounty_hunter_wind_walk')

    Desire = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(ShadowWalk)
        return
    end
end

function X.Consider()
    if not ShadowWalk:IsFullyCastable() or J.IsRealInvisible(bot) then return BOT_ACTION_DESIRE_NONE end


	local nSkillLV = ShadowWalk:GetLevel()

    local botTarget = J.GetProperTarget(bot)

    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
    local nEnemyTowers = bot:GetNearbyTowers(1600, true)

	if J.IsGoingOnSomeone( bot )
    and ( bot:GetLevel() >= 7 or DotaTime() > 6 * 60 or nSkillLV >= 2 )
	then
		if J.IsValidHero( botTarget )
        and J.CanCastOnMagicImmune( botTarget )
        and J.IsInRange( bot, botTarget, 2500 )
        and ( not J.IsInRange( bot, botTarget, 1000 )
                or J.IsChasingTarget( bot, botTarget ) )
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsRetreating( bot )
    and bot:WasRecentlyDamagedByAnyHero( 3.0 )
    and ( (nEnemyHeroes ~= nil and #nEnemyHeroes >= 1) or J.GetHP(bot) < 0.2 )
    and bot:DistanceFromFountain() > 800
	then
		return BOT_ACTION_DESIRE_HIGH
	end

	if J.IsInEnemyArea( bot ) and bot:GetLevel() >= 7
	then
		if nEnemyHeroes ~= nil and #nEnemyHeroes == 0
        and nEnemyTowers ~= nil and #nEnemyTowers == 0
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end


	return BOT_ACTION_DESIRE_NONE
end

return X