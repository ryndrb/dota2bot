local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local U = require(GetScriptDirectory()..'/FunLib/MinionLib/utils')

local X = {}
X.ConsiderBrewLinkSpell = {}
local bot, botTarget

local nAllyHeroes, nEnemyHeroes

function X.Think(ownerBot, hMinionUnit)
	if not U.IsValidUnit(hMinionUnit) or J.CanNotUseAction(hMinionUnit) then return end

    bot = ownerBot
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = hMinionUnit:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = hMinionUnit:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	if hMinionUnit.abilities == nil
	then
        U.InitiateAbility(hMinionUnit)
	end

	for i = 1, #hMinionUnit.abilities
	do
		if J.CanCastAbility(hMinionUnit.abilities[i])
		then
			hMinionUnit.cast_desire, hMinionUnit.cast_target, hMinionUnit.cast_type = X.ConsiderBrewLinkSpell[hMinionUnit.abilities[i]:GetName()](hMinionUnit, hMinionUnit.abilities[i])
			if hMinionUnit.cast_desire > 0
			then
				if hMinionUnit.cast_type == 'no_target'
				then
					hMinionUnit:Action_UseAbility(hMinionUnit.abilities[i])
					return
				elseif hMinionUnit.cast_type == 'point'
				then
					hMinionUnit:Action_UseAbilityOnLocation(hMinionUnit.abilities[i], hMinionUnit.cast_target)
					return
				elseif hMinionUnit.cast_type == 'unit'
				then
					hMinionUnit:Action_UseAbilityOnEntity(hMinionUnit.abilities[i], hMinionUnit.cast_target)
					return
				elseif hMinionUnit.cast_type == 'tree'
				then
					hMinionUnit:Action_UseAbilityOnTree(hMinionUnit.abilities[i], hMinionUnit.cast_target)
					return
				end
			end
		end
	end

	hMinionUnit.retreat_desire   , hMinionUnit.retreat_location = X.ConsiderRetreat(hMinionUnit)
	if hMinionUnit.retreat_desire > 0
	then
		hMinionUnit:Action_MoveToLocation(hMinionUnit.retreat_location)
		return
	end

    hMinionUnit.attack_desire    , hMinionUnit.attack_target = X.ConsiderAttack(hMinionUnit)
	if hMinionUnit.attack_desire > 0
	then
		hMinionUnit:Action_AttackUnit(hMinionUnit.attack_target, true)
		return
	end

    hMinionUnit.move_desire      , hMinionUnit.move_location = X.ConsiderMove(hMinionUnit)
    if hMinionUnit.move_desire > 0
	then
		hMinionUnit:Action_MoveToLocation(hMinionUnit.move_location)
		return
	end
end

