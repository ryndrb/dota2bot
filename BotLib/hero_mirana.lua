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
					['t25'] = {0, 10},
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
				"item_force_staff",--
				"item_boots_of_bearing",--
				"item_pipe",--
				"item_sheepstick",--
				"item_gungir",--
				"item_wind_waker",--
				"item_aghanims_shard",
				"item_ultimate_scepter_2",
				"item_moon_shard",
			},
            ['sell_list'] = {
				"item_circlet",
				"item_magic_wand",
			},
        },
    },
    ['pos_5'] = {
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
				"item_guardian_greaves",--
				"item_force_staff",--
				"item_pipe",--
				"item_sheepstick",--
				"item_gungir",--
				"item_wind_waker",--
				"item_aghanims_shard",
				"item_ultimate_scepter_2",
				"item_moon_shard",
			},
            ['sell_list'] = {
				"item_circlet",
				"item_magic_wand",
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

local abilityQ = bot:GetAbilityByName('mirana_starfall')
local abilityW = bot:GetAbilityByName('mirana_arrow')
local abilityE = bot:GetAbilityByName('mirana_leap')
local abilityR = bot:GetAbilityByName('mirana_invis')


local castQDesire, castQTarget
local castWDesire, castWTarget
local castEDesire, castETarget
local castRDesire, castRTarget


local nKeepMana,nMP,nHP,nLV,hEnemyList,hAllyList,botTarget,sMotive;
local aetherRange = 0


function X.SkillsComplement()
	
	if J.CanNotUseAbility(bot) then return end

	abilityQ = bot:GetAbilityByName('mirana_starfall')
	abilityW = bot:GetAbilityByName('mirana_arrow')
	abilityE = bot:GetAbilityByName('mirana_leap')
	abilityR = bot:GetAbilityByName('mirana_invis')
	
	nKeepMana = 400
	aetherRange = 0
	nLV = bot:GetLevel();
	nMP = bot:GetMana()/bot:GetMaxMana();
	nHP = bot:GetHealth()/bot:GetMaxHealth();
	botTarget = J.GetProperTarget(bot);
	hEnemyList = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE);
	hAllyList = J.GetAlliesNearLoc(bot:GetLocation(), 1600);
	
	local aether = J.IsItemAvailable("item_aether_lens");
	if aether ~= nil then aetherRange = 250 end	
	
	
	castQDesire, castQTarget, sMotive = X.ConsiderQ();
	if ( castQDesire > 0 ) 
	then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbility( abilityQ )
		return;
	end
	
	castWDesire, castWTarget, sMotive = X.ConsiderW();
	if ( castWDesire > 0 ) 
	then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbilityOnLocation( abilityW, castWTarget )
		return;
	end
	
	castEDesire, castETarget, sMotive = X.ConsiderE();
	if ( castEDesire > 0 ) 
	then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbility( abilityE )
		return;
	end
	
	castRDesire, castRTarget, sMotive = X.ConsiderR();
	if ( castRDesire > 0 ) 
	then
		J.SetQueuePtToINT(bot, false)
		bot:ActionQueue_UseAbility( abilityR )
		return;
	
	end

end


