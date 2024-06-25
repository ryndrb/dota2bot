local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local KineticField

function X.Cast()
    bot = GetBot()
    KineticField = bot:GetAbilityByName('disruptor_kinetic_field')

    Desire, Location = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(KineticField, Location)
        bot.KineticFieldLocation = Location
        bot.KineticFieldTimeLast = DotaTime()
        return
    end
end

function X.Consider()
    if not KineticField:IsFullyCastable()
    then
        return BOT_ACTION_DESIRE_NONE, 0
    end

	local nCastRange = J.GetProperCastRange(false, bot, KineticField:GetCastRange())
	local nCastPoint = KineticField:GetCastPoint()
	local nRadius = KineticField:GetSpecialValueInt('radius')

    local botTarget = J.GetProperTarget(bot)

    local nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
	local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	if J.IsInTeamFight(bot, 1200)
	then
		local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, nCastPoint, 0)
        local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius * 0.8)

		if nInRangeEnemy ~= nil and #nInRangeEnemy >= 2
        then
			return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
		end
	end

    if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange + nRadius)
        and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:IsMagicImmune()
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_skeleton_king_reincarnation_scepter_active')
		then
            if nEnemyHeroes ~= nil and #nEnemyHeroes <= 1
            then
                if J.IsChasingTarget(bot, botTarget)
                then
                    if not J.IsInRange(bot, botTarget, nCastRange)
                    then
                        return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, botTarget:GetLocation(), nCastRange)
                    else
                        return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(botTarget, 0.2)
                    end
                end
            else
                local nInRangeEnemy = J.GetEnemiesNearLoc(botTarget:GetLocation(), nRadius - 75)

                if not J.IsInRange(bot, botTarget, nCastRange)
                then
                    if nInRangeEnemy ~= nil and #nInRangeEnemy >= 1
                    then
                        return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, J.GetCenterOfUnits(nInRangeEnemy), nCastRange)
                    else
                        return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, botTarget:GetLocation(), nCastRange)
                    end
                else
                    if nInRangeEnemy ~= nil and #nInRangeEnemy >= 1
                    then
                        return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nInRangeEnemy)
                    else
                        return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(botTarget, 0.2)
                    end
                end
            end
		end
	end

    if  J.IsRetreating(bot)
    and bot:GetActiveModeDesire() >= 0.7
    and not J.IsRealInvisible(bot)
	then
        if  J.IsValidHero(nEnemyHeroes[1])
        and J.IsInRange(bot, nEnemyHeroes[1], nCastRange)
        and J.IsChasingTarget(nEnemyHeroes[1], bot)
        and not J.IsSuspiciousIllusion(nEnemyHeroes[1])
        and not J.IsDisabled(nEnemyHeroes[1])
        and not nEnemyHeroes[1]:IsMagicImmune()
        and not nEnemyHeroes[1]:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not nEnemyHeroes[1]:HasModifier('modifier_necrolyte_reapers_scythe')
        then
            if GetUnitToLocationDistance(bot, J.GetCorrectLoc(nEnemyHeroes[1], nCastPoint)) > nRadius
            then
                return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
            else
                return BOT_ACTION_DESIRE_HIGH, (bot:GetLocation() + nEnemyHeroes[1]:GetLocation()) / 2
            end
        end
	end

    for _, allyHero in pairs(nAllyHeroes)
    do
        if  J.IsValidHero(allyHero)
        and J.IsRetreating(allyHero)
        and J.IsCore(allyHero)
        and allyHero:GetActiveModeDesire() >= 0.75
        and allyHero:WasRecentlyDamagedByAnyHero(4.0)
        and not allyHero:IsIllusion()
        and not J.IsGoingOnSomeone(bot)
        then
            local nAllyInRangeEnemy = allyHero:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

            if J.IsValidHero(nAllyInRangeEnemy[1])
            and J.IsInRange(bot, nAllyInRangeEnemy[1], nCastRange)
            and J.IsChasingTarget(nAllyInRangeEnemy[1], allyHero)
            and not J.IsDisabled(nAllyInRangeEnemy[1])
            and not J.IsSuspiciousIllusion(nAllyInRangeEnemy[1])
            and not nAllyInRangeEnemy[1]:IsMagicImmune()
            and not nAllyInRangeEnemy[1]:HasModifier('modifier_faceless_void_chronosphere_freeze')
            and not nAllyInRangeEnemy[1]:HasModifier('modifier_necrolyte_reapers_scythe')
            and GetUnitToUnitDistance(allyHero, nAllyInRangeEnemy[1]) < GetUnitToUnitDistance(bot, nAllyInRangeEnemy[1])
            then
                return BOT_ACTION_DESIRE_HIGH, nAllyInRangeEnemy[1]:GetLocation()
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

return X