local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_sven'
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
					['t20'] = {10, 0},
					['t15'] = {0, 10},
					['t10'] = {10, 0},
				}
            },
            ['ability'] = {
                [1] = {1,3,2,2,2,6,2,3,3,3,6,1,1,1,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_quelling_blade",
				"item_double_gauntlets",
			
				"item_magic_wand",
				"item_power_treads",
				"item_mask_of_madness",
				"item_echo_sabre",
				"item_blink",
				"item_black_king_bar",--
				"item_aghanims_shard",
				"item_greater_crit",--
				"item_harpoon",--
				"item_satanic",--
				"item_swift_blink",--
				"item_moon_shard",
				"item_ultimate_scepter_2",
				"item_bloodthorn",--
			},
            ['sell_list'] = {
				"item_quelling_blade", "item_echo_sabre",
				"item_gauntlets", "item_blink",
				"item_gauntlets", "item_black_king_bar",
				"item_magic_wand", "item_greater_crit",
				"item_mask_of_madness", "item_satanic",
				"item_power_treads", "item_bloodthorn",
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

if J.Role.IsPvNMode() or J.Role.IsAllShadow() then X['sBuyList'], X['sSellList'] = { 'PvN_str_carry' }, {"item_power_treads", 'item_quelling_blade'} end

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

local StormBolt = bot:GetAbilityByName('sven_storm_bolt')
local GreatCleave = bot:GetAbilityByName('sven_great_cleave')
local Warcry = bot:GetAbilityByName('sven_warcry')
local GodsStrength = bot:GetAbilityByName('sven_gods_strength')

local StormBoltDesire, StormBoltTarget
local WarcryDesire
local GodsStrengthDesire

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
	bot = GetBot()

	if J.CanNotUseAbility(bot) then return end

	StormBolt = bot:GetAbilityByName('sven_storm_bolt')
	GreatCleave = bot:GetAbilityByName('sven_great_cleave')
	Warcry = bot:GetAbilityByName('sven_warcry')
	GodsStrength = bot:GetAbilityByName('sven_gods_strength')

    bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	GodsStrengthDesire = X.ConsiderGodsStrength()
	if GodsStrengthDesire > 0
	then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbility(GodsStrength)
		return
	end

	StormBoltDesire, StormBoltTarget = X.ConsiderStormBolt()
	if StormBoltDesire > 0
	then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnEntity(StormBolt, StormBoltTarget)
		return

	end

	WarcryDesire = X.ConsiderWarcry()
	if WarcryDesire > 0
	then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbility(Warcry)
		return
	end
end

function X.ConsiderStormBolt()
	if not J.CanCastAbility(StormBolt) then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = StormBolt:GetCastRange()
	local nCastPoint = StormBolt:GetCastPoint()
	local nRadius = StormBolt:GetSpecialValueInt('bolt_aoe')
	local nDamage = StormBolt:GetSpecialValueInt('#AbilityDamage')
	local nSpeed = StormBolt:GetSpecialValueInt('bolt_speed')
	local nAbilityLevel = StormBolt:GetLevel()
	local nManaCost = StormBolt:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Warcry, GodsStrength})

	for _, enemyHero in pairs(nEnemyHeroes) do
		if J.IsValidHero(enemyHero)
		and J.CanBeAttacked(enemyHero)
		and J.IsInRange(bot, enemyHero, nCastRange + 300)
		and J.CanCastOnNonMagicImmune(enemyHero)
		and J.CanCastOnTargetAdvanced(enemyHero)
		and not J.IsDisabled(enemyHero)
		then
			local eta = (GetUnitToUnitDistance(bot, enemyHero) / nSpeed) + nCastPoint
			if enemyHero:HasModifier('modifier_teleporting') then
				if J.GetModifierTime(enemyHero, 'modifier_teleporting') > eta then
					return BOT_ACTION_DESIRE_HIGH, enemyHero
				end
			elseif enemyHero:IsChanneling() and fManaAfter > fManaThreshold1 then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
			end

			if  J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL, nCastPoint)
            and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
            and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
            and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
            and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero
            end
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange + 300)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.CanCastOnTargetAdvanced(botTarget)
		and not J.IsDisabled(botTarget)
		and not botTarget:IsDisarmed()
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
		and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
		and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
		then
			if nAbilityLevel >= 3 or fManaAfter > 0.65 or J.GetHP(botTarget) < 0.4 or botHP < 0.25 then
				return BOT_ACTION_DESIRE_HIGH, botTarget
			end
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and J.CanCastOnTargetAdvanced(enemyHero)
			and not J.IsDisabled(enemyHero)
			and not enemyHero:IsDisarmed()
			and bot:WasRecentlyDamagedByHero(enemyHero, 2.0)
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
			end
		end
	end

	local nEnemyCreeps = bot:GetNearbyCreeps(Min(nCastRange + 300, 1600), true)

	if J.IsPushing(bot) and #nAllyHeroes <= 2 and bAttacking and #nEnemyHeroes == 0 and fManaAfter > fManaThreshold1 + 0.2 then
		for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 5) then
                    return BOT_ACTION_DESIRE_HIGH, creep
                end
            end
        end
	end

	if J.IsDefending(bot) and #nAllyHeroes <= 2 and bAttacking and #nEnemyHeroes == 0 and fManaAfter > fManaThreshold1 then
		for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 5) then
                    return BOT_ACTION_DESIRE_HIGH, creep
                end
            end
        end
	end

	if J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold1 and nAbilityLevel >= 3 then
		for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) and not J.IsRunning(creep)
			and not J.CanKillTarget(creep, nDamage, DAMAGE_TYPE_MAGICAL)
			and not J.CanKillTarget(creep, bot:GetAttackDamage() * 3, DAMAGE_TYPE_PHYSICAL)
			then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 3)
				or (nLocationAoE.count >= 2 and creep:IsAncientCreep())
				then
                    return BOT_ACTION_DESIRE_HIGH, creep
                end
            end
        end
	end

	if J.IsLaning(bot) and J.IsInLaningPhase() and fManaAfter > fManaThreshold1 then
		for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep)
			and J.CanBeAttacked(creep)
			and not J.IsOtherAllyCanKillTarget(creep)
			then
				local eta = (GetUnitToUnitDistance(bot, creep) / nSpeed) + nCastPoint
				if J.WillKillTarget(creep, nDamage, DAMAGE_TYPE_MAGICAL, eta) then
					local sCreepName = creep:GetUnitName()
					local nLocationAoE = bot:FindAoELocation(true, true, creep:GetLocation(), 0, 600, 0, 0)
					if string.find(sCreepName, 'ranged') then
						if nLocationAoE.count > 0 or J.IsUnitTargetedByTower(creep, false) then
							return BOT_ACTION_DESIRE_HIGH, creep
						end
					end

					nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, nDamage)
					if nLocationAoE.count >= 2 and #nEnemyHeroes > 0 then
						return BOT_ACTION_DESIRE_HIGH, creep
					end
				end
            end
        end
	end

	if J.IsDoingRoshan(bot) then
		if J.IsRoshan(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange )
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.CanCastOnTargetAdvanced(botTarget)
		and not J.IsDisabled(botTarget)
		and not botTarget:IsDisarmed()
		and bAttacking
		and fManaAfter > fManaThreshold1
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	if J.IsDoingTormentor(bot) then
		if J.IsTormentor(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange )
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.CanCastOnTargetAdvanced(botTarget)
		and not J.IsDisabled(botTarget)
		and not botTarget:IsDisarmed()
		and bAttacking
		and fManaAfter > fManaThreshold1
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderWarcry()
	if not J.CanCastAbility(Warcry) then
		return BOT_ACTION_DESIRE_NONE
	end

	local nRadius = Warcry:GetSpecialValueInt('radius')
	local nManaCost = Warcry:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {StormBolt, GodsStrength})
	local bCanBeAttacked = J.CanBeAttacked(bot)

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.IsInRange(bot, botTarget, 800)
		and bot:WasRecentlyDamagedByAnyHero(2.0)
		and fManaAfter > fManaThreshold1
		and bCanBeAttacked
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(3.0) then
		if bCanBeAttacked and botHP < 0.75 then
			return BOT_ACTION_DESIRE_HIGH
		end

		local nInRangeAlly = J.GetSpecialModeAllies(bot, nRadius, BOT_MODE_RETREAT)
		if #nInRangeAlly >= 3 and fManaAfter > fManaThreshold1 then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsDoingRoshan(bot) then
		if J.IsRoshan(botTarget)
		and J.IsInRange(bot, botTarget, 800)
		and botHP < 0.5
		and bCanBeAttacked
		and bAttacking
		and fManaAfter > fManaThreshold1
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsDoingTormentor(bot) then
		if J.IsTormentor(botTarget)
		and J.IsInRange(bot, botTarget, 800)
		and botHP < 0.5
		and bCanBeAttacked
		and bAttacking
		and fManaAfter > fManaThreshold1
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if bCanBeAttacked and botHP < 0.3 and not J.IsRealInvisible(bot) then
		if bot:WasRecentlyDamagedByAnyHero(2.0)
		or bot:WasRecentlyDamagedByCreep(2.0)
		or bot:WasRecentlyDamagedByTower(2.0)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	local nWeakAllyCount = 0
	for _, allyHero in pairs(nAllyHeroes) do
		if J.IsValidHero(allyHero)
		and J.CanBeAttacked(allyHero)
		and J.GetHP(allyHero) < 0.5
		and not J.IsSuspiciousIllusion(allyHero)
		and not allyHero:HasModifier('modifier_abaddon_borrowed_time')
		and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
		and not allyHero:HasModifier('modifier_oracle_false_promise_timer')
		and not allyHero:HasModifier('modifier_sven_warcry')
		and not allyHero:HasModifier('modifier_item_crimson_guard_extra')
		then
			nWeakAllyCount = nWeakAllyCount + 1
		end
	end

	if (nWeakAllyCount >= 3 or (J.IsInTeamFight(bot, 1200) and nWeakAllyCount >= 2)) and fManaAfter > fManaThreshold1 then
		return BOT_ACTION_DESIRE_HIGH
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderGodsStrength()
	if not J.CanCastAbility(GodsStrength) then
		return BOT_ACTION_DESIRE_NONE
	end

	local nManaCost = GodsStrength:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {StormBolt, Warcry})

	if botHP < 0.25 then
		if  not bot:HasModifier('modifier_oracle_false_promise_timer')
		and not bot:HasModifier('modifier_dazzle_shallow_grave')
		then
			return BOT_ACTION_DESIRE_NONE
		end
	end

	if J.IsInTeamFight(bot, 1200) then
		if J.IsValidHero(botTarget) and J.IsInRange(bot, botTarget, 800) then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, 600)
		and not J.IsSuspiciousIllusion(botTarget)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
		then
			local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), 1200)
			local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1200)
			if not (#nInRangeAlly >= #nInRangeEnemy + 2) then
				if #nInRangeEnemy >= 2 then
					return BOT_ACTION_DESIRE_HIGH
				else
					if not botTarget:HasModifier('modifier_necrolyte_reapers_scythe') then
						return BOT_ACTION_DESIRE_HIGH
					end
				end
			end
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsDoingRoshan(bot) then
		if J.IsRoshan(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, 800)
		and J.GetHP(botTarget) > 0.4
		and bAttacking
		and fManaAfter > fManaThreshold1
		and #nEnemyHeroes == 0
		and bot:GetNetWorth() < 20000
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsDoingTormentor(bot) then
		if J.IsTormentor(botTarget)
		and J.IsInRange(bot, botTarget, 800)
		and bAttacking
		and fManaAfter > fManaThreshold1
		and #nEnemyHeroes == 0
		and bot:GetNetWorth() < 20000
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

return X
