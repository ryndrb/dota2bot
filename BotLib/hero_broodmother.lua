local X             = {}
local bot           = GetBot()

local J             = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion        = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList   = J.Skill.GetTalentList( bot )
local sAbilityList  = J.Skill.GetAbilityList( bot )
local sOutfitType   = J.Item.GetOutfitType( bot )

local tTalentTreeList = {
						{--pos2
                            ['t25'] = {0, 10},
                            ['t20'] = {10, 0},
                            ['t15'] = {0, 10},
                            ['t10'] = {0, 10},
                        },
                        {--pos3
                            ['t25'] = {0, 10},
                            ['t20'] = {10, 0},
                            ['t15'] = {0, 10},
                            ['t10'] = {10, 0},
                        }
}

local tAllAbilityBuildList = {
						{2,3,2,3,2,6,2,3,3,1,6,1,1,1,6},--pos2
                        {2,3,2,1,2,6,2,3,3,3,6,1,1,1,6},--pos3
}

local nAbilityBuildList
local nTalentBuildList

if sOutfitType == "outfit_mid"
then
    nAbilityBuildList   = tAllAbilityBuildList[1]
    nTalentBuildList    = J.Skill.GetTalentBuild(tTalentTreeList[1])
elseif sOutfitType == "outfit_tank"
then
    nAbilityBuildList   = tAllAbilityBuildList[2]
    nTalentBuildList    = J.Skill.GetTalentBuild(tTalentTreeList[2])
end

local tOutFitList = {}

tOutFitList['outfit_carry'] = tOutFitList['outfit_carry']

tOutFitList['outfit_mid'] = {
    "item_tango",
    "item_double_branches",

    "item_double_wraith_band",
    "item_power_treads",
    "item_soul_ring",
    "item_magic_wand",
    "item_bloodthorn",--
    "item_black_king_bar",--
    "item_sheepstick",--
    "item_aghanims_shard",
    "item_nullifier",--
    "item_skadi",--
    "item_travel_boots_2",--
    "item_moon_shard",
    "item_ultimate_scepter",
    "item_ultimate_scepter_2",
}

tOutFitList['outfit_tank'] = {
    "item_tango",
    "item_double_branches",

    "item_double_wraith_band",
    "item_power_treads",
    "item_soul_ring",
    "item_magic_wand",
    "item_bloodthorn",--
    "item_black_king_bar",--
    "item_assault",--
    "item_aghanims_shard",
    "item_sheepstick",--
    "item_skadi",--
    "item_travel_boots_2",--
    "item_moon_shard",
    "item_ultimate_scepter",
    "item_ultimate_scepter_2",
}

tOutFitList['outfit_priest'] = tOutFitList['outfit_carry']

tOutFitList['outfit_mage'] = tOutFitList['outfit_carry']

X['sBuyList'] = tOutFitList[sOutfitType]

Pos2SellList = {
	"item_wraith_band",
    "item_soul_ring",
    "item_magic_wand"
}

Pos3SellList = {
	"item_wraith_band",
    "item_soul_ring",
    "item_magic_wand"
}

X['sSellList'] = {}

if sOutfitType == "outfit_mid"
then
    X['sSellList'] = Pos2SellList
elseif sOutfitType == "outfit_tank"
then
    X['sSellList'] = Pos3SellList
end

if J.Role.IsPvNMode() or J.Role.IsAllShadow() then X['sBuyList'], X['sSellList'] = { 'PvN_antimage' }, {} end

nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] = J.SetUserHeroInit( nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] )

X['sSkillList'] = J.Skill.GetSkillList( sAbilityList, nAbilityBuildList, sTalentList, nTalentBuildList )

X['bDeafaultAbility'] = false
X['bDeafaultItem'] = false

function X.MinionThink( hMinionUnit )
	Minion.MinionThink(hMinionUnit)
end

local InsatiableHunger  = bot:GetAbilityByName('broodmother_insatiable_hunger')
local SpinWeb           = bot:GetAbilityByName('broodmother_spin_web')
local SilkenBola        = bot:GetAbilityByName('broodmother_silken_bola')
-- local SpinnersSnare     = bot:GetAbilityByName('broodmother_sticky_snare')
local SpawnSpiderlings  = bot:GetAbilityByName('broodmother_spawn_spiderlings')

