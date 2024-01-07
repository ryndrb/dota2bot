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
						['t15'] = {10, 0},
						['t10'] = {10, 0},
}

local tAllAbilityBuildList = {
						{3,1,3,2,3,6,3,1,1,1,2,6,2,2,6},--pos2
}

local nAbilityBuildList = J.Skill.GetRandomBuild( tAllAbilityBuildList )

local nTalentBuildList = J.Skill.GetTalentBuild( tTalentTreeList )

local tOutFitList = {}

tOutFitList['outfit_carry'] = tOutFitList['outfit_mid']

tOutFitList['outfit_mid'] = {
    "item_tango",
    "item_double_branches",
    "item_circlet",
    "item_gauntlets",

    "item_bottle",
    "item_bracer",
    "item_boots",
    "item_magic_wand",
    "item_power_treads",
    "item_echo_sabre",
    "item_ultimate_scepter",
    "item_manta",--
    "item_black_king_bar",--
    "item_travel_boots",
    "item_greater_crit",--
    "item_sheepstick",--
    "item_ultimate_scepter_2",
    "item_travel_boots_2",--
    "item_bloodthorn",--
    "item_moon_shard",
    "item_aghanims_shard",
}

tOutFitList['outfit_priest'] = tOutFitList['outfit_carry']

tOutFitList['outfit_mage'] = tOutFitList['outfit_carry']

tOutFitList['outfit_tank'] = tOutFitList['outfit_carry']

X['sBuyList'] = tOutFitList[sOutfitType]

