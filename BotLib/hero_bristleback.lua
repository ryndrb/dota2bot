----------------------------------------------------------------------------------------------------
--- The Creation Come From: BOT EXPERIMENT Credit:FURIOUSPUPPY
--- BOT EXPERIMENT Author: Arizona Fauzie 2018.11.21
--- Link:http://steamcommunity.com/sharedfiles/filedetails/?id=837040016
--- Refactor: 决明子 Email: dota2jmz@163.com 微博@Dota2_决明子
--- Link:http://steamcommunity.com/sharedfiles/filedetails/?id=1573671599
--- Link:http://steamcommunity.com/sharedfiles/filedetails/?id=1627071163
----------------------------------------------------------------------------------------------------
local X = {}
local bDebugMode = ( 1 == 10 )
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

local tTalentTreeList = {
						{--pos1,2,3
							['t25'] = {0, 10},
							['t20'] = {10, 0},
							['t15'] = {10, 0},
							['t10'] = {10, 0},
						},
						{--pos1,2,3
							['t25'] = {0, 10},
							['t20'] = {10, 0},
							['t15'] = {10, 0},
							['t10'] = {0, 10},
						}
}

local tAllAbilityBuildList = {
						{2,3,2,3,2,6,2,3,3,1,6,1,1,1,6},--pos1,2,3
						{2,3,2,1,2,6,2,3,3,3,6,1,1,1,6},--pos1,2,3
}

local nAbilityBuildList = J.Skill.GetRandomBuild( tAllAbilityBuildList )

local nTalentBuildList = J.Skill.GetTalentBuild(J.Skill.GetRandomBuild(tTalentTreeList))

local sUtility = {"item_heavens_halberd", "item_lotus_orb"}
local nUtility = sUtility[RandomInt(1, #sUtility)]

local sRoleItemsBuyList = {}

sRoleItemsBuyList['pos_1'] = {
	"item_tango",
	"item_double_branches",
	"item_quelling_blade",

	"item_bracer",
	"item_arcane_boots",
	"item_vanguard",
	"item_magic_wand",
	"item_ultimate_scepter",
	"item_aghanims_shard",
	"item_bloodstone",--
	"item_kaya_and_sange",--
	"item_black_king_bar",--
	"item_assault",--
	"item_basher",
	"item_travel_boots_2",--
	"item_abyssal_blade",--
	"item_moon_shard",
}

sRoleItemsBuyList['pos_2'] = {
	"item_tango",
	"item_double_branches",
	"item_quelling_blade",

	"item_bracer",
	"item_bottle",
	"item_arcane_boots",
	"item_vanguard",
	"item_magic_wand",
	"item_ultimate_scepter",
	"item_aghanims_shard",
	"item_bloodstone",--
	"item_kaya_and_sange",--
	"item_black_king_bar",--
	"item_assault",--
	"item_basher",
	"item_travel_boots_2",--
	"item_abyssal_blade",--
	"item_moon_shard",
}

sRoleItemsBuyList['pos_3'] = {
	"item_tango",
	"item_double_branches",
	"item_quelling_blade",

	"item_bracer",
	"item_arcane_boots",
	"item_vanguard",
	"item_magic_wand",
	"item_ultimate_scepter",
	"item_aghanims_shard",
	"item_bloodstone",--
	"item_pipe",--
	nUtility,--
	"item_shivas_guard",--
	"item_black_king_bar",--
	"item_travel_boots",
	"item_ultimate_scepter_2",
	"item_travel_boots_2",--
	"item_moon_shard",
}

sRoleItemsBuyList['pos_4'] = sRoleItemsBuyList['pos_4']

sRoleItemsBuyList['pos_5'] = sRoleItemsBuyList['pos_5']

X['sBuyList'] = sRoleItemsBuyList[sRole]

Pos1SellList = {
	"item_quelling_blade",
	"item_bracer",
	"item_vanguard",
	"item_magic_wand",
}

Pos2SellList = {
	"item_quelling_blade",
	"item_bracer",
	"item_bottle",
	"item_vanguard",
	"item_magic_wand",
}

Pos3SellList = {
	"item_quelling_blade",
	"item_bracer",
	"item_vanguard",
	"item_magic_wand",
}

X['sSellList'] = {}

if sRole == "pos_1" then X['sSellList'] = Pos1SellList end
if sRole == "pos_2" then X['sSellList'] = Pos2SellList end
if sRole == "pos_3" then X['sSellList'] = Pos3SellList end

if J.Role.IsPvNMode() or J.Role.IsAllShadow() then X['sBuyList'], X['sSellList'] = { 'PvN_tank' }, {"item_power_treads", 'item_quelling_blade'} end

nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] = J.SetUserHeroInit( nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] )

