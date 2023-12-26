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
						['t15'] = {10, 0},
						['t10'] = {10, 0},
}

local tAllAbilityBuildList = {
						{2,1,1,2,1,6,1,2,2,3,6,3,3,3,6},--pos1
}

local nAbilityBuildList = J.Skill.GetRandomBuild( tAllAbilityBuildList )

local nTalentBuildList = J.Skill.GetTalentBuild( tTalentTreeList )

local tOutFitList = {}

tOutFitList['outfit_carry'] = {

	"item_tango",
    "item_double_branches",
	"item_quelling_blade",
	
    "item_bracer",
	"item_phase_boots",
    "item_radiance",--
    "item_magic_wand",
    "item_blink",
    "item_black_king_bar",--
    "item_assault",--
    "item_swift_blink",--
    "item_aghanims_shard",
    "item_abyssal_blade",--
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
    "item_magic_wand",
	
    "item_bracer",
	"item_phase_boots",

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

local UnstableConcoctionThrow   = bot:GetAbilityByName( "alchemist_unstable_concoction_throw" )
local UnstableConcoction        = bot:GetAbilityByName( "alchemist_unstable_concoction" )
local AcidSpray                 = bot:GetAbilityByName( "alchemist_acid_spray" )
local ChemicalRage              = bot:GetAbilityByName( "alchemist_chemical_rage" )


local UnstableConcoctionThrowDesire
local UnstableConcoctionDesire
local AcidSprayDesire
local ChemicalRageDesire

local defDuration = 2
local offDuration = 4.25
local CCStartTime = 0

function X.SkillsComplement()

    if J.CanNotUseAbility( bot ) or bot:IsInvisible() then return end

    AcidSprayDesire, AcidSprayLocation              = X.ConsiderAcidSpray();
	UnstableConcoctionThrowDesire, ThrowLocation    = X.ConsiderUnstableConcoctionThrow();
	UnstableConcoctionDesire                        = X.ConsiderUnstableConcoction();
	ChemicalRageDesire                              = X.ConsiderChemicalRage();
	
	if ( ChemicalRageDesire > 0 ) 
	then
		bot:Action_UseAbility( ChemicalRage );
		return;
	end

	if ( UnstableConcoctionThrowDesire > 0 ) 
	then
		bot:Action_UseAbilityOnEntity( UnstableConcoctionThrow, ThrowLocation );
		return;
	end
	
	if ( AcidSprayDesire > 0 ) 
	then
		bot:Action_UseAbilityOnLocation( AcidSpray, AcidSprayLocation );
		return;
	end
	
	if ( UnstableConcoctionDesire > 0 ) 
	then
		bot:Action_UseAbility( UnstableConcoction );
		CCStartTime =  DotaTime();
		return
	end

end

function X.ConsiderUnstableConcoction()

	-- Make sure it's castable
	if ( not UnstableConcoction:IsFullyCastable() ) then 
		return BOT_ACTION_DESIRE_NONE;
	end

	-- Get some of its values
	local nCastRange = UnstableConcoction:GetCastRange()
	local nDamage = UnstableConcoction:GetSpecialValueInt( "max_damage" );

	--------------------------------------
	-- Mode based usage
	--------------------------------------

	-- If we're seriously retreating, see if we can land a stun on someone who's damaged us recently
	if J.IsRetreating(bot)
	then
		local tableNearbyEnemyHeroes = bot:GetNearbyHeroes( nCastRange, true, BOT_MODE_NONE );
		for _,npcEnemy in pairs( tableNearbyEnemyHeroes )
		do
			if ( bot:WasRecentlyDamagedByHero( npcEnemy, 1.0 )  and J.CanCastOnNonMagicImmune(npcEnemy) ) 
			then
				return BOT_ACTION_DESIRE_MODERATE
			end
		end
	end

	-- If a mode has set a target, and we can kill them, do it
	local npcTarget = bot:GetTarget();
	if ( J.IsValidTarget(npcTarget) and J.CanCastOnNonMagicImmune(npcTarget) )
	then
		if (  J.CanKillTarget(npcTarget, nDamage, DAMAGE_TYPE_PHYSICAL) and J.IsInRange(npcTarget, bot, nCastRange - 200)  )
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end
	
	-- If we're going after someone
	if J.IsGoingOnSomeone(bot)
	then
		if J.IsValidTarget(npcTarget) and J.CanCastOnNonMagicImmune(npcTarget) and J.IsInRange(npcTarget, bot, nCastRange - 200)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	return BOT_ACTION_DESIRE_NONE;

end

function X.ConsiderUnstableConcoctionThrow()

	-- Make sure it's castable
	if ( not UnstableConcoctionThrow:IsFullyCastable() or UnstableConcoctionThrow:IsHidden() ) then 
		return BOT_ACTION_DESIRE_NONE, 0;
	end
	
	-- Get some of its values
	local nCastRange = UnstableConcoctionThrow:GetCastRange();
	local nDamage = UnstableConcoction:GetSpecialValueInt( "max_damage" );
	
	
	-- If a mode has set a target, and we can kill them, do it
	local npcTarget = bot:GetTarget();
	if ( J.IsValidTarget(npcTarget) and J.CanCastOnNonMagicImmune(npcTarget) )
	then
		if ( ( DotaTime() == CCStartTime + offDuration or 
				J.CanKillTarget(npcTarget, nDamage, DAMAGE_TYPE_PHYSICAL)  ) and 
				J.IsInRange(npcTarget, bot, nCastRange + 200) )
		then
			return BOT_ACTION_DESIRE_HIGH, npcTarget;
		end
	end
	
	
	-- If we're seriously retreating, see if we can land a stun on someone who's damaged us recently
	if J.IsRetreating(bot)
	then
		local tableNearbyEnemyHeroes = bot:GetNearbyHeroes( nCastRange, true, BOT_MODE_NONE );
		for _,npcEnemy in pairs( tableNearbyEnemyHeroes )
		do 
			if ( bot:WasRecentlyDamagedByHero( npcEnemy, 2.0 ) and J.CanCastOnNonMagicImmune(npcEnemy) and DotaTime() >= CCStartTime + defDuration ) 
			then
				return BOT_ACTION_DESIRE_HIGH, npcEnemy;
			end
		end
	end

	-- If we're going after someone
	if J.IsGoingOnSomeone(bot)
	then
		if J.IsValidTarget(npcTarget) and 
		   J.CanCastOnNonMagicImmune(npcTarget) and 
		   ( DotaTime() >= CCStartTime + offDuration or npcTarget:GetHealth() < nDamage or npcTarget:IsChanneling() ) 
		then
			return BOT_ACTION_DESIRE_HIGH, npcTarget;
		end
	end

	local tableNearbyEnemyHeroes = bot:GetNearbyHeroes( 1300, true, BOT_MODE_NONE );
	for _,npcEnemy in pairs( tableNearbyEnemyHeroes )
	do
		if ( J.CanCastOnNonMagicImmune(npcEnemy) and 
		   ( DotaTime() >= CCStartTime + offDuration or npcEnemy:GetHealth() < nDamage or npcEnemy:IsChanneling() ) and 
		   J.IsInRange(npcTarget, bot, nCastRange+200)  ) 
		then
			return BOT_ACTION_DESIRE_HIGH, npcEnemy;
		end
	end
	
	return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderAcidSpray()

	-- Make sure it's castable
	if ( not AcidSpray:IsFullyCastable() ) 
	then 
		return BOT_ACTION_DESIRE_NONE, 0
	end


	-- Get some of its values
	local nRadius = AcidSpray:GetSpecialValueInt( "radius" );
	local nCastRange = AcidSpray:GetCastRange();
	local nCastPoint = AcidSpray:GetCastPoint( );

	--------------------------------------
	-- Mode based usage
	--------------------------------------
	-- If we're seriously retreating, see if we can land a stun on someone who's damaged us recently
	if J.IsRetreating(bot)
	then
		local tableNearbyEnemyHeroes = bot:GetNearbyHeroes( nCastRange, true, BOT_MODE_NONE );
		for _,npcEnemy in pairs( tableNearbyEnemyHeroes )
		do
			if ( bot:WasRecentlyDamagedByHero( npcEnemy, 2.0 ) ) 
			then
				return BOT_ACTION_DESIRE_MODERATE, bot:GetLocation();
			end
		end
	end
	
	if bot:GetActiveMode() == BOT_MODE_FARM 
	then
		local locationAoE = bot:FindAoELocation( true, false, bot:GetLocation(), 400, 300, 0, 0 );
		if  locationAoE.count >= 3 then
			return BOT_ACTION_DESIRE_HIGH, locationAoE.targetloc;
		end
	end	
	
	if ( bot:GetActiveMode() == BOT_MODE_ROSHAN  ) 
	then
		local npcTarget = bot:GetAttackTarget();
		if ( J.IsRoshan(npcTarget) and J.CanCastOnMagicImmune(npcTarget) and J.IsInRange(npcTarget, bot, nCastRange)  )
		then
			return BOT_ACTION_DESIRE_MODERATE, npcTarget:GetLocation();
		end
	end
	
	-- If we're pushing or defending a lane and can hit 4+ creeps, go for it
	if ( bot:GetActiveMode() == BOT_MODE_LANING or
	     J.IsDefending(bot) or J.IsPushing(bot) ) and bot:GetMana() / bot:GetMaxMana() > 0.5
	then
		local lanecreeps = bot:GetNearbyLaneCreeps(nCastRange+200, true);
		local locationAoE = bot:FindAoELocation( true, false, bot:GetLocation(), nCastRange, nRadius/2, 0, 0 );
		if ( locationAoE.count >= 4 and #lanecreeps >= 4  ) 
		then
			return BOT_ACTION_DESIRE_HIGH, locationAoE.targetloc;
		end
	end
	
	if J.IsInTeamFight(bot, 1200)
	then
		local locationAoE = bot:FindAoELocation( true, true, bot:GetLocation(), nCastRange, nRadius/2, 0, 0 );
		if  locationAoE.count >= 2 then
			return BOT_ACTION_DESIRE_HIGH, locationAoE.targetloc;
		end
	end
	
	-- If we're going after someone
	if J.IsGoingOnSomeone(bot)
	then
		local npcTarget = bot:GetTarget();
		if ( J.IsValidTarget(npcTarget) and J.CanCastOnNonMagicImmune(npcTarget) and J.IsInRange(npcTarget, bot, nCastRange) ) 
		then
			local EnemyHeroes = npcTarget:GetNearbyHeroes( nRadius, false, BOT_MODE_NONE );
			if ( #EnemyHeroes >= 2 )
			then
				return BOT_ACTION_DESIRE_MODERATE, npcTarget:GetExtrapolatedLocation( nCastPoint );
			end
		end
	end
	
	local skThere, skLoc = J.IsSandKingThere(bot, nCastRange+200, 2.0);
	
	if skThere then
		return BOT_ACTION_DESIRE_MODERATE, skLoc;
	end
	
	return BOT_ACTION_DESIRE_NONE, 0;
end

function X.ConsiderChemicalRage()
	-- Make sure it's castable
	if ( not ChemicalRage:IsFullyCastable() ) then 
		return BOT_ACTION_DESIRE_NONE;
	end
	
	local nRadius = 1000;
	
	if bot:GetHealth() / bot:GetMaxHealth() < 0.5 then
		return BOT_ACTION_DESIRE_LOW
	end
	
	-- If we're seriously retreating, see if we can land a stun on someone who's damaged us recently
	if J.IsRetreating(bot)
	then
		local tableNearbyEnemyHeroes = bot:GetNearbyHeroes( nRadius, true, BOT_MODE_NONE );
		for _,npcEnemy in pairs( tableNearbyEnemyHeroes )
		do
			if ( bot:WasRecentlyDamagedByHero( npcEnemy, 1.0 ) ) 
			then
				return BOT_ACTION_DESIRE_MODERATE
			end
		end
	end
	
	if bot:GetActiveMode() == BOT_MODE_FARM and bot:GetHealth()/bot:GetMaxHealth() < 0.55
	then
		local npcTarget = bot:GetAttackTarget();
		if npcTarget ~= nil then
			return BOT_ACTION_DESIRE_HIGH
		end
	end	
	
	if ( bot:GetActiveMode() == BOT_MODE_ROSHAN  ) 
	then
		local npcTarget = bot:GetTarget();
		if ( J.IsRoshan(npcTarget) and J.CanCastOnMagicImmune(npcTarget) and J.IsInRange(npcTarget, bot, 300)  )
		then
			return BOT_ACTION_DESIRE_MODERATE
		end
	end
	
	if J.IsInTeamFight(bot, 1200)
	then
		local tableNearbyEnemyHeroes = bot:GetNearbyHeroes( nRadius, true, BOT_MODE_NONE  );
		if ( #tableNearbyEnemyHeroes >= 2 )
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end
	
	-- If we're going after someone
	if  J.IsGoingOnSomeone(bot)
	then
		local npcTarget = bot:GetTarget();
		if ( J.IsValidTarget(npcTarget) and J.CanCastOnNonMagicImmune(npcTarget) and J.IsInRange(npcTarget, bot, nRadius-400) ) 
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end
	
	return BOT_ACTION_DESIRE_NONE
end

return X