local InsatiableHungerDesire
local SpinWebDesire, SpinWebLocation
local SilkenBolaDesire, SilkenBolaTarget
-- local SpinnersSnareDesire, SpinnersSnareLocation -- No Unit.
local SpawnSpiderlingsDesire, SpirderlingsTarget

function X.SkillsComplement()
	if J.CanNotUseAbility(bot)
    or bot:IsInvisible()
    then
        return
    end

    SpawnSpiderlingsDesire, SpirderlingsTarget = X.ConsiderSpawnSpiderlings()
    if SpawnSpiderlingsDesire > 0
    then
        bot:Action_UseAbilityOnEntity(SpawnSpiderlings, SpirderlingsTarget)
        return
    end

    SpinWebDesire, SpinWebLocation = X.ConsiderSpinWeb()
    if SpinWebDesire > 0
    then
        bot:Action_UseAbilityOnLocation(SpinWeb, SpinWebLocation)
        return
    end

    SilkenBolaDesire, SilkenBolaTarget = X.ConsiderSilkenBola()
    if SilkenBolaDesire > 0
    then
        bot:Action_UseAbilityOnEntity(SilkenBola, SilkenBolaTarget)
        return
    end

    InsatiableHungerDesire = X.ConsiderInsatiableHunger()
    if InsatiableHungerDesire > 0
    then
        bot:Action_UseAbility(InsatiableHunger)
        return
    end
end

