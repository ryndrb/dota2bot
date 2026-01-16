local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local U = require(GetScriptDirectory()..'/FunLib/MinionLib/utils')
local I = dofile(GetScriptDirectory()..'/FunLib/MinionLib/illusions')

local X = {}

X.ConsiderSpellUsage = {}

local bot

local botHP, botTarget, bAttacking
local minionHP, nAllyHeroes, nEnemyHeroes

local SPELL_TARGET_TYPE_NONE    = 0
local SPELL_TARGET_TYPE_UNIT    = 1
local SPELL_TARGET_TYPE_POINT   = 2

function X.Think(ownerBot, hMinionUnit)
    bot = ownerBot

	if not J.IsValid(hMinionUnit) or J.CanNotUseAbility(hMinionUnit) then return end

    bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    minionHP = J.GetHP(hMinionUnit)
    nAllyHeroes = hMinionUnit:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = hMinionUnit:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    local nDesire, hTarget, nCastType = 0, nil, -1

    for i = 0, 5 do
        local hAbility = hMinionUnit:GetAbilityInSlot(i)
        if J.CanCastAbility(hAbility) then
            local sAbilityName = hAbility:GetName()

            if J.CheckBitfieldFlag(hAbility:GetBehavior(), ABILITY_BEHAVIOR_UNIT_TARGET) then
                nDesire, hTarget = X.ConsiderUnitTarget(hMinionUnit, hAbility)
                if nDesire > 0 then
                    hMinionUnit:Action_UseAbilityOnEntity(hAbility, hTarget)
                    return
                end
            end

            local spellFunction = X.ConsiderSpellUsage[sAbilityName]
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
                    end
                end
            end
        end
    end

    -- Attack, Move
    -- TODO: Personalize for select minions.
	I.Think(bot, hMinionUnit)
end

function X.ConsiderUnitTarget(hMinionUnit, ability)
	local nCastRange = ability:GetCastRange()

    -- break linken
    for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemyHero)
        and J.IsInRange(hMinionUnit, enemyHero, nCastRange)
        and (enemyHero:HasModifier('modifier_item_sphere_target') or enemyHero:HasModifier('modifier_mirror_shield_delay'))
        then
            return BOT_ACTION_DESIRE_HIGH, enemyHero
        end
    end

	return BOT_ACTION_DESIRE_NONE, nil
end

-- Heal
X.ConsiderSpellUsage['forest_troll_high_priest_heal'] = function (hMinionUnit, ability)

    local nCastRange = ability:GetSpecialValueInt('AbilityCastRange')

    for _, allyHero in pairs(nAllyHeroes) do
        if J.IsValidHero(allyHero)
        and J.CanBeAttacked(allyHero)
        and J.IsInRange(hMinionUnit, allyHero, nCastRange)
        and not allyHero:IsIllusion()
        and not allyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and J.GetHP(allyHero) < 0.5
        then
            return BOT_ACTION_DESIRE_HIGH, allyHero, SPELL_TARGET_TYPE_UNIT
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

-- Vex
X.ConsiderSpellUsage['fel_beast_haunt'] = function (hMinionUnit, ability)

    local nCastRange = ability:GetCastRange()

    for i = 1, 5 do
        local allyHero =  GetTeamMember(i)

        if J.IsValidHero(allyHero) then
            local allyHeroTarget = J.GetProperTarget(allyHero)

            if J.IsGoingOnSomeone(allyHero) then
                if  J.IsValidHero(allyHeroTarget)
                and J.CanBeAttacked(allyHeroTarget)
                and J.IsInRange(hMinionUnit, allyHeroTarget, nCastRange)
                and J.CanCastOnNonMagicImmune(allyHeroTarget)
                and J.CanCastOnTargetAdvanced(allyHeroTarget)
                and not J.IsDisabled(allyHeroTarget)
                and not allyHeroTarget:IsSilenced()
                and not allyHeroTarget:HasModifier('modifier_necrolyte_reapers_scythe')
                then
                    return BOT_ACTION_DESIRE_HIGH, allyHeroTarget, SPELL_TARGET_TYPE_UNIT
                end
            end

            if J.IsRetreating(allyHero) and not J.IsRealInvisible(allyHero) then
                for _, enemyHero in pairs(nEnemyHeroes) do
                    if  J.IsValidHero(enemyHero)
                    and J.CanBeAttacked(enemyHero)
                    and J.IsInRange(hMinionUnit, enemyHero, nCastRange)
                    and J.CanCastOnNonMagicImmune(enemyHero)
                    and J.CanCastOnTargetAdvanced(enemyHero)
                    and not J.IsDisabled(enemyHero)
                    and allyHero:WasRecentlyDamagedByHero(enemyHero, 3.0)
                    and enemyHero:IsFacingLocation(allyHero:GetLocation(), 20)
                    then
                        return BOT_ACTION_DESIRE_HIGH, enemyHero, SPELL_TARGET_TYPE_UNIT
                    end
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

