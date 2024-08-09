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
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
                [1] = {2,1,2,1,2,6,2,3,3,3,6,3,1,1,6},
            },
            ['buy_list'] = {
				"item_double_tango",
				"item_double_branches",
				"item_blood_grenade",
			
				"item_ring_of_basilius",
				"item_magic_wand",
				"item_vladmir",--
				"item_ancient_janggo",
				"item_boots",
				"item_solar_crest",--
				"item_aghanims_shard",
				"item_boots_of_bearing",--
				"item_glimmer_cape",--
				"item_holy_locket",--
				"item_assault",--
				"item_ultimate_scepter_2",
				"item_moon_shard",
			},
            ['sell_list'] = {},
        },
    },
    ['pos_5'] = {
        [1] = {
            ['talent'] = {
				[1] = {
					['t25'] = {0, 10},
					['t20'] = {0, 10},
					['t15'] = {10, 0},
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
                [1] = {1,2,2,3,2,6,3,1,1,1,6,3,3,3,6},
            },
            ['buy_list'] = {
				"item_double_tango",
				"item_double_branches",
				"item_blood_grenade",
			
				"item_ring_of_basilius",
				"item_magic_wand",
				"item_vladmir",--
				"item_mekansm",
				"item_boots",
				"item_pipe",--
				"item_aghanims_shard",
				"item_guardian_greaves",--
				"item_glimmer_cape",--
				"item_holy_locket",--
				"item_assault",--
				"item_ultimate_scepter_2",
				"item_moon_shard",
			},
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

if bot.ChenCreepList == nil then bot.ChenCreepList = {} end

local botTarget

function X.SkillsComplement()
	if J.CanNotUseAbility(bot) then return end

    Penitence         = bot:GetAbilityByName('chen_penitence')
    HolyPersuasion    = bot:GetAbilityByName('chen_holy_persuasion')
    DivineFavor       = bot:GetAbilityByName('chen_divine_favor')
    SummonConvert     = bot:GetAbilityByName('chen_summon_convert')
    HandOfGod         = bot:GetAbilityByName('chen_hand_of_god')

    botTarget = J.GetProperTarget(bot)

    HandOfGodDesire = X.ConsiderHandOfGod()
    if HandOfGodDesire > 0
    then
        bot:Action_UseAbility(HandOfGod)
        return
    end

    PenitenceDesire, PenitenceTarget = X.ConsiderPenitence()
    if PenitenceDesire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(Penitence, PenitenceTarget)
        return
    end

    SummonConvertDesire = X.ConsiderSummonConvert()
    if SummonConvertDesire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(SummonConvert)
        return
    end

    HolyPersuasionDesire, HolyPersuasionTarget = X.ConsiderHolyPersuasion()
    if HolyPersuasionDesire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(HolyPersuasion, HolyPersuasionTarget)
        return
    end

    DivineFavorDesire, DivineFavorTarget = X.ConsiderDivineFavor()
    if DivineFavorDesire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(DivineFavor, DivineFavorTarget)
        return
    end
end

function X.ConsiderPenitence()
    if not J.CanCastAbility(Penitence)
    then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = J.GetProperCastRange(false, bot, Penitence:GetCastRange())
    local nAttackRange = bot:GetAttackRange()

    local botTarget = J.GetProperTarget(bot)

    local nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    for _, allyHero in pairs(nAllyHeroes)
    do
        if  J.IsValidHero(allyHero)
        and J.IsInRange(bot, allyHero, nCastRange)
        and J.IsRetreating(allyHero)
        and allyHero:WasRecentlyDamagedByAnyHero(3)
        and not allyHero:IsIllusion()
        then
            local nAllyInRangeEnemy = allyHero:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

            if J.IsValidHero(nAllyInRangeEnemy[1])
            and J.IsInRange(bot, nAllyInRangeEnemy[1], nCastRange)
            and J.IsChasingTarget(nAllyInRangeEnemy[1], allyHero)
            and allyHero:GetCurrentMovementSpeed() < nAllyInRangeEnemy[1]:GetCurrentMovementSpeed()
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
        and J.IsInRange(bot, botTarget, nCastRange)
        and not J.IsSuspiciousIllusion(botTarget)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
            if J.IsChasingTarget(bot, botTarget)
            and bot:GetCurrentMovementSpeed() < botTarget:GetCurrentMovementSpeed()
            then
                return BOT_ACTION_DESIRE_HIGH, botTarget
            end

            local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), 1200)
            if  J.IsInRange(bot, botTarget, nAttackRange)
            and J.IsAttacking(bot)
            and J.GetHeroCountAttackingTarget(nInRangeAlly, botTarget) >= 2
            then
                return BOT_ACTION_DESIRE_HIGH, botTarget
            end
		end
	end

	if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
	then
        for _, enemyHero in pairs(nEnemyHeroes)
        do
            if  J.IsValidHero(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and J.IsChasingTarget(enemyHero, bot)
            and not J.IsSuspiciousIllusion(enemyHero)
            and not J.IsDisabled(enemyHero)
            and bot:GetCurrentMovementSpeed() < enemyHero:GetCurrentMovementSpeed()
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero
            end
        end
	end

	if J.IsDoingRoshan(bot) or J.IsDoingTormentor(bot)
	then
        local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), 800)

		if  (J.IsRoshan(botTarget) or J.IsTormentor(botTarget))
        and not botTarget:IsAttackImmune()
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.IsAttacking(bot)
        and nInRangeAlly ~= nil and #nInRangeAlly >= 1
        and J.GetHeroCountAttackingTarget(nInRangeAlly, botTarget) >= 2
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderHolyPersuasion()
	if not J.CanCastAbility(HolyPersuasion)
    then
		return BOT_ACTION_DESIRE_NONE, nil
	end

    local nCastRange = J.GetProperCastRange(false, bot, HolyPersuasion:GetCastRange())
    local nMaxUnit = HolyPersuasion:GetSpecialValueInt('max_units')
    local nMaxLevel = HolyPersuasion:GetSpecialValueInt('level_req')
	local nNeutralCreeps = bot:GetNearbyNeutralCreeps(nCastRange)

    local unitTable = {}
    for _, unit in pairs(GetUnitList(UNIT_LIST_ALLIES))
    do
        if string.find(unit:GetUnitName(), 'neutral')
        and unit:HasModifier('modifier_chen_holy_persuasion')
        then
            table.insert(unitTable, unit)
        end
    end

    bot.ChenCreepList = unitTable

    local nGoodCreep = {
        "npc_dota_neutral_alpha_wolf",
        "npc_dota_neutral_centaur_khan",
        "npc_dota_neutral_polar_furbolg_ursa_warrior",
        "npc_dota_neutral_dark_troll_warlord",
        "npc_dota_neutral_satyr_hellcaller",
        "npc_dota_neutral_enraged_wildkin",
        "npc_dota_neutral_warpine_raider",
    }

    if nMaxLevel < 5
    then
        for _, creep in pairs(nNeutralCreeps)
        do
            if J.IsValid(creep)
            then
                return BOT_ACTION_DESIRE_HIGH, creep
            end
        end
    else
        if bot.ChenCreepList ~= nil and #bot.ChenCreepList < nMaxUnit
        then
            for _, creep in pairs(nNeutralCreeps)
            do
                if J.IsValid(creep)
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
        end
    end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderDivineFavor()
    if not J.CanCastAbility(DivineFavor)
    then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = J.GetProperCastRange(false, bot, DivineFavor:GetCastRange())
    local nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	for _, allyHero in pairs(nAllyHeroes)
	do
		if  J.IsValidHero(allyHero)
		and J.IsInRange(bot, allyHero, nCastRange)
        and not allyHero:IsIllusion()
		and not allyHero:IsInvulnerable()
        and not allyHero:HasModifier('modifier_abaddon_borrowed_time')
		and not allyHero:HasModifier('modifier_legion_commander_press_the_attack')
        and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not allyHero:HasModifier('modifier_chen_penitence_attack_speed_buff')
        and not allyHero:HasModifier('modifier_chen_divine_favor_armor_buff')
		then
			if J.IsGoingOnSomeone(allyHero)
			then
				local allyTarget = allyHero:GetAttackTarget()

				if  J.IsValidTarget(allyTarget)
                and J.IsCore(allyHero)
				and J.IsInRange(allyHero, allyTarget, 1200)
                and not J.IsSuspiciousIllusion(allyTarget)
				then
					return BOT_ACTION_DESIRE_HIGH, allyHero
				end
			end

            if  J.IsRetreating(allyHero)
            and allyHero:WasRecentlyDamagedByAnyHero(3)
            then
                local nAllyInRangeEnemy = allyHero:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

                if J.IsValidHero(nAllyInRangeEnemy[1])
                and J.IsInRange(allyHero, nAllyInRangeEnemy[1], 700)
                and J.IsChasingTarget(nAllyInRangeEnemy[1], allyHero)
                and not J.IsDisabled(nAllyInRangeEnemy[1])
                and not J.IsSuspiciousIllusion(nAllyInRangeEnemy[1])
                and not nAllyInRangeEnemy[1]:HasModifier('modifier_necrolyte_reapers_scythe')
                then
                    return BOT_ACTION_DESIRE_HIGH, allyHero
                end
            end
		end
	end

    if J.IsDoingRoshan(bot) or J.IsDoingTormentor(bot)
	then
		if  (J.IsRoshan(botTarget) or J.IsTormentor(botTarget))
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.IsAttacking(bot)
		then
            local target = J.GetAttackableWeakestUnit(bot, nCastRange, true, false)

            if target ~= nil
            then
                return BOT_ACTION_DESIRE_HIGH, target
            end
        end
	end

    if J.IsInTeamFight(bot, 1200)
    then
        local totDist = 0

        if bot.ChenCreepList ~= nil
        then
            for _, creep in pairs(bot.ChenCreepList)
            do
                local dist = GetUnitToUnitDistance(bot, creep)
                if dist > 1600
                then
                    totDist = totDist + dist
                end
            end

            if bot.ChenCreepList ~= nil and #bot.ChenCreepList > 0
            then
                if (totDist / #bot.ChenCreepList) > 1600
                then
                    return BOT_ACTION_DESIRE_HIGH, bot
                end
            end
        end
    end

    if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
	then
        if  J.IsValidHero(nEnemyHeroes[1])
        and J.IsInRange(bot, nEnemyHeroes[1], nCastRange)
        and J.IsChasingTarget(nEnemyHeroes[1], bot)
        and not J.IsDisabled(nEnemyHeroes[1])
        and bot:WasRecentlyDamagedByAnyHero(3.5)
        then
            return BOT_ACTION_DESIRE_HIGH, bot
        end
	end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderSummonConvert()
    if not J.CanCastAbility(SummonConvert)
    or X.IsThereChenCreepAlive()
    then
        return BOT_ACTION_DESIRE_NONE
    end

    local botTarget = J.GetProperTarget(bot)

    if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
        and J.IsInRange(bot, botTarget, 900)
        and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
            return BOT_ACTION_DESIRE_HIGH
		end
	end

    if  (J.IsFarming(bot) or J.IsPushing(bot) or J.IsDefending(bot) or J.IsLaning(bot))
    and J.IsAttacking(bot)
    then
        return BOT_ACTION_DESIRE_HIGH
    end

    if J.IsDoingRoshan(bot) or J.IsDoingTormentor(bot)
	then
		if  (J.IsRoshan(botTarget) or J.IsTormentor(botTarget))
        and J.IsInRange(bot, botTarget, bot:GetAttackRange())
        and J.IsAttacking(bot)
		then
            return BOT_ACTION_DESIRE_HIGH
        end
	end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderHandOfGod()
	if not J.CanCastAbility(HandOfGod)
    then
		return BOT_ACTION_DESIRE_NONE
	end

    local nTeamFightLocation = J.GetTeamFightLocation(bot)

    if nTeamFightLocation ~= nil
    then
        local nAllyList = J.GetAlliesNearLoc(nTeamFightLocation, 1600)

        for _, allyHero in pairs(nAllyList)
        do
            if  J.IsValidHero(allyHero)
            and J.IsCore(allyHero)
            and not J.IsSuspiciousIllusion(allyHero)
            and not allyHero:IsAttackImmune()
			and not allyHero:IsInvulnerable()
            and J.GetHP(allyHero) < 0.63
            and allyHero:WasRecentlyDamagedByAnyHero(3)
            and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not allyHero:HasModifier('modifier_oracle_false_promise_timer')
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    end

    for _, allyHero in pairs(GetUnitList(UNIT_LIST_ALLIED_HEROES))
    do
        if  J.IsValidHero(allyHero)
        and J.IsRetreating(allyHero) and allyHero:GetActiveModeDesire() >= 0.65
        and allyHero:DistanceFromFountain() > 1000
        and J.IsCore(allyHero)
        and not allyHero:IsAttackImmune()
		and not allyHero:IsInvulnerable()
        and J.GetHP(allyHero) < 0.5
        and allyHero:WasRecentlyDamagedByAnyHero(4)
        and not J.IsSuspiciousIllusion(allyHero)
        and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not allyHero:HasModifier('modifier_oracle_false_promise_timer')
        then
            local nAllyInRangeEnemy = allyHero:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

            if  nAllyInRangeEnemy ~= nil and #nAllyInRangeEnemy >= 1
            and J.IsValidHero(nAllyInRangeEnemy[1])
            and J.IsChasingTarget(nAllyInRangeEnemy[1], allyHero)
            and not J.IsSuspiciousIllusion(nAllyInRangeEnemy[1])
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    end

	return BOT_ACTION_DESIRE_NONE
end

function X.IsThereChenCreepAlive()
    for _, unit in pairs(GetUnitList(UNIT_LIST_ALLIES))
    do
        if  string.find(unit:GetUnitName(), 'neutral')
        and unit:HasModifier('modifier_chen_holy_persuasion')
        then
            return true
        end
    end

    return false
end

return X