function X.ConsiderInsatiableHunger()
    if not InsatiableHunger:IsFullyCastable()
    then
        return BOT_ACTION_DESIRE_NONE
    end

    local nAttackRange = bot:GetAttackRange()
    local botTarget = J.GetProperTarget(bot)

    if J.IsGoingOnSomeone(bot)
    then
		if J.IsValidTarget(botTarget)
        and J.IsInRange(bot, botTarget, 1.5 * nAttackRange)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
    end

    if J.IsFarming(bot)
    then
        local botAttackTarget = bot:GetAttackTarget()
        local nNeutralCreeps = bot:GetNearbyNeutralCreeps(700)

        if botAttackTarget ~= nil
        and nNeutralCreeps ~= nil and #nNeutralCreeps > 0
        and J.GetHP(bot) < 0.4
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderSpinWeb()
    if not SpinWeb:IsFullyCastable()
    or bot:IsCastingAbility()
    or SpinWeb:IsInAbilityPhase()
    then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nRadius = SpinWeb:GetSpecialValueInt('radius')
	local nCastRange = SpinWeb:GetCastRange()
	local nCastPoint = SpinWeb:GetCastPoint()
    local botTarget = J.GetProperTarget(bot)
    local nEnemyTowers = bot:GetNearbyTowers(nRadius, false)
    local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(nCastRange, true)

    if J.IsStuck(bot)
	then
		return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
	end

    if J.IsLaning(bot)
    then
		if nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 4
        and not DoesLocationHaveWeb(bot:GetLocation(), nRadius)
        then
			return BOT_MODE_DESIRE_HIGH, bot:GetLocation()
		end
	end

    if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not DoesLocationHaveWeb(botTarget:GetExtrapolatedLocation(nCastPoint), nRadius)
		then
			return BOT_ACTION_DESIRE_MODERATE, botTarget:GetExtrapolatedLocation(nCastPoint)
		end
	end

    if J.IsRetreating(bot)
	then
		local nEnemyHeroes = bot:GetNearbyHeroes(nCastRange, true, BOT_MODE_NONE)

		for _, enemyHero in pairs(nEnemyHeroes)
		do
			if bot:WasRecentlyDamagedByHero(enemyHero, 2)
            and not DoesLocationHaveWeb(GetTowardsFountainLocation(bot:GetLocation(), nCastRange), nRadius)
			then
				return BOT_ACTION_DESIRE_HIGH, GetTowardsFountainLocation(bot:GetLocation(), nCastRange)
			end
		end
	end

    if J.IsPushing(bot)
	then
		local nLocationAoE = bot:FindAoELocation( true, false, bot:GetLocation(), nCastRange, nRadius / 2, 0, 0)

		if nLocationAoE.count >= 3 and #nEnemyLaneCreeps >= 3
        and not DoesLocationHaveWeb(nLocationAoE.targetloc, nRadius)
        then
			return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
		end

		if nEnemyTowers[1] ~= nil and J.CanBeAttacked(nEnemyTowers[1])
        and not DoesLocationHaveWeb(nEnemyTowers[1]:GetLocation(), nRadius)
		then
			return BOT_ACTION_DESIRE_HIGH, nEnemyTowers[1]:GetLocation()
		end
	end

	if J.IsDefending(bot)
	then
		if nEnemyTowers[1] ~= nil and J.CanBeAttacked(nEnemyTowers[1])
        and not DoesLocationHaveWeb(nEnemyTowers[1]:GetLocation(), nRadius)
		then
			return BOT_ACTION_DESIRE_HIGH, nEnemyTowers[1]:GetLocation()
		end
	end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderSilkenBola()
	if not SilkenBola:IsFullyCastable()
    then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = SilkenBola:GetCastRange()
    local nDamage = SilkenBola:GetSpecialValueInt('impact_damage')
    local botTarget = J.GetProperTarget(bot)
    local nEnemyHeroes = bot:GetNearbyHeroes(nCastRange, true, BOT_MODE_NONE)

    if J.IsValidTarget(botTarget)
    and J.CanCastOnNonMagicImmune(botTarget)
    and J.IsInRange(bot, botTarget, nCastRange)
    and J.CanKillTarget(botTarget, nDamage, DAMAGE_TYPE_MAGICAL)
    then
        return BOT_ACTION_DESIRE_ABSOLUTE, botTarget
    end

	if J.IsGoingOnSomeone(bot)
	then
		if J.IsValidTarget(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
		and not J.IsDisabled(botTarget)
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	if J.IsRetreating(bot)
	then
		for _, enemyHero in pairs(nEnemyHeroes)
		do
			if bot:WasRecentlyDamagedByHero(enemyHero, 2.0)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and not J.IsDisabled(enemyHero)
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderSpawnSpiderlings()
	if not SpawnSpiderlings:IsFullyCastable()
    then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastRange = SpawnSpiderlings:GetCastRange()
    local nMana = bot:GetMana() / bot:GetMaxMana()
	local nDamage = SpawnSpiderlings:GetSpecialValueInt('damage')
	local botTarget = J.GetProperTarget(bot)

	if J.IsValidTarget(botTarget)
    and J.CanCastOnNonMagicImmune(botTarget)
    and J.IsInRange(bot, botTarget, nCastRange)
    and J.CanKillTarget(botTarget, nDamage, DAMAGE_TYPE_MAGICAL)
	then
		return BOT_ACTION_DESIRE_ABSOLUTE, botTarget
	end

	if J.IsLaning(bot) or J.IsDefending(bot) or J.IsPushing(bot)
	then
		local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(nCastRange, true)
		for _, creep in pairs(nEnemyLaneCreeps)
		do
			if J.CanKillTarget(creep, nDamage, DAMAGE_TYPE_MAGICAL)
            and nMana > 0.5
            then
				return BOT_ACTION_DESIRE_HIGH, creep
			end
		end
	end

    if J.IsFarming(bot)
	then
		local nNeutralCreeps = bot:GetNearbyLaneCreeps(nCastRange, true)
		for _, creep in pairs(nNeutralCreeps)
		do
			if J.CanKillTarget(creep, nDamage, DAMAGE_TYPE_MAGICAL)
            and nMana > 0.5
            then
				return BOT_ACTION_DESIRE_HIGH, creep
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

-- Helper Funcs
function DoesLocationHaveWeb(location, nRadius)
	local unit = GetUnitList(UNIT_LIST_ALLIES)
	local locSize = (1.5 * nRadius) + 150

	for _, u in pairs (unit)
	do
		if u:GetUnitName() == 'npc_dota_broodmother_web'
        and GetUnitToLocationDistance(u, location) <= locSize
		then
			return true
		end
	end

	return false
end

function GetTowardsFountainLocation(unitLoc, distance)
	local destination = {}

	if GetTeam() == TEAM_RADIANT
    then
		destination[1] = unitLoc[1] - distance / math.sqrt(2)
		destination[2] = unitLoc[2] - distance / math.sqrt(2)
	end

	if GetTeam() == TEAM_DIRE
    then
		destination[1] = unitLoc[1] + distance / math.sqrt(2)
		destination[2] = unitLoc[2] + distance / math.sqrt(2)
	end

	return Vector(destination[1], destination[2])
end

return X