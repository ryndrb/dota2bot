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
				"item_moon_shard",
				"item_satanic",--
				"item_ultimate_scepter_2",
				"item_skadi",--
			},
            ['sell_list'] = {
				"item_quelling_blade", "item_black_king_bar",
				"item_magic_wand", "item_butterfly",
				"item_wraith_band", "item_refresher",
				"item_power_treads", "item_skadi",
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

local TimeWalkDesire, TimeWalkLocation
local TimeDilationDesire
local ChronosphereDesire, ChronosphereLocation
local TimeWalkReverseDesire
local TimezoneDesire, TimezoneLocation

local TimeWalkPrevLocation

local botTarget

function X.SkillsComplement()
    if J.CanNotUseAbility(bot) then return end

    TimeWalk 			= bot:GetAbilityByName('faceless_void_time_walk')
    TimeDilation 		= bot:GetAbilityByName('faceless_void_time_dilation')
    TimeWalkReverse 	= bot:GetAbilityByName('faceless_void_time_walk_reverse')
    Chronosphere 		= bot:GetAbilityByName('faceless_void_chronosphere')
	Timezone   			= bot:GetAbilityByName('faceless_void_time_zone')

	botTarget = J.GetProperTarget(bot)

	TimeWalkReverseDesire = X.ConsiderTimeWalkReverse()
	if TimeWalkReverseDesire > 0
	then
		bot:Action_UseAbility(TimeWalkReverse)
		return
	end

	TimeWalkDesire, TimeWalkLocation = X.ConsiderTimeWalk()
    if TimeWalkDesire > 0
	then
        J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnLocation(TimeWalk, TimeWalkLocation)
		TimeWalkPrevLocation = TimeWalkLocation
		return
	end

	TimeDilationDesire = X.ConsiderTimeDilation()
	if TimeDilationDesire > 0
	then
        J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbility(TimeDilation)
		return
	end

	ChronosphereDesire, ChronosphereLocation = X.ConsiderChronosphere()
    if ChronosphereDesire > 0
	then
		bot:Action_UseAbilityOnLocation(Chronosphere, ChronosphereLocation)
		return
	end

	TimezoneDesire, TimezoneLocation = X.ConsiderTimezone()
    if TimezoneDesire > 0
	then
		bot:Action_UseAbilityOnLocation(Timezone, TimezoneLocation)
		return
	end
end

function X.ConsiderTimeWalk()
	if not J.CanCastAbility(TimeWalk)
	or bot:HasModifier("modifier_faceless_void_chronosphere_speed")
	then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastRange = TimeWalk:GetSpecialValueInt('range')
	local nCastPoint = TimeWalk:GetCastPoint()
	local nSpeed = TimeWalk:GetSpecialValueInt('speed')
	local nDamageWindow = TimeWalk:GetSpecialValueInt('backtrack_duration')

	local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
    local nEnemyTowers = bot:GetNearbyTowers(888, true)

	if bot.InfoBuffer ~= nil
	then
		-- try to backtrack ~^40% of damage
		for i = 1, math.ceil(nDamageWindow)
		do
			local prevHealth = bot.InfoBuffer[i].health
			if prevHealth and (prevHealth / bot:GetMaxHealth()) - J.GetHP(bot) >= 0.4
			then
				return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, J.GetTeamFountain(), nCastRange)
			end
		end
	end

	if J.IsStuck(bot)
	then
		return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, J.GetTeamFountain(), nCastRange)
	end

	if J.IsStunProjectileIncoming(bot, 350)
	or J.IsUnitTargetProjectileIncoming(bot, 350)
    then
        return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, J.GetTeamFountain(), nCastRange)
    end

	if  not bot:HasModifier('modifier_sniper_assassinate')
	and not bot:IsMagicImmune()
	then
		if J.IsWillBeCastUnitTargetSpell(bot, 350)
		then
			return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, J.GetTeamFountain(), nCastRange)
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
		and not J.IsSuspiciousIllusion(botTarget)
		and not botTarget:IsAttackImmune()
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			local eta = (GetUnitToUnitDistance(bot, botTarget) / nSpeed) + nCastPoint
			local loc = J.GetCorrectLoc(botTarget, eta)

			if IsLocationPassable(loc)
			and not J.IsLocationInArena(loc, 600)
			then
				if GetUnitToLocationDistance(bot, loc) > bot:GetAttackRange() * 2
				then
					if J.IsInLaningPhase()
					then
						local nInRangeAlly = bot:GetNearbyHeroes(888, false, BOT_MODE_NONE)
						if nEnemyTowers ~= nil
                        and (#nEnemyTowers == 0 or J.IsValidBuilding(nEnemyTowers[1]) and GetUnitToLocationDistance(botTarget, loc) > 888)
						and botTarget:GetHealth() <= J.GetTotalEstimatedDamageToTarget(nInRangeAlly, botTarget, 5.0)
						then
                            if GetUnitToLocationDistance(bot, loc) > nCastRange
                            then
                                return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, loc, nCastRange)
                            else
                                return BOT_ACTION_DESIRE_HIGH, loc
                            end
						end
					else
						if GetUnitToLocationDistance(bot, loc) > nCastRange
                        then
                            return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, loc, nCastRange)
                        else
                            return BOT_ACTION_DESIRE_HIGH, loc
                        end
					end
				end
			end
		end
	end

	if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
	and bot:GetActiveModeDesire() > 0.65
	then
		for _, enemy in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemy)
			and J.IsInRange(bot, enemy, 600)
			and bot:WasRecentlyDamagedByHero(enemy, nDamageWindow)
			and (not J.IsSuspiciousIllusion(enemy) or (J.GetHP(bot) < 0.4 and J.IsChasingTarget(enemy, bot)))
			then
				return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, J.GetTeamFountain(), nCastRange)
			end
		end

		local nAllyHeroes = J.GetAlliesNearLoc(bot:GetLocation(), 1200)
		if not J.IsInLaningPhase() then
			if #nEnemyHeroes >= #nAllyHeroes + 2 then
				return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, J.GetTeamFountain(), nCastRange)
			end
		end
	end

    local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(nCastRange, true)

	if J.IsPushing(bot)
    and J.GetManaAfter(TimeWalk:GetManaCost()) > 0.45
	then
		if  nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 3
        and J.CanBeAttacked(nEnemyLaneCreeps[1])
		and GetUnitToLocationDistance(bot, J.GetCenterOfUnits(nEnemyLaneCreeps)) > 500
		then
			return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nEnemyLaneCreeps)
		end
	end

	if J.IsFarming(bot)
    and J.GetManaAfter(TimeWalk:GetManaCost()) > 0.33
	then
		if  J.IsValid(botTarget)
		and GetUnitToUnitDistance(bot, botTarget) > 500
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

	if J.IsLaning(bot)
	then
		if  J.GetManaAfter(TimeWalk:GetManaCost()) > 0.85
		and bot:DistanceFromFountain() > 100
		and bot:DistanceFromFountain() < 6000
		and J.IsInLaningPhase()
		and nEnemyHeroes ~= nil and #nEnemyHeroes == 0
		then
			local nLane = bot:GetAssignedLane()
			local nLaneFrontLocation = GetLaneFrontLocation(GetTeam(), nLane, 0)
			local nDistFromLane = GetUnitToLocationDistance(bot, nLaneFrontLocation)

			if nDistFromLane > nCastRange
			then
				local nLocation = J.Site.GetXUnitsTowardsLocation(bot, nLaneFrontLocation, nCastRange)
				if IsLocationPassable(nLocation)
                and bot:IsFacingLocation(nLocation, 30)
				then
					return BOT_ACTION_DESIRE_HIGH, nLocation
				end
			end
		end
	end

	if J.IsDoingRoshan(bot)
    and bot:GetActiveModeDesire() > 0.7
    then
		local roshLoc = J.GetCurrentRoshanLocation()
        if GetUnitToLocationDistance(bot, roshLoc) > nCastRange
        then
			local targetLoc = J.Site.GetXUnitsTowardsLocation(bot, roshLoc, nCastRange)

			if  nEnemyHeroes ~= nil and #nEnemyHeroes == 0
			and IsLocationPassable(targetLoc)
			then
				return BOT_ACTION_DESIRE_HIGH, targetLoc
			end
        end
    end

    if J.IsDoingTormentor(bot)
    and bot:GetActiveModeDesire() > 0.7
    then
		local tormentorLoc = J.GetTormentorWaitingLocation(GetTeam())
        if GetUnitToLocationDistance(bot, tormentorLoc) > 1600
        then
			local targetLoc = J.Site.GetXUnitsTowardsLocation(bot, tormentorLoc, nCastRange)

			if  nEnemyHeroes ~= nil and #nEnemyHeroes == 0
			and IsLocationPassable(targetLoc)
			then
				return BOT_ACTION_DESIRE_HIGH, targetLoc
			end

        end
    end

	return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderTimeDilation()
    if not J.CanCastAbility(TimeDilation)
	then
		return BOT_ACTION_DESIRE_NONE
	end

	local nRadius = TimeDilation:GetSpecialValueInt('radius')

	if J.IsInTeamFight(bot, 1200)
	then
		local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), nRadius)
		if nInRangeEnemy ~= nil and #nInRangeEnemy >= 2
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.IsInRange(bot, botTarget, nRadius)
		and not J.IsSuspiciousIllusion(botTarget)
		and not J.IsDisabled(botTarget)
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
    and bot:WasRecentlyDamagedByAnyHero(4)
	then
		local nInRangeEnemy = bot:GetNearbyHeroes(nRadius, true, BOT_MODE_NONE)

        if  J.IsValidHero(nInRangeEnemy[1])
        and J.CanCastOnNonMagicImmune(nInRangeEnemy[1])
        and J.IsChasingTarget(nInRangeEnemy[1], bot)
        then
            return BOT_ACTION_DESIRE_HIGH
        end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderTimeWalkReverse()
	if not J.CanCastAbility(TimeWalkReverse)
	then
		return BOT_ACTION_DESIRE_NONE
	end

	if J.IsStunProjectileIncoming(bot, 350)
	or J.IsUnitTargetProjectileIncoming(bot, 350)
    then
        return BOT_ACTION_DESIRE_HIGH
    end

	if  not bot:HasModifier('modifier_sniper_assassinate')
	and not bot:IsMagicImmune()
	then
		if J.IsWillBeCastUnitTargetSpell(bot, 350)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if  not bot:HasModifier('modifier_faceless_void_chronosphere_speed')
	and J.IsValidTarget(botTarget)
	and J.IsInRange(bot, botTarget, 1600)
	and not J.IsSuspiciousIllusion(botTarget)
	then
		local nInRangeAlly = botTarget:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
		local nInRangeEnemy = botTarget:GetNearbyHeroes(1600, false, BOT_MODE_NONE)

		local isPrevLocDist1 = GetUnitToLocationDistance(bot, TimeWalkPrevLocation) > GetUnitToLocationDistance(botTarget, TimeWalkPrevLocation)
		local isPrevLocDist2 = GetUnitToLocationDistance(bot, TimeWalkPrevLocation) > GetUnitToUnitDistance(bot, botTarget)

		if nInRangeAlly ~= nil and nInRangeEnemy ~= nil
		then
			if  #nInRangeEnemy > #nInRangeAlly
			and isPrevLocDist1
			and isPrevLocDist2
			then
				return BOT_ACTION_DESIRE_HIGH
			end
		end

		if bot.InfoBuffer ~= nil
		then
			-- try to backtrack ~^40% of damage
			for i = 1, 3
			do
				local prevHealth = bot.InfoBuffer[i].health
				if prevHealth and (prevHealth / bot:GetMaxHealth()) - J.GetHP(bot) >= 0.4
				and isPrevLocDist1 and isPrevLocDist2
				then
					return BOT_ACTION_DESIRE_HIGH
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderChronosphere()
	if not J.CanCastAbility(Chronosphere)
	or bot:GetCurrentMovementSpeed() >= 1000
	then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastRange = J.GetProperCastRange(false, bot, Chronosphere:GetCastRange())
	local nCastPoint = Chronosphere:GetCastPoint()
	local nRadius = Chronosphere:GetSpecialValueInt('radius')
	local nDuration = Chronosphere:GetSpecialValueInt('duration')
	local nAttackDamage = bot:GetAttackDamage()
	local nAttackSpeed = bot:GetAttackSpeed()
	local nBotKills = GetHeroKills(bot:GetPlayerID())
	local nBotDeaths = GetHeroDeaths(bot:GetPlayerID())

    local nAllyHeroes = bot:GetNearbyHeroes(1200, false, BOT_MODE_NONE)
    local nEnemyHeroes = bot:GetNearbyHeroes(1200, true, BOT_MODE_NONE)

	if J.IsInTeamFight(bot, 1200)
	then
		local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, nCastPoint, 0)
        local nInRangeAlly = J.GetAlliesNearLoc(nLocationAoE.targetloc, nRadius)
		local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)

		if nInRangeEnemy ~= nil and #nInRangeEnemy >= 2
		then
			local targetHero = nil
			local currHeroHP = 10000

			for _, enemyHero in pairs(nInRangeEnemy)
			do
				if  J.IsValidHero(enemyHero)
				and not J.IsSuspiciousIllusion(enemyHero)
				and not enemyHero:IsAttackImmune()
				and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
				and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
				and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
				and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
				and enemyHero:GetHealth() < currHeroHP
				then
					currHeroHP = enemyHero:GetHealth()
					targetHero = enemyHero
				end
			end

			if targetHero ~= nil
			then
                local targetLoc = X.GetBestChrono(nInRangeAlly, nInRangeEnemy, nRadius, nLocationAoE.targetloc)
                if targetLoc == 0 then targetLoc = nLocationAoE.targetloc end
                bot:SetTarget(targetHero)
				return BOT_ACTION_DESIRE_HIGH, targetLoc
			end

		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
		and J.CanCastOnMagicImmune(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and not botTarget:IsAttackImmune()
        and not J.IsHaveAegis(botTarget)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
		then
			if  nAllyHeroes ~= nil and nEnemyHeroes ~= nil
			and #nAllyHeroes >= #nEnemyHeroes
			and #nAllyHeroes <= 1 and #nEnemyHeroes <= 1
			then
				local loc = J.GetCorrectLoc(botTarget, nCastPoint)

				if  J.CanKillTarget(botTarget, nAttackDamage * nAttackSpeed * nDuration, DAMAGE_TYPE_PHYSICAL)
				and not J.IsLocationInChrono(loc)
				and not J.IsLocationInBlackHole(loc)
				and not J.IsLocationInArena(loc, nRadius)
				then
                    local nInRangeAlly = J.GetAlliesNearLoc(botTarget:GetLocation(), nRadius)
                    local nInRangeEnemy = J.GetEnemiesNearLoc(botTarget:GetLocation(), nRadius)

					if J.IsCore(botTarget)
					then
                        local targetLoc = X.GetBestChrono(nInRangeAlly, nInRangeEnemy, nRadius, loc)

                        if targetLoc == 0 then targetLoc = loc end
                        bot:SetTarget(botTarget)
                        return BOT_ACTION_DESIRE_HIGH, targetLoc
					end

					if  not J.IsCore(botTarget)
					and nBotDeaths > nBotKills + 4
					then
						local targetLoc = X.GetBestChrono(nInRangeAlly, nInRangeEnemy, nRadius, loc)

                        if targetLoc == 0 then targetLoc = loc end
                        bot:SetTarget(botTarget)
                        return BOT_ACTION_DESIRE_HIGH, targetLoc
					end
				end
			end
		end
	end

	if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
    and bot:WasRecentlyDamagedByAnyHero(5)
	then
        if J.IsValidHero(nEnemyHeroes[1])
        and J.IsInRange(bot, nEnemyHeroes[1], nCastRange)
        and J.IsChasingTarget(nEnemyHeroes[1], bot)
        and not J.IsSuspiciousIllusion(nEnemyHeroes[1])
        and not nEnemyHeroes[1]:HasModifier('modifier_legion_commander_duel')
        and not nEnemyHeroes[1]:HasModifier('modifier_necrolyte_reapers_scythe')
        then
            local nInRangeAlly = nEnemyHeroes[1]:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
            local nTargetInRangeAlly = nEnemyHeroes[1]:GetNearbyHeroes(1600, false, BOT_MODE_NONE)

            if  nTargetInRangeAlly ~= nil and nInRangeAlly ~= nil
            and #nTargetInRangeAlly > #nInRangeAlly + 2
            and #nInRangeAlly <= 1
            then
                local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, nCastPoint, 0)
                local nTargetLocInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)

                if not J.IsLocationInChrono(nLocationAoE.targetloc)
                and not J.IsLocationInBlackHole(nLocationAoE.targetloc)
                and not J.IsLocationInArena(nLocationAoE.targetloc, nRadius)
                then
                    if #nTargetLocInRangeEnemy >= 2
                    then
                        return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                    else
                        return BOT_ACTION_DESIRE_HIGH, nEnemyHeroes[1]:GetLocation()
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
		local nAllyHeroes = J.GetAlliesNearLoc(nLocationAoE.targetloc, nRadius)
		local nEnemyHeroes = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)
		if (#nAllyHeroes >= 2 and #nEnemyHeroes >= 2) then
			local nGoodEnemies = 0
			for _, enemyHero in pairs(nEnemyHeroes) do
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

function X.GetBestChrono(nInRangeAlly, nInRangeEnemy, nRadius, vCurrLoc)
    local vLoc = 0

    for _ = 1, 25
    do
        local loc = J.GetRandomLocationWithinDist(vCurrLoc, 0, nRadius)

        local enemyCount = 0
        local allyCount = 0

        for _, enemyHero in pairs(nInRangeEnemy)
        do
            if J.IsValidHero(enemyHero)
            then
                if GetUnitToLocationDistance(enemyHero, loc) <= nRadius
                then
                    enemyCount = enemyCount + 1
                end
            end
        end

        for _, allyHero in pairs(nInRangeAlly)
        do
            if J.IsValidHero(allyHero)
            and not allyHero:IsIllusion()
            and GetUnitToLocationDistance(allyHero, loc) <= nRadius
            then
                allyCount = allyCount + 1
            end
        end

        if enemyCount > allyCount
        then
            vLoc = loc
        end
    end

    return vLoc
end

function IsAllowedToCast(manaCost)
	if  Chronosphere:IsTrained()
	and Chronosphere:IsFullyCastable()
	then
		local ultCost = Chronosphere:GetManaCost()
		if bot:GetMana() - manaCost * 2 > ultCost
		then
			return true
		else
			return false
		end
	end

	return true
end

return X