-- Chain Lightning
X.ConsiderSpellUsage['harpy_storm_chain_lightning'] = function (hMinionUnit, ability)

    local nCastRange = ability:GetCastRange()
    local nDamage = ability:GetSpecialValueInt('initial_damage')
    local nJumpDist = ability:GetSpecialValueInt('jump_range')

    for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
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
            return BOT_ACTION_DESIRE_HIGH, enemyHero, SPELL_TARGET_TYPE_UNIT
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
                and not J.IsDisabled(allyHeroTarget)
                and not allyHeroTarget:HasModifier('modifier_abaddon_borrowed_time')
                and not allyHeroTarget:HasModifier('modifier_dazzle_shallow_grave')
                and not allyHeroTarget:HasModifier('modifier_necrolyte_reapers_scythe')
                and not allyHeroTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
                then
                    return BOT_ACTION_DESIRE_HIGH, allyHeroTarget, SPELL_TARGET_TYPE_UNIT
                end
            end

            if bot == allyHero and J.IsInRange(bot, hMinionUnit, 1600) then
                local nEnemyCreeps = allyHero:GetNearbyCreeps(nCastRange, true)

                if J.IsPushing(bot) and #nAllyHeroes <= 2 and bAttacking and #nEnemyHeroes == 0 then
                    for _, creep in pairs(nEnemyCreeps) do
                        if J.IsValid(creep) and J.CanBeAttacked(creep) then
                            local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nJumpDist, 0, 0)
                            if (nLocationAoE.count >= 4) then
                                return BOT_ACTION_DESIRE_HIGH, creep, SPELL_TARGET_TYPE_UNIT
                            end
                        end
                    end
                end

                if J.IsDefending(bot) and bAttacking then
                    for _, creep in pairs(nEnemyCreeps) do
                        if J.IsValid(creep) and J.CanBeAttacked(creep) then
                            local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nJumpDist, 0, 0)
                            if (nLocationAoE.count >= 4) then
                                return BOT_ACTION_DESIRE_HIGH, creep, SPELL_TARGET_TYPE_UNIT
                            end
                        end
                    end
                end

                if J.IsFarming(bot) and bAttacking  then
                    for _, creep in pairs(nEnemyCreeps) do
                        if J.IsValid(creep) and J.CanBeAttacked(creep) then
                            local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nJumpDist, 0, 0)
                            if (nLocationAoE.count >= 3)
                            or (nLocationAoE.count >= 2 and creep:IsAncientCreep())
                            or (nLocationAoE.count >= 1 and creep:GetHealth() >= 500)
                            then
                                return BOT_ACTION_DESIRE_HIGH, creep, SPELL_TARGET_TYPE_UNIT
                            end
                        end
                    end
                end
            end

            if J.IsDoingRoshan(allyHero) then
                if  J.IsRoshan(allyHeroTarget)
                and J.CanBeAttacked(allyHeroTarget)
                and J.IsInRange(hMinionUnit, allyHeroTarget, 1200)
                and J.CanCastOnNonMagicImmune(allyHeroTarget)
                and J.IsAttacking(allyHero)
                then
                    return BOT_ACTION_DESIRE_HIGH, allyHeroTarget, SPELL_TARGET_TYPE_UNIT
                end
            end

            if J.IsDoingTormentor(allyHero) then
                if  J.IsTormentor(allyHeroTarget)
                and J.IsInRange(hMinionUnit, allyHeroTarget, 1200)
                and J.IsAttacking(allyHero)
                then
                    return BOT_ACTION_DESIRE_HIGH, allyHeroTarget, SPELL_TARGET_TYPE_UNIT
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

-- Take Off
X.ConsiderSpellUsage['harpy_scout_take_off'] = function (hMinionUnit, ability)

    local bIsToggled = ability:GetToggleState()

    if J.IsStuck(hMinionUnit) then
        if not bIsToggled then
            return BOT_ACTION_DESIRE_HIGH, nil, SPELL_TARGET_TYPE_NONE
        else
            return BOT_ACTION_DESIRE_NONE
        end
    end

    if bIsToggled then
        return BOT_ACTION_DESIRE_HIGH, nil, SPELL_TARGET_TYPE_NONE
    end

    return BOT_ACTION_DESIRE_NONE
end

-- War Stomp
X.ConsiderSpellUsage['centaur_khan_war_stomp'] = function (hMinionUnit, ability)

    local nRadius = ability:GetSpecialValueInt('radius')

    for _, enemyHero in pairs(nEnemyHeroes) do
        if J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.IsInRange(bot, enemyHero, nRadius)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and enemyHero:IsChanneling()
        then
            return BOT_ACTION_DESIRE_HIGH, nil, SPELL_TARGET_TYPE_NONE
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
                and J.IsInRange(hMinionUnit, allyHeroTarget, nRadius)
                and J.CanCastOnNonMagicImmune(allyHeroTarget)
                and not J.IsDisabled(allyHeroTarget)
                and not allyHeroTarget:HasModifier('modifier_abaddon_borrowed_time')
                and not allyHeroTarget:HasModifier('modifier_dazzle_shallow_grave')
                and not allyHeroTarget:HasModifier('modifier_necrolyte_reapers_scythe')
                then
                    return BOT_ACTION_DESIRE_HIGH, nil, SPELL_TARGET_TYPE_NONE
                end
            end

            if J.IsRetreating(allyHero) and not J.IsRealInvisible(allyHero) then
                for _, enemyHero in pairs(nEnemyHeroes) do
                    if  J.IsValidHero(enemyHero)
                    and J.CanBeAttacked(enemyHero)
                    and J.IsInRange(allyHero, enemyHero, 1200)
                    and J.IsInRange(hMinionUnit, enemyHero, nRadius)
                    and J.CanCastOnNonMagicImmune(enemyHero)
                    and not J.IsDisabled(enemyHero)
                    and allyHero:WasRecentlyDamagedByHero(enemyHero, 3.0)
                    then
                        return BOT_ACTION_DESIRE_HIGH, nil, SPELL_TARGET_TYPE_NONE
                    end
                end
            end
        end
    end

    if #nEnemyHeroes >= 2 and J.IsAttacking(hMinionUnit) then
        return BOT_ACTION_DESIRE_HIGH, nil, SPELL_TARGET_TYPE_NONE
    end

    return BOT_ACTION_DESIRE_NONE, nil, ''
end

