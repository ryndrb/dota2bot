local X = {}
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

if J.Role.IsPvNMode() or J.Role.IsAllShadow() then X['sBuyList'], X['sSellList'] = { 'PvN_melee_carry' }, {"item_power_treads", 'item_quelling_blade'} end

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
local abilityR = bot:GetAbilityByName( sAbilityList[6] )
local BloodMist = bot:GetAbilityByName( 'bloodseeker_blood_mist' )

local castQDesire, castQTarget = 0
local castWDesire, castWLocation = 0
local castRDesire, castRTarget = 0
local BloodMistDesire

local nKeepMana, nMP, nHP, nLV, hEnemyHeroList


function X.SkillsComplement()



	if J.CanNotUseAbility( bot ) or bot:IsInvisible() then return end



	nKeepMana = 300
	nMP = bot:GetMana()/bot:GetMaxMana()
	nHP = bot:GetHealth()/bot:GetMaxHealth()
	nLV = bot:GetLevel()
	hEnemyHeroList = bot:GetNearbyHeroes( 1600, true, BOT_MODE_NONE )


	BloodMistDesire = X.ConsiderBloodMist()
	if (BloodMistDesire > 0)
	then
		bot:Action_ClearActions( false )
		bot:ActionQueue_UseAbility(BloodMist)
		return
	end


	castRDesire, castRTarget = X.ConsiderR()
	if ( castRDesire > 0 )
	then

		J.SetQueuePtToINT( bot, false )

		bot:ActionQueue_UseAbilityOnEntity( abilityR, castRTarget )
		return

	end

	castQDesire, castQTarget = X.ConsiderQ()
	if ( castQDesire > 0 )
	then

		bot:Action_ClearActions( false )

		bot:ActionQueue_UseAbilityOnEntity( abilityQ, castQTarget )
		return

	end

	castWDesire, castWLocation = X.ConsiderW()
	if ( castWDesire > 0 )
	then

		J.SetQueuePtToINT( bot, false )

		bot:ActionQueue_UseAbilityOnLocation( abilityW, castWLocation )
		return
	end


end

function X.ConsiderBloodMist()

	if not bot:HasScepter()
	or not BloodMist:IsFullyCastable()
	then
		return BOT_MODE_NONE
	end

	local nRadius = 450
	local nInRangeEnemyHeroList = bot:GetNearbyHeroes(nRadius, true, BOT_MODE_NONE)
	local botTarget = J.GetProperTarget(bot)

	if BloodMist:GetToggleState() == true
	then
		if nHP < 0.2
		then
			return BOT_ACTION_DESIRE_HIGH
		end

		if #nInRangeEnemyHeroList == 0
		then
			return BOT_ACTION_DESIRE_ABSOLUTE
		end
	end

	if not BloodMist:GetToggleState() == false
	and nHP > 0.5
	then
		if J.IsValidHero(botTarget)
		and J.IsInRange(bot, botTarget, nRadius * 0.8)
		and J.CanCastOnNonMagicImmune(botTarget)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	return BOT_MODE_NONE
end

