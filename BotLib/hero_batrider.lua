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
					['t25'] = {0, 10},
					['t20'] = {10, 0},
					['t15'] = {0, 10},
					['t10'] = {0, 10},
				},
            },
            ['ability'] = {
				[1] = {1,3,1,2,1,6,1,3,3,3,6,2,2,2,6},
            },
            ['buy_list'] = {
				"item_tango",
                "item_magic_wand",
                "item_faerie_fire",
			
				"item_bottle",
                "item_power_treads",
                "item_dragon_lance",
				"item_blink",
				"item_black_king_bar",--
                "item_hurricane_pike",--
				"item_aghanims_shard",
                "item_devastator",--
                "item_sphere",--
				"item_ultimate_scepter_2",
				"item_overwhelming_blink",--
				"item_moon_shard",
				"item_travel_boots_2",--
			},
            ['sell_list'] = {
				"item_magic_wand", "item_devastator",
				"item_bottle", "item_sphere"
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
				},
            },
            ['ability'] = {
                [1] = {1,2,1,3,1,6,1,3,3,3,2,6,2,2,6},
            },
            ['buy_list'] = {
				"item_tango",
                "item_faerie_fire",
				"item_double_circlet",
				"item_double_branches",
			
				"item_magic_wand",
				"item_bracer",
                "item_null_talisman",
				"item_power_treads",
				"item_blink",
                "item_pipe",--
				"item_black_king_bar",--
				"item_aghanims_shard",
				"item_shivas_guard",--
                "item_octarine_core",--
				"item_ultimate_scepter_2",
				"item_overwhelming_blink",--
				"item_travel_boots_2",--
				"item_moon_shard",
			},
            ['sell_list'] = {
				"item_magic_wand", "item_black_king_bar",
                "item_bracer", "item_shivas_guard",
                "item_null_talisman", "item_octarine_core",
			},
        },
    },
    ['pos_4'] = {
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
                [1] = {2,3,3,1,3,6,3,1,1,1,6,2,2,2,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_double_circlet",
				"item_blood_grenade",
			
				"item_magic_wand",
				"item_tranquil_boots",
				"item_blink",
                "item_ancient_janggo",
				"item_force_staff",
				"item_black_king_bar",--
				"item_boots_of_bearing",--
				"item_aghanims_shard",
				"item_shivas_guard",--
                "item_sphere",--
				"item_ultimate_scepter_2",
				"item_overwhelming_blink",--
				"item_moon_shard",
                "item_hurricane_pike",--
			},
            ['sell_list'] = {
				"item_circlet", "item_force_staff",
                "item_circlet", "item_black_king_bar",
				"item_magic_wand", "item_sphere",
			},
        },
    },
    ['pos_5'] = {
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
                [1] = {2,3,3,1,3,6,3,1,1,1,6,2,2,2,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_double_circlet",
				"item_blood_grenade",
			
				"item_magic_wand",
				"item_arcane_boots",
				"item_blink",
                "item_mekansm",
				"item_force_staff",
				"item_black_king_bar",--
				"item_guardian_greaves",--
				"item_aghanims_shard",
				"item_shivas_guard",--
                "item_sphere",--
				"item_ultimate_scepter_2",
				"item_overwhelming_blink",--
				"item_moon_shard",
                "item_hurricane_pike",--
			},
            ['sell_list'] = {
				"item_circlet", "item_force_staff",
                "item_circlet", "item_black_king_bar",
				"item_magic_wand", "item_sphere",
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

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
    bot = GetBot()

	if J.CanNotUseAbility(bot) then return end

	StickyNapalm  = bot:GetAbilityByName('batrider_sticky_napalm')
	Flamebreak    = bot:GetAbilityByName('batrider_flamebreak')
	Firefly       = bot:GetAbilityByName('batrider_firefly')
	FlamingLasso  = bot:GetAbilityByName('batrider_flaming_lasso')

	bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	BlinkLassoDesire, BlinkLassoTarget = X.ConsiderBlinkLasso()
	if BlinkLassoDesire > 0 and BlinkLassoTarget then
		bot:Action_ClearActions(true)

        local BlackKingBar = J.IsItemAvailable('item_black_king_bar')
		if J.CanCastAbility(BlackKingBar) and (bot:GetMana() > (FlamingLasso:GetManaCost() + BlackKingBar:GetManaCost() + 75)) then
			bot:ActionQueue_UseAbility(BlackKingBar)
			bot:ActionQueue_Delay(0.1)
		end

		bot:ActionQueue_UseAbilityOnLocation(bot.Blink, BlinkLassoTarget:GetLocation())
		bot:ActionQueue_Delay(0.1)
		bot:ActionQueue_UseAbilityOnEntity(FlamingLasso, BlinkLassoTarget)
		return
	end

	FireflyDesire = X.ConsiderFirefly()
    if FireflyDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbility(Firefly)
		return
    end

    StickyNapalmDesire, StickyNapalmLocation = X.ConsiderStickyNapalm()
    if StickyNapalmDesire > 0 then
		J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(StickyNapalm, StickyNapalmLocation)
        return
    end

    FlamingLassoDesire, FlamingLassoTarget = X.ConsiderFlamingLasso()
    if FlamingLassoDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(FlamingLasso, FlamingLassoTarget)
        return
    end

    FlamebreakDesire, FlamebreakLocation = X.ConsiderFlamebreak()
    if FlamebreakDesire > 0 then
		J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnLocation(Flamebreak, FlamebreakLocation)
        return
    end
end

function X.ConsiderStickyNapalm()
	if not J.CanCastAbility(StickyNapalm) then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nCastRange = J.GetProperCastRange(false, bot, StickyNapalm:GetCastRange())
    local nCastPoint = StickyNapalm:GetCastPoint()
    local nRadius = StickyNapalm:GetSpecialValueInt('radius')
    local fBuildingDamagePct = StickyNapalm:GetSpecialValueInt('building_damage_pct') / 100

    if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.CanCastOnNonMagicImmune(botTarget)
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
            return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and not J.IsDisabled(enemyHero)
            and bot:WasRecentlyDamagedByHero(enemyHero, 3.0)
            then
                local nStacks = J.GetModifierCount(enemyHero, 'modifier_batrider_sticky_napalm')
                if nStacks <= 4 then
                    return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
                end
            end
        end
    end

    local nEnemyCreeps = bot:GetNearbyCreeps(Min(nCastRange + 300, 1600), true)

    if J.IsPushing(bot) and bAttacking then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 2)
                or (nLocationAoE.count >= 1 and creep:GetHealth() >= 500)
                then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

    if J.IsDefending(bot) and bAttacking then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 2) then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end

        local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
        if nLocationAoE.count >= 1 then
            return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
        end
    end

    if J.IsFarming(bot) and bAttacking then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 2)
                or (nLocationAoE.count >= 1 and creep:GetHealth() >= 500)
                then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

    for _, enemyHero in pairs(nEnemyHeroes) do
        if J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and not J.IsDisabled(enemyHero)
        then
            if not J.IsRetreating(bot) and not J.IsRealInvisible(bot) and not J.IsEarlyGame() and #nAllyHeroes >= #nEnemyHeroes then
                return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
            end

            if J.IsLaning(bot) and J.IsInLaningPhase() then
                local nEnemyLaneCreeps = enemyHero:GetNearbyLaneCreeps(nRadius, false)
                if #nEnemyLaneCreeps > 0 then
                    return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
                end
            end
        end
    end

    if fBuildingDamagePct > 0 then
        if  J.IsValidBuilding(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange + 300)
        then
            if bAttacking or botTarget:GetHealthRegen() == 0 then
                return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
            end
        end
    end

    if J.IsDoingRoshan(bot) then
		if  J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and bAttacking
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

    if J.IsDoingTormentor(bot) then
		if  J.IsTormentor(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and bAttacking
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderFlamebreak()
	if not J.CanCastAbility(Flamebreak) then
        return BOT_ACTION_DESIRE_NONE, 0
    end

    local nCastRange = J.GetProperCastRange(false, bot, Flamebreak:GetCastRange())
    local nCastPoint = Flamebreak:GetCastPoint()
    local nRadius = Flamebreak:GetSpecialValueInt('explosion_radius')
    local nSpeed = Flamebreak:GetSpecialValueInt('speed')
    local nDamage = Flamebreak:GetSpecialValueInt('damage_impact')
    local nManaCost = Flamebreak:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {StickyNapalm, Firefly, FlamingLasso})

    for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
        then
            local eta = (GetUnitToUnitDistance(bot, enemyHero) / nSpeed) + nCastPoint
            if J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL, eta) then
                return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(enemyHero, eta)
            end
        end
    end

    if J.IsGoingOnSomeone(bot) then
		if  J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
            local eta = (GetUnitToUnitDistance(bot, botTarget) / nSpeed) + nCastPoint
            local vLocation = J.GetCorrectLoc(botTarget, eta)
            if GetUnitToLocationDistance(bot, vLocation) <= nCastRange then
                vLocation = J.VectorAway(vLocation, bot:GetLocation(), nRadius / 2)
                if GetUnitToLocationDistance(bot, vLocation) <= nCastRange then
                    return BOT_ACTION_DESIRE_HIGH, vLocation
                end
            end
		end
	end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and not J.IsDisabled(enemyHero)
            and bot:WasRecentlyDamagedByHero(enemyHero, 3.0)
            then
                local distance = GetUnitToUnitDistance(bot, enemyHero)
                return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(enemyHero:GetLocation(), bot:GetLocation(), Min(distance, nRadius * 0.75))
            end
        end
    end

    local nEnemyCreeps = bot:GetNearbyCreeps(Min(nCastRange + 300, 1600), true)

    if J.IsPushing(bot) and bAttacking and fManaAfter > fManaThreshold1 and #nAllyHeroes <= 3 and #nEnemyHeroes == 0 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) then
                local nStacks = J.GetModifierCount(creep, 'modifier_batrider_sticky_napalm')
                if nStacks >= 4 then
                    local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                    if (nLocationAoE.count >= 3) then
                        return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                    end
                end
            end
        end
    end

    if J.IsDefending(bot) and bAttacking and fManaAfter > fManaThreshold1 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) then
                local nStacks = J.GetModifierCount(creep, 'modifier_batrider_sticky_napalm')
                if nStacks >= 4 then
                    local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                    if (nLocationAoE.count >= 3) then
                        return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                    end
                end
            end
        end

        local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
        if nLocationAoE.count >= 2 and not J.IsRealInvisible(bot) then
            return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
        end
    end

    if J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold1 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) then
                local nStacks = J.GetModifierCount(creep, 'modifier_batrider_sticky_napalm')
                if nStacks >= 4 then
                    local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                    if (nLocationAoE.count >= 2)
                    or (nLocationAoE.count >= 1 and creep:GetHealth() >= 500)
                    then
                        return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                    end
                end
            end
        end
    end

    if J.IsLaning(bot) and J.IsInLaningPhase() and fManaAfter > fManaThreshold1 then
		for _, creep in pairs(nEnemyCreeps) do
			if  J.IsValid(creep)
            and J.CanBeAttacked(creep)
            and not J.IsRunning(creep)
            and not J.IsOtherAllysTarget(creep)
			then
                local eta = (GetUnitToUnitDistance(bot, creep) / nSpeed) + nCastPoint
                if J.WillKillTarget(creep, nDamage, DAMAGE_TYPE_MAGICAL, eta) then
                    local sCreepName = creep:GetUnitName()
                    local nLocationAoE = bot:FindAoELocation(true, true, creep:GetLocation(), 0, nRadius, 0, 0)
                    if string.find(sCreepName, 'ranged') then
                        if nLocationAoE.count > 0 or J.IsUnitTargetedByTower(creep, false) or J.IsEnemyTargetUnit(creep, 900) then
                            return BOT_ACTION_DESIRE_HIGH, creep:GetLocation()
                        end
                    end

                    nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, nDamage)
                    if nLocationAoE.count >= 2 and (J.IsCore(bot) or not J.IsThereCoreInLocation(nLocationAoE.targetloc, 600)) then
                        return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                    end
                end
			end
		end
	end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderFirefly()
	if not J.CanCastAbility(Firefly) then
        return BOT_ACTION_DESIRE_NONE
    end

    local nRadius = Firefly:GetSpecialValueInt('radius')
    local nManaCost = Firefly:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {StickyNapalm, Flamebreak, FlamingLasso})

    if J.IsStuck(bot)
    or bot:HasModifier('modifier_batrider_flaming_lasso_self')
    then
        return BOT_ACTION_DESIRE_HIGH
    end

    if J.IsGoingOnSomeone(bot) then
		if  J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
            local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), nRadius)
            if J.IsInRange(bot, botTarget, nRadius + 75) or #nInRangeEnemy > 0 then
                return BOT_ACTION_DESIRE_HIGH
            end
		end
	end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, 800)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and not J.IsDisabled(enemyHero)
            and bot:WasRecentlyDamagedByHero(enemyHero, 3.0)
            then
                if J.IsRunning(bot) then
                    return BOT_ACTION_DESIRE_HIGH
                end
            end
        end
    end

    local nEnemyCreeps = bot:GetNearbyCreeps(Min(nRadius + 150, 1600), true)

    if J.IsPushing(bot) and bAttacking and fManaAfter > fManaThreshold1 and #nAllyHeroes <= 1 and #nEnemyHeroes == 0 and botHP > 0.6 then
        if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
            if (#nEnemyCreeps >= 4) then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    end

    if J.IsDefending(bot) and bAttacking and fManaAfter > fManaThreshold1 and #nEnemyHeroes == 0 and botHP > 0.5 then
        if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
            if (#nEnemyCreeps >= 4) then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    end

    if J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold1 and botHP > 0.5 then
        if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
            if (#nEnemyCreeps >= 3)
            or (#nEnemyCreeps >= 2 and nEnemyCreeps[1]:GetHealth() >= 500)
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderFlamingLasso()
	if not J.CanCastAbility(FlamingLasso) then
        return BOT_ACTION_DESIRE_NONE
    end

    local nCastRange = Max(FlamingLasso:GetCastRange(), bot:GetAttackRange())
    local nDuration = FlamingLasso:GetSpecialValueFloat('duration')

    if J.IsGoingOnSomeone(bot) then
        local hTarget = nil
        local hTargetDamage = 0
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange + 300)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and not J.IsDisabled(enemyHero)
            and not J.IsHaveAegis(enemyHero)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_doom_bringer_doom_aura_enemy')
            and not enemyHero:HasModifier('modifier_legion_commander_duel')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemyHero:HasModifier('modifier_ice_blast')
            and enemyHero:GetHealth() >= 500
            then
                local enemyHeroDamage = enemyHero:GetAttackDamage() * enemyHero:GetAttackSpeed()
                if enemyHeroDamage > hTargetDamage then
                    hTarget = enemyHero
                    hTargetDamage = enemyHeroDamage
                end
            end
        end

        if hTarget then
            if J.IsInTeamFight(bot, 1200) then
                return BOT_ACTION_DESIRE_HIGH, hTarget
            else
                local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), 1200)
                local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1200)
                if not (#nInRangeAlly >= #nInRangeEnemy + 3) then
                    if J.GetTotalEstimatedDamageToTarget(nAllyHeroes, hTarget, nDuration) > hTarget:GetHealth() then
                        return BOT_ACTION_DESIRE_HIGH, hTarget
                    end
                end
            end
        end
	end

    return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderBlinkLasso()
	if J.CanCastAbility(FlamingLasso) and J.CanBlinkDagger(bot) then
        if bot:GetMana() > FlamingLasso:GetManaCost() + 75 then
            return BOT_ACTION_DESIRE_NONE, nil
        end

        if J.IsInTeamFight(bot, 1200) then
            local hTarget = nil
            local hTargetDamage = 0
            for _, enemyHero in pairs(nEnemyHeroes) do
                if  J.IsValidHero(enemyHero)
                and J.CanBeAttacked(enemyHero)
                and J.IsInRange(bot, enemyHero, 1200)
                and not J.IsInRange(bot, enemyHero, bot:GetAttackRange())
                and J.CanCastOnTargetAdvanced(enemyHero)
                and not J.IsDisabled(enemyHero)
                and not J.IsHaveAegis(enemyHero)
                and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
                and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
                and not enemyHero:HasModifier('modifier_doom_bringer_doom_aura_enemy')
                and not enemyHero:HasModifier('modifier_legion_commander_duel')
                and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
                and not enemyHero:HasModifier('modifier_ice_blast')
                and enemyHero:GetHealth() >= 500
                then
                    local enemyHeroDamage = enemyHero:GetAttackDamage() * enemyHero:GetAttackSpeed()
                    local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), 1200)
                    local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1200)

                    if enemyHeroDamage > hTargetDamage and #nInRangeAlly >= #nInRangeEnemy then
                        hTarget = enemyHero
                        hTargetDamage = enemyHeroDamage
                    end
                end
            end

            if hTarget then
                return BOT_ACTION_DESIRE_HIGH, hTarget
            end
        end
    end

	return BOT_ACTION_DESIRE_NONE, nil
end

return X