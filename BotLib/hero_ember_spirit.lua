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
						['t20'] = {10, 0},
						['t15'] = {0, 10},
						['t10'] = {10, 0},
}

local tAllAbilityBuildList = {
						{3,2,2,3,2,6,2,1,1,1,1,3,3,6,6},--pos2
}

local nAbilityBuildList = J.Skill.GetRandomBuild( tAllAbilityBuildList )

local nTalentBuildList = J.Skill.GetTalentBuild( tTalentTreeList )

local tOutFitList = {}

tOutFitList['outfit_mid'] = {
    "item_tango",
    "item_double_branches",
    "item_faerie_fire",
    "item_quelling_blade",

	"item_bottle",
	"item_boots",
    "item_phase_boots",
    "item_magic_wand",
	"item_mage_slayer",
    "item_maelstrom",
	"item_kaya_and_sange",--
    "item_black_king_bar",--
    "item_shivas_guard",--
    "item_ultimate_scepter",
    "item_gungir",--
    "item_travel_boots",
    "item_aghanims_shard",
    "item_ultimate_scepter_2",
    "item_octarine_core",--
    "item_travel_boots_2",--
    "item_moon_shard",
}

tOutFitList['outfit_tank'] = tOutFitList['outfit_mid']

tOutFitList['outfit_carry'] = tOutFitList['outfit_mid'] 

tOutFitList['outfit_priest'] = tOutFitList['outfit_mid']

tOutFitList['outfit_mage'] = tOutFitList['outfit_mid']

X['sBuyList'] = tOutFitList[sOutfitType]

