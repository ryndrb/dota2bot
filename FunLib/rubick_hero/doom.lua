local bot
local X = {}
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')

local Devour
local ScorchedEarth
local InfernalBlade
local Doom

local botTarget

function X.ConsiderStolenSpell(ability)
    bot = GetBot()

    if J.CanNotUseAbility(bot) then return end

    botTarget = J.GetProperTarget(bot)
    local abilityName = ability:GetName()

    if abilityName == 'doom_bringer_doom'
    then
        Doom = ability
        DoomDesire, DoomTarget = X.ConsiderDoom()
        if DoomDesire > 0
        then
            bot:Action_UseAbilityOnEntity(Doom, DoomTarget)
            return
        end
    end

    if abilityName == 'doom_bringer_infernal_blade'
    then
        InfernalBlade = ability
        InfernalBladeDesire, InfernalBladeTarget = X.ConsiderInfernalBlade()
        if InfernalBladeDesire > 0
        then
            bot:Action_UseAbilityOnEntity(InfernalBlade, InfernalBladeTarget)
            return
        end
    end

    if abilityName == 'doom_bringer_scorched_earth'
    then
        ScorchedEarth = ability
        ScorchedEarthDesire = X.ConsiderScorchedEarth()
        if ScorchedEarthDesire > 0
        then
            bot:Action_UseAbility(ScorchedEarth)
            return
        end
    end

    if abilityName == 'doom_bringer_devour'
    then
        Devour = ability
        DevourDesire, DevourTarget = X.ConsiderDevour()
        if DevourDesire > 0
        then
            bot:Action_UseAbilityOnEntity(Devour, DevourTarget)
            return
        end
    end
end

