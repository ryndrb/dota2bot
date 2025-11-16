local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_zuus'
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
					['t20'] = {0, 10},
					['t15'] = {10, 0},
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
                [1] = {1,3,1,2,1,6,1,2,2,2,6,3,3,3,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_faerie_fire",
				"item_circlet",
				"item_mantle",
			
				"item_bottle",
				"item_magic_wand",
				"item_arcane_boots",
				"item_null_talisman",
				"item_kaya",
				"item_ultimate_scepter",
				"item_aghanims_shard",
				"item_octarine_core",--
				"item_kaya_and_sange",--
				"item_black_king_bar",--
				"item_sheepstick",--
				"item_wind_waker",--
				"item_ultimate_scepter_2",
				"item_moon_shard",
				"item_travel_boots_2",--
			},
            ['sell_list'] = {
				"item_magic_wand", "item_octarine_core",
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
					['t25'] = {0, 10},
					['t20'] = {0, 10},
					['t15'] = {10, 0},
					['t10'] = {0, 10},
				},
            },
            ['ability'] = {
                [1] = {1,3,1,2,1,6,1,2,2,2,6,3,3,3,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_magic_stick",
				"item_double_branches",
				"item_blood_grenade",
				"item_faerie_fire",
			
				"item_tranquil_boots",
				"item_magic_wand",
				"item_aether_lens",
				"item_ancient_janggo",
				"item_force_staff",
				"item_octarine_core",--
				"item_aghanims_shard",
				"item_boots_of_bearing",--
				"item_ultimate_scepter",
				"item_sheepstick",--
				"item_ethereal_blade",--
				"item_black_king_bar",--
				"item_ultimate_scepter_2",
				"item_moon_shard",
				"item_hurricane_pike",--
			},
            ['sell_list'] = {
				"item_magic_wand", "item_ultimate_scepter",
			},
        },
    },
    ['pos_5'] = {
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
                [1] = {1,3,1,2,1,6,1,2,2,2,6,3,3,3,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_magic_stick",
				"item_double_branches",
				"item_blood_grenade",
				"item_faerie_fire",
			
				"item_arcane_boots",
				"item_magic_wand",
				"item_aether_lens",
				"item_mekansm",
				"item_force_staff",
				"item_octarine_core",--
				"item_aghanims_shard",
				"item_guardian_greaves",--
				"item_ultimate_scepter",
				"item_sheepstick",--
				"item_ethereal_blade",--
				"item_black_king_bar",--
				"item_ultimate_scepter_2",
				"item_moon_shard",
				"item_hurricane_pike",--
			},
            ['sell_list'] = {
				"item_magic_wand", "item_ultimate_scepter",
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
		and hMinionUnit:GetUnitName() ~= 'npc_dota_zeus_cloud'
	then
		Minion.IllusionThink( hMinionUnit )
	end

end

end

local ArcLightning = bot:GetAbilityByName('zuus_arc_lightning')
local LightningBolt = bot:GetAbilityByName('zuus_lightning_bolt')
local HeavenlyJump = bot:GetAbilityByName('zuus_heavenly_jump')
local Nimbus = bot:GetAbilityByName('zuus_cloud')
local LightningHands = bot:GetAbilityByName('zuus_lightning_hands')
local ThundergodsWrath = bot:GetAbilityByName('zuus_thundergods_wrath')

local talent5 = bot:GetAbilityByName( sTalentList[5] )
local talent7 = bot:GetAbilityByName( sTalentList[7] )
local talent8 = bot:GetAbilityByName( sTalentList[8] )

local ArcLightningDesire, ArcLightningTarget
local LightningBoltDesire, LightningBoltLocation
local HeavenlyJumpDesire
local NimbusDesire, NimbusLocation
local LightningHandsDesire
local ThundergodsWrathDesire

local bAttacking = false
local botTarget, botHP
local nAllyHeroes, nEnemyHeroes

function X.SkillsComplement()
	bot = GetBot()

	if J.CanNotUseAbility(bot) then return end

	ArcLightning = bot:GetAbilityByName('zuus_arc_lightning')
	LightningBolt = bot:GetAbilityByName('zuus_lightning_bolt')
	HeavenlyJump = bot:GetAbilityByName('zuus_heavenly_jump')
	Nimbus = bot:GetAbilityByName('zuus_cloud')
	LightningHands = bot:GetAbilityByName('zuus_lightning_hands')
	ThundergodsWrath = bot:GetAbilityByName('zuus_thundergods_wrath')

    bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
    botTarget = J.GetProperTarget(bot)
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	ThundergodsWrathDesire = X.ConsiderThundergodsWrath()
	if ThundergodsWrathDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbility(ThundergodsWrath)
		return
	end

	LightningBoltDesire, LightningBoltLocation = X.ConsiderLightningBolt()
	if LightningBoltDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnLocation(LightningBolt, LightningBoltLocation)
		return
	end

	ArcLightningDesire, ArcLightningTarget = X.ConsiderArcLightning()
	if ArcLightningDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnEntity(ArcLightning, ArcLightningTarget)
		return
	end

	NimbusDesire, NimbusLocation = X.ConsiderNimbus()
	if NimbusDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnLocation(Nimbus, NimbusLocation)
		return
	end

	HeavenlyJumpDesire = X.ConsiderHeavenlyJump()
	if HeavenlyJumpDesire > 0 then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbility(HeavenlyJump)
		return
	end

	LightningHandsDesire = X.ConsiderLightningHands()
	if LightningHandsDesire > 0 then
		bot:Action_UseAbility(LightningHands)
		return
	end
end

function X.ConsiderArcLightning()
	if not J.CanCastAbility(ArcLightning) then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = ArcLightning:GetCastRange()
	local nCastPoint = ArcLightning:GetCastPoint()
	local nRadius = ArcLightning:GetSpecialValueInt('radius')
	local nDamage = ArcLightning:GetSpecialValueInt('arc_damage')
	local nManaCost = ArcLightning:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {LightningBolt, HeavenlyJump, Nimbus, ThundergodsWrath})
	local fManaThreshold2 = J.GetManaThreshold(bot, nManaCost, {ThundergodsWrath})

	for _, enemyHero in pairs(nEnemyHeroes) do
		if J.IsValidHero(enemyHero)
		and J.CanBeAttacked(enemyHero)
		and J.IsInRange(bot, enemyHero, nCastRange)
		and J.CanCastOnNonMagicImmune(enemyHero)
		and J.CanCastOnTargetAdvanced(enemyHero)
		and not enemyHero:HasModifier('modifier_abaddon_aphotic_shield')
		and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
		and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
		and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
		and not enemyHero:HasModifier('modifier_oracle_false_promise')
		and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
		then
			if J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL) then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
			end

			if not J.IsRetreating(bot) and not J.IsRealInvisible(bot) and #nAllyHeroes >= #nEnemyHeroes and fManaAfter > fManaThreshold1 then
				if J.GetHP(enemyHero) <= 0.2 then
					return BOT_ACTION_DESIRE_HIGH, enemyHero
				end
			end

			if J.IsInTeamFight(bot, 1200) and fManaAfter > fManaThreshold2 then
				local nLocationAoE = bot:FindAoELocation(true, true, enemyHero:GetLocation(), 0, nRadius, 0, 0)
				if nLocationAoE.count >= 2 then
					return BOT_ACTION_DESIRE_HIGH, enemyHero
				end
			end

			if J.IsDefending(bot) and bAttacking and fManaAfter > fManaThreshold1 then
				local nLocationAoE = bot:FindAoELocation(true, true, enemyHero:GetLocation(), 0, nRadius, 0, 0)
				if nLocationAoE.count >= 2 then
					return BOT_ACTION_DESIRE_HIGH, enemyHero
				end
			end
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.CanCastOnTargetAdvanced(botTarget)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
		and fManaAfter > fManaThreshold1 + 0.05
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
			and J.CanCastOnTargetAdvanced(enemyHero)
			and bot:WasRecentlyDamagedByHero(enemyHero, 3.0)
			then
				if not J.IsInRange(bot, enemyHero, nCastRange / 2)
				or bot:IsFacingLocation(enemyHero:GetLocation(), 45)
				then
					return BOT_ACTION_DESIRE_HIGH, enemyHero
				end
			end
		end
	end

    local nEnemyCreeps = bot:GetNearbyCreeps(Min(nCastRange + 300, 1600), true)

    if J.IsPushing(bot) and bAttacking and fManaAfter > fManaThreshold1 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 3)
                or (nLocationAoE.count >= 2 and creep:GetHealth() >= 550)
                then
                    return BOT_ACTION_DESIRE_HIGH, creep
                end
            end
        end
    end

    if J.IsDefending(bot) and bAttacking and fManaAfter > fManaThreshold1 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 3)
                or (nLocationAoE.count >= 2 and creep:GetHealth() >= 550)
                then
                    return BOT_ACTION_DESIRE_HIGH, creep
                end
            end
        end
    end

    if J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold1 then
        for _, creep in pairs(nEnemyCreeps) do
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
    end

	if J.IsLaning(bot) and J.IsInLaningPhase() and fManaAfter > fManaThreshold1 then
		for _, creep in pairs(nEnemyCreeps) do
			if J.IsValid(creep)
			and J.CanBeAttacked(creep)
			and J.IsEnemyTargetUnit(creep, 1400)
			and J.WillKillTarget(creep, nDamage, DAMAGE_TYPE_MAGICAL, nCastPoint)
			and not J.IsOtherAllysTarget(creep)
			then
				if J.IsEnemyTargetUnit(creep, 1400) or J.IsUnitTargetedByTower(creep, false) then
					return BOT_ACTION_DESIRE_HIGH, creep
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

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderLightningBolt()
	if not J.CanCastAbility(LightningBolt) then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastRange = LightningBolt:GetCastRange()
	local nCastPoint = LightningBolt:GetCastPoint()
	local nDamage = LightningBolt:GetSpecialValueInt('#AbilityDamage')
	local nRadius = Max(LightningBolt:GetSpecialValueInt('aoe_radius'), 1)
	local nManaCost = LightningBolt:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = J.GetManaThreshold(bot, nManaCost, {ArcLightning, HeavenlyJump, Nimbus, ThundergodsWrath})

	for _, enemyHero in pairs(nEnemyHeroes) do
		if J.IsValidHero(enemyHero)
		and J.CanBeAttacked(enemyHero)
		and J.IsInRange(bot, enemyHero, nCastRange + 300)
		and J.CanCastOnNonMagicImmune(enemyHero)
		then
			if enemyHero:IsChanneling() then
				return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
			end

			if J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL, nCastPoint)
			and not enemyHero:HasModifier('modifier_abaddon_aphotic_shield')
			and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
			and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
			and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			and not enemyHero:HasModifier('modifier_oracle_false_promise')
			and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
			end

			if J.IsDefending(bot) and bAttacking and fManaAfter > fManaThreshold1 then
				local nLocationAoE = bot:FindAoELocation(true, true, enemyHero:GetLocation(), 0, nRadius, 0, 0)
				if nLocationAoE.count >= 2 then
					return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
				end
			end
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and J.CanCastOnNonMagicImmune(botTarget)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and J.IsRunning(bot) then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange)
			and not J.IsInRange(bot, enemyHero, nCastRange * 0.6)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and bot:WasRecentlyDamagedByHero(enemyHero, 3.0)
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
			end
		end
	end

    local nEnemyCreeps = bot:GetNearbyCreeps(Min(nCastRange + 300, 1600), true)

    if J.IsPushing(bot) and bAttacking and fManaAfter > fManaThreshold1 + 0.1 and #nAllyHeroes <= 3 and #nEnemyHeroes == 0 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 3)
                or (nLocationAoE.count >= 2 and creep:GetHealth() >= 550)
                then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

    if J.IsDefending(bot) and bAttacking and fManaAfter > fManaThreshold1 + 0.1 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 3)
                or (nLocationAoE.count >= 2 and creep:GetHealth() >= 550)
                then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

    if J.IsFarming(bot) and bAttacking and fManaAfter > fManaThreshold1 + 0.1 then
        for _, creep in pairs(nEnemyCreeps) do
            if J.IsValid(creep) and J.CanBeAttacked(creep) then
                local nLocationAoE = bot:FindAoELocation(true, false, creep:GetLocation(), 0, nRadius, 0, 0)
                if (nLocationAoE.count >= 2)
                or (nLocationAoE.count >= 1 and creep:IsAncientCreep())
                or (nLocationAoE.count >= 1 and creep:GetHealth() >= 550)
                then
                    return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
                end
            end
        end
    end

    if J.IsLaning(bot) and J.IsInLaningPhase() and fManaAfter > fManaThreshold1 then
		for _, creep in pairs(nEnemyCreeps) do
			if  J.IsValid(creep)
            and J.CanBeAttacked(creep)
			and J.WillKillTarget(creep, nDamage, DAMAGE_TYPE_MAGICAL, nCastPoint)
            and not J.IsOtherAllysTarget(creep)
			then
				local sCreepName = creep:GetUnitName()
				local nLocationAoE = bot:FindAoELocation(true, true, creep:GetLocation(), 0, 800, 0, 0)
				if string.find(sCreepName, 'ranged') then
					if nLocationAoE.count > 0 or J.IsUnitTargetedByTower(creep, false) then
						return BOT_ACTION_DESIRE_HIGH, creep:GetLocation()
					end
				end
			end
		end
	end

	if J.IsDoingRoshan(bot)	then
		if J.IsRoshan(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and J.CanBeAttacked(botTarget)
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

function X.ConsiderHeavenlyJump()
	if not J.CanCastAbility(HeavenlyJump)
	or bot:IsRooted()
	then
		return BOT_ACTION_DESIRE_NONE
	end

	local nHopDistance = HeavenlyJump:GetSpecialValueInt('hop_distance')
	local nShockRadius = HeavenlyJump:GetSpecialValueInt('range')
	local nManaCost = HeavenlyJump:GetManaCost()

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nShockRadius)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.IsRunning(botTarget)
		and not J.IsDisabled(botTarget)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
		if J.IsRunning(bot) and bot:IsFacingLocation(J.GetTeamFountain(), 45) and #nEnemyHeroes > 0 then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsGoingToRune(bot) then
		if bot.rune and bot.rune.location and bot.rune.normal.status == RUNE_STATUS_AVAILABLE and bot:IsFacingLocation(bot.rune.location, 20) then
			local distance = GetUnitToLocationDistance(bot, bot.rune.location)
			local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), nShockRadius)
			if J.IsRunning(bot) and distance < nHopDistance + nHopDistance * 0.5 then
				if J.IsValidHero(nInRangeEnemy[1]) and (nInRangeEnemy[1]:IsFacingLocation(bot.rune.location, 20) or nInRangeEnemy[1]:IsFacingLocation(bot:GetLocation(), 20)) then
					return BOT_ACTION_DESIRE_HIGH
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderNimbus()
	if not J.CanCastAbility(Nimbus) then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	for i = 1, 5 do
		local allyHero =  GetTeamMember(i)

		if J.IsValidHero(allyHero)
		and J.IsGoingOnSomeone(allyHero)
		then
			local allyTarget = J.GetProperTarget(allyHero)

			if J.IsValidHero(allyTarget)
			and J.CanBeAttacked(allyTarget)
			and J.IsInRange(allyHero, allyTarget, 1200)
			and J.CanCastOnNonMagicImmune(allyTarget)
			and not J.IsDisabled(allyTarget)
			and not allyTarget:HasModifier('modifier_abaddon_borrowed_time')
			then
				return BOT_ACTION_DESIRE_HIGH, allyTarget:GetLocation()
			end
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, 1200)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and bot:WasRecentlyDamagedByHero(enemyHero, 2.0)
			and enemyHero:IsFacingLocation(bot:GetLocation(), 20)
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderLightningHands()
	if not J.CanCastAbility(LightningHands) then
		return BOT_ACTION_DESIRE_NONE
	end

	local bIsToggled = LightningHands:GetToggleState()

	if not bIsToggled then
		return BOT_ACTION_DESIRE_HIGH
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderThundergodsWrath()
	if not J.CanCastAbility(ThundergodsWrath) then
		return BOT_ACTION_DESIRE_NONE
	end

	local nCastPoint = ThundergodsWrath:GetCastPoint()
	local nDamage = ThundergodsWrath:GetSpecialValueInt('damage')

	local unitList = GetUnitList(UNIT_LIST_ENEMY_HEROES)
	for _, enemyHero in pairs(unitList) do
		if J.IsValidHero(enemyHero)
		and J.CanBeAttacked(enemyHero)
		and J.CanCastOnNonMagicImmune(enemyHero)
		and not enemyHero:HasModifier('modifier_abaddon_aphotic_shield')
		and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
		and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
		and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
		and not enemyHero:HasModifier('modifier_oracle_false_promise')
		and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
		then
			if J.WillKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL, nCastPoint) then
				local nAllyHeroesTargetingTarget = J.GetHeroesTargetingUnit(nAllyHeroes, enemyHero)
				local nInRangeAlly = J.GetAlliesNearLoc(enemyHero:GetLocation(), 1000)
				local nInRangeEnemy = J.GetEnemiesNearLoc(enemyHero:GetLocation(), 1000)

				if #nAllyHeroesTargetingTarget <= 1
				or #nInRangeAlly == 0
				or (#nInRangeAlly >= #nInRangeEnemy)
				or (J.GetTotalEstimatedDamageToTarget(nAllyHeroes, enemyHero, 3.0) < enemyHero:GetHealth())
				then
					return BOT_ACTION_DESIRE_HIGH
				end
			end
		end
	end

	for i = 1, 5 do
		local allyHero =  GetTeamMember(i)

		if J.IsValidHero(allyHero) and J.IsGoingOnSomeone(allyHero) then
			local count = 0
			local nInRangeEnemy = J.GetEnemiesNearLoc(allyHero:GetLocation(), 1600)
			for _, enemyHero in pairs(nInRangeEnemy) do
				if J.IsValidHero(enemyHero)
				and J.CanBeAttacked(enemyHero)
				and J.CanCastOnNonMagicImmune(enemyHero)
				and not enemyHero:HasModifier('modifier_abaddon_aphotic_shield')
				and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
				and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
				and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
				and not enemyHero:HasModifier('modifier_oracle_false_promise')
				and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
				and J.GetHP(enemyHero) <= 0.65
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