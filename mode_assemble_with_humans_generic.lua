if GetBot():IsInvulnerable() or not GetBot():IsHero() or not string.find(GetBot():GetUnitName(), "hero") or  GetBot():IsIllusion() then
	return
end

-- since I don't think this mode does anything
-- non-general retreat; for stuff that bots should retreat from if they'are not retreating
-- valve's default retreat mode works just fine (in the context of bots); not overriding that (bots have better pathing there); it's just not strong enough for certain things

local X = {}
local bot = GetBot()
local J = require( GetScriptDirectory()..'/FunLib/jmz_func')

local vTeamFountain = J.GetTeamFountain()

local botTarget, botLevel, botHP, botHealth, botLocation, botAttackRange

local tAllyHeroes, tAllyHeroes_real, tAllyHeroes_attacking
local tEnemyHeroes, tEnemyHeroes_real

local nChainFrostBounceDistance = 600 -- min

local ShouldRetreatWhenTowerTargeted = false
local RetreatWhenTowerTargetedTime = 0

local retreatFromTormentorTime = 0

bot.should_attack_move = false

function GetDesire()
    if not bot:IsAlive() or J.IsRetreating(bot) then
        return BOT_MODE_DESIRE_NONE
    end

    -- retreat from tormentor if can die
    if DotaTime() > (J.IsModeTurbo() and (10 * 60) or (20 * 60)) then
        local TormentorLocation = J.GetTormentorLocation(GetTeam())
        if DotaTime() < retreatFromTormentorTime + 20 then
            if not bot:HasModifier('modifier_fountain_aura_buff') or J.GetHP(bot) < 0.5 then
                return BOT_MODE_DESIRE_ABSOLUTE
            else
                retreatFromTormentorTime = 0
            end
        end

        if GetUnitToLocationDistance(bot, TormentorLocation) < 1200
        and J.GetHP(bot) < 0.25
        and bot.tormentor_state == true then
            retreatFromTormentorTime = DotaTime()
        end
    end

    if DotaTime() > 25 and DotaTime() < RetreatWhenTowerTargetedTime + 5 then
        return BOT_MODE_DESIRE_ABSOLUTE
    end

    -- when roshan dies, every desire sometimes drops to 0 somehow and it lingers in Roshan mode (which is also 0)
    if bot:GetActiveMode() == BOT_MODE_ROSHAN
    and not J.IsRoshanAlive()
    and GetUnitToLocationDistance(bot, J.GetCurrentRoshanLocation()) < 1200 then
        local bAegisNearby = false
        for _, droppedItem in pairs(GetDroppedItemList()) do
            if droppedItem ~= nil
            and droppedItem.item:GetName() == 'item_aegis'
            and GetUnitToLocationDistance(bot, droppedItem.location) < 1200
            then
                bAegisNearby = true
                break
            end
        end

        if not bAegisNearby then
            return BOT_MODE_DESIRE_MODERATE
        end
    end

    local nDesire = 0
    botTarget = J.GetProperTarget(bot)
    botLevel = bot:GetLevel()
    botHP = J.GetHP(bot)
    botHealth = bot:GetHealth()
    botLocation = bot:GetLocation()
    botAttackRange = bot:GetAttackRange()

    tAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    tAllyHeroes_attacking = bot:GetNearbyHeroes(1600, false, BOT_MODE_ATTACK)
    tEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    tAllyHeroes_real = J.GetAlliesNearLoc(botLocation, 1600)
    tEnemyHeroes_real = J.GetEnemiesNearLoc(botLocation, 1600)

    nDesire = X.GetUnitDesire()
    if nDesire > 0 then
        return nDesire
    end

    nDesire = X.GetModifierDesire()
    if nDesire > 0 then
        return nDesire
    end

    ShouldRetreatWhenTowerTargeted = X.RetreatWhenTowerTargeted()
	if ShouldRetreatWhenTowerTargeted then
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
		bot:Action_MoveToLocation(vTeamFountain + J.RandomForwardVector(350))
		return
	end

    if bot.should_attack_move then
        bot:Action_AttackMove(vTeamFountain + J.RandomForwardVector(600))
    else
        if DotaTime() < retreatFromTormentorTime + 20 then
            bot:Action_MoveToLocation(vTeamFountain)
        else
            bot:Action_MoveToLocation(vTeamFountain + J.RandomForwardVector(600))
        end
    end
