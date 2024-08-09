local X = {}
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

if GetBot():GetUnitName() == 'npc_dota_hero_slardar'
then

local RI = require(GetScriptDirectory()..'/FunLib/util_role_item')

local sUtility = {"item_crimson_guard", "item_pipe", "item_heavens_halberd"}
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
					['t20'] = {0, 10},
					['t15'] = {10, 0},
					['t10'] = {0, 10},
				}
            },
            ['ability'] = {
                [1] = {2,3,1,2,2,6,3,3,3,1,6,1,1,2,6},
            },
            ['buy_list'] = {
				"item_tango",
				"item_quelling_blade",
				"item_double_branches",
				"item_faerie_fire",
				"item_circlet",
			
				"item_bottle",
				"item_bracer",
				"item_boots",
				"item_magic_wand",
				"item_power_treads",
				"item_blink",
				"item_harpoon",--
				"item_black_king_bar",--
				"item_ultimate_scepter",
				"item_assault",--
				"item_aghanims_shard",
				"item_bloodthorn",--
				"item_travel_boots",
				"item_overwhelming_blink",--
				"item_ultimate_scepter_2",
				"item_travel_boots_2",--
				"item_moon_shard",
			},
            ['sell_list'] = {
				"item_quelling_blade",
				"item_bottle",
				"item_bracer",
				"item_magic_wand",
				"item_echo_sabre",
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
			
				"item_bracer",
				"item_power_treads",
				"item_magic_wand",
				"item_soul_ring",
				"item_blink",
				"item_black_king_bar",--
				"item_ultimate_scepter",
				sUtilityItem,--
				"item_aghanims_shard",
				"item_assault",--
				"item_cyclone",
				"item_travel_boots",
				"item_swift_blink",--
				"item_wind_waker",--
				"item_ultimate_scepter_2",
				"item_travel_boots_2",--
				"item_moon_shard",
			},
            ['sell_list'] = {
				"item_quelling_blade",
				"item_bracer",
				"item_magic_wand",
				"item_soul_ring",
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

if J.Role.IsPvNMode() or J.Role.IsAllShadow() then X['sBuyList'], X['sSellList'] = { 'PvN_tank' }, {"item_power_treads", 'item_quelling_blade'} end

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

npc_dota_hero_slardar

"Ability1"		"slardar_sprint"
"Ability2"		"slardar_slithereen_crush"
"Ability3"		"slardar_bash"
"Ability4"		"generic_hidden"
"Ability5"		"generic_hidden"
"Ability6"		"slardar_amplify_damage"
"Ability10"		"special_bonus_hp_regen_6"
"Ability11"		"special_bonus_attack_damage_20"
"Ability12"		"special_bonus_hp_275"
"Ability13"		"special_bonus_unique_slardar_2"
"Ability14"		"special_bonus_lifesteal_25"
"Ability15"		"special_bonus_night_vision_800"
"Ability16"		"special_bonus_unique_slardar_4"
"Ability17"		"special_bonus_unique_slardar_3"

modifier_slardar_sprint
modifier_slardar_sprint_river
modifier_slithereen_crush
modifier_slardar_bash_active
modifier_slardar_amplify_damage


--]]

local abilityQ = bot:GetAbilityByName('slardar_sprint')
local abilityW = bot:GetAbilityByName('slardar_slithereen_crush')
local abilityE = bot:GetAbilityByName('slardar_bash')
local abilityR = bot:GetAbilityByName('slardar_amplify_damage')
local talent2 = bot:GetAbilityByName( sTalentList[2] )
local talent6 = bot:GetAbilityByName( sTalentList[6] )

local castQDesire, castQTarget
local castWDesire, castWTarget
local castEDesire, castETarget
local castRDesire, castRTarget

local nKeepMana, nMP, nHP, nLV, hEnemyList, hAllyList, botTarget, sMotive
local aetherRange = 0


