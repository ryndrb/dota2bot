local X = {}
local bDebugMode = ( 1 == 10 )
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sOutfitType = J.Item.GetOutfitType( bot )

local tTalentTreeList = {
						['t25'] = {0, 10},
						['t20'] = {0, 10},
						['t15'] = {0, 10},
						['t10'] = {10, 0},
}

local tAllAbilityBuildList = {
						{1,2,3,3,3,6,3,1,1,1,2,6,2,2,6},--pos1
}

local nAbilityBuildList = J.Skill.GetRandomBuild( tAllAbilityBuildList )

local nTalentBuildList = J.Skill.GetTalentBuild( tTalentTreeList )

local sRandomItem_1 = RandomInt( 1, 9 ) > 6 and "item_satanic" or "item_butterfly"

local tOutFitList = {}

tOutFitList['outfit_carry'] = {
    "item_tango",
    "item_double_branches",
    "item_quelling_blade",
	"item_slippers",
	"item_circlet",

    "item_wraith_band",
    "item_power_treads",
    "item_magic_wand",
    "item_mask_of_madness",
    "item_mjollnir",--
    "item_black_king_bar",--
    "item_skadi",--
    "item_aghanims_shard",
	"item_butterfly",--
    "item_refresher",--
    "item_travel_boots",
    "item_moon_shard",
    "item_travel_boots_2",--
    "item_ultimate_scepter_2",
}

tOutFitList['outfit_mid'] = tOutFitList['outfit_carry']

tOutFitList['outfit_priest'] = tOutFitList['outfit_carry']

tOutFitList['outfit_mage'] = tOutFitList['outfit_carry']

tOutFitList['outfit_tank'] = tOutFitList['outfit_carry']

X['sBuyList'] = tOutFitList[sOutfitType]

X['sSellList'] = {
    "item_quelling_blade",
    "item_wraith_band",
    "item_magic_wand",
    "item_mask_of_madness",
}

if J.Role.IsPvNMode() or J.Role.IsAllShadow() then X['sBuyList'], X['sSellList'] = { 'PvN_antimage' }, {} end

nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] = J.SetUserHeroInit( nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] )

X['sSkillList'] = J.Skill.GetSkillList( sAbilityList, nAbilityBuildList, sTalentList, nTalentBuildList )

X['bDeafaultAbility'] = false
X['bDeafaultItem'] = false

function X.MinionThink( hMinionUnit )

	if Minion.IsValidUnit( hMinionUnit )
	then
		if hMinionUnit:IsIllusion()
		then
			Minion.IllusionThink( hMinionUnit )
		end
	end

end

local TimeWalk 			= bot:GetAbilityByName( "faceless_void_time_walk" )
local TimeDilation 		= bot:GetAbilityByName( "faceless_void_time_dilation" )
local Chronosphere 		= bot:GetAbilityByName( "faceless_void_chronosphere" )
local TimeWalkReverse 	= bot:GetAbilityByName( "faceless_void_time_walk_reverse" )

local TimeWalkDesire
local TimeDilationDesire
local ChronosphereDesire
local TimeWalkReverseDesire

local hasTimeWalked = false
local hasChronod = false
local timeSinceTimeWalked = 0

function X.SkillsComplement()

    if J.CanNotUseAbility( bot ) then return end

	TimeWalkDesire, TimeWalkLoc = X.ConsiderTimeWalk()
    if  TimeWalkDesire > 0
	and IsAllowedToCast(TimeWalk:GetManaCost())
	then
        J.SetQueuePtToINT(bot, false)

		bot:Action_UseAbilityOnLocation(TimeWalk, TimeWalkLoc)
		hasTimeWalked = true
		timeSinceTimeWalked = DotaTime()
		return
	end

	TimeDilationDesire = X.ConsiderTimeDilation()
	if  TimeDilationDesire > 0
	and IsAllowedToCast(TimeDilation:GetManaCost())
	then
        J.SetQueuePtToINT(bot, false)

		bot:Action_UseAbility(TimeDilation)
		return
	end

	TimeWalkReverseDesire = X.ConsiderTimeWalkReverse()
	if TimeWalkReverseDesire > 0
	then
		bot:Action_UseAbility(TimeWalkReverse)
		hasTimeWalked = false
		hasChronod = false
		return
	end

	ChronosphereDesire, ChronoLoc = X.ConsiderChronosphere()
    if ChronosphereDesire > 0
	then
		bot:Action_UseAbilityOnLocation(Chronosphere, ChronoLoc)
		hasChronod = true
		return
	end
