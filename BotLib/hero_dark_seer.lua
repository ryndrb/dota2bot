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

local sUtility = {}
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
					['t15'] = {0, 10},
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
                [1] = {2,3,2,1,2,6,2,3,3,3,1,6,1,1,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_magic_stick",
				"item_quelling_blade",
				"item_enchanted_mango",
			
				"item_magic_wand",
				"item_arcane_boots",
				"item_veil_of_discord",
				"item_guardian_greaves",--
				"item_blink",
				sUtilityItem,--
				"item_ultimate_scepter",
				"item_black_king_bar",--
				"item_shivas_guard",--
				"item_sheepstick",--
				"item_arcane_blink",--
				"item_ultimate_scepter_2",
				"item_aghanims_shard",
				"item_moon_shard",
			},
            ['sell_list'] = {
				"item_quelling_blade",
				"item_magic_wand",
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

local botTarget

if bot.shouldBlink == nil then bot.shouldBlink = false end

function X.SkillsComplement()
	if J.CanNotUseAbility(bot) then return end

    Vacuum            = bot:GetAbilityByName('dark_seer_vacuum')
    IonShell          = bot:GetAbilityByName('dark_seer_ion_shell')
    Surge             = bot:GetAbilityByName('dark_seer_surge')
    WallOfReplica     = bot:GetAbilityByName('dark_seer_wall_of_replica')

    botTarget = J.GetProperTarget(bot)

    VacuumWallDesire, VacuumwallLocation = X.ConsiderVacuumWall()
    if VacuumWallDesire > 0
    then
        bot:Action_ClearActions(false)
        bot:ActionQueue_UseAbilityOnLocation(bot.Blink, VacuumwallLocation)
        bot:ActionQueue_Delay(0.1)
        bot:ActionQueue_UseAbilityOnLocation(Vacuum, VacuumwallLocation)
        bot:ActionQueue_Delay(0.8)
        bot:ActionQueue_UseAbilityOnLocation(WallOfReplica, VacuumwallLocation)
        bot:ActionQueue_Delay(0.93)
        return
    end

    VacuumDesire, VacuumLocation = X.ConsiderVacuum()
    if VacuumDesire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(Vacuum, VacuumLocation)
        return
    end

    WallOfReplicaDesire, WallOfReplicaLocation = X.ConsiderWallOfReplica()
    if WallOfReplicaDesire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(WallOfReplica, WallOfReplicaLocation)
        return
    end

    SurgeDesire, SurgeTarget = X.ConsiderSurge()
    if SurgeDesire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(Surge, SurgeTarget)
        return
    end

    IonShellDesire, IonShellTarget = X.ConsiderIonShell()
    if IonShellDesire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(IonShell, IonShellTarget)
        return
    end
end

function X.ConsiderVacuum()
    if not J.CanCastAbility(Vacuum)
    then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nCastRange = J.GetProperCastRange(false, bot, Vacuum:GetCastRange())
    local nCastPoint = Vacuum:GetCastPoint()
    local nRadius = Vacuum:GetSpecialValueInt('radius')
    local nDamage = Vacuum:GetSpecialValueInt('damage')

    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    for _, enemyHero in pairs(nEnemyHeroes)
    do
        if  J.IsValidHero(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange + nRadius)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
        and not J.IsInTeamFight(bot, 1200)
        and not J.IsSuspiciousIllusion(enemyHero)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
        and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
        then
            if J.IsChasingTarget(bot, enemyHero)
            then
                if not J.IsInRange(bot, enemyHero, nCastRange)
                then
                    return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, enemyHero:GetLocation(), nCastRange)
                else
                    return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
                end
            end
        end
    end

	if J.IsInTeamFight(bot, 1200)
	then
		local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, nCastPoint, 0)
        local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)

		if nInRangeEnemy ~= nil and #nInRangeEnemy >= 2
		then
			return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nInRangeEnemy)
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange + nRadius)
        and not botTarget:HasModifier('modifier_enigma_black_hole_pull')
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not botTarget:HasModifier("modifier_legion_commander_duel")
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
            local nInRangeEnemy = J.GetEnemiesNearLoc(botTarget:GetLocation(), nRadius)
            if #nInRangeEnemy >= 2
            then
                if not J.IsInRange(bot, botTarget, nCastRange)
                then
                    return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, J.GetCenterOfUnits(nInRangeEnemy), nCastRange)
                else
                    return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nInRangeEnemy)
                end
            else
                if not J.IsInRange(bot, botTarget, nCastRange)
                then
                    return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, botTarget:GetLocation(), nCastRange)
                else
                    return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
                end
            end
		end
	end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderIonShell()
	if not J.CanCastAbility(IonShell)
    then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = J.GetProperCastRange(false, bot, IonShell:GetCastRange())
    local nRadius = IonShell:GetSpecialValueInt('radius')
    local nAbilityLevel = IonShell:GetLevel()

    local nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
    local nAllyLaneCreeps = bot:GetNearbyLaneCreeps(1600, false)
    local nEnemyTowers = bot:GetNearbyTowers(700, true)

    if J.IsGoingOnSomeone(bot)
	then
		local target = nil
		local maxTargetCount = 1

        if nAllyHeroes ~= nil and #nAllyHeroes >= 1
        then
            for _, allyHero in pairs(nAllyHeroes)
            do
                if  J.IsValidHero(allyHero)
                and J.IsInRange(bot, allyHero, nCastRange)
                and not allyHero:IsIllusion()
                and not allyHero:HasModifier('modifier_dark_seer_ion_shell')
                and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
                then
                    local nAllyCount = 0
                    local nAllyEnemyHeroes = allyHero:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
                    local nAllyEnemyCreeps = allyHero:GetNearbyCreeps(1200, true)

                    for _, allyEnemyHero in pairs(nAllyEnemyHeroes)
                    do
                        if J.IsValidHero(allyEnemyHero)
                        and allyEnemyHero:GetAttackTarget() == allyHero
                        and not J.IsSuspiciousIllusion(allyEnemyHero)
                        and allyHero:GetAttackRange() <= 326
                        then
                            nAllyCount = nAllyCount + 1
                        end
                    end

                    for _, creep in pairs(nAllyEnemyCreeps)
                    do
                        if J.IsValid(creep)
                        and creep:GetAttackTarget() == allyHero
                        and creep:GetAttackRange() <= 326
                        then
                            nAllyCount = nAllyCount + 1
                        end
                    end

                    if nAllyCount > maxTargetCount
                    then
                        maxTargetCount = nAllyCount
                        target = allyHero
                    end
                end
            end
        else
            if  J.IsValidTarget(botTarget)
            and J.IsInRange(bot, botTarget, nRadius)
            and not J.IsSuspiciousIllusion(botTarget)
            and not bot:HasModifier('modifier_dark_seer_ion_shell')
            then
                target = bot
            end
        end

        if target ~= nil
        then
            return BOT_ACTION_DESIRE_HIGH, target
        end
	end

    if  J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
    and bot:GetActiveModeDesire() > 0.75
    and bot:WasRecentlyDamagedByAnyHero(3.5)
	then
        if  J.IsValidHero(nEnemyHeroes[1])
        and J.CanCastOnNonMagicImmune(nEnemyHeroes[1])
        and J.IsChasingTarget(nEnemyHeroes[1], bot)
        and not bot:HasModifier('modifier_dark_seer_ion_shell')
        then
            return BOT_ACTION_DESIRE_HIGH, bot
        end
	end

	if J.IsPushing(bot) or J.IsDefending(bot)
	then
        if nEnemyHeroes ~= nil and #nEnemyHeroes == 0
        and nAllyLaneCreeps ~= nil and #nAllyLaneCreeps >= 1
        then
            local targetCreep = nil
            local targetDis = 0

            for _, creep in pairs(nAllyLaneCreeps)
            do
                if  J.IsValid(creep)
                and J.IsInRange(bot, creep, nCastRange)
                and J.GetHP(creep) > 0.75
                and creep:DistanceFromFountain() > targetDis
                and creep:GetAttackRange() <= 326
                and not creep:HasModifier('modifier_dark_seer_ion_shell')
                then
                    targetCreep = creep
                    targetDis = creep:DistanceFromFountain()
                end
            end

            if targetCreep ~= nil
            then
                return BOT_ACTION_DESIRE_HIGH, targetCreep
            end
        end
	end

    if J.IsFarming(bot)
    then
        local nCreeps = bot:GetNearbyCreeps(600, true)

        if  J.IsValid(botTarget)
        and botTarget:IsCreep()
        and nCreeps ~= nil and #nCreeps >= 2
        and not bot:HasModifier('modifier_dark_seer_ion_shell')
        then
            return BOT_ACTION_DESIRE_HIGH, bot
        end
    end

    if J.IsLaning(bot)
    then
        local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(nRadius, true)

        if  nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 3
        and J.CanBeAttacked(nEnemyLaneCreeps[1])
        and nEnemyHeroes ~= nil and #nEnemyHeroes == 0
        and nEnemyTowers ~= nil and #nEnemyTowers == 0
        and nAbilityLevel >= 2
        and J.IsAttacking(bot)
        and not bot:HasModifier('modifier_dark_seer_ion_shell')
        then
            return BOT_ACTION_DESIRE_HIGH, bot
        end
    end

    if J.IsDoingRoshan(bot) or J.IsDoingTormentor(bot)
	then
		if  (J.IsRoshan(botTarget) or J.IsTormentor(botTarget))
        and J.IsInRange(bot, botTarget, nRadius)
        and J.IsAttacking(bot)
        and not bot:HasModifier('modifier_dark_seer_ion_shell')
		then
			return BOT_ACTION_DESIRE_HIGH, bot
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderSurge()
	if not J.CanCastAbility(Surge)
    then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = J.GetProperCastRange(false, bot, Surge:GetCastRange())
    local nAbilityLevel = Surge:GetLevel()
    local RoshanLocation = J.GetCurrentRoshanLocation()
    local TormentorLocation = J.GetTormentorLocation(GetTeam())

    local nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
        and J.IsInRange(bot, botTarget, 1200)
        and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			local tToMeDist = GetUnitToUnitDistance(bot, botTarget)
			local targetHero = bot

			for _, allyHero in pairs(nAllyHeroes)
            do
                if J.IsValidHero(bot, allyHero, nCastRange + 150)
                then
                    local allyTarget = J.GetProperTarget(allyHero)
                    local dist = GetUnitToUnitDistance(allyHero, botTarget)

                    if  dist < tToMeDist
                    and dist < nCastRange
                    and J.IsValidTarget(allyTarget)
                    and not J.IsSuspiciousIllusion(allyTarget)
                    and not allyTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
                    and not allyTarget:HasModifier('modifier_necrolyte_reapers_scythe')
                    and allyHero:IsFacingLocation(allyTarget:GetLocation(), 30)
                    then
                        tToMeDist = dist
                        targetHero = allyHero
                    end
                end
			end

			return BOT_ACTION_DESIRE_HIGH, targetHero
		end
	end

    if  J.IsRetreating(bot)
    and bot:GetActiveModeDesire() > 0.75
    and not J.IsRealInvisible(bot)
	then
        if  J.IsValidHero(nEnemyHeroes[1])
        and (J.IsChasingTarget(nEnemyHeroes[1], bot) or bot:WasRecentlyDamagedByAnyHero(3))
        and J.IsInRange(bot, nEnemyHeroes[1], 600)
        and not bot:HasModifier('modifier_dark_seer_ion_shell')
        and not J.IsSuspiciousIllusion(nEnemyHeroes[1])
        then
            return BOT_ACTION_DESIRE_HIGH, bot
        end
	end

    if J.IsDoingRoshan(bot)
	then
        if  GetUnitToLocationDistance(bot, RoshanLocation) > 1600
        and J.GetManaAfter(Surge:GetManaCost()) > 0.5
        and J.GetManaAfter(Surge:GetManaCost()) > 0.5
        and nAbilityLevel >= 3
        then
            return BOT_ACTION_DESIRE_HIGH, bot
        end
	end

    if J.IsDoingTormentor(bot)
	then
        if  GetUnitToLocationDistance(bot, TormentorLocation) > 1600
        and J.GetManaAfter(Surge:GetManaCost()) > 0.5
        and J.GetManaAfter(Surge:GetManaCost()) > 0.5
        and nAbilityLevel >= 2
        then
            return BOT_ACTION_DESIRE_HIGH, bot
        end
	end

    for _, allyHero in pairs(nAllyHeroes)
    do
        if  J.IsValidHero(allyHero)
        and J.IsInRange(bot, allyHero, nCastRange)
        and J.IsRetreating(allyHero)
        and allyHero:WasRecentlyDamagedByAnyHero(4)
        and not allyHero:IsIllusion()
        then
            local nAllyInRangeEnemy = allyHero:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

            if J.IsValidHero(nAllyInRangeEnemy[1])
            and J.IsChasingTarget(nAllyInRangeEnemy[1], allyHero)
            and (allyHero:GetCurrentMovementSpeed() < nAllyInRangeEnemy[1]:GetCurrentMovementSpeed() or J.IsDisabled(allyHero))
            and allyHero:IsFacingLocation(J.GetTeamFountain(), 30)
            and not J.IsDisabled(nAllyInRangeEnemy[1])
            and not J.IsSuspiciousIllusion(nAllyInRangeEnemy[1])
            then
                return BOT_ACTION_DESIRE_HIGH, allyHero
            end
        end
    end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderWallOfReplica()
	if not J.CanCastAbility(WallOfReplica)
	then
		return BOT_ACTION_DESIRE_NONE, 0
	end

    local _, Vacuum_ = J.HasAbility(bot, 'dark_seer_vacuum')
	local nCastRange = J.GetProperCastRange(false, bot, WallOfReplica:GetCastRange())
	local nCastPoint = WallOfReplica:GetCastPoint() + 0.73
	local nRadius = nCastRange / 2

    if Vacuum_ ~= nil then nRadius = Vacuum_:GetSpecialValueInt('radius') end

	if J.IsInTeamFight(bot, 1200)
	then
        local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, nCastPoint, 0)
        local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)

        if nInRangeEnemy ~= nil and #nInRangeEnemy >= 2
        then
            return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nInRangeEnemy)
        end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderVacuumWall()
    if X.CanDoVacuumWall()
    then
        local nWallOfReplicaCastPoint = WallOfReplica:GetCastPoint() + 0.73
        local nVacuumCastRange = J.GetProperCastRange(false, bot, Vacuum:GetCastRange())
        local nVacuumRadius = Vacuum:GetSpecialValueInt('radius')

        if J.IsInTeamFight(bot, 1600)
        then
            local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nVacuumCastRange, nVacuumRadius, nWallOfReplicaCastPoint, 0)
            local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nVacuumRadius)

            if nInRangeEnemy ~= nil and #nInRangeEnemy >= 2
            then
                return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nInRangeEnemy)
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.CanDoVacuumWall()
    if J.CanCastAbility(Vacuum) and J.CanCastAbility(WallOfReplica) and J.CanBlinkDagger(bot)
    then
        local manaCost = Vacuum:GetManaCost() + WallOfReplica:GetManaCost()

        if bot:GetMana() >= manaCost
        then
            bot.shouldBlink = true
            return true
        end
    end

    bot.shouldBlink = false
    return false
end

return X