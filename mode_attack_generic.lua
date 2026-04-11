local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local bot = GetBot()

local botTarget = {
    unit = nil,
    id = -1,
    location = nil,
    locationFuture = nil,
    hidden1 = false,
    hidden2 = false,
}

local botAttackRange, botHP, botMP, botHealth, botAttackDamage, botAttackSpeed, botActiveModeDesire, botTargetLocation, botName, botLocation

if J.IsNonStableHero(GetBot():GetUnitName()) then
-- if GetTeam() == TEAM_RADIANT then

local bClearMode = false
local fModeCooldown = { time = 0, interval = 0 }

function GetDesire()
    if not bot:IsAlive()
    or bot:IsIllusion()
    or bot:HasModifier('modifier_fountain_fury_swipes_damage_increase')
    then
        return BOT_MODE_DESIRE_NONE
    end

    if bClearMode then bClearMode = false return 0 end

    if J.IsInLaningPhase() then
        local nEnemyCreeps = bot:GetNearbyCreeps(600, true)
        if J.IsGoingOnSomeone(bot) and #nEnemyCreeps >= 4 and bot:WasRecentlyDamagedByCreep(3.0) then
            return BOT_MODE_DESIRE_NONE
        end
    end

    botTarget.hidden1 = false
    botTarget.hidden2 = false

    botAttackRange = bot:GetAttackRange()
    botHP = J.GetHP(bot)
    botMP = J.GetMP(bot)
    botHealth = bot:GetHealth()
    botName = bot:GetUnitName()
    botLocation = bot:GetLocation()
    local bCore = J.IsCore(bot)

    local nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    local nAllyHeroes_real = J.GetAlliesNearLoc(botLocation, 1600)
    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
    local nEnemyHeroes_real = J.GetEnemiesNearLoc(botLocation, 1600)
    local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(1600, true)
    local nEnemyTowers = bot:GetNearbyTowers(1600, true)

    -- TODO: team wide synergy
    -- get target
    local target = nil
    local targetScore = 0
    for _, enemy in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemy)
        and J.IsInRange(bot, enemy, Max(1200, botAttackRange + 650))
        and not J.IsSuspiciousIllusion(enemy)
        and not enemy:HasModifier('modifier_abaddon_borrowed_time')
        and not enemy:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemy:HasModifier('modifier_skeleton_king_reincarnation_scepter_active')
        and not enemy:HasModifier('modifier_troll_warlord_battle_trance')
        and not enemy:HasModifier('modifier_winter_wyvern_cold_embrace')
        then
            local sEnemyName = enemy:GetUnitName()
            local fMultiplier = 1

            if sEnemyName == 'npc_dota_hero_sniper' then
                fMultiplier = 4
            elseif sEnemyName == 'npc_dota_hero_drow_ranger' then
                fMultiplier = 2
            elseif sEnemyName == 'npc_dota_hero_crystal_maiden' and not J.IsModifierInRadius(bot, 'modifier_crystal_maiden_freezing_field_slow', 1600) then
                fMultiplier = 2
            elseif sEnemyName == 'npc_dota_hero_jakiro' and not J.IsModifierInRadius(bot, 'modifier_jakiro_macropyre_burn', 1600) then
                fMultiplier = 2.5
            elseif sEnemyName == 'npc_dota_hero_lina' then
                fMultiplier = 3
            elseif sEnemyName == 'npc_dota_hero_nevermore' then
                fMultiplier = 3
            elseif sEnemyName == 'npc_dota_hero_bristleback' and not enemy:IsFacingLocation(botLocation, 90) then
                fMultiplier = 0.5
            elseif sEnemyName == 'npc_dota_hero_enchantress' and enemy:GetLevel() >= 6 then
                fMultiplier = 0.5
            elseif enemy:HasModifier('modifier_troll_warlord_battle_trance') then
                fMultiplier = 0.5
            elseif enemy:HasModifier('modifier_item_blade_mail_reflect') then
                fMultiplier = 0.3
            elseif enemy:HasModifier('modifier_item_aeon_disk_buff') then
                fMultiplier = 0.5
            end

            if sEnemyName ~= 'npc_dota_hero_bristleback' then
                if J.IsCore(enemy) then
                    fMultiplier = fMultiplier * 1.5
                else
                    fMultiplier = fMultiplier * 0.5
                end
            end

            if J.IsDisabled(enemy) then
                fMultiplier = fMultiplier * 3
            end

            if J.IsEarlyGame() then
                if J.IsValidBuilding(nEnemyTowers[1]) and J.IsInRange(enemy, nEnemyTowers[1], 800) then
                    fMultiplier = fMultiplier * 0.5
                end
            end

            local nInRangeAlly = J.GetAlliesNearLoc(enemy:GetLocation(), 1200)

            local fTotalEtimatedAllyDamage = J.GetTotalEstimatedDamageToTarget(nInRangeAlly, enemy, 5.0)
            local fKillPct      = Max(fTotalEtimatedAllyDamage / Max(enemy:GetHealth(), 1), 1)
            local fHpFrac       = 1 - J.GetHP(enemy)
            local baseScore     = (0.35 + fHpFrac * 0.65) * Max(fKillPct, 0.15)
            local fRangeFrac    = Min(1, botAttackRange / GetUnitToUnitDistance(bot, enemy))
            local enemyScore    = baseScore * fRangeFrac * fMultiplier

            if not J.CanBeAttacked(enemy) then
                enemyScore = enemyScore * 0.2
            end

            if enemyScore > targetScore then
                target = enemy
                targetScore = enemyScore
            end
        end
    end

    botTarget.unit = target or X.GetWeakestNearbyHero(true, botAttackRange + 700)

    if J.IsValidHero(botTarget.unit) then
        botTarget.id = botTarget.unit:GetPlayerID()
        botTarget.location = botTarget.unit:GetLocation()
        botTarget.locationFuture = botTarget.unit:GetExtrapolatedLocation(5.0)
    end

    if (bot:HasModifier('modifier_marci_unleash') and J.GetModifierTime(bot, 'modifier_marci_unleash') > 3)
    or (bot:HasModifier('modifier_muerta_pierce_the_veil_buff') and J.GetModifierTime(bot, 'modifier_muerta_pierce_the_veil_buff') > 3)
    then
        if #nEnemyHeroes_real > 0
        and not (#nEnemyHeroes_real >= #nAllyHeroes_real + 2)
        and (  (botName == 'npc_dota_hero_muerta' and (botHP > 0.3 or bot:HasModifier('modifier_item_satanic_unholy') or bot:IsAttackImmune()))
            or (botName == 'npc_dota_hero_marci' and (botHP > 0.45 or bot:HasModifier('modifier_item_satanic_unholy') or bot:IsAttackImmune())))
        and J.IsValidHero(botTarget.unit)
        then
            bot:SetTarget(botTarget.unit)
            return BOT_MODE_DESIRE_ABSOLUTE
        end
    end

    local fAlly     = { damage = 0, health = 0}
    local fEnemy    = { damage = 0, health = 0 }
    local nUnitList_HeroesAllied = GetUnitList(UNIT_LIST_ALLIED_HEROES)
    local nUnitList_HeroesEnemy  = GetUnitList(UNIT_LIST_ENEMY_HEROES)

    if  J.IsValidHero(botTarget.unit)
    and not J.IsSuspiciousIllusion(botTarget.unit)
    and not botTarget.unit:HasModifier('modifier_necrolyte_reapers_scythe')
    then
        if DotaTime() < fModeCooldown.time + fModeCooldown.interval then
            return BOT_MODE_DESIRE_NONE
        end

        local fCoolOffTime = IsRecklesslyDivingTower()
        if fCoolOffTime ~= 0 then
            fModeCooldown.time = DotaTime()
            fModeCooldown.interval = fCoolOffTime
            return BOT_MODE_DESIRE_NONE
        end

        -- our damage
        local fDamageInterval = (bot:GetLevel() < 6 and 2.5) or 5
        for _, allyHero in ipairs(nUnitList_HeroesAllied) do
            if  J.IsValidHero(allyHero)
            and not J.IsSuspiciousIllusion(allyHero)
            and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not allyHero:HasModifier('modifier_teleporting')
            and (   J.IsInLaningPhase() and J.IsInRange(allyHero, botTarget.unit, 1600)
                or (not J.IsInLaningPhase() and (((GetUnitToUnitDistance(allyHero, botTarget.unit) - allyHero:GetAttackRange()) / allyHero:GetCurrentMovementSpeed()) <= 6.0)))
            then
                local fTimeToReach = Max(0, math.floor((GetUnitToUnitDistance(allyHero, botTarget.unit) - allyHero:GetAttackRange()) / allyHero:GetCurrentMovementSpeed()))
                fAlly.damage = fAlly.damage + allyHero:GetEstimatedDamageToTarget(true, botTarget.unit, fDamageInterval - fTimeToReach, DAMAGE_TYPE_ALL)
                fAlly.health = fAlly.health + allyHero:GetHealth()
            end
        end

        local nAllyTowers = botTarget.unit:GetNearbyTowers(350, true)
        if J.IsValidBuilding(nAllyTowers[1]) and (J.IsEarlyGame() or not J.CanBeAttacked(nAllyTowers[1])) then
            fAlly.damage = fAlly.damage + #nAllyTowers * botTarget.unit:GetActualIncomingDamage(nAllyTowers[1]:GetAttackDamage()*3, DAMAGE_TYPE_PHYSICAL)
        end

        -- enemy damage
        for _, enemyHero in ipairs(nUnitList_HeroesEnemy) do
            if  J.IsValidHero(enemyHero)
            and ((GetUnitToUnitDistance(enemyHero, botTarget.unit)) / enemyHero:GetCurrentMovementSpeed()) <= 6.0
            and not J.IsSuspiciousIllusion(enemyHero)
            then
                local fTimeToReach = math.floor((GetUnitToUnitDistance(enemyHero, botTarget.unit) - enemyHero:GetAttackRange()) / enemyHero:GetCurrentMovementSpeed())
                if  not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
                and not enemyHero:HasModifier('modifier_teleporting')
                then
                    if enemyHero:GetAttackTarget() == bot
                    or J.IsChasingTarget(enemyHero, bot)
                    or bot:WasRecentlyDamagedByHero(enemyHero, 2.0)
                    then
                        fEnemy.damage = fEnemy.damage + enemyHero:GetEstimatedDamageToTarget(false, bot, fDamageInterval, DAMAGE_TYPE_ALL)
                    end
                end
                fEnemy.health = fEnemy.health + enemyHero:GetHealth()
            end
        end

        nEnemyTowers = bot:GetNearbyTowers(1200, true)
        if J.IsValidBuilding(nEnemyTowers[1]) and (J.IsEarlyGame() or not J.CanBeAttacked(nEnemyTowers[1])) then
            fEnemy.damage = fEnemy.damage + #nEnemyTowers * bot:GetActualIncomingDamage(nEnemyTowers[1]:GetAttackDamage()*3, DAMAGE_TYPE_PHYSICAL)
        end

        -- evaluate
        if fEnemy.health > 0 and J.IsValidHero(botTarget.unit) then
            -- local allyDamageRatio  = fAlly.damage / Max(fEnemy.health, 1)
            local allyDamageRatio  = fAlly.damage / Max(botTarget.unit:GetHealth(), 1)
            local enemyDamageRatio = fEnemy.damage / botHealth
            local fFightingDesire           = RemapValClamped(allyDamageRatio, 1/3, 2/3, 0, 1.5)
            local fSelfPreservationDesire   = RemapValClamped(enemyDamageRatio, 0.5, 1.5, 1.5, 0.5)

            if J.IsInLaningPhase() then
                if #nAllyHeroes_real >= #nEnemyHeroes_real then
                    if bot:HasModifier('modifier_tower_aura_bonus') then
                        fFightingDesire = fFightingDesire + BOT_MODE_DESIRE_LOW
                    end
                end
            end

            if #nAllyHeroes_real >= #nEnemyHeroes_real then
                if  J.IsValidHero(nEnemyHeroes_real[1])
                and J.CanBeAttacked(nEnemyHeroes_real[1])
                and J.IsInRange(bot, nEnemyHeroes_real[1], botAttackRange + 150)
                and (not bot:WasRecentlyDamagedByAnyHero(3.0) and not bot:WasRecentlyDamagedByTower(2.0) or J.IsInTeamFight(bot, 1200))
                then
                    if not (J.IsInLaningPhase() and IsThereDyingCreepNearby()) then
                        botTarget.unit = nEnemyHeroes_real[1]
                        fFightingDesire = fFightingDesire + BOT_MODE_DESIRE_HIGH
                    end
                end
            end

            if bot:HasModifier('modifier_oracle_false_promise_timer') then
                if (#nAllyHeroes_real >= #nEnemyHeroes_real and allyDamageRatio >= 1/3) or allyDamageRatio >= 0.8 then
                    fFightingDesire = fFightingDesire + BOT_MODE_DESIRE_HIGH
                end
            end

            if bot:HasModifier('modifier_item_satanic_unholy') and J.IsInRange(bot, botTarget.unit, botAttackRange - 75) and botHP < 0.6 then
                if (#nAllyHeroes_real >= #nEnemyHeroes_real and allyDamageRatio >= 1/3) or allyDamageRatio >= 0.8 then
                    fFightingDesire = fFightingDesire + BOT_MODE_DESIRE_HIGH
                end
            end

            if bot:HasModifier('modifier_slark_shadow_dance') then
                if (#nAllyHeroes_real >= #nEnemyHeroes_real and allyDamageRatio >= 1/3) or allyDamageRatio >= 2/3 then
                    fFightingDesire = fFightingDesire + BOT_MODE_DESIRE_HIGH
                end
            end

            local nDesire = RemapValClamped(fFightingDesire * fSelfPreservationDesire, 0, 1, BOT_MODE_DESIRE_NONE, BOT_MODE_DESIRE_VERYHIGH + 0.05)
            if nDesire > BOT_MODE_DESIRE_VERYHIGH then
                bot:SetTarget(botTarget.unit)
                return nDesire
            end
        end
    end

    -- ally is engaging nearby?
	for _, allyHero in pairs(GetUnitList(UNIT_LIST_ALLIED_HEROES)) do
		if  J.IsValidHero(allyHero)
        and bot ~= allyHero
		and not allyHero:IsIllusion()
        and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
		and not allyHero:HasModifier('modifier_teleporting')
        and ( J.IsInLaningPhase() and J.IsInRange(bot, allyHero, 900)
                or (not J.IsInLaningPhase() and (((GetUnitToUnitDistance(bot, allyHero)) / bot:GetCurrentMovementSpeed()) <= 11.0)))
		then
            local allyHeroTarget = J.GetProperTarget(allyHero)
            if J.IsGoingOnSomeone(allyHero) then
                if J.IsValidHero(allyHeroTarget) and not J.IsSuspiciousIllusion(allyHeroTarget) then
                    botTarget.unit = allyHeroTarget
                    bot:SetTarget(botTarget.unit)
                    return BOT_MODE_DESIRE_VERYHIGH + 0.05
                end

                if J.IsInRange(bot, allyHero, 1000) and #nEnemyHeroes_real == 0 then
                    botTarget.location = allyHero:GetLocation()
                    botTarget.hidden1 = true
                    return BOT_MODE_DESIRE_VERYHIGH + 0.05
                end

                for i = 1, 5 do
                    local member = GetTeamMember(i)
                    if member and member == allyHero then
                        local ping = member:GetMostRecentPing()
                        if  ping ~= nil
                        and ping.normal_ping
                        and GameTime() < ping.time + 5.5
                        then
                            local nInRangeEnemy = J.GetEnemiesNearLoc(ping.location, 300)
                            if J.IsValidHero(nInRangeEnemy[1]) then
                                botTarget.location = ping.location
                                return BOT_MODE_DESIRE_VERYHIGH + 0.05
                            end
                        end
                    end
                end
            end
		end
	end

    -- still pursue if can't see, but was nearby
    if #nEnemyHeroes_real == 0 then
        if botTarget.locationFuture then
            for _, id in ipairs(GetTeamPlayers(GetOpposingTeam())) do
                if IsHeroAlive(id) and id == botTarget.id then
                    local info = GetHeroLastSeenInfo(id)
                    if info then
                        local dInfo = info[1]
                        if  dInfo
                        and dInfo.time_since_seen > 0.5
                        and dInfo.time_since_seen < 5.0
                        and J.GetDistance(dInfo.location, botTarget.locationFuture) <= 1200
                        and J.GetDistance(botLocation, botTarget.locationFuture) <= 1200
                        then
                            botTarget.hidden2 = true
                            return BOT_MODE_DESIRE_VERYHIGH + 0.05
                        end
                    end
                end
            end
        end
    end

    return BOT_MODE_DESIRE_NONE
end

function Think()
    if J.CanNotUseAction(bot) then return end

    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
    local nEnemyTowers = bot:GetNearbyTowers(1600, true)
    local bTeamFight = J.IsInTeamFight(bot, 1600)

    -- get away
    if bot:HasModifier('modifier_pugna_life_drain') then
        local nearbyPugna = nil
        for _, enemy in ipairs(nEnemyHeroes) do
            if J.IsValidHero(enemy)
            and J.IsInRange(bot, enemy, 750)
            and not J.IsSuspiciousIllusion(enemy)
            and enemy:GetUnitName() == 'npc_dota_hero_pugna' then
                nearbyPugna = enemy
                break
            end
        end

        if nearbyPugna == nil then
            for _, enemy in ipairs(nEnemyHeroes) do
                if J.IsValidHero(enemy)
                and J.IsInRange(bot, enemy, 750)
                and not J.IsSuspiciousIllusion(enemy)
                and enemy:GetUnitName() == 'npc_dota_hero_rubick' then
                    nearbyPugna = enemy
                    break
                end
            end
        end

        if nearbyPugna then
            bot:Action_MoveToLocation(J.VectorAway(botLocation, nearbyPugna:GetLocation(), 800))
            return
        end
    elseif bot:HasModifier('modifier_razor_static_link_debuff') then
        local nearbyRazor = nil
        for _, enemy in ipairs(nEnemyHeroes) do
            if J.IsValidHero(enemy)
            and J.IsInRange(bot, enemy, 750)
            and not J.IsSuspiciousIllusion(enemy)
            and enemy:GetUnitName() == 'npc_dota_hero_razor' then
                nearbyRazor = enemy
                break
            end
        end

        if nearbyRazor then
            bot:Action_MoveToLocation(J.VectorAway(botLocation, nearbyRazor:GetLocation(), 800))
            return
        end
    end

    if botTarget.unit == nil then botTarget.unit = X.GetWeakestNearbyHero(true, botAttackRange + 800) end

    if J.IsValidHero(botTarget.unit) then
        local dist = GetUnitToUnitDistance(bot, botTarget.unit)
        local bIsMuerta = botName == 'npc_dota_hero_muerta'
        local bEtherealForm = J.IsInEtherealForm(botTarget.unit)
        local bAttackImmune = botTarget.unit:IsAttackImmune() and (not bEtherealForm or not bIsMuerta)

        if bAttackImmune then
            bot:Action_MoveToLocation(J.VectorTowards(botTarget.unit:GetLocation(), botLocation, botAttackRange / 2))
            return
        end

        bot:Action_AttackUnit(botTarget.unit, false)
        return
    end

    if botTarget.hidden1 and botTarget.location then
        bot:Action_MoveToLocation(botTarget.location)
        return
    end

    if botTarget.hidden2 and botTarget.locationFuture then
        if GetUnitToLocationDistance(bot, botTarget.locationFuture) > botAttackRange then
            bot:Action_MoveToLocation(botTarget.locationFuture)
            return
        end
    end

    bClearMode = true
end

function OnEnd()
    botTarget.location = nil
    botTarget.locationFuture = nil
    botTarget.hidden1 = false
    botTarget.hidden2 = false
end

end

function IsRecklesslyDivingTower()
    if J.IsValidHero(botTarget.unit) then
        local nEnemyTowers = bot:GetNearbyTowers(800, true)
        if J.IsValidBuilding(nEnemyTowers[1]) then
            local nInRangeAlly = botTarget.unit:GetNearbyHeroes(900, true, BOT_MODE_NONE)

            local ourDamage = 0
            for _, allyHero in pairs(nInRangeAlly) do
                if J.IsValidHero(allyHero) and J.IsGoingOnSomeone(allyHero) and not J.IsSuspiciousIllusion(allyHero) then
                    local allyHeroTarget = J.GetProperTarget(allyHero)
                    if allyHeroTarget == botTarget.unit then
                        ourDamage = ourDamage + allyHero:GetAttackDamage() * allyHero:GetAttackSpeed() * (Max(1, 3 - (GetUnitToUnitDistance(allyHero, botTarget.unit) / allyHero:GetCurrentMovementSpeed())))
                    end
                end
            end

            if botTarget.unit:GetActualIncomingDamage(ourDamage, DAMAGE_TYPE_PHYSICAL) < (botTarget.unit:GetHealth() + botTarget.unit:GetHealthRegen() * 3) then
                return 2.5
            end
        end
    end

    return 0
end

function IsThereDyingCreepNearby()
    local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(Min(botAttackRange + 300, 1600), true)
    for _, creep in pairs(nEnemyLaneCreeps) do
        if J.IsValidHero(creep) and J.CanBeAttacked(creep) then
            if creep:GetHealth() < (botAttackDamage + botAttackDamage / 2) then
                return true
            end
        end
    end

    return false
end

function X.GetWeakestNearbyHero(bEnemy, nRadius)
	local weakestHero = nil
	local weakestHeroScore = 0
    local nNearbyHeroes = bot:GetNearbyHeroes(Min(nRadius, 1600), bEnemy, BOT_MODE_NONE)

	for _, hero in ipairs(nNearbyHeroes) do
		if  J.IsValidHero(hero)
        and not J.IsSuspiciousIllusion(hero)
		and not hero:HasModifier('modifier_abaddon_borrowed_time')
		and not hero:HasModifier('modifier_necrolyte_reapers_scythe')
		and not hero:HasModifier('modifier_skeleton_king_reincarnation_scepter_active')
        and not hero:HasModifier('modifier_item_helm_of_the_undying_active')
		then
			local heroScore = hero:GetActualIncomingDamage(bot:GetAttackDamage() * bot:GetAttackSpeed() * 3.0, DAMAGE_TYPE_PHYSICAL) / (hero:GetHealth() + hero:GetHealthRegen() * 3.0)
			if heroScore > weakestHeroScore then
				weakestHero = hero
				weakestHeroScore = heroScore
			end
		end
	end

	return weakestHero
end
