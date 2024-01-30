local X             = {}
local bot           = GetBot()

local J             = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion        = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList   = J.Skill.GetTalentList( bot )
local sAbilityList  = J.Skill.GetAbilityList( bot )
local sOutfitType   = J.Item.GetOutfitType( bot )

local tTalentTreeList = {
                        ['t25'] = {0, 10},
                        ['t20'] = {10, 0},
                        ['t15'] = {0, 10},
                        ['t10'] = {0, 10},
}

local tAllAbilityBuildList = {
                        {2,1,2,3,2,6,2,1,1,1,6,3,3,3,6},--pos3
}

local nAbilityBuildList = J.Skill.GetRandomBuild(tAllAbilityBuildList)

local nTalentBuildList = J.Skill.GetTalentBuild(tTalentTreeList)

local sUtility = {"item_crimson_guard", "item_pipe", "item_lotus_orb", "item_heavens_halberd"}
local nUtility = sUtility[RandomInt(1, #sUtility)]

local tOutFitList = {}

tOutFitList['outfit_carry'] = tOutFitList['outfit_carry']

tOutFitList['outfit_mid'] = tOutFitList['outfit_carry']

tOutFitList['outfit_tank'] = {
    "item_tango",
    "item_double_branches",
    "item_quelling_blade",

    "item_bracer",
    "item_phase_boots",
    "item_magic_wand",
    "item_soul_ring",
    "item_echo_sabre",
    "item_desolator",--
    "item_aghanims_shard",
    "item_black_king_bar",--
    nUtility,--
    "item_assault",--
    "item_harpoon",--
    "item_abyssal_blade",--
    "item_ultimate_scepter",
    "item_recipe_ultimate_scepter_2",
    "item_moon_shard",
}

tOutFitList['outfit_priest'] = tOutFitList['outfit_carry']

tOutFitList['outfit_mage'] = tOutFitList['outfit_carry']

X['sBuyList'] = tOutFitList[sOutfitType]

X['sSellList'] = {
    "item_quelling_blade",
    "item_bracer",
    "item_phase_boots",
    "item_magic_wand",
    "item_soul_ring",
}

if J.Role.IsPvNMode() or J.Role.IsAllShadow() then X['sBuyList'], X['sSellList'] = { 'PvN_antimage' }, {} end

nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] = J.SetUserHeroInit( nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] )

X['sSkillList'] = J.Skill.GetSkillList( sAbilityList, nAbilityBuildList, sTalentList, nTalentBuildList )

X['bDeafaultAbility'] = false
X['bDeafaultItem'] = false

function X.MinionThink( hMinionUnit )
	Minion.MinionThink(hMinionUnit)
end

local Starbreaker       = bot:GetAbilityByName('dawnbreaker_fire_wreath')
local CelestialHammer   = bot:GetAbilityByName('dawnbreaker_celestial_hammer')
local Converge          = bot:GetAbilityByName('dawnbreaker_converge')
-- local Luminosity        = bot:GetAbilityByName('dawnbreaker_luminosity')
local SolarGuardian     = bot:GetAbilityByName('dawnbreaker_solar_guardian')

local CelestialHammerCastRangeTalent = bot:GetAbilityByName('special_bonus_unique_dawnbreaker_celestial_hammer_cast_range')

local StarbreakerDesire, StarbreakerLocation
local CelestialHammerDesire, CelestialHammerLocation
local ConvergeDesire
local SolarGuardianDesire, SolarGuardianLocation

local CelestialHammerTime = -1
local IsHammerCastedWhenRetreatingToEnemy = false

function X.SkillsComplement()
	if J.CanNotUseAbility(bot)
    then
        return
    end

    CelestialHammerDesire, CelestialHammerLocation = X.ConsiderCelestialHammer()
    if CelestialHammerDesire > 0
    then
        local nSpeed = CelestialHammer:GetSpecialValueInt('projectile_speed')

        bot:Action_UseAbilityOnLocation(CelestialHammer, CelestialHammerLocation)
        CelestialHammerTime = DotaTime() + CelestialHammer:GetCastPoint() + (GetUnitToLocationDistance(bot, CelestialHammerLocation) / nSpeed)
        return
    end

    ConvergeDesire = X.ConsiderConverge()
    if ConvergeDesire > 0
    then
        bot:Action_UseAbility(Converge)
        return
    end

    StarbreakerDesire, StarbreakerLocation = X.ConsiderStarBreaker()
    if StarbreakerDesire > 0
    then
        bot:Action_UseAbilityOnLocation(Starbreaker, StarbreakerLocation)
        return
    end

    SolarGuardianDesire, SolarGuardianLocation = X.ConsiderSolarGuardian()
    if SolarGuardianDesire > 0
    then
        bot:Action_UseAbilityOnLocation(SolarGuardian, SolarGuardianLocation)
        return
    end
