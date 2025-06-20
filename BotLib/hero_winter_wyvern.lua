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
                "ite_circlet",
                "item_mantle",
            
                "item_bottle",
                "item_magic_wand",
                "item_power_treads",
                "item_null_talisman",
                "item_falcon_blade",
                "item_witch_blade",
                "item_ultimate_scepter",
                "item_hurricane_pike",--
                "item_revenants_brooch",--
                "item_black_king_bar",--
                "item_devastator",--
                "item_bloodthorn",--
                "item_ultimate_scepter_2",
                "item_moon_shard",
                "item_travel_boots_2",--
            },
            ['sell_list'] = {
                "item_magic_wand", "item_ultimate_scepter",
                "item_null_talisman", "item_hurricane_pike",
                "item_bottle", "item_revenants_brooch",
                "item_falcon_blade", "item_black_king_bar",
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
                "ite_circlet",
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
                    ['t25'] = {0, 10},
                    ['t20'] = {0, 10},
                    ['t15'] = {0, 10},
                    ['t10'] = {10, 0},
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
                "item_enchanted_mango",
            
                "item_tranquil_boots",
                "item_magic_wand",
                "item_glimmer_cape",--
                "item_solar_crest",--
                "item_ancient_janggo",
                "item_force_staff",
                "item_boots_of_bearing",--
                "item_shivas_guard",--
                "item_aghanims_shard",
                "item_sheepstick",--
                "item_hurricane_pike",--
                "item_ultimate_scepter_2",
                "item_moon_shard",
            },
            ['sell_list'] = {
                "item_magic_wand", "item_sheepstick",
            },
        },
    },
    ['pos_5'] = {
        [1] = {
            ['talent'] = {
                [1] = {
                    ['t25'] = {0, 10},
                    ['t20'] = {0, 10},
                    ['t15'] = {0, 10},
                    ['t10'] = {10, 0},
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
                "item_enchanted_mango",
            
                "item_arcane_boots",
                "item_magic_wand",
                "item_glimmer_cape",--
                "item_solar_crest",--
                "item_mekansm",
                "item_force_staff",
                "item_guardian_greaves",--
                "item_shivas_guard",--
                "item_aghanims_shard",
                "item_sheepstick",--
                "item_hurricane_pike",--
                "item_ultimate_scepter_2",
                "item_moon_shard",
            },
            ['sell_list'] = {
                "item_magic_wand", "item_sheepstick",
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

local botTarget

function X.SkillsComplement()
	if J.CanNotUseAbility(bot) then return end

    ArcticBurn    = bot:GetAbilityByName('winter_wyvern_arctic_burn')
    SplinterBlast = bot:GetAbilityByName('winter_wyvern_splinter_blast')
    ColdEmbrace   = bot:GetAbilityByName('winter_wyvern_cold_embrace')
    WintersCurse  = bot:GetAbilityByName('winter_wyvern_winters_curse')

    botTarget = J.GetProperTarget(bot)

    WintersCurseDesire, WintersCurseTarget = X.ConsiderWintersCurse()
    if WintersCurseDesire > 0
    then
        bot:Action_UseAbilityOnEntity(WintersCurse, WintersCurseTarget)
        return
    end

    ColdEmbraceDesire, ColdEmbraceTarget = X.ConsiderColdEmbrace()
    if ColdEmbraceDesire > 0
    then
        bot:Action_UseAbilityOnEntity(ColdEmbrace, ColdEmbraceTarget)
        return
    end

    SplinterBlastDesire, SplinterBlastTarget = X.ConsiderSplinterBlast()
    if SplinterBlastDesire > 0
    then
        bot:Action_UseAbilityOnEntity(SplinterBlast, SplinterBlastTarget)
        return
    end

    ArcticBurnDesire = X.ConsiderArcticBurn()
    if ArcticBurnDesire > 0
    then
        bot:Action_UseAbility(ArcticBurn)
        return
    end
end

function X.ConsiderArcticBurn()
    if not J.CanCastAbility(ArcticBurn)
    then
        return BOT_ACTION_DESIRE_NONE
    end

	local nBonusRange = ArcticBurn:GetSpecialValueInt('attack_range_bonus')
	local nAttackRange = bot:GetAttackRange()

	if not bot:HasScepter()
    then
		if J.IsStuck(bot)
		then
			return BOT_ACTION_DESIRE_HIGH
		end

		if J.IsGoingOnSomeone(bot)
		then
			if  J.IsValidTarget(botTarget)
            and J.CanCastOnNonMagicImmune(botTarget)
            and J.IsInRange(bot, botTarget, nAttackRange + nBonusRange)
            and not J.IsSuspiciousIllusion(botTarget)
            and not J.IsDisabled(botTarget)
            and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
			then
                local nInRangeAlly = botTarget:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
                local nInRangeEnemy = botTarget:GetNearbyHeroes(1200, false, BOT_MODE_NONE)

                if  nInRangeAlly ~= nil and nInRangeEnemy ~= nil
                and #nInRangeAlly >= #nInRangeEnemy
                then
                    if J.IsInLaningPhase()
                    then
                        if J.IsChasingTarget(bot, botTarget)
                        then
                            return BOT_ACTION_DESIRE_HIGH
                        end
                    else
                        return BOT_ACTION_DESIRE_HIGH
                    end
                end
			end
		end

        if J.IsRetreating(bot)
        then
            local nInRangeEnemy = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
            for _, enemyHero in pairs(nInRangeEnemy)
            do
                if  J.IsValidHero(enemyHero)
                and J.IsChasingTarget(enemyHero, bot)
                and not J.IsSuspiciousIllusion(enemyHero)
                and not J.IsDisabled(enemyHero)
                then
                    local nInRangeAlly = enemyHero:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
                    local nTargetInRangeAlly = enemyHero:GetNearbyHeroes(1200, false, BOT_MODE_NONE)

                    if  nInRangeAlly ~= nil and nTargetInRangeAlly ~= nil
                    and ((#nTargetInRangeAlly > #nInRangeAlly)
                        or bot:WasRecentlyDamagedByAnyHero(2))
                    then
                        return BOT_ACTION_DESIRE_HIGH
                    end
                end
            end
        end
	else
		if  J.IsStuck(bot)
        and not ArcticBurn:GetToggleState() == false
		then
			return BOT_ACTION_DESIRE_HIGH
		end

		if J.IsGoingOnSomeone(bot)
		then
			if  J.IsValidTarget(botTarget)
            and J.CanCastOnNonMagicImmune(botTarget)
            and J.IsInRange(bot, botTarget, nAttackRange + nBonusRange)
            and not J.IsSuspiciousIllusion(botTarget)
            and not J.IsDisabled(botTarget)
            and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
			then
                if not botTarget:HasModifier('modifier_winter_wyvern_arctic_burn_slow')
                then
                    if ArcticBurn:GetToggleState() == false
                    then
                        return BOT_ACTION_DESIRE_HIGH
                    else
                        return BOT_ACTION_DESIRE_NONE
                    end
                end

                if botTarget:HasModifier('modifier_winter_wyvern_arctic_burn_slow')
                then
                    if ArcticBurn:GetToggleState() == true
                    then
                        return BOT_ACTION_DESIRE_HIGH
                    else
                        return BOT_ACTION_DESIRE_NONE
                    end
                end
			end
		end

        if J.IsRetreating(bot)
        then
            local nInRangeEnemy = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

            if nInRangeEnemy ~= nil and #nInRangeEnemy == 0
            then
                if ArcticBurn:GetToggleState() == true
                then
                    return BOT_ACTION_DESIRE_HIGH
                end
            end

            for _, enemyHero in pairs(nInRangeEnemy)
            do
                if  J.IsValidHero(enemyHero)
                and J.IsChasingTarget(enemyHero, bot)
                and not J.IsSuspiciousIllusion(enemyHero)
                and not J.IsDisabled(enemyHero)
                then
                    local nInRangeAlly = enemyHero:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
                    local nTargetInRangeAlly = enemyHero:GetNearbyHeroes(1200, false, BOT_MODE_NONE)

                    if  nInRangeAlly ~= nil and nTargetInRangeAlly ~= nil
                    and ((#nTargetInRangeAlly > #nInRangeAlly)
                        or bot:WasRecentlyDamagedByAnyHero(2))
                    then
                        if ArcticBurn:GetToggleState() == false
                        then
                            return BOT_ACTION_DESIRE_HIGH
                        else
                            return BOT_ACTION_DESIRE_NONE
                        end
                    end
                end
            end
        end

        if ArcticBurn:GetToggleState() == true
        then
            return BOT_ACTION_DESIRE_HIGH
        end
	end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderSplinterBlast()
    if not J.CanCastAbility(SplinterBlast)
    then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = J.GetProperCastRange(false, bot, SplinterBlast:GetCastRange())
	local nDamage = SplinterBlast:GetSpecialValueInt('damage')
	local nRadius = SplinterBlast:GetSpecialValueInt('split_radius')
    local nManaCost = SplinterBlast:GetManaCost()

    local nEnemyHeroes = bot:GetNearbyHeroes(nCastRange, true, BOT_MODE_NONE)
    for _, enemyHero in pairs(nEnemyHeroes)
    do
        if  J.IsValidHero(enemyHero)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
        and not J.IsInRange(bot, enemyHero, nCastRange + nRadius)
        and not J.IsSuspiciousIllusion(enemyHero)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
        and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
        then
            local nTargetInRangeCreeps = enemyHero:GetNearbyCreeps(nRadius, true)
            for _, creep in pairs(nTargetInRangeCreeps)
            do
                if  J.IsValid(creep)
                and J.CanCastOnNonMagicImmune(creep)
                then
                    return BOT_ACTION_DESIRE_HIGH, creep
                end
            end

            local nTargetInRangeAlly = enemyHero:GetNearbyHeroes(nRadius, false, BOT_MODE_NONE)
            for _, enemyHero2 in pairs(nTargetInRangeAlly)
            do
                if  J.IsValidHero(enemyHero2)
                and J.CanCastOnNonMagicImmune(enemyHero2)
                and J.IsNotSelf(enemyHero, enemyHero2)
                then
                    return BOT_ACTION_DESIRE_HIGH, enemyHero2
                end
            end
        end
    end

	if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not J.IsSuspiciousIllusion(botTarget)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
            local nInRangeAlly = botTarget:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
            local nInRangeEnemy = botTarget:GetNearbyHeroes(1200, false, BOT_MODE_NONE)

            if  nInRangeAlly ~= nil and nInRangeEnemy ~= nil
            and #nInRangeAlly >= #nInRangeEnemy
            then
                local nTargetInRangeCreeps = botTarget:GetNearbyCreeps(nRadius, true)
                for _, creep in pairs(nTargetInRangeCreeps)
                do
                    if  J.IsValid(creep)
                    and J.CanCastOnNonMagicImmune(creep)
                    then
                        return BOT_ACTION_DESIRE_HIGH, creep
                    end
                end

                local nTargetInRangeAlly = botTarget:GetNearbyHeroes(nRadius, false, BOT_MODE_NONE)
                for _, enemyHero in pairs(nTargetInRangeAlly)
                do
                    if  J.IsValidHero(enemyHero)
                    and J.CanCastOnNonMagicImmune(enemyHero)
                    and J.IsNotSelf(botTarget, enemyHero)
                    then
                        return BOT_ACTION_DESIRE_HIGH, enemyHero
                    end
                end
            end
		end
	end

    if J.IsRetreating(bot)
    then
        local nInRangeEnemy = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
        for _, enemyHero in pairs(nInRangeEnemy)
        do
            if  J.IsValidHero(enemyHero)
            and J.IsChasingTarget(enemyHero, bot)
            and not J.IsSuspiciousIllusion(enemyHero)
            and not J.IsDisabled(enemyHero)
            and not enemyHero:HasModifier('modifier_winter_wyvern_arctic_burn_slow')
            then
                local nInRangeAlly = enemyHero:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
                local nTargetInRangeAlly = enemyHero:GetNearbyHeroes(1200, false, BOT_MODE_NONE)

                if  nInRangeAlly ~= nil and nTargetInRangeAlly ~= nil
                and ((#nTargetInRangeAlly > #nInRangeAlly)
                    or bot:WasRecentlyDamagedByAnyHero(2))
                then
                    local nTargetInRangeCreeps = enemyHero:GetNearbyCreeps(nRadius, true)
                    for _, creep in pairs(nTargetInRangeCreeps)
                    do
                        if  J.IsValid(creep)
                        and J.CanCastOnNonMagicImmune(creep)
                        then
                            return BOT_ACTION_DESIRE_HIGH, creep
                        end
                    end

                    nTargetInRangeAlly = enemyHero:GetNearbyHeroes(nRadius, false, BOT_MODE_NONE)
                    for _, enemyHero2 in pairs(nTargetInRangeAlly)
                    do
                        if  J.IsValidHero(enemyHero2)
                        and J.CanCastOnNonMagicImmune(enemyHero2)
                        and J.IsNotSelf(enemyHero, enemyHero2)
                        then
                            return BOT_ACTION_DESIRE_HIGH, enemyHero2
                        end
                    end
                end
            end
        end
    end

	if J.IsPushing(bot) or J.IsDefending(bot)
	then
        local creepList = {}
        local creepTarget = nil
        local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(1600, true)
        for _, creep in pairs(nEnemyLaneCreeps)
        do
            if  J.IsValid(creep)
            and J.CanBeAttacked(creep)
            then
                if creep:GetHealth() <= nDamage
                then
                    table.insert(creepList, creep)
                end

                if creep:GetHealth() > nDamage
                then
                    creepTarget = creep
                end
            end
        end

        if  creepTarget ~= nil
        and #creepList >= 3
        and J.GetManaAfter(nManaCost) > 0.4
        and not J.IsThereCoreNearby(1200)
        then
            return BOT_ACTION_DESIRE_HIGH, creepTarget
        end

        if  creepTarget == nil
        and #creepList >= 4
        and J.GetManaAfter(nManaCost) > 0.4
        and not J.IsThereCoreNearby(1200)
        then
            return BOT_ACTION_DESIRE_HIGH, creepList[1]
        end

        if  nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 4
        and J.GetManaAfter(nManaCost) > 0.4
        then
            return BOT_ACTION_DESIRE_HIGH, nEnemyLaneCreeps[1]
        end

        local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), 1600, nRadius, 0, 0)
        local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)
        if nInRangeEnemy ~= nil and #nInRangeEnemy >= 2
        then
            return BOT_ACTION_DESIRE_HIGH, nInRangeEnemy[1]
        end
	end

    if J.IsLaning(bot)
    then
        local creepList = {}
        local creepTarget = nil
        local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(1600, true)
        for _, creep in pairs(nEnemyLaneCreeps)
        do
            if  J.IsValid(creep)
            and J.CanBeAttacked(creep)
            then
                if creep:GetHealth() <= nDamage
                then
                    table.insert(creepList, creep)
                end

                if creep:GetHealth() > nDamage
                then
                    creepTarget = creep
                end
            end
        end

        if  creepTarget ~= nil
        and #creepList >= 3
        and J.GetManaAfter(nManaCost) > 0.5
        and not J.IsThereCoreNearby(1200)
        then
            return BOT_ACTION_DESIRE_HIGH, creepTarget
        end

        if  creepTarget == nil
        and #creepList >= 4
        and J.GetManaAfter(nManaCost) > 0.5
        and not J.IsThereCoreNearby(1200)
        then
            return BOT_ACTION_DESIRE_HIGH, creepList[1]
        end

        local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), nCastRange + nRadius)
        for _, enemyHero in pairs(nInRangeEnemy)
        do
            if  J.IsValidHero(enemyHero)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.GetManaAfter(nManaCost) > 0.35
            and not J.IsSuspiciousIllusion(enemyHero)
            and not J.IsDisabled(enemyHero)
            and not enemyHero:HasModifier('modifier_winter_wyvern_arctic_burn_slow')
            then
                local nInRangeAlly = bot:GetNearbyHeroes(1200, false, BOT_MODE_NONE)
                for _, allyHero in pairs(nInRangeAlly)
                do
                    if  J.IsValidHero(allyHero)
                    and (J.IsChasingTarget(enemyHero, allyHero) or enemyHero:GetAttackTarget() == allyHero)
                    and not J.IsSuspiciousIllusion(allyHero)
                    then
                        local nTargetInRangeCreeps = enemyHero:GetNearbyCreeps(nRadius, true)
                        for _, creep in pairs(nTargetInRangeCreeps)
                        do
                            if  J.IsValid(creep)
                            and J.CanCastOnNonMagicImmune(creep)
                            then
                                return BOT_ACTION_DESIRE_HIGH, creep
                            end
                        end

                        local nTargetInRangeAlly = enemyHero:GetNearbyHeroes(nRadius, false, BOT_MODE_NONE)
                        for _, enemyHero2 in pairs(nTargetInRangeAlly)
                        do
                            if  J.IsValidHero(enemyHero2)
                            and J.CanCastOnNonMagicImmune(enemyHero2)
                            and J.IsNotSelf(enemyHero, enemyHero2)
                            then
                                return BOT_ACTION_DESIRE_HIGH, enemyHero2
                            end
                        end
                    end
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderColdEmbrace()
    if not J.CanCastAbility(ColdEmbrace)
    then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = J.GetProperCastRange(false, bot, ColdEmbrace:GetCastRange())
    local nDuration = ColdEmbrace:GetSpecialValueFloat('duration')
    local nBaseHealPerSec = ColdEmbrace:GetSpecialValueInt('heal_additive')
    local nMaxHPHealPercentage = ColdEmbrace:GetSpecialValueInt('heal_percentage') / 100

    local nAllyHeroes = bot:GetNearbyHeroes(nCastRange, false, BOT_MODE_NONE)
    for _, allyHero in pairs(nAllyHeroes)
    do
        if  J.IsValidHero(allyHero)
        and J.IsCore(allyHero)
        and not J.IsSuspiciousIllusion(allyHero)
        and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        then
            local nAllyInRangeEnemy = allyHero:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
            for _, enemyHero in pairs(nAllyInRangeEnemy)
            do
                if  J.IsValidHero(enemyHero)
                and enemyHero:GetAttackTarget() == allyHero
                and not J.IsSuspiciousIllusion(enemyHero)
                then
                    if allyHero:HasModifier('modifier_legion_commander_duel')
                    or allyHero:HasModifier('modifier_enigma_black_hole_pull')
                    or allyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
                    then
                        return BOT_ACTION_DESIRE_HIGH, allyHero
                    end
                end
            end
        end
    end

    if J.IsGoingOnSomeone(bot)
    then
        if  J.IsValidTarget(botTarget)
        and J.IsInRange(bot, botTarget, bot:GetCurrentVisionRange())
        and not J.IsSuspiciousIllusion(botTarget)
        then
            local nInRangeAlly2 = botTarget:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
            local nInRangeEnemy = botTarget:GetNearbyHeroes(1200, false, BOT_MODE_NONE)

            if  nInRangeAlly2 ~= nil and nInRangeEnemy ~= nil
            and #nInRangeAlly2 >= #nInRangeEnemy
            then
                local nInRangeAlly = bot:GetNearbyHeroes(nCastRange, false, BOT_MODE_NONE)
                -- Core
                for _, allyHero in pairs(nInRangeAlly)
                do
                    if  J.IsValidHero(allyHero)
                    and J.GetHP(allyHero) < 0.3
                    and J.IsCore(allyHero)
                    and not J.IsSuspiciousIllusion(allyHero)
                    and not J.IsInEtherealForm(allyHero)
                    and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
                    and not allyHero:HasModifier('modifier_necrolyte_sadist_active')
                    then
                        return BOT_ACTION_DESIRE_HIGH, allyHero
                    end
                end

                -- Support
                for _, allyHero in pairs(nInRangeAlly)
                do
                    if  J.IsValidHero(allyHero)
                    and J.GetHP(allyHero) < 0.25
                    and not J.IsCore(allyHero)
                    and not J.IsSuspiciousIllusion(allyHero)
                    and not J.IsInEtherealForm(allyHero)
                    and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
                    then
                        return BOT_ACTION_DESIRE_HIGH, allyHero
                    end
                end
            end
        end
    end

    if J.IsRetreating(bot)
    then
        local nInRangeEnemy = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
        for _, enemyHero in pairs(nInRangeEnemy)
        do
            if  J.IsValidHero(enemyHero)
            and J.IsChasingTarget(enemyHero, bot)
            and J.GetHP(bot) < 0.25
            and not J.IsSuspiciousIllusion(enemyHero)
            and not J.IsDisabled(enemyHero)
            and not not enemyHero:HasModifier('modifier_fountain_aura_buff')
            then
                local nInRangeAlly = enemyHero:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
                local nTargetInRangeAlly = enemyHero:GetNearbyHeroes(1200, false, BOT_MODE_NONE)

                if  nInRangeAlly ~= nil and nTargetInRangeAlly ~= nil
                and ((#nTargetInRangeAlly > #nInRangeAlly)
                    or bot:WasRecentlyDamagedByAnyHero(1))
                then
                    return BOT_ACTION_DESIRE_HIGH, bot
                end
            end
        end
    end

    for _, allyHero in pairs(nAllyHeroes)
    do
        if  J.IsValidHero(allyHero)
        and J.GetHP(allyHero) < 0.25
        and not J.IsSuspiciousIllusion(allyHero)
        and not J.IsInEtherealForm(allyHero)
        and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not not allyHero:HasModifier('modifier_fountain_aura_buff')
        then
            return BOT_ACTION_DESIRE_HIGH, allyHero
        end
    end

    if J.IsDoingTormentor(bot)
    then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, 500)
        then
            if J.GetHP(bot) < 0.2
            then
                return BOT_ACTION_DESIRE_HIGH, bot
            end

            local nInRangeAlly = bot:GetNearbyHeroes(nCastRange, false, BOT_MODE_NONE)
            for _, allyHero in pairs(nInRangeAlly)
            do
                if  J.IsValidHero(allyHero)
                and J.GetHP(allyHero) < 0.3
                and not allyHero:IsIllusion()
                and not allyHero:HasModifier('modifier_abaddon_borrowed_time')
                and not allyHero:HasModifier('modifier_dazzle_shallow_grave')
                and not allyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
                and not allyHero:HasModifier('modifier_obsidian_destroyer_astral_imprisonment_prison')
                then
                    return BOT_ACTION_DESIRE_HIGH, allyHero
                end
            end
        end
    end

    if J.GetHP(bot) < 0.2
    then
        return BOT_ACTION_DESIRE_HIGH, bot
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderWintersCurse()
    if not J.CanCastAbility(WintersCurse)
    then
        return BOT_ACTION_DESIRE_NONE, nil
    end

	local nCastRange = J.GetProperCastRange(false, bot, WintersCurse:GetCastRange())
    local nRadius = WintersCurse:GetSpecialValueInt('radius')
    local nDuration = WintersCurse:GetSpecialValueFloat('duration')

	if J.IsGoingOnSomeone(bot)
	then
		local target = nil
		local dmg = 0

		local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), bot:GetCurrentVisionRange())
		if nInRangeEnemy ~= nil and #nInRangeEnemy >= 3
        then
			for _, enemyHero in pairs(nInRangeEnemy)
			do
				if  J.IsValidHero(enemyHero)
                and not J.IsSuspiciousIllusion(enemyHero)
                and not J.IsDisabled(enemyHero)
                and not enemyHero:HasModifier('modifier_enigma_black_hole_pull')
                and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
                and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
                and not enemyHero:HasModifier('modifier_winter_wyvern_winters_curse_aura')
				then
					local nInRangeAlly = J.GetAlliesNearLoc(enemyHero:GetLocation(), 1200)
                    local nTargetInRangeAlly = J.GetEnemiesNearLoc(enemyHero:GetLocation(), 1200)
                    local currDmg = enemyHero:GetEstimatedDamageToTarget(true, bot, nDuration, DAMAGE_TYPE_ALL)

                    if  nInRangeAlly ~= nil and nTargetInRangeAlly ~= nil
                    and #nInRangeAlly >= #nTargetInRangeAlly
                    and currDmg > dmg
                    then
                        nTargetInRangeAlly = J.GetEnemiesNearLoc(enemyHero:GetLocation(), nRadius)
                        if nTargetInRangeAlly ~= nil and #nTargetInRangeAlly >= 2
                        then
                            dmg = currDmg
                            target = enemyHero
                        end
                    end
				end
			end

			if target ~= nil
			then
				return BOT_ACTION_DESIRE_HIGH, target
			end
		end
	end

    if J.IsRetreating(bot)
    then
        local nInRangeEnemy = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
        for _, enemyHero in pairs(nInRangeEnemy)
        do
            if  J.IsValidHero(enemyHero)
            and J.IsChasingTarget(enemyHero, bot)
            and J.GetHP(bot) < 0.5
            and not J.IsSuspiciousIllusion(enemyHero)
            and not J.IsDisabled(enemyHero)
            and not enemyHero:HasModifier('modifier_enigma_black_hole_pull')
            and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemyHero:HasModifier('modifier_winter_wyvern_winters_curse_aura')
            then
                local nInRangeAlly = J.GetAlliesNearLoc(enemyHero:GetLocation(), 1200)
                local nTargetInRangeAlly = J.GetEnemiesNearLoc(enemyHero:GetLocation(), 1200)

                if  nInRangeAlly ~= nil and nTargetInRangeAlly ~= nil
                and ((#nTargetInRangeAlly > #nInRangeAlly)
                    or bot:WasRecentlyDamagedByAnyHero(2.5))
                and #nInRangeAlly >= 2
                then
                    nTargetInRangeAlly = J.GetEnemiesNearLoc(enemyHero:GetLocation(), nRadius)
                    if nTargetInRangeAlly ~= nil and #nTargetInRangeAlly >= 1
                    then
                        return BOT_ACTION_DESIRE_HIGH, enemyHero
                    end
                end
            end
        end
    end

    local nEnemyHeroes = bot:GetNearbyHeroes(nCastRange, true, BOT_MODE_NONE)
	for _, enemyHero in pairs(nEnemyHeroes)
	do
		if  J.IsValidHero(enemyHero)
        and J.CanCastOnMagicImmune(enemyHero)
        and enemyHero:IsChanneling()
        and not J.IsSuspiciousIllusion(enemyHero)
        and not enemyHero:HasModifier('modifier_winter_wyvern_winters_curse_aura')
		then
            local nInRangeEnemy = J.GetEnemiesNearLoc(enemyHero:GetLocation(), nRadius)
            if nInRangeEnemy ~= nil and #nInRangeEnemy >= 1
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero
            end
		end
	end

    return BOT_ACTION_DESIRE_NONE, nil
end

return X