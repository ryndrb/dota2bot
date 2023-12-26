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
						['t20'] = {10, 0},
						['t15'] = {0, 10},
						['t10'] = {0, 10},
}

local tAllAbilityBuildList = {
						{3,1,3,2,3,6,3,2,2,2,6,1,1,1,6},--pos1
}

local nAbilityBuildList = J.Skill.GetRandomBuild( tAllAbilityBuildList )

local nTalentBuildList = J.Skill.GetTalentBuild( tTalentTreeList )

local tOutFitList = {}

tOutFitList['outfit_carry'] = {
	"item_tango",
    "item_double_branches",
    "item_faerie_fire",
    "item_quelling_blade",

    "item_phase_boots",
    "item_magic_wand",
    "item_bfury",--
    "item_blink",
    "item_basher",
    "item_black_king_bar",--
    "item_abyssal_blade",--
    "item_ultimate_scepter",
    "item_monkey_king_bar",--
    "item_swift_blink",--
    "item_ultimate_scepter_2",
    "item_travel_boots",
    "item_moon_shard",
    "item_aghanims_shard",
    "item_travel_boots_2",--
}

tOutFitList['outfit_mid'] = tOutFitList['outfit_carry']

tOutFitList['outfit_priest'] = tOutFitList['outfit_carry']

tOutFitList['outfit_mage'] = tOutFitList['outfit_carry']

tOutFitList['outfit_tank'] = tOutFitList['outfit_carry']

X['sBuyList'] = tOutFitList[sOutfitType]

X['sSellList'] = {
    "item_quelling_blade",
    -- "item_phase_boots",

    "item_magic_wand",
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

local Earthshock    = bot:GetAbilityByName( "ursa_earthshock" )
local Overpower     = bot:GetAbilityByName( "ursa_overpower" )
local Enrage        = bot:GetAbilityByName( "ursa_enrage" )


local EarthshockDesire
local OverpowerDesire
local EnrageDesire

function X.SkillsComplement()
    if J.CanNotUseAbility(bot) then return end

    EarthshockDesire    = X.ConsiderEarthshock();
	OverpowerDesire     = X.ConsiderOverpower();
	EnrageDesire        = X.ConsiderEnrage();

    if (EnrageDesire > 0) 
	then
		bot:Action_UseAbility(Enrage)
		return
	end

	if (EarthshockDesire > 0)
	then
		bot:Action_UseAbility(Earthshock)
		return
	end
	
	if (OverpowerDesire > 0)
	then
		bot:Action_UseAbility(Overpower)
		return
	end
end

function X.ConsiderEarthshock()
	if ( not Earthshock:IsFullyCastable() ) then 
		return BOT_ACTION_DESIRE_NONE
	end

	local nRadius = Earthshock:GetSpecialValueInt( "shock_radius" )
	local nCastRange = 0
	local nDamage = Earthshock:GetAbilityDamage()

	if J.IsRetreating(bot)
	then
		local tableNearbyEnemyHeroes = bot:GetNearbyHeroes( 2*nRadius, true, BOT_MODE_NONE )
		if ( #tableNearbyEnemyHeroes > 0 and ( bot:WasRecentlyDamagedByAnyHero(2.0) or bot:WasRecentlyDamagedByTower(2.0) ) ) 
		then
			local loc = J.GetEscapeLoc()
			if bot:IsFacingLocation(loc, 15) then
				return BOT_ACTION_DESIRE_MODERATE
			end
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		local npcTarget = bot:GetTarget()
		if J.IsValidTarget(npcTarget) and J.CanCastOnNonMagicImmune(npcTarget) and J.IsInRange(npcTarget, bot, nRadius)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	return BOT_ACTION_DESIRE_NONE

end

function X.ConsiderOverpower()
	if ( not Overpower:IsFullyCastable() ) then 
		return BOT_ACTION_DESIRE_NONE;
	end
	
	if J.IsPushing(bot) and bot:GetMana() / bot:GetMaxMana() >= 0.65 
	then
		local tableNearbyEnemyTowers = bot:GetNearbyTowers( 800, true )
		if tableNearbyEnemyTowers ~= nil and #tableNearbyEnemyTowers >= 1 and tableNearbyEnemyTowers[1] ~= nil and
		   J.IsInRange(tableNearbyEnemyTowers[1], bot, 300)
		then
			return BOT_ACTION_DESIRE_MODERATE
		end
	end
	
	if J.IsFarming(bot)
	then
		local npcTarget = bot:GetAttackTarget()
		if npcTarget ~= nil then
			return BOT_ACTION_DESIRE_HIGH
		end
	end	
	
	if ( bot:GetActiveMode() == BOT_MODE_ROSHAN  )
	then
		local npcTarget = bot:GetAttackTarget()
		if ( J.IsRoshan(npcTarget) and J.CanCastOnMagicImmune(npcTarget) and J.IsInRange(npcTarget, bot, 300)  )
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end
	
	if J.IsGoingOnSomeone(bot)
	then
		local npcTarget = bot:GetTarget()
		if J.IsValidTarget(npcTarget) and J.CanCastOnMagicImmune(npcTarget) and J.IsInRange(npcTarget, bot, 400) 
		then
			return BOT_ACTION_DESIRE_MODERATE
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderEnrage()
	if ( not Enrage:IsFullyCastable() ) then 
		return BOT_ACTION_DESIRE_NONE
	end
	
	if J.IsRetreating(bot)
	then
		local tableNearbyEnemyHeroes = bot:GetNearbyHeroes( 800, true, BOT_MODE_NONE );
		for _,npcEnemy in pairs( tableNearbyEnemyHeroes )
		do
			if ( bot:WasRecentlyDamagedByHero( npcEnemy, 2.0 ) ) 
			then
				return BOT_ACTION_DESIRE_MODERATE
			end
		end
	end
	
	if  J.IsFarming(bot) and bot:GetHealth()/bot:GetMaxHealth() < 0.20
	then
		local npcTarget = bot:GetAttackTarget()
		if npcTarget ~= nil then
			return BOT_ACTION_DESIRE_MODERATE
		end
	end	
	
	if ( bot:GetActiveMode() == BOT_MODE_ROSHAN  ) and bot:GetHealth()/bot:GetMaxHealth() < 0.65
	then
		local npcTarget = bot:GetAttackTarget()
		if ( J.IsRoshan(npcTarget) and J.CanCastOnMagicImmune(npcTarget) and J.IsInRange(npcTarget, bot, 300)  )
		then
			return BOT_ACTION_DESIRE_MODERATE
		end
	end
	
	if J.IsGoingOnSomeone(bot) and bot:GetHealth()/bot:GetMaxHealth() < 0.65
	then
		local npcTarget = bot:GetTarget()
		if J.IsValidTarget(npcTarget) and J.CanCastOnMagicImmune(npcTarget) and J.IsInRange(npcTarget, bot, 300) 
		then
			return BOT_ACTION_DESIRE_MODERATE
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

return X