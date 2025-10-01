local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_weaver'
then

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
                    ['t15'] = {10, 0},
                    ['t10'] = {10, 0},
                }
            },
            ['ability'] = {
                [1] = {2,3,1,2,2,6,2,3,3,3,6,1,1,1,6},
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
                "item_falcon_blade",
                "item_maelstrom",
                "item_dragon_lance",
                "item_mjollnir",--
                "item_black_king_bar",--
                "item_hurricane_pike",--
                "item_aghanims_shard",
                "item_greater_crit",--
                "item_satanic",--
                "item_moon_shard",
                "item_ultimate_scepter_2",
                "item_butterfly",--
            },
            ['sell_list'] = {
                "item_quelling_blade", "item_dragon_lance",
                "item_wraith_band", "item_black_king_bar",
                "item_magic_wand", "item_greater_crit",
                "item_falcon_blade", "item_satanic",
                "item_power_treads", "item_butterfly",
            },
        },
        [2] = {
            ['talent'] = {
                [1] = {
                    ['t25'] = {10, 0},
                    ['t20'] = {0, 10},
                    ['t15'] = {10, 0},
                    ['t10'] = {10, 0},
                }
            },
            ['ability'] = {
                [1] = {2,3,1,2,2,6,2,3,3,3,6,1,1,1,6},
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
                "item_falcon_blade",
                "item_desolator",--
                "item_dragon_lance",
                "item_black_king_bar",--
                "item_hurricane_pike",--
                "item_aghanims_shard",
                "item_greater_crit",--
                "item_satanic",--
                "item_moon_shard",
                "item_ultimate_scepter_2",
                "item_butterfly",--
            },
            ['sell_list'] = {
                "item_quelling_blade", "item_dragon_lance",
                "item_wraith_band", "item_black_king_bar",
                "item_magic_wand", "item_greater_crit",
                "item_falcon_blade", "item_satanic",
                "item_power_treads", "item_butterfly",
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
                    ['t15'] = {10, 0},
                    ['t10'] = {10, 0},
                }
            },
            ['ability'] = {
                [1] = {2,3,1,2,2,6,2,1,1,1,6,3,3,3,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_magic_stick",
                "item_blood_grenade",
                "item_circlet",
            
                "item_urn_of_shadows",
                "item_magic_wand",
                "item_tranquil_boots",
                "item_spirit_vessel",
                "item_rod_of_atos",
                "item_orchid",
                "item_boots_of_bearing",--
                "item_sheepstick",--
                "item_gungir",--
                "item_sphere",--
                "item_bloodthorn",--
                "item_moon_shard",
                "item_aghanims_shard",
                "item_nullifier",--
                "item_ultimate_scepter_2",
            },
            ['sell_list'] = {
                "item_magic_wand", "item_sphere",
                "item_spirit_vessel", "item_nullifier",
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
                "item_tango",
                "item_double_branches",
                "item_magic_stick",
                "item_blood_grenade",
                "item_circlet",
            
                "item_urn_of_shadows",
                "item_magic_wand",
                "item_arcane_boots",
                "item_spirit_vessel",
                "item_rod_of_atos",
                "item_orchid",
                "item_guardian_greaves",--
                "item_sheepstick",--
                "item_gungir",--
                "item_sphere",--
                "item_bloodthorn",--
                "item_moon_shard",
                "item_aghanims_shard",
                "item_nullifier",--
                "item_ultimate_scepter_2",
            },
            ['sell_list'] = {
                "item_magic_wand", "item_sphere",
                "item_spirit_vessel", "item_nullifier",
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

local TheSwarm          = bot:GetAbilityByName('weaver_the_swarm')
local Shukuchi          = bot:GetAbilityByName('weaver_shukuchi')
-- local GeminateAttack    = bot:GetAbilityByName('weaver_geminate_attack')
local TimeLapse         = bot:GetAbilityByName('weaver_time_lapse')

local TheSwarmDesire, TheSwarmLocation
local ShukuchiDesire
local TimeLapseDesire

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
    bot = GetBot()

    if J.CanNotUseAbility(bot) then return end

    TheSwarm          = bot:GetAbilityByName('weaver_the_swarm')
    Shukuchi          = bot:GetAbilityByName('weaver_shukuchi')
    TimeLapse         = bot:GetAbilityByName('weaver_time_lapse')

	bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    TimeLapseDesire, Target = X.ConsiderTimeLapse()
    if TimeLapseDesire > 0 then
        if Target == 'self' then
            bot:Action_UseAbility(TimeLapse)
        else
            if bot:HasScepter() and string.find(bot:GetUnitName(), 'weaver') then
                bot:Action_UseAbilityOnEntity(TimeLapse, Target)
            end
        end

        return
    end

    ShukuchiDesire = X.ConsiderShukuchi()
    if ShukuchiDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(Shukuchi)
        return
    end

    TheSwarmDesire, TheSwarmLocation = X.ConsiderTheSwarm()
    if TheSwarmDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(TheSwarm, TheSwarmLocation)
        return
    end
end

function X.ConsiderTheSwarm()
    if not J.CanCastAbility(TheSwarm) then
        return BOT_ACTION_DESIRE_NONE, 0
    end

	local nCastRange = TheSwarm:GetCastRange()
    local nCastPoint = TheSwarm:GetCastPoint()
    local nRadius = TheSwarm:GetSpecialValueInt('spawn_radius')
    local nSpeed = TheSwarm:GetSpecialValueInt('speed')
    local nManaCost = TheSwarm:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Shukuchi, TimeLapse})

    if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.CanCastOnMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange / 2)
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and fManaAfter > fManaThreshold1
		then
            if J.IsChasingTarget(bot, botTarget) then
				if J.IsInRange(bot, botTarget, bot:GetAttackRange() + 350) then
					return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
				end
			else
				if J.IsInRange(bot, botTarget, nCastRange / 2) then
					return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
				end
			end
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(4.0) then
        if J.IsValidHero(nEnemyHeroes[1])
        and J.IsChasingTarget(nEnemyHeroes[1], bot)
        and not J.IsSuspiciousIllusion(nEnemyHeroes[1])
        then
            return BOT_ACTION_DESIRE_HIGH, nEnemyHeroes[1]:GetLocation()
        end

        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange / 2)
			and J.IsChasingTarget(enemyHero, bot)
            and not J.IsSuspiciousIllusion(enemyHero)
            and not J.IsDisabled(enemyHero)
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
            end
        end
	end

    if J.IsDoingRoshan(bot) then
        if  J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.GetHP(botTarget) > 0.2
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
                    and J.IsInRange(bot, enemyHero, nCastRange / 2)
                    and J.CanCastOnNonMagicImmune(enemyHero)
                    and J.CanCastOnTargetAdvanced(enemyHero)
                    and J.IsChasingTarget(enemyHero, allyHero)
                    and not J.IsDisabled(enemyHero)
                    then
                        return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(enemyHero, 1.0 + nCastPoint)
                    end
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderShukuchi()
    if not J.CanCastAbility(Shukuchi)
    or J.IsRealInvisible(bot)
    or bAttacking
    then
        return BOT_ACTION_DESIRE_NONE
    end

    local nAttackRange = bot:GetAttackRange()
    local nDamage = Shukuchi:GetSpecialValueInt('damage')
    local nDamageRadius = Shukuchi:GetSpecialValueInt('radius')
    local nManaCost = Shukuchi:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Shukuchi, TimeLapse})

    if not bot:IsMagicImmune() then
        if (J.IsStunProjectileIncoming(bot, 350))
        or (J.IsUnitTargetProjectileIncoming(bot, 400))
        or (not bot:HasModifier('modifier_sniper_assassinate') and J.IsWillBeCastUnitTargetSpell(bot, 400))
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsGoingOnSomeone(bot) then
		if J.IsValidTarget(botTarget)
        and not J.IsInRange(bot, botTarget, nAttackRange)
        and not botTarget:HasModifier('modifier_enigma_black_hole_pull')
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

    if J.IsRetreating(bot) then
        return BOT_ACTION_DESIRE_HIGH
	end

    if J.IsPushing(bot) and fManaAfter > fManaThreshold1 + 0.15 then
        local nLane = LANE_MID
		if bot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP then nLane = LANE_TOP end
		if bot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT then nLane = LANE_BOT end

		local vLaneFrontLocation = GetLaneFrontLocation(GetTeam(), nLane, 0)
		if GetUnitToLocationDistance(bot, vLaneFrontLocation) > nAttackRange * 2 then
            return BOT_ACTION_DESIRE_HIGH
		end
    end

    if J.IsDefending(bot) and fManaAfter > fManaThreshold1 + 0.15 then
        local nLane = LANE_MID
		if bot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP then nLane = LANE_TOP end
		if bot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT then nLane = LANE_BOT end

		local vLaneFrontLocation = GetLaneFrontLocation(GetTeam(), nLane, 0)
		if GetUnitToLocationDistance(bot, vLaneFrontLocation) > nAttackRange * 2 then
            return BOT_ACTION_DESIRE_HIGH
		end
    end

    if J.IsFarming(bot) and fManaAfter > fManaThreshold1 + 0.1 then
		if bot.farm and bot.farm.location then
			local distance = GetUnitToLocationDistance(bot, bot.farm.location)
			if J.IsRunning(bot) and distance > nAttackRange * 2 then
				return BOT_ACTION_DESIRE_HIGH
			end
		end

        local nLocationAoE = bot:FindAoELocation(true, false, bot:GetLocation(), 0, nDamageRadius, 0, nDamage + 1)
        if nLocationAoE.count >= 3 then
            return BOT_ACTION_DESIRE_HIGH
        end
	end

	if J.IsGoingToRune(bot) and fManaAfter > fManaThreshold1 + 0.1 then
		if bot.rune and bot.rune.location then
            local nInRangeEnemy = J.GetEnemiesNearLoc(bot.rune.location, 800)
            if #nInRangeEnemy > 0 then
                local distance = GetUnitToLocationDistance(bot, bot.rune.location)
                if J.IsRunning(bot) and distance > nAttackRange * 2 then
                    return BOT_ACTION_DESIRE_HIGH
                end
            end
		end
	end

    if J.IsLaning(bot) and J.IsInLaningPhase() then
		if  fManaAfter > 0.8
		and bot:DistanceFromFountain() > 100
		and bot:DistanceFromFountain() < 6000
		then
            local vLaneFrontLocation = GetLaneFrontLocation(GetTeam(), bot:GetAssignedLane(), 0)
            if  GetUnitToLocationDistance(bot, vLaneFrontLocation) > nAttackRange * 2
            and bot:IsFacingLocation(vLaneFrontLocation, 30)
            then
                return BOT_ACTION_DESIRE_HIGH
            end
		end

        local nLocationAoE = bot:FindAoELocation(true, false, bot:GetLocation(), 0, nDamageRadius, 0, nDamage + 1)
        if nLocationAoE.count >= 3 and fManaAfter > fManaThreshold1 + 0.1 then
            return BOT_ACTION_DESIRE_HIGH
        end
	end

    if J.IsDoingRoshan(bot) then
        local vRoshanLocation = J.GetCurrentRoshanLocation()
        if  GetUnitToLocationDistance(bot, vRoshanLocation) > nAttackRange * 2
        and #nEnemyHeroes == 0
        and fManaAfter > fManaThreshold1 + 0.2
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsDoingTormentor(bot) then
        local vTormentorLocation = J.GetTormentorLocation(GetTeam())
        if  GetUnitToLocationDistance(bot, vTormentorLocation) > nAttackRange * 2
        and #nEnemyHeroes == 0
        and fManaAfter > fManaThreshold1 + 0.2
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderTimeLapse()
    if not J.CanCastAbility(TimeLapse)
    or bot:HasModifier('modifier_fountain_aura_buff')
    then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nLapseTime = 5

	if  bot.history
    and bot.history[nLapseTime]
    and bot.history[nLapseTime].health
    then
        local prevHealth = bot.history[nLapseTime].health
        if prevHealth and (prevHealth / bot:GetMaxHealth()) - botHP >= 0.5 then
            return BOT_ACTION_DESIRE_HIGH, 'self'
        end
	end

    if J.IsValidHero(nEnemyHeroes[1]) and not J.IsSuspiciousIllusion(nEnemyHeroes[1]) then
        if(#nEnemyHeroes > #nAllyHeroes) then
            if  botHP < 0.5
            and J.CanCastAbilitySoon(Shukuchi, 2)
            and J.IsChasingTarget(nEnemyHeroes[1], bot)
            then
                return BOT_ACTION_DESIRE_HIGH, 'self'
            end
        end

        if botHP < 0.4 and bot:WasRecentlyDamagedByAnyHero(2.5) then
            return BOT_ACTION_DESIRE_HIGH, 'self'
        end

        if  bot.history
        and bot.history[nLapseTime]
        and bot.history[nLapseTime].location
        and J.IsInRange(bot, nEnemyHeroes[1], 800)
        and botHP < 0.5
        and (bot:WasRecentlyDamagedByAnyHero(3)
            or J.IsChasingTarget(nEnemyHeroes[1], bot)
            or (#nEnemyHeroes > #nAllyHeroes and nEnemyHeroes[1]:GetAttackTarget() == bot))
        then
            local vPrevLocation = bot.history[nLapseTime].location
            if vPrevLocation then
                local dist = GetUnitToLocationDistance(bot, vPrevLocation)
                local nInRangeAlly = J.GetAlliesNearLoc(vPrevLocation, 800)
                local nInRangeEnemy = J.GetEnemiesNearLoc(vPrevLocation, 800)
                if dist > 600 and #nInRangeAlly >= #nInRangeEnemy then
                    return BOT_ACTION_DESIRE_HIGH, 'self'
                end
            end
        end
    end

	if  bot:HasScepter()
    and bot:GetUnitName() == 'npc_dota_hero_weaver'
    and not J.IsRetreating(bot)
    and botHP > 0.5
    then
        local nCastRange = J.GetProperCastRange(false, bot, TimeLapse:GetCastRange())
		for _, allyHero in pairs(nAllyHeroes) do
			if  J.IsValidHero(allyHero)
            and J.CanBeAttacked(allyHero)
            and bot ~= allyHero
            and J.IsInRange(bot, allyHero, nCastRange)
            and J.IsRetreating(allyHero)
            and J.GetHP(allyHero) < 0.4
            and allyHero:WasRecentlyDamagedByAnyHero(2.0)
            and not J.IsSuspiciousIllusion(allyHero)
            and not allyHero:HasModifier('modifier_legion_commander_duel')
            and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			then
                if  allyHero.history[nLapseTime]
                and allyHero.history[nLapseTime].health
                then
                    local prevHealth = allyHero.history[nLapseTime].health
                    if prevHealth and (prevHealth / allyHero:GetMaxHealth()) - J.GetHP(allyHero) >= 0.5 then
                        return BOT_ACTION_DESIRE_HIGH, allyHero
                    end
                end
			end
		end
	end

    return BOT_ACTION_DESIRE_NONE, nil
end

return X