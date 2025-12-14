local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_magnataur'
then

local RI = require(GetScriptDirectory()..'/FunLib/util_role_item')

local sUtility = {"item_crimson_guard", "item_pipe", "item_lotus_orb", "item_heavens_halberd"}
local sUtilityItem = RI.GetBestUtilityItem(sUtility)

local HeroBuild = {
    ['pos_1'] = {
        [1] = {
            ['talent'] = {
                [1] = {
                    ['t25'] = {0, 10},
                    ['t20'] = {10, 0},
                    ['t15'] = {10, 0},
                    ['t10'] = {0, 10},
                },
                [2] = {
                    ['t25'] = {0, 10},
                    ['t20'] = {0, 10},
                    ['t15'] = {0, 10},
                    ['t10'] = {0, 10},
                },
            },
            ['ability'] = {
                -- [1] = {1,3,1,2,1,6,1,2,1,2,6,2,3,3,3,6}, -- +1 Q
                [1] = {1,3,2,2,2,6,2,3,3,3,6,1,1,1,6},
            },
            ['buy_list'] = {
                "item_quelling_blade",
                "item_double_branches",
                "item_tango",
                "item_double_circlet",
            
                "item_magic_wand",
                "item_bracer",
                "item_power_treads",
                "item_echo_sabre",
                "item_blink",
                "item_black_king_bar",--
                "item_aghanims_shard",
                "item_harpoon",--
                "item_bloodthorn",--
                "item_greater_crit",--
                "item_ultimate_scepter_2",
                "item_swift_blink",--
                "item_moon_shard",
                "item_travel_boots_2",--
            },
            ['sell_list'] = {
                "item_circlet", "item_blink",
                "item_quelling_blade", "item_black_king_bar",
                "item_magic_wand", "item_bloodthorn",
                "item_bracer", "item_greater_crit",
            },
        },
    },
    ['pos_2'] = {
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
                -- [1] = {1,3,1,2,1,6,1,2,1,2,6,2,3,3,3,6}, -- +1 Q
                [1] = {1,3,2,2,2,6,2,3,3,3,6,1,1,1,6},
            },
            ['buy_list'] = {
                "item_quelling_blade",
                "item_double_branches",
                "item_tango",
                "item_double_circlet",
            
                "item_bottle",
                "item_magic_wand",
                "item_null_talisman",
                "item_power_treads",
                "item_blink",
                "item_echo_sabre",
                "item_black_king_bar",--
                "item_aghanims_shard",
                "item_harpoon",--
                "item_bloodthorn",--
                "item_greater_crit",--
                "item_ultimate_scepter_2",
                "item_swift_blink",--
                "item_moon_shard",
                "item_travel_boots_2",--
            },
            ['sell_list'] = {
                "item_circlet", "item_blink",
                "item_quelling_blade", "item_echo_sabre",
                "item_magic_wand", "item_black_king_bar",
                "item_null_talisman", "item_bloodthorn",
                "item_bottle", "item_greater_crit",
            },
        },
    },
    ['pos_3'] = {
        [1] = {
            ['talent'] = {
                [1] = {
                    ['t25'] = {10, 0},
                    ['t20'] = {0, 10},
                    ['t15'] = {10, 0},
                    ['t10'] = {0, 10},
                }
            },
            ['ability'] = {
                -- [1] = {1,3,1,2,1,6,1,2,1,2,6,2,3,3,3,6}, -- +1 Q
                [1] = {1,3,2,2,2,6,2,3,3,3,6,1,1,1,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_double_circlet",
                "item_quelling_blade",
            
                "item_magic_wand",
                "item_bracer",
                "item_power_treads",
                "item_null_talisman",
                "item_blink",
                "item_echo_sabre",
                "item_black_king_bar",--
                sUtilityItem,--
                "item_harpoon",--
                "item_sheepstick",--
                "item_aghanims_shard",
                "item_ultimate_scepter_2",
                "item_arcane_blink",--
                "item_moon_shard",
                "item_travel_boots_2",--
            },
            ['sell_list'] = {
                "item_quelling_blade", "item_echo_sabre",
                "item_magic_wand", "item_black_king_bar",
                "item_bracer", sUtilityItem,
                "item_null_talisman", "item_sheepstick",
            },
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

function X.MinionThink(hMinionUnit)
    Minion.MinionThink(hMinionUnit)
end

end

local Shockwave         = bot:GetAbilityByName('magnataur_shockwave')
local Empower           = bot:GetAbilityByName('magnataur_empower')
local Skewer            = bot:GetAbilityByName('magnataur_skewer')
local HornToss          = bot:GetAbilityByName('magnataur_horn_toss')
local ReversePolarity   = bot:GetAbilityByName('magnataur_reverse_polarity')

local ShockwaveDesire, ShockwaveLocation
local EmpowerDesire, EmpowerTarget
local SkewerDesire, SkewerLocation
local HornTossDesire
local ReversePolarityDesire

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
    bot = GetBot()

    if J.CanNotUseAbility(bot) then return end

    Shockwave         = bot:GetAbilityByName('magnataur_shockwave')
    Empower           = bot:GetAbilityByName('magnataur_empower')
    Skewer            = bot:GetAbilityByName('magnataur_skewer')
    HornToss          = bot:GetAbilityByName('magnataur_horn_toss')
    ReversePolarity   = bot:GetAbilityByName('magnataur_reverse_polarity')

    bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    X.ConsiderBlinkSkewer()
    X.ConsiderBlinkRP()
    X.ConsiderBlinkHornTossSkewer()

    ReversePolarityDesire = X.ConsiderReversePolarity()
    if ReversePolarityDesire > 0 then
        bot:Action_UseAbility(ReversePolarity)
        return
    end

    HornTossDesire = X.ConsiderHornToss()
    if HornTossDesire > 0 then
        bot:Action_UseAbility(HornToss)
        return
    end

    SkewerDesire, SkewerLocation = X.ConsiderSkewer()
    if SkewerDesire > 0 then
        bot:Action_UseAbilityOnLocation(Skewer, SkewerLocation)
        return
    end

    ShockwaveDesire, ShockwaveLocation = X.ConsiderShockwave()
    if ShockwaveDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(Shockwave, ShockwaveLocation)
        return
    end

    EmpowerDesire, EmpowerTarget = X.ConsiderEmpower()
    if EmpowerDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(Empower, EmpowerTarget)
        return
    end
end

function X.ConsiderShockwave()
    if not J.CanCastAbility(Shockwave) then
        return BOT_ACTION_DESIRE_NONE, 0
    end

	local nCastRange = J.GetProperCastRange(false, bot, Shockwave:GetCastRange())
	local nCastPoint = Shockwave:GetCastPoint()
    local nRadius = Shockwave:GetSpecialValueInt('shock_width')
	local nDamage = Shockwave:GetSpecialValueInt('shock_damage')
	local nSpeed = Shockwave:GetSpecialValueInt('shock_speed')
    local nManaCost = Shockwave:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Empower, Skewer, HornToss, ReversePolarity})

    for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
        and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
        then
            local nDelay = (GetUnitToUnitDistance(bot, enemyHero) / nSpeed) + nCastPoint
            if J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL, nDelay) then
                return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(enemyHero, nDelay)
            end
        end
    end

	if J.IsGoingOnSomeone(bot) then
        if  J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange * 0.8)
        and not J.IsInRange(bot, botTarget, bot:GetAttackRange())
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_enigma_black_hole_pull')
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        then
            local nDelay = (GetUnitToUnitDistance(bot, botTarget) / nSpeed) + nCastPoint
            return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(botTarget, nDelay)
        end
	end

    local nEnemyCreeps = bot:GetNearbyCreeps(nCastRange, true)

    if J.IsPushing(bot) and bAttacking and fManaAfter > fManaThreshold1 + 0.1 and #nAllyHeroes <= 2 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 4)
                or (nLocationAoE.count >= 3 and creep:GetHealth() >= 550)
                then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

    if J.IsDefending(bot) and bAttacking and fManaAfter > fManaThreshold1 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 4)
                or (nLocationAoE.count >= 3 and creep:GetHealth() >= 550)
                then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end

        local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
		if nLocationAoE.count >= 2 then
			return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
		end
    end

    if J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold1 + 0.1 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 3)
                or (nLocationAoE.count >= 2 and creep:IsAncientCreep())
                or (nLocationAoE.count >= 1 and creep:GetHealth() >= 550)
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
			and not J.IsOtherAllysTarget(creep)
			then
				local nDelay = (GetUnitToUnitDistance(bot, creep) / nSpeed) + nCastPoint
				if J.WillKillTarget(creep, nDamage, DAMAGE_TYPE_MAGICAL, nDelay) then
					local sCreepName = creep:GetUnitName()
					local nLocationAoE = bot:FindAoELocation(true, true, creep:GetLocation(), 0, 600, 0, 0)

					if string.find(sCreepName, 'ranged') then
						if nLocationAoE.count > 0 or J.IsUnitTargetedByTower(creep, false) or J.IsEnemyTargetUnit(creep, 1200) then
							return BOT_ACTION_DESIRE_HIGH, creep:GetLocation()
						end
					end

					nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, nDamage)
					if nLocationAoE.count >= 2 then
						return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
					end
				end
			end
		end
	end

    if J.IsDoingRoshan(bot) then
        if  J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
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

