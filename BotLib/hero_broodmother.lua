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
                "item_revenants_brooch",--
				"item_butterfly",--
				"item_bloodthorn",--
                "item_abyssal_blade",--
				"item_travel_boots_2",--
				"item_moon_shard",
				"item_ultimate_scepter_2",
			},
            ['sell_list'] = {
                "item_quelling_blade", "item_orchid",
				"item_magic_wand", "item_black_king_bar",
				"item_soul_ring", "item_revenants_brooch",
                "item_wraith_band", "item_butterfly",
                "item_wraith_band", "item_abyssal_blade",
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
                "item_revenants_brooch",--
				"item_butterfly",--
				"item_bloodthorn",--
                "item_abyssal_blade",--
				"item_travel_boots_2",--
				"item_moon_shard",
				"item_ultimate_scepter_2",
			},
            ['sell_list'] = {
                "item_quelling_blade", "item_orchid",
				"item_magic_wand", "item_black_king_bar",
				"item_soul_ring", "item_revenants_brooch",
                "item_wraith_band", "item_butterfly",
                "item_wraith_band", "item_abyssal_blade",
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
				"item_travel_boots_2",--
				"item_moon_shard",
				"item_ultimate_scepter_2",
			},
            ['sell_list'] = {
                "item_quelling_blade", "item_orchid",
				"item_magic_wand", "item_assault",
				"item_soul_ring", "item_black_king_bar",
                "item_wraith_band", "item_sheepstick",
                "item_wraith_band", "item_abyssal_blade",
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
-- local SpinnersSnare     = bot:GetAbilityByName('broodmother_sticky_snare')
local SpawnSpiderlings  = bot:GetAbilityByName('broodmother_spawn_spiderlings')

local InsatiableHungerDesire
local SpinWebDesire, SpinWebLocation
-- local SilkenBolaDesire, SilkenBolaTarget
-- local SpinnersSnareDesire, SpinnersSnareLocation -- No Unit.
local SpawnSpiderlingsDesire, SpirderlingsTarget

function X.SkillsComplement()
	if J.CanNotUseAbility(bot) then return end

	InsatiableHunger  = bot:GetAbilityByName('broodmother_insatiable_hunger')
	SpinWeb           = bot:GetAbilityByName('broodmother_spin_web')
	SpawnSpiderlings  = bot:GetAbilityByName('broodmother_spawn_spiderlings')

    SpawnSpiderlingsDesire, SpirderlingsTarget = X.ConsiderSpawnSpiderlings()
    if SpawnSpiderlingsDesire > 0
    then
		J.SetQueuePtToINT(bot, true)
        bot:ActionQueue_UseAbilityOnEntity(SpawnSpiderlings, SpirderlingsTarget)
        return
    end

    SpinWebDesire, SpinWebLocation = X.ConsiderSpinWeb()
    if SpinWebDesire > 0
    then
		J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(SpinWeb, SpinWebLocation)
        return
    end

    -- SilkenBolaDesire, SilkenBolaTarget = X.ConsiderSilkenBola()
    -- if SilkenBolaDesire > 0
    -- then
    --     bot:Action_UseAbilityOnEntity(SilkenBola, SilkenBolaTarget)
    --     return
    -- end

    InsatiableHungerDesire = X.ConsiderInsatiableHunger()
    if InsatiableHungerDesire > 0
    then
		J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(InsatiableHunger)
        return
    end
end

function X.ConsiderInsatiableHunger()
	if not J.CanCastAbility(InsatiableHunger)
    then
        return BOT_ACTION_DESIRE_NONE
    end

    local nAttackRange = bot:GetAttackRange()
    local botTarget = J.GetProperTarget(bot)

    if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
        and J.IsInRange(bot, botTarget, nAttackRange + 150)
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

    if J.IsFarming(bot)
    then
        local nCreeps = bot:GetNearbyCreeps(700, true)

        if  nCreeps ~= nil and #nCreeps > 0
        and J.CanBeAttacked(nCreeps[1])
        and J.GetHP(bot) < 0.4
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsDoingRoshan(bot)
	then
		if  J.IsRoshan(botTarget)
        and J.IsInRange(bot, botTarget, 500)
        and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

    if J.IsDoingTormentor(bot)
    then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, 500)
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderSpinWeb()
	if not J.CanCastAbility(SpinWeb)
    then
        return BOT_ACTION_DESIRE_NONE, 0
    end

	local nCastRange = J.GetProperCastRange(false, bot, SpinWeb:GetCastRange())
    local nRadius = SpinWeb:GetSpecialValueInt('radius')
    local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(1600, true)
    local nEnemyHeroes = bot:GetNearbyTowers(1600, true)
    local nEnemyTowers = bot:GetNearbyTowers(700, true)
    local botTarget = J.GetProperTarget(bot)

    -- limit web in first ~3 minutes for mid; try every 30 sec; 7.37 change
    -- if bot.shouldWebMid == false
    -- and DotaTime() < 3 * 60 and DotaTime() % 30 ~= 0
    -- and J.GetPosition(bot) ~= 2
    -- then
    --     return BOT_ACTION_DESIRE_NONE, 0
    -- end

    -- if bot.shouldWebMid == true
    -- then
    --     local targetLoc = Vector(-277, -139, 49)
    --     if GetTeam() == TEAM_DIRE
    --     then
    --         targetLoc = Vector(-768, -621, 56)
    --     end

    --     if GetUnitToLocationDistance(bot, targetLoc) <= nCastRange / 2
    --     then
    --         bot.shouldWebMid = false
    --         return BOT_ACTION_DESIRE_HIGH, targetLoc
    --     end
    -- end

    if  J.IsStuck(bot)
    and not X.DoesLocationHaveWeb(bot:GetLocation(), nRadius)
	then
		return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
	end

    if J.IsInTeamFight(bot, 1200)
	then
        local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
        local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius / 1.7)

        if  nInRangeEnemy ~= nil and #nInRangeEnemy >= 2
        and not X.DoesLocationHaveWeb(nLocationAoE.targetloc, nRadius)
        and not J.IsLocationInChrono(nLocationAoE.targetloc)
        then
			return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
        end
	end

    if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not J.IsSuspiciousIllusion(botTarget)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not X.DoesLocationHaveWeb(botTarget:GetLocation(), nRadius)
        and not J.IsLocationInChrono(botTarget:GetLocation())
		then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

    if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
	then
        if J.IsValidHero(nEnemyHeroes[1])
        and J.IsInRange(bot, nEnemyHeroes[1], 600)
        and bot:WasRecentlyDamagedByAnyHero(3)
        and not J.IsSuspiciousIllusion(nEnemyHeroes[1])
        and not J.IsDisabled(nEnemyHeroes[1])
        and not X.DoesLocationHaveWeb(bot:GetLocation(), nRadius)
        then
            return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
        end
    end

    if J.IsPushing(bot)
	then
		if  nEnemyTowers ~= nil and #nEnemyTowers >= 1
        and J.CanBeAttacked(nEnemyTowers[1])
        and not X.DoesLocationHaveWeb(nEnemyTowers[1]:GetLocation(), nRadius)
		then
			return BOT_ACTION_DESIRE_HIGH, nEnemyTowers[1]:GetLocation()
		end
	end

    if J.IsLaning(bot) or J.IsPushing(bot)
    then
		if  nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 4
        and J.CanBeAttacked(nEnemyLaneCreeps[1])
        and not J.IsRunning(nEnemyLaneCreeps[1])
        and not X.DoesLocationHaveWeb(J.GetCenterOfUnits(nEnemyLaneCreeps), nRadius)
        then
			return BOT_MODE_DESIRE_HIGH, J.GetCenterOfUnits(nEnemyLaneCreeps)
		end
	end

    if J.IsDoingRoshan(bot)
	then
		if  J.IsRoshan(botTarget)
        and J.IsInRange(bot, botTarget, 500)
        and J.IsAttacking(bot)
        and not X.DoesLocationHaveWeb(botTarget:GetLocation(), nRadius)
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

    if J.IsDoingTormentor(bot)
    then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, 500)
        and J.IsAttacking(bot)
        and not X.DoesLocationHaveWeb(botTarget:GetLocation(), nRadius)
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.DoesLocationHaveWeb(loc, nRadius)
	for _, u in pairs (GetUnitList(UNIT_LIST_ALLIES))
	do
		if  J.IsValid(u)
        and u:GetUnitName() == 'npc_dota_broodmother_web'
        and GetUnitToLocationDistance(u, loc) < nRadius
		then
			return true
		end
	end

	return false
end

function X.ConsiderSpawnSpiderlings()
	if not J.CanCastAbility(SpawnSpiderlings)
    then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastRange = J.GetProperCastRange(false, bot, SpawnSpiderlings:GetCastRange())
	local nDamage = SpawnSpiderlings:GetSpecialValueInt('damage')

    local nEnemyHeroes = bot:GetNearbyHeroes(nCastRange, true, BOT_MODE_NONE)
    for _, enemyHero in pairs(nEnemyHeroes)
    do
        if  J.IsValidHero(enemyHero)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
        and not J.IsSuspiciousIllusion(enemyHero)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
        and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
        then
            return BOT_ACTION_DESIRE_HIGH, enemyHero
        end
    end

    local nCreeps = bot:GetNearbyCreeps(nCastRange, true)
    for _, creep in pairs(nCreeps)
    do
        if  J.IsValid(creep)
        and J.CanBeAttacked(creep)
        and J.CanKillTarget(creep, nDamage, DAMAGE_TYPE_MAGICAL)
        and not J.IsRetreating(bot)
        then
            return BOT_ACTION_DESIRE_HIGH, creep
        end
    end

	return BOT_ACTION_DESIRE_NONE, 0
end

return X