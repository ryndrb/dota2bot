local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_dawnbreaker'
then

local RI = require(GetScriptDirectory()..'/FunLib/util_role_item')

local sUtility = {"item_crimson_guard", "item_pipe", "item_lotus_orb", "item_heavens_halberd"}
local sUtilityItem = RI.GetBestUtilityItem(sUtility)

local HeroBuild = {
    ['pos_1'] = {
        [1] = {
            ['talent'] = {
                [1] = {},
            },
            ['ability'] = {
                [1] = {},
            },
            ['buy_list'] = {},
            ['sell_list'] = {},
        },
    },
    ['pos_2'] = {
        [1] = {
            ['talent'] = {
				[1] = {
					['t25'] = {0, 10},
					['t20'] = {10, 0},
					['t15'] = {0, 10},
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
                [1] = {2,1,2,3,2,6,2,1,1,1,6,3,3,3,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_quelling_blade",
			
				"item_bottle",
				"item_bracer",
				"item_boots",
				"item_soul_ring",
				"item_phase_boots",
				"item_magic_wand",
				"item_blade_mail",
				"item_echo_sabre",
				"item_aghanims_shard",
				"item_desolator",--
				"item_black_king_bar",--
				"item_assault",--
				"item_harpoon",--
				"item_basher",
				"item_greater_crit",--
				"item_abyssal_blade",--
				"item_ultimate_scepter_2",
				"item_moon_shard",
			},
            ['sell_list'] = {
				"item_quelling_blade",
				"item_bottle",
				"item_bracer",
				"item_phase_boots",
				"item_soul_ring",
				"item_magic_wand",
				"item_blade_mail",
			},
        },
    },
    ['pos_3'] = {
        [1] = {
            ['talent'] = {
				[1] = {
					['t25'] = {0, 10},
					['t20'] = {10, 0},
					['t15'] = {0, 10},
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
                [1] = {2,1,2,3,2,6,2,1,1,1,6,3,3,3,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_quelling_blade",
			
				"item_bracer",
				"item_boots",
				"item_soul_ring",
				"item_phase_boots",
				"item_magic_wand",
				"item_blade_mail",
				"item_echo_sabre",
				"item_aghanims_shard",
				"item_desolator",--
				"item_black_king_bar",--
				sUtilityItem,--
				"item_assault",--
				"item_harpoon",--
				"item_abyssal_blade",--
				"item_ultimate_scepter_2",
				"item_moon_shard",
			},
            ['sell_list'] = {
				"item_quelling_blade",
				"item_bracer",
				"item_phase_boots",
				"item_soul_ring",
				"item_magic_wand",
				"item_blade_mail",
			},
        },
    },
    ['pos_4'] = {
        [1] = {
            ['talent'] = {
				[1] = {
					['t25'] = {10, 0},
					['t20'] = {0, 10},
					['t15'] = {10, 0},
					['t10'] = {10, 0},
				}
            },
            ['ability'] = {
                [1] = {1,2,2,3,2,6,2,1,1,1,6,3,3,3,6},
            },
            ['buy_list'] = {
				"item_double_branches",
				"item_double_enchanted_mango",
				"item_faerie_fire",
				"item_blood_grenade",
			
				"item_boots",
				"item_magic_stick",
				"item_tranquil_boots",
				"item_magic_wand",
				"item_pavise",
				"item_solar_crest",--
				"item_ultimate_scepter",
				"item_holy_locket",--
				sUtilityItem,--
				"item_boots_of_bearing",--
				"item_assault",--
				"item_shivas_guard",--
				"item_ultimate_scepter_2",
				"item_aghanims_shard",
				"item_moon_shard",
			},
            ['sell_list'] = {},
        },
    },
    ['pos_5'] = {
        [1] = {
            ['talent'] = {
				[1] = {
					['t25'] = {10, 0},
					['t20'] = {0, 10},
					['t15'] = {10, 0},
					['t10'] = {10, 0},
				}
            },
            ['ability'] = {
                [1] = {1,2,2,3,2,6,2,1,1,1,6,3,3,3,6},
            },
            ['buy_list'] = {
				"item_double_branches",
				"item_double_enchanted_mango",
				"item_faerie_fire",
				"item_blood_grenade",
			
				"item_boots",
				"item_magic_stick",
				"item_arcane_boots",
				"item_magic_wand",
				"item_pavise",
				"item_guardian_greaves",--
				"item_solar_crest",--
				"item_ultimate_scepter",
				"item_holy_locket",--
				sUtilityItem,--
				"item_assault",--
				"item_shivas_guard",--
				"item_ultimate_scepter_2",
				"item_aghanims_shard",
				"item_moon_shard",
			},
            ['sell_list'] = {},
        },
    },
}

local sSelectedBuild = HeroBuild[sRole][RandomInt(1, #HeroBuild[sRole])]

local nTalentBuildList = J.Skill.GetTalentBuild(J.Skill.GetRandomBuild(sSelectedBuild.talent))
local nAbilityBuildList = J.Skill.GetRandomBuild(sSelectedBuild.ability)

X['sBuyList'] = sSelectedBuild.buy_list
X['sSellList'] = sSelectedBuild.sell_list

if J.Role.IsPvNMode() or J.Role.IsAllShadow() then X['sBuyList'], X['sSellList'] = { 'PvN_antimage' }, {} end

nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] = J.SetUserHeroInit( nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] )

X['sSkillList'] = J.Skill.GetSkillList( sAbilityList, nAbilityBuildList, sTalentList, nTalentBuildList )

X['bDeafaultAbility'] = false
X['bDeafaultItem'] = false

function X.MinionThink( hMinionUnit )
	Minion.MinionThink(hMinionUnit)
end

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

local ShouldBKB = false

local ConvergeHammerLocation = nil
local CelestialHammerTime = -1
local IsHammerCastedWhenRetreatingToEnemy = false

function X.SkillsComplement()
	if J.CanNotUseAbility(bot)
    then
        return
    end

	Starbreaker       = bot:GetAbilityByName('dawnbreaker_fire_wreath')
	CelestialHammer   = bot:GetAbilityByName('dawnbreaker_celestial_hammer')
	Converge          = bot:GetAbilityByName('dawnbreaker_converge')
	SolarGuardian     = bot:GetAbilityByName('dawnbreaker_solar_guardian')

    CelestialHammerDesire, CelestialHammerLocation = X.ConsiderCelestialHammer()
    if CelestialHammerDesire > 0
    then
        J.SetQueuePtToINT(bot, false)

        local nSpeed = CelestialHammer:GetSpecialValueInt('projectile_speed')
        ConvergeHammerLocation = CelestialHammerLocation

        if bot:GetUnitName() == 'npc_dota_hero_dawnbreaker'
        then
            CelestialHammerCastRangeTalent = bot:GetAbilityByName('special_bonus_unique_dawnbreaker_celestial_hammer_cast_range')
            if CelestialHammerCastRangeTalent:IsTrained()
            then
                nSpeed = nSpeed * (1 + (CelestialHammerCastRangeTalent:GetSpecialValueInt('value') / 100))
            end
        end

        bot:ActionQueue_UseAbilityOnLocation(CelestialHammer, CelestialHammerLocation)
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
		J.SetQueuePtToINT(bot, true)
        bot:ActionQueue_UseAbilityOnLocation(Starbreaker, StarbreakerLocation)
        return
    end

    SolarGuardianDesire, SolarGuardianLocation = X.ConsiderSolarGuardian()
    if SolarGuardianDesire > 0
    then
        J.SetQueuePtToINT(bot, false)

        if  J.CanBlackKingBar(bot)
        and ShouldBKB
        then
            bot:ActionQueue_UseAbility(bot.BlackKingBar)
            ShouldBKB = false
        end

        bot:ActionQueue_UseAbilityOnLocation(SolarGuardian, SolarGuardianLocation)
        return
    end
end

function X.ConsiderStarBreaker()
    if not J.CanCastAbility(Starbreaker)
    then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nRadius = Starbreaker:GetSpecialValueInt('swipe_radius')
    local nComboDuration = Starbreaker:GetSpecialValueFloat('duration')
	local nCastPoint = Starbreaker:GetCastPoint()
    local nDamage = bot:GetAttackDamage() + Starbreaker:GetSpecialValueInt('swipe_damage') + Starbreaker:GetSpecialValueInt('smash_damage')
    local botTarget = J.GetProperTarget(bot)

    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
    local nCreeps = bot:GetNearbyCreeps(nRadius, true)
    local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(nRadius, true)

    for _, enemyHero in pairs(nEnemyHeroes)
	do
        if  J.IsValidHero(enemyHero)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.IsInRange(bot, enemyHero, nRadius)
        then
            if enemyHero:IsChanneling() or J.IsCastingUltimateAbility(enemyHero)
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
            end

            if  J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_PHYSICAL)
            and not enemyHero:HasModifier('modifier_abaddon_aphotic_shield')
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
            then
                return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(enemyHero, nComboDuration + nCastPoint)
            end
        end
	end

	if J.IsInTeamFight(bot, 1200)
	then
		local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nRadius, nRadius, nComboDuration + nCastPoint, 0)

		if  nLocationAoE.count >= 2
        and not J.IsLocationInChrono(nLocationAoE.targetloc)
        then
            return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        and not J.IsSuspiciousIllusion(botTarget)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(botTarget, nComboDuration + nCastPoint)
		end
	end

    if J.IsFarming(bot)
    then
        if nCreeps ~= nil
        and J.CanBeAttacked(nCreeps[1])
        and not J.IsRunning(nCreeps[1])
        and ((#nCreeps >= 3)
            or (#nCreeps >= 2 and nCreeps[1]:IsAncientCreep()))
        then
            return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nCreeps)
        end
    end

    if J.IsPushing(bot) or J.IsDefending(bot)
    then
        if  nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 4
        and J.CanBeAttacked(nEnemyLaneCreeps[1])
        and not J.IsRunning(nEnemyLaneCreeps[1])
        then
            return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nEnemyLaneCreeps)
        end
    end

    if  J.IsLaning(bot)
	and J.GetManaAfter(Starbreaker:GetManaCost()) > 0.25
	then
        local creepCount = 0
        local loc = nil

		for _, creep in pairs(nEnemyLaneCreeps)
		do
			if  J.IsValid(creep)
            and J.CanBeAttacked(creep)
			and creep:GetHealth() <= nDamage
            and creep:GetHealth() > bot:GetAttackDamage()
			then
                loc = creep:GetLocation()
                creepCount = creepCount + 1
			end
		end

        if  creepCount >= 2
        and loc ~= nil
        then
            return BOT_ACTION_DESIRE_HIGH, loc
        end
	end

    if J.IsDoingRoshan(bot)
    then
        if  J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
    end

    if J.IsDoingTormentor(bot)
    then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderCelestialHammer()
	if not J.CanCastAbility(CelestialHammer)
    or bot:HasModifier('modifier_starbreaker_fire_wreath_caster')
    then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nCastRange = CelestialHammer:GetSpecialValueInt('range')
	local nCastPoint = CelestialHammer:GetCastPoint()
    local nSpeed = CelestialHammer:GetSpecialValueInt('projectile_speed')
    local nDamage = CelestialHammer:GetSpecialValueInt('hammer_damage')
    local botTarget = J.GetProperTarget(bot)

    if bot:GetUnitName() == 'npc_dota_hero_dawnbreaker'
    then
        local CelestialHammerCastRangeTalent = bot:GetAbilityByName('special_bonus_unique_dawnbreaker_celestial_hammer_cast_range')
        if CelestialHammerCastRangeTalent:IsTrained()
        then
            nCastRange = nCastRange * (1 + (CelestialHammerCastRangeTalent:GetSpecialValueInt('value') / 100))
            nSpeed = nSpeed * (1 + (CelestialHammerCastRangeTalent:GetSpecialValueInt('value') / 100))
        end
    end

    local nEnemyHeroes = bot:GetNearbyHeroes(math.min(nCastRange, 1600), true, BOT_MODE_NONE)
    local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(math.min(nCastRange, 1600), true)

    for _, enemyHero in pairs(nEnemyHeroes)
	do
		if  J.IsValidHero(enemyHero)
        and J.CanCastOnNonMagicImmune(enemyHero)
		and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
		and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
        and J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
        then
            local nDelay = (GetUnitToUnitDistance(bot, enemyHero) / nSpeed) + nCastPoint

            if J.IsRunning(enemyHero)
            then
                return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(enemyHero, nDelay)
            else
                return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
            end
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not J.IsInRange(bot, botTarget, 300)
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
		then
			local nDelay = (GetUnitToUnitDistance(bot, botTarget) / nSpeed) + nCastPoint
            if J.IsRunning(botTarget)
            then
                return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(botTarget, nDelay)
            else
                return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
            end
		end
	end

    if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
    and bot:WasRecentlyDamagedByAnyHero(4)
	then
		if J.IsValidHero(nEnemyHeroes[1])
        and not J.IsSuspiciousIllusion(nEnemyHeroes[1])
		and not J.IsRealInvisible(bot)
		then
            local nDelay = (GetUnitToUnitDistance(bot, nEnemyHeroes[1]) / nSpeed) + nCastPoint

            if GetUnitToUnitDistance(bot, nEnemyHeroes[1]) > 600
            then
                IsHammerCastedWhenRetreatingToEnemy = true
                return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(nEnemyHeroes[1], nDelay)
            else
                IsHammerCastedWhenRetreatingToEnemy = false
                local loc = J.GetEscapeLoc()
                return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, loc, nCastRange)
            end
		end
	end

    if  J.IsLaning(bot)
    and J.GetManaAfter(CelestialHammer:GetManaCost()) > 0.55
	then

        for _, creep in pairs(nEnemyLaneCreeps)
        do
            if  J.IsValid(creep)
            and J.CanBeAttacked(creep)
            and (J.IsKeyWordUnit('ranged', creep) or J.IsKeyWordUnit('siege', creep))
            and creep:GetHealth() <= nDamage
            and not J.IsRunning(creep)
            then
                if J.IsValidHero(nEnemyHeroes[1])
                and GetUnitToUnitDistance(creep, nEnemyHeroes[1]) <= 600
                then
                    return BOT_ACTION_DESIRE_HIGH, creep:GetLocation()
                end
            end
        end
	end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderConverge()
    if not J.CanCastAbility(Converge)
    then
        return BOT_ACTION_DESIRE_NONE
    end

    local nCastRange = 700 + ((Converge:GetLevel() - 1) * 200)
    local nSpeed = 1500
    local botTarget = J.GetProperTarget(bot)

    if bot:GetUnitName() == 'npc_dota_hero_dawnbreaker'
    then
        local CelestialHammerCastRangeTalent = bot:GetAbilityByName('special_bonus_unique_dawnbreaker_celestial_hammer_cast_range')
        if CelestialHammerCastRangeTalent:IsTrained()
        then
            nCastRange = nCastRange * (1 + (CelestialHammerCastRangeTalent:GetSpecialValueInt('value') / 100))
            nSpeed = nSpeed * (1 + (CelestialHammerCastRangeTalent:GetSpecialValueInt('value') / 100))
        end
    end

    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    if  J.IsGoingOnSomeone(bot)
    and ConvergeHammerLocation ~= nil
    then
		if  J.IsValidTarget(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, 1600)
        and not J.IsInRange(bot, botTarget, 300)
        and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
		then
            if GetUnitToLocationDistance(botTarget, ConvergeHammerLocation) < GetUnitToLocationDistance(bot, ConvergeHammerLocation)
            and DotaTime() >= CelestialHammerTime
            then
                return BOT_ACTION_DESIRE_HIGH
            end
		end
    end

    if  J.IsRetreating(bot)
    and IsHammerCastedWhenRetreatingToEnemy == false
    and not J.IsRealInvisible(bot)
    and bot:WasRecentlyDamagedByAnyHero(3)
    then
		if J.IsValidHero(nEnemyHeroes[1])
		then
            local loc = J.GetEscapeLoc()
            if  bot:IsFacingLocation(loc, 30)
            and DotaTime() >= CelestialHammerTime
            then
                return BOT_ACTION_DESIRE_HIGH
            end
		end
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderSolarGuardian()
    if not J.CanCastAbility(SolarGuardian)
    then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nChannelTime = SolarGuardian:GetChannelTime()
	local nRadius = SolarGuardian:GetSpecialValueInt('radius')
    local nAirTime = SolarGuardian:GetSpecialValueFloat('airtime_duration')
    local nCastPoint = SolarGuardian:GetCastPoint()
    local nTeamFightLocation = J.GetTeamFightLocation(bot)

    local nTotalCastTime = nChannelTime + nAirTime + nCastPoint

    if nTeamFightLocation ~= nil
    then
        local nAllyList = J.GetAlliesNearLoc(nTeamFightLocation, nRadius)

        if nAllyList ~= nil and #nAllyList >= 1
        then
            local allyHero = nAllyList[#nAllyList]
            if J.IsValidHero(allyHero)
            and not J.IsSuspiciousIllusion(allyHero)
            then
                local nNeabyEnemyNearAllyList = allyHero:GetNearbyHeroes(nRadius, true, BOT_MODE_NONE)

                if  not J.IsLocationInChrono(nTeamFightLocation)
                and (nNeabyEnemyNearAllyList ~= nil and #nNeabyEnemyNearAllyList >= 1)
                then
                    local aLocationAoE = bot:FindAoELocation(false, true, nTeamFightLocation, GetUnitToLocationDistance(bot, nTeamFightLocation), nRadius, nTotalCastTime, 0)
                    local eLocationAoE = bot:FindAoELocation(true, true, nTeamFightLocation, GetUnitToLocationDistance(bot, nTeamFightLocation), nRadius, nTotalCastTime, 0)
                    local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 700)

                    if aLocationAoE.count >= 1 and eLocationAoE.count >= 1
                    then
                        if  nInRangeEnemy ~= nil and #nInRangeEnemy >= 1
                        and not bot:IsMagicImmune()
                        then
                            ShouldBKB = true
                        end

                        return BOT_ACTION_DESIRE_HIGH, aLocationAoE.targetloc
                    end
                end
            end
        end
    end

    local nEnemyHeroes = bot:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
    if (J.IsRetreating(bot) and bot:DistanceFromFountain() > 1600 and J.GetHP(bot) < 0.33 and not J.IsRealInvisible(bot))
	then
		for _, enemyHero in pairs(nEnemyHeroes)
		do
			if J.IsValidHero(enemyHero)
            and bot:WasRecentlyDamagedByHero(enemyHero, 5.0)
			and not J.IsSuspiciousIllusion(enemyHero)
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
                and furthestAlly ~= nil and GetUnitToUnitDistance(bot, furthestAlly) > 1600
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