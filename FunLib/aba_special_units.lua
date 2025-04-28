local X = {}

local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')

-- handle attacking special units

local targetUnit = nil

function X.GetDesire(bot__)
    bot = bot__

    if J.CanNotUseAction(bot) or bot:IsDisarmed() then
        return 0
    end

    local botHealth = bot:GetHealth()
    local botHP = J.GetHP(bot)
    local botLocation = bot:GetLocation()
	local botAttackRange = bot:GetAttackRange()
    local botLevel = bot:GetLevel()
    local bMagicImmune = bot:IsMagicImmune()
    local botTarget = J.GetProperTarget(bot)
    local botName = bot:GetUnitName()
    local botHealthRegen = bot:GetHealthRegen()

    local tAllyHeroes = J.GetAlliesNearLoc(bot:GetLocation(), 1600)
	local tEnemyHeroes = J.GetEnemiesNearLoc(bot:GetLocation(), 1600)

    local tAllyHeroes_all = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    local tEnemyHeroes_all = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
    local bOutnumbered = #tEnemyHeroes > #tAllyHeroes

    local unitList = GetUnitList(UNIT_LIST_ALL)
    for _, unit in pairs(unitList)
	do
		if J.IsValid(unit)
        and J.IsInRange(bot, unit, 1600)
		then
            bot.special_unit_target = unit
            local sUnitName = unit:GetUnitName()
            local botAttackDamage = X.GetUnitAttackDamageWithinTime(bot, 5.0)
            local unitHealth = unit:GetHealth()
            local unitHealthRegen = unit:GetHealthRegen()
            local unitLocation = unit:GetLocation()
            local withinAttackRange = GetUnitToUnitDistance(bot, unit) <= botAttackRange

            if string.find(sUnitName, 'rattletrap_cog')
            then
                -- Expanded Armature
                -- seems? facet have a frame hit when inside
                if string.find(botName, 'rattletrap') and withinAttackRange then
                    if J.IsGoingOnSomeone(bot) then
                        if J.IsValidHero(botTarget)
                        and J.CanCastOnNonMagicImmune(botTarget)
                        and J.IsInRange(bot, botTarget, 800)
                        and not J.IsInRange(bot, botTarget, 400)
                        and not (J.IsInRange(bot, botTarget, 800) and J.IsChasingTarget(bot, botTarget))
                        then
                            local tResult = PointToLineDistance(botLocation, botTarget:GetLocation(), unitLocation)
                            if tResult ~= nil and tResult.within and tResult.distance <= 185 then
                                return 2
                            end
                        end
                    end

                    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
                        for _, enemyHero in pairs(tEnemyHeroes) do
                            if J.IsValidHero(enemyHero) and J.IsInRange(bot, enemyHero, 800) and not J.IsInRange(bot, enemyHero, 400) and J.IsChasingTarget(enemyHero, bot) then
                                local tResult = PointToLineDistance(botLocation, botTarget:GetLocation(), unitLocation)
                                if tResult ~= nil and tResult.within and tResult.distance <= 185 then
                                    return 2
                                end
                            end
                        end
                    end
                else
                    local cogsCount1 = J.GetPowerCogsCountInLoc(botLocation, 1000)
                    local cogsCount2 = J.GetPowerCogsCountInLoc(botLocation, 216)

                    if #tEnemyHeroes_all >= 1
                    then
                        local nInRangeEnemy = J.GetEnemiesNearLoc(botLocation, 800)

                        -- Is stuck inside?
                        if cogsCount1 == 8 and cogsCount2 >= 4 and withinAttackRange
                        then
                            if #nInRangeEnemy == 0
                            or J.IsGoingOnSomeone(bot)
                            or (J.IsRetreating(bot) and not J.IsRealInvisible(bot) and #nInRangeEnemy >= 1)
                            or #tAllyHeroes < #tEnemyHeroes
                            then
                                return 0.95
                            else
                                return 0.55
                            end
                        end
                    end

                    if #tEnemyHeroes == 0 then
                        if cogsCount1 == 8 and cogsCount2 >= 4 and withinAttackRange then
                            return 0.90
                        else
                            if bot:GetTeam() ~= unit:GetTeam()
                            and J.IsInRange(bot, unit, botAttackRange + 350)
                            and not J.IsInLaningPhase()
                            then
                                return 0.75
                            else
                                return 0.50
                            end
                        end
                    end
                end
            end

            if bot:GetTeam() ~= unit:GetTeam()
            then
                if string.find(sUnitName, 'juggernaut_healing_ward')
                or string.find(sUnitName, 'invoker_forged_spirit')
                or string.find(sUnitName, 'venomancer_plague_ward')
                or string.find(sUnitName, 'clinkz_skeleton_archer')
                then
                    if J.IsInRange(bot, unit, botAttackRange + 300) then
                        return RemapValClamped(botLevel, 1, 6, 0.44, 0.55)
                    end

                    if #tEnemyHeroes == 0 then
                        if botHP > 0.6 then
                            return 0.9
                        else
                            return 0.75
                        end
                    end
                elseif string.find(sUnitName, 'shadow_shaman_ward') and not bOutnumbered
                then
                    local tSerpents = J.GetSameUnitType(bot, 1600, sUnitName, false)
                    local unitsAttackDamage = bot:GetActualIncomingDamage(J.GetUnitListTotalAttackDamage(tSerpents, 5.0), DAMAGE_TYPE_PHYSICAL) - botHealthRegen * 5.0

                    if not J.IsInTeamFight(bot, 1200) and not (J.IsRetreating(bot) and J.IsRealInvisible(bot)) then
                        if unitsAttackDamage / botHealth < 0.4
                        or J.IsInRange(bot, unit, botAttackRange) and not J.IsInRange(bot, unit, unit:GetAttackRange()) then
                            return 0.95
                        end
                    end
                elseif string.find(sUnitName, 'pugna_nether_ward') and not bOutnumbered
                then
                    if J.IsInRange(bot, unit, botAttackRange + 150) then
                        if J.IsGoingOnSomeone(bot) and (not X.IsHeroWithinRadius(tEnemyHeroes, 800) or not X.IsBeingAttackedByHero(bot)) then
                            return 0.75
                        else
                            if not X.IsBeingAttackedByHero(bot) then
                                return 0.90
                            end
                        end
                    else
                        return 0.5
                    end
                elseif string.find(sUnitName, 'grimstroke_ink_creature')
                    or string.find(sUnitName, 'weaver_swarm')
                then
                    if #tEnemyHeroes == 0 then
                        return 0.95
                    end

                    if J.IsGoingOnSomeone(bot) and (not X.IsHeroWithinRadius(tEnemyHeroes, 600) or not X.IsBeingAttackedByHero(bot))
                    then
                        return 0.9
                    else
                        if not X.IsHeroWithinRadius(tEnemyHeroes, 600) then
                            return 0.75
                        end
                    end
                elseif string.find(sUnitName, 'gyrocopter_homing_missile')
                then
                    if not J.IsInTeamFight(bot, 1200)
                    and withinAttackRange
                    and not (J.IsRetreating(bot) and J.IsRealInvisible(bot))
                    and not X.IsBeingAttackedByHero(bot)
                    then
                        if not J.IsRunning(unit)
                        or not J.IsInRange(bot, unit, 250)
                        then
                            return 0.9
                        end
                    end
                elseif string.find(sUnitName, 'ignis_fatuss')
                    or string.find(sUnitName, 'zeus_cloud')
                then
                    if #tAllyHeroes > #tEnemyHeroes or #tEnemyHeroes_all == 0
                    then
                        if J.IsInRange(bot, unit, botAttackRange + 500) then return 0.9 end
                        return 0.75
                    end
                elseif unit:HasModifier('modifier_dominated')
                    or unit:HasModifier('modifier_chen_holy_persuasion')
                    or unit:IsDominated()
                    or string.find(sUnitName, 'visage_familiar')
                then
                    if not bOutnumbered and J.IsInRange(bot, unit, botAttackRange + 500) then
                        local unitAttackDamage = bot:GetActualIncomingDamage(X.GetUnitAttackDamageWithinTime(unit, 5.0), DAMAGE_TYPE_PHYSICAL) - botHealthRegen * 5.0
                        botAttackDamage = unit:GetActualIncomingDamage(botAttackDamage, DAMAGE_TYPE_PHYSICAL) - unitHealthRegen * 5.0

                        if not J.IsInTeamFight(bot, 1200)
                        and not (J.IsRetreating(bot) and not J.IsRealInvisible(bot))
                        and botAttackDamage / unitHealth > 0.5 and unitAttackDamage / botHealth < 0.4
                        then
                            return 0.9
                        end
                    end
                elseif string.find(sUnitName, 'lycan_wolf')
                    or string.find(sUnitName, 'eidolon')
                    or string.find(sUnitName, 'beastmaster_boar')
                    or string.find(sUnitName, 'beastmaster_greater_boar')
                    or string.find(sUnitName, 'furion_treant')
                    or string.find(sUnitName, 'broodmother_spiderling')
                    or string.find(sUnitName, 'skeleton_warrior')
                then
                    if not bOutnumbered and J.IsInRange(bot, unit, botAttackRange + 300) and not J.IsRetreating(bot) then
                        local tUnits = J.GetSameUnitType(bot, 1600, sUnitName, true)
                        local unitsAttackDamage = bot:GetActualIncomingDamage(J.GetUnitListTotalAttackDamage(tUnits, 5.0), DAMAGE_TYPE_PHYSICAL) - botHealthRegen * 5.0
                        local totalUnitHealth = X.GetTotalUnitHealth(tUnits)
                        botAttackDamage = J.GetTotalAttackDamageToUnits(botAttackDamage, tUnits, DAMAGE_TYPE_PHYSICAL) - unitHealthRegen * 5.0

                        if not J.IsInTeamFight(bot, 1200)
                        and unitsAttackDamage / botHealth < 0.34
                        and botAttackDamage / totalUnitHealth > 0.65
                        then
                            return 0.9
                        end
                    end
                elseif string.find(sUnitName, 'observer_wards')
                    or string.find(sUnitName, 'sentry_wards')
                then
                    if not X.IsBeingAttackedByHero(bot) or #tEnemyHeroes <= 1
                    then
                        if J.IsInRange(bot, unit, botAttackRange + 500) then return 0.95 end
                        return 0.75
                    end
                elseif string.find(sUnitName, 'phoenix_sun') and not bOutnumbered
                then
                    if (#tAllyHeroes >= #tEnemyHeroes or J.WeAreStronger(bot, 1600))
                    and not bot:HasModifier('modifier_phoenix_fire_spirit_burn')
                    and not J.IsRetreating(bot)
                    and botHP > 0.45
                    then
                        if J.IsInRange(bot, unit, botAttackRange + 300) then return 0.95 end
                        return 0.75
                    end
                elseif string.find(sUnitName, 'ice_spire') and not bOutnumbered
                then
                    if (#tAllyHeroes >= #tEnemyHeroes or J.WeAreStronger(bot, 1600))
                    and (botHP > 0.80 or bMagicImmune)
                    and not J.IsRetreating(bot)
                    and not X.IsBeingAttackedByHero(bot)
                    then
                        if J.IsInRange(bot, unit, botAttackRange + 300) then return 0.9 end
                        return 0.75
                    end
                elseif string.find(sUnitName, 'tombstone') and not bOutnumbered
                then
                    if #tAllyHeroes_all >= #tEnemyHeroes_all and not J.IsRetreating(bot) and botHP > 0.45
                    then
                        if J.IsInRange(bot, unit, botAttackRange + 300) then return 0.95 end
                        return 0.75
                    end
                elseif string.find(sUnitName, 'warlock_golem') and not bOutnumbered
                then
                    local tGolems = J.GetSameUnitType(bot, 1600, sUnitName, false)
                    local unitAttackDamage = bot:GetActualIncomingDamage(J.GetUnitListTotalAttackDamage(tGolems, 5.0), DAMAGE_TYPE_PHYSICAL) - botHealthRegen * 5.0
                    botAttackDamage = unit:GetActualIncomingDamage(X.GetUnitAttackDamageWithinTime(bot, 5.0), DAMAGE_TYPE_PHYSICAL) - unitHealthRegen * 5.0

                    if not J.IsInTeamFight(bot, 1200)
                    and #tAllyHeroes_all >= #tEnemyHeroes_all
                    and not J.IsRetreating(bot)
                    then
                        local canKillGolem = botAttackDamage / unitHealth > 0.75 and unitAttackDamage / botHealth < 0.4

                        if J.IsInRange(bot, unit, botAttackRange + 300) then
                            if not X.IsUnitAfterUnit(unit, bot)
                            or (X.IsUnitAfterUnit(unit, bot) and canKillGolem)
                            then
                                return 0.95
                            else
                                return 0.75
                            end
                        else
                            if not X.IsUnitAfterUnit(unit, bot)
                            or (X.IsUnitAfterUnit(unit, bot) and canKillGolem)
                            then
                                return 0.75
                            end
                        end
                    end
                end
            end
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.Think()
    if J.CanNotUseAction(bot) then return end

    if J.IsValid(targetUnit) and not bot:IsDisarmed() then
        bot:Action_AttackUnit(targetUnit, true)
        return
    end
end

function X.IsUnitAfterUnit(hUnit1, hUnit2)
    return hUnit1:GetAttackTarget() == hUnit2 or J.IsChasingTarget(hUnit1, hUnit2)
end

function X.GetUnitAttackDamageWithinTime(hUnit, fTimeInterval)
    return hUnit:GetAttackDamage() * hUnit:GetAttackSpeed() * fTimeInterval
end

function X.GetTotalUnitHealth(tUnits)
    local hp = 0
    for i = 1, #tUnits
    do
        hp = hp + tUnits[i]:GetHealth()
    end

    return hp
end

function X.IsBeingAttackedByHero(hUnit)
    local nEnemyHeroes = J.GetEnemiesNearLoc(hUnit:GetLocation(), 1600)
    for _, enemy in pairs(nEnemyHeroes) do
        if J.IsValidHero(enemy)
        and not J.IsSuspiciousIllusion(enemy)
        and (enemy:GetAttackTarget() == hUnit or J.IsChasingTarget(enemy, hUnit))
        then
            return true
        end
    end

    return false
end

function X.IsHeroWithinRadius(tUnits, nRadius)
    if J.IsValidHero(tUnits[1]) and J.IsInRange(bot, tUnits[1], nRadius) then
        return true
    end

    return false
end

return X