end

function OnEnd()
    RetreatWhenTowerTargetedTime = 0
    bot.should_attack_move = false
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
                local illusionPower = X.GetTotalAttackDamage(tIllusions, 5.0)

                if illusionPower > botHealth
                then
                    if illusionPower > botHealth * 1.5
                    then
                        return 0.90
                    else
                        return 0.70
                    end
                end
            end

            if string.find(unitName, 'warlock_golem') and thisUnitIsAfterBot
            then
                local tWarlockGolems = X.GetUnitTypeAttackingBot(1600, unitName)
                local golemsPower = X.GetTotalAttackDamage(tWarlockGolems, 5.0)

                if golemsPower > botHealth
                then
                    return RemapValClamped(golemsPower / botHealth, 0.8, 1.5, 0.8, 0.95)
                end
            end

            if string.find(unitName, 'spiderlings') and thisUnitIsAfterBot
            and not J.IsInTeamFight(bot, 1600)
            then
                if not J.IsInTeamFight(bot, 1600)
                then
                    local tSpiderlings = X.GetUnitTypeAttackingBot(1600, unitName)
                    local spiderlingsPower = X.GetTotalAttackDamage(tSpiderlings, 5.0)

                    if spiderlingsPower > botHealth
                    then
                        return RemapValClamped(spiderlingsPower / botHealth, 0.8, 1.5, 0.55, 0.90)
                    end
                end
            end

            if string.find(unitName, 'eidolon') and thisUnitIsAfterBot
            and not J.IsInTeamFight(bot, 1600)
            then
                if not J.IsInTeamFight(bot, 1600)
                then
                    local tSpiderlings = X.GetUnitTypeAttackingBot(1600, unitName)
                    local eidolonPower = X.GetTotalAttackDamage(tSpiderlings, 5.0)

                    if eidolonPower > botHealth
                    then
                        return RemapValClamped(eidolonPower / botHealth, 0.8, 1.5, 0.55, 0.90)
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

    local canBeCloseToKillingTarget = false
    if X.IsUnitTargetRealHeroInRange(botAttackRange)
    and not bot:IsDisarmed()
    then
        canBeCloseToKillingTarget = J.CanKillTarget(botTarget, bot:GetAttackDamage() * 3, DAMAGE_TYPE_ALL)
    end

	if bot:HasModifier('modifier_jakiro_macropyre_burn')
	then
        if botHP < 0.6 and X.IsBeingAttackedByHero(bot) and not botIsMagicImmune
        and not canBeCloseToKillingTarget
        then
            return 0.95
        end
	end

    if bot:HasModifier('modifier_dark_seer_wall_slow')
    then
        if X.IsBeingAttackedByRealHero(bot) and botHP < 0.5 then
            bot.should_attack_move = true
            return 0.95
        end
    end

    if bot:HasModifier('modifier_lich_chainfrost_slow')
    then
        if not botIsMagicImmune and X.IsOtherUnitsInRange(bot, nChainFrostBounceDistance) and botHP < 0.5
        and not canBeCloseToKillingTarget
        then
            return 0.95
        end

        if J.IsInTeamFight(bot, 1200)
        then
            if (botHP < 0.42 or (not botIsMagicImmune and botHP < 0.65))
            and not canBeCloseToKillingTarget
            and not J.WeAreStronger(bot, 1200) then
                return 0.95
            end
        end
    end

    if bot:HasModifier('modifier_windrunner_gale_force')
    or bot:HasModifier('modifier_crystal_maiden_freezing_field_slow') then
        if ((not botIsMagicImmune or botHP < 0.5) and not X.IsUnitTargetRealHeroInRange(botAttackRange) and not canBeCloseToKillingTarget)
        or (not J.WeAreStronger(bot, 1600) and not X.IsUnitTargetRealHeroInRange(botAttackRange) and not canBeCloseToKillingTarget) then
            return 0.9
        end
    end

    if bot:HasModifier('modifier_shredder_chakram_debuff') then
        if #tEnemyHeroes_real > #tAllyHeroes_real
        or botHP < 0.2
        or (not X.IsUnitTargetRealHeroInRange(botAttackRange) and X.IsBeingAttackedByHero(bot)) then
            return 0.85
        end
    end

    if bot:HasModifier('modifier_warlock_upheaval')
    or bot:HasModifier('modifier_skywrath_mystic_flare_aura_effect')
    then
        if botHP < 0.5 and not botIsMagicImmune and not X.IsUnitTargetRealHeroInRange(botAttackRange) then
            return 0.85
        end
    end

    if bot:HasModifier('modifier_sandking_sand_storm_slow')
    then
        if (not X.IsUnitTargetRealHeroInRange(botAttackRange) or not canBeCloseToKillingTarget)
        and not (#tAllyHeroes_real >= #tEnemyHeroes_real + 2)
        then
            bot.should_attack_move = true
            return RemapValClamped(botHP, 0.25, 0.5, 0.95, 0.75)
        end
    end

    if bot:HasModifier('modifier_sand_king_epicenter_slow')
    or bot:HasModifier('modifier_disruptor_static_storm')
    then
        if not botIsMagicImmune
        and (not X.IsUnitTargetRealHeroInRange(botAttackRange) or not canBeCloseToKillingTarget)
        and not (#tAllyHeroes_real >= #tEnemyHeroes_real + 2)
        then
            return RemapValClamped(botHP, 0.25, 0.5, 0.95, 0.75)
        end
    end

	return BOT_MODE_DESIRE_NONE
end

function X.RetreatWhenTowerTargeted()
	if DotaTime() > 10 * 60
    or J.IsInTeamFight(bot, 1600)
    or #tAllyHeroes_attacking >= #tEnemyHeroes + 1
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

function X.GetTotalAttackDamage(tUnits, nTime)
    local dmg = 0

	for _, unit in pairs(tUnits)
	do
		if J.IsValid(unit) then
            dmg = dmg + unit:GetAttackDamage() * unit:GetAttackSpeed() * nTime

            if J.IsSuspiciousIllusion(unit) then
                local unitName = unit:GetUnitName()
                -- just consider the highest level damage
                if string.find(unitName, 'phantom_lancer') then
                    dmg = dmg * 0.19
                elseif string.find(unitName, 'naga_siren') then
                    dmg = dmg * 0.4
                elseif string.find(unitName, 'terrorblade') then
                    if X.IsEnemyTerrorbladeNear(unit, 1200) then
                        dmg = dmg * (0.6 + 0.25)
                    else
                        dmg = dmg * (0.6 - 0.50)
                    end
                elseif unit:HasModifier('modifier_darkseer_wallofreplica_illusion') then
                    dmg = dmg * 0.9
                else
                    dmg = dmg * 0.33
                end
            end
		end
	end

	return dmg
end

function X.IsBeingAttackedByHero(unit)
    for _, enemy in pairs(GetUnitList(UNIT_LIST_ENEMIES))
    do
        if J.IsValidHero(enemy)
        and (enemy:GetAttackTarget() == unit or J.IsChasingTarget(enemy, unit))
        then
            return true
        end
    end

    return false
end

function X.IsBeingAttackedByRealHero(unit)
    for _, enemy in pairs(GetUnitList(UNIT_LIST_ENEMIES))
    do
        if J.IsValidHero(enemy)
        and not J.IsSuspiciousIllusion(enemy)
        and (enemy:GetAttackTarget() == unit or J.IsChasingTarget(enemy, unit))
        then
            return true
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

function X.IsUnitTargetRealHeroInRange(nRadius)
    return J.IsValidHero(botTarget)
        and not J.IsSuspiciousIllusion(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
end

function X.IsEnemyTerrorbladeNear(unit, nRadius)
    for _, enemy in pairs(GetUnitList(UNIT_LIST_ENEMY_HEROES))
    do
        if J.IsValidHero(enemy)
        and not J.IsSuspiciousIllusion(enemy)
        and J.IsInRange(unit, enemy, nRadius) then
            return true
        end
    end

    return false
end

return X