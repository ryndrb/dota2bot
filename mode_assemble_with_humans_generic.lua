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

local botTarget, botLevel, botHP, botMP, botHealth, botLocation, botAttackRange, botName

local tAllyHeroes, tAllyHeroes_real, tAllyHeroes_attacking
local tEnemyHeroes, tEnemyHeroes_real

local RetreatWhenTowerTargetedTime = 0

local retreatFromTormentorTime = 0
local retreatFromRoshanTime = 0

function GetDesire()
    if not bot:IsAlive()
    or (J.IsRetreating(bot) and bot:GetActiveMode() ~= BOT_MODE_ASSEMBLE_WITH_HUMANS)
    or bot:HasModifier('modifier_skeleton_king_reincarnation_scepter_active')
    then
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

    if (DotaTime() > 25 and DotaTime() < RetreatWhenTowerTargetedTime + 5)
    or (bot:GetUnitName() == 'npc_dota_hero_lone_druid' and DotaTime() > 25 and DotaTime() < retreatFromRoshanTime + 6.5)
    then
        return BOT_MODE_DESIRE_ABSOLUTE
    end

    local vRoshanLocation = J.GetCurrentRoshanLocation()

    if bot:GetUnitName() == 'npc_dota_hero_lone_druid'
    and bot:GetActiveMode() == BOT_MODE_ITEM
    and GetUnitToLocationDistance(bot, vRoshanLocation) < 1200
    and IsLocationVisible(vRoshanLocation)
    then
        for _, droppedItem in pairs(GetDroppedItemList()) do
            if droppedItem ~= nil
            and droppedItem.item:GetName() == 'item_aegis'
            and GetUnitToLocationDistance(bot, droppedItem.location) < 1200
            then
                retreatFromRoshanTime = DotaTime()
                return 3.33
            end
        end
    end

    -- when roshan dies, every desire sometimes drops to 0 somehow and it lingers in Roshan mode (which is also 0)
    if bot:GetActiveMode() == BOT_MODE_ROSHAN
    and not J.IsRoshanAlive()
    and GetUnitToLocationDistance(bot, vRoshanLocation) < 1200
    and IsLocationVisible(vRoshanLocation)
    then
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
    botMP = J.GetMP(bot)
    botHealth = bot:GetHealth()
    botLocation = bot:GetLocation()
    botAttackRange = bot:GetAttackRange()
    botName = bot:GetUnitName()

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

    nDesire = X.RetreatWhenTowerTargetedDesire()
	if nDesire > 0 then
		return nDesire
	end

    return X.GetOtherRetreatDesire()
end

function Think()
    if J.CanNotUseAction(bot) then return end

    local bSeparate = false
    local vSteerLocation = Vector(0,0,0)
    for _, unit in pairs(GetUnitList(UNIT_LIST_ALL)) do
        if J.IsValid(unit)
        and bot ~= unit
        and not unit:IsBuilding()
        and not string.find(unit:GetUnitName(), 'ward')
        then
            if bot:HasModifier('modifier_lich_chainfrost_slow')
            or unit:HasModifier('modifier_lich_chainfrost_slow')
            or unit:GetUnitName() == 'npc_dota_lich_ice_spire'
            then
                bSeparate = true
                if GetUnitToUnitDistance(bot, unit) < 1000 then
                    vSteerLocation = vSteerLocation + (bot:GetLocation() - unit:GetLocation())
                end
            end
        end
    end

    if bSeparate then
        bot:Action_MoveToLocation(bot:GetLocation() + vSteerLocation)
        return
    end

    if DotaTime() < retreatFromTormentorTime + 20 then
        bot:Action_MoveToLocation(vTeamFountain)
    else
        bot:Action_MoveToLocation(vTeamFountain + J.RandomForwardVector(600))
    end
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
                        return 0.85
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
                    return RemapValClamped(golemsPower / botHealth, 0.8, 1.5, 0.7, 0.95)
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
                        return RemapValClamped(spiderlingsPower / botHealth, 0.8, 1.5, 0.45, 0.85)
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
                        return RemapValClamped(eidolonPower / botHealth, 0.8, 1.5, 0.45, 0.85)
                    end
                end
            end
        end
    end

    return BOT_MODE_DESIRE_NONE