end

function X.ConsiderTimeWalk()
	if not TimeWalk:IsFullyCastable()
	or bot:HasModifier("modifier_faceless_void_chronosphere_speed")
	then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastRange = TimeWalk:GetSpecialValueInt("range")
	local nCastPoint = TimeWalk:GetCastPoint()
	local nAttackPoint = bot:GetAttackPoint()
	local nMana = bot:GetMana() / bot:GetMaxMana()
	local botLevel = bot:GetLevel()
	local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
	local nEnemysTowers = bot:GetNearbyTowers(1200, true)
	local nAllyHeroes = J.GetAllyList(bot, 1200)
	local aliveEnemyCount = J.GetNumOfAliveHeroes(true)

	local botTarget = J.GetProperTarget(bot)

	if J.IsStuck(bot)
	then
		local loc = J.GetEscapeLoc()
		return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, loc, nCastRange)
	end

	if J.IsRetreating(bot)
	or (J.IsRetreating(bot) and J.GetHP(bot) < 0.2 and bot:DistanceFromFountain() > 600)
	then
		if  J.ShouldEscape(bot)
		and not J.IsRealInvisible(bot)
		then
			local loc = J.GetEscapeLoc()
			return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, loc, nCastRange)
		end
	end

	if J.IsGoingOnSomeone(bot)
	and (#nAllyHeroes >= 2 or #nEnemyHeroes <= 1)
	then
		if  J.IsValidTarget(botTarget)
		and J.CanCastOnMagicImmune(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange + 200 )
		and not J.IsInRange(bot, botTarget, 400)
		and not botTarget:IsAttackImmune()
		then
			local nNearbyTargetAllyList = botTarget:GetNearbyHeroes(800, false, BOT_MODE_NONE)
			local nNearbyTargetEnemyList = botTarget:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
			local nTargetAllyList = J.GetAllyList(botTarget, 1600)

			if J.WillKillTarget(botTarget, bot:GetAttackDamage() * 3, DAMAGE_TYPE_PHYSICAL, 2.0)
			or (#nNearbyTargetAllyList <= #nNearbyTargetEnemyList)
			or (#nTargetAllyList <= 1)
			or (aliveEnemyCount <= 2)
			then
				local fLocation = botTarget:GetExtrapolatedLocation(nAttackPoint + nCastPoint)
				local bLocation = botTarget:GetExtrapolatedLocation(nCastPoint)

				if GetUnitToLocationDistance(bot, bLocation) < GetUnitToLocationDistance(bot, fLocation)
				then
					bLocation = fLocation
				end

				if GetUnitToLocationDistance(bot, bLocation) < nCastRange + 150
				then
					bot:SetTarget(botTarget)
					return BOT_ACTION_DESIRE_HIGH, bLocation
				end
			end
		end
	end

	if J.IsFarming(bot)
	then
		if  botTarget ~= nil and botTarget:IsAlive()
		and GetUnitToUnitDistance(bot, botTarget) > 550
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

	if  J.IsLaning(bot)
	and #nEnemyHeroes == 0 and #nEnemysTowers == 0
	then
		local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(nCastRange + 80, true)

		for _, creep in pairs(nEnemyLaneCreeps)
		do
			if J.IsValid(creep)
			and J.CanBeAttacked(creep)
			and J.IsKeyWordUnit("ranged", creep)
			and GetUnitToUnitDistance(creep, bot) > 500
			then
				local nTime = nCastPoint + bot:GetAttackPoint()
				local nDamage = bot:GetAttackDamage()

				if J.WillKillTarget(creep, nDamage, DAMAGE_TYPE_PHYSICAL, nTime)
				then
					bot:SetTarget(creep)
					return BOT_ACTION_DESIRE_HIGH, creep:GetLocation()
				end
			end
		end

		if nMana > 0.9
		and bot:DistanceFromFountain() > 100
		and bot:DistanceFromFountain() < 6000
		and bot:GetAttackTarget() == nil
		then
			local nLane = bot:GetAssignedLane()
			local nLaneFrontLocation = GetLaneFrontLocation(GetTeam(), nLane, 0)
			local nDistFromLane = GetUnitToLocationDistance(bot, nLaneFrontLocation)

			if nDistFromLane > 1600
			then
				local location = J.Site.GetXUnitsTowardsLocation(bot, nLaneFrontLocation, nCastRange)

				if IsLocationPassable(location)
				then
					return BOT_ACTION_DESIRE_HIGH, location
				end
			end
		end
	end

	local nAttackingAllyList = bot:GetNearbyHeroes(1600, false, BOT_MODE_ATTACK)
	if  #nEnemyHeroes == 0 and not bot:WasRecentlyDamagedByAnyHero(3.0) and botLevel >= 8
	and #nAttackingAllyList == 0 and (botTarget == nil or not botTarget:IsHero())
	then
		local nAOELocation = bot:FindAoELocation(true, false, bot:GetLocation(), 1600, 400, 0, 0)
		local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(1600, true)

		if  nAOELocation.count >= 3
		and #nEnemyLaneCreeps >= 3
		then
			local bCreepsCenterLoc = J.GetCenterOfUnits(nEnemyLaneCreeps)
			local bLocDistFromMe = GetUnitToLocationDistance( bot, bCreepsCenterLoc)
			local vLocation = J.Site.GetXUnitsTowardsLocation(bot, bCreepsCenterLoc, bLocDistFromMe + 550)
			local bLocation = J.Site.GetXUnitsTowardsLocation(bot, bCreepsCenterLoc, bLocDistFromMe - 350)

			if bLocDistFromMe >= 1500 then bLocation = J.Site.GetXUnitsTowardsLocation(bot, bCreepsCenterLoc, 1150) end

			if  IsLocationPassable(bLocation)
			and IsLocationVisible(vLocation)
			and GetUnitToLocationDistance(bot, bLocation) > 600
			then
				return BOT_ACTION_DESIRE_HIGH, bLocation
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderTimeDilation()

	if not TimeDilation:IsFullyCastable()
	then
		return BOT_ACTION_DESIRE_NONE
	end

	local nRadius = TimeDilation:GetSpecialValueInt("radius");

	if J.IsRetreating(bot)
	then
		local nEnemyHeroes = bot:GetNearbyHeroes(nRadius, true, BOT_MODE_NONE)
		for _, npcEnemy in pairs(nEnemyHeroes)
		do
			if bot:WasRecentlyDamagedByHero(npcEnemy, 2.0)
			and J.CanCastOnNonMagicImmune(npcEnemy)
			then
				return BOT_ACTION_DESIRE_MODERATE
			end
		end
	end

	if J.IsInTeamFight(bot, 1200)
	then
		local nEnemyHeroes = bot:GetNearbyHeroes(nRadius, true, BOT_MODE_NONE)

		if nEnemyHeroes ~= nil
		and #nEnemyHeroes >= 2
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		local npcTarget = bot:GetTarget()

		if J.IsValidTarget(npcTarget)
		and J.CanCastOnNonMagicImmune(npcTarget)
		and J.IsInRange(npcTarget, bot, nRadius)
		then
			return BOT_ACTION_DESIRE_MODERATE
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderChronosphere()
	if not Chronosphere:IsFullyCastable()
	then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nRadius = Chronosphere:GetSpecialValueInt("radius")
	local nDuration = Chronosphere:GetSpecialValueInt("duration")
	local nCastRange = Chronosphere:GetCastRange()
	local nCastPoint = Chronosphere:GetCastPoint()
	local nAttackDamage = bot:GetAttackDamage()
	local nAttackSpeed = bot:GetAttackSpeed()
	local nBotKills = GetHeroKills(bot:GetPlayerID())
	local nBotDeaths = GetHeroDeaths(bot:GetPlayerID())
	local nEnemyHeroes = bot:GetNearbyHeroes(1200, true, BOT_MODE_NONE)

	if J.IsInTeamFight(bot, 1200)
	then
		local locationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, nCastPoint, 0)

		if locationAoE.count >= 2
		then
			if nEnemyHeroes[1] ~= nil
			then
				local targetHero = nEnemyHeroes[1]
				local currHeroHP = 10000

				for _, enemyHero in pairs(nEnemyHeroes)
				do
					if  enemyHero:GetHealth() < currHeroHP
					and J.IsCore(enemyHero)
					then
						currHeroHP = enemyHero:GetHealth()
						targetHero = enemyHero
					end
				end

				bot:SetTarget(targetHero)
				return BOT_ACTION_DESIRE_HIGH, locationAoE.targetloc
			end
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		local botTarget = J.GetProperTarget(bot)
		local nAllyHeroes = bot:GetNearbyHeroes(1200, false, BOT_MODE_NONE)

		if  J.IsValidTarget(botTarget)
		and J.CanCastOnMagicImmune(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange + nRadius)
		and not J.IsSuspiciousIllusion(botTarget)
		then
            if  nEnemyHeroes ~= nil and #nEnemyHeroes <= 1
			and nAllyHeroes ~= nil and #nAllyHeroes <= 1
            then
                if  J.IsCore(botTarget)
				and J.CanKillTarget(botTarget, nAttackDamage * nAttackSpeed * nDuration, DAMAGE_TYPE_PHYSICAL)
                then
					bot:SetTarget(botTarget)
                    return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
				elseif not J.IsCore(botTarget)
				and    nBotDeaths > nBotKills + 4
				then
					bot:SetTarget(botTarget)
					return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
                end
            end
		end
	end

	if J.IsRetreating(bot)
	then
		for _, enemyHero in pairs(nEnemyHeroes)
		do
			if  bot:WasRecentlyDamagedByHero(enemyHero, 2.0)
			and J.CanCastOnMagicImmune(enemyHero)
			and not J.IsSuspiciousIllusion(enemyHero)
			and not J.IsRealInvisible(bot)
			then
				local nAllyHeroes = bot:GetNearbyHeroes(nCastRange + 100, false, BOT_MODE_NONE)

				if  nAllyHeroes ~= nil
				and (#nAllyHeroes <= 1 and #nEnemyHeroes >= 3)
				then
					return BOT_ACTION_DESIRE_MODERATE, enemyHero:GetLocation()
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderTimeWalkReverse()
	if not TimeWalkReverse:IsTrained()
	or not TimeWalkReverse:IsFullyCastable()
	then
		return BOT_ACTION_DESIRE_NONE
	end

	local botTarget = J.GetProperTarget(bot)

	if  hasTimeWalked
	and not hasChronod
	and DotaTime() - timeSinceTimeWalked() < 1.5
	and J.IsValidTarget(botTarget)
	then
		return BOT_ACTION_DESIRE_MODERATE
	end

	return BOT_ACTION_DESIRE_NONE
end

--Helper Funcs
function IsAllowedToCast(manaCost)
	if  Chronosphere:IsTrained()
	and Chronosphere:IsFullyCastable()
	then
		local ultCost = Chronosphere:GetManaCost()
		if bot:GetMana() - manaCost <= ultCost
		then
			return true
		else
			return false
		end
	end

	return true
end

return X