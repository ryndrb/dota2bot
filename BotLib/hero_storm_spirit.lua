-- Credit goes to Furious Puppy for Bot Experiment

local X = {}
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
						{1,3,2,1,1,6,1,3,3,3,6,2,2,2,6},--pos2
}

local nAbilityBuildList = J.Skill.GetRandomBuild( tAllAbilityBuildList )

local nTalentBuildList = J.Skill.GetTalentBuild( tTalentTreeList )

local tOutFitList = {}

tOutFitList['outfit_mid'] = {
    "item_tango",
	"item_double_branches",
	"item_faerie_fire",

	"item_bottle",
	"item_boots",
	"item_falcon_blade",
    "item_power_treads",
    "item_magic_wand",
    "item_witch_blade",
    "item_kaya_and_sange",--
	"item_parasma",--
    "item_black_king_bar",--
    "item_ultimate_scepter",
    "item_shivas_guard",--
    "item_aghanims_shard",
    "item_sheepstick",--
    "item_ultimate_scepter_2",
    "item_travel_boots_2",--
    "item_moon_shard",
}

tOutFitList['outfit_tank'] = tOutFitList['outfit_mid']

tOutFitList['outfit_carry'] = tOutFitList['outfit_mid'] 

tOutFitList['outfit_priest'] = tOutFitList['outfit_mid']

tOutFitList['outfit_mage'] = tOutFitList['outfit_mid']

X['sBuyList'] = tOutFitList[sOutfitType]

X['sSellList'] = {
    "item_bottle",
	"item_falcon_blade",
    "item_magic_wand",
}

if J.Role.IsPvNMode() or J.Role.IsAllShadow() then X['sBuyList'], X['sSellList'] = { 'PvN_mid' }, {} end

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

function X.SkillsComplement()
    -- Check if we're already using an ability
	if J.CanNotUseAbility(bot) then return end

    castQDesire = X.ConsiderQ()
    castWDesire, castWTarget = X.ConsiderW()
    castRDesire, castRLocation = X.ConsiderR()

    if ( castRDesire > 0 ) 
	then
		bot:ActionQueue_UseAbilityOnLocation( abilityR, castRLocation );
		return;
	end
	if ( castWDesire > 0 ) 
	then
		if bot:HasScepter() then
			bot:ActionQueue_UseAbility( abilityW );
			return;
		else
			bot:ActionQueue_UseAbilityOnEntity( abilityW, castWTarget );
			return;
		end
	end
	if ( castQDesire > 0 ) 
	then
		bot:ActionQueue_UseAbility(abilityQ)
		return
	end

end

