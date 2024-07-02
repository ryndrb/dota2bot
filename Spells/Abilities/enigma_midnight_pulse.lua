local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local MidnightPulse

function X.Cast()
    bot = GetBot()
    MidnightPulse = bot:GetAbilityByName('enigma_midnight_pulse')

    Desire, Target = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(MidnightPulse, Target)
        return
    end
end

function X.Consider()
    if not MidnightPulse:IsFullyCastable()
    then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nCastRange = J.GetProperCastRange(false, bot, MidnightPulse:GetCastRange())
    local nRadius = MidnightPulse:GetSpecialValueInt('radius')
    local botTarget = J.GetProperTarget(bot)

    if bot:GetUnitName() == 'npc_dota_hero_enigma'
    then
        local MidnightPulseRadiusTalent = bot:GetAbilityByName('special_bonus_unique_enigma_9')
        if MidnightPulseRadiusTalent:IsTrained()
        then
            nRadius = nRadius + MidnightPulse:GetSpecialValueInt('value')
        end
    end

	if J.IsInTeamFight(bot, 1200)
	then
		local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
        local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius * 0.8)

		if nInRangeEnemy ~= nil and #nInRangeEnemy >= 2
        then
			return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		then
            local nInRangeEnemy = J.GetEnemiesNearLoc(botTarget:GetLocation(), nRadius * 0.66)
            if J.IsInRange(bot, botTarget, nCastRange)
            then
                if not J.IsRunning(bot)
                then
                    if nInRangeEnemy ~= nil and #nInRangeEnemy >= 2
                    then
                        return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nInRangeEnemy)
                    else
                        return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
                    end
                else
                    return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(botTarget, 1)
                end
            else
                if  J.IsInRange(bot, botTarget, nCastRange + nRadius)
                and not J.IsInRange(bot, botTarget, nCastRange)
                and not J.IsChasingTarget(bot, botTarget)
                then
                    return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, botTarget:GetLocation(), nCastRange)
                end
            end
		end
	end

    if J.IsDoingRoshan(bot)
	then
        if  J.IsRoshan(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
	end

    if J.IsDoingTormentor(bot)
	then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
	end

    return BOT_ACTION_DESIRE_NONE, 0
end

return X