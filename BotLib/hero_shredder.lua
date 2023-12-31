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
						{1,3,2,2,2,6,2,1,1,1,6,3,3,3,6},--pos3
}

local nAbilityBuildList = J.Skill.GetRandomBuild( tAllAbilityBuildList )

local nTalentBuildList = J.Skill.GetTalentBuild( tTalentTreeList )

local sLotusPipe = RandomInt( 1, 2 ) == 1 and "item_lotus_orb" or "item_pipe"

local tOutFitList = {}

tOutFitList['outfit_carry'] = tOutFitList['outfit_tank'] 

tOutFitList['outfit_mid'] = tOutFitList['outfit_tank']

tOutFitList['outfit_priest'] = tOutFitList['outfit_tank']

tOutFitList['outfit_mage'] = tOutFitList['outfit_tank']

tOutFitList['outfit_tank'] = {
    "item_tango",
    "item_double_branches",
	"item_circlet",
	"item_circlet",

    "item_magic_wand",
	"item_helm_of_iron_will",
	"item_ring_of_basilius",
    "item_arcane_boots",
	"item_veil_of_discord",
	"item_blink",
    "item_eternal_shroud",--
    "item_kaya_and_sange",--
	"item_shivas_guard",--
    sLotusPipe,--
	"item_travel_boots",
    "item_arcane_blink",--
	"item_travel_boots_2",--
    "item_aghanims_shard",
    "item_ultimate_scepter_2",
    "item_moon_shard"
}

X['sBuyList'] = tOutFitList[sOutfitType]