function X.ConsiderDevour()
    if not Devour:IsFullyCastable()
    then
        return BOT_ACTION_DESIRE_NONE, nil
    end

	local nMaxLevel = Devour:GetSpecialValueInt('creep_level')
    local nCreeps = bot:GetNearbyCreeps(1200, true)

    if not J.IsRetreating(bot)
    then
        local nEnemyTowers = bot:GetNearbyTowers(1600, true)
        local nCreepTarget = X.GetRangedOrSiegeCreep(nCreeps, nMaxLevel)

        if nCreepTarget ~= nil
        then
            if  J.IsLaning(bot)
            and nEnemyTowers ~= nil
            and (#nEnemyTowers == 0
                or #nEnemyTowers >= 1
                    and J.IsValidBuilding(nEnemyTowers[1])
                    and GetUnitToUnitDistance(nCreepTarget, nEnemyTowers[1]) > 700)
            then
                return BOT_ACTION_DESIRE_HIGH, nCreepTarget
            end
        end

        for _, creep in pairs(nCreeps)
        do
            if  J.IsValid(creep)
            and J.CanBeAttacked(creep)
            and creep:GetLevel() <= nMaxLevel
            and not J.IsRoshan(creep)
            and not J.IsTormentor(creep)
            then
                if  J.IsInLaningPhase()
                and creep:GetTeam() ~= bot:GetTeam()
                and creep:GetTeam() ~= TEAM_NEUTRAL
                and nEnemyTowers ~= nil
                and (#nEnemyTowers == 0
                    or #nEnemyTowers >= 1
                        and J.IsValidBuilding(nEnemyTowers[1])
                        and GetUnitToUnitDistance(creep, nEnemyTowers[1]) > 700)
                then
                    return BOT_ACTION_DESIRE_HIGH, creep
                end

                nCreepTarget = nil
                if  creep
                and creep:GetTeam() == TEAM_NEUTRAL
                then
                    nCreepTarget = J.GetMostHpUnit(nCreeps)
                end

                if nCreepTarget ~= nil
                then
                    if not nCreepTarget:IsAncientCreep()
                    then
                        return BOT_ACTION_DESIRE_HIGH, nCreepTarget
                    end
                end

                if not creep:IsAncientCreep()
                then
                    return BOT_ACTION_DESIRE_HIGH, creep
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderScorchedEarth()
    if not ScorchedEarth:IsFullyCastable()
    then
        return BOT_ACTION_DESIRE_NONE
    end

    local nRadius = ScorchedEarth:GetSpecialValueInt('radius')

    if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nRadius + 150)
        and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
        and not botTarget:HasModifier('modifier_skeleton_king_reincarnation_scepter_active')
		then
            local nInRangeAlly = botTarget:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
            local nInRangeEnemy = botTarget:GetNearbyHeroes(1200, false, BOT_MODE_NONE)

            if  nInRangeAlly ~= nil and nInRangeEnemy ~= nil
            and #nInRangeAlly >= #nInRangeEnemy
            then
                return BOT_ACTION_DESIRE_HIGH
            end
		end
	end

    if  J.IsRetreating(bot)
    and bot:GetActiveModeDesire() >= 0.75
	then
        local nInRangeEnemy = bot:GetNearbyHeroes(nRadius + 200, true, BOT_MODE_NONE)
        for _, enemyHero in pairs(nInRangeEnemy)
        do
            if  J.IsValidHero(enemyHero)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.IsChasingTarget(enemyHero, bot)
            and not J.IsSuspiciousIllusion(enemyHero)
            and not J.IsDisabled(enemyHero)
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            then
                local nInRangeAlly = enemyHero:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
                local nTargetInRangeAlly = enemyHero:GetNearbyHeroes(1200, false, BOT_MODE_NONE)

                if  nInRangeAlly ~= nil and nTargetInRangeAlly ~= nil
                and ((#nTargetInRangeAlly > #nInRangeAlly + 1)
                    or bot:WasRecentlyDamagedByAnyHero(2))
                then
                    return BOT_ACTION_DESIRE_HIGH
                end
            end
        end
	end

    if J.IsFarming(bot)
	then
		local nCreeps = bot:GetNearbyCreeps(nRadius, true)
        if  nEnemyLaneCreeps ~= nil
        and (#nCreeps >= 3 or (#nCreeps >= 2 and nCreeps[1]:IsAncientCreep()))
        and J.CanBeAttacked(nCreeps[1])
        and J.IsAttacking(bot)
        and J.GetManaAfter(ScorchedEarth:GetManaCost()) * bot:GetMana() > Doom:GetManaCost() * 1.75
        then
            return BOT_ACTION_DESIRE_HIGH
        end
	end

    if J.IsDoingRoshan(bot)
	then
		if  J.IsRoshan(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        and J.IsAttacking(bot)
        and J.GetManaAfter(ScorchedEarth:GetManaCost()) * bot:GetMana() > Doom:GetManaCost() * 2
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

    if J.IsDoingTormentor(bot)
    then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        and J.IsAttacking(bot)
        and J.GetManaAfter(ScorchedEarth:GetManaCost()) * bot:GetMana() > Doom:GetManaCost() * 2
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderInfernalBlade()
    if not InfernalBlade:IsFullyCastable()
    then
        return BOT_ACTION_DESIRE_NONE, nil
    end

	local nCastRange = InfernalBlade:GetCastRange()
    local nBurnDamage = InfernalBlade:GetSpecialValueInt('burn_damage')
    local nDamagePct = InfernalBlade:GetSpecialValueInt('burn_damage_pct') / 100
    local nDuration = InfernalBlade:GetSpecialValueInt('burn_duration')

	local nEnemyHeroes = bot:GetNearbyHeroes(700, true, BOT_MODE_NONE)
	for _, enemyHero in pairs(nEnemyHeroes)
	do
		if  J.IsValidHero(enemyHero)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanCastOnTargetAdvanced(enemyHero)
        and not J.IsSuspiciousIllusion(enemyHero)
		then
            local nEnemyTowers = enemyHero:GetNearbyTowers(700, false)
            if enemyHero:IsChanneling()
            then
                if J.IsInLaningPhase()
                then
                    if nEnemyTowers ~= nil and #nEnemyTowers == 0
                    then
                        return BOT_ACTION_DESIRE_HIGH, enemyHero
                    end
                else
                    return BOT_ACTION_DESIRE_HIGH, enemyHero
                end
            end

            if  J.WillKillTarget(enemyHero, nBurnDamage + enemyHero:GetMaxHealth() * nDamagePct, DAMAGE_TYPE_MAGICAL, nDuration)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
            and not enemyHero:HasModifier('modifier_skeleton_king_reincarnation_scepter_active')
            and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
            then
                if J.IsInLaningPhase()
                then
                    if nEnemyTowers ~= nil and #nEnemyTowers == 0
                    then
                        return BOT_ACTION_DESIRE_HIGH, enemyHero
                    end
                else
                    return BOT_ACTION_DESIRE_HIGH, enemyHero
                end
            end
		end
	end

    if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.CanCastOnTargetAdvanced(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange + 150)
        and not J.IsSuspiciousIllusion(botTarget)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_enigma_black_hole_pull')
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_skeleton_king_reincarnation_scepter_active')
		then
            local nInRangeAlly = botTarget:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
            local nInRangeEnemy = botTarget:GetNearbyHeroes(1200, false, BOT_MODE_NONE)

            if  nInRangeAlly ~= nil and nInRangeEnemy ~= nil
            and #nInRangeAlly >= #nInRangeEnemy
            then
                return BOT_ACTION_DESIRE_HIGH, botTarget
            end
		end
	end

    if J.IsRetreating(bot)
	then
        local nInRangeEnemy = bot:GetNearbyHeroes(nCastRange, true, BOT_MODE_NONE)
        for _, enemyHero in pairs(nInRangeEnemy)
        do
            if  J.IsValidHero(enemyHero)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and J.IsChasingTarget(enemyHero, bot)
            and not J.IsSuspiciousIllusion(enemyHero)
            and not J.IsDisabled(enemyHero)
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            then
                local nInRangeAlly = enemyHero:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
                local nTargetInRangeAlly = enemyHero:GetNearbyHeroes(1200, false, BOT_MODE_NONE)

                if  nInRangeAlly ~= nil and nTargetInRangeAlly ~= nil
                and ((#nTargetInRangeAlly > #nInRangeAlly)
                    or bot:WasRecentlyDamagedByAnyHero(2))
                then
                    return BOT_ACTION_DESIRE_HIGH, enemyHero
                end
            end
        end
	end

	if J.IsFarming(bot)
	then
		local nNeutralCreeps = bot:GetNearbyNeutralCreeps(nCastRange + 150)
        if nNeutralCreeps ~= nil and #nNeutralCreeps >= 1
        then
            local targetCreep = J.GetMostHpUnit(nNeutralCreeps)
            if  J.IsValid(targetCreep)
            and J.GetManaAfter(ScorchedEarth:GetManaCost()) * bot:GetMana() > Doom:GetManaCost()
            and not J.IsOtherAllysTarget(targetCreep)
            then
                return BOT_ACTION_DESIRE_HIGH, targetCreep
            end
        end
	end

    if J.IsLaning(bot)
	then
		local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(nCastRange + 75, true)
		for _, creep in pairs(nEnemyLaneCreeps)
		do
			if  J.IsValid(creep)
            and J.CanBeAttacked(creep)
			and (J.IsKeyWordUnit('ranged', creep) or J.IsKeyWordUnit('siege', creep) or J.IsKeyWordUnit('flagbearer', creep))
			and creep:GetHealth() <= nBurnDamage
			then
				local nCreepInRangeHero = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

				if  nCreepInRangeHero ~= nil and #nCreepInRangeHero >= 1
                and GetUnitToUnitDistance(creep, nCreepInRangeHero[1]) < 500
				then
					return BOT_ACTION_DESIRE_HIGH, creep
				end
			end
		end
	end

	if J.IsDoingRoshan(bot)
	then
        -- Remove Spell Block
		if  J.IsRoshan(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

    if J.IsDoingTormentor(bot)
    then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderDoom()
	if not Doom:IsFullyCastable()
    then
		return BOT_ACTION_DESIRE_NONE, nil
	end

    local nDuration = Doom:GetSpecialValueInt('duration')

    if J.IsGoingOnSomeone(bot)
	then
		local target = nil
		local dmg = 0
        local nEnemyHeroes = bot:GetNearbyHeroes(1000, true, BOT_MODE_NONE)

		for _, enemyHero in pairs(nEnemyHeroes)
		do
			if  J.IsValid(enemyHero)
            and J.CanCastOnMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and not J.IsSuspiciousIllusion(enemyHero)
            and not J.IsDisabled(enemyHero)
            and not J.IsHaveAegis(enemyHero)
            and not enemyHero:HasModifier('modifier_doom_bringer_doom')
            and not enemyHero:HasModifier('modifier_enigma_black_hole_pull')
            and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
            and not enemyHero:HasModifier('modifier_skeleton_king_reincarnation_scepter_active')
			then
                local nInRangeAlly = enemyHero:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
                local nInRangeEnemy = enemyHero:GetNearbyHeroes(1600, false, BOT_MODE_NONE)

                if  nInRangeAlly ~= nil and nInRangeEnemy ~= nil
                and #nInRangeAlly >= #nInRangeEnemy
                then
                    local estDmg = enemyHero:GetEstimatedDamageToTarget(false, bot, 3.0, DAMAGE_TYPE_ALL)
                    if dmg < estDmg
                    then
                        dmg = estDmg
                        target = enemyHero
                    end
                end
			end
		end

		if target ~= nil
		then
            local nInRangeAlly = target:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
            local nInRangeEnemy = target:GetNearbyHeroes(1600, false, BOT_MODE_NONE)

            if nInRangeAlly ~= nil and nInRangeEnemy ~= nil
            then
                if J.IsInLaningPhase()
                then
                    if  not (#nInRangeAlly >= #nInRangeEnemy + 2)
                    and J.IsAttacking(target)
                    then
                        if target:GetHealth() <= bot:GetEstimatedDamageToTarget(true, target, nDuration, DAMAGE_TYPE_ALL)
                        then
                            return BOT_ACTION_DESIRE_HIGH, target
                        end
                    end
                else
                    if not (#nInRangeAlly >= #nInRangeEnemy + 2)
                    then
                        return BOT_ACTION_DESIRE_HIGH, target
                    end
                end
            end
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

return X