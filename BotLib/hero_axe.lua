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

local botTarget

function X.SkillsComplement()
	if J.CanNotUseAbility(bot) then return end

    BerserkersCall    = bot:GetAbilityByName('axe_berserkers_call')
    BattleHunger      = bot:GetAbilityByName('axe_battle_hunger')
    CullingBlade      = bot:GetAbilityByName('axe_culling_blade')

	botTarget = J.GetProperTarget(bot)

    CullingBladeDesire, CullingBladeTarget = X.ConsiderCullingBlade()
    if CullingBladeDesire > 0
    then
        bot:Action_UseAbilityOnEntity(CullingBlade, CullingBladeTarget)
        return
    end

    BerserkersCallDesire = X.ConsiderBerserkersCall()
    if BerserkersCallDesire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(BerserkersCall)

        local BladeMail = J.IsItemAvailable('item_blade_mail')
        if BladeMail ~= nil and BladeMail:IsFullyCastable()
        then
            bot:ActionQueue_Delay(0.3 + 0.5)
            bot:ActionQueue_UseAbility(BladeMail)
        end

        return
    end

    BattleHungerDesire, BattleHungerTarget = X.ConsiderBattleHunger()
    if BattleHungerDesire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(BattleHunger, BattleHungerTarget)
        return
    end
end

