local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_oracle'
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
					['t15'] = {10, 0},
					['t10'] = {10, 0},
				}
            },
            ['ability'] = {
				[1] = {1,3,3,2,3,6,3,2,2,2,1,6,1,1,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_magic_stick",
				"item_faerie_fire",
				"item_blood_grenade",
			
				"item_tranquil_boots",
				"item_magic_wand",
				"item_glimmer_cape",--
				"item_aether_lens",
				"item_ancient_janggo",
				"item_sheepstick",--
				"item_boots_of_bearing",--
				"item_aghanims_shard",
				"item_ultimate_scepter",
				"item_ethereal_blade",--
				"item_refresher",--
				"item_wind_waker",--
				"item_ultimate_scepter_2",
				"item_moon_shard",
			},
            ['sell_list'] = {
				"item_magic_wand", "item_refresher"
			},
        },
    },
    ['pos_5'] = {
        [1] = {
            ['talent'] = {
				[1] = {
					['t25'] = {10, 0},
					['t20'] = {0, 10},
					['t15'] = {10, 0},
					['t10'] = {10, 0},
				}
            },
            ['ability'] = {
				[1] = {1,3,3,2,3,6,3,2,2,2,1,6,1,1,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_magic_stick",
				"item_faerie_fire",
				"item_blood_grenade",
			
				"item_arcane_boots",
				"item_magic_wand",
				"item_glimmer_cape",--
				"item_aether_lens",
				"item_mekansm",
				"item_sheepstick",--
				"item_guardian_greaves",--
				"item_aghanims_shard",
				"item_ultimate_scepter",
				"item_ethereal_blade",--
				"item_refresher",--
				"item_wind_waker",--
				"item_ultimate_scepter_2",
				"item_moon_shard",
			},
            ['sell_list'] = {
				"item_magic_wand", "item_refresher"
			},
        },
    },
}

local sSelectedBuild = HeroBuild[sRole][RandomInt(1, #HeroBuild[sRole])]

local nTalentBuildList = J.Skill.GetTalentBuild(J.Skill.GetRandomBuild(sSelectedBuild.talent))
local nAbilityBuildList = J.Skill.GetRandomBuild(sSelectedBuild.ability)

X['sBuyList'] = sSelectedBuild.buy_list
X['sSellList'] = sSelectedBuild.sell_list

if J.Role.IsPvNMode() or J.Role.IsAllShadow() then X['sBuyList'], X['sSellList'] = { 'PvN_mage' }, {} end

nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] = J.SetUserHeroInit( nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] )

X['sSkillList'] = J.Skill.GetSkillList( sAbilityList, nAbilityBuildList, sTalentList, nTalentBuildList )

X['bDeafaultAbility'] = true
X['bDeafaultItem'] = true

function X.MinionThink( hMinionUnit )

	if Minion.IsValidUnit( hMinionUnit )
	then
		Minion.IllusionThink( hMinionUnit )
	end

end

end

local FortunesEnd = bot:GetAbilityByName('oracle_fortunes_end')
local FatesEdict = bot:GetAbilityByName('oracle_fates_edict')
local PurifyingFlames = bot:GetAbilityByName('oracle_purifying_flames')
local RainOfDestiny = bot:GetAbilityByName('oracle_rain_of_destiny')
local FalsePromise = bot:GetAbilityByName('oracle_false_promise')

local FortunesEndDesire, FortunesEndTarget
local FatesEdictDesire, FatesEdictTarget
local PurifyingFlamesDesire, PurifyingFlamesTarget
local RainOfDestinyDesire, RainOfDestinyLocation
local FalsePromiseDesire, FalsePromiseTarget

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
	bot = GetBot()

	FortunesEnd = bot:GetAbilityByName('oracle_fortunes_end')
	FatesEdict = bot:GetAbilityByName('oracle_fates_edict')
	PurifyingFlames = bot:GetAbilityByName('oracle_purifying_flames')
	RainOfDestiny = bot:GetAbilityByName('oracle_rain_of_destiny')
	FalsePromise = bot:GetAbilityByName('oracle_false_promise')

	FalsePromiseDesire, FalsePromiseTarget = X.ConsiderFalsePromise()

	X.ConsiderFortunesEndCancel()

	if J.CanNotUseAbility(bot) then return end

    bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	if FalsePromiseDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnEntity(FalsePromise, FalsePromiseTarget)
		return
	end

	PurifyingFlamesDesire, PurifyingFlamesTarget = X.ConsiderPurifyingFlames()
	if PurifyingFlamesDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnEntity(PurifyingFlames, PurifyingFlamesTarget)
		return
	end

	FatesEdictDesire, FatesEdictTarget = X.ConsiderFatesEdict()
	if FatesEdictDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnEntity(FatesEdict, FatesEdictTarget)
		return
	end

	FortunesEndDesire, FortunesEndTarget = X.ConsiderFortunesEnd()
	if FortunesEndDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnEntity(FortunesEnd, FortunesEndTarget)
		return
	end

	RainOfDestinyDesire, RainOfDestinyLocation = X.ConsiderRainOfDestiny()
	if RainOfDestinyDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnLocation(RainOfDestiny, RainOfDestinyLocation)
		return
	end