X['sSellList'] = {
    "item_bottle",
    "item_magic_wand",
    "item_bracer",
    "item_echo_sabre",
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

local AetherRemnant = bot:GetAbilityByName( "void_spirit_aether_remnant" )
local Dissimilate   = bot:GetAbilityByName( "void_spirit_dissimilate" )
local ResonantPulse = bot:GetAbilityByName( "void_spirit_resonant_pulse" )
local AstralStep    = bot:GetAbilityByName( "void_spirit_astral_step" )

local AetherRemnantDesire
local DissimilateDesire
local ResonantPulseDesire
local AstralStepDesire

local remnantCastTime = -100
local remnantCastGap  = 0.2

function X.SkillsComplement()
    if J.CanNotUseAbility(bot) then return end

    AetherRemnantDesire, aetherRemnantLoc   = X.ConsiderAetherRemnant()
    DissimilateDesire                       = X.ConsiderDissimilate()
    ResonantPulseDesire                     = X.ConsiderResonantPulse()
    AstralStepDesire, astralStepLoc         = X.ConsiderAstralStep()
   
    if AetherRemnantDesire > 0
    then
        bot:Action_UseAbilityOnLocation(AetherRemnant, aetherRemnantLoc)
    end

    if DissimilateDesire > 0
    then
        bot:Action_UseAbility(Dissimilate)
    end

    if ResonantPulseDesire > 0
    then
        bot:Action_UseAbility(ResonantPulse)
    end

    if AstralStepDesire > 0
    then
        remnantCastTime = DotaTime()
        bot:Action_UseAbilityOnLocation(AstralStep, astralStepLoc)
    end

end

function X.ConsiderAetherRemnant()
    if ( not AetherRemnant:IsFullyCastable() ) then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nRadius    = AetherRemnant:GetSpecialValueInt('radius')
	local nCastRange = AetherRemnant:GetCastRange()
	local nCastPoint = AetherRemnant:GetCastPoint()
	local nManaCost  = AetherRemnant:GetManaCost()
	local nDamage    = AetherRemnant:GetSpecialValueInt( 'impact_damage')

	local nEnemyHeroes = bot:GetNearbyHeroes(nCastRange, true, BOT_MODE_NONE)

	for _, npcEnemy in pairs(nEnemyHeroes)
	do
		if J.IsValidTarget(npcEnemy)
		and J.CanCastOnNonMagicImmune(npcEnemy)
		and J.IsInRange(npcEnemy, bot, nCastRange)
		and J.CanKillTarget(npcEnemy, nDamage, DAMAGE_TYPE_PHYSICAL)
		then
			local loc = npcEnemy:GetLocation()
			local adjLoc = {x = loc.x - 100, y = loc.y - 100, z = loc.z - 100}
			return BOT_ACTION_DESIRE_HIGH, adjLoc
		end
	end

	if J.IsRetreating(bot)
	then
		for _, npcEnemy in pairs(nEnemyHeroes)
		do
			if bot:WasRecentlyDamagedByHero(npcEnemy, 2.0)
			and J.CanCastOnNonMagicImmune(npcEnemy)
			then
				return BOT_ACTION_DESIRE_MODERATE, bot:GetLocation()
			end
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		local npcTarget = bot:GetTarget()
		if J.IsValidTarget(npcTarget)
		and J.CanCastOnNonMagicImmune(npcTarget)
		and J.IsInRange(npcTarget, bot, nCastRange)
		then
			local loc = npcTarget:GetLocation()
			local adjLoc = {x = loc.x - 100, y = loc.y - 100, z = loc.z - 100}
			return BOT_ACTION_DESIRE_HIGH, adjLoc
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderDissimilate()
    if ( not Dissimilate:IsFullyCastable() ) then 
		return BOT_ACTION_DESIRE_NONE;
	end

	local nRadius   = Dissimilate:GetSpecialValueInt( "first_ring_distance_offset" );
	local nDamage   = Dissimilate:GetAbilityDamage();
	local nManaCost = Dissimilate:GetManaCost( );

	if J.IsRetreating(bot)
	then
		local nEnemyHeroes = bot:GetNearbyHeroes(nRadius * 2, true, BOT_MODE_NONE)
		for _, npcEnemy in pairs(nEnemyHeroes)
		do
			if bot:WasRecentlyDamagedByHero(npcEnemy, 2.0)
			then
				return BOT_ACTION_DESIRE_MODERATE
			end
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		local npcTarget = bot:GetTarget()
		if J.IsValidTarget(npcTarget)
		and J.CanCastOnNonMagicImmune(npcTarget)
		and J.IsInRange(npcTarget, bot, nRadius)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderResonantPulse()
    if (not ResonantPulse:IsFullyCastable()) then
		return BOT_ACTION_DESIRE_NONE
	end

	local nRadius   = ResonantPulse:GetSpecialValueInt( "radius" )
	local nDamage   = ResonantPulse:GetSpecialValueInt( "damage" )
	local nManaCost = ResonantPulse:GetManaCost()

	local nEnemyHeroes = bot:GetNearbyHeroes( nRadius, true, BOT_MODE_NONE )

	for _, npcEnemy in pairs(nEnemyHeroes)
	do
		if J.CanCastOnNonMagicImmune(npcEnemy)
		and J.CanKillTarget(npcEnemy, nDamage, DAMAGE_TYPE_MAGICAL)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsRetreating(bot)
	then
		for _,npcEnemy in pairs(nEnemyHeroes)
		do
			if bot:WasRecentlyDamagedByHero(npcEnemy, 2.0)
			and J.CanCastOnNonMagicImmune(npcEnemy)
			then
				return BOT_ACTION_DESIRE_MODERATE
			end

			if J.CanKillTarget(npcEnemy, nDamage, DAMAGE_TYPE_MAGICAL)
			and J.CanCastOnNonMagicImmune(npcEnemy)
			then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if J.IsInTeamFight(bot, 1200)
	then
		if nEnemyHeroes ~= nil and #nEnemyHeroes >= 2
		and J.CanCastOnNonMagicImmune(nEnemyHeroes[1])
		then
			return BOT_ACTION_DESIRE_MODERATE
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		local npcTarget = bot:GetTarget()
		if J.IsValidTarget(npcTarget)
		and J.CanCastOnNonMagicImmune(npcTarget)
		and J.IsInRange(npcTarget, bot, nRadius)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderAstralStep()
	if not AstralStep:IsFullyCastable()
	or bot:IsRooted()
	or DotaTime() <= remnantCastTime + remnantCastGap
	then
		return BOT_ACTION_DESIRE_NONE, {}
	end

	local nRadius      = AstralStep:GetSpecialValueInt( "radius" )
	local nCastRange   = AstralStep:GetSpecialValueInt("max_travel_distance")
	local nCastPoint   = AstralStep:GetCastPoint()
	local nDamage      = AstralStep:GetSpecialValueInt( "pop_damage" )
	local nSpeed       = 3000
	local nManaCost    = AstralStep:GetManaCost()

	local nEnemyHeroes = bot:GetNearbyHeroes( nCastRange, true, BOT_MODE_NONE )

	for _,npcEnemy in pairs(nEnemyHeroes)
	do
		if J.CanCastOnMagicImmune(npcEnemy)
		and J.CanKillTarget(npcEnemy, nDamage, DAMAGE_TYPE_MAGICAL)
		then
			return BOT_ACTION_DESIRE_HIGH, npcEnemy:GetExtrapolatedLocation(nCastPoint)
		end
	end

	if J.IsRetreating(bot)
	then
		for _, npcEnemy in pairs(nEnemyHeroes)
		do
			if (bot:WasRecentlyDamagedByHero(npcEnemy, 2.0))
			then
				local loc = J.GetEscapeLoc()
				return BOT_ACTION_DESIRE_MODERATE, J.Site.GetXUnitsTowardsLocation(bot, loc, nCastRange)
			end
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		local npcTarget = bot:GetTarget()
		if J.IsValidTarget(npcTarget)
		and J.CanCastOnMagicImmune(npcTarget)
		and J.IsInRange(npcTarget, bot, nCastRange)
		then
			local targetAlly  = npcTarget:GetNearbyHeroes(nCastRange, false, BOT_MODE_NONE)
			local targetEnemy = npcTarget:GetNearbyHeroes(nCastRange, true, BOT_MODE_NONE)
			if targetEnemy ~= nil and targetAlly ~= nil and #targetEnemy >= #targetAlly then
				return BOT_ACTION_DESIRE_HIGH, npcTarget:GetExtrapolatedLocation(nCastPoint)
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, {}
end

return X