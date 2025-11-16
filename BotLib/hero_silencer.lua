local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_silencer'
then

local RI = require(GetScriptDirectory()..'/FunLib/util_role_item')

local sUtility = {}
local sUtilityItem = RI.GetBestUtilityItem(sUtility)

local HeroBuild = {
    ['pos_1'] = {
        [1] = {
            ['talent'] = {
				[1] = {
					['t25'] = {0, 10},
					['t20'] = {0, 10},
					['t15'] = {10, 0},
					['t10'] = {10, 0},
				}
            },
            ['ability'] = {
				-- [1] = {2,1,2,1,2,6,2,1,1,3,6,3,3,3,6},
				[1] = {2,1,2,1,2,6,2,3,2,1,1,6,3,3,3,6}, -- +1 Glaives of Wisdom
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_faerie_fire",
				"item_double_circlet",
			
				"item_magic_wand",
				"item_boots",
				"item_double_null_talisman",
				"item_power_treads",
				"item_witch_blade",
				"item_black_king_bar",--
				"item_hurricane_pike",--
				"item_aghanims_shard",
				"item_devastator",--
				"item_bloodthorn",--
				"item_satanic",--
				"item_moon_shard",
				"item_ultimate_scepter_2",
				"item_travel_boots_2",--
			},
            ['sell_list'] = {
				"item_magic_wand", "item_hurricane_pike",
				"item_null_talisman", "item_bloodthorn",
				"item_null_talisman", "item_satanic",
			},
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
				}
            },
            ['ability'] = {
				-- [1] = {2,1,2,1,2,6,2,1,1,3,6,3,3,3,6},
				[1] = {2,1,2,1,2,6,2,3,2,1,1,6,3,3,3,6}, -- +1 Glaives of Wisdom
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_faerie_fire",
				"item_double_circlet",
			
				"item_bottle",
				"item_magic_wand",
				"item_boots",
				"item_double_null_talisman",
				"item_power_treads",
				"item_witch_blade",
				"item_force_staff",
				"item_black_king_bar",--
				"item_aghanims_shard",
				"item_hurricane_pike",--
				"item_devastator",--
				"item_bloodthorn",--
				"item_sheepstick",--
				"item_moon_shard",
				"item_ultimate_scepter_2",
				"item_travel_boots_2",--
			},
            ['sell_list'] = {
				"item_magic_wand", "item_force_staff",
				"item_null_talisman", "item_black_king_bar",
				"item_null_talisman", "item_bloodthorn",
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
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
				-- [1] = {1,2,1,3,1,6,1,3,3,3,6,2,2,2,6},
				[1] = {1,2,1,3,1,6,1,3,3,3,6,2,2,2,2,6}, -- +1 Glaives of Wisdom
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_blood_grenade",
				"item_circlet",
				"item_mantle",
			
				"item_magic_wand",
				"item_tranquil_boots",
				"item_null_talisman",
				"item_force_staff",
				"item_solar_crest",--
				"item_boots_of_bearing",--
				"item_refresher",--
				"item_aghanims_shard",
				"item_sheepstick",--
				"item_bloodthorn",--
				"item_ultimate_scepter_2",
				"item_moon_shard",
				"item_hurricane_pike",--
			},
            ['sell_list'] = {
				"item_magic_wand", "item_sheepstick",
				"item_null_talisman", "item_bloodthorn",
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
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
                -- [1] = {1,2,1,3,1,6,1,3,3,3,6,2,2,2,6},
				[1] = {1,2,1,3,1,6,1,3,3,3,6,2,2,2,2,6}, -- +1 Glaives of Wisdom
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_blood_grenade",
				"item_circlet",
				"item_mantle",
			
				"item_magic_wand",
				"item_arcane_boots",
				"item_null_talisman",
				"item_force_staff",
				"item_solar_crest",--
				"item_guardian_greaves",--
				"item_refresher",--
				"item_aghanims_shard",
				"item_sheepstick",--
				"item_bloodthorn",--
				"item_ultimate_scepter_2",
				"item_moon_shard",
				"item_hurricane_pike",--
			},
            ['sell_list'] = {
				"item_magic_wand", "item_sheepstick",
				"item_null_talisman", "item_bloodthorn",
			},
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

local ArcaneCurse = bot:GetAbilityByName('silencer_curse_of_the_silent')
local GlaivesOfWisdom = bot:GetAbilityByName('silencer_glaives_of_wisdom')
local LastWord = bot:GetAbilityByName('silencer_last_word')
local GlobalSilence = bot:GetAbilityByName('silencer_global_silence')

local ArcaneCurseDesire, ArcaneCurseLocation
local GlaivesOfWisdomDesire, GlaivesOfWisdomTarget
local LastWordDesire, LastWordTarget
local GlobalSilenceDesire

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
	bot = GetBot()

	if J.CanNotUseAbility(bot) then return end

	ArcaneCurse = bot:GetAbilityByName('silencer_curse_of_the_silent')
	GlaivesOfWisdom = bot:GetAbilityByName('silencer_glaives_of_wisdom')
	LastWord = bot:GetAbilityByName('silencer_last_word')
	GlobalSilence = bot:GetAbilityByName('silencer_global_silence')

    bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	GlobalSilenceDesire = X.ConsiderGlobalSilence()
	if GlobalSilenceDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbility(GlobalSilence)
		return
	end

	ArcaneCurseDesire, ArcaneCurseLocation = X.ConsiderArcaneCurse()
	if ArcaneCurseDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnLocation(ArcaneCurse, ArcaneCurseLocation)
		return
	end

	LastWordDesire, LastWordTarget = X.ConsiderLastWord()
	if LastWordDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		if J.CheckBitfieldFlag(LastWord:GetBehavior(), ABILITY_BEHAVIOR_POINT) then
			bot:ActionQueue_UseAbilityOnLocation(LastWord, LastWordTarget:GetLocation())
			return
		else
			bot:ActionQueue_UseAbilityOnEntity(LastWord, LastWordTarget)
			return
		end
	end

	GlaivesOfWisdomDesire, GlaivesOfWisdomTarget = X.ConsiderGlaivesOfWisdom()
	if GlaivesOfWisdomDesire > 0 then
		bot:Action_UseAbilityOnEntity(GlaivesOfWisdom, GlaivesOfWisdomTarget)
		return
	end
end

function X.ConsiderArcaneCurse()
	if not J.CanCastAbility(ArcaneCurse) then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastRange = ArcaneCurse:GetCastRange()
	local nCastPoint = ArcaneCurse:GetCastPoint()
	local nRadius = ArcaneCurse:GetSpecialValueInt('radius')
	local nFirstDamage = ArcaneCurse:GetSpecialValueInt('application_damage')
	local nDPS = ArcaneCurse:GetSpecialValueInt('damage')
	local nDuration = ArcaneCurse:GetSpecialValueInt('duration')
	local nManaCost = ArcaneCurse:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {ArcaneCurse, LastWord, GlobalSilence})
	local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {GlobalSilence})

	for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
        and J.CanCastOnNonMagicImmune(enemyHero)
		and J.CanKillTarget(enemyHero, nFirstDamage + (nDPS * nDuration), DAMAGE_TYPE_MAGICAL)
		and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
		and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
		and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
		and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
		and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
		and not enemyHero:HasModifier('modifier_silencer_curse_of_the_silent')
		and fManaAfter > fManaThreshold1
        then
			return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
        end
    end

    if J.IsGoingOnSomeone(bot) then
        if  J.IsValidTarget(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.CanCastOnNonMagicImmune(botTarget)
        and not J.IsDisabled(botTarget)
		and not botTarget:HasModifier('modifier_silencer_curse_of_the_silent')
		and fManaAfter > fManaThreshold2
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
			and not enemyHero:IsDisarmed()
			and not enemyHero:HasModifier('modifier_silencer_curse_of_the_silent')
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
			end
		end
	end

    local nEnemyCreeps = bot:GetNearbyCreeps(Min(nCastRange + 300, 1600), true)

    if J.IsPushing(bot) and bAttacking and fManaAfter > fManaThreshold1 and #nAllyHeroes <= 2 and #nEnemyHeroes == 0 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsOtherAllysTarget(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 4)
                or (nLocationAoE.count >= 3 and creep:GetHealth() >= 550)
                then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

    if J.IsDefending(bot) and bAttacking and fManaAfter > fManaThreshold1 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsOtherAllysTarget(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 4)
                or (nLocationAoE.count >= 3 and creep:GetHealth() >= 550)
                then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end

        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and not enemyHero:HasModifier('modifier_rubick_telekinesis')
            then
                local nLocationAoE = bot:FindAoELocation(true, true, enemyHero:GetLocation(), 0, nRadius, 0, 0)
                if nLocationAoE.count >= 3 then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

    if J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold1 and #nEnemyHeroes == 0 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsOtherAllysTarget(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 3)
                or (nLocationAoE.count >= 2 and creep:IsAncientCreep())
				or (nLocationAoE.count >= 1 and creep:GetHealth() >= 550)
                then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

	if not J.IsRetreating(bot) and not J.IsRealInvisible(bot) and fManaAfter > fManaThreshold1 + 0.1 and #nAllyHeroes <= 1 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, nFirstDamage + (nDPS * nDuration))
                if (nLocationAoE.count >= 5)
				or (nLocationAoE.count >= 3 and creep:IsAncientCreep())
				or (nLocationAoE.count >= 1 and string.find(creep:GetUnitName(), 'warlock_golem'))
				then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
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
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

	if J.IsDoingTormentor(bot) then
		if J.IsTormentor(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and bAttacking
		and fManaAfter > fManaThreshold1
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderGlaivesOfWisdom()
	if not J.CanCastAbility(GlaivesOfWisdom)
	or bot:IsDisarmed()
	then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local botAttackRange = bot:GetAttackRange()
	local nAttackDamage = bot:GetAttackDamage()
	local nIntDamage = GlaivesOfWisdom:GetSpecialValueInt('intellect_damage_pct') / 100 * bot:GetAttributeValue(ATTRIBUTE_INTELLECT)
	local nManaCost = GlaivesOfWisdom:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {ArcaneCurse, LastWord, GlobalSilence})

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, botAttackRange + 150)
		and J.CanCastOnNonMagicImmune(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		and not botTarget:HasModifier('modifier_item_blade_mail_reflect')
		and fManaAfter > fManaThreshold1 + 0.05
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	if fManaAfter > fManaThreshold1 + 0.2 and bAttacking then
		if J.IsPushing(bot) or J.IsDefending(bot) or J.IsFarming(bot) then
			if  J.IsValid(botTarget)
			and J.CanBeAttacked(botTarget)
			and J.IsInRange(bot, botTarget, botAttackRange)
			and J.CanCastOnNonMagicImmune(botTarget)
			and not J.CanKillTarget(botTarget, (nAttackDamage + nIntDamage) * 3, DAMAGE_TYPE_PHYSICAL)
			and not J.IsRoshan(botTarget)
			and not J.IsTormentor(botTarget)
			and not J.IsOtherAllysTarget(botTarget)
			and not botTarget:IsBuilding()
			then
				return BOT_ACTION_DESIRE_HIGH, botTarget
			end
		end
	end

	if J.IsLaning(bot) and J.IsInLaningPhase() and fManaAfter > fManaThreshold1 + 0.1 then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if  J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, botAttackRange + 150)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
			and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
			and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
			and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
			then
				if  not J.IsRealInvisible(bot)
				and not bot:WasRecentlyDamagedByTower(3.0)
				and not bot:WasRecentlyDamagedByCreep(2.0)
				and #nAllyHeroes >= #nEnemyHeroes
				then
					return BOT_ACTION_DESIRE_HIGH, enemyHero
				end
			end
		end
	end

	if J.IsDoingRoshan(bot) then
        if  J.IsRoshan(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, botAttackRange)
		and bAttacking
		and fManaAfter > fManaThreshold1 + 0.1
        then
			return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

    if J.IsDoingTormentor(bot) then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, botAttackRange)
		and bAttacking
        and fManaAfter > fManaThreshold1 + 0.1
        then
			return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderLastWord()
	if not J.CanCastAbility(LastWord) then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = J.GetProperCastRange(false, bot, LastWord:GetCastRange())
	local nCastPoint = LastWord:GetCastPoint()
	local nBaseDamage = LastWord:GetSpecialValueInt('damage')
	local fIntDamageFactor = LastWord:GetSpecialValueFloat('int_multiplier')
	local nCastTimer = LastWord:GetSpecialValueInt('debuff_duration')
	local nManaCost = LastWord:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {ArcaneCurse, GlobalSilence})

	for _, enemyHero in pairs (nEnemyHeroes) do
		if J.IsValidHero(enemyHero)
		and J.CanBeAttacked(enemyHero)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanCastOnTargetAdvanced(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange)
		and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
		and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
		and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
		and not enemyHero:HasModifier('modifier_troll_warlord_battle_trance')
		and not enemyHero:HasModifier('modifier_ursa_enrage')
        then
			local nDamage = nBaseDamage + math.abs(bot:GetAttributeValue(ATTRIBUTE_INTELLECT) - enemyHero:GetAttributeValue(ATTRIBUTE_INTELLECT)) * fIntDamageFactor
			if J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL, nCastPoint + nCastTimer) then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
			end
        end
	end

	if J.IsGoingOnSomeone(bot) then
        if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.CanCastOnTargetAdvanced(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
		and not J.IsDisabled(botTarget)
		and not botTarget:IsSilenced()
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        then
			return BOT_ACTION_DESIRE_HIGH, botTarget
        end
    end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and fManaAfter > fManaThreshold1 then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange)
			and bot:WasRecentlyDamagedByHero(enemyHero, 3.0)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and J.CanCastOnTargetAdvanced(enemyHero)
			and not J.IsDisabled(enemyHero)
			and not enemyHero:IsSilenced()
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
			end
		end
	end

	if fManaAfter > fManaThreshold1 + 0.2 and bAttacking then
		if J.IsPushing(bot) or J.IsDefending(bot) or J.IsFarming(bot) then
			if  J.IsValid(botTarget)
			and J.CanBeAttacked(botTarget)
			and J.IsInRange(bot, botTarget, nCastRange)
			and J.CanCastOnNonMagicImmune(botTarget)
			and not J.CanKillTarget(botTarget, nBaseDamage * 3, DAMAGE_TYPE_MAGICAL)
			and not J.CanKillTarget(botTarget, bot:GetAttackDamage() * 5, DAMAGE_TYPE_PHYSICAL)
			and not J.IsRoshan(botTarget)
			and not J.IsTormentor(botTarget)
			and not J.IsOtherAllysTarget(botTarget)
			and not botTarget:IsBuilding()
			then
				return BOT_ACTION_DESIRE_HIGH, botTarget
			end
		end
	end

	if J.IsDoingRoshan(bot) then
		if J.IsRoshan(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and bAttacking
		and fManaAfter > fManaThreshold1 + 0.1
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	if J.IsDoingTormentor(bot) then
		if J.IsTormentor(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and bAttacking
		and fManaAfter > fManaThreshold1 + 0.1
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderGlobalSilence()
	if not J.CanCastAbility(GlobalSilence) then
		return BOT_ACTION_DESIRE_NONE
	end

	for _, enemyHero in pairs(nEnemyHeroes) do
		if  J.IsValidHero(enemyHero)
		and enemyHero:IsChanneling()
		and enemyHero:GetLevel() >= 6
		and not J.IsSuspiciousIllusion(enemyHero)
		and not enemyHero:HasModifier('modifier_teleporting')
		and not enemyHero:IsMagicImmune()
		then
			local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), 1200)
			local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1200)
			local nAllyHeroesAttackingTarget = J.GetHeroesTargetingUnit(nAllyHeroes, enemyHero)
			local sEnemyHeroName = enemyHero:GetUnitName()

			if (sEnemyHeroName == 'npc_dota_hero_enigma')
			or (sEnemyHeroName == 'npc_dota_hero_witch_doctor')
			or (sEnemyHeroName == 'npc_dota_hero_bane')
			or (sEnemyHeroName == 'npc_dota_hero_dawnbreaker' and #nAllyHeroesAttackingTarget > 0)
			then
				if #nInRangeAlly >= #nInRangeEnemy or J.IsInTeamFight(bot, 1200) then
					return BOT_ACTION_DESIRE_HIGH
				end
			end
		end
	end

	for i = 1, 5 do
		local allyHero = GetTeamMember(i)
		if J.IsValidHero(allyHero) and J.IsInTeamFight(allyHero, 2000) then
			local nInRangeEnemy = J.GetEnemiesNearLoc(allyHero:GetLocation(), 2400)
			local count = 0

			for _, enemyHero in pairs(nInRangeEnemy) do
				if  J.IsValidHero(enemyHero)
				and not J.IsSuspiciousIllusion(enemyHero)
				and not enemyHero:HasModifier('modifier_teleporting')
				and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
				and not enemyHero:IsMagicImmune()
				and not enemyHero:IsSilenced()
				then
					count = count + 1
				end
			end

			if count >= 2 then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

return X
