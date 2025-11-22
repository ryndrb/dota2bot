local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_queenofpain'
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
					['t15'] = {10, 0},
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
                [1] = {3,1,1,2,3,6,3,3,2,2,6,2,1,1,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_faerie_fire",
				"item_circlet",
				"item_mantle",
			
				"item_bottle",
				"item_magic_wand",
				"item_power_treads",
				"item_null_talisman",
				"item_witch_blade",
				"item_kaya",
				"item_aghanims_shard",
				"item_black_king_bar",--
				"item_kaya_and_sange",--
				"item_ultimate_scepter",
				"item_devastator",--
				"item_shivas_guard",--
				"item_octarine_core",--
				"item_ultimate_scepter_2",
				"item_moon_shard",
				"item_travel_boots_2",--
			},
            ['sell_list'] = {
				"item_magic_wand", "item_black_king_bar",
				"item_null_talisman", "item_ultimate_scepter",
				"item_bottle", "item_shivas_guard",
			},
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
                [1] = {3,1,1,2,3,6,3,3,2,2,6,2,1,1,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_faerie_fire",
				"item_circlet",
				"item_mantle",
			
				"item_magic_wand",
				"item_power_treads",
				"item_null_talisman",
				"item_blade_mail",
				"item_pipe",--
				"item_rod_of_atos",
				"item_black_king_bar",--
				"item_aghanims_shard",
				"item_shivas_guard",--
				"item_gungir",--
				"item_ultimate_scepter_2",
				"item_sheepstick",--
				"item_travel_boots_2",--
				"item_moon_shard",
			},
            ['sell_list'] = {
				"item_magic_wand", "item_black_king_bar",
				"item_null_talisman", "item_shivas_guard",
				"item_blade_mail", "item_sheepstick",
			},
        },
    },
    ['pos_4'] = {
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
                [1] = {1,3,1,2,1,6,1,2,2,2,3,6,3,3,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_faerie_fire",
				"item_magic_stick",
				"item_blood_grenade",
			
				"item_tranquil_boots",
				"item_magic_wand",
				"item_blade_mail",
				"item_ancient_janggo",
				"item_force_staff",
				"item_black_king_bar",--
				"item_boots_of_bearing",--
				"item_aghanims_shard",
				"item_shivas_guard",--
				"item_octarine_core",--
				"item_ultimate_scepter_2",
				"item_sheepstick",--
				"item_moon_shard",
				"item_hurricane_pike",--
			},
            ['sell_list'] = {
				"item_magic_wand", "item_octarine_core",
				"item_blade_mail", "item_sheepstick",
			},
        },
    },
    ['pos_5'] = {
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
                [1] = {1,3,1,2,1,6,1,2,2,2,3,6,3,3,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_faerie_fire",
				"item_magic_stick",
				"item_blood_grenade",
			
				"item_arcane_boots",
				"item_magic_wand",
				"item_blade_mail",
				"item_mekansm",
				"item_force_staff",
				"item_guardian_greaves",--
				"item_black_king_bar",--
				"item_aghanims_shard",
				"item_shivas_guard",--
				"item_octarine_core",--
				"item_ultimate_scepter_2",
				"item_sheepstick",--
				"item_moon_shard",
				"item_hurricane_pike",--
			},
            ['sell_list'] = {
				"item_magic_wand", "item_octarine_core",
				"item_blade_mail", "item_sheepstick",
			},
        },
    },
}