function X.SkillsComplement()

	if J.CanNotUseAbility( bot ) or bot:IsInvisible() then return end

	abilityQ = bot:GetAbilityByName('slardar_sprint')
	abilityW = bot:GetAbilityByName('slardar_slithereen_crush')
	abilityR = bot:GetAbilityByName('slardar_amplify_damage')

	nKeepMana = 400
	aetherRange = 0
	nLV = bot:GetLevel()
	nMP = bot:GetMana() / bot:GetMaxMana()
	nHP = bot:GetHealth() / bot:GetMaxHealth()
	botTarget = J.GetProperTarget( bot )
	hEnemyList = bot:GetNearbyHeroes( 1600, true, BOT_MODE_NONE )
	hAllyList = J.GetAlliesNearLoc( bot:GetLocation(), 1600 )


	castWDesire, castWTarget, sMotive = X.ConsiderW()
	if castWDesire > 0
	then

		J.SetQueuePtToINT( bot, true )

		bot:ActionQueue_UseAbility( abilityW )
		return
	end


	castRDesire, castRTarget, sMotive = X.ConsiderR()
	if castRDesire > 0
	then

		J.SetQueuePtToINT( bot, false )

		bot:ActionQueue_UseAbilityOnEntity( abilityR, castRTarget )
		return
	end
	
	
	castQDesire, castQTarget, sMotive = X.ConsiderQ()
	if castQDesire > 0
	then

		J.SetQueuePtToINT( bot, false )

		bot:ActionQueue_UseAbility( abilityQ )
		return
	end

end


function X.ConsiderQ()


	if not J.CanCastAbility(abilityQ) then return 0 end

	local nSkillLV = abilityQ:GetLevel()
	local nCastRange = abilityQ:GetCastRange()
	local nRadius = 600
	local nCastPoint = abilityQ:GetCastPoint()
	local nManaCost = abilityQ:GetManaCost()
	local nDamage = 0
	local nDamageType = DAMAGE_TYPE_MAGICAL
	local nInRangeEnemyList = J.GetAroundEnemyHeroList( nCastRange )
	local nInBonusEnemyList = J.GetAroundEnemyHeroList( nCastRange + 200 )
	local hCastTarget = nil
	local sCastMotive = nil

	
	--攻击敌人时
	if J.IsGoingOnSomeone( bot )
		and J.IsRunning( bot )
	then
		if J.IsValidHero( botTarget )
			and J.IsInRange( bot, botTarget, 1600 )
			and not J.IsInRange( bot, botTarget, 200 )
		then
			hCastTarget = botTarget
			sCastMotive = 'Q-进攻:'..J.Chat.GetNormName( hCastTarget )
			return BOT_ACTION_DESIRE_HIGH, hCastTarget, sCastMotive
		end
	end
	
	
	--逃跑时
	if J.IsRetreating( bot ) 
		and J.IsRunning( bot ) 
		and bot:WasRecentlyDamagedByAnyHero( 5.0 )
		and #hEnemyList >= 1
	then
		hCastTarget = bot
		sCastMotive = 'Q-撤退了'
		return BOT_ACTION_DESIRE_HIGH, hCastTarget, sCastMotive	
	end


	return BOT_ACTION_DESIRE_NONE


end

