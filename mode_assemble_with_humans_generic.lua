if GetBot():IsInvulnerable() or not GetBot():IsHero() or not string.find(GetBot():GetUnitName(), "hero") or  GetBot():IsIllusion() then
	return
end

-- since I don't think this mode does anything
-- non-general retreat; for stuff that bots should retreat from if they'are not retreating
-- valve's default retreat mode works just fine (in the context of bots); not overriding that (bots have better pathing there); it's just not strong enough for certain things

local X = {}
local bot = GetBot()
local J = require( GetScriptDirectory()..'/FunLib/jmz_func')

local botTarget, botLevel, botHP, botHealth, botLocation

local nAllyHeroes, nAllyHeroes_attacking
local nEnemyHeroes

local nChainFrostBounceDistance = 600 -- min

local ShouldRetreatWhenTowerTargeted = false
local RetreatWhenTowerTargetedTime = 0

function GetDesire()
    if not bot:IsAlive() or J.IsRetreating(bot) then
        return BOT_MODE_DESIRE_NONE
    end

    local nDesire = 0
    botTarget = J.GetProperTarget(bot)
    botLevel = bot:GetLevel()
    botHP = J.GetHP(bot)
    botHealth = bot:GetHealth()
    botLocation = bot:GetLocation()

    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nAllyHeroes_attacking = bot:GetNearbyHeroes(1600, false, BOT_MODE_ATTACK)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    if bot:GetUnitName() == 'npc_dota_hero_medusa' then
        botHealth = botHealth + bot:GetMana()
    end

    nDesire = X.GetUnitDesire()
    if nDesire > 0 then
        return nDesire
    end

    nDesire = X.GetModifierDesire()
    if nDesire > 0 then
        return nDesire
    end

    ShouldRetreatWhenTowerTargeted = X.RetreatWhenTowerTargeted()
	if ShouldRetreatWhenTowerTargeted and DotaTime() < RetreatWhenTowerTargetedTime + 5
	then
		return 0.95
	end

    return BOT_MODE_DESIRE_NONE
end

function Think()
    if J.CanNotUseAction(bot) then return end

    if bot:HasModifier('modifier_lich_chainfrost_slow') then
        local targetLoc = bot:GetLocation()
        for _, unit in pairs(GetUnitList(UNIT_LIST_ALL))
        do
            if J.IsValid(unit)
            and bot ~= unit
            and not unit:IsBuilding()
            and not string.find(unit:GetUnitName(), 'ward')
            and J.IsInRange(bot, unit, nChainFrostBounceDistance)
            then
                -- ??
                local dir = botLocation - unit:GetLocation()
                dir = dir:Normalized() * nChainFrostBounceDistance
                targetLoc = targetLoc + dir
            end
        end

        bot:Action_MoveToLocation(targetLoc)
        return
    end

	if ShouldRetreatWhenTowerTargeted then
		bot:Action_MoveToLocation(J.GetTeamFountain() + J.RandomForwardVector(350))
		return
	end

    bot:Action_MoveToLocation(J.GetTeamFountain())
end

