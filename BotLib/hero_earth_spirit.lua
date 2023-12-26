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
						['t10'] = {0, 10},
}

local tAllAbilityBuildList = {
						{1,2,1,2,1,6,1,2,2,3,6,3,3,3,6},--pos2
}

local nAbilityBuildList = J.Skill.GetRandomBuild( tAllAbilityBuildList )

local nTalentBuildList = J.Skill.GetTalentBuild( tTalentTreeList )

local tOutFitList = {}

tOutFitList['outfit_carry'] = tOutFitList['outfit_mid']

tOutFitList['outfit_mid'] = {
    "item_tango",
    "item_double_branches",
    "item_faerie_fire",
    "item_quelling_blade",

    "item_bottle",
    "item_boots",
    "item_magic_wand",
    "item_urn_of_shadows",
    "item_spirit_vessel",
    "item_blade_mail",
    "item_heart",--
    "item_black_king_bar",--
    "item_travel_boots",
    "item_shivas_guard",--
    "item_octarine_core",--
    "item_travel_boots_2",--
    "item_sheepstick",--

    "item_aghanims_shard",
    "item_moon_shard",
    "item_ultimate_scepter_2",
}

tOutFitList['outfit_priest'] = tOutFitList['outfit_carry']

tOutFitList['outfit_mage'] = tOutFitList['outfit_carry']

tOutFitList['outfit_tank'] = tOutFitList['outfit_carry']

X['sBuyList'] = tOutFitList[sOutfitType]

