local X = {}
local bDebugMode = ( 1 == 10 )
local bot = GetBot()

local Hero = require(GetScriptDirectory()..'/FunLib/bot_builds/'..string.gsub(bot:GetUnitName(), 'npc_dota_hero_', ''))
local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

local nTalentBuildList = J.Skill.GetTalentBuild(Hero.TalentBuild[sRole][RandomInt(1, #Hero.TalentBuild[sRole])])
local nAbilityBuildList = Hero.AbilityBuild[sRole][RandomInt(1, #Hero.AbilityBuild[sRole])]

local sRand = RandomInt(1, #Hero.BuyList[sRole])
X['sBuyList'] = Hero.BuyList[sRole][sRand]
X['sSellList'] = Hero.SellList[sRole][sRand]

if J.Role.IsPvNMode() or J.Role.IsAllShadow() then X['sBuyList'], X['sSellList'] = { 'PvN_tank' }, {"item_power_treads", 'item_quelling_blade'} end

nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] = J.SetUserHeroInit( nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] )

X['sSkillList'] = J.Skill.GetSkillList( sAbilityList, nAbilityBuildList, sTalentList, nTalentBuildList )


X['bDeafaultAbility'] = true
X['bDeafaultItem'] = false

function X.MinionThink( hMinionUnit )

	if Minion.IsValidUnit( hMinionUnit )
	then
		Minion.IllusionThink( hMinionUnit )
	end

end

local abilityQ = bot:GetAbilityByName( sAbilityList[1] )
local abilityW = bot:GetAbilityByName( sAbilityList[2] )
local abilityR = bot:GetAbilityByName( sAbilityList[6] )
local talent6 = bot:GetAbilityByName( sTalentList[6] )
local abilityArmlet = nil

local castQDesire, castQTarget = 0
local castWDesire, castWTarget = 0
local castRDesire = 0


local nKeepMana, nMP, nHP, nLV, hEnemyHeroList


function X.SkillsComplement()

	if J.CanNotUseAbility( bot ) or bot:IsInvisible() then return end

	nKeepMana = 240
	nMP = bot:GetMana()/bot:GetMaxMana()
	nHP = bot:GetHealth()/bot:GetMaxHealth()
	nLV = bot:GetLevel()
	hEnemyHeroList = bot:GetNearbyHeroes( 1600, true, BOT_MODE_NONE )
	abilityArmlet = J.IsItemAvailable( "item_armlet" )

	castRDesire = X.ConsiderR()
	if ( castRDesire > 0 )
	then

		if abilityArmlet ~= nil
			and abilityArmlet:IsFullyCastable()
			and abilityArmlet:GetToggleState() == false
		then
			bot:ActionQueue_UseAbility( abilityArmlet )
		end

		bot:ActionQueue_UseAbility( abilityR )
		return
	end

	castWDesire, castWTarget = X.ConsiderW()
	if ( castWDesire > 0 )
	then

		J.SetQueuePtToINT( bot, false )

		bot:ActionQueue_UseAbilityOnEntity( abilityW, castWTarget )
		return
	end

	castQDesire, castQTarget = X.ConsiderQ()
	if ( castQDesire > 0 )
	then

		J.SetQueuePtToINT( bot, true )

		bot:ActionQueue_UseAbilityOnEntity( abilityQ, castQTarget )
		return
	end



end

function X.ConsiderQ()

	if not abilityQ:IsFullyCastable() then return BOT_ACTION_DESIRE_NONE end

	local nCastRange = abilityQ:GetCastRange()
	local nCastPoint = abilityQ:GetCastPoint()
	local nSkillLV = abilityQ:GetLevel()
	local nDamage = 30 + nSkillLV * 30 + 120 * 0.38

	local nEnemysHeroesInCastRange = bot:GetNearbyHeroes( nCastRange + 99, true, BOT_MODE_NONE )
	local nEnemysHeroesInView = bot:GetNearbyHeroes( 880, true, BOT_MODE_NONE )

	--击杀
	if #nEnemysHeroesInCastRange > 0 then
		for i=1, #nEnemysHeroesInCastRange do
			if J.IsValid( nEnemysHeroesInCastRange[i] )
				and J.CanCastOnNonMagicImmune( nEnemysHeroesInCastRange[i] )
				and J.CanCastOnTargetAdvanced( nEnemysHeroesInCastRange[i] )
				and nEnemysHeroesInCastRange[i]:GetHealth() < nEnemysHeroesInCastRange[i]:GetActualIncomingDamage( nDamage, DAMAGE_TYPE_MAGICAL )
				and not ( GetUnitToUnitDistance( nEnemysHeroesInCastRange[i], bot ) <= bot:GetAttackRange() + 60 )
				and not J.IsDisabled( nEnemysHeroesInCastRange[i] )
			then
				return BOT_ACTION_DESIRE_HIGH, nEnemysHeroesInCastRange[i]
			end
		end
	end

	--打断
	if #nEnemysHeroesInView > 0 then
		for i=1, #nEnemysHeroesInView do
			if J.IsValid( nEnemysHeroesInView[i] )
				and J.CanCastOnNonMagicImmune( nEnemysHeroesInView[i] )
				and J.CanCastOnTargetAdvanced( nEnemysHeroesInView[i] )
				and nEnemysHeroesInView[i]:IsChanneling()
			then
				return BOT_ACTION_DESIRE_HIGH, nEnemysHeroesInView[i]
			end
		end
	end


	--团战
	if J.IsInTeamFight( bot, 1200 )
		and DotaTime() > 4 * 60
	then
		local npcMostDangerousEnemy = nil
		local nMostDangerousDamage = 0

		for _, npcEnemy in pairs( nEnemysHeroesInCastRange )
		do
			if J.IsValid( npcEnemy )
				and J.CanCastOnNonMagicImmune( npcEnemy )
				and J.CanCastOnTargetAdvanced( npcEnemy )
				and not J.IsDisabled( npcEnemy )
				and not npcEnemy:IsDisarmed()
			then
				local npcEnemyDamage = npcEnemy:GetEstimatedDamageToTarget( false, bot, 3.0, DAMAGE_TYPE_ALL )
				if ( npcEnemyDamage > nMostDangerousDamage )
				then
					nMostDangerousDamage = npcEnemyDamage
					npcMostDangerousEnemy = npcEnemy
				end
			end
		end

		if ( npcMostDangerousEnemy ~= nil )
		then
			return BOT_ACTION_DESIRE_HIGH, npcMostDangerousEnemy
		end
	end


	--常规
	if J.IsGoingOnSomeone( bot )
	then
		local target = J.GetProperTarget( bot )
		if J.IsValidHero( target )
			and J.CanCastOnNonMagicImmune( target )
			and J.CanCastOnTargetAdvanced( target )
			and J.IsInRange( target, bot, nCastRange )
			and not J.IsDisabled( target )
			and not target:IsDisarmed()
		then
			return BOT_ACTION_DESIRE_HIGH, target
		end
	end

	--对线期间


	if J.IsRetreating( bot )
	then
		if J.IsValid( nEnemysHeroesInCastRange[1] )
			and J.CanCastOnNonMagicImmune( nEnemysHeroesInCastRange[1] )
			and J.CanCastOnTargetAdvanced( nEnemysHeroesInCastRange[1] )
			and not J.IsDisabled( nEnemysHeroesInCastRange[1] )
			and not nEnemysHeroesInCastRange[1]:IsDisarmed()
			and GetUnitToUnitDistance( bot, nEnemysHeroesInCastRange[1] ) <= nCastRange - 60
		then
			return BOT_ACTION_DESIRE_HIGH, nEnemysHeroesInCastRange[1]
		end
	end


	if bot:GetActiveMode() == BOT_MODE_ROSHAN
		and bot:GetMana() > 400
	then
		local target =  bot:GetAttackTarget()

		if target ~= nil and target:IsAlive()
			and J.GetHP( target ) > 0.2
			and not J.IsDisabled( target )
			and not target:IsDisarmed()
		then
			return BOT_ACTION_DESIRE_LOW, target
		end
	end

	return BOT_ACTION_DESIRE_NONE
end


function X.ConsiderW()

	if not abilityW:IsFullyCastable() or bot:IsRooted() then return BOT_ACTION_DESIRE_NONE end

	local nCastRange = abilityW:GetCastRange()
	local nCastPoint = abilityW:GetCastPoint()
	local nSkillLV = abilityW:GetLevel()
	local nDamage = 0
	local bIgnoreMagicImmune = talent6:IsTrained()

	local nEnemysHeroesInCastRange = bot:GetNearbyHeroes( nCastRange, true, BOT_MODE_NONE )


	if J.IsGoingOnSomeone( bot )
	then
		local target = J.GetProperTarget( bot )
		if J.IsValidHero( target )
			and J.IsInRange( target, bot, nCastRange + 50 )
			and ( not J.IsInRange( bot, target, 200 ) or not target:HasModifier( 'modifier_chaos_knight_reality_rift' ) )
			and J.CanCastOnNonMagicImmune( target )
			and J.CanCastOnTargetAdvanced( target )
			and not J.IsDisabled( target )
		then
			return BOT_ACTION_DESIRE_HIGH, target
		end
	end


	if J.IsRetreating( bot )
	then
		local enemies = bot:GetNearbyHeroes( 800, true, BOT_MODE_NONE )
		local creeps = bot:GetNearbyLaneCreeps( nCastRange, true )

		if enemies[1] ~= nil and creeps[1] ~= nil
		then
			for _, creep in pairs( creeps )
			do
				if enemies[1]:IsFacingLocation( bot:GetLocation(), 30 )
					and bot:IsFacingLocation( creep:GetLocation(), 30 )
					and GetUnitToUnitDistance( bot, creep ) >= 650
				then
					return BOT_ACTION_DESIRE_LOW, creep
				end
			end
		end
	end


	if hEnemyHeroList[1] == nil
		and bot:GetAttackDamage() >= 150
	then
		local nCreeps = bot:GetNearbyLaneCreeps( 1000, true )
		for i=1, #nCreeps
		do
			local creep = nCreeps[#nCreeps -i + 1]
			if J.IsValid( creep )
				and not creep:HasModifier( "modifier_fountain_glyph" )
				and J.IsKeyWordUnit( "ranged", creep )
				and GetUnitToUnitDistance( bot, creep ) >= 350
			then
				return BOT_ACTION_DESIRE_LOW, creep
			end
		end
	end

	if bot:GetActiveMode() == BOT_MODE_ROSHAN
		and bot:GetMana() > 400
	then
		local target =  bot:GetAttackTarget()
		if target ~= nil
			and not J.IsDisabled( target )
			and not target:IsDisarmed()
		then
			return BOT_ACTION_DESIRE_LOW, target
		end
	end

	return BOT_ACTION_DESIRE_NONE

end

function X.ConsiderR()

	if not abilityR:IsFullyCastable() or bot:DistanceFromFountain() < 500 then return BOT_ACTION_DESIRE_NONE end

	local nNearbyAllyHeroes = J.GetAlliesNearLoc( bot:GetLocation(), 1200 )
	local nNearbyEnemyHeroes = J.GetEnemyList( bot, 1600 )
	local nNearbyEnemyTowers = bot:GetNearbyTowers( 700, true )
	local nNearbyEnemyBarracks = bot:GetNearbyBarracks( 400, true )
	local nNearbyAlliedCreeps = bot:GetNearbyLaneCreeps( 1000, false )
	local nCastRange = abilityW:IsFullyCastable() and 1200 or 900

	-- if #nNearbyAllyHeroes + #nNearbyEnemyHeroes >= 3
		-- and  #hEnemyHeroList - #nNearbyAllyHeroes <= 2
		-- and  ( #nNearbyEnemyHeroes >= 2 or ( #hEnemyHeroList <= 1 and #nNearbyEnemyHeroes >= 1 ) )
	-- then
	  	-- return BOT_ACTION_DESIRE_HIGH
	-- end

	if J.IsGoingOnSomeone( bot )
	then
		local botTarget = J.GetProperTarget( bot )
		if J.IsValidHero( botTarget )
			and J.IsInRange( bot, botTarget, nCastRange )
			and J.CanCastOnMagicImmune( botTarget )
			--and #nNearbyAllyHeroes - #nNearbyEnemyHeroes <= 2
			and ( J.GetHP( botTarget ) > 0.5
				  or nHP < 0.7
				  or #nNearbyEnemyHeroes >= 2 )

		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end


	if J.IsInTeamFight( bot, 1200 )
	then
		if #nNearbyEnemyHeroes >= 2
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end


	if J.IsPushing( bot )
		and DotaTime() > 8 * 30
	then
		if ( #nNearbyEnemyTowers >= 1 or #nNearbyEnemyBarracks >= 1 )
			and #nNearbyAlliedCreeps >= 2
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end


	if bot:GetActiveMode() == BOT_MODE_RETREAT
		and nHP >= 0.5
		and J.IsValidHero( nNearbyEnemyHeroes[1] )
		and GetUnitToUnitDistance( bot, nNearbyEnemyHeroes[1] ) <= 700
	then
		return BOT_ACTION_DESIRE_HIGH
	end

	return BOT_ACTION_DESIRE_NONE
end


return X
-- dota2jmz@163.com QQ:2462331592..