local sSelectedBuild = HeroBuild[sRole][RandomInt(1, #HeroBuild[sRole])]

local nTalentBuildList = J.Skill.GetTalentBuild(J.Skill.GetRandomBuild(sSelectedBuild.talent))
local nAbilityBuildList = J.Skill.GetRandomBuild(sSelectedBuild.ability)

X['sBuyList'] = sSelectedBuild.buy_list
X['sSellList'] = sSelectedBuild.sell_list

if J.Role.IsPvNMode() or J.Role.IsAllShadow() then X['sBuyList'],X['sSellList'] = { 'PvN_mage' }, {} end

nAbilityBuildList,nTalentBuildList,X['sBuyList'],X['sSellList'] = J.SetUserHeroInit(nAbilityBuildList,nTalentBuildList,X['sBuyList'],X['sSellList']);

X['sSkillList'] = J.Skill.GetSkillList(sAbilityList, nAbilityBuildList, sTalentList, nTalentBuildList)

X['bDeafaultAbility'] = false
X['bDeafaultItem'] = true

function X.MinionThink(hMinionUnit)

	if Minion.IsValidUnit(hMinionUnit) 
	then
		Minion.IllusionThink(hMinionUnit)	
	end

end

end

local ShadowStrike = bot:GetAbilityByName('queenofpain_shadow_strike')
local Blink = bot:GetAbilityByName('queenofpain_blink')
local ScreamOfPain = bot:GetAbilityByName('queenofpain_scream_of_pain')
local SonicWave = bot:GetAbilityByName('queenofpain_sonic_wave')

local ShadowStrikeDesire, ShadowStrikeTarget
local BlinkDesire, BlinkLocation
local ScreamOfPainDesire
local SonicWaveDesire, SonicWaveLocation

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
	bot = GetBot()

	if J.CanNotUseAbility(bot) then return end

	ShadowStrike = bot:GetAbilityByName('queenofpain_shadow_strike')
	Blink = bot:GetAbilityByName('queenofpain_blink')
	ScreamOfPain = bot:GetAbilityByName('queenofpain_scream_of_pain')
	SonicWave = bot:GetAbilityByName('queenofpain_sonic_wave')

    bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	BlinkDesire, BlinkLocation = X.ConsiderBlink()
	if BlinkDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnLocation(Blink, BlinkLocation)
		return
	end

	ShadowStrikeDesire, ShadowStrikeTarget = X.ConsiderShadowStrike()
	if ShadowStrikeDesire > 0 then
		J.SetQueuePtToINT(bot, false)

		if J.CheckBitfieldFlag(ShadowStrike:GetBehavior(), ABILITY_BEHAVIOR_POINT) then
			bot:ActionQueue_UseAbilityOnLocation(ShadowStrike, ShadowStrikeTarget:GetLocation())
		else
			bot:ActionQueue_UseAbilityOnEntity(ShadowStrike, ShadowStrikeTarget)
		end
		return
	end

	SonicWaveDesire, SonicWaveLocation = X.ConsiderSonicWave()
	if SonicWaveDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnLocation(SonicWave, SonicWaveLocation)
		return
	end

	ScreamOfPainDesire = X.ConsiderScreamOfPain()
	if ScreamOfPainDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbility(ScreamOfPain)
		return
	end
end

function X.ConsiderShadowStrike()
	if not J.CanCastAbility(ShadowStrike) then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = ShadowStrike:GetCastRange()
	local nCastPoint = ShadowStrike:GetCastPoint()
	local nInitDamage = ShadowStrike:GetSpecialValueInt('strike_damage')
	local nDPS = ShadowStrike:GetSpecialValueInt('duration_damage')
	local nSpeed = ShadowStrike:GetSpecialValueInt('projectile_speed')
	local nDuration = ShadowStrike:GetSpecialValueFloat('duration')
	local nDamageInterval = ShadowStrike:GetSpecialValueFloat('damage_interval')
	local nManaCost = ShadowStrike:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {Blink, ScreamOfPain, SonicWave})
	local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {ShadowStrike, Blink, ScreamOfPain, SonicWave})

	for _, enemyHero in pairs(nEnemyHeroes) do
		if J.IsValidHero(enemyHero)
		and J.CanBeAttacked(enemyHero)
		and J.IsInRange(bot, enemyHero, nCastRange + 300)
		and J.CanCastOnNonMagicImmune(enemyHero)
		and J.CanCastOnTargetAdvanced(enemyHero)
		and not enemyHero:HasModifier('modifier_queenofpain_shadow_strike')
		and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
		and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
		then
			local eta = (GetUnitToUnitDistance(bot, enemyHero) / nSpeed) + nCastPoint
			if J.WillKillTarget(enemyHero, nInitDamage + nDPS * (nDuration / nDamageInterval), DAMAGE_TYPE_MAGICAL, eta) then
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
		and not J.IsChasingTarget(bot, botTarget)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
		and not botTarget:HasModifier('modifier_queenofpain_shadow_strike')
        then
            return BOT_ACTION_DESIRE_HIGH, botTarget
        end

		if fManaAfter > fManaThreshold1 then
			for _, enemyHero in pairs(nEnemyHeroes) do
				if J.IsValidHero(enemyHero)
				and J.CanBeAttacked(enemyHero)
				and J.IsInRange(bot, enemyHero, nCastRange + 300)
				and J.CanCastOnNonMagicImmune(enemyHero)
				and J.CanCastOnTargetAdvanced(enemyHero)
				and not enemyHero:HasModifier('modifier_queenofpain_shadow_strike')
				and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
				then
					return BOT_ACTION_DESIRE_HIGH, enemyHero
				end
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
			and not enemyHero:HasModifier('modifier_queenofpain_shadow_strike')
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
			end
		end
	end

	local nEnemyCreeps = bot:GetNearbyCreeps(Min(nCastRange + 300, 1600), true)

	if (J.IsPushing(bot) and bAttacking and fManaAfter > fManaThreshold2 and #nAllyHeroes <= 2 and #nEnemyHeroes <= 1)
	or (J.IsDefending(bot) and bAttacking and fManaAfter > fManaThreshold1 and #nEnemyHeroes == 0)
	or (J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold1)
	then
		local hTargetCreep = nil
		local hTargetCreepHealth = 0
		for _, creep in pairs(nEnemyCreeps) do
			if J.IsValid(creep)
			and J.CanBeAttacked(creep)
			and J.CanCastOnTargetAdvanced(creep)
			and not J.CanKillTarget(creep, bot:GetAttackDamage() * 5, DAMAGE_TYPE_PHYSICAL)
			and not J.IsOtherAllysTarget(creep)
			then
				local creepHealth = creep:GetHealth()
				if creepHealth > hTargetCreepHealth then
					hTargetCreep = creep
					hTargetCreepHealth = creepHealth
				end
			end
		end

		if hTargetCreep then
			return BOT_ACTION_DESIRE_HIGH, hTargetCreep
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

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderBlink()
	if not J.CanCastAbility(Blink)
	or bot:IsRooted()
	or bot:HasModifier('modifier_bloodseeker_rupture')
	then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastRange = Blink:GetCastRange()
	local nCastRangeMin = Blink:GetSpecialValueInt('min_blink_range')
	local nCastPoint = Blink:GetCastPoint()
	local botAttackRange = bot:GetAttackRange()
	local nManaCost = Blink:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {ShadowStrike, Blink, ScreamOfPain, SonicWave})

	if J.CanCastAbility(ScreamOfPain) and (bot:GetMana() > (Blink:GetManaCost() + ScreamOfPain:GetManaCost() + 100)) then
		if not J.IsRetreating(bot) then
			local nRadius = ScreamOfPain:GetSpecialValueInt('area_of_effect')
			local nDamage = ScreamOfPain:GetSpecialValueInt('damage')
			for _, enemyHero in pairs(nEnemyHeroes) do
				if J.IsValidHero(enemyHero)
				and J.CanBeAttacked(enemyHero)
				and J.IsInRange(bot, enemyHero, nCastRange)
				and not J.IsInRange(bot, enemyHero, nCastRangeMin)
				and not J.IsInRange(bot, enemyHero, botAttackRange)
				and J.CanCastOnNonMagicImmune(enemyHero)
				and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
				and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
				and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
				and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
				then
					local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), 1200)
					local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1200)
					if #nInRangeAlly >= #nInRangeEnemy then
						if J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL, nCastPoint + ScreamOfPain:GetCastPoint()) then
							bot:SetTarget(enemyHero)
							return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
						end
					end
				end
			end
		end
	end

	if J.IsStuck(bot) then
		return BOT_ACTION_DESIRE_ABSOLUTE, J.GetTeamFountain()
	end

	if  not bot:IsMagicImmune()
	and (  J.IsStunProjectileIncoming(bot, 600)
		or J.IsUnitTargetProjectileIncoming(bot, 400)
		or (J.GetAttackProjectileDamageByRange(bot, 800) > bot:GetHealth())
		or (not bot:HasModifier('modifier_sniper_assassinate') and J.IsWillBeCastUnitTargetSpell(bot, 400)))
	then
		return BOT_ACTION_DESIRE_HIGH, J.GetTeamFountain()
	end

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange + 300)
		and GetUnitToLocationDistance(botTarget, J.GetEnemyFountain()) > 600
		and not J.IsInRange(bot, botTarget, nCastRangeMin)
		and not J.IsInRange(bot, botTarget, botAttackRange)
		and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		and fManaAfter > fManaThreshold1
		then
			local vLocation = botTarget:GetLocation()
			if J.IsChasingTarget(bot, botTarget) and not J.IsInRange(bot, botTarget, 500) then
				vLocation = J.VectorAway(botTarget:GetLocation(), bot:GetLocation(), 300)
			end

			if J.IsInLaningPhase() then
				local nEnemyTowers = botTarget:GetNearbyTowers(1000, false)
				if #nEnemyTowers == 0 or (J.IsValidBuilding(nEnemyTowers[1]) and nEnemyTowers[1] ~= bot) then
					return BOT_ACTION_DESIRE_HIGH, vLocation
				end
			else
				return BOT_ACTION_DESIRE_HIGH, vLocation
			end
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
		if not bot:HasModifier('modifier_fountain_aura_buff') then
			return BOT_ACTION_DESIRE_HIGH, J.GetTeamFountain()
		end
	end

	if J.IsPushing(bot) and fManaAfter > fManaThreshold1 + 0.2 then
		local nLane = LANE_MID
		if bot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP then nLane = LANE_TOP end
		if bot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT then nLane = LANE_BOT end

		local vLaneFrontLocation = GetLaneFrontLocation(GetTeam(), nLane, 0)
		if GetUnitToLocationDistance(bot, vLaneFrontLocation) > nCastRange then
			if J.IsRunning(bot) and IsLocationPassable(vLaneFrontLocation) then
				return BOT_ACTION_DESIRE_HIGH, vLaneFrontLocation
			end
		end
	end

	if J.IsDefending(bot) and fManaAfter > fManaThreshold1 then
		local nLane = LANE_MID
		if bot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP then nLane = LANE_TOP end
		if bot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT then nLane = LANE_BOT end

		local vLaneFrontLocation = GetLaneFrontLocation(GetTeam(), nLane, 0)
		if GetUnitToLocationDistance(bot, vLaneFrontLocation) > nCastRange then
			if J.IsRunning(bot) and IsLocationPassable(vLaneFrontLocation) then
				return BOT_ACTION_DESIRE_HIGH, vLaneFrontLocation
			end
		end
	end

	if J.IsFarming(bot) and fManaAfter > fManaThreshold1 + 0.1 then
		if bot.farm and bot.farm.location then
			local distance = GetUnitToLocationDistance(bot, bot.farm.location)
			if J.IsRunning(bot) and distance > nCastRange / 2 and IsLocationPassable(bot.farm.location) then
				return BOT_ACTION_DESIRE_HIGH, bot.farm.location
			end
		end
	end

	if J.IsLaning(bot) and J.IsInLaningPhase() and DotaTime() > 0 and fManaAfter > 0.8 then
		local vLaneFrontLocation = GetLaneFrontLocation(GetTeam(), bot:GetAssignedLane(), 0)
		if GetUnitToLocationDistance(bot, vLaneFrontLocation) > 2000 and #nEnemyHeroes <= 1 then
			if J.IsRunning(bot) and IsLocationPassable(vLaneFrontLocation) then
				return BOT_ACTION_DESIRE_HIGH, vLaneFrontLocation
			end
		end
	end

	if J.IsGoingToRune(bot) and fManaAfter > fManaThreshold1 + 0.1 then
		if bot.rune and bot.rune.location then
			local distance = GetUnitToLocationDistance(bot, bot.rune.location)
			if J.IsRunning(bot) and distance > nCastRange / 2 and IsLocationPassable(bot.rune.location) then
				return BOT_ACTION_DESIRE_HIGH, bot.rune.location
			end
		end
	end

	if J.IsDoingRoshan(bot) then
		local vRoshanLocation = J.GetCurrentRoshanLocation()
		if  GetUnitToLocationDistance(bot, vRoshanLocation) > 2000
		and #nEnemyHeroes <= 1
		and fManaAfter > fManaThreshold1 + 0.1
		then
			if J.IsRunning(bot) and IsLocationPassable(vRoshanLocation) then
				return BOT_ACTION_DESIRE_HIGH, vRoshanLocation
			end
		end
	end

	if J.IsDoingTormentor(bot) then
		local vTormentorLocation = J.GetTormentorLocation(GetTeam())
		if  GetUnitToLocationDistance(bot, vTormentorLocation) > 2000
		and #nEnemyHeroes <= 1
		and fManaAfter > fManaThreshold1 + 0.1
		then
			if J.IsRunning(bot) and IsLocationPassable(vTormentorLocation) then
				return BOT_ACTION_DESIRE_HIGH, vTormentorLocation
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderScreamOfPain()
	if not J.CanCastAbility(ScreamOfPain) then
		return BOT_ACTION_DESIRE_NONE
	end

	local nCastPoint = ScreamOfPain:GetCastPoint()
	local nRadius = ScreamOfPain:GetSpecialValueInt('area_of_effect')
	local nDamage = ScreamOfPain:GetSpecialValueInt('damage')
	local nManaCost = ScreamOfPain:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {ShadowStrike, Blink, SonicWave})

	for _, enemyHero in pairs(nEnemyHeroes) do
		if J.IsValidHero(enemyHero)
		and J.CanBeAttacked(enemyHero)
		and J.IsInRange(bot, enemyHero, nRadius)
		and J.CanCastOnNonMagicImmune(enemyHero)
		and J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
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
		and J.IsInRange(bot, botTarget, nRadius - botTarget:GetBoundingRadius())
		and J.CanCastOnMagicImmune(botTarget)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
        and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, nRadius)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and bot:WasRecentlyDamagedByHero(enemyHero, 5.0)
			and not J.IsDisabled(enemyHero)
			then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	local nEnemyCreeps = bot:GetNearbyCreeps(nRadius, true)

	if J.IsPushing(bot) and bAttacking and fManaAfter > fManaThreshold1 and #nAllyHeroes <= 3 then
		if J.CanBeAttacked(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) and J.CanCastOnNonMagicImmune(nEnemyCreeps[1]) then
			if (#nEnemyCreeps >= 4)
			or (#nEnemyCreeps >= 3 and string.find(nEnemyCreeps[1]:GetUnitName(), 'upgraded'))
			or (#nEnemyCreeps >= 3 and nEnemyCreeps[1]:GetHealth() >= 500)
			then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if J.IsDefending(bot) and bAttacking and fManaAfter > fManaThreshold1 then
		if J.CanBeAttacked(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) and J.CanCastOnNonMagicImmune(nEnemyCreeps[1]) then
			if (#nEnemyCreeps >= 4)
			or (#nEnemyCreeps >= 3 and string.find(nEnemyCreeps[1]:GetUnitName(), 'upgraded'))
			or (#nEnemyCreeps >= 3 and nEnemyCreeps[1]:GetHealth() >= 500)
			then
				return BOT_ACTION_DESIRE_HIGH
			end
		end

		local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), 0, nRadius, 0, 0)
		if nLocationAoE.count >= 3 then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold1 then
		if J.CanBeAttacked(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) and J.CanCastOnNonMagicImmune(nEnemyCreeps[1]) then
			if (#nEnemyCreeps >= 3)
			or (#nEnemyCreeps >= 2 and nEnemyCreeps[1]:IsAncientCreep())
			or (#nEnemyCreeps >= 1 and nEnemyCreeps[1]:GetHealth() >= 500)
			then
				return BOT_ACTION_DESIRE_HIGH
			end
		end
	end

	if J.IsLaning(bot) and J.IsInLaningPhase() and fManaAfter > fManaThreshold1 then
		local nCanKillOtherCount = 0
		local nCanKillRangeCount = 0
		for _, creep in pairs(nEnemyCreeps) do
			if J.IsValid(creep)
			and J.CanBeAttacked(creep)
			and J.CanCastOnNonMagicImmune(creep)
			and not J.IsOtherAllysTarget(creep)
			and (J.IsCore(bot) or not J.IsThereCoreNearby(600))
			then
				local sCreepName = creep:GetUnitName()
				if J.WillKillTarget(creep, nDamage, DAMAGE_TYPE_MAGICAL, nCastPoint) then
					local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), 0, nRadius * 0.75, 0, 0)
					if string.find(sCreepName, 'ranged') then
						nCanKillRangeCount = nCanKillRangeCount + 1
						if nLocationAoE.count > 0 or J.IsUnitTargetedByTower(creep, false) then
							return BOT_ACTION_DESIRE_HIGH
						end
					else
						nCanKillOtherCount = nCanKillOtherCount + 1
						if nLocationAoE.count > 0 then
							return BOT_ACTION_DESIRE_HIGH
						end
					end
				end
			end
		end

		if (nCanKillOtherCount + nCanKillRangeCount >= 3)
		or (nCanKillRangeCount >= 1 and nCanKillOtherCount >= 1)
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

function X.ConsiderSonicWave()
	if not J.CanCastAbility(SonicWave) then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastRange = SonicWave:GetCastRange()
	local nCastPoint = SonicWave:GetCastPoint()
	local nDamage = SonicWave:GetSpecialValueInt('damage')
	local nRadius = SonicWave:GetSpecialValueInt('final_aoe')
	local nDuration = SonicWave:GetSpecialValueFloat('knockback_duration')

	for _, enemyHero in pairs(nEnemyHeroes) do
		if J.IsValidHero(enemyHero)
		and J.CanBeAttacked(enemyHero)
		and J.IsInRange(bot, enemyHero, nCastRange + 300)
		and J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL, nCastPoint + nDuration)
		and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
		and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
		then
			local nAllyHeroesAttackingTarget = J.GetHeroesTargetingUnit(nAllyHeroes, enemyHero)
			if #nAllyHeroesAttackingTarget <= 2 then
				if (J.GetModifierTime(enemyHero, 'modifier_teleporting') > nCastPoint + nDuration)
				or (J.IsRetreating(bot) and not J.IsRealInvisible(bot) and #nAllyHeroes <= 2)
				then
					return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
				end
			end
		end
	end

	if J.IsInTeamFight(bot, 1200) then
		local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
		local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius * 0.9)
		if #nInRangeEnemy >= 2 then
			local count = 0
			for _, enemyHero in pairs(nInRangeEnemy) do
				if  J.IsValidHero(enemyHero)
				and J.CanBeAttacked(enemyHero)
				and not J.IsChasingTarget(bot, enemyHero)
				and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
				and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
				then
					if enemyHero:HasModifier('modifier_enigma_black_hole_pull')
					or enemyHero:HasModifier('modifier_legion_commander_duel')
					or enemyHero:HasModifier('modifier_bane_fiends_grip')
					or enemyHero:HasModifier('modifier_sand_king_epicenter_slow')
					or enemyHero:HasModifier('modifier_jakiro_macropyre_burn')
					then
						if J.IsCore(enemyHero) and J.GetHP(enemyHero) > 0.4 then
							return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
						end
					end

					count = count + 1
				end
			end

			if count >= 2 then
				return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
			end
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and not J.IsChasingTarget(bot, botTarget)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
		then
			local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), 1200)
			local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1200)

			if (not (#nInRangeAlly >= #nInRangeEnemy + 2)) or (SonicWave:GetCooldown() <= 40 and J.IsCore(botTarget)) then
				if J.GetTotalEstimatedDamageToTarget(nInRangeAlly, botTarget, 5.0) > botTarget:GetHealth() then
					if J.IsDisabled(botTarget)
					or botTarget:GetCurrentMovementSpeed() < 250
					or J.IsInRange(bot, botTarget, nCastRange * 0.65)
					then
						return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
					end
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

return X