X['sSkillList'] = J.Skill.GetSkillList( sAbilityList, nAbilityBuildList, sTalentList, nTalentBuildList )

X['bDeafaultAbility'] = false
X['bDeafaultItem'] = false

function X.MinionThink( hMinionUnit )

	if Minion.IsValidUnit( hMinionUnit )
	then
		Minion.IllusionThink( hMinionUnit )
	end

end

local abilityQ = bot:GetAbilityByName( sAbilityList[1] )
local abilityW = bot:GetAbilityByName( sAbilityList[2] )
local abilityAS = bot:GetAbilityByName( sAbilityList[4] )
local Bristleback = bot:GetAbilityByName( "bristleback_bristleback" )


local castQDesire, castQTarget
local castWDesire
local castASDesire, castASTarget
local BristlebackDesire, BristlebackLoc

local nKeepMana, nMP, nHP, nLV, hEnemyList, botTarget


function X.SkillsComplement()


	if J.CanNotUseAbility( bot ) or bot:IsInvisible() then return end


	nKeepMana = 180
	nMP = bot:GetMana()/bot:GetMaxMana()
	nHP = bot:GetHealth()/bot:GetMaxHealth()
	nLV = bot:GetLevel()
	botTarget = J.GetProperTarget( bot )
	hEnemyList = bot:GetNearbyHeroes( 1600, true, BOT_MODE_NONE )


	castASDesire, castASTarget = X.ConsiderAS()
	if ( castASDesire > 0 )
	then

		J.SetQueuePtToINT( bot, true )
	
		bot:ActionQueue_UseAbilityOnLocation( abilityAS, castASTarget )

		return
	end

	BristlebackDesire, BristlebackLoc = X.ConsiderBristleback()
	if (BristlebackDesire > 0 and bot:HasScepter())
	then
		bot:ActionQueue_UseAbilityOnLocation( Bristleback, BristlebackLoc )
		return
	end

	castQDesire, castQTarget = X.ConsiderQ()
	if ( castQDesire > 0 )
	then

		J.SetQueuePtToINT( bot, true )

		bot:ActionQueue_UseAbilityOnEntity( abilityQ, castQTarget )
		return
	end

	castWDesire = X.ConsiderW()
	if ( castWDesire > 0 )
	then

		J.SetQueuePtToINT( bot, true )

		bot:ActionQueue_UseAbility( abilityW )
		return
	end


end