end

function X.ConsiderFortunesEnd()
	if not J.CanCastAbility(FortunesEnd) then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = FortunesEnd:GetCastRange()
	local nCastPoint = FortunesEnd:GetCastPoint()
	local nChannelTime = FortunesEnd:GetSpecialValueFloat('channel_time')
	local nSpeed = FortunesEnd:GetSpecialValueInt('bolt_speed')
	local nManaCost = FortunesEnd:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {FatesEdict, PurifyingFlames, RainOfDestiny, FalsePromise})

	if not bot:IsMagicImmune() then
		if J.IsStunProjectileIncoming(bot, 650) then
			return BOT_ACTION_DESIRE_NONE, nil
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.CanCastOnTargetAdvanced(botTarget)
		and not J.IsDisabled(botTarget)
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderFortunesEndCancel()
	if FortunesEnd and FortunesEnd:IsTrained() and FortunesEnd:IsChanneling() then
		if FalsePromiseDesire > 0 then
			bot:Action_ClearActions(true)
			return
		end

		if not bot:IsMagicImmune() then
			if J.IsStunProjectileIncoming(bot, 400) then
				bot:Action_ClearActions(true)
				return
			end
		end

		if J.IsValidHero(FortunesEndTarget) then
			if not J.CanCastOnNonMagicImmune(FortunesEndTarget) then
				bot:Action_ClearActions(true)
				return
			end
		end
	end
end

