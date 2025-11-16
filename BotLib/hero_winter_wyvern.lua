local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_winter_wyvern'
then

local RI = require(GetScriptDirectory()..'/FunLib/util_role_item')

local sUtility = {"item_heavens_halberd", "item_pipe", "item_lotus_orb"}
local sUtilityItem = RI.GetBestUtilityItem(sUtility)

local HeroBuild = {
    ['pos_1'] = {
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
    ['pos_2'] = {
        [1] = {
            ['talent'] = {
                [1] = {
                    ['t25'] = {10, 0},
                    ['t20'] = {10, 0},
                    ['t15'] = {10, 0},
                    ['t10'] = {10, 0},
                }
            },
            ['ability'] = {
                [1] = {2,1,2,1,2,6,2,1,1,3,6,3,3,3,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_faerie_fire",
                "item_circlet",
                "item_mantle",
            
                "item_bottle",
                "item_magic_wand",
                "item_power_treads",
                "item_null_talisman",
                "item_maelstrom",
                "item_witch_blade",
                "item_mjollnir",--
                "item_orchid",--
                "item_black_king_bar",--
                "item_devastator",--
                "item_ultimate_scepter",
                "item_hurricane_pike",--
                "item_ultimate_scepter_2",
                "item_bloodthorn",--
                "item_moon_shard",
                "item_travel_boots_2",--
            },
            ['sell_list'] = {
                "item_magic_wand", "item_orchid",
                "item_null_talisman", "item_black_king_bar",
                "item_bottle", "item_hurricane_pike",
            },
        },
    },
    ['pos_3'] = {
        [1] = {
            ['talent'] = {
                [1] = {
                    ['t25'] = {10, 0},
                    ['t20'] = {10, 0},
                    ['t15'] = {10, 0},
                    ['t10'] = {0, 10},
                }
            },
            ['ability'] = {
                [1] = {1,2,1,2,1,6,1,2,2,3,6,3,3,3,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_faerie_fire",
                "item_circlet",
                "item_mantle",
            
                "item_magic_wand",
                "item_power_treads",
                "item_null_talisman",
                "item_force_staff",
                "item_pipe",--
                "item_black_king_bar",--
                "item_hurricane_pike",--
                "item_ultimate_scepter",
                "item_bloodthorn",--
                "item_sheepstick",--
                "item_ultimate_scepter_2",
                "item_moon_shard",
                "item_travel_boots_2",--
            },
            ['sell_list'] = {
                "item_magic_wand", "item_ultimate_scepter",
                "item_null_talisman", "item_bloodthorn",
            },
        },
    },
    ['pos_4'] = {
        [1] = {
            ['talent'] = {
                [1] = {
                    ['t25'] = {10, 0},
                    ['t20'] = {10, 0},
                    ['t15'] = {10, 0},
                    ['t10'] = {0, 10},
                }
            },
            ['ability'] = {
                [1] = {1,2,2,3,2,6,2,1,1,1,6,3,3,3,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_blood_grenade",
                "item_magic_stick",
                "item_faerie_fire",
            
                "item_tranquil_boots",
                "item_magic_wand",
                "item_glimmer_cape",--
                "item_ancient_janggo",
                "item_solar_crest",--
                "item_boots_of_bearing",--
                "item_aghanims_shard",
                "item_sheepstick",--
                "item_octarine_core",--
                "item_shivas_guard",--
                "item_ultimate_scepter_2",
                "item_moon_shard",
            },
            ['sell_list'] = {
                "item_magic_wand", "item_shivas_guard",
            },
        },
    },
    ['pos_5'] = {
        [1] = {
            ['talent'] = {
                [1] = {
                    ['t25'] = {10, 0},
                    ['t20'] = {10, 0},
                    ['t15'] = {10, 0},
                    ['t10'] = {0, 10},
                }
            },
            ['ability'] = {
                [1] = {1,2,2,3,2,6,2,1,1,1,6,3,3,3,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_blood_grenade",
                "item_magic_stick",
                "item_faerie_fire",
            
                "item_arcane_boots",
                "item_magic_wand",
                "item_glimmer_cape",--
                "item_mekansm",
                "item_solar_crest",--
                "item_guardian_greaves",--
                "item_aghanims_shard",
                "item_sheepstick",--
                "item_octarine_core",--
                "item_shivas_guard",--
                "item_ultimate_scepter_2",
                "item_moon_shard",
            },
            ['sell_list'] = {
                "item_magic_wand", "item_shivas_guard",
            },
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

local ArcticBurn    = bot:GetAbilityByName('winter_wyvern_arctic_burn')
local SplinterBlast = bot:GetAbilityByName('winter_wyvern_splinter_blast')
local ColdEmbrace   = bot:GetAbilityByName('winter_wyvern_cold_embrace')
local WintersCurse  = bot:GetAbilityByName('winter_wyvern_winters_curse')

local ArcticBurnDesire
local SplinterBlastDesire, SplinterBlastTarget
local ColdEmbraceDesire, ColdEmbraceTarget
local WintersCurseDesire, WintersCurseTarget

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
    bot = GetBot()

	if J.CanNotUseAbility(bot) then return end

    ArcticBurn    = bot:GetAbilityByName('winter_wyvern_arctic_burn')
    SplinterBlast = bot:GetAbilityByName('winter_wyvern_splinter_blast')
    ColdEmbrace   = bot:GetAbilityByName('winter_wyvern_cold_embrace')
    WintersCurse  = bot:GetAbilityByName('winter_wyvern_winters_curse')

    bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    WintersCurseDesire, WintersCurseTarget = X.ConsiderWintersCurse()
    if WintersCurseDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(WintersCurse, WintersCurseTarget)
        return
    end

    ColdEmbraceDesire, ColdEmbraceTarget = X.ConsiderColdEmbrace()
    if ColdEmbraceDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(ColdEmbrace, ColdEmbraceTarget)
        return
    end

    SplinterBlastDesire, SplinterBlastTarget = X.ConsiderSplinterBlast()
    if SplinterBlastDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(SplinterBlast, SplinterBlastTarget)
        return
    end

    ArcticBurnDesire = X.ConsiderArcticBurn()
    if ArcticBurnDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(ArcticBurn)
        return
    end
end

function X.ConsiderArcticBurn()
    if not J.CanCastAbility(ArcticBurn) then
        return BOT_ACTION_DESIRE_NONE
    end

	local nBonusRange = ArcticBurn:GetSpecialValueInt('attack_range_bonus')
	local botAttackRange = bot:GetAttackRange() + nBonusRange
    local botMP = J.GetMP(bot)
    local nManaCost = ArcticBurn:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {SplinterBlast, ColdEmbrace, WintersCurse})

    local bHasScepter = bot:HasScepter()

	if not bHasScepter then
		if J.IsStuck(bot) then
			return BOT_ACTION_DESIRE_HIGH
		end

		if J.IsGoingOnSomeone(bot) then
			if  J.IsValidTarget(botTarget)
            and J.CanBeAttacked(botTarget)
            and J.CanCastOnNonMagicImmune(botTarget)
            and J.IsInRange(bot, botTarget, botAttackRange)
            and not J.IsDisabled(botTarget)
            and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
            and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
            and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
            and fManaAfter > fManaThreshold1
			then
                return BOT_ACTION_DESIRE_HIGH
			end
		end

        local nEnemyCreeps = bot:GetNearbyCreeps(Min(botAttackRange + 300, 1600), true)

        if J.IsPushing(bot) and bAttacking and fManaAfter > fManaThreshold1 + 0.15 and #nAllyHeroes <= 2 and #nEnemyHeroes == 0 then
            if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
                if (#nEnemyCreeps >= 3)
                or (#nEnemyCreeps >= 2 and nEnemyCreeps[1]:GetHealth() >= 550)
                then
                    return BOT_ACTION_DESIRE_HIGH
                end
            end
        end

        if J.IsDefending(bot) and bAttacking and fManaAfter > fManaThreshold1 then
            if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
                if (#nEnemyCreeps >= 3)
                or (#nEnemyCreeps >= 2 and nEnemyCreeps[1]:GetHealth() >= 550)
                then
                    return BOT_ACTION_DESIRE_HIGH
                end
            end
        end

        if J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold1 + 0.15 then
            if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
                if (#nEnemyCreeps >= 2)
                or (#nEnemyCreeps >= 1 and nEnemyCreeps[1]:IsAncientCreep())
                or (#nEnemyCreeps >= 1 and nEnemyCreeps[1]:GetHealth() >= 550)
                then
                    return BOT_ACTION_DESIRE_HIGH
                end
            end
        end

        if J.IsDoingRoshan(bot) then
            if  J.IsRoshan(botTarget)
            and J.CanBeAttacked(botTarget)
            and J.CanCastOnNonMagicImmune(botTarget)
            and J.IsInRange(bot, botTarget, botAttackRange)
            and bAttacking
            and fManaAfter > fManaThreshold1
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end

        if J.IsDoingTormentor(bot) then
            if  J.IsTormentor(botTarget)
            and J.IsInRange(bot, botTarget, botAttackRange)
            and bAttacking
            and fManaAfter > fManaThreshold1
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
	else
        local bIsToggled = ArcticBurn:GetToggleState()

		if J.IsStuck(bot) and not bIsToggled then
			return BOT_ACTION_DESIRE_HIGH
		end

		if J.IsGoingOnSomeone(bot) then
			if  J.IsValidTarget(botTarget)
            and J.CanBeAttacked(botTarget)
            and J.CanCastOnNonMagicImmune(botTarget)
            and J.IsInRange(bot, botTarget, botAttackRange)
            and not J.IsDisabled(botTarget)
            and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
            and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
            and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
			then
                if fManaAfter > fManaThreshold1 + 0.1 then
                    if not bIsToggled then
                        return BOT_ACTION_DESIRE_HIGH
                    else
                        return BOT_ACTION_DESIRE_NONE
                    end
                end
			end
		end

        local nEnemyCreeps = bot:GetNearbyCreeps(Min(botAttackRange + 300, 1600), true)

        if J.IsPushing(bot) and #nAllyHeroes <= 2 and #nEnemyHeroes == 0 then
            if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
                if (#nEnemyCreeps >= 3)
                or (#nEnemyCreeps >= 2 and nEnemyCreeps[1]:GetHealth() >= 550)
                then
                    if fManaAfter > fManaThreshold1 + 0.1 then
                        if not bIsToggled and bAttacking then
                            return BOT_ACTION_DESIRE_HIGH
                        else
                            return BOT_ACTION_DESIRE_NONE
                        end
                    end
                end
            end
        end

        if J.IsDefending(bot) then
            if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
                if (#nEnemyCreeps >= 3)
                or (#nEnemyCreeps >= 2 and nEnemyCreeps[1]:GetHealth() >= 550)
                then
                    if fManaAfter > fManaThreshold1 + 0.1 then
                        if not bIsToggled and bAttacking then
                            return BOT_ACTION_DESIRE_HIGH
                        else
                            return BOT_ACTION_DESIRE_NONE
                        end
                    end
                end
            end
        end

        if J.IsFarming(bot) then
            if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
                if (#nEnemyCreeps >= 2)
                or (#nEnemyCreeps >= 1 and nEnemyCreeps[1]:IsAncientCreep())
                or (#nEnemyCreeps >= 1 and nEnemyCreeps[1]:GetHealth() >= 550)
                then
                    if fManaAfter > fManaThreshold1 + 0.1 then
                        if not bIsToggled and bAttacking then
                            return BOT_ACTION_DESIRE_HIGH
                        else
                            return BOT_ACTION_DESIRE_NONE
                        end
                    end
                end
            end
        end

        if J.IsDoingRoshan(bot) then
            if  J.IsRoshan(botTarget)
            and J.CanBeAttacked(botTarget)
            and J.CanCastOnNonMagicImmune(botTarget)
            and J.IsInRange(bot, botTarget, botAttackRange)
            and fManaAfter > fManaThreshold1
            then
                if fManaAfter > fManaThreshold1 + 0.2 then
                    if not bIsToggled and bAttacking then
                        return BOT_ACTION_DESIRE_HIGH
                    else
                        return BOT_ACTION_DESIRE_NONE
                    end
                end
            end
        end

        if J.IsDoingTormentor(bot) then
            if  J.IsTormentor(botTarget)
            and J.IsInRange(bot, botTarget, botAttackRange)
            and bAttacking
            and fManaAfter > fManaThreshold1
            then
                if fManaAfter > fManaThreshold1 + 0.2 then
                    if not bIsToggled and bAttacking then
                        return BOT_ACTION_DESIRE_HIGH
                    else
                        return BOT_ACTION_DESIRE_NONE
                    end
                end
            end
        end

        if bIsToggled then
            return BOT_ACTION_DESIRE_HIGH
        end
	end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderSplinterBlast()
    if not J.CanCastAbility(SplinterBlast) then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = J.GetProperCastRange(false, bot, SplinterBlast:GetCastRange())
    local nCastPoint = SplinterBlast:GetCastPoint()
	local nDamage = SplinterBlast:GetSpecialValueInt('damage')
	local nRadius = SplinterBlast:GetSpecialValueInt('split_radius')
    local nSpeed = SplinterBlast:GetSpecialValueInt('projectile_speed')
    local nSplitTime = SplinterBlast:GetSpecialValueInt('projectile_max_time')
    local nManaCost = SplinterBlast:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {ArcticBurn, ColdEmbrace, WintersCurse})

    for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
        and not J.IsInRange(bot, enemyHero, nCastRange)
        and not J.IsSuspiciousIllusion(enemyHero)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
        and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
        then
            local eta = (GetUnitToUnitDistance(bot, enemyHero) / nSpeed) + nCastPoint + nSplitTime
            if J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL, eta) then
                local hTarget = X.GetNearestUnit(enemyHero, nCastRange, nRadius)
                if hTarget then
                    return BOT_ACTION_DESIRE_HIGH, hTarget
                end
            end
        end
    end

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
        and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
        and not botTarget:HasModifier('modifier_winter_wyvern_arctic_burn_slow')
		then
            local hTarget = X.GetNearestUnit(botTarget, nCastRange, nRadius)
            if hTarget then
                return BOT_ACTION_DESIRE_HIGH, hTarget
            end
		end
	end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and not J.IsDisabled(enemyHero)
            and not enemyHero:HasModifier('modifier_winter_wyvern_arctic_burn_slow')
            and bot:WasRecentlyDamagedByAnyHero(5.0)
            then
                local hTarget = X.GetNearestUnit(enemyHero, nCastRange, nRadius)
                if hTarget then
                    return BOT_ACTION_DESIRE_HIGH, hTarget
                end
            end
        end
    end

    local nEnemyCreeps = bot:GetNearbyCreeps(Min(nCastRange + 300, 1600), true)

    if J.IsPushing(bot) and bAttacking and fManaAfter > fManaThreshold1 and #nAllyHeroes <= 3 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 3)
                or (nLocationAoE.count >= 2 and creep:GetHealth() >= 550)
                then
                    return BOT_ACTION_DESIRE_HIGH, creep
                end
            end
        end
    end

    if J.IsDefending(bot) and bAttacking and fManaAfter > fManaThreshold1 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 3)
                or (nLocationAoE.count >= 2 and creep:GetHealth() >= 550)
                then
                    return BOT_ACTION_DESIRE_HIGH, creep
                end
            end
        end

        if J.IsValidHero(nEnemyHeroes[1]) and J.CanCastOnTargetAdvanced(nEnemyHeroes[1]) then
            local nLocationAoE = bot:FindAoELocation(true, true, nEnemyHeroes[1]:GetLocation(), 0, nRadius, 0, 0)
            if nLocationAoE.count >= 3 then
                return BOT_ACTION_DESIRE_HIGH, nEnemyHeroes[1]
            end
        end
    end

    if J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold1 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 3)
                or (nLocationAoE.count >= 2 and creep:IsAncientCreep())
                or (nLocationAoE.count >= 2 and creep:GetHealth() >= 550)
                then
                    return BOT_ACTION_DESIRE_HIGH, creep
                end
            end
        end
    end

    if J.IsLaning(bot) and J.IsInLaningPhase() and fManaAfter > fManaThreshold1 and (J.IsCore(bot) or not J.IsThereCoreNearby(800)) then
		for _, creep in pairs(nEnemyCreeps) do
			if  J.IsValid(creep)
            and J.CanBeAttacked(creep)
            and not J.IsOtherAllysTarget(creep)
			then
                local eta = (GetUnitToUnitDistance(bot, creep) / nSpeed) + nCastPoint + nSplitTime
                if J.WillKillTarget(creep, nDamage, DAMAGE_TYPE_MAGICAL, eta) then
                    local sCreepName = creep:GetUnitName()
                    local nLocationAoE = bot:FindAoELocation(true, true, creep:GetLocation(), 0, 600, 0, 0)
                    if string.find(sCreepName, 'ranged') then
                        if nLocationAoE.count > 0 or J.IsUnitTargetedByTower(creep, false) then
                            local hTarget = X.GetNearestUnit(creep, nCastRange, nRadius)
                            if hTarget then
                                return BOT_ACTION_DESIRE_HIGH, hTarget
                            end
                        end
                    end

                    nLocationAoE = bot:FindAoELocation(true, true, creep:GetLocation(), 0, nRadius, 0, nDamage * 2)
                    if fManaAfter > fManaThreshold1 + 0.1 and nLocationAoE.count > 0 then
                        return BOT_ACTION_DESIRE_HIGH, creep
                    end

                    nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, nDamage)
                    if nLocationAoE.count >= 3 then
                        return BOT_ACTION_DESIRE_HIGH, creep
                    end
                end
			end
		end
	end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderColdEmbrace()
    if not J.CanCastAbility(ColdEmbrace) then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = J.GetProperCastRange(false, bot, ColdEmbrace:GetCastRange())
    local nDuration = ColdEmbrace:GetSpecialValueFloat('duration')
    local nBaseHealPerSec = ColdEmbrace:GetSpecialValueInt('heal_additive')
    local nMaxHPHealPercentage = ColdEmbrace:GetSpecialValueInt('heal_percentage') / 100

    for _, allyHero in pairs(nAllyHeroes) do
        if  J.IsValidHero(allyHero)
        and J.CanBeAttacked(allyHero)
        and J.IsInRange(bot, allyHero, nCastRange)
        and not J.IsSuspiciousIllusion(allyHero)
        and not allyHero:IsChanneling()
        and not allyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not allyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not allyHero:HasModifier('modifier_doom_bringer_doom_aura_enemy')
        and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not allyHero:HasModifier('modifier_ice_blast')
        and not allyHero:HasModifier('modifier_fountain_aura_buff')
        and not allyHero:HasModifier('modifier_teleporting')
        then
            local allyHP = J.GetHP(allyHero)
            local damage = J.GetTotalEstimatedDamageToTarget(nEnemyHeroes, allyHero, nDuration)
            local nEnemyHeroesTargetingAlly = J.GetHeroesTargetingUnit(nEnemyHeroes, allyHero)

            if J.IsCore(allyHero) then
                if damage > allyHero:GetHealth() then
                    if allyHero:HasModifier('modifier_legion_commander_duel')
                    or allyHero:HasModifier('modifier_enigma_black_hole_pull')
                    or allyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
                    then
                        return BOT_ACTION_DESIRE_HIGH, allyHero
                    end
                end
            end

            if allyHP < 0.3 and not J.IsInEtherealForm(allyHero) then
                if not bot:WasRecentlyDamagedByAnyHero(nDuration) or #nEnemyHeroesTargetingAlly == 0 then
                    return BOT_ACTION_DESIRE_HIGH, allyHero
                end

                if  (bot:WasRecentlyDamagedByCreep(2.0) or bot:WasRecentlyDamagedByTower(2.0))
                and allyHP < 0.15
                and #nEnemyHeroes == 0
                then
                    return BOT_ACTION_DESIRE_HIGH, allyHero
                end
            end

            if J.IsDoingTormentor(bot) then
                if  J.IsTormentor(botTarget)
                and J.IsInRange(bot, botTarget, 1200)
                then
                    if allyHP < 0.3 then
                        return BOT_ACTION_DESIRE_HIGH, allyHero
                    end
                end
            end
        end
    end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(3.0) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.IsInRange(bot, enemyHero, 1200)
            and J.IsChasingTarget(enemyHero, bot)
            and not J.IsSuspiciousIllusion(enemyHero)
            and not J.IsDisabled(enemyHero)
            and not enemyHero:HasModifier('modifier_fountain_aura_buff')
            and botHP < 0.3
            then
                local damage = J.GetTotalEstimatedDamageToTarget(nEnemyHeroes, bot, nDuration)
                if damage > bot:GetHealth() then
                    return BOT_ACTION_DESIRE_HIGH, bot
                end
            end
        end
    end

    if J.GetHP(bot) < 0.2 and not bot:WasRecentlyDamagedByAnyHero(nDuration) then
        return BOT_ACTION_DESIRE_HIGH, bot
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderWintersCurse()
    if not J.CanCastAbility(WintersCurse) then
        return BOT_ACTION_DESIRE_NONE, nil
    end

	local nCastRange = J.GetProperCastRange(false, bot, WintersCurse:GetCastRange())
    local nRadius = WintersCurse:GetSpecialValueInt('radius')
    local nDuration = WintersCurse:GetSpecialValueFloat('duration')

	if J.IsGoingOnSomeone(bot) then
		local hTarget = nil
		local hTargetDamage = 0

        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange + 300)
            and not J.IsSuspiciousIllusion(enemyHero)
            and not J.IsDisabled(enemyHero)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemyHero:HasModifier('modifier_winter_wyvern_winters_curse_aura')
            then
                local enemyHeroDamage = enemyHero:GetEstimatedDamageToTarget(false, bot, nDuration, DAMAGE_TYPE_ALL)
                local nInRangeEnemy = J.GetEnemiesNearLoc(enemyHero:GetLocation(), nRadius)
                if not (#nAllyHeroes >= #nEnemyHeroes + 2) and #nInRangeEnemy >= 2 then
                    if enemyHeroDamage > hTargetDamage then
                        hTarget = enemyHero
                        hTargetDamage = enemyHeroDamage
                    end
                end
            end
        end

        if hTarget then
            return BOT_ACTION_DESIRE_HIGH, hTarget
        end
	end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and not J.IsInTeamFight(bot, 1200) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and not J.IsSuspiciousIllusion(enemyHero)
            and not J.IsDisabled(enemyHero)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemyHero:HasModifier('modifier_winter_wyvern_winters_curse_aura')
            and bot:WasRecentlyDamagedByHero(enemyHero, 3.0)
            and botHP < 0.5
            then
                local nInRangeEnemy = J.GetEnemiesNearLoc(enemyHero:GetLocation(), nRadius)
                if not (#nAllyHeroes >= #nEnemyHeroes + 2) and #nInRangeEnemy >= 2 then
                    return BOT_ACTION_DESIRE_HIGH, enemyHero
                end
            end
        end
    end

    if not J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange + 400)
            and not J.IsSuspiciousIllusion(enemyHero)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_winter_wyvern_winters_curse_aura')
            and enemyHero:HasModifier('modifier_teleporting')
            then
                if J.GetTotalEstimatedDamageToTarget(nAllyHeroes, enemyHero, nDuration) > enemyHero:GetHealth() then
                    return BOT_ACTION_DESIRE_HIGH, enemyHero
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.GetNearestUnit(hUnit, nCastRange, nRadius)
    local unitList = GetUnitList(UNIT_LIST_ALL)
    for _, unit in pairs(unitList) do
        if J.IsValid(unit)
        and (unit:IsHero() or unit:IsCreep())
        and unit ~= bot
        and unit ~= hUnit
        and J.IsInRange(unit, bot, nCastRange)
        and J.IsInRange(unit, hUnit, nRadius)
        and J.CanCastOnTargetAdvanced(unit)
        then
            return unit
        end
    end

    return nil
end

return X