X['sSellList'] = {
    "item_quelling_blade",
    "item_bottle",
    "item_magic_wand",
    "item_spirit_vessel",
    "item_blade_mail",
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

local BoulderSmash = bot:GetAbilityByName( "earth_spirit_boulder_smash" )
local RollingBoulder = bot:GetAbilityByName( "earth_spirit_rolling_boulder" )
local GeomagneticGrip = bot:GetAbilityByName( "earth_spirit_geomagnetic_grip" )
local StoneCaller = bot:GetAbilityByName( "earth_spirit_stone_caller" )
local Petrify = bot:GetAbilityByName( "earth_spirit_petrify" )
local Magnetize = bot:GetAbilityByName( "earth_spirit_magnetize" )
local GripAllies = bot:GetAbilityByName( "special_bonus_unique_earth_spirit_2" )

local BoulderSmashDesire = 0
local RollingBoulderDesire = 0
local GeomagneticGripDesire = 0
local StoneCallerDesire = 0
local PetrifyDesire = 0
local MagnetizeDesire = 0
local GripAlliesDesire = 0

local nStone = 0
local stoneCast = -100
local stoneCastGap = 1

function X.SkillsComplement()

    if bot:IsUsingAbility() or bot:IsChanneling() or bot:IsSilenced() or bot:NumQueuedActions() > 0 then return end

    BoulderSmashDesire, boulderLoc, castBS, QStoneNear  = X.ConsiderBoulderSmash()
    RollingBoulderDesire, rollLoc, castRB               = X.ConsiderRollingBoulder()
    GeomagneticGripDesire, gripLoc, castGG              = X.ConsiderGeomagneticGrip()
    StoneCallerDesire, callerLoc                        = X.ConsiderStoneCaller()
    PetrifyDesire, petrifyTarget                        = X.ConsiderPetrify()
    MagnetizeDesire                                     = X.ConsiderMagnetize()

    if StoneCaller:IsFullyCastable()
    then
        nStone = 1
    else
        nStone = 0
    end

    if MagnetizeDesire > 0
    then
        bot:Action_UseAbility(Magnetize)
    end

    if PetrifyDesire > 0
    then
        bot:ActionQueue_UseAbilityOnEntity(Petrify, petrifyTarget)
		bot:ActionQueue_UseAbilityOnLocation(BoulderSmash, bot:GetLocation() + RandomVector(800))
    end

    if BoulderSmashDesire > 0
	then
		if castBS then
			bot:Action_ClearActions(false)
			bot:ActionQueue_UseAbilityOnLocation(StoneCaller, bot:GetLocation())
			bot:ActionQueue_UseAbilityOnLocation(BoulderSmash, boulderLoc)
			return;
		else
			if QStoneNear then
				bot:Action_UseAbilityOnLocation( BoulderSmash, boulderLoc )
				return
			else
				bot:Action_UseAbilityOnEntity( BoulderSmash, boulderLoc )
				return
			end
		end
	end

    if RollingBoulderDesire > 0
	then
		if castRB then
			bot:Action_ClearActions(false)
			bot:ActionQueue_UseAbilityOnLocation(RollingBoulder, rollLoc)
			bot:ActionQueue_UseAbilityOnLocation(StoneCaller, J.Site.GetXUnitsTowardsLocation(bot, rollLoc, 300))
			return
		else
			bot:Action_UseAbilityOnLocation( RollingBoulder, rollLoc)
			return
		end
	end

    if GeomagneticGripDesire > 0
	then
		if castGG then
			bot:Action_ClearActions(false);
			bot:ActionQueue_UseAbilityOnLocation(StoneCaller, gripLoc)
			bot:ActionQueue_UseAbilityOnLocation(GeomagneticGrip, gripLoc)
			return
		else
			bot:Action_UseAbilityOnLocation( GeomagneticGrip, gripLoc )
			return
		end
	end
	
	if StoneCallerDesire > 0
	then
		bot:Action_UseAbilityOnLocation( StoneCaller, callerLoc)
		stoneCast = DotaTime()
		return
	end
end

function X.ConsiderBoulderSmash()
    if ( not BoulderSmash:IsFullyCastable() ) then
		return BOT_ACTION_DESIRE_NONE, 0, false, false
	end

	local nRadius     = BoulderSmash:GetSpecialValueInt('radius')
	local nSearchRad  = BoulderSmash:GetSpecialValueInt('rock_search_aoe')
	local nUnitCR     = 150
	local nStoneCR    = BoulderSmash:GetSpecialValueInt('rock_distance')
	local nCastPoint  = BoulderSmash:GetCastPoint()
	local nManaCost   = BoulderSmash:GetManaCost()
	local nSpeed      = BoulderSmash:GetSpecialValueInt('speed')
	local nDamage     = BoulderSmash:GetSpecialValueInt('rock_damage')

	if nStoneCR > 1600 then nStoneCR = 1300 end
	
	local stoneNearby = IsStoneNearby(bot:GetLocation(), nSearchRad)
	
	if stoneNearby then
		local tableNearbyEnemyHeroes = bot:GetNearbyHeroes( nStoneCR, true, BOT_MODE_NONE )
		local target = J.GetCanBeKilledUnit(tableNearbyEnemyHeroes, nDamage, DAMAGE_TYPE_MAGICAL, false)
		if target ~= nil then
			local loc = J.GetCorrectLoc(target, GetUnitToUnitDistance(bot, target) / nSpeed)
			return BOT_ACTION_DESIRE_HIGH, loc, false, true
		end
	elseif nStone >= 1 then
		local tableNearbyEnemyHeroes = bot:GetNearbyHeroes( nStoneCR, true, BOT_MODE_NONE )
		local target = J.GetCanBeKilledUnit(tableNearbyEnemyHeroes, nDamage, DAMAGE_TYPE_MAGICAL, false)
		if target ~= nil then
			local loc = J.GetCorrectLoc(target, GetUnitToUnitDistance(bot, target) / nSpeed)
			return BOT_ACTION_DESIRE_HIGH, loc, true, false
		end
	elseif nStone < 1 then
		local tableNearbyEnemyHeroes = bot:GetNearbyHeroes( nUnitCR+200, true, BOT_MODE_NONE )
		local target = J.GetCanBeKilledUnit(tableNearbyEnemyHeroes, nDamage, DAMAGE_TYPE_MAGICAL, false)
		if target ~= nil then
			return BOT_ACTION_DESIRE_HIGH, target, false, false
		end
	end

	if J.IsRetreating(bot) and bot:WasRecentlyDamagedByAnyHero( 1.0 )
	then
		if stoneNearby then
			local tableNearbyEnemyHeroes = bot:GetNearbyHeroes( nStone, true, BOT_MODE_NONE )
			local target = J.GetClosestUnit(tableNearbyEnemyHeroes)
			if target ~= nil then
				return BOT_ACTION_DESIRE_HIGH, target:GetLocation(), false, true
			end
		elseif nStone >= 1 then
			local tableNearbyEnemyHeroes = bot:GetNearbyHeroes( nStone, true, BOT_MODE_NONE )
			local target = J.GetClosestUnit(tableNearbyEnemyHeroes)
			if target ~= nil then
				return BOT_ACTION_DESIRE_HIGH, target:GetLocation(), true, false
			end
		elseif nStone < 1 then
			local tableNearbyEnemyHeroes = bot:GetNearbyHeroes( nUnitCR+200, true, BOT_MODE_NONE )
			local target = J.GetClosestUnit(tableNearbyEnemyHeroes)
			if target ~= nil then
				return BOT_ACTION_DESIRE_HIGH, target, false, false
			end
		end
	end

	if J.IsInTeamFight(bot, 1200) 
	then
		local locationAoE = bot:FindAoELocation( true, true, bot:GetLocation(), nStoneCR, nRadius, nCastPoint, 0 );
		if ( locationAoE.count >= 2 ) 
		then
			if stoneNearby then
				return BOT_ACTION_DESIRE_LOW, locationAoE.targetloc, false, true;
			elseif nStone >= 1 then
				return BOT_ACTION_DESIRE_LOW, locationAoE.targetloc, true, false;
			end
		end
	end

	if J.IsGoingOnSomeone(bot) 
	then
		local npcTarget = bot:GetTarget();
		if J.IsValidTarget(npcTarget) and J.CanCastOnNonMagicImmune(npcTarget) and J.IsInRange(npcTarget, bot, nStoneCR + 200) 
		then
			local loc = J.GetCorrectLoc(npcTarget, GetUnitToUnitDistance(bot, target) / nSpeed)
			if stoneNearby then
				return BOT_ACTION_DESIRE_HIGH, loc, false, true;
			elseif nStone >= 1 then
				return BOT_ACTION_DESIRE_HIGH, loc, true, false;
			end
		end
	end

	local skThere, skLoc = J.IsSandKingThere(bot, nStoneCR, 2.0);

	if skThere and nStone >= 1 then
		return BOT_ACTION_DESIRE_MODERATE, skLoc, true, false;
	end

	return BOT_ACTION_DESIRE_NONE, 0, false, false;
end

function X.ConsiderRollingBoulder()
    if ( not RollingBoulder:IsFullyCastable() or bot:IsRooted() ) then
		return BOT_ACTION_DESIRE_NONE, 0, false
	end

	local nRadius     = RollingBoulder:GetSpecialValueInt('radius')
	local nUnitCR     = RollingBoulder:GetSpecialValueInt('distance')
	local nStoneCR    = RollingBoulder:GetSpecialValueInt('rock_distance')
	local nCastPoint  = RollingBoulder:GetCastPoint( )
	local nDelay      = RollingBoulder:GetSpecialValueFloat('delay')
	local nManaCost   = RollingBoulder:GetManaCost( )
	local nSpeed      = RollingBoulder:GetSpecialValueInt('speed')
	local nRSpeed     = RollingBoulder:GetSpecialValueInt('rock_speed')
	local nDamage     = RollingBoulder:GetSpecialValueInt('damage')

	if nStoneCR > 1600 then nStoneCR = 1300 end

	local eHeroes = bot:GetNearbyHeroes( nRadius, true, BOT_MODE_NONE );
	for _, npcEnemy in pairs( eHeroes )
	do
		if (npcEnemy:IsChanneling())
		then
			local loc = J.GetCorrectLoc(npcEnemy, (GetUnitToUnitDistance(bot, npcEnemy) / nRSpeed) + nDelay)
			return BOT_ACTION_DESIRE_HIGH, loc, true
		end
	end

	if J.IsStuck(bot)
	then
		local loc = J.GetEscapeLoc()
		return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, loc, nStoneCR)
	end

	if nStone >= 1 then
		local tableNearbyEnemyHeroes = bot:GetNearbyHeroes( nStoneCR, true, BOT_MODE_NONE )
		local target = J.GetCanBeKilledUnit(tableNearbyEnemyHeroes, nDamage, DAMAGE_TYPE_MAGICAL, false)
		if target ~= nil then
			local loc = J.GetCorrectLoc(target, (GetUnitToUnitDistance(bot, target)/nRSpeed)+nDelay)
			if IsStoneInPath(loc, (nUnitCR/2)+200) then
				return BOT_ACTION_DESIRE_HIGH, loc, false
			else
				return BOT_ACTION_DESIRE_HIGH, loc, true
			end
		end
	elseif nStone < 1 then
		local tableNearbyEnemyHeroes = bot:GetNearbyHeroes( nUnitCR-200, true, BOT_MODE_NONE )
		local target = J.GetCanBeKilledUnit(tableNearbyEnemyHeroes, nDamage, DAMAGE_TYPE_MAGICAL, false)
		if target ~= nil then
			return BOT_ACTION_DESIRE_HIGH, target, false
		end
	end

	if J.IsRetreating(bot) and bot:WasRecentlyDamagedByAnyHero(1.0)
	then
		local location = J.GetEscapeLoc()
		local loc = J.Site.GetXUnitsTowardsLocation(bot, location, nUnitCR)
		if IsStoneInPath(loc, (nUnitCR / 2) + 200) then
			return BOT_ACTION_DESIRE_MODERATE, loc, false
		elseif nStone >= 1 then
			return BOT_ACTION_DESIRE_MODERATE, loc, true
		elseif nStone < 1 then
			return BOT_ACTION_DESIRE_MODERATE, loc, false
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		local npcTarget = bot:GetTarget()
		if nStone >= 1 and J.IsValidTarget(npcTarget) and J.CanCastOnNonMagicImmune(npcTarget) and J.IsInRange(npcTarget, bot, nStoneCR + 200)
		then
			local targetAlly  = npcTarget:GetNearbyHeroes(1000, false, BOT_MODE_NONE)
			local targetEnemy = npcTarget:GetNearbyHeroes(1000, true, BOT_MODE_NONE)
			if targetEnemy ~= nil and targetAlly ~= nil and #targetEnemy >= #targetAlly then
				local loc = J.GetCorrectLoc(npcTarget, GetUnitToUnitDistance(bot, target)/nRSpeed)
				if IsStoneInPath(loc, (nUnitCR / 2) + 200) then
					return BOT_ACTION_DESIRE_HIGH, loc, false
				else
					return BOT_ACTION_DESIRE_HIGH, loc, true
				end
			end	
		elseif nStone < 1 and J.IsValidTarget(npcTarget) and J.CanCastOnNonMagicImmune(npcTarget) and J.IsInRange(npcTarget, bot, nUnitCR / 2)  then
			local loc = J.GetCorrectLoc(npcTarget, GetUnitToUnitDistance(bot, target)/nSpeed)
			return BOT_ACTION_DESIRE_HIGH, loc, false;
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0, false
end

