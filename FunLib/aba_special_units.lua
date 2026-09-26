local X = {}

local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')

-- handle attacking special units

local targetUnit = nil

function X.GetDesire(hUnit)
    bot = hUnit

    if J.CanNotUseAction(bot)
    or bot:IsDisarmed()
    or bot:HasModifier('modifier_phoenix_fire_spirit_burn')
    then
        return BOT_MODE_DESIRE_NONE
    end

	local totalAttackingDamageEnemy = X.GetTotalDamageToUnit(bot, true, true, true, true, 5.0)

	if totalAttackingDamageEnemy / bot:GetHealth() >= 0.5 then
		return BOT_MODE_DESIRE_NONE
	end

    local botHealth = bot:GetHealth()
    local botHP = J.GetHP(bot)
    local botLocation = bot:GetLocation()
	local botAttackRange = bot:GetAttackRange()
    local botLevel = bot:GetLevel()
    local botMovementSpeed = bot:GetCurrentMovementSpeed()
    local botActiveMode = bot:GetActiveMode()
    local bMagicImmune = bot:IsMagicImmune()
    local botTarget = J.GetProperTarget(bot)
    local botName = bot:GetUnitName()
    local botHealthRegen = bot:GetHealthRegen()
    local botSecPerAttack = bot:GetSecondsPerAttack()

    local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), 1600)
	local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1600)

    local nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
    local bOutnumbered = #nInRangeEnemy > #nInRangeAlly

    local bIsGoingOnSomeone = J.IsGoingOnSomeone(bot) and botActiveMode ~= BOT_MODE_TEAM_ROAM

    local nUnitList = GetUnitList(UNIT_LIST_ALL)
    for _, unit in pairs(nUnitList) do
		if J.IsValid(unit) and J.IsInRange(bot, unit, 1600) then
            bot.special_unit_target = unit
            local sUnitName = unit:GetUnitName()
            local nUnitHealth = unit:GetHealth()
            local nUnitHealthRegen = unit:GetHealthRegen()
            local vUnitLocation = unit:GetLocation()
            local dist = GetUnitToUnitDistance(bot, unit)
            local bWithinAttackRange = dist <= botAttackRange
            local bOutsideTowerRange = X.IsOutsideTowerRange(unit, nUnitList)

            if string.find(sUnitName, 'rattletrap_cog')
            then
                -- Expanded Armature
                -- seems? facet have a frame hit when inside
                if string.find(botName, 'rattletrap') and bWithinAttackRange and false then
                    if bIsGoingOnSomeone then
                        if J.IsValidHero(botTarget)
                        and J.CanCastOnNonMagicImmune(botTarget)
                        and J.IsInRange(bot, botTarget, 800)
                        and not J.IsInRange(bot, botTarget, 400)
                        and not (J.IsInRange(bot, botTarget, 800) and J.IsChasingTarget(bot, botTarget))
                        then
                            local tResult = PointToLineDistance(botLocation, botTarget:GetLocation(), vUnitLocation)
                            if tResult ~= nil and tResult.within and tResult.distance <= 185 then
                                return BOT_MODE_DESIRE_VERYHIGH * 1.5
                            end
                        end
                    end

                    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
                        for _, enemyHero in pairs(nInRangeEnemy) do
                            if J.IsValidHero(enemyHero) and J.IsInRange(bot, enemyHero, 800) and not J.IsInRange(bot, enemyHero, 400) and J.IsChasingTarget(enemyHero, bot) then
                                local tResult = PointToLineDistance(botLocation, botTarget:GetLocation(), vUnitLocation)
                                if tResult ~= nil and tResult.within and tResult.distance <= 185 then
                                    return BOT_MODE_DESIRE_VERYHIGH * 1.5
                                end
                            end
                        end
                    end
                else
                    if bot:IsFacingLocation(unit:GetLocation(), 60) and J.IsInRange(bot, unit, 300) then
                        if bIsGoingOnSomeone then
                            if J.IsValidHero(botTarget) and not J.IsInRange(bot, botTarget, botAttackRange) then
                                return BOT_MODE_DESIRE_VERYHIGH * 1.5
                            end
                        end

                        return BOT_MODE_DESIRE_ABSOLUTE
                    end
                end
            end

            if bot:GetTeam() ~= unit:GetTeam() then
                if string.find(sUnitName, 'phoenix_sun') then
                    if (not bOutnumbered or J.WeAreStronger(bot, 1600))
                    and not bot:HasModifier('modifier_phoenix_fire_spirit_burn')
                    and not J.IsRetreating(bot)
                    and botHP > 0.45
                    then
                        if J.IsInRange(bot, unit, botAttackRange + 300) then
                            if botSecPerAttack <= 0.3 then
                                return BOT_MODE_DESIRE_ABSOLUTE * 1.5
                            else
                                return BOT_MODE_DESIRE_ABSOLUTE
                            end
                        end
                    end
                end

                if string.find(sUnitName, 'tombstone') and not bOutnumbered then
                    if #nAllyHeroes >= #nEnemyHeroes and not J.IsRetreating(bot) and botHP > 0.45 then
                        if J.IsInRange(bot, unit, botAttackRange + 300) then
                            if botSecPerAttack <= 0.3 then
                                return BOT_MODE_DESIRE_ABSOLUTE * 1.5
                            else
                                return BOT_MODE_DESIRE_ABSOLUTE
                            end
                        end
                    end
                end

                if string.find(sUnitName, 'shadow_shaman_ward') and not bOutnumbered then
                    local nSerpentList = J.GetSameUnitType(bot, 700, sUnitName, false)
                    local unitsAttackDamage = bot:GetActualIncomingDamage(J.GetUnitListTotalAttackDamage(nSerpentList, 5.0), DAMAGE_TYPE_PHYSICAL) - botHealthRegen * 5.0

                    if #nSerpentList > 0 and not bIsGoingOnSomeone then
                        if unitsAttackDamage / #nSerpentList < botHealthRegen
                        or unitsAttackDamage / botHealth < 0.4
                        then
                            return BOT_MODE_DESIRE_ABSOLUTE
                        end
                    end

                    if #nEnemyHeroes == 0 and not bot:WasRecentlyDamagedByAnyHero(5.0) and dist > 650 and bWithinAttackRange then
                        return BOT_MODE_DESIRE_ABSOLUTE
                    end

                    -- stuck inside
                    nSerpentList = J.GetSameUnitType(bot, 250, sUnitName, false)
                    if #nSerpentList >= 10 then
                        if bot:IsFacingLocation(unit:GetLocation(), 45) and bWithinAttackRange then
                            return BOT_MODE_DESIRE_ABSOLUTE
                        end
                    end
                end

                if string.find(sUnitName, 'ignis_fatuss')
                or string.find(sUnitName, 'zeus_cloud')
                then
                    if #nInRangeAlly > #nInRangeEnemy or (#nEnemyHeroes == 0 and not bot:WasRecentlyDamagedByAnyHero(8.0) and bOutsideTowerRange) then
                        if (string.find(sUnitName, 'ignis_fatuss') and (dist <= 725 or bWithinAttackRange))
                        or (string.find(sUnitName, 'zeus_cloud')   and ((dist <= 450 and botHP > 0.3) or (dist > 425 and bWithinAttackRange)))
                        then
                            return BOT_MODE_DESIRE_ABSOLUTE
                        end
                    end
                end

                if string.find(sUnitName, 'pugna_nether_ward') and not bOutnumbered then
                    if #nEnemyHeroes == 0 and J.IsInRange(bot, unit, botAttackRange + 600) and bOutsideTowerRange then
                        return BOT_MODE_DESIRE_ABSOLUTE
                    end

                    if J.IsInRange(bot, unit, botAttackRange + 300) then
                        if bIsGoingOnSomeone then
                            if not X.IsEnemyHeroCanAttackNearby(nInRangeEnemy) and bWithinAttackRange then
                                return BOT_MODE_DESIRE_ABSOLUTE
                            end

                            if not X.IsBeingAttackedByHero(bot, nInRangeEnemy) then
                                return BOT_MODE_DESIRE_VERYHIGH
                            end
                        end
                    end
                end

                if string.find(sUnitName, 'juggernaut_healing_ward')
                or string.find(sUnitName, 'invoker_forged_spirit')
                or string.find(sUnitName, 'venomancer_plague_ward')
                or string.find(sUnitName, 'clinkz_skeleton_archer')
                or string.find(sUnitName, 'tinker_turret')
                then
                    if J.IsInRange(bot, unit, botAttackRange + 300) then
                        if not bOutnumbered then
                            if (bIsGoingOnSomeone)
                            or (#nInRangeAlly > #nInRangeEnemy)
                            then
                                return BOT_MODE_DESIRE_VERYHIGH
                            end
                        end

                        if #nInRangeEnemy == 0 then
                            if botHP > 0.5 or string.find(sUnitName, 'juggernaut_healing_ward') then
                                return BOT_MODE_DESIRE_ABSOLUTE
                            end
                        end
                    end
                end

                if string.find(sUnitName, 'grimstroke_ink_creature')
                or string.find(sUnitName, 'weaver_swarm')
                then
                    if #nInRangeEnemy == 0 then
                        return BOT_MODE_DESIRE_ABSOLUTE
                    end

                    if not J.IsStunProjectileIncoming(bot, 800) then
                        if bIsGoingOnSomeone and (not X.IsEnemyHeroCanAttackNearby(nInRangeEnemy) or not X.IsBeingAttackedByHero(bot, nInRangeEnemy)) then
                            return BOT_MODE_DESIRE_VERYHIGH
                        end

                        if not X.IsEnemyHeroCanAttackNearby(nInRangeEnemy) then
                            return BOT_MODE_DESIRE_VERYHIGH + 0.05
                        end
                    end
                end

                if string.find(sUnitName, 'gyrocopter_homing_missile') then
                    if  not J.IsInTeamFight(bot, 1200)
                    and not (J.IsRetreating(bot) and J.IsRealInvisible(bot))
                    and not X.IsBeingAttackedByHero(bot, nInRangeEnemy)
                    and bWithinAttackRange
                    then
                        if bOutsideTowerRange or not bot:WasRecentlyDamagedByTower(5.0) then
                            if #nEnemyHeroes == 0 and not bot:WasRecentlyDamagedByAnyHero(5.0) then
                                return BOT_MODE_DESIRE_ABSOLUTE
                            else
                                return BOT_MODE_DESIRE_VERYHIGH
                            end
                        end
                    end
                end

                if string.find(sUnitName, 'observer_wards')
                or string.find(sUnitName, 'sentry_wards')
                then
                    if  J.IsInRange(bot, unit, botAttackRange + 500)
                    and not bot:WasRecentlyDamagedByAnyHero(5.0)
                    and bOutsideTowerRange
                    then
                        return BOT_MODE_DESIRE_ABSOLUTE
                    end
                end

                if string.find(sUnitName, 'ice_spire') then
                    if  not bOutnumbered
                    and not J.IsRetreating(bot)
                    and J.IsInRange(bot, unit, botAttackRange + 80)
                    and (botHP > 0.80 or bMagicImmune)
                    then
                        if not X.IsBeingAttackedByHero(bot, nInRangeEnemy) then
                            return BOT_MODE_DESIRE_ABSOLUTE
                        end

                        return BOT_MODE_DESIRE_VERYHIGH
                    end
                end

                local nUnitMovementSpeed = unit:GetCurrentMovementSpeed()
                local nUnitAttackRange = unit:GetAttackRange()

                if unit:HasModifier('modifier_dominated')
                or unit:HasModifier('modifier_chen_holy_persuasion')
                or unit:IsDominated()
                or string.find(sUnitName, 'visage_familiar')
                or string.find(sUnitName, 'chen_zealot_goodguys')
                then
                    if  not bOutnumbered
                    and not bIsGoingOnSomeone
                    and not J.IsRetreating(bot)
                    and botMovementSpeed > nUnitMovementSpeed
                    and (J.IsInRange(bot, unit, botAttackRange + 300) or J.IsInRange(bot, unit, nUnitAttackRange + 300))
                    then
                        local unitsAttackDamageAlly = X.GetTotalDamageToUnit(unit, false, true, true, true, 5.0)

                        if (unitsAttackDamageAlly / nUnitHealth) >= 0.5 and (totalAttackingDamageEnemy / botHealth) < 0.4 then
                            return BOT_MODE_DESIRE_ABSOLUTE
                        end
                    end
                end

                if string.find(sUnitName, 'lycan_wolf')
                or string.find(sUnitName, 'eidolon')
                or string.find(sUnitName, 'beastmaster_boar')
                or string.find(sUnitName, 'beastmaster_greater_boar')
                or string.find(sUnitName, 'furion_treant')
                or string.find(sUnitName, 'broodmother_spiderling')
                or string.find(sUnitName, 'skeleton_warrior')
                then
                    if  not bIsGoingOnSomeone
                    and not J.IsRetreating(bot)
                    and J.IsInRange(bot, unit, botAttackRange + 200)
                    and botMovementSpeed > nUnitMovementSpeed
                    then
                        if totalAttackingDamageEnemy / botHealth < 0.4 then
                            if #nInRangeEnemy == 0 and not bot:WasRecentlyDamagedByAnyHero(5.0) then
                                return BOT_MODE_DESIRE_ABSOLUTE
                            end

                            return BOT_MODE_DESIRE_VERYHIGH
                        end
                    end
                end

                if string.find(sUnitName, 'warlock_golem') then
                    if  not bIsGoingOnSomeone
                    and not bOutnumbered
                    and not J.IsRetreating(bot)
                    and not bot:WasRecentlyDamagedByTower(5.0)
                    then
                        local fTime = 6.0
                        local damage = bot:GetEstimatedDamageToTarget(true, unit, fTime, DAMAGE_TYPE_PHYSICAL) > (nUnitHealth + nUnitHealthRegen * 6.0)

                        if J.IsInRange(bot, unit, botAttackRange) and not J.IsInRange(bot, unit, nUnitAttackRange) and damage > 0.3 then
                            return BOT_MODE_DESIRE_ABSOLUTE
                        end

                        if J.IsInRange(bot, unit, botAttackRange + 300) and bOutsideTowerRange then
                            if damage > 0.75
                            or J.GetHeroesTargetingUnit(nInRangeEnemy, unit) >= 4
                            then
                                return BOT_MODE_DESIRE_ABSOLUTE
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
    return (hUnit:GetAttackDamage() / hUnit:GetSecondsPerAttack()) * fTimeInterval
end

function X.GetTotalUnitHealth(tUnits)
    local hp = 0
    for i = 1, #tUnits
    do
        hp = hp + tUnits[i]:GetHealth()
    end

    return hp
end

function X.IsBeingAttackedByHero(hUnit, nUnitList)
    for _, enemy in pairs(nUnitList) do
        if J.IsValidHero(enemy) and (enemy:GetAttackTarget() == hUnit or J.IsChasingTarget(enemy, hUnit)) then
            return true
        end
    end

    return false
end

function X.IsEnemyHeroCanAttackNearby(nUnitList)
    for _, enemy in pairs(nUnitList) do
        if J.IsValidHero(enemy) and J.IsInRange(bot, enemy, enemy:GetAttackRange() + 150) then
            return true
        end
    end

    return false
end

function X.GetTotalDamageToUnit(hUnit, bEnemy, bHero, bCreep, bTower, fTime)
	local totalAttackingDamage = 0
	local nUnitList = GetUnitList(UNIT_LIST_ALL)
    for _, unit in pairs(nUnitList) do
        if J.IsValid(unit) and (hUnit:GetTeam() ~= unit:GetTeam()) == bEnemy and J.IsInRange(hUnit, unit, 1600) then
			if unit:GetAttackTarget() == hUnit
			or J.IsChasingTarget(unit, hUnit)
			or (unit:IsHero() and hUnit:WasRecentlyDamagedByHero(unit, 3.0))
			then
				local fTimeToReach = (GetUnitToUnitDistance(unit, hUnit) - unit:GetAttackRange()) / unit:GetCurrentMovementSpeed()
                local damage = hUnit:GetActualIncomingDamage((unit:GetAttackDamage() / unit:GetSecondsPerAttack()) * (fTime + fTimeToReach), DAMAGE_TYPE_PHYSICAL)

                if bHero then
                    if not J.IsSuspiciousIllusion(unit) then
                        totalAttackingDamage = totalAttackingDamage + unit:GetEstimatedDamageToTarget(true, hUnit, fTime + fTimeToReach, DAMAGE_TYPE_ALL)
                    else
                        totalAttackingDamage = totalAttackingDamage + damage
                    end
                elseif bCreep then
                    totalAttackingDamage = totalAttackingDamage + damage
                elseif bTower then
                    totalAttackingDamage = totalAttackingDamage + damage
                end
			end
		end
    end

    return totalAttackingDamage
end

function X.IsOutsideTowerRange(hUnit, nUnitList)
    for _, unit in pairs(nUnitList) do
        if J.IsValidBuilding(unit) and unit:IsTower() and J.IsInRange(hUnit, unit, 900) then
            return false
        end
    end
    return true
end

return X