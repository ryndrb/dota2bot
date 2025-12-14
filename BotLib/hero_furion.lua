local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_furion'
then

local RI = require(GetScriptDirectory()..'/FunLib/util_role_item')

local sUtility = {"item_heavens_halberd", "item_crimson_guard", "item_pipe"}
local sUtilityItem = RI.GetBestUtilityItem(sUtility)

local HeroBuild = {
    ['pos_1'] = {
        [1] = {
            ['talent'] = {
                [1] = {
                    ['t25'] = {10, 0},
                    ['t20'] = {10, 0},
                    ['t15'] = {0, 10},
                    ['t10'] = {0, 10},
                }
            },
            ['ability'] = {
                [1] = {1,2,1,2,1,6,1,2,2,3,6,3,3,3,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_faerie_fire",
                "item_double_branches",
                "item_circlet",
                "item_mantle",
            
                "item_magic_wand",
                "item_null_talisman",
                "item_power_treads",
                "item_maelstrom",
                "item_orchid",
                "item_mjollnir",--
                "item_black_king_bar",--
                "item_aghanims_shard",
                "item_hurricane_pike",--
                "item_satanic",--
                "item_bloodthorn",--
                "item_moon_shard",
                "item_greater_crit",--
                "item_ultimate_scepter_2",
            },
            ['sell_list'] = {
                "item_magic_wand", "item_hurricane_pike",
                "item_null_talisman", "item_satanic",
                "item_power_treads", "item_greater_crit",
            },
        },
    },
    ['pos_2'] = {
        [1] = {
            ['talent'] = {
                [1] = {
                    ['t25'] = {10, 0},
                    ['t20'] = {10, 0},
                    ['t15'] = {0, 10},
                    ['t10'] = {0, 10},
                }
            },
            ['ability'] = {
                [1] = {1,2,1,2,1,6,1,2,2,3,6,3,3,3,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_faerie_fire",
                "item_double_branches",
                "item_circlet",
                "item_mantle",
            
                "item_bottle",
                "item_magic_wand",
                "item_null_talisman",
                "item_power_treads",
                "item_maelstrom",
                "item_orchid",
                "item_mjollnir",--
                "item_black_king_bar",--
                "item_aghanims_shard",
                "item_hurricane_pike",--
                "item_satanic",--
                "item_bloodthorn",--
                "item_moon_shard",
                "item_sheepstick",--
                "item_ultimate_scepter_2",
            },
            ['sell_list'] = {
                "item_magic_wand", "item_black_king_bar",
                "item_null_talisman", "item_hurricane_pike",
                "item_bottle", "item_satanic",
                "item_power_treads", "item_sheepstick",
            },
        },
    },
    ['pos_3'] = {
        [1] = {
            ['talent'] = {
                [1] = {
                    ['t25'] = {10, 0},
                    ['t20'] = {10, 0},
                    ['t15'] = {0, 10},
                    ['t10'] = {0, 10},
                }
            },
            ['ability'] = {
                [1] = {3,1,3,2,3,6,3,2,2,2,6,1,1,1,6},
            },
            ['buy_list'] = {
                "item_blight_stone",
                "item_tango",
                "item_faerie_fire",
                "item_double_branches",
            
                "item_magic_wand",
                "item_double_bracer",
                "item_power_treads",
                "item_maelstrom",
                "item_rod_of_atos",
                "item_assault",--
                "item_mjollnir",--
                "item_black_king_bar",--
                "item_aghanims_shard",
                "item_hurricane_pike",--
                "item_sheepstick",--
                "item_moon_shard",
                "item_nullifier",--
                "item_ultimate_scepter_2",
            },
            ['sell_list'] = {
                "item_blight_stone", "item_rod_of_atos",
                "item_magic_wand", "item_assault",
                "item_bracer", "item_black_king_bar",
                "item_bracer", "item_hurricane_pike",
                "item_power_treads", "item_sheepstick",
                "item_rod_of_atos", "item_nullifier",
            },
        },
    },
    ['pos_4'] = {
        [1] = {
            ['talent'] = {
                [1] = {
                    ['t25'] = {0, 10},
                    ['t20'] = {0, 10},
                    ['t15'] = {10, 0},
                    ['t10'] = {10, 0},
                }
            },
            ['ability'] = {
                [1] = {2,1,1,2,1,6,1,2,2,3,6,3,3,3,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_blood_grenade",
                "item_double_circlet",
            
                "item_magic_wand",
                "item_tranquil_boots",
                "item_urn_of_shadows",
                "item_solar_crest",--
                "item_spirit_vessel",
                "item_boots_of_bearing",--
                "item_aghanims_shard",
                "item_ultimate_scepter",
                "item_orchid",
                "item_nullifier",--
                "item_bloodthorn",--
                "item_sheepstick",--
                "item_ultimate_scepter_2",
                "item_greater_crit",--
                "item_moon_shard",
            },
            ['sell_list'] = {
                "item_circlet", "item_orchid",
                "item_magic_wand", "item_nullifier",
                "item_spirit_vessel", "item_greater_crit",
            },
        },
    },
    ['pos_5'] = {
        [1] = {
            ['talent'] = {
                [1] = {
                    ['t25'] = {0, 10},
                    ['t20'] = {0, 10},
                    ['t15'] = {10, 0},
                    ['t10'] = {10, 0},
                }
            },
            ['ability'] = {
                [1] = {2,1,1,2,1,6,1,2,2,3,6,3,3,3,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_blood_grenade",
                "item_double_circlet",
            
                "item_magic_wand",
                "item_arcane_boots",
                "item_urn_of_shadows",
                "item_solar_crest",--
                "item_spirit_vessel",
                "item_guardian_greaves",--
                "item_aghanims_shard",
                "item_ultimate_scepter",
                "item_orchid",
                "item_nullifier",--
                "item_bloodthorn",--
                "item_sheepstick",--
                "item_ultimate_scepter_2",
                "item_greater_crit",--
                "item_moon_shard",
            },
            ['sell_list'] = {
                "item_circlet", "item_orchid",
                "item_magic_wand", "item_nullifier",
                "item_spirit_vessel", "item_greater_crit",
            },
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

local Sprout                = bot:GetAbilityByName('furion_sprout')
local Teleportation         = bot:GetAbilityByName('furion_teleportation')
local NaturesCall           = bot:GetAbilityByName('furion_force_of_nature')
local CurseOfTheOldGrowth   = bot:GetAbilityByName('furion_curse_of_the_forest')
local WrathOfNature         = bot:GetAbilityByName('furion_wrath_of_nature')

local SproutDesire, SproutTarget
local TeleportationDesire, TeleportationLocation
local NaturesCallDesire, NaturesCallLocation
local CurseOfTheOldGrowthDesire
local WrathOfNatureDesire, WrathOfNatureTarget

local SproutCallDesire, SproutCallTarget, SproutCallLocation

local bCanSummonMultipleTreants = true

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
    bot = GetBot()

    if J.CanNotUseAbility(bot) then return end

    Sprout                = bot:GetAbilityByName('furion_sprout')
    Teleportation         = bot:GetAbilityByName('furion_teleportation')
    NaturesCall           = bot:GetAbilityByName('furion_force_of_nature')
    CurseOfTheOldGrowth   = bot:GetAbilityByName('furion_curse_of_the_forest')
    WrathOfNature         = bot:GetAbilityByName('furion_wrath_of_nature')

    bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    if bCanSummonMultipleTreants then
        SproutCallDesire, SproutCallTarget, SproutCallLocation = X.ConsiderSproutCall()
        if SproutCallDesire > 0 then
            bot:Action_ClearActions(true)
            bot:ActionQueue_UseAbilityOnEntity(Sprout, SproutCallTarget)
            bot:ActionQueue_UseAbilityOnLocation(NaturesCall, SproutCallLocation)
            return
        end
    end

    TeleportationDesire, TeleportationLocation = X.ConsiderTeleportation()
    if TeleportationDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(Teleportation, TeleportationLocation)
        return
    end

    SproutDesire, SproutTarget = X.ConsiderSprout()
    if SproutDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(Sprout, SproutTarget)
        return
    end

    NaturesCallDesire, NaturesCallLocation = X.ConsiderNaturesCall()
    if NaturesCallDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        if bCanSummonMultipleTreants then
            bot:ActionQueue_UseAbilityOnLocation(NaturesCall, GetTreeLocation(NaturesCallLocation))
        else
            bot:ActionQueue_UseAbilityOnTree(NaturesCall, NaturesCallLocation)
        end
        return
    end

    CurseOfTheOldGrowthDesire = X.ConsiderCurseOfTheOldGrowth()
    if CurseOfTheOldGrowthDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(CurseOfTheOldGrowth)
        return
    end

    WrathOfNatureDesire, WrathOfNatureTarget = X.ConsiderWrathOfNature()
    if WrathOfNatureDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(WrathOfNature, WrathOfNatureTarget)
        return
    end
end

function X.ConsiderSprout()
    if not J.CanCastAbility(Sprout) then
        return BOT_ACTION_DESIRE_NONE, nil
    end

	local nCastRange = J.GetProperCastRange(false, bot, Sprout:GetCastRange())
    local nRadius = Sprout:GetSpecialValueInt('sprout_damage_radius')
    local nDamage = Sprout:GetSpecialValueInt('sprout_damage')
    local nDuration = Sprout:GetSpecialValueInt('duration')
    local nLevel = Sprout:GetLevel()
    local nManaCost = Sprout:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Teleportation, NaturesCall, CurseOfTheOldGrowth, WrathOfNature})

	if J.IsInTeamFight(bot, 1200) then
        local hTarget = nil
        local hTargetDamage = 0
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange + 300)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and not J.IsSuspiciousIllusion(enemyHero)
            and not J.IsDisabled(enemyHero)
            and not enemyHero:HasModifier('modifier_hoodwink_scurry_active')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            then
                local enemyHeroDamage = enemyHero:GetEstimatedDamageToTarget(false, bot, 5.0, DAMAGE_TYPE_ALL)
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

    if J.IsGoingOnSomeone(bot) then
        if  J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.CanCastOnTargetAdvanced(botTarget)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_hoodwink_scurry_active')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and not J.IsSuspiciousIllusion(enemyHero)
            and not J.IsDisabled(enemyHero)
            and bot:WasRecentlyDamagedByHero(enemyHero, 2.0)
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero
            end
        end
	end

    if nDamage > 0 then
        local nEnemyCreeps = bot:GetNearbyCreeps(Min(nCastRange + 300, 1600), true)

        if nLevel >= 3 and not J.HasItem(bot, 'item_mjollnir') then
            if J.IsPushing(bot) and bAttacking and fManaAfter > fManaThreshold1 + 0.1 and #nAllyHeroes <= 1 and #nEnemyHeroes <= 1 then
                for _, creep in pairs(nEnemyCreeps) do
                    if J.IsValid(creep) and J.CanBeAttacked(creep) then
                        local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                        if (nLocationAoE.count >= 4)
                        or (nLocationAoE.count >= 3 and creep:GetHealth() >= 550)
                        then
                            return BOT_ACTION_DESIRE_HIGH, creep
                        end
                    end
                end
            end

            if J.IsDefending(bot) and bAttacking and fManaAfter > fManaThreshold1 and #nAllyHeroes <= 2 then
                for _, creep in pairs(nEnemyCreeps) do
                    if J.IsValid(creep) and J.CanBeAttacked(creep) then
                        local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                        if (nLocationAoE.count >= 4)
                        or (nLocationAoE.count >= 3 and creep:GetHealth() >= 550)
                        then
                            return BOT_ACTION_DESIRE_HIGH, creep
                        end
                    end
                end
            end

            if J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold1 + 0.05 then
                for _, creep in pairs(nEnemyCreeps) do
                    if J.IsValid(creep) and J.CanBeAttacked(creep) then
                        local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                        if (nLocationAoE.count >= 3)
                        or (nLocationAoE.count >= 2 and creep:IsAncientCreep())
                        or (nLocationAoE.count >= 1 and creep:GetHealth() >= 550)
                        then
                            return BOT_ACTION_DESIRE_HIGH, creep
                        end
                    end
                end
            end
        end

        if J.IsLaning(bot) and J.IsInLaningPhase() and fManaAfter > fManaThreshold1 then
            for _, creep in pairs(nEnemyCreeps) do
                if  J.IsValid(creep)
                and J.CanBeAttacked(creep)
                and J.CanKillTarget(creep, nDamage, DAMAGE_TYPE_MAGICAL)
                and not J.IsOtherAllysTarget(creep)
                then
                    local sCreepName = creep:GetUnitName()
                    local nLocationAoE = bot:FindAoELocation(true, true, creep:GetLocation(), 0, 600, 0, 0)

                    if string.find(sCreepName, 'ranged') then
                        if nLocationAoE.count > 0 or J.IsUnitTargetedByTower(creep, false) or J.IsEnemyTargetUnit(creep, 1200) then
                            return BOT_ACTION_DESIRE_HIGH, creep
                        end
                    end

                    nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, nDamage)
                    if nLocationAoE.count >= 2 then
                        return BOT_ACTION_DESIRE_HIGH, creep
                    end
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderTeleportation()
    if not J.CanCastAbility(Teleportation) then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nChannelTime = Teleportation:GetCastPoint()

    local fTimeToFountain = bot:DistanceFromFountain() / bot:GetCurrentMovementSpeed()

	if not bot:IsMagicImmune() then
		if (J.IsStunProjectileIncoming(bot, 900))
        or (J.GetAttackProjectileDamageByRange(bot, 1200) > bot:GetHealth())
        then
			return BOT_ACTION_DESIRE_NONE, 0
		end
	end

	if J.IsStuck(bot) then
        local vLocation = J.GetClosestTeamLane(bot)
        if vLocation then
            local nInRangeEnemy = J.GetEnemiesNearLoc(vLocation, 1200)
            if #nInRangeEnemy == 0 then
                return BOT_ACTION_DESIRE_HIGH, vLocation
            end
        end
	end

    for i = 1, 5 do
        local allyHero = GetTeamMember(i)

        if J.IsValidHero(allyHero) and not bot:WasRecentlyDamagedByAnyHero(5.0) then
            if  J.IsInTeamFight(allyHero, 1200)
            and not J.IsInLaningPhase()
            and not J.IsRetreating(bot)
            and botHP > 0.3
            then
                local hTarget = nil
                local hTargetDamage = 0
                local nInRangeEnemy = J.GetEnemiesNearLoc(allyHero:GetLocation(), 1200)
                for _, enemyHero in pairs(nInRangeEnemy) do
                    if  J.IsValidHero(enemyHero)
                    and J.CanBeAttacked(enemyHero)
                    and GetUnitToLocationDistance(enemyHero, J.GetEnemyFountain()) > 1200
                    and not J.IsChasingTarget(allyHero, enemyHero)
                    and not J.IsSuspiciousIllusion(enemyHero)
                    and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
                    and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
                    then
                        local enemyHeroDamage = bot:GetEstimatedDamageToTarget(false, enemyHero, 5.0, DAMAGE_TYPE_ALL) / enemyHero:GetHealth()
                        local nInRangeAlly__ = J.GetAlliesNearLoc(allyHero:GetLocation(), 800)
                        local nInRangeEnemy__ = J.GetEnemiesNearLoc(allyHero:GetLocation(), 800)
                        if enemyHeroDamage > hTargetDamage and #nInRangeAlly__ >= #nInRangeEnemy__ then
                            hTarget = enemyHero
                            hTargetDamage = enemyHeroDamage
                        end
                    end
                end

                if hTarget and ((GetUnitToUnitDistance(bot, hTarget) / bot:GetCurrentMovementSpeed()) > nChannelTime + 2) then
                    return BOT_ACTION_DESIRE_HIGH, hTarget:GetLocation()
                end
            end
        end
    end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
        local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1200)
        if J.IsRunning(bot) and fTimeToFountain > nChannelTime + 1 and #nInRangeEnemy == 0 and botHP < 0.75 then
            return BOT_ACTION_DESIRE_HIGH, J.GetTeamFountain()
        end
	end

	if J.IsPushing(bot) and not bAttacking and #nEnemyHeroes == 0 then
		local nLane = LANE_MID
		if bot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP then nLane = LANE_TOP end
		if bot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT then nLane = LANE_BOT end

		local vLaneFrontLocation = GetLaneFrontLocation(GetTeam(), nLane, 0)
		if (GetUnitToLocationDistance(bot, vLaneFrontLocation) / bot:GetCurrentMovementSpeed()) > nChannelTime * 2 then
			if J.IsRunning(bot) and IsLocationPassable(vLaneFrontLocation) then
				return BOT_ACTION_DESIRE_HIGH, vLaneFrontLocation
			end
		end
	end

	if J.IsDefending(bot) and not bAttacking and #nEnemyHeroes == 0 then
		local nLane = LANE_MID
		if bot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP then nLane = LANE_TOP end
		if bot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT then nLane = LANE_BOT end

		local vLaneFrontLocation = GetLaneFrontLocation(GetTeam(), nLane, -1000)
		if (GetUnitToLocationDistance(bot, vLaneFrontLocation) / bot:GetCurrentMovementSpeed()) > nChannelTime * 2 then
			if J.IsRunning(bot) and IsLocationPassable(vLaneFrontLocation) then
				return BOT_ACTION_DESIRE_HIGH, vLaneFrontLocation
			end
		end
	end

	if J.IsFarming(bot) and not bAttacking and #nEnemyHeroes == 0 then
		if bot.farm and bot.farm.location then
            if (GetUnitToLocationDistance(bot, bot.farm.location) / bot:GetCurrentMovementSpeed()) > nChannelTime * 2 then
                if J.IsRunning(bot) and IsLocationPassable(bot.farm.location) then
                    return BOT_ACTION_DESIRE_HIGH, bot.farm.location
                end
            end
		end
	end

	if J.IsGoingToRune(bot) then
		if bot.rune and bot.rune.location then
            if (GetUnitToLocationDistance(bot, bot.rune.location) / bot:GetCurrentMovementSpeed()) > nChannelTime * 2 then
                if J.IsRunning(bot) and IsLocationPassable(bot.rune.location) then
                    return BOT_ACTION_DESIRE_HIGH, bot.rune.location
                end
            end
		end
	end

    if J.IsDoingRoshan(bot) then
        local vRoshanLocation = J.GetCurrentRoshanLocation()
        local nInRangeAlly = J.GetAlliesNearLoc(vRoshanLocation, 800)

        if ((GetUnitToLocationDistance(bot, vRoshanLocation) / bot:GetCurrentMovementSpeed()) > (nChannelTime + 1)) and #nInRangeAlly >= 1 then
            return BOT_ACTION_DESIRE_HIGH, vRoshanLocation
        end
    end

    if J.IsDoingTormentor(bot) then
        local vTormentorLocation = J.GetTormentorLocation()
        local nInRangeAlly = J.GetAlliesNearLoc(vTormentorLocation, 800)

        if ((GetUnitToLocationDistance(bot, vTormentorLocation) / bot:GetCurrentMovementSpeed()) > (nChannelTime + 1)) and (#nInRangeAlly >= 1 or bot.tormentor_state == false) then
            return BOT_ACTION_DESIRE_HIGH, vTormentorLocation
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderNaturesCall()
    if not J.CanCastAbility(NaturesCall) then
        return BOT_ACTION_DESIRE_NONE, 0
    end

	local nCastRange = J.GetProperCastRange(false, bot, NaturesCall:GetCastRange())
    local nManaCost = NaturesCall:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Sprout, Teleportation, CurseOfTheOldGrowth, WrathOfNature})

    local nTrees = bot:GetNearbyTrees(nCastRange)

    if #nTrees >= 1 then
        if J.IsInTeamFight(bot, 800) then
            return BOT_ACTION_DESIRE_HIGH, nTrees[1]
        end

        if J.IsGoingOnSomeone(bot) then
            if J.IsValidHero(botTarget)
            and J.CanBeAttacked(botTarget)
            and J.IsInRange(bot, botTarget, 900)
            and not J.IsSuspiciousIllusion(botTarget)
            and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
            and fManaAfter > fManaThreshold1
            then
                return BOT_ACTION_DESIRE_HIGH, nTrees[1]
            end
        end

        local nEnemyCreeps = bot:GetNearbyCreeps(1200, true)

        if J.IsPushing(bot) and bAttacking and fManaAfter > fManaThreshold1 and #nAllyHeroes <= 3 then
            if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
                if #nEnemyCreeps >= 4 then
                    return BOT_ACTION_DESIRE_HIGH, nTrees[1]
                end
            end
        end

        if J.IsDefending(bot) and bAttacking and fManaAfter > fManaThreshold1 then
            if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
                if #nEnemyCreeps >= 4 then
                    return BOT_ACTION_DESIRE_HIGH, nTrees[1]
                end
            end
        end

        if J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold1 then
            if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
                if (#nEnemyCreeps >= 3)
                or (#nEnemyCreeps >= 2 and nEnemyCreeps[1]:GetHealth() >= 550)
                then
                    return BOT_ACTION_DESIRE_HIGH, nTrees[1]
                end
            end
        end

        if J.IsDoingRoshan(bot) then
            if  J.IsRoshan(botTarget)
            and J.CanBeAttacked(botTarget)
            and J.IsInRange(bot, botTarget, bot:GetAttackRange())
            and bAttacking
            and fManaAfter > fManaThreshold1
            then
                return BOT_ACTION_DESIRE_HIGH, nTrees[1]
            end
        end

        if J.IsDoingTormentor(bot) then
            if  J.IsTormentor(botTarget)
            and J.IsInRange(bot, botTarget, bot:GetAttackRange())
            and bAttacking
            and fManaAfter > fManaThreshold1
            then
                return BOT_ACTION_DESIRE_HIGH, nTrees[1]
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderCurseOfTheOldGrowth()
    if not J.CanCastAbility(CurseOfTheOldGrowth) then
        return BOT_ACTION_DESIRE_NONE
    end

    local nRadius = CurseOfTheOldGrowth:GetSpecialValueInt('range')

    if J.IsGoingOnSomeone(bot) then
        local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), nRadius)
        if #nInRangeEnemy >= 2 then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderWrathOfNature()
    if not J.CanCastAbility(WrathOfNature) then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nDamage = WrathOfNature:GetSpecialValueInt('damage')

    for _, enemyHero in pairs(GetUnitList(UNIT_LIST_ENEMY_HEROES)) do
        if  J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanCastOnTargetAdvanced(enemyHero)
        and J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
        and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
        then
            return BOT_ACTION_DESIRE_HIGH, enemyHero
        end
    end

	if J.IsGoingOnSomeone(bot) and (bAttacking or bot:HasScepter()) then
        local hTarget = nil
        local hTargetHealth = math.huge
        for _, enemyHero in pairs(nEnemyHeroes) do
            if J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
            then
                local enemyHeroHealth = enemyHero:GetHealth()
                if enemyHeroHealth < hTargetHealth then
                    hTarget = enemyHero
                    hTargetHealth = enemyHeroHealth
                end
            end
        end

        if hTarget then
            return BOT_ACTION_DESIRE_HIGH, hTarget
        end
	end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderSproutCall()
    if J.CanCastAbility(Sprout) and J.CanCastAbility(NaturesCall) and (bot:GetMana() > (Sprout:GetManaCost() + NaturesCall:GetManaCost() + 100)) then
        local nCastRange = Min(Sprout:GetCastRange(), NaturesCall:GetCastRange())
        local nRadius = Sprout:GetSpecialValueInt('sprout_damage_radius')
        local nManaCost = Sprout:GetManaCost() + NaturesCall:GetManaCost()
        local fManaAfter = J.GetManaAfter(nManaCost)
        local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Teleportation, CurseOfTheOldGrowth, WrathOfNature})

        local nTrees = bot:GetNearbyTrees(nCastRange)

        if #nTrees >= 1 then
            local nEnemyCreeps = bot:GetNearbyCreeps(1200, true)

            if J.IsPushing(bot) and bAttacking and fManaAfter > fManaThreshold1 + 0.15 and #nAllyHeroes <= 2 then
                for _, creep in pairs(nEnemyCreeps) do
                    if J.IsValid(creep) and J.CanBeAttacked(creep) then
                        local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                        if (nLocationAoE.count >= 4) then
                            return BOT_ACTION_DESIRE_HIGH, creep, creep:GetLocation()
                        end
                    end
                end
            end

            if J.IsDefending(bot) and bAttacking and fManaAfter > fManaThreshold1 + 0.1 and #nEnemyHeroes <= 2 then
                for _, creep in pairs(nEnemyCreeps) do
                    if J.IsValid(creep) and J.CanBeAttacked(creep) then
                        local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                        if (nLocationAoE.count >= 4) then
                            return BOT_ACTION_DESIRE_HIGH, creep, creep:GetLocation()
                        end
                    end
                end
            end

            if J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold1 + 0.1 then
                for _, creep in pairs(nEnemyCreeps) do
                    if J.IsValid(creep) and J.CanBeAttacked(creep) then
                        local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                        if (nLocationAoE.count >= 3)
                        or (nLocationAoE.count >= 2 and creep:IsAncientCreep())
                        or (nLocationAoE.count >= 1 and creep:GetHealth() >= 550 and fManaAfter > fManaThreshold1 + 0.2)
                        then
                            return BOT_ACTION_DESIRE_HIGH, creep, creep:GetLocation()
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
                    return BOT_ACTION_DESIRE_HIGH, botTarget, botTarget:GetLocation()
                end
            end

            if J.IsDoingTormentor(bot) then
                if  J.IsTormentor(botTarget)
                and J.IsInRange(bot, botTarget, nCastRange)
                and bAttacking
                and fManaAfter > fManaThreshold1
                then
                    return BOT_ACTION_DESIRE_HIGH, botTarget, botTarget:GetLocation()
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil, 0
end

return X