function X.ConsiderGeomagneticGrip()
    if ( not GeomagneticGrip:IsFullyCastable() ) then
		return BOT_ACTION_DESIRE_NONE, 0, false, false
	end

	local nRadius     = GeomagneticGrip:GetSpecialValueInt('radius')
	local nSearchRad  = 175
	local nCastRange  = GeomagneticGrip:GetCastRange()
	local nCastPoint  = GeomagneticGrip:GetCastPoint( )
	local nManaCost   = GeomagneticGrip:GetManaCost( )
	local nDamage     = GeomagneticGrip:GetSpecialValueInt('rock_damage')

	if GripAllies ~= nil and GripAllies:IsTrained() then
		local tableNearbyAllies = bot:GetNearbyHeroes( nCastRange + 200, false, BOT_MODE_NONE )
		for _,ally in pairs(tableNearbyAllies)
		do
			if ally:GetActiveMode() == BOT_MODE_RETREAT and ally:WasRecentlyDamagedByAnyHero(2.0) then
				return BOT_ACTION_DESIRE_HIGH, ally:GetLocation(), false, true
			end
		end
	end

	local tableNearbyEnemyHeroes = bot:GetNearbyHeroes( nCastRange, true, BOT_MODE_NONE )
	local target = J.GetCanBeKilledUnit(tableNearbyEnemyHeroes, nDamage, DAMAGE_TYPE_MAGICAL, false)
	if target ~= nil then
		local loc = J.GetCorrectLoc(target, 2*nCastPoint)
		local stoneNearby = IsStoneNearby(loc, nSearchRad)
		if stoneNearby and ( nStone >= 1 or  nStone < 1 ) then
			return BOT_ACTION_DESIRE_HIGH, loc, false, true
		elseif nStone >= 1 then
			return BOT_ACTION_DESIRE_HIGH, loc, true, false
		end
	end

	if J.IsInTeamFight(bot, 1200)
	then
		local locationAoE = bot:FindAoELocation( true, true, bot:GetLocation(), nCastRange, nRadius, nCastPoint, 0)
		if (locationAoE.count >= 2)
		then
			local stoneNearby = IsStoneNearby(locationAoE.targetloc, nSearchRad)
			if stoneNearby and ( nStone >= 1 or  nStone < 1 ) then
				return BOT_ACTION_DESIRE_HIGH, locationAoE.targetloc, false, true
			elseif nStone >= 1 then
				return BOT_ACTION_DESIRE_HIGH, locationAoE.targetloc, true, false
			end
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		local npcTarget = bot:GetTarget()
		if J.IsValidTarget(npcTarget) and J.CanCastOnNonMagicImmune(npcTarget) and J.IsInRange(npcTarget, bot, nCastRange - 200)
		then
			local targetAlly  = npcTarget:GetNearbyHeroes(1000, false, BOT_MODE_NONE)
			local targetEnemy = npcTarget:GetNearbyHeroes(1000, true, BOT_MODE_NONE)
			if targetEnemy ~= nil and targetAlly ~= nil and #targetEnemy >= #targetAlly then
				local loc = J.GetCorrectLoc(npcTarget, 2*nCastPoint)
				local stoneNearby = IsStoneNearby(loc, nSearchRad)
				if stoneNearby and ( nStone >= 1 or  nStone < 1 ) then
					return BOT_ACTION_DESIRE_HIGH, loc, false, true
				elseif nStone >= 1 then
					return BOT_ACTION_DESIRE_HIGH, loc, true, false
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0, false, false
end

