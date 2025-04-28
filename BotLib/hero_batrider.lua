local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_batrider'
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
                [1] = {
					['t25'] = {10, 0},
					['t20'] = {10, 0},
					['t15'] = {10, 0},
					['t10'] = {0, 10},
				},
            },
            ['ability'] = {
				[1] = {1,3,1,2,1,6,1,3,3,3,6,2,2,2,6},
            },
            ['buy_list'] = {
				"item_tango",
                "item_faerie_fire",
				"item_double_circlet",
				"item_double_branches",
			
				"item_bottle",
                "item_double_null_talisman",
				"item_magic_wand",
                "item_boots",
				"item_blink",
				"item_travel_boots",
				"item_black_king_bar",--
				"item_shivas_guard",--
				"item_octarine_core",--
				"item_ultimate_scepter",
				"item_refresher",--
				"item_ultimate_scepter_2",
				"item_overwhelming_blink",--
				"item_travel_boots_2",--
				"item_aghanims_shard",
				"item_moon_shard",
			},
            ['sell_list'] = {
                "item_null_talisman", "item_black_king_bar",
                "item_null_talisman", "item_shivas_guard",
				"item_magic_wand", "item_octarine_core",
				"item_bottle", "item_ultimate_scepter"
			},
        },
    },
    ['pos_3'] = {
        [1] = {
            ['talent'] = {
				[1] = {
					['t25'] = {10, 0},
					['t20'] = {10, 0},
					['t15'] = {0, 10},
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
                [1] = {1,2,1,3,1,6,1,3,3,3,2,6,2,2,6},
            },
            ['buy_list'] = {
				"item_tango",
                "item_faerie_fire",
				"item_double_circlet",
				"item_double_branches",
			
				"item_bracer",
                "item_null_talisman",
				"item_magic_wand",
				"item_arcane_boots",
				"item_wind_lace",
				"item_veil_of_discord",
				"item_blink",
                "item_pipe",--
				"item_black_king_bar",--
				"item_travel_boots",
				"item_shivas_guard",--
				"item_ultimate_scepter",
				"item_refresher",--
				"item_ultimate_scepter_2",
				"item_overwhelming_blink",--
				"item_travel_boots_2",--
				"item_aghanims_shard",
				"item_moon_shard",
			},
            ['sell_list'] = {
				"item_magic_wand", "item_pipe",
                "item_null_talisman", "item_black_king_bar",
                "item_wind_lace", "item_travel_boots",
                "item_bracer", "item_ultimate_scepter",
			},
        },
    },
    ['pos_4'] = {
        [1] = {
            ['talent'] = {
				[1] = {
					['t25'] = {10, 0},
					['t20'] = {10, 0},
					['t15'] = {10, 0},
					['t10'] = {10, 0},
				}
            },
            ['ability'] = {
                [1] = {2,3,3,1,3,6,3,1,1,1,6,2,2,2,6},
            },
            ['buy_list'] = {
				"item_double_tango",
				"item_double_branches",
				"item_circlet",
				"item_blood_grenade",
			
				"item_boots",
				"item_magic_wand",
				"item_tranquil_boots",
				"item_blink",
				"item_force_staff",--
				"item_black_king_bar",--
				"item_boots_of_bearing",--
				"item_shivas_guard",--
				"item_wind_waker",--
				"item_arcane_blink",--
				"item_aghanims_shard",
				"item_ultimate_scepter_2",
				"item_moon_shard",
			},
            ['sell_list'] = {
				"item_circlet", "item_force_staff",
				"item_magic_wand", "item_black_king_bar",
			},
        },
    },
    ['pos_5'] = {
        [1] = {
            ['talent'] = {
				[1] = {
					['t25'] = {10, 0},
					['t20'] = {10, 0},
					['t15'] = {10, 0},
					['t10'] = {10, 0},
				}
            },
            ['ability'] = {
                [1] = {2,3,3,1,3,6,3,1,1,1,6,2,2,2,6},
            },
            ['buy_list'] = {
				"item_double_tango",
				"item_double_branches",
				"item_circlet",
				"item_blood_grenade",
			
				"item_boots",
				"item_magic_wand",
				"item_arcane_boots",
				"item_blink",
				"item_force_staff",--
				"item_black_king_bar",--
				"item_guardian_greaves",--
				"item_shivas_guard",--
				"item_wind_waker",--
				"item_arcane_blink",--
				"item_aghanims_shard",
				"item_ultimate_scepter_2",
				"item_moon_shard",
			},
            ['sell_list'] = {
				"item_circlet", "item_force_staff",
				"item_magic_wand", "item_black_king_bar",
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

local StickyNapalm  = bot:GetAbilityByName('batrider_sticky_napalm')
local Flamebreak    = bot:GetAbilityByName('batrider_flamebreak')
local Firefly       = bot:GetAbilityByName('batrider_firefly')
local FlamingLasso  = bot:GetAbilityByName('batrider_flaming_lasso')

local StickyNapalmDesire, StickyNapalmLocation
local FlamebreakDesire, FlamebreakLocation
local FireflyDesire
local FlamingLassoDesire, FlamingLassoTarget

local BlinkLassoDesire, BlinkLassoTarget

function X.SkillsComplement()
	if J.CanNotUseAbility(bot) then return end

	StickyNapalm  = bot:GetAbilityByName('batrider_sticky_napalm')
	Flamebreak    = bot:GetAbilityByName('batrider_flamebreak')
	Firefly       = bot:GetAbilityByName('batrider_firefly')
	FlamingLasso  = bot:GetAbilityByName('batrider_flaming_lasso')

	BlinkLassoDesire, BlinkLassoTarget = X.ConsiderBlinkLasso()
	if BlinkLassoDesire > 0
	then
		bot:Action_ClearActions(false)

		if J.CanCastAbility(Firefly)
		and J.GetManaAfter(Firefly:GetManaCost()) * bot:GetMana() > FlamingLasso:GetManaCost()
		then
			bot:ActionQueue_UseAbility(Firefly)
		end

		if J.CanBlackKingBar(bot)
		then
			bot:ActionQueue_UseAbility(bot.BlackKingBar)
			bot:ActionQueue_Delay(0.1)
		end

		bot:ActionQueue_UseAbilityOnLocation(bot.Blink, BlinkLassoTarget:GetLocation())
		bot:ActionQueue_Delay(0.1)
		bot:ActionQueue_UseAbilityOnEntity(FlamingLasso, BlinkLassoTarget)
		return
	end

	FireflyDesire = X.ConsiderFirefly()
    if FireflyDesire > 0
    then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbility(Firefly)
		return
    end

    FlamingLassoDesire, FlamingLassoTarget = X.ConsiderFlamingLasso()
    if FlamingLassoDesire > 0
    then
        bot:Action_UseAbilityOnEntity(FlamingLasso, FlamingLassoTarget)
        return
    end

    FlamebreakDesire, FlamebreakLocation = X.ConsiderFlamebreak()
    if FlamebreakDesire > 0
    then
		J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(Flamebreak, FlamebreakLocation)
        return
    end

    StickyNapalmDesire, StickyNapalmLocation = X.ConsiderStickyNapalm()
    if StickyNapalmDesire > 0
    then
		J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(StickyNapalm, StickyNapalmLocation)
        return
    end
end

function X.ConsiderStickyNapalm()
	if not J.CanCastAbility(StickyNapalm)
    then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nCastRange = J.GetProperCastRange(false, bot, StickyNapalm:GetCastRange())
    local nCastPoint = StickyNapalm:GetCastPoint()
    local nRadius = StickyNapalm:GetSpecialValueInt('radius')
    local botTarget = J.GetProperTarget(bot)

    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
    local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(nCastRange, true)
    local nNeutralCreeps = bot:GetNearbyNeutralCreeps(nCastRange)

    if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
            return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(botTarget, nCastPoint)
		end
	end

    if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
    then
        for _, enemyHero in pairs(nEnemyHeroes)
        do
            if J.IsValidHero(enemyHero)
            and (bot:GetActiveModeDesire() > 0.7 or bot:WasRecentlyDamagedByHero(enemyHero, 3))
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.IsInRange(bot, enemyHero, 350)
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            then
                return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(enemyHero, nCastPoint)
            end
        end
    end

    if (J.IsDefending(bot) or J.IsPushing(bot))
    then
        if J.IsValidBuilding(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end

        local nLocationAoE = bot:FindAoELocation(true, false, bot:GetLocation(), nCastRange, nRadius, 0, 0)

        if  nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 4
        and J.CanBeAttacked(nEnemyLaneCreeps[1])
        then
            return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nEnemyLaneCreeps)
        end

        nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, nCastPoint, 0)
        if nLocationAoE.count >= 1
        then
            return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
        end
    end

    if  J.IsFarming(bot)
    and J.GetManaAfter(StickyNapalm:GetManaCost()) > 0.33
    then
        if  nNeutralCreeps ~= nil and #nNeutralCreeps >= 2
        and J.CanBeAttacked(nNeutralCreeps[1])
        then
            return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nNeutralCreeps)
        end

        if  nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 3
        and J.CanBeAttacked(nEnemyLaneCreeps[1])
        then
            return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nEnemyLaneCreeps)
        end
    end

    if  J.IsLaning(bot)
    and J.GetMP(bot) > 0.55
    then
        if  J.IsValidHero(nEnemyHeroes[1])
        and J.IsInRange(bot, nEnemyHeroes[1], nCastRange)
        and J.IsValid(nEnemyLaneCreeps[1])
        and GetUnitToLocationDistance(nEnemyHeroes[1], J.GetCenterOfUnits(nEnemyLaneCreeps)) < nRadius
        then
            return BOT_ACTION_DESIRE_HIGH, nEnemyHeroes[1]:GetExtrapolatedLocation(nCastPoint)
        end

        if  nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 3
        and J.CanBeAttacked(nEnemyLaneCreeps[1])
        then
            return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nEnemyLaneCreeps)
        end
    end

    if J.IsDoingRoshan(bot)
	then
		if  J.IsRoshan(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

    if J.IsDoingTormentor(bot)
	then
		if  J.IsTormentor(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderFlamebreak()
	if not J.CanCastAbility(Flamebreak)
    then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nCastRange = J.GetProperCastRange(false, bot, Flamebreak:GetCastRange())
    local nCastPoint = Flamebreak:GetCastPoint()
    local nRadius = Flamebreak:GetSpecialValueInt('explosion_radius')
    local nSpeed = Flamebreak:GetSpecialValueInt('speed')
    local nDamage = Flamebreak:GetSpecialValueInt('damage_impact')
    local botTarget = J.GetProperTarget(bot)

    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    for _, enemyHero in pairs(nEnemyHeroes)
    do
        if  J.IsValidHero(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        then
            local nDelay = (GetUnitToUnitDistance(bot, enemyHero) / nSpeed) + nCastPoint
            return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(enemyHero, nDelay)
        end
    end

    if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not botTarget:HasModifier('modifier_enigma_black_hole_pull')
        and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
            local nDelay = (GetUnitToUnitDistance(bot, botTarget) / nSpeed) + nCastPoint
            return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(botTarget, nDelay)
		end
	end

    if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
    then
        for _, enemyHero in pairs(nEnemyHeroes)
        do
            if J.IsValidHero(enemyHero)
            and (bot:GetActiveModeDesire() > 0.7 and bot:WasRecentlyDamagedByHero(enemyHero, 2.5))
            and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.IsChasingTarget(enemyHero, bot)
            then
                if J.IsInRange(bot, enemyHero, nRadius)
                then
                    return BOT_ACTION_DESIRE_HIGH, (bot:GetLocation() + enemyHero:GetLocation()) / 2
                else
                    local nDelay = (GetUnitToUnitDistance(bot, enemyHero) / nSpeed) + nCastPoint
                    return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(enemyHero, nDelay)
                end
            end
        end
    end

    if J.IsDefending(bot)
    then
        local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, nCastPoint, 0)
        if nLocationAoE.count >= 1
        then
            return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
        end
    end

    if  J.IsLaning(bot)
    and J.IsCore(bot)
    and J.GetMP(bot) > 0.39
	then
        local canKill = 0
        local creepList = {}
		local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(nCastRange, true)

		for _, creep in pairs(nEnemyLaneCreeps)
		do
			if  J.IsValid(creep)
			and (J.IsKeyWordUnit('ranged', creep) or J.IsKeyWordUnit('siege', creep) or J.IsKeyWordUnit('flagbearer', creep))
			and creep:GetHealth() <= nDamage
            and J.CanBeAttacked(creep)
			then
				if  J.IsValidHero(nEnemyHeroes[1])
                and GetUnitToUnitDistance(nEnemyHeroes[1], creep) < 500
				then
					return BOT_ACTION_DESIRE_HIGH, creep:GetLocation()
				end
			end

            if  J.IsValid(creep)
            and creep:GetHealth() <= nDamage
            then
                canKill = canKill + 1
                table.insert(creepList, creep)
            end
		end

        if canKill >= 2
        then
            return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(creepList)
        end
	end

    local nAllyHeroes = bot:GetNearbyHeroes(nCastRange, false, BOT_MODE_NONE)
    for _, allyHero in pairs(nAllyHeroes)
    do
        if  J.IsValidHero(allyHero)
        and J.IsRetreating(allyHero)
        and allyHero:WasRecentlyDamagedByAnyHero(3)
        and not J.IsSuspiciousIllusion(allyHero)
        then
            local nAllyInRangeEnemy = allyHero:GetNearbyHeroes(nCastRange, true, BOT_MODE_NONE)

            if  J.IsValidHero(nAllyInRangeEnemy[1])
            and J.CanCastOnNonMagicImmune(nAllyInRangeEnemy[1])
            and J.IsInRange(allyHero, nAllyInRangeEnemy[1], 500)
            and J.IsInRange(bot, nAllyInRangeEnemy[1], nCastRange)
            and not J.IsChasingTarget(nAllyInRangeEnemy[1], bot)
            and not J.IsDisabled(nAllyInRangeEnemy[1])
            and not nAllyInRangeEnemy[1]:HasModifier('modifier_enigma_black_hole_pull')
            and not nAllyInRangeEnemy[1]:HasModifier('modifier_faceless_void_chronosphere_freeze')
            then
                local nDelay = (GetUnitToUnitDistance(bot, nAllyInRangeEnemy[1]) / nSpeed) + nCastPoint
                return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(nAllyInRangeEnemy[1], nDelay)
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderFirefly()
	if not J.CanCastAbility(Firefly)
    then
        return BOT_ACTION_DESIRE_NONE
    end

    local botTarget = J.GetProperTarget(bot)
    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    if J.IsStuck(bot)
    then
        return BOT_ACTION_DESIRE_HIGH
    end

    if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, 800)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
            if J.IsInRange(bot, botTarget, 200)
            or (J.IsValidHero(nEnemyHeroes[1]) and J.IsInRange(bot, nEnemyHeroes[1], 200))
            then
                return BOT_ACTION_DESIRE_HIGH
            end
		end

        if J.IsInTeamFight(bot, 1200)
        then
            return BOT_ACTION_DESIRE_HIGH
        end
	end

    if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
    then
        if (bot:GetActiveModeDesire() > 0.85 or bot:WasRecentlyDamagedByAnyHero(3))
        and J.IsValidHero(nEnemyHeroes[1])
		and J.IsChasingTarget(nEnemyHeroes[1], bot)
        and J.CanCastOnNonMagicImmune(nEnemyHeroes[1])
        and J.IsInRange(bot, nEnemyHeroes[1], 400)
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderFlamingLasso()
	if not J.CanCastAbility(FlamingLasso)
    then
        return BOT_ACTION_DESIRE_NONE
    end

    local nCastRange = J.GetProperCastRange(false, bot, FlamingLasso:GetCastRange()) + 300

    if J.IsGoingOnSomeone(bot)
	then
        local nTarget = nil
        local nInRangeEnemy = bot:GetNearbyHeroes(nCastRange, true, BOT_MODE_NONE)
        for _, enemyHero in pairs(nInRangeEnemy)
        do
            if  J.IsValidTarget(enemyHero)
            and J.CanCastOnMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and not J.IsDisabled(enemyHero)
            and not J.IsHaveAegis(enemyHero)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_enigma_black_hole_pull')
            and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
            and not enemyHero:HasModifier('modifier_legion_commander_duel')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            then
                nTarget = enemyHero
                break
            end
        end

        if nTarget ~= nil
        then
            local nInRangeAlly = nTarget:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
            local nTargetInRangeAlly = nTarget:GetNearbyHeroes(1600, false, BOT_MODE_NONE)

            if (#nInRangeAlly >= #nTargetInRangeAlly or J.WeAreStronger(bot, 1200))
            then
                return BOT_ACTION_DESIRE_HIGH, nTarget
            end
        end
	end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderBlinkLasso()
	if J.CanCastAbility(FlamingLasso) and J.CanBlinkDagger(bot) and bot:GetMana() >= FlamingLasso:GetManaCost()
    then
        local nDuration = FlamingLasso:GetSpecialValueInt('duration')

        if J.IsGoingOnSomeone(bot)
        then
            local strongestTarget = J.GetStrongestUnit(1199, bot, true, false, nDuration)

            if strongestTarget == nil
            then
                strongestTarget = J.GetStrongestUnit(1199, bot, true, true, nDuration)
            end

            if  J.IsValidTarget(strongestTarget)
            and J.CanCastOnMagicImmune(strongestTarget)
            and J.CanCastOnTargetAdvanced(strongestTarget)
            and J.IsInRange(bot, strongestTarget, 1199)
            and not J.IsDisabled(strongestTarget)
            and not J.IsHaveAegis(strongestTarget)
            and not strongestTarget:HasModifier('modifier_abaddon_borrowed_time')
            and not strongestTarget:HasModifier('modifier_dazzle_shallow_grave')
            and not strongestTarget:HasModifier('modifier_enigma_black_hole_pull')
            and not strongestTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
            and not strongestTarget:HasModifier('modifier_legion_commander_duel')
            and not strongestTarget:HasModifier('modifier_necrolyte_reapers_scythe')
            then
				bot.shouldBlink = true
                return BOT_ACTION_DESIRE_HIGH, strongestTarget
            end
        end
    end

    bot.shouldBlink = false
	return BOT_ACTION_DESIRE_NONE, nil
end



return X