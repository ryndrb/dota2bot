local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local U = require(GetScriptDirectory()..'/FunLib/MinionLib/utils')

local X = {}
X.ConsiderBrewLinkSpell = {}

local bot, botTarget
local nAllyHeroes, nEnemyHeroes

local SPELL_TARGET_TYPE_NONE    = 0
local SPELL_TARGET_TYPE_UNIT    = 1
local SPELL_TARGET_TYPE_POINT   = 2
local SPELL_TARGET_TYPE_TREE    = 3

function X.Think(ownerBot, hMinionUnit)
	if not J.IsValid(hMinionUnit) or J.CanNotUseAction(hMinionUnit) then return end

    bot = ownerBot
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = hMinionUnit:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = hMinionUnit:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    local nDesire, hTarget, nCastType = 0, nil, -1

    for i = 0, 5 do
        local hAbility = hMinionUnit:GetAbilityInSlot(i)
        if J.CanCastAbility(hAbility) then
            local sAbilityName = hAbility:GetName()

            local spellFunction = X.ConsiderBrewLinkSpell[sAbilityName]
            if spellFunction then
                nDesire, hTarget, nCastType = spellFunction(hMinionUnit, hAbility)
                if nDesire > 0 then
                    if nCastType == SPELL_TARGET_TYPE_NONE then
                        hMinionUnit:Action_UseAbility(hAbility)
                        return
                    elseif nCastType == SPELL_TARGET_TYPE_UNIT then
                        hMinionUnit:Action_UseAbilityOnEntity(hAbility, hTarget)
                        return
                    elseif nCastType == SPELL_TARGET_TYPE_POINT then
                        hMinionUnit:Action_UseAbilityOnLocation(hAbility, hTarget)
                        return
                    elseif nCastType == SPELL_TARGET_TYPE_TREE then
                        hMinionUnit:Action_UseAbilityOnTree(hAbility, hTarget)
                        return
                    end
                end
            end
        end
	end

    if J.CanNotUseAction(hMinionUnit) then
		return
	end

	nDesire, hTarget = X.ConsiderRetreat(hMinionUnit)
	if nDesire > 0 then
		hMinionUnit:Action_MoveToLocation(hTarget)
		return
	end

    nDesire, hTarget = X.ConsiderAttack(hMinionUnit)
	if nDesire > 0 then
		hMinionUnit:Action_AttackUnit(hTarget, true)
		return
	end

    nDesire, hTarget = X.ConsiderMove(hMinionUnit)
    if nDesire > 0 then
		hMinionUnit:Action_MoveToLocation(hTarget)
		return
	end
end

X.ConsiderBrewLinkSpell['brewmaster_earth_hurl_boulder'] = function (hMinionUnit, ability)

    local nCastRange = ability:GetCastRange()
    local nDamage = ability:GetSpecialValueInt('damage')

    for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.IsInRange(hMinionUnit, enemyHero, nCastRange + 300)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanCastOnTargetAdvanced(enemyHero)
        then
            if enemyHero:IsChanneling() then
                return BOT_ACTION_DESIRE_HIGH, enemyHero, SPELL_TARGET_TYPE_UNIT
            end

            if  J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_PHYSICAL)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero, SPELL_TARGET_TYPE_UNIT
            end
        end
    end

    for i = 1, 5 do
        local allyHero =  GetTeamMember(i)

        if J.IsValidHero(allyHero) then
            local allyHeroTarget = J.GetProperTarget(allyHero)

            if J.IsGoingOnSomeone(allyHero) then
                if  J.IsValidHero(allyHeroTarget)
                and J.CanBeAttacked(allyHeroTarget)
                and J.IsInRange(allyHero, allyHeroTarget, 1600)
                and J.IsInRange(hMinionUnit, allyHeroTarget, nCastRange)
                and J.CanCastOnNonMagicImmune(allyHeroTarget)
                and J.CanCastOnTargetAdvanced(allyHeroTarget)
                and J.IsChasingTarget(allyHero, allyHeroTarget)
                and not J.IsDisabled(allyHeroTarget)
                and not allyHeroTarget:HasModifier('modifier_abaddon_borrowed_time')
                and not allyHeroTarget:HasModifier('modifier_dazzle_shallow_grave')
                and not allyHeroTarget:HasModifier('modifier_necrolyte_reapers_scythe')
                then
                    return BOT_ACTION_DESIRE_HIGH, allyHeroTarget, SPELL_TARGET_TYPE_UNIT
                end
            end

            if J.IsRetreating(allyHero) and not J.IsRealInvisible(allyHero) then
                for _, enemyHero in pairs(nEnemyHeroes) do
                    if  J.IsValidHero(enemyHero)
                    and J.CanBeAttacked(enemyHero)
                    and J.IsInRange(allyHero, enemyHero, 1200)
                    and J.IsInRange(hMinionUnit, enemyHero, nCastRange)
                    and J.CanCastOnNonMagicImmune(enemyHero)
                    and J.CanCastOnTargetAdvanced(enemyHero)
                    and not J.IsDisabled(enemyHero)
                    and allyHero:WasRecentlyDamagedByHero(enemyHero, 3.0)
                    then
                        return BOT_ACTION_DESIRE_HIGH, allyHeroTarget, SPELL_TARGET_TYPE_UNIT
                    end
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_HIGH
end

