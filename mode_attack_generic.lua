local J = require(GetScriptDirectory()..'/FunLib/jmz_func')

if J.IsNonStableHero(GetBot():GetUnitName()) then

local bot = GetBot()

local thisBotAttackTarget = nil
local thisBotMoveLocation = nil

local botAttackRange, botHP, botMP, botHealth, botAttackDamage, botAttackSpeed, botActiveModeDesire, botTarget

local dontEngageTime = 0
local lastAttackTime = 0
local attackCooldown = 2.0 -- seconds

function GetDesire()
    if DotaTime() < dontEngageTime + 2.5 then
        return 0
    end

    botAttackRange = bot:GetAttackRange() + bot:GetBoundingRadius()
    botTarget = J.GetProperTarget(bot)

    botHP = J.GetHP(bot)
    botMP = J.GetMP(bot)
    botHealth = bot:GetHealth()
    local botLevel = bot:GetLevel()

    botAttackDamage = bot:GetAttackDamage()
    botAttackSpeed = bot:GetAttackSpeed()

    botActiveModeDesire = bot:GetActiveModeDesire()

    local tAllyHeroes = bot:GetNearbyHeroes(1200, false, BOT_MODE_NONE)
    local tAllyHeroes_real = J.GetAlliesNearLoc(bot:GetLocation(), 1200)
    local tEnemyHeroes = bot:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
    local tEnemyHeroes_real = J.GetEnemiesNearLoc(bot:GetLocation(), 1200)
    local tEnemyLaneCreeps = bot:GetNearbyLaneCreeps(1200, true)

    if     botLevel >= 18 then attackCooldown = 10.0
    elseif botLevel >= 16 then attackCooldown = 8.0
    elseif botLevel >= 14 then attackCooldown = 7.5
    elseif botLevel >= 12 then attackCooldown = 7.0
    elseif botLevel >= 10 then attackCooldown = 6.0
    elseif botLevel >= 8  then attackCooldown = 5.0
    end

    if (J.IsRetreating(bot) and botActiveModeDesire > 0.9 and not J.IsInTeamFight(bot, 3200))
    or (J.IsLaning(bot) and #tEnemyLaneCreeps >= 2 and (bot:WasRecentlyDamagedByCreep(1.5) or bot:WasRecentlyDamagedByAnyHero(2.0) or bot:WasRecentlyDamagedByTower(2.0)))
    then
        dontEngageTime = DotaTime()
    end

    if DotaTime() < lastAttackTime + attackCooldown and #tEnemyHeroes_real > 0 then
        local hTarget = GetTarget(tEnemyHeroes_real)
        bot:SetTarget(hTarget)
        return 1.0
    end

    if J.IsInTeamFight(bot, 2200)
    or IsAllyGoingOnSomeone()
    or (J.IsGoingOnSomeone(bot)
        and (not J.IsInLaningPhase()
        or (J.IsInLaningPhase() and #tEnemyLaneCreeps <= 1 and J.IsValidHero(botTarget) and GetAllDamageAttacking(botTarget, 800, 5.0) > botTarget:GetHealth() * 1.2)))
    then
        lastAttackTime = DotaTime()
    end

    if IsEnemyStrongerInTime(tEnemyHeroes_real, tAllyHeroes, 8.0) and not J.IsInTeamFight(bot, 3000)
    or (J.IsInLaningPhase() and botHP < 0.4 and not J.IsInTeamFight(bot, 800) and bot:WasRecentlyDamagedByAnyHero(2.0))
    or (#tEnemyHeroes_real > #tAllyHeroes_real + 1 and not J.IsInTeamFight(bot, 3000))
    then
        return 0
    end

    local fTotalDamageToUs = GetAllDamageAttacking(bot, 1600, 5.0)
    if fTotalDamageToUs > botHealth * 1.5 and not J.IsInTeamFight(bot, 3200)
    or botHP < RemapValClamped(bot:GetLevel(), 1, 8, 0.4, 0.2) and #tEnemyHeroes_real > #tAllyHeroes_real then
        return 0
    end

    if J.IsValidHero(botTarget) and not J.IsSuspiciousIllusion(botTarget)
    and (J.IsChasingTarget(bot, botTarget) or (J.IsAttacking(bot) and bot:GetAttackTarget() == botTarget)) then
        local botTargetHealth = botTarget:GetHealth()

        if J.IsInLaningPhase() then
            local tEnemyTowers = bot:GetNearbyTowers(1600, true)
            if (J.IsValidBuilding(tEnemyTowers[1]) or botTarget:HasModifier('modifier_tower_aura') or botTarget:HasModifier('modifier_tower_aura_bonus'))
            and GetAllDamageAttacking(botTarget, 800, 2.0) < botTargetHealth
            then
                return 0
            end
        end

        if GetAllDamageAttacking(botTarget, 800, 5.0) * 2 < botTargetHealth then
            return 0
        end
    end

    local nTeamFightLocation = J.GetTeamFightLocation(bot)
    if nTeamFightLocation ~= nil and GetUnitToLocationDistance(bot, nTeamFightLocation) < 4000 then
        if (not J.IsCore(bot) or (J.IsCore(bot) and not J.IsInLaningPhase())) then
            local nInRangeAlly = J.GetAlliesNearLoc(nTeamFightLocation, 1200)
            local nInRangeEnemy = J.GetEnemiesNearLoc(nTeamFightLocation, 1200)
            local hTarget = GetTarget(nInRangeEnemy)
            if hTarget ~= nil then
                bot:SetTarget(hTarget)
                if #nInRangeAlly >= #nInRangeEnemy then
                    return 1.0
                else
                    return 0.95
                end
            else
                for i = 1, 5 do
                    local member = GetTeamMember(i)
                    if J.IsValidHero(member) and GetUnitToLocationDistance(member, nTeamFightLocation) < 4000 then
                        local target = member:GetAttackTarget()
                        if J.IsValidHero(target) then
                            bot:SetTarget(target)
                            return 0.95
                        end
                    end
                end
            end
        end
    end

    if (not J.IsCore(bot) or (J.IsCore(bot) and not J.IsInLaningPhase())) and not J.IsFarming(bot) then
        for i = 1, 5 do
            local member = GetTeamMember(i)
            if J.IsValidHero(member) and member ~= bot
            and J.IsGoingOnSomeone(member)
            and J.IsInRange(bot, member, 3200)
            then
                local target = member:GetAttackTarget()
                if J.IsValidHero(target) then
                    bot:SetTarget(target)
                    return 0.95
                end
            end
        end
    end

    if (bot:HasModifier('modifier_marci_unleash') and J.GetModifierTime(bot, 'modifier_marci_unleash') >= 7.5)
    or (bot:HasModifier('modifier_muerta_pierce_the_veil_buff') and J.GetModifierTime(bot, 'modifier_muerta_pierce_the_veil_buff') >= 3.5)
    then
        if J.IsValidHero(botTarget) and J.CanBeAttacked(botTarget) and not J.IsSuspiciousIllusion(botTarget) then
            bot:SetTarget(botTarget)
            return 0.95
        end
    end

    if not J.IsRetreating(bot) and J.IsGoingOnSomeone(bot) then
        if J.IsValidHero(botTarget) and J.CanBeAttacked(botTarget) and not J.IsSuspiciousIllusion(botTarget) then
            bot:SetTarget(botTarget)
            if J.IsInLaningPhase() and GetUnitToLocationDistance(bot, GetLaneFrontLocation(GetTeam(), bot:GetAssignedLane(), 0)) < 2000 then
                local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(600, true)
                if #nEnemyLaneCreeps <= 1 then
                    return 0.5
                end
            else
                return 0.95
            end
        end
    end

    -- for _, enemy in pairs(tEnemyHeroes) do
    --     if J.IsValidHero(enemy) and J.CanBeAttacked(enemy) and not J.IsSuspiciousIllusion(enemy)
    --     and J.IsInRange(bot, enemy, botAttackRange)
    --     and bot:WasRecentlyDamagedByHero(enemy, 2.0)
    --     and not J.IsInTeamFight(bot, 1600)
    --     then
    --         bot:SetTarget(enemy)
    --         if J.IsInLaningPhase() then
    --             if bot:WasRecentlyDamagedByTower(2.0) and botHP < 0.6 then
    --                 return 0.5
    --             end
    --         else
    --             return 0.75
    --         end
    --     end
    -- end

    local hTarget = GetTarget(tEnemyHeroes_real)
    if J.IsValidHero(hTarget) then
        if #tAllyHeroes_real > 1 then
            local fAllyDamage = 0
            for _, ally in pairs(tAllyHeroes) do
                if J.IsValid(ally) and not ally:IsIllusion() then
                    fAllyDamage = fAllyDamage + ally:GetEstimatedDamageToTarget(true, hTarget, 5.0, DAMAGE_TYPE_ALL)
                end
            end

            if fAllyDamage > hTarget:GetHealth() * 2 and botHP > 0.3 then
                bot:SetTarget(hTarget)
                return 0.95
            end
        end

        local nInRangeEnemy = hTarget:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
        local fTotalEnemyDamage = GetTotalEstimatedDamageToTarget(nInRangeEnemy, bot, 5.0, DAMAGE_TYPE_ALL)

        bot:SetTarget(hTarget)
        if fTotalEnemyDamage * 2 < botHealth then
            if J.IsInLaningPhase() and GetBestLastHitCreep(tEnemyLaneCreeps) ~= nil then
                local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(600, true)
                if #nEnemyLaneCreeps <= 1 then
                    return 0.5
                end
            else
                return 0.95
            end
        end
    end

    return 0
end

-- local last_seen_location = nil
-- function Think()
-- end

-- copy target acquire
local target = nil
local targetTime = 0
function GetTarget(tUnits)
    if J.IsValidHero(botTarget) then
        return botTarget
    end

    if J.IsValidHero(target)
	and not J.IsSuspiciousIllusion(target)
	and not target:HasModifier('modifier_abaddon_borrowed_time')
	and not target:HasModifier('modifier_necrolyte_reapers_scythe')
	and not target:HasModifier('modifier_necrolyte_sadist_active')
	and not target:HasModifier('modifier_skeleton_king_reincarnation_scepter_active')
	and not target:HasModifier('modifier_item_blade_mail_reflect')
	and not target:HasModifier('modifier_item_aeon_disk_buff')
	and DotaTime() < targetTime + 3.5
	then
		bot:SetTarget(target)
        return target
	end

    local __target = nil
    local targetScore = 0
    for _, enemy in pairs(tUnits) do
        if J.IsValidHero(enemy)
        and not J.IsSuspiciousIllusion(enemy)
		and not enemy:HasModifier('modifier_abaddon_borrowed_time')
		and not enemy:HasModifier('modifier_necrolyte_reapers_scythe')
		and not enemy:HasModifier('modifier_skeleton_king_reincarnation_scepter_active')
		and not enemy:HasModifier('modifier_item_blade_mail_reflect')
		and not enemy:HasModifier('modifier_item_aeon_disk_buff')
        and J.CanBeAttacked(enemy) then
            local enemyName = enemy:GetUnitName()
			local mul = 1

            if enemyName == 'npc_dota_hero_sniper' then
				mul = 4
			elseif enemyName == 'npc_dota_hero_drow_ranger' then
				mul = 2
			elseif enemyName == 'npc_dota_hero_crystal_maiden' and not IsModifierInRadius('modifier_crystal_maiden_freezing_field_slow', 1600) then
				mul = 2
			elseif enemyName == 'npc_dota_hero_jakiro' and not IsModifierInRadius('modifier_jakiro_macropyre_burn', 1600) then
				mul = 2.5
			elseif enemyName == 'npc_dota_hero_lina' then
				mul = 3
			elseif enemyName == 'npc_dota_hero_nevermore' then
				mul = 3
			elseif enemyName == 'npc_dota_hero_bristleback' and not enemy:IsFacingLocation(bot:GetLocation(), 90) then
				mul = 0.5
			elseif enemyName == 'npc_dota_hero_enchantress' then
				mul = 0.5
            end

			if enemyName ~= 'npc_dota_hero_bristleback' then
				if J.IsCore(enemy) then
					mul = mul * 1.5
				else
					mul = mul * 0.5
				end
			end

            local enemyScore = (Min(1, bot:GetAttackRange() / GetUnitToUnitDistance(bot, enemy)))
								* ((1-J.GetHP(enemy)) * bot:GetEstimatedDamageToTarget(true, enemy, 5.0, DAMAGE_TYPE_ALL))
								* mul
            if enemyScore > targetScore then
                targetScore = enemyScore
                __target = enemy
				-- print(botName, enemyName, enemyScore)
            end
        end
    end

	if __target ~= nil then
		bot:SetTarget(__target)
		target = __target
		return __target
	end

    for i = 1, 5 do
        local member = GetTeamMember(i)
        if J.IsValidHero(member) and J.IsInRange(bot, member, 1200) then
            target = member:GetAttackTarget()
            if J.IsValidHero(target) then
                bot:SetTarget(target)
                return target
            end
        end
    end
end

function IsModifierInRadius(sModifierName, nRadius)
	for _, unit in pairs(GetUnitList(UNIT_LIST_ALL)) do
		if J.IsValid(unit)
		and J.IsInRange(bot, unit, nRadius)
		and unit:HasModifier(sModifierName) then
			return true
		end
	end

	return false
end

function GetTotalEstimatedDamageToTarget(nUnits, __hTarget, fDuration, nDamageType)
	local dmg = 0
	for _, unit in pairs(nUnits) do
        if J.IsValid(unit) then
            local bCurrentlyAvailable = true
            if unit:GetTeam() ~= GetBot():GetTeam() then
                bCurrentlyAvailable = false
            end

            dmg = dmg + unit:GetEstimatedDamageToTarget(bCurrentlyAvailable, __hTarget, fDuration, nDamageType)
        end
	end

	return dmg
end

function GetBestLastHitCreep(hCreepList)
	local attackDamage = bot:GetAttackDamage()

	if bot:GetItemSlotType(bot:FindItemSlot("item_quelling_blade")) == ITEM_SLOT_TYPE_MAIN then
		if bot:GetAttackRange() > 310 or bot:GetUnitName() == "npc_dota_hero_templar_assassin" then
			attackDamage = attackDamage + 4
		else
			attackDamage = attackDamage + 8
		end
	end

	for _, creep in pairs(hCreepList) do
		if J.IsValid(creep) and J.CanBeAttacked(creep) then
			local nDelay = J.GetAttackProDelayTime(bot, creep)
			if J.WillKillTarget(creep, attackDamage, DAMAGE_TYPE_PHYSICAL, nDelay) then
				return creep
			end
		end
	end

	return nil
end

function GetAllDamageAttacking(hUnit, nRadius, fDuration)
    local fDamage = 0
    for _, unit in pairs(GetUnitList(UNIT_LIST_ALL)) do
        if J.IsValid(unit) and J.IsInRange(hUnit, unit, nRadius) and (unit:GetAttackTarget() == hUnit or J.IsChasingTarget(unit, hUnit))
        then
            if unit:IsHero() and not J.IsSuspiciousIllusion(unit) then
                fDamage = fDamage + unit:GetEstimatedDamageToTarget(false, hUnit, fDuration, DAMAGE_TYPE_ALL)
            else
                fDamage = fDamage + unit:GetAttackDamage() * unit:GetAttackSpeed() * fDuration
            end
        end
    end

    return fDamage
end

function IsEnemyStrongerInTime(tEnemyHeroes, tAllyHeroes, fDuration)
    local fDamage = 0
    local nTotalAllyHealth = 0
    for _, enemy in pairs(tEnemyHeroes) do
        if J.IsValidHero(enemy)
        and not enemy:HasModifier('modifier_necrolyte_reapers_scythe')
        then
            for _, ally in pairs(tAllyHeroes) do
                if J.IsValidHero(ally)
                and not ally:IsIllusion()
                and not ally:HasModifier('modifier_necrolyte_reapers_scythe')
                then
                    nTotalAllyHealth = nTotalAllyHealth + ally:GetHealth()
                    if not J.IsSuspiciousIllusion(enemy) then
                        fDamage = fDamage + enemy:GetEstimatedDamageToTarget(false, ally, fDuration, DAMAGE_TYPE_ALL)
                    else
                        fDamage = fDamage + enemy:GetAttackDamage() * enemy:GetAttackSpeed() * fDuration
                    end
                end
            end
        end
    end

    return fDamage > nTotalAllyHealth * 2 and nTotalAllyHealth > 500
end

function IsAllyGoingOnSomeone()
    for i = 1, 5 do
        local member = GetTeamMember(i)
        if J.IsValidHero(member) and member ~= bot
        and J.IsGoingOnSomeone(member)
        and J.IsInRange(bot, member, 2200)
        then
            if J.IsValidHero(member:GetAttackTarget()) then
                bot:SetTarget(member:GetAttackTarget())
                return true
            end
        end
    end
    return false
end

end