X['sSellList'] = {
	"item_circlet",
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
local abilityRR = bot:GetAbilityByName( 'shredder_return_chakram' )


local castQDesire
local castWDesire
local castRDesire
local castRRDesire
local closingDesire

local ultLoc
local ultETA1 = 0
local ultTime1 = 0

local function GetUltLoc(npcBot, enemy, nManaCost, nCastRange, s)

	local v=enemy:GetVelocity();
	local sv=GetDistance(Vector(0,0),v);
	if sv>800 then
		v=(v / sv) * enemy:GetCurrentMovementSpeed();
	end
	
	local x=npcBot:GetLocation();
	local y=enemy:GetLocation();
	
	local a=v.x*v.x + v.y*v.y - s*s;
	local b=-2*(v.x*(x.x-y.x) + v.y*(x.y-y.y));
	local c= (x.x-y.x)*(x.x-y.x) + (x.y-y.y)*(x.y-y.y);
	
	local t=math.max((-b+math.sqrt(b*b-4*a*c))/(2*a) , (-b-math.sqrt(b*b-4*a*c))/(2*a));
	
	local dest = (t+0.35)*v + y;

	if GetUnitToLocationDistance(npcBot,dest)>nCastRange or npcBot:GetMana()<100+nManaCost then
		return nil;
	end
	
	if enemy:GetMovementDirectionStability()<0.4 or ((not npcBot:IsFacingLocation(enemy:GetLocation(), 60)) ) then
		dest=VectorTowards(y, Fountain(GetOpposingTeam()),180);
	end

	if J.IsDisabled(enemy) then
		dest=enemy:GetLocation();
	end
	
	return dest;
	
end

function X.SkillsComplement()

	if J.CanNotUseAbility( bot ) then return end

	castQDesire = X.ConsiderQ()
	castWDesire, castTree, castType = X.ConsiderW()
	castRDesire, castCHLocation, eta = X.ConsiderR()
	castRRDesire = X.ConsiderRR()
	closingDesire, target = X.ConsiderClosing()

	-- Return Chakram
	if ( castRRDesire > 0 ) 
	then
		bot:Action_UseAbility( abilityRR );
		ultLoc = Vector(-6376, 6419, 0); 
		return;
	end

	-- Cast Chakram
	if ( castRDesire > 0 ) 
	then
		bot:Action_UseAbilityOnLocation( abilityR, castCHLocation );
		ultLoc = castCHLocation; 
		ultTime1 = DotaTime();
		ultETA1 = eta + 0.5;
		return;
	end

	if ( castWDesire > 0 )
	then
		if castType == "tree" then
			bot:Action_UseAbilityOnLocation( abilityW, GetTreeLocation(castTree) )
		else
			bot:Action_UseAbilityOnLocation( abilityW, castTree )
		end	
		return
	end

	if ( castQDesire > 0 )
	then
        bot:Action_UseAbility(abilityQ)
		return
	end

	closingDesire, target = X.ConsiderClosing()
	if closingDesire > 0 then
		bot:Action_MoveToLocation(target);
		return
	end
end

function X.ConsiderQ()
	-- Make sure it's castable
	if ( not abilityQ:IsFullyCastable() ) then 
		return BOT_ACTION_DESIRE_NONE;
	end


	-- Get some of its values
	local nRadius = abilityQ:GetSpecialValueInt( "whirling_radius" );
	local nCastRange = 0;
	local nDamage = abilityQ:GetSpecialValueInt("whirling_damage");

	--------------------------------------
	-- Mode based usage
	--------------------------------------

	-- If we're seriously retreating, see if we can land a stun on someone who's damaged us recently
	if J.IsRetreating(bot)
	then
		local tableNearbyEnemyHeroes = bot:GetNearbyHeroes( nRadius, true, BOT_MODE_NONE );
		for _,npcEnemy in pairs( tableNearbyEnemyHeroes )
		do
			if ( bot:WasRecentlyDamagedByHero( npcEnemy, 1.0 ) and J.CanCastOnNonMagicImmune(npcEnemy)  ) 
			then
				return BOT_ACTION_DESIRE_HIGH;
			end
		end
	end
	
	if J.IsInTeamFight(bot, 1200)
	then
		local tableNearbyEnemyHeroes = bot:GetNearbyHeroes( nRadius, true, BOT_MODE_NONE );
		if ( tableNearbyEnemyHeroes ~= nil and #tableNearbyEnemyHeroes >= 2 ) then
			return BOT_ACTION_DESIRE_ABSOLUTE;
		end
	end

	-- If we're farming and can kill 3+ creeps with LSA
	if J.IsPushing(bot) or J.IsLaning(bot) or J.IsFarming(bot)
	then
		local NearbyCreeps = bot:GetNearbyLaneCreeps(nRadius, true);
		if NearbyCreeps ~= nil and #NearbyCreeps >= 2 and bot:GetMana()/bot:GetMaxMana() > 0.2 then 
			return BOT_ACTION_DESIRE_HIGH
		end
	end
	
	-- If we're going after someone
	if J.IsGoingOnSomeone(bot)
	then
		local npcTarget = bot:GetTarget();

		if J.IsValidTarget(npcTarget) and J.CanCastOnNonMagicImmune(npcTarget) and J.IsInRange(npcTarget, bot, nRadius)
		then
			return BOT_ACTION_DESIRE_ABSOLUTE;
		end
	end

	if J.IsFarming(bot)
	then
		local NearbyCreeps = bot:GetNearbyNeutralCreeps(nRadius);
		if NearbyCreeps ~= nil and #NearbyCreeps >= 2 and bot:GetMana() / bot:GetMaxMana() > 0.2 then 
			return BOT_ACTION_DESIRE_HIGH
		end
	end


	return BOT_ACTION_DESIRE_NONE;

end

function X.ConsiderW()
	-- Make sure it's castable
	if ( not abilityW:IsFullyCastable() ) 
	then 
		return BOT_ACTION_DESIRE_NONE, 0;
	end
	-- Get some of its values
	local nRadius = abilityW:GetSpecialValueInt( "chain_radius" );
	local nSpeed = abilityW:GetSpecialValueInt( "speed" );
	local nCastRange = J.GetProperCastRange(false, bot, abilityW:GetCastRange());
	local nDamage = abilityW:GetSpecialValueInt("damage");

	if J.IsStuck(bot)
	then
		return BOT_ACTION_DESIRE_VERYHIGH, J.Site.GetXUnitsTowardsLocation( GetAncient(GetTeam()):GetLocation(), nCastRange ), "loc";
	end
	
	-- If we're seriously retreating, see if we can land a stun on someone who's damaged us recently
	if J.IsRetreating(bot) and bot:DistanceFromFountain() > 1000
	then
		local tableNearbyEnemyHeroes = bot:GetNearbyHeroes( 1200, true, BOT_MODE_NONE );
		if tableNearbyEnemyHeroes ~= nil and #tableNearbyEnemyHeroes >= 1 then
			local BRTree = GetBestRetreatTree(bot, nCastRange);
			if BRTree ~= nil then
				return BOT_ACTION_DESIRE_ABSOLUTE, BRTree, "loc";
			end
		end
	end
	
	-- If we're going after someone
	if J.IsGoingOnSomeone(bot)
	then
		local npcTarget = bot:GetTarget();
		if ( J.IsValidTarget(npcTarget) and J.CanCastOnNonMagicImmune(npcTarget) and J.IsInRange(npcTarget, bot, nCastRange) and
			not AreTreesBetween( npcTarget:GetLocation(),nRadius ) ) 
		then
			local BTree = GetBestTree(bot, npcTarget, nCastRange, nRadius);
			if BTree ~= nil then
				return BOT_ACTION_DESIRE_ABSOLUTE, BTree, "tree";
			end
		end
	end
	
	return BOT_ACTION_DESIRE_NONE, 0;


end

function X.ConsiderR()
	-- Make sure it's castable
	if ( not abilityR:IsFullyCastable() or abilityR:IsHidden() ) 
	then 
		return BOT_ACTION_DESIRE_NONE, 0, 0;
	end


	-- Get some of its values
	local nRadius = abilityR:GetSpecialValueFloat( "radius" );
	local nSpeed = abilityR:GetSpecialValueFloat( "speed" );
	local nCastRange = J.GetProperCastRange(false, bot, abilityR:GetCastRange());
	local nManaCost = abilityR:GetManaCost( );
	local nDamage = 2*abilityR:GetSpecialValueInt("pass_damage");

	--------------------------------------
	-- Mode based usage
	-------------------------------------
	-- If we're seriously retreating, see if we can land a stun on someone who's damaged us recently
	if J.IsRetreating(bot)
	then
		local tableNearbyEnemyHeroes = bot:GetNearbyHeroes( 1000, true, BOT_MODE_NONE );
		for _,npcEnemy in pairs( tableNearbyEnemyHeroes )
		do
			if ( bot:WasRecentlyDamagedByHero( npcEnemy, 1.0 ) ) 
			then
				local loc = npcEnemy:GetLocation();
				local eta = GetUnitToLocationDistance(bot, loc) / nSpeed;
				return BOT_ACTION_DESIRE_MODERATE, loc, eta;
			end
		end
	end

	-- If we're pushing or defending a lane and can hit 4+ creeps, go for it
	if J.IsDefending(bot) or J.IsPushing(bot) or J.IsLaning(bot) or J.IsFarming(bot)
	then
		local locationAoE = bot:FindAoELocation( true, false, bot:GetLocation(), nCastRange, nRadius, 0, 0 );
		if ( locationAoE.count >= 2 and bot:GetMana() / bot:GetMaxMana() > 0.2 ) 
		then
			local loc = locationAoE.targetloc;
			local eta = GetUnitToLocationDistance(bot, loc) / nSpeed;
			return BOT_ACTION_DESIRE_ABSOLUTE, loc, eta;
		end
	end


	-- If we're going after someone
	if J.IsGoingOnSomeone(bot)
	then
		local npcTarget = bot:GetTarget();
		if J.IsValidTarget(npcTarget) and J.CanCastOnNonMagicImmune(npcTarget) and J.IsInRange(npcTarget, bot, nCastRange-200) 
		then
			local Loc = GetUltLoc(bot, npcTarget, nManaCost, nCastRange, nSpeed)
			if Loc ~= nil then
				local eta = GetUnitToLocationDistance(bot, Loc) / nSpeed;
				return BOT_ACTION_DESIRE_HIGH, Loc, eta;
			end
		end
	end
	--
	return BOT_ACTION_DESIRE_NONE, 0;
end

function X.ConsiderRR()
	-- Make sure it's castable
	if ( ultLoc == 0 or not abilityRR:IsFullyCastable() or abilityRR:IsHidden() ) then 
		return BOT_ACTION_DESIRE_NONE;
	end
	
	if DotaTime() < ultTime1 + ultETA1 or StillTraveling(1) then 
		return BOT_ACTION_DESIRE_NONE;
	end	
	
	local nRadius = abilityR:GetSpecialValueFloat( "radius" );
	local nDamage = abilityR:GetSpecialValueInt("pass_damage");
	local nManaCost = abilityR:GetManaCost( );
	
	if bot:GetMana() < 100 or GetUnitToLocationDistance(bot, ultLoc) > 1600 then
		return BOT_ACTION_DESIRE_HIGH;
	end
	
	if  J.IsDefending(bot) or J.IsPushing(bot) 
	then
		local nUnits = 0;
		local nLowHPUnits = 0;
		local NearbyUnits = bot:GetNearbyLaneCreeps(1300, true);
		for _,c in pairs(NearbyUnits)
		do 
			if GetUnitToLocationDistance(c, ultLoc) < nRadius  then
				nUnits = nUnits + 1;
			end
			if GetUnitToLocationDistance(c, ultLoc) < nRadius and c:GetHealth() <= nDamage then
				nLowHPUnits = nLowHPUnits + 1
			end
		end
		if nUnits == 0 or nLowHPUnits >= 1  then
			return BOT_ACTION_DESIRE_HIGH
		end
	end
	
	if  bot:GetActiveMode() == BOT_MODE_RETREAT or J.IsGoingOnSomeone(bot) 
	then
		local nUnits = 0;
		local nLowHPUnits = 0;
		local NearbyUnits = bot:GetNearbyHeroes(1000, true, BOT_MODE_NONE);
		for _,c in pairs(NearbyUnits)
		do 
			if GetUnitToLocationDistance(c, ultLoc) < nRadius  then
				nUnits = nUnits + 1;
			end
			if GetUnitToLocationDistance(c, ultLoc) < nRadius and c:GetHealth() <= nDamage / 2 then
				nLowHPUnits = nLowHPUnits + 1;
			end
		end
		if nUnits == 0 or nLowHPUnits >= 1 then
			return BOT_ACTION_DESIRE_HIGH;
		end
	end
	
	local enemies = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
	local creeps = bot:GetNearbyLaneCreeps(1600, true)
	if #enemies == 0 and #creeps <= 2 then
		return BOT_ACTION_DESIRE_ABSOLUTE
	end
	
	return BOT_ACTION_DESIRE_NONE;
end

function X.ConsiderClosing()

	-- Make sure it's castable
	if ( not bot:HasModifier("modifier_shredder_chakram_disarm") ) then 
		return BOT_ACTION_DESIRE_NONE, 0;
	end
	
	if J.IsGoingOnSomeone(bot)
	then
		local npcTarget = bot:GetTarget();
		if J.IsValidTarget(npcTarget) and J.IsInRange(bot, npcTarget, 1000) 
		then
			return BOT_ACTION_DESIRE_MODERATE, npcTarget:GetLocation();
		end
	end
	
	return BOT_ACTION_DESIRE_NONE, 0;
end

-- HELPER FUNCS

-- CONTRIBUTOR: Function below was based off above function by Platinum_dota2
function AreTreesBetween(loc,r)
	local npcBot=GetBot();
	
	local trees=npcBot:GetNearbyTrees(GetUnitToLocationDistance(npcBot,loc));
	--check if there are trees between us
	for _,tree in pairs(trees) do
		local x=GetTreeLocation(tree);
		local y=npcBot:GetLocation();
		local z=loc;
		
		if x~=y then
			local a=1;
			local b=1;
			local c=0;
		
			if x.x-y.x ==0 then
				b=0;
				c=-x.x;
			else
				a=-(x.y-y.y)/(x.x-y.x);
				c=-(x.y + x.x*a);
			end
		
			local d = math.abs((a*z.x+b*z.y+c)/math.sqrt(a*a+b*b));
			if d<=r and GetUnitToLocationDistance(npcBot,loc)> GetDistance(x,loc)+50 then
				return true;
			end
		end
	end
	return false;
end

function GetDistance(s, t)
    return math.sqrt((s[1]-t[1])*(s[1]-t[1]) + (s[2]-t[2])*(s[2]-t[2]));
end

function Fountain(team)
	if team==TEAM_RADIANT then
		return Vector(-7093,-6542);
	end
	return Vector(7015,6534);
end

-- CONTRIBUTOR: Function below was based off above function by Platinum_dota2
function VectorTowards(s,t,d)
	local f=t-s;
	f=f / GetDistance(f,Vector(0,0));
	return s+(f*d);
end

function GetBestRetreatTree(npcBot, nCastRange)
	local trees=npcBot:GetNearbyTrees(nCastRange);
	
	local dest=VectorTowards(npcBot:GetLocation(), Fountain(GetTeam()),1000);
	
	local BestTree=nil;
	local maxdis=0;
	
	for _,tree in pairs(trees) do
		local loc=GetTreeLocation(tree);
		
		if (not AreTreesBetween(loc,100)) and 
			GetUnitToLocationDistance(npcBot,loc)>maxdis and 
			GetUnitToLocationDistance(npcBot,loc)<nCastRange and 
			GetDistance(loc,dest)<880 
		then
			maxdis=GetUnitToLocationDistance(npcBot,loc);
			BestTree=loc;
		end
	end
	
	if BestTree~=nil and maxdis>250 then
		return BestTree;
	end
	
	return nil;
end

function GetBestTree(npcBot, enemy, nCastRange, hitRadios)
   
	--find a tree behind enemy
	local bestTree=nil;
	local mindis=10000;

	local trees=npcBot:GetNearbyTrees(nCastRange);
	
	for _,tree in pairs(trees) do
		local x=GetTreeLocation(tree);
		local y=npcBot:GetLocation();
		local z=enemy:GetLocation();
		
		if x~=y then
			local a=1;
			local b=1;
			local c=0;
		
			if x.x-y.x ==0 then
				b=0;
				c=-x.x;
			else
				a=-(x.y-y.y)/(x.x-y.x);
				c=-(x.y + x.x*a);
			end
		
			local d = math.abs((a*z.x+b*z.y+c)/math.sqrt(a*a+b*b));
			if d<=hitRadios and mindis>GetUnitToLocationDistance(enemy,x) and (GetUnitToLocationDistance(enemy,x)<=GetUnitToLocationDistance(npcBot,x)) then
				bestTree=tree;
				mindis=GetUnitToLocationDistance(enemy,x);
			end
		end
	end
	
	return bestTree;

end

function StillTraveling(cType)
	local proj = GetLinearProjectiles();
	for _,p in pairs(proj)
	do
		if p ~= nil and (( cType == 1 and p.ability:GetName() == "shredder_chakram" ) or (  cType == 2 and p.ability:GetName() == "shredder_chakram_2" ) ) then
			return true; 
		end
	end
	return false;
end

return X