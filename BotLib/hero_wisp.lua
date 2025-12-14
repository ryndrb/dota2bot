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
                "item_magic_stick",
                "item_faerie_fire",
            
                "item_tranquil_boots",
                "item_magic_wand",
                "item_glimmer_cape",--
                "item_ancient_janggo",
                "item_solar_crest",--
                "item_boots_of_bearing",--
                "item_aghanims_shard",
                "item_holy_locket",--
                "item_sheepstick",--
                "item_heart",--
                "item_ultimate_scepter_2",
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
                "item_magic_stick",
                "item_faerie_fire",
            
                "item_arcane_boots",
                "item_magic_wand",
                "item_glimmer_cape",--
                "item_mekansm",
                "item_solar_crest",--
                "item_guardian_greaves",--
                "item_aghanims_shard",
                "item_holy_locket",--
                "item_sheepstick",--
                "item_heart",--
                "item_ultimate_scepter_2",
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

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

local spirit_state = false

local SpiritsToggleTime = -1

function X.SkillsComplement()
    bot = GetBot()

    if  bot.wisp == nil then
        bot.wisp = {
            tether      = { target = nil },
            relocate    = { fountain = false, back = false }
        }
    end

    Tether        = bot:GetAbilityByName('wisp_tether')
    BreakTether   = bot:GetAbilityByName('wisp_tether_break')
    Spirits       = bot:GetAbilityByName('wisp_spirits')
    Spirits_in    = bot:GetAbilityByName('wisp_spirits_in')
    Spirits_out   = bot:GetAbilityByName('wisp_spirits_out')
    Overcharge    = bot:GetAbilityByName('wisp_overcharge')
    Relocate      = bot:GetAbilityByName('wisp_relocate')

    if J.CanNotUseAbility(bot) then return end

    bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    if not bot:HasModifier('modifier_wisp_tether') then
        bot.wisp.tether.target = nil
    else
        X.ConsiderItems()
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
            bot.wisp.tether.target = TetherTarget
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

    local botActiveMode = bot:GetActiveMode()
    if botActiveMode == BOT_MODE_RUNE
    or botActiveMode == BOT_MODE_WARD
    or bot.wisp.relocate.fountain == true
    or bot:HasModifier('modifier_fountain_aura_buff')
    or bot:DistanceFromFountain() < 700
    then
        return BOT_ACTION_DESIRE_NONE
    end

    local target = nil
    local targetScore = 0
    for _, ally in pairs(nAllyHeroes) do
        if J.IsValidHero(ally)
        and bot ~= ally
        and not ally:IsIllusion()
        and not J.IsStuck(ally)
        and not ally:IsInvulnerable()
        and J.IsInRange(bot, ally, nCastRange)
        and not ally:HasModifier('modifier_doom_bringer_doom_aura_enemy')
        and not ally:HasModifier('modifier_necrolyte_reapers_scythe')
        and not ally:HasModifier('modifier_skeleton_king_reincarnation_scepter_active')
        then
            if J.IsDisabled(ally) and #nAllyHeroes >= #nEnemyHeroes then
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
            local allyScore = ally:GetAttackDamage() * ally:GetAttackSpeed()
            -- if (J.IsLaning(ally) and bCore and bot:GetAssignedLane() == ally:GetAssignedLane())
            -- or (J.IsFarming(ally) and bCore)
            -- or J.IsGoingOnSomeone(ally)
            -- or J.IsPushing(ally)
            -- or J.IsDoingRoshan(ally)
            -- or J.IsDoingTormentor(ally)
            -- then
            --     if allyScore > targetScore then
            --         targetScore = allyScore
            --         target = ally
            --     end
            -- end

            if (J.IsLaning(ally) and bCore and bot:GetAssignedLane() == ally:GetAssignedLane())
            or (J.IsGoingOnSomeone(ally))
            or (J.IsPushing(ally))
            or (J.IsDoingRoshan(ally))
            or (J.IsDoingTormentor(ally) and bot.tormentor_state == true)
            then
                if allyScore > targetScore and bot:GetActiveMode() == ally:GetActiveMode() then
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
        local targetDir = (J.GetTeamFountain() - bot:GetLocation()):Normalized()
        for _, ally in pairs(GetUnitList(UNIT_LIST_ALLIES)) do
            if  J.IsValid(ally)
            and bot ~= ally
            and (ally:IsCreep() or ally:IsHero())
            and J.IsInRange(bot, ally, nCastRange)
            and not J.IsInRange(bot, ally, nCastRange / 2)
            and ally:DistanceFromFountain() < bot:DistanceFromFountain()
            then
                local allyDir = (ally:GetLocation() - bot:GetLocation()):Normalized()
                local dot = J.DotProduct(targetDir, allyDir)
                local nAngle = J.GetAngleFromDotProduct(dot)

                if nAngle <= 45 then
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

    local tetheredAlly = bot.wisp.tether.target

    if tetheredAlly ~= nil then
        if tetheredAlly:HasModifier('modifier_teleporting') then
            return BOT_ACTION_DESIRE_HIGH
        end

        if J.IsEarlyGame() and J.IsInTeamFight(bot, 1200) then
            if J.IsValidHero(tetheredAlly)
            and not J.IsCore(tetheredAlly)
            and not J.IsRetreating(tetheredAlly)
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    end


    local botActiveMode = bot:GetActiveMode()
    if botActiveMode == BOT_MODE_RUNE
    or botActiveMode == BOT_MODE_WARD
    or (bot.wisp.relocate.fountain == true and bot.wisp.relocate.back == false)
    then
        return BOT_ACTION_DESIRE_HIGH
    end

    return BOT_ACTION_DESIRE_NONE
