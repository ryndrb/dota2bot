local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_dazzle'
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
				}
            },
            ['ability'] = {
                [1] = {3,1,1,3,1,6,1,3,3,2,6,2,2,2,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_double_circlet",
				"item_faerie_fire",
			
				"item_bottle",
				"item_magic_wand",
				"item_power_treads",
				"item_orchid",
				"item_ultimate_scepter",
				"item_black_king_bar",--
				"item_aghanims_shard",
				"item_octarine_core",--
				"item_hurricane_pike",--
				"item_bloodthorn",--
				"item_sheepstick",--
				"item_ultimate_scepter_2",
				"item_moon_shard",
				"item_travel_boots_2",--
			},
            ['sell_list'] = {
				"item_circlet", "item_ultimate_scepter",
				"item_circlet", "item_black_king_bar",
				"item_magic_wand", "item_octarine_core",
				"item_bottle", "item_hurricane_pike",
			},
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
					['t25'] = {0, 10},
					['t20'] = {0, 10},
					['t15'] = {0, 10},
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
                [1] = {1,3,1,2,1,6,1,3,3,3,6,2,2,2,6},
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
				"item_aghanims_shard",
				"item_holy_locket",--
				"item_boots_of_bearing",--
				"item_octarine_core",--
				"item_sheepstick",--
				"item_ultimate_scepter_2",
				"item_moon_shard"
			},
            ['sell_list'] = {},
        },
    },
    ['pos_5'] = {
        [1] = {
            ['talent'] = {
				[1] = {
					['t25'] = {0, 10},
					['t20'] = {0, 10},
					['t15'] = {0, 10},
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
                [1] = {1,3,1,2,1,6,1,3,3,3,6,2,2,2,6},
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
				"item_aghanims_shard",
				"item_holy_locket",--
				"item_guardian_greaves",--
				"item_octarine_core",--
				"item_sheepstick",--
				"item_ultimate_scepter_2",
				"item_moon_shard"
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

if J.Role.IsPvNMode() or J.Role.IsAllShadow() then X['sBuyList'], X['sSellList'] = { 'PvN_priest' }, {} end

nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] = J.SetUserHeroInit( nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] )

X['sSkillList'] = J.Skill.GetSkillList( sAbilityList, nAbilityBuildList, sTalentList, nTalentBuildList )

X['bDeafaultAbility'] = false
X['bDeafaultItem'] = true

function X.MinionThink( hMinionUnit )

	if Minion.IsValidUnit( hMinionUnit )
	then
		Minion.IllusionThink( hMinionUnit )
	end

end

end

local PoisonTouch = bot:GetAbilityByName('dazzle_poison_touch')
local ShallowGrave = bot:GetAbilityByName('dazzle_shallow_grave')
local ShadowWave = bot:GetAbilityByName('dazzle_shadow_wave')
local BadJuju = bot:GetAbilityByName('dazzle_bad_juju')
local NothlProjection = bot:GetAbilityByName('dazzle_nothl_projection')
local NothlProjectionEnd = bot:GetAbilityByName('dazzle_nothl_projection_end')

local PoisonTouchDesire, PoisonTouchTarget
local ShallowGraveDesire, ShallowGraveTarget
local ShadowWaveDesire, ShadowWaveTarget
local NothlProjectionDesire, NothlProjectionLocation
local NothlProjectionEndDesire

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
	bot = GetBot()

	if J.CanNotUseAbility(bot) or bot:HasModifier('modifier_dazzle_nothl_projection_physical_body_debuff') then return end

	PoisonTouch = bot:GetAbilityByName('dazzle_poison_touch')
	ShallowGrave = bot:GetAbilityByName('dazzle_shallow_grave')
	ShadowWave = bot:GetAbilityByName('dazzle_shadow_wave')
	BadJuju = bot:GetAbilityByName('dazzle_bad_juju')
	NothlProjection = bot:GetAbilityByName('dazzle_nothl_projection')
	NothlProjectionEnd = bot:GetAbilityByName('dazzle_nothl_projection_end')

	bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	NothlProjectionDesire, NothlProjectionLocation = X.ConsiderNothlProjection()
	if NothlProjectionDesire > 0 then
		J.SetQueuePtToINT(bot, true)
		bot:ActionQueue_UseAbilityOnLocation(NothlProjection, NothlProjectionLocation)
		return
	end

	ShallowGraveDesire, ShallowGraveTarget = X.ConsiderShallowGrave()
	if ShallowGraveDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnEntity(ShallowGrave, ShallowGraveTarget)
		return
	end

	PoisonTouchDesire, PoisonTouchTarget = X.ConsiderPoisonTouch()
	if PoisonTouchDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnEntity(PoisonTouch, PoisonTouchTarget)
		return
	end

	ShadowWaveDesire, ShadowWaveTarget = X.ConsiderShadowWave()
	if ShadowWaveDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnEntity(ShadowWave, ShadowWaveTarget)
		return
	end

	NothlProjectionEndDesire = X.ConsiderNothlProjectionEnd()
	if NothlProjectionEndDesire > 0 then
		bot:Action_UseAbility(NothlProjectionEnd)
		return
	end
end

function X.ConsiderPoisonTouch()
	if not J.CanCastAbility(PoisonTouch) then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = J.GetProperCastRange(false, bot, PoisonTouch:GetCastRange())
	local nDamage = PoisonTouch:GetSpecialValueInt('damage')
	local nDuration = PoisonTouch:GetSpecialValueFloat('duration')
	local nDistance = PoisonTouch:GetSpecialValueInt('end_distance')
	local nRadiusStart = PoisonTouch:GetSpecialValueInt('start_radius')
	local nRadiusEnd = PoisonTouch:GetSpecialValueInt('end_radius')
	local nManaCost = PoisonTouch:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {ShallowGrave, ShadowWave, NothlProjection})
	local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {PoisonTouch, ShallowGrave, ShadowWave, NothlProjection})

	for _, enemyHero in pairs(nEnemyHeroes) do
		if J.IsValidHero(enemyHero)
		and J.CanBeAttacked(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange + 200)
		and J.CanCastOnNonMagicImmune(enemyHero)
		and J.CanCastOnTargetAdvanced(enemyHero)
		and J.CanKillTarget(enemyHero, nDamage * nDuration, DAMAGE_TYPE_MAGICAL)
		and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
		and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
		and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
		and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
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
            and J.IsInRange(bot, enemyHero, nCastRange + 150)
			and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and not J.IsDisabled(enemyHero)
			and not enemyHero:HasModifier('modifier_dazzle_poison_touch')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            then
                local enemyHeroDamage = enemyHero:GetEstimatedDamageToTarget(false, bot, 5.0, DAMAGE_TYPE_ALL)
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
        and J.IsInRange(bot, botTarget, nCastRange + 100)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.CanCastOnTargetAdvanced(botTarget)
		and not botTarget:HasModifier('modifier_dazzle_poison_touch')
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and bot:WasRecentlyDamagedByHero(enemyHero, 3.0)
            and not J.IsDisabled(enemyHero)
			and not enemyHero:HasModifier('modifier_dazzle_poison_touch')
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero
            end
        end
	end

	local nEnemyCreeps = bot:GetNearbyCreeps(Min(nCastRange + 300, 1600), true)

	if J.IsPushing(bot) and bAttacking and fManaAfter > fManaThreshold1 and #nAllyHeroes <= 3 and #nEnemyHeroes == 0 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) then
				local count = 0
				for _, c in pairs(nEnemyCreeps) do
					if J.IsValid(c) and J.CanBeAttacked(c) then
						local tResult = PointToLineDistance(bot:GetLocation(), creep:GetLocation(), c:GetLocation())
						if tResult and tResult.within and tResult.distance <= nRadiusStart then
							count = count + 1
							if (count >= 4) then
								return BOT_ACTION_DESIRE_HIGH, creep
							end
						end
					end
				end
            end
        end
	end

	if J.IsDefending(bot) and bAttacking and fManaAfter > fManaThreshold1 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) then
				local count = 0
				for _, c in pairs(nEnemyCreeps) do
					if J.IsValid(c) and J.CanBeAttacked(c) then
						local tResult = PointToLineDistance(bot:GetLocation(), creep:GetLocation(), c:GetLocation())
						if tResult and tResult.within and tResult.distance <= nRadiusStart then
							count = count + 1
							if (count >= 4) then
								return BOT_ACTION_DESIRE_HIGH, creep
							end
						end
					end
				end
            end
        end
	end

	if J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold1 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) then
				local count = 0
				for _, c in pairs(nEnemyCreeps) do
					if J.IsValid(c) and J.CanBeAttacked(c) then
						local tResult = PointToLineDistance(bot:GetLocation(), creep:GetLocation(), c:GetLocation())
						if tResult and tResult.within and tResult.distance <= nRadiusStart then
							count = count + 1
							if (count >= 3)
							or (count >= 2 and creep:GetHealth() >= 500)
							then
								return BOT_ACTION_DESIRE_HIGH, creep
							end
						end
					end
				end
            end
        end
	end

	if J.IsDoingRoshan(bot) then
		if J.IsRoshan(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
		and not J.IsDisabled(botTarget)
        and bAttacking
		and fManaAfter > fManaThreshold1
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

    if J.IsDoingTormentor(bot) then
		if J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and bAttacking
		and fManaAfter > fManaThreshold1
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderShallowGrave()
	if not J.CanCastAbility(ShallowGrave) then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = ShallowGrave:GetCastRange()
	local nCastPoint = ShallowGrave:GetCastPoint()

	for _, allyHero in pairs(nAllyHeroes) do
		if J.IsValidHero(allyHero)
		and J.CanBeAttacked(allyHero)
        and not allyHero:IsIllusion()
        and J.IsInRange(bot, allyHero, nCastRange + 600)
        and J.GetHP(allyHero) < 0.4
        and not allyHero:HasModifier('modifier_abaddon_borrowed_time')
		and not allyHero:HasModifier('modifier_dazzle_shallow_grave')
		and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			local nEnemyHeroesTargetingAlly = J.GetHeroesTargetingUnit(nEnemyHeroes, allyHero)
			local eta = (GetUnitToUnitDistance(bot, allyHero) / bot:GetCurrentMovementSpeed()) + nCastPoint
			local allyHeroHealth = allyHero:GetHealth()

			if X.GetEnemyDamageToAlly(allyHero, eta) > allyHeroHealth then
				return BOT_ACTION_DESIRE_HIGH, allyHero
			end

			if J.GetAttackProjectileDamageByRange(allyHero, 1200) > allyHero:GetHealth() then
				return BOT_ACTION_DESIRE_HIGH, allyHero
			end

			if J.GetHP(allyHero) < 0.15 then
				if allyHero:HasModifier( 'modifier_sniper_assassinate' ) then
					return BOT_ACTION_DESIRE_HIGH, allyHero
				end

				if allyHero:HasModifier('modifier_huskar_burning_spear_counter')
                or allyHero:HasModifier('modifier_jakiro_macropyre_burn')
                or allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
                or allyHero:HasModifier('modifier_viper_viper_strike_slow')
                or allyHero:HasModifier('modifier_viper_nethertoxin')
                or allyHero:HasModifier('modifier_viper_poison_attack_slow')
                or allyHero:HasModifier('modifier_maledict')
				then
					return BOT_ACTION_DESIRE_HIGH, allyHero
				end

				if J.IsInRange(bot, allyHero, nCastRange + 300) and #nEnemyHeroesTargetingAlly >= 1 then
					return BOT_ACTION_DESIRE_HIGH, allyHero
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderShadowWave()
	if not J.CanCastAbility(ShadowWave) then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = J.GetProperCastRange(false, bot, ShadowWave:GetCastRange())
	local nHealRadius = ShadowWave:GetSpecialValueInt('bounce_radius')
	local nDamageRadius = ShadowWave:GetSpecialValueInt('damage_radius')
	local nDamage = ShadowWave:GetSpecialValueInt('damage')
	local nMaxHealCount = ShadowWave:GetSpecialValueInt('tooltip_max_targets_inc_dazzle')
	local nManaCost = ShadowWave:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
    local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {PoisonTouch, ShallowGrave, NothlProjection})
	local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {ShallowGrave})

	local hWeakestAlly = nil
	local hWeakestAllyHealth = math.huge
	for _, allyHero in pairs(nAllyHeroes) do
		if  J.IsValidHero(allyHero)
		and J.CanBeAttacked(allyHero)
		and J.IsInRange(bot, allyHero, nCastRange + 300)
		and not allyHero:IsIllusion()
		and not allyHero:HasModifier('modifier_abaddon_borrowed_time')
		and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			local allyHeroHealth = allyHero:GetHealth()
			if allyHeroHealth < hWeakestAllyHealth then
				hWeakestAlly = allyHero
				hWeakestAllyHealth = allyHeroHealth
			end

			if  allyHero:HasModifier('modifier_dazzle_shallow_grave')
			and allyHero:WasRecentlyDamagedByAnyHero(3.0)
			and J.GetHP(allyHero) < 0.8
			and fManaAfter > fManaThreshold2
			then
				return BOT_ACTION_DESIRE_HIGH, allyHero
			end
		end
	end

	if hWeakestAlly then
		if fManaAfter > fManaThreshold2 + 0.05 and J.GetHP(hWeakestAlly) < 0.8 then
			return BOT_ACTION_DESIRE_HIGH, hWeakestAlly
		end
	end

	local waveDamage = 0
	for _, enemyHero in pairs(nEnemyHeroes) do
		if J.IsValidHero(enemyHero)
		and J.CanBeAttacked(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange + 300)
		and J.CanCastOnTargetAdvanced(enemyHero)
		then
			local nAllyUnitNearbyCount = J.GetUnitAllyCountAroundEnemyTarget(enemyHero, nDamageRadius)

			if J.CanKillTarget(enemyHero, nAllyUnitNearbyCount * nDamage, DAMAGE_TYPE_PHYSICAL)
			and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
			and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
			and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
			then
				local hTargetAlly = X.GetBestHealTarget(enemyHero, nDamageRadius)
				if J.IsValid(hTargetAlly) then
					return BOT_ACTION_DESIRE_HIGH, hTargetAlly
				end
			end

			if J.IsValid(hWeakestAlly) then
				if nAllyUnitNearbyCount > 0 then
					waveDamage = waveDamage + nAllyUnitNearbyCount * nDamage
				end

				if waveDamage >= 800 and J.IsInRange(bot, hWeakestAlly, nCastRange + 50) then
					return BOT_ACTION_DESIRE_HIGH, hWeakestAlly
				end
			end
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange + 200)
		and J.CanCastOnTargetAdvanced(botTarget)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			local nAllyUnitNearbyCount = J.GetUnitAllyCountAroundEnemyTarget(botTarget, nDamageRadius)
			if (nAllyUnitNearbyCount >= nMaxHealCount - 2)
			or (nAllyUnitNearbyCount >= 4)
			then
				local hTargetAlly = X.GetBestHealTarget(botTarget, nDamageRadius)
				if J.IsValid(hTargetAlly) then
					return BOT_ACTION_DESIRE_HIGH, hTargetAlly
				end
			end
		end
	end

	local nAllyCreeps = bot:GetNearbyCreeps(Min(nCastRange + 300, 1600), false)
    local nEnemyCreeps = bot:GetNearbyCreeps(nDamageRadius, true)
	local bPushing = J.IsPushing(bot)
	local bDefending = J.IsDefending(bot)
	local bFarming = J.IsFarming(bot)

    if (bPushing and bAttacking and fManaAfter > fManaThreshold1 + 0.1 and #nAllyHeroes <= 3 and #nEnemyHeroes <= 1)
	or (bDefending and bAttacking and fManaAfter > fManaThreshold1)
	or (bFarming and bAttacking and fManaAfter > fManaThreshold1)
	then
		if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
			if (#nEnemyCreeps >= 3 and (bPushing or bDefending))
			or (#nEnemyCreeps >= 2 and (bFarming))
			or (#nEnemyCreeps >= 1 and nEnemyCreeps[1]:GetHealth() >= 500 and (bFarming))
			then
				return BOT_ACTION_DESIRE_HIGH, bot
			end
		end

		for _, creep in pairs(nAllyCreeps) do
            if J.IsValid(creep) then
				local needHealCount = 0
				local nLocationAoE1 = bot:FindAoELocation(false, false, creep:GetLocation(), 0, nHealRadius, 0, nDamage)
				needHealCount = needHealCount + nLocationAoE1.count
				local nLocationAoE2 = bot:FindAoELocation(false, false, creep:GetLocation(), 0, nHealRadius, 0, nDamage * 0.5)
				needHealCount = needHealCount + nLocationAoE2.count * 0.5

				if (needHealCount >= 3 and (bPushing or bDefending))
				or (needHealCount >= 2 and (bFarming))
				or (needHealCount >= 1 and creep:GetHealth() >= 500 and (bFarming))
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
			and not J.IsOtherAllysTarget(creep)
			then
				local nAllyUnitNearbyCount = J.GetUnitAllyCountAroundEnemyTarget(creep, nDamageRadius)
				if J.CanKillTarget(creep, nAllyUnitNearbyCount * nDamage, DAMAGE_TYPE_MAGICAL) then
					local hTargetAlly = X.GetBestHealTarget(creep, nDamageRadius)
					if hTargetAlly then
						local sCreepName = creep:GetUnitName()
						local nLocationAoE = bot:FindAoELocation(true, true, creep:GetLocation(), 0, 600, 0, 0)

						if string.find(sCreepName, 'ranged') then
							if nLocationAoE.count > 0 or J.IsUnitTargetedByTower(creep, false) then
								return BOT_ACTION_DESIRE_HIGH, hTargetAlly
							end
						end

						local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), nDamage)
						if #nInRangeEnemy > 0 then
							return BOT_ACTION_DESIRE_HIGH, hTargetAlly
						end

						nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nDamageRadius, 0, nDamage)
						if nLocationAoE.count >= 2 then
							return BOT_ACTION_DESIRE_HIGH, hTargetAlly
						end
					end
				end
			end
		end
	end

	local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), 1200)
	local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1200)

	if #nInRangeAlly <= 3 and #nInRangeEnemy == 0 and fManaAfter > fManaThreshold1 then
		local nAllyLaneCreeps = bot:GetNearbyLaneCreeps(Min(nCastRange + 300, 1600), false)
		for _, creep in pairs(nAllyLaneCreeps) do
            if J.IsValid(creep) then
				local needHealCount = 0
				local nLocationAoE1 = bot:FindAoELocation(false, false, creep:GetLocation(), 0, nHealRadius, 0, nDamage)
				needHealCount = needHealCount + nLocationAoE1.count
				local nLocationAoE2 = bot:FindAoELocation(false, false, creep:GetLocation(), 0, nHealRadius, 0, nDamage * 0.5)
				needHealCount = needHealCount + nLocationAoE2.count * 0.5

				if needHealCount >= nMaxHealCount - 1 then
					return BOT_ACTION_DESIRE_HIGH, creep
				end
            end
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderR()
	if not J.CanCastAbility(BadJuju) then return BOT_ACTION_DESIRE_NONE end

    local nBaseHealth = 75
    local nCDR = BadJuju:GetSpecialValueInt('cooldown_reduction')
    local nJuJuStacks = bot:GetModifierStackCount(bot:GetModifierByName('modifier_dazzle_bad_juju_manacost'))

    local _, PoisonTouch_ = J.HasAbility(bot, 'dazzle_poison_touch')
    local _, ShallowGrave_ = J.HasAbility(bot, 'dazzle_shallow_grave')
    local _, ShadowWave_ = J.HasAbility(bot, 'dazzle_shadow_wave')

    if J.IsRetreating(bot) and J.IsRealInvisible(bot) and ShallowGrave_ ~= nil and not ShallowGrave_:IsFullyCastable()
    then
        return BOT_ACTION_DESIRE_NONE
    end

    if PoisonTouch_ ~= nil and not PoisonTouch_:IsFullyCastable()
    and ShallowGrave_ ~= nil and not ShallowGrave_:IsFullyCastable()
    and ShadowWave_ ~= nil and not ShadowWave_:IsFullyCastable()
    and (bot:HasModifier('modifier_dazzle_shallow_grave') or J.GetHealthAfter((nBaseHealth * nJuJuStacks)) > 0.25)
    then
        return BOT_ACTION_DESIRE_HIGH
    end

	if ShallowGrave_ ~= nil and ShallowGrave_:GetCooldownTimeRemaining() > nCDR
    and J.GetHealthAfter((nBaseHealth * nJuJuStacks)) > 0.15
	then
		return BOT_ACTION_DESIRE_HIGH
	end

    if not string.find(bot:GetUnitName(), 'dazzle')
    and J.IsGoingOnSomeone(bot)
    then
        local sAbilityList_ = J.Skill.GetAbilityList(bot)
        local ability1 = bot:GetAbilityByName(sAbilityList_[1])
        local ability2 = bot:GetAbilityByName(sAbilityList_[2])
        local ability3 = bot:GetAbilityByName(sAbilityList_[3])

        if J.IsGoingOnSomeone(bot)
        and J.GetHealthAfter((nBaseHealth * nJuJuStacks)) > 0.25
        then
            if (ability1 ~= nil and not ability1:IsPassive() and ability1:GetCooldownTimeRemaining() > nCDR)
            or (ability2 ~= nil and not ability2:IsPassive() and ability2:GetCooldownTimeRemaining() > nCDR)
            or (ability3 ~= nil and not ability3:IsPassive() and ability3:GetCooldownTimeRemaining() > nCDR)
            then
                return BOT_ACTION_DESIRE_HIGH
            end
        end
    end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderNothlProjection()
	if not J.CanCastAbility(NothlProjection)
	or bot:HasModifier('modifier_dazzle_nothl_projection_soul_debuff')
	then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastRange = NothlProjection:GetCastRange()
	local bSpellsAvailable = J.CanCastAbility(PoisonTouch)

	if J.IsInTeamFight(bot, 800) and bSpellsAvailable then
		return BOT_ACTION_DESIRE_HIGH, bot:GetLocation() + RandomVector(nCastRange)
	end

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, bot:GetAttackRange())
		and J.CanCastOnNonMagicImmune(botTarget)
		and not J.IsChasingTarget(bot, botTarget)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
		and (J.IsCore(botTarget) or not J.IsEarlyGame())
		then
			local nInRangeAlly = J.GetAlliesNearLoc(botTarget:GetLocation(), 1200)
			local nInRangeEnemy = J.GetEnemiesNearLoc(botTarget:GetLocation(), 1200)
			local nEnemyTowers = bot:GetNearbyTowers(900, true)

			if not (#nInRangeAlly >= #nInRangeEnemy + 2) and #nEnemyTowers == 0 then
				return BOT_ACTION_DESIRE_HIGH, bot:GetLocation() + RandomVector(nCastRange)
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderNothlProjectionEnd()
	if not J.CanCastAbility(NothlProjectionEnd) then
		return BOT_ACTION_DESIRE_NONE
	end

	local hOriginal = nil

	for _, unit in pairs(GetUnitList(UNIT_LIST_ALLIES)) do
		if J.IsValidHero(unit) and string.find(unit:GetUnitName(), 'dazzle') and unit:HasModifier('modifier_dazzle_nothl_projection_physical_body_debuff') then
			hOriginal = unit
			break
		end
	end

	local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), 1600)
	local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1600)

	if hOriginal ~= nil then
		if #nInRangeEnemy == 0 or GetUnitToUnitDistance(bot, hOriginal) > 1200 then
			return BOT_ACTION_DESIRE_HIGH
		end

		if (#nInRangeEnemy > #nInRangeAlly and not J.IsInTeamFight(bot, 1200))
		or (not J.CanCastAbility(PoisonTouch) and not J.CanCastAbility(ShallowGrave) and not J.CanCastAbility(ShadowWave) and J.GetModifierTime(bot, 'modifier_dazzle_nothl_projection_soul_debuff') <= 5.0)
		then
			nInRangeEnemy = J.GetEnemiesNearLoc(hOriginal:GetLocation(), 600)
			if #nInRangeEnemy <= 1 then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.GetBestHealTarget(hUnit, nRadius)
	local bestTarget = nil
	local bestTargetLostHealth = -1

	local nAllyCreeps = bot:GetNearbyCreeps(1600, false)
	local nAllyList = J.CombineTwoTable(nAllyHeroes, nAllyCreeps)

	for _, unit in pairs(nAllyList) do
		if  J.IsValid(unit)
        and J.IsInRange(unit, hUnit, nRadius)
		then
			local unitHealth = unit:GetHealth()
			local unitHealthMax = unit:GetMaxHealth()
			local unitHealthLost = unitHealthMax - unitHealth

			if unitHealthLost > bestTargetLostHealth then
				bestTarget = unit
				bestTargetLostHealth = unitHealthLost
			end
		end
	end

	return bestTarget
end

function X.GetEnemyDamageToAlly(hUnit, nDelay)
	local nEnemyHeroesTargetingAlly = J.GetHeroesTargetingUnit(nEnemyHeroes, hUnit)
	local totalDamage = 0

	for _, enemyHero in pairs(nEnemyHeroesTargetingAlly) do
		if J.IsValidHero(enemyHero) then
			totalDamage = totalDamage + enemyHero:GetEstimatedDamageToTarget(false, enemyHero, nDelay, DAMAGE_TYPE_ALL)
		end
	end

	return totalDamage
end

return X