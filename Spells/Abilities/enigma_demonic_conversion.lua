local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local DemonicSummoning

function X.Cast()
    bot = GetBot()
    DemonicSummoning = bot:GetAbilityByName('enigma_demonic_conversion')

    Desire, Target = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(DemonicSummoning, Target)
        return
    end
end

function X.Consider()
    if not DemonicSummoning:IsFullyCastable()
    then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nCastRange = J.GetProperCastRange(false, bot, DemonicSummoning:GetCastRange())
    local nHPCost = 75 + (25 * (DemonicSummoning:GetLevel() - 1))
    local botTarget = J.GetProperTarget(bot)

    if  J.IsGoingOnSomeone(bot)
    and J.GetHP(bot) > 0.5
	then
		if  J.IsValidTarget(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
		then
            if DotaTime() < 10 * 60
            then
                local nEnemyTowers = botTarget:GetNearbyTowers(800, false)
                if nEnemyTowers ~= nil
                then
                    if J.IsChasingTarget(bot, botTarget)
                    then
                        if  J.IsInRange(bot, botTarget, nCastRange)
                        and #nEnemyTowers == 0
                        then
                            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
                        else
                            if #nEnemyTowers == 0
                            then
                                return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, botTarget:GetLocation(), nCastRange)
                            end
                        end
                    else
                        if J.IsInRange(bot, botTarget, nCastRange)
                        then
                            return BOT_ACTION_DESIRE_HIGH, (bot:GetLocation() + botTarget:GetLocation()) / 2
                        end
                    end
                end
            else
                if J.IsChasingTarget(bot, botTarget)
                then
                    if J.IsInRange(bot, botTarget, nCastRange)
                    then
                        return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
                    else
                        return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, botTarget:GetLocation(), nCastRange)
                    end
                else
                    if J.IsInRange(bot, botTarget, bot:GetAttackRange())
                    then
                        return BOT_ACTION_DESIRE_HIGH, (bot:GetLocation() + botTarget:GetLocation()) / 2
                    end
                end
            end
		end
	end

    local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(1000, true)

	if (J.IsDefending(bot) or J.IsPushing(bot))
    and J.GetHealthAfter(nHPCost) > 0.5
	then
        if J.IsAttacking(bot)
        then
            if nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 4
            then
                return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
            end

            local nEnemyTowers = bot:GetNearbyTowers(888, true)
            local nEnemyBarracks = bot:GetNearbyBarracks(888,true)
            local nEnemyFillers = bot:GetNearbyFillers(888, true)

            if  J.IsValidBuilding(bot:GetAttackTarget())
            and (nEnemyTowers ~= nil and #nEnemyTowers >= 1
                or nEnemyBarracks ~= nil and #nEnemyBarracks >= 1
                or nEnemyFillers ~= nil and #nEnemyFillers >= 1)
            then
                return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
            end
        end
	end

    if  J.IsFarming(bot)
    and J.GetHealthAfter(nHPCost) > 0.5
    and J.GetManaAfter(DemonicSummoning:GetManaCost()) > 0.33
    and J.IsAttacking(bot)
    then
        if nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 4
        then
            return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
        end

        local nNeutralCreeps = bot:GetNearbyNeutralCreeps(nCastRange)
        if nNeutralCreeps ~= nil and #nNeutralCreeps >= 2
        then
            return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
        end
    end

    if  J.IsLaning(bot)
    and J.GetHealthAfter(nHPCost) > 0.61
    and J.GetManaAfter(DemonicSummoning:GetManaCost()) > 0.45
    then
        if nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 3
        then
            return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
        end
    end

    if  J.IsDoingRoshan(bot)
    and J.GetHealthAfter(nHPCost) > 0.5
	then
        if  J.IsRoshan(botTarget)
        and J.IsInRange(bot, botTarget, bot:GetAttackRange())
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
        end
	end

    if  J.IsDoingTormentor(bot)
    and J.GetHealthAfter(nHPCost) > 0.63
	then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, bot:GetAttackRange())
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
        end
	end

    return BOT_ACTION_DESIRE_NONE, 0
end

return X