local X = {}
local bDebugMode = ( 1 == 10 )
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_axe'
then

local RI = require(GetScriptDirectory()..'/FunLib/util_role_item')

local sUtility = {"item_pipe", "item_lotus_orb", "item_heavens_halberd"}
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
					['t20'] = {0, 10},
					['t15'] = {10, 0},
					['t10'] = {10, 0},
				},
            },
            ['ability'] = {
                [1] = {2,3,3,1,3,6,3,1,1,1,6,2,2,2,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_magic_stick",
				"item_quelling_blade",
	
                "item_bottle",
				"item_magic_wand",
				"item_double_bracer",
				"item_phase_boots",
				"item_blade_mail",
				"item_blink",
				"item_black_king_bar",--
				"item_aghanims_shard",
                "item_octarine_core",--
				"item_shivas_guard",--
				"item_overwhelming_blink",--
				"item_wind_waker",--
				"item_ultimate_scepter_2",
				"item_moon_shard",
				"item_travel_boots_2",--
			},
            ['sell_list'] = {
				"item_quelling_blade", "item_blade_mail",
				"item_magic_wand", "item_blink",
				"item_bracer", "item_black_king_bar",
				"item_bracer", "item_octarine_core",
				"item_bottle", "item_shivas_guard",
				"item_blade_mail", "item_wind_waker",
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
					['t10'] = {0, 10},
				},
                [2] = {
					['t25'] = {0, 10},
					['t20'] = {0, 10},
					['t15'] = {10, 0},
					['t10'] = {10, 0},
				},
            },
            ['ability'] = {
                [1] = {2,3,3,1,3,6,3,1,1,1,6,2,2,2,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_magic_stick",
				"item_quelling_blade",
	
				"item_bracer",
				"item_phase_boots",
				"item_magic_wand",
				"item_blade_mail",
				"item_blink",
                "item_crimson_guard",--
				"item_black_king_bar",--
				"item_aghanims_shard",
				sUtilityItem,--
				"item_overwhelming_blink",--
				"item_octarine_core",--
				"item_ultimate_scepter_2",
				"item_moon_shard",
				"item_travel_boots_2",--
			},
            ['sell_list'] = {
				"item_quelling_blade", "item_crimson_guard",
				"item_magic_wand", "item_black_king_bar",
				"item_bracer", sUtilityItem,
				"item_blade_mail", "item_octarine_core",
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


if J.Role.IsPvNMode() or J.Role.IsAllShadow() then X['sBuyList'], X['sSellList'] = { 'PvN_tank' }, {"item_heavens_halberd", 'item_quelling_blade'} end

nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] = J.SetUserHeroInit( nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] )

X['sSkillList'] = J.Skill.GetSkillList( sAbilityList, nAbilityBuildList, sTalentList, nTalentBuildList )

X['bDeafaultAbility'] = false
X['bDeafaultItem'] = false

function X.MinionThink( hMinionUnit )

	if Minion.IsValidUnit( hMinionUnit )
	then
		Minion.IllusionThink( hMinionUnit )
	end

end

end

local BerserkersCall    = bot:GetAbilityByName('axe_berserkers_call')
local BattleHunger      = bot:GetAbilityByName('axe_battle_hunger')
local CullingBlade      = bot:GetAbilityByName('axe_culling_blade')

local BerserkersCallDesire
local BattleHungerDesire, BattleHungerTarget
local CullingBladeDesire, CullingBladeTarget

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
	bot = GetBot()

	if J.CanNotUseAbility(bot) then return end

    BerserkersCall    = bot:GetAbilityByName('axe_berserkers_call')
    BattleHunger      = bot:GetAbilityByName('axe_battle_hunger')
    CullingBlade      = bot:GetAbilityByName('axe_culling_blade')

	bAttacking = J.IsAttacking(bot)
	botTarget = J.GetProperTarget(bot)
	botHP = J.GetHP(bot)
	nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
	nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    CullingBladeDesire, CullingBladeTarget = X.ConsiderCullingBlade()
    if CullingBladeDesire > 0 then
        bot:Action_UseAbilityOnEntity(CullingBlade, CullingBladeTarget)
        return
    end

    BerserkersCallDesire = X.ConsiderBerserkersCall()
    if BerserkersCallDesire > 0 then
		local BladeMail = J.IsItemAvailable('item_blade_mail')
		if J.CanCastAbility(BladeMail) and (bot:GetMana() > (BladeMail:GetManaCost() + BerserkersCall:GetManaCost() + 100)) then
			J.SetQueuePtToINT(bot, false)
			bot:ActionQueue_UseAbility(BladeMail)
			bot:ActionQueue_UseAbility(BerserkersCall)
			return
		else
			J.SetQueuePtToINT(bot, false)
			bot:ActionQueue_UseAbility(BerserkersCall)
			return
		end
    end

    BattleHungerDesire, BattleHungerTarget = X.ConsiderBattleHunger()
    if BattleHungerDesire > 0 then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(BattleHunger, BattleHungerTarget)
        return
    end
