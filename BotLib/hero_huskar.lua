local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_huskar'
then

local RI = require(GetScriptDirectory()..'/FunLib/util_role_item')

local sUtility = {"item_crimson_guard", "item_pipe"}
local sUtilityItem = RI.GetBestUtilityItem(sUtility)

local HeroBuild = {
    ['pos_1'] = {
        [1] = {
            ['talent'] = {
				[1] = {
					['t25'] = {0, 10},
					['t20'] = {0, 10},
					['t15'] = {10, 0},
					['t10'] = {0, 10},
				},
            },
            ['ability'] = {
				[1] = {2,3,3,2,3,6,3,1,2,2,1,6,1,1,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_faerie_fire",
				"item_double_gauntlets",
				"item_double_branches",
			
				"item_magic_wand",
				"item_boots",
				"item_armlet",
				"item_phase_boots",
				"item_sange_and_yasha",--
				"item_black_king_bar",--
				"item_ultimate_scepter",
				"item_satanic",--
				"item_aghanims_shard",
				"item_assault",--
				"item_ultimate_scepter_2",
				"item_hurricane_pike",--
				"item_moon_shard",
				"item_travel_boots_2",--
			},
            ['sell_list'] = {
				"item_gauntlets", "item_black_king_bar",
				"item_gauntlets", "item_ultimate_scepter",
				"item_magic_wand", "item_satanic",
				"item_armlet", "item_hurricane_pike",
			},
        },
    },
    ['pos_2'] = {
        [1] = {
            ['talent'] = {
				[1] = {
					['t25'] = {10, 0},
					['t20'] = {0, 10},
					['t15'] = {10, 0},
					['t10'] = {0, 10},
				},
				[2] = {
					['t25'] = {10, 0},
					['t20'] = {0, 10},
					['t15'] = {0, 10},
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
				[1] = {2,3,3,2,3,6,3,1,2,2,1,6,1,1,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_faerie_fire",
				"item_double_gauntlets",
			
				"item_boots",
				"item_armlet",
				"item_phase_boots",
				"item_sange",
				"item_black_king_bar",--
				"item_sange_and_yasha",--
				"item_ultimate_scepter",
				"item_satanic",--
				"item_aghanims_shard",
				"item_assault",--
				"item_ultimate_scepter_2",
				"item_hurricane_pike",--
				"item_moon_shard",
				"item_travel_boots_2",--
			},
            ['sell_list'] = {
				"item_gauntlets", "item_ultimate_scepter",
				"item_gauntlets", "item_satanic",
				"item_armlet", "item_hurricane_pike",
			},
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
				[1] = {1,3,2,2,3,6,3,3,2,2,1,6,1,1,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_faerie_fire",
				"item_double_gauntlets",
				"item_double_branches",
			
				"item_magic_wand",
				"item_double_bracer",
				"item_boots",
				"item_armlet",
				"item_phase_boots",
				"item_sange",
				"item_crimson_guard",--
				"item_black_king_bar",--
				"item_sange_and_yasha",--
				"item_ultimate_scepter",
				"item_assault",--
				"item_ultimate_scepter_2",
				"item_aghanims_shard",
				"item_satanic",--
				"item_moon_shard",
				"item_travel_boots_2",--
			},
            ['sell_list'] = {
				"item_magic_wand", "item_crimson_guard",
				"item_bracer", "item_black_king_bar",
				"item_bracer", "item_ultimate_scepter",
				"item_armlet", "item_travel_boots_2",
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

if J.Role.IsPvNMode() or J.Role.IsAllShadow() then X['sBuyList'], X['sSellList'] = { 'PvN_huskar' }, {} end

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

local InnerFire = bot:GetAbilityByName('huskar_inner_fire')
local BurningSpear = bot:GetAbilityByName('huskar_burning_spear')
local BerserkersBlood = bot:GetAbilityByName('huskar_berserkers_blood')
local LifeBreak = bot:GetAbilityByName('huskar_life_break')

local InnerFireDesire
local BurningSpearDesire, BurningSpearTarget
local BerserkersBloodDesire
local LifeBreakDesire, LifeBreakTarget

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
	bot = GetBot()

	if J.CanNotUseAbility(bot) then return end

	InnerFire = bot:GetAbilityByName('huskar_inner_fire')
	BurningSpear = bot:GetAbilityByName('huskar_burning_spear')
	BerserkersBlood = bot:GetAbilityByName('huskar_berserkers_blood')
	LifeBreak = bot:GetAbilityByName('huskar_life_break')

	bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	InnerFireDesire = X.ConsiderInnerFire()
	if InnerFireDesire > 0 then
		bot:Action_UseAbility(InnerFire)
		return
	end

	LifeBreakDesire, LifeBreakTarget = X.ConsiderLifeBreak()
	if LifeBreakDesire > 0 then
		bot:Action_UseAbilityOnEntity(LifeBreak, LifeBreakTarget)
		return
	end

	BurningSpearDesire, BurningSpearTarget = X.ConsiderBurningSpear()
	if BurningSpearDesire > 0 then
		bot:Action_UseAbilityOnEntity(BurningSpear, BurningSpearTarget)
		return
	end

	BerserkersBloodDesire = X.ConsiderBerserkersBlood()
	if BerserkersBloodDesire > 0 then
		bot:Action_UseAbility(BerserkersBlood)
		return
	end
end

function X.ConsiderInnerFire()
	if not J.CanCastAbility(InnerFire) then
		return BOT_ACTION_DESIRE_NONE
	end

	local fCastPoint = InnerFire:GetCastPoint()
	local nDamage = InnerFire:GetSpecialValueInt('damage')
	local nRadius = InnerFire:GetSpecialValueInt('radius')
	local nHealthCost = math.floor(InnerFire:GetSpecialValueInt('health_cost') * (1 - bot:GetMagicResist()))
	local fHealthAfter = J.GetHealthAfter(nHealthCost)

	local nAllyTowers = bot:GetNearbyTowers(1600, false)

	local nCanHurtCount = 0
	for _, enemyHero in pairs(nEnemyHeroes) do
		if J.IsValidHero(enemyHero)
		and J.IsInRange(bot, enemyHero, nRadius - 50)
		and J.CanBeAttacked(enemyHero)
		and J.CanCastOnNonMagicImmune(enemyHero)
		and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			nCanHurtCount = nCanHurtCount + 1

			if J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL, fCastPoint)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			then
				return BOT_ACTION_DESIRE_HIGH
			end

			if J.IsInLaningPhase(bot) and not J.IsRetreating(bot) then
				if J.IsValidBuilding(nAllyTowers[1])
				and nAllyTowers[1]:GetAttackTarget() == nil
				and J.IsInRange(nAllyTowers[1], enemyHero, 850)
				and not J.IsInRange(nAllyTowers[1], enemyHero, 700)
				and GetUnitToUnitDistance(bot, nAllyTowers[1]) > GetUnitToUnitDistance(enemyHero, nAllyTowers[1])
				then
					if (enemyHero:GetActualIncomingDamage(nAllyTowers[1]:GetAttackTarget() * 3, DAMAGE_TYPE_PHYSICAL) / enemyHero:GetHealth()) > 0.3 then
						return BOT_ACTION_DESIRE_HIGH
					end
				end
			end

			if nCanHurtCount >= 2 then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nRadius - 30)
		and J.IsAttacking(botTarget)
		and J.CanCastOnNonMagicImmune(botTarget)
		and not J.IsDisabled(botTarget)
		and not botTarget:IsDisarmed()
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		and (not J.IsChasingTarget(bot, botTarget) or J.IsInRange(bot, botTarget, nRadius * 0.5))
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(4.0) then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.IsInRange(bot, enemyHero, nRadius - 50)
			and J.CanBeAttacked(enemyHero)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			and not J.IsDisabled(enemyHero)
			and not enemyHero:IsDisarmed()
			then
				if J.IsChasingTarget(enemyHero, bot)
				or (enemyHero:GetAttackTarget() == bot)
				or (#nEnemyHeroes > #nAllyHeroes and #nEnemyHeroes >= 2)
				then
					return BOT_ACTION_DESIRE_HIGH
				end

				local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), nRadius)
				if #nInRangeEnemy >= 2 and J.IsAttacking(enemyHero) then
					return BOT_ACTION_DESIRE_HIGH
				end
			end
		end
	end

	local nEnemyCreeps = bot:GetNearbyCreeps(nRadius, true)

	if J.IsPushing(bot) and #nAllyHeroes <= 2 and fHealthAfter > 0.25 then
		if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
			nCanHurtCount = 0
			local nCanKillCount = 0
			for _, creep in pairs(nEnemyCreeps) do
				if J.IsValid(creep) and J.CanBeAttacked(creep) then
					nCanHurtCount = nCanHurtCount + 1
					if J.WillKillTarget(creep, nDamage, DAMAGE_TYPE_MAGICAL, fCastPoint) then
						nCanKillCount = nCanKillCount + 1
					end
				end
			end

			if nCanKillCount >= 2 then
				return BOT_ACTION_DESIRE_HIGH
			end

			if nCanHurtCount >= 4 and bAttacking then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if J.IsDefending(bot) and fHealthAfter > 0.3 then
		if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
			nCanHurtCount = 0
			local nCanKillCount = 0
			for _, creep in pairs(nEnemyCreeps) do
				if J.IsValid(creep) and J.CanBeAttacked(creep) then
					nCanHurtCount = nCanHurtCount + 1
					if J.WillKillTarget(creep, nDamage, DAMAGE_TYPE_MAGICAL, fCastPoint) then
						nCanKillCount = nCanKillCount + 1
					end
				end
			end

			if nCanKillCount >= 2 then
				return BOT_ACTION_DESIRE_HIGH
			end

			if nCanHurtCount >= 4 and bAttacking then
				return BOT_ACTION_DESIRE_HIGH
			end
		end

		local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), 0, nRadius, 0, 0)
		local nInRangeEnemy = J.GetAlliesNearLoc(bot:GetLocation(), 1600)
		if #nInRangeEnemy == 0 and nLocationAoE.count >= 2 and bAttacking then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsFarming(bot) and fHealthAfter > 0.2 and bAttacking then
		if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
			if (#nEnemyCreeps >= 2)
			or (#nEnemyCreeps >= 1 and nEnemyCreeps[1]:IsAncientCreep())
			then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if J.IsLaning(bot) and J.IsInLaningPhase() then
		local nCanKillCount = 0
		for _, creep in pairs(nEnemyCreeps) do
			if J.IsValid(creep)
			and J.CanBeAttacked(creep)
			and J.WillKillTarget(creep, nDamage, DAMAGE_TYPE_MAGICAL, fCastPoint)
			then
				nCanKillCount = nCanKillCount + 1
			end
		end

		if nCanKillCount >= 2 then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if fHealthAfter > 0.25 and #nEnemyHeroes == 0 then
		if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
			local nLocationAoE = bot:FindAoELocation(true, false, bot:GetLocation(), 0, 0, fCastPoint, nDamage)
			if nLocationAoE.count >= 3 then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if J.IsDoingRoshan(bot) then
		if J.IsRoshan(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nRadius)
        and fHealthAfter > 0.3
        and bAttacking
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

    if J.IsDoingTormentor(bot) then
		if J.IsTormentor(botTarget)
		and J.IsInRange(bot, botTarget, nRadius)
        and fHealthAfter > 0.3
        and bAttacking
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderBurningSpear()
	if not J.CanCastAbility(BurningSpear)
	or bot:IsDisarmed()
	then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = bot:GetAttackRange() + 50
	local nDamage = BurningSpear:GetSpecialValueInt('burn_damage')
	local nDuration = BurningSpear:GetSpecialValueInt('duration')
	local nAttackDamage = bot:GetAttackDamage()
	local bIsAutoCasted = BurningSpear:GetAutoCastState()

	for _, enemyHero in pairs(nEnemyHeroes) do
		if J.IsValidHero(enemyHero)
		and J.CanBeAttacked(enemyHero)
		and J.IsInRange(bot, enemyHero, nCastRange)
		and J.CanCastOnNonMagicImmune(enemyHero)
		and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
		and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
		and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
		then
			if J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL, nDuration) then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
			end
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if #nEnemyHeroes > 0 then
			if not bIsAutoCasted then
				BurningSpear:ToggleAutoCast()
			end
			return BOT_ACTION_DESIRE_NONE, nil
		end
	end

	if (J.IsPushing(bot) or J.IsDefending(bot) or J.IsFarming(bot)) then
		if J.IsValid(botTarget) and J.CanBeAttacked(botTarget) and not botTarget:IsBuilding() then
			if not bIsAutoCasted then
				BurningSpear:ToggleAutoCast()
			end
			return BOT_ACTION_DESIRE_NONE, nil
		end
	end

	local nEnemyTowers = bot:GetNearbyTowers(800, true)

	if J.IsLaning(bot) and J.IsInLaningPhase() and #nEnemyTowers == 0 and botHP > 0.4 then
		local nEnemyCreeps = bot:GetNearbyCreeps(nCastRange, true)
		for _, creep in pairs(nEnemyCreeps) do
			if J.IsValid(creep)
			and J.CanBeAttacked(creep)
			and not J.IsAllysTarget(creep)
			and not creep:HasModifier('modifier_huskar_burning_spear_self')
			then
				if J.CanKillTarget(creep, nAttackDamage + nDamage, DAMAGE_TYPE_PHYSICAL) then
					return BOT_ACTION_DESIRE_HIGH, creep
				end

				if J.WillKillTarget(creep, nDamage, DAMAGE_TYPE_MAGICAL, nDuration * 0.5) then
					return BOT_ACTION_DESIRE_HIGH, creep
				end
			end
		end
	end

	if not J.IsRetreating(bot) and not J.IsRealInvisible(bot) and #nAllyHeroes >= #nEnemyHeroes then
		local hTarget = J.GetAttackableWeakestUnit(bot, nCastRange, true, true)
		if J.IsValidHero(hTarget) then
			return BOT_ACTION_DESIRE_HIGH, hTarget
		end
	end

	if J.IsDoingRoshan(bot) then
		if J.IsRoshan(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and botHP > 0.25
		then
			if not bIsAutoCasted then
				BurningSpear:ToggleAutoCast()
			end
			return BOT_ACTION_DESIRE_NONE, nil
		end
	end

    if J.IsDoingTormentor(bot) then
		if J.IsTormentor(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and botHP > 0.25
		then
			if not bIsAutoCasted then
				BurningSpear:ToggleAutoCast()
			end
			return BOT_ACTION_DESIRE_NONE, nil
		end
	end

	if bIsAutoCasted then
		BurningSpear:ToggleAutoCast()
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderBerserkersBlood()
	if not J.CanCastAbility(BerserkersBlood) then
		return BOT_ACTION_DESIRE_NONE
	end

	local nActivationCost = math.floor(bot:GetHealth() * 0.30 * (1 - bot:GetMagicResist()))
	local nHealthAfter = J.GetHealthAfter(nActivationCost)

	if nHealthAfter > 0.2 then
		if bot:IsRooted()
		or bot:IsDisarmed()
		or (bot:IsSilenced() and not bot:HasModifier('modifier_item_mask_of_madness_berserk'))
		or bot:HasModifier('modifier_item_spirit_vessel_damage')
		or bot:HasModifier('modifier_dragonknight_breathefire_reduction')
		or bot:HasModifier('modifier_slardar_amplify_damage')
		or bot:HasModifier('modifier_item_dustofappearance')
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderLifeBreak()
	if not J.CanCastAbility(LifeBreak) then return 0 end

	local nCastRange = J.GetProperCastRange(false, bot, LifeBreak:GetCastRange())
	local bWeAreStronger = J.WeAreStronger(bot, 1200)

	if J.IsGoingOnSomeone(bot) then
        if bot:HasScepter() then
            for _, enemyHero in pairs(nEnemyHeroes) do
                if J.IsValidHero(enemyHero)
				and J.CanBeAttacked(enemyHero)
                and J.IsInRange(bot, enemyHero, nCastRange + 150)
                and enemyHero:GetUnitName() == 'npc_dota_hero_bristleback'
                and J.CanCastOnNonMagicImmune(enemyHero)
                and J.CanCastOnTargetAdvanced(enemyHero)
                and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
                and not enemyHero:HasModifier('modifier_legion_commander_duel')
                and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
                then
                    local nInRangeAlly = J.GetAlliesNearLoc(enemyHero:GetLocation(), 1200)
					local nInRangeEnemy = J.GetEnemiesNearLoc(enemyHero:GetLocation(), 1200)
					if #nInRangeAlly >= #nInRangeEnemy or bWeAreStronger then
						return BOT_ACTION_DESIRE_HIGH, enemyHero
					end
                end
            end
        end

		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.CanCastOnTargetAdvanced(botTarget)
		and (J.IsInRange(bot, botTarget, nCastRange + 150) or J.IsInRange(bot, botTarget, bot:GetAttackRange() + 150))
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
		and not botTarget:HasModifier('modifier_legion_commander_duel')
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			local nInRangeAlly = J.GetAlliesNearLoc(botTarget:GetLocation(), 1200)
			local nInRangeEnemy = J.GetEnemiesNearLoc(botTarget:GetLocation(), 1200)
			if #nInRangeAlly >= #nInRangeEnemy or bWeAreStronger then
				return BOT_ACTION_DESIRE_HIGH, botTarget
			end
		end
	end

	if not J.IsInLaningPhase() and bot:GetLevel() >= 12 and #nEnemyHeroes <= 1 and #nAllyHeroes <= 3 then
		if J.IsValid(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and not J.IsInRange(bot, botTarget, nCastRange - 150)
		and J.GetHP(botTarget) > 0.8
		and not botTarget:IsHero()
		and not J.IsRoshan(botTarget)
		and not J.IsTormentor(botTarget)
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

return X