function X.ConsiderFatesEdict()
	if not J.CanCastAbility(FatesEdict) then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = FatesEdict:GetCastRange()
	local nCastPoint = FatesEdict:GetCastPoint()
	local nManaCost = FatesEdict:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {FortunesEnd, PurifyingFlames, RainOfDestiny, FalsePromise})
	local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {PurifyingFlames, FalsePromise})

	if J.IsInTeamFight(bot, 1200) and #nEnemyHeroes >= 3 then
		local hTarget = nil
		local hTargetDamage = 0
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange + 300)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and J.CanCastOnTargetAdvanced(enemyHero)
			and not J.IsChasingTarget(bot, enemyHero)
			and not J.IsDisabled(enemyHero)
			and not enemyHero:IsDisarmed()
			then
				local enemyHeroDamage = enemyHero:GetAttackDamage() * enemyHero:GetAttackSpeed()
				if enemyHeroDamage > hTargetDamage then
					hTarget = enemyHero
					hTargetDamage = enemyHeroDamage
				end
			end
		end

		if hTarget then
			return BOT_ACTION_DESIRE_HIGH, hTarget
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.CanCastOnTargetAdvanced(botTarget)
		and J.IsAttacking(botTarget)
		and not J.IsDisabled(botTarget)
		and not J.IsChasingTarget(bot, botTarget)
		and not botTarget:IsDisarmed()
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and J.CanCastOnTargetAdvanced(enemyHero)
			and not J.IsDisabled(enemyHero)
			and not enemyHero:IsDisarmed()
			then
				if bot:WasRecentlyDamagedByHero(enemyHero, 2.0) or J.IsChasingTarget(enemyHero, bot) then
					return BOT_ACTION_DESIRE_HIGH, enemyHero
				end
			end
		end
	end

    if not J.IsRealInvisible(bot) and fManaAfter > fManaThreshold2 then
        for _, allyHero in pairs(nAllyHeroes) do
            if  J.IsValidHero(allyHero)
			and J.CanBeAttacked(allyHero)
			and J.IsInRange(bot, allyHero, nCastRange + 200)
            and not allyHero:IsIllusion()
			and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			and not allyHero:HasModifier('modifier_oracle_fates_edict')
            then
				local allyHP = J.GetHP(allyHero)

				if J.CanCastAbility(PurifyingFlames) then
					if (allyHP < 0.6)
					or (allyHP < 0.5 and J.GetTotalEstimatedDamageToTarget(nEnemyHeroes, 5.5, DAMAGE_TYPE_MAGICAL) > allyHero:GetHealth() and not allyHero:IsMagicImmune())
					then
						return BOT_ACTION_DESIRE_HIGH, allyHero
					end
				end

				if allyHero:HasModifier('modifier_enigma_black_hole_pull')
				or allyHero:HasModifier('modifier_jakiro_macropyre_burn')
				or allyHero:HasModifier('modifier_crystal_maiden_freezing_field_slow')
				or allyHero:HasModifier('modifier_sand_king_epicenter_slow')
				then
					return BOT_ACTION_DESIRE_HIGH, allyHero
				end
            end
        end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderPurifyingFlames()
	if not J.CanCastAbility(PurifyingFlames) then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = PurifyingFlames:GetCastRange()
	local nCastPoint = PurifyingFlames:GetCastPoint()
	local nDamage = PurifyingFlames:GetSpecialValueInt('damage')
	local nDuration = PurifyingFlames:GetSpecialValueInt('duration')
	local nHealPerSecond = PurifyingFlames:GetSpecialValueInt('heal_per_second')
	local nManaCost = PurifyingFlames:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {FortunesEnd, FatesEdict, RainOfDestiny, FalsePromise})
	local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {PurifyingFlames, FalsePromise})

	for _, enemyHero in pairs(nEnemyHeroes) do
		if J.IsValidHero(enemyHero)
		and J.CanBeAttacked(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange + 300)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
		and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
		then
			local eta = (GetUnitToUnitDistance(bot, enemyHero) / bot:GetCurrentMovementSpeed()) + nCastPoint
			if J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL, eta) then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
			end
		end
	end

	for _, allyHero in pairs(nAllyHeroes) do
		if J.IsValidHero(allyHero)
		and J.IsInRange(bot, allyHero, nCastRange + 300)
		and not J.IsSuspiciousIllusion(allyHero)
		and not allyHero:HasModifier('modifier_doom_bringer_doom_aura_enemy')
		and not allyHero:HasModifier('modifier_ice_blast')
		and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
		and not allyHero:HasModifier('modifier_fountain_aura_buff')
		and allyHero:GetUnitName() ~= 'npc_dota_hero_huskar'
		and allyHero:GetUnitName() ~= 'npc_dota_hero_medusa'
		then
			local fModifierTime = J.GetModifierTime(allyHero, 'modifier_oracle_purifying_flames')
			local allyHP = J.GetHP(allyHero)
			local fHealthAfter = ((allyHero:GetHealth() + fModifierTime * nHealPerSecond) - nDamage) / allyHero:GetMaxHealth()

			if not bot:HasModifier('modifier_oracle_purifying_flames') then
				if (allyHP < 0.65 and (#nEnemyHeroes == 0 or fHealthAfter > 0.4) and fManaAfter > fManaThreshold2) then
					return BOT_ACTION_DESIRE_HIGH, allyHero
				end
			end

			if (allyHero:HasModifier('modifier_oracle_false_promise_timer'))
			or (allyHero:HasModifier('modifier_oracle_fates_edict') and fManaAfter > fManaThreshold2)
			then
				return BOT_ACTION_DESIRE_HIGH, allyHero
			end
		end
	end

	local nEnemyCreeps = bot:GetNearbyCreeps(Min(nCastRange + 350, 1600), true)

	if (J.IsPushing(bot) and bAttacking and fManaAfter > fManaThreshold1)
	or (J.IsDefending(bot) and bAttacking and fManaAfter > fManaThreshold1)
	or (J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold1)
	then
		for _, creep in pairs(nEnemyCreeps) do
			if  J.IsValid(creep)
			and J.CanBeAttacked(creep)
			and J.CanCastOnNonMagicImmune(creep)
			and J.CanCastOnTargetAdvanced(creep)
			and not creep:HasModifier('modifier_item_pipe_barrier')
			and (J.IsCore(bot) or not J.IsOtherAllysTarget(creep))
			then
				local eta = (GetUnitToUnitDistance(bot, creep) / bot:GetCurrentMovementSpeed()) + nCastPoint
				if J.WillKillTarget(creep, nDamage - 1, DAMAGE_TYPE_MAGICAL, eta) then
					return BOT_ACTION_DESIRE_HIGH, creep
				end

				if  J.GetHP(creep) < 0.5
				and not J.CanKillTarget(creep, bot:GetAttackDamage() * 5, DAMAGE_TYPE_PHYSICAL)
				and fManaAfter > fManaThreshold1 + 0.15
				then
					return BOT_ACTION_DESIRE_HIGH, creep
				end
			end
		end
	end

    if J.IsLaning(bot) and J.IsInLaningPhase() and fManaAfter > fManaThreshold1 then
		for _, creep in pairs(nEnemyCreeps) do
			if  J.IsValid(creep)
            and J.CanBeAttacked(creep)
            and J.CanCastOnNonMagicImmune(creep)
            and J.CanCastOnTargetAdvanced(creep)
			and (J.IsCore(bot) or not J.IsOtherAllysTarget(creep))
			then
				local eta = (GetUnitToUnitDistance(bot, creep) / bot:GetCurrentMovementSpeed()) + nCastPoint
				if J.WillKillTarget(creep, nDamage - 1, DAMAGE_TYPE_MAGICAL, eta) then
					local sCreepName = creep:GetUnitName()
					if string.find(sCreepName, 'ranged') then
						return BOT_ACTION_DESIRE_HIGH, creep
					end

					local nLocationAoE = bot:FindAoELocation(true, true, creep:GetLocation(), 0, 550, 0, 0)
					if nLocationAoE.count > 0 or J.IsUnitTargetedByTower(creep, false) or J.IsEnemyTargetUnit(creep, 1200) then
						return BOT_ACTION_DESIRE_HIGH, creep
					end
				end
			end
		end
    end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderRainOfDestiny()
	if not J.CanCastAbility(RainOfDestiny) then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastRange = RainOfDestiny:GetCastRange()
	local nRadius = RainOfDestiny:GetSpecialValueInt('radius')
	local nManaCost = RainOfDestiny:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {FortunesEnd, FatesEdict, PurifyingFlames, FalsePromise})

	if J.IsGoingOnSomeone(bot) and fManaAfter > fManaThreshold1 then
		if  J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and J.CanCastOnNonMagicImmune(botTarget)
		and not J.IsChasingTarget(bot, botTarget)
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderFalsePromise()
	if not J.CanCastAbility(FalsePromise) then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = FalsePromise:GetCastRange()
	local nCastPoint = FalsePromise:GetCastPoint()
	local nDuration = FalsePromise:GetSpecialValueFloat('duration')
	local nManaCost = FalsePromise:GetManaCost()

	for _, allyHero in pairs(nAllyHeroes) do
		if J.IsValidHero(allyHero)
		and J.CanBeAttacked(allyHero)
		and J.IsInRange(bot, allyHero, nCastRange + 300)
		and allyHero:WasRecentlyDamagedByAnyHero(2.0)
		and not allyHero:IsIllusion()
		and not allyHero:HasModifier('modifier_doom_bringer_doom_aura_enemy')
		and not allyHero:HasModifier('modifier_oracle_false_promise_timer')
		and not allyHero:HasModifier('modifier_ice_blast')
		and not allyHero:HasModifier('modifier_fountain_aura_buff')
		then
			local allyHP = J.GetHP(allyHero)
			local allyTarget = J.GetProperTarget(allyHero)

			if allyHP < 0.55 then
				if J.IsRetreating(allyHero) and not J.IsRealInvisible(allyHero) then
					if allyHero ~= bot or botHP < 0.25 then
						return BOT_ACTION_DESIRE_HIGH, allyHero
					end
				end

				if J.IsGoingOnSomeone(allyHero) and allyHP < 0.3 then
					if J.IsValidHero(allyTarget)
					and J.IsInRange(allyHero, allyTarget, 600)
					then
						return BOT_ACTION_DESIRE_HIGH, allyHero
					end
				end

				local nInRangeEnemy = J.GetEnemiesNearLoc(allyHero:GetLocation(), 800)

				if not allyHero:IsBot()
				and J.GetHP(allyHero) <= 0.6
				and J.IsValidHero(allyTarget)
				and not J.IsSuspiciousIllusion(allyHP)
				and #nInRangeEnemy >= 2
				and (J.IsGoingOnSomeone(bot) or J.IsGoingOnSomeone(allyHero))
				then
					return BOT_ACTION_DESIRE_HIGH, allyHero
				end
			end

			if (allyHP < 0.35 and J.GetModifierTime(allyHero, 'modifier_enigma_black_hole_pull') >= 3)
			or (allyHP < 0.30 and J.GetModifierTime(allyHero, 'modifier_faceless_void_chronosphere_freeze') >= 3)
			or (allyHP < 0.20 and J.GetModifierTime(allyHero, 'modifier_legion_commander_duel') >= 3)
			then
				local nEnemyHeroesTargetingAlly = J.GetHeroesTargetingUnit(nEnemyHeroes, allyHero)
				if #nEnemyHeroesTargetingAlly > 0 then
					if (J.GetTotalEstimatedDamageToTarget(nEnemyHeroesTargetingAlly, allyHero, 5.0) > allyHero:GetHealth())
					or (J.IsInTeamFight(bot, 1200))
					then
						return BOT_ACTION_DESIRE_HIGH, allyHero
					end
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

return X
