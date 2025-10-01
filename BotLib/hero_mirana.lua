local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_mirana'
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
					['t15'] = {10, 0},
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
				[1] = {2,3,1,1,1,6,1,3,3,3,6,2,2,2,6},
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
				"item_mjollnir",--
				"item_aghanims_shard",
				"item_greater_crit",--
				"item_hurricane_pike",--
				"item_satanic",--
				"item_moon_shard",
				"item_butterfly",--
				"item_ultimate_scepter_2",
			},
            ['sell_list'] = {
				"item_quelling_blade", "item_black_king_bar",
				"item_wraith_band", "item_greater_crit",
				"item_magic_wand", "item_satanic",
				"item_power_treads", "item_butterfly",
			},
        },
    },
    ['pos_2'] = {
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
				[1] = {2,3,1,1,1,6,1,3,3,3,6,2,2,2,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_circlet",
				"item_slippers",
				"item_quelling_blade",

				"item_bottle",
				"item_magic_wand",
				"item_power_treads",
				"item_wraith_band",
				"item_maelstrom",
				"item_dragon_lance",
				"item_black_king_bar",--
				"item_mjollnir",--
				"item_aghanims_shard",
				"item_greater_crit",--
				"item_hurricane_pike",--
				"item_satanic",--
				"item_moon_shard",
				"item_butterfly",--
				"item_ultimate_scepter_2",
			},
            ['sell_list'] = {
				"item_quelling_blade", "item_dragon_lance",
				"item_wraith_band", "item_black_king_bar",
				"item_magic_wand", "item_greater_crit",
				"item_bottle", "item_satanic",
				"item_power_treads", "item_butterfly",
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
					['t20'] = {0, 10},
					['t15'] = {0, 10},
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
                [1] = {2,3,1,1,1,6,1,2,2,2,6,3,3,3,6},
            },
            ['buy_list'] = {
				"item_double_tango",
				"item_double_branches",
				"item_blood_grenade",
				"item_circlet",

				"item_magic_wand",
				"item_tranquil_boots",
				"item_ancient_janggo",
				"item_rod_of_atos",
				"item_force_staff",
				"item_boots_of_bearing",--
				"item_aghanims_shard",
				"item_lotus_orb",--
				"item_gungir",--
				"item_sheepstick",--
				"item_nullifier",--
				"item_moon_shard",
				"item_hurricane_pike",--
				"item_ultimate_scepter_2",
			},
            ['sell_list'] = {
				"item_circlet", "item_sheepstick",
				"item_magic_wand", "item_nullifier",
			},
        },
    },
    ['pos_5'] = {
        [1] = {
            ['talent'] = {
				[1] = {
					['t25'] = {10, 0},
					['t20'] = {0, 10},
					['t15'] = {0, 10},
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
                [1] = {2,3,1,1,1,6,1,2,2,2,6,3,3,3,6},
            },
            ['buy_list'] = {
				"item_double_tango",
				"item_double_branches",
				"item_blood_grenade",
				"item_circlet",

				"item_magic_wand",
				"item_arcane_boots",
				"item_mekansm",
				"item_rod_of_atos",
				"item_force_staff",
				"item_guardian_greaves",--
				"item_aghanims_shard",
				"item_lotus_orb",--
				"item_gungir",--
				"item_sheepstick",--
				"item_nullifier",--
				"item_moon_shard",
				"item_hurricane_pike",--
				"item_ultimate_scepter_2",
			},
            ['sell_list'] = {
				"item_circlet", "item_sheepstick",
				"item_magic_wand", "item_nullifier",
			},
        },
    },
}

