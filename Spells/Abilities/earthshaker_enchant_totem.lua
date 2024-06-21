local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local EnchantTotem

function X.Cast()
    bot = GetBot()
    EnchantTotem = bot:GetAbilityByName('earthshaker_enchant_totem')

    Desire, Target, WantToJump = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)

        if bot:HasScepter()
        then
            if WantToJump
            then
                bot:ActionQueue_UseAbilityOnLocation(EnchantTotem, Target)
            else
                bot:ActionQueue_UseAbilityOnEntity(EnchantTotem, bot)
            end
        else
            bot:ActionQueue_UseAbility(EnchantTotem)
        end

        return
    end
end

function X.Consider()
    if not EnchantTotem:IsFullyCastable()
    then
        return BOT_ACTION_DESIRE_NONE, 0, false
    end

    local _, Aftershock = J.HasAbility(bot, 'earthshaker_aftershock')
    local nCastRange = bot:HasScepter() and EnchantTotem:GetSpecialValueInt('distance_scepter') or 0
	local nRadius = 350
    local nLeapDuration = EnchantTotem:GetSpecialValueFloat('scepter_leap_duration')
    local botTarget = J.GetProperTarget(bot)

    if Aftershock ~= nil then nRadius = Aftershock:GetSpecialValueInt('aftershock_range') end

	if bot:HasScepter() and J.IsStuck(bot)
	then
		return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, J.GetTeamFountain(), nCastRange), true
	end

	if J.IsInTeamFight(bot)
	then
        local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), nRadius)
        local nInRangeIllusion = J.GetIllusionsNearLoc(bot:GetLocation(), nRadius)

		if bot:HasScepter()
        then
            local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, nLeapDuration, 0)
            nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)

            if nInRangeEnemy ~= nil and #nInRangeEnemy >= 2
            then
                return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nInRangeEnemy), true
            end

            nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1600)
            if  nInRangeIllusion ~= nil and #nInRangeIllusion >= 2
            and nInRangeEnemy ~= nil and #nInRangeEnemy == 0
            then
                return BOT_ACTION_DESIRE_HIGH, 0, false
            end
		else
            if nInRangeEnemy ~= nil and #nInRangeEnemy >= 2
            then
                return BOT_ACTION_DESIRE_HIGH, 0, false
            end

            nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1600)
            if  nInRangeIllusion ~= nil and #nInRangeIllusion >= 2
            and nInRangeEnemy ~= nil and #nInRangeEnemy == 0
            then
                return BOT_ACTION_DESIRE_HIGH, 0, false
            end
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
            local nInRangeAlly = bot:GetNearbyHeroes(1000, false, BOT_MODE_NONE)
            local nInRangeEnemy = bot:GetNearbyHeroes(800, true, BOT_MODE_NONE)

            if  nInRangeAlly ~= nil and nInRangeEnemy ~= nil
            and #nInRangeAlly >= #nInRangeEnemy
            then
                if bot:HasScepter()
                then
                    if  J.IsInRange(bot, botTarget, nCastRange)
                    and not J.IsInRange(bot, botTarget, nRadius)
                    and not botTarget:HasModifier('modifier_faceless_void_chronosphere')
                    then
                        return BOT_ACTION_DESIRE_HIGH, botTarget:GetExtrapolatedLocation(nLeapDuration), true
                    else
                        if J.IsInRange(bot, botTarget, nRadius - 50)
                        then
                            return BOT_ACTION_DESIRE_HIGH, 0, false
                        end
                    end
                else
                    if J.IsInRange(bot, botTarget, nRadius - 50)
                    then
                        return BOT_ACTION_DESIRE_HIGH, 0, false
                    end
                end
            end
		end
	end

    if  J.IsRetreating(bot)
    and bot:GetActiveModeDesire() > 0.7
    then
        local nInRangeEnemy = bot:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
        for _, enemyHero in pairs(nInRangeEnemy)
        do
            if  J.IsValidHero(enemyHero)
            and J.IsChasingTarget(enemyHero, bot)
            and not J.IsSuspiciousIllusion(enemyHero)
            and not J.IsDisabled(enemyHero)
            then
                local nInRangeAlly = enemyHero:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
                local nTargetInRangeAlly = enemyHero:GetNearbyHeroes(1200, false, BOT_MODE_NONE)

                if  nInRangeAlly ~= nil and nTargetInRangeAlly ~= nil
                and ((#nTargetInRangeAlly > #nInRangeAlly)
                    or bot:WasRecentlyDamagedByAnyHero(2))
                then
                    if bot:HasScepter()
                    then
                        return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, J.GetTeamFountain(), nCastRange), true
                    else
                        if J.IsInRange(bot, enemyHero, nRadius)
                        then
                            return BOT_ACTION_DESIRE_HIGH, 0, false
                        end
                    end
                end
            end
        end
    end

    if  (J.IsPushing(bot) or J.IsDefending(bot))
    and J.GetManaAfter(EnchantTotem:GetManaCost()) > 0.5
    and not bot:HasModifier('modifier_earthshaker_enchant_totem')
    then
        local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(1400, true)

        if bot:HasScepter()
        then
            if  nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 3
            and J.CanBeAttacked(nEnemyLaneCreeps[1])
            and not J.IsRunning(nEnemyLaneCreeps[1])
            then
                local nCreepCount = J.GetNearbyAroundLocationUnitCount(true, false, nRadius, nEnemyLaneCreeps[1]:GetLocation())
                if nCreepCount >= 3
                then
                    return BOT_ACTION_DESIRE_HIGH, nEnemyLaneCreeps[1]:GetLocation(), true
                end
            end

            if  J.IsValidBuilding(botTarget)
            and J.CanBeAttacked(botTarget)
            and J.IsAttacking(bot)
            then
                return BOT_ACTION_DESIRE_HIGH, 0, false
            end
        else
            nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(nRadius, true)
            if  nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 3
            and J.CanBeAttacked(nEnemyLaneCreeps[1])
            then
                return BOT_ACTION_DESIRE_HIGH, 0, false
            end

            if  J.IsValidBuilding(botTarget)
            and J.CanBeAttacked(botTarget)
            and J.IsAttacking(bot)
            then
                return BOT_ACTION_DESIRE_HIGH, 0, false
            end
        end
    end

    if J.IsFarming(bot)
    then
        local nNeutralCreeps = bot:GetNearbyNeutralCreeps(nRadius)
        if  nNeutralCreeps ~= nil and #nNeutralCreeps >= 1
        and J.GetManaAfter(EnchantTotem:GetManaCost()) > 0.3
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH, 0, false
        end
    end

    if  J.IsLaning(bot)
    and J.IsInLaningPhase()
    then
        local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), nRadius)
        if nInRangeEnemy ~= nil and #nInRangeEnemy >= 1
        and J.IsValidHero(nInRangeEnemy[1])
        and J.CanCastOnNonMagicImmune(nInRangeEnemy[1])
        and not J.IsDisabled(nInRangeEnemy[1])
        and not nInRangeEnemy[1]:HasModifier('modifier_abaddon_borrowed_time')
        then
            return BOT_ACTION_DESIRE_HIGH, 0, false
        end
    end

    if J.IsDoingRoshan(bot)
    then
        if  J.IsRoshan(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH, 0, false
        end
    end

    if J.IsDoingTormentor(bot)
    then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH, 0, false
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0, false
end

return X