X.ConsiderBrewLinkSpell['brewmaster_storm_dispel_magic'] = function (hMinionUnit, ability)

    local nCastRange = ability:GetCastRange()

    for i = 1, 5 do
        local allyHero =  GetTeamMember(i)

        if J.IsValidHero(allyHero) then
            if J.IsInRange(hMinionUnit, allyHero, nCastRange + 300) then
                if allyHero:HasModifier('modifier_bane_nightmare')
                or allyHero:HasModifier('modifier_axe_battle_hunger')
                or allyHero:HasModifier('modifier_bristleback_viscous_nasal_goo')
                or allyHero:HasModifier('modifier_earth_spirit_magnetize')
                or allyHero:HasModifier('modifier_phoenix_fire_spirit_burn')
                or allyHero:HasModifier('modifier_life_stealer_open_wounds')
                or allyHero:HasModifier('modifier_faceless_void_time_dilation_slow')
                or allyHero:HasModifier('modifier_warlock_fatal_bonds')
                or allyHero:HasModifier('modifier_arc_warden_flux')
                or allyHero:HasModifier('modifier_venomancer_venomous_gale')
                or allyHero:HasModifier('modifier_stunned')
                then
                    return BOT_ACTION_DESIRE_HIGH, allyHero:GetLocation(), SPELL_TARGET_TYPE_POINT
                end
            end
        end
    end

    for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.IsInRange(hMinionUnit, enemyHero, nCastRange + 300)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanCastOnTargetAdvanced(enemyHero)
        then
            if enemyHero:HasModifier('modifier_flask_healing')
            or enemyHero:HasModifier('modifier_clarity_potion')
            or enemyHero:HasModifier('modifier_item_pavise_shield')
            or enemyHero:HasModifier('modifier_item_solar_crest_armor_addition')
            or enemyHero:HasModifier('modifier_disperser_movespeed_buff')
            or enemyHero:HasModifier('modifier_earthshaker_enchant_totem')
            or enemyHero:HasModifier('modifier_legion_commander_overwhelming_odds')
            or enemyHero:HasModifier('modifier_legion_commander_press_the_attack')
            or enemyHero:HasModifier('modifier_ogre_magi_bloodlust')
            or enemyHero:HasModifier('modifier_shredder_reactive_armor_bomb')
            or enemyHero:HasModifier('modifier_ursa_overpower')
            or enemyHero:HasModifier('modifier_necrolyte_sadist_active')
            or enemyHero:HasModifier('modifier_pugna_decrepify')
            or enemyHero:HasModifier('modifier_warlock_shadow_word')
            or enemyHero:HasModifier('modifier_abaddon_aphotic_shield')
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation(), SPELL_TARGET_TYPE_POINT
            end
        end
    end

    local nInRangeEnemy = J.GetEnemiesNearLoc(hMinionUnit:GetLocation(), 1200)

    if  #nInRangeEnemy == 1
    and #nAllyHeroes >= 2
    and J.IsValidHero(nInRangeEnemy[1])
    and J.IsInRange(hMinionUnit, nInRangeEnemy[1], nCastRange)
    and nInRangeEnemy[1]:HasModifier("modifier_brewmaster_storm_cyclone")
    then
        return BOT_ACTION_DESIRE_HIGH, nInRangeEnemy[1]:GetLocation(), SPELL_TARGET_TYPE_POINT
    end

    return BOT_ACTION_DESIRE_HIGH
end

