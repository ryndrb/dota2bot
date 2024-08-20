local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local U = require(GetScriptDirectory()..'/FunLib/MinionLib/utils')
local I = dofile(GetScriptDirectory()..'/FunLib/MinionLib/illusions')

local X = {}

X.ConsiderSpellUsage = {}

local bot

local botHP, botTarget
local thisMinionHP, nAllyHeroes, nEnemyHeroes

function X.Think(ownerBot, hMinionUnit)
    bot = ownerBot

	if not U.IsValidUnit(hMinionUnit) or J.CanNotUseAbility(hMinionUnit) then return end

	if hMinionUnit.abilities == nil
	then
		U.InitiateAbility(hMinionUnit)
	end

	for i = 1, #hMinionUnit.abilities
	do
		if J.CanCastAbility(hMinionUnit.abilities[i])
		then
            botTarget = J.GetProperTarget(bot)
            thisMinionHP = J.GetHP(hMinionUnit)
            nAllyHeroes = hMinionUnit:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
            nEnemyHeroes = hMinionUnit:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

            -- will support others later; tedious rn
            hMinionUnit.cast_desire, hMinionUnit.cast_target, hMinionUnit.cast_type = X.ConsiderSpellUsage[hMinionUnit.abilities[i]:GetName()](hMinionUnit, hMinionUnit.abilities[i])
            if hMinionUnit.cast_desire > 0
            then
                if hMinionUnit.cast_type == 'unit'
                then
                    hMinionUnit:Action_UseAbilityOnEntity(hMinionUnit.abilities[i], hMinionUnit.cast_target)
                    return
                elseif hMinionUnit.cast_type == 'aoe'
                then
                    hMinionUnit:Action_UseAbilityOnLocation(hMinionUnit.abilities[i], hMinionUnit.cast_target)
                    return
                elseif hMinionUnit.cast_type == 'none'
                then
                    hMinionUnit:Action_UseAbility(hMinionUnit.abilities[i])
                    return
                end
            end

            -- Generic Casting

            -- Unit Target
			if J.CheckBitfieldFlag(hMinionUnit.abilities[i]:GetBehavior(), ABILITY_BEHAVIOR_UNIT_TARGET)
			then
                hMinionUnit.cast_desire, hMinionUnit.cast_target = X.ConsiderUnitTarget(hMinionUnit, hMinionUnit.abilities[i])
                if hMinionUnit.cast_desire > 0
                then
                    hMinionUnit:Action_UseAbilityOnEntity(hMinionUnit.abilities[i], hMinionUnit.cast_target)
                    return
                end
            end

            -- Point Target / AoE
			if X.CheckBitfieldFlag(hMinionUnit.abilities[i]:GetBehavior(), ABILITY_BEHAVIOR_POINT)
			then
				hMinionUnit.cast_desire, hMinionUnit.cast_location = X.ConsiderPointTarget(hMinionUnit, hMinionUnit.abilities[i])
				if hMinionUnit.cast_desire > 0
				then
					hMinionUnit:Action_UseAbilityOnLocation(hMinionUnit.abilities[i], hMinionUnit.cast_location)
					return
				end
            end

            -- No Target
			if X.CheckBitfieldFlag(hMinionUnit.abilities[i]:GetBehavior(), ABILITY_BEHAVIOR_NO_TARGET)
			then
				hMinionUnit.cast_desire = X.ConsiderNoTarget(hMinionUnit, hMinionUnit.abilities[i])
				if hMinionUnit.cast_desire > 0
				then
					hMinionUnit:Action_UseAbility(hMinionUnit.abilities[i])
					return
				end
			end
		end
	end

    -- Attack, Move
    -- TODO: Personalize for select minions.
	I.Think(bot, hMinionUnit)
end

