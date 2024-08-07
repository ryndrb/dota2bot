local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_juggernaut'
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
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
                [1] = {1,2,1,3,1,6,1,2,2,2,6,3,3,3,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_double_branches",
				"item_slippers",
				"item_circlet",
				"item_quelling_blade",
			
				"item_wraith_band",
				"item_power_treads",
				"item_maelstrom",
				"item_magic_wand",
				"item_manta",--
				"item_mjollnir",--
				"item_skadi",--
				"item_aghanims_shard",
				"item_basher",
				"item_butterfly",--
				"item_abyssal_blade",--
				"item_travel_boots_2",--
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

if J.Role.IsPvNMode() or J.Role.IsAllShadow() then X['sBuyList'], X['sSellList'] = { 'PvN_melee_carry' }, {"item_power_treads", 'item_quelling_blade'} end

nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] = J.SetUserHeroInit( nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] )

X['sSkillList'] = J.Skill.GetSkillList( sAbilityList, nAbilityBuildList, sTalentList, nTalentBuildList )

X['bDeafaultAbility'] = false
X['bDeafaultItem'] = false

function X.MinionThink( hMinionUnit )

	if Minion.IsValidUnit( hMinionUnit )
	then
		if hMinionUnit:GetUnitName() == 'npc_dota_juggernaut_healing_ward'
		then
			Minion.HealingWardThink( hMinionUnit )
		else
			Minion.IllusionThink( hMinionUnit )
		end
	end

end

end

--[[

npc_dota_hero_juggernaut

"Ability1"		"juggernaut_blade_fury"
"Ability2"		"juggernaut_healing_ward"
"Ability3"		"juggernaut_blade_dance"
"Ability4"		"juggernaut_swift_slash"
"Ability5"		"generic_hidden"
"Ability6"		"juggernaut_omni_slash"
"Ability10"		"special_bonus_all_stats_5"
"Ability11"		"special_bonus_movement_speed_20"
"Ability12"		"special_bonus_unique_juggernaut_4"
"Ability13"		"special_bonus_attack_speed_20"
"Ability14"		"special_bonus_armor_8"
"Ability15"		"special_bonus_unique_juggernaut_3"
"Ability16"		"special_bonus_hp_475"
"Ability17"		"special_bonus_unique_juggernaut_2"

modifier_juggernaut_blade_fury
modifier_juggernaut_healing_ward_aura
modifier_juggernaut_healing_ward_tracker
modifier_juggernaut_healing_ward_heal
modifier_juggernaut_blade_dance
modifier_juggernaut_omnislash
modifier_juggernaut_omnislash_invulnerability


--]]

local abilityQ = bot:GetAbilityByName('juggernaut_blade_fury')
local abilityW = bot:GetAbilityByName('juggernaut_healing_ward')
local abilityE = bot:GetAbilityByName('juggernaut_blade_dance')
local abilityD = bot:GetAbilityByName('juggernaut_swift_slash')
local abilityR = bot:GetAbilityByName('juggernaut_omni_slash')

local castQDesire, castQTarget
local castWDesire, castWTarget
local castEDesire, castETarget
local castDDesire, castDTarget
local castRDesire, castRTarget

local nKeepMana, nMP, nHP, nLV, hEnemyList, hAllyList, botTarget, sMotive
local aetherRange = 0


function X.SkillsComplement()
	if J.CanNotUseAbility( bot ) then return end

	abilityQ = bot:GetAbilityByName('juggernaut_blade_fury')
	abilityW = bot:GetAbilityByName('juggernaut_healing_ward')
	abilityD = bot:GetAbilityByName('juggernaut_swift_slash')
	abilityR = bot:GetAbilityByName('juggernaut_omni_slash')

	nKeepMana = 400
	aetherRange = 0
	nLV = bot:GetLevel()
	nMP = bot:GetMana() / bot:GetMaxMana()
	nHP = bot:GetHealth() / bot:GetMaxHealth()
	botTarget = J.GetProperTarget( bot )
	hEnemyList = bot:GetNearbyHeroes( 1600, true, BOT_MODE_NONE )
	hAllyList = J.GetAlliesNearLoc( bot:GetLocation(), 1600 )


	--计算天赋可能带来的通用变化
	local aether = J.IsItemAvailable( "item_aether_lens" )
	if aether ~= nil then aetherRange = 250 end


	castDDesire, castDTarget, sMotive = X.ConsiderD()
	if castDDesire > 0
	then

		J.SetQueuePtToINT( bot, true )

		bot:ActionQueue_UseAbilityOnEntity( abilityD, castDTarget )
		return
	end

	castRDesire, castRTarget, sMotive = X.ConsiderR()
	if castRDesire > 0
	then

		J.SetQueuePtToINT( bot, true )

		bot:ActionQueue_UseAbilityOnEntity( abilityR, castRTarget )
		return
	end
	
	castQDesire, sMotive = X.ConsiderQ()
	if castQDesire > 0
	then

		J.SetQueuePtToINT( bot, true )

		bot:ActionQueue_UseAbility( abilityQ )
		return
	end

	castWDesire, castWTarget, sMotive = X.ConsiderW()
	if castWDesire > 0
	then

		J.SetQueuePtToINT( bot, true )

		bot:ActionQueue_UseAbilityOnLocation( abilityW, castWTarget )
		return
	end
	

