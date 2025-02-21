local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_vengefulspirit'
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
                    ['t15'] = {0, 10},
                    ['t10'] = {10, 0},
                },
            },
            ['ability'] = {
                [1] = {1,2,1,2,1,6,1,2,2,3,6,3,3,3,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
                "item_magic_stick",
			
				"item_wraith_band",
				"item_magic_wand",
				"item_power_treads",
                "item_maelstrom",
                "item_dragon_lance",
				"item_black_king_bar",--
                "item_mjollnir",--
                "item_greater_crit",--
                "item_butterfly",--
                "item_hurricane_pike",--
                "item_moon_shard",
				"item_aghanims_shard",
				"item_travel_boots_2",--
				"item_ultimate_scepter_2",
            },
            ['sell_list'] = {
				"item_magic_wand", "item_greater_crit",
                "item_wraith_band", "item_butterfly",
            },
        },
    },
    ['pos_2'] = {
        [1] = {
            ['talent'] = {
                [1] = {
                    ['t25'] = {0, 10},
                    ['t20'] = {10, 0},
                    ['t15'] = {0, 10},
                    ['t10'] = {10, 0},
                },
            },
            ['ability'] = {
                [1] = {1,2,1,2,1,6,1,2,2,3,6,3,3,3,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
                "item_magic_stick",
			
                "item_bottle",
				"item_wraith_band",
				"item_magic_wand",
				"item_power_treads",
                "item_maelstrom",
                "item_dragon_lance",
				"item_black_king_bar",--
                "item_mjollnir",--
                "item_greater_crit",--
                "item_butterfly",--
                "item_hurricane_pike",--
                "item_moon_shard",
				"item_aghanims_shard",
				"item_travel_boots_2",--
				"item_ultimate_scepter_2",
            },
            ['sell_list'] = {
                "item_bottle", "item_greater_crit",
				"item_magic_wand", "item_butterfly",
                "item_wraith_band", "item_travel_boots_2",
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
                [1] = {
                    ['t25'] = {10, 0},
                    ['t20'] = {0, 10},
                    ['t15'] = {0, 10},
                    ['t10'] = {0, 10},
                }
            },
            ['ability'] = {
                [1] = {1,2,1,2,1,6,1,2,2,3,6,3,3,3,6},
            },
            ['buy_list'] = {
                "item_double_tango",
                "item_double_branches",
                "item_blood_grenade",
                "item_circlet",
            
                "item_boots",
                "item_magic_wand",
                "item_tranquil_boots",
                "item_ancient_janggo",
                "item_aghanims_shard",
                "item_solar_crest",--
                "item_boots_of_bearing",--
                "item_force_staff",
                "item_lotus_orb",--
                "item_aeon_disk",--
                "item_wind_waker",--
                "item_hurricane_pike",--
                "item_ultimate_scepter_2",
                "item_moon_shard",
            },
            ['sell_list'] = {
                "item_circlet", "item_boots_of_bearing",
                "item_magic_wand", "item_lotus_orb",
            },
        },
    },
    ['pos_5'] = {
        [1] = {
            ['talent'] = {
                [1] = {
                    ['t25'] = {10, 0},
                    ['t20'] = {0, 10},
                    ['t15'] = {0, 10},
                    ['t10'] = {0, 10},
                }
            },
            ['ability'] = {
                [1] = {1,2,1,2,1,6,1,2,2,3,6,3,3,3,6},
            },
            ['buy_list'] = {
                "item_double_tango",
                "item_double_branches",
                "item_blood_grenade",
                "item_circlet",
            
                "item_boots",
                "item_magic_wand",
                "item_arcane_boots",
                "item_mekansm",
                "item_aghanims_shard",
                "item_solar_crest",--
                "item_guardian_greaves",--
                "item_force_staff",
                "item_lotus_orb",--
                "item_aeon_disk",--
                "item_wind_waker",--
                "item_hurricane_pike",--
                "item_ultimate_scepter_2",
                "item_moon_shard",
            },
            ['sell_list'] = {
                "item_circlet", "item_boots_of_bearing",
                "item_magic_wand", "item_lotus_orb",
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

local MagicMissile  = bot:GetAbilityByName('vengefulspirit_magic_missile')
local WaveOfTerror  = bot:GetAbilityByName('vengefulspirit_wave_of_terror')
-- local VengeanceAura = bot:GetAbilityByName('vengefulspirit_command_aura')
local NetherSwap    = bot:GetAbilityByName('vengefulspirit_nether_swap')

local MagicMissileDesire, MagicMissileTarget
local WaveOfTerrorDesire, WaveOfTerrorLocation
local NetherSwapDesire, NetherSwapTarget

local botTarget

function X.SkillsComplement()
	if J.CanNotUseAbility(bot) then return end

    MagicMissile  = bot:GetAbilityByName('vengefulspirit_magic_missile')
    WaveOfTerror  = bot:GetAbilityByName('vengefulspirit_wave_of_terror')
    NetherSwap    = bot:GetAbilityByName('vengefulspirit_nether_swap')

    botTarget = J.GetProperTarget(bot)

    NetherSwapDesire, NetherSwapTarget = X.ConsiderNetherSwap()
    if NetherSwapDesire > 0
    then
        bot:Action_UseAbilityOnEntity(NetherSwap, NetherSwapTarget)
        return
    end

    MagicMissileDesire, MagicMissileTarget = X.ConsiderMagicMissile()
    if MagicMissileDesire > 0
    then
        bot:Action_UseAbilityOnEntity(MagicMissile, MagicMissileTarget)
        return
    end

    WaveOfTerrorDesire, WaveOfTerrorLocation = X.ConsiderWaveOfTerror()
    if WaveOfTerrorDesire > 0
    then
        bot:Action_UseAbilityOnLocation(WaveOfTerror, WaveOfTerrorLocation)
        return
    end
end

function X.ConsiderMagicMissile()
    if not J.CanCastAbility(MagicMissile)
    then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = J.GetProperCastRange(false, bot, MagicMissile:GetCastRange())
    local nDamage = MagicMissile:GetSpecialValueInt('magic_missile_damage')

    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
    for _, enemyHero in pairs(nEnemyHeroes)
    do
        if  J.IsValidHero(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanCastOnTargetAdvanced(enemyHero)
        then
            if enemyHero:IsChanneling()
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero
            end

            if  J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
            and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero
            end

            if J.IsInLaningPhase()
            then
                local nInRangeTower = enemyHero:GetNearbyTowers(700, true)

                if J.IsValidBuilding(nInRangeTower[1])
                and nInRangeTower[1]:GetAttackTarget() == enemyHero
                then
                    return BOT_ACTION_DESIRE_HIGH, enemyHero
                end
            end
        end
    end

    local nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    for _, allyHero in pairs(nAllyHeroes)
    do
        if  J.IsValidHero(allyHero)
        and J.IsRetreating(allyHero)
        and allyHero:WasRecentlyDamagedByAnyHero(3.0)
        and not allyHero:IsIllusion()
        then
            local nAllyInRangeEnemy = allyHero:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
            if J.IsValidHero(nAllyInRangeEnemy[1])
            and J.CanCastOnNonMagicImmune(nAllyInRangeEnemy[1])
            and J.CanCastOnTargetAdvanced(nAllyInRangeEnemy[1])
            and J.IsInRange(bot, nAllyInRangeEnemy[1], nCastRange)
            and J.IsChasingTarget(nAllyInRangeEnemy[1], allyHero)
            and not J.IsDisabled(nAllyInRangeEnemy[1])
            and not nAllyInRangeEnemy[1]:HasModifier('modifier_legion_commander_duel')
            and not nAllyInRangeEnemy[1]:HasModifier('modifier_enigma_black_hole_pull')
            and not nAllyInRangeEnemy[1]:HasModifier('modifier_faceless_void_chronosphere_freeze')
            and not nAllyInRangeEnemy[1]:HasModifier('modifier_necrolyte_reapers_scythe')
            then
                return BOT_ACTION_DESIRE_HIGH, nAllyInRangeEnemy[1]
            end
        end
    end

	if J.IsGoingOnSomeone(bot)
	then
        if  J.IsValidHero(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.CanCastOnTargetAdvanced(botTarget)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot)
	then
        for _, enemyHero in pairs(nEnemyHeroes)
        do
            if  J.IsValidHero(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and J.IsChasingTarget(enemyHero, bot)
            and not J.IsDisabled(enemyHero)
            then
                if #nEnemyHeroes > #nAllyHeroes or (J.GetHP(bot) < 0.55 and bot:WasRecentlyDamagedByAnyHero(3.0)) then
                    return BOT_ACTION_DESIRE_HIGH
                end
            end
        end
	end

    if J.IsLaning(bot) and J.GetMP(bot) > 0.3 and (J.IsCore(bot) or not J.IsCore(bot) and not J.IsThereCoreNearby(1200))
	then
		local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(nCastRange, true)

		for _, creep in pairs(nEnemyLaneCreeps)
		do
			if  J.IsValid(creep)
            and J.CanBeAttacked(creep)
			and J.IsKeyWordUnit('ranged', creep)
			and J.CanKillTarget(creep, nDamage, DAMAGE_TYPE_MAGICAL)
			then
				if  J.IsValid(nEnemyHeroes[1])
                and GetUnitToUnitDistance(nEnemyHeroes[1], creep) < 500
                and not J.IsThereCoreNearby(1200)
				then
					return BOT_ACTION_DESIRE_HIGH, creep
				end
			end
		end
	end

    if J.IsDoingRoshan(bot)
    then
        if  J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, 500)
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

    if J.IsDoingTormentor(bot)
    then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, 500)
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderWaveOfTerror()
    if not J.CanCastAbility(WaveOfTerror)
    then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nCastRange = J.GetProperCastRange(false, bot, WaveOfTerror:GetCastRange())
	local nRadius = WaveOfTerror:GetSpecialValueInt('wave_width')
    local nDamage = WaveOfTerror:GetAbilityDamage()
    local nManaAfter = J.GetManaAfter(WaveOfTerror:GetManaCost())

    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
    for _, enemyHero in pairs(nEnemyHeroes)
    do
        if  J.IsValidHero(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
        then
            local nLocationAoE = bot:FindAoELocation(true, true, enemyHero:GetLocation(), 0, nRadius, 0, 0)
            if nLocationAoE.count >= 2 then
                return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
            else
                return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
            end
        end
    end

    if J.IsGoingOnSomeone(bot)
	then
        if  J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and not J.IsChasingTarget(botTarget)
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        then
            local nLocationAoE = bot:FindAoELocation(true, true, botTarget:GetLocation(), 0, nRadius, 0, 0)
            if nLocationAoE.count >= 2 then
                return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
            else
                return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
            end
        end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot)
	then
        local nAllyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
        for _, enemyHero in pairs(nEnemyHeroes)
        do
            if  J.IsValidHero(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.IsChasingTarget(enemyHero, bot)
            then
                if #nEnemyHeroes > #nAllyHeroes or (J.GetHP(bot) < 0.55 and bot:WasRecentlyDamagedByAnyHero(3.0)) then
                    return BOT_ACTION_DESIRE_HIGH
                end
            end
        end
	end

	if (J.IsPushing(bot) or J.IsDefending(bot)) then
        local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(nCastRange, true)

        if #nEnemyLaneCreeps >= 4
        and J.IsValid(nEnemyLaneCreeps[1])
        and J.CanBeAttacked(nEnemyLaneCreeps[1])
        and not J.IsRunning(nEnemyLaneCreeps[1])
        and nManaAfter > 0.3
        then
            local nLocationAoE = bot:FindAoELocation(true, false, nEnemyLaneCreeps[1]:GetLocation(), 0, nRadius, 0, 0)
            if nLocationAoE.count >= 4 then
                return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
            end
        end

        local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
        if nLocationAoE.count >= 2 then
            return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
        end
	end

    local nEnemyLaneCreeps = bot:GetNearbyCreeps(nCastRange, true)
    if J.IsFarming(bot) and nManaAfter > 0.25 then
        if J.IsValid(nEnemyLaneCreeps[1])
        and J.CanBeAttacked(nEnemyLaneCreeps[1])
        and not J.IsRunning(nEnemyLaneCreeps[1])
        then
            local nLocationAoE = bot:FindAoELocation(true, false, nEnemyLaneCreeps[1]:GetLocation(), 0, nRadius, 0, 0)
            if nLocationAoE.count >= 3 or (nLocationAoE.count >= 2 and nEnemyLaneCreeps[1]:IsAncientCreep()) then
                return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
            end
        end
    end

    if J.IsLaning(bot) and nManaAfter > 0.2 then
        local hCreepList = {}
		for _, creep in pairs(nEnemyLaneCreeps) do
            if  J.IsValid(creep)
            and J.CanBeAttacked(creep)
            and not J.IsRunning(creep)
            and J.CanKillTarget(creep, nDamage, DAMAGE_TYPE_MAGICAL)
            then
                table.insert(hCreepList, creep)
            end
		end

        if #hCreepList >= 2
        and J.GetMP(bot) > 0.3
        then
            return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(hCreepList)
        end
	end

    if J.IsDoingRoshan(bot)
    then
        if  J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, 500)
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
    end

    if J.IsDoingTormentor(bot)
    then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, 500)
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderNetherSwap()
    if not J.CanCastAbility(NetherSwap)
    then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = J.GetProperCastRange(false, bot, NetherSwap:GetCastRange())

    local nAllyHeroes = J.GetAlliesNearLoc(bot:GetLocation(), 1600)
    if not J.IsCore(bot) then
        for _, allyHero in pairs(nAllyHeroes)
        do
            if  J.IsValidHero(allyHero)
            and J.IsInRange(bot, allyHero, nCastRange)
            and J.IsCore(allyHero)
            and not J.IsSuspiciousIllusion(allyHero)
            then
                if allyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
                or allyHero:HasModifier('modifier_enigma_black_hole_pull')
                or allyHero:HasModifier('modifier_legion_commander_duel')
                or (allyHero:HasModifier('modifier_mars_arena_of_blood_leash')
                    and not bot:HasModifier('modifier_mars_arena_of_blood_leash'))
                then
                    return BOT_ACTION_DESIRE_HIGH, allyHero
                end
            end
        end
    end

    local nEnemyHeroes = J.GetEnemiesNearLoc(bot:GetLocation(), 1600)

    if not J.IsCore(bot) or (J.IsCore(bot) and #nAllyHeroes > #nEnemyHeroes) then
        if J.IsGoingOnSomeone(bot)
        then
            local target = nil
            local dmg = 0
            for _, enemyHero in pairs(nEnemyHeroes)
            do
                if  J.IsValidHero(enemyHero)
                and J.IsInRange(bot, enemyHero, nCastRange)
                and J.CanCastOnNonMagicImmune(enemyHero)
                and J.CanCastOnTargetAdvanced(enemyHero)
                and not J.IsInRange(bot, enemyHero, nCastRange / 2)
                and not J.IsDisabled(enemyHero)
                and not enemyHero:HasModifier('modifier_legion_commander_duel')
                and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
                and not enemyHero:WasRecentlyDamagedByAnyHero(2)
                then
                    local nInRangeAlly = enemyHero:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
                    local nTargetInRangeAlly = enemyHero:GetNearbyHeroes(1200, false, BOT_MODE_NONE)
                    local currDmg = enemyHero:GetEstimatedDamageToTarget(true, bot, 5, DAMAGE_TYPE_ALL)

                    if  nInRangeAlly ~= nil and nTargetInRangeAlly ~= nil
                    and #nInRangeAlly >= #nTargetInRangeAlly
                    and #nInRangeAlly >= 1
                    and not (#nInRangeAlly > #nTargetInRangeAlly + 2)
                    and dmg < currDmg
                    then
                        dmg = currDmg
                        target = enemyHero
                    end
                end
            end

            if target ~= nil
            then
                return BOT_ACTION_DESIRE_HIGH, target
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

return X