function X.ConsiderEmpower()
    if not J.CanCastAbility(Empower) then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = J.GetProperCastRange(false, bot, Empower:GetCastRange())
    local nManaCost = Empower:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Shockwave, Skewer, HornToss, ReversePolarity})

    local bEmpowered = bot:HasModifier('modifier_magnataur_empower')

    local hTargetAlly = nil
	local hTargetAllyDamage = 0
	for _, allyHero in pairs(nAllyHeroes) do
		if  J.IsValidHero(allyHero)
        and J.IsInRange(bot, allyHero, nCastRange + 300)
        and not allyHero:IsIllusion()
        and not allyHero:HasModifier('modifier_magnataur_empower')
        and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not allyHero:HasModifier('modifier_skeleton_king_reincarnation_scepter_active')
		then
            local allyHeroDamage = allyHero:GetAttackDamage() * allyHero:GetAttackSpeed()

            if J.IsCore(allyHero) and not J.IsWithoutTarget(allyHero) then
                if allyHeroDamage > hTargetAllyDamage then
                    hTargetAlly = allyHero
                    hTargetAllyDamage = allyHeroDamage
                end
            end

            if J.IsFarming(allyHero) and fManaAfter > fManaThreshold1 then
                if J.IsCore(allyHero) or (allyHeroDamage > (bot:GetAttackDamage() * bot:GetAttackSpeed())) then
                    return BOT_ACTION_DESIRE_HIGH, allyHero
                end
            end

            if allyHero:HasModifier('modifier_legion_commander_duel') then
                return BOT_ACTION_DESIRE_HIGH, allyHero
            end
		end
	end

    if J.IsGoingOnSomeone(bot) then
		if  J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, 1600)
        and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
		then
            if hTargetAlly ~= nil then
                if hTargetAlly == bot and J.IsInRange(bot, botTarget, 1200) then
                    return BOT_ACTION_DESIRE_HIGH, hTargetAlly
                end

                if hTargetAlly ~= bot and J.IsInRange(bot, hTargetAlly, nCastRange) and fManaAfter > fManaThreshold1 then
                    local allyTarget = hTargetAlly:GetAttackTarget()

                    if (J.IsInRange(hTargetAlly, botTarget, 1200))
                    or (J.IsValidHero(allyTarget) and J.IsInRange(hTargetAlly, allyTarget, 1200))
                    then
                        return BOT_ACTION_DESIRE_HIGH, hTargetAlly
                    end
                end
            end
		end
	end

    local nEnemyCreeps = bot:GetNearbyCreeps(600, true)

    if J.IsFarming(bot) and not bEmpowered and bAttacking and fManaAfter > fManaThreshold1 + 0.1 then
        if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
            return BOT_ACTION_DESIRE_HIGH, bot
        end
    end

	if (J.IsPushing(bot) or J.IsDefending(bot)) and bAttacking and fManaAfter > fManaThreshold1 + 0.1 then
        if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) and not bEmpowered then
            if #nEnemyCreeps >= 3 then
                return BOT_ACTION_DESIRE_HIGH, bot
            end
        end
	end

    if J.IsLaning(bot) and J.IsInLaningPhase() and not bEmpowered and fManaAfter > fManaThreshold1 then
        local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(600, true)
        if J.IsValid(nEnemyLaneCreeps[1]) and J.CanBeAttacked(nEnemyLaneCreeps[1]) and not bEmpowered then
            if #nEnemyLaneCreeps >= 3 then
                return BOT_ACTION_DESIRE_HIGH, bot
            end
        end
    end

    if not J.IsRealInvisible(bot) and fManaAfter > fManaThreshold1 + 0.1 then
        if hTargetAlly then
            local allyTarget = J.GetProperTarget(hTargetAlly)
            if J.IsValidBuilding(allyTarget)
            and J.CanBeAttacked(allyTarget)
            and not allyTarget:HasModifier('modifier_backdoor_protection')
            and not allyTarget:HasModifier('modifier_backdoor_protection_active')
            and not allyTarget:HasModifier('modifier_backdoor_protection_in_base')
            and J.IsAttacking(hTargetAlly)
            then
                return BOT_ACTION_DESIRE_HIGH, hTargetAlly
            end
        end
    end

    if hTargetAlly and fManaAfter > fManaThreshold1 + 0.05 then
        if J.IsDoingRoshan(bot) then
            if  J.IsRoshan(botTarget)
            and J.CanBeAttacked(botTarget)
            and J.IsInRange(bot, botTarget, 800)
            and J.IsAttacking(hTargetAlly)
            then
                return BOT_ACTION_DESIRE_HIGH, hTargetAlly
            end
        end

        if J.IsDoingTormentor(bot) then
            if  J.IsTormentor(botTarget)
            and J.IsInRange(bot, botTarget, 600)
            and J.IsAttacking(hTargetAlly)
            then
                return BOT_ACTION_DESIRE_HIGH, hTargetAlly
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderSkewer()
    if not J.CanCastAbility(Skewer)
    or bot:IsRooted()
    then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nDistance = Skewer:GetSpecialValueInt('range')
	local nCastPoint = Skewer:GetCastPoint()
	local nSpeed = Skewer:GetSpecialValueInt('skewer_speed')
    local nRadius = Skewer:GetSpecialValueInt('skewer_radius')
    local nManaCost = Empower:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Shockwave, Empower, HornToss, ReversePolarity})

    for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.IsInRange(bot, enemyHero, nDistance)
        and J.CanCastOnNonMagicImmune(enemyHero)
        then
            local fDelay = (GetUnitToUnitDistance(bot, enemyHero) / nSpeed) + nCastPoint
            if J.GetModifierTime(enemyHero, 'modifier_teleporting') > fDelay then
                if #nAllyHeroes >= #nEnemyHeroes or J.IsInRange(bot, enemyHero, 550) then
                    return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
                end
            end

            if not J.IsRetreating(bot)
            and J.IsInLaningPhase()
            and J.IsInRange(bot, enemyHero, nRadius)
            then
                local nAllyTowers = bot:GetNearbyTowers(1000, false)
                if J.IsValidBuilding(nAllyTowers[1])
                and nAllyTowers[1]:GetAttackTarget() == nil
                then
                    local nEnemyToTowerDist = GetUnitToUnitDistance(enemyHero, nAllyTowers[1])
                    if nEnemyToTowerDist < 1000 and nEnemyToTowerDist > 600 then
                        return BOT_ACTION_DESIRE_HIGH, nAllyTowers[1]:GetLocation()
                    end
                end
            end
        end
    end

	if J.IsStuck(bot) then
		return BOT_ACTION_DESIRE_HIGH, J.GetTeamFountain()
	end

	if J.IsGoingOnSomeone(bot) then
        if  J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        then
            local nInRangeAlly = J.GetAlliesNearLoc(botTarget:GetLocation(), 1200)
            local nInRangeEnemy = J.GetEnemiesNearLoc(botTarget:GetLocation(), 1200)

            if J.IsInRange(bot, botTarget, nRadius) then
                local hTargetAlly = nil
                local hTargetAllyScore = 0
                for _ , allyHero in pairs(nAllyHeroes) do
                    if J.IsValidHero(allyHero)
                    and J.IsGoingOnSomeone(allyHero)
                    and J.IsInRange(bot, allyHero, nDistance + allyHero:GetAttackRange())
                    and not J.IsInRange(bot, allyHero, nDistance / 1.5)
                    and bot ~= allyHero
                    and not J.IsDisabled(allyHero)
                    and not allyHero:IsIllusion()
                    and not allyHero:HasModifier('modifier_doom_bringer_doom_aura_enemy')
                    and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
                    and not allyHero:HasModifier('modifier_ice_blast')
                    then
                        local allyHeroScore = allyHero:GetEstimatedDamageToTarget(true, botTarget, 5.0, DAMAGE_TYPE_ALL)
                        if allyHeroScore > hTargetAllyScore then
                            hTargetAlly = allyHero
                            hTargetAllyScore = allyHeroScore
                        end
                    end
                end

                if hTargetAlly then
                    return BOT_ACTION_DESIRE_HIGH, hTargetAlly:GetLocation()
                end

                if #nInRangeAlly <= 1 then
                    return BOT_ACTION_DESIRE_HIGH, J.GetTeamFountain()
                end
            else
                if J.IsInRange(bot, botTarget, nDistance - 200) then
                    if #nInRangeAlly >= #nInRangeEnemy then
                        local fDelay = (GetUnitToUnitDistance(bot, botTarget) / nSpeed) + nCastPoint
                        if J.IsEarlyGame() then
                            local nInRangeAlly_Engage = J.GetSpecialModeAllies(bot, 800, BOT_MODE_ATTACK)
                            if J.GetTotalEstimatedDamageToTarget(nInRangeAlly_Engage, botTarget, 5.0, DAMAGE_TYPE_ALL) > botTarget:GetHealth() + 200 then
                                local vLocation = J.GetCorrectLoc(botTarget, fDelay)
                                if GetUnitToLocationDistance(bot, vLocation) <= nDistance then
                                    return BOT_ACTION_DESIRE_HIGH, vLocation
                                end
                            end
                        else
                            if J.IsChasingTarget(bot, botTarget) and not J.IsInRange(bot, botTarget, bot:GetAttackRange() + 150) and botHP > 0.4 then
                                local vLocation = J.VectorAway(botTarget:GetLocation(), bot:GetLocation(), 350)
                                if GetUnitToLocationDistance(bot, vLocation) <= nDistance then
                                    return BOT_ACTION_DESIRE_HIGH, vLocation
                                end
                            end
                        end
                    end
                end
            end
        end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
		if not bot:HasModifier('modifier_fountain_aura_buff') then
            if #nEnemyHeroes > #nAllyHeroes or bot:WasRecentlyDamagedByAnyHero(4.0) then
                return BOT_ACTION_DESIRE_HIGH, J.GetTeamFountain()
            end
		end
	end

	if J.IsFarming(bot) and fManaAfter > 0.88 then
		if bot.farm and bot.farm.location then
			local distance = GetUnitToLocationDistance(bot, bot.farm.location)
			if J.IsRunning(bot) and distance > nDistance * 0.8 and IsLocationPassable(bot.farm.location) then
				return BOT_ACTION_DESIRE_HIGH, bot.farm.location
			end
		end
	end

	if J.IsGoingToRune(bot) and fManaAfter > fManaThreshold1 + 0.1 then
		if bot.rune and bot.rune.location and bot.rune.normal and bot.rune.normal.status == RUNE_STATUS_AVAILABLE then
            local nInRangeEnemy = J.GetEnemiesNearLoc(bot.rune.location, 900)
            if #nInRangeEnemy > 0 then
                local distance = GetUnitToLocationDistance(bot, bot.rune.location)
                if J.IsRunning(bot) and distance > nDistance / 2 and IsLocationPassable(bot.rune.location) then
                    return BOT_ACTION_DESIRE_HIGH, bot.rune.location
                end
            end
		end
	end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderHornToss()
    if not J.CanCastAbility(HornToss) then
        return BOT_ACTION_DESIRE_NONE
    end

    local nRadius = HornToss:GetSpecialValueInt('radius')
    local nPullAngle = HornToss:GetSpecialValueInt('pull_angle')

    if J.IsGoingOnSomeone(bot) then
        if  J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        and J.CanCastOnNonMagicImmune(botTarget)
        and bot:IsFacingLocation(botTarget:GetLocation(), nPullAngle)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_legion_commander_duel')
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.IsInRange(bot, enemyHero, nRadius)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and bot:IsFacingLocation(enemyHero:GetLocation(), nPullAngle * 0.6)
            and bot:IsFacingLocation(J.GetTeamFountain(), 30)
            and not J.IsDisabled(enemyHero)
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
	end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderReversePolarity()
    if not J.CanCastAbility(ReversePolarity)
    or bot:HasModifier('modifier_magnataur_skewer_movement')
    then
        return BOT_ACTION_DESIRE_NONE
    end

    local nRadius = ReversePolarity:GetSpecialValueInt('pull_radius')
	local nDamage = ReversePolarity:GetSpecialValueInt('polarity_damage')
    local fDuration = ReversePolarity:GetSpecialValueFloat('hero_stun_duration')

    if J.IsInTeamFight(bot, 1200) then
        local count = 0
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nRadius)
            and not J.IsSuspiciousIllusion(enemyHero)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_enigma_black_hole_pull')
            and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            then
                if J.IsCore(enemyHero) then
                    count = count + 1
                else
                    count = count + 0.5
                end
            end
        end

        if count >= 1.5 then
            return BOT_ACTION_DESIRE_HIGH
        end
	end

    if J.IsGoingOnSomeone(bot) then
        if J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_enigma_black_hole_pull')
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        then
            if botTarget:HasModifier('modifier_teleporting') and (J.IsEarlyGame() or J.IsCore(botTarget)) then
                local fModifierTime = J.GetModifierTime(botTarget, 'modifier_teleporting')
                if  J.GetTotalEstimatedDamageToTarget(nAllyHeroes, botTarget, fModifierTime) < botTarget:GetHealth()
                and J.GetTotalEstimatedDamageToTarget(nAllyHeroes, botTarget, fModifierTime + fDuration) > botTarget:GetHealth()
                then
                    return BOT_ACTION_DESIRE_HIGH
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderBlinkRP()
    if J.CanBlinkDagger(bot) and J.CanCastAbility(ReversePolarity) and (bot:GetMana() > (ReversePolarity:GetManaCost() + 100)) then
        local nCastRange = Max(bot.Blink:GetCastRange(), 1200)
        local nRadius = ReversePolarity:GetSpecialValueInt('pull_radius')

        if J.IsInTeamFight(bot, 1400) then
            local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
            local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius * 0.8)
            if #nInRangeEnemy >= 2 then
                local count = 0
                for _, enemyHero in pairs(nInRangeEnemy) do
                    if  J.IsValidHero(enemyHero)
                    and J.CanBeAttacked(enemyHero)
                    and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
                    and not enemyHero:HasModifier('modifier_enigma_black_hole_pull')
                    and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
                    and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
                    then
                        if J.IsCore(enemyHero) then
                            count = count + 1
                        else
                            count = count + 0.5
                        end
                    end
                end

                if count >= 1.5 then
                    bot:Action_ClearActions(false)

                    local BlackKingBar = J.IsItemAvailable('item_black_king_bar')
                    if J.CanCastAbility(BlackKingBar) and (bot:GetMana() > (ReversePolarity:GetManaCost() + BlackKingBar:GetManaCost() + 100)) and not bot:IsMagicImmune() then
                        bot:ActionQueue_UseAbility(BlackKingBar)
                        bot:ActionQueue_Delay(0.1)
                    end

                    bot:ActionQueue_UseAbilityOnLocation(bot.Blink, nLocationAoE.targetloc)
                    bot:ActionQueue_Delay(0.1)
                    bot:ActionQueue_UseAbility(ReversePolarity)
                    return
                end
            end
        end
    end
