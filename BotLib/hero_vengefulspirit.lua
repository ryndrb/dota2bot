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
                "item_quelling_blade",
                "item_circlet",
                "item_slippers",
			
				"item_magic_wand",
				"item_power_treads",
				"item_wraith_band",
                "item_maelstrom",
                "item_dragon_lance",
				"item_black_king_bar",--
                "item_mjollnir",--
				"item_aghanims_shard",
                "item_hurricane_pike",--
                "item_butterfly",--
                "item_greater_crit",--
				"item_ultimate_scepter_2",
                "item_moon_shard",
				"item_travel_boots_2",--
            },
            ['sell_list'] = {
                "item_quelling_blade", "item_black_king_bar",
				"item_magic_wand", "item_butterfly",
                "item_wraith_band", "item_greater_crit",
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
                "item_quelling_blade",
                "item_circlet",
                "item_slippers",
			
                "item_bottle",
				"item_magic_wand",
				"item_power_treads",
				"item_wraith_band",
                "item_maelstrom",
                "item_dragon_lance",
				"item_black_king_bar",--
                "item_mjollnir",--
				"item_aghanims_shard",
                "item_hurricane_pike",--
                "item_butterfly",--
                "item_greater_crit",--
				"item_ultimate_scepter_2",
                "item_moon_shard",
				"item_travel_boots_2",--
            },
            ['sell_list'] = {
                "item_quelling_blade", "item_dragon_lance",
				"item_magic_wand", "item_black_king_bar",
                "item_wraith_band", "item_butterfly",
                "item_bottle", "item_greater_crit",
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
                "item_tango",
                "item_double_branches",
                "item_magic_stick",
                "item_blood_grenade",
                "item_faerie_fire",
            
                "item_tranquil_boots",
                "item_magic_wand",
                "item_solar_crest",--
                "item_ancient_janggo",
                "item_aghanims_shard",
                "item_force_staff",
                "item_ultimate_scepter",
                "item_boots_of_bearing",--
                "item_lotus_orb",--
                "item_nullifier",--
                "item_sheepstick",--
                "item_ultimate_scepter_2",
                "item_hurricane_pike",--
                "item_moon_shard",
            },
            ['sell_list'] = {
                "item_magic_wand", "item_nullifier",
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
                "item_tango",
                "item_double_branches",
                "item_magic_stick",
                "item_blood_grenade",
                "item_faerie_fire",
            
                "item_arcane_boots",
                "item_magic_wand",
                "item_solar_crest",--
                "item_mekansm",
                "item_aghanims_shard",
                "item_force_staff",
                "item_ultimate_scepter",
                "item_guardian_greaves",--
                "item_lotus_orb",--
                "item_nullifier",--
                "item_sheepstick",--
                "item_ultimate_scepter_2",
                "item_hurricane_pike",--
                "item_moon_shard",
            },
            ['sell_list'] = {
                "item_magic_wand", "item_nullifier",
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

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
    bot = GetBot()

	if J.CanNotUseAbility(bot) then return end

    MagicMissile  = bot:GetAbilityByName('vengefulspirit_magic_missile')
    WaveOfTerror  = bot:GetAbilityByName('vengefulspirit_wave_of_terror')
    NetherSwap    = bot:GetAbilityByName('vengefulspirit_nether_swap')

	bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    NetherSwapDesire, NetherSwapTarget = X.ConsiderNetherSwap()
    if NetherSwapDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(NetherSwap, NetherSwapTarget)
        return
    end

    MagicMissileDesire, MagicMissileTarget = X.ConsiderMagicMissile()
    if MagicMissileDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(MagicMissile, MagicMissileTarget)
        return
    end

    WaveOfTerrorDesire, WaveOfTerrorLocation = X.ConsiderWaveOfTerror()
    if WaveOfTerrorDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(WaveOfTerror, WaveOfTerrorLocation)
        return
    end
end

function X.ConsiderMagicMissile()
    if not J.CanCastAbility(MagicMissile) then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = J.GetProperCastRange(false, bot, MagicMissile:GetCastRange())
    local nCastPoint = MagicMissile:GetCastPoint()
    local nDamage = MagicMissile:GetSpecialValueInt('magic_missile_damage')
    local nSpeed = MagicMissile:GetSpecialValueInt('magic_missile_speed')
	local nManaCost = MagicMissile:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {WaveOfTerror, NetherSwap})
	local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {MagicMissile, WaveOfTerror, NetherSwap})

    for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanCastOnTargetAdvanced(enemyHero)
        then
            local eta = (GetUnitToUnitDistance(bot, enemyHero) / nSpeed) + nCastPoint
            if enemyHero:HasModifier('modifier_teleporting') then
                if J.GetModifierTime(enemyHero, 'modifier_teleporting') > eta then
                    return BOT_ACTION_DESIRE_HIGH, enemyHero
                end
            elseif enemyHero:IsChanneling() and fManaAfter > fManaThreshold2 then
                return BOT_ACTION_DESIRE_HIGH, enemyHero
            end

            if  J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL, eta)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
            and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero
            end

            if J.IsInLaningPhase() then
                local nInRangeTower = enemyHero:GetNearbyTowers(500, true)

                if J.IsValidBuilding(nInRangeTower[1])
                and nInRangeTower[1]:GetAttackTarget() == enemyHero
                then
                    return BOT_ACTION_DESIRE_HIGH, enemyHero
                end
            end
        end
    end

	if J.IsGoingOnSomeone(bot) then
        if  J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.CanCastOnTargetAdvanced(botTarget)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
        and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(5.0) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and not J.IsDisabled(enemyHero)
            then
                if J.IsChasingTarget(enemyHero, bot)
                or (#nEnemyHeroes > #nAllyHeroes and enemyHero:GetAttackTarget() == bot)
                or (botHP < 0.5 and enemyHero:GetAttackTarget() == bot)
                then
                    return BOT_ACTION_DESIRE_HIGH, enemyHero
                end
            end
        end
	end

    if J.IsLaning(bot) and J.IsInLaningPhase() and fManaAfter > fManaThreshold1 then
		local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(nCastRange, true)
		for _, creep in pairs(nEnemyLaneCreeps) do
			if  J.IsValid(creep)
            and J.CanBeAttacked(creep)
			and J.IsKeyWordUnit('ranged', creep)
            and J.CanCastOnTargetAdvanced(creep)
            and (J.IsCore(bot) or not J.IsOtherAllysTarget(creep))
			then
                local eta = (GetUnitToUnitDistance(bot, creep) / nSpeed) + nCastPoint
                if J.WillKillTarget(creep, nDamage, DAMAGE_TYPE_MAGICAL, eta) then
                    local nLocationAoE = bot:FindAoELocation(true, true, creep:GetLocation(), 0, 600, 0, 0)
                    if nLocationAoE.count > 0 or J.IsUnitTargetedByTower(creep, false) then
                        return BOT_ACTION_DESIRE_HIGH, creep
                    end
                end
			end
		end
	end

    if J.IsDoingRoshan(bot) then
        if  J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and bAttacking
        and fManaAfter > fManaThreshold2
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

    if J.IsDoingTormentor(bot) then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and bAttacking
        and fManaAfter > fManaThreshold2
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

    if  not J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
    and not J.IsInTeamFight(bot, 1200)
    and fManaAfter > fManaThreshold1
    then
        for _, allyHero in pairs(nAllyHeroes) do
            if  J.IsValidHero(allyHero)
            and bot ~= allyHero
            and J.IsRetreating(allyHero)
            and allyHero:WasRecentlyDamagedByAnyHero(3.0)
            and not J.IsSuspiciousIllusion(allyHero)
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

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderWaveOfTerror()
    if not J.CanCastAbility(WaveOfTerror) then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nCastRange = J.GetProperCastRange(false, bot, WaveOfTerror:GetCastRange())
	local nRadius = WaveOfTerror:GetSpecialValueInt('wave_width')
    local nDamage = WaveOfTerror:GetAbilityDamage()
    local nManaCost = WaveOfTerror:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {MagicMissile, NetherSwap})
    local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {MagicMissile, NetherSwap})

    if not J.CanCastAbility(MagicMissile) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
            end
        end
    end

    if J.IsGoingOnSomeone(bot) then
        if  J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and not J.IsChasingTarget(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and not J.IsDisabled(enemyHero)
            and not enemyHero:IsDisarmed()
            then
                if J.IsChasingTarget(enemyHero, bot)
                or (#nEnemyHeroes > #nAllyHeroes and enemyHero:GetAttackTarget() == bot)
                then
                    return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
                end
            end
        end
	end

    local nEnemyCreeps = bot:GetNearbyCreeps(nCastRange, true)

    if J.IsPushing(bot) and fManaAfter > fManaThreshold1 and #nAllyHeroes <= 2 and #nEnemyHeroes == 0 and bAttacking then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) and not creep:HasModifier('modifier_vengefulspirit_wave_of_terror') then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 4) then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

    if J.IsDefending(bot) and fManaAfter > fManaThreshold1 and #nEnemyHeroes == 0 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) and not creep:HasModifier('modifier_vengefulspirit_wave_of_terror') then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 4) then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end

        local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
        if nLocationAoE.count >= 2 then
            return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
        end
    end

    if J.IsFarming(bot) and fManaAfter > fManaThreshold1 and bAttacking then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) and not creep:HasModifier('modifier_vengefulspirit_wave_of_terror') then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 3)
                or (nLocationAoE.count >= 2 and creep:IsAncientCreep())
                then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

    if J.IsLaning(bot) and J.IsInLaningPhase() and fManaAfter > fManaThreshold1 then
        local nLocationAoE = bot:FindAoELocation(true, false, bot:GetLocation(), nCastRange, nRadius, 0, nDamage)
        if (nLocationAoE.count >= 2) then
            return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
        end

        if not J.CanCastAbility(MagicMissile) then
            for _, creep in pairs(nEnemyCreeps) do
                if J.IsValid(creep)
                and J.CanBeAttacked(creep)
                and not J.IsRunning(creep)
                and J.IsKeyWordUnit('ranged', creep)
                and J.CanKillTarget(creep, nDamage, DAMAGE_TYPE_MAGICAL)
                then
                    nLocationAoE = bot:FindAoELocation(true, true, creep:GetLocation(), 0, 650, 0, 0)
                    if (nLocationAoE.count > 0) or J.IsUnitTargetedByTower(creep, false) then
                        return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                    end
                end
            end
        end
	end

    if J.IsDoingRoshan(bot) then
        if  J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
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

