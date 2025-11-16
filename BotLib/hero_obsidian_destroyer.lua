local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_obsidian_destroyer'
then

local RI = require(GetScriptDirectory()..'/FunLib/util_role_item')

local sUtility = {}
local sUtilityItem = RI.GetBestUtilityItem(sUtility)

local HeroBuild = {
    ['pos_1'] = {
        [1] = {
            ['talent'] = {
                [1] = {
                    ['t25'] = {0, 10},
                    ['t20'] = {10, 0},
                    ['t15'] = {10, 0},
                    ['t10'] = {10, 0},
                },
                [2] = {
                    ['t25'] = {10, 0},
                    ['t20'] = {10, 0},
                    ['t15'] = {10, 0},
                    ['t10'] = {10, 0},
                },
            },
            ['ability'] = {
                [1] = {2,1,3,2,2,6,2,1,1,1,6,3,3,3,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_faerie_fire",
                "item_double_circlet",
            
                "item_magic_wand",
                "item_double_null_talisman",
                "item_power_treads",
                "item_witch_blade",
                "item_force_staff",
                "item_hurricane_pike",--
                "item_black_king_bar",--
                "item_aghanims_shard",
                "item_devastator",--
                "item_sheepstick",--
                "item_shivas_guard",--
                "item_moon_shard",
                "item_ultimate_scepter_2",
                "item_travel_boots_2",--
            },
            ['sell_list'] = {
                "item_magic_wand", "item_black_king_bar",
                "item_null_talisman", "item_sheepstick",
                "item_null_talisman", "item_shivas_guard",
            },
        },
    },
    ['pos_2'] = {
        [1] = {
            ['talent'] = {
                [1] = {
                    ['t25'] = {0, 10},
                    ['t20'] = {10, 0},
                    ['t15'] = {10, 0},
                    ['t10'] = {10, 0},
                },
                [2] = {
                    ['t25'] = {10, 0},
                    ['t20'] = {10, 0},
                    ['t15'] = {10, 0},
                    ['t10'] = {10, 0},
                },
            },
            ['ability'] = {
                [1] = {2,1,3,2,2,6,2,1,1,1,6,3,3,3,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_faerie_fire",
                "item_double_mantle",
            
                "item_magic_wand",
                "item_double_null_talisman",
                "item_power_treads",
                "item_witch_blade",
                "item_force_staff",
                "item_hurricane_pike",--
                "item_black_king_bar",--
                "item_aghanims_shard",
                "item_devastator",--
                "item_sheepstick",--
                "item_shivas_guard",--
                "item_moon_shard",
                "item_ultimate_scepter_2",
                "item_travel_boots_2",--
            },
            ['sell_list'] = {
                "item_magic_wand", "item_black_king_bar",
                "item_null_talisman", "item_sheepstick",
                "item_null_talisman", "item_shivas_guard",
            },
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

if J.Role.IsPvNMode() or J.Role.IsAllShadow() then X['sBuyList'], X['sSellList'] = { 'PvN_mid' }, {} end

nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] = J.SetUserHeroInit( nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] )

X['sSkillList'] = J.Skill.GetSkillList( sAbilityList, nAbilityBuildList, sTalentList, nTalentBuildList )

X['bDeafaultAbility'] = false
X['bDeafaultItem'] = false

function X.MinionThink( hMinionUnit )

	if Minion.IsValidUnit( hMinionUnit )
	then
		Minion.IllusionThink( hMinionUnit )
	end
end

end

local ArcaneOrb             = bot:GetAbilityByName('obsidian_destroyer_arcane_orb')
local AstralImprisonment    = bot:GetAbilityByName('obsidian_destroyer_astral_imprisonment')
local EssenceFlux           = bot:GetAbilityByName('obsidian_destroyer_equilibrium')
local SanitysEclipse        = bot:GetAbilityByName('obsidian_destroyer_sanity_eclipse')

local ArcaneOrbDesire, ArcaneOrbTarget
local AstralImprisonmentDesire, AstralImprisonmentTarget
local SanitysEclipseDesire, SanitysEclipseLocation

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
    bot = GetBot()

    if J.CanNotUseAbility(bot) then return end

    ArcaneOrb             = bot:GetAbilityByName('obsidian_destroyer_arcane_orb')
    AstralImprisonment    = bot:GetAbilityByName('obsidian_destroyer_astral_imprisonment')
    EssenceFlux           = bot:GetAbilityByName('obsidian_destroyer_equilibrium')
    SanitysEclipse        = bot:GetAbilityByName('obsidian_destroyer_sanity_eclipse')

    bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    SanitysEclipseDesire, SanitysEclipseLocation = X.ConsiderSanitysEclipse()
    if SanitysEclipseDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(SanitysEclipse, SanitysEclipseLocation)
        return
    end

    AstralImprisonmentDesire, AstralImprisonmentTarget = X.ConsiderAstralImprisonment()
    if AstralImprisonmentDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(AstralImprisonment, AstralImprisonmentTarget)
        return
    end

    ArcaneOrbDesire, ArcaneOrbTarget = X.ConsiderArcaneOrb()
    if ArcaneOrbDesire > 0 then
        bot:Action_UseAbilityOnEntity(ArcaneOrb, ArcaneOrbTarget)
        return
    end
end

function X.ConsiderArcaneOrb()
    if not J.CanCastAbility(ArcaneOrb) then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local botAttackRange = bot:GetAttackRange()
    local nMul = ArcaneOrb:GetSpecialValueInt('mana_pool_damage_pct') / 100
    local nDamage = bot:GetAttackDamage() + bot:GetMana() * nMul
    local nAbilityLevel = ArcaneOrb:GetLevel()
    local bIsAutoCasted = ArcaneOrb:GetAutoCastState()
    local nManaCost = ArcaneOrb:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {AstralImprisonment, SanitysEclipse})

	if nAbilityLevel == 4 and not bIsAutoCasted then
        if EssenceFlux and EssenceFlux:IsTrained() and EssenceFlux:GetLevel() >= 2 then
            ArcaneOrb:ToggleAutoCast()
        end
	end

    if bIsAutoCasted then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    for _, enemyHero in pairs(nEnemyHeroes) do
        if J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.IsInRange(bot, enemyHero, botAttackRange + 300)
        and J.CanCastOnNonMagicImmune(enemyHero)
        then
            local eta = (GetUnitToUnitDistance(bot, enemyHero) / bot:GetAttackProjectileSpeed())
            if  J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL, eta)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
            and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero
            end
        end
    end

    if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, botAttackRange + 150)
        and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
            return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

    local nEnemyCreeps = bot:GetNearbyCreeps(botAttackRange + 300, true)

    if (J.IsPushing(bot) or J.IsDefending(bot) or J.IsFarming(bot)) and bAttacking and fManaAfter > fManaThreshold1 + 0.1 then
        if J.IsValid(botTarget) and J.CanBeAttacked(botTarget) and botTarget:IsCreep() then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

    if not J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
        if J.IsInLaningPhase() then
            for _, enemyHero in pairs(nEnemyHeroes) do
                if J.IsValidHero(enemyHero)
                and J.CanBeAttacked(enemyHero)
                and J.IsInRange(bot, enemyHero, botAttackRange + 150)
                and J.CanCastOnNonMagicImmune(enemyHero)
                then
                    return BOT_ACTION_DESIRE_HIGH, enemyHero
                end
            end
        end

        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and (J.IsCore(bot) or not J.IsOtherAllysTarget(creep)) then
                local eta = (GetUnitToUnitDistance(bot, creep) / bot:GetAttackProjectileSpeed())
                if J.WillKillTarget(creep, nDamage, DAMAGE_TYPE_MAGICAL, eta) then
                    return BOT_ACTION_DESIRE_HIGH, creep
                end
            end
        end
    end

    if J.IsDoingRoshan(bot) then
        if  J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, botAttackRange)
        and bAttacking
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

    if J.IsDoingTormentor(bot) then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, botAttackRange)
        and bAttacking
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderAstralImprisonment()
    if not J.CanCastAbility(AstralImprisonment) then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = AstralImprisonment:GetCastRange()
	local nDamage = AstralImprisonment:GetSpecialValueInt('damage')
    local nDuration = AstralImprisonment:GetSpecialValueInt('prison_duration')
    local nManaCost = AstralImprisonment:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {SanitysEclipse})


    if #nAllyHeroes > #nEnemyHeroes then
        if (J.GetAttackProjectileDamageByRange(bot, 800) > bot:GetHealth()) then
            return BOT_ACTION_DESIRE_HIGH, bot
        end

        if not bot:IsMagicImmune() then
            if (J.IsStunProjectileIncoming(bot, 600) and botHP < 0.2) then
                return BOT_ACTION_DESIRE_HIGH, bot
            end
        end
    end

    for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanCastOnTargetAdvanced(enemyHero)
        and fManaAfter > fManaThreshold1
        then
            if enemyHero:IsChanneling() then
                return BOT_ACTION_DESIRE_HIGH, enemyHero
            end

            local nAllyHeroesTargetingTarget = J.GetHeroesTargetingUnit(nAllyHeroes, enemyHero)

            if  J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
            and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
            and #nAllyHeroesTargetingTarget <= 1
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero
            end
        end
    end

	if J.IsInTeamFight(bot, 1200) and fManaAfter > fManaThreshold1 then
        for _, allyHero in pairs(nAllyHeroes) do
            if  J.IsValidHero(allyHero)
            and J.CanBeAttacked(allyHero)
            and not allyHero:IsIllusion()
            then
                if allyHero:HasModifier('modifier_enigma_black_hole_pull')
                or allyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
                or allyHero:HasModifier('modifier_legion_commander_duel')
                or allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
                or (J.GetHP(allyHero) < 0.33 and J.IsRetreating(allyHero))
                then
                    return BOT_ACTION_DESIRE_HIGH, allyHero
                end
            end
        end

        local hTarget = nil
        local hTargetDamage = 0
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange + 300)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and not J.IsDisabled(enemyHero)
            then
                if enemyHero:HasModifier('modifier_abaddon_borrowed_time')
                or enemyHero:HasModifier('modifier_dazzle_shallow_grave')
                then
                    return BOT_ACTION_DESIRE_HIGH, enemyHero
                end

                local enemyHeroDamage = enemyHero:GetEstimatedDamageToTarget(false, bot, 5.0, DAMAGE_TYPE_ALL)
                local nTotalAllyDamage = J.GetTotalEstimatedDamageToTarget(nAllyHeroes, enemyHero, 5.0)

                if enemyHeroDamage > hTargetDamage and nTotalAllyDamage < enemyHero:GetHealth() then
                    hTarget = enemyHero
                    hTargetDamage = enemyHeroDamage
                end
            end
        end

        if hTarget then
            return BOT_ACTION_DESIRE_HIGH, hTarget
        end
	end

    if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.CanCastOnTargetAdvanced(botTarget)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
        and fManaAfter > fManaThreshold1
		then
            local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), 800)
            local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 800)

            if not (#nInRangeAlly >= #nInRangeEnemy + 2) then
                if #nInRangeAlly <= 1 then
                    return BOT_ACTION_DESIRE_HIGH, botTarget
                end

                local nTotalDamage = 0
                for _, allyHero in pairs(nAllyHeroes) do
                    if  J.IsValidHero(allyHero)
                    and bot ~= allyHero
                    and not allyHero:IsIllusion()
                    and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
                    and (allyHero:GetAttackTarget() == botTarget or J.IsChasingTarget(allyHero, botTarget))
                    then
                        nTotalDamage = nTotalDamage + allyHero:GetEstimatedDamageToTarget(true, botTarget, nDuration, DAMAGE_TYPE_ALL)
                    end
                end

                if nTotalDamage * 1.25 < botTarget:GetHealth() then
                    return BOT_ACTION_DESIRE_HIGH, botTarget
                end
            end
		end
	end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if J.IsValidHero(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and not J.IsDisabled(enemyHero)
            and bot:WasRecentlyDamagedByHero(enemyHero, 5.0)
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero
            end
        end
    end

    if not J.IsRetreating(bot) and not J.IsRealInvisible(bot) and not J.IsInTeamFight(bot, 1200) and fManaAfter > fManaThreshold1 then
        for _, allyHero in pairs(nAllyHeroes) do
            if  J.IsValidHero(allyHero)
            and bot ~= allyHero
            and J.IsRetreating(allyHero)
            and not allyHero:IsIllusion()
            and allyHero:WasRecentlyDamagedByAnyHero(3.0)
            then
                for _, enemyHero in pairs(nEnemyHeroes) do
                    if J.IsValidHero(enemyHero)
                    and J.IsInRange(bot, enemyHero, nCastRange)
                    and J.CanCastOnNonMagicImmune(enemyHero)
                    and J.CanCastOnTargetAdvanced(enemyHero)
                    and not J.IsDisabled(enemyHero)
                    and allyHero:WasRecentlyDamagedByHero(enemyHero, 5.0)
                    and J.IsChasingTarget(enemyHero, allyHero)
                    then
                        return BOT_ACTION_DESIRE_HIGH, enemyHero
                    end
                end
            end
        end
    end

    if J.IsLaning(bot) and J.IsInLaningPhase() and fManaAfter > fManaThreshold1 then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange + 200)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and J.IsAttacking(enemyHero)
            and not J.IsDisabled(enemyHero)
            then
                local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), 800)
                local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 800)
                if not (#nInRangeAlly >= #nInRangeEnemy + 2) then
                    return BOT_ACTION_DESIRE_HIGH, enemyHero
                end
            end
        end
	end

    if J.IsDoingTormentor(bot) then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        then
            for _, allyHero in pairs(nAllyHeroes) do
                if  J.IsValidHero(allyHero)
                and J.GetHP(allyHero) < 0.3
                and not allyHero:IsIllusion()
                and not allyHero:HasModifier('modifier_abaddon_borrowed_time')
                and not allyHero:HasModifier('modifier_dazzle_shallow_grave')
                and not allyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
                then
                    return BOT_ACTION_DESIRE_HIGH, allyHero
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderSanitysEclipse()
    if not J.CanCastAbility(SanitysEclipse) then
        return BOT_ACTION_DESIRE_NONE, 0
    end

	local nCastRange = SanitysEclipse:GetCastRange()
    local nCastPoint = SanitysEclipse:GetCastPoint()
	local nMultiplier = SanitysEclipse:GetSpecialValueFloat('damage_multiplier')
    local nBaseDamage = SanitysEclipse:GetSpecialValueFloat('base_damage')

    if J.IsGoingOnSomeone(bot) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidTarget(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange + 300)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_enigma_black_hole_pull')
            and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
            and not enemyHero:HasModifier('modifier_legion_commander_duel')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
            then
                local eta = (GetUnitToUnitDistance(bot, enemyHero) / bot:GetCurrentMovementSpeed()) + nCastPoint
                local nManaDiff = math.abs(bot:GetMana() - enemyHero:GetMana())
                local nDamage = nManaDiff * nMultiplier

                if J.WillKillTarget(enemyHero, nBaseDamage + nDamage, DAMAGE_TYPE_MAGICAL, eta) then
                    return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
                end
            end
        end
	end

    return BOT_ACTION_DESIRE_NONE, 0
end

return X