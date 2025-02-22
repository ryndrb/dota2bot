local X = {}
local bDebugMode = ( 1 == 10 )
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_crystal_maiden'
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
					['t20'] = {10, 0},
					['t15'] = {10, 0},
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
                [1] = {1,2,3,2,2,6,2,1,1,1,6,3,3,3,6},
            },
            ['buy_list'] = {
				"item_double_tango",
				"item_double_branches",
				"item_faerie_fire",
				"item_enchanted_mango",
				"item_blood_grenade",
			
				"item_tranquil_boots",
				"item_magic_wand",
				"item_ancient_janggo",
				"item_glimmer_cape",--
				"item_solar_crest",--
				"item_boots_of_bearing",--
				"item_aghanims_shard",
				"item_black_king_bar",--
				"item_force_staff",--
				"item_sheepstick",--
				"item_ultimate_scepter_2",
				"item_moon_shard",
			},
            ['sell_list'] = {
				"item_magic_wand", "item_solar_crest",
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
                [1] = {1,2,3,2,2,6,2,1,1,1,6,3,3,3,6},
            },
            ['buy_list'] = {
				"item_double_tango",
				"item_double_branches",
				"item_faerie_fire",
				"item_enchanted_mango",
				"item_blood_grenade",
			
				"item_arcane_boots",
				"item_magic_wand",
				"item_mekansm",
				"item_glimmer_cape",--
				"item_solar_crest",--
				"item_guardian_greaves",--
				"item_aghanims_shard",
				"item_black_king_bar",--
				"item_force_staff",--
				"item_sheepstick",--
				"item_ultimate_scepter_2",
				"item_moon_shard",
			},
            ['sell_list'] = {
				"item_magic_wand", "item_solar_crest",
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

local abilityQ = bot:GetAbilityByName('crystal_maiden_crystal_nova')
local abilityW = bot:GetAbilityByName('crystal_maiden_frostbite')
local ArcaneAura = bot:GetAbilityByName('crystal_maiden_brilliance_aura')
local CrystalClone = bot:GetAbilityByName('crystal_maiden_crystal_clone')
local abilityR = bot:GetAbilityByName('crystal_maiden_freezing_field')

local castQDesire, castQLoc
local castWDesire, castWTarget
local CrystalCloneDesire, CrystalCloneLocation
local castRDesire

function X.SkillsComplement()
	if J.CanNotUseAbility( bot ) or bot:IsInvisible() then return end

	abilityQ = bot:GetAbilityByName('crystal_maiden_crystal_nova')
	abilityW = bot:GetAbilityByName('crystal_maiden_frostbite')
	ArcaneAura = bot:GetAbilityByName('crystal_maiden_brilliance_aura')
	CrystalClone = bot:GetAbilityByName('crystal_maiden_crystal_clone')
	abilityR = bot:GetAbilityByName('crystal_maiden_freezing_field')

	CrystalCloneDesire, CrystalCloneLocation = X.ConsiderCrystalClone()
	if CrystalCloneDesire > 0
	then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnLocation(CrystalClone, CrystalCloneLocation)
		return
	end

	castQDesire, castQLoc = X.ConsiderQ()
	if ( castQDesire > 0 )
	then
		J.SetQueuePtToINT( bot, false )

		bot:ActionQueue_UseAbilityOnLocation( abilityQ, castQLoc )
		return
	end

	castWDesire, castWTarget = X.ConsiderW()
	if ( castWDesire > 0 )
	then
		J.SetQueuePtToINT( bot, false )

		bot:ActionQueue_UseAbilityOnEntity( abilityW, castWTarget )
		return
	end

	castRDesire = X.ConsiderR()
	if ( castRDesire > 0 )
	then
		J.SetQueuePtToINT( bot, false )
		if J.CanCastAbility(ArcaneAura) and bot:GetMana() > abilityR:GetManaCost() * 1.65 then
			bot:ActionQueue_UseAbility(ArcaneAura)
		end
		J.SetQueueToInvisible(bot)
		bot:ActionQueue_UseAbility( abilityR )
		return
	end
end

function X.ConsiderQ()
    if not J.CanCastAbility(abilityQ) then return BOT_ACTION_DESIRE_NONE, 0 end

	local nRadius = abilityQ:GetSpecialValueInt( 'radius' )
	local nCastRange = J.GetProperCastRange(false, bot, abilityQ:GetCastRange())
	local nDamage = abilityQ:GetSpecialValueInt( 'nova_damage' )
	local nSkillLV = abilityQ:GetLevel()

	local nAllys =  bot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE )

	local nEnemysHeroesInRange = bot:GetNearbyHeroes( math.min(nCastRange + nRadius, 1600), true, BOT_MODE_NONE )
	local nEnemysHeroesInBonus = bot:GetNearbyHeroes( math.min(nCastRange + nRadius + 150, 1600), true, BOT_MODE_NONE )
	local nEnemysHeroesInView = bot:GetNearbyHeroes( 1600, true, BOT_MODE_NONE )
	local nWeakestEnemyHeroInRange, nWeakestEnemyHeroHealth1 = X.cm_GetWeakestUnit( nEnemysHeroesInRange )
	local nWeakestEnemyHeroInBonus, nWeakestEnemyHeroHealth2 = X.cm_GetWeakestUnit( nEnemysHeroesInBonus )

	local nEnemysLaneCreeps1 = bot:GetNearbyLaneCreeps( math.min(nCastRange + nRadius, 1600), true )
	local nEnemysLaneCreeps2 = bot:GetNearbyLaneCreeps( math.min(nCastRange + nRadius + 200, 1600), true )
	local nEnemysWeakestLaneCreeps1, nEnemysWeakestLaneCreepsHealth1 = X.cm_GetWeakestUnit( nEnemysLaneCreeps1 )
	local nEnemysWeakestLaneCreeps2, nEnemysWeakestLaneCreepsHealth2 = X.cm_GetWeakestUnit( nEnemysLaneCreeps2 )

	local nTowers = bot:GetNearbyTowers( 1000, true )

	local nCanKillHeroLocationAoE = bot:FindAoELocation( true, true, bot:GetLocation(), nCastRange, nRadius , 0.8, nDamage )
	local nCanHurtHeroLocationAoE = bot:FindAoELocation( true, true, bot:GetLocation(), nCastRange, nRadius , 0.8, 0 )
	local nCanKillCreepsLocationAoE = bot:FindAoELocation( true, false, bot:GetLocation(), nCastRange + nRadius, nRadius, 0.5, nDamage )
	local nCanHurtCreepsLocationAoE = bot:FindAoELocation( true, false, bot:GetLocation(), nCastRange + nRadius, nRadius, 0.5, 0 )

    local botTarget = J.GetProperTarget( bot )

	if nCanKillHeroLocationAoE.count ~= nil
		and nCanKillHeroLocationAoE.count >= 1
	then
		if J.IsValidHero( nWeakestEnemyHeroInBonus )
		then
			local nTargetLocation = J.GetCastLocation( bot, nWeakestEnemyHeroInBonus, nCastRange, nRadius )
			if nTargetLocation ~= nil
			then
				return BOT_ACTION_DESIRE_HIGH, nTargetLocation
			end
		end
	end

	if J.IsLaning(bot)
		and nTowers ~= nil and #nTowers <= 0
		and J.GetHP(bot) >= 0.4
	then
		if nCanHurtHeroLocationAoE.count >= 2
			and GetUnitToLocationDistance( bot, nCanHurtHeroLocationAoE.targetloc ) <= nCastRange + 50
		then
			return BOT_ACTION_DESIRE_HIGH, nCanHurtHeroLocationAoE.targetloc
		end
	end

	if J.IsRetreating(bot)
		and bot:WasRecentlyDamagedByAnyHero( 2.5 )
        and not J.IsRealInvisible(bot)
	then
		local nCanHurtHeroLocationAoENearby = bot:FindAoELocation( true, true, bot:GetLocation(), nCastRange - 300, nRadius, 0.8, 0 )
		if nCanHurtHeroLocationAoENearby.count >= 1
		then
			return BOT_ACTION_DESIRE_HIGH, nCanHurtHeroLocationAoENearby.targetloc
		end
	end

	if J.IsGoingOnSomeone( bot )
	then
		if J.IsValidHero( nWeakestEnemyHeroInBonus )
			and nCanHurtHeroLocationAoE.count >= 2
			and GetUnitToLocationDistance( bot, nCanHurtHeroLocationAoE.targetloc ) <= nCastRange
		then
			return BOT_ACTION_DESIRE_HIGH, nCanHurtHeroLocationAoE.targetloc
		end

		if J.IsValidHero( botTarget )
			and J.CanCastOnNonMagicImmune( botTarget )
		then

			--蓝很多随意用
			if J.GetMP(bot) > 0.75
				or bot:GetMana() > 400
			then
				local nTargetLocation = J.GetCastLocation( bot, botTarget, nCastRange, nRadius )
				if nTargetLocation ~= nil
				then
					return BOT_ACTION_DESIRE_HIGH, nTargetLocation
				end
			end

			if ( J.GetHP(botTarget) < 0.4 )
				and GetUnitToUnitDistance( botTarget, bot ) <= nRadius + nCastRange
			then
				local nTargetLocation = J.GetCastLocation( bot, botTarget, nCastRange, nRadius )
				if nTargetLocation ~= nil
				then
					return BOT_ACTION_DESIRE_HIGH, nTargetLocation
				end
			end

		end

		botTarget = nWeakestEnemyHeroInRange
		if J.IsValidHero(botTarget)
			and ( J.GetHP(botTarget) < 0.4 )
			and GetUnitToUnitDistance( botTarget, bot ) <= nRadius + nCastRange
		then
			local nTargetLocation = J.GetCastLocation( bot, botTarget, nCastRange, nRadius )
			if nTargetLocation ~= nil
			then
				return BOT_ACTION_DESIRE_HIGH, nTargetLocation
			end
		end

		if 	J.IsValid( nEnemysWeakestLaneCreeps2 )
			and nCanHurtCreepsLocationAoE.count >= 5
			and #nEnemysHeroesInBonus <= 0
			and bot:GetActiveMode() ~= BOT_MODE_ATTACK
			and nSkillLV >= 3
		then
			return BOT_ACTION_DESIRE_HIGH, nCanHurtCreepsLocationAoE.targetloc
		end

		if nCanKillCreepsLocationAoE.count >= 3
			and ( J.IsValid( nEnemysWeakestLaneCreeps1 ) or bot:GetLevel() >= 25 )
			and #nEnemysHeroesInBonus <= 0
			and bot:GetActiveMode() ~= BOT_MODE_ATTACK
			and nSkillLV >= 3
		then
			return BOT_ACTION_DESIRE_HIGH, nCanKillCreepsLocationAoE.targetloc
		end
	end

	if not J.IsRetreating(bot)
	then
		if J.IsValidHero( nWeakestEnemyHeroInBonus )
		then

			if nCanHurtHeroLocationAoE.count >= 3
				and GetUnitToLocationDistance( bot, nCanHurtHeroLocationAoE.targetloc ) <= nCastRange
			then
				return BOT_ACTION_DESIRE_VERYHIGH, nCanHurtHeroLocationAoE.targetloc
			end

			if nCanHurtHeroLocationAoE.count >= 2
				and GetUnitToLocationDistance( bot, nCanHurtHeroLocationAoE.targetloc ) <= nCastRange
				and bot:GetMana() > 250
			then
				return BOT_ACTION_DESIRE_HIGH, nCanHurtHeroLocationAoE.targetloc
			end

			if J.IsValidHero( nWeakestEnemyHeroInBonus )
			then
				if J.GetMP(bot) > 0.8
					or bot:GetMana() > 400
				then
					local nTargetLocation = J.GetCastLocation( bot, nWeakestEnemyHeroInBonus, nCastRange, nRadius )
					if nTargetLocation ~= nil
					then
						return BOT_ACTION_DESIRE_HIGH, nTargetLocation
					end
				end

				if ( J.GetHP(nWeakestEnemyHeroInBonus) < 0.4 )
					and GetUnitToUnitDistance( nWeakestEnemyHeroInBonus, bot ) <= nRadius + nCastRange
				then
					local nTargetLocation = J.GetCastLocation( bot, nWeakestEnemyHeroInBonus, nCastRange, nRadius )
					if nTargetLocation ~= nil
					then
						return BOT_ACTION_DESIRE_HIGH, nTargetLocation
					end
				end
			end
		end
	end

	if J.IsFarming( bot )
		and nSkillLV >= 3
	then

		if nCanKillCreepsLocationAoE.count >= 2
			and J.IsValid( nEnemysWeakestLaneCreeps1 )
            and J.CanBeAttacked(nEnemysWeakestLaneCreeps1)
		then
			return BOT_ACTION_DESIRE_HIGH, nCanKillCreepsLocationAoE.targetloc
		end

		if nCanHurtCreepsLocationAoE.count >= 4
			and J.IsValid( nEnemysWeakestLaneCreeps1 )
            and J.CanBeAttacked(nEnemysWeakestLaneCreeps1)
		then
			return BOT_ACTION_DESIRE_HIGH, nCanHurtCreepsLocationAoE.targetloc
		end

	end

	if #nAllys <= 2 and nSkillLV >= 3
		and ( J.IsPushing( bot ) or J.IsDefending( bot ) )
	then

		if nCanHurtCreepsLocationAoE.count >= 4
			and  J.IsValid( nEnemysWeakestLaneCreeps1 )
            and J.CanBeAttacked(nEnemysWeakestLaneCreeps1)
		then
			return BOT_ACTION_DESIRE_HIGH, nCanHurtCreepsLocationAoE.targetloc
		end

		if nCanKillCreepsLocationAoE.count >= 2
			and J.IsValid( nEnemysWeakestLaneCreeps1 )
            and J.CanBeAttacked(nEnemysWeakestLaneCreeps1)
		then
			return BOT_ACTION_DESIRE_HIGH, nCanKillCreepsLocationAoE.targetloc
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
		if J.IsTormentor( botTarget )
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation()
		end
	end

	local nNeutarlCreeps = bot:GetNearbyNeutralCreeps( math.min(nCastRange + nRadius, 1600) )
	if J.IsValid( nNeutarlCreeps[1] )
	then
		for _, creep in pairs( nNeutarlCreeps )
		do
			if J.IsValid( creep )
				and creep:HasModifier( 'modifier_crystal_maiden_frostbite' )
				and J.GetHP(creep) > 0.3
				and ( creep:GetUnitName() == 'npc_dota_neutral_dark_troll_warlord'
					or creep:GetUnitName() == 'npc_dota_neutral_satyr_hellcaller'
					or creep:GetUnitName() == 'npc_dota_neutral_polar_furbolg_ursa_warrior' )
			then
				local nTargetLocation = J.GetCastLocation( bot, creep, nCastRange, nRadius )
				if nTargetLocation ~= nil
				then
					return BOT_ACTION_DESIRE_HIGH, nTargetLocation
				end
			end
		end
	end

	if #nEnemysHeroesInView == 0
		and not J.IsGoingOnSomeone( bot )
		and nSkillLV > 2
	then

		if nCanKillCreepsLocationAoE.count >= 2
			and ( nEnemysWeakestLaneCreeps2 ~= nil or bot:GetLevel() == 25 )
		then
			return BOT_ACTION_DESIRE_HIGH, nCanKillCreepsLocationAoE.targetloc
		end

		if nCanHurtCreepsLocationAoE.count >= 4
			and nEnemysWeakestLaneCreeps2 ~= nil
		then
			return BOT_ACTION_DESIRE_HIGH, nCanHurtCreepsLocationAoE.targetloc
		end

	end

	return BOT_ACTION_DESIRE_NONE, 0
