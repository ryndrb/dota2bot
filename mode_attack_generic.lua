local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local bot = GetBot()

local botTarget = {unit = nil, location = 0, id = -1, fogChase = false}
local helpAlly = {should = false, location = 0}

local botAttackRange, botHP, botMP, botHealth, botAttackDamage, botAttackSpeed, botActiveModeDesire, botTargetLocation, botName, botLocation

local fLastAttackDesire = 0

if J.IsNonStableHero(GetBot():GetUnitName()) then

local bClearMode = false

local function IsValid(hUnit)
    return hUnit ~= nil and not hUnit:IsNull() and hUnit:IsAlive()
end

function GetDesire()
    if not bot:IsAlive()
    or bot:IsIllusion()
    or bot:HasModifier('modifier_fountain_fury_swipes_damage_increase')
    then
        return BOT_MODE_DESIRE_NONE
    end

    if bClearMode then bClearMode = false return 0 end

    botAttackRange = bot:GetAttackRange() + bot:GetBoundingRadius()
    botHP = J.GetHP(bot)
    botMP = J.GetMP(bot)
    botHealth = bot:GetHealth()
    botName = bot:GetUnitName()
    botLocation = bot:GetLocation()
	local bWeAreStronger = J.WeAreStronger(bot, 1600)
    local bCore = J.IsCore(bot)

    local tAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    local tAllyHeroes_real = J.GetAlliesNearLoc(botLocation, 1600)
    local tEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
    local tEnemyHeroes_real = J.GetEnemiesNearLoc(botLocation, 1600)
    local tEnemyLaneCreeps = bot:GetNearbyLaneCreeps(1600, true)
    local tEnemyTowers = bot:GetNearbyTowers(1600, true)

    if J.IsInLaningPhase() then
        local creepCountAttacking = 0
        local creepCountAttackingDamage = 0
        for _, creep in pairs(tEnemyLaneCreeps) do
            if J.IsValid(creep) and J.IsInRange(bot, creep, 600) and creep:GetAttackTarget() == bot then
                creepCountAttacking = creepCountAttacking + 1
                creepCountAttackingDamage = creepCountAttackingDamage + (bot:GetActualIncomingDamage(creep:GetAttackDamage() * creep:GetAttackSpeed() * 5.0, DAMAGE_TYPE_PHYSICAL) - bot:GetHealthRegen() * 5.0)
            end
        end

        if creepCountAttacking >= 4 and (creepCountAttackingDamage / botHealth) >= 0.25 then return X.GetActualDesire(BOT_MODE_DESIRE_NONE) end
    end

    if (bot:HasModifier('modifier_marci_unleash') and J.GetModifierTime(bot, 'modifier_marci_unleash') > 3)
    or (bot:HasModifier('modifier_muerta_pierce_the_veil_buff') and J.GetModifierTime(bot, 'modifier_muerta_pierce_the_veil_buff') > 3)
    then
        if #tEnemyHeroes_real > 0
        and not (#tEnemyHeroes_real >= #tAllyHeroes_real + 2)
        and (  (botName == 'npc_dota_hero_muerta' and (botHP > 0.3 or bot:HasModifier('modifier_item_satanic_unholy') or bot:IsAttackImmune()))
            or (botName == 'npc_dota_hero_marci' and (botHP > 0.45 or bot:HasModifier('modifier_item_satanic_unholy') or bot:IsAttackImmune())))
        then
            return X.GetActualDesire(BOT_MODE_DESIRE_ABSOLUTE)
        end
    end

	local fAllyDamage = 0
    local unitList_allies = GetUnitList(UNIT_LIST_ALLIED_HEROES)
    local unitList_enemies = GetUnitList(UNIT_LIST_ENEMY_HEROES)

    for _, enemyHero in ipairs(unitList_enemies) do
        if J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and not J.IsSuspiciousIllusion(enemyHero)
		and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and (   J.IsInLaningPhase() and J.IsInRange(bot, enemyHero, 1600)
            or (not J.IsInLaningPhase() and (((GetUnitToUnitDistance(bot, enemyHero) - botAttackRange) / bot:GetCurrentMovementSpeed()) <= 6.0)))
        then
            fAllyDamage = 0

            local nInRangeAlly = J.GetAlliesNearLoc(enemyHero:GetLocation(), 1200)
            local nInRangeEnemy = J.GetEnemiesNearLoc(enemyHero:GetLocation(), 1200)
            local vTeamFightLocation = J.GetTeamFightLocation(bot)

            for _, allyHero in ipairs(unitList_allies) do
                if J.IsValidHero(allyHero)
				and not J.IsSuspiciousIllusion(allyHero)
				and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
				and not allyHero:HasModifier('modifier_skeleton_king_reincarnation_scepter_active')
				and not allyHero:HasModifier('modifier_teleporting')
                and (((GetUnitToUnitDistance(allyHero, enemyHero) - botAttackRange) / allyHero:GetCurrentMovementSpeed()) <= 6.0)
                and (bot:GetPlayerID() == allyHero:GetPlayerID()
                    or J.IsNonStableHero(allyHero)
                    or allyHero:GetAttackTarget() == enemyHero
                    or J.IsInRange(allyHero, enemyHero, botAttackRange + 200))
                then
                    fAllyDamage = fAllyDamage + allyHero:GetEstimatedDamageToTarget(true, enemyHero, 3.0, DAMAGE_TYPE_ALL) - enemyHero:GetHealthRegen() * 3.0
                    local nAllyTowers = allyHero:GetNearbyTowers(800, false)
                    if J.IsValidBuilding(nAllyTowers[1]) then
                        fAllyDamage = fAllyDamage + #nAllyTowers * nAllyTowers[1]:GetAttackDamage()
                    end
                end
            end

            if J.IsInLaningPhase() and not bot:WasRecentlyDamagedByAnyHero(3.0) and not bot:WasRecentlyDamagedByCreep(2.0) and #nInRangeAlly >= #nInRangeEnemy then
                if not J.IsRetreating(bot) and GetUnitToUnitDistance(bot, enemyHero) < botAttackRange then
                    return X.GetActualDesire(BOT_MODE_DESIRE_VERYHIGH)
                end
            end

            -- enemy damage
            local fEnemyDamage = 0
            for _, possibleEnemyHero in ipairs(unitList_enemies) do
                if J.IsValidHero(possibleEnemyHero)
                and J.GetHP(possibleEnemyHero) >= 0.25
                and not J.IsSuspiciousIllusion(possibleEnemyHero)
                and not possibleEnemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
                and not possibleEnemyHero:HasModifier('modifier_teleporting')
                and ((GetUnitToUnitDistance(bot, possibleEnemyHero)) / possibleEnemyHero:GetCurrentMovementSpeed()) <= 6.0
                then
                    fEnemyDamage = fEnemyDamage + possibleEnemyHero:GetEstimatedDamageToTarget(false, bot, 3.0, DAMAGE_TYPE_ALL)
                end
            end

            local nEnemyTowers = bot:GetNearbyTowers(1200, true)
            if J.IsValidBuilding(nEnemyTowers[1]) then
                fEnemyDamage = fEnemyDamage + #nEnemyTowers * nEnemyTowers[1]:GetAttackDamage()
            end

            local b1 = (bWeAreStronger and fAllyDamage >= enemyHero:GetHealth() * 0.2 and bot:GetHealth() > fEnemyDamage * 1.15)
            local b2 = (#nInRangeAlly >= #nInRangeEnemy and fAllyDamage >= enemyHero:GetHealth() * 0.3 and bot:GetHealth() > fEnemyDamage * 1.15)
            local b3 = (vTeamFightLocation ~= nil and (((GetUnitToLocationDistance(bot, vTeamFightLocation) - botAttackRange) / bot:GetCurrentMovementSpeed()) <= 10.0))

            if b1 or b2 or b3 then
                local dist = GetUnitToUnitDistance(bot, enemyHero)
                if dist <= 2000 or ((dist / bot:GetCurrentMovementSpeed()) <= 10.0) then
                    if J.IsInLaningPhase() and bot:GetActiveMode() == BOT_MODE_ATTACK then
                        if (bot:WasRecentlyDamagedByTower(2.0) or (J.IsValidBuilding(tEnemyTowers[1]) and tEnemyTowers[1]:GetAttackTarget() == bot)) then
                            return X.GetActualDesire(BOT_MODE_DESIRE_VERYLOW)
                        end
                    end

                    if b1 then return X.GetActualDesire(BOT_MODE_DESIRE_VERYHIGH) end
                    if b2 then return X.GetActualDesire(BOT_MODE_DESIRE_VERYHIGH) end
                    if b3 then return X.GetActualDesire(BOT_MODE_DESIRE_ABSOLUTE) end
                else
                    return X.GetActualDesire(BOT_MODE_DESIRE_MODERATE)
                end
            end
        end
    end

    if not bCore or not J.IsInLaningPhase() then
        for _, allyHero in ipairs(unitList_allies) do
            if bot ~= allyHero
            and J.IsValidHero(allyHero)
            and J.IsInRange(bot, allyHero, 4000)
            and not J.IsSuspiciousIllusion(allyHero)
            and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not allyHero:HasModifier('modifier_skeleton_king_reincarnation_scepter_active')
            and not allyHero:HasModifier('modifier_item_helm_of_the_undying_active')
            and not allyHero:HasModifier('modifier_teleporting')
            then
                local enemyHero = allyHero:GetAttackTarget()
                local bWeAreStronger__Ally = J.WeAreStronger(allyHero, 1200)

                if J.IsValidHero(enemyHero)
                and J.IsInRange(allyHero, enemyHero, 1600)
                and not J.IsSuspiciousIllusion(enemyHero)
                and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
                then
                    fAllyDamage = fAllyDamage + allyHero:GetEstimatedDamageToTarget(true, enemyHero, 3.0, DAMAGE_TYPE_ALL) - enemyHero:GetHealthRegen() * 3.0
                    local nAllyTowers = allyHero:GetNearbyTowers(800, false)
                    if J.IsValidBuilding(nAllyTowers[1]) then
                        fAllyDamage = fAllyDamage + #nAllyTowers * nAllyTowers[1]:GetAttackDamage()
                    end

                    local nInRangeAlly = J.GetAlliesNearLoc(enemyHero:GetLocation(), 1600)
                    local nInRangeEnemy = J.GetEnemiesNearLoc(enemyHero:GetLocation(), 1600)

                    if #nInRangeAlly >= #nInRangeEnemy or bWeAreStronger__Ally then
                        helpAlly = {should = true, location = allyHero:GetLocation()}
                        return X.GetActualDesire(BOT_MODE_DESIRE_VERYHIGH)
                    else
                        helpAlly.should = false
                    end
                end
            end
        end
    end

    -- not sure if this is working, but it's here
    if IsValid(botTarget.unit) and not botTarget.unit:CanBeSeen()  then
        for _, id in ipairs(GetTeamPlayers(GetOpposingTeam())) do
            if IsHeroAlive(id) and id == botTarget.id then
                local info = GetHeroLastSeenInfo(id)
                if info then
                    local dInfo = info[1]
                    if dInfo
                    and dInfo.time_since_seen > 0.5
                    and dInfo.time_since_seen < 3.0
                    and J.GetDistance(dInfo.location, botTarget.location) <= 1200 then
                        if #tAllyHeroes_real >= #tEnemyHeroes_real or bWeAreStronger then
                            botTarget.fogChase = true
                            botTarget.location = dInfo.location
                            return X.GetActualDesire(BOT_MODE_DESIRE_VERYHIGH)
                        end
                    end
                end
            end
        end
    end

    botTarget.fogChase = false

    return X.GetActualDesire(BOT_MODE_DESIRE_NONE)
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
    else
        for _, enemy in pairs(nEnemyHeroes) do
            if J.IsValidHero(enemy)
            and enemy:GetAttackTarget() == bot
            and (  enemy:HasModifier('modifier_item_helm_of_the_undying_active')
                or enemy:HasModifier('modifier_skeleton_king_reincarnation_scepter_active')
                )
            then
                if J.IsInRange(bot, enemy, enemy:GetAttackRange() + 150) then
                    bot:Action_MoveToLocation(J.VectorAway(botLocation, enemy:GetLocation(), enemy:GetAttackRange() * 2))
                    return
                end
            end
        end

        if J.IsValidBuilding(nEnemyTowers[1]) and nEnemyTowers[1]:GetAttackTarget() == bot and not bTeamFight then
            local unitList = GetUnitList(UNIT_LIST_ENEMIES)
            local unitDamage = 0
            for _, unit in pairs(unitList) do
                if J.IsValid(unit) and unit:GetAttackTarget() == bot then
                    unitDamage = unitDamage + bot:GetActualIncomingDamage(unit:GetAttackDamage() * unit:GetAttackSpeed() * 3.0, DAMAGE_TYPE_PHYSICAL)
                end
            end

            if unitDamage / (bot:GetHealth() + bot:GetHealthRegen()*3.0) >= 0.2 then
                bot:Action_MoveToLocation(J.VectorAway(botLocation, nEnemyTowers[1]:GetLocation(), 800))
                return
            end
        end
    end

    local __target = nil
    local targetScore = 0
    for _, enemy in pairs(nEnemyHeroes) do
        if J.IsValidHero(enemy)
		and J.IsInRange(bot, enemy, 1200)
        and not J.IsSuspiciousIllusion(enemy)
		and not enemy:HasModifier('modifier_abaddon_borrowed_time')
		and not enemy:HasModifier('modifier_necrolyte_reapers_scythe')
		and not enemy:HasModifier('modifier_skeleton_king_reincarnation_scepter_active')
		and not enemy:HasModifier('modifier_troll_warlord_battle_trance')
		and not enemy:HasModifier('modifier_ursa_enrage')
		and not enemy:HasModifier('modifier_winter_wyvern_cold_embrace')
		and not enemy:HasModifier('modifier_item_blade_mail_reflect')
		and not enemy:HasModifier('modifier_item_aeon_disk_buff')
        and J.CanBeAttacked(enemy) then
            local enemyName = enemy:GetUnitName()
			local mul = 1

            if enemyName == 'npc_dota_hero_sniper' then
				mul = 4
			elseif enemyName == 'npc_dota_hero_drow_ranger' then
				mul = 2
			elseif enemyName == 'npc_dota_hero_crystal_maiden' and not J.IsModifierInRadius(bot, 'modifier_crystal_maiden_freezing_field_slow', 1600) then
				mul = 2
			elseif enemyName == 'npc_dota_hero_jakiro' and not J.IsModifierInRadius(bot, 'modifier_jakiro_macropyre_burn', 1600) then
				mul = 2.5
			elseif enemyName == 'npc_dota_hero_lina' then
				mul = 3
			elseif enemyName == 'npc_dota_hero_nevermore' then
				mul = 3
			elseif enemyName == 'npc_dota_hero_bristleback' and not enemy:IsFacingLocation(botLocation, 90) then
				mul = 0.5
			elseif enemyName == 'npc_dota_hero_enchantress' and enemy:GetLevel() >= 6 then
				mul = 0.5
            end

			if enemyName ~= 'npc_dota_hero_bristleback' then
				if J.IsCore(enemy) then
					mul = mul * 1.5
				else
					mul = mul * 0.5
				end
			end

			if (J.IsEarlyGame() or J.IsMidGame()) then
				if J.IsValidBuilding(nEnemyTowers[1])
				and J.IsInRange(enemy, nEnemyTowers[1], 800)
				then
					mul = mul * 0.5
				end
			end

			local nAllyHeroes_Attacking = J.GetSpecialModeAllies(enemy, 1200, BOT_MODE_ATTACK)
			local nInRangeAlly = J.GetAlliesNearLoc(enemy:GetLocation(), 900)
			local nInRangeEnemy = J.GetEnemiesNearLoc(enemy:GetLocation(), 900)

            local enemyScore = (Min(1, bot:GetAttackRange() / GetUnitToUnitDistance(bot, enemy)))
								* ((1-J.GetHP(enemy)) * J.GetTotalEstimatedDamageToTarget(nAllyHeroes_Attacking, enemy, 5.0))
								* mul
								* (math.exp(RemapValClamped(#nInRangeAlly - #nInRangeEnemy, -4, 4, 0, 1.6)) - 1)
            if enemyScore > targetScore then
                targetScore = enemyScore
                __target = enemy
            end
        end
    end

    if __target == nil then
        __target = X.GetWeakestNearbyHero(true, 1200)
    end

    if __target and J.IsValidHero(__target) then
        local dist = GetUnitToUnitDistance(bot, __target)
        botAttackRange = bot:GetAttackRange() + bot:GetBoundingRadius()

        botTarget.unit = __target
        botTarget.location = __target:GetExtrapolatedLocation(3.0)
        botTarget.id = __target:GetPlayerID()
        bot:SetTarget(__target)

        if botAttackRange < 330 and bot:GetUnitName() ~= 'npc_dota_hero_templar_assassin' then
            if dist < botAttackRange then
                if not J.CanBeAttacked(__target) --[[or (bot:GetLastAttackTime() + bot:GetSecondsPerAttack()) > GameTime()]] then
                    bot:Action_MoveToLocation(__target:GetLocation())
                    return
                else
                    bot:Action_AttackUnit(__target, true)
                    return
                end
            else
                bot:Action_MoveToLocation(__target:GetLocation())
                return
            end
        else
            if dist < botAttackRange then
                if not J.CanBeAttacked(__target) --[[or (bot:GetLastAttackTime() + bot:GetSecondsPerAttack()) > GameTime()]] then
                    if dist < botAttackRange - 100 then
                        bot:Action_MoveToLocation(J.VectorAway(botLocation, __target:GetLocation(), botAttackRange - dist - 100))
                        return
                    elseif dist > botAttackRange - 100 then
                        bot:Action_MoveToLocation(J.VectorTowards(botLocation, __target:GetLocation(), dist - botAttackRange - 100))
                        return
                    end
                else
                    -- if dist < botAttackRange then
                    --     bot:Action_MoveToLocation(J.VectorAway(botLocation, __target:GetLocation(), botAttackRange - dist))
                    --     return
                    -- else
                    --     bot:Action_AttackUnit(__target, true)
                    --     return
                    -- end
                    bot:Action_AttackUnit(__target, true)
                    return
                end
            else
                bot:Action_MoveToLocation(__target:GetLocation())
                return
            end
        end
    end

    if helpAlly.should then
        bot:Action_MoveToLocation(helpAlly.location)
        return
    end

    -- chase in FoW
    if botTarget.fogChase then
        local vLastSeenLocation = botTarget.location
        local vForwardDirs = {
            vLastSeenLocation + Vector(700, 0), -- right
            vLastSeenLocation + Vector(-700, 0), -- left
            vLastSeenLocation + Vector(0, 700), -- up
            vLastSeenLocation + Vector(0, -700), -- down
            vLastSeenLocation + Vector(700, 700), -- diagonal
        }

        local vLikelyLocation = nil
        local vLikelyLocationScore = 0
        for _, loc in ipairs(vForwardDirs) do
            local score = GetUnitPotentialValue(botTarget.unit, loc, 900)
            if score > vLikelyLocationScore and score > 180 then
                vLikelyLocationScore = score
                vLikelyLocation = loc
            end
        end

        if vLikelyLocation then
            bot:Action_MoveToLocation(vLikelyLocation)
            return
        end
    end

    bClearMode = true
end

function OnEnd()
    botTarget.fogChase = false
    helpAlly.should = false
end

end

function GetTarget(tUnits)
    local __target = J.GetSetNearbyTarget(bot, tUnits)
	if __target ~= nil then
		return __target
	end

    for i = 1, 5 do
        local member = GetTeamMember(i)
        if J.IsValidHero(member) and J.IsInRange(bot, member, 1200) then
            local target = member:GetAttackTarget()
            if J.IsValidHero(target) then
                return target
            end
        end
    end

    return nil
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
		and J.CanBeAttacked(hero)
        and not J.IsSuspiciousIllusion(hero)
		and not hero:HasModifier('modifier_abaddon_borrowed_time')
		and not hero:HasModifier('modifier_necrolyte_reapers_scythe')
		and not hero:HasModifier('modifier_skeleton_king_reincarnation_scepter_active')
		and not hero:HasModifier('modifier_troll_warlord_battle_trance')
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

function X.GetActualDesire(nDesire)
    local alpha = 0.3
    nDesire = fLastAttackDesire * (1 - alpha) + nDesire * alpha
    fLastAttackDesire = nDesire
    return nDesire
end
