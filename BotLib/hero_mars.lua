-- Credit goes to Furious Puppy for Bot Experiment

local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sOutfitType = J.Item.GetOutfitType( bot )

local tTalentTreeList = {
    ['t25'] = {10, 0},
    ['t20'] = {10, 0},
    ['t15'] = {0, 10},
    ['t10'] = {0, 10},
}

local tAllAbilityBuildList = {
    {2, 1, 1, 2, 1, 6, 1, 2, 2, 3, 6, 3, 3, 3, 6},
}

local nAbilityBuildList = J.Skill.GetRandomBuild( tAllAbilityBuildList )

local nTalentBuildList = J.Skill.GetTalentBuild( tTalentTreeList )

local tOutFitList = {}

tOutFitList['outfit_tank'] = {
    "item_magic_wand",
    "item_quelling_blade",

    "item_phase_boots",
    "item_blade_mail",
    "item_blink",
    "item_black_king_bar",--
    "item_sheepstick",--
    "item_refresher",--
    "item_shivas_guard",--
    "item_satanic",--
    "item_overwhelming_blink",--
    "item_aghanims_shard",
    "item_moon_shard",
    "item_ultimate_scepter_2"
}

tOutFitList['outfit_carry'] = tOutFitList['outfit_tank'] 

tOutFitList['outfit_mid'] = tOutFitList['outfit_tank']

tOutFitList['outfit_priest'] = tOutFitList['outfit_tank']

tOutFitList['outfit_mage'] = tOutFitList['outfit_tank']

X['sBuyList'] = tOutFitList[sOutfitType]

