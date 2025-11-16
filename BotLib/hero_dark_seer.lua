local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_dark_seer'
then

local RI = require(GetScriptDirectory()..'/FunLib/util_role_item')

local sUtility = {'item_crimson_guard', 'item_lotus_orb', 'item_heavens_halberd'}
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
					['t15'] = {10, 0},
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
                [1] = {2,3,2,1,2,6,2,3,3,3,1,6,1,1,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
                "item_quelling_blade",
                "item_circlet",
                "item_mantle",
			
				"item_magic_wand",
                "item_null_talisman",
				"item_arcane_boots",
                "item_soul_ring",
                "item_pipe",--
				"item_blink",
				sUtilityItem,--
				"item_black_king_bar",--
				"item_shivas_guard",--
				"item_aghanims_shard",
				"item_overwhelming_blink",--
				"item_ultimate_scepter_2",
				"item_moon_shard",
                "item_travel_boots_2",--
			},
            ['sell_list'] = {
                "item_quelling_blade", "item_blink",
				"item_magic_wand", sUtilityItem,
                "item_soul_ring", "item_black_king_bar",
                "item_null_talisman", "item_shivas_guard",
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

function X.MinionThink(hMinionUnit)
	Minion.MinionThink(hMinionUnit)
end

end

local Vacuum            = bot:GetAbilityByName('dark_seer_vacuum')
local IonShell          = bot:GetAbilityByName('dark_seer_ion_shell')
local Surge             = bot:GetAbilityByName('dark_seer_surge')
-- local NormalPunch       = bot:GetAbilityByName('dark_seer_normal_punch')
local WallOfReplica     = bot:GetAbilityByName('dark_seer_wall_of_replica')

local VacuumDesire, VacuumLocation
local IonShellDesire, IonShellTarget
local SurgeDesire, SurgeTarget
local WallOfReplicaDesire, WallOfReplicaLocation

local VacuumWallDesire, VacuumwallLocation

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
    bot = GetBot()

	if J.CanNotUseAbility(bot) then return end

    Vacuum            = bot:GetAbilityByName('dark_seer_vacuum')
    IonShell          = bot:GetAbilityByName('dark_seer_ion_shell')
    Surge             = bot:GetAbilityByName('dark_seer_surge')
    WallOfReplica     = bot:GetAbilityByName('dark_seer_wall_of_replica')

    bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    VacuumWallDesire, VacuumwallLocation = X.ConsiderVacuumWall()
    if VacuumWallDesire > 0 then
        bot:Action_ClearActions(true)

        if J.CanBlackKingBar(bot) and ((Vacuum:GetManaCost() + WallOfReplica:GetManaCost() + bot.BlackKingBar:GetManaCost() + 75) < bot:GetMana()) then
            bot:ActionQueue_UseAbility(bot.BlackKingBar)
            bot:ActionQueue_Delay(0.1)
        end

        bot:ActionQueue_UseAbilityOnLocation(bot.Blink, VacuumwallLocation)
        bot:ActionQueue_Delay(0.1)
        bot:ActionQueue_UseAbilityOnLocation(Vacuum, VacuumwallLocation)
        bot:ActionQueue_UseAbilityOnLocation(WallOfReplica, VacuumwallLocation)
        return
    end

    VacuumDesire, VacuumLocation = X.ConsiderVacuum()
    if VacuumDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(Vacuum, VacuumLocation)
        return
    end

    WallOfReplicaDesire, WallOfReplicaLocation = X.ConsiderWallOfReplica()
    if WallOfReplicaDesire > 0 then
        J.SetQueuePtToINT(bot, false)

        if J.CanCastAbility(Vacuum) and bot:GetMana() > Vacuum:GetManaCost() + WallOfReplica:GetManaCost() + 50 then
            bot:ActionQueue_UseAbilityOnLocation(Vacuum, WallOfReplicaLocation)
            bot:ActionQueue_UseAbilityOnLocation(WallOfReplica, WallOfReplicaLocation)
            return
        else
            bot:ActionQueue_UseAbilityOnLocation(WallOfReplica, WallOfReplicaLocation)
            return
        end
    end

    SurgeDesire, SurgeTarget = X.ConsiderSurge()
    if SurgeDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(Surge, SurgeTarget)
        return
    end

    IonShellDesire, IonShellTarget = X.ConsiderIonShell()
    if IonShellDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(IonShell, IonShellTarget)
        return
    end
end

function X.ConsiderVacuum()
    if not J.CanCastAbility(Vacuum) then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nCastRange = J.GetProperCastRange(false, bot, Vacuum:GetCastRange())
    local nCastPoint = Vacuum:GetCastPoint()
    local nRadius = Vacuum:GetSpecialValueInt('radius')
    local nDamage = Vacuum:GetSpecialValueInt('damage')

    if not J.IsRetreating(bot) and not J.IsGoingOnSomeone(bot) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange + nRadius)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
            and not J.IsSuspiciousIllusion(enemyHero)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
            and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
            then
                if not J.IsInRange(bot, enemyHero, nCastRange) then
                    return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(bot:GetLocation(), enemyHero:GetLocation(), nCastRange)
                else
                    return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
                end
            end
        end
    end

	if J.IsInTeamFight(bot, 1200) and not J.CanCastAbilitySoon(WallOfReplica, 5.0) then
		local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
        local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)
		if #nInRangeEnemy >= 2 then
            local count = 0
            for _, enemyHero in pairs(nInRangeEnemy) do
                if J.IsValidHero(enemyHero)
                and J.CanBeAttacked(enemyHero)
                and J.CanCastOnNonMagicImmune(enemyHero)
                and not J.IsChasingTarget(bot, enemyHero)
                then
                    count = count + 1
                end
            end

            if count >= 2 then
                return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
            end
		end
	end

	if J.IsGoingOnSomeone(bot) and not J.CanCastAbilitySoon(WallOfReplica, 5.0) then
		if  J.IsValidTarget(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not botTarget:HasModifier('modifier_enigma_black_hole_pull')
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not botTarget:HasModifier("modifier_legion_commander_duel")
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
            if J.IsChasingTarget(bot, botTarget) and not J.IsInRange(bot, botTarget, nCastRange / 2) then
                return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
            end
		end
	end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and not J.IsInTeamFight(bot, 1200) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and not J.IsInRange(bot, enemyHero, nCastRange - nRadius)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and not J.IsDisabled(enemyHero)
            and bot:WasRecentlyDamagedByHero(enemyHero, 3.0)
            then
                if J.IsChasingTarget(enemyHero, bot) or bot:IsRooted() then
                    return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderIonShell()
	if not J.CanCastAbility(IonShell) then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = J.GetProperCastRange(false, bot, IonShell:GetCastRange())
    local nRadius = IonShell:GetSpecialValueInt('radius')
    local nManaCost = IonShell:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Vacuum, Surge, WallOfReplica})
	local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {Vacuum, IonShell, Surge, WallOfReplica})

    if J.IsGoingOnSomeone(bot) then
        if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nRadius * 2)
		and J.CanCastOnNonMagicImmune(botTarget)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not bot:HasModifier('modifier_dark_seer_ion_shell')
		then
            return BOT_ACTION_DESIRE_HIGH, bot
		end

		local hTarget = nil
        local hTargetNearbys = 0
        for _, allyHero in pairs(nAllyHeroes) do
            if  J.IsValidHero(allyHero)
            and J.IsInRange(bot, allyHero, nCastRange)
            and J.IsGoingOnSomeone(allyHero)
            and not J.IsSuspiciousIllusion(allyHero)
            and not allyHero:HasModifier('modifier_dark_seer_ion_shell')
            and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            then
                local nAllyNearbys = 0
                local nInRangeEnemy = allyHero:GetNearbyHeroes(nRadius * 2, true, BOT_MODE_NONE)
                local nEnemyCreeps = allyHero:GetNearbyCreeps(nRadius, true)

                for _, enemyHero in pairs(nInRangeEnemy) do
                    if J.IsValidHero(enemyHero)
                    and J.CanBeAttacked(enemyHero)
                    and not J.IsSuspiciousIllusion(enemyHero)
                    then
                        nAllyNearbys = nAllyNearbys + 1
                    end
                end

                for _, creep in pairs(nEnemyCreeps) do
                    if J.IsValid(creep)
                    and J.CanBeAttacked(creep)
                    and creep:GetAttackTarget() == allyHero
                    then
                        nAllyNearbys = nAllyNearbys + 1
                    end
                end

                if nAllyNearbys > hTargetNearbys then
                    hTarget = allyHero
                    hTargetNearbys = nAllyNearbys
                end
            end
        end

        if hTarget then
            return BOT_ACTION_DESIRE_HIGH, hTarget
        end
	end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and not bot:HasModifier('modifier_dark_seer_ion_shell') then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nRadius * 1.5)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and not J.IsDisabled(enemyHero)
            and bot:WasRecentlyDamagedByHero(enemyHero, 3.0)
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero
            end
        end
	end

    if not bot:HasModifier('modifier_dark_seer_ion_shell') then
        local nEnemyCreeps = bot:GetNearbyCreeps(nRadius * 2, true)

        if J.IsPushing(bot) and bAttacking and fManaAfter > fManaThreshold1 and #nAllyHeroes <= 3 then
            if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
                if #nEnemyCreeps >= 3 then
                    return BOT_ACTION_DESIRE_HIGH, bot
                end
            end
        end

        if J.IsDefending(bot) and bAttacking and fManaAfter > fManaThreshold1 then
            if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
                if (#nEnemyCreeps >= 3)
                or (#nEnemyCreeps >= 2 and string.find(nEnemyCreeps[1]:GetUnitName(), 'upgraded'))
                then
                    return BOT_ACTION_DESIRE_HIGH, bot
                end
            end
        end

        if J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold1 then
            if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
                if (#nEnemyCreeps >= 2)
                or (#nEnemyCreeps >= 1 and nEnemyCreeps[1]:IsAncientCreep())
                then
                    return BOT_ACTION_DESIRE_HIGH, bot
                end
            end
        end

        if J.IsLaning(bot) and J.IsInLaningPhase() and fManaAfter > fManaThreshold1 then
            local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(nRadius * 2, true)
            local nEnemyTowers = bot:GetNearbyTowers(1000, true)

            if  J.IsValid(nEnemyLaneCreeps[1])
            and J.CanBeAttacked(nEnemyLaneCreeps[1])
            and #nEnemyLaneCreeps >= 3
            and #nEnemyHeroes == 0
            and #nEnemyTowers == 0
            and bAttacking
            then
                return BOT_ACTION_DESIRE_HIGH, bot
            end
        end

        if J.IsDoingRoshan(bot) then
            if J.IsRoshan(botTarget)
            and J.CanBeAttacked(botTarget)
            and J.IsInRange(bot, botTarget, nRadius * 2)
            and bAttacking
            and fManaAfter > fManaThreshold1
            then
                return BOT_ACTION_DESIRE_HIGH, bot
            end
        end

        if J.IsDoingTormentor(bot) then
            if J.IsTormentor(botTarget)
            and J.IsInRange(bot, botTarget, nRadius * 2)
            and bAttacking
            and fManaAfter > fManaThreshold1
            then
                return BOT_ACTION_DESIRE_HIGH, bot
            end
        end
    end

    if #nEnemyHeroes == 0 and not J.IsRealInvisible(bot) and fManaAfter > fManaThreshold2 then
        for _, allyHero in pairs(nAllyHeroes) do
            if  J.IsValidHero(allyHero)
            and bot ~= allyHero
            and J.IsInRange(bot, allyHero, nCastRange)
            then
                if not allyHero:HasModifier('modifier_dark_seer_ion_shell') then
                    local nEnemyCreeps = allyHero:GetNearbyCreeps(800, true)
                    if J.IsPushing(allyHero) or J.IsDefending(allyHero) then
                        if #nEnemyCreeps > 0 then
                            return BOT_ACTION_DESIRE_HIGH, allyHero
                        end
                    end

                    if J.IsFarming(allyHero) then
                        return BOT_ACTION_DESIRE_HIGH, allyHero
                    end
                end
            end
        end

        if not J.IsInLaningPhase() then
            local hTargetCreep = nil
            local hTargetCreepDistance = 0

            local nAllyLaneCreeps = bot:GetNearbyLaneCreeps(nCastRange, false)
            for _, creep in pairs(nAllyLaneCreeps) do
                if  J.IsValid(creep)
                and J.GetHP(creep) > 0.75
                and creep:DistanceFromFountain() > hTargetCreepDistance
                and creep:GetAttackRange() <= 326
                and not creep:HasModifier('modifier_dark_seer_ion_shell')
                then
                    hTargetCreep = creep
                    hTargetCreepDistance = creep:DistanceFromFountain()
                end
            end

            if hTargetCreep then
                return BOT_ACTION_DESIRE_HIGH, hTargetCreep
            end
        end
    end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderSurge()
	if not J.CanCastAbility(Surge) then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = J.GetProperCastRange(false, bot, Surge:GetCastRange())
    local nManaCost = Surge:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Vacuum, IonShell, WallOfReplica})
	local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {Vacuum, IonShell, Surge, WallOfReplica})

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
        and J.IsInRange(bot, botTarget, 1200)
        and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			local hTargetAlly = bot
            local hTargetAllyScore = bot:GetEstimatedDamageToTarget(false, botTarget, 5.0, DAMAGE_TYPE_ALL)

			for _, allyHero in pairs(nAllyHeroes) do
                if J.IsValidHero(allyHero)
                and J.IsInRange(bot, allyHero, nCastRange)
                and J.IsRunning(allyHero)
                and J.GetProperTarget(allyHero) == botTarget
                and J.IsGoingOnSomeone(allyHero)
                and not J.IsSuspiciousIllusion(allyHero)
                and not allyHero:HasModifier('modifier_dark_seer_surge')
                then
                    local allyHeroScore = allyHero:GetEstimatedDamageToTarget(false, botTarget, 5.0, DAMAGE_TYPE_ALL)
                    if allyHeroScore > hTargetAllyScore then
                        hTargetAlly = allyHero
                        hTargetAllyScore = allyHeroScore
                    end
                end

                if hTargetAlly then
                    return BOT_ACTION_DESIRE_HIGH, bot
                end
			end
		end
	end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.IsInRange(bot, enemyHero, 1200)
            then
                if (J.IsChasingTarget(enemyHero, bot))
                or (bot:WasRecentlyDamagedByAnyHero(1.0) and botHP < 0.5)
                then
                    return BOT_ACTION_DESIRE_HIGH, bot
                end
            end
        end

        if botHP < 0.4 and bot:IsFacingLocation(J.GetTeamFountain(), 30) and J.IsRunning(bot) then
            return BOT_ACTION_DESIRE_HIGH, bot
        end
	end

    if not J.IsRetreating(bot) and not J.IsRealInvisible(bot) and fManaAfter > fManaThreshold1 then
        for _, allyHero in pairs(nAllyHeroes) do
            if  J.IsValidHero(allyHero)
            and bot ~= allyHero
            and J.IsInRange(bot, allyHero, nCastRange)
            and J.IsRetreating(allyHero)
            and not J.IsSuspiciousIllusion(allyHero)
            and not allyHero:HasModifier('modifier_dark_seer_surge')
            then
                for _, enemyHero in pairs(nEnemyHeroes) do
                    if  J.IsValidHero(enemyHero)
                    and not J.IsSuspiciousIllusion(enemyHero)
                    and allyHero:WasRecentlyDamagedByHero(enemyHero, 2.0)
                    then
                        if J.IsChasingTarget(enemyHero, allyHero) then
                            return BOT_ACTION_DESIRE_HIGH, allyHero
                        end
                    end
                end
            end
        end

        if not J.IsInLaningPhase() then
            local nEnemyCreeps = bot:GetNearbyCreeps(Min(nCastRange + 300, 1600), false)
            for _, creep in pairs(nEnemyCreeps) do
                if  J.IsValid(creep)
                and J.GetHP(creep) > 0.5
                and J.IsRunning(creep)
                and not creep:HasModifier('modifier_dark_seer_surge')
                then
                    local sCreepName = creep:GetUnitName()
                    if string.find(sCreepName, 'warlock_golem')
                    or string.find(sCreepName, 'siege_upgraded')
                    or creep:IsDominated()
                    then
                        return BOT_ACTION_DESIRE_HIGH, creep
                    end
                end
            end
        end
    end

    if J.IsPushing(bot) and not bAttacking and fManaAfter > fManaThreshold2 + 0.1 then
		local nLane = LANE_MID
		if bot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP then nLane = LANE_TOP end
		if bot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT then nLane = LANE_BOT end

		local vLaneFrontLocation = GetLaneFrontLocation(GetTeam(), nLane, 0)
		if GetUnitToLocationDistance(bot, vLaneFrontLocation) > 3200 then
            return BOT_ACTION_DESIRE_HIGH, bot
		end
    end

    if J.IsDefending(bot) and not bAttacking and fManaAfter > fManaThreshold2 + 0.1 then
		local nLane = LANE_MID
		if bot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP then nLane = LANE_TOP end
		if bot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT then nLane = LANE_BOT end

		local vLaneFrontLocation = GetLaneFrontLocation(GetTeam(), nLane, 0)
		if GetUnitToLocationDistance(bot, vLaneFrontLocation) > 3200 then
            return BOT_ACTION_DESIRE_HIGH, bot
		end
    end

    if J.IsFarming(bot) and not bAttacking and fManaAfter > fManaThreshold2 + 0.1 and #nEnemyHeroes == 0 then
		if bot.farm and bot.farm.location then
			local distance = GetUnitToLocationDistance(bot, bot.farm.location)
			if J.IsRunning(bot) and distance > 1600 then
				return BOT_ACTION_DESIRE_HIGH, bot
			end
		end
    end

    if J.IsDoingRoshan(bot) then
        local vRoshanLocation = J.GetCurrentRoshanLocation()
        if  GetUnitToLocationDistance(bot, vRoshanLocation) > 2000
        and not bot:HasModifier('modifier_dark_seer_surge')
        and fManaAfter > fManaThreshold1
        then
            return BOT_ACTION_DESIRE_HIGH, bot
        end
	end

    if J.IsDoingTormentor(bot) then
        local vTormentorLocation = J.GetTormentorLocation(GetTeam())
        if  GetUnitToLocationDistance(bot, vTormentorLocation) > 2000
        and not bot:HasModifier('modifier_dark_seer_surge')
        and fManaAfter > fManaThreshold1
        then
            return BOT_ACTION_DESIRE_HIGH, bot
        end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderWallOfReplica()
	if not J.CanCastAbility(WallOfReplica) then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastRange = J.GetProperCastRange(false, bot, WallOfReplica:GetCastRange())
	local nCastPoint = WallOfReplica:GetCastPoint() + 0.73
    local nWidth = WallOfReplica:GetSpecialValueInt('width')
    local nRadius = 350

    if Vacuum and Vacuum:IsTrained() then nRadius = Vacuum:GetSpecialValueInt('radius') end

	if J.IsInTeamFight(bot, 1200) then
        local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
        local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)

        if #nInRangeEnemy >= 2 then
            return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
        end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderVacuumWall()
    if J.CanCastAbility(Vacuum) and J.CanCastAbility(WallOfReplica) and J.CanBlinkDagger(bot) then
        local nManaCost = Vacuum:GetManaCost() + WallOfReplica:GetManaCost() + 75
        if bot:GetMana() < nManaCost then return BOT_ACTION_DESIRE_NONE end

        local nVacuumCastRange = J.GetProperCastRange(false, bot, Vacuum:GetCastRange())
        local nVacuumRadius = Vacuum:GetSpecialValueInt('radius')

        if J.IsInTeamFight(bot, 1200) then
            local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), bot.Blink:GetCastRange(), nVacuumRadius, 0, 0)
            local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nVacuumRadius)
            if #nInRangeEnemy >= 2 then
                return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

return X