X['sSellList'] = {
    "item_quelling_blade",
	"item_bottle",
    "item_magic_wand",
	"item_mage_slayer",
    "item_maelstrom",
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

local abilityQ = bot:GetAbilityByName( "ember_spirit_searing_chains" )
local abilityW = bot:GetAbilityByName( "ember_spirit_sleight_of_fist" )
local abilityE = bot:GetAbilityByName( "ember_spirit_flame_guard" )
local abilityD = bot:GetAbilityByName( "ember_spirit_activate_fire_remnant" )
local abilityR = bot:GetAbilityByName( "ember_spirit_fire_remnant" )

local castQDesire = 0
local castWDesire = 0
local castEDesire = 0
local castDDesire = 0
local castRDesire = 0

local remnantLoc = Vector(0, 0, 0);
local remnantCastTime = -100;
local remnantCastGap  = 0.1;

function X.SkillsComplement()
    if bot:IsUsingAbility() or bot:IsChanneling() or bot:IsSilenced() then return end

    castQDesire           = X.ConsiderQ()
    castWDesire, castWLoc = X.ConsiderW()
    castEDesire           = X.ConsiderE()
    castDDesire, castDLoc = X.ConsiderD()
    castRDesire, castRLoc = X.ConsiderR()

    if ( castRDesire > 0 ) 
	then
		bot:Action_UseAbilityOnLocation( abilityR, castRLoc );
		remnantCastTime = DotaTime();
		remnantLoc = castRLoc;
		return;
	end
	
	if ( castDDesire > 0 ) 
	then
		bot:Action_UseAbilityOnLocation( abilityD, castDLoc );
		return;
	end

	if ( castQDesire > 0 ) 
	then
		bot:Action_UseAbility( abilityQ );
		return;
	end
	
	if ( castWDesire > 0 ) 
	then
		bot:Action_UseAbilityOnLocation( abilityW, castWLoc );
		return;
	end
	
	if ( castEDesire > 0 ) 
	then
		bot:Action_UseAbility( abilityE );
		return;
	end
end

function X.ConsiderQ()

	-- Make sure it's castable
	if ( not abilityQ:IsFullyCastable() ) then 
		return BOT_ACTION_DESIRE_NONE;
	end

	-- Get some of its values
	local nRadius   = abilityQ:GetSpecialValueInt( "radius" );
	local nDamage   = abilityQ:GetSpecialValueInt( "total_damage_tooltip" );
	local nManaCost = abilityQ:GetManaCost( );

	--------------------------------------
	-- Mode based usage
	--------------------------------------
	local tableNearbyEnemyHeroes = bot:GetNearbyHeroes( nRadius, true, BOT_MODE_NONE );
	
	for _,npcEnemy in pairs(tableNearbyEnemyHeroes)
	do
		if J.CanCastOnNonMagicImmune(npcEnemy) and ( npcEnemy:IsChanneling() or J.CanKillTarget(npcEnemy, nDamage, DAMAGE_TYPE_MAGICAL) ) then
			return BOT_ACTION_DESIRE_HIGH;
		end
	end
	
	-- If we're seriously retreating, see if we can land a stun on someone who's damaged us recently
	if J.IsRetreating(bot)
	then
		for _,npcEnemy in pairs( tableNearbyEnemyHeroes )
		do
			if ( bot:WasRecentlyDamagedByHero( npcEnemy, 2.0 ) and J.CanCastOnNonMagicImmune(npcEnemy) ) 
			then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if ( bot:GetActiveMode() == BOT_MODE_ROSHAN  ) 
	then
		local npcTarget = bot:GetAttackTarget();
		if ( J.IsRoshan(npcTarget) and J.CanCastOnMagicImmune(npcTarget) and J.IsInRange(npcTarget, bot, nRadius)  )
		then
			return BOT_ACTION_DESIRE_MODERATE
		end
	end
	
	if J.IsInTeamFight(bot, 1200)
	then
		if ( tableNearbyEnemyHeroes ~= nil and #tableNearbyEnemyHeroes >= 2 ) 
		then
			return BOT_ACTION_DESIRE_ABSOLUTE
		end
	end
	
	-- If we're going after someone
	if J.IsGoingOnSomeone(bot)
	then
		local npcTarget = bot:GetTarget();
		if J.IsValidTarget(npcTarget) and J.CanCastOnNonMagicImmune(npcTarget) and J.IsInRange(npcTarget, bot, nRadius - 50)
		then
			return BOT_ACTION_DESIRE_ABSOLUTE
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderW()

	-- Make sure it's castable
	if ( not abilityW:IsFullyCastable() ) then 
		return BOT_ACTION_DESIRE_NONE, 0;
	end

	-- Get some of its values
	local nRadius    = abilityW:GetSpecialValueInt('radius');
	local nCastRange = abilityW:GetCastRange();
	local nCastPoint = abilityW:GetCastPoint( );
	local nManaCost  = abilityW:GetManaCost( );
	local nDamage    = bot:GetAttackDamage() + abilityW:GetSpecialValueInt( 'bonus_hero_damage');
	
	local tableNearbyEnemyHeroes = bot:GetNearbyHeroes( nCastRange + nRadius/2, true, BOT_MODE_NONE );
	
	--if we can kill any enemies
	for _,npcEnemy in pairs(tableNearbyEnemyHeroes)
	do
		if J.CanCastOnMagicImmune(npcEnemy) and J.CanKillTarget(npcEnemy, nDamage, DAMAGE_TYPE_PHYSICAL) then
			return BOT_ACTION_DESIRE_ABSOLUTE, npcEnemy:GetLocation();
		end
	end
	
	-- If we're seriously retreating, see if we can land a stun on someone who's damaged us recently
	if J.IsRetreating(bot)
	then
		for _,npcEnemy in pairs( tableNearbyEnemyHeroes )
		do
			if ( bot:WasRecentlyDamagedByHero( npcEnemy, 2.0 ) and J.CanCastOnMagicImmune(npcEnemy) ) 
			then
				return BOT_ACTION_DESIRE_ABSOLUTE, npcEnemy:GetLocation();
			end
		end
	end
	
    if J.IsFarming(bot) and J.AllowedToSpam(bot, nManaCost)
	then
		local neutralCreeps = bot:GetNearbyNeutralCreeps(nCastRange + nRadius);
		local locationAoE = bot:FindAoELocation( true, false, bot:GetLocation(), nCastRange, nRadius/2, nCastPoint, 0 );
		if ( locationAoE.count >= 2 and #neutralCreeps >= 2  ) 
		then
            if abilityW:GetLevel() >= 3
            then
                return BOT_ACTION_DESIRE_ABSOLUTE, locationAoE.targetloc;
            end
			return BOT_ACTION_DESIRE_HIGH, locationAoE.targetloc;
		end
	end

	if ( J.IsPushing(bot) or J.IsDefending(bot) or J.IsLaning(bot) ) and J.AllowedToSpam(bot, nManaCost)
	then
		local lanecreeps = bot:GetNearbyLaneCreeps(nCastRange + nRadius, true);
		local locationAoE = bot:FindAoELocation( true, false, bot:GetLocation(), nCastRange, nRadius/2, nCastPoint, 0 );
		if ( locationAoE.count >= 3 and #lanecreeps >= 3  ) 
		then
            if abilityW:GetLevel() >= 3
            then
                return BOT_ACTION_DESIRE_VERYHIGH, locationAoE.targetloc;
            end
			return BOT_ACTION_DESIRE_MODERATE, locationAoE.targetloc;
		end
	end
	
	if J.IsInTeamFight(bot, 1200)
	then
		local locationAoE = bot:FindAoELocation( true, true, bot:GetLocation(), nCastRange, nRadius/2, 0, 0 );
		if ( locationAoE.count >= 2 ) 
		then
			return BOT_ACTION_DESIRE_ABSOLUTE, locationAoE.targetloc;
		end
	end

	-- If we're going after someone
	if J.IsGoingOnSomeone(bot)
	then
		local npcTarget = bot:GetTarget();
		if J.IsValidTarget(npcTarget) and J.CanCastOnMagicImmune(npcTarget) and J.IsInRange(npcTarget, bot, nCastRange + (nRadius/2)) 
		then
			return BOT_ACTION_DESIRE_ABSOLUTE, npcTarget:GetLocation()
		end
	end
	
	return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderE()

	-- Make sure it's castable
	if ( not abilityE:IsFullyCastable() ) then 
		return BOT_ACTION_DESIRE_NONE;
	end

	-- Get some of its values
	local nRadius   = abilityE:GetSpecialValueInt( "radius" );
	local nDamage   = abilityE:GetSpecialValueFloat( "duration" ) * abilityE:GetSpecialValueInt( "damage_per_second" )
	local nManaCost = abilityE:GetManaCost( );

	--------------------------------------
	-- Mode based usage
	--------------------------------------
	
	-- If we're seriously retreating, see if we can land a stun on someone who's damaged us recently
	if J.IsRetreating(bot)
	then
		local tableNearbyEnemyHeroes = bot:GetNearbyHeroes( nRadius+200, true, BOT_MODE_NONE );
		for _,npcEnemy in pairs( tableNearbyEnemyHeroes )
		do
			if ( bot:WasRecentlyDamagedByHero( npcEnemy, 2.0 ) ) 
			then
				return BOT_ACTION_DESIRE_MODERATE;
			end
		end
	end

	if bot:GetActiveMode() == BOT_MODE_FARM 
	then
		local npcTarget = bot:GetAttackTarget();
		if npcTarget ~= nil then
			return BOT_ACTION_DESIRE_HIGH
		end
	end	
	
	if ( bot:GetActiveMode() == BOT_MODE_ROSHAN  ) 
	then
		local npcTarget = bot:GetAttackTarget();
		if ( J.IsRoshan(npcTarget) and J.CanCastOnMagicImmune(npcTarget) and J.IsInRange(npcTarget, bot, nRadius)  )
		then
			return BOT_ACTION_DESIRE_MODERATE
		end
	end
	
	if J.IsInTeamFight(bot, 1200)
	then
		if ( tableNearbyEnemyHeroes ~= nil and #tableNearbyEnemyHeroes >= 2 and J.IsInRange(tableNearbyEnemyHeroes[1], bot, nRadius + 200) ) 
		then
			return BOT_ACTION_DESIRE_ABSOLUTE
		end
	end
	
	-- If we're going after someone
	if J.IsGoingOnSomeone(bot)
	then
		local npcTarget = bot:GetTarget();
		if J.IsValidTarget(npcTarget) and J.CanCastOnNonMagicImmune(npcTarget) and J.IsInRange(npcTarget, bot, nRadius + 200)
		then
			return BOT_ACTION_DESIRE_HIGH;
		end
	end

	return BOT_ACTION_DESIRE_NONE;
end

function X.ConsiderD()
	-- Make sure it's castable
	if ( not abilityD:IsFullyCastable() ) then 
		return BOT_ACTION_DESIRE_NONE, {};
	end
	
	local units = GetUnitList(UNIT_LIST_ALLIES);
	
	if J.IsRetreating(bot) or J.IsGoingOnSomeone(bot) then
		for _,u in pairs(units) do
			if u ~= nil and u:GetUnitName() == "npc_dota_ember_spirit_remnant" and GetUnitToLocationDistance(u, remnantLoc) < 250 then
				return BOT_ACTION_DESIRE_HIGH, u:GetLocation();
			end
		end
	end
	
	return BOT_ACTION_DESIRE_NONE, {};
end

function X.ConsiderR()
	
	-- Make sure it's castable
	if ( not abilityR:IsFullyCastable() or not abilityD:IsFullyCastable() or bot:IsRooted() ) then 
		return BOT_ACTION_DESIRE_NONE, {};
	end
	
	if DotaTime() < remnantCastTime + remnantCastGap then
		return BOT_ACTION_DESIRE_NONE, {};
	end
	
	local units = GetUnitList(UNIT_LIST_ALLIES);
	local remnantCount = 0;
	
	for _,u in pairs(units) do
		if u ~= nil and u:GetUnitName() == "npc_dota_ember_spirit_remnant" and GetUnitToUnitDistance(bot, u) < 1500 then
			remnantCount = remnantCount + 1;
		end
	end
	
	if remnantCount > 0 then
		return BOT_ACTION_DESIRE_NONE, {};
	end
	
	-- Get some of its values
	local nRadius      = abilityR:GetSpecialValueInt( "radius" );
	local nCastRange   = abilityR:GetCastRange();
	local nCastPoint   = abilityR:GetCastPoint();
	local nDamage      = abilityR:GetSpecialValueInt( "damage" );
	local nSpeed       = bot:GetCurrentMovementSpeed() * ( abilityR:GetSpecialValueInt( "speed_multiplier" ) / 100 );
	local nManaCost    = abilityR:GetManaCost( );

	if nCastRange > 1600 then nCastRange = 1600 end

	--------------------------------------
	-- Mode based usage
	--------------------------------------
	local tableNearbyEnemyHeroes = bot:GetNearbyHeroes( nCastRange - 200, true, BOT_MODE_NONE );
	
	--if we can kill any enemies
	for _,npcEnemy in pairs(tableNearbyEnemyHeroes)
	do
		if J.CanCastOnMagicImmune(npcEnemy) and J.CanKillTarget(npcEnemy, nDamage, DAMAGE_TYPE_MAGICAL) then
			if npcEnemy:GetMovementDirectionStability() < 1.0 then
				return BOT_ACTION_DESIRE_HIGH, npcEnemy:GetLocation();
			else
				local eta = ( GetUnitToUnitDistance(npcEnemy, bot) / nSpeed ) + nCastPoint;
				return BOT_ACTION_DESIRE_HIGH, npcEnemy:GetExtrapolatedLocation(eta);	
			end
		end
	end
	
	-- If we're seriously retreating, see if we can land a stun on someone who's damaged us recently
	if J.IsRetreating(bot)
	then
		for _,npcEnemy in pairs( tableNearbyEnemyHeroes )
		do
			if ( bot:WasRecentlyDamagedByHero( npcEnemy, 1.0 ) and #tableNearbyEnemyHeroes > 2)
			then
				local loc = J.GetEscapeLoc();
				return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation( bot, loc, nCastRange-(#tableNearbyEnemyHeroes*100) );
			end
		end
	end

	-- If we're going after someone
	if J.IsGoingOnSomeone(bot)
	then
		local npcTarget = bot:GetTarget();
		if J.IsValidTarget(npcTarget) and J.CanCastOnMagicImmune(npcTarget) and not J.IsInRange(npcTarget, bot, 300) and J.IsInRange(npcTarget, bot, nCastRange) 
		then
			local targetAlly  = npcTarget:GetNearbyHeroes(1000, false, BOT_MODE_NONE);
			local targetEnemy = npcTarget:GetNearbyHeroes(1000, true, BOT_MODE_NONE);
			if targetEnemy ~= nil and targetAlly ~= nil and #targetEnemy >= #targetAlly then
				if npcTarget:GetMovementDirectionStability() < 1.0 then
					return BOT_ACTION_DESIRE_HIGH, npcTarget:GetLocation();
				else
					local eta = ( GetUnitToUnitDistance(npcTarget, bot) / nSpeed ) + nCastPoint;
					return BOT_ACTION_DESIRE_HIGH, npcTarget:GetExtrapolatedLocation(eta);	
				end
			end
		end
	end
	
	return BOT_ACTION_DESIRE_NONE, {};
end

return X