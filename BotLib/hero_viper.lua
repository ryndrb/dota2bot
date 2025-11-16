local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_viper'
then

local RI = require(GetScriptDirectory()..'/FunLib/util_role_item')

local sUtility = {"item_heavens_halberd", "item_lotus_orb", "item_pipe"}
local sUtilityItem = RI.GetBestUtilityItem(sUtility)

local HeroBuild = {
    ['pos_1'] = {
        [1] = {
            ['talent'] = {
				[1] = {
					['t25'] = {10, 0},
					['t20'] = {10, 0},
					['t15'] = {10, 0},
					['t10'] = {10, 0},
				}
            },
            ['ability'] = {
                [1] = {1,3,1,2,1,6,1,3,2,3,6,2,3,2,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_circlet",
				"item_slippers",
				"item_quelling_blade",
			
				"item_magic_wand",
				"item_power_treads",
				"item_wraith_band",
				"item_maelstrom",
				"item_dragon_lance",
				"item_black_king_bar",--
				"item_hurricane_pike",--
				"item_mjollnir",--
				"item_aghanims_shard",
				"item_revenants_brooch",--
				"item_butterfly",--
				"item_moon_shard",
				"item_ultimate_scepter_2",
				"item_travel_boots_2",--
			},
            ['sell_list'] = {
				"item_quelling_blade", "item_black_king_bar",
				"item_wraith_band", "item_revenants_brooch",
				"item_magic_wand", "item_butterfly",
			},
        },
    },
    ['pos_2'] = {
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
                [1] = {1,3,1,2,1,6,1,3,2,3,6,2,3,2,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_circlet",
				"item_gauntlets",
				"item_quelling_blade",
			
				"item_bottle",
				"item_magic_wand",
				"item_bracer",
				"item_power_treads",
				"item_dragon_lance",
				"item_ultimate_scepter",
				"item_hurricane_pike",--
				"item_black_king_bar",--
				"item_aghanims_shard",
				"item_bloodthorn",--
				"item_sheepstick",--
				"item_butterfly",--
				"item_ultimate_scepter_2",
				"item_moon_shard",
				"item_travel_boots_2",--
			},
            ['sell_list'] = {
				"item_quelling_blade", "item_ultimate_scepter",
				"item_magic_wand", "item_black_king_bar",
				"item_bracer", "item_bloodthorn",
				"item_bottle", "item_sheepstick",
			},
        },
    },
    ['pos_3'] = {
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
                [1] = {1,3,1,3,1,6,1,2,3,3,6,2,2,2,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_quelling_blade",
				"item_double_circlet",
			
				"item_magic_wand",
				"item_boots",
				"item_double_wraith_band",
				"item_power_treads",
				"item_blade_mail",
				"item_hurricane_pike",--
				sUtilityItem,--
				"item_black_king_bar",--
				"item_aghanims_shard",
				"item_sheepstick",--
				"item_ultimate_scepter_2",
				"item_assault",--
				"item_moon_shard",
				"item_travel_boots_2",--
			},
            ['sell_list'] = {
				"item_quelling_blade", "item_hurricane_pike",
				"item_magic_wand", sUtilityItem,
				"item_wraith_band", "item_black_king_bar",
				"item_wraith_band", "item_sheepstick",
				"item_blade_mail", "item_assault",
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


X['bDeafaultAbility'] = true
X['bDeafaultItem'] = false

function X.MinionThink(hMinionUnit)
	Minion.MinionThink(hMinionUnit)
end

end

local PoisonAttack = bot:GetAbilityByName('viper_poison_attack')
local NetherToxin = bot:GetAbilityByName('viper_nethertoxin')
-- local CorrosiveSkin = bot:GetAbilityByName('viper_corrosive_skin')
local Nosedive = bot:GetAbilityByName('viper_nose_dive')
local ViperStrike = bot:GetAbilityByName('viper_viper_strike')

local PoisonAttackDesire, PoisonAttackTarget
local NetherToxinDesire, NetherToxinLocation
local NosediveDesire, NosediveLocation
local ViperStrikeDesire, ViperStrikeTarget

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
	bot = GetBot()

	if J.CanNotUseAbility(bot) then return end

	PoisonAttack = bot:GetAbilityByName('viper_poison_attack')
	NetherToxin = bot:GetAbilityByName('viper_nethertoxin')
	Nosedive = bot:GetAbilityByName('viper_nose_dive')
	ViperStrike = bot:GetAbilityByName('viper_viper_strike')

	bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	ViperStrikeDesire, ViperStrikeTarget = X.ConsiderViperStrike()
	if ViperStrikeDesire > 0 then
		J.SetQueuePtToINT(bot, true)
		bot:ActionQueue_UseAbilityOnEntity(ViperStrike, ViperStrikeTarget)
		return
	end

	NosediveDesire, NosediveLocation = X.ConsiderNosedive()
	if NosediveDesire > 0 then
		J.SetQueuePtToINT(bot, true)
		bot:ActionQueue_UseAbilityOnLocation(Nosedive, NosediveLocation)
		return
	end

	NetherToxinDesire, NetherToxinLocation = X.ConsiderNetherToxin()
	if NetherToxinDesire > 0 then
		J.SetQueuePtToINT(bot, true)
		bot:ActionQueue_UseAbilityOnLocation(NetherToxin, NetherToxinLocation)
		return
	end

	PoisonAttackDesire, PoisonAttackTarget = X.ConsiderPoisonAttack()
	if PoisonAttackDesire > 0 then
		bot:Action_ClearActions(false)
		bot:Action_UseAbilityOnEntity(PoisonAttack, PoisonAttackTarget)
		return
	end
end

function X.ConsiderPoisonAttack()
	if not J.CanCastAbility(PoisonAttack)
	or bot:IsDisarmed()
	then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = J.GetProperCastRange(false, bot, PoisonAttack:GetCastRange())
	local nAttackRange = bot:GetAttackRange()
	local nDamage = PoisonAttack:GetSpecialValueInt('damage')
	local nDuration = PoisonAttack:GetSpecialValueInt('duration')
	local nMaxStacks = PoisonAttack:GetSpecialValueInt('max_stacks')
	local nManaCost = PoisonAttack:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {NetherToxin, Nosedive, ViperStrike})

    for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemyHero)
		and J.CanBeAttacked(enemyHero)
		and J.IsInRange(bot, enemyHero, nCastRange)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and not J.IsSuspiciousIllusion(enemyHero)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
        and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
        then
			if  not J.IsRetreating(bot)
			and not J.IsRealInvisible(bot)
			and fManaAfter > fManaThreshold1
			then
				if  enemyHero:HasModifier('modifier_viper_viper_strike_slow')
				and J.IsInRange(bot, enemyHero, nCastRange + 300)
				then
					return BOT_ACTION_DESIRE_HIGH, enemyHero
				end

				if J.IsInLaningPhase()
				and J.IsInRange(bot, enemyHero, nCastRange + 150)
				and not bot:WasRecentlyDamagedByTower(5.0)
				and not bot:WasRecentlyDamagedByCreep(2.0)
				then
					return BOT_ACTION_DESIRE_HIGH, enemyHero
				end
			end

			local nCurrentStacks = J.GetModifierCount(enemyHero, 'modifier_viper_poison_attack_slow')
			if nMaxStacks > nCurrentStacks then
				if J.WillKillTarget(enemyHero, nDamage * nCurrentStacks, DAMAGE_TYPE_MAGICAL, nDuration) then
					return BOT_ACTION_DESIRE_HIGH, enemyHero
				end
			end
        end
    end

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nAttackRange + 150)
		and J.CanCastOnNonMagicImmune(botTarget)
        and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:IsMagicImmune()
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		and fManaAfter > fManaThreshold1 + 0.1
		then
			local nCurrentStacks = J.GetModifierCount(botTarget, 'modifier_viper_poison_attack_slow')

			if nMaxStacks > nCurrentStacks then
				return BOT_ACTION_DESIRE_HIGH, botTarget
			end
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and not J.IsDisabled(enemyHero)
			and not enemyHero:HasModifier('modifier_viper_poison_attack_slow')
			and enemyHero:GetAttackTarget() == bot
            then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
            end
        end
	end

    if fManaAfter > fManaThreshold1 + 0.1 then
        for _, allyHero in pairs(nAllyHeroes) do
            if  J.IsValidHero(allyHero)
            and bot ~= allyHero
            and J.IsRetreating(allyHero)
            and allyHero:WasRecentlyDamagedByAnyHero(3.0)
            and not J.IsSuspiciousIllusion(allyHero)
            then
                for _, enemyHero in pairs(nEnemyHeroes) do
                    if  J.IsValidHero(enemyHero)
                    and J.IsInRange(bot, enemyHero, nCastRange)
                    and J.CanCastOnNonMagicImmune(enemyHero)
                    and J.IsChasingTarget(enemyHero, allyHero)
                    and not J.IsDisabled(enemyHero)
					and not enemyHero:HasModifier('modifier_viper_poison_attack_slow')
                    then
						return BOT_ACTION_DESIRE_HIGH, enemyHero
                    end
                end
            end
        end

		if fManaAfter > 0.5 then
			if J.IsPushing(bot) or J.IsDefending(bot) or J.IsFarming(bot) then
				if  J.IsValid(botTarget)
				and J.CanBeAttacked(botTarget)
				and J.IsInRange(bot, botTarget, nAttackRange)
				and J.CanCastOnNonMagicImmune(botTarget)
				and not J.CanKillTarget(botTarget, bot:GetAttackDamage() * 5, DAMAGE_TYPE_PHYSICAL)
				and not J.IsRoshan(botTarget)
				and not J.IsTormentor(botTarget)
				and not botTarget:IsBuilding()
				then
					local nCurrentStacks = J.GetModifierCount(botTarget, 'modifier_viper_poison_attack_slow')
					if nMaxStacks > nCurrentStacks then
						return BOT_ACTION_DESIRE_HIGH, botTarget
					end
				end
			end
		end
    end

	if J.IsDoingRoshan(bot) then
        if  J.IsRoshan(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nAttackRange)
		and bAttacking
		and fManaAfter > fManaThreshold1 + 0.1
        then
			local nCurrentStacks = J.GetModifierCount(botTarget, 'modifier_viper_poison_attack_slow')
			if nMaxStacks > nCurrentStacks then
				return BOT_ACTION_DESIRE_HIGH, botTarget
			end
        end
    end

    if J.IsDoingTormentor(bot) then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nAttackRange)
		and bAttacking
        and fManaAfter > fManaThreshold1 + 0.1
        then
			local nCurrentStacks = J.GetModifierCount(botTarget, 'modifier_viper_poison_attack_slow')
			if nMaxStacks > nCurrentStacks then
				return BOT_ACTION_DESIRE_HIGH, botTarget
			end
        end
    end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderNetherToxin()
	if not J.CanCastAbility(NetherToxin) then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastRange = J.GetProperCastRange(false, bot, NetherToxin:GetCastRange())
	local nRadius = NetherToxin:GetSpecialValueInt('radius')
	local nManaCost = NetherToxin:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Nosedive, ViperStrike})
	local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {NetherToxin, Nosedive, ViperStrike})

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		and not botTarget:HasModifier('modifier_viper_nethertoxin')
		then
			if J.IsDisabled(botTarget)
			or not J.IsChasingTarget(bot, botTarget)
			or bot:GetCurrentMovementSpeed() < 200
			then
				if J.IsInTeamFight(bot, 1200) then
					local nLocationAoE = bot:FindAoELocation(true, true, botTarget:GetLocation(), 0, nRadius, 0, 0)
					if nLocationAoE.count >= 2 then
						return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
					end
				else
					return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
				end
			end
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, nRadius)
			and J.CanCastOnNonMagicImmune(enemyHero)
            and not J.IsSuspiciousIllusion(enemyHero)
            then
				if (#nEnemyHeroes > #nAllyHeroes and enemyHero:GetAttackTarget() == bot)
				or (botHP < 0.5)
				then
					if J.IsDisabled(enemyHero)
					or not J.IsChasingTarget(bot, enemyHero)
					or bot:GetCurrentMovementSpeed() < 200
					then
						return BOT_ACTION_DESIRE_HIGH, (bot:GetLocation() + enemyHero:GetLocation()) / 2
					end
				end
            end
        end
	end

	local nEnemyCreeps = bot:GetNearbyCreeps(nRadius, true)

	if J.IsPushing(bot) and bAttacking and fManaAfter > fManaThreshold2 and #nAllyHeroes <= 2 and #nEnemyHeroes == 0 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) and not creep:HasModifier('modifier_viper_nethertoxin') then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 4) then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

	if J.IsDefending(bot) and bAttacking and fManaAfter > fManaThreshold1 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) and not creep:HasModifier('modifier_viper_nethertoxin') then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 4) then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

	if J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold1 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) and not creep:HasModifier('modifier_viper_nethertoxin') then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 3)
				or (nLocationAoE.count >= 2 and creep:IsAncientCreep())
				then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

	if J.IsDoingRoshan(bot) then
        if  J.IsRoshan(botTarget)
		and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and bAttacking
		and fManaAfter > fManaThreshold2
		and not botTarget:HasModifier('modifier_viper_nethertoxin')
        then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
    end

    if J.IsDoingTormentor(bot) then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and bAttacking
		and fManaAfter > fManaThreshold2
		and not botTarget:HasModifier('modifier_viper_nethertoxin')
        then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
        end
    end

	return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderNosedive()
	if not J.CanCastAbility(Nosedive)
	or bot:IsRooted()
	then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastRange = J.GetProperCastRange(false, bot, Nosedive:GetCastRange())
	local nRadius = Nosedive:GetSpecialValueInt('corrosive_radius')

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.CanCastOnNonMagicImmune(botTarget)
        and not J.IsSuspiciousIllusion(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			if J.IsChasingTarget(bot, botTarget) then
				if J.IsInRange(bot, botTarget, nCastRange / 2) then
					return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
				end
			else
				if J.IsInRange(bot, botTarget, nCastRange) then
					return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
				end
			end
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
			and J.IsInRange(bot, enemyHero, 1200)
			and bot:IsFacingLocation(J.GetTeamFountain(), 30)
            and not J.IsSuspiciousIllusion(enemyHero)
            and not J.IsDisabled(enemyHero)
			and enemyHero:GetAttackTarget() == bot
            then
				if J.IsRunning(bot) then
					return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(bot:GetLocation(), J.GetTeamFountain(), nCastRange)
				end
            end
        end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderViperStrike()
	if not J.CanCastAbility(ViperStrike) then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = ViperStrike:GetCastRange()
	local nDamage = ViperStrike:GetSpecialValueInt('damage')
	local nDuration = ViperStrike:GetSpecialValueInt('duration')

	if J.IsGoingOnSomeone(bot) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidTarget(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange + 300)
			and J.CanCastOnTargetAdvanced(enemyHero)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
            and not enemyHero:HasModifier('modifier_item_aeon_disk_buff')
            then
				if enemyHero:GetUnitName() == 'npc_dota_hero_bristleback'
				or enemyHero:GetUnitName() == 'npc_dota_hero_spectre'
				or enemyHero:GetUnitName() == 'npc_dota_hero_huskar'
				or enemyHero:GetUnitName() == 'npc_dota_hero_dragon_knight'
				or enemyHero:GetUnitName() == 'npc_dota_hero_tidehunter'
				or enemyHero:GetUnitName() == 'npc_dota_hero_phantom_assassin'
				or enemyHero:GetUnitName() == 'npc_dota_hero_antimage'
				or enemyHero:GetUnitName() == 'npc_dota_hero_mars'
				or enemyHero:GetUnitName() == 'npc_dota_hero_centaur'
				or enemyHero:GetUnitName() == 'npc_dota_hero_necrolyte'
				then
					bot:SetTarget(enemyHero)
					return BOT_ACTION_DESIRE_HIGH, enemyHero
				end
            end
        end

		if math.floor(DotaTime()) % 2 == 0 then
			if  J.IsValidTarget(botTarget)
			and J.CanBeAttacked(botTarget)
			and J.IsInRange(bot, botTarget, nCastRange + 300)
			and J.CanCastOnTargetAdvanced(botTarget)
            and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
            and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
            and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
            and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
            and not botTarget:HasModifier('modifier_item_aeon_disk_buff')
			then
				return BOT_ACTION_DESIRE_HIGH, botTarget
			end
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
			and not J.IsInRange(bot, enemyHero, nCastRange / 2)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
			and J.GetHP(enemyHero) > 0.25
            and not J.IsDisabled(enemyHero)
            and not enemyHero:IsDisarmed()
            then
                if J.IsChasingTarget(enemyHero, bot)
                or (#nEnemyHeroes > #nAllyHeroes and enemyHero:GetAttackTarget() == bot)
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
		and J.CanCastOnTargetAdvanced(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and bAttacking
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

return X