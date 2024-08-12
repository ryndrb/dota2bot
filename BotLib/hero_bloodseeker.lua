local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_bloodseeker'
then

local RI = require(GetScriptDirectory()..'/FunLib/util_role_item')

local sUtility = {"item_crimson_guard", "item_pipe"}
local sUtilityItem = RI.GetBestUtilityItem(sUtility)

local HeroBuild = {
    ['pos_1'] = {
        [1] = {
            ['talent'] = {
                [1] = {
					['t25'] = {0, 10},
					['t20'] = {0, 10},
					['t15'] = {0, 10},
					['t10'] = {0, 10},
				},
            },
            ['ability'] = {
                [1] = {3,2,3,1,3,6,1,1,1,3,6,2,2,2,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_quelling_blade",
				"item_slippers",
				"item_circlet",
			
				"item_wraith_band",
				"item_phase_boots",
				"item_maelstrom",
				"item_magic_wand",
				"item_black_king_bar",--
				"item_mjollnir",--
				"item_basher",
				"item_aghanims_shard",
				"item_butterfly",--
				"item_abyssal_blade",--
				"item_skadi",--
				"item_monkey_king_bar",--
				"item_moon_shard",
				"item_ultimate_scepter_2",
			},
            ['sell_list'] = {
				"item_quelling_blade",
				"item_wraith_band",
				"item_phase_boots",
				"item_magic_wand",
			},
        },
    },
    ['pos_2'] = {
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
                [1] = {3,2,3,1,3,6,1,1,1,3,6,2,2,2,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_quelling_blade",
				"item_slippers",
				"item_circlet",
			
				"item_wraith_band",
				"item_bottle",
				"item_phase_boots",
				"item_maelstrom",
				"item_magic_wand",
				"item_black_king_bar",--
				"item_mjollnir",--
				"item_basher",
				"item_aghanims_shard",
				"item_butterfly",--
				"item_sheepstick",--
				"item_travel_boots",
				"item_abyssal_blade",--
				"item_travel_boots_2",--
				"item_moon_shard",
				"item_ultimate_scepter_2",
			},
            ['sell_list'] = {
				"item_bottle",
				"item_quelling_blade",
				"item_wraith_band",
				"item_phase_boots",
				"item_magic_wand",
			},
        },
    },
    ['pos_3'] = {
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
                [1] = {2,3,3,1,3,6,3,1,1,1,6,2,2,2,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_quelling_blade",
			
				"item_double_wraith_band",
				"item_boots",
				"item_magic_wand",
				"item_phase_boots",
				"item_maelstrom",
				"item_black_king_bar",--
				"item_gungir",--
				"item_heavens_halberd",--
				sUtilityItem,--
				"item_basher",
				"item_travel_boots",
				"item_abyssal_blade",--
				"item_travel_boots_2",--
				"item_aghanims_shard",
				"item_moon_shard",
				"item_ultimate_scepter_2",
			},
            ['sell_list'] = {
				"item_quelling_blade",
				"item_wraith_band",
				"item_magic_wand",
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

if J.Role.IsPvNMode() or J.Role.IsAllShadow() then X['sBuyList'], X['sSellList'] = { 'PvN_melee_carry' }, {"item_power_treads", 'item_quelling_blade'} end

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

local Bloodrage = bot:GetAbilityByName('bloodseeker_bloodrage')
local Bloodrite = bot:GetAbilityByName('bloodseeker_blood_bath')
local BloodMist = bot:GetAbilityByName('bloodseeker_blood_mist')
local Rupture = bot:GetAbilityByName('bloodseeker_rupture')

local BloodrageDesire, BloodrageTarget
local BloodriteDesire, BloodriteLocation
local BloodMistDesire
local RuptureDesire, RuptureTarget

function X.SkillsComplement()
	if J.CanNotUseAbility( bot ) then return end

	Bloodrage = bot:GetAbilityByName('bloodseeker_bloodrage')
	Bloodrite = bot:GetAbilityByName('bloodseeker_blood_bath')
	BloodMist = bot:GetAbilityByName('bloodseeker_blood_mist')
	Rupture = bot:GetAbilityByName('bloodseeker_rupture')

	BloodMistDesire = X.ConsiderBloodMist()
	if BloodMistDesire > 0
	then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbility(BloodMist)
		return
	end

	RuptureDesire, RuptureTarget = X.ConsiderRupture()
	if RuptureDesire > 0
	then
		J.SetQueuePtToINT( bot, false )
		bot:ActionQueue_UseAbilityOnEntity( Rupture, RuptureTarget )
		return
	end

	BloodrageDesire, BloodrageTarget = X.ConsiderBloodrage()
	if BloodrageDesire > 0
	then
		J.SetQueuePtToINT( bot, false )
		bot:ActionQueue_UseAbilityOnEntity( Bloodrage, BloodrageTarget )
		return
	end

	BloodriteDesire, BloodriteLocation = X.ConsiderBloodrite()
	if BloodriteDesire > 0
	then
		J.SetQueuePtToINT( bot, false )
		bot:ActionQueue_UseAbilityOnLocation( Bloodrite, BloodriteLocation )
		return
	end
end

function X.ConsiderBloodrage()
	if not J.CanCastAbility(Bloodrage) then return BOT_ACTION_DESIRE_NONE, nil end

	local nCastRange = J.GetProperCastRange(false, bot, Bloodrage:GetCastRange())
	local nDamage = bot:GetAttackDamage()

	local botTarget = J.GetProperTarget(bot)

    local nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	if J.IsInTeamFight(bot, 1200) or J.IsPushing(bot) or J.IsDefending(bot)
	then
		if nEnemyHeroes ~= nil and #nEnemyHeroes >= 1
        then
			local highesAD = 0
			local highesADUnit = nil

			for _, allyHero in pairs(nAllyHeroes)
			do
				if J.IsValidHero(allyHero)
                and J.IsInRange(bot, allyHero, nCastRange + 150)
                and allyHero:GetAttackTarget() ~= nil
                and J.CanCastOnNonMagicImmune(allyHero)
                and ( J.GetHP(allyHero) > 0.18 or J.GetHP(allyHero:GetAttackTarget() ) < 0.18 )
                and not allyHero:HasModifier( 'modifier_bloodseeker_bloodrage' )
				then
                    local AllyAD = allyHero:GetAttackDamage()
                    if AllyAD > highesAD
                    then
                        highesAD = AllyAD
                        highesADUnit = allyHero
                    end
				end
			end

			if highesADUnit ~= nil
            then
				return BOT_ACTION_DESIRE_HIGH, highesADUnit
			end

		end

	end

	if J.IsGoingOnSomeone(bot)
	then
		if J.IsValidHero(botTarget)
        and not botTarget:IsAttackImmune()
        and J.CanCastOnMagicImmune(botTarget)
        and J.IsInRange(botTarget, bot, 600)
        and not bot:HasModifier( 'modifier_bloodseeker_bloodrage' )
		then
            return BOT_ACTION_DESIRE_HIGH, bot
		end
	end

	if J.IsValid( botTarget ) and botTarget:GetTeam() == TEAM_NEUTRAL
	and not bot:HasModifier('modifier_bloodseeker_bloodrage')
	then
		local nCreeps = bot:GetNearbyCreeps(1000, true)
		for _, creep in pairs(nCreeps)
		do
			if J.IsValid(creep)
            and J.CanBeAttacked(creep)
            and not J.CanKillTarget(creep, nDamage, DAMAGE_TYPE_PHYSICAL)
			then
				return BOT_ACTION_DESIRE_HIGH, bot
			end
		end
	end

	if J.IsDoingRoshan(bot)
	then
		if J.IsRoshan(botTarget)
        and J.IsInRange(bot, botTarget, bot:GetAttackRange())
        and J.IsAttacking(bot)
        and not bot:HasModifier('modifier_bloodseeker_bloodrage')
		then
			return BOT_ACTION_DESIRE_HIGH, bot
		end
	end

    if J.IsDoingTormentor(bot)
	then
		if J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, bot:GetAttackRange())
        and J.IsAttacking(bot)
        and not bot:HasModifier('modifier_bloodseeker_bloodrage')
		then
			return BOT_ACTION_DESIRE_HIGH, bot
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderBloodrite()
	if not J.CanCastAbility(Bloodrite) then return 0 end

	local nCastRange = J.GetProperCastRange(false, bot, Bloodrite:GetCastRange())
	local nRadius = Bloodrite:GetSpecialValueInt('radius')
	local nCastPoint = Bloodrite:GetCastPoint()
	local nDelay = Bloodrite:GetSpecialValueFloat( 'delay' )
	local nManaCost = Bloodrite:GetManaCost()
	local nDamage = Bloodrite:GetSpecialValueInt( 'damage' )

    local botTarget = J.GetProperTarget(bot)

	local nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
	local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
    local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(1600, true)

	for _, enemyHero in pairs(nEnemyHeroes)
	do
		if J.IsValidHero(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange + nRadius)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_PURE)
		then
            if not J.IsInRange(bot, enemyHero, nCastRange)
            then
                return J.Site.GetXUnitsTowardsLocation(bot, enemyHero:GetLocation(), nCastRange)
            else
                return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(enemyHero, nDelay + nCastPoint)
            end
		end
	end

	if J.IsLaning(bot) and J.IsAllowedToSpam(bot, nManaCost)
	then
		if nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 4
        and J.CanBeAttacked(nEnemyLaneCreeps[1])
        and not J.IsRunning(nEnemyLaneCreeps[1])
		then
			return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nEnemyLaneCreeps)
		end
	end

	if (J.IsPushing(bot) or J.IsDefending(bot)) and J.IsAllowedToSpam(bot, nManaCost)
	and nEnemyHeroes == nil and #nEnemyHeroes == 0
	and nAllyHeroes ~= nil and #nAllyHeroes <= 2
	then
		if nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 4
        and J.CanBeAttacked(nEnemyLaneCreeps[1])
        and not J.IsRunning(nEnemyLaneCreeps[1])
		then
			return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nEnemyLaneCreeps)
		end
	end

	if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
    and nEnemyHeroes == nil and #nEnemyHeroes >= 1
	then
		for _, enemyHero in pairs(nEnemyHeroes)
		do
			if J.IsValidHero(enemyHero)
            and bot:WasRecentlyDamagedByHero(enemyHero, 1.0)
            and J.CanCastOnNonMagicImmune(enemyHero)
			then
                local nInRangeEnemy = J.GetEnemiesNearLoc(enemyHero:GetLocation(), nRadius)
                if #nInRangeEnemy >= 2
                then
                    return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nInRangeEnemy)
                else
                    return BOT_ACTION_DESIRE_HIGH, (bot:GetLocation() + enemyHero:GetLocation()) / 2
                end
			end
		end
	end

	if J.IsInTeamFight( bot, 1200 )
	then
		local nLocationAoE = bot:FindAoELocation( true, true, bot:GetLocation(), nCastRange - 200, nRadius/2, nCastPoint, 0 )
		if nLocationAoE.count >= 2
		then
			local nInvUnit = J.GetInvUnitInLocCount( bot, nCastRange, nRadius/2, nLocationAoE.targetloc, false )
			if nInvUnit >= nLocationAoE.count
            then
				return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc
			end
		end
	end

	if J.IsGoingOnSomeone( bot )
	then
		if J.IsValidHero(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange + nRadius)
		then
			local nCastLoc = J.GetDelayCastLocation(bot, botTarget, nCastRange, nRadius, 2.0)
			if nCastLoc ~= nil
			then
				return BOT_ACTION_DESIRE_HIGH, nCastLoc
			end
		end
	end

    if J.IsDoingRoshan(bot)
	then
		if J.IsRoshan(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

    if J.IsDoingTormentor(bot)
	then
		if J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderBloodMist()
	if not bot:HasScepter()
	or not J.CanCastAbility(BloodMist)
	then
		return BOT_ACTION_DESIRE_NONE
	end

	local nRadius = BloodMist:GetSpecialValueInt('radius')
	local nEnemyHeroes = bot:GetNearbyHeroes(nRadius, true, BOT_MODE_NONE)
	local botTarget = J.GetProperTarget(bot)

	if BloodMist:GetToggleState() == true
	then
		if J.GetHP(bot) < 0.2
		then
			return BOT_ACTION_DESIRE_HIGH
		end

		if nEnemyHeroes ~= nil and #nEnemyHeroes == 0
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if not BloodMist:GetToggleState() == false
	and J.GetHP(bot) > 0.5
	then
		if J.IsValidHero(botTarget)
		and J.IsInRange(bot, botTarget, nRadius * 0.8)
		and J.CanCastOnNonMagicImmune(botTarget)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderRupture()
	if not J.CanCastAbility(Rupture)
    then
        return BOT_ACTION_DESIRE_NONE, nil
    end

	local nCastRange = J.GetProperCastRange(false, bot, Rupture:GetCastRange())

	local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

    local botTarget = J.GetProperTarget(bot)

	if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
	then
		for _, enemyHero in pairs(nEnemyHeroes)
		do
			if J.IsValidHero(enemyHero)
            and (bot:GetActiveModeDesire() > 0.75 and bot:WasRecentlyDamagedByHero(enemyHero, 2.5))
            and J.IsInRange(bot, enemyHero, nCastRange + 150)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and not enemyHero:HasModifier('modifier_bloodseeker_rupture')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
			end
		end
	end

	if J.IsInTeamFight( bot, 1200 )
	then
        -- mobile heroes
		for _, enemyHero in pairs(nEnemyHeroes)
		do
			if J.IsValidHero(enemyHero)
            and not J.IsDisabled(enemyHero)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and X.IsMobileHero(enemyHero:GetUnitName())
            and not enemyHero:HasModifier('modifier_bloodseeker_rupture')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
			end
		end

		for _, enemyHero in pairs(nEnemyHeroes)
		do
			if J.IsValidHero(enemyHero)
            and not J.IsDisabled(enemyHero)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and J.IsCore(enemyHero)
            and not enemyHero:HasModifier('modifier_bloodseeker_rupture')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero
			end
		end
	end

	if J.IsGoingOnSomeone( bot )
	then
		if J.IsValidHero( botTarget )
        and not J.IsDisabled( botTarget )
        and J.CanCastOnNonMagicImmune( botTarget )
        and J.CanCastOnTargetAdvanced( botTarget )
        and J.IsInRange( botTarget, bot, nCastRange + 150 )
        and not botTarget:HasModifier( 'modifier_bloodseeker_rupture' )
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			local allies = botTarget:GetNearbyHeroes( 1200, true, BOT_MODE_NONE )
			if ( allies ~= nil and #allies >= 2 )
			then
				return BOT_ACTION_DESIRE_HIGH, botTarget
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.IsMobileHero(hName)
    local Hero = {
        ['npc_dota_hero_earth_spirit'] = true,
        ['npc_dota_hero_night_stalker'] = true,
        ['npc_dota_hero_slardar'] = true,
        ['npc_dota_hero_spirit_breaker'] = true,
        ['npc_dota_hero_shredder'] = true,
        ['npc_dota_hero_ember_spirit'] = true,
        ['npc_dota_hero_morphling'] = true,
        ['npc_dota_hero_razor'] = true,
        ['npc_dota_hero_slark'] = true,
        ['npc_dota_hero_weaver'] = true,
        ['npc_dota_hero_storm_spirit'] = true,
        ['npc_dota_hero_batrider'] = true,
        ['npc_dota_hero_magnataur'] = true,
        ['npc_dota_hero_mirana'] = true,
        ['npc_dota_hero_pangolier'] = true,
        ['npc_dota_hero_windrunner'] = true,
    }

    if Hero[hName] == nil then return false end
    return Hero[hName]
end

return X