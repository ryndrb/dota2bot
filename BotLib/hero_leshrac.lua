local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )
local M = require( GetScriptDirectory()..'/FunLib/aba_modifiers' )

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
                "item_arcane_boots",
                "item_null_talisman",
                "item_kaya",
                "item_bloodstone",--
                "item_black_king_bar",--
                "item_kaya_and_sange",--
                "item_aghanims_shard",
                "item_shivas_guard",--
                "item_sheepstick",--
                "item_ultimate_scepter_2",
                "item_moon_shard",
                "item_travel_boots_2",--
            },
            ['sell_list'] = {
                "item_magic_wand", "item_black_king_bar",
                "item_null_talisman", "item_shivas_guard",
                "item_bottle", "item_cyclone",
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
                "item_mantle",
                "item_circlet",
                "item_faerie_fire",
            
                "item_magic_wand",
                "item_arcane_boots",
                "item_null_talisman",
                "item_kaya",
                "item_pipe",--
                "item_cyclone",
                "item_kaya_and_sange",--
                "item_aghanims_shard",
                "item_black_king_bar",--
                "item_shivas_guard",--
                "item_wind_waker",--
                "item_ultimate_scepter_2",
                "item_travel_boots_2",--
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

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

local bCanEdictTower = true

function X.SkillsComplement()
    if J.CanNotUseAbility(bot) then return end

    SplitEarth        = bot:GetAbilityByName('leshrac_split_earth')
    DiabolicEdict     = bot:GetAbilityByName('leshrac_diabolic_edict')
    LightningStorm    = bot:GetAbilityByName('leshrac_lightning_storm')
    Nihilism          = bot:GetAbilityByName('leshrac_greater_lightning_storm')
    PulseNova         = bot:GetAbilityByName('leshrac_pulse_nova')

    bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    PulseNovaDesire = X.ConsiderPulseNova()
    if PulseNovaDesire > 0
    then
        bot:Action_UseAbility(PulseNova)
        return
    end

    LightningStormDesire, LightningStormTarget = X.ConsiderLightningStorm()
    if LightningStormDesire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(LightningStorm, LightningStormTarget)
        return
    end

    SplitEarthDesire, SplitEarthLocation = X.ConsiderSplitEarth()
    if SplitEarthDesire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(SplitEarth, SplitEarthLocation)
        return
    end

    DiabolicEdictDesire = X.ConsiderDiabolicEdict()
    if DiabolicEdictDesire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(DiabolicEdict)
        return
    end

    NihilismDesire = X.ConsiderNihilism()
    if NihilismDesire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(Nihilism)
        return
    end
end

function X.ConsiderSplitEarth()
    if not J.CanCastAbility(SplitEarth) then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nCastRange = J.GetProperCastRange(false, bot, SplitEarth:GetCastRange())
    local nCastPoint = SplitEarth:GetCastPoint()
    local nRadius = SplitEarth:GetSpecialValueInt('radius')
    local nDelay = SplitEarth:GetSpecialValueFloat('delay') + nCastPoint
    local nDamage = SplitEarth:GetAbilityDamage()
    local nManaCost = SplitEarth:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {DiabolicEdict, LightningStorm, Nihilism, PulseNova})
    local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {SplitEarth, DiabolicEdict, LightningStorm, Nihilism, PulseNova})

    for _, enemyHero in pairs(nEnemyHeroes) do
        if J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        and J.CanCastOnNonMagicImmune(enemyHero)
        then
            if enemyHero:HasModifier('modifier_teleporting') then
                if J.GetModifierTime(enemyHero, 'modifier_teleporting') > nDelay then
                    return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
                end
            elseif enemyHero:IsChanneling() and fManaAfter > fManaThreshold1 then
                return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
            end

            if  J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL, nDelay)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
            and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
            and not enemyHero:HasModifier('modifier_troll_warlord_battle_trance')
            and not enemyHero:HasModifier('modifier_ursa_enrage')
            then
                if J.IsDisabled(enemyHero) or enemyHero:GetCurrentMovementSpeed() < 200 then
                    return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
                end
            end
        end
    end

    if J.IsInTeamFight(bot, 1200) then
        local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
        local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)
        if #nInRangeEnemy >= 2 then
            local count = 0
            for _, enemyHero in pairs(nInRangeEnemy) do
                if J.IsValidHero(enemyHero)
                and J.CanBeAttacked(enemyHero)
                and J.CanCastOnNonMagicImmune(enemyHero)
                and not J.IsChasingTarget(bot, enemyHero)
                and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
                and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
                then
                    for i = 0, enemyHero:NumModifiers() do
                        local sModifierName = enemyHero:GetModifierName(i)
                        if sModifierName then
                            local fRemainingDuration = enemyHero:GetModifierRemainingDuration(i)
                            if M['stunned_unique_invulnerable'] and M['stunned_unique_invulnerable'][sModifierName]
                            or M['stunned_unique'] and M['stunned_unique'][sModifierName]
                            or M['hexed'] and M['hexed'][sModifierName]
                            or M['rooted'] and M['rooted'][sModifierName]
                            or M['stunned'] and M['stunned'][sModifierName]
                            then
                                if fRemainingDuration < nDelay and fRemainingDuration > nCastPoint then
                                    count = count + 1
                                end
                            end
                        end
                    end
                end
            end

            if count >= 2 then
                return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
            end
        end
    end

    if J.IsGoingOnSomeone(bot) then
        if J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and not J.IsChasingTarget(bot, botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        then
            for i = 0, botTarget:NumModifiers() do
                local sModifierName = botTarget:GetModifierName(i)
                if sModifierName then
                    local fRemainingDuration = botTarget:GetModifierRemainingDuration(i)
                    if M['stunned_unique_invulnerable'] and M['stunned_unique_invulnerable'][sModifierName]
                    or M['stunned_unique'] and M['stunned_unique'][sModifierName]
                    or M['hexed'] and M['hexed'][sModifierName]
                    or M['rooted'] and M['rooted'][sModifierName]
                    or M['stunned'] and M['stunned'][sModifierName]
                    then
                        if fRemainingDuration < nDelay and fRemainingDuration > nCastPoint then
                            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
                        end
                    end
                end
            end

            if botTarget:GetCurrentMovementSpeed() < 200 then
                return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
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
            and not J.IsDisabled(enemyHero)
            then
                return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
            end
        end
	end

    local nEnemyCreeps = bot:GetNearbyCreeps(nCastRange, true)

	if J.IsPushing(bot) and bAttacking and fManaAfter > fManaThreshold2 and #nAllyHeroes <= 2 and #nEnemyHeroes == 0 then
		for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 4)
				or (nLocationAoE.count >= 2 and string.find(creep:GetUnitName(), 'upgraded'))
				then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
	end

	if J.IsDefending(bot) and bAttacking and fManaAfter > fManaThreshold1 and #nAllyHeroes <= 2 then
		for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 4)
				or (nLocationAoE.count >= 2 and string.find(creep:GetUnitName(), 'upgraded'))
				then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end

		local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
		if nLocationAoE.count >= 3 then
			return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
		end
	end

    if J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold1 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 3)
                or (nLocationAoE.count >= 2 and creep:GetHealth() >= 500)
				or (nLocationAoE.count >= 2 and creep:IsAncientCreep())
				or (nLocationAoE.count >= 1 and creep:GetHealth() >= 1000)
				then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

    if J.IsLaning(bot) and not J.IsInLaningPhase() and fManaAfter > fManaThreshold1 and (J.IsCore(bot) or not J.IsThereCoreNearby(800)) then
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
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not J.IsDisabled(botTarget)
        and bAttacking
        and fManaAfter > fManaThreshold1
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
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

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderDiabolicEdict()
    if not J.CanCastAbility(DiabolicEdict) then
        return BOT_ACTION_DESIRE_NONE
    end

    local nRadius = DiabolicEdict:GetSpecialValueInt('radius')
    local nDamage = DiabolicEdict:GetSpecialValueInt('damage')
    local nNumExplosions = DiabolicEdict:GetSpecialValueInt('num_explosions')
    local nManaCost = DiabolicEdict:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {SplitEarth, LightningStorm, Nihilism, PulseNova})

    if J.IsGoingOnSomeone(bot) then
        if  J.IsValidTarget(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
        then
            if (J.IsChasingTarget(bot, botTarget) and J.CanKillTarget(botTarget, nDamage * nNumExplosions + 200, DAMAGE_TYPE_PURE) and J.IsInRange(bot, botTarget, nRadius * 0.8))
            or not J.IsChasingTarget(bot, botTarget)
            or J.IsInTeamFight(bot, nRadius * 1.5)
            or J.IsDisabled(botTarget)
            or bot:GetCurrentMovementSpeed() < 200
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
            and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nRadius)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.IsChasingTarget(enemyHero, bot)
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
	end

    local nEnemyCreeps = bot:GetNearbyCreeps(nRadius, true)

    if J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold1 and not bot:HasModifier('modifier_leshrac_pulse_nova') then
        if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
            if (#nEnemyCreeps >= 3)
            or (#nEnemyCreeps >= 2 and nEnemyCreeps[1]:IsAncientCreep())
            or (#nEnemyCreeps >= 1 and nEnemyCreeps[1]:GetHealth() >= 800)
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    end

    if bCanEdictTower then
        if J.IsPushing(bot) and fManaAfter > fManaThreshold1 then
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

function X.ConsiderLightningStorm()
    if not J.CanCastAbility(LightningStorm) then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = J.GetProperCastRange(false, bot, LightningStorm:GetCastRange())
    local nDamage = LightningStorm:GetSpecialValueInt('damage')
    local nRadius = LightningStorm:GetSpecialValueInt('radius')
    local nManaCost = LightningStorm:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {SplitEarth, DiabolicEdict, Nihilism, PulseNova})
    local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {SplitEarth, DiabolicEdict, LightningStorm, Nihilism, PulseNova})

    for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange + 300)
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
        and J.CanBeAttacked(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.CanCastOnTargetAdvanced(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange + 300)
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
            and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and J.IsChasingTarget(enemyHero, bot)
            and not J.IsDisabled(enemyHero)
            and bot:WasRecentlyDamagedByHero(enemyHero, 2.0)
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero
            end
        end
    end

    if not J.IsRetreating(bot) and not J.IsRealInvisible(bot) and fManaAfter > fManaThreshold2 and not J.IsInTeamFight(bot, 1200) then
        for _, allyHero in pairs(nAllyHeroes) do
            if  J.IsValidHero(allyHero)
            and bot ~= allyHero
            and J.IsRetreating(allyHero)
            and allyHero:WasRecentlyDamagedByAnyHero(2.0)
            and not allyHero:IsIllusion()
            then
                for _, enemyHero in pairs(nEnemyHeroes) do
                    if  J.IsValidHero(enemyHero)
                    and J.CanBeAttacked(enemyHero)
                    and J.IsInRange(bot, enemyHero, nCastRange)
                    and J.CanCastOnNonMagicImmune(enemyHero)
                    and J.CanCastOnTargetAdvanced(enemyHero)
                    and J.IsChasingTarget(enemyHero, allyHero)
                    and not J.IsDisabled(enemyHero)
                    and allyHero:WasRecentlyDamagedByHero(enemyHero, 2.0)
                    then
                        return BOT_ACTION_DESIRE_HIGH, enemyHero
                    end
                end
            end
        end
    end

    local nEnemyCreeps = bot:GetNearbyCreeps(nCastRange, true)

	if J.IsPushing(bot) and bAttacking and fManaAfter > fManaThreshold2 and #nAllyHeroes <= 3 and #nEnemyHeroes == 0 then
		for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 4)
				or (nLocationAoE.count >= 2 and string.find(creep:GetUnitName(), 'upgraded'))
				then
                    return BOT_ACTION_DESIRE_HIGH, creep
                end
            end
        end
	end

	if J.IsDefending(bot) and bAttacking and fManaAfter > fManaThreshold1 then
		for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 4)
				or (nLocationAoE.count >= 2 and string.find(creep:GetUnitName(), 'upgraded'))
				then
                    return BOT_ACTION_DESIRE_HIGH, creep
                end
            end
        end
	end

    if J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold1 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 3)
                or (nLocationAoE.count >= 2 and creep:GetHealth() >= 500)
				or (nLocationAoE.count >= 2 and creep:IsAncientCreep())
				or (nLocationAoE.count >= 1 and creep:GetHealth() >= 1000)
				then
                    return BOT_ACTION_DESIRE_HIGH, creep
                end
            end
        end
    end

    if J.IsLaning(bot) and J.IsInLaningPhase() and fManaAfter > fManaThreshold1 then
		for _, creep in pairs(nEnemyCreeps) do
			if  J.IsValid(creep)
            and J.CanBeAttacked(creep)
			and J.CanKillTarget(creep, nDamage, DAMAGE_TYPE_MAGICAL)
			then
				local sCreepName = creep:GetUnitName()
				local nLocationAoE = bot:FindAoELocation(true, true, creep:GetLocation(), 0, nRadius, 0, 0)
				if string.find(sCreepName, 'ranged') and not J.IsOtherAllysTarget(creep) then
					if nLocationAoE.count > 0 or J.IsUnitTargetedByTower(creep, false) then
						return BOT_ACTION_DESIRE_HIGH, creep
					end
				end

				nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, nDamage)
				if nLocationAoE.count >= 2 and (J.IsCore(bot) or not J.IsThereCoreInLocation(nLocationAoE.targetloc, 600)) then
					return BOT_ACTION_DESIRE_HIGH, creep
				end
			end
		end
    end

    if J.IsDoingRoshan(bot) then
        if  J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and bAttacking
        and fManaAfter > fManaThreshold1
        then
            if J.CanCastOnTargetAdvanced(botTarget)
            or fManaAfter > fManaThreshold2
            then
                return BOT_ACTION_DESIRE_HIGH, botTarget
            end
        end
    end

    if J.IsDoingTormentor(bot) then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and bAttacking
        and fManaAfter > fManaThreshold1
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderNihilism()
    if not J.CanCastAbility(Nihilism)
    or not J.CanBeAttacked(Nihilism)
    then
        return BOT_ACTION_DESIRE_NONE
    end

    local nRadius = Nihilism:GetSpecialValueInt('radius')

    if J.GetAttackProjectileDamageByRange(bot, 550) > bot:GetHealth() then
        return BOT_ACTION_DESIRE_HIGH
    end

    if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
    and bot:WasRecentlyDamagedByAnyHero(3.0)
    then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.IsInRange(bot, enemyHero, nRadius + 300)
            and not J.IsSuspiciousIllusion(enemyHero)
            then
                if J.IsChasingTarget(enemyHero, bot)
                or bot:IsRooted()
                then
                    return BOT_ACTION_DESIRE_HIGH
                end
            end
        end
	end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderPulseNova()
    if not J.CanCastAbility(PulseNova) then
        return BOT_ACTION_DESIRE_NONE
    end

	local nRadius = PulseNova:GetSpecialValueInt('radius')
    local botMP = J.GetMP(bot)
    local nManaCost = PulseNova:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {SplitEarth, DiabolicEdict, LightningStorm, Nihilism})
    local bIsToggled = PulseNova:GetToggleState()

    local nEnemyCreeps = bot:GetNearbyCreeps(nRadius, true)
    local nInRangeEnemy = bot:GetNearbyHeroes(nRadius, true, BOT_MODE_NONE)

    if  bot:HasModifier('modifier_item_bloodstone_active')
    and ((#nEnemyCreeps >= 1 and fManaAfter > fManaThreshold1) or #nEnemyHeroes > 0)
    then
        if not bIsToggled then
            return BOT_ACTION_DESIRE_HIGH
        else
            return BOT_ACTION_DESIRE_NONE
        end
    end

    if J.IsInTeamFight(bot, 1200) then
        if #nInRangeEnemy >= 1 then
            if not bIsToggled then
                return BOT_ACTION_DESIRE_HIGH
            else
                return BOT_ACTION_DESIRE_NONE
            end
        end
    end

    if J.IsGoingOnSomeone(bot) then
        if J.IsValidTarget(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
        then
            if fManaAfter > fManaThreshold1 and J.IsInRange(bot, botTarget, nRadius + 300) then
                if not bIsToggled and bAttacking then
                    return BOT_ACTION_DESIRE_HIGH
                end
                return BOT_ACTION_DESIRE_NONE
            end
        end
    end

    if J.IsPushing(bot) or J.IsDefending(bot) then
        if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
            if (#nEnemyCreeps >= 3)
            or (#nEnemyCreeps >= 2 and string.find(nEnemyCreeps[1]:GetUnitName(), 'upgraded'))
            then
                if fManaAfter > fManaThreshold1 + 0.1 then
                    if not bIsToggled and bAttacking then
                        return BOT_ACTION_DESIRE_HIGH
                    else
                        return BOT_ACTION_DESIRE_NONE
                    end
                end
            end
        end
    end

    if J.IsFarming(bot) then
        if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
            if (#nEnemyCreeps >= 3)
            or (#nEnemyCreeps >= 1 and nEnemyCreeps[1]:GetHealth() >= 800)
            or (#nEnemyCreeps >= 2 and nEnemyCreeps[1]:IsAncientCreep())
            then
                if fManaAfter > fManaThreshold1 + 0.1 then
                    if not bIsToggled and bAttacking then
                        return BOT_ACTION_DESIRE_HIGH
                    else
                        return BOT_ACTION_DESIRE_NONE
                    end
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
            if fManaAfter > fManaThreshold1 + 0.2 then
                if not bIsToggled and bAttacking then
                    return BOT_ACTION_DESIRE_HIGH
                else
                    return BOT_ACTION_DESIRE_NONE
                end
            end
        end
    end

    if J.IsDoingTormentor(bot) then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        then
            if fManaAfter > fManaThreshold1 + 0.2 then
                if not bIsToggled and bAttacking then
                    return BOT_ACTION_DESIRE_HIGH
                else
                    return BOT_ACTION_DESIRE_NONE
                end
            end
        end
    end

    if bIsToggled then
        return BOT_ACTION_DESIRE_HIGH
    end

    return BOT_ACTION_DESIRE_NONE
end

return X