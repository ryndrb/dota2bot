local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_enchantress'
then

local RI = require(GetScriptDirectory()..'/FunLib/util_role_item')

local sUtility = {"item_crimson_guard", "item_heavens_halberd"}
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
                [1] = {
                    ['t25'] = {0, 10},
                    ['t20'] = {0, 10},
                    ['t15'] = {0, 10},
                    ['t10'] = {10, 0},
                }
            },
            ['ability'] = {
                [1] = {1,3,1,3,1,6,1,2,3,3,6,2,2,2,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_magic_stick",
                "item_double_branches",
                "item_circlet",
            
                "item_bracer",
                "item_power_treads",
                "item_magic_wand",
                "item_mage_slayer",--
                "item_pipe",--
                "item_force_staff",
                "item_hurricane_pike",--
                sUtilityItem,--
                "item_assault",--
                "item_moon_shard",
                "item_travel_boots_2",--
                "item_aghanims_shard",
                "item_ultimate_scepter_2",
            },
            ['sell_list'] = {
                "item_bracer",
                "item_magic_wand",
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
                [1] = {2,3,2,3,2,6,2,1,1,1,1,6,3,3,6},
            },
            ['buy_list'] = {
                "item_double_tango",
                "item_double_branches",
                "item_faerie_fire",
                "item_blood_grenade",
            
                "item_magic_wand",
                "item_double_bracer",
                "item_boots",
                "item_force_staff",
                "item_hurricane_pike",--
                "item_aghanims_shard",
                "item_mage_slayer",--
                "item_boots_of_bearing",--
                "item_moon_shard",
                "item_bloodthorn",--
                "item_sheepstick",--
                "item_assault",--
                "item_ultimate_scepter_2",
            },
            ['sell_list'] = {
                "item_magic_wand",
                "item_bracer",
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
                [1] = {2,3,2,3,2,6,2,1,1,1,1,6,3,3,6},
            },
            ['buy_list'] = {
                "item_double_tango",
                "item_double_branches",
                "item_faerie_fire",
                "item_blood_grenade",
            
                "item_magic_wand",
                "item_double_bracer",
                "item_boots",
                "item_force_staff",
                "item_hurricane_pike",--
                "item_aghanims_shard",
                "item_mage_slayer",--
                "item_guardian_greaves",--
                "item_moon_shard",
                "item_bloodthorn",--
                "item_sheepstick",--
                "item_assault",--
                "item_ultimate_scepter_2",
            },
            ['sell_list'] = {
                "item_magic_wand",
                "item_bracer",
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

local Impetus           = bot:GetAbilityByName('enchantress_impetus')
local Enchant           = bot:GetAbilityByName('enchantress_enchant')
local NaturesAttendant  = bot:GetAbilityByName('enchantress_natures_attendants')
local Sproink           = bot:GetAbilityByName('enchantress_bunny_hop')
local LittleFriends     = bot:GetAbilityByName('enchantress_little_friends')
-- local Untouchable       = bot:GetAbilityByName('enchantress_untouchable')

local ImpetusDesire
local EnchantDesire, EnchantTarget
local NaturesAttendantDesire
local SproinkDesire
local LittleFriendsDesire, LittleFriendsTarget

function X.SkillsComplement()
	if J.CanNotUseAbility(bot)
    then
        return
    end

    Impetus           = bot:GetAbilityByName('enchantress_impetus')
    Enchant           = bot:GetAbilityByName('enchantress_enchant')
    NaturesAttendant  = bot:GetAbilityByName('enchantress_natures_attendants')
    Sproink           = bot:GetAbilityByName('enchantress_bunny_hop')
    LittleFriends     = bot:GetAbilityByName('enchantress_little_friends')

    LittleFriendsDesire, LittleFriendsTarget = X.ConsiderLittleFriends()
    if LittleFriendsDesire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(LittleFriends, LittleFriendsTarget)
        return
    end

    SproinkDesire = X.ConsiderSproink()
    if SproinkDesire > 0
    then
        bot:Action_UseAbility(Sproink)
        return
    end

    NaturesAttendantDesire = X.ConsiderNaturesAttendant()
    if NaturesAttendantDesire > 0
    then
        bot:Action_UseAbility(NaturesAttendant)
        return
    end

    EnchantDesire, EnchantTarget = X.ConsiderEnchant()
    if EnchantDesire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(Enchant, EnchantTarget)
        return
    end

    X.ConsiderImpetus()
end

function X.ConsiderImpetus()
    if not J.CanCastAbility(Impetus)
    then
        if Impetus:ToggleAutoCast() == true
        then
            return Impetus:ToggleAutoCast()
        end

        return
    end

    local nAttackRange = bot:GetAttackRange()
    local nAbilityLevel = Impetus:GetLevel()
    local botTarget = J.GetProperTarget(bot)

    if J.IsGoingOnSomeone(bot)
    then
        if  J.IsValidTarget(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and not botTarget:IsAttackImmune()
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        then
            if Impetus:GetAutoCastState() == false
            then
                return Impetus:ToggleAutoCast()
            else
                return
            end
        end
    end

    if J.IsFarming(bot)
    and nAbilityLevel == 4
    then
        local nNeutralCreeps = bot:GetNearbyNeutralCreeps(nAttackRange)

        if  nNeutralCreeps ~= nil and #nNeutralCreeps >= 1
        and J.CanBeAttacked(nNeutralCreeps[1])
        then
            if Impetus:GetAutoCastState() == false
            then
                return Impetus:ToggleAutoCast()
            else
                if Impetus:GetAutoCastState() == true and J.GetMP(bot) < 0.35
                then
                    return Impetus:ToggleAutoCast()
                end

                return
            end
        end
    end

    if J.IsDoingRoshan(bot)
    then
        if  J.IsRoshan(botTarget)
        and not botTarget:IsAttackImmune()
        and J.IsInRange(bot, botTarget, bot:GetAttackRange())
        and J.IsAttacking(bot)
        then
            if Impetus:GetAutoCastState() == false
            then
                return Impetus:ToggleAutoCast()
            else
                if Impetus:GetAutoCastState() == true and J.GetMP(bot) < 0.25
                then
                    return Impetus:ToggleAutoCast()
                end

                return
            end
        end
    end

    if J.IsDoingTormentor(bot)
    then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, 400)
        and J.IsAttacking(bot)
        then
            if Impetus:GetAutoCastState() == false
            then
                return Impetus:ToggleAutoCast()
            else
                if Impetus:GetAutoCastState() == true and J.GetMP(bot) < 0.25
                then
                    return Impetus:ToggleAutoCast()
                end

                return
            end
        end
    end

    if Impetus:GetAutoCastState() == true
    then
        return Impetus:ToggleAutoCast()
    end
end

function X.ConsiderEnchant()
    if not J.CanCastAbility(Enchant)
    then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = J.GetProperCastRange(false, bot, Enchant:GetCastRange())
    local nMaxLevel = Enchant:GetSpecialValueInt('level_req')
	local nNeutralCreeps = bot:GetNearbyNeutralCreeps(nCastRange)
    local botTarget = J.GetProperTarget(bot)

    local nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    for _, allyHero in pairs(nAllyHeroes)
    do
        if J.IsValidHero(allyHero)
        and J.IsRetreating(allyHero)
        and not allyHero:IsIllusion()
        then
            local nAllyInRangeEnemy = allyHero:GetNearbyHeroes(nCastRange, true, BOT_MODE_NONE)

            if J.IsValidHero(nAllyInRangeEnemy[1])
            and J.IsChasingTarget(nAllyInRangeEnemy[1], allyHero)
            and not J.IsSuspiciousIllusion(nAllyInRangeEnemy[1])
            and not J.IsDisabled(nAllyInRangeEnemy[1])
            then
                return BOT_ACTION_DESIRE_HIGH, nAllyInRangeEnemy[1]
            end
        end
    end

    if J.IsGoingOnSomeone(bot)
    then
        if  J.IsValidTarget(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.IsChasingTarget(bot, botTarget)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

    local nGoodCreep = {
        "npc_dota_neutral_alpha_wolf",
        "npc_dota_neutral_centaur_khan",
        "npc_dota_neutral_polar_furbolg_ursa_warrior",
        "npc_dota_neutral_dark_troll_warlord",
        "npc_dota_neutral_satyr_hellcaller",
        "npc_dota_neutral_enraged_wildkin",
        "npc_dota_neutral_warpine_raider",
    }

    for _, creep in pairs(nNeutralCreeps)
    do
        if  J.IsValid(creep)
        and creep:GetLevel() <= nMaxLevel
        then
            for _, gCreep in pairs(nGoodCreep)
            do
                if creep:GetUnitName() == gCreep
                then
                    return BOT_ACTION_DESIRE_HIGH, creep
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderNaturesAttendant()
    if not J.CanCastAbility(NaturesAttendant) or J.IsRealInvisible(bot)
    then
        return BOT_ACTION_DESIRE_NONE
    end

    if J.GetHP(bot) < 0.65
    and bot:DistanceFromFountain() > 800
    then
        return BOT_ACTION_DESIRE_HIGH
    end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderSproink()
    if not J.CanCastAbility(Sproink)
    or bot:IsRooted()
    then
        return BOT_ACTION_DESIRE_NONE
    end

    local nAttackRange = bot:GetAttackRange()

    local nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
    local nImpetusMul = 0
    local botTarget = J.GetProperTarget(bot)

    local _, Impetus_ = J.HasAbility(bot, 'enchantress_impetus')
    if Impetus_ ~= nil
    then
        nImpetusMul = Impetus_:GetSpecialValueFloat('value') / 100
    end

    for _, enemyHero in pairs(nEnemyHeroes)
    do
        if  J.IsValidHero(enemyHero)
        and not enemyHero:IsAttackImmune()
        and J.CanKillTarget(enemyHero, nImpetusMul * GetUnitToUnitDistance(bot, enemyHero), DAMAGE_TYPE_PURE)
        and bot:IsFacingLocation(enemyHero:GetLocation(), 15)
        and not J.IsSuspiciousIllusion(enemyHero)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsGoingOnSomeone(bot)
    then
        if  J.IsValidTarget(botTarget)
        and bot:IsFacingLocation(botTarget:GetLocation(), 15)
        and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
    then
        if nAllyHeroes ~= nil and nEnemyHeroes ~= nil
        and (#nEnemyHeroes > #nAllyHeroes or bot:WasRecentlyDamagedByAnyHero(4))
        and J.IsValidHero(nEnemyHeroes[1])
        and J.IsInRange(bot, nEnemyHeroes[1], nAttackRange)
        and bot:IsFacingLocation(nEnemyHeroes[1]:GetLocation(), 30)
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderLittleFriends()
    if not J.CanCastAbility(LittleFriends)
    then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = J.GetProperCastRange(false, bot, LittleFriends:GetCastRange())
    local nRadius = LittleFriends:GetSpecialValueInt('radius')
    local nDuration = LittleFriends:GetSpecialValueInt('duration')

    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    for _, enemyHero in pairs(nEnemyHeroes)
    do
        if  J.IsValidHero(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        and J.GetHP(enemyHero) < 0.33
        and not J.IsSuspiciousIllusion(enemyHero)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        then
            bot:SetTarget(enemyHero)
            return BOT_ACTION_DESIRE_HIGH, enemyHero
        end
    end

    if J.IsGoingOnSomeone(bot, 1200)
    then
        local botTarget = J.GetStrongestUnit(nCastRange, bot, true, false, nDuration)
        local nTargetInRangeEnemy = botTarget:GetNearbyHeroes(nRadius, true, BOT_MODE_NONE)

        if  J.IsValidTarget(botTarget)
        and nTargetInRangeEnemy ~= nil and #nTargetInRangeEnemy >= 1
        and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

    if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
    then
        if J.IsValidHero(nEnemyHeroes[1])
        and J.IsInRange(bot, nEnemyHeroes[1], nCastRange)
        and not J.IsSuspiciousIllusion(nEnemyHeroes[1])
        and not J.IsDisabled(nEnemyHeroes[1])
        then
            return BOT_ACTION_DESIRE_HIGH, nEnemyHeroes[1]
        end
    end

    if J.IsDoingRoshan(bot)
    then
        local botTarget = bot:GetAttackTarget()

        if  J.IsRoshan(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

return X