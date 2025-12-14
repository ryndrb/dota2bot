local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_enigma'
then

local RI = require(GetScriptDirectory()..'/FunLib/util_role_item')

local sUtility = {"item_lotus_orb", "item_crimson_guard"}
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
                [1] = {
                    ['t25'] = {10, 0},
                    ['t20'] = {0, 10},
                    ['t15'] = {0, 10},
                    ['t10'] = {0, 10},
                },
            },
            ['ability'] = {
                [1] = {2,1,2,1,2,6,2,1,1,3,6,3,3,3,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_faerie_fire",
                "item_double_circlet",

                "item_magic_wand",
                "item_tranquil_boots",
                "item_vladmir",
                "item_blink",
                "item_pipe",--
                "item_black_king_bar",--
                "item_shivas_guard",--
                "item_refresher",--
                "item_aghanims_shard",
                "item_arcane_blink",--
                "item_ultimate_scepter_2",
                "item_travel_boots_2",--
                "item_moon_shard",
            },
            ['sell_list'] = {
                "item_circlet", "item_pipe",
                "item_circlet", "item_black_king_bar",
                "item_magic_wand", "item_shivas_guard",
                "item_vladmir", "item_refresher",
            },
        },
    },
    ['pos_4'] = {
        [1] = {
            ['talent'] = {
                [1] = {
                    ['t25'] = {0, 10},
                    ['t20'] = {0, 10},
                    ['t15'] = {0, 10},
                    ['t10'] = {0, 10},
                }
            },
            ['ability'] = {
                [1] = {2,1,2,1,2,6,2,1,1,3,6,3,3,3,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_magic_stick",
                "item_blood_grenade",
                "item_faerie_fire",

                "item_tranquil_boots",
                "item_magic_wand",
                "item_vladmir",
                "item_ancient_janggo",
                "item_blink",
                "item_solar_crest",--
                "item_boots_of_bearing",--
                "item_black_king_bar",--
                "item_refresher",--
                "item_aghanims_shard",
                "item_sphere",--
                "item_arcane_blink",--
                "item_ultimate_scepter_2",
                "item_moon_shard",
            },
            ['sell_list'] = {
                "item_magic_wand", "item_refresher",
                "item_vladmir", "item_sphere",
            },
        },
    },
    ['pos_5'] = {
        [1] = {
            ['talent'] = {
                [1] = {
                    ['t25'] = {0, 10},
                    ['t20'] = {0, 10},
                    ['t15'] = {0, 10},
                    ['t10'] = {0, 10},
                }
            },
            ['ability'] = {
                [1] = {2,1,2,1,2,6,2,1,1,3,6,3,3,3,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_magic_stick",
                "item_blood_grenade",
                "item_faerie_fire",

                "item_arcane_boots",
                "item_magic_wand",
                "item_vladmir",
                "item_mekansm",
                "item_blink",
                "item_solar_crest",--
                "item_guardian_greaves",--
                "item_black_king_bar",--
                "item_refresher",--
                "item_aghanims_shard",
                "item_sphere",--
                "item_arcane_blink",--
                "item_ultimate_scepter_2",
                "item_moon_shard",
            },
            ['sell_list'] = {
                "item_magic_wand", "item_refresher",
                "item_vladmir", "item_sphere",
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

local Malefice          = bot:GetAbilityByName('enigma_malefice')
local DemonicSummoning  = bot:GetAbilityByName('enigma_demonic_conversion')
local MidnightPulse     = bot:GetAbilityByName('enigma_midnight_pulse')
local BlackHole         = bot:GetAbilityByName('enigma_black_hole')

local MaleficeDesire, MaleficeTarget
local DemonicSummoningDesire, DemonicSummoningLocation
local MidnightPulseDesire, MidnightPulseLocation
local BlackHoleDesire, BlackHoleLocation

local BlinkHoleDesire, BlinkHoleLocation
local BlinkPulseHoleDesire, BlinkPulseHoleLocation

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
    bot = GetBot()

    local hAbilityCurrentActive = bot:GetCurrentActiveAbility()
    if hAbilityCurrentActive and hAbilityCurrentActive == BlackHole then
        local nRadius = BlackHole:GetSpecialValueInt('radius')
        if BlackHoleLocation and type(BlackHoleLocation) == 'userdata' then
            local nInRangeEnemy = J.GetEnemiesNearLoc(BlackHoleLocation, nRadius)
            if #nInRangeEnemy == 0 then
                bot:Action_ClearActions(true)
                return
            end
        end

        if BlinkHoleLocation and type(BlinkHoleLocation) == 'userdata' then
            local nInRangeEnemy = J.GetEnemiesNearLoc(BlinkHoleLocation, nRadius)
            if #nInRangeEnemy == 0 then
                bot:Action_ClearActions(true)
                return
            end
        end

        if BlinkPulseHoleLocation and type(BlinkPulseHoleLocation) == 'userdata'  then
            local nInRangeEnemy = J.GetEnemiesNearLoc(BlinkPulseHoleLocation, nRadius)
            if #nInRangeEnemy == 0 then
                bot:Action_ClearActions(true)
                return
            end
        end

        return
    end

	if J.CanNotUseAbility(bot) then return end

    Malefice          = bot:GetAbilityByName('enigma_malefice')
    DemonicSummoning  = bot:GetAbilityByName('enigma_demonic_conversion')
    MidnightPulse     = bot:GetAbilityByName('enigma_midnight_pulse')
    BlackHole         = bot:GetAbilityByName('enigma_black_hole')

    bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    local vTeamFightLocation = J.GetTeamFightLocation(bot)

    BlinkPulseHoleDesire, BlinkPulseHoleLocation = X.ConsiderBlinkPulseHole()
    if BlinkPulseHoleDesire > 0 and J.CanCastAbility(bot.Blink) then
        bot:Action_ClearActions(false)

        if vTeamFightLocation and J.GetDistance(vTeamFightLocation, BlinkPulseHoleLocation) <= 1200 then
            local BlackKingBar = J.IsItemAvailable('item_black_king_bar')
            if J.CanCastAbility(BlackKingBar) and (bot:GetMana() > (MidnightPulse:GetManaCost() + BlackHole:GetManaCost() + BlackKingBar:GetManaCost() + 100)) and not bot:IsMagicImmune() then
                bot:ActionQueue_UseAbility(BlackKingBar)
                bot:ActionQueue_Delay(0.1)
            end
        end

        bot:ActionQueue_UseAbilityOnLocation(bot.Blink, BlinkPulseHoleLocation)
        bot:ActionQueue_Delay(0.1)
        bot:ActionQueue_UseAbilityOnLocation(MidnightPulse, BlinkPulseHoleLocation)
        bot:ActionQueue_UseAbilityOnLocation(BlackHole, BlinkPulseHoleLocation)
        return
    end

    BlinkHoleDesire, BlinkHoleLocation = X.ConsiderBlinkHole()
    if BlinkHoleDesire > 0 and J.CanCastAbility(bot.Blink) then
        bot:Action_ClearActions(false)

        if vTeamFightLocation and J.GetDistance(vTeamFightLocation, BlinkHoleLocation) <= 1200 then
            local BlackKingBar = J.IsItemAvailable('item_black_king_bar')
            if J.CanCastAbility(BlackKingBar) and (bot:GetMana() > (BlackHole:GetManaCost() + BlackKingBar:GetManaCost() + 100)) and not bot:IsMagicImmune() then
                bot:ActionQueue_UseAbility(BlackKingBar)
                bot:ActionQueue_Delay(0.1)
            end
        end

        bot:ActionQueue_UseAbilityOnLocation(bot.Blink, BlinkHoleLocation)
        bot:ActionQueue_Delay(0.1)
        bot:ActionQueue_UseAbilityOnLocation(BlackHole, BlinkHoleLocation)
        return
    end

    MidnightPulseDesire, MidnightPulseLocation = X.ConsiderMidnightPulse()
    if MidnightPulseDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(MidnightPulse, MidnightPulseLocation)
        return
    end

    BlackHoleDesire, BlackHoleLocation = X.ConsiderBlackHole()
    if BlackHoleDesire > 0 then
        local BlackKingBar = J.IsItemAvailable('item_black_king_bar')
        if not bot:IsMagicImmune() and J.CanCastAbility(BlackKingBar) then
            if (bot:GetMana() > (BlackHole:GetManaCost() + BlackKingBar:GetManaCost() + 100)) then
                bot:Action_ClearActions(false)
                bot:ActionQueue_UseAbility(BlackKingBar)
                bot:ActionQueue_Delay(0.1)
                bot:ActionQueue_UseAbilityOnLocation(BlackHole, BlackHoleLocation)
                return
            elseif J.CanCastAbility(MidnightPulse) and (bot:GetMana() > (MidnightPulse:GetManaCost() + BlackHole:GetManaCost() + BlackKingBar:GetManaCost() + 100)) then
                bot:Action_ClearActions(false)
                bot:ActionQueue_UseAbility(BlackKingBar)
                bot:ActionQueue_Delay(0.1)
                bot:ActionQueue_UseAbilityOnLocation(MidnightPulse, BlackHoleLocation)
                bot:ActionQueue_UseAbilityOnLocation(BlackHole, BlackHoleLocation)
                return
            end
        end

        if J.CanCastAbility(MidnightPulse) and (bot:GetMana() > (MidnightPulse:GetManaCost() + BlackHole:GetManaCost() + 100)) then
            bot:Action_ClearActions(false)
            bot:ActionQueue_UseAbilityOnLocation(MidnightPulse, BlackHoleLocation)
            bot:ActionQueue_UseAbilityOnLocation(BlackHole, BlackHoleLocation)
            return
        end

        bot:Action_UseAbilityOnLocation(BlackHole, BlackHoleLocation)
        return
    end

    MaleficeDesire, MaleficeTarget = X.ConsiderMalefice()
    if MaleficeDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(Malefice, MaleficeTarget)
        return
    end

    DemonicSummoningDesire, DemonicSummoningLocation = X.ConsiderDemonicSummoning()
    if DemonicSummoningDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(DemonicSummoning, DemonicSummoningLocation)
        return
    end
end

function X.ConsiderMalefice()
    if not J.CanCastAbility(Malefice) then
        return BOT_ACTION_DESIRE_NONE, nil
    end

	local nCastRange = J.GetProperCastRange(false, bot, Malefice:GetCastRange())
    local nStunInstances = Malefice:GetSpecialValueInt('stun_instances')
	local nDamage = Malefice:GetSpecialValueInt('damage') * nStunInstances
    local nManaCost = Malefice:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {DemonicSummoning, MidnightPulse, BlackHole})
	local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {BlackHole})

	for _, enemyHero in pairs(nEnemyHeroes) do
		if  J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange + 150)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanCastOnTargetAdvanced(enemyHero)
		then
            if enemyHero:IsChanneling() then
                return BOT_ACTION_DESIRE_HIGH, enemyHero
            end

            if  J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
            and not enemyHero:HasModifier('modifier_abaddon_aphotic_shield')
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero
            end
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange + 150)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.CanCastOnTargetAdvanced(botTarget)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_enigma_malefice')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
        and fManaAfter > fManaThreshold2
		then
            return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and not J.IsDisabled(enemyHero)
            and not enemyHero:HasModifier('modifier_enigma_malefice')
            and bot:WasRecentlyDamagedByHero(enemyHero, 3.0)
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero
            end
        end
	end

	if J.IsDoingRoshan(bot) then
        if  J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and bAttacking
        and fManaAfter > fManaThreshold1
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
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

function X.ConsiderDemonicSummoning()
    if not J.CanCastAbility(DemonicSummoning) then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nCastRange = J.GetProperCastRange(false, bot, DemonicSummoning:GetCastRange())
    local nHealthCost = 75 + (25 * (DemonicSummoning:GetLevel() - 1))
    local nManaCost = DemonicSummoning:GetManaCost()
    local fHealthAfter = J.GetHealthAfter(nHealthCost)
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Malefice, MidnightPulse, BlackHole})
	local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {BlackHole})

    local botAttackRange = bot:GetAttackRange()
    local botLocation = bot:GetLocation()

    if  J.IsGoingOnSomeone(bot) and fHealthAfter > 0.4 and fManaAfter > fManaThreshold2 then
		if  J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, botAttackRange)
        and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
		then
            local distance = GetUnitToUnitDistance(bot, botTarget)
            local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), 1200)
            local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1200)

            if #nInRangeAlly >= #nInRangeEnemy then
                return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(bot:GetLocation(), botTarget:GetLocation(), Min(distance, nCastRange))
            end

            return BOT_ACTION_DESIRE_HIGH, botLocation
		end
	end

    local nEnemyCreeps = bot:GetNearbyCreeps(Min(botAttackRange + 300, 1600), true)

    if J.IsPushing(bot) and bAttacking and fManaAfter > fManaThreshold1 and fHealthAfter > 0.5 and #nAllyHeroes <= 2 and #nEnemyHeroes == 0 then
        if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
            if (#nEnemyCreeps >= 2 and #nAllyHeroes <= 1)
            or (#nEnemyCreeps >= 3)
            then
                return BOT_ACTION_DESIRE_HIGH, botLocation
            end
        end

        local nAllyLaneCreeps = bot:GetNearbyLaneCreeps(900, false)

        if  J.IsValidBuilding(botTarget)
		and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, botAttackRange)
        and not botTarget:HasModifier('modifier_backdoor_protection')
        and #nAllyLaneCreeps >= 3
        then
            return BOT_ACTION_DESIRE_HIGH, botLocation
        end
    end

    if J.IsDefending(bot) and bAttacking and fManaAfter > fManaThreshold1 and fHealthAfter > 0.5 and #nAllyHeroes <= 3 and #nEnemyHeroes == 0 then
        if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
            if (#nEnemyCreeps >= 2 and #nAllyHeroes <= 1)
            or (#nEnemyCreeps >= 3)
            then
                return BOT_ACTION_DESIRE_HIGH, botLocation
            end
        end
    end

    if J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold1 and fHealthAfter > 0.4 then
        if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
            if (#nEnemyCreeps >= 2)
            or (#nEnemyCreeps >= 1 and nEnemyCreeps[1]:GetHealth() >= 550)
            then
                return BOT_ACTION_DESIRE_HIGH, botLocation
            end
        end
    end

    if J.IsLaning(bot) and J.IsInLaningPhase() and fManaAfter > fManaThreshold1 and fHealthAfter > 0.55 then
        local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), 1200)
        local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1200)
        if #nInRangeAlly >= #nInRangeEnemy and not bot:WasRecentlyDamagedByAnyHero(5.0) then
            local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(1000, true)
            if #nEnemyLaneCreeps >= 3 then
                return BOT_ACTION_DESIRE_HIGH, botLocation
            end
        end
    end

    if J.IsDoingRoshan(bot) then
        if  J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, botAttackRange)
        and bAttacking
        and fManaAfter > fManaThreshold1
        and fHealthAfter > 0.5
        then
            return BOT_ACTION_DESIRE_HIGH, botLocation
        end
	end

    if J.IsDoingTormentor(bot) then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, botAttackRange)
        and bAttacking
        and fManaAfter > fManaThreshold1
        and fHealthAfter > 0.6
        then
            return BOT_ACTION_DESIRE_HIGH, botLocation
        end
	end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderMidnightPulse()
    if not J.CanCastAbility(MidnightPulse) then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nCastRange = J.GetProperCastRange(false, bot, MidnightPulse:GetCastRange())
    local nRadius = MidnightPulse:GetSpecialValueInt('radius')
    local nManaCost = MidnightPulse:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {BlackHole})

	if J.IsInTeamFight(bot, 1200) then
        local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
        local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius * 0.8)
        if #nInRangeEnemy >= 2 then
            local count = 0
            for _, enemyHero in pairs(nInRangeEnemy) do
                if  J.IsValidHero(enemyHero)
                and J.CanBeAttacked(enemyHero)
                and not J.IsChasingTarget(bot, enemyHero)
                and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
                and not enemyHero:HasModifier('modifier_enigma_midnight_pulse_damage')
                then
                    count = count + 1
                end
            end

            if count >= 2 then
                return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
            end
        end
	end

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not J.IsChasingTarget(bot, botTarget)
        and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_enigma_midnight_pulse_damage')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
            if J.IsDisabled(botTarget)
            or botTarget:GetCurrentMovementSpeed() <= 250
            or botTarget:IsFacingLocation(bot:GetLocation(), 45)
            then
                return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
            end
		end
	end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderBlackHole()
    if not J.CanCastAbility(BlackHole) then
        return BOT_ACTION_DESIRE_NONE, 0
    end

	local nCastRange = J.GetProperCastRange(false, bot, BlackHole:GetCastRange())
    local nCastPoint = BlackHole:GetCastPoint()
    local nRadius = BlackHole:GetSpecialValueInt('radius')
    local nDamage = BlackHole:GetSpecialValueInt('damage')
    local nDuration = BlackHole:GetSpecialValueInt('duration')
    local fTickRate = BlackHole:GetSpecialValueFloat('tick_rate')

    if not bot:IsMagicImmune() then
		if J.IsStunProjectileIncoming(bot, 1200) then
			return BOT_ACTION_DESIRE_NONE, 0
		end
	end

    if J.GetAttackProjectileDamageByRange(bot, 1200) > bot:GetHealth() + 200 then
        return BOT_ACTION_DESIRE_NONE, 0
    end

	if J.IsInTeamFight(bot, 1200) then
        local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
        local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius * 0.8)
        if #nInRangeEnemy >= 2 then
            local count = 0
            for _, enemyHero in pairs(nInRangeEnemy) do
                if  J.IsValidHero(enemyHero)
                and J.CanBeAttacked(enemyHero)
                and not J.IsChasingTarget(bot, enemyHero)
                and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
                and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
                and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
                and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
                and not enemyHero:HasModifier('modifier_item_aeon_disk_buff')
                then
                    if J.IsCore(enemyHero) then
                        count = count + 1
                    else
                        count = count + 0.5
                    end
                end
            end

            if count >= 1.5 then
                return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
            end
        end
	end

	if J.IsGoingOnSomeone(bot) and not J.IsInTeamFight(bot, 1400) then
		if  J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, 800)
        and not J.IsSuspiciousIllusion(botTarget)
        and not J.IsChasingTarget(bot, botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
        and not botTarget:HasModifier('modifier_item_aeon_disk_buff')
		then
            local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), 1200)
            local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1200)
            local damage = nDamage * (nDuration * (1 - fTickRate))

            local nInRangeEnemy__ = J.GetEnemiesNearLoc(botTarget:GetLocation(), nRadius * 0.8)

            if not (#nInRangeAlly >= #nInRangeEnemy + 3) and botTarget:GetHealth() >= damage * 0.5 then
                if J.WillKillTarget(botTarget, damage, DAMAGE_TYPE_PURE, nDuration + nCastPoint) then
                    if #nInRangeAlly <= 2 and #nInRangeEnemy <= 1 then
                        if J.IsCore(botTarget) or #nInRangeEnemy__ >= 2 then
                            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
                        end
                    end
                end

                if J.GetTotalEstimatedDamageToTarget(nAllyHeroes, nDuration, nDuration + nCastPoint - 1) then
                    if J.IsCore(botTarget) or #nInRangeEnemy__ >= 2 then
                        return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
                    end
                end
            end
		end
	end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderBlinkHole()
    if J.CanCastAbility(BlackHole) and J.CanBlinkDagger(bot) then

        local nManaCost = BlackHole:GetManaCost() + 100
        if bot:GetMana() < nManaCost then
            return BOT_ACTION_DESIRE_NONE, 0
        end

        local nRadius = BlackHole:GetSpecialValueInt('radius')

        for i = 1, 5 do
            local allyHero = GetTeamMember(i)

            if  J.IsValidHero(allyHero)
            and J.IsInRange(bot, allyHero, 1600)
            and J.IsInTeamFight(allyHero, 1200)
            then
                local nLocationAoE = allyHero:FindAoELocation(true, true, allyHero:GetLocation(), 1200, nRadius, 0, 0)
                local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius * 0.8)
                if #nInRangeEnemy >= 2 then
                    local count = 0
                    for _, enemyHero in pairs(nInRangeEnemy) do
                        if  J.IsValidHero(enemyHero)
                        and J.CanBeAttacked(enemyHero)
                        and not J.IsChasingTarget(allyHero, enemyHero)
                        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
                        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
                        and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
                        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
                        and not enemyHero:HasModifier('modifier_item_aeon_disk_buff')
                        then
                            if J.IsCore(enemyHero) then
                                count = count + 1
                            else
                                count = count + 0.5
                            end
                        end
                    end

                    if count >= 1.5 then
                        return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                    end
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderBlinkPulseHole()
    if J.CanCastAbility(MidnightPulse) and J.CanCastAbility(BlackHole) and J.CanBlinkDagger(bot) then

        local nManaCost = BlackHole:GetManaCost() + MidnightPulse:GetManaCost() + 100
        if bot:GetMana() < nManaCost then
            return BOT_ACTION_DESIRE_NONE, 0
        end

        local nRadius = BlackHole:GetSpecialValueInt('radius')

        for i = 1, 5 do
            local allyHero = GetTeamMember(i)

            if  J.IsValidHero(allyHero)
            and J.IsInRange(bot, allyHero, 1600)
            and J.IsInTeamFight(allyHero, 1200)
            then
                local nLocationAoE = allyHero:FindAoELocation(true, true, allyHero:GetLocation(), 1200, nRadius, 0, 0)
                local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius * 0.8)
                if #nInRangeEnemy >= 2 then
                    local count = 0
                    for _, enemyHero in pairs(nInRangeEnemy) do
                        if  J.IsValidHero(enemyHero)
                        and J.CanBeAttacked(enemyHero)
                        and not J.IsChasingTarget(allyHero, enemyHero)
                        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
                        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
                        and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
                        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
                        and not enemyHero:HasModifier('modifier_item_aeon_disk_buff')
                        then
                            if J.IsCore(enemyHero) then
                                count = count + 1
                            else
                                count = count + 0.5
                            end
                        end
                    end

                    if count >= 1.5 then
                        return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                    end
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

return X