local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_medusa'
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
					['t20'] = {0, 10},
					['t15'] = {0, 10},
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
                [1] = {2,3,2,1,2,1,2,1,1,6,3,3,3,6,6},
            },
            ['buy_list'] = {
				"item_double_branches",
				"item_magic_stick",
				"item_quelling_blade",

				"item_arcane_boots",
				"item_magic_wand",
				"item_manta",--
				"item_butterfly",--
				"item_skadi",--
				"item_greater_crit",--
				"item_diffusal_blade",
				"item_travel_boots",
				"item_disperser",--
				"item_travel_boots_2",--
				"item_moon_shard",
				"item_aghanims_shard",
				"item_ultimate_scepter_2",
			},
            ['sell_list'] = {
				"item_magic_wand",
				"item_ring_of_basilius",
				"item_quelling_blade",
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

if J.Role.IsPvNMode() or J.Role.IsAllShadow() then X['sBuyList'], X['sSellList'] = { 'PvN_mid' }, {} end

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

--[[

npc_dota_hero_medusa

"Ability1"		"medusa_split_shot"
"Ability2"		"medusa_mystic_snake"
"Ability3"		"medusa_mana_shield"
"Ability4"		"generic_hidden"
"Ability5"		"generic_hidden"
"Ability6"		"medusa_stone_gaze"
"Ability10"		"special_bonus_attack_damage_15"
"Ability11"		"special_bonus_evasion_15"
"Ability12"		"special_bonus_attack_speed_30"
"Ability13"		"special_bonus_unique_medusa_3"
"Ability14"		"special_bonus_unique_medusa_5"
"Ability15"		"special_bonus_unique_medusa"
"Ability16"		"special_bonus_mp_1000"
"Ability17"		"special_bonus_unique_medusa_4"

modifier_medusa_split_shot
modifier_medusa_mana_shield
modifier_medusa_stone_gaze_tracker
modifier_medusa_stone_gaze
modifier_medusa_stone_gaze_slow
modifier_medusa_stone_gaze_facing
modifier_medusa_stone_gaze_stone


--]]

local abilityQ = bot:GetAbilityByName('medusa_split_shot')
local abilityW = bot:GetAbilityByName('medusa_mystic_snake')
local abilityE = bot:GetAbilityByName('medusa_mana_shield')
local abilityAS = bot:GetAbilityByName('medusa_cold_blooded')
local GorgonGrasp = bot:GetAbilityByName('medusa_gorgon_grasp')
local abilityR = bot:GetAbilityByName('medusa_stone_gaze')
local abilityM = nil

local castQDesire
local castWDesire, castWTarget
local GorgonGraspDesire, GorgonGraspLocation
local castRDesire


local nKeepMana, nMP, nHP, nLV, hEnemyHeroList
local lastToggleTime = 0


function X.SkillsComplement()

	-- J.ConsiderForMkbDisassembleMask( bot )
	J.ConsiderTarget()

	if J.CanNotUseAbility( bot ) or bot:IsInvisible() then return end

	abilityQ = bot:GetAbilityByName('medusa_split_shot')
	abilityW = bot:GetAbilityByName('medusa_mystic_snake')
	GorgonGrasp = bot:GetAbilityByName('medusa_gorgon_grasp')
	abilityR = bot:GetAbilityByName('medusa_stone_gaze')

	nKeepMana = 400
	nLV = bot:GetLevel()
	nMP = bot:GetMana()/bot:GetMaxMana()
	nHP = bot:GetHealth()/bot:GetMaxHealth()
	hEnemyHeroList = bot:GetNearbyHeroes( 1600, true, BOT_MODE_NONE )


	castWDesire, castWTarget = X.ConsiderW()
	if castWDesire > 0
	then

		J.SetQueuePtToINT( bot, true )

		bot:ActionQueue_UseAbilityOnEntity( abilityW, castWTarget )
		return
	end


	castRDesire = X.ConsiderR()
	if castRDesire > 0 
	then

		J.SetQueuePtToINT( bot, true )

		bot:ActionQueue_UseAbility( abilityR )
		return

	end

	GorgonGraspDesire, GorgonGraspLocation = X.ConsiderGorgonGrasp()
	if GorgonGraspDesire > 0
	then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnLocation(GorgonGrasp, GorgonGraspLocation)
		return
	end
	
	castQDesire = X.ConsiderQ()
	if castQDesire > 0
	then
		bot:Action_UseAbility( abilityQ )
		return
	end

end

function X.ConsiderQ()

	if not J.CanCastAbility(abilityQ) then return 0 end

	local nCastRange = bot:GetAttackRange() + 150
	local nSkillLv = abilityQ:GetLevel()
	
	local nInRangeEnemyHeroList = bot:GetNearbyHeroes(nCastRange, true, BOT_MODE_NONE)
	local nInRangeEnemyCreepList = bot:GetNearbyCreeps(nCastRange, true)
	local nInRangeEnemyLaneCreepList = bot:GetNearbyLaneCreeps(nCastRange, true)
	local nAllyLaneCreepList = bot:GetNearbyLaneCreeps(800, false)
	local botTarget = J.GetProperTarget(bot)
	
	--关闭分裂的情况
	if J.IsLaning( bot )
		or ( #nInRangeEnemyHeroList == 1 )
		or ( J.IsGoingOnSomeone(bot) and J.IsValidHero(botTarget) and nSkillLv <= 2 and #nInRangeEnemyHeroList == 2 )
		or ( #nInRangeEnemyHeroList == 0 and #nInRangeEnemyCreepList <= 1 )
		or ( #nInRangeEnemyHeroList == 0 and #nInRangeEnemyLaneCreepList >= 2 and #nAllyLaneCreepList >= 1 and nSkillLv <= 3 )
	then
		if abilityQ:GetToggleState()
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	else
		if not abilityQ:GetToggleState()
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end
	

	return BOT_ACTION_DESIRE_NONE
		
end


-- function X.ConsiderE()

-- 	if not abilityE:IsFullyCastable() then return 0 end

-- 	if nHP > 0.8 and nMP < 0.88 and nLV < 15
-- 	  and J.GetEnemyCount( bot, 1600 ) <= 1
-- 	  and lastToggleTime + 3.0 < DotaTime()
-- 	then
-- 		if abilityE:GetToggleState()
-- 		then
-- 			return BOT_ACTION_DESIRE_HIGH
-- 		end
-- 	else
-- 		if not abilityE:GetToggleState()
-- 		then
-- 			lastToggleTime = DotaTime()
-- 			return BOT_ACTION_DESIRE_HIGH
-- 		end
-- 	end

-- 	return BOT_ACTION_DESIRE_NONE


-- end

function X.ConsiderW()

	if not J.CanCastAbility(abilityW) then return 0 end

	local nCastRange = abilityW:GetCastRange() + 20
	local nDamage = abilityW:GetSpecialValueInt( 'snake_damage' ) * 2
	local nSkillLv = abilityW:GetLevel()

	if J.IsRetreating( bot )
	then
		local tableNearbyEnemyHeroes = bot:GetNearbyHeroes( nCastRange, true, BOT_MODE_NONE )
		for _, npcEnemy in pairs( tableNearbyEnemyHeroes )
		do
			if J.IsValidHero( npcEnemy )
				and bot:WasRecentlyDamagedByHero( npcEnemy, 3.0 )
				and J.CanCastOnTargetAdvanced( npcEnemy )
				and J.CanCastOnNonMagicImmune( npcEnemy )
			then
				return BOT_ACTION_DESIRE_MODERATE, npcEnemy
			end
		end
	end

	if J.IsInTeamFight( bot, 1200 )
	then

		local npcMaxManaEnemy = nil
		local nEnemyMaxMana = 0

		local tableNearbyEnemyHeroes = bot:GetNearbyHeroes( nCastRange + 50, true, BOT_MODE_NONE )
		for _, npcEnemy in pairs( tableNearbyEnemyHeroes )
		do
			if J.IsValidHero( npcEnemy )
				and J.CanCastOnNonMagicImmune( npcEnemy )
				and J.CanCastOnTargetAdvanced( npcEnemy )
			then
				local nMaxMana = npcEnemy:GetMaxMana()
				if ( nMaxMana > nEnemyMaxMana )
				then
					nEnemyMaxMana = nMaxMana
					npcMaxManaEnemy = npcEnemy
				end
			end
		end

		if ( npcMaxManaEnemy ~= nil )
		then
			return BOT_ACTION_DESIRE_HIGH, npcMaxManaEnemy
		end

	end

	if J.IsGoingOnSomeone( bot )
	then
		local npcTarget = J.GetProperTarget( bot )
		if J.IsValidHero( npcTarget )
			and J.CanCastOnNonMagicImmune( npcTarget )
			and J.CanCastOnTargetAdvanced( npcTarget )
			and J.IsInRange( npcTarget, bot, nCastRange + 90 )
		then
			return BOT_ACTION_DESIRE_HIGH, npcTarget
		end
	end

	if nSkillLv >= 3 then
		local nAoe = bot:FindAoELocation( true, false, bot:GetLocation(), 900, 500, 0, 0 )
		local nShouldAoeCount = 5
		local nCreeps = bot:GetNearbyCreeps( nCastRange, true )
		local nLaneCreeps = bot:GetNearbyLaneCreeps( 1600, true )

		if nSkillLv == 4 then nShouldAoeCount = 4 end
		if bot:GetLevel() >= 20 or J.GetMP( bot ) > 0.88 then nShouldAoeCount = 3 end

		if nAoe.count >= nShouldAoeCount
		then
			if J.IsValid( nCreeps[1] )
				and J.CanCastOnNonMagicImmune( nCreeps[1] )
				and not ( nCreeps[1]:GetTeam() == TEAM_NEUTRAL and #nLaneCreeps >= 1 )
				and J.GetAroundTargetEnemyUnitCount( nCreeps[1], 470 ) >= 2
			then
				return BOT_ACTION_DESIRE_HIGH, nCreeps[1]
			end
		end

		if #nCreeps >= 2 and nSkillLv >= 3
		then
			local creeps = bot:GetNearbyCreeps( 1400, true )
			local heroes = bot:GetNearbyHeroes( 1000, true, BOT_MODE_NONE )
			if J.IsValid( nCreeps[1] )
				and #creeps + #heroes >= 4
				and J.CanCastOnNonMagicImmune( nCreeps[1] )
				and not ( nCreeps[1]:GetTeam() == TEAM_NEUTRAL and #nLaneCreeps >= 1 )
				and J.GetAroundTargetEnemyUnitCount( nCreeps[1], 470 ) >= 2
			then
				return BOT_ACTION_DESIRE_HIGH, nCreeps[1]
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0

end

function X.ConsiderGorgonGrasp()
	if not J.CanCastAbility(GorgonGrasp)
	then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastRange = J.GetProperCastRange(false, bot, GorgonGrasp:GetCastRange())
	local nCastPoint = GorgonGrasp:GetCastPoint()
	local nRadius = GorgonGrasp:GetSpecialValueInt('radius')
	local nRadiusGrow = GorgonGrasp:GetSpecialValueInt('radius_grow')
	local nDelay = GorgonGrasp:GetSpecialValueInt('delay')
	local nVolleyInterval = GorgonGrasp:GetSpecialValueInt('volley_interval')
	local nDamage = GorgonGrasp:GetSpecialValueInt('damage')
	local nDPS = GorgonGrasp:GetSpecialValueInt('damage_pers')
	local nDuration = GorgonGrasp:GetSpecialValueInt('duration')
	local botTarget = J.GetProperTarget(bot)

	local tAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
	local tEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	local eta = nCastPoint + nDelay

	for _, enemyHero in pairs(tEnemyHeroes)
	do
		if J.IsValidHero(enemyHero)
		and J.IsInRange(bot, enemyHero, nCastRange)
		and J.CanCastOnNonMagicImmune(enemyHero)
		then
			if enemyHero:IsChanneling()
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation()
			end

			if J.CanKillTarget(enemyHero, nDamage + nDPS * nDuration, DAMAGE_TYPE_PHYSICAL)
			and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
			and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
			and not enemyHero:HasModifier('modifier_enigma_black_hole_pull')
			and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
			and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			then
				return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(enemyHero, eta)
			end
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		if J.IsValidHero(botTarget)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and not J.IsDisabled(botTarget)
		and not botTarget:HasModifier('modifier_enigma_black_hole_pull')
		and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(botTarget, eta)
		end
	end

	if J.IsRetreating(bot)
	and not J.IsRealInvisible(bot)
	then
		for _, enemyHero in pairs(tEnemyHeroes)
		do
			if J.IsValidHero(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange)
			and bot:WasRecentlyDamagedByHero(enemyHero, 2.5)
			and (J.IsChasingTarget(enemyHero, bot) or J.GetHP(bot) < 0.5)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and not J.IsDisabled(enemyHero)
			and not enemyHero:HasModifier('modifier_enigma_black_hole_pull')
			and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
			and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			then
				return BOT_ACTION_DESIRE_HIGH, (bot:GetLocation() + enemyHero:GetLocation()) / 2
			end
		end
	end

	for _, allyHero in pairs(tAllyHeroes)
    do
        if  J.IsValidHero(allyHero)
        and J.IsRetreating(allyHero)
        and allyHero:GetActiveModeDesire() >= 0.7
        and allyHero:WasRecentlyDamagedByAnyHero(3)
        and not allyHero:IsIllusion()
        then
            local nAllyInRangeEnemy = allyHero:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

            if J.IsValidHero(nAllyInRangeEnemy[1])
            and J.CanCastOnNonMagicImmune(nAllyInRangeEnemy[1])
            and J.IsInRange(bot, nAllyInRangeEnemy[1], nCastRange)
            and J.IsChasingTarget(nAllyInRangeEnemy[1], allyHero)
            and not J.IsDisabled(nAllyInRangeEnemy[1])
            and not nAllyInRangeEnemy[1]:HasModifier('modifier_enigma_black_hole_pull')
            and not nAllyInRangeEnemy[1]:HasModifier('modifier_faceless_void_chronosphere_freeze')
            and not nAllyInRangeEnemy[1]:HasModifier('modifier_necrolyte_reapers_scythe')
            then
                return BOT_ACTION_DESIRE_HIGH, J.GetCorrectLoc(nAllyInRangeEnemy[1], eta)
            end
        end
    end

	return BOT_ACTION_DESIRE_NONE, 0
end


function X.ConsiderR()

	if not J.CanCastAbility(abilityR) then return 0	end

	local nCastRange = abilityR:GetSpecialValueInt( "radius" )
	local nAttackRange = bot:GetAttackRange()

	--如果射程内无面对自己的真身则不开大
	local bRealHeroFace = false
	local realHeroList = J.GetEnemyList( bot, nAttackRange + 100 )
	for _, npcEnemy in pairs( realHeroList )
	do 
		if npcEnemy:IsFacingLocation( bot:GetLocation(), 50 )
		then
			bRealHeroFace = true
			break
		end
	end
	
	if not bRealHeroFace then return 0 end 
	

	if J.IsRetreating( bot )
	then
		local tableNearbyEnemyHeroes = bot:GetNearbyHeroes( 1000, true, BOT_MODE_NONE )
		for _, npcEnemy in pairs( tableNearbyEnemyHeroes )
		do
			if ( bot:WasRecentlyDamagedByHero( npcEnemy, 2.0 ) and npcEnemy:IsFacingLocation( bot:GetLocation(), 20 ) )
			then
				return BOT_ACTION_DESIRE_MODERATE
			end
		end
	end


	if J.IsInTeamFight( bot, 1200 ) or J.IsGoingOnSomeone( bot )
	then
		local locationAoE = bot:FindAoELocation( true, true, bot:GetLocation(), nAttackRange, 400, 0, 0 )
		if ( locationAoE.count >= 2 )
		then
			local nInvUnit = J.GetInvUnitInLocCount( bot, nAttackRange + 200, 400, locationAoE.targetloc, true )
			if nInvUnit >= locationAoE.count then
				return BOT_ACTION_DESIRE_MODERATE
			end
		end

		local nEnemysHerosInSkillRange = bot:GetNearbyHeroes( 800, true, BOT_MODE_NONE )
		if #nEnemysHerosInSkillRange >= 3
		then
			return BOT_ACTION_DESIRE_HIGH
		end

		local nAoe = bot:FindAoELocation( true, true, bot:GetLocation(), 10, 700, 1.0, 0 )
		if nAoe.count >= 3
		then
			return BOT_ACTION_DESIRE_HIGH
		end

		local npcTarget = J.GetProperTarget( bot )
		if J.IsValidHero( npcTarget )
			and J.CanCastOnNonMagicImmune( npcTarget )
			and not J.IsDisabled( npcTarget )
			and GetUnitToUnitDistance( npcTarget, bot ) <= bot:GetAttackRange()
			and npcTarget:GetHealth() > 600
			and npcTarget:GetPrimaryAttribute() ~= ATTRIBUTE_INTELLECT
			and npcTarget:IsFacingLocation( bot:GetLocation(), 30 )
		then
			return BOT_ACTION_DESIRE_HIGH
		end

	end

	return BOT_ACTION_DESIRE_NONE

end


function X.GetHurtCount( nUnit, nCount )

	local nHeroes = bot:GetNearbyHeroes( 1600, true, BOT_MODE_NONE )
	local nCreeps = bot:GetNearbyCreeps( 1600, true, BOT_MODE_NONE )
	local nTable = {}
	table.insert( nTable, nUnit )
	local nHurtCount = 1

	for i=1, nCount
	do
		local nNeastUnit = X.GetNearestUnit( nUnit, nHeroes, nCreeps, nTable )

		if nNeastUnit ~= nil
			and GetUnitToUnitDistance( nUnit, nNeastUnit ) <= 475
		then
			nHurtCount = nHurtCount + 1
			table.insert( nTable, nNeastUnit )
		else
			break
		end
	end


	return nHurtCount

end

function X.GetNearestUnit( nUnit, nHeroes, nCreeps, nTable )

	local NearestUnit = nil
	local NearestDist = 9999
	for _, unit in pairs( nHeroes )
	do
		if J.IsValid(unit)
			and not X.IsExistInTable( unit, nTable )
			and GetUnitToUnitDistance( nUnit, unit ) < NearestDist
		then
			NearestUnit = unit
			NearestDist = GetUnitToUnitDistance( nUnit, unit )
		end
	end

	for _, unit in pairs( nCreeps )
	do
		if J.IsValid(unit)
			and not X.IsExistInTable( unit, nTable )
			and GetUnitToUnitDistance( nUnit, unit ) < NearestDist
		then
			NearestUnit = unit
			NearestDist = GetUnitToUnitDistance( nUnit, unit )
		end
	end

	return NearestUnit

end

function X.IsExistInTable( u, tUnit )
	for _, t in pairs( tUnit )
	do
		if t == u
		then
			return true
		end
	end
	return false
end

return X