end

function X.ConsiderBlinkSkewer()
    if J.CanBlinkDagger(bot) and J.CanCastAbility(Skewer) and (bot:GetMana() > (Skewer:GetManaCost() + 100)) then
        local nCastRange = Max(bot.Blink:GetCastRange(), 1200)
        local nDistance = Skewer:GetSpecialValueInt('range')

        if J.IsGoingOnSomeone(bot) then
            if  J.IsValidHero(botTarget)
            and J.CanBeAttacked(botTarget)
            and J.IsInRange(bot, botTarget, nCastRange)
            and not J.IsInRange(bot, botTarget, 650)
            and J.CanCastOnNonMagicImmune(botTarget)
            and GetUnitToLocationDistance(botTarget, J.GetEnemyFountain()) > 1200
            and not botTarget:HasModifier('modifier_enigma_black_hole_pull')
            and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
            and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
            then
                local nInRangeAlly = J.GetAlliesNearLoc(botTarget:GetLocation(), nDistance + 350)
                local nInRangeEnemy = J.GetEnemiesNearLoc(botTarget:GetLocation(), nDistance + 350)

                if #nInRangeAlly >= 2 and #nInRangeAlly >= #nInRangeEnemy then
                    local hTargetAlly = nil
                    local hTargetAllyScore = 0
                    for _ , allyHero in pairs(nAllyHeroes) do
                        if J.IsValidHero(allyHero)
                        and bot ~= allyHero
                        and J.IsGoingOnSomeone(allyHero)
                        and J.IsInRange(allyHero, botTarget, nDistance + allyHero:GetAttackRange())
                        and not J.IsInRange(allyHero, botTarget, 650)
                        and not J.IsDisabled(allyHero)
                        and not allyHero:IsIllusion()
                        and not allyHero:HasModifier('modifier_doom_bringer_doom_aura_enemy')
                        and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
                        and not allyHero:HasModifier('modifier_ice_blast')
                        then
                            local allyHeroScore = allyHero:GetEstimatedDamageToTarget(true, botTarget, 5.0, DAMAGE_TYPE_ALL)
                            if allyHeroScore > hTargetAllyScore then
                                hTargetAlly = allyHero
                                hTargetAllyScore = allyHeroScore
                            end
                        end
                    end

                    if hTargetAlly then
                        bot:Action_ClearActions(false)

                        if J.IsInTeamFight(hTargetAlly, 1200) then
                            local BlackKingBar = J.IsItemAvailable('item_black_king_bar')
                            if J.CanCastAbility(BlackKingBar) and (bot:GetMana() > (Skewer:GetManaCost() + BlackKingBar:GetManaCost() + 100)) and not bot:IsMagicImmune() then
                                bot:ActionQueue_UseAbility(BlackKingBar)
                                bot:ActionQueue_Delay(0.1)
                            end
                        end

                        bot:ActionQueue_UseAbilityOnLocation(bot.Blink, botTarget:GetLocation())
                        bot:ActionQueue_Delay(0.1)
                        bot:ActionQueue_UseAbilityOnLocation(Skewer, hTargetAlly:GetLocation())
                        return
                    end
                end
            end
        end
    end