function X.ConsiderQ()
	-- Make sure it's castable
	if ( not abilityQ:IsFullyCastable() ) 
	then 
		return BOT_ACTION_DESIRE_NONE;
	end
	
	-- Get some of its values
	local nRadius = abilityQ:GetSpecialValueInt("static_remnant_radius");
	local manaCost  = abilityQ:GetManaCost();

	-- If we're seriously retreating, see if we can land a stun on someone who's damaged us recently
	if J.IsRetreating(bot)
	then
		local tableNearbyEnemyHeroes = bot:GetNearbyHeroes( 1000, true, BOT_MODE_NONE );
		for _,npcEnemy in pairs( tableNearbyEnemyHeroes )
		do
			if ( bot:WasRecentlyDamagedByHero( npcEnemy, 2.0 ) ) 
			then
				return BOT_ACTION_DESIRE_ABSOLUTE;
			end
		end
	end
	
	if J.IsInTeamFight(bot, 1200)
	then
		local tableNearbyEnemyHeroes = bot:GetNearbyHeroes( nRadius, true, BOT_MODE_NONE );
		if (tableNearbyEnemyHeroes ~= nil and #tableNearbyEnemyHeroes >= 1) then
			return BOT_ACTION_DESIRE_ABSOLUTE;
		end
	end
	
	if J.IsFarming(bot) and J.CanSpamSpell(bot, manaCost)
	then
		local tableNearbyCreeps = bot:GetNearbyNeutralCreeps(700)
		if (tableNearbyCreeps ~= nil and #tableNearbyCreeps > 1)
		then
			return BOT_ACTION_DESIRE_ABSOLUTE
		end
	end

	if J.IsLaning(bot) and J.CanSpamSpell(bot, manaCost)
	then
		local tableNearbyEnemyCreeps = bot:GetNearbyLaneCreeps( nRadius, true );
		if (tableNearbyEnemyCreeps ~= nil and #tableNearbyEnemyCreeps >= 2)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if (J.IsDefending(bot) or J.IsPushing(bot)) and J.CanSpamSpell(bot, manaCost)
	then
		local tableNearbyEnemyCreeps = bot:GetNearbyLaneCreeps( nRadius, true );
		if (tableNearbyEnemyCreeps ~= nil and #tableNearbyEnemyCreeps >= 2)
		then
			return BOT_ACTION_DESIRE_ABSOLUTE
		end
	end
	
	if J.IsGoingOnSomeone(bot)
	then
		local npcTarget = bot:GetTarget();
		if J.IsValidTarget(npcTarget) and J.IsInRange(npcTarget, bot, nRadius)
		then
			return BOT_ACTION_DESIRE_ABSOLUTE;
		end
	end

	return BOT_ACTION_DESIRE_NONE;
end

function X.ConsiderW()
    -- Make sure it's castable
	if ( not abilityW:IsFullyCastable() ) then 
		return BOT_ACTION_DESIRE_NONE, 0;
	end


	-- Get some of its values
	local nCastRange = abilityW:GetCastRange() + 200;
	if nCastRange < bot:GetAttackRange() then nCastRange = bot:GetAttackRange() + 200; end
	if bot:HasScepter() then nCastRange = 475 end 
	--------------------------------------
	-- Mode based usage
	--------------------------------------
	local tableNearbyEnemyHeroes = bot:GetNearbyHeroes( nCastRange, true, BOT_MODE_NONE );
	for _,npcEnemy in pairs( tableNearbyEnemyHeroes )
	do
		if ( npcEnemy:IsChanneling() ) 
		then
			return BOT_ACTION_DESIRE_ABSOLUTE, npcEnemy;
		end
	end
	
	-- If we're seriously retreating, see if we can land a stun on someone who's damaged us recently
	if J.IsRetreating(bot)
	then
		local tableNearbyEnemyHeroes = bot:GetNearbyHeroes( nCastRange, true, BOT_MODE_NONE );
		for _,npcEnemy in pairs( tableNearbyEnemyHeroes )
		do
			if ( bot:WasRecentlyDamagedByHero( npcEnemy, 2.0 ) and J.CanCastOnNonMagicImmune(npcEnemy)  ) 
			then
				return BOT_ACTION_DESIRE_HIGH, npcEnemy;
			end
		end
	end

	if J.IsInTeamFight(bot, 1200) and bot:HasScepter()
	then
		local tableNearbyEnemyHeroes = bot:GetNearbyHeroes( nCastRange, true, BOT_MODE_NONE );
		if (tableNearbyEnemyHeroes ~= nil and #tableNearbyEnemyHeroes >= 2) then
			return BOT_ACTION_DESIRE_HIGH, nil;
		end
	end
	
	-- If we're going after someone
	if J.IsGoingOnSomeone(bot)
	then
		local npcTarget = bot:GetTarget();
		if J.IsValidTarget(npcTarget) and J.CanCastOnNonMagicImmune(npcTarget) and J.IsInRange(npcTarget, bot, nCastRange-100) and
		   not J.IsDisabled(npcTarget)
		then
			return BOT_ACTION_DESIRE_ABSOLUTE, npcTarget;
		end
	end
	
	return BOT_ACTION_DESIRE_NONE, 0;
end

function X.ConsiderR()
    -- Make sure it's castable
	if ( not abilityR:IsFullyCastable() or abilityR:IsInAbilityPhase() or bot:HasModifier("modifier_storm_spirit_ball_lightning") or bot:IsRooted() ) 
	then 
		return BOT_ACTION_DESIRE_NONE, 0;
	end

	-- Get some of its values
	local nCastPoint = abilityR:GetCastPoint( );
	local nInitialMana = abilityR:GetSpecialValueInt("ball_lightning_initial_mana_base")
	local nInitialManaP = abilityR:GetSpecialValueInt("ball_lightning_initial_mana_percentage") / 100
	local nTravelCost = abilityR:GetSpecialValueInt("ball_lightning_travel_cost_base")
	local nTravelCostP = abilityR:GetSpecialValueFloat("ball_lightning_travel_cost_percent") / 100

	if J.IsStuck(bot)
	then
		local loc = J.GetEscapeLoc();
		return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, loc, RandomInt(600, 1000) );
	end
	
	-- If we're seriously retreating, see if we can land a stun on someone who's damaged us recently
	if J.IsRetreating(bot)
	then
		local tableNearbyEnemyHeroes = bot:GetNearbyHeroes( 1000, true, BOT_MODE_NONE )
		if ( bot:WasRecentlyDamagedByAnyHero(2.0) or bot:WasRecentlyDamagedByTower(2.0) or ( tableNearbyEnemyHeroes ~= nil and #tableNearbyEnemyHeroes > 1  ) )
		then
			local loc = J.GetEscapeLoc();
		    return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, loc, RandomInt(600, 1000) );
		end
	end
	
	if J.IsGoingOnSomeone(bot)
	then
		local npcTarget = bot:GetTarget();
		if J.IsValidTarget(npcTarget) and not J.IsInRange(npcTarget, bot, bot:GetAttackRange()-200) and J.IsInRange(npcTarget, bot, 1600)   
		then
			local MaxMana = bot:GetMaxMana();
			local distance = GetUnitToUnitDistance( npcTarget, bot );
			local tableNearbyAllyHeroes = npcTarget:GetNearbyHeroes( 800, true, BOT_MODE_NONE );
			local TotalInitMana = nInitialMana + ( nInitialManaP * MaxMana );
			local TotalTravelMana = ( nTravelCost * ( distance / 100 ) ) + ( nTravelCostP * MaxMana * ( distance / 100 ) );
			local TotalMana = TotalInitMana + TotalTravelMana;
			--print(TotalMana)
			if tableNearbyAllyHeroes ~= nil and #tableNearbyAllyHeroes >= 1 and BallLightningAllowed( TotalMana ) then
				return BOT_ACTION_DESIRE_VERYHIGH, npcTarget:GetExtrapolatedLocation( 2*nCastPoint );
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0;
end

-- HELPER FUNCS

function GetTowardsFountainLocation( unitLoc, distance )
	local destination = {};
	if ( GetTeam() == TEAM_RADIANT ) then
		destination[1] = unitLoc[1] - distance / math.sqrt(2);
		destination[2] = unitLoc[2] - distance / math.sqrt(2);
	end

	if ( GetTeam() == TEAM_DIRE ) then
		destination[1] = unitLoc[1] + distance / math.sqrt(2);
		destination[2] = unitLoc[2] + distance / math.sqrt(2);
	end
	return Vector(destination[1], destination[2]);
end

function BallLightningAllowed(manaCost)
	if ( bot:GetMana() - manaCost ) / bot:GetMaxMana() >= 0.20
	then
		return true
	end
	return false
end

return X