function X.ConsiderStoneCaller()
	if (not StoneCaller:IsFullyCastable()) then 
		return BOT_ACTION_DESIRE_NONE, 0
	end

	if DotaTime() < stoneCast + stoneCastGap then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastRange  = StoneCaller:GetCastRange( )
	local nRadius     = Magnetize:GetSpecialValueInt('rock_search_radius')

	local tableNearbyEnemyHeroes = bot:GetNearbyHeroes( nCastRange - 200, true, BOT_MODE_NONE )
	for _,npcEnemy in pairs( tableNearbyEnemyHeroes )
	do
		if npcEnemy:HasModifier('modifier_earth_spirit_magnetize')
		then
			local duration = npcEnemy:GetModifierRemainingDuration(npcEnemy:GetModifierByName('modifier_earth_spirit_magnetize'))
			if duration < 1.0 or CanChainMag(npcEnemy, nRadius) then
				return BOT_ACTION_DESIRE_MODERATE, npcEnemy:GetLocation()
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderPetrify()
	if ( not Petrify:IsFullyCastable() ) then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderMagnetize()
	if ( not Magnetize:IsFullyCastable() ) then 
		return BOT_ACTION_DESIRE_NONE
	end

	local nRadius    = Magnetize:GetSpecialValueInt( "cast_radius" )
	local nCastPoint = Magnetize:GetCastPoint( )
	local nManaCost  = Magnetize:GetManaCost( )

	if J.IsRetreating(bot) and bot:IsMagicImmune()
	then
		local tableNearbyEnemyHeroes = bot:GetNearbyHeroes( nRadius, true, BOT_MODE_NONE )
		for _,npcEnemy in pairs( tableNearbyEnemyHeroes )
		do
			if ( bot:WasRecentlyDamagedByHero( npcEnemy, 1.0 ) and J.CanCastOnNonMagicImmune(npcEnemy))
			then
				return BOT_ACTION_DESIRE_MODERATE
			end
		end
	end

	if J.IsInTeamFight(bot, 1200)
	then
		local tableNearbyEnemyHeroes = bot:GetNearbyHeroes( nRadius, true, BOT_MODE_NONE )
		if ( tableNearbyEnemyHeroes ~= nil and #tableNearbyEnemyHeroes >= 2 )
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		local npcTarget = bot:GetTarget()
		if J.IsValidTarget(npcTarget) and J.CanCastOnNonMagicImmune(npcTarget) and J.IsInRange(npcTarget, bot, nRadius - 100)
		then
			return BOT_ACTION_DESIRE_MODERATE
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

-- HELPER FUNCS --
function IsStoneNearby(location, radius)
	local units = GetUnitList(UNIT_LIST_ALLIED_OTHER);
	for _,u in pairs(units) do
		if u ~= nil and u:GetUnitName() == "npc_dota_earth_spirit_stone" and GetUnitToLocationDistance(u, location) < radius then
			return true;
		end
	end
	return false;
end 

function IsStoneInPath(location, dist)
	if bot:IsFacingLocation(location, 5) then
		local units = GetUnitList(UNIT_LIST_ALLIED_OTHER)
		for _,u in pairs(units) do
			if u ~= nil and u:GetUnitName() == "npc_dota_earth_spirit_stone"
			   and bot:IsFacingLocation(u:GetLocation(), 5) and GetUnitToUnitDistance(u, bot) < dist
			then
				return true
			end
		end
	end
	return false
end

function CanChainMag(target, radius)
	local enemies = target:GetNearbyHeroes(radius, false, BOT_MODE_NONE)
	for _,enemy in pairs(enemies)
	do
		if not enemy:HasModifier('modifier_earth_spirit_magnetize') then
			return true
		end
	end
	return false;
end

return X