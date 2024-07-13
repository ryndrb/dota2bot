local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

local RI = require(GetScriptDirectory()..'/FunLib/util_role_item')

local sUtility = {"item_nullifier", "item_heavens_halberd"}
local sUtilityItem = RI.GetBestUtilityItem(sUtility)

local HeroBuild = {
    ['pos_1'] = {
        [1] = {
            ['talent'] = {
                [1] = {
                    ['t25'] = {10, 0},
                    ['t20'] = {0, 10},
                    ['t15'] = {0, 10},
                    ['t10'] = {10, 0},
                }
            },
            ['ability'] = {
                [1] = {2,3,1,2,2,6,2,3,3,3,6,1,1,1,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_faerie_fire",
            
                "item_wraith_band",
                "item_falcon_blade",
                "item_power_treads",
                "item_magic_wand",
                "item_maelstrom",
                "item_dragon_lance",
                "item_gungir",--
                "item_black_king_bar",--
                "item_aghanims_shard",
                "item_greater_crit",--
                "item_hurricane_pike",--
                "item_satanic",--
                "item_butterfly",--
                "item_moon_shard",
                "item_ultimate_scepter_2",
            },
            ['sell_list'] = {
                "item_wraith_band",
                "item_falcon_blade",
                "item_power_treads",
                "item_magic_wand",
            },
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
                    ['t25'] = {10, 0},
                    ['t20'] = {0, 10},
                    ['t15'] = {0, 10},
                    ['t10'] = {10, 0},
                }
            },
            ['ability'] = {
                [1] = {2,3,2,3,2,6,3,2,3,1,6,1,1,1,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_enchanted_mango",
                "item_double_branches",
                "item_circlet",
                "item_slippers",
            
                "item_magic_wand",
                "item_double_wraith_band",
                "item_power_treads",
                "item_maelstrom",
                "item_sphere",--
                "item_desolator",--
                sUtilityItem,--
                "item_orchid",
                "item_gungir",--
                "item_aghanims_shard",
                "item_bloodthorn",--
                "item_satanic",--
                "item_moon_shard",
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
                    ['t25'] = {10, 0},
                    ['t20'] = {0, 10},
                    ['t15'] = {10, 0},
                    ['t10'] = {10, 0},
                }
            },
            ['ability'] = {
                [1] = {2,3,1,2,2,6,2,1,1,1,6,3,3,3,6},
            },
            ['buy_list'] = {
                "item_double_tango",
                "item_double_branches",
                "item_faerie_fire",
                "item_circlet",
            
                "item_spirit_vessel",--
                "item_magic_wand",
                "item_rod_of_atos",
                "item_heavens_halberd",--
                "item_boots_of_bearing",--
                "item_gungir",--
                "item_sheepstick",--
                "item_sphere",--
                "item_ultimate_scepter_2",
                "item_aghanims_shard",
                "item_moon_shard",
            },
            ['sell_list'] = {
                "item_circlet",
                "item_magic_wand",
            },
        },
    },
    ['pos_5'] = {
        [1] = {
            ['talent'] = {
                [1] = {
                    ['t25'] = {10, 0},
                    ['t20'] = {0, 10},
                    ['t15'] = {10, 0},
                    ['t10'] = {10, 0},
                }
            },
            ['ability'] = {
                [1] = {2,3,1,2,2,6,2,1,1,1,6,3,3,3,6},
            },
            ['buy_list'] = {
                "item_double_tango",
                "item_double_branches",
                "item_faerie_fire",
                "item_circlet",
            
                "item_spirit_vessel",--
                "item_magic_wand",
                "item_rod_of_atos",
                "item_heavens_halberd",--
                "item_guardian_greaves",--
                "item_gungir",--
                "item_sheepstick",--
                "item_sphere",--
                "item_ultimate_scepter_2",
                "item_aghanims_shard",
                "item_moon_shard",
            },
            ['sell_list'] = {
                "item_circlet",
                "item_magic_wand",
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

local TheSwarm          = bot:GetAbilityByName('weaver_the_swarm')
local Shukuchi          = bot:GetAbilityByName('weaver_shukuchi')
-- local GeminateAttack    = bot:GetAbilityByName('weaver_geminate_attack')
local TimeLapse         = bot:GetAbilityByName('weaver_time_lapse')

local TheSwarmDesire, TheSwarmLocation
local ShukuchiDesire
local TimeLapseDesire

local botTarget
if bot.tryShukuchiKill == nil then bot.tryShukuchiKill = false end
if bot.ShukuchiKillTarget == nil then bot.ShukuchiKillTarget = nil end

function X.SkillsComplement()
    if J.CanNotUseAbility(bot) then return end

    botTarget = J.GetProperTarget(bot)
    if not bot:HasModifier("modifier_weaver_shukuchi")
    then
        bot.tryShukuchiKill = false
    end

    TimeLapseDesire, Target = X.ConsiderTimeLapse()
    if TimeLapseDesire > 0
    then
        if Target == 'self'
        then
            bot:Action_UseAbility(TimeLapse)
        else
            if bot:HasScepter()
            then
                bot:Action_UseAbilityOnEntity(TimeLapse, Target)
            end
        end

        return
    end

    ShukuchiDesire = X.ConsiderShukuchi()
    if ShukuchiDesire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:Action_UseAbility(Shukuchi)
        return
    end

    TheSwarmDesire, TheSwarmLocation = X.ConsiderTheSwarm()
    if TheSwarmDesire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:Action_UseAbilityOnLocation(TheSwarm, TheSwarmLocation)
        return
    end
end

function X.ConsiderTheSwarm()
    if not TheSwarm:IsFullyCastable()
    then
        return BOT_ACTION_DESIRE_NONE, 0
    end

	local nCastRange = TheSwarm:GetCastRange()
    local nRadius = TheSwarm:GetSpecialValueInt('spawn_radius')

    if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
        and J.CanCastOnMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange * 0.8)
        and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
            local nInRangeAlly = botTarget:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
            local nInRangeEnemy = botTarget:GetNearbyHeroes(1200, false, BOT_MODE_NONE)

            if  nInRangeAlly ~= nil and nInRangeEnemy ~= nil
            and #nInRangeAlly >= #nInRangeEnemy
            then
                nInRangeEnemy = J.GetEnemiesNearLoc(botTarget:GetLocation(), nRadius)
                if nInRangeEnemy ~= nil and #nInRangeEnemy >= 1
                then
                    return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nInRangeEnemy)
                end

                return BOT_ACTION_DESIRE_HIGH, botTarget:GetExtrapolatedLocation(0.5)
            end
		end
	end

	if J.IsRetreating(bot)
	then
        local nInRangeEnemy = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
        for _, enemyHero in pairs(nInRangeEnemy)
        do
            if  J.IsValidHero(enemyHero)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.IsChasingTarget(enemyHero, bot)
            and not J.IsSuspiciousIllusion(enemyHero)
            and not J.IsDisabled(enemyHero)
            then
                local nInRangeAlly = enemyHero:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
                local nTargetInRangeAlly = enemyHero:GetNearbyHeroes(1200, false, BOT_MODE_NONE)

                if  nInRangeAlly ~= nil and nTargetInRangeAlly ~= nil
                and ((#nTargetInRangeAlly > #nInRangeAlly)
                    or bot:WasRecentlyDamagedByAnyHero(2))
                then
                    nInRangeEnemy = J.GetEnemiesNearLoc(enemyHero:GetLocation(), nRadius)
                    if nInRangeEnemy ~= nil and #nInRangeEnemy >= 1
                    then
                        return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nInRangeEnemy)
                    end

                    return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
                end
            end
        end
	end

	if J.IsPushing(bot) or J.IsDefending(bot)
	then
        local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(1600, true)
		if nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 5
        then
            return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nEnemyLaneCreeps)
        end

        local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), 1600, nRadius, 0, 0)
        local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)
        if nInRangeEnemy ~= nil and #nInRangeEnemy >= 1
        then
            return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nInRangeEnemy)
        end
	end

    if J.IsDoingRoshan(bot)
    then
        if  J.IsRoshan(botTarget)
        and J.CanCastOnMagicImmune(botTarget)
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

