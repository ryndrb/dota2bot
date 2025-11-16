local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_chen'
then

local RI = require(GetScriptDirectory()..'/FunLib/util_role_item')

local sUtility = {}
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
				[1] = {
					['t25'] = {0, 10},
					['t20'] = {0, 10},
					['t15'] = {10, 0},
					['t10'] = {10, 0},
				}
            },
            ['ability'] = {
                [1] = {1,2,2,3,2,6,3,1,1,1,6,3,3,2,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_blood_grenade",
                "item_faerie_fire",
                "item_magic_stick",
			
				"item_tranquil_boots",
				"item_magic_wand",
				"item_ancient_janggo",
				"item_vladmir",--
				"item_glimmer_cape",--
				"item_boots_of_bearing",--
				"item_aghanims_shard",
				"item_solar_crest",--
				"item_assault",--
                "item_sheepstick",--
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
					['t15'] = {10, 0},
					['t10'] = {10, 0},
				}
            },
            ['ability'] = {
                [1] = {1,2,2,3,2,6,3,1,1,1,6,3,3,2,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_blood_grenade",
                "item_faerie_fire",
                "item_magic_stick",
			
				"item_arcane_boots",
				"item_magic_wand",
				"item_mekansm",
				"item_vladmir",--
				"item_glimmer_cape",--
				"item_guardian_greaves",--
				"item_aghanims_shard",
				"item_solar_crest",--
				"item_assault",--
                "item_sheepstick",--
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

local Penitence         = bot:GetAbilityByName('chen_penitence')
local HolyPersuasion    = bot:GetAbilityByName('chen_holy_persuasion')
local DivineFavor       = bot:GetAbilityByName('chen_divine_favor')
local SummonConvert     = bot:GetAbilityByName('chen_summon_convert')
local HandOfGod         = bot:GetAbilityByName('chen_hand_of_god')

local PenitenceDesire, PenitenceTarget
local HolyPersuasionDesire, HolyPersuasionTarget
local DivineFavorDesire, DivineFavorTarget
local SummonConvertDesire
local HandOfGodDesire

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
    bot = GetBot()

    if  bot.chen == nil then
        bot.chen = {
            creeps = {},
            consider_persuasion = false,
        }
    end

    if bot.chen and bot.chen.creeps then
        bot.chen.creeps = {}
        for _, unit in pairs(GetUnitList(UNIT_LIST_ALLIES)) do
            if J.IsValid(unit) and unit:HasModifier('modifier_chen_holy_persuasion') then
                table.insert(bot.chen.creeps, unit)
            end
        end
    end

    if bot:HasModifier('modifier_chen_hand_of_god_invuln_aura') then
        if HandOfGod and HandOfGod:IsTrained() then
            local nRadius = HandOfGod:GetSpecialValueInt('debuff_immune_radius')
            local nInRangeAlly = J.GetEnemiesNearLoc(bot:GetLocation(), nRadius + 200)
            if #nInRangeAlly <= 1 then
                bot:Action_ClearActions(true)
                return
            end
        end
    end

	if J.CanNotUseAbility(bot) then return end

    Penitence         = bot:GetAbilityByName('chen_penitence')
    HolyPersuasion    = bot:GetAbilityByName('chen_holy_persuasion')
    DivineFavor       = bot:GetAbilityByName('chen_divine_favor')
    SummonConvert     = bot:GetAbilityByName('chen_summon_convert')
    HandOfGod         = bot:GetAbilityByName('chen_hand_of_god')

    bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    HandOfGodDesire = X.ConsiderHandOfGod()
    if HandOfGodDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(HandOfGod)
        return
    end

    PenitenceDesire, PenitenceTarget = X.ConsiderPenitence()
    if PenitenceDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(Penitence, PenitenceTarget)
        return
    end

    SummonConvertDesire = X.ConsiderSummonConvert()
    if SummonConvertDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(SummonConvert)
        return
    end

    HolyPersuasionDesire, HolyPersuasionTarget = X.ConsiderHolyPersuasion()
    if HolyPersuasionDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(HolyPersuasion, HolyPersuasionTarget)
        return
    end

    DivineFavorDesire, DivineFavorTarget = X.ConsiderDivineFavor()
    if DivineFavorDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(DivineFavor, DivineFavorTarget)
        return
    end
end

function X.ConsiderPenitence()
    if not J.CanCastAbility(Penitence) then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = J.GetProperCastRange(false, bot, Penitence:GetCastRange())
    local nManaCost = Penitence:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {HolyPersuasion, DivineFavor, HandOfGod})
    local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {Penitence, HolyPersuasion, DivineFavor, HandOfGod})

    if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.CanCastOnTargetAdvanced(botTarget)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
            local nAllyHeroesTargetingTarget = J.GetHeroesTargetingUnit(nAllyHeroes, botTarget)
            if J.IsChasingTarget(bot, botTarget) and bot:GetCurrentMovementSpeed() < botTarget:GetCurrentMovementSpeed() then
                if botHP < 0.4 or #nAllyHeroesTargetingTarget > 0 then
                    return BOT_ACTION_DESIRE_HIGH, botTarget
                end
            end

            local nInRangeAlly = J.GetAlliesNearLoc(botTarget:GetLocation(), 800)
            if #nAllyHeroesTargetingTarget > 0 and #nInRangeAlly >= 2 then
                return BOT_ACTION_DESIRE_HIGH, botTarget
            end
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and not J.IsDisabled(enemyHero)
            and bot:WasRecentlyDamagedByHero(enemyHero, 3.0)
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero
            end
        end
	end

    if not J.IsRetreating(bot) and not J.IsRealInvisible(bot) and fManaAfter > fManaThreshold1 then
        for _, allyHero in pairs(nAllyHeroes) do
            if  J.IsValidHero(allyHero)
            and bot ~= allyHero
            and J.IsRetreating(allyHero)
            and allyHero:WasRecentlyDamagedByAnyHero(3.0)
            and not allyHero:IsIllusion()
            then
                for _, enemyHero in pairs(nEnemyHeroes) do
                    if  J.IsValidHero(enemyHero)
                    and J.IsInRange(bot, enemyHero, nCastRange)
                    and J.CanCastOnNonMagicImmune(enemyHero)
                    and J.CanCastOnTargetAdvanced(enemyHero)
                    and J.IsChasingTarget(enemyHero, allyHero)
                    and not J.IsDisabled(enemyHero)
                    then
                        return BOT_ACTION_DESIRE_HIGH, enemyHero
                    end
                end
            end
        end
    end

    if J.IsDoingRoshan(bot) then
        if J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.CanCastOnTargetAdvanced(botTarget)
        and bAttacking
        and fManaAfter > fManaThreshold2
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

    if J.IsDoingTormentor(bot) then
        if J.IsTormentor(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.CanCastOnTargetAdvanced(botTarget)
        and bAttacking
        and fManaAfter > fManaThreshold2
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderHolyPersuasion()
	if not J.CanCastAbility(HolyPersuasion) then
		return BOT_ACTION_DESIRE_NONE, nil
	end

    local nCastRange = J.GetProperCastRange(false, bot, HolyPersuasion:GetCastRange())
    local nMaxUnit = HolyPersuasion:GetSpecialValueInt('max_units')
    local nMaxUnitAncients = 0
    local nMaxLevel = HolyPersuasion:GetSpecialValueInt('level_req')
    local bCanTargetAncient = HolyPersuasion:GetSpecialValueInt('creep_ability_level') > 0
    local nManaCost = HolyPersuasion:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Penitence, DivineFavor, HandOfGod})

    if HandOfGod and HandOfGod:IsTrained() and bCanTargetAncient then
        nMaxUnitAncients = HandOfGod:GetSpecialValueInt('ancient_creeps_scepter')
    end

    local nAncientCreepsCount = 0
    for _, unit in pairs(GetUnitList(UNIT_LIST_ALLIES)) do
        if J.IsValid(unit) and unit:HasModifier('modifier_chen_holy_persuasion') then
            if unit:IsAncientCreep() then
                nAncientCreepsCount = nAncientCreepsCount + 1
            end
        end
    end

    local nGoodCreep = {
        ['npc_dota_neutral_alpha_wolf'] = true,
        ['npc_dota_neutral_centaur_khan'] = true,
        ['npc_dota_neutral_polar_furbolg_ursa_warrior'] = true,
        ['npc_dota_neutral_dark_troll_warlord'] = true,
        ['npc_dota_neutral_satyr_hellcaller'] = true,
        ['npc_dota_neutral_enraged_wildkin'] = true,
        ['npc_dota_neutral_warpine_raider'] = true,
        ['npc_dota_neutral_satyr_soulstealer'] = true,
        ['npc_dota_neutral_ogre_mauler'] = true,
        ['npc_dota_neutral_ogre_magi'] = true,
        ['npc_dota_neutral_mud_golem'] = true,
        ['npc_dota_neutral_grown_frog'] = true,
        ['npc_dota_neutral_grown_frog_mage'] = true,
    }

    if not J.IsRealInvisible(bot) and fManaAfter > fManaThreshold1 then
        if bCanTargetAncient and nAncientCreepsCount >= nMaxUnitAncients and #bot.chen.creeps == nMaxUnit then
            return BOT_MODE_DESIRE_NONE, nil
        end

        local nNeutralCreeps = bot:GetNearbyNeutralCreeps(1600)

        local target = nil
        local targetLevel = 0
        for _, creep in pairs(nNeutralCreeps) do
            if J.IsValid(creep) then
                local nCreepLevel = creep:GetLevel()
                local sCreepName = creep:GetUnitName()
                local bIsLaneCreep = string.find(sCreepName, 'melee') or string.find(sCreepName, 'ranged') or string.find(sCreepName, 'siege')

                if nGoodCreep[sCreepName] and creep:GetLevel() <= nMaxLevel then
                    return BOT_ACTION_DESIRE_HIGH, creep
                end

                if (bCanTargetAncient and nMaxUnitAncients > 0) or not creep:IsAncientCreep() then
                    if not bIsLaneCreep or J.IsInLaningPhase() then
                        if nCreepLevel <= nMaxLevel and nCreepLevel > targetLevel then
                            target = creep
                            targetLevel = nCreepLevel
                        end
                    end
                end
            end
        end

        if target then
            return BOT_ACTION_DESIRE_HIGH, target
        end
    end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderDivineFavor()
    if not J.CanCastAbility(DivineFavor) then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = J.GetProperCastRange(false, bot, DivineFavor:GetCastRange())
    local nManaCost = DivineFavor:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {HolyPersuasion, Penitence, HandOfGod})
    local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {Penitence, HolyPersuasion, DivineFavor, HandOfGod})

	for _, allyHero in pairs(nAllyHeroes) do
		if  J.IsValidHero(allyHero)
		and J.IsInRange(bot, allyHero, nCastRange)
        and not allyHero:HasModifier('modifier_abaddon_borrowed_time')
		and not allyHero:HasModifier('modifier_legion_commander_press_the_attack')
        and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not allyHero:HasModifier('modifier_chen_penitence_attack_speed_buff')
        and not allyHero:HasModifier('modifier_chen_divine_favor_armor_buff')
        and bot ~= allyHero
		then
            if allyHero:WasRecentlyDamagedByAnyHero(1.5) and J.GetHP(allyHero) < 0.6 then
                return BOT_ACTION_DESIRE_HIGH, allyHero
            end

            if allyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
            or allyHero:HasModifier('modifier_enigma_black_hole_pull')
            or allyHero:HasModifier('modifier_legion_commander_duel')
            then
                return BOT_ACTION_DESIRE_HIGH, allyHero
            end
		end
	end

    if J.IsInTeamFight(bot, 1200) then
        local distance = 0
        if bot.chen.creeps and #bot.chen.creeps > 0 then
            for _, creep in pairs(bot.chen.creeps) do
                if J.IsValid(creep) then
                    distance = distance + GetUnitToUnitDistance(bot, creep)
                end
            end

            if (distance / #bot.chen.creeps) > 1200 then
                return BOT_ACTION_DESIRE_HIGH, bot
            end
        end
    end

    local hTarget = nil
    local hTargetHealth = math.huge
    for _, allyHero in pairs(nAllyHeroes) do
        if  J.IsValidHero(allyHero)
        and J.IsInRange(bot, allyHero, nCastRange)
        and not allyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not allyHero:HasModifier('modifier_legion_commander_press_the_attack')
        and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not allyHero:HasModifier('modifier_chen_penitence_attack_speed_buff')
        and not allyHero:HasModifier('modifier_chen_divine_favor_armor_buff')
        and bot ~= allyHero
        then
            local allyHeroHealth = allyHero:GetHealth()
            if allyHeroHealth < hTargetHealth then
                hTarget = allyHero
                hTargetHealth = allyHeroHealth
            end
        end
    end

    if J.IsDoingRoshan(bot) then
        if J.IsRoshan(botTarget)
        and J.IsInRange(bot, botTarget, 1200)
        and J.CanCastOnTargetAdvanced(botTarget)
        and fManaAfter > fManaThreshold1
        then
            if hTarget and J.IsAttacking(hTarget) then
                return BOT_ACTION_DESIRE_HIGH, hTarget
            end
        end
    end

    if J.IsDoingTormentor(bot) then
        if J.IsTormentor(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, 1200)
        and fManaAfter > fManaThreshold1
        then
            if hTarget and J.IsAttacking(hTarget) then
                return BOT_ACTION_DESIRE_HIGH, hTarget
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderSummonConvert()
    if not J.CanCastAbility(SummonConvert) then
        return BOT_ACTION_DESIRE_NONE
    end

    if bot.chen and bot.chen.creeps then
        if HolyPersuasion then
            local nMaxUnit = HolyPersuasion:GetSpecialValueInt('max_units')
            if #bot.chen.creeps < nMaxUnit then
                if not (bot:WasRecentlyDamagedByAnyHero(1.0) and botHP < 0.12) then
                    return BOT_ACTION_DESIRE_HIGH
                end
            end
        end
    end

    if bot:GetUnitName() ~= 'npc_dota_hero_chen' then
        if not (bot:WasRecentlyDamagedByAnyHero(1.0) and botHP < 0.12) then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderHandOfGod()
	if not J.CanCastAbility(HandOfGod) then
		return BOT_ACTION_DESIRE_NONE
	end

    local nHealAmountInitial = HandOfGod:GetSpecialValueInt('heal_amount')
    local nHealPerSecond = HandOfGod:GetSpecialValueInt('heal_per_second')
    local nDuration = HandOfGod:GetSpecialValueInt('hot_duration')

    local vTeamFightLocation = J.GetTeamFightLocation(bot)

    if vTeamFightLocation ~= nil then
        local nInRangeAlly = J.GetAlliesNearLoc(vTeamFightLocation, 1600)
        local count = 0

        for _, allyHero in pairs(nInRangeAlly) do
            if  J.IsValidHero(allyHero)
            and J.CanBeAttacked(allyHero)
            and J.GetHP(allyHero) < 0.75
            and not J.IsSuspiciousIllusion(allyHero)
            and not allyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not allyHero:HasModifier('modifier_doom_bringer_doom_aura_enemy')
            and not allyHero:HasModifier('modifier_ice_blast')
            and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not allyHero:HasModifier('modifier_oracle_false_promise_timer')
            then
                count = count + 1
                if J.IsCore(allyHero) or count >= 2 then
                    return BOT_ACTION_DESIRE_HIGH
                end
            end
        end
    end

    for _, allyHero in pairs(GetUnitList(UNIT_LIST_ALLIED_HEROES)) do
        if  J.IsValidHero(allyHero)
        and J.CanBeAttacked(allyHero)
        and allyHero:DistanceFromFountain() > 1000
        and not J.IsSuspiciousIllusion(allyHero)
        and not allyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not allyHero:HasModifier('modifier_doom_bringer_doom_aura_enemy')
        and not allyHero:HasModifier('modifier_ice_blast')
        and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not allyHero:HasModifier('modifier_oracle_false_promise_timer')
        and not allyHero:HasModifier('modifier_fountain_aura_buff')
        then
            local nInRangeEnemy = J.GetEnemiesNearLoc(allyHero:GetLocation(), 1200)
            local nTotalDamage = J.GetTotalEstimatedDamageToTarget(nInRangeEnemy, allyHero, 6.0)

            if allyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
            or allyHero:HasModifier('modifier_enigma_black_hole_pull')
            or allyHero:HasModifier('modifier_legion_commander_duel')
            then
                if (J.IsCore(bot) or J.IsLateGame()) and J.GetHP(allyHero) < 0.5 then
                    return BOT_ACTION_DESIRE_HIGH
                end
            end

            if  J.IsRetreating(allyHero)
            and J.IsCore(allyHero)
            and J.GetHP(allyHero) < 0.5
            then
                if  #nInRangeEnemy >= 2
                and nTotalDamage > allyHero:GetHealth()
                and nTotalDamage < allyHero:GetHealth() + (nHealAmountInitial + nHealPerSecond * nDuration)
                then
                    return BOT_ACTION_DESIRE_HIGH
                end

                for _, enemyHero in pairs(nInRangeEnemy) do
                    if  J.IsValidHero(enemyHero)
                    and not J.IsSuspiciousIllusion(enemyHero)
                    and not J.IsDisabled(enemyHero)
                    and not enemyHero:IsDisarmed()
                    and allyHero:WasRecentlyDamagedByAnyHero(3.0)
                    and nTotalDamage + 150 < enemyHero:GetHealth()
                    then
                        if J.IsChasingTarget(enemyHero, allyHero) or J.IsDisabled(allyHero) then
                            return BOT_ACTION_DESIRE_HIGH
                        end
                    end
                end
            end
        end
    end

	return BOT_ACTION_DESIRE_NONE
end

return X