function X.GetUnitDesire()
    for _, unit in pairs(GetUnitList(UNIT_LIST_ENEMIES))
    do
        if J.IsValid(unit)
        and J.IsInRange(bot, unit, 1600)
        then
            local unitName = unit:GetUnitName()
            local unitHealth = unit:GetHealth()
            local botDamage = bot:GetAttackDamage() * bot:GetAttackSpeed() * 8.0
            local unitDamage = unit:GetAttackDamage() * unit:GetAttackSpeed() * 8.0
            local thisUnitIsAfterBot = J.IsChasingTarget(unit, bot) or unit:GetAttackTarget() == bot

            if J.IsSuspiciousIllusion(unit)
            then
                local tIllusions = X.GetUnitTypeAttackingBot(1600, unitName)
                local illusionPower = X.GetRightClickDamage(tIllusions, 8)

                if illusionPower > unitHealth
                then
                    if illusionPower > unitHealth * 1.5
                    then
                        return BOT_MODE_DESIRE_ABSOLUTE * 0.95
                    else
                        return BOT_MODE_DESIRE_HIGH
                    end
                end
            end

            if string.find(unitName, 'warlock_golem') and thisUnitIsAfterBot
            then
                local tWarlockGolems = X.GetUnitTypeAttackingBot(1600, unitName)
                local golemsPower = X.GetRightClickDamage(tWarlockGolems, 8)

                if #tWarlockGolems == 1
                then
                    if golemsPower * 1.5 < botHealth
                    then
                        return BOT_MODE_DESIRE_NONE
                    end
                end

                if golemsPower > botHealth
                then
                    return RemapValClamped(golemsPower / botHealth, 0.8, 1.5, 0.80, 0.9)
                end
            end

            if string.find(unitName, 'spiderlings') and thisUnitIsAfterBot
            and not J.IsInTeamFight(bot, 1600)
            then
                if not J.IsInTeamFight(bot, 1600)
                then
                    local tSpiderlings = X.GetUnitTypeAttackingBot(1600, unitName)
                    local spiderlingsPower = X.GetRightClickDamage(tSpiderlings, 8)

                    if spiderlingsPower > botHealth
                    then
                        return RemapValClamped(spiderlingsPower / botHealth, 1, 1.5, 0.75, 0.95)
                    end
                end
            end

            if string.find(unitName, 'eidolon') and thisUnitIsAfterBot
            and not J.IsInTeamFight(bot, 1600)
            then
                if not J.IsInTeamFight(bot, 1600)
                then
                    local tSpiderlings = X.GetUnitTypeAttackingBot(1600, unitName)
                    local eidolonPower = X.GetRightClickDamage(tSpiderlings, 8)

                    if eidolonPower > botHealth
                    then
                        return RemapValClamped(eidolonPower / botHealth, 0.82, 1.5, 0.75, 0.95)
                    end
                end
            end
        end
    end

    return BOT_MODE_DESIRE_NONE
end

function X.GetModifierDesire()
    local botIsMagicImmune = false

	if bot:IsMagicImmune()
	or bot:HasModifier('modifier_black_king_bar_immune')
	or bot:HasModifier('modifier_life_stealer_rage')
	then
		botIsMagicImmune = true
	end

	if bot:HasModifier('modifier_jakiro_macropyre_burn')
	then
        if J.IsInTeamFight(bot, 1200) and botHP > 0.75
        then
            return BOT_MODE_DESIRE_NONE
        end

        if botHP < 0.6 and X.IsBeingAttacked(bot)
        then
            return BOT_MODE_DESIRE_VERYHIGH
        end

        if botHP < 0.38
        then
            return BOT_MODE_DESIRE_ABSOLUTE * 0.98
        end
	end

    if bot:HasModifier('modifier_dark_seer_wall_slow')
    then
        if not J.IsInTeamFight(bot, 1600)
        then
            return BOT_MODE_DESIRE_NONE
        end
    end

    if botIsMagicImmune then return BOT_MODE_DESIRE_NONE end

    if bot:HasModifier('modifier_lich_chainfrost_slow')
    then
        if botIsMagicImmune
        then
            return BOT_MODE_DESIRE_NONE
        end

        if J.IsInTeamFight(bot, 1200)
        then
            if botHP < 0.5 and not J.WeAreStronger(bot, 1200)
            then
                return BOT_MODE_DESIRE_ABSOLUTE * 0.98
            end
        end

        if botHP < 0.5
        then
            if not botIsMagicImmune and X.IsOtherUnitsInRange(bot, nChainFrostBounceDistance)
            then
                return BOT_MODE_DESIRE_ABSOLUTE * 0.99
            end
        end
    end

    if bot:HasModifier('modifier_crystal_maiden_freezing_field_slow')
    or bot:HasModifier('modifier_windrunner_gale_force')
    or bot:HasModifier('modifier_warlock_upheaval')
    or bot:HasModifier('modifier_skywrath_mystic_flare_aura_effect')
    or bot:HasModifier('modifier_shredder_chakram_debuff')
    then
        if #nAllyHeroes > #nEnemyHeroes + 2 and botHP > 0.5
        then
            return BOT_MODE_DESIRE_NONE
        end

        if botHP < 0.5 and not botIsMagicImmune then
            return BOT_MODE_DESIRE_VERYHIGH
        end
    end

    if bot:HasModifier('modifier_sandking_sand_storm_slow')
    then
        if not J.WeAreStronger(bot, 1600) and not J.IsInTeamFight(bot, 1600)
        then
            return RemapValClamped(botLevel, 6, 15, 0.99, 0.75)
        end

        if J.IsInTeamFight(bot, 1600)
        then
            return BOT_MODE_DESIRE_NONE
        end
    end

    if bot:HasModifier('modifier_sand_king_epicenter_slow')
    then
        if botHP < 0.33 and not botIsMagicImmune
        then
            return BOT_MODE_DESIRE_NONE
        end
    end

    if bot:HasModifier('modifier_disruptor_static_storm')
    then
        if J.WeAreStronger(bot, 1600)
        then
            return BOT_MODE_DESIRE_NONE
        else
            return BOT_MODE_DESIRE_HIGH * 1.1
        end
    end

	return BOT_MODE_DESIRE_NONE