function X.ConsiderShukuchi()
    if not Shukuchi:IsFullyCastable()
    then
        return BOT_ACTION_DESIRE_NONE
    end

    local nAttackRange = bot:GetAttackRange()
    local nDamage = Shukuchi:GetSpecialValueInt('damage')
    local nDuration = Shukuchi:GetSpecialValueFloat('duration')
    local nSpeed = 550
    local roshanLoc = J.GetCurrentRoshanLocation()
    local tormentorLoc = J.GetTormentorLocation(GetTeam())

    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
    for _, enemyHero in pairs(nEnemyHeroes)
    do
        if  J.IsValidHero(enemyHero)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
        and enemyHero:DistanceFromFountain() > 600
        and not J.IsSuspiciousIllusion(enemyHero)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
        and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
        then
            local eta = (GetUnitToUnitDistance(bot, enemyHero) / nSpeed)
            if eta + 1 < nDuration
            then
                if J.IsInLaningPhase()
                then
                    local nInRangeTower = enemyHero:GetNearbyTowers(700, false)
                    if nInRangeTower ~= nil and #nInRangeTower == 0
                    then
                        bot.tryShukuchiKill = true
                        bot.ShukuchiKillTarget = enemyHero
                        return BOT_ACTION_DESIRE_HIGH
                    end
                else
                    bot.tryShukuchiKill = true
                    bot.ShukuchiKillTarget = enemyHero
                    return BOT_ACTION_DESIRE_HIGH
                end
            end
        end
    end

    if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
        and J.CanCastOnMagicImmune(botTarget)
        and not J.IsInRange(bot, botTarget, nAttackRange + 300)
        and not botTarget:HasModifier('modifier_enigma_black_hole_pull')
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

    if J.IsRetreating(bot)
	then
        local nInRangeEnemy = bot:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
        for _, enemyHero in pairs(nInRangeEnemy)
        do
            if  J.IsValidHero(enemyHero)
            and J.IsChasingTarget(enemyHero, bot)
            and not J.IsDisabled(enemyHero)
            then
                local nInRangeAlly = enemyHero:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
                local nTargetInRangeAlly = enemyHero:GetNearbyHeroes(1200, false, BOT_MODE_NONE)

                if  nInRangeAlly ~= nil and nTargetInRangeAlly ~= nil
                and ((#nTargetInRangeAlly > #nInRangeAlly)
                    or bot:WasRecentlyDamagedByAnyHero(1.5))
                then
                    return BOT_ACTION_DESIRE_HIGH
                end
            end
        end

        if bot:WasRecentlyDamagedByTower(2)
        then
            return BOT_ACTION_DESIRE_HIGH
        end

        if  (J.IsTormentor(botTarget) or J.IsRoshan(botTarget))
        and J.IsInRange(bot, botTarget, 500)
        then
            if J.GetHP(bot) < 0.4
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
	end

    if J.IsPushing(bot)
    then
        local nInRangeAlly = bot:GetNearbyHeroes(1000, false, BOT_MODE_NONE)
        local nInRangeEnemy = bot:GetNearbyHeroes(1000, true, BOT_MODE_NONE)
        local eta = (GetUnitToLocationDistance(bot, GetLaneFrontLocation(GetTeam(), bot.laneToPush, 0)) / nSpeed)

        if  J.GetMP(bot) > 0.33
        and nInRangeAlly ~= nil and #nInRangeAlly == 0
        and nInRangeEnemy ~= nil and #nInRangeEnemy == 0
        and eta > nDuration + 1
        then
            return  BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsDefending(bot)
    then
        local nInRangeAlly = bot:GetNearbyHeroes(1000, false, BOT_MODE_NONE)
        local nInRangeEnemy = bot:GetNearbyHeroes(1000, true, BOT_MODE_NONE)
        local eta = (GetUnitToLocationDistance(bot, GetLaneFrontLocation(GetTeam(), bot.laneToDefend, 0)) / nSpeed)

        if  J.GetMP(bot) > 0.33
        and nInRangeAlly ~= nil and #nInRangeAlly == 0
        and nInRangeEnemy ~= nil and #nInRangeEnemy == 0
        and eta > nDuration
        then
            return  BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsFarming(bot)
	then
        local eta = (GetUnitToLocationDistance(bot, bot.farmLocation) / nSpeed)
        local nCreeps = bot:GetNearbyCreeps(1000, true)

		if  nCreeps ~= nil and #nCreeps == 0
        and J.GetMP(bot) > 0.3
        and eta > nDuration
		then
			return BOT_ACTION_DESIRE_HIGH
		end

        if  J.IsAttacking(bot)
        and J.IsValid(botTarget)
        and botTarget:IsCreep()
        and J.GetMP(bot) > 0.3
        and nCreeps ~= nil and #nCreeps >= 2
        then
            return BOT_ACTION_DESIRE_HIGH
        end
	end

    if J.IsLaning(bot)
	then
		if  ((bot:GetMana() - Shukuchi:GetManaCost()) / bot:GetMaxMana()) > 0.8
		and bot:DistanceFromFountain() > 100
		and bot:DistanceFromFountain() < 6000
		and J.IsInLaningPhase()
		and #nEnemyHeroes == 0
		then
			local nLane = bot:GetAssignedLane()
			local nLaneFrontLocation = GetLaneFrontLocation(GetTeam(), nLane, 0)
			local nDistFromLane = GetUnitToLocationDistance(bot, nLaneFrontLocation)

			if nDistFromLane > 800
			then
                return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

    if  J.IsDoingRoshan(bot)
    and J.GetMP(bot) > 0.4
    then
        local eta = (GetUnitToLocationDistance(bot, roshanLoc) / nSpeed)
        if eta > nDuration
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if  J.IsDoingTormentor(bot)
    and J.GetMP(bot) > 0.4
    then
        local eta = (GetUnitToLocationDistance(bot, tormentorLoc) / nSpeed)
        if eta > nDuration
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderTimeLapse()
    if not TimeLapse:IsFullyCastable()
    then
        return BOT_ACTION_DESIRE_NONE, nil
    end

	if J.IsRetreating(bot)
	then
        local nInRangeEnemy = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
        for _, enemyHero in pairs(nInRangeEnemy)
        do
            if  J.IsValidHero(enemyHero)
            and not J.IsSuspiciousIllusion(enemyHero)
            and not J.IsDisabled(enemyHero)
            then
                local nInRangeAlly = enemyHero:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
                local nTargetInRangeAlly = enemyHero:GetNearbyHeroes(1200, false, BOT_MODE_NONE)

                if  nInRangeAlly ~= nil and nTargetInRangeAlly ~= nil
                and ((#nTargetInRangeAlly > #nInRangeAlly))
                then
                    if J.GetHP(bot) < 0.42
                    and Shukuchi:IsTrained() and Shukuchi:GetCooldownTimeRemaining() < 2.5
                    and J.IsChasingTarget(enemyHero, bot)
                    then
                        return BOT_ACTION_DESIRE_HIGH, 'self'
                    end
                end

                if  J.GetHP(bot) < 0.33
                and bot:WasRecentlyDamagedByHero(enemyHero, 1)
                then
                    return BOT_ACTION_DESIRE_HIGH, 'self'
                end
            end
        end
	end

	if bot:HasScepter()
	then
        local nCastRange = TimeLapse:GetCastRange()
		local nInRangeAlly = bot:GetNearbyHeroes(nCastRange, false, BOT_MODE_NONE)

		for _, allyHero in pairs(nInRangeAlly)
        do
			if  J.IsValidHero(allyHero)
            and J.IsRetreating(allyHero)
            and J.GetHP(allyHero) < 0.33
            and J.IsCore(allyHero)
            and J.GetHP(bot) > 0.75
            and allyHero:WasRecentlyDamagedByAnyHero(2)
            and not J.IsSuspiciousIllusion(allyHero)
            and not allyHero:HasModifier('modifier_legion_commander_duel')
            and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			then
                local nInRangeEnemy = allyHero:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
                for _, enemyHero in pairs(nInRangeEnemy)
                do
                    if  J.IsValidHero(enemyHero)
                    and J.IsChasingTarget(enemyHero, allyHero)
                    and not J.IsSuspiciousIllusion(enemyHero)
                    and not J.IsDisabled(enemyHero)
                    then
                        return BOT_ACTION_DESIRE_HIGH, allyHero
                    end
                end
			end
		end
	end

    return BOT_ACTION_DESIRE_NONE, nil
end

return X