-- Intimidate
X.ConsiderSpellUsage['giant_wolf_intimidate'] = function (hMinionUnit, ability)

    local nRadius = ability:GetSpecialValueInt('radius')

    for i = 1, 5 do
        local allyHero =  GetTeamMember(i)

        if J.IsValidHero(allyHero) then
            local allyHeroTarget = J.GetProperTarget(allyHero)

            if J.IsGoingOnSomeone(allyHero) then
                if  J.IsValidHero(allyHeroTarget)
                and J.CanBeAttacked(allyHeroTarget)
                and J.IsInRange(allyHero, allyHeroTarget, 1600)
                and J.IsInRange(hMinionUnit, allyHeroTarget, nRadius)
                and J.CanCastOnNonMagicImmune(allyHeroTarget)
                and not J.IsDisabled(allyHeroTarget)
                and not allyHeroTarget:HasModifier('modifier_necrolyte_reapers_scythe')
                then
                    return BOT_ACTION_DESIRE_HIGH, nil, SPELL_TARGET_TYPE_NONE
                end
            end

            if J.IsRetreating(allyHero) and not J.IsRealInvisible(allyHero) then
                for _, enemyHero in pairs(nEnemyHeroes) do
                    if  J.IsValidHero(enemyHero)
                    and J.CanBeAttacked(enemyHero)
                    and J.IsInRange(allyHero, enemyHero, 1200)
                    and J.IsInRange(hMinionUnit, enemyHero, nRadius)
                    and J.CanCastOnNonMagicImmune(enemyHero)
                    and not J.IsDisabled(enemyHero)
                    and not enemyHero:IsDisarmed()
                    and allyHero:WasRecentlyDamagedByHero(enemyHero, 3.0)
                    then
                        return BOT_ACTION_DESIRE_HIGH, nil, SPELL_TARGET_TYPE_NONE
                    end
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

-- Mana Burn
X.ConsiderSpellUsage['satyr_soulstealer_mana_burn'] = function (hMinionUnit, ability)

    local nCastRange = ability:GetCastRange()

    for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.IsInRange(hMinionUnit, enemyHero, nCastRange + 300)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanCastOnTargetAdvanced(enemyHero)
        and J.GetMP(enemyHero) > 0.5
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        then
            return BOT_ACTION_DESIRE_HIGH, enemyHero, SPELL_TARGET_TYPE_UNIT
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

