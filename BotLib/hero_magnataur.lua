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
                "item_circlet",
            
                "item_magic_wand",
                "item_null_talisman",
                "item_power_treads",
                "item_echo_sabre",
                "item_blink",
                "item_black_king_bar",--
                "item_aghanims_shard",
                "item_harpoon",--
                "item_bloodthorn",--
                "item_greater_crit",--
                "item_swift_blink",--
                "item_ultimate_scepter_2",
                "item_moon_shard",
                "item_travel_boots_2",--
            },
            ['sell_list'] = {
                "item_quelling_blade", "item_black_king_bar",
                "item_magic_wand", "item_bloodthorn",
                "item_null_talisman", "item_greater_crit",
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
                "item_circlet",
            
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
                "item_swift_blink",--
                "item_ultimate_scepter_2",
                "item_moon_shard",
                "item_travel_boots_2",--
            },
            ['sell_list'] = {
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
                "item_enchanted_mango",
            
                "item_magic_wand",
                "item_bracer",
                "item_null_talisman",
                "item_power_treads",
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

if bot.shouldBlink == nil then bot.shouldBlink = false end

local nAllyHeroes, nEnemyHeroes
local botTarget, nMana

function X.SkillsComplement()
    if J.CanNotUseAbility(bot) then return end

    if string.find(bot:GetUnitName(), 'rubick') then
        Shockwave         = bot:GetAbilityByName('magnataur_shockwave')
        Empower           = bot:GetAbilityByName('magnataur_empower')
        Skewer            = bot:GetAbilityByName('magnataur_skewer')
        HornToss          = bot:GetAbilityByName('magnataur_horn_toss')
        ReversePolarity   = bot:GetAbilityByName('magnataur_reverse_polarity')
    end

    nMana = J.GetMP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    X.ConsiderBlinkRPSkewer()
    X.ConsiderBlinkRP()
    X.ConsiderBlinkForHornTossSkewer()
    X.ConsiderBlinkForSkewer()

    ReversePolarityDesire = X.ConsiderReversePolarity()
    if ReversePolarityDesire > 0
    then
        bot:Action_UseAbility(ReversePolarity)
        return
    end

    HornTossDesire = X.ConsiderHornToss()
    if HornTossDesire > 0
    then
        bot:Action_UseAbility(HornToss)
        return
    end

    SkewerDesire, SkewerLocation = X.ConsiderSkewer()
    if SkewerDesire > 0
    then
        bot:Action_UseAbilityOnLocation(Skewer, SkewerLocation)
        return
    end

    ShockwaveDesire, ShockwaveLocation = X.ConsiderShockwave()
    if ShockwaveDesire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(Shockwave, ShockwaveLocation)
        return
    end

    EmpowerDesire, EmpowerTarget = X.ConsiderEmpower()
    if EmpowerDesire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(Empower, EmpowerTarget)
        return
    end
end

function X.ConsiderShockwave()
    if not J.CanCastAbility(Shockwave)
    then
        return BOT_ACTION_DESIRE_NONE, 0
    end

	local nCastRange = J.GetProperCastRange(false, bot, Shockwave:GetCastRange())
	local nCastPoint = Shockwave:GetCastPoint()
    local nRadius = Shockwave:GetSpecialValueInt('shock_width')
	local nDamage = Shockwave:GetSpecialValueInt('shock_damage')
	local nSpeed = Shockwave:GetSpecialValueInt('shock_speed')

    for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemyHero)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        and J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
        and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
        then
            local nDelay = (GetUnitToUnitDistance(bot, enemyHero) / nSpeed) + nCastPoint
            return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(enemyHero, nDelay)
        end
    end

	if J.IsGoingOnSomeone(bot) then
        if  J.IsValidHero(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange - 200)
        and J.IsChasingTarget(bot, botTarget)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_enigma_black_hole_pull')
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        then
            local nDelay = (GetUnitToUnitDistance(bot, botTarget) / nSpeed) + nCastPoint
            return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(botTarget, nDelay)
        end
	end

    if J.IsFarming(bot) and J.IsAttacking(bot) and J.GetManaAfter(Shockwave:GetManaCost()) > 0.25 then
        local nEnemyCreeps = bot:GetNearbyCreeps(nCastRange, true)
        if J.CanBeAttacked(nEnemyCreeps[1])
        and not J.IsRunning(nEnemyCreeps[1])
        then
            local nLocationAoE = bot:FindAoELocation(true, false, nEnemyCreeps[1]:GetLocation(), 0, nRadius, 0, 0)
            if (nLocationAoE.count >= 3)
            or (nLocationAoE.count >= 2 and nEnemyCreeps[1]:IsAncientCreep())
            then
                return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
            end
        end
    end

    local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(nCastRange, true)

	if (J.IsDefending(bot) or J.IsPushing(bot) and nMana > 0.47)
	then
        if #nEnemyLaneCreeps >= 4
        and J.CanBeAttacked(nEnemyLaneCreeps[1])
        and not J.IsRunning(nEnemyLaneCreeps[1])
        then
            local nLocationAoE = bot:FindAoELocation(true, false, nEnemyLaneCreeps[1]:GetLocation(), 0, nRadius, 0, 0)
            if nLocationAoE.count >= 4 then
                return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
            end
        end

        local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
        if nLocationAoE.count >= 1 then
            return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
        end
	end

    if J.IsLaning(bot) and nMana > 0.35 then
		for _, creep in pairs(nEnemyLaneCreeps) do
			if  J.IsValid(creep)
            and J.CanBeAttacked(creep)
			and J.IsKeyWordUnit('ranged', creep)
			and J.CanKillTarget(creep, nDamage, DAMAGE_TYPE_MAGICAL)
			then
				if J.IsValidHero(nEnemyHeroes[1])
				and GetUnitToUnitDistance(creep, nEnemyHeroes[1]) <= 500
				then
					return BOT_ACTION_DESIRE_HIGH, creep:GetLocation()
				end
			end
		end

        local nLocationAoE = bot:FindAoELocation(true, false, bot:GetLocation(), nCastRange - 200, nRadius, 0, nDamage)
        if nLocationAoE.count >= 2 and J.IsValidHero(nEnemyHeroes[1]) and GetUnitToLocationDistance(nEnemyHeroes[1], nLocationAoE.targetloc) <= 800 then
            return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
        end
	end

    if J.IsDoingRoshan(bot) and nMana > 0.4 then
        if  J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
    end

    if J.IsDoingTormentor(bot) and nMana > 0.4 then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
    end

    for _, allyHero in pairs(nAllyHeroes) do
        if J.IsValidHero(allyHero)
        and J.IsRetreating(allyHero)
        and allyHero:WasRecentlyDamagedByAnyHero(3.0)
        and not allyHero:IsIllusion()
        and nMana > 0.5
        then
            local nAllyInRangeEnemy = allyHero:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
            if J.IsValidHero(nAllyInRangeEnemy[1])
            and J.CanCastOnNonMagicImmune(nAllyInRangeEnemy[1])
            and J.IsInRange(allyHero, nAllyInRangeEnemy[1], 400)
            and J.IsInRange(bot, nAllyInRangeEnemy[1], nCastRange)
            and J.IsChasingTarget(nAllyInRangeEnemy[1], allyHero)
            and not J.IsDisabled(nAllyInRangeEnemy[1])
            and (GetUnitToUnitDistance(bot, allyHero) > GetUnitToUnitDistance(nAllyInRangeEnemy[1], allyHero) + 200)
            then
                local nDelay = (GetUnitToUnitDistance(bot, botTarget) / nSpeed) + nCastPoint
                return BOT_ACTION_DESIRE_HIGH, nAllyInRangeEnemy[1]:GetExtrapolatedLocation(nDelay + nCastPoint)
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderEmpower()
    if not J.CanCastAbility(Empower)
    then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = J.GetProperCastRange(false, bot, Empower:GetCastRange())
    local bEmpowered = bot:HasModifier('modifier_magnataur_empower')

    local hTarget = nil
	local nMaxDamage = 0
	for _, allyHero in pairs(nAllyHeroes)
	do
		if  J.IsValidHero(allyHero)
        and J.IsCore(allyHero)
        and not allyHero:IsIllusion()
        and not J.IsDisabled(allyHero)
        and (not J.IsWithoutTarget(allyHero))
        and not allyHero:HasModifier('modifier_magnataur_empower')
        and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not allyHero:HasModifier('modifier_skeleton_king_reincarnation_scepter_active')
		then
            local nDamage = allyHero:GetAttackDamage() * allyHero:GetAttackSpeed()
            if nDamage > nMaxDamage then
                hTarget = allyHero
                nMaxDamage = nDamage
            end
		end

        if J.IsValidHero(allyHero)
        and J.IsInRange(bot, allyHero, nCastRange)
        and J.IsCore(allyHero) and J.IsFarming(allyHero)
        and not allyHero:HasModifier('modifier_magnataur_empower')
        then
            return BOT_ACTION_DESIRE_HIGH, allyHero
        end
	end

    if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
        and J.IsInRange(bot, botTarget, 1600)
        and J.CanBeAttacked(botTarget)
        and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
		then
            if hTarget ~= nil then
                if hTarget == bot and J.IsInRange(bot, botTarget, 1200)
                then
                    return BOT_ACTION_DESIRE_HIGH, hTarget
                end

                if hTarget ~= bot and J.IsInRange(bot, hTarget, nCastRange) then
                    local hTarget_target = hTarget:GetAttackTarget()
                    if J.IsInRange(hTarget, botTarget, 800)
                    or (J.IsValidHero(hTarget_target) and J.IsInRange(hTarget, hTarget_target, 1200))
                    then
                        return BOT_ACTION_DESIRE_HIGH, hTarget
                    end
                end
            end
		end
	end

    if J.IsFarming(bot) and not bEmpowered and J.IsAttacking(bot) then
        local nEnemyCreeps = bot:GetNearbyCreeps(600, true)
        if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
            return BOT_ACTION_DESIRE_HIGH, bot
        end
    end

    local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(600, true)

	if (J.IsPushing(bot) or J.IsDefending(bot))
	then
		if #nEnemyLaneCreeps >= 4
        and J.CanBeAttacked(nEnemyLaneCreeps[1])
        and J.IsAttacking(bot)
        and not bEmpowered
        then
			return BOT_ACTION_DESIRE_HIGH, bot
		end

		local nEnemyTowers = bot:GetNearbyTowers(900, true)
		if J.IsValidBuilding(nEnemyTowers[1])
        and hTarget ~= nil
        and J.IsPushing(hTarget)
        and J.IsInRange(bot, hTarget, nCastRange)
        then
            if hTarget == bot then
                return BOT_ACTION_DESIRE_HIGH, hTarget
            end

            if hTarget ~= bot and J.IsInRange(hTarget, nEnemyTowers[1], 900) then
                return BOT_ACTION_DESIRE_HIGH, hTarget
            end
		end
	end

    if J.IsLaning(bot) then
		if #nEnemyLaneCreeps >= 3
        and J.CanBeAttacked(nEnemyLaneCreeps[1])
        and J.IsAttacking(bot)
        and not bEmpowered
        then
			return BOT_ACTION_DESIRE_HIGH, bot
		end
    end

    if hTarget ~= nil and J.IsInRange(bot, hTarget, nCastRange) then
        if J.IsDoingRoshan(bot) then
            if  J.IsRoshan(botTarget)
            and J.CanBeAttacked(botTarget)
            and J.IsInRange(bot, botTarget, 600)
            and J.IsAttacking(hTarget)
            then
                return BOT_ACTION_DESIRE_HIGH, hTarget
            end
        end

        if J.IsDoingTormentor(bot) then
            if  J.IsTormentor(botTarget)
            and J.IsInRange(bot, botTarget, 600)
            and J.IsAttacking(hTarget)
            then
                return BOT_ACTION_DESIRE_HIGH, hTarget
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

    local nDist = Skewer:GetSpecialValueInt('range')
	local nCastPoint = Skewer:GetCastPoint()
	local nSpeed = Skewer:GetSpecialValueInt('skewer_speed')
    local nRadius = Skewer:GetSpecialValueInt('skewer_radius')

    for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemyHero)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.IsInRange(bot, enemyHero, nDist)
        then
            local fDelay = (GetUnitToUnitDistance(bot, enemyHero) / nSpeed) + nCastPoint
            local fTPTime = J.GetModifierTime(enemyHero, 'modifier_teleporting')
            if fDelay < fTPTime then
                return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
            end

            if not J.IsRetreating(bot)
            and J.IsInLaningPhase(bot, enemyHero, nRadius)
            and J.CanBeAttacked(enemyHero)
            then
                local nAllyTowers = bot:GetNearbyTowers(1600, false)
                if J.IsValidBuilding(nAllyTowers[1])
                and nAllyTowers[1]:GetAttackTarget() == nil
                then
                    local nEnemyToTowerDist = GetUnitToUnitDistance(enemyHero, nAllyTowers[1])
                    if nEnemyToTowerDist < 850 and nEnemyToTowerDist > 300
                    and (nEnemyToTowerDist < GetUnitToUnitDistance(bot, nAllyTowers[1]))
                    then
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
        if  J.IsValidTarget(botTarget)
        and J.IsInRange(bot, botTarget, nDist)
        and J.CanCastOnNonMagicImmune(botTarget)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        then
            local nInRangeAlly = J.GetAlliesNearLoc(botTarget:GetLocation(), 1600)
            local nInRangeEnemy = J.GetEnemiesNearLoc(botTarget:GetLocation(), 1600)

            if #nInRangeAlly >= #nInRangeEnemy then
                local fDelay = (GetUnitToUnitDistance(bot, botTarget) / nSpeed) + nCastPoint

                if J.IsInLaningPhase() and #nInRangeAlly <= 1 then
                    if (#nInRangeAlly >= 3 or not botTarget:HasModifier('modifier_tower_aura_bonus'))
                    and J.GetTotalEstimatedDamageToTarget(nInRangeAlly, botTarget, 8.0, DAMAGE_TYPE_ALL) > botTarget:GetHealth() * 1.25 then
                        return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(botTarget, fDelay)
                    end
                else
                    local hAllyList = {}
                    for _ , ally in pairs(nInRangeAlly) do
                        if J.IsValidHero(ally)
                        and bot ~= ally
                        and not ally:IsIllusion()
                        and not ally:HasModifier('modifier_enigma_black_hole_pull')
                        and not ally:HasModifier('modifier_faceless_void_chronosphere_freeze')
                        and not ally:HasModifier('modifier_necrolyte_reapers_scythe')
                        then
                            table.insert(hAllyList, ally)
                        end
                    end

                    local vAllyCenter = J.GetCenterOfUnits(hAllyList)
                    if J.IsInRange(bot, botTarget, nRadius) then
                        if #nInRangeAlly > 1 and GetUnitToLocationDistance(bot, vAllyCenter) >= 500 then
                            return BOT_ACTION_DESIRE_HIGH, vAllyCenter
                        else
                            return BOT_ACTION_DESIRE_HIGH, J.GetTeamFountain()
                        end
                    end

                    if J.IsChasingTarget(bot, botTarget) and not J.IsInRange(bot, botTarget, 400) and J.GetHP(botTarget) < 0.25 and J.GetHP(bot) > 0.48 then
                        return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(botTarget, fDelay)
                    end
                end
            end
        end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
        if J.IsValidHero(nEnemyHeroes[1])
        and J.IsInRange(bot, nEnemyHeroes[1], 700)
        and not J.IsInRange(bot, nEnemyHeroes[1], nRadius + 150)
        and not J.IsSuspiciousIllusion(nEnemyHeroes[1])
        and not J.IsDisabled(nEnemyHeroes[1])
        and (  (#nAllyHeroes + 2 <= #nEnemyHeroes)
            or (J.IsChasingTarget(nEnemyHeroes[1], bot) and bot:WasRecentlyDamagedByAnyHero(3.0)))
        then
            return BOT_ACTION_DESIRE_HIGH, J.GetTeamFountain()
        end
	end

    return BOT_ACTION_DESIRE_NONE, 0
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
        local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), nRadius)
        if #nInRangeEnemy >= 2 and (J.IsCore(nInRangeEnemy[1]) or J.IsCore(nInRangeEnemy[2])) then
            if not nInRangeEnemy[1]:HasModifier('modifier_enigma_black_hole_pull')
            and not nInRangeEnemy[1]:HasModifier('modifier_faceless_void_chronosphere_freeze')
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
	end

    if J.IsGoingOnSomeone(bot) then
        if J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_enigma_black_hole_pull')
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        then
            if botTarget:HasModifier('modifier_teleporting') and (J.IsInLaningPhase() or (not J.IsInLaningPhase() and J.IsCore(botTarget))) then
                local fTPTime = J.GetModifierTime(botTarget, 'modifier_teleporting')
                local nInRangeAlly = J.GetAlliesNearLoc(botTarget:GetLocation(), 1200)

                if J.GetHP(botTarget) < 0.3
                and J.GetTotalEstimatedDamageToTarget(nInRangeAlly, botTarget, fTPTime) < botTarget:GetHealth()
                and J.GetTotalEstimatedDamageToTarget(nInRangeAlly, botTarget, fTPTime + fDuration) > botTarget:GetHealth()
                then
                    return BOT_ACTION_DESIRE_HIGH
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderHornToss()
    if not J.CanCastAbility(HornToss)
    then
        return BOT_ACTION_DESIRE_NONE
    end

    local nRadius = HornToss:GetSpecialValueInt('radius')

    if not J.CanCastAbility(Skewer) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.IsInRange(bot, enemyHero, nRadius)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    end

    if J.IsGoingOnSomeone(bot) then
        if  J.IsValidTarget(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.CanCastOnTargetAdvanced(botTarget)
        and bot:IsFacingLocation(botTarget:GetLocation(), 15)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_legion_commander_duel')
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
    and not J.CanCastAbility(Skewer)
    and (bot:WasRecentlyDamagedByAnyHero(3.0) or #nAllyHeroes < #nEnemyHeroes)
    then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.IsInRange(bot, enemyHero, nRadius)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and bot:IsFacingLocation(enemyHero:GetLocation(), 15)
            and bot:IsFacingLocation(J.GetTeamFountain(), 30)
            and not J.IsDisabled(enemyHero)
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
	end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderBlinkRP()
    if J.CanBlinkDagger(bot)
    and J.CanCastAbility(ReversePolarity)
    and bot:GetMana() > ReversePolarity:GetManaCost() + 150
    then
        bot.shouldBlink = true

        local nCastRange = 1199
        local nRadius = ReversePolarity:GetSpecialValueInt('pull_radius')

        if J.IsInTeamFight(bot, 1200) then
            local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
            local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)

            if #nInRangeEnemy >= 2
            and not J.IsLocationInChrono(nLocationAoE.targetloc)
            and not J.IsLocationInBlackHole(nLocationAoE.targetloc)
            then
                bot:Action_ClearActions(false)

                if J.CanBlackKingBar(bot) then
                    bot:ActionQueue_UseAbility(bot.BlackKingBar)
                    bot:ActionQueue_Delay(0.1)
                end

                bot:ActionQueue_UseAbilityOnLocation(bot.Blink, nLocationAoE.targetloc)
                bot:ActionQueue_Delay(0.1)
                bot:ActionQueue_UseAbility(ReversePolarity)
                return
            end
        end
    end

    bot.shouldBlink = false
    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderBlinkForSkewer()
    if J.CanBlinkDagger(bot)
    and J.CanCastAbility(Skewer)
    and bot:GetMana() > Skewer:GetManaCost() + 150
    then
        bot.shouldBlink = true

        if J.IsGoingOnSomeone(bot) then
            if  J.IsValidTarget(botTarget)
            and J.IsInRange(bot, botTarget, 1199)
            and J.CanCastOnNonMagicImmune(botTarget)
            and not botTarget:HasModifier('modifier_enigma_black_hole_pull')
            and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
            and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
            then
                local nInRangeAlly = J.GetAlliesNearLoc(botTarget:GetLocation(), 1600)
                local nInRangeEnemy = J.GetEnemiesNearLoc(botTarget:GetLocation(), 1600)

                if #nInRangeAlly >= 2 and #nInRangeAlly >= #nInRangeEnemy then
                    local hAllyList = {}
                    for _ , ally in pairs(nInRangeAlly) do
                        if J.IsValidHero(ally)
                        and bot ~= ally
                        and not ally:IsIllusion()
                        and not ally:HasModifier('modifier_enigma_black_hole_pull')
                        and not ally:HasModifier('modifier_faceless_void_chronosphere_freeze')
                        and not ally:HasModifier('modifier_necrolyte_reapers_scythe')
                        then
                            table.insert(hAllyList, ally)
                        end
                    end

                    local vLocation = J.GetTeamFountain()

                    if #nInRangeAlly > 1 then
                        vLocation = J.GetCenterOfUnits(hAllyList)
                    end

                    bot:Action_ClearActions(false)

                    if J.IsInTeamFight(bot, 1200) and J.CanBlackKingBar(bot) then
                        bot:ActionQueue_UseAbility(bot.BlackKingBar)
                        bot:ActionQueue_Delay(0.1)
                    end

                    bot:ActionQueue_UseAbilityOnLocation(bot.Blink, J.GetCorrectLoc(botTarget, 0.2))
                    bot:ActionQueue_Delay(0.1)
                    bot:ActionQueue_UseAbilityOnLocation(Skewer, vLocation)
                    return
                end
            end
        end
    end

    bot.shouldBlink = false
    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderBlinkRPSkewer()
    if J.CanBlinkDagger(bot)
    and J.CanCastAbility(ReversePolarity)
    and J.CanCastAbility(Skewer)
    and bot:GetMana() > (ReversePolarity:GetManaCost() + Skewer:GetManaCost() + 150)
    then
        bot.shouldBlink = true
        local nCastRange = 1199
        local nRadius = ReversePolarity:GetSpecialValueInt('pull_radius')

        if J.IsInTeamFight(bot, 1600) then
            local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
            local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)

            if #nInRangeEnemy >= 2
            and not J.IsLocationInChrono(nLocationAoE.targetloc)
            and not J.IsLocationInBlackHole(nLocationAoE.targetloc)
            then
                bot:Action_ClearActions(false)

                if J.CanBlackKingBar(bot) then
                    bot:ActionQueue_UseAbility(bot.BlackKingBar)
                    bot:ActionQueue_Delay(0.1)
                end

                bot:ActionQueue_UseAbilityOnLocation(bot.Blink, nLocationAoE.targetloc)
                bot:ActionQueue_Delay(0.1)
                bot:ActionQueue_UseAbility(ReversePolarity)
                bot:ActionQueue_Delay(0.3 + 1.3)
                bot:ActionQueue_UseAbilityOnLocation(Skewer, J.GetTeamFountain())
                return
            end
        end
    end

    bot.shouldBlink = false
    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderBlinkForHornTossSkewer()
    if J.CanBlinkDagger(bot)
    and J.CanCastAbility(HornToss)
    and J.CanCastAbility(Skewer)
    and bot:GetMana() > (HornToss:GetMana() + Skewer:GetMana() + 150)
    then
        bot.shouldBlink = true

        if J.IsGoingOnSomeone(bot) then
            if  J.IsValidTarget(botTarget)
            and J.IsInRange(bot, botTarget, 1199)
            and J.CanCastOnNonMagicImmune(botTarget)
            and J.CanCastOnTargetAdvanced(botTarget)
            and bot:IsFacingLocation(botTarget:GetLocation(), 15)
            and not J.IsDisabled(botTarget)
            and not botTarget:HasModifier('modifier_legion_commander_duel')
            then
                local nInRangeAlly = J.GetAlliesNearLoc(botTarget:GetLocation(), 1400)
                local nInRangeEnemy = J.GetEnemiesNearLoc(botTarget:GetLocation(), 1400)

                if #nInRangeAlly >= #nInRangeEnemy then
                    bot:Action_ClearActions(false)

                    if J.CanBlackKingBar(bot)
                    then
                        bot:ActionQueue_UseAbility(bot.BlackKingBar)
                        bot:ActionQueue_Delay(0.1)
                    end

                    bot:ActionQueue_UseAbilityOnLocation(bot.Blink, botTarget:GetLocation())
                    bot:ActionQueue_Delay(0.1)
                    bot:ActionQueue_UseAbility(HornToss)
                    bot:ActionQueue_Delay(0.2 + 0.79 + 0.6)
                    bot:ActionQueue_UseAbilityOnLocation(Skewer, J.GetTeamFountain())
                    return
                end
            end
        end
    end

    bot.shouldBlink = false
    return BOT_ACTION_DESIRE_NONE
end

return X