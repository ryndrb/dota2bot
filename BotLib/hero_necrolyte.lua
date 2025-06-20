local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_necrolyte'
then

local RI = require(GetScriptDirectory()..'/FunLib/util_role_item')

local sUtility = {"item_pipe", "item_lotus_orb", "item_heavens_halberd"}
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
					['t20'] = {10, 0},
					['t15'] = {0, 10},
					['t10'] = {10, 0},
				}
            },
            ['ability'] = {
                [1] = {1,3,1,3,1,6,1,2,3,3,6,2,2,2,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_faerie_fire",
				"item_double_circlet",
			
				"item_magic_wand",
				"item_boots",
				"item_double_null_talisman",
				"item_radiance",--
				"item_travel_boots",
				"item_ultimate_scepter",
				"item_aghanims_shard",
				"item_heart",--
				"item_shivas_guard",--
				"item_wind_waker",--
				"item_octarine_core",
				"item_ultimate_scepter_2",
				"item_moon_shard",
				"item_travel_boots_2",--
			},
            ['sell_list'] = {
				"item_magic_wand", "item_heart",
				"item_null_talisman", "item_shivas_guard",
				"item_null_talisman", "item_wind_waker",
			},
        },
    },
    ['pos_3'] = {
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
                [1] = {1,3,1,2,1,6,1,3,3,3,6,2,2,2,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_faerie_fire",
				"item_double_circlet",
			
				"item_magic_wand",
				"item_boots",
				"item_null_talisman",
				"item_bracer",
				"item_radiance",--
				sUtilityItem,--
				"item_travel_boots",
				"item_aghanims_shard",
				"item_heart",--
				"item_ultimate_scepter",
				"item_shivas_guard",--
				"item_cyclone",
				"item_ultimate_scepter_2",
				"item_wind_waker",--
				"item_moon_shard",
				"item_travel_boots_2",--
			},
            ['sell_list'] = {
				"item_magic_wand", "item_heart",
				"item_null_talisman", "item_ultimate_scepter",
				"item_bracer", "item_shivas_guard",
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

--[[

npc_dota_hero_necrolyte

"Ability1"		"necrolyte_death_pulse"
"Ability2"		"necrolyte_sadist"
"Ability3"		"necrolyte_heartstopper_aura"
"Ability4"		"generic_hidden"
"Ability5"		"generic_hidden"
"Ability6"		"necrolyte_reapers_scythe"
"Ability10"		"special_bonus_attack_damage_30"
"Ability11"		"special_bonus_strength_10"
"Ability12"		"special_bonus_unique_necrophos_3"
"Ability13"		"special_bonus_unique_necrophos_4"
"Ability14"		"special_bonus_magic_resistance_20"
"Ability15"		"special_bonus_attack_speed_70"
"Ability16"		"special_bonus_unique_necrophos_2"
"Ability17"		"special_bonus_unique_necrophos"

modifier_necrolyte_sadist_active
modifier_necrolyte_sadist_aura_effect
modifier_necrolyte_heartstopper_aura
modifier_necrolyte_heartstopper_aura_counter
modifier_necrolyte_heartstopper_aura_effect
modifier_necrolyte_reapers_scythe
modifier_necrolyte_reapers_scythe_respawn_time


--]]

local abilityQ = bot:GetAbilityByName('necrolyte_death_pulse')
local abilityW = bot:GetAbilityByName('necrolyte_ghost_shroud')
local abilityE = bot:GetAbilityByName('necrolyte_heartstopper_aura')
local abilityAS = bot:GetAbilityByName('necrolyte_death_seeker')
local abilityR = bot:GetAbilityByName('necrolyte_reapers_scythe')


local castQDesire
local castWDesire
local castWQDesire
local castRDesire, castRTarget
local castASDesire, castASTarget

local nKeepMana, nMP, nHP, nLV, hEnemyHeroList

function X.SkillsComplement()


	if J.CanNotUseAbility( bot ) then return end

	abilityQ = bot:GetAbilityByName('necrolyte_death_pulse')
	abilityW = bot:GetAbilityByName('necrolyte_ghost_shroud')
	abilityAS = bot:GetAbilityByName('necrolyte_death_seeker')
	abilityR = bot:GetAbilityByName('necrolyte_reapers_scythe')


	nKeepMana = 400
	nLV = bot:GetLevel()
	nMP = bot:GetMana()/bot:GetMaxMana()
	nHP = bot:GetHealth()/bot:GetMaxHealth()
	hEnemyHeroList = bot:GetNearbyHeroes( 1600, true, BOT_MODE_NONE )


	castRDesire, castRTarget = X.ConsiderR()
	if ( castRDesire > 0 )
	then

		J.SetQueuePtToINT( bot, false )

		bot:ActionQueue_UseAbilityOnEntity( abilityR, castRTarget )
		return
	end

	castWDesire = X.ConsiderW()
	if ( castWDesire > 0 )
	then

		J.SetQueuePtToINT( bot, false )

		bot:ActionQueue_UseAbility( abilityW )
		return

	end
	
	castASDesire, castASTarget = X.ConsiderAS()
	if ( castASDesire > 0 )
	then

		J.SetQueuePtToINT( bot, true )

		bot:ActionQueue_UseAbilityOnEntity( abilityAS, castASTarget )
		return

	end

	castQDesire = X.ConsiderQ()
	if ( castQDesire > 0 )
	then

		J.SetQueuePtToINT( bot, false )

		bot:ActionQueue_UseAbility( abilityQ )
		return

	end

end


function X.ConsiderW()

	if ( not J.CanCastAbility(abilityW) ) then
		return BOT_ACTION_DESIRE_NONE
	end

	local nRadius = abilityW:GetSpecialValueInt( "slow_aoe" )

	local SadStack = 0
	local npcModifier = bot:NumModifiers()

	for i = 0, npcModifier
	do
		if bot:GetModifierName( i ) == "modifier_necrolyte_death_pulse_counter" then
			SadStack = bot:GetModifierStackCount( i )
			break
		end
	end

	if ( SadStack >= 8 or bot:GetHealthRegen() > 99 )
		and bot:GetHealth() / bot:GetMaxHealth() < 0.5
		and bot:GetAttackTarget() == nil
	then
		return BOT_ACTION_DESIRE_LOW
	end


	if J.IsRetreating( bot )
	then
		local tableNearbyEnemyHeroes = bot:GetNearbyHeroes( nRadius, true, BOT_MODE_NONE )
		if bot:WasRecentlyDamagedByAnyHero( 2.0 ) and #tableNearbyEnemyHeroes > 0
		then
			return BOT_ACTION_DESIRE_MODERATE
		end
	end

	if J.IsWithoutTarget( bot ) and J.GetAttackProjectileDamageByRange( bot, 1600 ) >= bot:GetHealth()
	then
		return BOT_ACTION_DESIRE_MODERATE
	end

	if J.IsGoingOnSomeone( bot ) and false
	then
		local npcTarget = bot:GetTarget()
		if J.IsValidHero( npcTarget )
			and J.IsRunning( npcTarget )
			and J.IsRunning( bot )
			and bot:GetAttackTarget() == nil
			and J.CanCastOnNonMagicImmune( npcTarget )
			and J.IsInRange( npcTarget, bot, nRadius - 30 )
			and ( J.GetHP( bot ) < 0.25
				or ( not J.IsInRange( npcTarget, bot, 430 )
					  and bot:IsFacingLocation( npcTarget:GetLocation(), 30 )
					  and not npcTarget:IsFacingLocation( bot:GetLocation(), 120 ) ) )
		then
			local targetAllies = npcTarget:GetNearbyHeroes( 1000, false, BOT_MODE_NONE )
			if targetAllies == nil then targetAllies = {} end
			if #targetAllies == 1 then
				return BOT_ACTION_DESIRE_MODERATE
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
end


function X.ConsiderQ()

	if not J.CanCastAbility(abilityQ)
		or bot:IsInvisible()
		or ( J.GetHP( bot ) > 0.62 and abilityR ~= nil and abilityR:GetCooldownTimeRemaining() < 6 and bot:GetMana() < abilityR:GetManaCost() )
	then
		return BOT_ACTION_DESIRE_NONE
	end


	local nRadius = abilityQ:GetSpecialValueInt( "area_of_effect" )
	local nCastRange = 0
	local nDamage = abilityQ:GetAbilityDamage()
	local nDamageType = DAMAGE_TYPE_MAGICAL

	if J.IsRetreating( bot ) or J.GetHP( bot ) < 0.5
	then
		local tableNearbyEnemyHeroes = bot:GetNearbyHeroes( 2 * nRadius, true, BOT_MODE_NONE )
		if ( bot:WasRecentlyDamagedByAnyHero( 2.0 ) and #tableNearbyEnemyHeroes > 0 )
			or ( J.GetHP( bot ) < 0.75 and bot:DistanceFromFountain() < 400 )
			or J.GetHP( bot ) < J.GetMP( bot )
			or J.GetHP( bot ) < 0.25
		then
			return BOT_ACTION_DESIRE_MODERATE
		end
	end

	if abilityQ:GetLevel() >= 3
	then
		local tableNearbyEnemyCreeps = bot:GetNearbyLaneCreeps( nRadius, true )
		local nCanHurtCount = 0
		local nCanKillCount = 0
		for _, creep in pairs( tableNearbyEnemyCreeps )
		do
			if J.IsValid( creep )
				and not creep:HasModifier( "modifier_fountain_glyph" )
			then
				nCanHurtCount = nCanHurtCount + 1
				if J.CanKillTarget( creep, nDamage + 2, nDamageType )
				then
					nCanKillCount = nCanKillCount + 1
				end
			end
		end

		if nCanKillCount >= 2
			or ( nCanKillCount >= 1 and J.GetMP( bot ) > 0.9 )
			or ( nCanHurtCount >= 3 and bot:GetActiveMode() ~= BOT_MODE_LANING )
			or ( nCanHurtCount >= 3 and nCanKillCount >= 1 and J.IsAllowedToSpam( bot, 190 ) )
			or ( nCanHurtCount >= 3 and J.GetMP( bot ) > 0.8 and bot:GetLevel() > 10 and #tableNearbyEnemyCreeps == 3 )
			or ( nCanHurtCount >= 2 and nCanKillCount >= 1 and bot:GetLevel() > 24 and #tableNearbyEnemyCreeps == 2 )
		then
			return BOT_ACTION_DESIRE_HIGH
		end

	end

	if J.IsInTeamFight( bot, 1200 )
	then
		local tableNearbyEnemyHeroes = bot:GetNearbyHeroes( nRadius, true, BOT_MODE_NONE )
		local tableNearbyAlliesHeroes = bot:GetNearbyHeroes( nRadius, false, BOT_MODE_NONE )
		local lowHPAllies = 0
		for _, ally in pairs( tableNearbyAlliesHeroes )
		do
			if J.IsValidHero( ally )
			then
				local allyHealth = ally:GetHealth() / ally:GetMaxHealth()
				if allyHealth < 0.5 then
					lowHPAllies = lowHPAllies + 1
				end
			end
		end

		if #tableNearbyEnemyHeroes >= 2 or lowHPAllies >= 1 then
			return BOT_ACTION_DESIRE_MODERATE
		end
	end

	local tableNearbyAlliesHeroes = bot:GetNearbyHeroes( nRadius, false, BOT_MODE_NONE )
	if #tableNearbyAlliesHeroes >= 2
	then
		local needHPCount = 0
		for _, Ally in pairs( tableNearbyAlliesHeroes )
		do
			if J.IsValidHero( Ally )
				and Ally:GetMaxHealth()- Ally:GetHealth() > 220
			then
				needHPCount = needHPCount + 1

				if Ally:GetHealth()/Ally:GetMaxHealth() < 0.15
				then
					return BOT_ACTION_DESIRE_MODERATE
				end

				if needHPCount >= 2 and  Ally:GetHealth()/Ally:GetMaxHealth() < 0.38
				then
					return BOT_ACTION_DESIRE_MODERATE
				end

				if needHPCount >= 3
				then
					return BOT_ACTION_DESIRE_MODERATE
				end

			end
		end

	end

	if J.IsGoingOnSomeone( bot )
	then
		local npcTarget = J.GetProperTarget( bot )

		if J.IsValidHero( npcTarget )
			and J.IsInRange( npcTarget, bot, nRadius )
			and J.CanCastOnNonMagicImmune( npcTarget )
		then
			return BOT_ACTION_DESIRE_MODERATE
		end
	end

	local botTarget = J.GetProperTarget( bot )
	if J.IsDoingRoshan(bot)
	then
		if J.IsRoshan( botTarget )
		and J.IsInRange( botTarget, bot, nRadius )
		and J.CanBeAttacked(botTarget)
		and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

    if J.IsDoingTormentor(bot)
	then
		if J.IsTormentor(botTarget)
        and J.IsInRange( botTarget, bot, nRadius )
        and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	return BOT_ACTION_DESIRE_NONE

end


function X.ConsiderR()

	if not J.CanCastAbility(abilityR) then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nCastRange = abilityR:GetCastRange()
	local nDamagePerHealth = abilityR:GetSpecialValueFloat( "damage_per_health" )

	if J.IsGoingOnSomeone( bot )
	then
		local npcTarget = J.GetProperTarget( bot )
		if J.IsValidHero( npcTarget )
			and J.CanCastOnNonMagicImmune( npcTarget )
			and J.CanCastOnTargetAdvanced( npcTarget )
			and not J.IsHaveAegis( npcTarget )
			and not npcTarget:HasModifier( "modifier_arc_warden_tempest_double" )
			and npcTarget:GetUnitName() ~= "npc_dota_hero_abaddon"
			and J.IsInRange( npcTarget, bot, nCastRange + 200 )
		then
			local EstDamage = X.GetEstDamage( bot, npcTarget, nDamagePerHealth )

			if J.CanKillTarget( npcTarget, EstDamage, DAMAGE_TYPE_MAGICAL )
				or ( npcTarget:IsChanneling() and npcTarget:HasModifier( "modifier_teleporting" ) )
			then
				return BOT_ACTION_DESIRE_HIGH, npcTarget
			end
		end
	end

	if J.IsInTeamFight( bot, 1200 )
	then
		local npcToKill = nil
		local tableNearbyEnemyHeroes = bot:GetNearbyHeroes( 1200, true, BOT_MODE_NONE )
		for _, npcEnemy in pairs( tableNearbyEnemyHeroes )
		do
			if J.IsValidHero( npcEnemy )
				and J.CanCastOnNonMagicImmune( npcEnemy )
				and J.CanCastOnTargetAdvanced( npcEnemy )
				and not J.IsHaveAegis( npcEnemy )
				and not npcEnemy:HasModifier( "modifier_arc_warden_tempest_double" )
				and npcEnemy:GetUnitName() ~= "npc_dota_hero_abaddon"
			then
				local EstDamage = X.GetEstDamage( bot, npcEnemy, nDamagePerHealth )
				if J.CanKillTarget( npcEnemy, EstDamage, DAMAGE_TYPE_MAGICAL )
				then
					npcToKill = npcEnemy
					break
				end
			end
		end
		if ( npcToKill ~= nil )
		then
			return BOT_ACTION_DESIRE_HIGH, npcToKill
		end
	end

	local tableNearbyEnemyHeroes = bot:GetNearbyHeroes( 1200, true, BOT_MODE_NONE )
	for _, npcEnemy in pairs( tableNearbyEnemyHeroes )
	do
		if J.IsValidHero( npcEnemy )
			and not J.IsHaveAegis( npcEnemy )
			and J.CanCastOnTargetAdvanced( npcEnemy )
			and npcEnemy:GetUnitName() ~= "npc_dota_hero_abaddon"
			and not npcEnemy:HasModifier( "modifier_arc_warden_tempest_double" )
		then
			local EstDamage = X.GetEstDamage( bot, npcEnemy, nDamagePerHealth )
			if J.CanCastOnNonMagicImmune( npcEnemy ) and J.CanKillTarget( npcEnemy, EstDamage, DAMAGE_TYPE_MAGICAL )
			then
				return BOT_ACTION_DESIRE_HIGH, npcEnemy
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0
end


function X.GetEstDamage( bot, npcTarget, nDamagePerHealth )

	local targetMaxHealth = npcTarget:GetMaxHealth()

	if npcTarget:GetHealth()/ targetMaxHealth > 0.75
	then
		return targetMaxHealth * 0.3
	end

	local AroundTargetAllyCount = J.GetAroundTargetAllyHeroCount( npcTarget, 650 )

	local MagicResistReduce = 1 - npcTarget:GetMagicResist()
	if MagicResistReduce  < 0.1 then  MagicResistReduce = 0.1 end
	local HealthBack =  npcTarget:GetHealthRegen() * 2

	local EstDamage = ( targetMaxHealth - npcTarget:GetHealth() - HealthBack ) * nDamagePerHealth - HealthBack/MagicResistReduce

	if bot:GetLevel() >= 9 then EstDamage = EstDamage + targetMaxHealth * 0.026 end
	if bot:GetLevel() >= 12 then EstDamage = EstDamage + targetMaxHealth * 0.032 end
	if bot:GetLevel() >= 18 then EstDamage = EstDamage + targetMaxHealth * 0.016 end

	if bot:HasScepter() and J.GetHP( bot ) < 0.2 then EstDamage = EstDamage + targetMaxHealth * 0.3 end

	if AroundTargetAllyCount >= 2 then EstDamage = EstDamage + targetMaxHealth * 0.08 * ( AroundTargetAllyCount - 1 ) end

	if npcTarget:HasModifier( "modifier_medusa_mana_shield" )
	then
		local EstDamageMaxReduce = EstDamage * 0.6
		if npcTarget:GetMana() * 2.5 >= EstDamageMaxReduce
		then
			EstDamage = EstDamage * 0.4
		else
			EstDamage = EstDamage * 0.4 + EstDamageMaxReduce - npcTarget:GetMana() * 2.5
		end
	end

	if npcTarget:GetUnitName() == "npc_dota_hero_bristleback"
		and not npcTarget:IsFacingLocation( GetBot():GetLocation(), 120 )
	then
		EstDamage = EstDamage * 0.7
	end

	if npcTarget:HasModifier( "modifier_kunkka_ghost_ship_damage_delay" )
	then
		local buffTime = J.GetModifierTime( npcTarget, "modifier_kunkka_ghost_ship_damage_delay" )
		if buffTime > 2.0 then EstDamage = EstDamage * 0.55 end
	end

	if npcTarget:HasModifier( "modifier_templar_assassin_refraction_absorb" ) then EstDamage = 0 end

	return EstDamage

end



function X.ConsiderAS()

	if not J.CanCastAbility(abilityAS)
	then
		return BOT_ACTION_DESIRE_NONE, 0
	end

	local nRadius = 500
	local nCastRange = abilityAS:GetCastRange()
	local nCastPoint = abilityAS:GetCastPoint()
	local nManaCost = abilityAS:GetManaCost()

	local tableNearbyEnemyHeroes = bot:GetNearbyHeroes( 1600, true, BOT_MODE_NONE )
	
	

	if J.IsInTeamFight( bot, 1400 )
		and #tableNearbyEnemyHeroes >= 3
	then
		local npcMostDangerousEnemy = nil
		local nMostDangerousDamage = 2

		for _, npcEnemy in pairs( tableNearbyEnemyHeroes )
		do
			if J.IsValid( npcEnemy )
				and J.CanCastOnNonMagicImmune( npcEnemy )
				and J.CanCastOnTargetAdvanced( npcEnemy )
			then
				local enemyHeroList = npcEnemy:GetNearbyHeroes( 500, false, BOT_MODE_NONE )
				local allyHeroList = npcEnemy:GetNearbyHeroes( 500, true, BOT_MODE_NONE )
				
				if enemyHeroList == nil then enemyHeroList = {} end
				if allyHeroList == nil then allyHeroList = {} end
				
				local npcEnemyDamage = #enemyHeroList + #allyHeroList
				if ( npcEnemyDamage > nMostDangerousDamage )
				then
					nMostDangerousDamage = npcEnemyDamage
					npcMostDangerousEnemy = npcEnemy
				end
			end
		end

		if ( npcMostDangerousEnemy ~= nil )
		then
			return BOT_ACTION_DESIRE_HIGH, npcMostDangerousEnemy, "AS-团战AOE"
		end
		
	end
	

	if J.IsGoingOnSomeone( bot )
	then
		local targetHero = J.GetProperTarget( bot )
		if J.IsValidHero( targetHero )
			and J.IsInRange( bot, targetHero, nCastRange )
			and J.CanCastOnNonMagicImmune( targetHero )
			and J.CanCastOnTargetAdvanced( targetHero )
		then
			return BOT_ACTION_DESIRE_HIGH, targetHero
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0

end

return X