function X.ConsiderQ()

	if not abilityQ:IsFullyCastable() then return 0 end

	local nCastRange = abilityQ:GetCastRange()
	local nCastPoint = abilityQ:GetCastPoint()
	local nManaCost = abilityQ:GetManaCost()
	local nDamage = bot:GetAttackDamage()

	local npcTarget = J.GetProperTarget( bot )


	
	--团战时辅助
	if J.IsInTeamFight( bot, 1200 ) or J.IsPushing( bot ) or J.IsDefending( bot )
	then
		local tableNearbyEnemyHeroes = bot:GetNearbyHeroes( 1200, true, BOT_MODE_NONE )

		if #tableNearbyEnemyHeroes >= 1 then
			local tableNearbyAllyHeroes = bot:GetNearbyHeroes( nCastRange + 200, false, BOT_MODE_NONE )
			local highesAD = 0
			local highesADUnit = nil

			for _, npcAlly in pairs( tableNearbyAllyHeroes )
			do
				local AllyAD = npcAlly:GetAttackDamage()
				if ( J.IsValid( npcAlly )
					and npcAlly:GetAttackTarget() ~= nil
					and J.CanCastOnNonMagicImmune( npcAlly )
					and ( J.GetHP( npcAlly ) > 0.18 or J.GetHP( npcAlly:GetAttackTarget() ) < 0.18 )
					and not npcAlly:HasModifier( 'modifier_bloodseeker_bloodrage' )
					and AllyAD > highesAD )
				then
					highesAD = AllyAD
					highesADUnit = npcAlly
				end
			end

			if highesADUnit ~= nil then
				return BOT_ACTION_DESIRE_HIGH, highesADUnit
			end

		end

	end

	if J.IsGoingOnSomeone( bot )
	then
		local npcTarget = J.GetProperTarget( bot )
		if J.IsValidHero( npcTarget )
			and J.CanCastOnMagicImmune( npcTarget )
			and J.IsInRange( npcTarget, bot, 600 )
		then
			if not bot:HasModifier( 'modifier_bloodseeker_bloodrage' )
			then
				return BOT_ACTION_DESIRE_HIGH, bot
			end
		end
	end
	
	--打野时加速
	if J.IsValid( npcTarget ) and npcTarget:GetTeam() == TEAM_NEUTRAL
		and not bot:HasModifier( 'modifier_bloodseeker_bloodrage' )
	then
		local tableNearbyCreeps = bot:GetNearbyCreeps( 1000, true )
		for _, ECreep in pairs( tableNearbyCreeps )
		do
			if J.IsValid( ECreep ) and not J.CanKillTarget( ECreep, nDamage, DAMAGE_TYPE_PHYSICAL ) 
			then
				return BOT_ACTION_DESIRE_HIGH, bot
			end
		end
	end


	--打肉时加速
	if ( bot:GetActiveMode() == BOT_MODE_ROSHAN )
	then
		if not bot:HasModifier( 'modifier_bloodseeker_bloodrage' )
			and bot:GetAttackTarget() ~= nil
		then
			return BOT_ACTION_DESIRE_HIGH, bot
		end
	end


	return BOT_ACTION_DESIRE_NONE, 0

end