end


function X.ConsiderQ()


	if not J.CanCastAbility(abilityQ)
		or bot:HasModifier('modifier_juggernaut_blade_fury')
		or bot:HasModifier('modifier_juggernaut_omnislash')
	then return 0 end

	local nSkillLV = abilityQ:GetLevel()
	local nCastRange = abilityQ:GetSpecialValueInt( 'blade_fury_radius' )
	local nRadius = abilityQ:GetSpecialValueInt( 'blade_fury_radius' )
	local nCastPoint = abilityQ:GetCastPoint()
	local nManaCost = abilityQ:GetManaCost()
	local nDamage = 0
	local nDamageType = DAMAGE_TYPE_MAGICAL
	local nInRangeEnemyList = J.GetAroundEnemyHeroList( nRadius )
	local nInBonusEnemyList = J.GetAroundEnemyHeroList( nRadius + 200 )
	local hCastTarget = nil
	local sCastMotive = nil

	--防御眩晕弹道
	if nHP < 0.85 
		and J.IsStunProjectileIncoming( bot, 1000 )
	then		
		hCastTarget = bot
		sCastMotive = 'Q-防御眩晕弹道'
		return BOT_ACTION_DESIRE_HIGH, sCastMotive		
	end	
	
	--打架攻击
	if J.IsGoingOnSomeone( bot )
	then
		if J.IsValidHero( botTarget )
			and J.IsInRange( botTarget, bot, nRadius )
			and J.CanCastOnNonMagicImmune( botTarget )			
		then			
			hCastTarget = botTarget
			sCastMotive = 'Q-攻击:'..J.Chat.GetNormName( hCastTarget )
			return BOT_ACTION_DESIRE_HIGH, sCastMotive
		end
	end
	
	
	--团战AOE
	if J.IsInTeamFight( bot, 1000 )
	then
		local nAoeCount = 0
		for _, npcEnemy in pairs( nInRangeEnemyList )
		do 
			if J.IsValidHero( npcEnemy )
				and J.CanCastOnNonMagicImmune( npcEnemy )
			then
				nAoeCount = nAoeCount + 1	
			end
		end

		if nAoeCount >= 2
		then
			hCastTarget = botTarget
			sCastMotive = 'Q-团战AOE'..nAoeCount
			return BOT_ACTION_DESIRE_HIGH, sCastMotive
		end
	end
	
	
	--撤退时保护自己
	if J.IsRetreating( bot )
	then
		for _, npcEnemy in pairs( hEnemyList )
		do
			if J.IsValid( npcEnemy )
				and J.IsInRange( bot, npcEnemy, 1200 )
				and bot:WasRecentlyDamagedByHero( npcEnemy, 2.0 )
				and J.CanCastOnMagicImmune( npcEnemy )
				and ( J.IsInRange( bot, npcEnemy, nRadius - 120 ) 
					or ( nLV >= 9 and bot:GetCurrentMovementSpeed() < 220 ) )
			then
				hCastTarget = npcEnemy
				sCastMotive = 'Q-撤退'..J.Chat.GetNormName( hCastTarget )
				return BOT_ACTION_DESIRE_HIGH, sCastMotive
			end
		end
		
		if J.IsNotAttackProjectileIncoming( bot, 700 )
		then
			hCastTarget = bot
			sCastMotive = 'Q-躲避'..J.Chat.GetNormName( hCastTarget )
			return BOT_ACTION_DESIRE_HIGH, sCastMotive
		end		
	end
		
	
	--带线AOE
	if ( J.IsPushing( bot ) or J.IsDefending( bot ) or J.IsFarming( bot ) )
		and J.IsAllowedToSpam( bot, nManaCost * 0.32 )
		and #hAllyList <= 2 
		and J.IsItemAvailable( "item_bfury" ) == nil
	then
		local laneCreepList = bot:GetNearbyLaneCreeps( nCastRange , true )
		if ( #laneCreepList >= 4 or ( #laneCreepList >= 3 and nMP > 0.82 ) )
			and not laneCreepList[1]:HasModifier( "modifier_fountain_glyph" )
		then
			hCastTarget = creep
			sCastMotive = 'Q-带线AOE'..(#laneCreepList)
			return BOT_ACTION_DESIRE_HIGH, sCastMotive
		end
	end
	
	
	
	--打野AOE
	if J.IsFarming( bot )
		and DotaTime() > 6 * 60
		and J.IsAllowedToSpam( bot, nManaCost * 0.25 )
		and J.IsItemAvailable( "item_bfury" ) == nil
	then
		local creepList = bot:GetNearbyNeutralCreeps( nRadius )

		if #creepList >= 4
			and J.IsValid( botTarget )
		then
			hCastTarget = botTarget
			sCastMotive = 'Q-打野AOE'..(#creepList)
			return BOT_ACTION_DESIRE_HIGH, sCastMotive
	    end
	end



	return BOT_ACTION_DESIRE_NONE


end


function X.ConsiderW()


	if not J.CanCastAbility(abilityW) then return 0 end

	local nSkillLV = abilityW:GetLevel()
	local nCastRange = abilityW:GetCastRange()
	local nRadius = 600
	local nCastPoint = abilityW:GetCastPoint()
	local nManaCost = abilityW:GetManaCost()
	local nDamage = abilityW:GetSpecialValueInt( 'dam' )
	local nDamageType = DAMAGE_TYPE_MAGICAL
	local nInRangeEnemyList = J.GetAroundEnemyHeroList( nCastRange )
	local nInBonusEnemyList = J.GetAroundEnemyHeroList( nCastRange + 200 )
	local hCastTarget = nil
	local sCastMotive = nil

	
	--团战回血
	if J.IsInTeamFight( bot, 1200 )
	then
		local lostHP = 0
		for _, npcAlly in pairs( hAllyList )
		do 
			if J.IsValidHero( npcAlly )
				and J.IsInRange( bot, npcAlly, 1000 )
			then
				lostHP = lostHP + 1 - npcAlly:GetHealth()/npcAlly:GetMaxHealth()
			end
		end
		
		if lostHP >= 0.6
		then
			hCastTarget = J.GetFaceTowardDistanceLocation( bot, 16 )
			sCastMotive = 'W-团战辅助'
			return BOT_ACTION_DESIRE_HIGH, hCastTarget, sCastMotive			
		end
	end	
	
	
	
	--攻击敌人时
	if J.IsGoingOnSomeone( bot )
		and nHP < 0.6
	then
		if J.IsValidHero( botTarget )
			and J.IsInRange( bot, botTarget, 900 )
			and J.CanCastOnMagicImmune( botTarget )
		then
			hCastTarget = J.GetFaceTowardDistanceLocation( bot, 16 )
			sCastMotive = 'W-辅助进攻:'..J.Chat.GetNormName( botTarget )
			return BOT_ACTION_DESIRE_HIGH, hCastTarget, sCastMotive	
		end
	end
	
	
	
	--撤退时保护自己
	if J.IsRetreating( bot ) 
		and nHP < 0.5
		and bot:DistanceFromFountain() > 800
	then
		hCastTarget = J.GetFaceTowardDistanceLocation( bot, 16 )
		sCastMotive = 'W-撤退回血'
		return BOT_ACTION_DESIRE_HIGH, hCastTarget, sCastMotive	
	end
	
	

	return BOT_ACTION_DESIRE_NONE


end


function X.ConsiderR()


	if not J.CanCastAbility(abilityR)
		or bot:HasModifier('modifier_juggernaut_blade_fury')
		or bot:HasModifier('modifier_juggernaut_omnislash')
	then return 0 end

	local nSkillLV = abilityR:GetLevel()
	local nCastRange = abilityR:GetCastRange() 
	local nRadius = 600
	local nCastPoint = abilityR:GetCastPoint()
	local nManaCost = abilityR:GetManaCost()
	local nDamage = abilityR:GetSpecialValueInt( 'damage' )
	local nDamageType = DAMAGE_TYPE_MAGICAL
	local nInRangeEnemyList = J.GetAroundEnemyHeroList( nCastRange + 50 )
	local nInBonusEnemyList = J.GetAroundEnemyHeroList( nCastRange + 200 )
	local hCastTarget = nil
	local sCastMotive = nil
	
	
	--防御眩晕弹道
	if J.IsStunProjectileIncoming( bot, 1000 )
	then
		for _, npcEnemy in pairs( nInBonusEnemyList )
		do
			if J.IsValid( npcEnemy )
				and J.CanCastOnNonMagicImmune( npcEnemy )
				and J.CanCastOnTargetAdvanced( npcEnemy )
			then
				hCastTarget = npcEnemy
				sCastMotive = 'R-防御:'..J.Chat.GetNormName( hCastTarget )
				return BOT_ACTION_DESIRE_HIGH, hCastTarget, sCastMotive
			end
		end	
	end
	
	
	--攻击敌人时
	if J.IsGoingOnSomeone( bot )
	then
		if J.IsValidHero( botTarget )
			and J.IsInRange( botTarget, bot, 900 )
			and ( botTarget:GetHealth() > bot:GetAttackDamage() * 4 
					or nHP < 0.2
					or #nInBonusEnemyList >= 2 )
		then
			for _, npcEnemy in pairs( nInRangeEnemyList )
			do
				if J.IsValid( npcEnemy )
					and J.CanCastOnNonMagicImmune( npcEnemy )
					and J.CanCastOnTargetAdvanced( npcEnemy )
				then
					hCastTarget = npcEnemy
					sCastMotive = 'R-攻击:'..J.Chat.GetNormName( hCastTarget )
					return BOT_ACTION_DESIRE_HIGH, hCastTarget, sCastMotive
				end
			end
		end
	end
	
	
	--撤退时保护自己
	if J.IsRetreating( bot )
	then
		for _, npcEnemy in pairs( nInRangeEnemyList )
		do
			if J.IsValid( npcEnemy )
				and bot:WasRecentlyDamagedByHero( npcEnemy, 5.0 )
				and J.CanCastOnNonMagicImmune( npcEnemy )
				and J.CanCastOnTargetAdvanced( npcEnemy )
			then
				hCastTarget = npcEnemy
				sCastMotive = 'R-撤退'..J.Chat.GetNormName( hCastTarget )
				return BOT_ACTION_DESIRE_HIGH, hCastTarget, sCastMotive
			end
		end
	end



	return BOT_ACTION_DESIRE_NONE


end

function X.ConsiderD()


	if	not bot:HasScepter()
		or not J.CanCastAbility(abilityD)
		or bot:HasModifier('modifier_juggernaut_blade_fury')
		or bot:HasModifier('modifier_juggernaut_omnislash')
	then return 0 end

	local nSkillLV = abilityD:GetLevel()
	local nCastRange = abilityD:GetCastRange()
	local nRadius = 600
	local nCastPoint = abilityD:GetCastPoint()
	local nManaCost = abilityD:GetManaCost()
	local nDamage = 0
	local nDamageType = DAMAGE_TYPE_MAGICAL
	local nInRangeEnemyList = J.GetAroundEnemyHeroList( nCastRange )
	local nInBonusEnemyList = J.GetAroundEnemyHeroList( nCastRange + 200 )
	local hCastTarget = nil
	local sCastMotive = nil

	
	--攻击敌人时
	if J.IsGoingOnSomeone( bot )
	then
		if J.IsValidHero( botTarget )
			and J.IsInRange( botTarget, bot, 1400 )
		then
			for _, npcEnemy in pairs( nInRangeEnemyList )
			do
				if J.IsValid( npcEnemy )
					and J.IsInRange( botTarget, npcEnemy, 425 )
					and J.CanCastOnNonMagicImmune( npcEnemy )
					and J.CanCastOnTargetAdvanced( npcEnemy )
				then
					hCastTarget = npcEnemy
					sCastMotive = 'D-攻击:'..J.Chat.GetNormName( hCastTarget )
					return BOT_ACTION_DESIRE_HIGH, hCastTarget, sCastMotive
				end
			end
		end
	end
	
	
	--撤退时保护自己
	if J.IsRetreating( bot )
	then
		for _, npcEnemy in pairs( nInRangeEnemyList )
		do
			if J.IsValid( npcEnemy )
				and bot:WasRecentlyDamagedByHero( npcEnemy, 2.0 )
				and J.CanCastOnNonMagicImmune( npcEnemy )
				and J.CanCastOnTargetAdvanced( npcEnemy )
			then
				hCastTarget = npcEnemy
				sCastMotive = 'D-撤退'..J.Chat.GetNormName( hCastTarget )
				return BOT_ACTION_DESIRE_HIGH, hCastTarget, sCastMotive
			end
		end
	end


	return BOT_ACTION_DESIRE_NONE


end


return X