end

function X.GetModifierDesire()
    local bMagicImmune = false

	if bot:IsMagicImmune()
	then
		bMagicImmune = true
	end

    local canBeCloseToKillingTarget = false
    if X.IsUnitTargetRealHeroInRange(botAttackRange)
    and not bot:IsDisarmed()
    then
        canBeCloseToKillingTarget = J.CanKillTarget(botTarget, bot:GetAttackDamage() * 3, DAMAGE_TYPE_ALL)
    end

	if bot:HasModifier('modifier_jakiro_macropyre_burn')
	then
        if botHP < 0.6 and X.IsBeingAttackedByHero(bot) and not bMagicImmune
        and not canBeCloseToKillingTarget
        then
            return 0.95
        end
    elseif bot:HasModifier('modifier_dark_seer_wall_slow')
    then
        if X.IsBeingAttackedByRealHero(bot) and botHP < 0.5 then
            return 0.95
        end
    elseif bot:HasModifier('modifier_lich_chainfrost_slow')
    then
        if not bMagicImmune and X.IsOtherUnitsInRange(bot, 600) and botHP < 0.5
        and not canBeCloseToKillingTarget
        then
            return 0.95
        end

        if J.IsInTeamFight(bot, 1200)
        then
            if (botHP < 0.42 or (not bMagicImmune and botHP < 0.65))
            and not canBeCloseToKillingTarget
            and not J.WeAreStronger(bot, 1200) then
                return 0.95
            end
        end
    elseif bot:HasModifier('modifier_windrunner_gale_force')
        or bot:HasModifier('modifier_crystal_maiden_freezing_field_slow')
    then
        if ((not bMagicImmune or botHP < 0.5) and not X.IsUnitTargetRealHeroInRange(botAttackRange) and not canBeCloseToKillingTarget)
        or (not J.WeAreStronger(bot, 1600) and not X.IsUnitTargetRealHeroInRange(botAttackRange) and not canBeCloseToKillingTarget) then
            return 0.9
        end
    elseif bot:HasModifier('modifier_shredder_chakram_debuff') then
        if #tEnemyHeroes_real > #tAllyHeroes_real
        or botHP < 0.2
        or (not X.IsUnitTargetRealHeroInRange(botAttackRange) and X.IsBeingAttackedByHero(bot)) then
            return 0.85
        end
    elseif bot:HasModifier('modifier_warlock_upheaval')
        or bot:HasModifier('modifier_skywrath_mystic_flare_aura_effect')
    then
        if botHP < 0.5 and not bMagicImmune and not X.IsUnitTargetRealHeroInRange(botAttackRange) then
            return 0.85
        end
    elseif bot:HasModifier('modifier_sandking_sand_storm_slow')
    then
        if (not X.IsUnitTargetRealHeroInRange(botAttackRange) or not canBeCloseToKillingTarget)
        and not (#tAllyHeroes_real >= #tEnemyHeroes_real + 2)
        then
            return RemapValClamped(botHP, 0.25, 0.5, 0.95, 0.75)
        end
    elseif bot:HasModifier('modifier_sand_king_epicenter_slow')
        or (bot:HasModifier('modifier_disruptor_static_storm') and not J.IsStuck(bot))
    then
        if not bMagicImmune
        and (not X.IsUnitTargetRealHeroInRange(botAttackRange) or not canBeCloseToKillingTarget)
        and not (#tAllyHeroes_real >= #tEnemyHeroes_real + 2)
        then
            return RemapValClamped(botHP, 0.25, 0.5, 0.95, 0.75)
        end
    end

	return BOT_MODE_DESIRE_NONE
end

function X.RetreatWhenTowerTargetedDesire()
	if DotaTime() > 10 * 60
    or J.IsInTeamFight(bot, 1600)
    or #tAllyHeroes_attacking >= #tEnemyHeroes + 1
	then
		return 0
	end

	local nEnemyTowers = bot:GetNearbyTowers(1600, true)

    -- reduce feeding causes
	if J.IsValidBuilding(nEnemyTowers[1]) and not J.IsPushing(bot)
	then
        if J.IsGoingOnSomeone(bot)
        then
            if J.IsValidHero(botTarget)
            and not J.IsSuspiciousIllusion(botTarget)
            and bot:GetEstimatedDamageToTarget(true, botTarget, 5.0, DAMAGE_TYPE_ALL) * 1.2 < botTarget:GetHealth()
            then
                return 0.7
            end
        end

        if nEnemyTowers[1]:GetAttackTarget() == bot
        then
            RetreatWhenTowerTargetedTime = DotaTime()
            return BOT_MODE_DESIRE_VERYHIGH
        end
	end

	return 0
end

function X.GetOtherRetreatDesire()
    local nDesire = RemapValClamped(botHP, 1, 0, 0, 0.8)

    if bot:DistanceFromFountain() <= 3800 then
        if (not string.find(botName, 'huskar') and botMP < 0.22 and botHP < 0.7)
        or J.GetHP(bot) < 0.33
        then
            return 0.95
        end
    end

    local nearbyEnemies = 0
    for i, id in pairs(GetTeamPlayers(GetOpposingTeam())) do
		if IsHeroAlive(id) then
			local info = GetHeroLastSeenInfo(id)
			if info ~= nil then
				local dInfo = info[1]
				if dInfo ~= nil
                and J.GetLocationToLocationDistance(botLocation, dInfo.location) <= 1600
                and dInfo.time_since_seen < 10.0
				then
                    if i <= 3 then
                        nearbyEnemies = nearbyEnemies + 1
                    else
                        nearbyEnemies = nearbyEnemies + 0.5
                    end
				end
			end
		end
	end

    if nearbyEnemies > #tAllyHeroes_real then
        nDesire = nDesire + (nearbyEnemies - #tAllyHeroes_real)
                          * RemapValClamped(DotaTime(), 0, 10 * 60, 0.2, 0.5)
                          * RemapValClamped(X.GetTotalEstimatedDamageToTarget(tEnemyHeroes_real, bot, 6.0), 0, botHealth, 0, 1)
    end

    if bot:WasRecentlyDamagedByTower(2) or bot:WasRecentlyDamagedByAnyHero(2) then
        nDesire = nDesire + 0.1
    end

    if J.IsInTeamFight(bot, 1600) and #tAllyHeroes_real >= #tEnemyHeroes_real then
        nDesire = nDesire * 0.9
    end

    local tEnemyTowers = bot:GetNearbyTowers(1600, true)
    if nearbyEnemies == 0 and #tEnemyTowers == 0 then
        nDesire = nDesire - 0.35
    end

    return Clamp(nDesire, 0, 0.8)
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
            local nAttackDamage = unit:GetAttackDamage()

            if J.IsSuspiciousIllusion(unit) then
                local unitName = unit:GetUnitName()
                -- just consider the highest level damage
                if string.find(unitName, 'phantom_lancer') then
                    nAttackDamage = nAttackDamage * 0.19
                elseif string.find(unitName, 'naga_siren') then
                    nAttackDamage = nAttackDamage * 0.4
                elseif string.find(unitName, 'terrorblade') then
                    if X.IsEnemyTerrorbladeNear(unit, 1200) then
                        nAttackDamage = nAttackDamage * (0.6 + 0.25)
                    else
                        nAttackDamage = nAttackDamage * (0.6 - 0.50)
                    end
                elseif unit:HasModifier('modifier_darkseer_wallofreplica_illusion') then
                    nAttackDamage = nAttackDamage * 0.9
                elseif unit:HasModifier('modifier_grimstroke_scepter_buff') then
                    nAttackDamage = nAttackDamage * 1.5
                else
                    nAttackDamage = nAttackDamage * 0.33
                end
            end

            dmg = dmg + nAttackDamage * unit:GetAttackSpeed() * nTime
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