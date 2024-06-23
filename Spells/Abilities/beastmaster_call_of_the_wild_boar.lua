local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local CallOfTheWildBoar

function X.Cast()
    bot = GetBot()
    CallOfTheWildBoar = bot:GetAbilityByName('beastmaster_call_of_the_wild_boar')

    Desire = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(CallOfTheWildBoar)
        return
    end
end

function X.Consider()
    if not CallOfTheWildBoar:IsFullyCastable()
    then
		return BOT_ACTION_DESIRE_NONE
	end

    local botTarget = J.GetProperTarget(bot)

    if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
        and J.IsInRange(bot, botTarget, 800)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if (J.IsPushing(bot) or J.IsDefending(bot))
	then
        if J.IsAttacking(bot)
        then
            local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(700, true)
            if nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 4
            then
                return BOT_ACTION_DESIRE_HIGH
            end

            local nEnemyTowers = bot:GetNearbyTowers(700, true)
            if  nEnemyTowers ~= nil and #nEnemyTowers > 0
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
	end

    if  J.IsFarming(bot)
    and J.GetMP(bot) > 0.33
    then
        local nCreeps = bot:GetNearbyNeutralCreeps(600)

        if J.IsAttacking(bot)
        then
            if  J.IsValid(nCreeps[1])
            and (#nCreeps >= 2
                or (#nCreeps >= 1 and nCreeps[1]:IsAncientCreep()))
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    end

    if J.IsDoingRoshan(bot)
	then
		if  J.IsRoshan(botTarget)
        and J.IsInRange(bot, botTarget, 500)
        and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

    if J.IsDoingTormentor(bot)
	then
		if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, 500)
        and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

return X