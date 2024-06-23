local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local FriendlyShadow

function X.Cast()
    bot = GetBot()
    FriendlyShadow = bot:GetAbilityByName('bounty_hunter_wind_walk_ally')

    Desire, Target = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(FriendlyShadow, Target)
        return
    end
end

function X.Consider()
    if not FriendlyShadow:IsTrained()
	or not FriendlyShadow:IsFullyCastable()
	then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = J.GetProperCastRange(false, bot, FriendlyShadow:GetCastRange())
	local nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
    local nEnemyTowers = bot:GetNearbyTowers(1600, true)

	for _, allyHero in pairs(nAllyHeroes)
    do
        if J.IsValidHero(allyHero)
        and not J.IsRealInvisible(allyHero)
        then
            if J.IsGoingOnSomeone(allyHero)
            and J.IsInRange(bot, allyHero, nCastRange)
            and J.IsNotSelf(bot, allyHero)
            then
                return BOT_ACTION_DESIRE_HIGH, allyHero
            end

            if J.IsRetreating(allyHero)
            and allyHero:WasRecentlyDamagedByAnyHero(3.0)
            and allyHero:DistanceFromFountain() > 800
            and J.IsInRange(bot, allyHero, nCastRange)
            and J.IsNotSelf(bot, allyHero)
            and nEnemyHeroes ~= nil and #nEnemyHeroes >= 1
            then
                return BOT_ACTION_DESIRE_HIGH, allyHero
            end

            if J.IsInEnemyArea(bot)
            then
                if nEnemyHeroes ~= nil and #nEnemyHeroes == 0
                and nEnemyTowers ~= nil and #nEnemyTowers == 0
                and J.IsInRange(bot, allyHero, nCastRange)
                and J.IsNotSelf(bot, allyHero)
                then
                    return BOT_ACTION_DESIRE_HIGH, allyHero
                end
            end
        end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

return X