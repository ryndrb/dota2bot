local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_faceless_void'
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
					['t15'] = {0, 10},
					['t10'] = {10, 0},
				}
            },
            ['ability'] = {
                [1] = {1,2,3,3,3,6,3,1,1,1,2,6,2,2,6},
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
				"item_lifesteal",
				"item_mjollnir",--
				"item_black_king_bar",--
				"item_aghanims_shard",
				"item_butterfly",--
				"item_refresher",--
				"item_satanic",--
				"item_moon_shard",
				"item_monkey_king_bar",--
				"item_ultimate_scepter_2",
			},
            ['sell_list'] = {
				"item_quelling_blade", "item_black_king_bar",
				"item_magic_wand", "item_butterfly",
				"item_wraith_band", "item_refresher",
				"item_power_treads", "item_monkey_king_bar",
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

local TimeWalk 			= bot:GetAbilityByName('faceless_void_time_walk')
local TimeDilation 		= bot:GetAbilityByName('faceless_void_time_dilation')
local TimeWalkReverse 	= bot:GetAbilityByName('faceless_void_time_walk_reverse')
local Chronosphere 		= bot:GetAbilityByName('faceless_void_chronosphere')
local Timezone   		= bot:GetAbilityByName('faceless_void_time_zone')

local TimeWalkDesire, TimeWalkLocation, TimeWalkLocationPrev
local TimeDilationDesire
local ChronosphereDesire, ChronosphereLocation
local TimeWalkReverseDesire
local TimezoneDesire, TimezoneLocation

local bInsideChronosphere = false

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
	bot = GetBot()

	local hAbilityCurrentActive = bot:GetCurrentActiveAbility()
	if hAbilityCurrentActive and hAbilityCurrentActive == Chronosphere then
		local nRadius = Chronosphere:GetSpecialValueInt('radius')
		if Chronosphere and type(ChronosphereLocation) == 'userdata' then
            local nInRangeEnemy = J.GetEnemiesNearLoc(ChronosphereLocation, nRadius)
            if #nInRangeEnemy == 0 then
                bot:Action_ClearActions(true)
                return
            end
        end

		return
	end

    if J.CanNotUseAbility(bot) then return end

    TimeWalk 			= bot:GetAbilityByName('faceless_void_time_walk')
    TimeDilation 		= bot:GetAbilityByName('faceless_void_time_dilation')
    TimeWalkReverse 	= bot:GetAbilityByName('faceless_void_time_walk_reverse')
    Chronosphere 		= bot:GetAbilityByName('faceless_void_chronosphere')
	Timezone   			= bot:GetAbilityByName('faceless_void_time_zone')

    bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	bInsideChronosphere = bot:GetCurrentMovementSpeed() >= 1000

	TimeWalkReverseDesire = X.ConsiderTimeWalkReverse()
	if TimeWalkReverseDesire > 0 then
		bot:Action_UseAbility(TimeWalkReverse)
		return
	end

	TimeWalkDesire, TimeWalkLocation = X.ConsiderTimeWalk()
    if TimeWalkDesire > 0 then
		TimeWalkLocationPrev = bot:GetLocation()
        J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnLocation(TimeWalk, TimeWalkLocation)
		return
	end

	TimeDilationDesire = X.ConsiderTimeDilation()
	if TimeDilationDesire > 0 then
        J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbility(TimeDilation)
		return
	end

	ChronosphereDesire, ChronosphereLocation = X.ConsiderChronosphere()
    if ChronosphereDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnLocation(Chronosphere, ChronosphereLocation)
		return
	end

	TimezoneDesire, TimezoneLocation = X.ConsiderTimezone()
    if TimezoneDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnLocation(Timezone, TimezoneLocation)
		return
	end
end

function X.ConsiderTimeWalk()
	if not J.CanCastAbility(TimeWalk)
	or bot:IsRooted()
	then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastRange = TimeWalk:GetSpecialValueInt('range')
	local nCastPoint = TimeWalk:GetCastPoint()
	local nSpeed = TimeWalk:GetSpecialValueInt('speed')
	local nDamageWindow = TimeWalk:GetSpecialValueInt('backtrack_duration')
	local nManaCost = TimeWalk:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {TimeWalk, TimeDilation, Timezone, Chronosphere})
	local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {TimeDilation, Timezone, Chronosphere})
	local fManaThreshold3 = J.GetManaThreshold(bot, nManaCost, {Timezone, Chronosphere})

    local nEnemyTowers = bot:GetNearbyTowers(1600, true)

	local vLocation = J.VectorTowards(bot:GetLocation(), J.GetTeamFountain(), nCastRange)

	if bot.history then
		-- try to backtrack ~^40% of damage
		for i = 1, math.ceil(nDamageWindow) do
			if  bot.history[i]
			and bot.history[i].health
			then
				local prevHealth = bot.history[i].health
				if prevHealth and (prevHealth / bot:GetMaxHealth()) - botHP >= 0.4 then
					return BOT_ACTION_DESIRE_HIGH, vLocation
				end
			end
		end
	end

	if J.IsStuck(bot) then
		return BOT_ACTION_DESIRE_HIGH, vLocation
	end

	if not bot:IsMagicImmune() and fManaAfter > fManaThreshold2 then
		if (J.IsStunProjectileIncoming(bot, 350))
		or (J.IsUnitTargetProjectileIncoming(bot, 350))
		or (J.IsWillBeCastUnitTargetSpell(bot, 350) and not bot:HasModifier('modifier_sniper_assassinate'))
		then
			return BOT_ACTION_DESIRE_HIGH, vLocation
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if bot:HasScepter() and fManaAfter > fManaThreshold3 then
			for _, enemy in pairs(nEnemyHeroes) do
				if J.IsValidHero(enemy)
				and J.CanBeAttacked(enemy)
				and J.IsInRange(bot, enemy, nCastRange)
				and not J.IsSuspiciousIllusion(enemy)
				and enemy:HasModifier('modifier_teleporting')
				then
					return BOT_ACTION_DESIRE_HIGH, enemy:GetLocation()
				end
			end
		end

		if  J.IsValidTarget(botTarget)
		and J.CanBeAttacked(botTarget)
		and GetUnitToLocationDistance(botTarget, J.GetEnemyFountain()) > 600
		and not J.IsSuspiciousIllusion(botTarget)
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		and fManaAfter > fManaThreshold3
		then
			local eta = (GetUnitToUnitDistance(bot, botTarget) / nSpeed) + nCastPoint
			local targetLocation = J.GetCorrectLoc(botTarget, eta)
			if IsLocationPassable(targetLocation) and GetUnitToLocationDistance(bot, targetLocation) > bot:GetAttackRange() * 2 then
				if J.IsEarlyGame() then
					if #nEnemyTowers == 0 or (J.IsValidBuilding(nEnemyTowers[1]) and nEnemyTowers[1]:GetAttackTarget() ~= nil and GetUnitToLocationDistance(botTarget, targetLocation) > 900) then
						return BOT_ACTION_DESIRE_HIGH, (GetUnitToLocationDistance(bot, targetLocation) <= nCastRange and targetLocation) or J.VectorTowards(bot:GetLocation(), targetLocation, nCastRange)
					end
				else
					return BOT_ACTION_DESIRE_HIGH, (GetUnitToLocationDistance(bot, targetLocation) <= nCastRange and targetLocation) or J.VectorTowards(bot:GetLocation(), targetLocation, nCastRange)
				end
			end
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and not bInsideChronosphere then
		for _, enemy in pairs(nEnemyHeroes) do
			if  J.IsValidHero(enemy)
			and J.IsInRange(bot, enemy, 1000)
			and bot:WasRecentlyDamagedByHero(enemy, nDamageWindow)
			and not J.IsSuspiciousIllusion(enemy)
			then
				if J.IsChasingTarget(enemy, bot)
				or (#nEnemyHeroes > #nAllyHeroes and enemy:GetAttackTarget() == bot)
				then
					return BOT_ACTION_DESIRE_HIGH, vLocation
				end
			end
		end
	end

	if J.IsPushing(bot) and fManaAfter > fManaThreshold1 and #nEnemyHeroes == 0 and #nEnemyTowers == 0 then
		local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(nCastRange, true)
		if J.IsValid(nEnemyLaneCreeps[1]) and J.CanBeAttacked(nEnemyLaneCreeps[1]) then
			local vCenterOfUnits = J.GetCenterOfUnits(nEnemyLaneCreeps)
			if GetUnitToLocationDistance(bot, vCenterOfUnits) > 500 and GetUnitToLocationDistance(bot, vCenterOfUnits) <= nCastRange then
				return BOT_ACTION_DESIRE_HIGH, vCenterOfUnits
			end
		end

		if fManaAfter > fManaThreshold1 + 0.15 then
			local nLane = LANE_MID
			if bot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP then nLane = LANE_TOP end
			if bot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT then nLane = LANE_BOT end

			local vLaneFrontLocation = GetLaneFrontLocation(GetTeam(), nLane, 0)
			if (GetUnitToLocationDistance(bot, vLaneFrontLocation) / bot:GetCurrentMovementSpeed()) > 3.5 then
				if bot:IsFacingLocation(vLaneFrontLocation, 45) and IsLocationPassable(vLaneFrontLocation) then
					return BOT_ACTION_DESIRE_HIGH, (GetUnitToLocationDistance(bot, vLaneFrontLocation) <= nCastRange and vLaneFrontLocation) or J.VectorTowards(bot:GetLocation(), vLaneFrontLocation, nCastRange)
				end
			end
		end
	end

	if J.IsDefending(bot) and fManaAfter > fManaThreshold1 + 0.15 and #nEnemyHeroes == 0 then
		local nLane = LANE_MID
		if bot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP then nLane = LANE_TOP end
		if bot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT then nLane = LANE_BOT end

		local vLaneFrontLocation = GetLaneFrontLocation(GetTeam(), nLane, 0)
		if (GetUnitToLocationDistance(bot, vLaneFrontLocation) / bot:GetCurrentMovementSpeed()) > 3.5 then
			if bot:IsFacingLocation(vLaneFrontLocation, 45) and IsLocationPassable(vLaneFrontLocation) then
				return BOT_ACTION_DESIRE_HIGH, (GetUnitToLocationDistance(bot, vLaneFrontLocation) <= nCastRange and vLaneFrontLocation) or J.VectorTowards(bot:GetLocation(), vLaneFrontLocation, nCastRange)
			end
		end
	end

	if J.IsFarming(bot) and fManaAfter > fManaThreshold2 and #nEnemyHeroes == 0 and #nEnemyTowers == 0 then
		if bot.farm and bot.farm.location then
			local distance = GetUnitToLocationDistance(bot, bot.farm.location)
			vLocation = J.VectorTowards(bot:GetLocation(), bot.farm.location, Min(nCastRange, distance))
			if J.IsRunning(bot) and distance > nCastRange / 2 and IsLocationPassable(vLocation) then
				return BOT_ACTION_DESIRE_HIGH, vLocation
			end
		end
	end

	if J.IsLaning(bot) and J.IsInLaningPhase() and DotaTime() > 0 and fManaAfter > 0.8 then
		local vLaneFrontLocation = GetLaneFrontLocation(GetTeam(), bot:GetAssignedLane(), 0)
		if GetUnitToLocationDistance(bot, vLaneFrontLocation) > 2000 and #nEnemyHeroes <= 1 and #nEnemyTowers == 0 then
			if bot:IsFacingLocation(vLaneFrontLocation, 45) and IsLocationPassable(vLaneFrontLocation) then
				return BOT_ACTION_DESIRE_HIGH, (GetUnitToLocationDistance(bot, vLaneFrontLocation) <= nCastRange and vLaneFrontLocation) or J.VectorTowards(bot:GetLocation(), vLaneFrontLocation, nCastRange)
			end
		end
	end

	if J.IsGoingToRune(bot) and fManaAfter > fManaThreshold2 and #nEnemyTowers == 0 then
		if bot.rune and bot.rune.location then
			local distance = GetUnitToLocationDistance(bot, bot.rune.location)
			vLocation = J.VectorTowards(bot:GetLocation(), bot.rune.location, Min(nCastRange, distance))
			if J.IsRunning(bot) and distance > nCastRange / 2 and IsLocationPassable(vLocation) then
				return BOT_ACTION_DESIRE_HIGH, vLocation
			end
		end
	end

	if J.IsDoingRoshan(bot) then
		local vRoshanLocation = J.GetCurrentRoshanLocation()
		if  GetUnitToLocationDistance(bot, vRoshanLocation) > 2000
		and #nEnemyHeroes <= 1
		and fManaAfter > fManaThreshold2 + 0.1
		then
			if bot:IsFacingLocation(vRoshanLocation, 45) and IsLocationPassable(vRoshanLocation) then
				return BOT_ACTION_DESIRE_HIGH, vRoshanLocation
			end
		end
	end

	if J.IsDoingTormentor(bot) then
		local vTormentorLocation = J.GetTormentorLocation(GetTeam())
		if  GetUnitToLocationDistance(bot, vTormentorLocation) > 2000
		and #nEnemyHeroes <= 1
		and fManaAfter > fManaThreshold2 + 0.1
		then
			if bot:IsFacingLocation(vTormentorLocation, 45) and IsLocationPassable(vTormentorLocation) then
				return BOT_ACTION_DESIRE_HIGH, vTormentorLocation
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderTimeDilation()
    if not J.CanCastAbility(TimeDilation) then
		return BOT_ACTION_DESIRE_NONE
	end

	local nRadius = TimeDilation:GetSpecialValueInt('radius')
	local nManaCost = TimeDilation:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {TimeWalk, Timezone, Chronosphere})
	local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {Timezone, Chronosphere})

	if J.IsInTeamFight(bot, 1200) and fManaAfter > fManaThreshold1 then
		local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), nRadius)
		local count = 0
		for _, enemyHero in pairs(nInRangeEnemy) do
			if  J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and not J.IsDisabled(enemyHero)
			and not enemyHero:HasModifier('modifier_doom_bringer_doom_aura_enemy')
			and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			then
				count = count + 1
			end
		end

		if count >= 2 then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.IsInRange(bot, botTarget, nRadius * 0.85)
		and not J.IsDisabled(botTarget)
		and not botTarget:HasModifier('modifier_doom_bringer_doom_aura_enemy')
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		and fManaAfter > fManaThreshold2
		then
			local nInRangeEnemy = J.GetEnemiesNearLoc(botTarget:GetLocation(), nRadius * 0.85)
			if (#nInRangeEnemy >= 2)
			or (botTarget:IsChanneling() or botTarget:IsUsingAbility() or botTarget:IsCastingAbility())
			or (J.IsChasingTarget(bot, botTarget))
			then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(4.0) and fManaAfter > fManaThreshold2 then
		for _, enemy in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemy)
			and J.IsInRange(bot, enemy, nRadius * 0.9)
			and J.CanCastOnNonMagicImmune(enemy)
			and not J.IsDisabled(enemy)
			and not enemy:IsDisarmed()
			then
				local nInRangeEnemy = bot:GetNearbyHeroes(nRadius * 0.9, true, BOT_MODE_NONE)
				if (J.IsChasingTarget(enemy, bot))
				or (#nEnemyHeroes > #nAllyHeroes and enemy:GetAttackTarget() == bot)
				or #nInRangeEnemy >= 2
				then
					return BOT_ACTION_DESIRE_HIGH
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderTimeWalkReverse()
	if not J.CanCastAbility(TimeWalkReverse)
	or TimeWalkLocationPrev == nil
	then
		return BOT_ACTION_DESIRE_NONE
	end

	local nInRangeAlly = J.GetAlliesNearLoc(TimeWalkLocationPrev, 1600)
	local nInRangeEnemy = J.GetEnemiesNearLoc(TimeWalkLocationPrev, 1600)

	if not bot:IsMagicImmune() and #nInRangeAlly >= #nInRangeEnemy then
		if (J.IsStunProjectileIncoming(bot, 350))
		or (J.IsUnitTargetProjectileIncoming(bot, 350))
		or (J.IsWillBeCastUnitTargetSpell(bot, 350) and not bot:HasModifier('modifier_sniper_assassinate'))
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if not bInsideChronosphere and TimeWalkLocationPrev ~= nil then
		if J.IsGoingOnSomeone(bot) then
			if J.IsValidTarget(botTarget)
			and J.IsInRange(bot, botTarget, 1600)
			and not J.IsSuspiciousIllusion(botTarget)
			and #nInRangeAlly >= #nInRangeEnemy
			then
				local distance_BotToBotTarget = GetUnitToUnitDistance(bot, botTarget)
				local distance_BotTargetToPrevLocation = GetUnitToLocationDistance(botTarget, TimeWalkLocationPrev)
				if distance_BotToBotTarget > distance_BotTargetToPrevLocation and distance_BotTargetToPrevLocation <= 600 then
					return BOT_ACTION_DESIRE_HIGH
				end
			end
		end

		if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and #nEnemyHeroes > 0 then
			if #nInRangeAlly >= #nInRangeEnemy
			and GetUnitToLocationDistance(bot, J.GetTeamFountain()) > J.GetDistance(TimeWalkLocationPrev, J.GetTeamFountain())
			and bot:IsFacingLocation(J.GetTeamFountain(), 45)
			then
				return BOT_ACTION_DESIRE_HIGH
			end
		end

		if bot.history then
			-- try to backtrack ~^40% of damage
			for i = 1, 3 do
				if  bot.history[i]
				and bot.history[i].health
				then
					local prevHealth = bot.history[i].health
					if prevHealth and (prevHealth / bot:GetMaxHealth()) - botHP >= 0.4
					and #nInRangeAlly >= #nInRangeEnemy
					then
						return BOT_ACTION_DESIRE_HIGH
					end
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderChronosphere()
	if not J.CanCastAbility(Chronosphere)
	or bInsideChronosphere
	then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastRange = J.GetProperCastRange(false, bot, Chronosphere:GetCastRange())
	local nCastPoint = Chronosphere:GetCastPoint()
	local nRadius = Chronosphere:GetSpecialValueInt('radius')
	local nDuration = Chronosphere:GetSpecialValueInt('duration')
	local nBonusAttackSpeed = Chronosphere:GetSpecialValueInt('bonus_attack_speed')
	local nAttackDamage = bot:GetAttackDamage()
	local nAttackSpeed = bot:GetAttackSpeed() + (nBonusAttackSpeed / 100)

	if J.IsInTeamFight(bot, 1200) then
        local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), nCastRange)
		local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), nCastRange)
		if #nInRangeEnemy >= 2 then
			local count = 0
			for _, enemyHero in pairs(nInRangeEnemy) do
				if  J.IsValidHero(enemyHero)
				and J.CanBeAttacked(enemyHero)
				and not J.IsSuspiciousIllusion(enemyHero)
				and not J.IsMeepoClone(enemyHero)
				and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
				and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
				and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
				and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
				then
					count = count + (J.IsCore(enemyHero) and 1 or 0.5)
				end
			end

			if count >= 1.5 then
                local targetLocation = X.GetBestChronoLocation(nInRangeAlly, nInRangeEnemy, nCastRange, nRadius, bot:GetLocation())
				if targetLocation ~= nil then
					return BOT_ACTION_DESIRE_HIGH, targetLocation
				end
			end
		end
	else
		if J.IsGoingOnSomeone(bot) then
			if  J.IsValidTarget(botTarget)
			and J.CanBeAttacked(botTarget)
			and J.IsInRange(bot, botTarget, nCastRange * 0.9)
			and not J.IsHaveAegis(botTarget)
			and not J.IsSuspiciousIllusion(botTarget)
			and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
			and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
			and not botTarget:HasModifier('modifier_doom_bringer_doom_aura_enemy')
			and not botTarget:HasModifier('modifier_enigma_black_hole_pull')
			and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
			and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
			and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
			and not botTarget:HasModifier('modifier_winter_wyvern_cold_embrace')
			and not botTarget:HasModifier('modifier_winter_wyvern_winters_curse')
			and not botTarget:HasModifier('modifier_item_blade_mail_reflect')
			and (not J.IsLateGame() or (J.GetPosition(botTarget) <= 2))
			then
				local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), 1600)
				local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1600)
				local enemyCount = 0
				for _, enemyHero in pairs(nInRangeEnemy) do
					if J.IsValidHero(enemyHero) then
						if J.IsCore(enemyHero) then
							enemyCount = enemyCount + 1
						else
							enemyCount = enemyCount + 0.5
						end
					end
				end

				if #nInRangeAlly <= 2 and enemyCount == 1 then
					if J.WillKillTarget(botTarget, nAttackDamage * nAttackSpeed, DAMAGE_TYPE_PHYSICAL, nDuration) then
						bot:SetTarget(botTarget)
						return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
					end
				end
			end
		end

		if J.IsRetreating(bot)
		and not J.IsRealInvisible(bot)
		and bot:WasRecentlyDamagedByAnyHero(5)
		and bot:GetActiveModeDesire() >= 0.95
		and not J.IsLateGame()
		and #nAllyHeroes <= 2
		then
			for _, enemy in pairs(nEnemyHeroes) do
				if J.IsValidHero(enemy)
				and J.IsInRange(bot, enemy, nCastRange)
				and not J.IsSuspiciousIllusion(enemy)
				and not J.IsDisabled(enemy)
				and not enemy:IsDisarmed()
				and not enemy:HasModifier('modifier_enigma_black_hole_pull')
				and not enemy:HasModifier('modifier_faceless_void_chronosphere_freeze')
				and not enemy:HasModifier('modifier_legion_commander_duel')
				and not enemy:HasModifier('modifier_necrolyte_reapers_scythe')
				then
					if J.IsChasingTarget(enemy, bot) and #nEnemyHeroes > #nAllyHeroes and #nEnemyHeroes >= 2 then
						return BOT_ACTION_DESIRE_HIGH, enemy:GetLocation()
					end
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderTimezone()
	if not J.CanCastAbility(Timezone) then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastRange = J.GetProperCastRange(false, bot, Timezone:GetCastRange())
	local nRadius = TimeDilation:GetSpecialValueInt('radius')

	if J.IsInTeamFight(bot, 1600) then
		local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
		local nInRangeAlly = J.GetAlliesNearLoc(nLocationAoE.targetloc, nRadius)
		local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)
		if (#nInRangeAlly >= 2 and #nInRangeEnemy >= 2) then
			local nGoodEnemies = 0
			for _, enemyHero in pairs(nInRangeEnemy) do
				if J.IsValidHero(enemyHero)
				and not J.IsSuspiciousIllusion(enemyHero)
				and J.GetHP(enemyHero) > 0.25
				and J.CanBeAttacked(enemyHero)
				and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
				and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
				then
					nGoodEnemies = nGoodEnemies + 1
				end
			end

			if nGoodEnemies >= 2 then
				return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

function X.GetBestChronoLocation(nInRangeAlly, nInRangeEnemy, nCastRange, nRadius, vAoELocation)
	local vLocation = nil

	for _ = 1, 25 do
        local vRandomLocation = J.GetRandomLocationWithinDist(vAoELocation, 0, nCastRange)
        local enemyCount = 0
        local allyCount = 0

        for _, enemyHero in pairs(nInRangeEnemy) do
            if J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and not J.IsChasingTarget(bot, enemyHero)
			and not J.IsChasingTarget(enemyHero)
			and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			and GetUnitToLocationDistance(enemyHero, vRandomLocation) <= nRadius
            then
				enemyCount = enemyCount + (J.IsCore(enemyHero) and 1 or 0.5)
            end
        end

        for _, allyHero in pairs(nInRangeAlly) do
            if J.IsValidHero(allyHero)
			and bot ~= allyHero
            and not J.IsSuspiciousIllusion(allyHero)
            and GetUnitToLocationDistance(allyHero, vRandomLocation) <= nRadius
            then
                allyCount = allyCount + 1
            end
        end

		if enemyCount >= 1.5 and allyCount == 0 then
			return vRandomLocation
		end

        if enemyCount > allyCount and enemyCount >= 2 then
            vLocation = vRandomLocation
        end
    end

    return vLocation
end

return X