X.ConsiderSpellUsage['ogre_magi_frost_armor'] = function (hMinionUnit, ability)

    local nCastRange = ability:GetCastRange()

    for i = 1, 5 do
        local allyHero =  GetTeamMember(i)

        if J.IsValidHero(allyHero)
        and J.CanBeAttacked(allyHero)
        and J.IsInRange(hMinionUnit, allyHero, nCastRange + 300)
        and not allyHero:HasModifier('modifier_lich_frost_shield')
        and not allyHero:HasModifier('modifier_ogre_magi_frost_armor')
        then
            local allyHeroTarget = J.GetProperTarget(allyHero)
            local bIsInRange = J.IsInRange(hMinionUnit, allyHero, nCastRange)
			local nEnemyHeroesTargetingAlly = J.GetHeroesTargetingUnit(nEnemyHeroes, allyHero)

			if (#nEnemyHeroesTargetingAlly >= 2 and bIsInRange) then
				return BOT_ACTION_DESIRE_HIGH, allyHero, SPELL_TARGET_TYPE_UNIT
			end

			if J.IsGoingOnSomeone(allyHero) then
                if allyHero:WasRecentlyDamagedByAnyHero(2.0) then
                    return BOT_ACTION_DESIRE_HIGH, allyHero, SPELL_TARGET_TYPE_UNIT
                end
			end

			if J.IsRetreating(allyHero) and not J.IsRealInvisible(allyHero) then
				for _, enemyHero in pairs(nEnemyHeroes) do
					if J.IsValidHero(enemyHero)
					and J.CanCastOnNonMagicImmune(enemyHero)
					and J.IsInRange(allyHero, enemyHero, 1200)
					and allyHero:WasRecentlyDamagedByHero(enemyHero, 3.0)
                    and not J.IsDisabled(enemyHero)
                    and not enemyHero:IsDisarmed()
                    and allyHero:WasRecentlyDamagedByHero(enemyHero, 3.0)
					then
						return BOT_ACTION_DESIRE_HIGH, allyHero, SPELL_TARGET_TYPE_UNIT
					end
				end
			end

            if J.GetHP(allyHero) < 0.65 then
                if (bot:WasRecentlyDamagedByAnyHero(2.0))
                or (bot:WasRecentlyDamagedByTower(2.0))
                or (bot:WasRecentlyDamagedByCreep(2.0) and J.GetHP(allyHero) < 0.3)
                then
                    return BOT_ACTION_DESIRE_HIGH, allyHero, SPELL_TARGET_TYPE_UNIT
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

X.ConsiderSpellUsage['ogre_bruiser_ogre_smash'] = function (hMinionUnit, ability)

    local nRadius = ability:GetSpecialValueInt('radius')

    for i = 1, 5 do
        local allyHero =  GetTeamMember(i)

        if J.IsValidHero(allyHero) then
            local allyHeroTarget = J.GetProperTarget(allyHero)

            if J.IsGoingOnSomeone(allyHero) then
                if  J.IsValidHero(allyHeroTarget)
                and J.CanBeAttacked(allyHeroTarget)
                and J.IsInRange(allyHero, allyHeroTarget, 1600)
                and J.IsInRange(hMinionUnit, allyHeroTarget, nRadius)
                and J.CanCastOnNonMagicImmune(allyHeroTarget)
                and J.IsDisabled(allyHeroTarget)
                and not allyHeroTarget:HasModifier('modifier_necrolyte_reapers_scythe')
                then
                    return BOT_ACTION_DESIRE_HIGH, allyHeroTarget:GetLocation(), SPELL_TARGET_TYPE_POINT
                end
            end

            if J.IsRetreating(allyHero) and not J.IsRealInvisible(allyHero) then
                for _, enemyHero in pairs(nEnemyHeroes) do
                    if  J.IsValidHero(enemyHero)
                    and J.CanBeAttacked(enemyHero)
                    and J.IsInRange(allyHero, enemyHero, 1200)
                    and J.IsInRange(hMinionUnit, enemyHero, nRadius)
                    and J.CanCastOnNonMagicImmune(enemyHero)
                    and J.IsDisabled(enemyHero)
                    and allyHero:WasRecentlyDamagedByHero(enemyHero, 3.0)
                    then
                        return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation(), SPELL_TARGET_TYPE_POINT
                    end
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

-- Hurl Boulder
X.ConsiderSpellUsage['mud_golem_hurl_boulder'] = function (hMinionUnit, ability)

    local nCastRange = ability:GetCastRange()

    for _, enemyHero in pairs(nEnemyHeroes) do
        if J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.IsInRange(hMinionUnit, enemyHero, nCastRange)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanCastOnTargetAdvanced(enemyHero)
        and enemyHero:IsChanneling()
        then
            return BOT_ACTION_DESIRE_HIGH, enemyHero, SPELL_TARGET_TYPE_UNIT
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
                and not J.IsDisabled(allyHeroTarget)
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
                    and not J.IsDisabled(enemyHero)
                    and not enemyHero:IsDisarmed()
                    and allyHero:WasRecentlyDamagedByHero(enemyHero, 3.0)
                    then
                        return BOT_ACTION_DESIRE_HIGH, allyHeroTarget, SPELL_TARGET_TYPE_UNIT
                    end
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

-- Water Bubble (Small)
X.ConsiderSpellUsage['frogmen_water_bubble_small'] = function (hMinionUnit, ability)

    local nCastRange = ability:GetCastRange()

    for _, allyHero in pairs(nAllyHeroes) do
        if J.IsValidHero(allyHero)
        and J.CanBeAttacked(allyHero)
        and J.IsInRange(hMinionUnit, allyHero, nCastRange + 150)
        and not allyHero:IsIllusion()
        and not allyHero:IsMagicImmune()
        and not allyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        then
            if allyHero:WasRecentlyDamagedByAnyHero(2.0) then
                return BOT_ACTION_DESIRE_HIGH, allyHero, SPELL_TARGET_TYPE_UNIT
            end

            if J.IsStunProjectileIncoming(allyHero, 400)
            or J.IsUnitTargetProjectileIncoming(allyHero, 400)
            or (not allyHero:HasModifier('modifier_sniper_assassinate') and J.IsWillBeCastUnitTargetSpell(bot, 400))
            then
                return BOT_ACTION_DESIRE_HIGH, allyHero, SPELL_TARGET_TYPE_UNIT
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

-- Water Bubble (Medium)
X.ConsiderSpellUsage['frogmen_water_bubble_medium'] = function (hMinionUnit, ability)

    return X.ConsiderSpellUsage['frogmen_water_bubble_small'](hMinionUnit, ability)

end

-- Water Bubble (Large)
X.ConsiderSpellUsage['frogmen_water_bubble_large'] = function (hMinionUnit, ability)

    return X.ConsiderSpellUsage['frogmen_water_bubble_small'](hMinionUnit, ability)

end

-- Arm of the Deep
X.ConsiderSpellUsage['frogmen_arm_of_the_deep'] = function (hMinionUnit, ability)

    local nCastRange = ability:GetCastRange()
    local nDamage = ability:GetSpecialValueInt('damage')
    local nRadius = ability:GetSpecialValueInt('projectile_width')

    for _, enemyHero in pairs(nEnemyHeroes) do
        if J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.IsInRange(hMinionUnit, enemyHero, nCastRange)
        and J.CanCastOnNonMagicImmune(enemyHero)
        then
            if enemyHero:HasModifier('modifier_teleporting') then
                return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation(), SPELL_TARGET_TYPE_POINT
            end

            if J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation(), SPELL_TARGET_TYPE_POINT
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
                and not J.IsDisabled(allyHeroTarget)
                and not allyHeroTarget:HasModifier('modifier_abaddon_borrowed_time')
                and not allyHeroTarget:HasModifier('modifier_dazzle_shallow_grave')
                and not allyHeroTarget:HasModifier('modifier_necrolyte_reapers_scythe')
                then
                    return BOT_ACTION_DESIRE_HIGH, allyHeroTarget:GetLocation(), SPELL_TARGET_TYPE_POINT
                end
            end

            if J.IsRetreating(allyHero) and not J.IsRealInvisible(allyHero) then
                for _, enemyHero in pairs(nEnemyHeroes) do
                    if  J.IsValidHero(enemyHero)
                    and J.CanBeAttacked(enemyHero)
                    and J.IsInRange(allyHero, enemyHero, 1200)
                    and J.IsInRange(hMinionUnit, enemyHero, nCastRange)
                    and J.CanCastOnNonMagicImmune(enemyHero)
                    and not J.IsDisabled(enemyHero)
                    and not enemyHero:IsDisarmed()
                    and allyHero:WasRecentlyDamagedByHero(enemyHero, 3.0)
                    then
                        return BOT_ACTION_DESIRE_HIGH, allyHeroTarget:GetLocation(), SPELL_TARGET_TYPE_POINT
                    end
                end
            end
        end
    end

    local nLocationAoE = bot:FindAoELocation(true, true, hMinionUnit:GetLocation(), nCastRange, nRadius, 0, 0)
    if nLocationAoE.count >= 2 then
        return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, SPELL_TARGET_TYPE_POINT
    end

    nLocationAoE = bot:FindAoELocation(true, false, hMinionUnit:GetLocation(), nCastRange, nRadius, 0, nDamage)
    if nLocationAoE.count >= 3 and #nAllyHeroes <= 1 then
        return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, SPELL_TARGET_TYPE_POINT
    end

    return BOT_ACTION_DESIRE_NONE
end

-- Shockwave
X.ConsiderSpellUsage['satyr_hellcaller_shockwave'] = function (hMinionUnit, ability)

    local nCastRange = ability:GetCastRange()
    local nCastPoint = ability:GetCastPoint()
    local nSpeed = ability:GetSpecialValueInt('speed')
    local nDamage = ability:GetSpecialValueInt('#AbilityDamage')

    for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.IsInRange(hMinionUnit, enemyHero, nCastRange)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
        and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
        then
            local eta = (GetUnitToUnitDistance(hMinionUnit, enemyHero) / nSpeed) + nCastPoint
            if J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL, eta) then
                return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(hMinionUnit, eta), SPELL_TARGET_TYPE_POINT
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
                and not J.IsDisabled(allyHeroTarget)
                and not allyHeroTarget:HasModifier('modifier_abaddon_borrowed_time')
                and not allyHeroTarget:HasModifier('modifier_dazzle_shallow_grave')
                and not allyHeroTarget:HasModifier('modifier_necrolyte_reapers_scythe')
                then
                    local eta = (GetUnitToUnitDistance(hMinionUnit, allyHeroTarget) / nSpeed) + nCastPoint
                    return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(allyHeroTarget, eta), SPELL_TARGET_TYPE_POINT
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil, ''
end

