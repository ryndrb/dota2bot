local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_rattletrap'
then

local RI = require(GetScriptDirectory()..'/FunLib/util_role_item')

local sUtility = {}
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
                [1] = {},
            },
            ['ability'] = {
                [1] = {},
            },
            ['buy_list'] = {},
            ['sell_list'] = {},
        },
    },
    ['pos_3'] = {
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
    ['pos_4'] = {
        [1] = {
            ['talent'] = {
                [1] = {
                    ['t25'] = {0, 10},
                    ['t20'] = {0, 10},
                    ['t15'] = {10, 0},
                    ['t10'] = {0, 10},
                }
            },
            ['ability'] = {
                [1] = {1,2,1,3,1,6,1,3,3,3,6,2,2,2,6},
            },
            ['buy_list'] = {
                "item_double_tango",
                "item_double_branches",
                "item_blood_grenade",
                "item_wind_lace",
            
                "item_boots",
                "item_magic_wand",
                "item_tranquil_boots",
                "item_force_staff",--
                "item_blade_mail",--
                "item_ancient_janggo",
                "item_solar_crest",--
                "item_boots_of_bearing",--
                "item_aghanims_shard",
                "item_shivas_guard",--
                "item_heavens_halberd",--
                "item_ultimate_scepter_2",
                "item_moon_shard",
            },
            ['sell_list'] = {
                "item_magic_wand", "item_heavens_halberd",
            },
        },
    },
    ['pos_5'] = {
        [1] = {
            ['talent'] = {
                [1] = {
                    ['t25'] = {0, 10},
                    ['t20'] = {0, 10},
                    ['t15'] = {10, 0},
                    ['t10'] = {0, 10},
                }
            },
            ['ability'] = {
                [1] = {1,2,1,3,1,6,1,3,3,3,6,2,2,2,6},
            },
            ['buy_list'] = {
                "item_double_tango",
                "item_double_branches",
                "item_blood_grenade",
                "item_wind_lace",
            
                "item_boots",
                "item_magic_wand",
                "item_arcane_boots",
                "item_force_staff",--
                "item_blade_mail",--
                "item_mekansm",
                "item_solar_crest",--
                "item_guardian_greaves",--
                "item_aghanims_shard",
                "item_shivas_guard",--
                "item_heavens_halberd",--
                "item_ultimate_scepter_2",
                "item_moon_shard",
            },
            ['sell_list'] = {
                "item_magic_wand", "item_heavens_halberd",
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

function X.MinionThink(hMinionUnit)
	Minion.MinionThink(hMinionUnit)
end

end

local BatteryAssault    = bot:GetAbilityByName('rattletrap_battery_assault')
local PowerCogs         = bot:GetAbilityByName('rattletrap_power_cogs')
local RocketFlare       = bot:GetAbilityByName('rattletrap_rocket_flare')
local Jetpack           = bot:GetAbilityByName('rattletrap_jetpack')
local Overclocking      = bot:GetAbilityByName('rattletrap_overclocking')
local Hookshot          = bot:GetAbilityByName('rattletrap_hookshot')

local BatteryAssaultDesire
local PowerCogsDesire
local RocketFlareDesire, RocketFlareLocation
local JetpackDesire
local OverclockingDesire
local HookshotDesire, HookshotTarget

local fScoutRoshanTime = -1

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
    bot = GetBot()

	if J.CanNotUseAbility(bot) then return end

    BatteryAssault    = bot:GetAbilityByName('rattletrap_battery_assault')
    PowerCogs         = bot:GetAbilityByName('rattletrap_power_cogs')
    RocketFlare       = bot:GetAbilityByName('rattletrap_rocket_flare')
    Jetpack           = bot:GetAbilityByName('rattletrap_jetpack')
    Overclocking      = bot:GetAbilityByName('rattletrap_overclocking')
    Hookshot          = bot:GetAbilityByName('rattletrap_hookshot')

    bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    OverclockingDesire = X.ConsiderOverclocking()
    if OverclockingDesire > 0 then
        bot:Action_UseAbility(Overclocking)
        return
    end

    HookshotDesire, HookshotTarget = X.ConsiderHookshot()
    if HookshotDesire > 0 then
        bot:Action_UseAbilityOnLocation(Hookshot, HookshotTarget)
        return
    end

    PowerCogsDesire = X.ConsiderPowerCogs()
    if PowerCogsDesire > 0 then
        bot:Action_UseAbility(PowerCogs)
        return
    end

    BatteryAssaultDesire = X.ConsiderBatteryAssault()
    if BatteryAssaultDesire > 0 then
        bot:Action_UseAbility(BatteryAssault)
        return
    end

    RocketFlareDesire, RocketFlareLocation = X.ConsiderRocketFlare()
    if RocketFlareDesire > 0 then
        bot:Action_UseAbilityOnLocation(RocketFlare, RocketFlareLocation)
        return
    end

    JetpackDesire = X.ConsiderJetpack()
    if JetpackDesire > 0 then
        bot:Action_UseAbility(Jetpack)
        return
    end
end

function X.ConsiderBatteryAssault()
    if not J.CanCastAbility(BatteryAssault) then
        return BOT_ACTION_DESIRE_NONE
    end

	local nRadius = BatteryAssault:GetSpecialValueInt('radius')
    local nManaCost = BatteryAssault:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {PowerCogs, RocketFlare, Jetpack, Hookshot})

    if J.IsGoingOnSomeone(bot) then
		if  J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nRadius - 75)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
        and fManaAfter > fManaThreshold1
		then
            return BOT_ACTION_DESIRE_HIGH
		end
	end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nRadius)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and not J.IsDisabled(enemyHero)
            and not enemyHero:IsDisarmed()
            and bot:WasRecentlyDamagedByHero(enemyHero, 2.0)
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
	end

    local nEnemyCreeps = bot:GetNearbyCreeps(nRadius + 75, true)

    if J.IsPushing(bot) and fManaAfter > fManaThreshold1 and #nAllyHeroes <= 2 and #nEnemyHeroes == 0 and bAttacking then
        if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) and not J.IsRunning(nEnemyCreeps[1]) then
            if #nEnemyCreeps >= 4 then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    end

    if J.IsDefending(bot) and fManaAfter > fManaThreshold1 and #nAllyHeroes <= 2 and bAttacking then
        if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) and not J.IsRunning(nEnemyCreeps[1]) then
            if #nEnemyCreeps >= 4 then
                return BOT_ACTION_DESIRE_HIGH
            end
        end

        local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), 0, nRadius, 0, 0)
        if nLocationAoE.count >= 2 then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsFarming(bot) and fManaAfter > fManaThreshold1 and bAttacking then
        if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) and not J.IsRunning(nEnemyCreeps[1]) then
            if (#nEnemyCreeps >= 3)
            or (#nEnemyCreeps >= 2 and nEnemyCreeps[1]:IsAncientCreep())
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    end

    if J.IsDoingRoshan(bot) then
		if  J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        and bAttacking
        and fManaAfter > fManaThreshold1
		then
            return BOT_ACTION_DESIRE_HIGH
		end
	end

    if J.IsDoingTormentor(bot) then
		if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        and bAttacking
        and fManaAfter > fManaThreshold1
		then
            return BOT_ACTION_DESIRE_HIGH
		end
	end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderPowerCogs()
    if  not J.CanCastAbility(PowerCogs) then
		return BOT_ACTION_DESIRE_NONE
	end

	local nRadius = PowerCogs:GetSpecialValueInt('cogs_radius')
	local fDuration = PowerCogs:GetSpecialValueFloat('duration')

    if J.IsGoingOnSomeone(bot) then
		if  J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nRadius - 25)
        and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not botTarget:HasModifier('modifier_enigma_black_hole_pull')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_lina_flame_cloak')
        and not botTarget:HasModifier('modifier_item_spider_legs_active')
		then
            return BOT_ACTION_DESIRE_HIGH
		end
	end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and J.IsRunning(bot) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nRadius + 200)
            and not J.IsInRange(bot, enemyHero, nRadius)
            and not J.IsSuspiciousIllusion(enemyHero)
            and not enemyHero:HasModifier('modifier_lina_flame_cloak')
            and not enemyHero:HasModifier('modifier_item_spider_legs_active')
            and bot:WasRecentlyDamagedByHero(enemyHero, 3.0)
            and GetUnitToLocationDistance(bot, J.GetTeamFountain()) < GetUnitToLocationDistance(enemyHero, J.GetTeamFountain())
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderRocketFlare()
    if not J.CanCastAbility(RocketFlare) then
        return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastRange = 1600
	local nCastPoint = RocketFlare:GetCastPoint()
	local nRadius = RocketFlare:GetSpecialValueInt('radius')
    local nDamage = RocketFlare:GetSpecialValueInt('damage')
    local nSpeed = RocketFlare:GetSpecialValueInt('speed')
    local nManaCost = RocketFlare:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {BatteryAssault, PowerCogs, Jetpack, Hookshot})

    local unitList = GetUnitList(UNIT_LIST_ENEMY_HEROES)
    for _, enemyHero in pairs(unitList) do
        if  J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.IsInRange(bot, enemyHero, 3200)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
        and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
        then
            local eta = (GetUnitToUnitDistance(bot, enemyHero) / nSpeed) + nCastPoint
            if J.WillKillTarget(enemyHero, nDamage - (enemyHero:GetHealthRegen() * eta), DAMAGE_TYPE_MAGICAL, eta) then
                return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(enemyHero, eta)
            end
        end
    end

    local vTeamFightLocation = J.GetTeamFightLocation(bot)

    if vTeamFightLocation ~= nil then
        if GetUnitToLocationDistance(bot, vTeamFightLocation) > 1200 then
            local nInRangeEnemy = J.GetEnemiesNearLoc(vTeamFightLocation, nRadius)
            if #nInRangeEnemy >= 2 then
                return BOT_ACTION_DESIRE_HIGH, vTeamFightLocation
            end
        end
    end

    if J.IsInTeamFight(bot, 1200) then
        local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), 1200, nRadius, 0, 0)
        local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)
        if #nInRangeEnemy >= 2 then
            return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
        end
    end

    if J.IsGoingOnSomeone(bot) then
		if  J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, 1600)
        and J.CanCastOnNonMagicImmune(botTarget)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
            if J.IsChasingTarget(bot, botTarget) or J.GetHP(botTarget) < 0.4 or #nEnemyHeroes > 1 then
                local eta = (GetUnitToUnitDistance(bot, botTarget) / nSpeed) + nCastPoint
                return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(botTarget, eta)
            end
		end
	end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.IsInRange(bot, enemyHero, 1200)
            and not J.IsInRange(bot, enemyHero, 400)
            and not J.IsDisabled(enemyHero)
            and not enemyHero:IsDisarmed()
            and bot:WasRecentlyDamagedByHero(enemyHero, 2.0)
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
            end
        end
	end

    local nEnemyCreeps = bot:GetNearbyCreeps(800, true)

    if J.IsPushing(bot) and fManaAfter > fManaThreshold1 and bAttacking and #nEnemyHeroes == 0 and #nAllyHeroes <= 2 then
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
                if (nLocationAoE.count >= 4)
                or (nLocationAoE.count >= 3 and string.find(creep:GetUnitName(), 'upgraded'))
                then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end

        local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), 1200, nRadius, 0, 0)
        if nLocationAoE.count >= 2 then
            return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
        end
    end

    if J.IsFarming(bot) and fManaAfter > fManaThreshold1 and bAttacking then
		for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 2)
                or (nLocationAoE.count >= 1 and creep:IsAncientCreep())
                then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

    if J.IsLaning(bot) and J.IsInLaningPhase() and fManaAfter > fManaThreshold1 and (J.IsCore(bot) or not J.IsThereCoreNearby(800)) then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep)
            and J.CanBeAttacked(creep)
            and not J.IsRunning(creep)
            and not J.IsOtherAllysTarget(creep)
            and J.CanKillTarget(creep, nDamage, DAMAGE_TYPE_MAGICAL)
            then
                local sCreepName = creep:GetUnitName()
                local nLocationAoE = bot:FindAoELocation(true, true, creep:GetLocation(), 0, 600, 0, 0)
                if string.find(sCreepName, 'ranged') then
                    if nLocationAoE.count > 0 or J.IsUnitTargetedByTower(creep, false) then
                        return BOT_ACTION_DESIRE_HIGH, creep:GetLocation()
                    end
                end

                nLocationAoE = bot:FindAoELocation(true, true, creep:GetLocation(), 0, nRadius, 0, nDamage * 2)
                if fManaAfter > fManaThreshold1 + 0.1 and nLocationAoE.count > 0 then
                    return BOT_ACTION_DESIRE_HIGH, creep:GetLocation()
                end

                nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, nDamage)
                if nLocationAoE.count >= 2 and #nEnemyHeroes > 0 then
                    return BOT_ACTION_DESIRE_HIGH, creep:GetLocation()
                end
            end
        end
    end

    if J.IsDoingRoshan(bot) then
        local vRoshanLocation = J.GetCurrentRoshanLocation()

        if  J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and bAttacking
        and fManaAfter > fManaThreshold1
		then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end

        if  GetUnitToLocationDistance(bot, vRoshanLocation) > 1600
        and DotaTime() > fScoutRoshanTime + 15
        and fManaAfter > fManaThreshold1
        and not J.IsRoshanCloseToChangingSides()
        then
            fScoutRoshanTime = DotaTime()
            return BOT_ACTION_DESIRE_HIGH, vRoshanLocation
        end
    end

    if J.IsDoingTormentor(bot) then
		if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and bAttacking
        and fManaAfter > fManaThreshold1
		then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

    if fManaAfter > fManaThreshold1 and (J.IsCore(bot) or not J.IsThereCoreNearby(1000)) then
        local nLocationAoE = bot:FindAoELocation(true, false, bot:GetLocation(), 800, nRadius, 0, nDamage)
        if nLocationAoE.count >= 3 then
            return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
        end
    end

	return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderJetpack()
    if not J.CanCastAbility(Jetpack) then
        return BOT_ACTION_DESIRE_NONE
    end

    local bIsToggled = Jetpack:GetToggleState()

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(2.0) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.IsInRange(bot, enemyHero, 800)
            and not J.IsSuspiciousIllusion(enemyHero)
            then
                local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), 1200)
                local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1200)
                if J.IsChasingTarget(enemyHero, bot)
                or (#nInRangeEnemy > #nInRangeAlly and botHP < 0.75)
                then
                    if not bIsToggled then
                        return BOT_ACTION_DESIRE_HIGH
                    end
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderOverclocking()
    if not J.CanCastAbility(Overclocking) then
        return BOT_ACTION_DESIRE_NONE
    end

    if J.IsInTeamFight(bot, 1200) then
        local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1200)
        if #nInRangeEnemy >= 2 then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderHookshot()
    if not J.CanCastAbility(Hookshot)
    or bot:IsRooted()
    then
        return BOT_ACTION_DESIRE_NONE, 0
    end

	local nCastRange = Hookshot:GetCastRange()
    local nCastPoint = Hookshot:GetCastPoint()
	local nRadius = Hookshot:GetSpecialValueInt('latch_radius')
	local nSpeed = Hookshot:GetSpecialValueInt('speed')

	if J.IsGoingOnSomeone(bot) then
        for _, enemyHero in ipairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and GetUnitToLocationDistance(enemyHero, J.GetEnemyFountain()) > 1000
            and not enemyHero:HasModifier('modifier_enigma_black_hole_pull')
            and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            then
                local nInRangeAlly = J.GetAlliesNearLoc(enemyHero:GetLocation(), 1200)
                local nInRangeEnemy = J.GetEnemiesNearLoc(enemyHero:GetLocation(), 1200)
                local eta = (GetUnitToUnitDistance(bot, enemyHero) / nSpeed) + nCastPoint
                local vLocation = J.GetCorrectLoc(enemyHero, eta)

                local totalDamage = J.GetTotalEstimatedDamageToTarget(nAllyHeroes, enemyHero, 5.0)

                if #nInRangeAlly >= #nInRangeEnemy and not J.IsUnitBetweenMeAndLocation(bot, enemyHero, vLocation, nRadius) then
                    if totalDamage > (enemyHero:GetHealth() + enemyHero:GetHealthRegen() * 5.0)
                    or J.IsInTeamFight(bot, nCastRange)
                    then
                        return BOT_ACTION_DESIRE_HIGH, vLocation
                    end

                    if J.GetModifierTime(enemyHero, 'modifier_teleporting') > eta then
                        if J.GetTotalEstimatedDamageToTarget(nAllyHeroes, enemyHero, 4.0) > enemyHero:GetHealth() then
                            return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
                        end
                    end
                end
            end
        end
	end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and not J.IsInTeamFight(bot, 1600) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and not J.IsSuspiciousIllusion(enemyHero)
            and not enemyHero:IsDisarmed()
            and bot:WasRecentlyDamagedByHero(enemyHero, 2.0)
            then
                if J.IsChasingTarget(enemyHero, bot) or (botHP < 0.75 and #nEnemyHeroes > #nAllyHeroes and J.IsRunning(bot)) then
                    for _, allyHero in pairs(nAllyHeroes) do
                        if bot ~= allyHero
                        and J.IsValidHero(allyHero)
                        and GetUnitToUnitDistance(bot, allyHero) > 1200
                        and GetUnitToUnitDistance(allyHero, enemyHero) > 800
                        and (GetUnitToLocationDistance(allyHero, J.GetTeamFountain()) < GetUnitToLocationDistance(bot, J.GetTeamFountain()))
                        and bot:DistanceFromFountain() > 1600
                        and allyHero:DistanceFromFountain() > 1600
                        and not allyHero:HasModifier('modifier_enigma_black_hole_pull')
                        and not allyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
                        and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
                        then
                            local eta = (GetUnitToUnitDistance(bot, allyHero) / nSpeed) + nCastPoint
                            local vLocation = J.GetCorrectLoc(allyHero, eta)
                            if not J.IsUnitBetweenMeAndLocation(bot, allyHero, vLocation, nRadius) then
                                return BOT_ACTION_DESIRE_HIGH, vLocation
                            end
                        end
                    end

                    local vTeamFountain = J.GetTeamFountain()
                    for _, camp in pairs(GetNeutralSpawners()) do
                        if  camp
                        and GetUnitToLocationDistance(bot, camp.location) < nCastRange * 0.85
                        and not J.IsUnitBetweenMeAndLocation(bot, bot, camp.location, nRadius)
                        then
                            if (J.GetDistance(camp.location, vTeamFountain) < GetUnitToLocationDistance(bot, vTeamFountain))
                            and GetUnitToLocationDistance(bot, camp.location) > 800
                            and GetUnitToLocationDistance(enemyHero, camp.location) > 800
                            then
                                return BOT_ACTION_DESIRE_HIGH, camp.location
                            end
                        end
                    end
                end
            end
        end
	end

    return BOT_ACTION_DESIRE_NONE, 0
end

return X