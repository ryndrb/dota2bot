local X             = {}
local bot           = GetBot()

local J             = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion        = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList   = J.Skill.GetTalentList( bot )
local sAbilityList  = J.Skill.GetAbilityList( bot )
local sRole   = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_elder_titan'
then

local RI = require(GetScriptDirectory()..'/FunLib/util_role_item')

local sUtility = {"item_pipe", "item_heavens_halberd"}
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
                    ['t25'] = {0, 10},
                    ['t20'] = {0, 10},
                    ['t15'] = {10, 0},
                    ['t10'] = {10, 0},
                }
            },
            ['ability'] = {
                -- [1] = {2,3,2,3,2,3,2,3,6,1,6,1,1,1,6},
                [1] = {2,3,2,1,2,1,6,2,1,3,6,3,3,1,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_quelling_blade",
                "item_wind_lace",
            
                "item_magic_wand",
                "item_phase_boots",
                "item_radiance",--
                "item_vladmir",--
                "item_crimson_guard",--
                "item_black_king_bar",--
                "item_assault",--
                "item_travel_boots_2",--
                "item_ultimate_scepter_2",
                "item_moon_shard",
                -- "item_aghanims_shard",--alt cast bug..
            },
            ['sell_list'] = {
                "item_quelling_blade",
                "item_wind_lace",
                "item_magic_wand",
            },
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
                [1] = {2,3,2,1,1,6,1,1,3,3,3,6,2,2,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_blood_grenade",
                "item_wind_lace",
            
                "item_magic_wand",
                "item_tranquil_boots",
                "item_ancient_janggo",
                "item_solar_crest",--
                "item_vladmir",--
                "item_boots_of_bearing",--
                -- "item_aghanims_shard",--alt cast bug..
                "item_assault",--
                "item_black_king_bar",--
                "item_sheepstick",--
                "item_ultimate_scepter_2",
                "item_moon_shard",
            },
            ['sell_list'] = {
                "item_magic_wand",
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
                [1] = {2,3,2,1,1,6,1,1,3,3,3,6,2,2,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_blood_grenade",
                "item_wind_lace",
            
                "item_magic_wand",
                "item_arcane_boots",
                "item_mekansm",
                "item_solar_crest",--
                "item_vladmir",--
                "item_guardian_greaves",--
                -- "item_aghanims_shard",--alt cast bug..
                "item_assault",--
                "item_black_king_bar",--
                "item_sheepstick",--
                "item_ultimate_scepter_2",
                "item_moon_shard",
            },
            ['sell_list'] = {
                "item_wind_lace",
                "item_magic_wand",
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

-- hMinionUnit is not a "physical" minion
function X.MinionThink(hMinionUnit)
    if J.IsValid(hMinionUnit) and X.IsAstralSpiritSummoned()
    and hMinionUnit:GetUnitName() == 'npc_dota_elder_titan_ancestral_spirit'
    then
        bot.astral_spirit = hMinionUnit
        local EchoStomp = bot:GetAbilityByName('elder_titan_echo_stomp')
        local EchoStomp__astral = hMinionUnit:GetAbilityByName('elder_titan_echo_stomp_spirit')

        if J.CanNotUseAction(bot) or J.CanNotUseAbility(bot) then
            return
        end

        if EchoStomp__astral ~= nil and EchoStomp__astral:IsTrained() and (EchoStomp__astral:IsChanneling() or hMinionUnit:HasModifier('modifier_elder_titan_ancestral_spirit_cast_time')) then
            return
        end

        -- cannot perform actions with hMinionUnit
        Desire = X.ConsiderEchoStomp(hMinionUnit)
        if Desire > 0 and not J.IsInRange(bot, hMinionUnit, 150) and not X.HasShard() then
            bot:Action_UseAbility(EchoStomp)
            return
        end
    else
        Minion.MinionThink(hMinionUnit)
    end
end

end

local EchoStomp             = bot:GetAbilityByName('elder_titan_echo_stomp')
local AstralSpirit          = bot:GetAbilityByName('elder_titan_ancestral_spirit')
local MoveAstralSpirit      = bot:GetAbilityByName('elder_titan_move_spirit')
local ReturnAstralSpirit    = bot:GetAbilityByName('elder_titan_return_spirit')
local NaturalOrder          = bot:GetAbilityByName('elder_titan_natural_order')
local EarthSplitter         = bot:GetAbilityByName('elder_titan_earth_splitter')

local EchoStompDesire
local AstralSpiritDesire, AstralSpiritLocation
local MoveAstralSpiritDesire, MoveAstralSpiritLocation
local ReturnAstralSpiritDesire
local EarthSplitterDesire, EarthSplitterLocation

local botTarget

function X.SkillsComplement()
    EchoStomp             = bot:GetAbilityByName('elder_titan_echo_stomp')
    AstralSpirit          = bot:GetAbilityByName('elder_titan_ancestral_spirit')
    MoveAstralSpirit      = bot:GetAbilityByName('elder_titan_move_spirit')
    ReturnAstralSpirit    = bot:GetAbilityByName('elder_titan_return_spirit')
    EarthSplitter         = bot:GetAbilityByName('elder_titan_earth_splitter')

	if J.CanNotUseAbility(bot) then return end

    if EchoStomp ~= nil and EchoStomp:IsChanneling() then
        return
    end

    -- due to alt-cast bug, ET will not use echo stomp once shard is acquired (tormentor)

    botTarget = J.GetProperTarget(bot)

    EchoStompDesire = X.ConsiderEchoStomp(bot)
    if EchoStompDesire > 0 then
        if X.HasShard() then-- does not work
            if J.CanCastAbility(AstralSpirit) then
                bot:Action_ClearActions(false)
                bot:ActionQueue_UseAbilityOnLocation(AstralSpirit, J.GetFaceTowardDistanceLocation(bot, 250))
                bot:ActionQueue_Delay(0.4)
                local EchoStomp__astral = bot.astral_spirit:GetAbilityByName('elder_titan_echo_stomp_spirit')
                bot.astral_spirit:ActionQueue_UseAbility(EchoStomp__astral)
                return
            end
        else
            bot:Action_UseAbility(EchoStomp)
            return
        end
    end

    AstralSpiritDesire, AstralSpiritLocation, bStomp = X.ConsiderAstralSpirit()
    if AstralSpiritDesire > 0 then
        if bStomp then
            bot:Action_ClearActions(false)
            bot:ActionQueue_UseAbilityOnLocation(AstralSpirit, AstralSpiritLocation)
            bot:ActionQueue_Delay(0.4)
            bot:ActionQueue_UseAbility(EchoStomp)
            return
        else
            bot:Action_UseAbilityOnLocation(AstralSpirit, AstralSpiritLocation)
            return
        end
    end

    EarthSplitterDesire, EarthSplitterLocation = X.ConsiderEarthSplitter()
    if EarthSplitterDesire > 0 then
        bot:Action_UseAbilityOnLocation(EarthSplitter, EarthSplitterLocation)
        return
    end

    MoveAstralSpiritDesire, MoveAstralSpiritLocation = X.ConsiderMoveAstralSpirit()
    if MoveAstralSpiritDesire > 0 then
        bot:Action_UseAbilityOnLocation(MoveAstralSpirit, MoveAstralSpiritLocation)
        return
    end

    ReturnAstralSpiritDesire = X.ConsiderReturnAstralSpirit()
    if ReturnAstralSpiritDesire > 0 then
        bot:Action_UseAbility(ReturnAstralSpirit)
        return
    end
end

function X.ConsiderEchoStomp(hUnit)
    if not J.CanCastAbility(EchoStomp)
    or not J.IsValid(hUnit)
    or X.HasShard() then
        return BOT_ACTION_DESIRE_NONE
    end

    local fCastPoint = EchoStomp:GetCastPoint()
    local fChannelTime = EchoStomp:GetSpecialValueFloat('cast_time')
    local nRadius = EchoStomp:GetSpecialValueInt('radius')
    local nDamage = EchoStomp:GetSpecialValueInt('stomp_damage')

    local nAllyHeroes = hUnit:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    local nEnemyHeroes = hUnit:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    for _, enemy in pairs(nEnemyHeroes) do
        if J.IsValidHero(enemy)
        and J.IsInRange(hUnit, enemy, nRadius)
        and J.CanCastOnNonMagicImmune(enemy)
        then
            if enemy:HasModifier('modifier_teleporting') then
                return BOT_ACTION_DESIRE_HIGH
            end

            if J.CanKillTarget(enemy, nDamage * 2, DAMAGE_TYPE_PHYSICAL)
            and not J.IsChasingTarget(bot, enemy)
            and not (#nAllyHeroes >= #nEnemyHeroes + 2)
            and not enemy:HasModifier('modifier_abaddon_borrowed_time')
            and not enemy:HasModifier('modifier_dazzle_shallow_grave')
            and not enemy:HasModifier('modifier_necrolyte_reapers_scythe')
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    end

    if J.IsGoingOnSomeone(bot) then
        local nNonMagicImmuneEnemyCount = 0
        for _, enemy in pairs(nEnemyHeroes) do
            if J.IsValidHero(enemy)
            and J.IsInRange(hUnit, enemy, nRadius)
            and J.CanCastOnNonMagicImmune(enemy)
            and not J.IsChasingTarget(bot, enemy)
            and not enemy:HasModifier('modifier_enigma_black_hole_pull')
            and not enemy:HasModifier('modifier_faceless_void_chronosphere_freeze')
            and not enemy:HasModifier('modifier_necrolyte_reapers_scythe')
            then
                nNonMagicImmuneEnemyCount = nNonMagicImmuneEnemyCount + 1
            end
        end

        if nNonMagicImmuneEnemyCount >= 2 then
            return BOT_ACTION_DESIRE_HIGH
        end

        if J.IsValidHero(botTarget)
        and J.IsInRange(hUnit, botTarget, nRadius)
        and J.CanCastOnNonMagicImmune(botTarget)
        and not J.IsChasingTarget(bot, botTarget)
        and not botTarget:HasModifier('modifier_enigma_black_hole_pull')
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(3.5) then
        for _, enemy in pairs(nEnemyHeroes) do
            if J.IsValidHero(enemy)
            and J.IsInRange(hUnit, enemy, nRadius)
            and J.CanCastOnNonMagicImmune(enemy)
            and J.IsChasingTarget(enemy, bot)
            and not J.IsDisabled(enemy)
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    end

    local nEnemyCreeps = hUnit:GetNearbyCreeps(nRadius, true)

    if J.IsDefending(bot) then
        local nLocationAoE = hUnit:FindAoELocation(true, false, hUnit:GetLocation(), 0, nRadius, fCastPoint + fChannelTime, 0)
        if #nEnemyCreeps >= 4 and nLocationAoE.count >= 4
        and J.CanBeAttacked(nEnemyCreeps[1])
        and not J.IsRunning(nEnemyCreeps[1])
        and J.IsAttacking(bot)
        and #nEnemyHeroes == 0
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsFarming(bot) and J.GetMP(bot) > 0.35 and bot:GetLevel() < 20 and not J.HasItem(bot, 'item_radiance') then
        if J.IsValid(nEnemyCreeps[1])
        and (#nEnemyCreeps >= 3 or #nEnemyCreeps >= 2 and nEnemyCreeps[1]:IsAncientCreep())
        and J.CanBeAttacked(nEnemyCreeps[1])
        and not J.IsRunning(nEnemyCreeps[1])
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderAstralSpirit()
    if not J.CanCastAbility(AstralSpirit) then
        return BOT_ACTION_DESIRE_NONE, 0, false
    end

    local nCastRange = J.GetProperCastRange(false, bot, AstralSpirit:GetCastRange())
    local nRadius = AstralSpirit:GetSpecialValueInt('radius')
    local nDamage = AstralSpirit:GetSpecialValueInt('pass_damage')

    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    if J.CanCastAbility(EchoStomp) and not X.HasShard() then
        local nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)

        local nDamage__ = EchoStomp:GetSpecialValueInt('stomp_damage')

        for _, enemy in pairs(nEnemyHeroes) do
            if J.IsValidHero(enemy)
            and J.IsInRange(bot, enemy, nCastRange)
            and not J.IsInRange(bot, enemy, 650)
            and J.CanCastOnNonMagicImmune(enemy)
            then
                if enemy:HasModifier('modifier_teleporting') then
                    return BOT_ACTION_DESIRE_HIGH, enemy:GetLocation(), true
                end

                if J.CanKillTarget(enemy, nDamage__ * 2, DAMAGE_TYPE_PHYSICAL)
                and not J.IsChasingTarget(bot, enemy)
                and not (#nAllyHeroes >= #nEnemyHeroes + 2)
                and not enemy:HasModifier('modifier_abaddon_borrowed_time')
                and not enemy:HasModifier('modifier_dazzle_shallow_grave')
                and not enemy:HasModifier('modifier_necrolyte_reapers_scythe')
                then
                    return BOT_ACTION_DESIRE_HIGH, enemy:GetLocation(), true
                end
            end
        end
    end

    for _, enemy in pairs(nEnemyHeroes) do
        if J.IsValidHero(enemy)
        and J.IsInRange(bot, enemy, nCastRange)
        and not J.IsInRange(bot, enemy, nCastRange / 2)
        and J.CanCastOnNonMagicImmune(enemy)
        and J.CanKillTarget(enemy, nDamage, DAMAGE_TYPE_MAGICAL)
        and not enemy:HasModifier('modifier_abaddon_borrowed_time')
        and not enemy:HasModifier('modifier_dazzle_shallow_grave')
        and not enemy:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemy:HasModifier('modifier_oracle_false_promise_timer')
        then
            return BOT_ACTION_DESIRE_HIGH, enemy:GetLocation(), false
        end
    end

    if J.IsGoingOnSomeone(bot) then
        if J.IsValidHero(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not J.IsSuspiciousIllusion(botTarget)
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation(), false
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0, false
end

local hTaggedEnemies = {}
local hTargetUnits = {}
local function merge_table(t1,t2)
    for _, v in ipairs(t2) do
        table.insert(t1, v)
    end
    return t1
end

function X.ConsiderMoveAstralSpirit()
    if not J.CanCastAbility(MoveAstralSpirit) then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
    local nEnemyCreeps = bot:GetNearbyCreeps(1200, true)

    hTargetUnits = merge_table(nEnemyHeroes, nEnemyCreeps)

    local nAllyHeroes_real = J.GetAlliesNearLoc(bot:GetLocation(), 1600)
    local nEnemyHeroes_real = J.GetEnemiesNearLoc(bot:GetLocation(), 1600)

    if (#hTargetUnits == 0 or #hTaggedEnemies >= #hTargetUnits * 0.8)
    or (J.IsRetreating(bot) and not J.IsRealInvisible(bot) and #nEnemyHeroes_real > #nAllyHeroes_real)
    or (bot:WasRecentlyDamagedByAnyHero(2.0) and J.GetHP(bot) < 0.42 and #nEnemyHeroes_real > 0)
    or J.IsInTeamFight(bot, 1200)
    then
        return BOT_ACTION_DESIRE_NONE
    end

    if #hTargetUnits > 0 then
        for i, unit in pairs(hTargetUnits) do
            if J.IsValid(unit) then
                if not X.IsTagged(hTaggedEnemies, unit) then
                    if not J.IsInRange(bot.astral_spirit, unit, 25) then
                        return BOT_ACTION_DESIRE_HIGH, unit:GetLocation()
                    else
                        table.insert(hTaggedEnemies, unit)
                    end
                else
                    table.remove(hTargetUnits, i)
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderReturnAstralSpirit()
    if not J.CanCastAbility(ReturnAstralSpirit) then
        return BOT_ACTION_DESIRE_NONE
    end

    local nAllyHeroes_real = J.GetAlliesNearLoc(bot:GetLocation(), 1600)
    local nEnemyHeroes_real = J.GetEnemiesNearLoc(bot:GetLocation(), 1600)

    if (#hTargetUnits == 0 or #hTaggedEnemies >= #hTargetUnits * 0.8)
    or (J.IsRetreating(bot) and not J.IsRealInvisible(bot) and #nEnemyHeroes_real > #nAllyHeroes_real)
    or (bot:WasRecentlyDamagedByAnyHero(2.0) and J.GetHP(bot) < 0.42 and #nEnemyHeroes_real > 0)
    or J.IsInTeamFight(bot, 1200)
    then
        return BOT_ACTION_DESIRE_HIGH
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderEarthSplitter()
    if not J.CanCastAbility(EarthSplitter) then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nCastRange = EarthSplitter:GetCastRange()
    local nCrackDistance = EarthSplitter:GetSpecialValueInt('crack_distance')
    local nRadius = EarthSplitter:GetSpecialValueInt('crack_width')
    local fEffectDelay = EarthSplitter:GetSpecialValueFloat('crack_time')
    local nSpeed = EarthSplitter:GetSpecialValueInt('speed')

    local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
    local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)

    if J.IsInTeamFight(bot, 1600) then
        local nCore = 0
        for _, enemy in pairs(nInRangeEnemy) do
            if J.IsValidHero(enemy) and J.IsCore(enemy) then
                nCore = nCore + 1
            end
        end

        if #nInRangeEnemy >= 2 and nCore >= 1 then
            return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
        end
    end

    local nAllyHeroes_real = J.GetAlliesNearLoc(nLocationAoE.targetloc, 1200)
    local nEnemyHeroes_real = J.GetEnemiesNearLoc(nLocationAoE.targetloc, 1200)

    local nSplitterCount = 0
    for _, enemy in pairs(nInRangeEnemy) do
        if J.IsValidHero(enemy)
        and J.CanCastOnNonMagicImmune(enemy)
        and (#nAllyHeroes_real >= #nEnemyHeroes_real or J.WeAreStronger(bot, 1300))
        then
            if enemy:HasModifier('modifier_faceless_void_chronosphere_freeze') and J.GetModifierTime(bot, 'modifier_faceless_void_chronosphere_freeze') > 1.8
            or enemy:HasModifier('modifier_enigma_black_hole_pull') and J.GetModifierTime(bot, 'modifier_enigma_black_hole_pull') > 1.8
            then
                nSplitterCount = nSplitterCount + 1
            end
        end
    end

    if nSplitterCount >= 2 then
        return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.IsTagged(table, value)
    for _, v in pairs(table) do
        if v ~= nil and v == value then return true end
    end
    return false
end

function X.IsAstralSpiritSummoned()
    return J.CanCastAbility(ReturnAstralSpirit)
end

function X.HasShard()
    if EchoStomp ~= nil and EchoStomp:IsTrained() then
        local nLevel = EchoStomp:GetLevel()
        local fCooldown = EchoStomp:GetCooldown()
        if nLevel == 1 and fCooldown <= 12
        or nLevel == 2 and fCooldown <= 11
        or nLevel == 3 and fCooldown <= 10
        or nLevel == 4 and fCooldown <= 9
        then
            return true
        end
    end

    return false
end

return X