end

function X.ConsiderBerserkersCall()
    if not J.CanCastAbility(BerserkersCall) then
		return BOT_ACTION_DESIRE_NONE
	end

	local nRadius = BerserkersCall:GetSpecialValueInt('radius')
	local nManaCost = BerserkersCall:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {CullingBlade, 75})
	local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {BerserkersCall, BattleHunger, CullingBlade})

	for _, enemyHero in pairs(nEnemyHeroes) do
		if  J.IsValidHero(enemyHero)
		and J.IsInRange(bot, enemyHero, nRadius)
        and enemyHero:IsChanneling()
        and not enemyHero:HasModifier('modifier_legion_commander_duel')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
		and fManaAfter > fManaThreshold1
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nRadius - 75)
        and not J.IsDisabled(botTarget)
		and not botTarget:HasModifier('modifier_legion_commander_duel')
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		and fManaAfter > fManaThreshold1
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	local nEnemyCreeps = bot:GetNearbyCreeps(800, true)

	if J.IsPushing(bot) and fManaAfter > fManaThreshold2 and #nAllyHeroes <= 2 and #nEnemyHeroes == 0 then
		if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
			local nLocationAoE = bot:FindAoELocation(true, false, bot:GetLocation(), 0, nRadius, 0, 0)
			if nLocationAoE.count >= 4 then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if J.IsDefending(bot) and fManaAfter > fManaThreshold2 and #nAllyHeroes <= 1 then
		if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
			local nLocationAoE = bot:FindAoELocation(true, false, bot:GetLocation(), 0, nRadius, 0, 0)
			if nLocationAoE.count >= 4 and #nEnemyHeroes == 0 then
				return BOT_ACTION_DESIRE_HIGH
			end
		end

		local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1600)
		if #nInRangeEnemy == 0 and botHP > 0.65 then
			local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), 0, nRadius, 0, 0)
			if nLocationAoE.count >= 3 then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if J.IsFarming(bot) and fManaAfter > fManaThreshold2 and bAttacking then
		local nLocationAoE = bot:FindAoELocation(true, false, bot:GetLocation(), 0, nRadius, 0, 0)
		if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
			if (nLocationAoE.count >= 3 and not J.IsLateGame())
			or (nLocationAoE.count >= 2 and nEnemyCreeps[1]:IsAncientCreep())
			then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if J.IsDoingRoshan(bot) then
		if  J.IsRoshan(botTarget)
		and J.CanBeAttacked(botTarget)
        and not J.IsDisabled(botTarget)
        and not botTarget:IsDisarmed()
        and J.IsInRange(bot, botTarget, nRadius)
		and bAttacking
		and fManaAfter > fManaThreshold2
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderBattleHunger()
    if not J.CanCastAbility(BattleHunger) then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = J.GetProperCastRange(false, bot, BattleHunger:GetCastRange())
	local nDuration = BattleHunger:GetSpecialValueInt('duration')
	local nDamage = BattleHunger:GetSpecialValueInt('damage_per_second') * nDuration
	local nManaCost = BattleHunger:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {BerserkersCall, BattleHunger, CullingBlade})
	local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {BerserkersCall, CullingBlade})
	local fManaThreshold3 = J.GetManaThreshold(bot, nManaCost, {CullingBlade})

	for _, enemyHero in pairs(nEnemyHeroes) do
		if  J.IsValidHero(enemyHero)
		and J.CanBeAttacked(enemyHero)
		and J.IsInRange(bot, enemyHero, nCastRange)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanCastOnTargetAdvanced(enemyHero)
        and J.WillMagicKillTarget(bot, enemyHero, nDamage, nDuration)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_axe_battle_hunger')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
		and fManaAfter > fManaThreshold2
		then
			return BOT_ACTION_DESIRE_HIGH, enemyHero
		end
	end

	if J.IsInTeamFight(bot, 1200) then
		local hTarget = nil
		local hTargetDamage = 0
		for _, enemyHero in pairs(nEnemyHeroes) do
			if  J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
			and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_axe_battle_hunger')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			then
				local enemyHeroDamage = enemyHero:GetActualIncomingDamage(nDamage * nDuration, DAMAGE_TYPE_PHYSICAL)
				if enemyHeroDamage > hTargetDamage then
					hTargetDamage = enemyHeroDamage
					hTarget = enemyHero
				end
			end
		end

		if hTarget ~= nil and fManaAfter > fManaThreshold3 then
			if fManaAfter > fManaThreshold2 then
				return BOT_ACTION_DESIRE_HIGH, hTarget
			end
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.CanCastOnTargetAdvanced(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
		and not botTarget:HasModifier('modifier_axe_battle_hunger')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		and fManaAfter > fManaThreshold2
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(3.0) then
		local hTarget = nil
		local hTargetDamage = 0
		for _, enemyHero in pairs(nEnemyHeroes) do
			if  J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_axe_battle_hunger')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			then
				local enemyHeroDamage = enemyHero:GetActualIncomingDamage(nDamage * nDuration, DAMAGE_TYPE_PHYSICAL)
				if enemyHeroDamage > hTargetDamage then
					hTargetDamage = enemyHeroDamage
					hTarget = enemyHero
				end
			end
		end

		if hTarget ~= nil then
			return BOT_ACTION_DESIRE_HIGH, hTarget
		end
	end

	if J.IsFarming(bot) and bAttacking then
		local nNeutralCreeps = bot:GetNearbyCreeps(nCastRange, true)
		local hTargetCreep = J.GetMostHpUnit(nNeutralCreeps)

		if J.IsValid(hTargetCreep)
		and J.CanBeAttacked(hTargetCreep)
        and not J.IsRoshan(hTargetCreep)
        and not J.IsTormentor(hTargetCreep)
        and not hTargetCreep:HasModifier('modifier_axe_battle_hunger')
        and not J.CanKillTarget(hTargetCreep, bot:GetAttackDamage() * 3, DAMAGE_TYPE_PHYSICAL)
		and fManaAfter > 0.5
		and fManaAfter > fManaThreshold2
		and not J.IsLateGame()
		then
			return BOT_ACTION_DESIRE_HIGH, hTargetCreep
	    end
	end

	if J.IsDoingRoshan(bot) then
		if  J.IsRoshan(botTarget)
		and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_axe_battle_hunger')
		and fManaAfter > 0.5
		and fManaAfter > fManaThreshold1
		and bAttacking
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

    if J.IsDoingTormentor(bot) then
		if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and not botTarget:HasModifier('modifier_axe_battle_hunger')
		and fManaAfter > 0.5
		and fManaAfter > fManaThreshold1
		and bAttacking
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderCullingBlade()
    if not J.CanCastAbility(CullingBlade) then return BOT_ACTION_DESIRE_NONE, nil end

	local nCastRange = J.GetProperCastRange(false, bot, CullingBlade:GetCastRange())
	local nDamage = CullingBlade:GetSpecialValueInt('damage')

	for _, enemyHero in pairs(nEnemyHeroes) do
		if  J.IsValidHero(enemyHero)
		and J.CanBeAttacked(enemyHero)
		and J.IsInRange(bot, enemyHero, nCastRange + 300)
		and (enemyHero:GetHealth() + enemyHero:GetHealthRegen() * 0.8 < nDamage)
		and J.CanCastOnMagicImmune(enemyHero)
		and J.CanCastOnTargetAdvanced(enemyHero)
        and not J.IsHaveAegis(enemyHero)
		and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
		and not enemyHero:HasModifier('modifier_winter_wyvern_winters_curse')
		and not enemyHero:HasModifier('modifier_winter_wyvern_winters_curse_aura')
		and not enemyHero:HasModifier('modifier_item_aeon_disk_buff')
		then
			return BOT_ACTION_DESIRE_HIGH, enemyHero
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

return X