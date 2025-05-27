local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_leshrac'
then

local RI = require(GetScriptDirectory()..'/FunLib/util_role_item')

local sUtility = {"item_pipe", "item_lotus_orb"}
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
                    ['t10'] = {10, 0},
                },
                [2] = {
                    ['t25'] = {0, 10},
                    ['t20'] = {0, 10},
                    ['t15'] = {0, 10},
                    ['t10'] = {10, 0},
                },
            },
            ['ability'] = {
                [1] = {3,1,3,1,3,6,3,2,2,2,2,6,1,1,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_mantle",
                "item_circlet",
                "item_faerie_fire",
            
                "item_bottle",
                "item_magic_wand",
                "item_null_talisman",
                "item_arcane_boots",
                "item_kaya",
                "item_bloodstone",--
                "item_black_king_bar",--
                "item_kaya_and_sange",--
                "item_cyclone",
                "item_shivas_guard",--
                "item_aghanims_shard",
                "item_travel_boots",
                "item_wind_waker",--
                "item_travel_boots_2",--
                "item_ultimate_scepter_2",
                "item_moon_shard",
            },
            ['sell_list'] = {
                "item_magic_wand", "item_black_king_bar",
                "item_bottle", "item_cyclone",
                "item_null_talisman", "item_shivas_guard",
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
                    ['t10'] = {10, 0},
                },
                [2] = {
                    ['t25'] = {0, 10},
                    ['t20'] = {0, 10},
                    ['t15'] = {0, 10},
                    ['t10'] = {10, 0},
                },
            },
            ['ability'] = {
                [1] = {3,2,2,1,2,6,2,1,1,1,6,3,3,3,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
            
                "item_null_talisman",
                "item_magic_wand",
                "item_arcane_boots",
                "item_kaya",
                "item_bloodstone",--
                sUtilityItem,--
                "item_black_king_bar",--
                "item_shivas_guard",--
                "item_kaya_and_sange",--
                "item_aghanims_shard",
                "item_travel_boots_2",--
                "item_ultimate_scepter_2",
                "item_moon_shard",
            },
            ['sell_list'] = {
                "item_magic_wand", "item_black_king_bar",
                "item_null_talisman", "item_shivas_guard",
            },
        },
    },
    ['pos_4'] = {
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
    ['pos_5'] = {
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
}

local sSelectedBuild = HeroBuild[sRole][RandomInt(1, #HeroBuild[sRole])]

local nTalentBuildList = J.Skill.GetTalentBuild(J.Skill.GetRandomBuild(sSelectedBuild.talent))
local nAbilityBuildList = J.Skill.GetRandomBuild(sSelectedBuild.ability)

X['sBuyList'] = sSelectedBuild.buy_list
X['sSellList'] = sSelectedBuild.sell_list

if J.Role.IsPvNMode() or J.Role.IsAllShadow() then X['sBuyList'], X['sSellList'] = { 'PvN_mid' }, {} end

nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] = J.SetUserHeroInit( nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] )

X['sSkillList'] = J.Skill.GetSkillList( sAbilityList, nAbilityBuildList, sTalentList, nTalentBuildList )

X['bDeafaultAbility'] = false
X['bDeafaultItem'] = false

function X.MinionThink(hMinionUnit)
    Minion.MinionThink(hMinionUnit)
end

end

local SplitEarth        = bot:GetAbilityByName('leshrac_split_earth')
local DiabolicEdict     = bot:GetAbilityByName('leshrac_diabolic_edict')
local LightningStorm    = bot:GetAbilityByName('leshrac_lightning_storm')
local Nihilism          = bot:GetAbilityByName('leshrac_greater_lightning_storm')
local PulseNova         = bot:GetAbilityByName('leshrac_pulse_nova')

local SplitEarthDesire, SplitEarthLocation
local DiabolicEdictDesire
local LightningStormDesire, LightningStormTarget
local NihilismDesire
local PulseNovaDesire

local botTarget
local nAllyHeroes, nEnemyHeroes

local bCanEdictTower = true

function X.SkillsComplement()
    if J.CanNotUseAbility(bot) then return end

    SplitEarth        = bot:GetAbilityByName('leshrac_split_earth')
    DiabolicEdict     = bot:GetAbilityByName('leshrac_diabolic_edict')
    LightningStorm    = bot:GetAbilityByName('leshrac_lightning_storm')
    Nihilism          = bot:GetAbilityByName('leshrac_greater_lightning_storm')
    PulseNova         = bot:GetAbilityByName('leshrac_pulse_nova')

    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
    botTarget = J.GetProperTarget(bot)

    PulseNovaDesire = X.ConsiderPulseNova()
    if PulseNovaDesire > 0
    then
        bot:Action_UseAbility(PulseNova)
        return
    end

    LightningStormDesire, LightningStormTarget = X.ConsiderLightningStorm()
    if LightningStormDesire > 0
    then
        bot:Action_UseAbilityOnEntity(LightningStorm, LightningStormTarget)
        return
    end

    SplitEarthDesire, SplitEarthLocation = X.ConsiderSplitEarth()
    if SplitEarthDesire > 0
    then
        bot:Action_UseAbilityOnLocation(SplitEarth, SplitEarthLocation)
        return
    end

    DiabolicEdictDesire = X.ConsiderDiabolicEdict()
    if DiabolicEdictDesire > 0
    then
        bot:Action_UseAbility(DiabolicEdict)
        return
    end

    NihilismDesire = X.ConsiderNihilism()
    if NihilismDesire > 0
    then
        bot:Action_UseAbility(Nihilism)
        return
    end
end

function X.ConsiderSplitEarth()
    if not J.CanCastAbility(SplitEarth)
    then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nCastRange = J.GetProperCastRange(false, bot, SplitEarth:GetCastRange())
    local nCastPoint = SplitEarth:GetCastPoint()
    local nRadius = SplitEarth:GetSpecialValueInt('radius')
    local nDelay = SplitEarth:GetSpecialValueFloat('delay')
    local nDamage = SplitEarth:GetAbilityDamage()
    local nManaCost = SplitEarth:GetManaCost()
    local nAbilityLevel = SplitEarth:GetLevel()
    local nLocationAoE = 0
    local bAttacking = J.IsAttacking(bot)

    for _, enemyHero in pairs(nEnemyHeroes) do
        if J.IsValidHero(enemyHero)
        and J.CanCastOnNonMagicImmune(enemyHero)
        then
            nLocationAoE = bot:FindAoELocation(true, true, enemyHero:GetLocation(), 0, nRadius, 0, 0)
            if enemyHero:IsChanneling() and enemyHero:HasModifier('modifier_teleporting') then
                return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
            end

            if  J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
            and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
            and not enemyHero:HasModifier('modifier_troll_warlord_battle_trance')
            and not enemyHero:HasModifier('modifier_ursa_enrage')
            then
                local vLocation = J.GetCorrectLoc(enemyHero, nDelay + nCastPoint)
                if not J.IsInRange(bot, enemyHero, nCastRange) and J.IsInRange(bot, enemyHero, nCastRange + nRadius) then
                    nLocationAoE = bot:FindAoELocation(true, true, J.Site.GetXUnitsTowardsLocation(bot, vLocation, nCastRange), 0, nRadius, 0, 0)
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                else
                    nLocationAoE = bot:FindAoELocation(true, true, vLocation, 0, nRadius, 0, 0)
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

    if J.IsInTeamFight(bot, 1200) then
        nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
        local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)
        if #nInRangeEnemy >= 2
        and (J.CanCastOnNonMagicImmune(nInRangeEnemy[1]) or J.CanCastOnNonMagicImmune(nInRangeEnemy[2]))
        and not J.IsEnemyChronosphereInLocation(nLocationAoE.targetloc)
        and not J.IsEnemyBlackHoleInLocation(nLocationAoE.targetloc)
        then
            return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
        end
    end

    if J.IsGoingOnSomeone(bot) then
        if  J.IsValidTarget(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        then
            nLocationAoE = bot:FindAoELocation(true, true, J.GetCorrectLoc(botTarget, nDelay + nCastPoint), 0, nRadius, 0, 0)
            return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
        end
    end

    if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
    and bot:WasRecentlyDamagedByAnyHero(3.0)
	then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.IsChasingTarget(enemyHero, bot)
            and not J.IsDisabled(enemyHero)
            then
                nLocationAoE = bot:FindAoELocation(true, true, J.GetCorrectLoc(enemyHero, nDelay + nCastPoint), 0, nRadius, 0, 0)
                return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
            end
        end
	end

    if J.IsFarming(bot) and J.GetManaAfter(nManaCost) > 0.3 and bAttacking then
        local nEnemyCreeps = bot:GetNearbyCreeps(nCastRange, true)
        if J.IsValid(nEnemyCreeps[1])
        and J.CanBeAttacked(nEnemyCreeps[1])
        and not J.IsRunning(nEnemyCreeps[1])
        then
            nLocationAoE = bot:FindAoELocation(true, false, nEnemyCreeps[1]:GetLocation(), 0, nRadius, 0, 0)
            if (nLocationAoE.count >= 3)
            or (nLocationAoE.count >= 2 and nEnemyCreeps[1]:IsAncientCreep())
            then
                return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
            end
        end
    end

    local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(nCastRange, true)
    if (J.IsPushing(bot) or J.IsDefending(bot)) and J.GetManaAfter(nManaCost) > 0.3 then
        nLocationAoE = bot:FindAoELocation(true, false, bot:GetLocation(), nCastRange, nRadius, 0, 0)
        if J.IsValid(nEnemyLaneCreeps[1])
        and J.CanBeAttacked(nEnemyLaneCreeps[1])
        and not J.IsRunning(nEnemyLaneCreeps[1])
        and not J.IsThereCoreNearby(1000)
        then
            nLocationAoE = bot:FindAoELocation(true, false, nEnemyLaneCreeps[1]:GetLocation(), 0, nRadius, 0, 0)
            if nLocationAoE.count >= 4 then
                return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
            end
        end

        nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
        if nLocationAoE.count >= 2
        then
            return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
        end
    end

    if J.IsLaning(bot) and nAbilityLevel >= 2 then
        local hCreepList = {}
		for _, creep in pairs(nEnemyLaneCreeps) do
            if J.IsValid(creep)
            and J.CanBeAttacked(creep)
            and not J.IsRunning(creep)
            and J.CanKillTarget(creep, nDamage, DAMAGE_TYPE_MAGICAL)
            then
                table.insert(hCreepList, creep)
            end
		end

        if  J.GetManaAfter(nManaCost) > 0.25
        and ( (J.IsValidHero(nEnemyHeroes[1]) and J.IsInRange(bot, nEnemyHeroes[1], 700) and not J.IsSuspiciousIllusion(nEnemyHeroes[1]) and #hCreepList >= 2)
            or #hCreepList >= 3)
        then
            nLocationAoE = bot:FindAoELocation(true, false, hCreepList[1]:GetLocation(), 0, nRadius, 0, 0)
            return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
        end
	end

    if J.IsDoingRoshan(bot) then
        if  J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, 500)
        and J.IsAttacking(bot)
        and not J.IsDisabled(botTarget)
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
    end

    if J.IsDoingTormentor(bot) then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, 500)
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
    end

    for _, allyHero in pairs(nAllyHeroes) do
        if  J.IsValidHero(allyHero)
        and J.IsRetreating(allyHero)
        and J.GetManaAfter(nManaCost) > 0.3
        and allyHero:WasRecentlyDamagedByAnyHero(3.0)
        and not J.IsSuspiciousIllusion(allyHero)
        then
            for _, enemyHero in pairs(nEnemyHeroes) do
                if  J.IsValidHero(enemyHero)
                and J.CanCastOnNonMagicImmune(enemyHero)
                and J.IsInRange(bot, enemyHero, nCastRange)
                and J.IsChasingTarget(enemyHero, allyHero)
                and not J.IsDisabled(enemyHero)
                and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
                then
                    return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(enemyHero, nDelay + nCastPoint)
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderDiabolicEdict()
    if not J.CanCastAbility(DiabolicEdict)
    then
        return BOT_ACTION_DESIRE_NONE
    end

    local nRadius = DiabolicEdict:GetSpecialValueInt('radius')
    local nDamage = DiabolicEdict:GetSpecialValueInt('damage')
    local nNumExplosions = DiabolicEdict:GetSpecialValueInt('num_explosions')
    local nManaCost = DiabolicEdict:GetManaCost()

    if J.IsGoingOnSomeone(bot) then
        if  J.IsValidTarget(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
        then
            if J.IsChasingTarget(bot, botTarget) and J.CanKillTarget(botTarget, nDamage * nNumExplosions + 200, DAMAGE_TYPE_MAGICAL)
            or not J.IsChasingTarget(bot, botTarget)
            or J.IsInTeamFight(bot, nRadius * 1.5)
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    end

    if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
    and bot:WasRecentlyDamagedByAnyHero(3.0)
	then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.IsInRange(bot, enemyHero, nRadius)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.IsChasingTarget(enemyHero, bot)
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
	end

    local nEnemyCreeps = bot:GetNearbyCreeps(nRadius, true)
    if J.IsFarming(bot)
    and (J.GetManaAfter(nManaCost) > 0.22 or bot:HasModifier('modifier_item_bloodstone_active'))
    and not bot:HasModifier('modifier_leshrac_pulse_nova')
    then
        if J.IsValid(nEnemyCreeps[1])
        and J.CanBeAttacked(nEnemyCreeps[1])
        and not J.IsRunning(nEnemyCreeps[1])
        and (#nEnemyCreeps >= 3 or (#nEnemyCreeps >= 2 and nEnemyCreeps[1]:IsAncientCreep()))
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if bCanEdictTower then
        if J.IsPushing(bot) and J.GetManaAfter(nManaCost) > 0.25 then
            local nEnemyTowers = bot:GetNearbyTowers(nRadius, true)
            local nEnemyBarracks = bot:GetNearbyBarracks(nRadius, true)
            local hEnemyAncient = GetAncient(GetOpposingTeam())
            if (   J.IsValidBuilding(nEnemyTowers[1]) and J.CanBeAttacked(nEnemyTowers[1])
                or J.IsValidBuilding(nEnemyBarracks[1]) and J.CanBeAttacked(nEnemyBarracks[1])
                or J.IsValidBuilding(hEnemyAncient) and J.CanBeAttacked(hEnemyAncient)
            )
            and #nEnemyCreeps <= 2
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    end

    if J.IsDoingRoshan(bot) then
        if  J.IsRoshan(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsDoingTormentor(bot) then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderLightningStorm()
    if not J.CanCastAbility(LightningStorm)
    then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = J.GetProperCastRange(false, bot, LightningStorm:GetCastRange())
    local nDamage = LightningStorm:GetSpecialValueInt('damage')
    local nRadius = LightningStorm:GetSpecialValueInt('radius')
    local nManaCost = LightningStorm:GetManaCost()

    for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemyHero)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanCastOnTargetAdvanced(enemyHero)
        and J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
        then
            return BOT_ACTION_DESIRE_HIGH, enemyHero
        end
    end

    if J.IsGoingOnSomeone(bot) then
        if  J.IsValidTarget(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.CanCastOnTargetAdvanced(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        then
            local nLocationAoE = bot:FindAoELocation(true, true, botTarget:GetLocation(), 0, nRadius, 0, 0)
            if J.IsChasingTarget(bot, botTarget) or nLocationAoE.count >= 2 then
                return BOT_ACTION_DESIRE_HIGH, botTarget
            end
        end
    end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(3.0) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and J.IsChasingTarget(enemyHero, bot)
            and not J.IsDisabled(enemyHero)
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero
            end
        end
    end

    local nEnemyCreeps = bot:GetNearbyCreeps(nRadius, true)
    if J.IsFarming(bot) and J.GetManaAfter(nManaCost) > 0.4 then
        if J.IsValid(nEnemyCreeps[1])
        and J.CanBeAttacked(nEnemyCreeps[1])
        and not J.IsRunning(nEnemyCreeps[1])
        and (#nEnemyCreeps >= 3 or (#nEnemyCreeps >= 2 and nEnemyCreeps[1]:IsAncientCreep()))
        then
            local nLocationAoE = bot:FindAoELocation(true, false, nEnemyCreeps[1]:GetLocation(), 0, nRadius, 0, 0)
            if nLocationAoE.count >= 3
            or (nLocationAoE.count >= 2 and nEnemyCreeps[1]:IsAncientCreep())
            then
                return BOT_ACTION_DESIRE_HIGH, nEnemyCreeps[1]
            end
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsLaning(bot) and J.GetMP(bot) > 0.3 then
        local hCreepList = {}
		for _, creep in pairs(nEnemyCreeps) do
			if  J.IsValid(creep)
            and J.CanBeAttacked(creep)
			and J.IsKeyWordUnit('ranged', creep)
			and J.CanKillTarget(creep, nDamage, DAMAGE_TYPE_MAGICAL)
			then
				if J.IsValidHero(nEnemyHeroes[1]) and J.IsInRange(creep, nEnemyHeroes[1], 700) then
					return BOT_ACTION_DESIRE_HIGH, creep
				end
			end

            if J.IsValid(creep) and J.CanKillTarget(creep, nDamage, DAMAGE_TYPE_MAGICAL) then
                table.insert(hCreepList, creep)
            end
		end

        if  J.GetMP(bot) > 0.25
        and J.IsValidHero(nEnemyHeroes[1])
        and #hCreepList >= 2
        then
            return BOT_ACTION_DESIRE_HIGH, hCreepList[1]
        end
	end

    if J.IsDoingRoshan(bot)
    then
        if  J.IsRoshan(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.IsAttacking(bot)
        then
            if botTarget:HasModifier('modifier_roshan_spell_block')
            or J.GetMP(bot) > 0.5
            then
                return BOT_ACTION_DESIRE_HIGH, botTarget
            end
        end
    end

    if J.IsDoingTormentor(bot) then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.IsAttacking(bot)
        and J.GetMP(bot) > 0.3
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

    if J.GetManaAfter(nManaCost) > 0.2 then
        for _, allyHero in pairs(nAllyHeroes) do
            if  J.IsValidHero(allyHero)
            and J.IsRetreating(allyHero)
            and allyHero:WasRecentlyDamagedByAnyHero(3.0)
            and not J.IsSuspiciousIllusion(allyHero)
            then
                for _, enemyHero in pairs(nEnemyHeroes) do
                    if  J.IsValidHero(enemyHero)
                    and J.CanCastOnNonMagicImmune(enemyHero)
                    and J.CanCastOnTargetAdvanced(enemyHero)
                    and J.IsInRange(bot, enemyHero, nCastRange)
                    and J.IsChasingTarget(enemyHero, allyHero)
                    and not J.IsDisabled(enemyHero)
                    and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
                    then
                        return BOT_ACTION_DESIRE_HIGH, enemyHero
                    end
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderPulseNova()
    if not J.CanCastAbility(PulseNova)
    then
        return BOT_ACTION_DESIRE_NONE
    end

	local nRadius = PulseNova:GetSpecialValueInt('radius')
    local botMP = J.GetMP(bot)

    local nEnemyCreeps = bot:GetNearbyCreeps(nRadius, true)
    if bot:HasModifier('modifier_item_bloodstone_active')
    and botMP < 0.8
    and (#nEnemyCreeps >= 1 or #nEnemyHeroes > 0)
    then
        if PulseNova:GetToggleState() == false then
            return BOT_ACTION_DESIRE_HIGH
        else
            return BOT_ACTION_DESIRE_NONE
        end
    end

    if J.IsInTeamFight(bot, 1200) then
        local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), nRadius + 300)
        if #nInRangeEnemy >= 1 then
            if PulseNova:GetToggleState() == false then
                return BOT_ACTION_DESIRE_HIGH
            else
                return BOT_ACTION_DESIRE_NONE
            end
        end
    end

    if J.IsGoingOnSomeone(bot) then
        if J.IsValidTarget(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
        then
            if botMP > 0.25 and J.IsInRange(bot, botTarget, nRadius + 300) then
                if PulseNova:GetToggleState() == false then
                    return BOT_ACTION_DESIRE_HIGH
                end
                return BOT_ACTION_DESIRE_NONE
            else
                if (botMP < 0.25 and not J.IsInTeamFight(bot, 800)) or not J.IsInRange(bot, botTarget, nRadius + 400) then
                    if PulseNova:GetToggleState() == true then
                        return BOT_ACTION_DESIRE_HIGH
                    end
                    return BOT_ACTION_DESIRE_NONE
                end
                return BOT_ACTION_DESIRE_NONE
            end
        end
    end

    if (J.IsPushing(bot) or J.IsDefending(bot)) and not J.IsThereCoreNearby(1000) then
        if #nEnemyCreeps >= 3
        and J.IsValid(nEnemyCreeps[1])
        and J.CanBeAttacked(nEnemyCreeps[1])
        and not J.IsRunning(nEnemyCreeps[1])
        then
            if botMP > 0.5 then
                if PulseNova:GetToggleState() == false and J.IsAttacking(bot) then
                    return BOT_ACTION_DESIRE_HIGH
                end
                return BOT_ACTION_DESIRE_NONE
            else
                if (#nEnemyCreeps == 0 or botMP < 0.25) then
                    if PulseNova:GetToggleState() == true then
                        return BOT_ACTION_DESIRE_HIGH
                    end
                    return BOT_ACTION_DESIRE_NONE
                end
                return BOT_ACTION_DESIRE_NONE
            end
        end
    end

    if J.IsFarming(bot) then
        if J.IsValid(nEnemyCreeps[1])
        and J.CanBeAttacked(nEnemyCreeps[1])
        and not J.IsRunning(nEnemyCreeps[1])
        then
            if (#nEnemyCreeps >= 3 or (#nEnemyCreeps >= 2 and nEnemyCreeps[1]:IsAncientCreep())) then
                if botMP > 0.5 then
                    if PulseNova:GetToggleState() == false and J.IsAttacking(bot) then
                        return BOT_ACTION_DESIRE_HIGH
                    end
                    return BOT_ACTION_DESIRE_NONE
                else
                    if (#nEnemyCreeps == 0 or botMP < 0.25) then
                        if PulseNova:GetToggleState() == true then
                            return BOT_ACTION_DESIRE_HIGH
                        end
                        return BOT_ACTION_DESIRE_NONE
                    end
                    return BOT_ACTION_DESIRE_NONE
                end
            end
        end
    end

    if J.IsDoingRoshan(bot) then
        if  J.IsRoshan(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        then
            if botMP > 0.6 then
                if PulseNova:GetToggleState() == false and J.IsAttacking(bot) then
                    return BOT_ACTION_DESIRE_HIGH
                end
                return BOT_ACTION_DESIRE_NONE
            else
                if (J.GetHP(botTarget) < 0.2 or botMP < 0.25) then
                    if PulseNova:GetToggleState() == true then
                        return BOT_ACTION_DESIRE_HIGH
                    end
                    return BOT_ACTION_DESIRE_NONE
                end
                return BOT_ACTION_DESIRE_NONE
            end
        end
    end

    if J.IsDoingTormentor(bot) then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        then
            if botMP > 0.6 then
                if PulseNova:GetToggleState() == false and J.IsAttacking(bot) then
                    return BOT_ACTION_DESIRE_HIGH
                end
                return BOT_ACTION_DESIRE_NONE
            else
                if (J.GetHP(botTarget) < 0.2 or botMP < 0.25) then
                    if PulseNova:GetToggleState() == true then
                        return BOT_ACTION_DESIRE_HIGH
                    end
                    return BOT_ACTION_DESIRE_NONE
                end
                return BOT_ACTION_DESIRE_NONE
            end
        end
    end

    if PulseNova:GetToggleState() == true then
        return BOT_ACTION_DESIRE_HIGH
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderNihilism()
    if not J.CanCastAbility(Nihilism)
    then
        return BOT_ACTION_DESIRE_NONE
    end

    local nRadius = Nihilism:GetSpecialValueInt('radius')

    if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
    and bot:WasRecentlyDamagedByAnyHero(3.0)
	then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.IsInRange(bot, enemyHero, nRadius + 300)
            and J.IsChasingTarget(enemyHero, bot)
            and not J.IsSuspiciousIllusion(enemyHero)
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
	end

    return BOT_ACTION_DESIRE_NONE
end

return X