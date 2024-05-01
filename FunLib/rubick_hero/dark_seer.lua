local bot
local X = {}
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')

local Vacuum
local IonShell
local Surge
local WallOfReplica

local botTarget

function X.ConsiderStolenSpell(ability)
    bot = GetBot()

    if J.CanNotUseAbility(bot) then return end

    botTarget = J.GetProperTarget(bot)
    local abilityName = ability:GetName()

    if abilityName == 'dark_seer_vacuum'
    then
        Vacuum = ability
        VacuumDesire, VacuumLocation = X.ConsiderVacuum()
        if VacuumDesire > 0
        then
            bot:Action_UseAbilityOnLocation(Vacuum, VacuumLocation)
            return
        end
    end

    if abilityName == 'dark_seer_wall_of_replica'
    then
        WallOfReplica = ability
        WallOfReplicaDesire, WallOfReplicaLocation = X.ConsiderWallOfReplica()
        if WallOfReplicaDesire > 0
        then
            bot:Action_UseAbilityOnLocation(WallOfReplica, WallOfReplicaLocation)
            return
        end
    end

    if abilityName == 'dark_seer_surge'
    then
        Surge = ability
        SurgeDesire, SurgeTarget = X.ConsiderSurge()
        if SurgeDesire > 0
        then
            bot:Action_UseAbilityOnEntity(Surge, SurgeTarget)
            return
        end
    end

    if abilityName == 'dark_seer_ion_shell'
    then
        IonShell = ability
        IonShellDesire, IonShellTarget = X.ConsiderIonShell()
        if IonShellDesire > 0
        then
            bot:Action_UseAbilityOnEntity(IonShell, IonShellTarget)
            return
        end
    end
end

