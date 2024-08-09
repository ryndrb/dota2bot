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
                "item_magic_stick",
            
                "item_double_wraith_band",
                "item_magic_wand",
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
                "item_magic_wand",
                "item_wraith_band",
                "item_power_treads",
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

end

local TheSwarm          = bot:GetAbilityByName('weaver_the_swarm')
local Shukuchi          = bot:GetAbilityByName('weaver_shukuchi')
-- local GeminateAttack    = bot:GetAbilityByName('weaver_geminate_attack')
local TimeLapse         = bot:GetAbilityByName('weaver_time_lapse')

local TheSwarmDesire, TheSwarmLocation
local ShukuchiDesire
local TimeLapseDesire

local botTarget, botName

function X.SkillsComplement()
    if J.CanNotUseAbility(bot) then return end

    TheSwarm          = bot:GetAbilityByName('weaver_the_swarm')
    Shukuchi          = bot:GetAbilityByName('weaver_shukuchi')
    TimeLapse         = bot:GetAbilityByName('weaver_time_lapse')

    botTarget = J.GetProperTarget(bot)
    botName = GetBot():GetUnitName()

    TimeLapseDesire, Target = X.ConsiderTimeLapse()
    if TimeLapseDesire > 0
    then
        if Target == 'self'
        then
            bot:Action_UseAbility(TimeLapse)
        else
            if bot:HasScepter()
            and string.find(botName, 'weaver')
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
        bot:ActionQueue_UseAbility(Shukuchi)
        return
    end

    TheSwarmDesire, TheSwarmLocation = X.ConsiderTheSwarm()
    if TheSwarmDesire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(TheSwarm, TheSwarmLocation)
        return
    end
end

