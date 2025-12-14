local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_earthshaker'
then

local RI = require(GetScriptDirectory()..'/FunLib/util_role_item')

local sUtility = {"item_heavens_halberd", "item_pipe", "item_lotus_orb"}
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
                    ['t15'] = {10, 0},
                    ['t10'] = {0, 10},
                }
            },
            ['ability'] = {
                [1] = {2,3,2,3,2,6,2,1,3,3,6,1,1,1,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_quelling_blade",
                "item_double_branches",
                "item_circlet",
                "item_mantle",
            
                "item_bottle",
                "item_magic_wand",
                "item_null_talisman",
                "item_power_treads",
                "item_blink",
                "item_kaya",
                "item_ultimate_scepter",
                "item_aghanims_shard",
                "item_black_king_bar",--
                "item_yasha_and_kaya",--
                "item_octarine_core",--
                "item_wind_waker",--
                "item_ultimate_scepter_2",
                "item_moon_shard",
                "item_arcane_blink",--
                "item_travel_boots_2",--
            },
            ['sell_list'] = {
                "item_quelling_blade", "item_kaya",
                "item_magic_wand", "item_ultimate_scepter",
                "item_null_talisman", "item_black_king_bar",
                "item_bottle", "item_octarine_core",
            },
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
                [1] = {1,2,3,3,3,6,3,1,1,1,6,2,2,2,6},
            },
            ['buy_list'] = {
                "item_tango",
                "item_quelling_blade",
                "item_double_branches",
            
                "item_double_bracer",
                "item_magic_wand",
                "item_arcane_boots",
                "item_blink",
                "item_crimson_guard",--
                "item_ultimate_scepter",
                "item_aghanims_shard",
                sUtilityItem,--
                "item_black_king_bar",--
                "item_overwhelming_blink",--`
                "item_octarine_core",--
                "item_ultimate_scepter_2",
                "item_moon_shard",
                "item_travel_boots_2",--
            },
            ['sell_list'] = {
                "item_quelling_blade", "item_crimson_guard",
                "item_magic_wand", "item_ultimate_scepter",
                "item_bracer", sUtilityItem,
                "item_bracer", "item_black_king_bar",
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
                [1] = {1,2,3,3,3,6,3,1,1,1,6,2,2,2,6},
            },
            ['buy_list'] = {
                "item_double_tango",
                "item_double_branches",
                "item_blood_grenade",
                "item_magic_stick",
            
                "item_tranquil_boots",
                "item_magic_wand",
                "item_blink",
                "item_ancient_janggo",
                "item_force_staff",--
                "item_octarine_core",--
                "item_boots_of_bearing",--
                "item_aghanims_shard",
                "item_ultimate_scepter",
                "item_wind_waker",--
                "item_arcane_blink",--
                "item_ultimate_scepter_2",
                "item_black_king_bar",--
                "item_moon_shard",
            },
            ['sell_list'] = {
                "item_magic_wand", "item_wind_waker",
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
                [1] = {1,2,3,3,3,6,3,1,1,1,6,2,2,2,6},
            },
            ['buy_list'] = {
                "item_double_tango",
                "item_double_branches",
                "item_blood_grenade",
                "item_magic_stick",
            
                "item_arcane_boots",
                "item_magic_wand",
                "item_blink",
                "item_mekansm",
                "item_force_staff",--
                "item_octarine_core",--
                "item_guardian_greaves",--
                "item_aghanims_shard",
                "item_ultimate_scepter",
                "item_wind_waker",--
                "item_arcane_blink",--
                "item_ultimate_scepter_2",
                "item_black_king_bar",--
                "item_moon_shard",
            },
            ['sell_list'] = {
                "item_magic_wand", "item_wind_waker",
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

local Fissure       = bot:GetAbilityByName('earthshaker_fissure')
local EnchantTotem  = bot:GetAbilityByName('earthshaker_enchant_totem')
local Aftershock    = bot:GetAbilityByName('earthshaker_aftershock')
local EchoSlam      = bot:GetAbilityByName('earthshaker_echo_slam')

local FissureDesire, FissureLocation
local EnchantTotemDesire, EnchantTotemLocation, WantToJump
local EchoSlamDesire

local BlinkSlamDesire, BlinkSlamLocation
local TotemSlamDesire, TotemSlamLocation

local bAttacking = false
local botTarget, botHP, botLocation
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
    bot = GetBot()

	if J.CanNotUseAbility(bot) then return end

    Fissure       = bot:GetAbilityByName('earthshaker_fissure')
    EnchantTotem  = bot:GetAbilityByName('earthshaker_enchant_totem')
    Aftershock    = bot:GetAbilityByName('earthshaker_aftershock')
    EchoSlam      = bot:GetAbilityByName('earthshaker_echo_slam')

    bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botLocation = bot:GetLocation()
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    local vTeamFightLocation = J.GetTeamFightLocation(bot)

    BlinkSlamDesire, BlinkSlamLocation = X.ConsiderBlinkSlam()
    if BlinkSlamDesire > 0 then
        J.SetQueuePtToINT(bot, false)

        if vTeamFightLocation and J.GetDistance(vTeamFightLocation, BlinkSlamLocation) <= 1200 then
            local BlackKingBar = J.IsItemAvailable('item_black_king_bar')
            if J.CanCastAbility(BlackKingBar) and (bot:GetMana() > (EchoSlam:GetManaCost() + BlackKingBar:GetManaCost() + 100)) and not bot:IsMagicImmune() then
                bot:ActionQueue_UseAbility(BlackKingBar)
                bot:ActionQueue_Delay(0.1)
            end
        end

        bot:ActionQueue_UseAbilityOnLocation(bot.Blink, BlinkSlamLocation)
        bot:ActionQueue_Delay(0.1)
        bot:ActionQueue_UseAbility(EchoSlam)
        return
    end

    TotemSlamDesire, TotemSlamLocation = X.ConsiderTotemSlam()
    if TotemSlamDesire > 0 then
        local nLeapDuration = EnchantTotem:GetSpecialValueFloat('scepter_leap_duration')
        J.SetQueuePtToINT(bot, false)

        if vTeamFightLocation and J.GetDistance(vTeamFightLocation, TotemSlamLocation) <= 1200 then
            local BlackKingBar = J.IsItemAvailable('item_black_king_bar')
            if J.CanCastAbility(BlackKingBar) and (bot:GetMana() > (EnchantTotem:GetManaCost() + EchoSlam:GetManaCost() + BlackKingBar:GetManaCost() + 100)) and not bot:IsMagicImmune() then
                bot:ActionQueue_UseAbility(BlackKingBar)
                bot:ActionQueue_Delay(0.1)
            end
        end

        bot:ActionQueue_UseAbilityOnLocation(EnchantTotem, TotemSlamLocation)
        bot:ActionQueue_UseAbility(EchoSlam)
        return
    end

    EchoSlamDesire = X.ConsiderEchoSlam()
    if EchoSlamDesire > 0 then
        bot:ActionPush_UseAbility(EchoSlam)
        return
    end

    EnchantTotemDesire, EnchantTotemLocation, WantToJump = X.ConsiderEnchantTotem()
    if EnchantTotemDesire > 0 then
        J.SetQueuePtToINT(bot, true)
        if bot:HasScepter() then
            if WantToJump then
                bot:ActionQueue_UseAbilityOnLocation(EnchantTotem, EnchantTotemLocation)
            else
                bot:ActionQueue_UseAbilityOnEntity(EnchantTotem, bot)
            end
        else
            bot:ActionQueue_UseAbility(EnchantTotem)
        end
    end

    FissureDesire, FissureLocation = X.ConsiderFissure()
    if FissureDesire > 0 then
        J.SetQueuePtToINT(bot, true)
        bot:ActionQueue_UseAbilityOnLocation(Fissure, FissureLocation)
        return
    end
end

function X.ConsiderFissure()
    if not J.CanCastAbility(Fissure) then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nCastRange = J.GetProperCastRange(false, bot, Fissure:GetCastRange())
	local fCastPoint = Fissure:GetCastPoint()
	local nRadius = Fissure:GetSpecialValueInt('fissure_radius')
    local nDamage = Fissure:GetSpecialValueInt('fissure_damage')
    local nAbilityLevel = Fissure:GetLevel()
    local nManaCost = Fissure:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Fissure, EchoSlam})
    local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {EchoSlam})

    for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        and J.CanCastOnNonMagicImmune(enemyHero)
        then
            if enemyHero:HasModifier('modifier_teleporting') then
                if J.GetModifierTime(enemyHero, 'modifier_teleporting') > fCastPoint then
                    return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
                end
            elseif enemyHero:IsChanneling() and fManaAfter > fManaThreshold1 then
                return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
            end

            if  J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL, fCastPoint)
            and J.CanBeAttacked(enemyHero)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
            and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
            then
                return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(enemyHero, fCastPoint)
            end
        end
    end

    if fManaAfter > fManaThreshold2 then
        for _, allyHero in pairs(nAllyHeroes) do
            if  bot ~= allyHero
            and J.IsValidHero(allyHero)
            and J.IsRetreating(allyHero)
            and allyHero:WasRecentlyDamagedByAnyHero(3)
            and not J.IsSuspiciousIllusion(allyHero)
            then
                for _, enemyHero in ipairs(nEnemyHeroes) do
                    if J.IsValidHero(enemyHero)
                    and J.CanCastOnNonMagicImmune(enemyHero)
                    and J.IsInRange(bot, enemyHero, nCastRange)
                    and J.IsChasingTarget(enemyHero, allyHero)
                    and not J.IsDisabled(enemyHero)
                    and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
                    then
                        return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(enemyHero, fCastPoint + 0.1)
                    end
                end
            end
        end
    end

	if J.IsInTeamFight(bot, 1200) then
        local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, fCastPoint, 0)
        local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)
        if #nInRangeEnemy >= 2 then
            local count = 0
            for _, enemyHero in pairs(nEnemyHeroes) do
                if  J.IsValidHero(enemyHero)
                and J.CanBeAttacked(enemyHero)
                and J.IsInRange(bot, enemyHero, nCastRange)
                and J.CanCastOnNonMagicImmune(enemyHero)
                and not J.IsDisabled(enemyHero)
                and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
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
		if  J.IsValidTarget(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
            return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(botTarget, fCastPoint)
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(3.0) then
        for _, enemyHero in ipairs(nEnemyHeroes) do
            if J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and not J.IsDisabled(enemyHero)
            then
                if J.IsChasingTarget(enemyHero, bot)
                or (#nEnemyHeroes > #nAllyHeroes and enemyHero:GetAttackTarget() == bot)
                or (botHP < 0.5 and enemyHero:GetAttackTarget() == bot)
                then
                    return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
                end
            end
        end
    end

    local nEnemyCreeps = bot:GetNearbyCreeps(1600, true)

    if J.IsPushing(bot) and #nAllyHeroes <= 2 and nAbilityLevel >= 3 and bAttacking and fManaAfter > 0.55 and fManaAfter > fManaThreshold1 and #nEnemyHeroes <= 1 then
		for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 4) then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end

        if J.IsValid(nEnemyCreeps[1]) then
            local vLocation = J.VectorAway(nEnemyCreeps[1]:GetLocation(), botLocation, nCastRange - GetUnitToUnitDistance(bot, nEnemyCreeps[1]))
            local count = 0
            for _, creep in ipairs(nEnemyCreeps) do
                if J.IsValid(creep)
                and J.CanBeAttacked(creep)
                and J.IsInRange(bot, creep, 800)
                and not J.IsRunning(creep)
                then
                    local tResult = PointToLineDistance(botLocation, vLocation, creep:GetLocation())
                    if tResult ~= nil and tResult.within and tResult.distance <= nRadius then
                        count = count + 1
                    end
                end
            end

            if count >= 4 then
                return BOT_ACTION_DESIRE_HIGH, vLocation
            end
        end
    end

    if J.IsDefending(bot) and fManaAfter > 0.5 and nAbilityLevel >= 2 and bAttacking then
		for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) and #nEnemyHeroes == 0 then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 4) then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end

        if J.IsValid(nEnemyCreeps[1]) then
            local count = 0
            local vLocation = J.VectorAway(nEnemyCreeps[1]:GetLocation(), botLocation, nCastRange - GetUnitToUnitDistance(bot, nEnemyCreeps[1]))
            for _, creep in ipairs(nEnemyCreeps) do
                if J.IsValid(creep)
                and J.CanBeAttacked(creep)
                and J.IsInRange(bot, creep, 800)
                and not J.IsRunning(creep)
                then
                    local tResult = PointToLineDistance(botLocation, vLocation, creep:GetLocation())
                    if tResult ~= nil and tResult.within and tResult.distance <= nRadius then
                        count = count + 1
                    end
                end
            end

            if count >= 4 then
                return BOT_ACTION_DESIRE_HIGH, vLocation
            end
        end

        local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
        if nLocationAoE.count >= 3 and #nEnemyHeroes > #nAllyHeroes then
            return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
        end
    end

    if J.IsFarming(bot) and fManaAfter > 0.4 and fManaAfter > fManaThreshold1 and bAttacking then
		for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 3)
                or (nLocationAoE.count >= 2 and creep:IsAncientCreep())
                or (nLocationAoE.count >= 2 and fManaAfter > 0.65)
                then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end

        if J.IsValid(nEnemyCreeps[1]) then
            local count = 0
            local vLocation = J.VectorAway(nEnemyCreeps[1]:GetLocation(), botLocation, nCastRange - GetUnitToUnitDistance(bot, nEnemyCreeps[1]))
            for _, creep in ipairs(nEnemyCreeps) do
                if J.IsValid(creep)
                and J.CanBeAttacked(creep)
                and J.IsInRange(bot, creep, 800)
                and not J.IsRunning(creep)
                then
                    local tResult = PointToLineDistance(botLocation, vLocation, creep:GetLocation())
                    if tResult ~= nil and tResult.within and tResult.distance <= nRadius then
                        count = count + 1
                    end
                end
            end

            if (count >= 3)
            or (count >= 2 and nEnemyCreeps[1]:IsAncientCreep())
            or (count >= 2 and fManaAfter > 0.65)
            then
                return BOT_ACTION_DESIRE_HIGH, vLocation
            end
        end
    end

    if fManaAfter > 0.5 and fManaAfter > fManaThreshold2 then
		for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 4) then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end

        if J.IsValid(nEnemyCreeps[1]) then
            local count = 0
            local vLocation = J.VectorAway(nEnemyCreeps[1]:GetLocation(), botLocation, nCastRange - GetUnitToUnitDistance(bot, nEnemyCreeps[1]))
            for _, creep in ipairs(nEnemyCreeps) do
                if J.IsValid(creep)
                and J.CanBeAttacked(creep)
                and J.IsInRange(bot, creep, 800)
                and not J.IsRunning(creep)
                and J.WillKillTarget(creep, nDamage, DAMAGE_TYPE_MAGICAL, fCastPoint)
                then
                    local tResult = PointToLineDistance(botLocation, vLocation, creep:GetLocation())
                    if tResult ~= nil and tResult.within and tResult.distance <= nRadius then
                        count = count + 1
                    end
                end
            end

            if count >= 4 then
                return BOT_ACTION_DESIRE_HIGH, vLocation
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderEnchantTotem()
    if not J.CanCastAbility(EnchantTotem) then
        return BOT_ACTION_DESIRE_NONE, 0, false
    end

    local bHasScepter = bot:HasScepter()
    local bAfterShock = Aftershock and Aftershock:IsTrained()
    local nCastRange = bHasScepter and EnchantTotem:GetSpecialValueInt('distance_scepter') or 0
	local nRadius = 350
    local fLeapDuration = EnchantTotem:GetSpecialValueFloat('scepter_leap_duration')
    local nManaCost = EnchantTotem:GetManaCost()
    local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Fissure, EchoSlam})

    if bAfterShock then nRadius = Aftershock:GetSpecialValueInt('aftershock_range') end

    if bAfterShock then
        for _, enemyHero in ipairs(nEnemyHeroes) do
            if J.IsValidHero(enemyHero) and J.CanBeAttacked(enemyHero) and J.CanCastOnNonMagicImmune(enemyHero) then
                if enemyHero:HasModifier('modifier_teleporting') then
                    local fTime = J.GetModifierTime(enemyHero, 'modifier_teleporting')

                    if J.IsInRange(bot, enemyHero, nRadius) then
                        if fTime > 0.5 then
                            return BOT_ACTION_DESIRE_HIGH, 0, false
                        end
                    else
                        if bHasScepter and not J.IsRetreating(bot) then
                            if J.IsInRange(bot, enemyHero, nCastRange) and not J.IsInRange(bot, enemyHero, 400) then
                                local nInRangeAlly = J.GetAlliesNearLoc(enemyHero:GetLocation(), 1200)
                                local nInRangeEnemy = J.GetEnemiesNearLoc(enemyHero:GetLocation(), 1200)
                                if #nInRangeAlly >= #nInRangeEnemy and fTime > fLeapDuration then
                                    return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation(), true
                                end
                            end
                        end
                    end
                elseif enemyHero:IsChanneling() and J.IsInRange(bot, enemyHero, nRadius) then
                    return BOT_ACTION_DESIRE_HIGH, 0, false
                end
            end
        end
    end

	if bHasScepter and J.IsStuck(bot) then
		return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(botLocation, J.GetTeamFountain(), nCastRange), true
	end

	if J.IsInTeamFight(bot) then
        local nInRangeEnemy = J.GetEnemiesNearLoc(botLocation, nRadius)

		if bHasScepter then
            local nLocationAoE = bot:FindAoELocation(true, true, botLocation, nCastRange, nRadius, fLeapDuration, 0)
            nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)

            if #nInRangeEnemy >= 2
            and J.GetDistance(nLocationAoE.targetloc, J.GetEnemyFountain()) > 600
            and not J.IsLocationInChrono(nLocationAoE.targetloc)
            then
                return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, true
            end

            nInRangeEnemy = J.GetEnemiesNearLoc(botLocation, 1600)
            nLocationAoE = bot:FindAoELocation(true, true, botLocation, 0, nRadius, 0, 0)
            if #nInRangeEnemy == 0 and nLocationAoE.count >= 2 then
                if fManaAfter > fManaThreshold1 then
                    return BOT_ACTION_DESIRE_HIGH, 0, false
                end
            end
		else
            if #nInRangeEnemy >= 2 then
                return BOT_ACTION_DESIRE_HIGH, 0, false
            end

            nInRangeEnemy = J.GetEnemiesNearLoc(botLocation, 1200)
            local nLocationAoE = bot:FindAoELocation(true, true, botLocation, 0, nRadius, 0, 0)
            if #nInRangeEnemy == 0 and nLocationAoE.count >= 2 then
                if fManaAfter > fManaThreshold1 then
                    return BOT_ACTION_DESIRE_HIGH, 0, false
                end
            end
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
            if bHasScepter then
                if  J.IsInRange(bot, botTarget, nCastRange)
                and not J.IsInRange(bot, botTarget, nRadius)
                and GetUnitToLocationDistance(botTarget, J.GetEnemyFountain()) > 600
                and not botTarget:HasModifier('modifier_faceless_void_chronosphere')
                then
                    return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(botTarget, fLeapDuration), true
                else
                    if J.IsInRange(bot, botTarget, nRadius - 50) then
                        if fManaAfter > fManaThreshold1 then
                            return BOT_ACTION_DESIRE_HIGH, 0, false
                        end
                    end
                end
            else
                if J.IsInRange(bot, botTarget, nRadius - 50) then
                    if fManaAfter > fManaThreshold1 then
                        return BOT_ACTION_DESIRE_HIGH, 0, false
                    end
                end
            end
		end
	end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(4.0) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if J.IsValidHero(enemyHero) and J.CanBeAttacked(enemyHero) then
                if (J.IsChasingTarget(enemyHero, bot) and not J.IsSuspiciousIllusion(enemyHero)) or #nEnemyHeroes > #nAllyHeroes then
                    if bHasScepter then
                        return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(botLocation, J.GetTeamFountain(), nCastRange), true
                    else
                        if bAfterShock then
                            if J.IsInRange(bot, enemyHero, nRadius)
                            and J.CanCastOnNonMagicImmune(enemyHero)
                            and not J.IsDisabled(enemyHero)
                            then
                                return BOT_ACTION_DESIRE_HIGH, 0, false
                            end
                        end
                    end
                end
            end
        end
    end

    local nEnemyCreeps = bot:GetNearbyCreeps(1200, true)

    if J.IsPushing(bot)
    and fManaAfter > 0.5 and fManaAfter > fManaThreshold1
    and not bot:HasModifier('modifier_earthshaker_enchant_totem')
    then
        if bHasScepter then
            for _, creep in pairs(nEnemyCreeps) do
                if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                    local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                    if (nLocationAoE.count >= 3) and GetUnitToLocationDistance(bot, nLocationAoE.targetloc) > bot:GetAttackRange() then
                        return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, true
                    end
                end
            end

            local nLocationAoE = bot:FindAoELocation(true, false, bot:GetLocation(), 0, nRadius, 0, 0)
            if nLocationAoE.count >= 3 and bAttacking then
                return BOT_ACTION_DESIRE_HIGH, 0, false
            end

            if J.IsValidBuilding(botTarget) and J.CanBeAttacked(botTarget) and bAttacking then
                return BOT_ACTION_DESIRE_HIGH, 0, false
            end
        else
            local nLocationAoE = bot:FindAoELocation(true, false, bot:GetLocation(), 0, nRadius, 0, 0)
            if nLocationAoE.count >= 3 then
                return BOT_ACTION_DESIRE_HIGH, 0, false
            end

            if J.IsValidBuilding(botTarget) and J.CanBeAttacked(botTarget) and bAttacking then
                return BOT_ACTION_DESIRE_HIGH, 0, false
            end
        end
    end

    if J.IsDefending(bot)
    and fManaAfter > 0.5 and fManaAfter > fManaThreshold1
    and not bot:HasModifier('modifier_earthshaker_enchant_totem')
    then
        if bHasScepter then
            if #nEnemyHeroes <= 1 then
                for _, creep in pairs(nEnemyCreeps) do
                    if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                        local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                        if (nLocationAoE.count >= 3) and GetUnitToLocationDistance(bot, nLocationAoE.targetloc) > bot:GetAttackRange() then
                            return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, true
                        end
                    end
                end
            end

            local nLocationAoE = bot:FindAoELocation(true, false, bot:GetLocation(), 0, nRadius, 0, 0)
            if nLocationAoE.count >= 3 and bAttacking then
                return BOT_ACTION_DESIRE_HIGH, 0, false
            end

            nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), 0, nRadius, 0, 0)
            if nLocationAoE.count >= 2 and bAttacking then
                return BOT_ACTION_DESIRE_HIGH, 0, false
            end
        else
            local nLocationAoE = bot:FindAoELocation(true, false, bot:GetLocation(), 0, nRadius, 0, 0)
            if nLocationAoE.count >= 3 then
                return BOT_ACTION_DESIRE_HIGH, 0, false
            end

            nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), 0, nRadius, 0, 0)
            if nLocationAoE.count >= 2 and bAttacking then
                return BOT_ACTION_DESIRE_HIGH, 0, false
            end
        end
    end

    if J.IsFarming(bot) and fManaAfter > fManaThreshold1 and bAttacking and not bot:HasModifier('modifier_earthshaker_enchant_totem') then
        if  J.IsValid(botTarget)
        and J.CanBeAttacked(botTarget)
        and botTarget:IsCreep()
        and not J.CanKillTarget(botTarget, bot:GetAttackDamage() * 2, DAMAGE_TYPE_PHYSICAL)
        then
            return BOT_ACTION_DESIRE_HIGH, 0, false
        end
    end

    if J.IsDoingRoshan(bot) then
        if  J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        and fManaAfter > fManaThreshold1
        and bAttacking
        and not bot:HasModifier('modifier_earthshaker_enchant_totem')
        then
            return BOT_ACTION_DESIRE_HIGH, 0, false
        end
    end

    if J.IsDoingTormentor(bot) then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        and fManaAfter > fManaThreshold1
        and bAttacking
        and not bot:HasModifier('modifier_earthshaker_enchant_totem')
        then
            return BOT_ACTION_DESIRE_HIGH, 0, false
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0, false
end

function X.ConsiderEchoSlam()
    if not J.CanCastAbility(EchoSlam) then
        return BOT_ACTION_DESIRE_NONE
    end

	local nRadius = EchoSlam:GetSpecialValueInt('echo_slam_echo_range')

	if J.IsInTeamFight(bot, 1200) then
        local nInRangeEnemy_real = {}
        local nInRangeEnemy_all = {}
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nRadius * 0.8)
            and not enemyHero:IsMagicImmune()
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
            then
                if not J.IsSuspiciousIllusion(enemyHero) then
                    table.insert(nInRangeEnemy_real, enemyHero)
                end
                table.insert(nInRangeEnemy_all, enemyHero)
            end
        end

        if #nInRangeEnemy_real >= 2 then
            local totalHealth = 0
            for _, enemyHero in pairs(nInRangeEnemy_real) do
                if enemyHero then
                    totalHealth = totalHealth + enemyHero:GetHealth()
                end
            end

            local totalDamage, totalDamageToTarget = X.GetEchoSlamDamage(botLocation, nil)
            if (totalDamage > totalHealth * 0.5)
            or (#nInRangeEnemy_real >= 3)
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
	end

    if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
        and J.CanBeAttacked(botTarget)
        and not botTarget:IsMagicImmune()
        and J.IsInRange(bot, botTarget, nRadius * 0.8)
        and (J.IsEarlyGame() or J.IsCore(botTarget))
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
        and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
        and not botTarget:HasModifier('modifier_item_aeon_disk_buff')
		then
            local nInRangeAlly = J.GetAlliesNearLoc(botTarget:GetLocation(), 1200)
            local nInRangeEnemy = J.GetEnemiesNearLoc(botTarget:GetLocation(), 1200)

            local totalDamage, totalDamageToTarget = X.GetEchoSlamDamage(botLocation, botTarget)

            if #nInRangeAlly <= 1 and #nInRangeEnemy <= 1 then
                if J.GetHP(botTarget) < 0.5 and (totalDamageToTarget / botTarget:GetHealth()) >= (J.IsInRange(bot, botTarget, 300) and 0.6 or 0.8) then
                    return BOT_ACTION_DESIRE_HIGH
                end
            else
                if Aftershock and Aftershock:IsTrained() and J.IsInRange(bot, botTarget, Aftershock:GetSpecialValueInt('aftershock_range')) then
                    local nAllyHeroesAttackingTarget = J.GetHeroesTargetingUnit(nInRangeAlly, botTarget)
                    if botTarget:HasModifier('modifier_teleporting') and #nAllyHeroesAttackingTarget >= 3 then
                        if botTarget:GetHealth() > J.GetTotalEstimatedDamageToTarget(nAllyHeroesAttackingTarget, botTarget, J.GetModifierTime(botTarget, 'modifier_teleporting')) then
                            return BOT_ACTION_DESIRE_HIGH
                        end
                    end
                end

                if #nInRangeEnemy > #nInRangeAlly then
                    if botTarget:GetHealth() < totalDamageToTarget then
                        return BOT_ACTION_DESIRE_HIGH
                    end
                end

                if #nInRangeAlly >= #nInRangeEnemy and not (#nInRangeAlly >= #nInRangeEnemy + 2) and J.GetHP(botTarget) > 0.4 then
                    if botTarget:GetHealth() * 0.5 < totalDamageToTarget then
                        return BOT_ACTION_DESIRE_HIGH
                    end
                end
            end
		end
	end

    return BOT_ACTION_DESIRE_NONE
end

function X.GetEchoSlamDamage(vLocation, hTarget)
    local nTotalDamage = 0
    local nDamageToTarget = 0

    if EchoSlam and EchoSlam:IsTrained() then
        local nBaseDamage = EchoSlam:GetSpecialValueInt('echo_slam_initial_damage')
        local nEchoDamage = EchoSlam:GetSpecialValueInt('echo_slam_echo_damage')
        local nDamageRange = EchoSlam:GetSpecialValueInt('echo_slam_damage_range')
        local nEchoRange = EchoSlam:GetSpecialValueInt('echo_slam_echo_search_range')

        local hHitUnits = {}
        local unitList = GetUnitList(UNIT_LIST_ENEMIES)
        for _, unit in pairs(unitList) do
            if J.IsValid(unit) and (unit:IsHero() or unit:IsCreep()) then
                if GetUnitToLocationDistance(unit, vLocation) <= nDamageRange then
                    table.insert(hHitUnits, unit)
                    nTotalDamage = nTotalDamage + unit:GetActualIncomingDamage(nBaseDamage, DAMAGE_TYPE_MAGICAL)
                    if unit == hTarget then
                        nDamageToTarget = nDamageToTarget + unit:GetActualIncomingDamage(nBaseDamage, DAMAGE_TYPE_MAGICAL)
                    end
                end
            end
        end

        for _, unit in pairs(hHitUnits) do
            local echoes = 0
            local maxEchoes = (unit:IsHero() and not J.IsSuspiciousIllusion(unit)) and 2 or 1
            if maxEchoes > echoes then
                for _, other in pairs(unitList) do
                    if other ~= unit
                    and bot ~= other
                    and J.IsValid(other)
                    and (other:IsHero() or other:IsCreep())
                    and (unit:GetTeam() == other:GetTeam() or other:GetTeam() == TEAM_NEUTRAL)
                    and GetUnitToUnitDistance(unit, other) <= nEchoRange then
                        nTotalDamage = nTotalDamage + other:GetActualIncomingDamage(nEchoDamage, DAMAGE_TYPE_MAGICAL)
                        echoes = echoes + 1
                        if other == hTarget then
                            nDamageToTarget = nDamageToTarget + other:GetActualIncomingDamage(nEchoDamage, DAMAGE_TYPE_MAGICAL)
                        end
                    end
                end
            end
        end
    end

    return nTotalDamage, nDamageToTarget
end

-- Blink > Echo
function X.ConsiderBlinkSlam()
    if J.CanBlinkDagger(bot) and J.CanCastAbility(EchoSlam) and (bot:GetMana() > (EchoSlam:GetManaCost() + 150)) then
        local nCastRange = bot.Blink:GetCastRange()
        local nRadius = EchoSlam:GetSpecialValueInt('echo_slam_echo_range')

        if J.IsGoingOnSomeone(bot) then
            if  J.IsValidTarget(botTarget)
            and J.CanBeAttacked(botTarget)
            and not botTarget:IsMagicImmune()
            and J.IsInRange(bot, botTarget, nCastRange)
            and not J.IsInRange(bot, botTarget, 700)
            and J.IsCore(botTarget)
            and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
            and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
            and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
            and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
            and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
            and not botTarget:HasModifier('modifier_item_aeon_disk_buff')
            then
                local totalDamage, totalDamageToTarget = X.GetEchoSlamDamage(botTarget:GetLocation(), botTarget)
                local nInRangeEnemy = J.GetEnemiesNearLoc(botTarget:GetLocation(), nRadius)
                if #nInRangeEnemy <= 1 then
                    if (totalDamageToTarget / botTarget:GetHealth()) >= 0.8 then
                        bot.shouldBlink = true
                        return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
                    end
                else
                    local totalHealth = 0
                    for _, enemyHero in pairs(nInRangeEnemy) do
                        if J.IsValidTarget(enemyHero)
                        and J.CanBeAttacked(enemyHero)
                        and not enemyHero:IsMagicImmune()
                        and J.IsCore(enemyHero)
                        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
                        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
                        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
                        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
                        and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
                        and not enemyHero:HasModifier('modifier_item_aeon_disk_buff')
                        then
                            totalHealth = totalHealth + enemyHero:GetHealth()
                        end
                    end

                    totalDamage, totalDamageToTarget = X.GetEchoSlamDamage(botTarget:GetLocation(), nil)
                    if totalDamage > totalHealth * 0.75 or #nInRangeEnemy >= 3 then
                        bot.shouldBlink = true
                        return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
                    end
                end
            end
        end
    end

    bot.shouldBlink = false
    return BOT_ACTION_DESIRE_NONE, 0
end

-- Enchant Totem > Echo
function X.ConsiderTotemSlam()
    if bot:HasScepter() and J.CanCastAbility(EnchantTotem) and J.CanCastAbility(EchoSlam) and bot:GetMana() > (EnchantTotem:GetManaCost() + EchoSlam:GetManaCost() + 100) then
        local nETCastRange = EnchantTotem:GetSpecialValueInt('distance_scepter')
        local nETLeapDuration = EnchantTotem:GetSpecialValueFloat('scepter_leap_duration')
        local nRadius = EchoSlam:GetSpecialValueInt('echo_slam_echo_range')

        if J.IsGoingOnSomeone(bot) then
            if  J.IsValidTarget(botTarget)
            and J.CanBeAttacked(botTarget)
            and not botTarget:IsMagicImmune()
            and J.IsInRange(bot, botTarget, nETCastRange)
            and not J.IsInRange(bot, botTarget, 400)
            and J.IsCore(botTarget)
            and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
            and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
            and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
            and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
            and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
            and not botTarget:HasModifier('modifier_item_aeon_disk_buff')
            then
                local vLocation = J.GetCorrectLoc(botTarget, nETLeapDuration + 0.1)
                local totalDamage, totalDamageToTarget = X.GetEchoSlamDamage(vLocation, botTarget)
                local nInRangeEnemy = J.GetEnemiesNearLoc(botTarget:GetLocation(), nRadius)
                if #nInRangeEnemy <= 1 then
                    if (totalDamageToTarget / botTarget:GetHealth()) >= 0.8 then
                        return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
                    end
                else
                    local totalHealth = 0
                    for _, enemyHero in pairs(nInRangeEnemy) do
                        if J.IsValidTarget(enemyHero)
                        and J.CanBeAttacked(enemyHero)
                        and not enemyHero:IsMagicImmune()
                        and J.IsCore(enemyHero)
                        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
                        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
                        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
                        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
                        and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
                        and not enemyHero:HasModifier('modifier_item_aeon_disk_buff')
                        then
                            totalHealth = totalHealth + enemyHero:GetHealth()
                        end
                    end

                    totalDamage, totalDamageToTarget = X.GetEchoSlamDamage(vLocation, nil)
                    if totalDamage > totalHealth * 0.75 or #nInRangeEnemy >= 3 then
                        return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
                    end
                end
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

return X