X.ConsiderBrewLinkSpell['brewmaster_earth_hurl_boulder'] = function (hMinionUnit, ability)
    local nCastRange = J.GetProperCastRange(false, hMinionUnit, ability:GetCastRange())
    local nDamage = ability:GetSpecialValueInt('damage')

    for _, enemyHero in pairs(nEnemyHeroes)
    do
        if  J.IsValidHero(enemyHero)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanCastOnTargetAdvanced(enemyHero)
        then
            if enemyHero:IsChanneling()
            and J.IsInRange(hMinionUnit, enemyHero, nCastRange)
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero, 'unit'
            end

            if  J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_PHYSICAL)
            and J.IsInRange(hMinionUnit, enemyHero, nCastRange)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero, 'unit'
            end
        end

        if  J.IsValidTarget(enemyHero)
        and J.CanCastOnMagicImmune(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        and not U.CantMove(enemyHero)
        and not enemyHero:HasModifier('modifier_brewmaster_storm_cyclone')
        and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not enemyHero:HasModifier('modifier_enigma_black_hole_pull')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        then
            return BOT_ACTION_DESIRE_HIGH, enemyHero, 'unit'
        end
    end

    return BOT_ACTION_DESIRE_HIGH, nil, ''
end

-- Will improve once I'll care about fixing dispels stuff etc.
X.ConsiderBrewLinkSpell['brewmaster_storm_dispel_magic'] = function (hMinionUnit, ability)
    local nCastRange = J.GetProperCastRange(false, hMinionUnit, ability:GetCastRange())

    for _, ally in pairs(nAllyHeroes)
    do
        if J.IsValidHero(ally)
        and J.IsInRange(hMinionUnit, ally, nCastRange)
        and not ally:IsIllusion()
        and J.IsDisabled(ally)
        then
            return BOT_ACTION_DESIRE_HIGH, ally:GetLocation(), 'point'
        end
    end

    if #nEnemyHeroes == 1
    and J.IsInRange(hMinionUnit, nEnemyHeroes[1], nCastRange)
    and not J.IsSuspiciousIllusion(nEnemyHeroes[1])
    and nEnemyHeroes[1]:HasModifier("modifier_brewmaster_storm_cyclone")
    then
        return BOT_ACTION_DESIRE_HIGH, nEnemyHeroes[1]:GetLocation(), 'point'
    end

    return BOT_ACTION_DESIRE_HIGH, nil, ''
end

X.ConsiderBrewLinkSpell['brewmaster_storm_cyclone'] = function (hMinionUnit, ability)
    local nCastRange = J.GetProperCastRange(false, hMinionUnit, ability:GetCastRange())

    local target = nil
    local targetRightClickDmg = 0

    for _, enemy in pairs(nEnemyHeroes)
    do
        if J.IsValid(enemy)
        and J.IsInRange(hMinionUnit, enemy, nCastRange)
        and J.CanCastOnNonMagicImmune(enemy)
        and J.CanCastOnTargetAdvanced(enemy)
        then
            if enemy:GetUnitName() == 'npc_dota_hero_faceless_void'
            and (enemy:HasModifier('modifier_faceless_void_chronosphere_speed') or enemy:HasModifier('modifier_faceless_void_chronosphere_selfbuff'))
            then
                return BOT_ACTION_DESIRE_HIGH, enemy, 'unit'
            end

            local rightClickDmg = enemy:GetAttackDamage() * enemy:GetAttackSpeed()
            if rightClickDmg > targetRightClickDmg
            then
                targetRightClickDmg = rightClickDmg
                target = enemy
            end
        end
    end

    if target ~= nil
    then
        return BOT_ACTION_DESIRE_HIGH, target, 'unit'
    end

    for i = 1, #nEnemyHeroes
    do
        if J.IsValidHero(nEnemyHeroes[i])
        and J.CanCastOnNonMagicImmune(nEnemyHeroes[i])
        and J.CanCastOnTargetAdvanced(nEnemyHeroes[i])
        then
            if nEnemyHeroes[i]:IsChanneling()
            then
                return BOT_ACTION_DESIRE_HIGH, nEnemyHeroes[i], 'unit'
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil, ''
end

X.ConsiderBrewLinkSpell['brewmaster_storm_wind_walk'] = function (hMinionUnit, ability)
    if hMinionUnit:HasModifier('modifier_brewmaster_storm_wind_walk')
    then
        return BOT_ACTION_DESIRE_NONE, nil, ''
    end

    local nEnemyLaneCreeps = hMinionUnit:GetNearbyLaneCreeps(1600, true)

    if J.IsRetreating(bot)
    or (#nEnemyLaneCreeps == 0 and #nEnemyHeroes == 0)
    then
        return BOT_ACTION_DESIRE_HIGH, nil, 'no_target'
    end

    return BOT_ACTION_DESIRE_HIGH, nil, ''
end

X.ConsiderBrewLinkSpell['brewmaster_void_astral_pull'] = function (hMinionUnit, ability)
    local nCastRange = J.GetProperCastRange(false, hMinionUnit, ability:GetCastRange())

    for _, enemyHero in pairs(nEnemyHeroes)
    do
        if J.IsValidHero(enemyHero)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanCastOnTargetAdvanced(enemyHero)
        and enemyHero:IsChanneling()
        and J.IsInRange(hMinionUnit, enemyHero, nCastRange)
        then
            return BOT_ACTION_DESIRE_HIGH, enemyHero, 'unit'
        end
    end

    for _, ally in pairs(GetUnitList(UNIT_LIST_ALLIES))
    do
        if U.IsValidUnit(ally)
        and ally:GetUnitName() == 'npc_dota_brewmaster_earth'
        and J.GetHP(ally) < 0.45
        then
            if J.IsInRange(hMinionUnit, ally, nCastRange)
            and hMinionUnit:IsFacingLocation(J.GetTeamFountain(), 30)
            then
                return BOT_ACTION_DESIRE_HIGH, ally, 'unit'
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil, ''
end

-- X.ConsiderBrewLinkSpell['brewmaster_cinder_brew'] = function (hMinionUnit, ability)
--     local nCastRange = J.GetProperCastRange(false, hMinionUnit, ability:GetCastRange())
--     local targetStrongest = J.GetStrongestUnit(nCastRange, hMinionUnit, true, false, 5.0)

--     if targetStrongest ~= nil then
--         return BOT_ACTION_DESIRE_HIGH, targetStrongest:GetLocation(), 'point'
--     end

--     return BOT_ACTION_DESIRE_HIGH, nil, ''
-- end

-- X.ConsiderBrewLinkSpell['brewmaster_thunder_clap'] = function (hMinionUnit, ability)
--     local nRadius = ability:GetSpecialValueInt("radius")
--     local nEnemyHeroes = hMinionUnit:GetNearbyHeroes(nRadius, true, BOT_MODE_NONE)

--     if nEnemyHeroes ~= nil and #nEnemyHeroes >= 1
--     then
--         return BOT_ACTION_DESIRE_HIGH, nil, 'no_target'
--     end

--     return BOT_ACTION_DESIRE_HIGH, nil, ''
-- end

-- X.ConsiderBrewLinkSpell['brewmaster_drunken_brawler'] = function (hMinionUnit, ability)
--     local nAttackRange = hMinionUnit:GetAttackRange()
--     local nEnemyHeroes = hMinionUnit:GetNearbyHeroes(nAttackRange, true, BOT_MODE_NONE)

--     if nEnemyHeroes ~= nil and #nEnemyHeroes >= 1
--     then
--         return BOT_ACTION_DESIRE_HIGH, nil, 'no_target'
--     end

--     return BOT_ACTION_DESIRE_HIGH, nil, ''
-- end

function X.ConsiderRetreat(hMinionUnit)
	if J.CanNotUseAction(hMinionUnit) or U.CantMove(hMinionUnit)
	then
		return BOT_ACTION_DESIRE_NONE, 0
	end

    if J.GetHP(hMinionUnit) < 0.5
    and not J.IsInTeamFight(bot, 1600)
    and (U.IsTargetedByHero(hMinionUnit)
        or U.IsTargetedByTower(hMinionUnit)
        or U.IsTargetedByCreep(hMinionUnit))
    then
        return BOT_ACTION_DESIRE_HIGH, J.GetTeamFountain()
    end

    if #nAllyHeroes == 0 and #nEnemyHeroes > 1
    or J.GetHP(hMinionUnit) < 0.4
	then
        return BOT_ACTION_DESIRE_HIGH, J.GetTeamFountain()
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderAttack(hMinionUnit)
	if U.IsBusy(hMinionUnit) or U.CantAttack(hMinionUnit)
	then
		return BOT_ACTION_DESIRE_NONE, nil
	end

    local target = U.GetWeakestHero(1600, hMinionUnit)
    if target == nil
	then
		if target == nil then target = U.GetWeakestCreep(1600, hMinionUnit) end
		if target == nil then target = U.GetWeakestTower(1600, hMinionUnit) end
	end

    if target ~= nil and not U.IsNotAllowedToAttack(target)
    then
        return BOT_ACTION_DESIRE_HIGH, target
    end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderMove(hMinionUnit)
	if U.CantMove(hMinionUnit)
	then
		return BOT_MODE_DESIRE_NONE, 0
	end

    local target = U.GetWeakestHero(1600, hMinionUnit)
    if target == nil
	then
		if target == nil then target = U.GetWeakestCreep(1600, hMinionUnit) end
		if target == nil then target = U.GetWeakestTower(1600, hMinionUnit) end
	end

    if target ~= nil
    then
        return BOT_ACTION_DESIRE_HIGH, target:GetLocation()
    end

    local loc = J.GetClosestTeamLane(hMinionUnit)
    local nInRangeEnemy = J.GetEnemiesNearLoc(loc, 1600)
    if #nEnemyHeroes == 0
    then
        if #nInRangeEnemy == 0
        then
            return BOT_MODE_DESIRE_HIGH, J.GetClosestTeamLane(hMinionUnit)
        else
            return BOT_ACTION_DESIRE_HIGH, J.GetTeamFountain()
        end
    else
        if J.IsValidHero(nAllyHeroes[1])
        then
            return BOT_ACTION_DESIRE_HIGH, nAllyHeroes[1]:GetLocation()
        else
            return BOT_ACTION_DESIRE_HIGH, J.GetTeamFountain()
        end
    end
end

return X