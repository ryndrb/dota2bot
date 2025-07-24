local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_legion_commander'
then

local RI = require(GetScriptDirectory()..'/FunLib/util_role_item')

local sUtility = {"item_nullifier", "item_heavens_halberd"}
local sUtilityItem = RI.GetBestUtilityItem(sUtility)

local HeroBuild = {
    ['pos_1'] = {
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
                [1] = {1,3,1,2,1,6,1,3,3,3,6,2,2,2,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_quelling_blade",
				"item_circlet",
				"item_gauntlets",
			
				"item_magic_wand",
				"item_phase_boots",
				"item_bracer",
				"item_bfury",--
				"item_blade_mail",
				"item_black_king_bar",--
				"item_blink",
				"item_greater_crit",--
				"item_aghanims_shard",
				"item_overwhelming_blink",--
				"item_bloodthorn",--
				"item_ultimate_scepter_2",
				"item_moon_shard",
				"item_travel_boots_2",--
			},
            ['sell_list'] = {
				"item_magic_wand", "item_blink",
				"item_bracer", "item_greater_crit",
				"item_blade_mail", "item_bloodthorn",
			},
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
					['t20'] = {10, 0},
					['t15'] = {10, 0},
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
                [1] = {1,3,1,2,1,6,1,3,3,3,6,2,2,2,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_quelling_blade",
				"item_circlet",
				"item_gauntlets",
			
				"item_magic_wand",
				"item_bracer",
				"item_phase_boots",
				"item_blade_mail",
				"item_blink",
				"item_crimson_guard",--
				"item_black_king_bar",--
				sUtilityItem,--
				"item_aghanims_shard",
				"item_greater_crit",--
				"item_overwhelming_blink",--
				"item_ultimate_scepter_2",
				"item_moon_shard",
				"item_travel_boots_2",--
			},
            ['sell_list'] = {
				"item_quelling_blade", "item_crimson_guard",
				"item_magic_wand", "item_black_king_bar",
				"item_bracer", sUtilityItem,
				"item_blade_mail", "item_greater_crit",
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

if J.Role.IsPvNMode() or J.Role.IsAllShadow() then X['sBuyList'], X['sSellList'] = { 'PvN_tank' }, {"item_power_treads", 'item_quelling_blade'} end

nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] = J.SetUserHeroInit( nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] )

X['sSkillList'] = J.Skill.GetSkillList( sAbilityList, nAbilityBuildList, sTalentList, nTalentBuildList )

X['bDeafaultAbility'] = false
X['bDeafaultItem'] = false

function X.MinionThink(hMinionUnit)
	Minion.IllusionThink(hMinionUnit)
end

end

local OverwhelmingOdds = bot:GetAbilityByName('legion_commander_overwhelming_odds')
local PressTheAttack = bot:GetAbilityByName('legion_commander_press_the_attack')
local MomentOfCourage = bot:GetAbilityByName('legion_commander_moment_of_courage')
local Duel = bot:GetAbilityByName('legion_commander_duel')

local OverwhelmingOddsDesire
local PressTheAttackDesire, PressTheAttackTarget
local DuelDesire, DuelTarget

local bAttacking = false
local botTarget, botHP, botMaxMana, botManaRegen
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
	bot = GetBot()

	if J.CanNotUseAbility(bot) then return end

	OverwhelmingOdds = bot:GetAbilityByName('legion_commander_overwhelming_odds')
	PressTheAttack = bot:GetAbilityByName('legion_commander_press_the_attack')
	Duel = bot:GetAbilityByName('legion_commander_duel')

	bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
	botMaxMana = bot:GetMaxMana()
	botManaRegen = bot:GetManaRegen()
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	DuelDesire, DuelTarget = X.ConsiderDuel()
	if DuelDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		local BladeMail = J.IsItemAvailable('item_blade_mail')
		if J.CanCastAbility(BladeMail) and (bot:GetMana() > (Duel:GetManaCost() + BladeMail:GetManaCost() + 75)) then
			bot:ActionQueue_UseAbility(BladeMail)
			bot:ActionQueue_UseAbilityOnEntity(Duel, DuelTarget)
			return
		else
			bot:ActionQueue_UseAbilityOnEntity(Duel, DuelTarget)
			return
		end
	end

	OverwhelmingOddsDesire = X.ConsiderOverwhelmingOdds()
	if OverwhelmingOddsDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbility(OverwhelmingOdds)
		return
	end

	PressTheAttackDesire, PressTheAttackTarget = X.ConsiderPressTheAttack()
	if PressTheAttackDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		if J.CheckBitfieldFlag(PressTheAttack:GetBehavior(), ABILITY_BEHAVIOR_POINT) then
			bot:ActionQueue_UseAbilityOnLocation(PressTheAttack, PressTheAttackTarget:GetLocation())
		else
			bot:ActionQueue_UseAbilityOnEntity(PressTheAttack, PressTheAttackTarget)
		end
		return
	end
end


function X.ConsiderOverwhelmingOdds()
	if not J.CanCastAbility(OverwhelmingOdds) then
		return BOT_ACTION_DESIRE_NONE
	end

	local nRadius = OverwhelmingOdds:GetSpecialValueInt('radius')
	local fCastPoint = OverwhelmingOdds:GetCastPoint()
	local nBaseDamage = OverwhelmingOdds:GetSpecialValueInt('damage')
	local nBonusDamageHero = OverwhelmingOdds:GetSpecialValueInt('damage_per_unit')
	local nBonusDamageCreep = OverwhelmingOdds:GetSpecialValueInt('damage_per_hero')
	local nAbilityLevel = OverwhelmingOdds:GetLevel()
	local nDamage = nBaseDamage
	local nManaCost = OverwhelmingOdds:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {OverwhelmingOdds, PressTheAttack, Duel})
	local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {PressTheAttack, Duel})
	local fManaThreshold3 = J.GetManaThreshold(bot, nManaCost, {Duel})

	local nLocationAoE_Heroes = bot:FindAoELocation(true, true, bot:GetLocation(), 0, nRadius, 0, 0)
	local nLocationAoE_Creeps = bot:FindAoELocation(true, false, bot:GetLocation(), 0, nRadius, 0, 0)

	nDamage = nDamage + (nLocationAoE_Heroes.count * nBonusDamageHero) + (nLocationAoE_Creeps.count * nBonusDamageCreep)

	for _, enemyHero in pairs(nEnemyHeroes) do
		if J.IsValidHero(enemyHero)
		and J.CanBeAttacked(enemyHero)
		and J.IsInRange(bot, enemyHero, nRadius - 75)
		and J.CanCastOnNonMagicImmune(enemyHero)
		and J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL, fCastPoint)
		and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
		and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
		and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
		and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsInTeamFight(bot, 1200) then
		local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), nRadius)
		if #nInRangeEnemy >= 2 then
			local count = 0
			for _, enemyHero in pairs(nInRangeEnemy) do
				if J.IsValidHero(enemyHero)
				and J.CanBeAttacked(enemyHero)
				and J.CanCastOnNonMagicImmune(enemyHero)
				and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
				and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
				and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
				then
					count = count + 1
				end
			end

			if count >= 2 and bAttacking then
				if fManaAfter > fManaThreshold3 then
					return BOT_ACTION_DESIRE_HIGH
				end
			end
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nRadius - 75)
		and J.CanCastOnNonMagicImmune(botTarget)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		and bAttacking
		then
			if fManaAfter > fManaThreshold2 then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if J.IsRetreating(bot)
	and not J.IsRealInvisible(bot)
	and not bot:HasModifier('modifier_legion_commander_overwhelming_odds')
	and bot:WasRecentlyDamagedByAnyHero(3.0)
	then
		local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), nRadius)
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, nRadius - 80)
			and J.CanCastOnNonMagicImmune(enemyHero)
			then
				if #nInRangeEnemy >= 2 then
					if J.IsChasingTarget(enemyHero, bot) and botHP < 0.5
					or #nEnemyHeroes > #nAllyHeroes
					or (botHP < 0.5 and enemyHero:GetAttackTarget() == bot)
					then
						return BOT_ACTION_DESIRE_HIGH
					end
				end
			end
		end
	end

	local nEnemyCreeps = bot:GetNearbyCreeps(nRadius, true)

	if not bot:HasModifier('modifier_legion_commander_overwhelming_odds') then
		if J.IsPushing(bot) and #nAllyHeroes <= 2 and #nEnemyHeroes == 0
		and fManaAfter > fManaThreshold1
		and fManaAfter > 0.5
		and bAttacking
		then
			if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
				if #nEnemyCreeps >= 4 then
					return BOT_ACTION_DESIRE_HIGH
				end
			end
		end

		if J.IsDefending(bot)
		and fManaAfter > fManaThreshold2
		and fManaAfter > 0.5
		and bAttacking
		then
			if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
				if #nEnemyCreeps >= 4  then
					return BOT_ACTION_DESIRE_HIGH
				end
			end

			if nLocationAoE_Heroes.count >= 3 then
				return BOT_ACTION_DESIRE_HIGH
			end
		end

		if J.IsFarming(bot) and fManaAfter > fManaThreshold2 and bAttacking and nAbilityLevel >= 3 then
			if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
				if #nEnemyCreeps >= 3
				or (#nEnemyCreeps >= 2 and nEnemyCreeps[1]:IsAncientCreep())
				or (#nEnemyCreeps >= 2 and fManaAfter > 0.65 and nEnemyCreeps[1]:GetHealth() > bot:GetAttackDamage() * 3)
				then
					return BOT_ACTION_DESIRE_HIGH
				end
			end
		end

		if J.IsLaning(bot) and J.IsInLaningPhase() and bAttacking and fManaAfter > 0.5 then
			local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), nRadius)
			if #nInRangeEnemy >= 2 then
				local count = 0
				for _, enemyHero in pairs(nInRangeEnemy) do
					if J.IsValidHero(enemyHero)
					and J.CanBeAttacked(enemyHero)
					and J.CanCastOnNonMagicImmune(enemyHero)
					and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
					and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
					and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
					then
						count = count + 1
					end
				end

				if count >= 2 and bAttacking then
					if fManaAfter > fManaThreshold2 then
						return BOT_ACTION_DESIRE_HIGH
					end
				end
			end
		end

		if fManaAfter > fManaThreshold3 then
			nLocationAoE_Creeps = bot:FindAoELocation(true, false, bot:GetLocation(), 0, nRadius, 0, nDamage)
			if nLocationAoE_Creeps.count >= 4 then
				return BOT_ACTION_DESIRE_HIGH
			end
		end

		if J.IsDoingRoshan(bot) then
			if J.IsRoshan(botTarget)
			and J.CanBeAttacked(botTarget)
			and J.IsInRange(bot, botTarget, nRadius)
			and J.CanCastOnNonMagicImmune(botTarget)
			and fManaAfter > fManaThreshold2
			and fManaAfter > 0.5
			and bAttacking
			then
				return BOT_ACTION_DESIRE_HIGH
			end
		end

		if J.IsDoingTormentor(bot) then
			if J.IsTormetor(botTarget)
			and J.IsInRange(bot, botTarget, nRadius)
			and fManaAfter > fManaThreshold2
			and fManaAfter > 0.5
			and bAttacking
			then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderPressTheAttack()
	if not J.CanCastAbility(PressTheAttack) then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = J.GetProperCastRange(false, bot, PressTheAttack:GetCastRange())
	local nHPRegen = PressTheAttack:GetSpecialValueInt('hp_regen')
	local nDuration = PressTheAttack:GetSpecialValueInt('duration')
	local nManaCost = PressTheAttack:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Duel})

	for _, allyHero in pairs(nAllyHeroes) do
		if J.IsValidHero(allyHero)
		and J.IsInRange(bot, allyHero, nCastRange)
		and J.CanBeAttacked(allyHero)
		and not allyHero:HasModifier('modifier_legion_commander_press_the_attack')
		and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			if J.IsGoingOnSomeone(allyHero) then
				local allyTarget = J.GetProperTarget(allyHero)
				if  J.IsValidHero(allyTarget)
				and J.CanBeAttacked(allyTarget)
				and J.IsInRange(allyHero, allyTarget, allyHero:GetAttackRange() + 300)
				and allyTarget:IsFacingLocation(allyTarget:GetLocation(), 45)
				and not allyTarget:HasModifier('modifier_necrolyte_reapers_scythe')
				then
					if J.IsAttacking(allyHero)
					or J.IsChasingTarget(allyHero, allyTarget)
					or J.GetHP(allyHero) < 0.5
					then
						if fManaAfter > fManaThreshold1 then
							return BOT_ACTION_DESIRE_HIGH, allyHero
						end
					end
				end
			end

			if J.IsRetreating(allyHero)
			and not J.IsRealInvisible(allyHero)
			and J.IsRunning(allyHero)
			and (allyHero:GetMaxHealth() - allyHero:GetHealth() >= (nHPRegen * nDuration))
			and allyHero:WasRecentlyDamagedByAnyHero(5.0)
			and allyHero:IsFacingLocation(J.GetTeamFountain(), 45)
			then
				return BOT_ACTION_DESIRE_HIGH, allyHero
			end

			if J.IsDisabled(allyHero) then
				return BOT_ACTION_DESIRE_HIGH, allyHero
			end

			if J.GetHP(allyHero) < 0.3 then
				if fManaAfter > fManaThreshold1 then
					return BOT_ACTION_DESIRE_HIGH, allyHero
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderDuel()
	if not J.CanCastAbility(Duel) then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = J.GetProperCastRange(false, bot, Duel:GetCastRange())
	local fDuration = Duel:GetSpecialValueInt('duration')
	local bWeAreStronger = J.WeAreStronger(bot, 1200)

	if not J.IsRetreating(bot) and botHP > 0.5 then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange + 400)
			and J.CanCastOnTargetAdvanced(enemyHero)
			and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			then
				local nInRangeAlly = J.GetAlliesNearLoc(enemyHero:GetLocation(), 1200)
				local nInRangeEnemy = J.GetEnemiesNearLoc(enemyHero:GetLocation(), 1200)

				if #nInRangeAlly >= #nInRangeEnemy or bWeAreStronger then
					if enemyHero:IsChanneling() then
						if J.GetHP(enemyHero) < 0.5 or #J.GetHeroesTargetingUnit(nInRangeAlly, enemyHero) >= 3 then
							return BOT_ACTION_DESIRE_HIGH, enemyHero
						end
					end

					local totalDamage = enemyHero:GetActualIncomingDamage(bot:GetAttackDamage() * bot:GetAttackSpeed() * fDuration, DAMAGE_TYPE_PHYSICAL)
					local allyDamage = X.GetAllyToTargetDamage(enemyHero, fDuration, DAMAGE_TYPE_PHYSICAL)
					totalDamage = totalDamage * 1.2 + allyDamage * 0.8 - 100

					if  (totalDamage > enemyHero:GetHealth() + enemyHero:GetHealthRegen() * fDuration)
					and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
					and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
					and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
					and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
					and not enemyHero:HasModifier('modifier_troll_warlord_battle_trance')
					and not enemyHero:HasModifier('modifier_ursa_enrage')
					and not enemyHero:HasModifier('modifier_item_aeon_disk_buff')
					then
						return BOT_ACTION_DESIRE_HIGH, enemyHero
					end
				end
			end
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.CanCastOnTargetAdvanced(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange + 300)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		and not botTarget:HasModifier('modifier_ursa_enrage')
		and not botTarget:HasModifier('modifier_item_aeon_disk_buff')
		then
			local totalDamage = botTarget:GetActualIncomingDamage(bot:GetAttackDamage() * bot:GetAttackSpeed() * fDuration, DAMAGE_TYPE_PHYSICAL)
			local allyDamage = X.GetAllyToTargetDamage(botTarget, fDuration, DAMAGE_TYPE_ALL)
			totalDamage = totalDamage * 1.2 + allyDamage * 0.8 - 100

			if totalDamage > (botTarget:GetHealth() + botTarget:GetHealthRegen() * fDuration) then
				return BOT_ACTION_DESIRE_HIGH, botTarget
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.GetAllyToTargetDamage(hTarget, fDuration, nDamageType)
	local nTotalDamage = 0
	for i = 1, 5 do
		local member = GetTeamMember(i)
		if bot ~= member
		and J.IsValidHero(member)
		and J.IsInRange(member, hTarget, member:GetAttackRange() + 200)
		and member:GetAttackTarget() == hTarget
		then
			nTotalDamage = nTotalDamage + hTarget:GetActualIncomingDamage(member:GetAttackDamage() * member:GetAttackSpeed() * fDuration, DAMAGE_TYPE_PHYSICAL)
		end
	end

	return nTotalDamage
end

return X