local sSelectedBuild = HeroBuild[sRole][RandomInt(1, #HeroBuild[sRole])]

local nTalentBuildList = J.Skill.GetTalentBuild(J.Skill.GetRandomBuild(sSelectedBuild.talent))
local nAbilityBuildList = J.Skill.GetRandomBuild(sSelectedBuild.ability)

X['sBuyList'] = sSelectedBuild.buy_list
X['sSellList'] = sSelectedBuild.sell_list

if J.Role.IsPvNMode() or J.Role.IsAllShadow() then X['sBuyList'],X['sSellList'] = { 'PvN_ranged_carry' }, {} end

nAbilityBuildList,nTalentBuildList,X['sBuyList'],X['sSellList'] = J.SetUserHeroInit(nAbilityBuildList,nTalentBuildList,X['sBuyList'],X['sSellList']);

X['sSkillList'] = J.Skill.GetSkillList(sAbilityList, nAbilityBuildList, sTalentList, nTalentBuildList)

X['bDeafaultAbility'] = false
X['bDeafaultItem'] = false

function X.MinionThink(hMinionUnit)

	if Minion.IsValidUnit(hMinionUnit) 
	then
		Minion.IllusionThink(hMinionUnit)	
	end

end

end

local Starstorm = bot:GetAbilityByName('mirana_starfall')
local SacredArrow = bot:GetAbilityByName('mirana_arrow')
local Leap = bot:GetAbilityByName('mirana_leap')
local MoonlightShadow = bot:GetAbilityByName('mirana_invis')

local StarstormDesire
local SacredArrowDesire, SacredArrowLocation
local LeapDesire
local MoonlightShadowDesire

local fLastLeapTime = 0

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
	bot = GetBot()

	if J.CanNotUseAbility(bot) then return end

	Starstorm = bot:GetAbilityByName('mirana_starfall')
	SacredArrow = bot:GetAbilityByName('mirana_arrow')
	Leap = bot:GetAbilityByName('mirana_leap')
	MoonlightShadow = bot:GetAbilityByName('mirana_invis')

	bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	StarstormDesire = X.ConsiderStarstorm()
	if StarstormDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbility(Starstorm)
		return
	end

	SacredArrowDesire, SacredArrowLocation = X.ConsiderSacredArrow()
	if SacredArrowDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnLocation(SacredArrow, SacredArrowLocation)
		return
	end

	LeapDesire = X.ConsiderLeap()
	if LeapDesire > 0 then
		fLastLeapTime = DotaTime()
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbility(Leap)
		return
	end

	MoonlightShadowDesire = X.ConsiderMoonlightShadow()
	if MoonlightShadowDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbility(MoonlightShadow)
		return
	end
end


function X.ConsiderStarstorm()
	if not J.CanCastAbility(Starstorm) then
		return BOT_ACTION_DESIRE_NONE
	end

	local nCastPoint = Starstorm:GetCastPoint()
	local nRadius = Starstorm:GetSpecialValueInt('starfall_radius')
	local nDamage = Starstorm:GetSpecialValueInt('damage')
	local nManaCost = Starstorm:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {SacredArrow, Leap, MoonlightShadow})
	local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {Starstorm, SacredArrow, Leap, MoonlightShadow})

	for _, enemyHero in pairs(nEnemyHeroes) do
		if J.IsValidHero(enemyHero)
		and J.CanBeAttacked(enemyHero)
		and J.IsInRange(bot, enemyHero, nRadius - 75)
		and J.CanCastOnNonMagicImmune(enemyHero)
		and J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL, nCastPoint)
		and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
		and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
		and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
		and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nRadius)
		and J.CanCastOnNonMagicImmune(botTarget)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(3.0) then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, nRadius)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and not J.IsDisabled(enemyHero)
			and not enemyHero:IsDisarmed()
			then
				if J.IsChasingTarget(enemyHero, bot)
				or (#nEnemyHeroes > #nAllyHeroes and enemyHero:GetAttackTarget() == bot)
				or (botHP < 0.5 and fManaAfter > fManaThreshold1)
				then
					return BOT_ACTION_DESIRE_HIGH
				end
			end
		end
	end

	local nEnemyCreeps = bot:GetNearbyCreeps(nRadius, true)

	if J.IsPushing(bot) and #nEnemyHeroes == 0 and fManaAfter > fManaThreshold2 and bAttacking then
		if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
			if (#nEnemyCreeps >= 4 and #nAllyHeroes <= 2)
			or (#nEnemyCreeps >= 6)
			then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if J.IsDefending(bot) and fManaAfter > fManaThreshold1 and bAttacking then
		if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
			if #nEnemyCreeps >= 4 then
				return BOT_ACTION_DESIRE_HIGH
			end
		end

		local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), 0, nRadius, 0, 0)
		if nLocationAoE.count >= 3 then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsFarming(bot) and fManaAfter > fManaThreshold1 and bAttacking then
		if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
			if (#nEnemyCreeps >= 3)
			or (#nEnemyCreeps >= 2 and nEnemyCreeps[1]:IsAncientCreep())
			or (#nEnemyCreeps >= 2 and fManaAfter > 0.65 and nEnemyCreeps[1]:GetHealth() > bot:GetAttackDamage() * 3)
			then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if J.IsLaning(bot) and J.IsInLaningPhase() and fManaAfter > fManaThreshold1 then
		local nCanKillMeleeCount = 0
		local nCanKillRangedCount = 0
		for _, creep in pairs(nEnemyCreeps) do
			if  J.IsValid(creep)
			and J.CanBeAttacked(creep)
			and J.CanCastOnNonMagicImmune(creep)
			and (J.IsCore(bot) or not J.IsOtherAllysTarget(creep))
			then
				if J.WillKillTarget(creep, nDamage, DAMAGE_TYPE_MAGICAL, nCastPoint) then
					if J.IsKeyWordUnit('ranged', creep) then
						nCanKillRangedCount = nCanKillRangedCount + 1
					end

					if J.IsKeyWordUnit('melee', creep)
					or J.IsKeyWordUnit('flagbearer', creep)
					or J.IsKeyWordUnit('siege', creep)
					then
						nCanKillMeleeCount = nCanKillMeleeCount + 1
					end
				end
			end
		end

		local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), 0, nRadius, 0, 0)

		if (nCanKillRangedCount + nCanKillMeleeCount >= 3)
		or (nCanKillRangedCount >= 1 and nCanKillMeleeCount >= 1)
		or (nCanKillRangedCount >= 1 and nLocationAoE.count > 0)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsDoingRoshan(bot) then
		if J.IsRoshan( botTarget )
		and J.CanBeAttacked(botTarget)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.IsInRange(bot, botTarget, nRadius)
		and J.GetHP(botTarget) > 0.25
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

function X.ConsiderSacredArrow()
	if not J.CanCastAbility(SacredArrow) then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastRange = SacredArrow:GetCastRange()
	local nCastPoint = SacredArrow:GetCastPoint()
	local nRadius = SacredArrow:GetSpecialValueInt('arrow_width')
	local nDamage = SacredArrow:GetSpecialValueInt('#AbilityDamage')
	local nSpeed = SacredArrow:GetSpecialValueInt('arrow_speed')
	local nManaCost = SacredArrow:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Starstorm, Leap, MoonlightShadow})
	local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {Starstorm, SacredArrow, Leap, MoonlightShadow})

	local unitList = GetUnitList(UNIT_LIST_ENEMY_HEROES)

	for _, enemyHero in pairs(unitList) do
		if J.IsValidHero(enemyHero)
		and J.CanBeAttacked(enemyHero)
		and J.IsInRange(bot, enemyHero, nCastRange)
		and J.CanCastOnNonMagicImmune(enemyHero)
		then
			local eta = (GetUnitToUnitDistance(bot, enemyHero) / nSpeed) + nCastPoint
			if not J.IsEnemyUnitBetweenSourceAndTarget(bot, enemyHero, enemyHero:GetLocation(), nCastRange, nRadius) then
				if enemyHero:HasModifier('modifier_teleporting') then
					if J.GetModifierTime(enemyHero, 'modifier_teleporting') > eta then
						return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
					end
				end

				if  (J.IsDisabled(enemyHero) or enemyHero:GetCurrentMovementSpeed() < 150)
				and not J.IsInRange(bot, enemyHero, 550)
				and fManaAfter > fManaThreshold1
				then
					return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
				end

				if J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL, eta)
				and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
				and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
				and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
				and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
				then
					return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
				end
			end
		end
	end

	local nEnemyCreeps = bot:GetNearbyCreeps(1600, true)

	if J.IsFarming(bot) and #nEnemyHeroes == 0 and fManaAfter > fManaThreshold1 then
		local hTarget = J.GetMostHpUnit(nEnemyCreeps)
		if J.IsValid(hTarget)
		and J.CanBeAttacked(hTarget)
		and not J.CanKillTarget(hTarget, nDamage * 2, DAMAGE_TYPE_MAGICAL)
		and not J.CanKillTarget(hTarget, bot:GetAttackDamage() * 4, DAMAGE_TYPE_PHYSICAL)
		and not J.IsEnemyUnitBetweenSourceAndTarget(bot, hTarget, hTarget:GetLocation(), nCastRange, nRadius)
		then
			return BOT_ACTION_DESIRE_HIGH, hTarget:GetLocation()
		end
	end

    if J.IsLaning(bot) and J.IsInLaningPhase(bot) and fManaAfter > fManaThreshold1 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep)
            and J.CanBeAttacked(creep)
			and not J.IsRunning(creep)
            and string.find(creep:GetUnitName(), 'range')
			and (J.IsCore(bot) or not J.IsOtherAllysTarget(creep))
			and not J.IsEnemyUnitBetweenSourceAndTarget(bot, creep, creep:GetLocation(), nCastRange, nRadius)
            then
                local nDelay = (GetUnitToUnitDistance(bot, creep) / nSpeed) + nCastPoint
                if J.WillKillTarget(creep, nDamage, DAMAGE_TYPE_PHYSICAL, nDelay) then
					local nLocationAoE = bot:FindAoELocation(true, true, creep:GetLocation(), 0, 600, 0, 0)
					if nLocationAoE.count > 0
					or J.IsUnitTargetedByTower(creep, false)
					then
						return BOT_ACTION_DESIRE_HIGH, creep:GetLocation()
					end
                end
            end
        end
    end

	if J.IsDoingRoshan(bot) then
		if J.IsRoshan(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and not J.IsInRange(bot, botTarget, bot:GetAttackRange())
		and not J.IsEnemyUnitBetweenSourceAndTarget(bot, botTarget, botTarget:GetLocation(), nCastRange, nRadius)
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

    if (fManaAfter > 0.7 or J.IsFarming(bot) and fManaAfter > 0.4) and fManaAfter > fManaThreshold2 then
        local nNeutralCreeps = bot:GetNearbyNeutralCreeps(1600)
        for _, creep in pairs(nNeutralCreeps) do
            if  J.IsValid(creep)
            and not J.IsRunning(creep)
            and J.CanBeAttacked(creep)
			and not J.IsEnemyUnitBetweenSourceAndTarget(bot, creep, creep:GetLocation(), nCastRange, nRadius)
            and not creep:IsAncientCreep()
            then
                local sCreepName = creep:GetUnitName()
                if sCreepName == 'npc_dota_neutral_satyr_hellcaller'
                or sCreepName == 'npc_dota_neutral_polar_furbolg_ursa_warrior'
                or sCreepName == 'npc_dota_neutral_dark_troll_warlord'
                or sCreepName == 'npc_dota_neutral_centaur_khan'
                or sCreepName == 'npc_dota_neutral_enraged_wildkin'
                or sCreepName == 'npc_dota_neutral_warpine_raider'
                then
                    return BOT_ACTION_DESIRE_HIGH, creep:GetLocation()
                end
            end
        end
    end

	return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderLeap()
	if not J.CanCastAbility(Leap)
	or bot:IsRooted()
	then
		return BOT_ACTION_DESIRE_NONE
	end

	local nLeapDistance = Leap:GetSpecialValueInt('leap_distance')
	local nRestoreTime = Leap:GetSpecialValueInt('AbilityChargeRestoreTime')
	local nManaCost = Leap:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Starstorm, SacredArrow, MoonlightShadow})
	local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {Starstorm, SacredArrow, Leap, MoonlightShadow})

	local bHasLeapBuff = bot:HasModifier('modifier_mirana_leap_buff')

	local vLocation = J.GetFaceTowardDistanceLocation(bot, nLeapDistance)

	if J.IsStuck(bot) then
		if IsLocationPassable(vLocation) then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsGoingOnSomeone(bot) and not bHasLeapBuff then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nLeapDistance + bot:GetAttackRange() + 150)
		and not J.IsInRange(bot, botTarget, nLeapDistance * 0.4)
		and bot:IsFacingLocation(botTarget:GetLocation(), 20)
		then
			local nInRangeAlly = botTarget:GetNearbyHeroes(1200, false, BOT_MODE_NONE)
			local nInRangeEnemy = botTarget:GetNearbyHeroes(1200, true, BOT_MODE_NONE)

			if #nInRangeAlly >= #nInRangeEnemy
			or J.CanKillTarget(botTarget, bot:GetAttackDamage() * 3, DAMAGE_TYPE_PHYSICAL)
			then
				if IsLocationPassable(vLocation) then
					return BOT_ACTION_DESIRE_HIGH
				end
			end
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(3.0) then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and not J.IsDisabled(enemyHero)
			and not bot:IsFacingLocation(enemyHero:GetLocation(), 155)
			and (not J.IsSuspiciousIllusion(enemyHero) or botHP < 0.4)
			then
				if J.IsChasingTarget(enemyHero, bot)
				or (#nEnemyHeroes > #nAllyHeroes and enemyHero:GetAttackTarget() == bot)
				or (botHP < 0.4)
				then
					if IsLocationPassable(vLocation) then
						return BOT_ACTION_DESIRE_HIGH
					end
				end
			end
		end
	end

    if J.IsPushing(bot) and fManaAfter > fManaThreshold2 and not bAttacking and #nEnemyHeroes == 0 then
		local nLane = LANE_MID
		if bot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP then nLane = LANE_TOP end
		if bot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT then nLane = LANE_BOT end

		local vLaneFrontLocation = GetLaneFrontLocation(GetTeam(), nLane, 0)
		if GetUnitToLocationDistance(bot, vLaneFrontLocation) > 3200
		and GetUnitToLocationDistance(bot, J.GetTeamFountain()) < J.GetDistance(vLaneFrontLocation, J.GetTeamFountain())
		and DotaTime() > fLastLeapTime + nRestoreTime
		then
			if IsLocationPassable(vLocation) and bot:IsFacingLocation(vLocation, 20) then
				return BOT_ACTION_DESIRE_HIGH
			end
		end

        if J.IsValidBuilding(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nLeapDistance)
		and J.IsRunning(bot)
		and not J.IsInRange(bot, botTarget, bot:GetAttackRange())
		and bot:IsFacingLocation(botTarget:GetLocation(), 20)
        then
			if IsLocationPassable(vLocation) then
				return BOT_ACTION_DESIRE_HIGH
			end
        end
    end

    if J.IsDefending(bot) and not bAttacking and fManaAfter > fManaThreshold1 then
		local nLane = LANE_MID
		if bot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP then nLane = LANE_TOP end
		if bot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT then nLane = LANE_BOT end

		local vLaneFrontLocation = GetLaneFrontLocation(GetTeam(), nLane, 0)
		if GetUnitToLocationDistance(bot, vLaneFrontLocation) > 3200
		and GetUnitToLocationDistance(bot, J.GetTeamFountain()) > J.GetDistance(vLaneFrontLocation, J.GetTeamFountain())
		and DotaTime() > fLastLeapTime + nRestoreTime
		then
			if IsLocationPassable(vLocation) and bot:IsFacingLocation(vLocation, 20) then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
    end

	if J.IsFarming(bot) and fManaAfter > fManaThreshold1 and not bHasLeapBuff then
		if J.IsValid(botTarget)
		and J.CanBeAttacked(botTarget)
		and botTarget:IsCreep()
		and J.IsInRange(bot, botTarget, nLeapDistance + bot:GetAttackRange() + 300)
		and not J.IsInRange(bot, botTarget, nLeapDistance * 0.8)
		and bot:IsFacingLocation(botTarget:GetLocation(), 30)
		and not J.CanKillTarget(botTarget, bot:GetAttackDamage() * 3, DAMAGE_TYPE_PHYSICAL)
		and bAttacking
		and DotaTime() > fLastLeapTime + nRestoreTime
		then
			if IsLocationPassable(vLocation) then
				return BOT_ACTION_DESIRE_HIGH
			end
		end

		if bot.farm and bot.farm.location and DotaTime() > fLastLeapTime + nRestoreTime then
			local distance = GetUnitToLocationDistance(bot, bot.farm.location)
			if J.IsRunning(bot) and bot:IsFacingLocation(bot.farm.location, 45) and distance > nLeapDistance then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

    if J.IsLaning(bot) and not J.IsInLaningPhase() and fManaAfter > 0.8 and #nEnemyHeroes == 0 then
        local vLaneFrontLocation = GetLaneFrontLocation(GetTeam(), bot:GetAssignedLane(), 0)
        if GetUnitToLocationDistance(bot, vLaneFrontLocation) > 2000 and DotaTime() > fLastLeapTime + nRestoreTime then
            if IsLocationPassable(vLocation) and bot:IsFacingLocation(vLocation, 20) then
				return BOT_ACTION_DESIRE_HIGH
			end
        end
	end

	if J.IsGoingToRune(bot) and fManaAfter > fManaThreshold1 and not bHasLeapBuff then
		if bot.rune and bot.rune.location and DotaTime() > fLastLeapTime + nRestoreTime then
			local distance = GetUnitToLocationDistance(bot, bot.rune.location)
			if J.IsRunning(bot) and bot:IsFacingLocation(bot.rune.location, 30) and distance > nLeapDistance then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

    if J.IsDoingRoshan(bot) then
        local vRoshanLocation = J.GetCurrentRoshanLocation()
        if GetUnitToLocationDistance(bot, vRoshanLocation) > 3200 and #nEnemyHeroes == 0 and DotaTime() > fLastLeapTime + nRestoreTime then
			if IsLocationPassable(vLocation) and bot:IsFacingLocation(vLocation, 20) then
				return BOT_ACTION_DESIRE_HIGH
			end
        end
    end

    if J.IsDoingTormentor(bot) then
        local vTormentorLocation = J.GetTormentorLocation(GetTeam())
        if GetUnitToLocationDistance(bot, vTormentorLocation) > 3200 and #nEnemyHeroes == 0 and DotaTime() > fLastLeapTime + nRestoreTime then
			if IsLocationPassable(vLocation) and bot:IsFacingLocation(vLocation, 20) then
				return BOT_ACTION_DESIRE_HIGH
			end
        end
    end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderMoonlightShadow()
	if not J.CanCastAbility(MoonlightShadow) then
		return BOT_ACTION_DESIRE_NONE
	end

	local nManaCost = MoonlightShadow:GetManaCost()
	local nEnemyHeroesTargetingMe = J.GetHeroesTargetingUnit(nEnemyHeroes, bot)

	for i = 1, 5 do
		local allyHero = GetTeamMember(i)
		if J.IsValidHero(allyHero)
		and not J.IsRealInvisible(allyHero)
		then
			if J.IsGoingOnSomeone(allyHero) then
				local allyTarget = J.GetProperTarget(allyHero)

				if J.IsValidHero(allyTarget)
				and GetUnitToLocationDistance(allyTarget, J.GetEnemyFountain()) > 2000
				and not J.IsSuspiciousIllusion(allyTarget)
				then
					local nInRangeAlly = J.GetAlliesNearLoc(allyTarget:GetLocation(), 3500)
					local nAllyHeroesAttackingTarget = J.GetHeroesTargetingUnit(nInRangeAlly, allyTarget)
					if #nAllyHeroesAttackingTarget >= 2 then
						local vLocation = J.GetCenterOfUnits(nAllyHeroesAttackingTarget)
						if  GetUnitToLocationDistance(allyTarget, vLocation) <= 3200
						and GetUnitToLocationDistance(allyTarget, vLocation) >= 1600
						then
							return BOT_ACTION_DESIRE_HIGH
						end
					end
				end
			end

			if J.IsRetreating(allyHero) and allyHero:WasRecentlyDamagedByAnyHero(3.0) then
				local nInRangeEnemy = allyHero:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
				for _, enemyHero in pairs(nInRangeEnemy) do
					if J.IsValidHero(enemyHero)
					and not J.IsDisabled(enemyHero)
					and not enemyHero:IsDisarmed()
					then
						if (J.IsChasingTarget(enemyHero, allyHero))
						or (#nEnemyHeroes > #nAllyHeroes and enemyHero:GetAttackTarget() == allyHero)
						then
							return BOT_ACTION_DESIRE_HIGH
						end
					end
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

return X