local X             = {}
local bot           = GetBot()

local J             = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion        = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList   = J.Skill.GetTalentList( bot )
local sAbilityList  = J.Skill.GetAbilityList( bot )
local sOutfitType   = J.Item.GetOutfitType( bot )

local tTalentTreeList = {
						['t25'] = {10, 0},
						['t20'] = {0, 10},
						['t15'] = {0, 10},
						['t10'] = {10, 0},
}

local tAllAbilityBuildList = {
						{3,1,2,2,2,6,2,1,1,1,6,3,3,3,6},--pos4,5
}

local nAbilityBuildList = J.Skill.GetRandomBuild( tAllAbilityBuildList )

local nTalentBuildList = J.Skill.GetTalentBuild( tTalentTreeList )

local tOutFitList = {}

tOutFitList['outfit_carry'] = tOutFitList['outfit_carry']

tOutFitList['outfit_mid'] = tOutFitList['outfit_carry']

tOutFitList['outfit_tank'] = tOutFitList['outfit_carry']

tOutFitList['outfit_priest'] = {
    "item_tango",
    "item_tango",
    "item_double_branches",
    "item_enchanted_mango",
    "item_enchanted_mango",
    "item_faerie_fire",
    "item_blood_grenade",

    "item_tranquil_boots",
    "item_magic_wand",
    "item_force_staff",--
    "item_aghanims_shard",
    "item_veil_of_discord",
    "item_solar_crest",--
    "item_glimmer_cape",--
    "item_boots_of_bearing",--
    "item_shivas_guard",--
    "item_aeon_disk",--
    "item_ultimate_scepter_2",
    "item_moon_shard"
}

tOutFitList['outfit_mage'] = {
    "item_tango",
    "item_tango",
    "item_double_branches",
    "item_enchanted_mango",
    "item_enchanted_mango",
    "item_faerie_fire",
    "item_blood_grenade",

    "item_arcane_boots",
    "item_magic_wand",
    "item_force_staff",--
    "item_aghanims_shard",
    "item_solar_crest",--
    "item_glimmer_cape",--
    "item_guardian_greaves",--
    "item_sheepstick",--
    "item_aeon_disk",--
    "item_ultimate_scepter_2",
    "item_moon_shard"
}

X['sBuyList'] = tOutFitList[sOutfitType]

Pos4SellList = {
	"item_magic_wand",
}

Pos5SellList = {
	"item_magic_wand",
}

X['sSellList'] = {}

if sOutfitType == "outfit_priest"
then
    X['sSellList'] = Pos4SellList
elseif sOutfitType == "outfit_mage"
then
    X['sSellList'] = Pos5SellList
end

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

local ColdFeet          = bot:GetAbilityByName('ancient_apparition_cold_feet')
local IceVortex         = bot:GetAbilityByName('ancient_apparition_ice_vortex')
local ChillingTouch     = bot:GetAbilityByName('ancient_apparition_chilling_touch')
local IceBlast          = bot:GetAbilityByName('ancient_apparition_ice_blast')
local IceBlastRelease   = bot:GetAbilityByName('ancient_apparition_ice_blast_release')

local ColdFeetAoETalent = bot:GetAbilityByName('special_bonus_unique_ancient_apparition_7')

local ColdFeetDesire, ColdFeetTarget
local IceVortexDesire, IceVortextLocation
local ChillingTouchDesire, ChillingTouchTarget
local IceBlastDesire, IceBlastLocation
local IceBlastReleaseDesire

local IceBlastReleaseLocation

function X.SkillsComplement()
	if J.CanNotUseAbility(bot)
    or bot:IsInvisible()
    then
        return
    end

    IceBlastReleaseDesire = X.ConsiderIceBlastRelease()
    if IceBlastReleaseDesire > 0
    then
        bot:Action_UseAbility(IceBlastRelease)
        return
    end

    IceBlastDesire, IceBlastLocation = X.ConsiderIceBlast()
    if IceBlastDesire > 0
    then
        bot:Action_UseAbilityOnLocation(IceBlast, IceBlastLocation)
        IceBlastReleaseLocation = IceBlastLocation
        return
    end

    IceVortexDesire, IceVortextLocation = X.ConsiderIceVortex()
    if IceVortexDesire > 0
    then
        bot:Action_UseAbilityOnLocation(IceVortex, IceVortextLocation)
        return
    end

    ColdFeetDesire, ColdFeetTarget = X.ConsiderColdFeet()
    if ColdFeetDesire > 0
    then
        if ColdFeetAoETalent:IsTrained()
        then
            local nAoERadius = 450
            local nCastRange = ColdFeet:GetCastRange()
            local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nAoERadius, 0, 0)

            if nLocationAoE.count >= 1
            then
                bot:Action_UseAbilityOnLocation(ColdFeet, nLocationAoE.targetLoc)
            end
        else
            bot:Action_UseAbilityOnEntity(ColdFeet, ColdFeetTarget)
        end
        return
    end

    ChillingTouchDesire, ChillingTouchTarget = X.ConsiderChillingTouch()
    if ChillingTouchDesire > 0
    then
        bot:Action_UseAbilityOnEntity(ChillingTouch, ChillingTouchTarget)
        return
    end
end

