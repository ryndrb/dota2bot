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
						{1,2,3,1,1,6,1,3,3,3,2,6,2,2,6},--pos1
}

local nAbilityBuildList = J.Skill.GetRandomBuild( tAllAbilityBuildList )

local nTalentBuildList = J.Skill.GetTalentBuild( tTalentTreeList )

local sRandomItem_1 = RandomInt( 1, 9 ) > 6 and "item_satanic" or "item_butterfly"

local tOutFitList = {}

tOutFitList['outfit_carry'] = {

    "item_tango",
    "item_double_branches",
    "item_quelling_blade",

    "item_wraith_band",
    "item_power_treads",
    "item_magic_wand",
    "item_mask_of_madness",
    "item_maelstrom",
    "item_mjollnir",--
    "item_black_king_bar",--
    "item_skadi",--
    "item_aghanims_shard",
    "item_refresher",--
    "item_monkey_king_bar",--
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

    "item_power_treads",
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

local castQDesire
local castWDesire
local castRDesire

local abilityQ = bot:GetAbilityByName( "faceless_void_time_walk" )
local abilityW = bot:GetAbilityByName( "faceless_void_time_dilation" )
local abilityR = bot:GetAbilityByName( "faceless_void_chronosphere" )

function X.SkillsComplement()

    if J.CanNotUseAbility( bot ) then return end

    castQDesire, castQLocation  = X.ConsiderQ();
	castWDesire                 = X.ConsiderW();
	castRDesire, castRLocation  = X.ConsiderR();

    if ( castQDesire > 0 ) 
	then
        J.SetQueuePtToINT( bot, false )
		bot:Action_UseAbilityOnLocation( abilityQ, castQLocation )
		return
	end	

    if ( castRDesire > 0 ) 
	then
		bot:Action_UseAbilityOnLocation( abilityR, castRLocation )
		return
	end	
	
	if ( castWDesire > 0 ) 
	then
        J.SetQueuePtToINT( bot, false )
		bot:Action_UseAbility( abilityW )
		return
	end

end

function X.ConsiderQ()

	-- Make sure it's castable
	if ( not abilityQ:IsFullyCastable() or bot:IsRooted() ) 
	then 
		return BOT_ACTION_DESIRE_NONE, 0;
	end
	
	if ( bot:HasModifier("modifier_faceless_void_chronosphere_speed") ) 
	then 
		return BOT_ACTION_DESIRE_NONE, 0;
	end
	
	-- Get some of its values
	local nCastRange = abilityQ:GetSpecialValueInt("range");
	local nCastPoint = abilityQ:GetCastPoint( );

	if J.IsStuck(bot)
	then
		local loc = J.GetEscapeLoc();
		return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, loc, nCastRange );
	end
	
	-- If we're seriously retreating, see if we can land a stun on someone who's damaged us recently
	if J.IsRetreating(bot)
	then
		local tableNearbyEnemyHeroes = bot:GetNearbyHeroes( 1000, true, BOT_MODE_NONE );
		if ( bot:WasRecentlyDamagedByAnyHero(2.0) or bot:WasRecentlyDamagedByTower(2.0) or ( tableNearbyEnemyHeroes ~= nil and #tableNearbyEnemyHeroes > 1  ) )
		then
			local loc = J.GetEscapeLoc();
		    return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, loc, nCastRange );
		end	
	end
	
	if J.IsGoingOnSomeone(bot)
	then
		local npcTarget = bot:GetTarget();
		if J.IsValidTarget(npcTarget) and J.CanCastOnMagicImmune(npcTarget) and not J.IsInRange(npcTarget, bot, 200) and J.IsInRange(npcTarget, bot, nCastRange) 
		then
			local tableNearbyEnemies = npcTarget:GetNearbyHeroes( 1000, false, BOT_MODE_NONE );
			local tableNearbyAllies = npcTarget:GetNearbyHeroes( 1200, true, BOT_MODE_NONE );
			if #tableNearbyEnemies <= #tableNearbyAllies then
				return BOT_ACTION_DESIRE_MODERATE, npcTarget:GetExtrapolatedLocation( (GetUnitToUnitDistance(npcTarget, bot) / 3000) + nCastPoint );
			end
		end
	end
	
	return BOT_ACTION_DESIRE_NONE, 0;
end

function X.ConsiderW()

	-- Make sure it's castable
	if ( not abilityW:IsFullyCastable() ) 
	then 
		return BOT_ACTION_DESIRE_NONE;
	end

	if ( castQDesire > 0 ) 
	then
		return BOT_ACTION_DESIRE_NONE;
	end
	
	-- Get some of its values
	local nRadius = abilityW:GetSpecialValueInt("radius");

	-- If we're seriously retreating, see if we can land a stun on someone who's damaged us recently
	if J.IsRetreating(bot)
	then
		local tableNearbyEnemyHeroes = bot:GetNearbyHeroes( nRadius, true, BOT_MODE_NONE );
		for _,npcEnemy in pairs( tableNearbyEnemyHeroes )
		do
			if ( bot:WasRecentlyDamagedByHero( npcEnemy, 2.0 ) ) 
			then
				return BOT_ACTION_DESIRE_MODERATE;
			end
		end
	end
	
	if J.IsInTeamFight(bot, 1200)
	then
		local tableNearbyEnemyHeroes = bot:GetNearbyHeroes( nRadius - 200, true, BOT_MODE_NONE );
		if (tableNearbyEnemyHeroes ~= nil and #tableNearbyEnemyHeroes >= 2) then
			return BOT_ACTION_DESIRE_MODERATE;
		end
	end
	
	if J.IsGoingOnSomeone(bot)
	then
		local npcTarget = bot:GetTarget();
		local tableNearbyEnemyHeroes = bot:GetNearbyHeroes( nRadius, true, BOT_MODE_NONE );
		if J.IsValidTarget(npcTarget) and J.CanCastOnNonMagicImmune(npcTarget) and J.IsInRange(npcTarget, bot, nRadius)
		then
			return BOT_ACTION_DESIRE_MODERATE;
		end
	end
	
	return BOT_ACTION_DESIRE_NONE;
end

function X.ConsiderR()

	-- Make sure it's castable
	if ( not abilityR:IsFullyCastable() ) 
	then 
		return BOT_ACTION_DESIRE_NONE, 0;
	end

	-- Get some of its values
	local nRadius = abilityR:GetSpecialValueInt("radius");
	local nCastRange = abilityR:GetCastRange();

	-- If we're seriously retreating, see if we can land a stun on someone who's damaged us recently
	if J.IsRetreating(bot)
	then
		local tableNearbyEnemyHeroes = bot:GetNearbyHeroes( nCastRange+(nRadius/2), true, BOT_MODE_NONE );
		local tableNearbyAllyHeroes = bot:GetNearbyHeroes( 1000, false, BOT_MODE_ATTACK );
		if tableNearbyAllyHeroes ~= nil and  #tableNearbyAllyHeroes >= 2 then
			for _,npcEnemy in pairs( tableNearbyEnemyHeroes )
			do
				if bot:WasRecentlyDamagedByHero( npcEnemy, 2.0 ) 
				then
					local allies = J.GetAlliesNearLoc(npcEnemy:GetLocation(), nRadius);
					if #allies <= 2 then
						return BOT_ACTION_DESIRE_LOW, npcEnemy:GetLocation();
					end	
				end
			end
		end
	end
	
	if J.IsInTeamFight(bot, 1200)
	then
		local locationAoE = bot:FindAoELocation( true, true, bot:GetLocation(), nCastRange, nRadius/2, 0, 0 );
		if ( locationAoE.count >= 2 ) then
            return BOT_ACTION_DESIRE_HIGH, locationAoE.targetloc
		end
	end
	
	if J.IsGoingOnSomeone(bot)
	then
		local npcTarget = bot:GetTarget();
		if ( J.IsValidTarget(npcTarget) and J.CanCastOnMagicImmune(npcTarget) and J.IsInRange(npcTarget, bot, nCastRange+(nRadius/2)) )   
		then
            local enemies = bot:GetNearbyHeroes(nRadius, true, BOT_MODE_NONE)
            if #enemies == 1
            then
                if bot:GetOffensivePower() >= (bot:GetTarget()):GetHealth()
                and J.IsCore(npcTarget)
                then
                    return BOT_ACTION_DESIRE_ABSOLUTE, npcTarget:GetLocation()
                end

                if not J.IsCore(npcTarget)
                then
                    return 0, 0
                end
            end

            return BOT_ACTION_DESIRE_MODERATE, npcTarget:GetLocation()
		end
	end
	
--
	return BOT_ACTION_DESIRE_NONE;
end

return X