-- Purge
X.ConsiderSpellUsage['satyr_trickster_purge'] = function (hMinionUnit, ability)

    local nCastRange = ability:GetCastRange()

    for i = 1, 5 do
        local allyHero =  GetTeamMember(i)

        if J.IsValidHero(allyHero) then
            local allyHeroTarget = J.GetProperTarget(allyHero)

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
                    return BOT_ACTION_DESIRE_HIGH, allyHero, SPELL_TARGET_TYPE_UNIT
                end
            end

            if J.IsGoingOnSomeone(allyHero) then
                if  J.IsValidHero(allyHeroTarget)
                and J.CanBeAttacked(allyHeroTarget)
                and J.IsInRange(allyHero, allyHeroTarget, 1600)
                and J.IsInRange(hMinionUnit, allyHeroTarget, nCastRange)
                and not J.IsInRange(allyHero, allyHeroTarget, allyHero:GetAttackRange())
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
                return BOT_ACTION_DESIRE_HIGH, enemyHero, SPELL_TARGET_TYPE_UNIT
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

-- Thunder Clap
X.ConsiderSpellUsage['polar_furbolg_ursa_warrior_thunder_clap'] = function (hMinionUnit, ability)

    local nRadius = ability:GetSpecialValueInt('radius')
    local nDamage = ability:GetSpecialValueInt('#AbilityDamage')

    for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.IsInRange(hMinionUnit, enemyHero, nRadius)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
        and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
        then
            return BOT_ACTION_DESIRE_HIGH, nil, SPELL_TARGET_TYPE_NONE
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
                and J.IsInRange(hMinionUnit, allyHeroTarget, nRadius)
                and J.CanCastOnNonMagicImmune(allyHeroTarget)
                and not J.IsDisabled(allyHeroTarget)
                and not allyHeroTarget:HasModifier('modifier_abaddon_borrowed_time')
                and not allyHeroTarget:HasModifier('modifier_dazzle_shallow_grave')
                and not allyHeroTarget:HasModifier('modifier_necrolyte_reapers_scythe')
                then
                    return BOT_ACTION_DESIRE_HIGH, nil, SPELL_TARGET_TYPE_NONE
                end
            end

            if J.IsRetreating(allyHero) and not J.IsRealInvisible(allyHero) then
                for _, enemyHero in pairs(nEnemyHeroes) do
                    if  J.IsValidHero(enemyHero)
                    and J.CanBeAttacked(enemyHero)
                    and J.IsInRange(allyHero, enemyHero, 1200)
                    and J.IsInRange(hMinionUnit, enemyHero, nRadius)
                    and J.CanCastOnNonMagicImmune(enemyHero)
                    and not J.IsDisabled(enemyHero)
                    and not enemyHero:IsDisarmed()
                    and allyHero:WasRecentlyDamagedByHero(enemyHero, 3.0)
                    then
                        return BOT_ACTION_DESIRE_HIGH, nil, SPELL_TARGET_TYPE_NONE
                    end
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

-- Hurricane
X.ConsiderSpellUsage['enraged_wildkin_hurricane'] = function (hMinionUnit, ability)

    local nCastRange = ability:GetCastRange()

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
                and not J.IsDisabled(allyHeroTarget)
                and not allyHeroTarget:HasModifier('modifier_necrolyte_reapers_scythe')
                then
                    return BOT_ACTION_DESIRE_HIGH, allyHeroTarget, SPELL_TARGET_TYPE_UNIT
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil, ''
end

-- Tornado
X.ConsiderSpellUsage['enraged_wildkin_tornado'] = function (hMinionUnit, ability)

    local nCastRange = ability:GetCastRange()

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
                and not J.IsDisabled(allyHeroTarget)
                and not allyHeroTarget:HasModifier('modifier_necrolyte_reapers_scythe')
                then
                    return BOT_ACTION_DESIRE_HIGH, allyHeroTarget:GetLocation(), SPELL_TARGET_TYPE_POINT
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