end

function X.ConsiderStarBreaker()
    if not Starbreaker:IsFullyCastable()
    then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nRadius = Starbreaker:GetSpecialValueInt('swipe_radius')
	local nCastPoint = Starbreaker:GetCastPoint()

    local nInRangeEnemyHeroes = bot:GetNearbyHeroes(nRadius, true, BOT_MODE_NONE)
    for _, enemyHero in pairs(nInRangeEnemyHeroes)
	do
		if  enemyHero:IsChanneling() or J.IsCastingUltimateAbility(enemyHero)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and not J.IsSuspiciousIllusion(enemyHero)
        then
			return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
		end
	end

	if J.IsInTeamFight(bot, 1200)
	then
		local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nRadius, nRadius, nCastPoint, 0)

		if nLocationAoE.count >= 2
        then
			local target = J.GetVulnerableUnitNearLoc(bot, true, true, nRadius, nRadius, nLocationAoE.targetloc)

			if  J.IsValidTarget(target)
            and not J.IsSuspiciousIllusion(target)
            then
				return BOT_ACTION_DESIRE_HIGH, target:GetLocation()
			end
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		local botTarget = J.GetProperTarget(bot)

		if  J.IsValidTarget(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        and not J.IsSuspiciousIllusion(botTarget)
        and not J.IsDisabled(botTarget)
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

    if J.IsFarming(bot)
    then
        local botAttackTarget = bot:GetAttackTarget()
        local nNeutralCreeps = bot:GetNearbyNeutralCreeps(300)
        local nLocationAoE = bot:FindAoELocation(true, false, bot:GetLocation(), nRadius, nRadius, 0, 0)

        if  J.IsValid(botAttackTarget)
        and (botAttackTarget:IsCreep() or botAttackTarget:IsAncientCreep())
        and nNeutralCreeps ~= nil and #nNeutralCreeps >= 2
        and nLocationAoE.count >= 2
        then
            return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
        end
    end

    if J.IsPushing(bot)
    then
        local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(nRadius, true)
        local nLocationAoE = bot:FindAoELocation(true, false, bot:GetLocation(), nRadius, nRadius, 0, 0)

        if  nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 4
        and nLocationAoE.count >= 4
        then
            return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
        end
    end

    if J.IsDoingRoshan(bot)
    then
        local botAttackTarget = bot:GetAttackTarget()
        if  J.IsRoshan(botAttackTarget)
        and J.IsInRange(bot, botAttackTarget, nRadius)
        then
            return BOT_ACTION_DESIRE_HIGH, botAttackTarget:GetLocation()
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderCelestialHammer()
    if not CelestialHammer:IsFullyCastable()
    or bot:HasModifier('modifier_starbreaker_fire_wreath_caster')
    then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nCastRange = CelestialHammer:GetSpecialValueInt('range')
	local nCastPoint = CelestialHammer:GetCastPoint()
    local nDamage = CelestialHammer:GetSpecialValueInt('hammer_damage')

    if CelestialHammerCastRangeTalent:IsTrained()
    then
        nCastRange = nCastRange * (1 + (CelestialHammerCastRangeTalent:GetSpecialValueInt('value') / 100))
    end

    local nInRangeEnemyHeroes = bot:GetNearbyHeroes(nCastRange, true, BOT_MODE_NONE)
    for _, enemyHero in pairs(nInRangeEnemyHeroes)
	do
		if  J.IsValidHero(enemyHero)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and not J.IsSuspiciousIllusion(enemyHero)
        and J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL, nCastPoint)
        then
			return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		local botTarget = J.GetProperTarget(bot)
        local nAllyHeroes = bot:GetNearbyHeroes(nCastRange, false, BOT_MODE_NONE)

		if  J.IsValidTarget(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not J.IsInRange(bot, botTarget, 300)
        and not J.IsSuspiciousIllusion(botTarget)
        and nInRangeEnemyHeroes ~= nil and nAllyHeroes ~= nil
        and #nInRangeEnemyHeroes <= #nAllyHeroes
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

    if J.IsRetreating(bot)
	or (J.IsRetreating(bot) and J.GetHP(bot) < 0.33 and bot:DistanceFromFountain() > 600)
	then
		if  J.ShouldEscape(bot)
		and not J.IsRealInvisible(bot)
		then
			local loc = J.GetEscapeLoc()

            if nInRangeEnemyHeroes ~= nil and #nInRangeEnemyHeroes >= 1
            then
                if GetUnitToUnitDistance(bot, nInRangeEnemyHeroes[1]) > 600
                then
                    IsHammerCastedWhenRetreatingToEnemy = true
                    return BOT_ACTION_DESIRE_HIGH, nInRangeEnemyHeroes[1]:GetLocation()
                else
                    IsHammerCastedWhenRetreatingToEnemy = false
                    return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, loc, nCastRange)
                end
            end
		end
	end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderConverge()
    if not Converge:IsFullyCastable()
    then
        return BOT_ACTION_DESIRE_NONE
    end

    local nCastRange = CelestialHammer:GetSpecialValueInt('range')
    local nEnemyHeroes = bot:GetNearbyHeroes(nCastRange, true, BOT_MODE_NONE)

    if CelestialHammerCastRangeTalent:IsTrained()
    then
        nCastRange = nCastRange * (1 + (CelestialHammerCastRangeTalent:GetSpecialValueInt('value') / 100))
    end

    if DotaTime() - CelestialHammerTime <= 1
    then
        if J.IsGoingOnSomeone(bot)
        then
            if nEnemyHeroes ~= nil and #nEnemyHeroes <= 2
            and GetUnitToLocationDistance(nEnemyHeroes[1], CelestialHammerLocation) <= GetUnitToLocationDistance(bot, CelestialHammerLocation)
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end

        if  J.IsRetreating(bot)
        and not IsHammerCastedWhenRetreatingToEnemy
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderSolarGuardian()
    if not SolarGuardian:IsFullyCastable()
    or bot:HasModifier('modifier_starbreaker_fire_wreath_caster')
    then
        return BOT_ACTION_DESIRE_NONE, 0
    end

	local nRadius   = SolarGuardian:GetSpecialValueInt('radius')
    local nTeamFightLocation = J.GetTeamFightLocation(bot)

    if nTeamFightLocation ~= nil
    then
        local nAllyList = J.GetAlliesNearLoc(nTeamFightLocation, nRadius)
        local coreCount = 0

        if nAllyList ~= nil and #nAllyList >= 2
        then
            local nNeabyEnemyNearAllyList = nAllyList[#nAllyList]:GetNearbyHeroes(nRadius, true, BOT_MODE_NONE)

            for _, ally in pairs(nAllyList)
            do
                if  J.IsCore(ally)
                and not ally:HasModifier('modifier_faceless_void_chronosphere')
                then
                    coreCount = coreCount + 1
                end
            end

            if  coreCount >= 1
            and (nNeabyEnemyNearAllyList ~= nil and #nNeabyEnemyNearAllyList >= 2)
            and (GetUnitToLocationDistance(bot, nTeamFightLocation) > 2000
                or (GetUnitToLocationDistance(bot, nTeamFightLocation) <= nRadius + 100 and J.GetHP(bot) < 0.33 and bot:WasRecentlyDamagedByAnyHero(2)))
            then
                local aLocationAoE = bot:FindAoELocation(false, true, nTeamFightLocation, GetUnitToLocationDistance(bot, nTeamFightLocation), nRadius, 0, 0)
                local eLocationAoE = bot:FindAoELocation(true, true, nTeamFightLocation, GetUnitToLocationDistance(bot, nTeamFightLocation), nRadius, 0, 0)
                local nEnemyHeroes = bot:GetNearbyHeroes(nRadius, true, BOT_MODE_NONE)

                if  aLocationAoE.count >= 1 and eLocationAoE.count >= 1
                and ((nEnemyHeroes ~= nil and #nEnemyHeroes <= 1) or bot:IsMagicImmune())
                then
                    return BOT_ACTION_DESIRE_HIGH, aLocationAoE.targetloc
                end
            end
        end
    end

    local nEnemyHeroes = bot:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
    if (J.IsRetreating(bot) and bot:DistanceFromFountain() > 1600 and J.GetHP(bot) < 0.33)
	then
		for _, enemyHero in pairs(nEnemyHeroes)
		do
			if  bot:WasRecentlyDamagedByHero(enemyHero, 2.0)
			and not J.IsSuspiciousIllusion(enemyHero)
			and not J.IsRealInvisible(bot)
			then
                local nAllyHeroes = bot:GetNearbyHeroes(1000, false, BOT_MODE_NONE)
                local furthestAlly = nil

                for i = 1, 5
                do
                    local ally = GetTeamMember(i)
                    local dist = 0

                    if  ally ~= nil
                    and ally:IsAlive()
                    and GetUnitToUnitDistance(bot, ally) > dist
                    then
                        dist = GetUnitToUnitDistance(bot, ally)
                        furthestAlly = ally
                    end
                end

				if  nAllyHeroes ~= nil
				and (#nAllyHeroes <= 1 and #nEnemyHeroes >= 3)
                and furthestAlly ~= nil and GetUnitToUnitDistance(bot, furthestAlly) > 2500
                and bot:IsMagicImmune()
				then
					return BOT_ACTION_DESIRE_MODERATE, furthestAlly:GetLocation()
				end
			end
		end
	end

    return BOT_ACTION_DESIRE_NONE, 0
end

return X