function X.ConsiderQ()

	if ( not abilityQ:IsFullyCastable() ) then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nRadius = abilityQ:GetSpecialValueInt( 'radius_scepter' )
	local nCastRange = abilityQ:GetCastRange()
	local nCastPoint = abilityQ:GetCastPoint()
	local nManaCost = abilityQ:GetManaCost()

	local tableNearbyEnemyHeroes = bot:GetNearbyHeroes( nRadius, true, BOT_MODE_NONE )
	local nEnemyHeroes = bot:GetNearbyHeroes( 800, true, BOT_MODE_NONE )

	if J.IsRetreating( bot )
	then
		local npcEnemy = tableNearbyEnemyHeroes[1]
		if J.IsValid( npcEnemy )
		then
			if bot:HasScepter()
			then
				return BOT_ACTION_DESIRE_LOW, npcEnemy
			end

			if J.CanCastOnNonMagicImmune( npcEnemy )
				and J.CanCastOnTargetAdvanced( npcEnemy )
				and ( bot:IsFacingLocation( npcEnemy:GetLocation(), 10 ) or #nEnemyHeroes <= 1 )
				and ( bot:WasRecentlyDamagedByHero( npcEnemy, 2.0 ) or nLV >= 10 )
			then
				return BOT_ACTION_DESIRE_LOW, npcEnemy
			end
		end
	end

	if ( bot:GetActiveMode() == BOT_MODE_ROSHAN )
	then
		local npcTarget = bot:GetAttackTarget()
		if ( J.IsRoshan( npcTarget ) and J.CanCastOnMagicImmune( npcTarget ) and J.IsInRange( npcTarget, bot, nCastRange ) )
		then
			return BOT_ACTION_DESIRE_LOW, npcTarget
		end
	end

	if J.IsInTeamFight( bot, 1400 ) and bot:HasScepter()
	then
		if tableNearbyEnemyHeroes ~= nil
			and #tableNearbyEnemyHeroes >= 1
			and J.IsValidHero( tableNearbyEnemyHeroes[1] )
			and J.CanCastOnNonMagicImmune( tableNearbyEnemyHeroes[1] )
		then
			return BOT_ACTION_DESIRE_HIGH, tableNearbyEnemyHeroes[1]
		end
	end

	if J.IsGoingOnSomeone( bot )
	then
		local npcTarget = J.GetProperTarget( bot )
		if J.IsValidHero( npcTarget )
			and J.CanCastOnNonMagicImmune( npcTarget )
			and J.IsInRange( npcTarget, bot, nRadius )
			and J.CanCastOnTargetAdvanced( npcTarget )
		then
			return BOT_ACTION_DESIRE_ABSOLUTE, npcTarget
		end

		if J.IsValid( npcTarget )
			and #hEnemyList == 0
			and J.IsAllowedToSpam( bot, nManaCost )
			and J.CanCastOnNonMagicImmune( npcTarget )
			and J.CanCastOnTargetAdvanced( npcTarget )
			and J.IsInRange( npcTarget, bot, nRadius )
			and not J.CanKillTarget( npcTarget, bot:GetAttackDamage() * 1.68, DAMAGE_TYPE_PHYSICAL )
		then
			local nCreeps = bot:GetNearbyCreeps( 800, true )
			if #nCreeps >= 1
			then
				return BOT_ACTION_DESIRE_ABSOLUTE, npcTarget
			end
		end

	end

	return BOT_ACTION_DESIRE_NONE, 0

end


function X.ConsiderW()

	if not abilityW:IsFullyCastable() then
		return BOT_ACTION_DESIRE_NONE
	end

	local nRadius = abilityW:GetSpecialValueInt( "radius" )
	local nCastPoint = abilityW:GetCastPoint()
	local nManaCost = abilityW:GetManaCost()

	local tableNearbyEnemyHeroes = bot:GetNearbyHeroes( nRadius, true, BOT_MODE_NONE )

	if J.IsRetreating( bot ) and #tableNearbyEnemyHeroes > 0
	then
		for _, npcEnemy in pairs( tableNearbyEnemyHeroes )
		do
			if bot:WasRecentlyDamagedByHero( npcEnemy, 4.0 )
				or npcEnemy:HasModifier( "modifier_bristleback_quill_spray" )
			then
				return BOT_ACTION_DESIRE_MODERATE
			end
		end
	end

	if J.IsPushing( bot )
		or J.IsDefending( bot )
		or ( J.IsGoingOnSomeone( bot ) and nLV >= 6 )
	then
		local tableNearbyEnemyCreeps = bot:GetNearbyLaneCreeps( nRadius, true )
		if ( tableNearbyEnemyCreeps ~= nil and #tableNearbyEnemyCreeps >= 1 and J.IsAllowedToSpam( bot, nManaCost ) ) then
			return BOT_ACTION_DESIRE_MODERATE
		end
	end

	if J.IsFarming( bot ) and nLV > 5
		and J.IsAllowedToSpam( bot, nManaCost )
	then
		local npcTarget = J.GetProperTarget( bot )
		if J.IsValid( npcTarget )
			and npcTarget:GetTeam() == TEAM_NEUTRAL
		then
			if npcTarget:GetHealth() > bot:GetAttackDamage() * 2.28
			then
				return BOT_ACTION_DESIRE_HIGH
			end

			local nCreeps = bot:GetNearbyCreeps( nRadius, true )
			if ( #nCreeps >= 2 )
			then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if J.IsInTeamFight( bot, 1200 )
	then
		if #tableNearbyEnemyHeroes >= 1
		then
			return BOT_ACTION_DESIRE_LOW
		end
	end

	if J.IsGoingOnSomeone( bot )
	then
		local npcTarget = J.GetProperTarget( bot )
		if J.IsValidHero( npcTarget )
			and J.CanCastOnMagicImmune( npcTarget )
			and J.IsInRange( npcTarget, bot, nRadius-100 )
		then
			return BOT_ACTION_DESIRE_MODERATE
		end

		if J.IsValidHero( npcTarget )
			and J.IsAllowedToSpam( bot, nManaCost )
			and J.CanCastOnNonMagicImmune( npcTarget )
			and J.IsInRange( npcTarget, bot, nRadius )
		then
			local nCreeps = bot:GetNearbyCreeps( 800, true )
			if #nCreeps >= 1
			then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if ( bot:GetActiveMode() == BOT_MODE_ROSHAN )
	then
		local npcTarget = bot:GetAttackTarget()
		if ( J.IsRoshan( npcTarget ) and J.CanCastOnMagicImmune( npcTarget ) and J.IsInRange( bot, npcTarget, nRadius ) )
		then
			return BOT_ACTION_DESIRE_MODERATE
		end
	end

	if nMP > 0.95
		and nLV >= 6
		and bot:DistanceFromFountain() > 2400
		and J.IsAllowedToSpam( bot, nManaCost )
	then
		return BOT_ACTION_DESIRE_LOW
	end

	return BOT_ACTION_DESIRE_NONE

end

function X.ConsiderAS()

	if not abilityAS:IsTrained()
		or not abilityAS:IsFullyCastable() 
	then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nRadius = 700
	local nCastRange = abilityAS:GetCastRange()
	local nCastPoint = abilityAS:GetCastPoint()
	local nManaCost = abilityAS:GetManaCost()

	if J.IsRetreating( bot )
	then
		local enemyHeroList = bot:GetNearbyHeroes( nRadius, true, BOT_MODE_NONE )
		local targetHero = enemyHeroList[1]
		if J.IsValidHero( targetHero )
			and J.CanCastOnNonMagicImmune( targetHero )
		then
			return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
		end		
	end
	

	if J.IsInTeamFight( bot, 1400 )
	then
		local nAoeLoc = J.GetAoeEnemyHeroLocation( bot, nCastRange, nRadius, 2 )
		if nAoeLoc ~= nil
		then
			return BOT_ACTION_DESIRE_HIGH, nAoeLoc
		end		
	end
	

	if J.IsGoingOnSomeone( bot )
	then
		local targetHero = J.GetProperTarget( bot )
		if J.IsValidHero( targetHero )
			and J.IsInRange( bot, targetHero, nCastRange )
			and J.CanCastOnNonMagicImmune( targetHero )
		then
			return BOT_ACTION_DESIRE_HIGH, targetHero:GetLocation()
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0

end

function X.ConsiderBristleback()
	if not Bristleback:IsTrained()
	or not Bristleback:IsFullyCastable()
	then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	if J.IsInTeamFight( bot, 1400 )
	then
		local nAoeLoc = J.GetAoeEnemyHeroLocation( bot, 700, 700, 2 )
		if nAoeLoc ~= nil
		then
			return BOT_ACTION_DESIRE_HIGH, nAoeLoc
		end
	end

	if J.IsGoingOnSomeone( bot )
	then
		local targetHero = J.GetProperTarget( bot )
		if J.IsValidHero( targetHero )
		and J.IsInRange( bot, targetHero, 700 )
		and J.CanCastOnNonMagicImmune( targetHero )
		then
			return BOT_ACTION_DESIRE_HIGH, targetHero:GetLocation()
		end
	end

	if J.IsRetreating( bot )
	then
		local nEnemyHeroes = bot:GetNearbyHeroes( 700, true, BOT_MODE_NONE )
		if nEnemyHeroes ~= nil and #nEnemyHeroes > 0
		then
			local targetHero = nEnemyHeroes[1]
			if J.IsValidHero( targetHero )
			and J.CanCastOnNonMagicImmune( targetHero )
			then
				return BOT_ACTION_DESIRE_MODERATE, targetHero:GetLocation()
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

return X
-- dota2jmz@163.com QQ:2462331592..