function X.ConsiderUnitTarget(hMinionUnit, ability)
	local nCastRange = ability:GetCastRange() + 300
    local nDamage = ability:GetAbilityDamage()

    if nDamage
    then
        for _, enemy in pairs(nEnemyHeroes)
        do
            if J.IsValidHero(enemy)
            and J.IsInRange(hMinionUnit, enemy, nCastRange)
            and J.CanCastOnNonMagicImmune(enemy)
            and not J.IsSuspiciousIllusion(enemy)
            then
                if J.CanKillTarget(enemy, nDamage, DAMAGE_TYPE_ALL)
                and not enemy:HasModifier('modifier_abaddon_borrowed_time')
                and not enemy:HasModifier('modifier_dazzle_shallow_grave')
                and not enemy:HasModifier('modifier_necrolyte_reapers_scythe')
                and not enemy:HasModifier('modifier_oracle_false_promise_timer')
                then
                    return BOT_ACTION_DESIRE_HIGH, enemy, 'unit'
                end
            end
        end
    end

	if J.IsRetreating(bot)
    then
		if #nEnemyHeroes > 0
        then
			for _, enemy in pairs(nEnemyHeroes)
            do
                if J.IsValidHero(enemy)
                and J.IsInRange(hMinionUnit, enemy, nCastRange)
                and J.CanCastOnNonMagicImmune(enemy)
                and J.CanCastOnTargetAdvanced(enemy)
                and (J.IsSuspiciousIllusion(enemy) and enemy:HasModifier('modifier_arc_warden_tempest_double')
                    or J.IsSuspiciousIllusion(enemy) and enemy:GetUnitName() == 'npc_dota_hero_chaos_knight'
                    or not J.IsSuspiciousIllusion(enemy))
                and not U.CantMove(enemy)
                and bot:WasRecentlyDamagedByHero(enemy, 3.0)
                then
                    return BOT_ACTION_DESIRE_HIGH, enemy, 'unit'
                end
			end
		end
	else
        if J.IsValidHero(botTarget)
        and J.IsInRange(hMinionUnit, botTarget, nCastRange)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.CanCastOnTargetAdvanced(botTarget)
        and not J.IsSuspiciousIllusion(botTarget)
        and not U.CantMove(botTarget)
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget, 'unit'
        end

        if J.IsDoingRoshan(bot)
        then
            -- Remove Spell Block
            if  J.IsRoshan(botTarget)
            and J.CanCastOnNonMagicImmune(botTarget)
            and J.IsInRange(bot, botTarget, nCastRange)
            and J.GetHP(botTarget) > 0.5
            and J.IsAttacking(bot)
            then
                return BOT_ACTION_DESIRE_HIGH, botTarget, 'unit'
            end
        end

        if J.IsDoingTormentor(bot)
        then
            if  J.IsTormentor(botTarget)
            and J.IsInRange(bot, botTarget, nCastRange)
            and J.GetHP(botTarget) > 0.5
            and J.IsAttacking(bot)
            then
                return BOT_ACTION_DESIRE_HIGH, botTarget, 'unit'
            end
        end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderPointTarget(hMinionUnit, ability)
	local nCastRange = ability:GetCastRange() + 300
    local nCastPoint = ability:GetCastPoint()
    local nDamage = ability:GetAbilityDamage()

    if nDamage
    then
        for _, enemy in pairs(nEnemyHeroes)
        do
            if J.IsValidHero(enemy)
            and J.IsInRange(hMinionUnit, enemy, nCastRange)
            and J.CanCastOnNonMagicImmune(enemy)
            and not J.IsSuspiciousIllusion(enemy)
            then
                if J.CanKillTarget(enemy, nDamage, DAMAGE_TYPE_ALL)
                and not enemy:HasModifier('modifier_abaddon_borrowed_time')
                and not enemy:HasModifier('modifier_dazzle_shallow_grave')
                and not enemy:HasModifier('modifier_necrolyte_reapers_scythe')
                and not enemy:HasModifier('modifier_oracle_false_promise_timer')
                then
                    return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(enemy, nCastPoint), 'aoe'
                end
            end
        end
    end


	if J.IsRetreating(bot)
    then
		if #nEnemyHeroes > 0
        then
			for _, enemy in pairs(nEnemyHeroes)
            do
                if J.IsValidHero(enemy)
                and J.IsInRange(hMinionUnit, enemy, nCastRange)
                and J.CanCastOnNonMagicImmune(enemy)
                and (J.IsSuspiciousIllusion(enemy) and enemy:HasModifier('modifier_arc_warden_tempest_double')
                    or J.IsSuspiciousIllusion(enemy) and enemy:GetUnitName() == 'npc_dota_hero_chaos_knight'
                    or not J.IsSuspiciousIllusion(enemy))
                and not U.CantMove(enemy)
                and bot:WasRecentlyDamagedByHero(enemy, 3.0)
                then
                    return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(enemy, nCastPoint), 'aoe'
                end
			end
		end
    end

    if J.IsGoingOnSomeone(bot)
    or bot:GetActiveMode() == BOT_MODE_DEFEND_ALLY
    then
        if J.IsValidHero(botTarget)
        and J.IsInRange(hMinionUnit, botTarget, nCastRange)
        and J.CanCastOnNonMagicImmune(botTarget)
        and not J.IsSuspiciousIllusion(botTarget)
        and not U.CantMove(botTarget)
        then
            return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(botTarget, nCastPoint), 'aoe'
        end
    end

    if J.IsDoingRoshan(bot)
    then
        -- Remove Spell Block
        if  J.IsRoshan(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.GetHP(botTarget) > 0.5
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation(), 'aoe'
        end
    end

    if J.IsDoingTormentor(bot)
    then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.GetHP(botTarget) > 0.5
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation(), 'aoe'
        end
    end

	return BOT_ACTION_DESIRE_NONE, nil
end


function X.ConsiderNoTarget(hMinionUnit, ability)
	local nRadius = 600

	if J.IsRetreating(bot)
    then
		if #nEnemyHeroes > 0
        then
			for _, enemy in pairs(nEnemyHeroes)
            do
                if J.IsValidHero(enemy)
                and J.IsInRange(hMinionUnit, enemy, nRadius)
                and (J.IsSuspiciousIllusion(enemy) and enemy:HasModifier('modifier_arc_warden_tempest_double')
                    or J.IsSuspiciousIllusion(enemy) and enemy:GetUnitName() == 'npc_dota_hero_chaos_knight'
                    or not J.IsSuspiciousIllusion(enemy))
                and not U.CantMove(enemy)
                and bot:WasRecentlyDamagedByHero(enemy, 3.0)
                then
                    return BOT_ACTION_DESIRE_HIGH, 'none'
                end
			end
		end
    end

    if J.IsGoingOnSomeone(bot)
    or bot:GetActiveMode() == BOT_MODE_DEFEND_ALLY
    then
        if J.IsValidHero(botTarget)
        and J.IsInRange(hMinionUnit, botTarget, nRadius)
        and not J.IsSuspiciousIllusion(botTarget)
        and not U.CantMove(botTarget)
        then
            return BOT_ACTION_DESIRE_HIGH, 'none'
        end
    end

	return BOT_ACTION_DESIRE_NONE, ''
end

-- Cast Spells

X.ConsiderSpellUsage['enraged_wildkin_tornado'] = function (hMinionUnit, ability)
    return BOT_ACTION_DESIRE_NONE, nil, ''
end

X.ConsiderSpellUsage['enraged_wildkin_hurricane'] = function (hMinionUnit, ability)
    return BOT_ACTION_DESIRE_NONE, nil, ''
end

X.ConsiderSpellUsage['polar_furbolg_ursa_warrior_thunder_clap'] = function (hMinionUnit, ability)
    return BOT_ACTION_DESIRE_NONE, nil, ''
end

X.ConsiderSpellUsage['ogre_bruiser_ogre_smash'] = function (hMinionUnit, ability)
    return BOT_ACTION_DESIRE_NONE, nil, ''
end

X.ConsiderSpellUsage['ogre_magi_frost_armor'] = function (hMinionUnit, ability)
    return BOT_ACTION_DESIRE_NONE, nil, ''
end

X.ConsiderSpellUsage['dark_troll_warlord_ensnare'] = function (hMinionUnit, ability)
    return BOT_ACTION_DESIRE_NONE, nil, ''
end

X.ConsiderSpellUsage['dark_troll_warlord_raise_dead'] = function (hMinionUnit, ability)
    return BOT_ACTION_DESIRE_NONE, nil, ''
end

X.ConsiderSpellUsage['mud_golem_hurl_boulder'] = function (hMinionUnit, ability)
    return BOT_ACTION_DESIRE_NONE, nil, ''
end

X.ConsiderSpellUsage['big_thunder_lizard_slam'] = function (hMinionUnit, ability)
    return BOT_ACTION_DESIRE_NONE, nil, ''
end

X.ConsiderSpellUsage['big_thunder_lizard_frenzy'] = function (hMinionUnit, ability)
    return BOT_ACTION_DESIRE_NONE, nil, ''
end

X.ConsiderSpellUsage['ice_shaman_incendiary_bomb'] = function (hMinionUnit, ability)
    return BOT_ACTION_DESIRE_NONE, nil, ''
end

X.ConsiderSpellUsage['black_dragon_fireball'] = function (hMinionUnit, ability)
    return BOT_ACTION_DESIRE_NONE, nil, ''
end

X.ConsiderSpellUsage['warpine_raider_seed_shot'] = function (hMinionUnit, ability)
    return BOT_ACTION_DESIRE_NONE, nil, ''
end

-- Vex
X.ConsiderSpellUsage['fel_beast_haunt'] = function (hMinionUnit, ability)
    local nCastRange = ability:GetCastRange()

    if J.IsGoingOnSomeone(bot)
    and J.IsInRange(bot, hMinionUnit, 1600)
    then
        if  J.IsValidTarget(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.CanCastOnTargetAdvanced(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_skeleton_king_reincarnation_scepter_active')
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget, 'unit'
        end
    end

    if J.IsRetreating(bot)
    and J.IsInRange(bot, hMinionUnit, 1600)
    then
        for _, enemyHero in pairs(nEnemyHeroes)
        do
            if  J.IsValidHero(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and J.IsChasingTarget(enemyHero, bot)
            and not J.IsDisabled(enemyHero)
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemyHero:HasModifier('modifier_skeleton_king_reincarnation_scepter_active')
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero, 'unit'
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil, ''
end

-- Take Off
X.ConsiderSpellUsage['harpy_scout_take_off'] = function (hMinionUnit, ability)
    if J.IsStuck(hMinionUnit)
    then
        if ability:GetToggleState() == false
        then
            return BOT_ACTION_DESIRE_HIGH, nil, 'none'
        else
            return BOT_ACTION_DESIRE_NONE, nil, 'none'
        end
    end

    if ability:GetToggleState() == true
    then
        return BOT_ACTION_DESIRE_HIGH, nil, 'none'
    end

    return BOT_ACTION_DESIRE_NONE, nil, ''
end

-- Chain Lightning
X.ConsiderSpellUsage['harpy_storm_chain_lightning'] = function (hMinionUnit, ability)
    local nCastRange = ability:GetCastRange()
    local nDamage = ability:GetSpecialValueInt('initial_damage')
    local nJumpDist = ability:GetSpecialValueInt('jump_range')

    for _, enemyHero in pairs(nEnemyHeroes)
    do
        if  J.IsValidHero(enemyHero)
        and J.IsInRange(hMinionUnit, enemyHero, nCastRange)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanCastOnTargetAdvanced(enemyHero)
        and J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
        and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
        then
            return BOT_ACTION_DESIRE_HIGH, enemyHero, 'unit'
        end
    end

    if J.IsGoingOnSomeone(bot)
    and J.IsInRange(bot, hMinionUnit, 1600)
    then
        if  J.IsValidTarget(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.CanCastOnTargetAdvanced(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget, 'unit'
        end
    end

    if J.IsRetreating(bot)
    and J.IsInRange(bot, hMinionUnit, 1600)
    then
        for _, enemyHero in pairs(nEnemyHeroes)
        do
            if  J.IsValidHero(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and J.IsChasingTarget(enemyHero, bot)
            and not J.IsDisabled(enemyHero)
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero, 'unit'
            end
        end
    end

    if J.IsFarming(bot)
    and J.IsInRange(bot, hMinionUnit, 1600)
    then
        local nCreeps = bot:GetNearbyCreeps(1600, true)
        if  nCreeps ~= nil
        and ((#nCreeps >= 3)
            or (#nCreeps >= 2 and nCreeps[1]:IsAncientCreep()))
        and J.IsAttacking(bot)
        then
            for _, creep in pairs(nCreeps)
            do
                if  J.IsValid(creep)
                and J.CanBeAttacked(creep)
                then
                    local nCreepCountAround = J.GetNearbyAroundLocationUnitCount(true, false, nJumpDist, creep:GetLocation())
                    if nCreepCountAround >= 2
                    then
                        return BOT_ACTION_DESIRE_HIGH, creep, 'unit'
                    end
                end
            end
        end
    end

    if J.IsDoingRoshan(bot)
    then
        -- Remove Spell Block
        if  J.IsRoshan(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget, 'unit'
        end
    end

    if J.IsDoingTormentor(bot)
    then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget, 'unit'
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil, ''
end

return X