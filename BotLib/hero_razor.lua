local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_razor'
then

local RI = require(GetScriptDirectory()..'/FunLib/util_role_item')

local sUtility = {}
local sUtilityItem = RI.GetBestUtilityItem(sUtility)

local HeroBuild = {
    ['pos_1'] = {
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
                [1] = {2,1,2,1,2,6,2,3,1,1,6,3,3,3,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_magic_stick",
				"item_quelling_blade",
			
				"item_power_treads",
				"item_magic_wand",
				"item_falcon_blade",
				"item_manta",--
				"item_black_king_bar",--
				"item_aghanims_shard",
				"item_satanic",--
				"item_butterfly",--
				"item_refresher",--
				"item_ultimate_scepter_2",
				"item_moon_shard",
				"item_skadi",--
			},
            ['sell_list'] = {
				"item_quelling_blade", "item_satanic",
				"item_magic_wand", "item_butterfly",
				"item_falcon_blade", "item_refresher",
				"item_power_treads", "item_skadi",
			},
        },
    },
    ['pos_2'] = {
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
                [1] = {2,1,2,1,2,6,2,3,1,1,6,3,3,3,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_magic_stick",
				"item_quelling_blade",
			
				"item_bottle",
				"item_magic_wand",
				"item_power_treads",
				"item_falcon_blade",
				"item_manta",--
				"item_black_king_bar",--
				"item_aghanims_shard",
				"item_satanic",--
				"item_assault",--
				"item_refresher",--
				"item_ultimate_scepter_2",
				"item_moon_shard",
				"item_butterfly",--
			},
            ['sell_list'] = {
				"item_quelling_blade", "item_black_king_bar",
				"item_magic_wand", "item_satanic",
				"item_bottle", "item_assault",
				"item_falcon_blade", "item_refresher",
				"item_power_treads", "item_butterfly",
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
					['t10'] = {10, 0},
				}
            },
            ['ability'] = {
                [1] = {1,2,2,1,1,6,1,3,3,3,6,3,2,2,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_quelling_blade",
				"item_double_circlet",
			
				"item_magic_wand",
				"item_power_treads",
				"item_double_wraith_band",
				"item_blade_mail",
				"item_black_king_bar",--
				"item_shivas_guard",--
				"item_ultimate_scepter",
				"item_aghanims_shard",
				"item_refresher",--
				"item_satanic",--
				"item_ultimate_scepter_2",
				"item_sheepstick",--
				"item_moon_shard",
				"item_swift_blink",--
			},
            ['sell_list'] = {
				"item_quelling_blade", "item_black_king_bar",
				"item_magic_wand", "item_shivas_guard",
				"item_wraith_band", "item_ultimate_scepter",
				"item_wraith_band", "item_refresher",
				"item_blade_mail", "item_sheepstick",
				"item_power_treads", "item_swift_blink",
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

if J.Role.IsPvNMode() or J.Role.IsAllShadow() then X['sBuyList'], X['sSellList'] = { 'PvN_mid' }, {} end

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

local PlasmaField = bot:GetAbilityByName('razor_plasma_field')
local StaticLink = bot:GetAbilityByName('razor_static_link')
local StormSurge = bot:GetAbilityByName('razor_unstable_current')
local EyeOfTheStorm = bot:GetAbilityByName('razor_eye_of_the_storm')

local PlasmaFieldDesire
local StaticLinkDesire, StaticLinkTarget
local EyeOfTheStormDesire

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
	bot = GetBot()

	if J.CanNotUseAbility(bot) then return end

	PlasmaField = bot:GetAbilityByName('razor_plasma_field')
	StaticLink = bot:GetAbilityByName('razor_static_link')
	EyeOfTheStorm = bot:GetAbilityByName('razor_eye_of_the_storm')

	bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	PlasmaFieldDesire = X.ConsiderPlasmaField()
	if PlasmaFieldDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbility(PlasmaField)
		return
	end

	StaticLinkDesire, StaticLinkTarget = X.ConsiderStaticLink()
	if StaticLinkDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnEntity(StaticLink, StaticLinkTarget)
		return
	end

	EyeOfTheStormDesire = X.ConsiderEyeOfTheStorm()
	if EyeOfTheStormDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbility(EyeOfTheStorm)
		return
	end
end

function X.ConsiderPlasmaField()
	if not J.CanCastAbility(PlasmaField) then
		return BOT_ACTION_DESIRE_NONE
	end

	local nRadius = PlasmaField:GetSpecialValueInt('radius')
	local nDamageMin = PlasmaField:GetSpecialValueInt('damage_min')
	local nDamageMax = PlasmaField:GetSpecialValueInt('damage_max')
	local nTotalAbilityTime = PlasmaField:GetSpecialValueInt('total_ability_time')
	local nManaCost = PlasmaField:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {StaticLink, EyeOfTheStorm})
	local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {PlasmaField, StaticLink, EyeOfTheStorm})

	for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemyHero)
		and J.CanBeAttacked(enemyHero)
        and J.IsInRange(bot, enemyHero, nRadius)
        and J.CanCastOnNonMagicImmune(enemyHero)
        then
			local dist = GetUnitToUnitDistance(bot, enemyHero)
			local eta = RemapValClamped(dist, 0, nRadius, 0, nTotalAbilityTime / 2)
			local nDamage = RemapValClamped(dist, 0, nRadius, nDamageMin, nDamageMax)

            if J.WillKillTarget(enemyHero, nDamage * 2, DAMAGE_TYPE_MAGICAL, eta)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
            and not enemyHero:HasModifier('modifier_troll_warlord_battle_trance')
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero
            end

			if  fManaAfter > fManaThreshold1
			and enemyHero:HasModifier('modifier_flask_healing')
			and J.GetModifierTime(enemyHero, 'modifier_flask_healing') > eta
			and J.GetModifierTime(enemyHero, 'modifier_flask_healing') > 3.0
			then
				return BOT_ACTION_DESIRE_HIGH
			end

			if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(3.0) then
				if J.IsChasingTarget(enemyHero, bot)
				or (#nEnemyHeroes > #nAllyHeroes and enemyHero:GetAttackTarget() == bot)
				or (botHP < 0.5)
				then
					return BOT_ACTION_DESIRE_HIGH
				end
			end
        end
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nRadius)
		and J.CanCastOnNonMagicImmune(botTarget)
		and not J.IsDisabled(botTarget)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
		and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	local nEnemyCreeps = bot:GetNearbyCreeps(nRadius, true)

	if J.IsPushing(bot) and bAttacking and fManaAfter > fManaThreshold2 and #nAllyHeroes <= 3 then
		local nCanKillCount = 0
		local nCanHurtCount = 0
		for _, creep in pairs(nEnemyCreeps) do
			if J.IsValid(creep) and J.CanBeAttacked(creep) then
				nCanHurtCount = nCanHurtCount + 1
				local dist = GetUnitToUnitDistance(bot, creep)
				local nDamage = RemapValClamped(dist, 0, nRadius, nDamageMin, nDamageMax)
				if J.CanKillTarget(creep, nDamage * 2, DAMAGE_TYPE_MAGICAL) then
					nCanKillCount = nCanKillCount + 1
				end
			end
		end

		if nCanKillCount >= 3 or nCanHurtCount >= 5 then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsDefending(bot) and bAttacking and fManaAfter > fManaThreshold1 then
		local nCanKillCount = 0
		local nCanHurtCount = 0
		for _, creep in pairs(nEnemyCreeps) do
			if J.IsValid(creep) and J.CanBeAttacked(creep) then
				nCanHurtCount = nCanHurtCount + 1
				local dist = GetUnitToUnitDistance(bot, creep)
				local nDamage = RemapValClamped(dist, 0, nRadius, nDamageMin, nDamageMax)
				if J.CanKillTarget(creep, nDamage * 2, DAMAGE_TYPE_MAGICAL) then
					nCanKillCount = nCanKillCount + 1
				end
			end
		end

		if nCanKillCount >= 3 or nCanHurtCount >= 5 then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold1 then
		if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
			if (#nEnemyCreeps >= 3)
			or (#nEnemyCreeps >= 2 and nEnemyCreeps[1]:IsAncientCreep())
			then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if J.IsLaning(bot) and J.IsInLaningPhase() and (J.IsCore(bot) or not J.IsThereCoreNearby(800)) and fManaAfter > fManaThreshold1 then
		local nCanKillMeleeCount = 0
		local nCanKillRangedCount = 0
		for _, creep in pairs(nEnemyCreeps) do
			if J.IsValid(creep) and J.CanBeAttacked(creep) then
				local dist = GetUnitToUnitDistance( bot, creep )
				local nDamage = RemapValClamped(dist, 0, nRadius, nDamageMin, nDamageMax)
				if J.CanKillTarget(creep, nDamage * 2, DAMAGE_TYPE_MAGICAL) then
					if J.IsKeyWordUnit('ranged', creep) then
						nCanKillRangedCount = nCanKillRangedCount + 1
						local nLocationAoE = bot:FindAoELocation(true, true, creep:GetLocation(), 0, 550, 0, 0)
						if nLocationAoE.count > 0 or J.IsUnitTargetedByTower(creep, false) then
							return BOT_ACTION_DESIRE_HIGH
						end
					end

					nCanKillMeleeCount = nCanKillMeleeCount + 1
				end
			end
		end

		if (nCanKillMeleeCount + nCanKillRangedCount >= 3)
		or (nCanKillRangedCount >= 1 and nCanKillMeleeCount >= 1)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsDoingRoshan(bot) then
		if J.IsRoshan(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nRadius)
		and bAttacking
		and fManaAfter > fManaThreshold1
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

    if J.IsDoingTormentor(bot) then
		if J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        and bAttacking
		and fManaAfter > fManaThreshold1
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	return BOT_ACTION_DESIRE_NONE
end


function X.ConsiderStaticLink()
	if not J.CanCastAbility(StaticLink) then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = J.GetProperCastRange(false, bot, StaticLink:GetCastRange())
	local nManaCost = StaticLink:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {PlasmaField, EyeOfTheStorm})
	local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {PlasmaField, StaticLink, EyeOfTheStorm})

	if J.IsGoingOnSomeone(bot) then
		local hTarget = nil
		local hTargetScore = 0
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange)
			and J.CanCastOnTargetAdvanced(enemyHero)
			and not enemyHero:HasModifier('modifier_razor_static_link_debuff')
			then
				local enemyHeroScore = enemyHero:GetAttackDamage() * enemyHero:GetAttackSpeed()
				if enemyHeroScore > hTargetScore then
					hTarget = enemyHero
					hTargetScore = enemyHeroScore
				end
			end
		end

		if hTarget and J.IsInRange(bot, hTarget, nCastRange * 0.8) then
			return BOT_ACTION_DESIRE_HIGH, hTarget
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and J.CanCastOnTargetAdvanced(enemyHero)
			and not enemyHero:HasModifier('modifier_razor_static_link_debuff')
			and bot:WasRecentlyDamagedByHero(enemyHero, 3.0)
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
			end
		end
	end

	if J.IsLaning(bot) and J.IsInLaningPhase() and fManaAfter > fManaThreshold1 then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange / 2)
			and J.CanCastOnTargetAdvanced(enemyHero)
			and not enemyHero:HasModifier('modifier_razor_static_link_debuff')
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderEyeOfTheStorm()
	if not J.CanCastAbility(EyeOfTheStorm) then
		return BOT_ACTION_DESIRE_NONE
	end

	local nRadius = EyeOfTheStorm:GetSpecialValueInt('radius')
	local nManaCost = EyeOfTheStorm:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {PlasmaField, StaticLink})

	if J.IsInTeamFight(bot, 1200) then
		local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), nRadius)
		local count = 0
		for _, enemyHero in pairs(nInRangeEnemy) do
			if J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, nRadius)
			and not enemyHero:IsMagicImmune()
			and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
			and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
			and not enemyHero:HasModifier('modifier_troll_warlord_battle_trance')
			and not enemyHero:HasModifier('modifier_item_blade_mail_reflect')
			then
				count = count + 1
			end
		end

		if count >= 2 then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nRadius)
		and not botTarget:IsMagicImmune()
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
		and not botTarget:HasModifier('modifier_razor_static_link_debuff')
		and not botTarget:HasModifier('modifier_troll_warlord_battle_trance')
		and not botTarget:HasModifier('modifier_item_blade_mail_reflect')
		and bot:WasRecentlyDamagedByAnyHero(1.0)
		then
			local nInRangeAlly = J.GetEnemiesNearLoc(bot:GetLocation(), 800)
			local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 800)
			if not (#nInRangeAlly >= #nInRangeEnemy + 2) and J.IsCore(botTarget) then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if J.IsPushing(bot) and bAttacking and fManaAfter > fManaThreshold1 and bot:HasScepter() and #nEnemyHeroes == 0 and #nAllyHeroes <= 3 then
		if J.IsValidBuilding(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nRadius)
		and J.GetHP(botTarget) > 0.5
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	local nEnemyCreeps = bot:GetNearbyCreeps(nRadius, true)

    if J.IsDefending(bot) and bAttacking and fManaAfter > fManaThreshold1 and #nEnemyHeroes == 0 then
		if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) and not J.IsRunning(nEnemyCreeps[1]) then
			if (#nEnemyCreeps >= 6)
			or (#nEnemyCreeps >= 4 and string.find(nEnemyCreeps[1]:GetUnitName(), 'upgraded') and #nAllyHeroes <= 3)
			then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
    end

    if J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold1 and #nEnemyHeroes == 0 and not J.IsLateGame() then
		if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) and not J.IsRunning(nEnemyCreeps[1]) then
			if (#nEnemyCreeps >= 5)
			or (#nEnemyCreeps >= 3 and nEnemyCreeps[1]:IsAncientCreep())
			then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
    end

	if J.IsDoingRoshan(bot) then
		if J.IsRoshan(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nRadius)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.GetHP(botTarget) > 0.4
		and not J.IsLateGame()
		and bAttacking
		and fManaAfter > fManaThreshold1
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsDoingTormentor(bot) then
		if J.IsTormentor(botTarget)
		and J.IsInRange(bot, botTarget, nRadius)
		and not J.IsLateGame()
		and bAttacking
		and fManaAfter > fManaThreshold1
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	return BOT_ACTION_DESIRE_NONE
end


return X