end

function X.ConsiderW()
    if not J.CanCastAbility(abilityW) then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = J.GetProperCastRange(false, bot, abilityW:GetCastRange() + 30)
	local nCastPoint = abilityW:GetCastPoint()
    local nDPS = abilityW:GetSpecialValueInt('damage_per_second')
    local nDuration = abilityW:GetSpecialValueFloat('duration')
	local nDamage = ( nDPS * nDuration )

	local nAllies =  bot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE )

	local nEnemysHeroesInView = bot:GetNearbyHeroes( 1600, true, BOT_MODE_NONE )
	if nEnemysHeroesInView ~= nil and #nEnemysHeroesInView <= 1 and nCastRange < bot:GetAttackRange() then nCastRange = bot:GetAttackRange() + 60 end
	local nEnemysHeroesInRange = bot:GetNearbyHeroes( nCastRange, true, BOT_MODE_NONE )
	local nEnemysHeroesInBonus = bot:GetNearbyHeroes( nCastRange + 200, true, BOT_MODE_NONE )

	local nWeakestEnemyHeroInRange, nWeakestEnemyHeroHealth1 = X.cm_GetWeakestUnit( nEnemysHeroesInRange )
	local nWeakestEnemyHeroInBonus, nWeakestEnemyHeroHealth2 = X.cm_GetWeakestUnit( nEnemysHeroesInBonus )

	local nEnemysCreeps1 = bot:GetNearbyCreeps( nCastRange + 100, true )
	local nEnemysCreeps2 = bot:GetNearbyCreeps( 1400, true )

	local nEnemysStrongestCreeps1, nEnemysStrongestCreepsHealth1 = X.cm_GetStrongestUnit( nEnemysCreeps1 )
	local nEnemysStrongestCreeps2, nEnemysStrongestCreepsHealth2 = X.cm_GetStrongestUnit( nEnemysCreeps2 )

	local nTowers = bot:GetNearbyTowers( 900, true )

	if J.IsValidHero( nWeakestEnemyHeroInRange )
		and J.CanCastOnTargetAdvanced( nWeakestEnemyHeroInRange )
	then
		if J.WillMagicKillTarget( bot, nWeakestEnemyHeroInRange, nDamage, nCastPoint )
		then
			return BOT_ACTION_DESIRE_HIGH, nWeakestEnemyHeroInRange
		end
	end

	for _, npcEnemy in pairs( nEnemysHeroesInBonus )
	do
		if J.IsValidHero( npcEnemy )
			and npcEnemy:IsChanneling()
			and npcEnemy:HasModifier( 'modifier_teleporting' )
			and J.CanCastOnNonMagicImmune( npcEnemy )
			and J.CanCastOnTargetAdvanced( npcEnemy )
		then
			return BOT_ACTION_DESIRE_HIGH, npcEnemy
		end
	end

	if J.IsInTeamFight( bot, 1200 )
		and  DotaTime() > 6 * 60
	then
		local npcMostDangerousEnemy = nil
		local nMostDangerousDamage = 0

		for _, npcEnemy in pairs( nEnemysHeroesInRange )
		do
			if J.IsValidHero( npcEnemy )
				and J.CanCastOnNonMagicImmune( npcEnemy )
				and J.CanCastOnTargetAdvanced( npcEnemy )
				and not J.IsDisabled( npcEnemy )
				and not npcEnemy:IsDisarmed()
			then
				local npcEnemyDamage = npcEnemy:GetEstimatedDamageToTarget( false, bot, 3.0, DAMAGE_TYPE_ALL )
				if ( npcEnemyDamage > nMostDangerousDamage )
				then
					nMostDangerousDamage = npcEnemyDamage
					npcMostDangerousEnemy = npcEnemy
				end
			end
		end

		if ( npcMostDangerousEnemy ~= nil )
		then
			return BOT_ACTION_DESIRE_HIGH, npcMostDangerousEnemy
		end

	end

	if bot:WasRecentlyDamagedByAnyHero( 3.0 )
		and #nEnemysHeroesInRange >= 1
	then
		for _, npcEnemy in pairs( nEnemysHeroesInRange )
		do
			if J.IsValidHero( npcEnemy )
				and J.CanCastOnNonMagicImmune( npcEnemy )
				and J.CanCastOnTargetAdvanced( npcEnemy )
				and not J.IsDisabled( npcEnemy )
				and not npcEnemy:IsDisarmed()
				and bot:IsFacingLocation( npcEnemy:GetLocation(), 45 )
			then
				return BOT_ACTION_DESIRE_HIGH, npcEnemy
			end
		end
	end

	if J.IsLaning(bot) and nTowers ~= nil and #nTowers == 0
	then
		if( J.GetMP(bot) > 0.5 or bot:GetMana()> 250 )
		then
			if J.IsValidHero( nWeakestEnemyHeroInRange )
				and not J.IsDisabled( nWeakestEnemyHeroInRange )
			then
				return BOT_ACTION_DESIRE_HIGH, nWeakestEnemyHeroInRange
			end
		end

		if( J.GetMP(bot) > 0.78 or bot:GetMana()> 250 )
		then
			if J.IsValidHero( nWeakestEnemyHeroInBonus )
				and J.GetHP(bot) > 0.6
				and nTowers ~= nil and #nTowers == 0
				and (nEnemysCreeps2 ~= nil and #nEnemysCreeps2 + #nEnemysHeroesInBonus <= 5)
				and not J.IsDisabled( nWeakestEnemyHeroInBonus )
				and nWeakestEnemyHeroInBonus:GetCurrentMovementSpeed() < bot:GetCurrentMovementSpeed()
			then
				return BOT_ACTION_DESIRE_HIGH, nWeakestEnemyHeroInBonus
			end
		end


		if J.IsValidHero( nEnemysHeroesInView[1] )
		then
			if J.GetAllyUnitCountAroundEnemyTarget( bot, nEnemysHeroesInView[1], 350 ) >= 5
				and not J.IsDisabled( nEnemysHeroesInView[1] )
				and not nEnemysHeroesInView[1]:IsMagicImmune()
				and J.GetHP(bot) > 0.7
				and bot:GetMana()> 250
				and nEnemysCreeps2 ~= nil and #nEnemysCreeps2 + #nEnemysHeroesInBonus <= 3
				and nTowers ~= nil and #nTowers == 0
			then
				return BOT_ACTION_DESIRE_HIGH, nEnemysHeroesInView[1]
			end
		end

		if J.IsValidHero( nWeakestEnemyHeroInRange )
		then
			if J.GetHP(nWeakestEnemyHeroInRange) < 0.5
			then
				return BOT_ACTION_DESIRE_HIGH, nWeakestEnemyHeroInRange
			end
		end
	end

	if nEnemysHeroesInRange[1] == nil
		and nEnemysCreeps1[1] ~= nil
	then
		for _, EnemyplayerCreep in pairs( nEnemysCreeps1 )
		do
			if J.IsValid( EnemyplayerCreep )
				and EnemyplayerCreep:GetTeam() == GetOpposingTeam()
				and EnemyplayerCreep:GetHealth() > 460
				and not EnemyplayerCreep:IsMagicImmune()
				and not EnemyplayerCreep:IsInvulnerable()
				and ( EnemyplayerCreep:IsDominated()  --[[or EnemyplayerCreep:IsMinion()]] )
			then
				return BOT_ACTION_DESIRE_HIGH, EnemyplayerCreep
			end
		end
	end

	if bot:GetActiveMode() ~= BOT_MODE_LANING
		and  bot:GetActiveMode() ~= BOT_MODE_RETREAT
		and  bot:GetActiveMode() ~= BOT_MODE_ATTACK
		and  nEnemysHeroesInView ~= nil and #nEnemysHeroesInView == 0
		and  nAllies ~= nil and #nAllies < 3
		and  bot:GetLevel() >= 5
	then
		if J.IsValid( nEnemysStrongestCreeps2 )
			and ( DotaTime() > 10 * 60
				or ( nEnemysStrongestCreeps2:GetUnitName() ~= 'npc_dota_creep_badguys_melee'
					and nEnemysStrongestCreeps2:GetUnitName() ~= 'npc_dota_creep_badguys_ranged'
					and nEnemysStrongestCreeps2:GetUnitName() ~= 'npc_dota_creep_goodguys_melee'
					and nEnemysStrongestCreeps2:GetUnitName() ~= 'npc_dota_creep_goodguys_ranged' ) )
		then
			if ( nEnemysStrongestCreepsHealth2 > 460 or ( nEnemysStrongestCreepsHealth1 > 390 and J.GetMP(bot) > 0.45 ) )
				and nEnemysStrongestCreepsHealth2 <= 1200
			then
				return BOT_ACTION_DESIRE_LOW, nEnemysStrongestCreeps2
			end
		end

		if J.IsValid( nEnemysStrongestCreeps1 )
			and ( DotaTime() > 10 * 60
				or ( nEnemysStrongestCreeps1:GetUnitName() ~= 'npc_dota_creep_badguys_melee'
					and nEnemysStrongestCreeps1:GetUnitName() ~= 'npc_dota_creep_badguys_ranged'
					and nEnemysStrongestCreeps1:GetUnitName() ~= 'npc_dota_creep_goodguys_melee'
					and nEnemysStrongestCreeps1:GetUnitName() ~= 'npc_dota_creep_goodguys_ranged' ) )
		then
			if ( nEnemysStrongestCreepsHealth1 > 410 or ( nEnemysStrongestCreepsHealth1 > 360 and J.GetMP(bot) > 0.45 ) )
				and nEnemysStrongestCreepsHealth1 <= 1200
			then
				return BOT_ACTION_DESIRE_LOW, nEnemysStrongestCreeps1
			end
		end

	end

	if J.IsGoingOnSomeone( bot )
	then
		local npcTarget = J.GetProperTarget( bot )
		if J.IsValidHero( npcTarget )
			and J.CanCastOnNonMagicImmune( npcTarget )
			and J.CanCastOnTargetAdvanced( npcTarget )
			and J.IsInRange( npcTarget, bot, nCastRange + 50 )
			and not J.IsDisabled( npcTarget )
			and not npcTarget:IsDisarmed()
		then
			return BOT_ACTION_DESIRE_HIGH, npcTarget
		end
	end

	if J.IsRetreating( bot )
    and not J.IsRealInvisible(bot)
	then
		for _, npcEnemy in pairs( nEnemysHeroesInRange )
		do
			if J.IsValidHero( npcEnemy )
				and bot:WasRecentlyDamagedByHero( npcEnemy, 5.0 )
				and J.CanCastOnNonMagicImmune( npcEnemy )
				and J.CanCastOnTargetAdvanced( npcEnemy )
				and not J.IsDisabled( npcEnemy )
				and J.IsInRange( npcEnemy, bot, nCastRange - 80 )
			then
				return BOT_ACTION_DESIRE_HIGH, npcEnemy
			end
		end
	end


	if J.IsDoingRoshan(bot)
	then
		local npcTarget = bot:GetAttackTarget()
		if J.IsRoshan( npcTarget )
			and not J.IsDisabled( npcTarget )
			and not npcTarget:IsDisarmed()
			and J.IsInRange( npcTarget, bot, nCastRange )
            and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH, npcTarget
		end
	end


	return BOT_ACTION_DESIRE_NONE, nil
end

function X.ConsiderR()
    if not J.CanCastAbility(abilityR)
    or bot:DistanceFromFountain() < 300
    then
        return BOT_ACTION_DESIRE_NONE
    end


    local nRadius = abilityR:GetAOERadius() * 0.88

    local nAllies =  bot:GetNearbyHeroes( 1200, false, BOT_MODE_NONE )

    local nEnemysHeroesInRange = bot:GetNearbyHeroes( nRadius, true, BOT_MODE_NONE )

    local _, CrystalNova = J.HasAbility(bot, 'crystal_maiden_crystal_nova')
    local _, abilityW = J.HasAbility(bot, 'crystal_maiden_frostbite')

    local botTarget = J.GetProperTarget(bot)


    local aoeCanHurtCount = 0
    for _, enemy in pairs ( nEnemysHeroesInRange )
    do
        if J.IsValidHero( enemy )
            and J.CanCastOnNonMagicImmune( enemy )
            and ( J.IsDisabled( enemy )
                or J.IsInRange( bot, enemy, nRadius * 0.82 - enemy:GetCurrentMovementSpeed() ) )
        then
            aoeCanHurtCount = aoeCanHurtCount + 1
        end
    end
    if not J.IsRetreating(bot)
        or ( J.IsRetreating(bot) and bot:GetActiveModeDesire() <= 0.85 )
    then
        if ( nEnemysHeroesInRange ~= nil and #nEnemysHeroesInRange >= 3 or aoeCanHurtCount >= 2 )
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end


    if J.IsGoingOnSomeone( bot )
    then
        if J.IsValidHero( botTarget )
            and J.CanCastOnNonMagicImmune( botTarget )
            and ( J.IsDisabled( botTarget ) or J.IsInRange( bot, botTarget, 280 ) )
            and botTarget:GetHealth() <= botTarget:GetActualIncomingDamage( bot:GetOffensivePower() * 1.5, DAMAGE_TYPE_MAGICAL )
            and GetUnitToUnitDistance( botTarget, bot ) <= nRadius
            and botTarget:GetHealth() > 400
            and nAllies ~= nil and #nAllies <= 2
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    if J.IsRetreating( bot ) and J.GetHP(bot) > 0.38
    then
        local nEnemysHeroesNearby = bot:GetNearbyHeroes( 500, true, BOT_MODE_NONE )
        local nEnemysHeroesFurther = bot:GetNearbyHeroes( 1300, true, BOT_MODE_NONE )
        local npcTarget = nEnemysHeroesNearby[1]
        if J.IsValidHero( npcTarget )
            and J.CanCastOnNonMagicImmune( npcTarget )
            and (CrystalNova ~= nil and not CrystalNova:IsFullyCastable())
            and (abilityW ~= nil and not abilityW:IsFullyCastable())
            and J.GetHP(bot) > 0.38 * #nEnemysHeroesFurther
        then
            return BOT_ACTION_DESIRE_HIGH
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.ConsiderCrystalClone()
	if not J.CanCastAbility(CrystalClone)
	then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nRadius = 450
	local botTarget = J.GetProperTarget(bot)

	if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
        and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nRadius)
		and J.CanCastOnNonMagicImmune(botTarget)
		then
            return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, J.GetTeamFountain(), nRadius)
		end
	end

    if J.IsRetreating(bot)
    and not J.IsRealInvisible(bot)
    then
        local nInRangeEnemy = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

        if J.IsValidHero(nInRangeEnemy[1])
        and bot:WasRecentlyDamagedByAnyHero(4)
        and J.IsInRange(bot, nInRangeEnemy[1], nRadius)
        and not J.IsSuspiciousIllusion(nInRangeEnemy[1])
        then
            return BOT_ACTION_DESIRE_HIGH, J.Site.GetXUnitsTowardsLocation(bot, J.GetTeamFountain(), nRadius)
        end
    end

	return BOT_ACTION_DESIRE_NONE, 0