function X.ConsiderVacuum()
    if not Vacuum:IsFullyCastable()
    then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nCastRange = J.GetProperCastRange(false, bot, Vacuum:GetCastRange())
    local nCastPoint = Vacuum:GetCastPoint()
    local nRadius = Vacuum:GetSpecialValueInt('radius')
    local nDamage = Vacuum:GetSpecialValueInt('damage')
    local nEnemyHeroes = bot:GetNearbyHeroes(nCastRange, true, BOT_MODE_NONE)

    for _, enemyHero in pairs(nEnemyHeroes)
    do
        if  J.IsValidHero(enemyHero)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
        and not J.IsInTeamFight(bot, 1200)
        and not J.IsSuspiciousIllusion(enemyHero)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
        and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
        then
            return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
        end
    end

	if J.IsInTeamFight(bot, 1200)
	then
		local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, nCastPoint, 0)
        local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)

		if nInRangeEnemy ~= nil and #nInRangeEnemy >= 2
		then
			return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nInRangeEnemy)
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange + nRadius)
        and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:HasModifier('modifier_enigma_black_hole_pull')
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not botTarget:HasModifier("modifier_legion_commander_duel")
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
            local nInRangeAlly = botTarget:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
            local nInRangeEnemy = botTarget:GetNearbyHeroes(1200, false, BOT_MODE_NONE)

            if  nInRangeAlly ~= nil and nInRangeEnemy ~= nil
            and #nInRangeAlly >= #nInRangeEnemy
            then
                if not J.IsInRange(bot, botTarget, nCastRange)
                then
                    return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, botTarget:GetLocation(), nCastRange)
                else
                    return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
                end
            end
		end
	end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderIonShell()
	if not IonShell:IsFullyCastable()
    then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = J.GetProperCastRange(false, bot, IonShell:GetCastRange())
    local nRadius = IonShell:GetSpecialValueInt('radius')
    local nAbilityLevel = IonShell:GetLevel()

    if J.IsGoingOnSomeone(bot)
	then
		local target = nil
		local maxTargetCount = 1

        local nAllyHeroes = bot:GetNearbyHeroes(nCastRange, false, BOT_MODE_NONE)
        if nAllyHeroes ~= nil and #nAllyHeroes >= 1
        then
            for _, allyHero in pairs(nAllyHeroes)
            do
                if  J.IsValid(allyHero)
                and not allyHero:IsIllusion()
                and not allyHero:HasModifier('modifier_dark_seer_ion_shell')
                and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
                then
                    local nAllyCount = 0
                    local nAllyEnemyHeroes = allyHero:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
                    local nAllyEnemyCreeps = allyHero:GetNearbyCreeps(1200, true)

                    for _, allyEnemyHero in pairs(nAllyEnemyHeroes)
                    do
                        if  allyEnemyHero ~= nil
                        and allyEnemyHero:IsAlive()
                        and allyEnemyHero:GetAttackTarget() == allyHero
                        and not J.IsSuspiciousIllusion(allyEnemyHero)
                        and allyHero:GetAttackRange() <= 326
                        then
                            nAllyCount = nAllyCount + 1
                        end
                    end

                    for _, creep in pairs(nAllyEnemyCreeps)
                    do
                        if  creep ~= nil
                        and creep:IsAlive()
                        and creep:GetAttackTarget() == allyHero
                        and creep:GetAttackRange() <= 326
                        then
                            nAllyCount = nAllyCount + 1
                        end
                    end

                    if nAllyCount > maxTargetCount
                    then
                        maxTargetCount = nAllyCount
                        target = allyHero
                    end
                end
            end
        else
            if  J.IsValidTarget(botTarget)
            and J.IsInRange(bot, botTarget, nRadius)
            and not J.IsSuspiciousIllusion(botTarget)
            and not bot:HasModifier('modifier_dark_seer_ion_shell')
            then
                target = bot
            end
        end

        if target ~= nil
        then
            return BOT_ACTION_DESIRE_HIGH, target
        end
	end

    if  J.IsRetreating(bot)
    and bot:GetActiveModeDesire() > 0.75
    and not Vacuum:IsFullyCastable()
	then
        local nInRangeEnemy = bot:GetNearbyHeroes(nRadius, true, BOT_MODE_NONE)
        for _, enemyHero in pairs(nInRangeEnemy)
        do
            if  J.IsValidHero(enemyHero)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.IsChasingTarget(enemyHero, bot)
            and not bot:HasModifier('modifier_dark_seer_ion_shell')
            and not J.IsSuspiciousIllusion(enemyHero)
            and not J.IsDisabled(enemyHero)
            and not J.IsRealInvisible(bot)
            then
                local nInRangeAlly = enemyHero:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
                local nTargetInRangeAlly = enemyHero:GetNearbyHeroes(1200, false, BOT_MODE_NONE)

                if  nInRangeAlly ~= nil and nTargetInRangeAlly ~= nil
                and ((#nTargetInRangeAlly > #nInRangeAlly)
                    or bot:WasRecentlyDamagedByAnyHero(2))
                then
                    return BOT_ACTION_DESIRE_HIGH, bot
                end
            end
        end
	end

	if J.IsPushing(bot) or J.IsDefending(bot)
	then
        local nInRangeEnemy = bot:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
        if nInRangeEnemy ~= nil and #nInRangeEnemy == 0
        then
            local nAllyLaneCreeps = bot:GetNearbyLaneCreeps(nCastRange, false)
            if  nAllyLaneCreeps ~= nil and #nAllyLaneCreeps >= 1
            then
                local targetCreep = nil
                local targetDis = 0

                for _, creep in pairs(nAllyLaneCreeps)
                do
                    if  J.IsValid(creep)
                    and J.GetHP(creep) > 0.75
                    and creep:DistanceFromFountain() > targetDis
                    and creep:GetAttackRange() <= 326
                    and not creep:HasModifier('modifier_dark_seer_ion_shell')
                    then
                        targetCreep = creep
                        targetDis = creep:DistanceFromFountain()
                    end
                end

                if targetCreep ~= nil
                then
                    return BOT_ACTION_DESIRE_HIGH, targetCreep
                end
            end
        end
	end

    if J.IsFarming(bot)
    then
        local botAttackTarget = bot:GetAttackTarget()
        local nNeutralCreeps = bot:GetNearbyNeutralCreeps(nRadius + bot:GetAttackRange())

        if  J.IsValid(botAttackTarget)
        and botAttackTarget:IsCreep()
        and nNeutralCreeps ~= nil and #nNeutralCreeps >= 2
        then
            if not bot:HasModifier('modifier_dark_seer_ion_shell')
            then
                return BOT_ACTION_DESIRE_HIGH, bot
            end
        end
    end

    if J.IsLaning(bot)
    then
        local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(nRadius, true)
        local nInRangeEnemy = bot:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
        local nEnemyTowers = bot:GetNearbyTowers(700, true)

        if  nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 3
        and nInRangeEnemy ~= nil and #nInRangeEnemy == 0
        and nEnemyTowers ~= nil and #nInRangeEnemy == 0
        and nAbilityLevel >= 2
        then
            if  J.IsAttacking(bot)
            and J.CanBeAttacked(nEnemyLaneCreeps[1])
            and not bot:HasModifier('modifier_dark_seer_ion_shell')
            then
                return BOT_ACTION_DESIRE_HIGH, bot
            end
        end
    end

    if J.IsDoingRoshan(bot) or J.IsDoingTormentor(bot)
	then
		if  (J.IsRoshan(botTarget) or J.IsTormentor(botTarget))
        and J.IsInRange(bot, botTarget, nRadius)
        and J.IsAttacking(bot)
        and not bot:HasModifier('modifier_dark_seer_ion_shell')
		then
			return BOT_ACTION_DESIRE_HIGH, bot
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderSurge()
	if not Surge:IsFullyCastable()
    then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = J.GetProperCastRange(false, bot, Surge:GetCastRange())
    local nAbilityLevel = Surge:GetLevel()
    local RoshanLocation = J.GetCurrentRoshanLocation()
    local TormentorLocation = J.GetTormentorLocation(GetTeam())

	if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
        and J.IsInRange(bot, botTarget, 1200)
        and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
            local nAllyHeroes = bot:GetNearbyHeroes(1200, false, BOT_MODE_NONE)
			local tToMeDist = GetUnitToUnitDistance(bot, botTarget)
			local targetHero = bot

			for _, allyHero in pairs(nAllyHeroes)
            do
                local allyTarget = J.GetProperTarget(allyHero)
				local dist = GetUnitToUnitDistance(allyHero, botTarget)

				if  dist < tToMeDist
                and dist < nCastRange
                and J.IsValidTarget(allyTarget)
                and not J.IsSuspiciousIllusion(allyTarget)
                and not allyTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
                and not allyTarget:HasModifier('modifier_necrolyte_reapers_scythe')
                and allyHero:IsFacingLocation(allyTarget:GetLocation(), 30)
                then
					tToMeDist = dist
					targetHero = allyHero
				end
			end

			return BOT_ACTION_DESIRE_HIGH, targetHero
		end
	end

    if  J.IsRetreating(bot)
    and bot:GetActiveModeDesire() > 0.75
	then
        local nInRangeEnemy = bot:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
        for _, enemyHero in pairs(nInRangeEnemy)
        do
            if  J.IsValidHero(enemyHero)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.IsChasingTarget(enemyHero, bot)
            and J.IsInRange(bot, enemyHero, 600)
            and not bot:HasModifier('modifier_dark_seer_ion_shell')
            and not J.IsSuspiciousIllusion(enemyHero)
            and not J.IsDisabled(enemyHero)
            and not J.IsRealInvisible(bot)
            then
                local nInRangeAlly = enemyHero:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
                local nTargetInRangeAlly = enemyHero:GetNearbyHeroes(1200, false, BOT_MODE_NONE)

                if  nInRangeAlly ~= nil and nTargetInRangeAlly ~= nil
                and ((#nTargetInRangeAlly > #nInRangeAlly)
                    or bot:WasRecentlyDamagedByAnyHero(1.5))
                then
                    return BOT_ACTION_DESIRE_HIGH, bot
                end
            end
        end
	end

    if J.IsDoingRoshan(bot)
	then
        if  GetUnitToLocationDistance(bot, RoshanLocation) > 1600
        and J.GetManaAfter(Surge:GetManaCost()) * bot:GetMana() > Vacuum:GetManaCost()
        and J.GetManaAfter(Surge:GetManaCost()) * bot:GetMana() > WallOfReplica:GetManaCost()
        and nAbilityLevel >= 3
        then
            return BOT_ACTION_DESIRE_HIGH, bot
        end
	end

    if J.IsDoingTormentor(bot)
	then
        if  GetUnitToLocationDistance(bot, TormentorLocation) > 1600
        and J.GetManaAfter(Surge:GetManaCost()) * bot:GetMana() > Vacuum:GetManaCost()
        and J.GetManaAfter(Surge:GetManaCost()) * bot:GetMana() > WallOfReplica:GetManaCost()
        and nAbilityLevel >= 2
        then
            return BOT_ACTION_DESIRE_HIGH, bot
        end
	end

    local nAllyHeroes = bot:GetNearbyHeroes(nCastRange, false, BOT_MODE_NONE)
    for _, allyHero in pairs(nAllyHeroes)
    do
        local nAllyInRangeEnemy = allyHero:GetNearbyHeroes(1200, true, BOT_MODE_NONE)

        if  J.IsValidHero(allyHero)
        and J.IsRetreating(allyHero)
        and allyHero:WasRecentlyDamagedByAnyHero(1.5)
        and not allyHero:IsIllusion()
        then
            if  nAllyInRangeEnemy ~= nil and #nAllyInRangeEnemy >= 1
            and J.IsValidHero(nAllyInRangeEnemy[1])
            and J.IsInRange(bot, nAllyInRangeEnemy[1], nCastRange)
            and J.IsChasingTarget(nAllyInRangeEnemy[1], allyHero)
            and allyHero:GetCurrentMovementSpeed() < nAllyInRangeEnemy[1]:GetCurrentMovementSpeed()
            and allyHero:IsFacingLocation(J.GetTeamFountain(), 30)
            and not J.IsDisabled(nAllyInRangeEnemy[1])
            and not J.IsTaunted(nAllyInRangeEnemy[1])
            and not J.IsSuspiciousIllusion(nAllyInRangeEnemy[1])
            and not nAllyInRangeEnemy[1]:HasModifier('modifier_necrolyte_reapers_scythe')
            then
                return BOT_ACTION_DESIRE_HIGH, allyHero
            end
        end
    end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderWallOfReplica()
	if not WallOfReplica:IsFullyCastable()
	then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastRange = J.GetProperCastRange(false, bot, WallOfReplica:GetCastRange())
	local nCastPoint = WallOfReplica:GetCastPoint() + 0.73

	if J.IsInTeamFight(bot, 1200)
	then
        local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange + 300, 500, nCastPoint, 0)
        local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, 500)

        if nInRangeEnemy ~= nil and #nInRangeEnemy >= 2
        then
            return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nInRangeEnemy)
        end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

return X