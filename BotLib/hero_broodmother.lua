local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_broodmother'
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
					['t20'] = {0, 10},
					['t15'] = {10, 0},
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
                [1] = {2,3,1,2,2,6,2,3,3,3,6,1,1,1,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
                "item_quelling_blade",
                "item_double_circlet",
			
				"item_magic_wand",
                "item_double_wraith_band",
                "item_soul_ring",
				"item_power_treads",
                "item_orchid",
				"item_black_king_bar",--
				"item_aghanims_shard",
				"item_butterfly",--
				"item_bloodthorn",--
                "item_abyssal_blade",--
                "item_greater_crit",--
				"item_moon_shard",
				"item_travel_boots_2",--
				"item_ultimate_scepter_2",
			},
            ['sell_list'] = {
                "item_quelling_blade", "item_orchid",
				"item_magic_wand", "item_black_king_bar",
                "item_wraith_band", "item_butterfly",
                "item_wraith_band", "item_abyssal_blade",
				"item_soul_ring", "item_greater_crit",
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
                [1] = {2,3,1,2,2,6,2,3,3,3,6,1,1,1,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
                "item_quelling_blade",
                "item_double_circlet",
			
				"item_magic_wand",
                "item_double_wraith_band",
                "item_soul_ring",
				"item_power_treads",
                "item_orchid",
				"item_black_king_bar",--
				"item_aghanims_shard",
				"item_butterfly",--
				"item_bloodthorn",--
                "item_abyssal_blade",--
                "item_greater_crit",--
				"item_moon_shard",
				"item_travel_boots_2",--
				"item_ultimate_scepter_2",
			},
            ['sell_list'] = {
                "item_quelling_blade", "item_orchid",
				"item_magic_wand", "item_black_king_bar",
                "item_wraith_band", "item_butterfly",
                "item_wraith_band", "item_abyssal_blade",
				"item_soul_ring", "item_greater_crit",
			},
        },
    },
    ['pos_3'] = {
        [1] = {
            ['talent'] = {
				[1] = {
					['t25'] = {0, 10},
					['t20'] = {10, 0},
					['t15'] = {0, 10},
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
                [1] = {2,3,1,2,2,6,2,3,3,3,6,1,1,1,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
                "item_quelling_blade",
                "item_double_circlet",
			
				"item_magic_wand",
                "item_double_wraith_band",
				"item_soul_ring",
				"item_power_treads",
                "item_orchid",
                "item_assault",--
				"item_black_king_bar",--
				"item_aghanims_shard",
				"item_sheepstick",--
				"item_bloodthorn",--
                "item_abyssal_blade",--
				"item_moon_shard",
				"item_travel_boots_2",--
				"item_ultimate_scepter_2",
			},
            ['sell_list'] = {
                "item_quelling_blade", "item_orchid",
				"item_magic_wand", "item_assault",
                "item_wraith_band", "item_black_king_bar",
                "item_wraith_band", "item_sheepstick",
				"item_soul_ring", "item_abyssal_blade",
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

if J.Role.IsPvNMode() or J.Role.IsAllShadow() then X['sBuyList'], X['sSellList'] = { 'PvN_antimage' }, {} end

nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] = J.SetUserHeroInit( nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] )

X['sSkillList'] = J.Skill.GetSkillList( sAbilityList, nAbilityBuildList, sTalentList, nTalentBuildList )

X['bDeafaultAbility'] = false
X['bDeafaultItem'] = false

function X.MinionThink( hMinionUnit )
	Minion.MinionThink(hMinionUnit)
end

end

local InsatiableHunger  = bot:GetAbilityByName('broodmother_insatiable_hunger')
local SpinWeb           = bot:GetAbilityByName('broodmother_spin_web')
-- local SilkenBola        = bot:GetAbilityByName('broodmother_silken_bola')
local SpinnersSnare     = bot:GetAbilityByName('broodmother_sticky_snare')
local SpawnSpiderlings  = bot:GetAbilityByName('broodmother_spawn_spiderlings')

local InsatiableHungerDesire
local SpinWebDesire, SpinWebLocation
-- local SilkenBolaDesire, SilkenBolaTarget
local SpinnersSnareDesire, SpinnersSnareLocation
local SpawnSpiderlingsDesire, SpirderlingsTarget

local fLastSpinWebTime = 0

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
    bot = GetBot()

	if J.CanNotUseAbility(bot) then return end

    InsatiableHunger  = bot:GetAbilityByName('broodmother_insatiable_hunger')
	SpinWeb           = bot:GetAbilityByName('broodmother_spin_web')
    SpinnersSnare     = bot:GetAbilityByName('broodmother_sticky_snare')
	SpawnSpiderlings  = bot:GetAbilityByName('broodmother_spawn_spiderlings')

    bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    SpawnSpiderlingsDesire, SpirderlingsTarget = X.ConsiderSpawnSpiderlings()
    if SpawnSpiderlingsDesire > 0 then
		J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(SpawnSpiderlings, SpirderlingsTarget)
        return
    end

    SpinWebDesire, SpinWebLocation = X.ConsiderSpinWeb()
    if SpinWebDesire > 0 then
        fLastSpinWebTime = DotaTime()
        bot:Action_UseAbilityOnLocation(SpinWeb, SpinWebLocation)
        return
    end

    -- SilkenBolaDesire, SilkenBolaTarget = X.ConsiderSilkenBola()
    -- if SilkenBolaDesire > 0
    -- then
    --     bot:Action_UseAbilityOnEntity(SilkenBola, SilkenBolaTarget)
    --     return
    -- end

    InsatiableHungerDesire = X.ConsiderInsatiableHunger()
    if InsatiableHungerDesire > 0 then
		J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(InsatiableHunger)
        return
    end

    SpinnersSnareDesire, SpinnersSnareLocation = X.ConsiderSpinnerSnare()
    if SpinnersSnareDesire > 0 then
		J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(SpinnersSnare, SpinnersSnareLocation)
        return
    end
end

function X.ConsiderInsatiableHunger()
	if not J.CanCastAbility(InsatiableHunger)
    or bot:IsDisarmed()
    then
        return BOT_ACTION_DESIRE_NONE
    end

    local botAttackRange = bot:GetAttackRange()
    local nManaCost = InsatiableHunger:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost , {InsatiableHunger, SpawnSpiderlings})
    local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost , {SpawnSpiderlings})

    if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
        and J.IsInRange(bot, botTarget, botAttackRange + 150)
        and J.CanBeAttacked(botTarget)
        and J.IsAttacking(bot)
        and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
        and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
		then
            return BOT_ACTION_DESIRE_HIGH
		end
	end

    if  J.IsValid(botTarget)
    and J.CanBeAttacked(botTarget)
    and botTarget:IsCreep()
    and bAttacking
    and botHP < 0.25
    and fManaAfter > fManaThreshold2
    and not J.CanKillTarget(botTarget, bot:GetAttackDamage() * 3, DAMAGE_TYPE_PHYSICAL)
    and #nEnemyHeroes <= 1
    then
        return BOT_ACTION_DESIRE_HIGH
    end

    if J.IsDoingRoshan(bot) then
		if  J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, 800)
        and bAttacking
        and fManaAfter > fManaThreshold1
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

    if J.IsDoingTormentor(bot) then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, 800)
        and bAttacking
        and fManaAfter > fManaThreshold1
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderSpinWeb()
	if not J.CanCastAbility(SpinWeb) then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local botLocation = bot:GetLocation()

	local nCastRange = J.GetProperCastRange(false, bot, SpinWeb:GetCastRange())
    local nRadius = SpinWeb:GetSpecialValueInt('radius')
    local nCharges = SpinWeb:GetSpecialValueInt('AbilityCharges')
    local nChargeRestoreTime = SpinWeb:GetSpecialValueInt('AbilityChargeRestoreTime')
    local nAbilityLevel = SpinWeb:GetLevel()
    local nManaCost = SpinWeb:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost , {InsatiableHunger, SpawnSpiderlings})

    if J.IsStuck(bot) and not X.DoesLocationHaveWeb(botLocation, nRadius) then
		return BOT_ACTION_DESIRE_HIGH, botLocation
	end

    if J.IsInTeamFight(bot, 1200) then
        local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
        local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)

        if  #nInRangeEnemy >= 2
        and not X.DoesLocationHaveWeb(nLocationAoE.targetloc, nRadius * 2)
        and not J.IsLocationInChrono(nLocationAoE.targetloc)
        then
			return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
        end
	end

    if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not J.IsSuspiciousIllusion(botTarget)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not X.DoesLocationHaveWeb(botTarget:GetLocation(), nRadius * 2)
        and not J.IsLocationInChrono(botTarget:GetLocation())
        and fManaAfter > fManaThreshold1
		then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and not X.DoesLocationHaveWeb(botLocation, nRadius * 2) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if J.IsValidHero(enemyHero)
            and J.IsInRange(bot, enemyHero, 800)
            and not J.IsSuspiciousIllusion(enemyHero)
            and not enemyHero:IsDisarmed()
            then
                if (J.IsChasingTarget(enemyHero, bot))
                or (#nEnemyHeroes > #nAllyHeroes and enemyHero:GetAttackTarget() == bot)
                then
                    return BOT_ACTION_DESIRE_HIGH, botLocation
                end
            end
        end
    end

    local nEnemyCreeps = bot:GetNearbyCreeps(800, true)
    local nEnemyTowers = bot:GetNearbyTowers(1600, true)

    if J.IsPushing(bot) and fManaAfter > fManaThreshold1 and bAttacking then
        if J.IsValidBuilding(botTarget)
        and J.CanBeAttacked(botTarget)
        and not X.DoesLocationHaveWeb(botTarget:GetLocation(), nRadius * 2)
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end

        if #nEnemyTowers == 0 and #nAllyHeroes <= 2 then
            if  J.IsValid(nEnemyCreeps[1])
            and J.CanBeAttacked(nEnemyCreeps[1])
            and #nEnemyCreeps >= 4
            and not J.IsRunning(nEnemyCreeps[1])
            and not X.DoesLocationHaveWeb(botLocation, nRadius * 2 + nRadius * 0.5)
            then
                return BOT_MODE_DESIRE_HIGH, botLocation
            end
        end
	end

    if J.IsFarming(bot) and fManaAfter > fManaThreshold1 + 0.15 and bAttacking then
		if  J.IsValid(nEnemyCreeps[1])
        and J.CanBeAttacked(nEnemyCreeps[1])
        and #nEnemyCreeps >= 3
        and not J.IsRunning(nEnemyCreeps[1])
        and not X.DoesLocationHaveWeb(botLocation, nRadius * 2)
        then
			return BOT_MODE_DESIRE_HIGH, botLocation
		end
	end

    if J.IsLaning(bot) and J.IsInLaningPhase() and fManaAfter > fManaThreshold1 and bAttacking then
		if  J.IsValid(nEnemyCreeps[1])
        and J.CanBeAttacked(nEnemyCreeps[1])
        and #nEnemyCreeps >= 4
        and not J.IsRunning(nEnemyCreeps[1])
        and not X.DoesLocationHaveWeb(botLocation, nRadius * 2)
        then
			return BOT_MODE_DESIRE_HIGH, botLocation
		end
	end

    if  fManaAfter > fManaThreshold1 + 0.2
    and DotaTime() > 0
    and #nEnemyHeroes <= 1
    and bot:DistanceFromFountain() > 1600
    and not X.DoesLocationHaveWeb(botLocation, nRadius + nRadius * 0.5)
    and not bot:HasModifier('modifier_broodmother_spin_web')
    and DotaTime() > fLastSpinWebTime + nChargeRestoreTime
    then
        return BOT_ACTION_DESIRE_HIGH, botLocation
    end

    if J.IsDoingRoshan(bot) then
		if  J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, 800)
        and bAttacking
        and fManaAfter > fManaThreshold1
        and not X.DoesLocationHaveWeb(botTarget:GetLocation(), nRadius * 2)
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

    if J.IsDoingTormentor(bot) then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, 500)
        and bAttacking
        and fManaAfter > fManaThreshold1
        and not X.DoesLocationHaveWeb(botTarget:GetLocation(), nRadius * 2)
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderSpinnerSnare()
    if not J.CanCastAbility(SpinnersSnare) then
        return BOT_ACTION_DESIRE_NONE, 0
    end

	local nCastRange = J.GetProperCastRange(false, bot, SpinnersSnare:GetCastRange())
    local nWidth = SpinnersSnare:GetSpecialValueInt('width')
    local nManaCost = SpinnersSnare:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost , {InsatiableHunger, SpawnSpiderlings})

    if J.IsInTeamFight(bot, 1200) then
        local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nWidth, 0, 0)
        local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nWidth)

        if SpinnersSnareLocation == nil or J.GetDistance(nLocationAoE.targetloc, SpinnersSnareLocation) > nWidth then
            if  #nInRangeEnemy >= 2
            and not J.IsLocationInChrono(nLocationAoE.targetloc)
            then
                return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
            end
        end
	end

    if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.CanCastOnNonMagicImmune(botTarget)
        and not J.IsDisabled(botTarget)
        and not J.IsLocationInChrono(botTarget:GetLocation())
        and fManaAfter > fManaThreshold1
		then
            if SpinnersSnareLocation == nil or GetUnitToLocationDistance(botTarget, SpinnersSnareLocation) > nWidth then
                return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
            end
		end
	end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if J.IsValidHero(enemyHero)
            and J.IsInRange(bot, enemyHero, nWidth)
            and not enemyHero:IsMagicImmune()
            and not J.IsSuspiciousIllusion(enemyHero)
            and not enemyHero:IsDisarmed()
            then
                if (J.IsChasingTarget(enemyHero, bot))
                or (#nEnemyHeroes > #nAllyHeroes and enemyHero:GetAttackTarget() == bot)
                then
                    if SpinnersSnareLocation == nil or GetUnitToLocationDistance(bot, SpinnersSnareLocation) > nWidth then
                        return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
                    end
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderSpawnSpiderlings()
	if not J.CanCastAbility(SpawnSpiderlings) then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastRange = J.GetProperCastRange(false, bot, SpawnSpiderlings:GetCastRange())
    local nCastPoint = SpawnSpiderlings:GetCastPoint()
	local nDamage = SpawnSpiderlings:GetSpecialValueInt('damage')
    local nSpeed = SpawnSpiderlings:GetSpecialValueInt('projectile_speed')
    local nManaCost = SpawnSpiderlings:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost , {InsatiableHunger, SpawnSpiderlings})
    local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost , {InsatiableHunger})

    for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange + 300)
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
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange + 300)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.CanCastOnTargetAdvanced(botTarget)
		and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
		and not botTarget:HasModifier('modifier_enigma_black_hole_pull')
		and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
        and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
        and fManaAfter > fManaThreshold1 + 0.15
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

    if not J.IsRetreating(bot) and not J.IsRealInvisible(bot) and fManaAfter > fManaThreshold2 and bAttacking then
        local nEnemyCreeps = bot:GetNearbyCreeps(nCastRange, true)
        for _, creep in pairs(nEnemyCreeps) do
            if  J.IsValid(creep)
            and J.CanBeAttacked(creep)
            and J.CanCastOnNonMagicImmune(creep)
            and J.CanCastOnTargetAdvanced(creep)
            then
                local eta = (GetUnitToUnitDistance(bot, creep) / nSpeed) + nCastPoint
                if J.WillKillTarget(creep, nDamage, DAMAGE_TYPE_MAGICAL, eta) then
                    return BOT_ACTION_DESIRE_HIGH, creep
                end
            end
        end
    end

	return BOT_ACTION_DESIRE_NONE, 0
end

function X.DoesLocationHaveWeb(vLocation, nRadius)
	for _, unit in pairs (GetUnitList(UNIT_LIST_ALL)) do
		if  J.IsValid(unit)
        and unit:GetUnitName() == 'npc_dota_broodmother_web'
        and GetUnitToLocationDistance(unit, vLocation) <= nRadius
		then
			return true
		end
	end

	return false
end

return X