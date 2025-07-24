local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_abyssal_underlord'
then

local RI = require(GetScriptDirectory()..'/FunLib/util_role_item')

local sUtility = {"item_pipe", "item_lotus_orb", "item_heavens_halberd"}
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
					['t25'] = {0, 10},
					['t20'] = {0, 10},
					['t15'] = {0, 10},
					['t10'] = {10, 0},
				},
            },
            ['ability'] = {
                [1] = {1,3,1,3,1,2,1,6,2,2,2,6,3,3,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_quelling_blade",
				"item_double_gauntlets",
	
				"item_magic_wand",
				"item_arcane_boots",
				"item_soul_ring",
                "item_rod_of_atos",
				"item_crimson_guard",--
				"item_ultimate_scepter",
				sUtilityItem,--
				"item_aghanims_shard",
				"item_shivas_guard",--
				"item_octarine_core",--
				"item_ultimate_scepter_2",
				"item_moon_shard",
				"item_harpoon",--
                "item_gungir",--
			},
            ['sell_list'] = {
				"item_quelling_blade", "item_ultimate_scepter",
				"item_magic_wand", sUtilityItem,
				"item_soul_ring", "item_shivas_guard",
                "item_arcane_boots", "item_gungir",
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

local Firestorm     = bot:GetAbilityByName('abyssal_underlord_firestorm')
local PitOfMalice   = bot:GetAbilityByName('abyssal_underlord_pit_of_malice')
-- local AtrophyAura   = bot:GetAbilityByName('abyssal_underlord_atrophy_aura')
local FiendsGate    = bot:GetAbilityByName('abyssal_underlord_dark_portal')

local FirestormDesire, FirestormLocation
local PitOfMaliceDesire, PitOfMaliceLocation
local FiendsGateDesire, FiendsGateLocation

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
    bot = GetBot()

	if J.CanNotUseAbility(bot) then return end

    Firestorm   = bot:GetAbilityByName('abyssal_underlord_firestorm')
    PitOfMalice = bot:GetAbilityByName('abyssal_underlord_pit_of_malice')
    FiendsGate  = bot:GetAbilityByName('abyssal_underlord_dark_portal')

    bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    PitOfMaliceDesire, PitOfMaliceLocation = X.ConsiderPitOfMalice()
    if PitOfMaliceDesire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(PitOfMalice, PitOfMaliceLocation)
        return
    end

    FirestormDesire, FirestormLocation = X.ConsiderFirestorm()
    if FirestormDesire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(Firestorm, FirestormLocation)
        return
    end

    FiendsGateDesire, FiendsGateLocation = X.ConsiderFiendsGate()
    if FiendsGateDesire > 0
    then
        bot:Action_UseAbilityOnLocation(FiendsGate, FiendsGateLocation)
        return
    end
end

function X.ConsiderFirestorm()
    if not J.CanCastAbility(Firestorm) then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nCastRange = J.GetProperCastRange(false, bot, Firestorm:GetCastRange())
    local nCastPoint = Firestorm:GetCastPoint()
    local nRadius = Firestorm:GetSpecialValueInt('radius')
    local nManaCost = Firestorm:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Firestorm, PitOfMalice})

    if J.IsInTeamFight(bot, 1200) then
        local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
        local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)
        if #nInRangeEnemy >= 2 then
            local count = 0
            for _, enemyHero in pairs(nEnemyHeroes) do
                if J.IsValidHero(enemyHero)
                and J.CanBeAttacked(enemyHero)
                and J.CanCastOnNonMagicImmune(enemyHero)
                then
                    count = count + 1
                end
            end

            if count >= 1.5 then
                return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
            end
        end
    end

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange + nRadius)
        and J.CanCastOnNonMagicImmune(botTarget)
        and not J.IsChasingTarget(bot, botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
		then
            local vLocation = (J.IsInRange(bot, botTarget, nCastRange) and botTarget:GetLocation()) or (J.VectorTowards(bot:GetLocation(), botTarget:GetLocation(), nCastRange))
            return BOT_ACTION_DESIRE_HIGH, vLocation
		end
	end

    local nEnemyCreeps = bot:GetNearbyCreeps(nCastRange, true)

    if J.IsPushing(bot) and #nAllyHeroes <= 3 and bAttacking and fManaAfter > fManaThreshold1 and #nEnemyHeroes == 0 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 4) then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

    if J.IsDefending(bot) and #nAllyHeroes <= 2 and bAttacking and fManaAfter > fManaThreshold1 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 4) then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

    if J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold1 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 3)
                or (nLocationAoE.count >= 2 and creep:IsAncientCreep())
                or (nLocationAoE.count >= 1 and creep:IsAncientCreep() and creep:GetHealth() >= 1000 and fManaAfter > 0.75)
                then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

    if  J.IsLaning(bot) and J.IsInLaningPhase()
    and fManaAfter > fManaThreshold1
    and bAttacking
    and #nAllyHeroes <= 2
    and #nEnemyHeroes == 0
	then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 4) then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
	end

    if J.IsDoingRoshan(bot) then
        if  J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastPoint)
        and bAttacking
        and fManaAfter > fManaThreshold1
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
    end

    if J.IsDoingTormentor(bot) then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nCastPoint)
        and bAttacking
        and fManaAfter > fManaThreshold1
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderPitOfMalice()
    if not J.CanCastAbility(PitOfMalice) then
        return BOT_ACTION_DESIRE_NONE, 0
    end

	local nCastRange = J.GetProperCastRange(false, bot, PitOfMalice:GetCastRange())
    local nCastPoint = PitOfMalice:GetCastPoint()
	local nRadius = PitOfMalice:GetSpecialValueInt('radius')
    local nManaCost = Firestorm:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Firestorm, PitOfMalice})
    local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {Firestorm})

    for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange + nRadius)
        and J.CanCastOnNonMagicImmune(enemyHero)
        then
            local vLocation = (J.IsInRange(bot, enemyHero, nCastRange) and enemyHero:GetLocation()) or (J.VectorTowards(bot:GetLocation(), enemyHero:GetLocation(), nCastRange))
            if enemyHero:HasModifier('modifier_teleporting') then
                local eta = (GetUnitToUnitDistance(bot, enemyHero) / bot:GetCurrentMovementSpeed()) + nCastPoint
                if eta < J.GetModifierTime(enemyHero, 'modifier_teleporting') then
                    return BOT_ACTION_DESIRE_HIGH, vLocation
                end
            elseif enemyHero:IsChanneling() and fManaAfter > fManaThreshold2 then
                local nAllyHeroesAttackingTarget = J.GetHeroesTargetingUnit(nAllyHeroes, enemyHero)
                if #nAllyHeroesAttackingTarget >= 2 then
                    return BOT_ACTION_DESIRE_HIGH, vLocation
                end
            end
        end
    end

    if J.IsInTeamFight(bot, 1200) then
        local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
        local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)
        if #nInRangeEnemy >= 2 then
            local count = 0
            for _, enemyHero in pairs(nEnemyHeroes) do
                if J.IsValidHero(enemyHero)
                and J.CanBeAttacked(enemyHero)
                and J.CanCastOnNonMagicImmune(enemyHero)
                and not enemyHero:IsStunned()
                and not enemyHero:IsRooted()
                and not enemyHero:IsHexed()
                and not enemyHero:IsNightmared()
                then
                    count = count + 1
                end
            end

            if count >= 2 then
                return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
            end
        end
    end

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange + nRadius)
        and not botTarget:IsStunned()
        and not botTarget:IsRooted()
        and not botTarget:IsHexed()
        and not botTarget:IsNightmared()
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
            local vLocation = (J.IsInRange(bot, botTarget, nCastRange) and botTarget:GetLocation()) or (J.VectorTowards(bot:GetLocation(), botTarget:GetLocation(), nCastRange))
            return BOT_ACTION_DESIRE_HIGH, vLocation
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(4.0) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange + nRadius)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and not enemyHero:IsDisarmed()
            then
                if (J.IsChasingTarget(enemyHero, bot) and botHP < 0.65)
                or (#nEnemyHeroes > #nAllyHeroes and enemyHero:GetAttackTarget() == bot)
                then
                    local vHalfLocation = (bot:GetLocation() + enemyHero:GetLocation()) / 2
                    local vLocation = (J.IsInRange(bot, enemyHero, nCastRange) and vHalfLocation) or (J.VectorTowards(bot:GetLocation(), enemyHero:GetLocation(), nCastRange))
                    return BOT_ACTION_DESIRE_HIGH, vLocation
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderFiendsGate()
    if not J.CanCastAbility(FiendsGate) then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local vTeamFightLocation = J.GetTeamFightLocation(bot)
    local botMovementSpeed = bot:GetCurrentMovementSpeed()

    if  vTeamFightLocation ~= nil
    and (GetUnitToLocationDistance(bot, vTeamFightLocation) / botMovementSpeed) > 5.0
    and J.GetDistance(vTeamFightLocation, J.GetEnemyFountain()) > 800
    and not J.IsGoingOnSomeone(bot)
    and not J.IsRetreating(bot)
    and not J.IsInLaningPhase()
    then
        local nInRangeAlly = J.GetAlliesNearLoc(vTeamFightLocation, 1200)
        local nInRangeEnemy = J.GetEnemiesNearLoc(vTeamFightLocation, 1200)

        if #nInRangeAlly + 1 >= #nInRangeEnemy and #nInRangeEnemy >= 2 then
            local vTargetLocation = J.GetCenterOfUnits(nInRangeAlly)

            if  IsLocationPassable(vTargetLocation)
            and not J.IsLocationInChrono(vTargetLocation)
            and not J.IsLocationInBlackHole(vTargetLocation)
            then
                return BOT_ACTION_DESIRE_HIGH, vTargetLocation
            end
        end
    end

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
        and J.CanBeAttacked(botTarget)
        and not J.IsSuspiciousIllusion(botTarget)
        and not J.IsInLaningPhase()
        and (GetUnitToUnitDistance(bot, botTarget) / botMovementSpeed) > 5.0
		then
			local nInRangeAlly = J.GetAlliesNearLoc(botTarget:GetLocation(), 1200)
            local nInRangeEnemy = J.GetEnemiesNearLoc(botTarget:GetLocation(), 1200)
            local nEnemyTowers = bot:GetNearbyTowers(900, true)

			if  (#nInRangeAlly >= 1 and #nInRangeAlly + 1 >= #nInRangeEnemy)
            and (#nEnemyHeroes <= 1 and #nEnemyTowers == 0)
            then
                local vTargetLocation = J.GetCenterOfUnits(nInRangeAlly)

                if  IsLocationPassable(vTargetLocation)
                and not J.IsLocationInChrono(vTargetLocation)
                and not J.IsLocationInBlackHole(vTargetLocation)
                then
                    return BOT_ACTION_DESIRE_HIGH, vTargetLocation
                end
            end
		end
	end

    local tAverageDistance = {0, 0, 0}
    local tPushCount = {0, 0, 0}

    local vLaneFrontLocationTop = GetLaneFrontLocation(GetTeam(), LANE_TOP, 0)
    local vLaneFrontLocationMid = GetLaneFrontLocation(GetTeam(), LANE_MID, 0)
    local vLaneFrontLocationBot = GetLaneFrontLocation(GetTeam(), LANE_BOT, 0)

    local botActiveMode = bot:GetActiveMode()

    for _, allyHero in pairs(GetUnitList(UNIT_LIST_ALLIED_HEROES)) do
        if  J.IsValidHero(allyHero)
        and bot ~= allyHero
        and J.IsGoingOnSomeone(allyHero)
        and (GetUnitToUnitDistance(bot, allyHero) / botMovementSpeed) > 5.0
        and not J.IsSuspiciousIllusion(allyHero)
        and not J.IsMeepoClone(allyHero)
        and not J.IsInLaningPhase()
        and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        then
            local allyTarget = allyHero:GetAttackTarget()
            local nInRangeAlly = J.GetAlliesNearLoc(allyHero:GetLocation(), 800)

            if  J.IsValidTarget(allyTarget)
            and J.IsInRange(allyHero, allyTarget, 800)
            and J.GetHP(allyHero) > 0.5
            and J.IsCore(allyTarget)
            and GetUnitToLocationDistance(allyTarget, J.GetEnemyFountain()) > 1200
            and not J.IsSuspiciousIllusion(allyTarget)
            and not allyTarget:HasModifier('modifier_necrolyte_reapers_scythe')
            then
                local nInRangeEnemy = allyTarget:GetNearbyHeroes(800, false, BOT_MODE_NONE)
                local nEnemyTowers = bot:GetNearbyTowers(900, true)

                if  (#nInRangeAlly + 1 >= #nInRangeEnemy)
                and (#nInRangeEnemy >= 2)
                and (#nInRangeEnemy == 0 and #nEnemyTowers == 0)
                then
                    local vTargetLocation = allyHero:GetLocation()

                    if  IsLocationPassable(vTargetLocation)
                    and not J.IsLocationInChrono(vTargetLocation)
                    and not J.IsLocationInBlackHole(vTargetLocation)
                    then
                        return BOT_ACTION_DESIRE_HIGH, vTargetLocation
                    end
                end
            end
        end

        if  J.IsValidHero(allyHero)
        and bot ~= allyHero
        and not J.IsSuspiciousIllusion(allyHero)
        and not J.IsMeepoClone(allyHero)
        and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        then
            if allyHero:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP and botActiveMode == BOT_MODE_PUSH_TOWER_TOP then
                tPushCount[1] = tPushCount[1] + 1
                tAverageDistance[1] = tAverageDistance[1] + GetUnitToLocationDistance(allyHero, vLaneFrontLocationTop)
            end

            if allyHero:GetActiveMode() == BOT_MODE_PUSH_TOWER_MID and botActiveMode == BOT_MODE_PUSH_TOWER_MID then
                tPushCount[2] = tPushCount[2] + 1
                tAverageDistance[2] = tAverageDistance[2] + GetUnitToLocationDistance(allyHero, vLaneFrontLocationMid)
            end

            if allyHero:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT and botActiveMode == BOT_MODE_PUSH_TOWER_BOT then
                tPushCount[3] = tPushCount[3] + 1
                tAverageDistance[3] = tAverageDistance[3] + GetUnitToLocationDistance(allyHero, vLaneFrontLocationBot)
            end
        end
    end

    if tPushCount[1] ~= nil and tPushCount[1] >= 3 and (tAverageDistance[1] / tPushCount[1]) <= 1200 then
        if (GetUnitToLocationDistance(bot, vLaneFrontLocationTop) / botMovementSpeed) > 8.0 then
            return BOT_ACTION_DESIRE_HIGH, vLaneFrontLocationTop
        end
    end

    if tPushCount[2] ~= nil and tPushCount[2] >= 3 and (tAverageDistance[2] / tPushCount[2]) <= 1200 then
        if (GetUnitToLocationDistance(bot, vLaneFrontLocationMid) / botMovementSpeed) > 8.0 then
            return BOT_ACTION_DESIRE_HIGH, vLaneFrontLocationMid
        end
    end

    if tPushCount[3] ~= nil and tPushCount[3] >= 3 and (tAverageDistance[3] / tPushCount[3]) <= 1200 then
        if (GetUnitToLocationDistance(bot, vLaneFrontLocationBot) / botMovementSpeed) > 8.0 then
            return BOT_ACTION_DESIRE_HIGH, vLaneFrontLocationBot
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

return X