function X.ConsiderW()


	if not J.CanCastAbility(abilityW) then return 0 end

	local nSkillLV = abilityW:GetLevel()
	local nCastRange = abilityW:GetSpecialValueInt( 'crush_radius' )
	local nRadius = abilityW:GetSpecialValueInt( 'crush_radius' )
	local nCastPoint = abilityW:GetCastPoint()
	local nManaCost = abilityW:GetManaCost()
	local nDamage = abilityW:GetAbilityDamage()
	local nDamageType = DAMAGE_TYPE_MAGICAL
	local nInRangeEnemyList = J.GetAroundEnemyHeroList( nCastRange - 30 )
	local nInBonusEnemyList = J.GetAroundEnemyHeroList( nCastRange - 100 )
	local hCastTarget = nil
	local sCastMotive = nil

	
	--击杀打断敌人
	for _, npcEnemy in pairs( nInRangeEnemyList )
	do 
		if J.IsValid( npcEnemy )
			and J.CanCastOnNonMagicImmune( npcEnemy )
			and ( J.CanKillTarget( npcEnemy, nDamage, nDamageType )
					or npcEnemy:IsChanneling() )
		then
			hCastTarget = npcEnemy
			sCastMotive = 'W-击杀打断'..J.Chat.GetNormName( hCastTarget )
			return BOT_ACTION_DESIRE_HIGH, hCastTarget, sCastMotive
		end
	
	end
		
	
	--打架攻击
	if J.IsGoingOnSomeone( bot )
	then
		if J.IsValidHero( botTarget )
			and J.IsInRange( botTarget, bot, nRadius - 99 )
			and J.CanCastOnMagicImmune( botTarget )	
			and not J.IsDisabled( botTarget )
		then			
			hCastTarget = botTarget
			sCastMotive = 'W-攻击'..J.Chat.GetNormName( hCastTarget )
			return BOT_ACTION_DESIRE_HIGH, hCastTarget, sCastMotive
		end
	end
	
	
	--团战AOE
	if J.IsInTeamFight( bot, 1000 )
	then
		local nAoeCount = 0
		for _, npcEnemy in pairs( nInBonusEnemyList )
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
			sCastMotive = 'W-团战AOE'..nAoeCount
			return BOT_ACTION_DESIRE_HIGH, hCastTarget, sCastMotive
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
				and not J.IsDisabled( npcEnemy )
				and not npcEnemy:IsDisarmed()
			then
				hCastTarget = npcEnemy
				sCastMotive = 'W-撤退'..J.Chat.GetNormName( hCastTarget )
				return BOT_ACTION_DESIRE_HIGH, hCastTarget, sCastMotive
			end
		end
	end
	
	
	--带线AOE
	if ( J.IsPushing( bot ) or J.IsDefending( bot ) or J.IsFarming( bot ) )
		and J.IsAllowedToSpam( bot, nManaCost )
		and #hAllyList <= 2
	then
		local laneCreepList = bot:GetNearbyLaneCreeps( nCastRange , true )
		if ( #laneCreepList >= 4 or ( #laneCreepList >= 3 and nMP > 0.82 ) )
			and not laneCreepList[1]:HasModifier( "modifier_fountain_glyph" )
		then
			hCastTarget = creep
			sCastMotive = 'W-带线AOE'..(#laneCreepList)
			return BOT_ACTION_DESIRE_HIGH, hCastTarget, sCastMotive
		end
	end
	
	
	
	--打野AOE
	if J.IsFarming( bot )
		and DotaTime() > 6 * 60
		and J.IsAllowedToSpam( bot, nManaCost )
	then
		local creepList = bot:GetNearbyNeutralCreeps( nRadius )

		if #creepList >= 3
			and J.IsValid( botTarget )
		then
			hCastTarget = botTarget
			sCastMotive = 'W-打野AOE'..(#creepList)
			return BOT_ACTION_DESIRE_HIGH, hCastTarget, sCastMotive
	    end
	end
	
	
	if bot:GetActiveMode() == BOT_MODE_ROSHAN
		and bot:GetMana() >= 400
	then
		local npcTarget = bot:GetAttackTarget()
		if J.IsRoshan( npcTarget )
			and not J.IsDisabled( npcTarget )
			and not npcTarget:IsDisarmed()
			and J.IsInRange( npcTarget, bot, nCastRange )
		then
			hCastTarget = botTarget
			sCastMotive = 'W-打肉山'
			return BOT_ACTION_DESIRE_HIGH, hCastTarget, sCastMotive
		end
	end

	return BOT_ACTION_DESIRE_NONE


end


function X.ConsiderR()


	if not J.CanCastAbility(abilityR) then return 0 end

	local nSkillLV = abilityR:GetLevel()
	local nCastRange = abilityR:GetCastRange()
	local nRadius = 600
	local nCastPoint = abilityR:GetCastPoint()
	local nManaCost = abilityR:GetManaCost()
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
			and J.IsInRange( botTarget, bot, nCastRange )
			and J.CanCastOnNonMagicImmune( botTarget )			
			and J.CanCastOnTargetAdvanced( botTarget )
			and not botTarget:HasModifier( 'modifier_slardar_amplify_damage' )
		then			
			hCastTarget = botTarget
			sCastMotive = 'R-攻击:'..J.Chat.GetNormName( hCastTarget )
			return BOT_ACTION_DESIRE_HIGH, hCastTarget, sCastMotive
		end
	end
	
	
	--团战中对护甲最低的敌人使用
	if J.IsInTeamFight( bot, 1200 )
	then
		local npcWeakestEnemy = nil
		local npcWeakestEnemyHealth = 100000

		for _, npcEnemy in pairs( nInBonusEnemyList )
		do
			if J.IsValid( npcEnemy )
				and not npcEnemy:HasModifier( 'modifier_slardar_amplify_damage' )
				and J.CanCastOnNonMagicImmune( npcEnemy )
				and J.CanCastOnTargetAdvanced( npcEnemy )
			then
				local npcEnemyHealth = npcEnemy:GetArmor()
				if ( npcEnemyHealth < npcWeakestEnemyHealth )
				then
					npcWeakestEnemyHealth = npcEnemyHealth
					npcWeakestEnemy = npcEnemy
				end
			end
		end

		if npcWeakestEnemy ~= nil
		then
			hCastTarget = npcWeakestEnemy
			sCastMotive = 'R-团战'..J.Chat.GetNormName( hCastTarget )
			return BOT_ACTION_DESIRE_HIGH, hCastTarget, sCastMotive
		end
	end
	
	
	--打野时
	if J.IsFarming( bot )
		and nSkillLV >= 2
		and J.IsAllowedToSpam( bot, nManaCost )
	then		

		local targetCreep = bot:GetAttackTarget()
		if J.IsValid( targetCreep )
			and J.IsInRange( bot, targetCreep, nCastRange )
			and not targetCreep:HasModifier( 'modifier_slardar_amplify_damage' )
			and not J.CanKillTarget( targetCreep, bot:GetAttackDamage() * 3, DAMAGE_TYPE_PHYSICAL )
		then
			hCastTarget = targetCreep
			sCastMotive = 'R-打野'
			return BOT_ACTION_DESIRE_HIGH, hCastTarget, sCastMotive
	    end
	end
	
	
	--打肉 
	if bot:GetActiveMode() == BOT_MODE_ROSHAN
	then
		if J.IsRoshan( botTarget )
			and J.IsInRange( botTarget, bot, nCastRange )
			and not botTarget:HasModifier( 'modifier_slardar_amplify_damage' )
		then
			hCastTarget = botTarget
			sCastMotive = 'R-肉山'
			return BOT_ACTION_DESIRE_HIGH, hCastTarget, sCastMotive
		end
	end
	
	
	--通用标记敌人
	if nLV >= 12
		and ( bot:GetActiveMode() ~= BOT_MODE_RETREAT or #hAllyList >= 3 )
		and #nInRangeEnemyList >= 1
	then
		for _, npcEnemy in pairs( nInRangeEnemyList )
		do
			if J.IsValid( npcEnemy )
				and not npcEnemy:HasModifier( 'modifier_slardar_amplify_damage' )
				and J.CanCastOnNonMagicImmune( npcEnemy )
				and J.CanCastOnTargetAdvanced( npcEnemy )
			then
				hCastTarget = npcEnemy
				sCastMotive = 'R-标记'
				return BOT_ACTION_DESIRE_HIGH, hCastTarget, sCastMotive
			end
		end
	end


	return BOT_ACTION_DESIRE_NONE


end


return X