end

function X.cm_GetWeakestUnit( nEnemyUnits )

	local nWeakestUnit = nil
	local nWeakestUnitLowestHealth = 10000
	for _, unit in pairs( nEnemyUnits )
	do
		if J.IsValid(unit)
        and J.CanCastOnNonMagicImmune( unit )
		then
			if unit:GetHealth() < nWeakestUnitLowestHealth
			then
				nWeakestUnitLowestHealth = unit:GetHealth()
				nWeakestUnit = unit
			end
		end
	end

	return nWeakestUnit, nWeakestUnitLowestHealth
end

function X.cm_GetStrongestUnit( nEnemyUnits )

	local nStrongestUnit = nil
	local nStrongestUnitHealth = GetBot():GetAttackDamage()

	for _, unit in pairs( nEnemyUnits )
	do
		if 	J.IsValid(unit)
			and not unit:HasModifier( 'modifier_fountain_glyph' )
			-- and not unit:IsIllusion()
			and not unit:IsMagicImmune()
			and not unit:IsInvulnerable()
			and unit:GetHealth() <= 1100
			and not unit:IsAncientCreep()
			and unit:GetMagicResist() < 1.05 - unit:GetHealth()/1100
			-- and not unit:WasRecentlyDamagedByAnyHero( 2.5 )
			and not J.IsOtherAllysTarget( unit )
			and string.find( unit:GetUnitName(), 'siege' ) == nil
			and ( bot:GetLevel() < 25 or unit:GetTeam() == TEAM_NEUTRAL )
		then
			if string.find( unit:GetUnitName(), 'ranged' ) ~= nil
				and unit:GetHealth() > GetBot():GetAttackDamage() * 2
			then
				return unit, 500
			end

			if unit:GetHealth() > nStrongestUnitHealth
			then
				nStrongestUnitHealth = unit:GetHealth()
				nStrongestUnit = unit
			end
		end
	end

	return nStrongestUnit, nStrongestUnitHealth
end

return X