end

function X.ConsiderBlinkHornTossSkewer()
    if J.CanBlinkDagger(bot) and J.CanCastAbility(HornToss) and J.CanCastAbility(Skewer) and (bot:GetMana() > (HornToss:GetManaCost() + Skewer:GetManaCost() + 100)) then
        local nCastRange = Max(bot.Blink:GetCastRange(), 1200)
        local nDistance = Skewer:GetSpecialValueInt('range')

        if J.IsGoingOnSomeone(bot) then
            if  J.IsValidHero(botTarget)
            and J.CanBeAttacked(botTarget)
            and J.IsInRange(bot, botTarget, nCastRange)
            and not J.IsInRange(bot, botTarget, 650)
            and J.CanCastOnNonMagicImmune(botTarget)
            and GetUnitToLocationDistance(botTarget, J.GetEnemyFountain()) > 1200
            and not botTarget:HasModifier('modifier_enigma_black_hole_pull')
            and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
            and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
            then
                local nInRangeAlly = J.GetAlliesNearLoc(botTarget:GetLocation(), nDistance + 350)
                local nInRangeEnemy = J.GetEnemiesNearLoc(botTarget:GetLocation(), nDistance + 350)

                if #nInRangeAlly >= 2 and #nInRangeAlly >= #nInRangeEnemy then
                    local hTargetAlly = nil
                    local hTargetAllyScore = 0
                    for _ , allyHero in pairs(nAllyHeroes) do
                        if J.IsValidHero(allyHero)
                        and bot ~= allyHero
                        and J.IsGoingOnSomeone(allyHero)
                        and J.IsInRange(allyHero, botTarget, nDistance + allyHero:GetAttackRange())
                        and not J.IsInRange(allyHero, botTarget, 650)
                        and not J.IsDisabled(allyHero)
                        and not allyHero:IsIllusion()
                        and not allyHero:HasModifier('modifier_doom_bringer_doom_aura_enemy')
                        and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
                        and not allyHero:HasModifier('modifier_ice_blast')
                        then
                            local allyHeroScore = allyHero:GetEstimatedDamageToTarget(true, botTarget, 5.0, DAMAGE_TYPE_ALL)
                            if allyHeroScore > hTargetAllyScore then
                                hTargetAlly = allyHero
                                hTargetAllyScore = allyHeroScore
                            end
                        end
                    end

                    if hTargetAlly then
                        bot:Action_ClearActions(false)

                        if J.IsInTeamFight(hTargetAlly, 1200) then
                            local BlackKingBar = J.IsItemAvailable('item_black_king_bar')
                            if J.CanCastAbility(BlackKingBar) and (bot:GetMana() > (HornToss:GetManaCost() + Skewer:GetManaCost() + BlackKingBar:GetManaCost() + 100)) and not bot:IsMagicImmune() then
                                bot:ActionQueue_UseAbility(BlackKingBar)
                                bot:ActionQueue_Delay(0.1)
                            end
                        end

                        bot:ActionQueue_UseAbilityOnLocation(bot.Blink, J.VectorTowards(botTarget:GetLocation(), bot:GetLocation(), 325 / 2))
                        bot:ActionQueue_Delay(0.1)
                        bot:ActionQueue_UseAbility(HornToss)
                        bot:ActionQueue_UseAbilityOnLocation(Skewer, hTargetAlly:GetLocation())
                        return
                    end
                end
            end
        end
    end
end

return X