local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local FlameGuard

function X.Cast()
    bot = GetBot()
    FlameGuard = bot:GetAbilityByName('ember_spirit_flame_guard')

    Desire = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(FlameGuard)
        return
    end
end

function X.Consider()
    if not FlameGuard:IsFullyCastable()
	then
		return BOT_ACTION_DESIRE_NONE
	end

	local nRadius = FlameGuard:GetSpecialValueInt('radius')
	local botTarget = J.GetProperTarget(bot)

    local nEnemyHeroes = J.GetEnemiesNearLoc(bot:GetLocation(), nRadius)

	if J.IsInTeamFight(bot, 1200)
	then
		return BOT_ACTION_DESIRE_HIGH
	end

	if J.IsGoingOnSomeone(bot)
	then
        if #nEnemyHeroes >= 2
		then
			return BOT_ACTION_DESIRE_HIGH
		end

		if J.IsValidTarget(botTarget)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.IsInRange(bot, botTarget, nRadius)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
	then
		if #nEnemyHeroes >= 1
        and bot:WasRecentlyDamagedByAnyHero(4)
        and bot:GetActiveModeDesire() > 0.5
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsFarming(bot)
    and J.GetManaAfter(FlameGuard:GetManaCost()) > 0.4
    and J.IsAttacking(bot)
    and not (J.HasItem(bot, 'item_maelstrom') or J.HasItem(bot, 'item_mjollnir') or J.HasItem(bot, 'item_gungir'))
	then
		local nNeutralCreeps = bot:GetNearbyNeutralCreeps(nRadius)
		if nNeutralCreeps ~= nil and #nNeutralCreeps >= 3
		then
			return BOT_ACTION_DESIRE_HIGH
		end

        local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(nRadius + 150, true)
        if nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 4
        and J.CanBeAttacked(nEnemyLaneCreeps[1])
        then
            return BOT_ACTION_DESIRE_HIGH
        end
	end

	if J.IsDoingRoshan(bot)
	then
		if  J.IsRoshan(botTarget)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.IsInRange(bot, botTarget, nRadius)
        and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

    if J.IsDoingTormentor(bot)
	then
		if  J.IsTormentor(botTarget)
		and J.IsInRange(bot, botTarget, nRadius)
        and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

return X