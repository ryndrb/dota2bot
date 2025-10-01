local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_troll_warlord'
then

local RI = require(GetScriptDirectory()..'/FunLib/util_role_item')

local sUtility = {}
local sUtilityItem = RI.GetBestUtilityItem(sUtility)

local HeroBuild = {
    ['pos_1'] = {
        [1] = {
            ['talent'] = {
                [1] = {
                    ['t25'] = {10, 0},
                    ['t20'] = {0, 10},
                    ['t15'] = {0, 10},
                    ['t10'] = {10, 0},
                }
            },
            ['ability'] = {
                [1] = {2,4,2,5,2,6,2,5,5,5,4,6,4,4,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_quelling_blade",
                "item_circlet",
                "item_slippers",
            
                "item_magic_wand",
                "item_phase_boots",
                "item_wraith_band",
                "item_bfury",--
                "item_yasha",
                "item_black_king_bar",--
                "item_sange_and_yasha",--
                "item_aghanims_shard",
                "item_basher",
                "item_satanic",--
                "item_abyssal_blade",--
                "item_ultimate_scepter_2",
                "item_travel_boots_2",--
                "item_moon_shard",
            },
            ['sell_list'] = {
                "item_magic_wand", "item_basher",
                "item_wraith_band", "item_satanic",
            },
        },
        [2] = {
            ['talent'] = {
                [1] = {
                    ['t25'] = {10, 0},
                    ['t20'] = {10, 0},
                    ['t15'] = {10, 0},
                    ['t10'] = {0, 10},
                }
            },
            ['ability'] = {
                [1] = {2,4,2,5,2,6,2,5,5,5,4,6,4,4,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_quelling_blade",
                "item_circlet",
                "item_slippers",
            
                "item_magic_wand",
                "item_phase_boots",
                "item_wraith_band",
                "item_maelstrom",
                "item_yasha",
                "item_black_king_bar",--
                "item_sange_and_yasha",--
                "item_aghanims_shard",
                "item_mjollnir",--
                "item_basher",
                "item_satanic",--
                "item_abyssal_blade",--
                "item_ultimate_scepter_2",
                "item_travel_boots_2",--
                "item_moon_shard",
            },
            ['sell_list'] = {
                "item_quelling_blade", "item_black_king_bar",
                "item_magic_wand", "item_basher",
                "item_wraith_band", "item_satanic",
            },
        },
    },
    ['pos_2'] = {
        [1] = {
            ['talent'] = {
                [1] = {},
            },
            ['ability'] = {
                [1] = {},
            },
            ['buy_list'] = {},
            ['sell_list'] = {},
        },
    },
    ['pos_3'] = {
        [1] = {
            ['talent'] = {
                [1] = {},
            },
            ['ability'] = {
                [1] = {},
            },
            ['buy_list'] = {},
            ['sell_list'] = {},
        },
    },
    ['pos_4'] = {
        [1] = {
            ['talent'] = {
                [1] = {},
            },
            ['ability'] = {
                [1] = {},
            },
            ['buy_list'] = {},
            ['sell_list'] = {},
        },
    },
    ['pos_5'] = {
        [1] = {
            ['talent'] = {
                [1] = {},
            },
            ['ability'] = {
                [1] = {},
            },
            ['buy_list'] = {},
            ['sell_list'] = {},
        },
    },
}

local sSelectedBuild = HeroBuild[sRole][RandomInt(1, #HeroBuild[sRole])]

local nTalentBuildList = J.Skill.GetTalentBuild(J.Skill.GetRandomBuild(sSelectedBuild.talent))
local nAbilityBuildList = J.Skill.GetRandomBuild(sSelectedBuild.ability)

X['sBuyList'] = sSelectedBuild.buy_list
X['sSellList'] = sSelectedBuild.sell_list

if J.Role.IsPvNMode() or J.Role.IsAllShadow() then X['sBuyList'], X['sSellList'] = { 'PvN_antimage' }, {} end

nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] = J.SetUserHeroInit( nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] )

X['sSkillList'] = J.Skill.GetSkillList( sAbilityList, nAbilityBuildList, sTalentList, nTalentBuildList )

X['bDeafaultAbility'] = false
X['bDeafaultItem'] = false

function X.MinionThink(hMinionUnit)
    Minion.MinionThink(hMinionUnit)
end

end

local BattleStance          = bot:GetAbilityByName('troll_warlord_switch_stance')
local WhirlingAxesRanged    = bot:GetAbilityByName('troll_warlord_whirling_axes_ranged')
local WhirlingAxesMelee     = bot:GetAbilityByName('troll_warlord_whirling_axes_melee')
-- local Fervor                = bot:GetAbilityByName('troll_warlord_fervor')
local BerserkersRage        = bot:GetAbilityByName('troll_warlord_berserkers_rage')
local BattleTrance          = bot:GetAbilityByName('troll_warlord_battle_trance')

local BattleStanceDesire
local WhirlingAxesRangedDesire, WhirlingAxesRangedLocation
local WhirlingAxesMeleeDesire
local BerserkersRageDesire
local BattleTranceDesire

local bRealInvisible = false
local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
    bot = GetBot()

    if J.CanNotUseAbility(bot) then return end

    BattleStance          = bot:GetAbilityByName('troll_warlord_switch_stance')
    WhirlingAxesRanged    = bot:GetAbilityByName('troll_warlord_whirling_axes_ranged')
    WhirlingAxesMelee     = bot:GetAbilityByName('troll_warlord_whirling_axes_melee')
    BattleTrance          = bot:GetAbilityByName('troll_warlord_battle_trance')

    bRealInvisible = J.IsRealInvisible(bot)
	bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    BattleTranceDesire = X.ConsiderBattleTrance()
    if BattleTranceDesire > 0 then
        bot:Action_UseAbility(BattleTrance)
        return
    end

    BattleStanceDesire = X.ConsiderBattleStance()
    if BattleStanceDesire > 0 then
        bot:Action_UseAbility(BattleStance)
        return
    end

    WhirlingAxesRangedDesire, WhirlingAxesRangedLocation = X.ConsiderWhirlingAxesRanged()
    if WhirlingAxesRangedDesire > 0 then
        bot:Action_UseAbilityOnLocation(WhirlingAxesRanged, WhirlingAxesRangedLocation)
        return
    end

    WhirlingAxesMeleeDesire = X.ConsiderWhirlingAxesMelee()
    if WhirlingAxesMeleeDesire > 0 then
        bot:Action_UseAbility(WhirlingAxesMelee)
        return
    end
end

function X.ConsiderBattleStance()
    if not J.CanCastAbility(BattleStance) then
        return BOT_ACTION_DESIRE_NONE
    end

    local nBonusMS = BattleStance:GetSpecialValueInt('bonus_move_speed')
    local bToggleState = BattleStance:GetToggleState()

    if J.IsGoingOnSomeone(bot) then
		if J.IsValidTarget(botTarget)
        and not J.IsSuspiciousIllusion(botTarget)
		then
            if  J.IsChasingTarget(bot, botTarget)
            and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
            then
                if bToggleState == false then
                    return BOT_ACTION_DESIRE_HIGH
                else
                    return BOT_ACTION_DESIRE_NONE
                end
            else
                if bAttacking
                and J.IsInRange(bot, botTarget, 300)
                and not J.IsChasingTarget(botTarget)
                and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
                then
                    if bToggleState == false then
                        return BOT_ACTION_DESIRE_HIGH
                    else
                        return BOT_ACTION_DESIRE_NONE
                    end
                end
            end
		end
	end

    if J.IsRetreating(bot) and not bRealInvisible and bot:WasRecentlyDamagedByAnyHero(3.0) then
        for _, enemyHero in ipairs(nEnemyHeroes) do
            if J.IsValidHero(enemyHero)
            and not J.IsSuspiciousIllusion(enemyHero)
            then
                local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), 1200)
                local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1200)
                if (#nInRangeEnemy > #nInRangeAlly) or J.IsChasingTarget(enemyHero, bot) then
                    if  enemyHero:GetCurrentMovementSpeed() > bot:GetCurrentMovementSpeed()
                    and enemyHero:GetCurrentMovementSpeed() < bot:GetCurrentMovementSpeed() + nBonusMS
                    then
                        if bToggleState == false then
                            return BOT_ACTION_DESIRE_HIGH
                        else
                            return BOT_ACTION_DESIRE_NONE
                        end
                    end
                end
            end
        end
    end

	if J.IsPushing(bot) then
		if nEnemyHeroes ~= nil and #nEnemyHeroes == 0 then
            if bToggleState == false then
                return BOT_ACTION_DESIRE_HIGH
            else
                return BOT_ACTION_DESIRE_NONE
            end
        else
            if bToggleState == true then
                return BOT_ACTION_DESIRE_HIGH
            else
                return BOT_ACTION_DESIRE_NONE
            end
        end
	end

    if J.IsFarming(bot) then
        if bToggleState == false then
            return BOT_ACTION_DESIRE_HIGH
        else
            return BOT_ACTION_DESIRE_NONE
        end
	end

	if J.IsLaning(bot) then
		local nNearbyEnemyFurthestRange = 0
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero) and not J.IsSuspiciousIllusion(enemyHero) then
                local enemyAttackRange = enemyHero:GetAttackRange()
                if enemyAttackRange > nNearbyEnemyFurthestRange then
                    nNearbyEnemyFurthestRange = enemyHero:GetAttackRange()
                end
            end
		end

		if nNearbyEnemyFurthestRange < 324 then
            if bToggleState == false then
                return BOT_ACTION_DESIRE_HIGH
            else
                return BOT_ACTION_DESIRE_NONE
            end
        end

		if nNearbyEnemyFurthestRange > 324 then
            if bToggleState == true then
                return BOT_ACTION_DESIRE_HIGH
            else
                return BOT_ACTION_DESIRE_NONE
            end
		end
	end

    if bToggleState == false then
        return BOT_ACTION_DESIRE_HIGH
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderWhirlingAxesRanged()
    if not J.CanCastAbility(WhirlingAxesRanged) then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nCastRange = J.GetProperCastRange(false, bot, WhirlingAxesRanged:GetCastRange())
    local nCastPoint = WhirlingAxesRanged:GetCastPoint()
    local nRadius = WhirlingAxesRanged:GetSpecialValueInt('axe_width')
    local nSpeed = WhirlingAxesRanged:GetSpecialValueInt('axe_speed')
    local nDamage = WhirlingAxesRanged:GetSpecialValueInt('axe_damage')
    local nManaCost = WhirlingAxesRanged:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {WhirlingAxesMelee, BattleStance})
    local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {WhirlingAxesRanged, WhirlingAxesMelee, BattleStance})

    for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        and J.CanCastOnNonMagicImmune(enemyHero)
        then
            local eta = (GetUnitToUnitDistance(bot, enemyHero) / nSpeed) + nCastPoint
            local vLocation = J.GetCorrectLoc(enemyHero, eta)
            if GetUnitToLocationDistance(bot, vLocation) <= nCastRange then
                if J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL, eta)
                and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
                and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
                and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
                and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
                and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
                then
                    return BOT_ACTION_DESIRE_HIGH, vLocation
                end
            end
        end
    end

    if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsChasingTarget(bot, botTarget)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
		then
            local eta = (GetUnitToUnitDistance(bot, botTarget) / nSpeed) + nCastPoint
            local vLocation = J.GetCorrectLoc(botTarget, eta)
            if GetUnitToLocationDistance(bot, vLocation) <= nCastRange then
                return BOT_ACTION_DESIRE_HIGH, vLocation
            end
		end
	end

	if J.IsRetreating(bot) and not bRealInvisible and bot:WasRecentlyDamagedByAnyHero(3.0) then
        for _, enemyHero in ipairs(nEnemyHeroes) do
            if J.IsValidHero(enemyHero)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            then
                if (#nEnemyHeroes > #nAllyHeroes and enemyHero:GetAttackTarget() == bot)
                or (J.IsChasingTarget(enemyHero, bot))
                or (botHP < 0.5 and enemyHero:GetAttackTarget() == bot)
                then
                    return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
                end
            end
        end
	end

    local nEnemyCreeps = bot:GetNearbyCreeps(nCastRange, true)

	if J.IsPushing(bot) and fManaAfter > fManaThreshold2 and bAttacking and #nAllyHeroes <= 3 then
		for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 4) then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
	end

    if J.IsDefending(bot) and fManaAfter > fManaThreshold1 and bAttacking then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 4) then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end

        local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, nCastPoint, 0)
        if nLocationAoE.count >= 2 and fManaAfter > fManaThreshold2 then
            return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
        end
	end

    if J.IsFarming(bot) and fManaAfter > fManaThreshold1 and bAttacking then
		for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 3)
                or (nLocationAoE.count >= 2 and creep:IsAncientCreep())
                then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

    if J.IsLaning(bot) and J.IsInLaningPhase() and fManaAfter > fManaThreshold1 then
		for _, creep in pairs(nEnemyCreeps) do
			if  J.IsValid(creep)
            and J.CanBeAttacked(creep)
            and not J.IsRunning(creep)
			and (J.IsKeyWordUnit('ranged', creep) or J.IsKeyWordUnit('siege', creep) or J.IsKeyWordUnit('flagbearer', creep))
			then
                local eta = (GetUnitToUnitDistance(bot, creep) / nSpeed) + nCastPoint
                if J.WillKillTarget(creep, nDamage, DAMAGE_TYPE_MAGICAL, eta) then
                    local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), 0, nRadius, 0, 0)
                    if nLocationAoE.count > 0 or J.IsUnitTargetedByTower(creep, false) then
                        return BOT_ACTION_DESIRE_HIGH, creep:GetLocation()
                    end
                end
			end
		end

        local nLocationAoE = bot:FindAoELocation(true, false, bot:GetLocation(), nCastRange, nRadius, nCastPoint, nDamage)
        if nLocationAoE.count >= 3 then
            return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
        end
	end

    if J.IsDoingRoshan(bot) then
        if  J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and bAttacking
        and fManaAfter > fManaThreshold1
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
    end

    if J.IsDoingTormentor(bot) then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and bAttacking
        and fManaAfter > fManaThreshold1
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderWhirlingAxesMelee()
    if not J.CanCastAbility(WhirlingAxesMelee) then
        return BOT_ACTION_DESIRE_NONE
    end

    local nRadius = WhirlingAxesMelee:GetSpecialValueInt('max_range')
    local nDamage = WhirlingAxesMelee:GetSpecialValueInt('damage')
    local nManaCost = WhirlingAxesMelee:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {WhirlingAxesMelee, BattleStance})
    local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {WhirlingAxesRanged, WhirlingAxesMelee, BattleStance})

    local nInRangeEnemy = bot:GetNearbyHeroes(nRadius, true, BOT_MODE_NONE)
    local nEnemyHeroesTargetingMe = J.GetHeroesTargetingUnit(nInRangeEnemy, bot)

    for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.IsInRange(bot, enemyHero, nRadius)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
        and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
        then
            if J.IsChasingTarget(bot, enemyHero) then
                if J.IsInRange(bot, enemyHero, nRadius / 2) then
                    return BOT_ACTION_DESIRE_HIGH
                end
            else
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    end

    if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
        and #nEnemyHeroesTargetingMe >= 1
		then
            return BOT_ACTION_DESIRE_HIGH
		end

        if #nEnemyHeroesTargetingMe >= 2 and botHP < 0.5 then
            return BOT_ACTION_DESIRE_HIGH
        end
	end

	if J.IsRetreating(bot) and not bRealInvisible and bot:WasRecentlyDamagedByAnyHero(5.0) then
        for _, enemyHero in ipairs(nEnemyHeroes) do
            if J.IsValidHero(enemyHero)
            and J.IsInRange(bot, enemyHero, nRadius)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and not J.IsSuspiciousIllusion(enemyHero)
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemyHero:HasModifier('modifier_troll_warlord_whirling_axes_slow')
            then
                if (#nEnemyHeroes > #nAllyHeroes and enemyHero:GetAttackTarget() == bot)
                or (J.IsChasingTarget(enemyHero, bot))
                or botHP < 0.5
                then
                    return BOT_ACTION_DESIRE_HIGH
                end
            end
        end
	end

    local nEnemyCreeps = bot:GetNearbyCreeps(nRadius, true)

	if (J.IsPushing(bot) and fManaAfter > fManaThreshold1 and #nAllyHeroes <= 2 and bAttacking)
    or (J.IsDefending(bot) and fManaAfter > fManaThreshold2 and #nAllyHeroes <= 3 and bAttacking)
    then
        if  J.IsValid(nEnemyCreeps[1])
        and J.CanBeAttacked(nEnemyCreeps[1])
        and not J.IsRunning(nEnemyCreeps[1])
        and #nEnemyCreeps >= 4
        then
            return BOT_ACTION_DESIRE_HIGH
        end
	end

    if J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold1 then
        if J.IsValid(nEnemyCreeps[1])
        and J.CanBeAttacked(nEnemyCreeps[1])
        and not J.IsRunning(nEnemyCreeps[1])
        and (#nEnemyCreeps >= 3 or (#nEnemyCreeps >= 2 and nEnemyCreeps[1]:IsAncientCreep()))
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsLaning(bot) and J.IsInLaningPhase() and fManaAfter > fManaThreshold1 then
        if #nEnemyCreeps >= 5 and bAttacking and #nEnemyHeroes == 0 then
            return BOT_ACTION_DESIRE_HIGH
        end

        local nLocationAoE = bot:FindAoELocation(true, false, bot:GetLocation(), 0, nRadius, 0, nDamage)
        if nLocationAoE.count >= 3 then
            return BOT_ACTION_DESIRE_HIGH
        end
	end

    if J.IsDoingRoshan(bot) then
        if  J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        and bAttacking
        and fManaAfter > fManaThreshold1
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsDoingTormentor(bot) then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        and bAttacking
        and fManaAfter > fManaThreshold1
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderBattleTrance()
    if not J.CanCastAbility(BattleTrance)
    or (bot:HasModifier('modifier_item_satanic_unholy') and botHP > 0.4)
    or not J.CanBeAttacked(bot)
    then
        return BOT_ACTION_DESIRE_NONE
    end

    local fDuration = BattleTrance:GetSpecialValueFloat('trance_duration')
    local nBonusAS = BattleTrance:GetSpecialValueInt('attack_speed')

    if J.IsGoingOnSomeone(bot) then
        if  J.IsValidTarget(nEnemyHeroes[1])
        and J.CanBeAttacked(nEnemyHeroes[1])
        and J.IsInRange(bot, nEnemyHeroes[1], 900)
        and not J.IsSuspiciousIllusion(nEnemyHeroes[1])
        and not nEnemyHeroes[1]:HasModifier('modifier_abaddon_borrowed_time')
        and not nEnemyHeroes[1]:HasModifier('modifier_dazzle_shallow_grave')
        and not nEnemyHeroes[1]:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not nEnemyHeroes[1]:HasModifier('modifier_necrolyte_reapers_scythe')
        and not nEnemyHeroes[1]:HasModifier('modifier_oracle_false_promise_timer')
        and not nEnemyHeroes[1]:HasModifier('modifier_item_blade_mail_reflect')
        then
            local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), 1200)
            local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1200)
            local totalAttackDamge = nEnemyHeroes[1]:GetActualIncomingDamage(bot:GetAttackDamage() * (bot:GetAttackSpeed() + nBonusAS / 100) * fDuration, DAMAGE_TYPE_PHYSICAL)

            if (totalAttackDamge >= (nEnemyHeroes[1]:GetHealth() + nEnemyHeroes[1]:GetHealthRegen() * fDuration) and not (#nInRangeAlly >= #nInRangeEnemy + 2))
            or (#nInRangeEnemy >= #nInRangeAlly + 2 and J.IsInTeamFight(bot, 1200) and botHP < 0.65)
            or botHP < 0.2
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
	end

    local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), 800)
    if J.IsRetreating(bot) and not bRealInvisible and bot:DistanceFromFountain() > 4500 then
        local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 800)
        local nEnemyHeroesTargetingMeCount = #J.GetHeroesTargetingUnit(nInRangeEnemy, bot)

        if #nInRangeEnemy > #nInRangeAlly and botHP < 0.2 and nEnemyHeroesTargetingMeCount >= 2 then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsDoingRoshan(bot) and bAttacking then
        if  J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, 700)
        and #nInRangeAlly >= 2
        and J.IsAttacking(nInRangeAlly[1])
        and J.IsAttacking(nInRangeAlly[2])
        and (not J.IsLateGame() or (botHP < 0.25 and J.GetHP(botTarget) > 0.5 and botTarget:GetAttackTarget() == bot))
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsDoingTormentor(bot) and bAttacking then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, 700)
        and botHP < 0.25
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

return X