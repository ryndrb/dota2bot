local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_visage'
then

local RI = require(GetScriptDirectory()..'/FunLib/util_role_item')

local sUtility = {"item_pipe", "item_crimson_guard"}
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
                [1] = {2,1,1,3,1,6,1,3,3,3,6,2,2,2,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_double_circlet",
                "item_faerie_fire",
            
                "item_bottle",
                "item_magic_wand",
                "item_null_talisman",
                "item_bracer",
                "item_power_treads",
                "item_vladmir",
                "item_orchid",
                "item_aghanims_shard",
                "item_black_king_bar",--
                "item_assault",--
                "item_bloodthorn",--
                "item_nullifier",--
                "item_ultimate_scepter_2",
                "item_angels_demise",--
                "item_moon_shard",
                "item_travel_boots_2",--
            },
            ['sell_list'] = {
                "item_magic_wand", "item_vladmir",
                "item_null_talisman", "item_black_king_bar",
                "item_bracer", "item_assault",
                "item_bottle", "item_nullifier",
                "item_vladmir", "item_travel_boots_2",
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
                },
            },
            ['ability'] = {
                [1] = {2,1,1,3,1,6,1,3,3,3,6,2,2,2,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_double_circlet",
                "item_faerie_fire",
            
                "item_magic_wand",
                "item_boots",
                "item_double_bracer",
                "item_arcane_boots",
                "item_vladmir",
                "item_pipe",--
                "item_assault",--
                "item_aghanims_shard",
                "item_black_king_bar",--
                "item_bloodthorn",--
                "item_ultimate_scepter_2",
                "item_shivas_guard",--
                "item_moon_shard",
                "item_travel_boots_2",--
            },
            ['sell_list'] = {
                "item_magic_wand", "item_assault",
                "item_bracer", "item_black_king_bar",
                "item_bracer", "item_bloodthorn",
                "item_vladmir", "item_travel_boots_2",
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
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
                [1] = {2,1,2,3,2,6,2,1,1,1,6,3,3,3,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_magic_stick",
				"item_blood_grenade",
				"item_faerie_fire",
			
				"item_tranquil_boots",
				"item_magic_wand",
                "item_phylactery",
                "item_solar_crest",--
                "item_ancient_janggo",
                "item_glimmer_cape",--
				"item_aghanims_shard",
                "item_boots_of_bearing",--
                "item_lotus_orb",--
                "item_shivas_guard",--
                "item_angels_demise",--
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
					['t25'] = {0, 10},
					['t20'] = {0, 10},
					['t15'] = {0, 10},
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
                [1] = {2,1,2,3,2,6,2,1,1,1,6,3,3,3,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_magic_stick",
				"item_blood_grenade",
				"item_faerie_fire",
			
				"item_arcane_boots",
				"item_magic_wand",
                "item_phylactery",
                "item_solar_crest",--
                "item_mekansm",
                "item_glimmer_cape",--
				"item_aghanims_shard",
                "item_guardian_greaves",--
                "item_lotus_orb",--
                "item_shivas_guard",--
                "item_angels_demise",--
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

local GraveChill        = bot:GetAbilityByName('visage_grave_chill')
local SoulAssumption    = bot:GetAbilityByName('visage_soul_assumption')
local GravekeepersCloak = bot:GetAbilityByName('visage_gravekeepers_cloak')
local SilentAsTheGrave  = bot:GetAbilityByName('visage_silent_as_the_grave')
local SummonFamiliars   = bot:GetAbilityByName('visage_summon_familiars')

local GraveChillDesire, GraveChillTarget
local SoulAssumptionDesire, SoulAssumptionTarget
local GravekeepersCloakDesire
local SilentAsTheGraveDesire
local SummonFamiliarsDesire

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
	if J.CanNotUseAbility(bot) then return end

    GraveChill        = bot:GetAbilityByName('visage_grave_chill')
    SoulAssumption    = bot:GetAbilityByName('visage_soul_assumption')
    GravekeepersCloak = bot:GetAbilityByName('visage_gravekeepers_cloak')
    SilentAsTheGrave  = bot:GetAbilityByName('visage_silent_as_the_grave')
    SummonFamiliars   = bot:GetAbilityByName('visage_summon_familiars')

    bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    GraveChillDesire, GraveChillTarget = X.ConsiderGraveChill()
    if GraveChillDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(GraveChill, GraveChillTarget)
        return
    end

    SoulAssumptionDesire, SoulAssumptionTarget = X.ConsiderSoulAssumption()
    if SoulAssumptionDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(SoulAssumption, SoulAssumptionTarget)
        return
    end

    GravekeepersCloakDesire = X.ConsiderGravekeepersCloak()
    if GravekeepersCloakDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(GravekeepersCloak)
        return
    end

    SilentAsTheGraveDesire = X.ConsiderSilentAsTheGrave()
    if SilentAsTheGraveDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(SilentAsTheGrave)
        return
    end

    -- Bugged...
    -- Summons when using Buff (bots/Buff/Spells.lua)
    -- SummonFamiliarsDesire = X.ConsiderSummonFamiliars()
    -- if SummonFamiliarsDesire > 0 then
    --     bot:Action_UseAbility(SummonFamiliars)
    --     return
    -- end
end

function X.ConsiderGraveChill()
    if not J.CanCastAbility(GraveChill) then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = J.GetProperCastRange(false, bot, GraveChill:GetCastRange())
    local nManaCost = GraveChill:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {SoulAssumption, GravekeepersCloak, SilentAsTheGrave, SummonFamiliars})

	if J.IsGoingOnSomeone(bot) then
        local hTarget = nil
        local hTargetDamage = 0
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and not J.IsDisabled(enemyHero)
            and not enemyHero:IsDisarmed()
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemyHero:HasModifier('modifier_teleporting')
            then
                local enemyHeroDamage = enemyHero:GetAttackDamage() * enemyHero:GetAttackSpeed()
                if enemyHeroDamage > hTargetDamage then
                    hTarget = enemyHero
                    hTargetDamage = enemyHeroDamage
                end
            end
        end

        if hTarget then
            return BOT_ACTION_DESIRE_HIGH, hTarget
        end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and not J.IsDisabled(enemyHero)
            and not enemyHero:IsDisarmed()
            and not enemyHero:HasModifier('modifier_teleporting')
            and bot:WasRecentlyDamagedByHero(enemyHero, 3.0)
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero
            end
        end
	end

    if J.IsDoingRoshan(bot) then
        if  J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not J.IsDisabled(botTarget)
        and not botTarget:IsDisarmed()
        and bAttacking
        and fManaAfter > fManaThreshold1 + 0.1
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

    if J.IsDoingTormentor(bot) then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and bAttacking
        and fManaAfter > fManaThreshold1 + 0.1
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderSoulAssumption()
    if not J.CanCastAbility(SoulAssumption) then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nStacks = J.GetModifierCount(bot, 'modifier_visage_soul_assumption')

	local nCastRange = J.GetProperCastRange(false, bot, SoulAssumption:GetCastRange())
    local nCastPoint = SoulAssumption:GetCastPoint()
    local nSpeed = SoulAssumption:GetSpecialValueInt('bolt_speed')
	local nStackLimit = SoulAssumption:GetSpecialValueInt('stack_limit')
	local nBaseDamage = SoulAssumption:GetSpecialValueInt('soul_base_damage')
	local nChargeDamage = SoulAssumption:GetSpecialValueInt('soul_charge_damage')
	local nDamage = nBaseDamage + (nStacks * nChargeDamage)
    local nManaCost = SoulAssumption:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {GraveChill, GravekeepersCloak, SilentAsTheGrave, SummonFamiliars})

    for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanCastOnTargetAdvanced(enemyHero)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
        and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
        then
            local eta = (GetUnitToUnitDistance(bot, enemyHero) / nSpeed) + nCastPoint
            if J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL, eta) then
                return BOT_ACTION_DESIRE_HIGH, enemyHero
            end
        end
    end

    if J.IsGoingOnSomeone(bot) then
        local hTarget = nil
        local hTargetScore = 0
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and not J.IsSuspiciousIllusion(enemyHero)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
            and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
            and nStacks == nStackLimit
            then
                local enemyHeroScore = enemyHero:GetActualIncomingDamage(nDamage, DAMAGE_TYPE_MAGICAL) / enemyHero:GetHealth()
                if enemyHeroScore > hTargetScore then
                    hTarget = enemyHero
                    hTargetScore = enemyHeroScore
                end
            end
        end

        if hTarget then
            return BOT_ACTION_DESIRE_HIGH, hTarget
        end
	end

    local nEnemyCreeps = bot:GetNearbyCreeps(Min(nCastRange + 300, 1600), true)

	if J.IsLaning(bot) and J.IsInLaningPhase() and fManaAfter > fManaThreshold1 then
		for _, creep in pairs(nEnemyCreeps) do
			if  J.IsValid(creep)
            and J.CanBeAttacked(creep)
            and J.CanCastOnTargetAdvanced(creep)
			and not J.IsOtherAllysTarget(creep)
			then
                local eta = (GetUnitToUnitDistance(bot, creep) / nSpeed) + nCastPoint
                if J.WillKillTarget(creep, nDamage ,DAMAGE_TYPE_MAGICAL, eta) then
                    local sCreepName = creep:GetUnitName()
                    if string.find(sCreepName, 'ranged') then
                        if J.IsUnitTargetedByTower(creep, false) or J.IsEnemyTargetUnit(creep, 1200) then
                            return BOT_ACTION_DESIRE_HIGH, creep
                        end
                    end
                end
			end
		end
	end

    if J.IsDoingRoshan(bot) then
        if  J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.CanCastOnTargetAdvanced(botTarget)
        and bAttacking
        and fManaAfter > fManaThreshold1
        and nStacks == nStackLimit
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

    if J.IsDoingTormentor(bot) then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and bAttacking
        and fManaAfter > fManaThreshold1
        and nStacks == nStackLimit
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderGravekeepersCloak()
    if not J.CanCastAbility(GravekeepersCloak) then
        return BOT_ACTION_DESIRE_NONE
    end

    if botHP < 0.5 and not bot:HasModifier('modifier_fountain_aura_buff') then
        return BOT_ACTION_DESIRE_HIGH
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderSilentAsTheGrave()
    if not J.CanCastAbility(SilentAsTheGrave)
    or J.IsRealInvisible(bot)
    then
        return BOT_ACTION_DESIRE_NONE
    end

    if J.IsGoingOnSomeone(bot) then
		if  J.IsValidHero(botTarget)
        and not J.IsInRange(bot, botTarget, bot:GetAttackRange() * 2)
        and not J.IsSuspiciousIllusion(botTarget)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not bAttacking
		then
            return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsRetreating(bot) then
        if J.IsValidHero(nEnemyHeroes[1]) and not J.IsSuspiciousIllusion(nEnemyHeroes[1]) then
            if (bot:WasRecentlyDamagedByAnyHero(2.0) and J.IsChasingTarget(nEnemyHeroes[1], bot))
            or (bot:WasRecentlyDamagedByAnyHero(5.0) and #nEnemyHeroes > #nAllyHeroes and #nEnemyHeroes >= 2)
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
	end

    if J.IsDoingRoshan(bot) then
        local vRoshanLocation = J.GetCurrentRoshanLocation()
        if GetUnitToLocationDistance(bot, vRoshanLocation) > 3200 and #nEnemyHeroes == 0 then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsDoingTormentor(bot) then
        local vTormentorLocation = J.GetTormentorLocation(GetTeam())
        if GetUnitToLocationDistance(bot, vTormentorLocation) > 3200 and #nEnemyHeroes == 0 then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderSummonFamiliars()
    if not J.CanCastAbility(SummonFamiliars) then
        return BOT_ACTION_DESIRE_NONE
    end

    local nFamiliarCount = SummonFamiliars:GetSpecialValueInt('familiar_count')
    local nCurrFamiliar = 0

	for _, unit in pairs(GetUnitList(UNIT_LIST_ALLIES)) do
        if J.IsValid(unit) then
            if string.find(unit:GetUnitName(), 'npc_dota_visage_familiar') then
                nCurrFamiliar = nCurrFamiliar + 1
            end
        end
	end

	if nFamiliarCount > nCurrFamiliar then
		return BOT_ACTION_DESIRE_HIGH
	end

    return BOT_ACTION_DESIRE_NONE
end

return X