function X.ConsiderQ()


	if not J.CanCastAbility(abilityQ) then return 0 end

	local nSkillLV = abilityQ:GetLevel()
	local nCastRange = abilityQ:GetSpecialValueInt( "starfall_radius" )
	local nRadius = abilityQ:GetSpecialValueInt( "starfall_secondary_radius" )
	local nCastPoint = abilityQ:GetCastPoint()
	local nManaCost = abilityQ:GetManaCost()
	local nDamage = abilityQ:GetAbilityDamage()
	local nDamageType = DAMAGE_TYPE_MAGICAL
	local nInRangeEnemyList = J.GetAroundEnemyHeroList( nRadius )
	local nInBonusEnemyList = J.GetAroundEnemyHeroList( nCastRange )
	local hCastTarget = nil
	local sCastMotive = nil
	
	
	--击杀敌人
	for _, npcEnemy in pairs( nInBonusEnemyList )
	do 
		if J.IsValid( npcEnemy )
			and J.CanCastOnNonMagicImmune( npcEnemy )
			and J.WillMagicKillTarget( bot, npcEnemy, nDamage , nCastPoint )
		then
			hCastTarget = npcEnemy
			sCastMotive = 'Q-击杀:'..J.Chat.GetNormName( hCastTarget )
			return BOT_ACTION_DESIRE_HIGH, hCastTarget, sCastMotive
		end	
	end
	
	
	--打架先手
	if J.IsGoingOnSomeone( bot )
	then
		if J.IsValidHero( botTarget )
			and J.IsInRange( bot, botTarget, nCastRange )
			and J.CanCastOnNonMagicImmune( botTarget )			
			and ( #nInRangeEnemyList >= 1 
					or #nInBonusEnemyList >= 2
					or nHP < 0.4 )
		then			
			hCastTarget = botTarget
			sCastMotive = 'Q-攻击:'..J.Chat.GetNormName( hCastTarget )
			return BOT_ACTION_DESIRE_HIGH, hCastTarget, sCastMotive
		end
	end
	
	
	--撤退时保护自己
	if J.IsRetreating( bot )
		and bot:WasRecentlyDamagedByAnyHero( 3.0 )
		and ( #nInRangeEnemyList >= 1 or nHP < 0.6 )
	then
		for _, npcEnemy in pairs( nInBonusEnemyList )
		do
			if J.IsValid( npcEnemy )
				and J.CanCastOnNonMagicImmune( npcEnemy )				
			then
				hCastTarget = npcEnemy
				sCastMotive = 'Q-撤退'..J.Chat.GetNormName( hCastTarget )
				return BOT_ACTION_DESIRE_HIGH, hCastTarget, sCastMotive
			end
		end
	end
	
	
	--对线期间补刀
	if bot:GetActiveMode() == BOT_MODE_LANING or ( nLV <= 7 and #hAllyList <= 2 )
	then
		local nCanKillMeleeCount = 0
		local nCanKillRangedCount = 0
		local hLaneCreepList = bot:GetNearbyLaneCreeps( nCastRange, true )
		for _, creep in pairs( hLaneCreepList )
		do
			if J.IsValid( creep )
				and not creep:HasModifier( "modifier_fountain_glyph" )
				and not J.IsOtherAllysTarget( creep )
			then
				local lastHitDamage = nDamage
								
				if J.WillKillTarget( creep, lastHitDamage, nDamageType, nCastPoint + 0.57 )
				then
					if J.IsKeyWordUnit( 'ranged', creep )
					then
						nCanKillRangedCount = nCanKillRangedCount + 1
					end

					if J.IsKeyWordUnit( 'melee', creep )
					then
						nCanKillMeleeCount = nCanKillMeleeCount + 1
					end

				end
			end
		end

		if nCanKillMeleeCount + nCanKillRangedCount >= 3
		then
			hCastTarget = bot
			sCastMotive = 'Q对线1'
			return BOT_ACTION_DESIRE_HIGH, hCastTarget, sCastMotive
		end

		if nCanKillRangedCount >= 1 and nCanKillMeleeCount >= 1
		then
			hCastTarget = bot
			sCastMotive = 'Q对线2'
			return BOT_ACTION_DESIRE_HIGH, hCastTarget, sCastMotive
		end

		if #hLaneCreepList == 0
			and #nInRangeEnemyList >= 1
			and nMP > 0.5
		then
			hCastTarget = nInRangeEnemyList[1]
			sCastMotive = 'Q对线消耗:'..J.Chat.GetNormName( hCastTarget )
			return BOT_ACTION_DESIRE_HIGH, hCastTarget, sCastMotive
		end
	end
	
	
	--带线
	if ( J.IsPushing( bot ) or J.IsDefending( bot ) or J.IsFarming( bot ) )
		and J.IsAllowedToSpam( bot, nManaCost * 0.32 )
		and #hAllyList <= 3 and #hEnemyList == 0
	then
		local laneCreepList = bot:GetNearbyLaneCreeps( nCastRange - 50, true )
		
		if J.IsValid( laneCreepList[1] )
			and not laneCreepList[1]:HasModifier( "modifier_fountain_glyph" )
			and ( #laneCreepList >= 5 or ( nMP > 0.88 and #laneCreepList >= 4 ) )
		then
			hCastTarget = creep
			sCastMotive = 'Q-带线'
			return BOT_ACTION_DESIRE_HIGH, hCastTarget, sCastMotive
		end
		
	end
	
	
	--打野
	if J.IsFarming( bot )
		and DotaTime() > 8 * 60
		and J.IsAllowedToSpam( bot, nManaCost )
	then
		local creepList = bot:GetNearbyNeutralCreeps( nRadius )

		if #creepList >= 3
			and J.IsValid( botTarget )
			and botTarget:GetMagicResist() < 0.51
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
	local nCastRange = abilityW:GetSpecialValueInt( 'arrow_range' )
	local nRadius = abilityW:GetSpecialValueInt( 'arrow_width' )
	local nSpeed = abilityW:GetSpecialValueInt( 'arrow_speed' )
	local nCastPoint = abilityW:GetCastPoint()
	local nManaCost = abilityW:GetManaCost()
	local nDamage = 0
	local nDamageType = DAMAGE_TYPE_MAGICAL
	
	local nCanSeenEnemyHeroList = GetUnitList( UNIT_LIST_ENEMY_HEROES )
	
	local hCastTarget = nil
	local sCastMotive = nil
	
	
	
	for _, npcEnemy in pairs( nCanSeenEnemyHeroList )
	do
		if J.IsValidHero(npcEnemy)
		and J.IsInRange( bot, npcEnemy, nCastRange )
			and not J.IsInRange( bot, npcEnemy, 80 )
			and J.CanCastOnNonMagicImmune( npcEnemy )
			and not J.IsOtherAllyCanKillTarget( bot, npcEnemy )
		then
			--打断TP
			if npcEnemy:HasModifier( 'modifier_teleporting' )
				and not X.IsEnemyCreepBetweenEnemyHero( bot, npcEnemy, nRadius )
			then
				hCastTarget = npcEnemy
				sCastMotive = 'W-射箭打断:'..J.Chat.GetNormName( hCastTarget )
				return BOT_ACTION_DESIRE_HIGH, hCastTarget:GetLocation(), sCastMotive			
			end
			
			
			--辅助眩晕
			-- if npcEnemy:IsStunned()
			-- then
				-- local nDistance = GetUnitToUnitDistance( bot, npcEnemy )
				-- local nDelay = nCastPoint + ( nDistance - 50 ) / nSpeed
				-- if J.GetRemainStunTime( npcEnemy ) > nDelay * 0.666
				   -- or J.GetRemainStunTime( npcEnemy ) > 1.4
				-- then
					-- hCastTarget = npcEnemy
					-- sCastMotive = 'W-辅助眩晕:'..J.Chat.GetNormName( hCastTarget )
					-- return BOT_ACTION_DESIRE_HIGH, hCastTarget:GetLocation(), sCastMotive		
				-- end
			-- end
			--辅助控制
			if J.IsDisabled( npcEnemy )
				and not X.IsEnemyCreepBetweenEnemyHero( bot, npcEnemy, nRadius )
			then
				hCastTarget = npcEnemy
				sCastMotive = 'W-辅助控制:'..J.Chat.GetNormName( hCastTarget )
				return BOT_ACTION_DESIRE_HIGH, hCastTarget:GetLocation(), sCastMotive				
			end
					
		end
	end
	
	
	--打野
	if J.IsFarming( bot )
		and DotaTime() > 4 * 60
		and nLV <= 22
		and J.IsAllowedToSpam( bot, nManaCost )
	then
		local creepList = bot:GetNearbyNeutralCreeps( 1600 )

		local targetCreep = J.GetMostHpUnit( creepList )

		if J.IsValid( targetCreep )
			and targetCreep:GetHealth() > 920
			and not targetCreep:IsAncientCreep()
			and not J.IsOtherAllysTarget( targetCreep )
		then
			hCastTarget = targetCreep
			sCastMotive = 'W-打野'
			return BOT_ACTION_DESIRE_HIGH, hCastTarget:GetLocation(), sCastMotive
		end
	end
	

	--肉山
	if J.IsDoingRoshan( bot )
	then
		if J.IsRoshan( botTarget )
			and J.IsInRange( bot, botTarget, nCastRange )
			and not J.IsInRange( bot, botTarget, 300 )
		then
			hCastTarget = botTarget
			sCastMotive = 'W-肉山'
			return BOT_ACTION_DESIRE_HIGH, hCastTarget:GetLocation(), sCastMotive
		end
	end


	return BOT_ACTION_DESIRE_NONE


end


function X.ConsiderE()


	if not J.CanCastAbility(abilityE)
		or bot:IsRooted()
	then return 0 end

	local nSkillLV = abilityE:GetLevel()
	local nCastRange = abilityE:GetSpecialValueInt( "leap_distance" )
	local nRadius = bot:GetAttackRange()
	local nCastPoint = abilityE:GetCastPoint()
	local nManaCost = abilityE:GetManaCost()
	local nDamage = 0
	local nDamageType = DAMAGE_TYPE_MAGICAL
	local nInRangeEnemyList = J.GetAroundEnemyHeroList( 800 )
	local nInBonusEnemyList = J.GetAroundEnemyHeroList( 1200 )
	local hCastTarget = nil
	local sCastMotive = nil

	
	--攻击敌人
	if J.IsGoingOnSomeone( bot ) 
		and not bot:HasModifier( 'modifier_mirana_leap_buff' )
	then
		if J.IsValidHero( botTarget )
			and J.IsInRange( bot, botTarget, nCastRange + nRadius + 100 )
			and not J.IsInRange( bot, botTarget, nCastRange - 30 )
			and not botTarget:IsAttackImmune()
			and J.CanCastOnMagicImmune( botTarget )
			and bot:IsFacingLocation( botTarget:GetLocation(), 6 )
		then
			local enemyList = botTarget:GetNearbyHeroes( 900, false, BOT_MODE_NONE )
			local allyList = botTarget:GetNearbyHeroes( 1300, true, BOT_MODE_NONE )
			local aliveEnemyCount = J.GetNumOfAliveHeroes( true )
			
			if aliveEnemyCount <= 2
				or #enemyList <= 1
				or #enemyList <= #allyList
				or J.WillKillTarget( botTarget, bot:GetAttackDamage() * 3, DAMAGE_TYPE_PHYSICAL, 2.0 )
			then
			
				hCastTarget = botTarget
				sCastMotive = 'E-进攻:'..J.Chat.GetNormName( hCastTarget )
				return BOT_ACTION_DESIRE_HIGH, hCastTarget, sCastMotive
				
			end		
	
		end
	end
	
	
	
	--被卡住了
	if J.IsStuck( bot )
	then
		hCastTarget = bot
		sCastMotive = 'E-被卡住'
		return BOT_ACTION_DESIRE_HIGH, hCastTarget, sCastMotive
	end	
	
	
	
	--撤退时保护自己
	if J.IsRetreating( bot ) 
		and bot:WasRecentlyDamagedByAnyHero( 3.0 )
	then
		for _, npcEnemy in pairs( nInRangeEnemyList )
		do
			if J.IsValid( npcEnemy )
				and not J.IsDisabled( npcEnemy )
				and not bot:IsFacingLocation( npcEnemy:GetLocation(), 155 )
			then
				hCastTarget = npcEnemy
				sCastMotive = 'E-逃跑:'..J.Chat.GetNormName( hCastTarget )
				return BOT_ACTION_DESIRE_HIGH, hCastTarget, sCastMotive			
			end
		end
	end
	
	
	--打钱赶路
	if J.IsFarming( bot ) 
		and nLV >= 12
		and not bot:HasModifier( 'modifier_mirana_leap_buff' )
	then
	
		if botTarget ~= nil 
			and botTarget:IsAlive()
			and J.IsInRange( bot, botTarget, nCastRange + nRadius + 400 )
			and not J.IsInRange( bot, botTarget, 1080 )
			and bot:IsFacingLocation( botTarget:GetLocation(), 6 )			
		then
			hCastTarget = botTarget:GetLocation()
			sCastMotive = 'E-打钱赶路'
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
	local nDamage = abilityR:GetSpecialValueInt( 'dam' )
	local nDamageType = DAMAGE_TYPE_MAGICAL
	local nInRangeEnemyList = J.GetAroundEnemyHeroList( nCastRange )
	local nInBonusEnemyList = J.GetAroundEnemyHeroList( nCastRange + 200 )
	local hCastTarget = nil
	local sCastMotive = nil

	
	
	for i = 1, 5
	do 
		local npcAlly = GetTeamMember( i )
		if npcAlly ~= nil
			and npcAlly:IsAlive()
			and not npcAlly:IsInvisible()
		then
			
			--为潜行准备进攻的队友们提供隐身
			if J.IsGoingOnSomeone( npcAlly ) 
			then
				local allyTarget = J.GetProperTarget( npcAlly )
				if J.IsValidHero( allyTarget )
					and not J.IsInRange( npcAlly, allyTarget, 1600 )
					and J.IsInRange( npcAlly, allyTarget, 2800 )
				then
					local nearAllyList = J.GetAlliesNearLoc( npcAlly:GetLocation(), 1000 )
					if #nearAllyList >= 2
					then
						hCastTarget = npcAlly
						sCastMotive = 'R-潜行准备进攻的队友:'..J.Chat.GetNormName( hCastTarget )
						return BOT_ACTION_DESIRE_HIGH, hCastTarget, sCastMotive
					end					
				end			
			end
			
			
			--为撤退的队友隐身
			if J.IsRetreating( npcAlly )
			then
				local enemyList = npcAlly:GetNearbyHeroes( 900, true, BOT_MODE_NONE )
				for _, npcEnemy in pairs( enemyList )
				do 
					if npcAlly:WasRecentlyDamagedByHero( npcEnemy, 3.0 )
					then
						hCastTarget = npcAlly
						sCastMotive = 'R-隐身撤退的队友:'..J.Chat.GetNormName( hCastTarget )
						return BOT_ACTION_DESIRE_HIGH, hCastTarget, sCastMotive
					end
				end
			end
		end	
	end


	return BOT_ACTION_DESIRE_NONE


end


function X.IsEnemyCreepBetweenEnemyHero( hSource, hTarget, nRadius )
	
	local vStart = hSource:GetLocation()
	local vEnd = hTarget:GetLocation()
	local creeps = hSource:GetNearbyLaneCreeps(1600, true)
	for i,creep in pairs(creeps) 
	do
		local tResult = PointToLineDistance(vStart, vEnd, creep:GetLocation())
		if tResult ~= nil 
			and tResult.within 
			and tResult.distance <= nRadius + 20 
		then
			return true
		end
	end
	
	creeps = hTarget:GetNearbyLaneCreeps(1600, false)
	for i,creep in pairs(creeps) 
	do
		local tResult = PointToLineDistance(vStart, vEnd, creep:GetLocation());
		if tResult ~= nil 
			and tResult.within 
			and tResult.distance <= nRadius + 20 
		then
			return true
		end
	end
	
	return false
	
end

return X