X.ConsiderBrewLinkSpell['brewmaster_storm_cyclone'] = function (hMinionUnit, ability)

    local nCastRange = ability:GetCastRange()

    local target = nil
    local targetDamage = 0
    for _, enemyHero in pairs(nEnemyHeroes) do
        if J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.IsInRange(hMinionUnit, enemyHero, nCastRange)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanCastOnTargetAdvanced(enemyHero)
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        then
            if enemyHero:IsChanneling() then
                return BOT_ACTION_DESIRE_HIGH, enemyHero, SPELL_TARGET_TYPE_UNIT
            end

            local sEnemyHeroName = enemyHero:GetUnitName()
            if sEnemyHeroName == 'npc_dota_hero_faceless_void' and enemyHero:GetCurrentMovementSpeed() >= 1000 then
                return BOT_ACTION_DESIRE_HIGH, enemyHero, SPELL_TARGET_TYPE_UNIT
            end

            local enemyHeroDamage = enemyHero:GetAttackDamage() * enemyHero:GetAttackSpeed()
            if enemyHeroDamage > targetDamage then
                target = enemyHero
                targetDamage = enemyHeroDamage
            end
        end
    end

    if target ~= nil then
        return BOT_ACTION_DESIRE_HIGH, target, SPELL_TARGET_TYPE_UNIT
    end

    return BOT_ACTION_DESIRE_NONE
end

X.ConsiderBrewLinkSpell['brewmaster_storm_wind_walk'] = function (hMinionUnit, ability)

    if J.IsRealInvisible(hMinionUnit) then
        return BOT_ACTION_DESIRE_NONE
    end

    local nEnemyLaneCreeps = hMinionUnit:GetNearbyLaneCreeps(1600, true)

    if (J.IsStunProjectileIncoming(hMinionUnit, 500))
    or (hMinionUnit:IsRooted())
    or (J.GetAttackProjectileDamageByRange(hMinionUnit, 800))
    or (#nEnemyLaneCreeps == 0 and #nEnemyHeroes == 0 and J.IsRunning(hMinionUnit))
    then
        return BOT_ACTION_DESIRE_HIGH, nil, SPELL_TARGET_TYPE_NONE
    end

    return BOT_ACTION_DESIRE_NONE
end

X.ConsiderBrewLinkSpell['brewmaster_primal_split_cancel'] = function (hMinionUnit, ability)

    if string.find(hMinionUnit:GetUnitName(), 'earth') then
        local nInRangeEnemy = J.GetEnemiesNearLoc(hMinionUnit:GetLocation(), 2000)
        if #nInRangeEnemy == 0 and hMinionUnit:DistanceFromFountain() > 4000 then
            return BOT_ACTION_DESIRE_HIGH, nil, SPELL_TARGET_TYPE_NONE
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderRetreat(hMinionUnit)

    local vTeamFightLocation = J.GetTeamFightLocation(hMinionUnit)

    if J.GetHP(hMinionUnit) < 0.5 and vTeamFightLocation == nil then
        if U.IsTargetedByHero(hMinionUnit)
        or U.IsTargetedByTower(hMinionUnit)
        or U.IsTargetedByCreep(hMinionUnit)
        then
            return BOT_ACTION_DESIRE_HIGH, J.GetTeamFountain()
        end
    end

    if #nAllyHeroes == 0 and #nEnemyHeroes > 1
    or J.GetHP(hMinionUnit) < 0.3
	then
        return BOT_ACTION_DESIRE_HIGH, J.GetTeamFountain()
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderAttack(hMinionUnit)

    local target = U.GetWeakestHero(1600, hMinionUnit)
    if target == nil then
		if target == nil then target = U.GetWeakestCreep(1600, hMinionUnit) end
		if target == nil then target = U.GetWeakestTower(1600, hMinionUnit) end
	end

    if target ~= nil then
        return BOT_ACTION_DESIRE_HIGH, target
    end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderMove(hMinionUnit)

    local target = U.GetWeakestHero(1600, hMinionUnit)
    if target == nil then
		if target == nil then target = U.GetWeakestCreep(1600, hMinionUnit) end
		if target == nil then target = U.GetWeakestTower(1600, hMinionUnit) end
	end

    if target ~= nil then
        return BOT_ACTION_DESIRE_HIGH, target:GetLocation()
    end

    for i = 1, 5 do
        local allyHero =  GetTeamMember(i)
        if J.IsValidHero(allyHero) and J.IsInRange(hMinionUnit, allyHero, 3200) then
            if J.IsGoingOnSomeone(allyHero) then
                return BOT_ACTION_DESIRE_HIGH, allyHero:GetLocation()
            end
        end
    end

    local vLocation = J.GetClosestTeamLane(hMinionUnit)
    local nInRangeEnemy = J.GetEnemiesNearLoc(vLocation, 1600)
    if #nEnemyHeroes == 0 then
        if #nInRangeEnemy == 0 then
            return BOT_MODE_DESIRE_HIGH, vLocation
        else
            return BOT_ACTION_DESIRE_HIGH, J.GetTeamFountain()
        end
    else
        if J.IsValidHero(nAllyHeroes[1]) then
            return BOT_ACTION_DESIRE_HIGH, nAllyHeroes[1]:GetLocation()
        else
            return BOT_ACTION_DESIRE_HIGH, J.GetTeamFountain()
        end
    end
end

return X