X['sSellList'] = {
    "item_quelling_blade",
    "item_magic_wand",

    "item_blade_mail",
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
local abilityE = bot:GetAbilityByName( sAbilityList[3] )
local abilityR = bot:GetAbilityByName( sAbilityList[6] )

local castCombo1Desire = 0;
local castCombo2Desire = 0;
local castQDesire = 0;
local castWDesire = 0;
local castEDesire = 0;
local castRDesire = 0;

function X.SkillsComplement()
	
	if J.CanNotUseAbility( bot ) then return end
	
	castQDesire, castQLoc = X.ConsiderQ();
	castWDesire, castWLoc = X.ConsiderW();
	castEDesire, ETarget  = X.ConsiderE();
	castRDesire, castRLoc = X.ConsiderR();
	
	if castWDesire > 0 then
		bot:Action_UseAbilityOnLocation(abilityW, castWLoc);		
		return
	end
	
	if castRDesire > 0 then
		bot:Action_UseAbilityOnLocation(abilityR, castRLoc);		
		return
	end
	
	if castQDesire > 0 then
		bot:Action_UseAbilityOnLocation(abilityQ, castQLoc);		
		return
	end
	
	if castEDesire > 0 then
		bot:Action_UseAbility(abilityE);		
		return
	end

end

function X.ConsiderQ()
	if not J.CanBeCast(abilityQ) then
		return BOT_ACTION_DESIRE_NONE, nil;
	end
	
	local castRange = J.GetProperCastRange(false, bot, abilityQ:GetCastRange());
	local castPoint = abilityQ:GetCastPoint();
	local manaCost  = abilityQ:GetManaCost();
	local nRadius   = abilityQ:GetSpecialValueInt( "spear_width" );
	local nDuration = 1;
	local nSpeed    = abilityQ:GetSpecialValueInt('spear_speed');
	local nDamage   = abilityQ:GetSpecialValueInt('damage');
	
	local target  = bot:GetTarget(); 
	local enemies = bot:GetNearbyHeroes(castRange, true, BOT_MODE_NONE);

	local tableNearbyEnemyHeroes = bot:GetNearbyHeroes( castRange, true, BOT_MODE_NONE );
	for _,npcEnemy in pairs( tableNearbyEnemyHeroes )
	do
		if ( npcEnemy:IsChanneling() ) 
		then
			return BOT_ACTION_DESIRE_HIGH, npcEnemy:GetLocation()
		end
	end

	if J.IsRetreating(bot)
	then
		if #enemies > 0 and bot:WasRecentlyDamagedByAnyHero(2.0) then
			local enemy = J.GetLowestHPUnit(enemies, false);
			if enemy ~= nil then
				return BOT_ACTION_DESIRE_VERYHIGH, enemy:GetLocation();
			end	
		end
	end	
	
	if ( J.IsPushing(bot) or J.IsDefending(bot)) and J.AllowedToSpam(bot, manaCost)
	then
		local lanecreeps = bot:GetNearbyLaneCreeps(castRange, true);
		local locationAoE = bot:FindAoELocation( true, false, bot:GetLocation(), castRange, nRadius, 0, 0 );
		local tableNearbyCreeps = bot:GetNearbyNeutralCreeps(nRadius)
		if ( locationAoE.count >= 3 and (#lanecreeps >= 3 or #tableNearbyCreeps >= 2))
		then
			if J.IsLaning(bot) or J.IsFarming(bot)
			then
				return BOT_ACTION_DESIRE_HIGH, locationAoE.targetloc;
			else
				return BOT_ACTION_DESIRE_HIGH, locationAoE.targetloc;
			end
		end
	end
	
	if J.IsInTeamFight(bot, 1300)
	then
		local locationAoE = bot:FindAoELocation( true, true, bot:GetLocation(), castRange, nRadius, 0, 0 );
		local unitCount = J.CountVulnerableUnit(enemies, locationAoE, nRadius, 2);
		if ( unitCount >= 2 ) 
		then
			return BOT_ACTION_DESIRE_HIGH, locationAoE.targetloc;
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		if J.IsValidTarget(target) and J.CanCastOnNonMagicImmune(target) and J.IsInRange(target, bot, castRange) 
		then
			return BOT_ACTION_DESIRE_HIGH, J.GetProperLocation( target, (GetUnitToUnitDistance(bot, target)/nSpeed)+castPoint );
		end
	end
	
	return BOT_ACTION_DESIRE_NONE, nil;

end

function X.ConsiderW()
    if not J.CanBeCast(abilityW) then
		return BOT_ACTION_DESIRE_NONE, nil;
	end
	
	local castRange = J.GetProperCastRange(false, bot, abilityW:GetCastRange());
	local castPoint = abilityW:GetCastPoint();
	local manaCost  = abilityW:GetManaCost();
	local nRadius   = abilityW:GetSpecialValueInt( "radius" );
	local nDamage   = bot:GetAttackDamage()*abilityW:GetSpecialValueInt('crit_mult')/100;
	
	local target  = bot:GetTarget(); 
	local enemies = bot:GetNearbyHeroes(castRange, true, BOT_MODE_NONE);
	
	if J.IsRetreating(bot)
	then
		if #enemies > 0 and bot:WasRecentlyDamagedByAnyHero(2.0) then
			local enemy = J.GetLowestHPUnit(enemies, false);
			if enemy ~= nil and not J.IsDisabled(enemy)
            then
				return BOT_ACTION_DESIRE_ABSOLUTE, enemy:GetLocation();
			end	
		end
	end	

	if J.IsFarming(bot)
	then
		local neutralCreeps = bot:GetNearbyNeutralCreeps(nRadius)
		local locationAoE = bot:FindAoELocation( true, false, bot:GetLocation(), castRange, nRadius/2, 0, 0 );
		if ( locationAoE.count >= 1 and (#neutralCreeps >= 2))
		then
			return BOT_ACTION_DESIRE_ABSOLUTE, locationAoE.targetloc;
		end
		
	end
	
	if ( J.IsPushing(bot) or J.IsDefending(bot) or J.IsLaning(bot)) and J.AllowedToSpam(bot, manaCost)
	then
		local lanecreeps = bot:GetNearbyLaneCreeps(castRange, true);
		local locationAoE = bot:FindAoELocation( true, false, bot:GetLocation(), castRange, nRadius/2, 0, 0 );
		if ( locationAoE.count >= 1 and (#lanecreeps >= 3))
		then
			return BOT_ACTION_DESIRE_VERYHIGH, locationAoE.targetloc;
		end
	end
	
	if J.IsInTeamFight(bot, 1300)
	then
		local locationAoE = bot:FindAoELocation( true, true, bot:GetLocation(), castRange-150, nRadius/2, castPoint, 0 );
		local unitCount = J.CountNotStunnedUnits(enemies, locationAoE, nRadius, 2);
		if ( unitCount >= 2 ) 
		then
			return BOT_ACTION_DESIRE_ABSOLUTE, locationAoE.targetloc;
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		if J.IsValidTarget(target) and J.CanCastOnNonMagicImmune(target) and J.IsInRange(target, bot, castRange-200)
        and not J.IsDisabled(target)
		then
			return BOT_ACTION_DESIRE_ABSOLUTE, target:GetLocation();
		end
	end

	
	return BOT_ACTION_DESIRE_NONE, nil;
end

function X.ConsiderE()
    if not J.CanBeCast(abilityE) then
		return BOT_ACTION_DESIRE_NONE, nil;
	end
	
	if J.IsRetreating(bot) and bot:WasRecentlyDamagedByAnyHero(3.0) and abilityE:GetToggleState( ) == false
	then
		local allies = bot:GetNearbyHeroes(1300, false, BOT_MODE_ATTACK)
		if #allies > 1 then
			local num_facing = 0;
			local enemies = bot:GetNearbyHeroes(1300, true, BOT_MODE_NONE)
			for i=1, #enemies do
				if J.IsValidTarget(enemies[i])
					and J.CanCastOnMagicImmune(enemies[i])
					and bot:WasRecentlyDamagedByHero(enemies[i], 3.5)
					and bot:IsFacingLocation(enemies[i]:GetLocation(), 20) 
				then
					num_facing = num_facing + 1;
				end	
			end
			if num_facing >= 1 then
				return BOT_ACTION_DESIRE_HIGH, nil;
			end
		end
	end	
	
	if J.IsGoingOnSomeone(bot) and abilityE:GetToggleState( ) == true then
		return BOT_ACTION_DESIRE_HIGH, nil;
	end
	
	local enemies = bot:GetNearbyHeroes(1300, true, BOT_MODE_NONE)
	if #enemies == 0 and abilityE:GetToggleState( ) == true then
		return BOT_ACTION_DESIRE_HIGH, nil;
	end
	
	return BOT_ACTION_DESIRE_NONE, nil;
end

function X.ConsiderR()
    if not J.CanBeCast(abilityR) then
		return BOT_ACTION_DESIRE_NONE, nil;
	end
	
	local castRange = J.GetProperCastRange(false, bot, abilityR:GetCastRange());
	local castPoint = abilityR:GetCastPoint();
	local manaCost  = abilityR:GetManaCost();
	local nRadius   = abilityR:GetSpecialValueInt( "radius" );
	local nDamage   = abilityR:GetSpecialValueInt('spear_damage');
	
	local target  = bot:GetTarget(); 
	local enemies = bot:GetNearbyHeroes(castRange, true, BOT_MODE_NONE);

	if J.IsRetreating(bot)
	then
		local tableNearbyAllyHeroes = bot:GetNearbyHeroes( 1000, false, BOT_MODE_ATTACK );
		if #enemies > 0 and  #tableNearbyAllyHeroes >= 2 and bot:WasRecentlyDamagedByAnyHero(2.0) then
			return BOT_ACTION_DESIRE_HIGH, bot:GetLocation();
		end
	end	
	
	if J.IsInTeamFight(bot, 1300)
	then
		local locationAoE = bot:FindAoELocation( true, true, bot:GetLocation(), castRange, nRadius, castPoint, 0 );
		local unitCount = J.CountVulnerableUnit(enemies, locationAoE, nRadius, 2);
		if ( unitCount >= 2 ) 
		then
			return BOT_ACTION_DESIRE_ABSOLUTE, locationAoE.targetloc;
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		if J.IsValidTarget(target) and J.CanCastOnNonMagicImmune(target) and J.IsInRange(target, bot, castRange) 
		then
			local targetAllies = target:GetNearbyHeroes(2*nRadius, false, BOT_MODE_NONE);
			if #targetAllies >= 2 then
				return BOT_ACTION_DESIRE_HIGH, J.GetProperLocation( target, castPoint );
			end
		end
	end
	
	return BOT_ACTION_DESIRE_NONE, nil;

end

return X