function X.ConsiderW()

	if not abilityW:IsFullyCastable()  then return 0 end

	local nRadius = 600
	local nCastRange = abilityW:GetCastRange()
	local nCastPoint = abilityW:GetCastPoint()
	local nDelay = abilityW:GetSpecialValueFloat( 'delay' )
	local nManaCost = abilityW:GetManaCost()
	local nDamage = abilityW:GetSpecialValueInt( 'damage' )

	local tableNearbyEnemyHeroes = bot:GetNearbyHeroes( nCastRange, true, BOT_MODE_NONE )
	local tableNearbyAllyHeroes = bot:GetNearbyHeroes( 800, false, BOT_MODE_NONE )

	for _, npcEnemy in pairs( tableNearbyEnemyHeroes )
	do
		if J.IsValid( npcEnemy ) and J.CanCastOnNonMagicImmune( npcEnemy ) and J.CanKillTarget( npcEnemy, nDamage, DAMAGE_TYPE_PURE )
		then
			if npcEnemy:GetMovementDirectionStability() >= 0.75 then
				return BOT_ACTION_DESIRE_HIGH, npcEnemy:GetExtrapolatedLocation( nDelay )
			else
				return BOT_ACTION_DESIRE_HIGH, npcEnemy:GetLocation()
			end
		end
	end

	--对线期补兵
	if bot:GetActiveMode() == BOT_MODE_LANING and J.IsAllowedToSpam( bot, nManaCost )
	then
		local locationAoE = bot:FindAoELocation( true, false, bot:GetLocation(), 1000, nRadius/2, nCastPoint, nDamage )
		if ( locationAoE.count >= 4 )
		then
			return BOT_ACTION_DESIRE_MODERATE, locationAoE.targetloc
		end
	end

	--推进带线
	if ( J.IsPushing( bot ) or J.IsDefending( bot ) ) and J.IsAllowedToSpam( bot, nManaCost )
		and tableNearbyEnemyHeroes == nil or #tableNearbyEnemyHeroes == 0
		and #tableNearbyAllyHeroes <= 2
	then
		local lanecreeps = bot:GetNearbyLaneCreeps( 1000, true )
		local locationAoE = bot:FindAoELocation( true, false, bot:GetLocation(), 1000, nRadius/2, nCastPoint, nDamage )
		if ( locationAoE.count >= 4 and #lanecreeps >= 4 )
		then
			return BOT_ACTION_DESIRE_MODERATE, locationAoE.targetloc
		end
	end

	if J.IsRetreating( bot )
	then
		for _, npcEnemy in pairs( tableNearbyEnemyHeroes )
		do
			if ( J.IsValid( npcEnemy ) and bot:WasRecentlyDamagedByHero( npcEnemy, 1.0 ) and J.CanCastOnNonMagicImmune( npcEnemy ) )
			then
				return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
			end
		end
	end

	--团战
	if J.IsInTeamFight( bot, 1200 )
	then
		local locationAoE = bot:FindAoELocation( true, true, bot:GetLocation(), nCastRange - 200, nRadius/2, nCastPoint, 0 )
		if ( locationAoE.count >= 2 )
		then
			local nInvUnit = J.GetInvUnitInLocCount( bot, nCastRange, nRadius/2, locationAoE.targetloc, false )
			if nInvUnit >= locationAoE.count then
				return BOT_ACTION_DESIRE_MODERATE, locationAoE.targetloc
			end
		end
	end

	if J.IsGoingOnSomeone( bot )
	then
		local npcTarget = J.GetProperTarget( bot )
		if J.IsValidHero( npcTarget )
			and J.CanCastOnNonMagicImmune( npcTarget )
			and J.IsInRange( npcTarget, bot, nCastRange + nRadius )
		then
			local nCastLoc = J.GetDelayCastLocation( bot, npcTarget, nCastRange, nRadius, 2.0 )
			if nCastLoc ~= nil
			then
				return BOT_ACTION_DESIRE_HIGH, nCastLoc
			end
		end
	end

	--特殊用法
	local skThere, skLoc = J.IsSandKingThere( bot, nCastRange, 2.0 )
	if skThere then
		return BOT_ACTION_DESIRE_MODERATE, skLoc
	end

	return BOT_ACTION_DESIRE_NONE, 0

end

function X.ConsiderR()

	if not abilityR:IsFullyCastable() then 	return 0 end

	local nCastRange = abilityR:GetCastRange()
	local nCastPoint = abilityR:GetCastPoint()
	local nManaCost = abilityR:GetManaCost()

	local tableNearbyEnemyHeroes = bot:GetNearbyHeroes( nCastRange + 200, true, BOT_MODE_NONE )

	if J.IsRetreating( bot )
	then
		for _, npcEnemy in pairs( tableNearbyEnemyHeroes )
		do
			if bot:WasRecentlyDamagedByHero( npcEnemy, 1.0 )
				and J.CanCastOnNonMagicImmune( npcEnemy )
				and J.CanCastOnTargetAdvanced( npcEnemy )
				and not npcEnemy:HasModifier( 'modifier_bloodseeker_bloodrage' )
			then
				return BOT_ACTION_DESIRE_MODERATE, npcEnemy
			end
		end
	end

	if J.IsInTeamFight( bot, 1200 )
	then
		for _, npcEnemy in pairs( tableNearbyEnemyHeroes )
		do
			if J.CanCastOnNonMagicImmune( npcEnemy )
				and J.CanCastOnTargetAdvanced( npcEnemy )
				and J.Role.IsCarry( npcEnemy:GetUnitName() )
				and not npcEnemy:HasModifier( 'modifier_bloodseeker_bloodrage' )
				and not J.IsDisabled( npcEnemy )
			then
				return BOT_ACTION_DESIRE_HIGH, npcEnemy
			end
		end
	end

	if J.IsGoingOnSomeone( bot )
	then
		local npcTarget = J.GetProperTarget( bot )
		if J.IsValidHero( npcTarget )
			and J.CanCastOnNonMagicImmune( npcTarget )
			and J.CanCastOnTargetAdvanced( npcTarget )
			and J.IsInRange( npcTarget, bot, nCastRange + 100 )
			and not npcTarget:HasModifier( 'modifier_bloodseeker_bloodrage' )
			and not J.IsDisabled( npcTarget )
		then
			local allies = npcTarget:GetNearbyHeroes( 1200, true, BOT_MODE_NONE )
			if ( allies ~= nil and #allies >= 2 )
			then
				return BOT_ACTION_DESIRE_HIGH, npcTarget
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0

end


return X
-- dota2jmz@163.com QQ:2462331592..