-- Raise Dead
X.ConsiderSpellUsage['dark_troll_warlord_raise_dead'] = function (hMinionUnit, ability)

    for i = 1, 5 do
        local allyHero =  GetTeamMember(i)

        if J.IsValidHero(allyHero) and J.IsInRange(hMinionUnit, allyHero, 1200) then
            local allyHeroTarget = J.GetProperTarget(allyHero)

            if J.IsGoingOnSomeone(allyHero) then
                if  J.IsValidHero(allyHeroTarget)
                and J.CanBeAttacked(allyHeroTarget)
                and J.IsInRange(allyHero, allyHeroTarget, allyHero:GetAttackRange() + 300)
                and not J.IsSuspiciousIllusion(allyHeroTarget)
                then
                    return BOT_ACTION_DESIRE_HIGH, nil, SPELL_TARGET_TYPE_NONE
                end
            end

            if J.IsPushing(allyHero) then
                if J.IsValidBuilding(allyHeroTarget)
                and J.CanBeAttacked(allyHeroTarget)
                and not string.find(allyHeroTarget:GetUnitName(), 'fillers')
                then
                    return BOT_ACTION_DESIRE_HIGH, nil, SPELL_TARGET_TYPE_NONE
                end
            end

            if J.IsDoingRoshan(allyHero) then
                if J.IsRoshan(allyHeroTarget)
                and J.CanBeAttacked(allyHeroTarget)
                and J.IsInRange(allyHero, allyHeroTarget, 1200)
                and J.IsAttacking(allyHero)
                then
                    return BOT_ACTION_DESIRE_HIGH, nil, SPELL_TARGET_TYPE_NONE
                end
            end

            if J.IsDoingTormentor(allyHero) then
                if J.IsTormentor(botTarget)
                and J.IsInRange(allyHero, allyHeroTarget, 1200)
                and J.IsAttacking(allyHero)
                then
                    return BOT_ACTION_DESIRE_HIGH, nil, SPELL_TARGET_TYPE_NONE
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

-- Ensnare
X.ConsiderSpellUsage['dark_troll_warlord_ensnare'] = function (hMinionUnit, ability)

    local nCastRange = ability:GetCastRange()

    for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.IsInRange(hMinionUnit, enemyHero, nCastRange)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanCastOnTargetAdvanced(enemyHero)
        and enemyHero:IsChanneling()
        then
            return BOT_ACTION_DESIRE_HIGH, enemyHero, SPELL_TARGET_TYPE_UNIT
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
                and not allyHeroTarget:HasModifier('modifier_necrolyte_reapers_scythe')
                then
                    return BOT_ACTION_DESIRE_HIGH, allyHeroTarget, SPELL_TARGET_TYPE_UNIT
                end
            end

            if J.IsRetreating(allyHero) and not J.IsRealInvisible(allyHero) then
                for _, enemyHero in pairs(nEnemyHeroes) do
                    if J.IsValidHero(enemyHero)
                    and J.CanBeAttacked(enemyHero)
                    and J.IsInRange(allyHero, enemyHero, 1200)
                    and J.IsInRange(hMinionUnit, enemyHero, nCastRange)
                    and J.CanCastOnNonMagicImmune(enemyHero)
                    and J.CanCastOnTargetAdvanced(enemyHero)
                    and not J.IsDisabled(enemyHero)
                    and allyHero:WasRecentlyDamagedByHero(enemyHero, 3.0)
                    and enemyHero:IsFacingLocation(allyHero:GetLocation(), 25)
                    then
                        return BOT_ACTION_DESIRE_HIGH, enemyHero, SPELL_TARGET_TYPE_UNIT
                    end
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

-- Seed Shot
X.ConsiderSpellUsage['warpine_raider_seed_shot'] = function (hMinionUnit, ability)

    local nCastRange = ability:GetCastRange()
    local nDamage = ability:GetSpecialValueInt('damage')
    local nBounceRange = ability:GetSpecialValueInt('bounce_range')

    for _, enemyHero in pairs(nEnemyHeroes) do
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
            return BOT_ACTION_DESIRE_HIGH, enemyHero, SPELL_TARGET_TYPE_UNIT
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
                and not J.IsDisabled(allyHeroTarget)
                and not allyHeroTarget:HasModifier('modifier_abaddon_borrowed_time')
                and not allyHeroTarget:HasModifier('modifier_dazzle_shallow_grave')
                and not allyHeroTarget:HasModifier('modifier_necrolyte_reapers_scythe')
                then
                    local nLocationAoE = hMinionUnit:FindAoELocation(true, true, allyHeroTarget:GetLocation(), 0, nBounceRange, 0, 0)
                    if nLocationAoE.count >= 2 or J.IsChasingTarget(allyHero, allyHeroTarget) then
                        return BOT_ACTION_DESIRE_HIGH, allyHeroTarget, SPELL_TARGET_TYPE_UNIT
                    end

                    nLocationAoE = hMinionUnit:FindAoELocation(true, false, botTarget:GetLocation(), 0, nBounceRange, 0, 0)
                    if nLocationAoE.count >= 3 then
                        return BOT_ACTION_DESIRE_HIGH, allyHeroTarget, SPELL_TARGET_TYPE_UNIT
                    end
                end
            end

            if J.IsRetreating(allyHero) and not J.IsRealInvisible(allyHero) then
                for _, enemyHero in pairs(nEnemyHeroes) do
                    if J.IsValidHero(enemyHero)
                    and J.CanBeAttacked(enemyHero)
                    and J.IsInRange(allyHero, enemyHero, 1200)
                    and J.IsInRange(hMinionUnit, enemyHero, nCastRange)
                    and J.CanCastOnNonMagicImmune(enemyHero)
                    and J.CanCastOnTargetAdvanced(enemyHero)
                    and not J.IsDisabled(enemyHero)
                    and allyHero:WasRecentlyDamagedByHero(enemyHero, 3.0)
                    then
                        return BOT_ACTION_DESIRE_HIGH, enemyHero, SPELL_TARGET_TYPE_UNIT
                    end
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

-- Tendrils of the Deep
X.ConsiderSpellUsage['frogmen_tendrils_of_the_deep'] = function (hMinionUnit, ability)

    return X.ConsiderSpellUsage['frogmen_arm_of_the_deep'](hMinionUnit, ability)

end

-- Fireball
X.ConsiderSpellUsage['black_dragon_fireball'] = function (hMinionUnit, ability)

    local nCastRange = ability:GetCastRange()

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
                and not allyHeroTarget:HasModifier('modifier_abaddon_borrowed_time')
                and not allyHeroTarget:HasModifier('modifier_dazzle_shallow_grave')
                and not allyHeroTarget:HasModifier('modifier_necrolyte_reapers_scythe')
                then
                    if J.IsDisabled(allyHeroTarget) or not J.IsMoving(allyHeroTarget) or allyHeroTarget:IsChanneling() then
                        return BOT_ACTION_DESIRE_HIGH, allyHeroTarget:GetLocation(), SPELL_TARGET_TYPE_POINT
                    end
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