function X.ConsiderBerserkersCall()
    if not J.CanCastAbility(BerserkersCall) then return 0 end

    local nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	local nRadius = BerserkersCall:GetSpecialValueInt( 'radius' )
	if bot:GetUnitName() == 'npc_dota_hero_axe'
    then
        local CallRadiusTalent = bot:GetAbilityByName('special_bonus_unique_axe_2')
        if CallRadiusTalent:IsTrained()
        then
            nRadius = nRadius + CallRadiusTalent:GetSpecialValueInt('value')
        end
    end

	local nManaCost = BerserkersCall:GetManaCost()
	local nInRangeEnemyList = J.GetAroundEnemyHeroList(nRadius - 50)

	for _, enemyHero in pairs(nInRangeEnemyList)
	do
		if  J.IsValidHero(enemyHero)
        and enemyHero:IsChanneling()
		and not enemyHero:IsMagicImmune()
        and not enemyHero:HasModifier('modifier_legion_commander_duel')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidHero(botTarget)
        and J.IsInRange(bot, botTarget, nRadius - 75)
        and J.CanCastOnNonMagicImmune(botTarget)
        and not J.IsDisabled(botTarget)
		then
            if  nInRangeEnemyList ~= nil and #nInRangeEnemyList == 1
            and not botTarget:HasModifier('modifier_legion_commander_duel')
            and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
            then
                return BOT_ACTION_DESIRE_HIGH
            else
                return BOT_ACTION_DESIRE_HIGH
            end
		end
	end

	if  (J.IsPushing(bot) or J.IsDefending(bot))
    and J.GetManaAfter(nManaCost) > 0.35
    and bot:GetAttackTarget() ~= nil
    and DotaTime() > 6 * 60
    and nAllyHeroes ~= nil and #nAllyHeroes <= 2
    and nEnemyHeroes ~= nil and #nEnemyHeroes == 0
	then
		local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(nRadius - 50, true)
		if  nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 4
        and J.CanBeAttacked(nEnemyLaneCreeps[1])
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

    if  J.IsFarming(bot)
    and J.GetManaAfter(nManaCost) > 0.75
    and bot:GetAttackTarget() ~= nil
    and nEnemyHeroes ~= nil and #nEnemyHeroes == 0
    then
        local nCreeps = bot:GetNearbyCreeps(nRadius - 50, true)
		if  nCreeps ~= nil and #nCreeps >= 2
        and J.CanBeAttacked(nCreeps[1])
		then
			return BOT_ACTION_DESIRE_HIGH
		end
    end

	if J.IsDoingRoshan(bot)
	then
		if  J.IsRoshan(botTarget)
        and not J.IsDisabled(botTarget)
        and not botTarget:IsDisarmed()
        and J.IsInRange(bot, botTarget, nRadius)
        and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

    if J.IsDoingTormentor(bot)
	then
		if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderBattleHunger()
    if not J.CanCastAbility(BattleHunger) then return BOT_ACTION_DESIRE_NONE, nil end

	local nSkillLV = BattleHunger:GetLevel()
	local nCastRange = J.GetProperCastRange(false, bot, BattleHunger:GetCastRange())
	local nManaCost = BattleHunger:GetManaCost()

	local nDuration = BattleHunger:GetSpecialValueInt('duration')
	local nDamage = BattleHunger:GetSpecialValueInt('damage_per_second') * nDuration

	local nInRangeEnemyList = J.GetAroundEnemyHeroList(nCastRange)
	local nInBonusEnemyList = J.GetAroundEnemyHeroList(nCastRange + 200)

	for _, enemyHero in pairs(nInRangeEnemyList)
	do
		if  J.IsValidHero(enemyHero)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanCastOnTargetAdvanced(enemyHero)
        and J.WillMagicKillTarget(bot, enemyHero, nDamage , nDuration)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_axe_battle_hunger_self')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			return BOT_ACTION_DESIRE_HIGH, enemyHero
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidHero(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.CanCastOnTargetAdvanced(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_axe_battle_hunger_self')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	if J.IsInTeamFight(bot, 1200)
	then
		local npcWeakestEnemy = nil
		local npcWeakestEnemyHealth = 100000

		for _, enemyHero in pairs(nInBonusEnemyList)
		do
			if  J.IsValid(enemyHero)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_axe_battle_hunger_self')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			then
				local npcEnemyHealth = enemyHero:GetHealth()
				if npcEnemyHealth < npcWeakestEnemyHealth
				then
					npcWeakestEnemyHealth = npcEnemyHealth
					npcWeakestEnemy = enemyHero
				end
			end
		end

		if npcWeakestEnemy ~= nil
		then
			return BOT_ACTION_DESIRE_HIGH, npcWeakestEnemy
		end
	end

	if J.IsRetreating(bot)
	then
		for _, enemyHero in pairs(nInRangeEnemyList)
		do
			if  J.IsValidHero(enemyHero)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_axe_battle_hunger_self')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
			end
		end
	end

	if  J.IsFarming(bot)
    and nSkillLV >= 2
    and J.IsAllowedToSpam(bot, nManaCost * 0.25)
	then
		local nNeutralCreeps = bot:GetNearbyNeutralCreeps(nCastRange + 150)
		local nTargetCreep = J.GetMostHpUnit(nNeutralCreeps)

		if  J.IsValid(nTargetCreep)
        and not J.IsRoshan(nTargetCreep)
        and not J.IsTormentor(nTargetCreep)
        and not nTargetCreep:HasModifier( 'modifier_axe_battle_hunger_self' )
        and not J.CanKillTarget(nTargetCreep, bot:GetAttackDamage() * 2.88, DAMAGE_TYPE_PHYSICAL)
        and (nTargetCreep:GetMagicResist() < 0.3 )
		then
			return BOT_ACTION_DESIRE_HIGH, nTargetCreep
	    end
	end

    if J.IsLaning(bot) and nManaCost > 0.5
	then
		for _, enemyHero in pairs(nInRangeEnemyList)
		do
			if  J.IsValid(enemyHero)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and enemyHero:GetAttackTarget() == nil
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_axe_battle_hunger_self')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
			end
		end
	end

	if J.IsDoingRoshan(bot)
	then
		if  J.IsRoshan(botTarget)
        and not J.IsDisabled(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.IsAttacking(bot)
        and not botTarget:HasModifier('modifier_axe_battle_hunger_self')
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

    if J.IsDoingTormentor(bot)
	then
		if  J.IsTormentor(botTarget)
        and not J.IsDisabled(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.IsAttacking(bot)
        and not botTarget:HasModifier('modifier_axe_battle_hunger_self')
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderCullingBlade()
    if not J.CanCastAbility(CullingBlade) then return BOT_ACTION_DESIRE_NONE, nil end

	local nCastRange = CullingBlade:GetCastRange()
	local nKillDamage = CullingBlade:GetSpecialValueInt('damage')

    if bot:GetUnitName() == 'npc_dota_hero_axe'
    then
        CullingBladeDamageTalent = bot:GetAbilityByName('special_bonus_unique_axe_5')
        if CullingBladeDamageTalent:IsTrained()
        then
            nKillDamage = nKillDamage + CullingBladeDamageTalent:GetSpecialValueInt('value')
        end
    end

	local nInBonusEnemyList = J.GetAroundEnemyHeroList(nCastRange + 300)

	for _, enemyHero in pairs(nInBonusEnemyList)
	do
		if  J.IsValidHero(enemyHero)
        and enemyHero:GetHealth() + enemyHero:GetHealthRegen() * 0.8 < nKillDamage
        and not J.IsHaveAegis(enemyHero)
        and not enemyHero:IsInvulnerable()
        and not enemyHero:IsMagicImmune() --V BUG
        and not J.IsSuspiciousIllusion(enemyHero)
        and not X.HasSpecialModifier(enemyHero)
        and not X.IsKillBotAntiMage(enemyHero)
		then
			return BOT_ACTION_DESIRE_HIGH, enemyHero
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.HasSpecialModifier(npcEnemy)
	if npcEnemy:HasModifier('modifier_winter_wyvern_winters_curse')
    or npcEnemy:HasModifier('modifier_winter_wyvern_winters_curse_aura')
    or npcEnemy:HasModifier('modifier_antimage_spell_shield')
    or npcEnemy:HasModifier('modifier_item_lotus_orb_active')
    or npcEnemy:HasModifier('modifier_item_aeon_disk_buff')
    or npcEnemy:HasModifier('modifier_item_sphere_target')
    or npcEnemy:HasModifier('modifier_illusion')
    or npcEnemy:HasModifier('modifier_necrolyte_reapers_scythe')
	then
		return true
	else
		return false
	end
end


function X.IsKillBotAntiMage(npcEnemy)
	if not npcEnemy:IsBot()
    or npcEnemy:GetUnitName() ~= 'npc_dota_hero_antimage'
    or npcEnemy:IsStunned()
    or npcEnemy:IsHexed()
    or npcEnemy:IsNightmared()
    or npcEnemy:IsChanneling()
    or J.IsTaunted(npcEnemy)
	then
		return false
	end

	return true
end

return X