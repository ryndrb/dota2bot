local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_skywrath_mage'
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
					['t15'] = {0, 10},
					['t10'] = {10, 0},
				}
            },
            ['ability'] = {
				[1] = {1,2,1,3,1,6,1,3,3,3,6,2,2,2,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_circlet",
				"item_mantle",
				"item_faerie_fire",
			
				"item_bottle",
				"item_magic_wand",
				"item_null_talisman",
				"item_arcane_boots",
				"item_rod_of_atos",
				"item_kaya",
				"item_aghanims_shard",
				"item_ultimate_scepter",
				"item_kaya_and_sange",--
				"item_black_king_bar",--
				"item_sheepstick",--
				"item_octarine_core",--
				"item_ultimate_scepter_2",
				"item_gungir",--
				"item_moon_shard",
				"item_travel_boots_2",--
			},
            ['sell_list'] = {
				"item_magic_wand", "item_ultimate_scepter",
				"item_null_talisman", "item_black_king_bar",
				"item_bottle", "item_sheepstick",
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
					['t25'] = {10, 0},
					['t20'] = {10, 0},
					['t15'] = {0, 10},
					['t10'] = {10, 0},
				}
            },
            ['ability'] = {
                [1] = {2,1,2,3,2,6,2,3,3,3,6,1,1,1,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_double_circlet",
				"item_blood_grenade",
			
				"item_magic_wand",
				"item_double_null_talisman",
				"item_tranquil_boots",
				"item_rod_of_atos",
				"item_glimmer_cape",--
				"item_aghanims_shard",
				"item_boots_of_bearing",--
				"item_solar_crest",
				"item_ultimate_scepter",
				"item_octarine_core",--
				"item_gungir",--
				"item_sheepstick",--
				"item_ultimate_scepter_2",
				"item_moon_shard",
			},
            ['sell_list'] = {
				"item_magic_wand", "item_solar_crest",
				"item_null_talisman", "item_ultimate_scepter",
				"item_null_talisman", "item_octarine_core",
			},
        },
    },
    ['pos_5'] = {
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
                [1] = {2,1,2,3,2,6,2,3,3,3,6,1,1,1,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_double_circlet",
				"item_blood_grenade",
			
				"item_magic_wand",
				"item_double_null_talisman",
				"item_arcane_boots",
				"item_rod_of_atos",
				"item_glimmer_cape",--
				"item_aghanims_shard",
				"item_guardian_greaves",--
				"item_solar_crest",
				"item_ultimate_scepter",
				"item_octarine_core",--
				"item_gungir",--
				"item_sheepstick",--
				"item_ultimate_scepter_2",
				"item_moon_shard",
			},
            ['sell_list'] = {
				"item_magic_wand", "item_solar_crest",
				"item_null_talisman", "item_ultimate_scepter",
				"item_null_talisman", "item_octarine_core",
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

X['bDeafaultAbility'] = false
X['bDeafaultItem'] = true

function X.MinionThink( hMinionUnit )

	if Minion.IsValidUnit( hMinionUnit )
	then
		Minion.IllusionThink( hMinionUnit )
	end

end

end

local ArcaneBolt = bot:GetAbilityByName('skywrath_mage_arcane_bolt')
local ConcussiveShot = bot:GetAbilityByName('skywrath_mage_concussive_shot')
local AncientSeal = bot:GetAbilityByName('skywrath_mage_ancient_seal')
local MysticFlare = bot:GetAbilityByName('skywrath_mage_mystic_flare')

local ArcaneBoltDesire, ArcaneBoltTarget
local ConcussiveShotDesire
local AncientSealDesire, AncientSealTarget
local MysticFlareDesire, MysticFlareLocation

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
	bot = GetBot()

	if J.CanNotUseAbility(bot) then return end

	ArcaneBolt = bot:GetAbilityByName('skywrath_mage_arcane_bolt')
	ConcussiveShot = bot:GetAbilityByName('skywrath_mage_concussive_shot')
	AncientSeal = bot:GetAbilityByName('skywrath_mage_ancient_seal')
	MysticFlare = bot:GetAbilityByName('skywrath_mage_mystic_flare')

    bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	ConcussiveShotDesire = X.ConsiderConcussiveShot()
	if ConcussiveShotDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbility(ConcussiveShot)
		return
	end

	AncientSealDesire, AncientSealTarget = X.ConsiderAncientSeal()
	if AncientSealDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnEntity(AncientSeal, AncientSealTarget)
		return
	end

	ArcaneBoltDesire, ArcaneBoltTarget = X.ConsiderArcaneBolt()
	if ArcaneBoltDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnEntity(ArcaneBolt, ArcaneBoltTarget)
		return
	end

	MysticFlareDesire, MysticFlareLocation = X.ConsiderMysticFlare()
	if MysticFlareDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnLocation(MysticFlare, MysticFlareLocation)
		return
	end
end

function X.ConsiderArcaneBolt()
	if not J.CanCastAbility(ArcaneBolt) then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = ArcaneBolt:GetCastRange()
	local nCastPoint = ArcaneBolt:GetCastPoint()
	local nDamage = ArcaneBolt:GetSpecialValueInt('bolt_damage') + (bot:GetAttributeValue(ATTRIBUTE_INTELLECT) * ArcaneBolt:GetSpecialValueFloat('int_multiplier'))
	local nSpeed = ArcaneBolt:GetSpecialValueInt('bolt_speed')
	local nManaCost = ArcaneBolt:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {ArcaneBolt, ConcussiveShot, AncientSeal, MysticFlare})

    for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanCastOnTargetAdvanced(enemyHero)
        then
            if J.IsInEtherealForm(enemyHero) and fManaAfter > fManaThreshold1 and not J.IsRealInvisible(bot) then
                return BOT_ACTION_DESIRE_HIGH, enemyHero
            end

			local eta = (GetUnitToUnitDistance(bot, enemyHero) / nSpeed) + nCastPoint

            if J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL, eta)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
            and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero
            end

			if fManaAfter > fManaThreshold1 then
				if not J.IsRetreating(bot) and not J.IsRealInvisible(bot) and not J.IsGoingOnSomeone(bot) then
					if  not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
					and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
					and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
					and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
					then
						if (#nAllyHeroes >= #nEnemyHeroes and fManaAfter > fManaThreshold1 + 0.15)
						or (J.GetHP(enemyHero) < 0.2)
						or (enemyHero:HasModifier('modifier_skywrath_mage_ancient_seal'))
						then
							return BOT_ACTION_DESIRE_HIGH, enemyHero
						end
					end
				end
			end
        end
    end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange + 150)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.CanCastOnTargetAdvanced(botTarget)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
		and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	if J.IsRetreating( bot ) and not J.IsRealInvisible(bot) then
		for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and not J.IsInRange(bot, enemyHero, nCastRange / 2)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and bot:WasRecentlyDamagedByHero(enemyHero, 3.0)
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero
            end
        end
	end

	if fManaAfter > fManaThreshold1 and bAttacking then
		if J.IsPushing(bot) or J.IsDefending(bot) or J.IsFarming(bot) then
			if  J.IsValid(botTarget)
			and J.CanBeAttacked(botTarget)
			and J.IsInRange(bot, botTarget, nCastRange)
			and J.CanCastOnNonMagicImmune(botTarget)
			and J.CanCastOnTargetAdvanced(botTarget)
			and not J.CanKillTarget(botTarget, bot:GetAttackDamage() * 3.5, DAMAGE_TYPE_PHYSICAL)
			and not J.IsRoshan(botTarget)
			and not J.IsTormentor(botTarget)
			and not J.IsOtherAllysTarget(botTarget)
			and not botTarget:IsBuilding()
			then
				return BOT_ACTION_DESIRE_HIGH, botTarget
			end
		end
	end

	if J.IsLaning(bot) and J.IsInLaningPhase() and fManaAfter > fManaThreshold1 then
		local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(Min(nCastRange + 300, 1600), true)
		for _, creep in pairs(nEnemyLaneCreeps) do
			if J.IsValid(creep)
			and J.CanBeAttacked(creep)
			and not J.IsOtherAllysTarget(creep)
			and not J.CanKillTarget( creep, bot:GetAttackDamage(), DAMAGE_TYPE_PHYSICAL)
			then
				local eta = (GetUnitToUnitDistance(bot, creep) / nSpeed) + nCastPoint
				if J.WillKillTarget(creep, nDamage, DAMAGE_TYPE_MAGICAL, eta) then
					local nLocationAoE = bot:FindAoELocation(true, true, creep:GetLocation(), 0, 600, 0, 0)
					if nLocationAoE.count > 0 or J.IsUnitTargetedByTower(creep, false) then
						return BOT_ACTION_DESIRE_HIGH, creep
					end
				end
			end
		end
	end

	if J.IsDoingRoshan(bot) then
		if J.IsRoshan(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
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

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderConcussiveShot()
	if not J.CanCastAbility(ConcussiveShot) then
		return BOT_ACTION_DESIRE_NONE
	end

	local nCastPoint = ConcussiveShot:GetCastPoint()
	local nRadius = ConcussiveShot:GetSpecialValueInt('launch_radius')
	local nDamageRadius = ConcussiveShot:GetSpecialValueInt('slow_radius')
	local nDamage = ConcussiveShot:GetSpecialValueInt('damage')
	local nSpeed = ConcussiveShot:GetSpecialValueInt('speed')
	local nManaCost = ConcussiveShot:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {ArcaneBolt, AncientSeal, MysticFlare})

	local closestTarget = nEnemyHeroes[1]

	if  J.IsValidHero(closestTarget)
	and J.CanBeAttacked(closestTarget)
	and J.IsInRange(bot, closestTarget, nRadius)
	and J.CanCastOnNonMagicImmune(closestTarget)
	then
		if J.IsInEtherealForm(closestTarget) and fManaAfter > fManaThreshold1 and not J.IsRealInvisible(bot) then
			return BOT_ACTION_DESIRE_HIGH
		end

		local eta = (GetUnitToUnitDistance(bot, closestTarget) / nSpeed) + nCastPoint

		if J.WillKillTarget(closestTarget, nDamage, DAMAGE_TYPE_MAGICAL, eta)
		and not closestTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not closestTarget:HasModifier('modifier_dazzle_shallow_grave')
		and not closestTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		and not closestTarget:HasModifier('modifier_oracle_false_promise_timer')
		and not closestTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
		then
			return BOT_ACTION_DESIRE_HIGH
		end

		if fManaAfter > fManaThreshold1 then
			if not J.IsRetreating(bot) and not J.IsRealInvisible(bot) and not J.IsGoingOnSomeone(bot) then
				if  not closestTarget:HasModifier('modifier_abaddon_borrowed_time')
				and not closestTarget:HasModifier('modifier_dazzle_shallow_grave')
				and not closestTarget:HasModifier('modifier_necrolyte_reapers_scythe')
				and not closestTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
				then
					if (#nAllyHeroes >= #nEnemyHeroes and fManaAfter > fManaThreshold1 + 0.15)
					or (J.GetHP(closestTarget) < 0.2)
					or (closestTarget:HasModifier('modifier_skywrath_mage_ancient_seal'))
					then
						return BOT_ACTION_DESIRE_HIGH
					end
				end
			end
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidHero(closestTarget)
		and J.CanCastOnNonMagicImmune(closestTarget)
		and J.IsInRange(bot, closestTarget, nRadius)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
		if J.IsValidHero(closestTarget)
		and J.CanBeAttacked(closestTarget)
		and J.CanCastOnNonMagicImmune(closestTarget)
		and J.IsInRange(bot, closestTarget, nRadius)
		then
			if bot:WasRecentlyDamagedByHero(closestTarget, 2.0) or botHP < 0.4 then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	local nEnemyCreeps = bot:GetNearbyCreeps(Min(nRadius, 1600), true)
	closestTarget = nEnemyCreeps[1]

	if J.IsPushing(bot) and bAttacking and fManaAfter > fManaThreshold1 + 0.1 and #nAllyHeroes <= 3 and #nEnemyHeroes == 0 then
		local creep = closestTarget
		if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
			local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
			if (nLocationAoE.count >= 3)
			or (nLocationAoE.count >= 2 and creep:GetHealth() >= 550)
			or (nLocationAoE.count >= 1 and creep:GetHealth() >= 800)
			then
				return BOT_ACTION_DESIRE_HIGH, creep
			end
		end
	end

	if J.IsDefending(bot) and bAttacking and fManaAfter > fManaThreshold1 then
		local creep = closestTarget
		if J.IsValid(creep) and J.CanBeAttacked(creep) and #nEnemyHeroes == 0 then
			local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
			if (nLocationAoE.count >= 3)
			or (nLocationAoE.count >= 2 and creep:GetHealth() >= 550)
			then
				return BOT_ACTION_DESIRE_HIGH, creep
			end
		end

		if  J.IsValidHero(closestTarget)
		and J.CanBeAttacked(closestTarget)
		and J.IsInRange(bot, closestTarget, nRadius)
		and J.CanCastOnNonMagicImmune(closestTarget)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold1 + 0.1 and #nEnemyHeroes == 0 then
		local creep = closestTarget
		if J.IsValid(creep) and J.CanBeAttacked(creep) then
			local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
			if (nLocationAoE.count >= 2)
			or (nLocationAoE.count >= 1 and creep:IsAncientCreep())
			or (nLocationAoE.count >= 1 and creep:GetHealth() >= 550)
			then
				return BOT_ACTION_DESIRE_HIGH, creep
			end
		end
	end

    if J.IsDoingRoshan(bot) then
        if  J.IsRoshan(closestTarget)
        and J.CanBeAttacked(closestTarget)
        and J.CanCastOnNonMagicImmune(closestTarget)
        and J.IsInRange(bot, closestTarget, nRadius)
		and #nEnemyHeroes == 0
        and bAttacking
        and fManaAfter > fManaThreshold1 + 0.1
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsDoingTormentor(bot) then
        if  J.IsTormentor(closestTarget)
        and J.IsInRange(bot, closestTarget, nRadius)
		and #nEnemyHeroes == 0
        and bAttacking
        and fManaAfter > fManaThreshold1 + 0.1
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderAncientSeal()
	if not J.CanCastAbility(AncientSeal) then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = AncientSeal:GetCastRange()
	local nCastPoint = AncientSeal:GetCastPoint()
	local nManaCost = AncientSeal:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {ArcaneBolt, ConcussiveShot, MysticFlare})
	local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {ArcaneBolt, ConcussiveShot, AncientSeal, MysticFlare})

	for _, enemyHero in pairs(nEnemyHeroes) do
		if J.IsValidHero(enemyHero)
		and J.CanBeAttacked(enemyHero)
		and J.IsInRange(bot, enemyHero, nCastRange)
		and J.CanCastOnNonMagicImmune(enemyHero)
		and J.CanCastOnTargetAdvanced(enemyHero)
		and not enemyHero:HasModifier('modifier_teleporting')
		then
			if enemyHero:IsCastingAbility() or enemyHero:IsChanneling() then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
			end
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.CanCastOnTargetAdvanced(botTarget)
		and not J.IsDisabled(botTarget)
		and not botTarget:IsSilenced()
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange )
			and J.CanCastOnNonMagicImmune(enemyHero)
			and J.CanCastOnTargetAdvanced(enemyHero)
			and not J.IsDisabled(enemyHero)
			and not enemyHero:IsSilenced()
			and bot:WasRecentlyDamagedByHero(enemyHero, 3.0)
			then
				if enemyHero:GetMana() > 100 or enemyHero:IsUsingAbility() or enemyHero:IsCastingAbility() then
					return BOT_ACTION_DESIRE_HIGH, enemyHero
				end
			end
		end
	end

	if J.IsDoingRoshan(bot) then
		if J.IsRoshan(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and J.CanBeAttacked(botTarget)
		and bAttacking
		and fManaAfter > fManaThreshold2
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	if J.IsDoingTormentor(bot) then
		if J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and bAttacking
		and fManaAfter > fManaThreshold2
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderMysticFlare()
	if not J.CanCastAbility(MysticFlare) then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastRange = MysticFlare:GetCastRange()
	local nCastPoint = MysticFlare:GetCastPoint()
	local nRadius = MysticFlare:GetSpecialValueInt('radius')
	local nDamage = MysticFlare:GetSpecialValueInt('damage')
	local nManaCost = MysticFlare:GetManaCost()

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.CanCastOnNonMagicImmune( botTarget )
		and J.IsInRange(bot, botTarget, nCastRange)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
		and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
		and not botTarget:HasModifier('modifier_troll_warlord_battle_trance')
		and not botTarget:HasModifier('modifier_ursa_enrage')
		then
			if J.IsDisabled(botTarget) or botTarget:GetCurrentMovementSpeed() < 200 then
				return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

return X