-- Slam
X.ConsiderSpellUsage['big_thunder_lizard_slam'] = function (hMinionUnit, ability)

    local nRadius = ability:GetSpecialValueInt('radius')

    for i = 1, 5 do
        local allyHero =  GetTeamMember(i)

        if J.IsValidHero(allyHero) then
            local allyHeroTarget = J.GetProperTarget(allyHero)

            if J.IsGoingOnSomeone(allyHero) then
                if  J.IsValidHero(allyHeroTarget)
                and J.CanBeAttacked(allyHeroTarget)
                and J.IsInRange(allyHero, allyHeroTarget, 1600)
                and J.IsInRange(hMinionUnit, allyHeroTarget, nRadius)
                and J.CanCastOnNonMagicImmune(allyHeroTarget)
                and not allyHeroTarget:HasModifier('modifier_abaddon_borrowed_time')
                and not allyHeroTarget:HasModifier('modifier_dazzle_shallow_grave')
                and not allyHeroTarget:HasModifier('modifier_necrolyte_reapers_scythe')
                then
                    return BOT_ACTION_DESIRE_HIGH, nil, SPELL_TARGET_TYPE_NONE
                end
            end

            if J.IsRetreating(allyHero) and not J.IsRealInvisible(allyHero) then
                for _, enemyHero in pairs(nEnemyHeroes) do
                    if J.IsValidHero(enemyHero)
                    and J.CanBeAttacked(enemyHero)
                    and J.IsInRange(allyHero, enemyHero, 1200)
                    and J.IsInRange(hMinionUnit, enemyHero, nRadius)
                    and J.CanCastOnNonMagicImmune(enemyHero)
                    and not J.IsDisabled(enemyHero)
                    and allyHero:WasRecentlyDamagedByHero(enemyHero, 3.0)
                    and enemyHero:IsFacingLocation(allyHero:GetLocation(), 25)
                    then
                        return BOT_ACTION_DESIRE_HIGH, nil, SPELL_TARGET_TYPE_NONE
                    end
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

-- Frenzy
X.ConsiderSpellUsage['big_thunder_lizard_frenzy'] = function (hMinionUnit, ability)

    local nCastRange = ability:GetCastRange()

    local target = nil
    local targetDamage = 0
    for _, allyHero in pairs(nAllyHeroes) do
        if J.IsValidHero(allyHero)
        and not allyHero:IsIllusion()
        and J.IsInRange(hMinionUnit, allyHero, nCastRange)
        and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not allyHero:HasModifier('modifier_teleporting')
        then
            if J.IsGoingOnSomeone(allyHero) then
                local allyHeroDamage = allyHero:GetAttackDamage() * allyHero:GetAttackSpeed()
                if allyHeroDamage > targetDamage then
                    target = allyHero
                    targetDamage = allyHeroDamage
                end
            end
        end
    end

    if target ~= nil then
        return BOT_ACTION_DESIRE_HIGH, target, SPELL_TARGET_TYPE_UNIT
    end

    return BOT_ACTION_DESIRE_NONE
end

-- Icefire Bomb
X.ConsiderSpellUsage['ice_shaman_incendiary_bomb'] = function (hMinionUnit, ability)

    local nCastRange = ability:GetCastRange()

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
                and not allyHeroTarget:HasModifier('modifier_abaddon_borrowed_time')
                and not allyHeroTarget:HasModifier('modifier_dazzle_shallow_grave')
                and not allyHeroTarget:HasModifier('modifier_necrolyte_reapers_scythe')
                then
                    return BOT_ACTION_DESIRE_HIGH, allyHeroTarget, SPELL_TARGET_TYPE_UNIT
                end
            end

            if J.IsPushing(allyHero) and J.IsAttacking(allyHero) then
                if J.IsValidBuilding(allyHeroTarget)
                and J.CanBeAttacked(allyHeroTarget)
                and J.IsInRange(hMinionUnit, allyHeroTarget, nCastRange + 300)
                and not allyHeroTarget:HasModifier('modifier_backdoor_protection_active')
                and not string.find(allyHeroTarget:GetUnitName(), 'fillers')
                then
                    return BOT_ACTION_DESIRE_HIGH, allyHeroTarget, SPELL_TARGET_TYPE_UNIT
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

-- Desecrate
X.ConsiderSpellUsage['spawnlord_master_stomp'] = function (hMinionUnit, ability)

    local nRadius = ability:GetSpecialValueInt('radius')

    for i = 1, 5 do
        local allyHero =  GetTeamMember(i)

        if J.IsValidHero(allyHero) then
            local allyHeroTarget = J.GetProperTarget(allyHero)

            if J.IsGoingOnSomeone(allyHero) then
                if  J.IsValidHero(allyHeroTarget)
                and J.CanBeAttacked(allyHeroTarget)
                and J.IsInRange(allyHero, allyHeroTarget, 1600)
                and J.IsInRange(hMinionUnit, allyHeroTarget, nRadius)
                and J.CanCastOnNonMagicImmune(allyHeroTarget)
                and not allyHeroTarget:HasModifier('modifier_abaddon_borrowed_time')
                and not allyHeroTarget:HasModifier('modifier_dazzle_shallow_grave')
                and not allyHeroTarget:HasModifier('modifier_necrolyte_reapers_scythe')
                then
                    return BOT_ACTION_DESIRE_HIGH, nil, SPELL_TARGET_TYPE_NONE
                end
            end

            if J.IsRetreating(allyHero) and not J.IsRealInvisible(allyHero) then
                for _, enemyHero in pairs(nEnemyHeroes) do
                    if J.IsValidHero(enemyHero)
                    and J.CanBeAttacked(enemyHero)
                    and J.IsInRange(allyHero, enemyHero, 1200)
                    and J.IsInRange(hMinionUnit, enemyHero, nRadius)
                    and J.CanCastOnNonMagicImmune(enemyHero)
                    and not J.IsDisabled(enemyHero)
                    and allyHero:WasRecentlyDamagedByHero(enemyHero, 3.0)
                    then
                        return BOT_ACTION_DESIRE_HIGH, nil, SPELL_TARGET_TYPE_NONE
                    end
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