function X.ConsiderNetherSwap()
    if not J.CanCastAbility(NetherSwap) then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = J.GetProperCastRange(false, bot, NetherSwap:GetCastRange())
    local bWeAreStronger = J.WeAreStronger(bot, 2200)

    if not J.IsCore(bot) then
        for _, allyHero in pairs(nAllyHeroes) do
            if  J.IsValidHero(allyHero)
            and bot ~= allyHero
            and J.IsInRange(bot, allyHero, nCastRange + 500)
            and not J.IsInRange(bot, allyHero, nCastRange / 2)
            and J.IsCore(allyHero)
            and not J.IsSuspiciousIllusion(allyHero)
            and allyHero:WasRecentlyDamagedByAnyHero(1.0)
            then
                local nEnemyHeroesTargetingAlly = J.GetHeroesTargetingUnit(nEnemyHeroes, allyHero)
                if #nEnemyHeroesTargetingAlly > 0 then
                    if allyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
                    or allyHero:HasModifier('modifier_enigma_black_hole_pull')
                    or allyHero:HasModifier('modifier_legion_commander_duel')
                    then
                        return BOT_ACTION_DESIRE_HIGH, allyHero
                    end
                end
            end
        end
    end

    if not J.IsCore(bot) or (J.IsCore(bot) and (#nAllyHeroes > #nEnemyHeroes or bWeAreStronger and botHP > 0.7)) then
        if J.IsGoingOnSomeone(bot) then
            local target = nil
            local targetScore = 0
            for _, enemyHero in pairs(nEnemyHeroes) do
                if  J.IsValidHero(enemyHero)
                and J.CanBeAttacked(enemyHero)
                and J.IsInRange(bot, enemyHero, nCastRange)
                and J.CanCastOnNonMagicImmune(enemyHero)
                and J.CanCastOnTargetAdvanced(enemyHero)
                and not J.IsInRange(bot, enemyHero, nCastRange / 2)
                and not J.IsDisabled(enemyHero)
                and not enemyHero:HasModifier('modifier_legion_commander_duel')
                and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
                then
                    local nInRangeAlly = enemyHero:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
                    local nInRangeEnemy = enemyHero:GetNearbyHeroes(1200, false, BOT_MODE_NONE)
                    local enemyHeroScore = 0
                    for _, allyHero in pairs(nInRangeAlly) do
                        if J.IsValidHero(allyHero) and not J.IsSuspiciousIllusion(allyHero) then
                            enemyHeroScore = enemyHeroScore + enemyHero:GetEstimatedDamageToTarget(true, allyHero, 5.0, DAMAGE_TYPE_ALL)
                        end
                    end

                    if  #nInRangeAlly >= #nInRangeEnemy
                    and not (#nInRangeAlly > #nInRangeEnemy + 2)
                    and targetScore < enemyHeroScore
                    then
                        target = enemyHero
                        targetScore = enemyHeroScore
                    end
                end
            end

            if target ~= nil then
                return BOT_ACTION_DESIRE_HIGH, target
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

return X