end

function X.RetreatWhenTowerTargeted()
	if DotaTime() > 10 * 60
    or J.IsInTeamFight(bot, 1600)
    or #nAllyHeroes_attacking >= #nEnemyHeroes + 1
	then
		return false
	end

	local nEnemyTowers = bot:GetNearbyTowers(1600, true)

    -- reduce feeding causes
	if J.IsValidBuilding(nEnemyTowers[1]) and not J.IsPushing(bot)
	then
        if J.IsGoingOnSomeone(bot)
        then
            if J.IsValidHero(botTarget)
            and bot:GetEstimatedDamageToTarget(true, botTarget, 5.0, DAMAGE_TYPE_ALL) >= botTarget:GetHealth() * 1.2
            then
                return RemapValClamped(botHP, 0.5, 0.75, BOT_MODE_DESIRE_MODERATE, BOT_MODE_DESIRE_NONE)
            end
        end

        if nEnemyTowers[1]:GetAttackTarget() == bot
        then
            RetreatWhenTowerTargetedTime = DotaTime()
            return BOT_MODE_DESIRE_VERYHIGH
        end
	end

	return false
end

function X.GetUnitTypeAttackingBot(nRadius, hName)
    local tAttackingUnits = {}

    for _, unit in pairs(GetUnitList(UNIT_LIST_ENEMIES))
    do
        if J.IsValid(unit)
        and unit:GetUnitName() == hName
        and GetUnitToUnitDistance(bot, unit) <= nRadius
        and (unit:GetAttackTarget() == bot or J.IsChasingTarget(unit, bot))
        then
            table.insert(tAttackingUnits, unit)
        end
    end

    return tAttackingUnits
end

function X.GetTotalEstimatedPower(tUnits)
	local power = 0

	for _, unit in pairs(tUnits)
	do
		if J.IsValid(unit)
		then
			if unit:GetTeam() == bot:GetTeam()
			then
				power = power + unit:GetOffensivePower()
			else
				power = power + unit:GetRawOffensivePower()
			end
		end
    end

    return power
end

function X.GetTotalEstimatedDamageToTarget(tUnits, nTarget, nTime)
    local dmg = 0

	for _, unit in pairs(tUnits)
	do
		if J.IsValid(unit)
		then
            local bCurrentlyAvailable = true
            if unit:GetTeam() ~= bot:GetTeam()
            then
                bCurrentlyAvailable = false
            end

            dmg = dmg + unit:GetEstimatedDamageToTarget(bCurrentlyAvailable, nTarget, nTime, DAMAGE_TYPE_ALL)
		end
	end

	return dmg
end

function X.GetRightClickDamage(tUnits, nTime)
    local dmg = 0

	for _, unit in pairs(tUnits)
	do
		if J.IsValid(unit) then
            dmg = dmg + unit:GetAttackDamage() * unit:GetAttackSpeed() * nTime
		end
	end

	return dmg
end

function X.IsBeingAttacked(unit)
    for _, enemy in pairs(GetUnitList(UNIT_LIST_ENEMIES))
    do
        if J.IsValid(unit)
        then
            local enemyName = enemy:GetUnitName()
            if J.IsValidHero(enemy) or string.find(enemyName, 'warlock_golem')
            then
                if enemy:GetAttackTarget() == bot then
                    return true
                end
            end
        end
    end

    return false
end

function X.IsOtherUnitsInRange(unit__, nRadius)
    for _, unit in pairs(GetUnitList(UNIT_LIST_ALL))
    do
        if J.IsValid(unit)
        and unit__ ~= unit
        and J.IsInRange(unit__, unit, nRadius)
        then
            return true
        end
    end

    return false
end

return X