-- Petrify
X.ConsiderSpellUsage['spawnlord_master_freeze'] = function (hMinionUnit, ability)

    local nCastRange = ability:GetCastRange()

    for i = 1, 5 do
        local allyHero =  GetTeamMember(i)

        if J.IsValidHero(allyHero) then
            local allyHeroTarget = J.GetProperTarget(allyHero)

            if J.IsGoingOnSomeone(allyHero) then
                if  J.IsValidHero(allyHeroTarget)
                and J.CanBeAttacked(allyHeroTarget)
                and J.IsInRange(allyHero, allyHeroTarget, 1600)
                and J.IsInRange(hMinionUnit, allyHeroTarget, nCastRange * 2)
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
                    if J.IsValidHero(enemyHero)
                    and J.CanBeAttacked(enemyHero)
                    and J.IsInRange(allyHero, enemyHero, 1200)
                    and J.IsInRange(hMinionUnit, enemyHero, nCastRange + 150)
                    and J.CanCastOnNonMagicImmune(enemyHero)
                    and J.CanCastOnTargetAdvanced(enemyHero)
                    and not J.IsDisabled(enemyHero)
                    and not enemyHero:IsDisarmed()
                    and allyHero:WasRecentlyDamagedByHero(enemyHero, 3.0)
                    then
                        return BOT_ACTION_DESIRE_HIGH, allyHeroTarget, SPELL_TARGET_TYPE_UNIT
                    end
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

-- Congregations of the Deep
X.ConsiderSpellUsage['frogmen_congregation_of_the_deep'] = function (hMinionUnit, ability)

    local nDamage = ability:GetSpecialValueInt('damage')
    local nRadius = ability:GetSpecialValueInt('range')

    for _, enemyHero in pairs(nEnemyHeroes) do
        if J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.IsInRange(hMinionUnit, enemyHero, nRadius)
        and J.CanCastOnNonMagicImmune(enemyHero)
        then
            if enemyHero:HasModifier('modifier_teleporting') then
                return BOT_ACTION_DESIRE_HIGH, nil, SPELL_TARGET_TYPE_NONE
            end

            if J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
            then
                return BOT_ACTION_DESIRE_HIGH, nil, SPELL_TARGET_TYPE_NONE
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
                and J.IsInRange(hMinionUnit, allyHeroTarget, nRadius)
                and J.CanCastOnNonMagicImmune(allyHeroTarget)
                and not J.IsDisabled(allyHeroTarget)
                and not allyHeroTarget:HasModifier('modifier_abaddon_borrowed_time')
                and not allyHeroTarget:HasModifier('modifier_dazzle_shallow_grave')
                and not allyHeroTarget:HasModifier('modifier_necrolyte_reapers_scythe')
                then
                    return BOT_ACTION_DESIRE_HIGH, nil, SPELL_TARGET_TYPE_NONE
                end
            end

            if J.IsRetreating(allyHero) and not J.IsRealInvisible(allyHero) then
                for _, enemyHero in pairs(nEnemyHeroes) do
                    if  J.IsValidHero(enemyHero)
                    and J.CanBeAttacked(enemyHero)
                    and J.IsInRange(allyHero, enemyHero, 1200)
                    and J.IsInRange(hMinionUnit, enemyHero, nRadius)
                    and J.CanCastOnNonMagicImmune(enemyHero)
                    and not J.IsDisabled(enemyHero)
                    and not enemyHero:IsDisarmed()
                    then
                        return BOT_ACTION_DESIRE_HIGH, nil, SPELL_TARGET_TYPE_NONE
                    end
                end
            end
        end
    end

    local nLocationAoE = bot:FindAoELocation(true, true, hMinionUnit:GetLocation(), 0, nRadius, 0, 0)
    if nLocationAoE.count >= 2 then
        return BOT_ACTION_DESIRE_HIGH, nil, SPELL_TARGET_TYPE_NONE
    end

    nLocationAoE = bot:FindAoELocation(true, false, hMinionUnit:GetLocation(), 0, nRadius, 0, nDamage)
    if nLocationAoE.count >= 4 and #nAllyHeroes <= 1 then
        return BOT_ACTION_DESIRE_HIGH, nil, SPELL_TARGET_TYPE_NONE
    end

    return BOT_ACTION_DESIRE_NONE
end

-- Purge (Book of the Dead)
X.ConsiderSpellUsage['necronomicon_archer_purge'] = function (hMinionUnit, ability)

    local nCastRange = ability:GetCastRange()

    for i = 1, 5 do
        local allyHero =  GetTeamMember(i)

        if J.IsValidHero(allyHero) then
            local allyHeroTarget = J.GetProperTarget(allyHero)

            if J.IsGoingOnSomeone(allyHero) then
                if  J.IsValidHero(allyHeroTarget)
                and J.CanBeAttacked(allyHeroTarget)
                and J.IsInRange(allyHero, allyHeroTarget, 1600)
                and J.IsInRange(hMinionUnit, allyHeroTarget, nCastRange)
                and not J.IsInRange(allyHero, allyHeroTarget, allyHero:GetAttackRange())
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
                return BOT_ACTION_DESIRE_HIGH, enemyHero, SPELL_TARGET_TYPE_UNIT
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

return X