function X.ConsiderTheSwarm()
    if not J.CanCastAbility(TheSwarm)
    then
        return BOT_ACTION_DESIRE_NONE, 0
    end

	local nCastRange = J.GetProperCastRange(false, bot, TheSwarm:GetCastRange())
    local nCastPoint = TheSwarm:GetCastPoint()
    local nRadius = TheSwarm:GetSpecialValueInt('spawn_radius')
    local nSpeed = TheSwarm:GetSpecialValueInt('speed')

    local nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.CanCastOnMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange * 0.8)
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
            local nDelay = (GetUnitToUnitDistance(bot, botTarget) / nSpeed) + nCastPoint
            local nInRangeEnemy = J.GetEnemiesNearLoc(botTarget:GetLocation(), nRadius)
            if nInRangeEnemy ~= nil and #nInRangeEnemy >= 2
            then
                return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nInRangeEnemy)
            end

            return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(botTarget, nDelay)
		end
	end

	if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
    and bot:WasRecentlyDamagedByAnyHero(3.5)
    and bot:GetActiveModeDesire() > 0.75
	then
        if string.find(botName, 'weaver')
        then
            if Shukuchi:GetCooldownTimeRemaining() < 2
            then
                return BOT_ACTION_DESIRE_NONE, 0
            end
        end

        if J.IsValidHero(nEnemyHeroes[1])
        and J.IsChasingTarget(nEnemyHeroes[1], bot)
        and not J.IsSuspiciousIllusion(nEnemyHeroes[1])
        then
            return BOT_ACTION_DESIRE_HIGH, nEnemyHeroes[1]:GetLocation()
        end
	end

    if J.IsDoingRoshan(bot)
    then
        if  J.IsRoshan(botTarget)
        and J.CanCastOnMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.IsAttacking(bot)
        and J.GetHP(botTarget) > 0.33
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
    end

    if J.IsDoingTormentor(bot)
    then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.IsAttacking(bot)
        and J.GetHP(botTarget) > 0.35
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
    end

    for _, allyHero in pairs(nAllyHeroes)
    do
        if J.IsValidHero(allyHero)
        and J.IsRetreating(allyHero)
        and allyHero:WasRecentlyDamagedByAnyHero(4)
        and not allyHero:IsIllusion()
        and not J.IsRealInvisible(allyHero)
        and not J.IsCore(bot)
        and not J.IsInTeamFight(bot, 1600)
        then
            local nAllyInRangeEnemy = allyHero:GetNearbyHeroes(nCastRange, true, BOT_MODE_NONE)

            if  J.IsValidHero(nAllyInRangeEnemy[1])
            and J.CanCastOnNonMagicImmune(nAllyInRangeEnemy[1])
            and J.IsInRange(allyHero, nAllyInRangeEnemy[1], 500)
            and J.IsInRange(bot, nAllyInRangeEnemy[1], nCastRange)
            and J.IsChasingTarget(nAllyInRangeEnemy[1], bot)
            and not J.IsDisabled(nAllyInRangeEnemy[1])
            and not nAllyInRangeEnemy[1]:HasModifier('modifier_enigma_black_hole_pull')
            and not nAllyInRangeEnemy[1]:HasModifier('modifier_faceless_void_chronosphere_freeze')
            then
                local nDelay = (GetUnitToUnitDistance(bot, botTarget) / nSpeed) + nCastPoint
                return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(nAllyInRangeEnemy[1], nDelay)
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderShukuchi()
    if not J.CanCastAbility(Shukuchi)
    or J.IsAttacking(bot)
    then
        return BOT_ACTION_DESIRE_NONE
    end

    local nAttackRange = bot:GetAttackRange()
    local nDamage = Shukuchi:GetSpecialValueInt('damage')
    local nDamageRadius = Shukuchi:GetSpecialValueInt('radius')
    local attackRange = bot:GetAttackRange()
    local manaCost = Shukuchi:GetManaCost()
    local roshanLoc = J.GetCurrentRoshanLocation()
    local tormentorLoc = J.GetTormentorLocation(GetTeam())

    if (J.IsStunProjectileIncoming(bot, 350) or J.IsUnitTargetProjectileIncoming(bot, 400))
    then
        return BOT_ACTION_DESIRE_HIGH
    end

	if not bot:HasModifier('modifier_sniper_assassinate') and not bot:IsMagicImmune()
	then
		if J.IsWillBeCastUnitTargetSpell(bot, 400)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

    if J.IsGoingOnSomeone(bot)
	then
		if J.IsValidTarget(botTarget)
        and J.CanCastOnMagicImmune(botTarget)
        and not J.IsInRange(bot, botTarget, nAttackRange)
        and not botTarget:HasModifier('modifier_enigma_black_hole_pull')
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

    if J.IsRetreating(bot)
	then
        local nInRangeAlly = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
        local nInRangeEnemy = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

        if bot:WasRecentlyDamagedByAnyHero(4)
        or (nInRangeAlly ~= nil and nInRangeEnemy ~= nil and #nInRangeEnemy > #nInRangeAlly)
        then
            return BOT_ACTION_DESIRE_HIGH
        end

        if bot:WasRecentlyDamagedByTower(3)
        then
            return BOT_ACTION_DESIRE_HIGH
        end

        if  (J.IsTormentor(botTarget) or J.IsRoshan(botTarget))
        and J.IsInRange(bot, botTarget, 1600)
        then
            if J.GetHP(bot) < 0.4
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
	end

    if J.IsPushing(bot)
    and J.GetManaAfter(manaCost) > 0.4
    and GetUnitToLocationDistance(bot, GetLaneFrontLocation(GetTeam(), bot.laneToPush, 0)) > attackRange * 2
    then
        return  BOT_ACTION_DESIRE_HIGH
    end

    if J.IsDefending(bot)
    and J.GetManaAfter(manaCost) > 0.4
    and GetUnitToLocationDistance(bot, GetLaneFrontLocation(GetTeam(), bot.laneToDefend, 0)) > attackRange * 2
    then
        return  BOT_ACTION_DESIRE_HIGH
    end

    if J.IsFarming(bot)
	then
		if J.GetManaAfter(Shukuchi:GetManaCost()) > 0.3
        and GetUnitToLocationDistance(bot, bot.farmLocation) > attackRange * 2
		then
			return BOT_ACTION_DESIRE_HIGH
		end

        local nCanKillCount = 0
        local nCreeps = bot:GetNearbyCreeps(nDamageRadius, true)
        for _, creep in pairs(nCreeps)
        do
            if J.IsValid(creep)
            and J.CanBeAttacked(creep)
            and creep:GetHealth() <= nDamage
            then
                nCanKillCount = nCanKillCount + 1
            end
        end

        if nCanKillCount >= 2
        then
            return BOT_ACTION_DESIRE_HIGH
        end
	end

    if J.IsLaning(bot)
	then
		if (J.GetManaAfter(manaCost)) > 0.8
		and bot:DistanceFromFountain() > 100
		and bot:DistanceFromFountain() < 6000
		and J.IsInLaningPhase()
		then
			local nLane = bot:GetAssignedLane()
			local nLaneFrontLocation = GetLaneFrontLocation(GetTeam(), nLane, 0)
			local nDistFromLane = GetUnitToLocationDistance(bot, nLaneFrontLocation)

			if nDistFromLane > 800
			then
                return BOT_ACTION_DESIRE_HIGH
			end
		end

        local nCanKillCount = 0
        local nCreeps = bot:GetNearbyCreeps(nDamageRadius, true)
        for _, creep in pairs(nCreeps)
        do
            if J.IsValid(creep)
            and J.CanBeAttacked(creep)
            and creep:GetHealth() <= nDamage
            then
                nCanKillCount = nCanKillCount + 1
            end
        end

        if nCanKillCount >= 2
        then
            return BOT_ACTION_DESIRE_HIGH
        end
	end

    if J.IsDoingRoshan(bot)
    and GetUnitToLocationDistance(bot, roshanLoc) > attackRange * 2
    and J.GetManaAfter(manaCost) > 0.3
    then
        return BOT_ACTION_DESIRE_HIGH
    end

    if J.IsDoingTormentor(bot)
    and GetUnitToLocationDistance(bot, tormentorLoc) > attackRange * 2
    and J.GetManaAfter(manaCost) > 0.3
    then
        return BOT_ACTION_DESIRE_HIGH
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderTimeLapse()
    if not J.CanCastAbility(TimeLapse)
    or bot:HasModifier('modifier_fountain_aura_buff')
    then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nInRangeAlly = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    local nInRangeEnemy = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
    local botHP = J.GetHP(bot)

	if bot.InfoBuffer ~= nil
	then
        local prevHealth = bot.InfoBuffer[5].health
        if prevHealth and (prevHealth / bot:GetMaxHealth()) - botHP >= 0.5
        then
            return BOT_ACTION_DESIRE_HIGH, 'self'
        end
	end

    if J.IsValidHero(nInRangeEnemy[1])
    then
        if  nInRangeAlly ~= nil and nInRangeEnemy ~= nil
        and (#nInRangeEnemy > #nInRangeAlly)
        then
            if botHP < 0.5
            and Shukuchi:IsTrained() and Shukuchi:GetCooldownTimeRemaining() < 2
            and J.IsChasingTarget(nInRangeEnemy[1], bot)
            then
                return BOT_ACTION_DESIRE_HIGH, 'self'
            end
        end

        if botHP < 0.51 and bot:WasRecentlyDamagedByAnyHero(2.5)
        then
            return BOT_ACTION_DESIRE_HIGH, 'self'
        end

        if bot.InfoBuffer ~= nil
        and J.IsInRange(bot, nInRangeEnemy[1], 800)
        and botHP < 0.5 and (bot:WasRecentlyDamagedByAnyHero(3) or J.IsChasingTarget(nInRangeEnemy[1], bot))
        then
            local prevLoc = bot.InfoBuffer[5].location
            if prevLoc
            then
                local dist = J.GetDistance(bot:GetLocation(), prevLoc)
                if dist > 800
                and J.GetDistance(nInRangeEnemy[1]:GetLocation(), prevLoc) > 800
                then
                    return BOT_ACTION_DESIRE_HIGH, 'self'
                end
            end
        end
    end

	if bot:HasScepter() and string.find(botName, 'weaver')
	then
        local nCastRange = J.GetProperCastRange(false, bot, TimeLapse:GetCastRange())
		for _, allyHero in pairs(nInRangeAlly)
        do
			if  J.IsValidHero(allyHero)
            and J.IsInRange(bot, allyHero, nCastRange)
            and J.IsRetreating(allyHero)
            and J.GetHP(allyHero) < 0.4
            and J.IsCore(allyHero)
            and allyHero:WasRecentlyDamagedByAnyHero(2)
            and not allyHero:IsIllusion()
            and not allyHero:HasModifier('modifier_legion_commander_duel')
            and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			then
                if J.IsValidHero(nInRangeEnemy[1])
                and J.IsChasingTarget(nInRangeEnemy[1], allyHero)
                and not J.IsSuspiciousIllusion(nInRangeEnemy[1])
                then
                    return BOT_ACTION_DESIRE_HIGH, allyHero
                end
			end
		end
	end

    return BOT_ACTION_DESIRE_NONE, nil
end

return X