end

local nCollisionRadius = 0
local nMinRange = 0
local nMaxRange = 0
local nSpeed = 0
function X.ConsiderSpirits()
    if not J.CanCastAbility(Spirits)
    or bot:HasModifier('modifier_smoke_of_deceit')
    then
        return BOT_ACTION_DESIRE_NONE
    end

    nCollisionRadius = Spirits:GetSpecialValueInt('hero_hit_radius')
    nMinRange = Spirits:GetSpecialValueInt('min_range')
    nMaxRange = Spirits:GetSpecialValueInt('max_range')
    nSpeed = Spirits:GetSpecialValueInt('spirit_movement_rate')

    local nManaCost = Spirits:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Overcharge, Relocate})

    if J.IsGoingOnSomeone(bot) and fManaAfter > fManaThreshold1 then
        if J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nMaxRange)
        and J.CanCastOnNonMagicImmune(botTarget)
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

    if #nEnemyHeroes > 0 then
        if J.IsValidHero(botTarget) then
            local distance = GetUnitToUnitDistance(bot, botTarget)
            if distance < nSpiritsRangeFromIO
            and nSpiritsRangeFromIO > nMinRange
            and math.abs(distance - nSpiritsRangeFromIO) > nCollisionRadius
            then
                if Spirits_in:GetToggleState() == false then
                    return BOT_ACTION_DESIRE_HIGH, 'in'
                end

                return BOT_ACTION_DESIRE_NONE, ''
            end

            if distance > nSpiritsRangeFromIO
            and nSpiritsRangeFromIO < nMaxRange
            and math.abs(distance - nSpiritsRangeFromIO) > nCollisionRadius
            then
                if Spirits_out:GetToggleState() == false then
                    return BOT_ACTION_DESIRE_HIGH, 'out'
                end

                return BOT_ACTION_DESIRE_NONE, ''
            end
        end
    end

    if J.IsValid(botTarget)
    and J.CanBeAttacked(botTarget)
    and botTarget:IsCreep()
    and not J.IsRunning(botTarget)
    then
        local distance = GetUnitToUnitDistance(bot, botTarget)

        if distance < nSpiritsRangeFromIO
        and nSpiritsRangeFromIO > nMinRange
        and math.abs(distance - nSpiritsRangeFromIO) > nCollisionRadius
        then
            if Spirits_in:GetToggleState() == false then
                return BOT_ACTION_DESIRE_HIGH, 'in'
            end

            return BOT_ACTION_DESIRE_NONE, ''
        end

        if distance > nSpiritsRangeFromIO
        and nSpiritsRangeFromIO < nMaxRange
        and math.abs(distance - nSpiritsRangeFromIO) > nCollisionRadius
        then
            if Spirits_out:GetToggleState() == false then
                return BOT_ACTION_DESIRE_HIGH, 'out'
            end

            return BOT_ACTION_DESIRE_NONE, ''
        end
    end

    if J.IsDoingRoshan(bot) or J.IsDoingTormentor(bot) then
        if (J.IsRoshan(botTarget) or J.IsTormentor(botTarget))
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nMaxRange)
        then
            local distance = GetUnitToUnitDistance(bot, botTarget)
            if distance < nSpiritsRangeFromIO
            and nSpiritsRangeFromIO > nMinRange
            and math.abs(distance - nSpiritsRangeFromIO) > nCollisionRadius
            then
                if Spirits_in:GetToggleState() == false then
                    return BOT_ACTION_DESIRE_HIGH, 'in'
                end

                return BOT_ACTION_DESIRE_NONE, ''
            end

            if distance > nSpiritsRangeFromIO
            and nSpiritsRangeFromIO < nMaxRange
            and math.abs(distance - nSpiritsRangeFromIO) > nCollisionRadius
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
    or bot.wisp.tether.target == nil
    then
        return BOT_ACTION_DESIRE_NONE
    end

    local tetheredAlly = bot.wisp.tether.target

    if tetheredAlly then
        if J.IsValidHero(tetheredAlly)
        and not tetheredAlly:HasModifier('modifier_necrolyte_reapers_scythe')
        and not tetheredAlly:HasModifier('modifier_skeleton_king_reincarnation_scepter_active')
        then
            local allyTarget = J.GetProperTarget(tetheredAlly)
            if J.IsGoingOnSomeone(tetheredAlly) then
                if J.IsValidHero(allyTarget)
                and J.CanBeAttacked(allyTarget)
                and J.IsInRange(tetheredAlly, allyTarget, tetheredAlly:GetAttackRange() + 300)
                and not J.IsSuspiciousIllusion(allyTarget)
                and not allyTarget:HasModifier('modifier_necrolyte_reapers_scythe')
                then
                    return BOT_ACTION_DESIRE_HIGH
                end
            end

            if J.IsRetreating(tetheredAlly) and J.GetHP(tetheredAlly) < 0.5 then
                return BOT_ACTION_DESIRE_HIGH
            end

            if J.IsDoingRoshan(bot) or J.IsDoingTormentor(bot) then
                if (J.IsRoshan(botTarget) or J.IsTormentor(botTarget))
                and J.CanBeAttacked(botTarget)
                and J.IsInRange(bot, botTarget, 800)
                and J.IsAttacking(tetheredAlly)
                then
                    return BOT_ACTION_DESIRE_HIGH
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderRelocate()
    if not J.CanCastAbility(Relocate) then
        bot.wisp.relocate.fountain = false
        bot.wisp.relocate.back = false
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local fEffectDelay = Relocate:GetSpecialValueFloat('cast_delay')

    if J.GetTotalEstimatedDamageToTarget(nEnemyHeroes, bot, fEffectDelay) > bot:GetHealth() + 150 then
        return BOT_ACTION_DESIRE_NONE
    end

	if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
    and not bot:HasModifier('modifier_wisp_tether')
    and botHP < 0.55
    then
        if bot:WasRecentlyDamagedByAnyHero(2.0) and #nEnemyHeroes > 0 then
            return BOT_ACTION_DESIRE_HIGH, J.GetTeamFountain()
        end
    end

    local tetheredAlly = bot.wisp.tether.target

    if tetheredAlly then
        if J.IsValidHero(tetheredAlly) and J.IsCore(tetheredAlly) then
            if J.IsInTeamFight(tetheredAlly, 1600) then
                if  J.IsRetreating(tetheredAlly)
                and J.GetHP(tetheredAlly) < 0.4
                and J.CanBeAttacked(tetheredAlly)
                and not tetheredAlly:HasModifier('modifier_item_satanic_unholy')
                and not tetheredAlly:HasModifier('modifier_abaddon_borrowed_time')
                and (J.GetTotalEstimatedDamageToTarget(nEnemyHeroes, tetheredAlly, fEffectDelay) + 100 < tetheredAlly:GetHealth())
                then
                    local nInRangeAlly = J.GetAlliesNearLoc(tetheredAlly:GetLocation(), 1200)
                    local nInRangeEnemy = J.GetEnemiesNearLoc(tetheredAlly:GetLocation(), 1200)
                    if tetheredAlly:WasRecentlyDamagedByAnyHero(2.0) and #nInRangeEnemy > 0 then
                        if #nInRangeAlly > #nInRangeEnemy then
                            bot.wisp.relocate.back = true
                        else
                            bot.wisp.relocate.back = false
                        end

                        bot.wisp.relocate.fountain = true
                        return BOT_ACTION_DESIRE_HIGH, J.GetTeamFountain()
                    end
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderTetherRelocate()
    if J.CanCastAbility(Tether) and J.CanCastAbility(Relocate) and not bot:HasModifier('modifier_wisp_tether') then
        local nCastRange = Tether:GetCastRange()
        local nManaCost = Tether:GetManaCost() + Relocate:GetManaCost() + 75

        if bot:GetMana() < nManaCost then
            return BOT_ACTION_DESIRE_NONE, nil, 0
        end

        if J.IsInTeamFight(bot, 1600) then
            for i = 1, 5 do
                local allyHero = GetTeamMember(i)
                if J.IsValidHero(allyHero)
                and bot ~= allyHero
                and J.IsRetreating(allyHero)
                and J.IsInRange(bot, allyHero, nCastRange)
                and J.GetHP(allyHero) < 0.4
                and not allyHero:HasModifier('modifier_item_satanic_unholy')
                and not allyHero:HasModifier('modifier_abaddon_borrowed_time')
                and J.CanBeAttacked(allyHero)
                and (J.GetTotalEstimatedDamageToTarget(nEnemyHeroes, allyHero, 4.0) + 100 < allyHero:GetHealth())
                then
                    local nInRangeAlly = J.GetAlliesNearLoc(allyHero:GetLocation(), 1200)
                    local nInRangeEnemy = J.GetEnemiesNearLoc(allyHero:GetLocation(), 1200)
                    if allyHero:WasRecentlyDamagedByAnyHero(2.0) and #nInRangeEnemy > 0 then
                        if #nInRangeAlly > #nInRangeEnemy then
                            bot.wisp.relocate.back = true
                        else
                            bot.wisp.relocate.back = false
                        end

                        bot.wisp.relocate.fountain = true
                        return BOT_ACTION_DESIRE_HIGH, J.GetTeamFountain()
                    end
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
    if not J.IsValidHero(bot.tethered_ally) then
        return BOT_ACTION_DESIRE_NONE, nil, nil, ''
    end

    local tetheredAlly = bot.wisp.tether.target

    if tetheredAlly and J.IsValidHero(tetheredAlly) then
        if  (J.IsGoingOnSomeone(tetheredAlly) or J.IsRetreating(tetheredAlly))
        and J.GetHP(tetheredAlly) < 0.5
        and tetheredAlly:DistanceFromFountain() > 2000
        and not tetheredAlly:HasModifier('modifier_doom_bringer_doom_aura_enemy')
        and not tetheredAlly:HasModifier('modifier_necrolyte_reapers_scythe')
        and not tetheredAlly:HasModifier('modifier_ice_blast')
        and not tetheredAlly:HasModifier('modifier_fountain_aura_buff')
        then
            local nCharges = 0

            local hItem = J.IsItemAvailable('item_holy_locket')
            if J.CanCastAbility(hItem) then
                nCharges = hItem:GetCurrentCharges()
                if nCharges >= 10 then
                    bot:ActionPush_UseAbility(hItem)
                    return
                end
            end

            hItem = J.IsItemAvailable('item_magic_wand')
            if J.CanCastAbility(hItem) then
                nCharges = hItem:GetCurrentCharges()
                if nCharges >= 10 then
                    bot:ActionPush_UseAbility(hItem)
                    return
                end
            end

            hItem = J.IsItemAvailable('item_magic_stick')
            if J.CanCastAbility(hItem) then
                nCharges = hItem:GetCurrentCharges()
                if nCharges >= 6 then
                    bot:ActionPush_UseAbility(hItem)
                    return
                end
            end
        end
    end
end

return X