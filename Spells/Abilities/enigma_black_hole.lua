local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local BlackHole

function X.Cast()
    bot = GetBot()
    BlackHole = bot:GetAbilityByName('enigma_black_hole')

    Desire, Target = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(BlackHole, Target)
        return
    end
end

function X.Consider()
    if not BlackHole:IsFullyCastable()
    then
        return BOT_ACTION_DESIRE_NONE, 0
    end

	local nCastRange = J.GetProperCastRange(false, bot, BlackHole:GetCastRange())
    local nRadius = BlackHole:GetSpecialValueInt('radius')
    local nDamage = BlackHole:GetSpecialValueInt('value')
    local nDuration = BlackHole:GetSpecialValueInt('duration')
    local botTarget = J.GetProperTarget(bot)

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
        and J.CanCastOnMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, 800)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
        and not botTarget:HasModifier('modifier_item_aeon_disk_buff')
		then
            local nInRangeAlly = botTarget:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
            local nInRangeEnemy = botTarget:GetNearbyHeroes(1600, false, BOT_MODE_NONE)

            if  nInRangeAlly ~= nil and nInRangeEnemy ~= nil
            and not (#nInRangeAlly + 3 >= #nInRangeEnemy)
            then
                if  #nInRangeEnemy >= #nInRangeAlly
                and #nInRangeEnemy <= 1
                then
                    if  J.CanKillTarget(botTarget, nDamage * nDuration, DAMAGE_TYPE_PURE)
                    and J.IsCore(botTarget)
                    and botTarget:GetHealth() > 200
                    then
                        nInRangeEnemy = J.GetEnemiesNearLoc(botTarget:GetLocation(), nRadius)
                        if nInRangeEnemy ~= nil and #nInRangeEnemy >= 2
                        then
                            return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nInRangeEnemy)
                        else
                            if  J.IsInRange(bot, botTarget, nCastRange + nRadius)
                            and not J.IsInRange(bot, botTarget, nCastRange)
                            then
                                return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, botTarget:GetLocation(), nCastRange)
                            else
                                return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
                            end
                        end
                    end
                end

                if  #nInRangeAlly >= #nInRangeEnemy
                and J.IsCore(botTarget)
                then
                    if  #nInRangeAlly == 0
                    and J.CanKillTarget(botTarget, nDamage * nDuration, DAMAGE_TYPE_PURE)
                    then
                        return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
                    else
                        nInRangeEnemy = J.GetEnemiesNearLoc(botTarget:GetLocation(), nRadius)
                        if nInRangeEnemy ~= nil and #nInRangeEnemy >= 1
                        then
                            return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nInRangeEnemy)
                        else
                            if  J.IsInRange(bot, botTarget, nCastRange + nRadius)
                            and not J.IsInRange(bot, botTarget, nCastRange)
                            then
                                return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, botTarget:GetLocation(), nCastRange)
                            else
                                return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
                            end
                        end
                    end
                end
            end
		end
	end

    return BOT_ACTION_DESIRE_NONE, 0
end

return X