function X.ConsiderColdFeet()
    if not ColdFeet:IsFullyCastable()
    then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = ColdFeet:GetCastRange()
    local botTarget = J.GetProperTarget(bot)
    local nEnemyHeroes = bot:GetNearbyHeroes(nCastRange, true, BOT_MODE_NONE)

    if J.IsGoingOnSomeone(bot)
    then
        if J.IsValidTarget(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not botTarget:HasModifier('modifier_cold_feet')
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

    if J.IsRetreating(bot)
    then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if J.GetHP(bot) <= 0.5
            and bot:WasRecentlyDamagedByHero(enemyHero, 2)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.IsInRange(bot, botTarget, nCastRange)
            and not botTarget:HasModifier('modifier_cold_feet')
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero
            end
        end
    end

    if J.IsDoingRoshan(bot)
    then
        if J.IsValidTarget(botTarget)
        and J.IsRoshan(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not botTarget:HasModifier('modifier_cold_feet')
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderIceVortex()
    if not IceVortex:IsFullyCastable()
    then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nCastRange = IceVortex:GetCastRange()
    local nRadius = IceVortex:GetSpecialValueInt('radius')
    local nCastPoint = IceVortex:GetCastPoint()
    local nMana = bot:GetMana() / bot:GetMaxMana()
    local botTarget = J.GetProperTarget(bot)
    local nEnemyHeroes = bot:GetNearbyHeroes(nCastRange, true, BOT_MODE_NONE)

    if J.IsGoingOnSomeone(bot)
	then
		if J.IsValidTarget(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
		and J.IsInRange(botTarget, bot, nCastRange+200)
        and not botTarget:HasModifier('modifier_ice_vortex')
		then
			return BOT_ACTION_DESIRE_MODERATE, botTarget:GetExtrapolatedLocation(nCastPoint)
		end
	end

    if J.IsRetreating(bot)
	then
		for _, enemyHero in pairs(nEnemyHeroes)
		do
            if bot:WasRecentlyDamagedByHero(enemyHero, 2)
            and J.GetHP(bot) <= 0.5
            and J.IsValidTarget(botTarget)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.IsInRange(bot, botTarget, nCastRange)
            and not botTarget:HasModifier('modifier_ice_vortex')
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero:GetExtrapolatedLocation(nCastPoint)
			end
		end
	end

    if (J.IsDefending(bot) or J.IsPushing(bot))
    and not J.IsThereCoreNearby(nCastRange)
    and nMana > 0.5
	then
		local lanecreeps = bot:GetNearbyLaneCreeps(nCastRange, true);
		local locationAoE = bot:FindAoELocation(true, false, bot:GetLocation(), nCastRange, nRadius, 0, 0)

		if locationAoE.count >= 4 and #lanecreeps >= 4
		then
			return BOT_ACTION_DESIRE_HIGH, locationAoE.targetloc
		end
	end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderChillingTouch()
    if not ChillingTouch:IsFullyCastable()
    then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = ChillingTouch:GetCastRange() + ChillingTouch:GetSpecialValueInt('attack_range_bonus')
    local nDamage = ChillingTouch:GetSpecialValueInt('damage')
    local botTarget = J.GetProperTarget(bot)
    local nAllyHeroes = bot:GetNearbyHeroes(nCastRange, false, BOT_MODE_RETREAT)

    if J.IsValidTarget(botTarget)
    and J.CanCastOnNonMagicImmune(botTarget)
    and J.IsInRange(bot, botTarget, nCastRange)
    and J.CanKillTarget(botTarget, nDamage, DAMAGE_TYPE_MAGICAL)
    then
        return BOT_ACTION_DESIRE_HIGH, botTarget
    end

    for _, allyHero in pairs(nAllyHeroes) do
        local allyTarget = allyHero:GetTarget()

        if J.GetHP(allyHero) < 0.55
        and J.IsValidTarget(allyTarget)
        and J.CanCastOnNonMagicImmune(allyTarget)
        and J.IsInRange(bot, allyTarget, nCastRange)
        and allyHero:WasRecentlyDamagedByHero(allyTarget, 2)
        then
            return BOT_ACTION_DESIRE_VERYHIGH, botTarget
        end
    end

    if J.IsGoingOnSomeone(bot)
	then
		if J.IsValidTarget(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not J.IsInRange(bot, botTarget, nCastRange - 300)
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

    if J.IsRetreating(bot)
    then
        if J.IsValidTarget(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and bot:WasRecentlyDamagedByHero(botTarget, 2)
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderIceBlast()
    if not IceBlast:IsFullyCastable()
    then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nTeamFightLocation = J.GetTeamFightLocation(bot)

    if nTeamFightLocation ~= nil
    then
        return BOT_ACTION_DESIRE_HIGH, nTeamFightLocation
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderIceBlastRelease()
    if not IceBlastRelease:IsFullyCastable()
    or IceBlastRelease:IsHidden()
    then
        return BOT_ACTION_DESIRE_NONE
    end

    local nProjectiles = GetLinearProjectiles()

    for _, p in pairs(nProjectiles)
	do
		if p ~= nil and p.ability:GetName() == "ancient_apparition_ice_blast"
        then
			if IceBlastReleaseLocation ~= nil
            and J.GetLocationToLocationDistance(IceBlastReleaseLocation, p.location) < 100
            then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

    return BOT_ACTION_DESIRE_NONE
end

return X