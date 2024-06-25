local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local BurningBarrage

function X.Cast()
    bot = GetBot()
    BurningBarrage = bot:GetAbilityByName('clinkz_burning_barrage')

    Desire, Location = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(BurningBarrage, Location)
        return
    end
end

function X.Consider()
    if not BurningBarrage:IsTrained()
    or not BurningBarrage:IsFullyCastable()
    then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nCastRange = J.GetProperCastRange(false, bot, BurningBarrage:GetCastRange())

    local botTarget = J.GetProperTarget(bot)

    local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(1600, true)

    if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange - 125)
        and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
            if not J.IsRunning(botTarget)
            then
                return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
            else
                return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(botTarget, 0.5)
            end
		end
	end

    if J.IsFarming(bot)
    then
        local nNeutralCreeps = bot:GetNearbyNeutralCreeps(1000)
        if  nNeutralCreeps ~= nil and #nNeutralCreeps >= 1
        and J.IsAttacking(bot)
        and J.GetManaAfter(BurningBarrage:GetManaCost()) > 0.38
        then
            if J.IsBigCamp(nNeutralCreeps)
            or nNeutralCreeps[1]:IsAncientCreep()
            then
                if #nNeutralCreeps >= 2
                then
                    return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nNeutralCreeps)
                end
            else
                if #nNeutralCreeps >= 3
                then
                    return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nNeutralCreeps)
                end
            end
        end
    end

    if J.IsPushing(bot) or J.IsDefending(bot) or J.IsFarming(bot)
    then
		if nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 4
        and J.CanBeAttacked(nEnemyLaneCreeps[1])
        and not J.IsRunning(nEnemyLaneCreeps[1])
        and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nEnemyLaneCreeps)
		end
    end

    if J.IsDoingRoshan(bot) or J.IsDoingTormentor(bot)
	then
		if  (J.IsRoshan(botTarget) or J.IsTormentor(botTarget))
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, bot:GetAttackRange())
        and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

    return BOT_ACTION_DESIRE_NONE, 0
end

return X