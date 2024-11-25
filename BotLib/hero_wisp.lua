local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_wisp'
then

local RI = require(GetScriptDirectory()..'/FunLib/util_role_item')

local sUtility = {"item_heavens_halberd", "item_lotus_orb"}
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
                    ['t25'] = {10, 0},
                    ['t20'] = {0, 10},
                    ['t15'] = {0, 10},
                    ['t10'] = {10, 0},
                }
            },
            ['ability'] = {
                [1] = {1,3,3,1,3,6,3,1,1,2,6,2,2,2,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_blood_grenade",
                "item_circlet",
            
                "item_magic_wand",
                "item_bracer",
                "item_boots",
                "item_ancient_janggo",
                "item_holy_locket",--
                "item_glimmer_cape",--
                "item_boots_of_bearing",--
                "item_heart",--
                sUtilityItem,--
                "item_greater_crit",--
                "item_aghanims_shard",
                "item_ultimate_scepter_2",
                "item_moon_shard",
            },
            ['sell_list'] = {
                "item_bracer", "item_heart",
            },
        },
    },
    ['pos_5'] = {
        [1] = {
            ['talent'] = {
                [1] = {
                    ['t25'] = {10, 0},
                    ['t20'] = {0, 10},
                    ['t15'] = {0, 10},
                    ['t10'] = {10, 0},
                }
            },
            ['ability'] = {
                [1] = {1,3,3,1,3,6,3,1,1,2,6,2,2,2,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_double_branches",
                "item_blood_grenade",
                "item_circlet",
            
                "item_magic_wand",
                "item_bracer",
                "item_boots",
                "item_mekansm",
                "item_holy_locket",--
                "item_glimmer_cape",--
                "item_guardian_greaves",--
                "item_heart",--
                sUtilityItem,--
                "item_greater_crit",--
                "item_aghanims_shard",
                "item_ultimate_scepter_2",
                "item_moon_shard",
            },
            ['sell_list'] = {
                "item_bracer", "item_heart",
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

local Tether        = bot:GetAbilityByName('wisp_tether')
local BreakTether   = bot:GetAbilityByName('wisp_tether_break')
local Spirits       = bot:GetAbilityByName('wisp_spirits')
local Spirits_in    = bot:GetAbilityByName('wisp_spirits_in')
local Spirits_out   = bot:GetAbilityByName('wisp_spirits_out')
local Overcharge    = bot:GetAbilityByName('wisp_overcharge')
local Relocate      = bot:GetAbilityByName('wisp_relocate')

local TetherDesire, TetherTarget
local BreakTetherDesire
local SpiritsDesire
local Spirits_IODesire, IO
local OverchargeDesire
local RelocateDesire, RelocateLocation

local TetherRelocateDesire, TetherRelocateTarget, TetherRelocateLocation

local botTarget
local tAllyHeroes_real
local tEnemyHeroes_real

local spirit_state = false

local SpiritsToggleTime = -1

function X.SkillsComplement()
    Tether        = bot:GetAbilityByName('wisp_tether')
    BreakTether   = bot:GetAbilityByName('wisp_tether_break')
    Spirits       = bot:GetAbilityByName('wisp_spirits')
    Spirits_in    = bot:GetAbilityByName('wisp_spirits_in')
    Spirits_out   = bot:GetAbilityByName('wisp_spirits_out')
    Overcharge    = bot:GetAbilityByName('wisp_overcharge')
    Relocate      = bot:GetAbilityByName('wisp_relocate')

    if J.CanNotUseAbility(bot) then return end

    botTarget = J.GetProperTarget(bot)
    tAllyHeroes_real = J.GetAlliesNearLoc(bot:GetLocation(), 1600)
    tEnemyHeroes_real = J.GetEnemiesNearLoc(bot:GetLocation(), 1600)

    if not bot:HasModifier('modifier_wisp_tether') then
        bot.tethered_ally = nil
    else
        ItemDesire, Item, ItemTarget, CastType = X.ConsiderItems()
        if ItemDesire > 0 then
            if CastType == 'none' then
                bot:Action_UseAbility(Item)
                return
            end
        end
    end

    TetherRelocateDesire, TetherRelocateTarget, TetherRelocateLocation = X.ConsiderTetherRelocate()
    if TetherRelocateDesire > 0 then
        bot:Action_ClearActions(false)
        bot:ActionQueue_UseAbilityOnEntity(Tether, TetherRelocateTarget)
        bot:ActionQueue_Delay(0.1)
        bot:ActionQueue_UseAbilityOnLocation(Relocate, TetherRelocateLocation)
        return
    end

    TetherDesire, TetherTarget = X.ConsiderTether()
    if TetherDesire > 0 then
        if J.IsValidHero(TetherTarget) then
            bot.tethered_ally = TetherTarget
        end
        bot:Action_UseAbilityOnEntity(Tether, TetherTarget)
        return
    end

    BreakTetherDesire = X.ConsiderBreakTether()
    if BreakTetherDesire > 0 then
        bot:Action_UseAbility(BreakTether)
        return
    end

    OverchargeDesire = X.ConsiderOvercharge()
    if OverchargeDesire > 0 then
        bot:Action_UseAbility(Overcharge)
        return
    end

    RelocateDesire, RelocateLocation = X.ConsiderRelocate()
    if RelocateDesire > 0 then
        bot:Action_UseAbilityOnLocation(Relocate, RelocateLocation)
        return
    end

    SpiritsDesire = X.ConsiderSpirits()
    if SpiritsDesire > 0 then
        bot:Action_UseAbility(Spirits)
        return
    end

    Spirits_IODesire, IO = X.ConsiderSpirits_IO()
    if Spirits_IODesire > 0 then
        if IO == 'in' then
            bot:Action_UseAbility(Spirits_in)
            if Spirits_in:GetToggleState() == true then
                spirit_state = false
                SpiritsToggleTime = DotaTime()
            end
            return
        elseif IO == 'out' then
            bot:Action_UseAbility(Spirits_out)
            if Spirits_out:GetToggleState() == true then
                spirit_state = true
                SpiritsToggleTime = DotaTime()
            end
            return
        end
    end
end

function X.ConsiderTether()
    if not J.CanCastAbility(Tether) then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    local nCastRange = J.GetProperCastRange(false, bot, Tether:GetCastRange())

    local botMode = bot:GetActiveMode()
    if botMode == BOT_MODE_RUNE
    or botMode == BOT_MODE_WARD
    or bot.relocate_fountain == true
    or bot:HasModifier('modifier_fountain_aura_buff')
    or bot:DistanceFromFountain() < 700
    then
        return BOT_ACTION_DESIRE_NONE
    end

    local target = nil
    local targetScore = 0
    for _, ally in pairs(tAllyHeroes_real) do
        if J.IsValidHero(ally)
        and bot ~= ally
        and not ally:IsIllusion()
        and not J.IsStuck(ally)
        and not ally:IsInvulnerable()
        and J.IsInRange(bot, ally, nCastRange)
        and not ally:HasModifier('modifier_doom_bringer_doom')
        and not ally:HasModifier('modifier_necrolyte_reapers_scythe')
        and not ally:HasModifier('modifier_skeleton_king_reincarnation_scepter_active')
        then
            if (ally:HasModifier('modifier_faceless_void_chronosphere_freeze')
                or ally:HasModifier('modifier_enigma_black_hole_pull')
                or ally:HasModifier('modifier_legion_commander_duel')
            )
            and #tAllyHeroes_real >= #tEnemyHeroes_real then
                return BOT_ACTION_DESIRE_HIGH, ally
            end

            if J.IsRetreating(ally)
            and ally:WasRecentlyDamagedByAnyHero(3.0)
            and J.GetHP(ally) < 0.5
            and ally:DistanceFromFountain() > 800
            and not J.IsRealInvisible(ally)
            then
                return BOT_ACTION_DESIRE_HIGH, ally
            end

            local bCore = J.IsCore(ally)
            local allyPos = J.GetPosition(ally)
            local allyScore = ally:GetAttackDamage() * ally:GetAttackSpeed()
            if J.IsLaning(ally) and bCore
            or J.IsGoingOnSomeone(ally)
            or J.IsPushing(ally)
            or J.IsDoingRoshan(ally)
            or J.IsDoingTormentor(ally)
            or J.IsFarming(ally) and bCore
            then
                if     allyPos == 1 then allyScore = allyScore * 5
                elseif allyPos == 2 then allyScore = allyScore * 2.5
                elseif allyPos == 3 then allyScore = allyScore * 1
                elseif allyPos >= 4 then allyScore = allyScore * 0.3
                end

                if allyScore > targetScore then
                    targetScore = allyScore
                    target = ally
                end
            end
        end
    end

    if target ~= nil then
        return BOT_ACTION_DESIRE_HIGH, target
    end

    if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
    and bot:WasRecentlyDamagedByAnyHero(2.0)
	then
        local vBotToFountain = (J.GetTeamFountain() - bot:GetLocation()):Normalized()
        local fNormVal = math.cos(45)

        for _, ally in pairs(GetUnitList(UNIT_LIST_ALLIES)) do
            if J.IsValid(ally)
            and bot ~= ally
            and J.IsInRange(bot, ally, nCastRange)
            and not J.IsInRange(bot, ally, 750)
            and ally:DistanceFromFountain() < bot:DistanceFromFountain()
            then
                local vAllyToFountain = (J.GetTeamFountain() - ally:GetLocation()):Normalized()
                if J.DotProduct(vBotToFountain, vAllyToFountain) >= fNormVal then
                    return BOT_ACTION_DESIRE_HIGH, ally
                end
            end
        end
	end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderBreakTether()
    if not J.CanCastAbility(BreakTether) then
        return BOT_ACTION_DESIRE_NONE
    end

    if bot.tethered_ally ~= nil and bot.tethered_ally:HasModifier('modifier_teleporting') then
        return BOT_ACTION_DESIRE_HIGH
    end

    if J.IsInLaningPhase() and J.IsInTeamFight(bot, 1200) then
        if J.IsValidHero(bot.tethered_ally)
        and not J.IsCore(bot.tethered_ally)
        and not J.IsRetreating(bot.tethered_ally)
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    local botMode = bot:GetActiveMode()
    if botMode == BOT_MODE_RUNE
    or botMode == BOT_MODE_WARD
    or (bot.relocate_fountain == true and bot.relocate_back == false)
    then
        return BOT_ACTION_DESIRE_HIGH
    end

    return BOT_ACTION_DESIRE_NONE
end

local CONST_COLLISION_RADIUS = 110
local nMinRange = 0
local nMaxRange = 0
local nSpeed = 0
function X.ConsiderSpirits()
    if not J.CanCastAbility(Spirits)
    or bot:HasModifier('modifier_smoke_of_deceit')
    then
        return BOT_ACTION_DESIRE_NONE
    end

    nMinRange = Spirits:GetSpecialValueInt('min_range')
    nMaxRange = Spirits:GetSpecialValueInt('max_range')
    nSpeed = Spirits:GetSpecialValueInt('spirit_movement_rate')

    if J.IsGoingOnSomeone(bot) and #tAllyHeroes_real >= #tEnemyHeroes_real then
        if J.IsValidHero(botTarget)
        and J.IsInRange(bot, botTarget, nMaxRange)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.CanBeAttacked(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderSpirits_IO()
    if J.IsRealInvisible(bot)
    or not J.CanCastAbility(Spirits_in)
    or not J.CanCastAbility(Spirits_out)
    then
        return BOT_ACTION_DESIRE_NONE, ''
    end

    local nSpiritsRangeFromIO = X.GetCurrentSpiritRangeFromIO(DotaTime() - SpiritsToggleTime, spirit_state, nMinRange, nMaxRange, nSpeed)

    if #tEnemyHeroes_real > 0 then
        if J.IsValidHero(botTarget) then
            if GetUnitToUnitDistance(bot, botTarget) < nSpiritsRangeFromIO
            and nSpiritsRangeFromIO > nMinRange
            and math.abs(GetUnitToUnitDistance(bot, botTarget) - nSpiritsRangeFromIO) > CONST_COLLISION_RADIUS
            then
                if Spirits_in:GetToggleState() == false then
                    return BOT_ACTION_DESIRE_HIGH, 'in'
                end

                return BOT_ACTION_DESIRE_NONE, ''
            end

            if GetUnitToUnitDistance(bot, botTarget) > nSpiritsRangeFromIO
            and nSpiritsRangeFromIO < nMaxRange
            and math.abs(GetUnitToUnitDistance(bot, botTarget) - nSpiritsRangeFromIO) > CONST_COLLISION_RADIUS
            then
                if Spirits_out:GetToggleState() == false then
                    return BOT_ACTION_DESIRE_HIGH, 'out'
                end

                return BOT_ACTION_DESIRE_NONE, ''
            end
        end
    end

    if J.IsValid(botTarget)
    and botTarget:IsCreep()
    and J.CanBeAttacked(botTarget)
    and not J.IsRunning(botTarget)
    then
        if GetUnitToUnitDistance(bot, botTarget) < nSpiritsRangeFromIO
        and nSpiritsRangeFromIO > nMinRange
        and math.abs(GetUnitToUnitDistance(bot, botTarget) - nSpiritsRangeFromIO) > CONST_COLLISION_RADIUS
        then
            if Spirits_in:GetToggleState() == false then
                return BOT_ACTION_DESIRE_HIGH, 'in'
            end

            return BOT_ACTION_DESIRE_NONE, ''
        end

        if GetUnitToUnitDistance(bot, botTarget) > nSpiritsRangeFromIO
        and nSpiritsRangeFromIO < nMaxRange
        and math.abs(GetUnitToUnitDistance(bot, botTarget) - nSpiritsRangeFromIO) > CONST_COLLISION_RADIUS
        then
            if Spirits_out:GetToggleState() == false then
                return BOT_ACTION_DESIRE_HIGH, 'out'
            end

            return BOT_ACTION_DESIRE_NONE, ''
        end
    end

    if J.IsDoingRoshan(bot) or J.IsDoingTormentor(bot) then
        if (J.IsRoshan(botTarget) or J.IsTormentor(botTarget))
        and J.IsInRange(bot, botTarget, nMaxRange)
        and J.GetHP(botTarget) > 0.5
        and J.IsAttacking(bot)
        then
            if GetUnitToUnitDistance(bot, botTarget) < nSpiritsRangeFromIO
            and nSpiritsRangeFromIO > nMinRange
            and math.abs(GetUnitToUnitDistance(bot, botTarget) - nSpiritsRangeFromIO) > CONST_COLLISION_RADIUS
            then
                if Spirits_in:GetToggleState() == false then
                    return BOT_ACTION_DESIRE_HIGH, 'in'
                end

                return BOT_ACTION_DESIRE_NONE, ''
            end

            if GetUnitToUnitDistance(bot, botTarget) > nSpiritsRangeFromIO
            and nSpiritsRangeFromIO < nMaxRange
            and math.abs(GetUnitToUnitDistance(bot, botTarget) - nSpiritsRangeFromIO) > CONST_COLLISION_RADIUS
            then
                if Spirits_out:GetToggleState() == false then
                    return BOT_ACTION_DESIRE_HIGH, 'out'
                end

                return BOT_ACTION_DESIRE_NONE, ''
            end
        end
    end

    if Spirits_in:GetToggleState() == true then
        return BOT_ACTION_DESIRE_HIGH, 'in'
    end

    if Spirits_out:GetToggleState() == true then
        return BOT_ACTION_DESIRE_HIGH, 'out'
    end

    return BOT_ACTION_DESIRE_NONE, ''
end

function X.ConsiderOvercharge()
    if not J.CanCastAbility(Overcharge)
    or not bot:HasModifier('modifier_wisp_tether')
    or bot.tethered_ally == nil
    then
        return BOT_ACTION_DESIRE_NONE
    end

    if J.IsValidHero(bot.tethered_ally)
    and not bot.tethered_ally:HasModifier('modifier_necrolyte_reapers_scythe')
    and not bot.tethered_ally:HasModifier('modifier_skeleton_king_reincarnation_scepter_active')
    then
        local allyTarget = J.GetProperTarget(bot.tethered_ally)
        if J.IsGoingOnSomeone(bot.tethered_ally) then
            if J.IsValidHero(allyTarget)
            and J.CanBeAttacked(allyTarget)
            and J.IsInRange(bot.tethered_ally, allyTarget, bot.tethered_ally:GetAttackRange() + 300)
            and not J.IsSuspiciousIllusion(allyTarget)
            and not allyTarget:HasModifier('modifier_necrolyte_reapers_scythe')
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end

        if J.IsRetreating(bot.tethered_ally) and J.GetHP(bot.tethered_ally) < 0.5 then
            return BOT_ACTION_DESIRE_HIGH
        end

        if J.IsDoingRoshan(bot) or J.IsDoingTormentor(bot) then
            if (J.IsRoshan(botTarget) or J.IsTormentor(botTarget))
            and J.IsInRange(bot, botTarget, 800)
            and J.GetHP(botTarget) > 0.5
            and J.IsAttacking(bot.tethered_ally)
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderRelocate()
    if not J.CanCastAbility(Relocate) then
        bot.relocate_fountain = false
        bot.relocate_back = false
        return BOT_ACTION_DESIRE_NONE, 0
    end

	if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
    and bot.tethered_ally == nil
    and J.GetHP(bot) < 0.4
    then
        if J.IsValidHero(tEnemyHeroes_real[1])
        and J.IsInRange(bot, tEnemyHeroes_real[1], 1200)
        and bot:WasRecentlyDamagedByAnyHero(3.0)
        and #tEnemyHeroes_real >= #tAllyHeroes_real
        then
            return BOT_ACTION_DESIRE_HIGH, J.GetTeamFountain()
        end
    end

    if J.IsValidHero(bot.tethered_ally) and J.IsCore(bot.tethered_ally) then
        if J.IsInTeamFight(bot, 1600) then
            if J.GetHP(bot.tethered_ally) < 0.4
            and not bot.tethered_ally:HasModifier('modifier_item_satanic_unholy')
            and not bot.tethered_ally:HasModifier('modifier_abaddon_borrowed_time')
            and J.CanBeAttacked(bot.tethered_ally)
            then
                if J.WeAreStronger(bot, 1600) and #tAllyHeroes_real > #tEnemyHeroes_real then
                    bot.relocate_back = true
                else
                    bot.relocate_back = false
                end

                bot.relocate_fountain = true
                return BOT_ACTION_DESIRE_HIGH, J.GetTeamFountain()
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderTetherRelocate()
    if J.CanCastAbility(Tether) and J.CanCastAbility(Relocate) then
        local nCastRange = J.GetProperCastRange(false, bot, Tether:GetCastRange())
        local nManaCost = Tether:GetManaCost() + Relocate:GetManaCost()

        if bot:GetMana() < nManaCost then
            return BOT_ACTION_DESIRE_NONE, nil, 0
        end

        if J.IsInTeamFight(bot, 1600) then
            for i = 1, 5 do
                local ally = GetTeamMember(i)
                if J.IsValidHero(ally)
                and bot ~= ally
                and J.IsInRange(bot, ally, nCastRange)
                and J.GetHP(ally) < 0.4
                and not bot.tethered_ally:HasModifier('modifier_item_satanic_unholy')
                and not bot.tethered_ally:HasModifier('modifier_abaddon_borrowed_time')
                and J.CanBeAttacked(bot.tethered_ally)
                then
                    if J.WeAreStronger(bot, 1600) and #tAllyHeroes_real > #tEnemyHeroes_real then
                        bot.relocate_back = true
                    else
                        bot.relocate_back = false
                    end

                    bot.relocate_fountain = true
                    return BOT_ACTION_DESIRE_HIGH, ally, J.GetTeamFountain()
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil, 0
end

function X.GetCurrentSpiritRangeFromIO(fTimeElapsed, bOutward, nMin, nMax, nSpeed_)
    if bOutward then
        local dist = nMin + (fTimeElapsed * nSpeed_)
        return math.min(dist, nMax)
    else
        local dist = nMax - (fTimeElapsed * nSpeed_)
        return math.max(dist, nMin)
    end
end

function X.ConsiderItems()
    local nCharges = 0
    local item = nil

    if not J.IsValidHero(bot.tethered_ally) then
        return BOT_ACTION_DESIRE_NONE, nil, nil, ''
    end

    if J.GetHP(bot.tethered_ally) < 0.5
    and bot.tethered_ally:DistanceFromFountain() > 2000
    and not bot.tethered_ally:HasModifier('modifier_necrolyte_reapers_scythe')
    and not bot.tethered_ally:HasModifier('modifier_fountain_aura_buff')
    then
        item = J.GetItem('item_holy_locket')
        if item ~= nil and item:IsFullyCastable() then
            nCharges = item:GetCurrentCharges()
            if nCharges >= 10 then
                return BOT_ACTION_DESIRE_HIGH, item, nil, 'none'
            end
        end

        item = J.GetItem('item_magic_wand')
        if item ~= nil and item:IsFullyCastable() then
            nCharges = item:GetCurrentCharges()
            if nCharges >= 10 then
                return BOT_ACTION_DESIRE_HIGH, item, nil, 'none'
            end
        end

        item = J.GetItem('item_magic_stick')
        if item ~= nil and item:IsFullyCastable() then
            nCharges = item:GetCurrentCharges()
            if nCharges >= 6 then
                return BOT_ACTION_DESIRE_HIGH, item, nil, 'none'
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, nil, ''
end

return X