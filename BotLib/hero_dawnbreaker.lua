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

local sUtility = {"item_nullifier", "item_lotus_orb", "item_heavens_halberd"}
local sUtilityItem = RI.GetBestUtilityItem(sUtility)

local HeroBuild = {
    ['pos_1'] = {
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
                "item_circlet",
                "item_gauntlets",
			
				"item_magic_wand",
				"item_bracer",
				"item_phase_boots",
                "item_echo_sabre",
                "item_desolator",--
                "item_black_king_bar",--
				"item_aghanims_shard",
                "item_harpoon",--
                "item_satanic",--
                "item_abyssal_blade",--
				"item_ultimate_scepter_2",
				"item_moon_shard",
                "item_bloodthorn",--
			},
            ['sell_list'] = {
				"item_quelling_blade", "item_black_king_bar",
				"item_bracer", "item_satanic",
				"item_magic_wand", "item_abyssal_blade",
                "item_phase_boots", "item_bloodthorn",
			},
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
                "item_circlet",
                "item_gauntlets",
			
                "item_bottle",
				"item_magic_wand",
				"item_bracer",
				"item_boots",
				"item_soul_ring",
				"item_phase_boots",
				"item_blade_mail",
                "item_desolator",--
				"item_black_king_bar",--
				"item_harpoon",--
                "item_basher",
				"item_aghanims_shard",
				"item_abyssal_blade",--
                "item_shivas_guard",--
				"item_moon_shard",
				"item_ultimate_scepter_2",
                "item_wind_waker",--
			},
            ['sell_list'] = {
				"item_quelling_blade", "item_blade_mail",
				"item_magic_wand", "item_desolator",
				"item_bracer", "item_black_king_bar",
				"item_soul_ring", "item_harpoon",
                "item_bottle", "item_basher",
				"item_phase_boots", "item_shivas_guard",
				"item_blade_mail", "item_wind_waker",
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
                "item_circlet",
                "item_gauntlets",
			
				"item_magic_wand",
				"item_bracer",
				"item_boots",
				"item_soul_ring",
				"item_phase_boots",
				"item_blade_mail",
                "item_crimson_guard",--
				"item_black_king_bar",--
				"item_harpoon",--
				sUtilityItem,--
				"item_aghanims_shard",
				"item_assault",--
				"item_ultimate_scepter_2",
				"item_moon_shard",
				"item_abyssal_blade",--
			},
            ['sell_list'] = {
				"item_quelling_blade", "item_crimson_guard",
				"item_magic_wand", "item_black_king_bar",
				"item_soul_ring", "item_harpoon",
				"item_bracer", sUtilityItem,
				"item_phase_boots", "item_assault",
				"item_blade_mail", "item_abyssal_blade",
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
                [2] = {2,1,2,1,2,6,2,3,1,1,6,3,3,3,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_faerie_fire",
				"item_blood_grenade",
			
				"item_magic_wand",
				"item_tranquil_boots",
                "item_blade_mail",
				"item_solar_crest",--
                "item_ancient_janggo",
				"item_ultimate_scepter",
				"item_boots_of_bearing",--
				"item_aghanims_shard",
                "item_sheepstick",--
                "item_shivas_guard",--
				"item_wind_waker",--
				"item_ultimate_scepter_2",
				"item_abyssal_blade",--
				"item_moon_shard",
			},
            ['sell_list'] = {
                "item_magic_wand", "item_shivas_guard",
                "item_blade_mail", "item_abyssal_blade",
            },
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
                [2] = {2,1,2,1,2,6,2,3,1,1,6,3,3,3,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_faerie_fire",
				"item_blood_grenade",
			
				"item_magic_wand",
				"item_arcane_boots",
                "item_blade_mail",
				"item_solar_crest",--
                "item_mekansm",
				"item_ultimate_scepter",
				"item_guardian_greaves",--
				"item_aghanims_shard",
                "item_sheepstick",--
                "item_shivas_guard",--
				"item_wind_waker",--
				"item_ultimate_scepter_2",
				"item_abyssal_blade",--
				"item_moon_shard",
			},
            ['sell_list'] = {
                "item_magic_wand", "item_shivas_guard",
                "item_blade_mail", "item_abyssal_blade",
            },
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

local bShouldBKB = false

local vConvergeHammerLocation = nil
local fCelestialHammerTime = -1
local bIsHammerCastedWhenRetreatingToEnemy = false

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
    bot = GetBot()

	if J.CanNotUseAbility(bot) then
        return
    end

	Starbreaker       = bot:GetAbilityByName('dawnbreaker_fire_wreath')
	CelestialHammer   = bot:GetAbilityByName('dawnbreaker_celestial_hammer')
	Converge          = bot:GetAbilityByName('dawnbreaker_converge')
	SolarGuardian     = bot:GetAbilityByName('dawnbreaker_solar_guardian')

    bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    CelestialHammerDesire, CelestialHammerLocation = X.ConsiderCelestialHammer()
    if CelestialHammerDesire > 0 then
        local nSpeed = CelestialHammer:GetSpecialValueInt('projectile_speed')
        vConvergeHammerLocation = CelestialHammerLocation

        if bot:GetUnitName() == 'npc_dota_hero_dawnbreaker' then
            if CelestialHammerCastRangeTalent and CelestialHammerCastRangeTalent:IsTrained() then
                nSpeed = nSpeed * (1 + (CelestialHammerCastRangeTalent:GetSpecialValueInt('value') / 100))
            end
        end

        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(CelestialHammer, CelestialHammerLocation)
        fCelestialHammerTime = DotaTime() + CelestialHammer:GetCastPoint() + (GetUnitToLocationDistance(bot, CelestialHammerLocation) / nSpeed)
        return
    end

    ConvergeDesire = X.ConsiderConverge()
    if ConvergeDesire > 0 then
        bot:Action_UseAbility(Converge)
        return
    end

    StarbreakerDesire, StarbreakerLocation = X.ConsiderStarBreaker()
    if StarbreakerDesire > 0 then
		J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(Starbreaker, StarbreakerLocation)
        return
    end

    SolarGuardianDesire, SolarGuardianLocation = X.ConsiderSolarGuardian()
    if SolarGuardianDesire > 0 then
        if J.CanBlackKingBar(bot)
        and bot:GetMana() > (SolarGuardian:GetManaCost() + bot.BlackKingBar:GetManaCost() + 100)
        and bShouldBKB
        then
            bot:Action_ClearActions(true)
            bot:ActionQueue_UseAbility(bot.BlackKingBar)
            bot:ActionQueue_UseAbilityOnLocation(SolarGuardian, SolarGuardianLocation)
            bShouldBKB = false
            return
        end

        bot:Action_UseAbilityOnLocation(SolarGuardian, SolarGuardianLocation)
        return
    end
end

function X.ConsiderStarBreaker()
    if not J.CanCastAbility(Starbreaker) then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nRadius = Starbreaker:GetSpecialValueInt('swipe_radius')
    local fComboDuration = Starbreaker:GetSpecialValueFloat('duration')
	local nCastPoint = Starbreaker:GetCastPoint()
    local nDamage = bot:GetAttackDamage() + Starbreaker:GetSpecialValueInt('swipe_damage') + Starbreaker:GetSpecialValueInt('smash_damage')
    local nManaCost = Starbreaker:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {CelestialHammer, SolarGuardian})
    local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {Starbreaker, CelestialHammer, SolarGuardian})
    local fManaThreshold3 = J.GetManaThreshold(bot, nManaCost, {SolarGuardian})

    for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.IsInRange(bot, enemyHero, nRadius)
        then
            if enemyHero:HasModifier('modifier_teleporting') then
                if J.GetModifierTime(enemyHero, 'modifier_teleporting') > fComboDuration then
                    return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
                end
            elseif enemyHero:IsChanneling() and fManaAfter > fManaThreshold2 then
                return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
            end

            if  J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_PHYSICAL, fComboDuration + nCastPoint)
            and not enemyHero:HasModifier('modifier_abaddon_aphotic_shield')
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
            end
        end
	end

	if J.IsInTeamFight(bot, 1200) then
		local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nRadius, nRadius, 0, 0)
        local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)
		if #nInRangeEnemy >= 2 and not J.IsLocationInChrono(nLocationAoE.targetloc) then
            return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        and not J.IsSuspiciousIllusion(botTarget)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and fManaAfter > fManaThreshold3
		then
            if not J.IsChasingTarget(bot, botTarget) or botTarget:GetCurrentMovementSpeed() <= 200 then
                return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
            end
		end
	end

    local nEnemyCreeps = bot:GetNearbyCreeps(nRadius + 300, true)

    if J.IsPushing(bot) and #nAllyHeroes <= 2 and fManaAfter > fManaThreshold2 and bAttacking and #nEnemyHeroes <= 1 then
		for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 4) then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

    if J.IsDefending(bot) and fManaAfter > fManaThreshold1 and bAttacking and #nAllyHeroes <= 3 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 4) then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end

        local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nRadius + 300, nRadius, 0, 0)
        if nLocationAoE.count >= 3 then
            return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
        end
    end

    if J.IsFarming(bot) and fManaAfter > fManaThreshold1 and bAttacking then
		for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 3)
                or (nLocationAoE.count >= 2 and creep:IsAncientCreep())
                then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

    if J.IsLaning(bot) and J.IsInLaningPhase() and fManaAfter > fManaThreshold1 then
		for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, nDamage)
                if (nLocationAoE.count >= 3) then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
	end

    if J.IsDoingRoshan(bot) then
        if  J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nRadius + 300)
        and J.GetHP(botTarget) > 0.5
        and fManaAfter > fManaThreshold2
        and bAttacking
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
    end

    if J.IsDoingTormentor(bot) then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nRadius + 300)
        and fManaAfter > fManaThreshold2
        and bAttacking
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
    end

    if fManaAfter > fManaThreshold2 and #nEnemyHeroes <= 1 then
		for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, nDamage)
                if (nLocationAoE.count >= 4) then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
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
    local nManaCost = CelestialHammer:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Starbreaker, SolarGuardian})
    local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {SolarGuardian})

    if bot:GetUnitName() == 'npc_dota_hero_dawnbreaker' then
        if CelestialHammerCastRangeTalent and CelestialHammerCastRangeTalent:IsTrained() then
            nCastRange = nCastRange * (1 + (CelestialHammerCastRangeTalent:GetSpecialValueInt('value') / 100))
            nSpeed = nSpeed * (1 + (CelestialHammerCastRangeTalent:GetSpecialValueInt('value') / 100))
        end
    end

    for _, enemyHero in pairs(nEnemyHeroes) do
		if  J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.IsInRange(bot, enemyHero, 1600)
        and J.CanCastOnNonMagicImmune(enemyHero)
		and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
		and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
        and fManaAfter > fManaThreshold2
        then
            local fDelay = (GetUnitToUnitDistance(bot, enemyHero) / nSpeed) + nCastPoint
            if J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL, fDelay) then
                return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(enemyHero, fDelay)
            end
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not J.IsInRange(bot, botTarget, 400)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and fManaAfter > fManaThreshold1
		then
			local fDelay = (GetUnitToUnitDistance(bot, botTarget) / nSpeed) + nCastPoint
            return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(botTarget, fDelay)
		end
	end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(4) then
        for _, enemyHero in ipairs(nEnemyHeroes) do
            if J.IsValidHero(enemyHero)
            and J.CanCastOnNonMagicImmune(enemyHero)
            then
                if J.IsChasingTarget(enemyHero, bot) or botHP < 0.5 or (#nEnemyHeroes > #nAllyHeroes and enemyHero:GetAttackTarget() == bot) then
                    local fDelay = (GetUnitToUnitDistance(bot, enemyHero) / nSpeed) + nCastPoint
                    if GetUnitToUnitDistance(bot, enemyHero) > 600 then
                        bIsHammerCastedWhenRetreatingToEnemy = true
                        return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(enemyHero, fDelay)
                    else
                        bIsHammerCastedWhenRetreatingToEnemy = false
                        return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(bot:GetLocation(), J.GetTeamFountain(), nCastRange)
                    end
                end
            end
        end
	end

    local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(900, true)

    if J.IsLaning(bot) and J.IsInLaningPhase() and fManaAfter > fManaThreshold1 then
        for _, creep in pairs(nEnemyLaneCreeps) do
            if  J.IsValid(creep)
            and J.CanBeAttacked(creep)
            and not J.IsRunning(creep)
            and (J.IsKeyWordUnit('ranged', creep) or J.IsKeyWordUnit('siege', creep))
            then
                local fDelay = (GetUnitToUnitDistance(bot, creep) / nSpeed) + nCastPoint
                if J.WillKillTarget(creep, nDamage, DAMAGE_TYPE_MAGICAL, fDelay) then
                    if (J.IsValidHero(nEnemyHeroes[1]) and not J.IsSuspiciousIllusion(nEnemyHeroes[1]) and GetUnitToUnitDistance(creep, nEnemyHeroes[1]) <= 600)
                    or J.IsUnitTargetedByTower(creep, false)
                    then
                        return BOT_ACTION_DESIRE_HIGH, creep:GetLocation()
                    end
                end
            end
        end
	end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderConverge()
    if not J.CanCastAbility(Converge) then
        return BOT_ACTION_DESIRE_NONE
    end

    if J.IsGoingOnSomeone(bot) and vConvergeHammerLocation ~= nil then
		if  J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, 1600)
        and not J.IsInRange(bot, botTarget, 400)
        and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
		then
            if GetUnitToLocationDistance(botTarget, vConvergeHammerLocation) < GetUnitToLocationDistance(bot, vConvergeHammerLocation)
            and DotaTime() > fCelestialHammerTime
            then
                return BOT_ACTION_DESIRE_HIGH
            end
		end
    end

    if not bIsHammerCastedWhenRetreatingToEnemy then
        if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
            if  bot:IsFacingLocation(J.GetTeamFountain(), 45) and DotaTime() > fCelestialHammerTime then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderSolarGuardian()
    if not J.CanCastAbility(SolarGuardian) then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nChannelTime = SolarGuardian:GetChannelTime()
	local nRadius = SolarGuardian:GetSpecialValueInt('radius')
    local nAirTime = SolarGuardian:GetSpecialValueFloat('airtime_duration')
    local nCastPoint = SolarGuardian:GetCastPoint()
    local fTotalCastTime = nChannelTime + nAirTime + nCastPoint

    local vTeamFightLocation = J.GetTeamFightLocation(bot)
    local nEnemyHeroesAttackingMe = J.GetHeroesTargetingUnit(nEnemyHeroes, bot)

    for i = 1, 5 do
        local allyHero = GetTeamMember(i)

        if  bot ~= allyHero
        and J.IsValidHero(allyHero)
        and not J.IsRetreating(allyHero)
        and not allyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        then
            local nInRangeAlly = J.GetAlliesNearLoc(allyHero:GetLocation(), 1200)
            local nInRangeEnemy = J.GetEnemiesNearLoc(allyHero:GetLocation(), nRadius * 0.9)
            if J.IsInTeamFight(allyHero, 1200) and J.GetHP(allyHero) < 0.75 then
                if #nInRangeEnemy >= 1 and (#nInRangeAlly + 1 >= #nInRangeEnemy) then
                    if not bot:IsMagicImmune() and #nEnemyHeroesAttackingMe >= 2 then
                        bShouldBKB = true
                    end

                    return BOT_ACTION_DESIRE_HIGH, allyHero:GetLocation()
                end
            end

            if not J.IsRetreating(bot) then
                if  J.IsCore(allyHero)
                and J.GetHP(allyHero) < 0.65
                and not allyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
                and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
                and not J.IsEarlyGame()
                then
                    if #nInRangeEnemy >= 1
                    and (#nInRangeAlly >= #nInRangeEnemy)
                    and #J.GetHeroesTargetingUnit(nEnemyHeroes, allyHero) >= 2
                    then
                        if not bot:IsMagicImmune() and #nEnemyHeroesAttackingMe >= 2 then
                            bShouldBKB = true
                        end

                        return BOT_ACTION_DESIRE_HIGH, allyHero:GetLocation()
                    end
                end
            end
        end
    end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:DistanceFromFountain() > 3000 and botHP < 0.5 and not J.IsInTeamFight(bot, 1200) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and not J.IsSuspiciousIllusion(enemyHero)
            and enemyHero:GetAttackTarget() == bot
            then
                local totalDamage = J.GetTotalEstimatedDamageToTarget(nEnemyHeroesAttackingMe, bot, fTotalCastTime)
                if not J.IsStunProjectileIncoming(bot, 1000) and bot:GetHealth() > totalDamage then
                    local hTargetAlly = nil
                    local hTargetAllyDistance = 0
                    for i = 1, 5 do
                        local member = GetTeamMember(i)
                        if bot ~= member and J.IsValidHero(member) and not J.IsRetreating(member) then
                            local memberDistance = GetUnitToUnitDistance(bot, member)
                            if memberDistance > 2000 and memberDistance > hTargetAllyDistance then
                                hTargetAlly = member
                                hTargetAllyDistance = memberDistance
                            end
                        end
                    end

                    if hTargetAlly then
                        return BOT_ACTION_DESIRE_HIGH, hTargetAlly:GetLocation()
                    end
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

return X