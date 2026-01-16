local X = {}
local bot = GetBot()
local bDebugMode = ( 1 == 10 )

if bot:IsInvulnerable() or not bot:IsHero() or bot:IsIllusion()
then return end

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local BotBuild = dofile( GetScriptDirectory().."/BotLib/"..string.gsub( bot:GetUnitName(), "npc_dota_", "" ) )

if BotBuild == nil then return end

if GetTeam() ~= TEAM_DIRE
then
	print( '&&&&&&&&&&&&&&&&&&&&&&'..J.Chat.GetNormName( bot )..': Hello, Dota2 World!' )
end

local bDeafaultAbilityHero = BotBuild['bDeafaultAbility']
local bDeafaultItemHero = BotBuild['bDeafaultItem']
local sAbilityLevelUpList = BotBuild['sSkillList']

local bRefreshMorphlingBuild = false
local refreshList = false

local function AbilityLevelUpComplement()

	if GetGameState() ~= GAME_STATE_PRE_GAME and GetGameState() ~= GAME_STATE_GAME_IN_PROGRESS then
		return
	end

	-- wait for changes, if set (buff)
	if bot:GetUnitName() == 'npc_dota_hero_morphling' then
		if J.IsModeTurbo() and DotaTime() < -50 or DotaTime() < -80 then
			return
		end
	end

	if not bRefreshMorphlingBuild then
		if bot:GetUnitName() == 'npc_dota_hero_morphling' then
			BotBuild = dofile( GetScriptDirectory().."/BotLib/"..string.gsub( bot:GetUnitName(), "npc_dota_", "" ) )
			BotBuild.SetAbilityBuild()
			sAbilityLevelUpList = BotBuild['sSkillList']
			bRefreshMorphlingBuild = true
			return
		end
	end

	if (bot:GetLevel() >= 30 and bot:GetUnitName() == "npc_dota_hero_bloodseeker")
	or (bot:HasModifier('modifier_dazzle_nothl_projection_soul_debuff'))
	or (bot:HasModifier('modifier_life_stealer_infest'))
	then
		return
	end

	if DotaTime() < 15
	then
		bot.theRole = J.Role.GetCurrentSuitableRole( bot, bot:GetUnitName() )
	end

	local botLoc = bot:GetLocation()
	if bot:IsAlive()
		and DotaTime() > 90
		and bot:GetCurrentActionType() == BOT_ACTION_TYPE_MOVE_TO
		and not IsLocationPassable( botLoc )
	then
		if bot.stuckLoc == nil
		then
			bot.stuckLoc = botLoc
			bot.stuckTime = DotaTime()
		elseif bot.stuckLoc ~= botLoc
		then
			bot.stuckLoc = botLoc
			bot.stuckTime = DotaTime()
		end
	else
		bot.stuckTime = nil
		bot.stuckLoc = nil
	end

	-- fix level up list for these two
	local botName = bot:GetUnitName()
	if not refreshList then
		local hasAbility = J.HasAbility(bot, 'faceless_void_chronosphere')
		if botName == 'npc_dota_hero_faceless_void' and hasAbility then
			for i = 1, #sAbilityLevelUpList do
				if sAbilityLevelUpList[i] and sAbilityLevelUpList[i].name == 'generic_hidden' then
					sAbilityLevelUpList[i].name = 'faceless_void_chronosphere'
				end
			end
			refreshList = true
		end
		hasAbility = J.HasAbility(bot, 'life_stealer_rage')
		if botName == 'npc_dota_hero_life_stealer' and hasAbility then
			for i = 1, #sAbilityLevelUpList do
				if sAbilityLevelUpList[i] and sAbilityLevelUpList[i].name == 'generic_hidden' then
					sAbilityLevelUpList[i].name = 'life_stealer_rage'
				end
			end
			refreshList = true
		end
	end

	local botLevel = bot:GetLevel()

	if #sAbilityLevelUpList >= 1 then
		if botName == 'npc_dota_hero_kez' then
			local abilitySwapMap = {
				kez_echo_slash       = 'kez_falcon_rush',
				kez_falcon_rush      = 'kez_echo_slash',
				kez_grappling_claw   = 'kez_talon_toss',
				kez_talon_toss       = 'kez_grappling_claw',
				kez_kazurai_katana   = 'kez_shodo_sai',
				kez_shodo_sai        = 'kez_kazurai_katana',
				kez_raptor_dance     = 'kez_ravens_veil',
				kez_ravens_veil      = 'kez_raptor_dance',
			}
		
			for i = 1, #sAbilityLevelUpList do
				local entry = sAbilityLevelUpList[i]
				if entry ~= nil and entry.name ~= nil then
					local hAbility = bot:GetAbilityByName(entry.name)
					if hAbility and hAbility:IsHidden() then
						local swap = abilitySwapMap[entry.name]
						if swap ~= nil then
							entry.name = swap
						end
					end
				end
			end
		end

		-- due to changing spells with vscript
		if DotaTime() < -30 then
			for i = 1, #sAbilityLevelUpList do
				if sAbilityLevelUpList[i].name ~= nil then
					if botName == 'npc_dota_hero_faceless_void' then
						if bot:GetAbilityByName('faceless_void_chronosphere') ~= nil then
							if sAbilityLevelUpList[i].name == 'faceless_void_time_zone' then
								sAbilityLevelUpList[i].name = 'faceless_void_chronosphere'
							end
						end
					elseif botName == 'npc_dota_hero_disruptor' then
						if bot:GetAbilityByName('disruptor_kinetic_field') ~= nil then
							if sAbilityLevelUpList[i].name == 'disruptor_kinetic_fence' then
								sAbilityLevelUpList[i].name = 'disruptor_kinetic_field'
							end
						end
					elseif botName == 'npc_dota_hero_keeper_of_the_light' then
						if bot:GetAbilityByName('keeper_of_the_light_radiant_bind') ~= nil then
							if sAbilityLevelUpList[i].name == 'keeper_of_the_light_recall' then
								sAbilityLevelUpList[i].name = 'keeper_of_the_light_radiant_bind'
							end
						end
					elseif botName == 'npc_dota_hero_tusk' then
						if bot:GetAbilityByName('tusk_tag_team') ~= nil then
							if sAbilityLevelUpList[i].name == 'tusk_drinking_buddies' then
								sAbilityLevelUpList[i].name = 'tusk_tag_team'
							end
						end
					end
				end
			end
		end
	end

	-- 7.40+ "broke" points distribution for most, annoying
	if bot:GetAbilityPoints() > 0 and #sAbilityLevelUpList >= 1 then
		for i = 1, botLevel do
			if sAbilityLevelUpList[i] and sAbilityLevelUpList[i].done == false then
				if sAbilityLevelUpList[i].name == nil then
					sAbilityLevelUpList[i].done = true
				else
					local sAbilityName = sAbilityLevelUpList[i].name
					local hAbility = bot:GetAbilityByName(sAbilityName)

					if hAbility and hAbility:IsHidden() then
						if sAbilityName == 'tiny_tree_grab' then
							sAbilityName = 'tiny_toss_tree'
							hAbility = bot:GetAbilityByName(sAbilityName)
						elseif sAbilityName == 'grimstroke_spirit_walk' then
							sAbilityName = 'grimstroke_return'
							hAbility = bot:GetAbilityByName(sAbilityName)
						elseif sAbilityName == 'alchemist_unstable_concoction' then
							sAbilityName = 'alchemist_unstable_concoction_throw'
							hAbility = bot:GetAbilityByName(sAbilityName)
						end
					end

					if hAbility ~= nil
					and not hAbility:IsHidden()
					and hAbility:CanAbilityBeUpgraded()
					and hAbility:GetLevel() < hAbility:GetMaxLevel()
					then
						bot:ActionImmediate_LevelAbility(sAbilityName)
						sAbilityLevelUpList[i].done = true
					end
				end
			end
		end
	end
end

function X.GetNumEnemyNearby( building )

	local nearbynum = 0
	for i, id in pairs( GetTeamPlayers( GetOpposingTeam() ) )
	do
		if IsHeroAlive( id )
		then
			local info = GetHeroLastSeenInfo( id )
			if info ~= nil
			then
				local dInfo = info[1]
				if dInfo ~= nil
					and GetUnitToLocationDistance( building, dInfo.location ) <= 3000
					and dInfo.time_since_seen < 1.0
				then
					nearbynum = nearbynum + 1
				end
			end
		end
	end

	return nearbynum

end

local fDeathTime = 0
function X.GetRemainingRespawnTime()

	if fDeathTime == 0
	then
		return 0
	else
		return bot:GetRespawnTime() - ( DotaTime() - fDeathTime )
	end

end

local nJiDiCount = RandomInt( 14, 20 )
local nTalkDelay = RandomInt( 19, 56 )/10
local nDeathReplyTime = -999
local nLastGold = 9999
local nLastKillCount = 999
local nLastDeathCount = 0
local nContinueKillCount = 0
local nReplyHumanCount = 0
local nMaxReplyCount = RandomInt( 5, 9 )
local bInstallChatCallbackDone = false
local nReplyHumanTime = nil
local sHumanString = nil
local bAllChat = false
function X.SetTalkMessage()

	local nBotID = bot:GetPlayerID()
	local nCurrentGold = bot:GetGold()
	local nCurrentKills = GetHeroKills( nBotID )
	local nCurrentDeaths = GetHeroDeaths( nBotID )
	local nRate = GetGameMode() == 23 and 2.0 or 1.0

	--回复玩家的对话
	if nBotID == J.Role.GetReplyMemberID()
		and nReplyHumanCount <= nMaxReplyCount
	then
		if not bInstallChatCallbackDone
		then
			bInstallChatCallbackDone = true
			--print(bot:GetUnitName())
			InstallChatCallback( function( tChat ) X.SetReplyHumanTime( tChat ) end )
		end

		if sHumanString ~= nil
			and nReplyHumanTime ~= nil
			and DotaTime() > nReplyHumanTime + nTalkDelay
		then
			local chatString = J.Chat.GetReplyString( sHumanString, bAllChat )
			if chatString ~= nil
			then
				if nReplyHumanCount == nMaxReplyCount
				then chatString = J.Chat.GetStopReplyString() end

				bot:ActionImmediate_Chat( chatString, bAllChat )

				nReplyHumanCount = nReplyHumanCount + 1
				nTalkDelay = RandomInt( 6, 30 )/10
				if nTalkDelay > 2.0 then nTalkDelay = RandomInt( 6, 30 )/10 end
			end
			sHumanString = nil
			nReplyHumanTime = nil
		end
	end

	--发问号
	if bot:IsAlive()
		and nCurrentGold > nLastGold + 600 * nRate
		and nCurrentKills > nLastKillCount
		and RandomInt( 1, 9 ) > 4
	then
		local sTauntMark = "?"
		if nCurrentGold > nLastGold + 800 * nRate then sTauntMark = "??" end
		if nCurrentGold > nLastGold + 1000 * nRate then sTauntMark = "???" end
		if nCurrentGold > nLastGold + 1500 * nRate then sTauntMark = "??????" end
		bot:ActionImmediate_Chat( sTauntMark, true )
	end

	--发省略号
	if not bot:IsAlive()
	then
		if nContinueKillCount >= 8
			and nDeathReplyTime == -999
		then
			nDeathReplyTime = DotaTime()
			nContinueKillCount = 0
		end

		if nDeathReplyTime ~= -999
			and nDeathReplyTime < DotaTime() - nTalkDelay
		then
			bot:ActionImmediate_Chat( "...", true )
			nDeathReplyTime = -999
			nTalkDelay = RandomInt( 36, 49 )/10
		end
	end

	--发"jidi, xiayiba"
	if nCurrentKills == 0
		and nCurrentDeaths >= nJiDiCount
		and J.Role.NotSayJiDi()
	then
		local sJiDi = RandomInt( 1, 9 ) >= 3 and "jidi, xiayiba" or "jidi, gkd"
		bot:ActionImmediate_Chat( sJiDi, true )
		J.Role['sayJiDi'] = true
	end

	--计算连杀数量
	if nLastDeathCount == nCurrentDeaths
	then
		if nCurrentKills >= nLastKillCount + 1
		then
			nContinueKillCount = nContinueKillCount + 1
		end
	else
		nContinueKillCount = 0
	end

	nLastKillCount = GetHeroKills( nBotID )
	nLastDeathCount = GetHeroDeaths( nBotID )
	nLastGold = bot:GetGold()

end


function X.SetReplyHumanTime( tChat )

	local sChatString = tChat.string
	local nChatID = tChat.player_id

	if sChatString ~= "-都来守家" or J.Role.IsAllyMemberID( nChatID )
	then
		J.Role.SetLastChatString( sChatString )
	end
		
	if not IsPlayerBot( nChatID )
		and ( tChat.team_only or J.Role.IsEnemyMemberID( nChatID ) )
	then
		sHumanString = sChatString
		nReplyHumanTime = DotaTime()
		bAllChat = not tChat.team_only
	end


end


local function BuybackUsageComplement()

	X.SetTalkMessage()

	if bot:GetLevel() <= 15
		or bot:HasModifier( 'modifier_arc_warden_tempest_double' )
		or J.IsMeepoClone(bot)
		or not J.Role.ShouldBuyBack()
		or bot:IsIllusion()
	then
		return
	end

	local bCore = J.IsCore(bot)

	if bot:IsAlive() and fDeathTime ~= 0
	then
		fDeathTime = 0
	end

	if not bot:IsAlive()
	then
		if fDeathTime == 0 then fDeathTime = DotaTime() end
	end

	if not bot:HasBuyback() then return end

	-- if bot:GetRespawnTime() < 60 then
	-- 	return
	-- end

	local nRespawnTime = X.GetRemainingRespawnTime()

	if bot:GetLevel() > 24
		and nRespawnTime > 80
	then
		local nTeamFightLocation = J.GetTeamFightLocation( bot )
		if nTeamFightLocation ~= nil and J.GetDistance(J.GetTeamFountain(), nTeamFightLocation) < 3200
		then
			J.Role['lastbbtime'] = DotaTime()
			bot:ActionImmediate_Buyback()
			return
		end
	end

	local ancient = GetAncient( GetTeam() )

	if ancient then
		if nRespawnTime < 50 and nRespawnTime > 15 then
			local nInRangeEnemy = J.GetEnemiesNearLoc(ancient:GetLocation(), 3000)
			for _, enemy in pairs(nInRangeEnemy) do
				if J.IsValidHero(enemy)
				and J.IsCore(enemy)
				then
					local enemyAttackTarget = enemy:GetAttackTarget()
					if J.IsValid(enemyAttackTarget)
					and (enemyAttackTarget:IsBuilding() or enemyAttackTarget == ancient)
					then
						J.Role['lastbbtime'] = DotaTime()
						bot:ActionImmediate_Buyback()
						return
					end
				end
			end
		end
	end

	-- if nRespawnTime < 50
	-- then
	-- 	return
	-- end

	if ancient ~= nil and nRespawnTime > 15
	then
		local nEnemyCount = X.GetNumEnemyNearby( ancient )
		local nAllyCount = J.GetNumOfAliveHeroes( false )
		if nEnemyCount > 0 and ((not bCore and nEnemyCount >= nAllyCount) or (bCore and nAllyCount + 1 >= nEnemyCount and not (nAllyCount + 1 >= nEnemyCount + 2)))
		then
			J.Role['lastbbtime'] = DotaTime()
			bot:ActionImmediate_Buyback()
			return
		end
	end

end


local courierTime = -90
local cState = -1
bot.SShopUser = false
local nReturnTime = -90
local function CourierUsageComplement()

	if DotaTime() < -56
	or bot:HasModifier( "modifier_arc_warden_tempest_double" )
	or nReturnTime + 5.0 > DotaTime()
	then
		return
	end

	if bot.theCourier == nil
	then
		bot.theCourier = X.GetBotCourier( bot )
		return
	end

	--------* * * * * * * ----------------* * * * * * * ----------------* * * * * * * --------
	local bDebugCourier = ( 1 == 10 )
	local npcCourier = bot.theCourier
	local cState = GetCourierState( npcCourier )
	local courierHP = npcCourier:GetHealth() / npcCourier:GetMaxHealth()
	local currentTime = DotaTime()
	local bAliveBot = bot:IsAlive()
	local botLV = bot:GetLevel()
	local useCourierCD = 2.3
	local protectCourierCD = 5.0
	--------* * * * * * * ----------------* * * * * * * ----------------* * * * * * * --------

	if cState == COURIER_STATE_DEAD then return	end

	if X.IsCourierTargetedByUnit( npcCourier )
	then
		if currentTime > nReturnTime + protectCourierCD
		then
			nReturnTime = currentTime

			J.SetReportMotive( bDebugCourier, "信使可能会被攻击" )

			bot:ActionImmediate_Courier( npcCourier, COURIER_ACTION_RETURN_STASH_ITEMS )

			local abilityBurst = npcCourier:GetAbilityByName( 'courier_burst' )
			if botLV >= 10 and J.CanCastAbility(abilityBurst) then
				bot:ActionImmediate_Courier( npcCourier, COURIER_ACTION_BURST )
			end

			return
		end
	end


	if bot.SShopUser
		and ( not bAliveBot or bot:GetActiveMode() == BOT_MODE_SECRET_SHOP or not bot.SecretShop )
	then
		bot.SShopUser = false
		J.SetReportMotive( bDebugCourier, "让信使返回基地避免被卡住" )
		bot:ActionImmediate_Courier( npcCourier, COURIER_ACTION_RETURN_STASH_ITEMS )
		return
	end


	if ( cState == COURIER_STATE_RETURNING_TO_BASE
		or cState == COURIER_STATE_AT_BASE
		or cState == COURIER_STATE_IDLE )
		and currentTime > nReturnTime + protectCourierCD
	then

		if cState == COURIER_STATE_AT_BASE and courierHP < 0.8 
		then return	end

		if cState == COURIER_STATE_IDLE and npcCourier:DistanceFromFountain() > 800
		then
			J.SetReportMotive( bDebugCourier, "让空闲的信使返回" )
			bot:ActionImmediate_Courier( npcCourier, COURIER_ACTION_RETURN_STASH_ITEMS )
			return
		end

		if bAliveBot
			and ( not X.IsInvFull( bot ) 
					or currentTime <= 5 * 60
					or ( bot.currListItemToBuy ~= nil and #bot.currListItemToBuy == 0 and bot.currentItemToBuy ~= 'item_travel_boots' ) )
			and ( cState == COURIER_STATE_AT_BASE
					or ( cState == COURIER_STATE_IDLE and npcCourier:DistanceFromFountain() < 800 ) )
		then
			local nMSlot = X.GetNumStashItem( bot )
			if nMSlot > 0
			then
				if ( bot.currListItemToBuy ~= nil and #bot.currListItemToBuy == 0 )
					or ( bot.currentComponentToBuy ~= nil
							and ( IsItemPurchasedFromSecretShop( bot.currentComponentToBuy )
									or X.GetNumStashItem( bot ) == 6
									or bot:GetGold() + 80 < GetItemCost( bot.currentComponentToBuy ) ) )
				then
					J.SetReportMotive( bDebugCourier, "信使取出物品并开始运输" )
					bot:ActionImmediate_Courier( npcCourier, COURIER_ACTION_TAKE_STASH_ITEMS )
					courierTime = currentTime
				end
			end
		end

		if bAliveBot and bot.SecretShop
			and npcCourier:DistanceFromFountain() < 7000
			and J.Item.GetEmptyInventoryAmount( npcCourier ) >= 2
			and not X.IsEnemyHeroAroundSecretShop() -- 商店附近没有敌人
			and currentTime > courierTime + useCourierCD
		then
			J.SetReportMotive( bDebugCourier, "信使前往神秘商店购物" )
			bot:ActionImmediate_Courier( npcCourier, COURIER_ACTION_SECRET_SHOP )
			bot.SShopUser = true
			courierTime = currentTime
			return
		end

		if bAliveBot
			and bot:GetCourierValue() > 0
			and bot:GetStashValue() < 100
			and ( not X.IsInvFull( bot ) or ( X.GetNumStashItem( bot ) == 0 and bot.currListItemToBuy ~= nil and #bot.currListItemToBuy == 0 ) )
			and ( npcCourier:DistanceFromFountain() < 4000 + botLV * 200 or GetUnitToUnitDistance( bot, npcCourier ) < 1800 )
			and currentTime > courierTime + useCourierCD
		then
			J.SetReportMotive( bDebugCourier, "信使运输背包中的东西" )
			bot:ActionImmediate_Courier( npcCourier, COURIER_ACTION_TRANSFER_ITEMS )
			courierTime = currentTime
			return
		end


	end

end


function X.GetBotCourier( bot )

	local nPlayerID = bot:GetPlayerID()

	for nCourierID = 0, 4
	do
		local courier = GetCourier( nCourierID )
		if courier:GetPlayerID() == nPlayerID
		then
			return courier
		end
	end

end


function X.GetNumStashItem( unit )

	local amount = 0
	for i = 9, 14
	do
		if unit:GetItemInSlot( i ) ~= nil
		then
			amount = amount + 1
		end
	end

	return amount

end

function X.IsThereRecipeInStash( unit )
	local amount = 0

	for i = 9, 14
	do
		local item = unit:GetItemInSlot(i)
		if item ~= nil
		then
			if string.find(item:GetName(), "item_recipe_")
			then
				amount = amount + 1
			end
		end
	end

	return amount > 0
end


function X.IsCourierTargetedByUnit( courier )

	if GetGameMode() == 23 then return false end

	local botLV = bot:GetLevel()

	if J.GetHP( courier ) < 0.9
	then
		return true
	end

	if courier:DistanceFromFountain() < 900 then return false end

	for i = 0, 10
	do
		local tower = GetTower( GetOpposingTeam(), i )
		if tower ~= nil and tower:CanBeSeen()
		then
			local towerTarget = tower:GetAttackTarget()

			if towerTarget == courier
			then
				return true
			end

			if towerTarget == nil
				and GetUnitToUnitDistance( courier, tower ) < 999
			then
				return true
			end
		end
	end

	for i, id in pairs( GetTeamPlayers( GetOpposingTeam() ) )
	do
		if IsHeroAlive( id )
		then
			local info = GetHeroLastSeenInfo( id )
			if info ~= nil
			then
				local dInfo = info[1]
				if dInfo ~= nil
					and GetUnitToLocationDistance( courier, dInfo.location ) <= 800
					and dInfo.time_since_seen < 1.8
				then
					return true
				end
			end
		end
	end

	local nEnemysHeroesCanSeen = GetUnitList( UNIT_LIST_ENEMY_HEROES )
	for _, enemy in pairs( nEnemysHeroesCanSeen )
	do
		if J.IsValidHero(enemy) then
			if GetUnitToUnitDistance( enemy, courier ) <= 700 + botLV * 15
			then
				local nNearCourierAllyList = J.GetAlliesNearLoc( enemy:GetLocation(), 600 )
				if #nNearCourierAllyList == 0
					or enemy:GetAttackTarget() == courier
				then
					return true
				end
			end
	
			if enemy:GetUnitName() == 'npc_dota_hero_sniper'
				and GetUnitToUnitDistance( enemy, courier ) <= 1100 + botLV * 30
			then
				return true
			end
	
			if GetUnitToUnitDistance( enemy, courier ) <= enemy:GetAttackRange() + 88
			then
				return true
			end
		end
	end

	local nEnemysHeroes = bot:GetNearbyHeroes( 1600, true, BOT_MODE_NONE )
	for _, enemy in pairs( nEnemysHeroes )
	do
		if J.IsValidHero(enemy) then
			if GetUnitToUnitDistance( enemy, courier ) <= 700 + botLV * 15
			then
				local nNearCourierAllyList = J.GetAlliesNearLoc( enemy:GetLocation(), 800 )
				if #nNearCourierAllyList == 0
					or enemy:GetAttackTarget() == courier
				then
					return true
				end
			end
	
			if GetUnitToUnitDistance( enemy, courier ) <= enemy:GetAttackRange() + 100
			then
				return true
			end
		end
	end

	local nAllEnemyCreeps = GetUnitList( UNIT_LIST_ENEMY_CREEPS )
	local nNearCourierAllyList = J.GetAlliesNearLoc( courier:GetLocation(), 1500 )
	local nNearCourierAllyCount = #nNearCourierAllyList
	for _, creep in pairs( nAllEnemyCreeps )
	do
		if J.IsValid(creep) then
			if GetUnitToUnitDistance( courier, creep ) <= 800
			and ( creep:GetAttackTarget() == courier or botLV > 10 )
			and ( nNearCourierAllyCount == 0 or creep:GetAttackTarget() == courier )
		then
			return true
		end
		end
	end

	return false

end


function X.IsInvFull( bot )

	for i = 0, 8
	do
		if bot:GetItemInSlot( i ) == nil
		then
			return false
		end
	end

	return true

end


function X.IsEnemyHeroAroundSecretShop()

	local vRadiantShop = GetShopLocation( GetTeam(), SHOP_SECRET )
	local vDireShop = GetShopLocation( GetTeam(), SHOP_SECRET2 )
	local vTeamSecretShop = GetTeam() == TEAM_DIRE and vDireShop or vRadiantShop

	local vCenterLocation = ( vTeamSecretShop + GetAncient( GetTeam() ):GetLocation() ) * 0.5

	if J.IsEnemyHeroAroundLocation( vCenterLocation, 2000 )
	then
		return true
	end

	return false

end

local fLastStashItemTimeList = {}
local vLocationRoshan, vLocationTormentor

local bAttacking = false
local botHP, botMP, botName, botLocation
local botTarget, botAttackRange, botActiveMode
local nAllyHeroes, nEnemyHeroes

local ITEM_TARGET_TYPE_NONE 	= 0
local ITEM_TARGET_TYPE_UNIT 	= 1
local ITEM_TARGET_TYPE_POINT 	= 2
local ITEM_TARGET_TYPE_TREE 	= 3
local ITEM_TARGET_TYPE_NONE_TWICE = 4

local function ItemUsageComplement()
	X.SetStashItemTimeUpdate()

	if not bot:IsAlive()
	or bot:IsMuted()
	or bot:IsHexed()
	or bot:IsStunned()
	or bot:IsChanneling()
	or bot:IsInvulnerable()
	or bot:IsUsingAbility()
	or bot:IsCastingAbility()
	or bot:NumQueuedActions() > 0
	or bot:HasModifier('modifier_teleporting')
	or bot:HasModifier('modifier_doom_bringer_doom_aura_enemy')
	or bot:HasModifier('modifier_phantom_lancer_phantom_edge_boost')
	or bot:HasModifier('modifier_life_stealer_infest')
	or (bot:HasModifier('modifier_nyx_assassin_vendetta') and J.IsRealInvisible(bot))
	or X.WillBreakInvisible(bot)
	then
		return
	end

	bAttacking = J.IsAttacking(bot)
    botHP = J.GetHP(bot)
	botMP = J.GetMP(bot)
	botName = bot:GetUnitName()
	botLocation = bot:GetLocation()
    botTarget = J.GetProperTarget(bot)
	botAttackRange = bot:GetAttackRange()
	botActiveMode = bot:GetActiveMode()
    nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	vLocationRoshan = J.GetCurrentRoshanLocation()
	vLocationTormentor = J.GetTormentorLocation(GetTeam())

	local nItemSlots = { 0, 1, 2, 3, 4, 5, 15, 16 }
	for _, slot in pairs(nItemSlots) do
		local hItem = bot:GetItemInSlot(slot)
		if J.CanCastAbility(hItem) then
			local sItemName = hItem:GetName()
			if X.ConsiderItemDesire[sItemName] ~= nil and not X.IsItemInStash(sItemName) then
				local nItemDesire, hItemTarget, nCastType = X.ConsiderItemDesire[sItemName](hItem)
				if nItemDesire > 0 then
					X.SetUseItem(hItem, hItemTarget, nCastType)
				end
			end
		end
	end
end

function X.SetUseItem(hItem, hItemTarget, nCastType)
	if nCastType == ITEM_TARGET_TYPE_NONE then
		bot:Action_UseAbility(hItem)
		return
	elseif nCastType == ITEM_TARGET_TYPE_UNIT then
		bot:Action_UseAbilityOnEntity(hItem, hItemTarget)
		return
	elseif nCastType == ITEM_TARGET_TYPE_POINT then
		if hItem then
			local sItemName = hItem:GetName()
			if sItemName == 'item_ward_dispenser' then
				if hItem:GetToggleState() == true then
					bot:Action_UseAbilityOnEntity(hItem, bot)
					bot:ActionQueue_UseAbilityOnLocation(hItem, hItemTarget)
					return
				end
			elseif sItemName == 'item_tpscroll' then
				local hAbility = bot:GetAbilityByName('furion_teleportation')
				if J.CanCastAbility(hAbility) then
					bot:Action_UseAbilityOnLocation(hAbility, hItemTarget)
					return
				end

				hAbility = bot:GetAbilityByName('tinker_keen_teleport')
				if J.CanCastAbility(hAbility) then
					bot:Action_UseAbilityOnLocation(hAbility, hItemTarget)
					return
				end
			end
		end

		bot:Action_UseAbilityOnLocation(hItem, hItemTarget)
		return
	elseif nCastType == ITEM_TARGET_TYPE_TREE then
		bot:Action_UseAbilityOnTree(hItem, hItemTarget)
		return
	elseif nCastType == ITEM_TARGET_TYPE_NONE_TWICE then
		bot:Action_UseAbility(hItem)
		bot:ActionQueue_UseAbility(hItem)
		return
	end
end

function X.IsWithoutSpellShield( npcEnemy )

	return J.IsValid(npcEnemy)
			and not npcEnemy:HasModifier( "modifier_item_sphere_target" )
			and not npcEnemy:HasModifier( "modifier_antimage_spell_shield" )
			and not npcEnemy:HasModifier( "modifier_item_lotus_orb_active" )

end

-- for detecting items moved from backpack -> main
local fLastDeleteTime = -90
function X.SetStashItemTimeUpdate()
	local fCurrentTime = DotaTime()

	for i = 6, 8 do
		local hItem = bot:GetItemInSlot(i)
		if hItem ~= nil then
			fLastStashItemTimeList[hItem:GetName()] = fCurrentTime
		end
	end

	if fCurrentTime > fLastDeleteTime + 7.0 then
		fLastDeleteTime = fCurrentTime
		for sItemName, fStashTime in pairs( fLastStashItemTimeList) do
			if fStashTime ~= nil and (fStashTime < fCurrentTime - 7.0) then
				fLastStashItemTimeList[sItemName] = nil
			end
		end
	end
end

function X.IsItemInStash(sItemName)
	return fLastStashItemTimeList[sItemName] ~= nil and (DotaTime() < fLastStashItemTimeList[sItemName] + 6.05)
end

function X.WillBreakInvisible( bot )

	local botName = bot:GetUnitName()

	if bot:IsInvisible()
	then
		if not bot:HasModifier( "modifier_phantom_assassin_blur_active" )
			and botName ~= "npc_dota_hero_riki"
		then
			return true
		end
	end

	return false

end

X.ConsiderItemDesire = {}

X.ConsiderItemDesire["item_abyssal_blade"] = function( hItem )

	local nCastRange = hItem:GetCastRange()

	for _, enemyHero in pairs(nEnemyHeroes) do
		if J.IsValidHero(enemyHero)
		and J.CanBeAttacked(enemyHero)
		and J.IsInRange(bot, enemyHero, nCastRange + 500)
		and J.CanCastOnTargetAdvanced(enemyHero)
		and not J.IsDisabled(enemyHero)
		and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			if enemyHero:IsChanneling() or enemyHero:IsCastingAbility() then
				return BOT_ACTION_DESIRE_HIGH, enemyHero, ITEM_TARGET_TYPE_UNIT
			end

			if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
				if  J.IsInRange(bot, enemyHero, nCastRange + 75)
				and not J.IsInRange(bot, enemyHero, nCastRange * 0.6)
				and not J.IsDisabled(enemyHero)
				and bot:WasRecentlyDamagedByHero(enemyHero, 3.0)
				then
					return BOT_ACTION_DESIRE_HIGH, enemyHero, ITEM_TARGET_TYPE_UNIT
				end
			end
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange + 150)
		and J.CanCastOnTargetAdvanced(botTarget)
		and not J.IsDisabled(botTarget)
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget, ITEM_TARGET_TYPE_UNIT
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

X.ConsiderItemDesire["item_aghanims_shard_roshan"] = function( hItem )
	return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
end

X.ConsiderItemDesire["item_arcane_blink"] = function( hItem )

	return X.ConsiderItemDesire["item_blink"]( hItem )

end

X.ConsiderItemDesire["item_arcane_boots"] = function(hItem)

	if bot:HasModifier('modifier_fountain_aura_buff') then
		return BOT_ACTION_DESIRE_NONE
	end

	local nRadius = hItem:GetSpecialValueInt('replenish_radius')
	local nReplenishAmount = hItem:GetSpecialValueInt('replenish_amount')

	local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), nRadius)

	if #nInRangeAlly >= 2
	and botHP < 0.2
	and bot:WasRecentlyDamagedByAnyHero(3.0)
	then
		return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
	end

	local nCountAllyNeedMana = 0

	for _, allyHero in pairs(nInRangeAlly) do
		if J.IsValidHero(allyHero)
		and not J.IsSuspiciousIllusion(allyHero)
		and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			if allyHero:GetMaxMana() - allyHero:GetMana() > nReplenishAmount then
				nCountAllyNeedMana = nCountAllyNeedMana + 1
			end
		end
	end

	if nCountAllyNeedMana >= 2
	or botMP < 0.5
	then
		return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
	end

	return BOT_ACTION_DESIRE_NONE
end

X.ConsiderItemDesire["item_armlet"] = function( hItem )

	local bIsToggled = hItem:GetToggleState()

	if J.IsValid(botTarget)
	and J.CanBeAttacked(botTarget)
	and J.IsInRange(bot, botTarget, botAttackRange + 300)
	and (not botTarget:IsBuilding() or not string.find(botTarget:GetUnitName(), 'OutpostName'))
	and not bot:IsDisarmed()
	then
		if not bIsToggled then
			return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
		else
			return BOT_ACTION_DESIRE_NONE
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
		if botHP < 0.2 then
			if bot:WasRecentlyDamagedByAnyHero(2.0)
			or J.IsAttackProjectileIncoming(bot, 1200)
			or J.IsStunProjectileIncoming(bot, 550)
			then
				if not bIsToggled then
					return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
				else
					return BOT_ACTION_DESIRE_NONE
				end
			end
		end
	end

	if (J.GetAttackProjectileDamageByRange(bot, 600) > bot:GetHealth() * 2)
	or (J.IsStunProjectileIncoming(bot, 600) and botHP < 0.25)
	then
		if not bIsToggled then
			return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
		else
			return BOT_ACTION_DESIRE_NONE
		end
	end

	if bIsToggled then
		return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
	end

	return BOT_ACTION_DESIRE_NONE
end

X.ConsiderItemDesire["item_bfury"] = function( hItem )

	return X.ConsiderItemDesire["item_quelling_blade"]( hItem )

end

X.ConsiderItemDesire["item_black_king_bar"] = function( hItem )

	if bot:HasModifier('modifier_dazzle_nothl_projection_soul_debuff')
	or bot:IsMagicImmune()
	or bot:IsInvulnerable()
	then
		return BOT_ACTION_DESIRE_NONE
	end

	local bIsGoingOnSomeone = J.IsGoingOnSomeone(bot)
	local bIsRetreating = J.IsRetreating(bot)

	local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1200)

	if #nInRangeEnemy > 0 and (bIsGoingOnSomeone or bIsRetreating) then
		if bot:IsRooted() then
			if (bIsGoingOnSomeone and J.IsValidHero(botTarget) and not J.IsInRange(bot, botTarget, botAttackRange + 150))
			or (bIsRetreating)
			then
				return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
			end
		end

		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and botTarget:HasModifier('modifier_item_blade_mail_reflect')
		and not botTarget:HasModifier('modifier_teleporting')
		and bIsGoingOnSomeone
		and bAttacking
		then
			return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
		end

		if  bot:IsSilenced()
		and bot:GetMana() > 100
		and not bot:HasModifier('modifier_item_mask_of_madness_berserk')
		and J.GetEnemyCount(bot, 800) >= 2
		and bIsGoingOnSomeone
		then
			return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
		end

		if bot:WasRecentlyDamagedByAnyHero(3.0) then
			if (J.IsWillBeCastUnitTargetSpell(bot, 800))
			or (J.IsWillBeCastPointSpell(bot, 800))
			or (J.IsStunProjectileIncoming(bot, 550))
			then
				if (bIsGoingOnSomeone and J.IsValidHero(botTarget) and not J.IsInRange(bot, botTarget, botAttackRange + 150))
				or (bIsRetreating and botHP < 0.55)
				then
					return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
				end
			end
		end

		if J.GetEnemyCount(bot, 800) >= 3 and (J.IsInTeamFight(bot, 1200) or not bRealInvisible) then
			return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

X.ConsiderItemDesire["item_blade_mail"] = function( hItem )

	if J.IsNotAttackProjectileIncoming(bot, 350) and #nEnemyHeroes > 0 then
		return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
	end

	for _, enemyHero in pairs(nEnemyHeroes) do
		if J.IsValidHero(enemyHero)
		and J.CanCastOnNonMagicImmune(enemyHero)
		then
			if (enemyHero:GetAttackTarget() == bot and (bot:WasRecentlyDamagedByHero(enemyHero, 5.0) or J.IsAttackProjectileIncoming(bot, 1000))) then
				return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

X.ConsiderItemDesire["item_blink"] = function( hItem )
	local nCastRange = Max(hItem:GetCastRange(), 1200)

	if bot:IsRooted() then
		return BOT_ACTION_DESIRE_NONE
	end

	if J.IsStuck(bot) then
		local vLocation = J.VectorTowards(botLocation, J.GetTeamFountain(), nCastRange)
		if IsLocationPassable(vLocation) then
			return BOT_ACTION_DESIRE_HIGH, vLocation, ITEM_TARGET_TYPE_POINT
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if botName == 'npc_dota_hero_nevermore' then
			local RequiemOfSouls = bot:GetAbilityByName('nevermore_requiem')
			if J.CanCastAbility(RequiemOfSouls) then
				return BOT_ACTION_DESIRE_NONE
			end
		end

		if  J.IsValidHero(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and GetUnitToLocationDistance(botTarget, J.GetEnemyFountain()) > 1200
		and not J.IsInRange(bot, botTarget, botAttackRange + 150)
		and not J.IsSuspiciousIllusion(botTarget)
		and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
		and not botTarget:HasModifier('modifier_enigma_black_hole_pull')
		then
			local nInRangeAlly = J.GetAlliesNearLoc(botLocation, 1200)
			local nNearbyEnemyHeroCount = 0
			for _, id in pairs(GetTeamPlayers(GetOpposingTeam())) do
				if IsHeroAlive(id) then
					local info = GetHeroLastSeenInfo(id)
					if info ~= nil then
						local dInfo = info[1]
						if dInfo ~= nil and dInfo.time_since_seen < 3.0 and GetUnitToLocationDistance(bot, dInfo.location) <= 1200 then
							nNearbyEnemyHeroCount = nNearbyEnemyHeroCount + 1
						end
					end
				end
			end

			if (#nInRangeAlly >= nNearbyEnemyHeroCount) then
				local vLocation = J.VectorAway(botTarget:GetLocation(), botLocation, 350)
				if J.IsDisabled(botTarget)
				or botTarget:HasModifier('modifier_teleporting')
				then
					vLocation = botTarget:GetLocation()
				end

				if IsLocationPassable(vLocation) and GetUnitToLocationDistance(bot, vLocation) <= nCastRange then
					return BOT_ACTION_DESIRE_HIGH, vLocation, ITEM_TARGET_TYPE_POINT
				end
			end
		end
	end

	if  J.IsRetreating(bot)
	and not J.IsRealInvisible(bot)
	and not bot:HasModifier('modifier_fountain_aura_buff')
	and bot:GetActiveModeDesire() > BOT_MODE_DESIRE_MODERATE
	then
		local vLocation = J.VectorTowards(botLocation, J.GetTeamFountain(), nCastRange)
		if IsLocationPassable(vLocation) and J.IsRunning(bot) then
			return BOT_ACTION_DESIRE_HIGH, vLocation, ITEM_TARGET_TYPE_POINT
		end
	end

	if J.IsFarming(bot) then
		if #nEnemyHeroes == 0 then
			if bot.farm and bot.farm.location then
				local distance = GetUnitToLocationDistance(bot, bot.farm.location)
				local vLocation = J.VectorTowards(botLocation, bot.farm.location, Min(nCastRange, distance))
				if J.IsRunning(bot) and distance > nCastRange and IsLocationPassable(vLocation) then
					return BOT_ACTION_DESIRE_HIGH, vLocation, ITEM_TARGET_TYPE_POINT
				end
			end
		end
	end

	if J.IsGoingToRune(bot) then
		if bot.rune and bot.rune.location then
			local distance = GetUnitToLocationDistance(bot, bot.rune.location)
			local vLocation = J.VectorTowards(botLocation, bot.rune.location, Min(nCastRange, distance))
			if J.IsRunning(bot) and distance > nCastRange and IsLocationPassable(vLocation) then
				return BOT_ACTION_DESIRE_HIGH, vLocation, ITEM_TARGET_TYPE_POINT
			end
		end
	end

	if (J.IsStunProjectileIncoming(bot, 450) and not bot:IsMagicImmune())
	or (J.GetAttackProjectileDamageByRange(bot, 800) > bot:GetHealth())
	then
		local vLocation = J.VectorTowards(botLocation, J.GetTeamFountain(), nCastRange)
		if IsLocationPassable(vLocation) then
			return BOT_ACTION_DESIRE_HIGH, vLocation, ITEM_TARGET_TYPE_POINT
		end
	end

	if hItem:GetName() == 'item_swift_blink' then
		local nInRangeEnemy = J.GetEnemiesNearLoc(botLocation, 1200)
		if J.IsPushing(bot) and #nInRangeEnemy == 0 then
			if  J.IsValidBuilding(botTarget)
			and J.CanBeAttacked(botTarget)
			and J.GetHP(botTarget) > 0.3
			and J.IsAttacking(bot)
			then
				return BOT_ACTION_DESIRE_HIGH, botLocation, ITEM_TARGET_TYPE_POINT
			end
		end
	end

	if J.IsDoingTormentor(bot) and not J.IsRealInvisible(bot) then
		local vTormentorLocation = J.GetTormentorLocation(GetTeam())
		if GetUnitToLocationDistance(bot, vTormentorLocation) > 2000 then
			local vLocation = J.VectorTowards(botLocation, vTormentorLocation, nCastRange)
			local nInRangeEnemy = J.GetEnemiesNearLoc(vLocation, 1200)
			if IsLocationPassable(vLocation) and #nInRangeEnemy == 0 then
				return BOT_ACTION_DESIRE_HIGH, vLocation, ITEM_TARGET_TYPE_POINT
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

X.ConsiderItemDesire['item_blood_grenade'] = function( hItem )

	local nCastRange = hItem:GetCastRange()
	local nCastPoint = hItem:GetCastPoint()
	local nRadius = hItem:GetSpecialValueInt('radius')
	local nHealthCost = hItem:GetSpecialValueInt('AbilityHealthCost')
	local nImpactDamage = hItem:GetSpecialValueInt('impact_damage')
	local nDuration = hItem:GetSpecialValueInt('debuff_duration')
	local nDPS = hItem:GetSpecialValueInt('damage_over_time')

	local botHealth = bot:GetHealth()

	for _, enemyHero in pairs(nEnemyHeroes) do
		if  J.IsValidHero(enemyHero)
		and J.CanBeAttacked(enemyHero)
		and J.IsInRange(bot, enemyHero, nCastRange)
		and J.CanCastOnNonMagicImmune(enemyHero)
		and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
		and not enemyHero:HasModifier('modifier_item_blood_grenade_debuff')
		and botHealth > nHealthCost * 2
		then
			if J.WillKillTarget(enemyHero, nImpactDamage + (nDPS * nDuration), DAMAGE_TYPE_MAGICAL, nDuration + nCastPoint) then
				return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation(), ITEM_TARGET_TYPE_POINT
			end

			if J.IsGoingOnSomeone(bot) then
				if J.IsChasingTarget(bot, enemyHero)
				and J.GetTotalEstimatedDamageToTarget(nAllyHeroes, enemyHero, nDuration + nCastPoint) > (enemyHero:GetHealth() + enemyHero:GetHealthRegen() * nDuration)
				then
					return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation(), ITEM_TARGET_TYPE_POINT
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

X.ConsiderItemDesire["item_bloodstone"] = function( hItem )

	if bot:HasModifier('modifier_alchemist_chemical_rage')
	or bot:HasModifier('modifier_doom_bringer_doom_aura_enemy')
	or bot:HasModifier('modifier_enchantress_natures_attendants')
	or bot:HasModifier('modifier_juggernaut_healing_ward_heal')
	or bot:HasModifier('modifier_legion_commander_press_the_attack')
	or bot:HasModifier('modifier_naga_siren_song_of_the_siren_healing')
	or bot:HasModifier('modifier_necrolyte_reapers_scythe')
	or bot:HasModifier('modifier_oracle_false_promise_timer')
	or bot:HasModifier('modifier_pugna_life_drain')
	or bot:HasModifier('modifier_ice_blast')
	or bot:HasModifier('modifier_item_aeon_disk_buff')
	or bot:HasModifier('modifier_item_bloodstone_active')
	or bot:HasModifier('modifier_item_satanic_unholy')
	or bot:HasModifier('modifier_fountain_aura_buff')
	or bot:HasModifier('modifier_rune_regen')
	then
		return BOT_ACTION_DESIRE_NONE
	end

	if J.IsGoingOnSomeone(bot) then
		if bot:HasModifier('modifier_leshrac_pulse_nova') then
			return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
		end

		if bot:WasRecentlyDamagedByAnyHero(2.0) and botHP < 0.5 then
			return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
		end
	end

	if #nEnemyHeroes > 0 then
		if (bot:IsRooted())
		or (J.IsRetreating(bot) and not J.IsRealInvisible(bot) and botHP < 0.3 and bot:WasRecentlyDamagedByAnyHero(1.0))
		then
			return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

X.ConsiderItemDesire["item_bloodthorn"] = function( hItem )

	return X.ConsiderItemDesire["item_orchid"]( hItem )

end

X.ConsiderItemDesire["item_boots_of_bearing"] = function( hItem )

	return X.ConsiderItemDesire["item_ancient_janggo"]( hItem )

end

X.ConsiderItemDesire["item_bottle"] = function( hItem )

	local nCharges = hItem:GetCurrentCharges()
	local nRestoreHealth = hItem:GetSpecialValueInt('health_restore')
	local nRestoreMana = hItem:GetSpecialValueInt('mana_restore')

	local nMissingHealth = bot:GetMaxHealth() - bot:GetHealth()
	local nMissingMana = bot:GetMaxMana() - bot:GetMana()

	if nCharges == 0
	or bot:HasModifier('modifier_bottle_regeneration')
	or bot:HasModifier('modifier_oracle_false_promise_timer')
	then
		return BOT_ACTION_DESIRE_NONE
	end

	if bot:HasModifier('modifier_fountain_aura_buff') then
		return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
	end

	if not bot:WasRecentlyDamagedByAnyHero( 3.0 ) then
		if nMissingHealth > nRestoreHealth and nMissingMana > nRestoreMana then
			return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
		end

		if (botHP < 0.5 and nMissingHealth > 500)
		or (botMP < 0.5 and nMissingMana > 500)
		then
			return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

X.ConsiderItemDesire["item_cheese"] = function( hItem )

	if bot:HasModifier('modifier_fountain_aura_buff') then return BOT_ACTION_DESIRE_NONE end

	local nLostHealth = bot:GetMaxHealth() - bot:GetHealth()
	local nLostMana = bot:GetMaxMana() - bot:GetMana()


	if (nLostHealth > 2500 and nLostMana > 1500)
	or (nLostHealth > 2000 and nLostHealth + nLostMana > 3000)
	or (botHP < 0.4 and botMP < 0.4)
	or (botHP < 0.2)
	or (botMP < 0.06)
	then
		if J.IsGoingOnSomeone(bot) then
			if J.IsValidHero(botTarget)
			and J.IsInRange(bot, botTarget, 1200)
			and bot:WasRecentlyDamagedByAnyHero(3.0)
			then
				return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
			end
		end

		if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:WasRecentlyDamagedByAnyHero(4.0) then
			return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

X.ConsiderItemDesire["item_clarity"] = function( hItem )

	local nCastRange = hItem:GetCastRange()
	local nDuration = hItem:GetSpecialValueInt('buff_duration')

	if botMP < 0.35
	and not bot:HasModifier('modifier_bottle_regeneration')
	and not bot:HasModifier('modifier_clarity_potion')
	and not bot:HasModifier('modifier_fountain_aura_buff')
	and not bot:WasRecentlyDamagedByAnyHero(4.0)
	and #nEnemyHeroes == 0
	then
		return BOT_ACTION_DESIRE_HIGH, bot, ITEM_TARGET_TYPE_UNIT
	end

	if #nEnemyHeroes == 0 then
		local hNeedManaAlly = nil
		local nNeedManaAllyMana = 99999
		for _, allyHero in pairs(nAllyHeroes) do
			if J.IsValidHero(allyHero)
			and allyHero ~= bot
			and J.CanBeAttacked(allyHero)
			and J.IsInRange(bot, allyHero, nCastRange * 2)
			and not allyHero:IsIllusion()
			and not allyHero:IsChanneling()
			and not allyHero:HasModifier('modifier_bottle_regeneration')
			and not allyHero:HasModifier('modifier_clarity_potion')
			and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			and not allyHero:HasModifier('modifier_fountain_aura_buff')
			and not allyHero:WasRecentlyDamagedByAnyHero(4.0)
			then
				local allyHeroMana = allyHero:GetMana() + allyHero:GetManaRegen() * nDuration
				if allyHero:GetMaxMana() - allyHeroMana > 350 and allyHeroMana < nNeedManaAllyMana then
					hNeedManaAlly = allyHero
					nNeedManaAllyMana = allyHeroMana
				end
			end
		end

		if hNeedManaAlly then
			return BOT_ACTION_DESIRE_HIGH, hNeedManaAlly, ITEM_TARGET_TYPE_UNIT
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

X.ConsiderItemDesire["item_crimson_guard"] = function( hItem )

	local nRadius = hItem:GetSpecialValueInt('bonus_aoe_radius')

	local nInRangeAlly = J.GetAlliesNearLoc(botLocation, nRadius)

	for _, allyHero in pairs(nInRangeAlly) do
		if J.IsValidHero(allyHero)
		and J.CanBeAttacked(allyHero)
		and J.IsInRange(bot, allyHero, nRadius)
		and J.GetHP(allyHero) < 0.8
		and allyHero:WasRecentlyDamagedByAnyHero(2.0)
		and not allyHero:IsIllusion()
		and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
		and not allyHero:HasModifier('modifier_item_crimson_guard_nostack')
		then
			if #nInRangeAlly >= 2 or (J.IsRetreating(bot) and not J.IsRealInvisible(bot) and #nInRangeAlly > 0) then
				return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
			end
		end
	end

	local nEnemyTowers = bot:GetNearbyTowers(Min(nRadius, 1600), true)
	local nInRangeEnemy = J.GetEnemiesNearLoc(botLocation, 1200)

	if #nInRangeAlly >= 2 and (#nInRangeEnemy + #nEnemyTowers >= 2 or #nInRangeEnemy >= 2) then
		local count = 0
		for _, allyHero in pairs(nInRangeAlly) do
			if J.IsValidHero(allyHero)
			and J.CanBeAttacked(allyHero)
			and J.IsInRange(bot, allyHero, nRadius)
			and allyHero:WasRecentlyDamagedByAnyHero(2.0)
			and not allyHero:IsIllusion()
			and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			and not allyHero:HasModifier('modifier_item_crimson_guard_nostack')
			then
				count = count + 1
			end
		end

		if count >= 2 then
			return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
		end
	end

	if J.IsDoingRoshan(bot) then
		if J.IsRoshan(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, 1200)
		and #nEnemyHeroes == 0
		and bAttacking
		then
			return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
		end
	end

	if J.IsDoingTormentor(bot) then
		if J.IsTormentor(botTarget)
		and J.IsInRange(bot, botTarget, 1200)
		and #nEnemyHeroes == 0
		and bAttacking
		then
			return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

X.ConsiderItemDesire["item_dagon"] = function( hItem )

	local nCastRange = hItem:GetCastRange()
	local nDamage = hItem:GetSpecialValueInt('damage')
	local nManaCost = hItem:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)

	for _, enemyHero in pairs(nEnemyHeroes) do
		if J.IsValidHero(enemyHero)
		and J.CanBeAttacked(enemyHero)
		and J.IsInRange(bot, enemyHero, nCastRange)
		and J.CanCastOnNonMagicImmune(enemyHero)
		and J.CanCastOnTargetAdvanced(enemyHero)
		and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
		and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
		and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
		and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
		and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
		then
			if (J.IsInEtherealForm(enemyHero) and J.GetHP(enemyHero) < 0.4)
			or (J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL))
			or (J.IsInTeamFight(bot, 1200) and J.IsCore(enemyHero) and bot:IsFacingLocation(enemyHero:GetLocation(), 30))
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero, ITEM_TARGET_TYPE_UNIT
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
		and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
		and not botTarget:HasModifier('modifier_templar_assassin_refraction_absorb')
		and fManaAfter > 0.3
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget, ITEM_TARGET_TYPE_UNIT
		end
	end

	if J.IsDoingRoshan(bot) then
		if J.IsRoshan(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and bAttacking
		and fManaAfter > 0.55
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget, ITEM_TARGET_TYPE_UNIT
		end
	end

    if J.IsDoingTormentor(bot) then
		if J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and bAttacking
		and fManaAfter > 0.55
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget, ITEM_TARGET_TYPE_UNIT
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

X.ConsiderItemDesire["item_dagon_2"] = function( hItem )

	return X.ConsiderItemDesire["item_dagon"]( hItem )

end

X.ConsiderItemDesire["item_dagon_3"] = function( hItem )

	return X.ConsiderItemDesire["item_dagon"]( hItem )

end

X.ConsiderItemDesire["item_dagon_4"] = function( hItem )

	return X.ConsiderItemDesire["item_dagon"]( hItem )

end

X.ConsiderItemDesire["item_dagon_5"] = function( hItem )

	return X.ConsiderItemDesire["item_dagon"]( hItem )

end

X.ConsiderItemDesire["item_diffusal_blade"] = function( hItem )

	local nCastRange = hItem:GetCastRange()

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.CanCastOnTargetAdvanced(botTarget)
		and J.IsChasingTarget(bot, botTarget)
		and botTarget:GetCurrentMovementSpeed() > 200
		and not J.IsDisabled(botTarget)
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		and not botTarget:HasModifier('modifier_item_diffusal_blade_slow')
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget, ITEM_TARGET_TYPE_UNIT
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and not J.IsDisabled(enemyHero)
			and not enemyHero:HasModifier('modifier_item_diffusal_blade_slow')
			and enemyHero:IsFacingLocation(botLocation, 30)
			and bot:WasRecentlyDamagedByHero(enemyHero, 3.0)
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero, ITEM_TARGET_TYPE_UNIT
            end
        end
	end

	return BOT_ACTION_DESIRE_NONE
end

X.ConsiderItemDesire['item_disperser'] = function( hItem )
	local nCastRange = hItem:GetCastRange()

	for _, allyHero in pairs(nAllyHeroes) do
		if J.IsValidHero(allyHero)
		and J.CanBeAttacked(allyHero)
		and J.IsInRange(bot, allyHero, nCastRange)
		and not J.IsSuspiciousIllusion(allyHero)
		and not allyHero:HasModifier('modifier_legion_commander_press_the_attack')
		and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
		and not allyHero:HasModifier('modifier_disperser_movespeed_buff')
		then
			if J.IsDisabled(allyHero) then
				return BOT_ACTION_DESIRE_HIGH, allyHero, ITEM_TARGET_TYPE_UNIT
			end

			if J.IsRetreating(allyHero) and not J.IsRealInvisible(allyHero) then
				for _, enemyHero in pairs(nEnemyHeroes) do
					if  J.IsValidHero(enemyHero)
					and J.CanBeAttacked(enemyHero)
					and J.IsInRange(allyHero, enemyHero, 1200)
					and not J.IsSuspiciousIllusion(enemyHero)
					and not J.IsDisabled(enemyHero)
					and enemyHero:IsFacingLocation(botLocation, 20)
					and allyHero:WasRecentlyDamagedByHero(enemyHero, 3.0)
					then
						return BOT_ACTION_DESIRE_HIGH, allyHero, ITEM_TARGET_TYPE_UNIT
					end
				end
			end
		end
	end

	return X.ConsiderItemDesire["item_diffusal_blade"]( hItem )
end

X.ConsiderItemDesire["item_ancient_janggo"] = function(hItem)

	local nRadius = hItem:GetSpecialValueInt('radius')

	if hItem:GetName() == 'item_boots_of_bearing' then
		if bot:HasModifier('modifier_faceless_void_time_zone_effect') then
			local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), 1200)
			if #nInRangeAlly >= 2 then
				return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
			end
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.IsInRange(bot, botTarget, nRadius)
		and not J.IsSuspiciousIllusion(botTarget)
		then
			if not bot:HasModifier('modifier_item_ancient_janggo_active')
			or not bot:HasModifier('modifier_item_boots_of_bearing_active')
			then
				return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

X.ConsiderItemDesire['item_dust'] = function( hItem )

	local nRadius = hItem:GetSpecialValueInt('radius') * 0.9
	
	local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), nRadius)
	local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), nRadius)

	if #nInRangeEnemy == 0 then
		for _, allyHero in pairs(nInRangeAlly) do
			if J.IsValidHero(allyHero) then
				local bSandKingVisible = X.IsHeroVisible(nInRangeEnemy, nRadius, 'npc_dota_hero_sand_king')
				local bRadianceCarrierVisible = X.IsItemCarrierVisible(nInRangeEnemy, nRadius, 'item_radiance')
				local bCoFCarrierVisible = X.IsItemCarrierVisible(nInRangeEnemy, nRadius, 'item_cloak_of_flames')
				local bGRCarrierVisible = X.IsItemCarrierVisible(nInRangeEnemy, nRadius, 'item_giants_ring')
		
				if (allyHero:HasModifier('modifier_item_radiance_debuff') and not bRadianceCarrierVisible)
				or (allyHero:HasModifier('modifier_item_cloak_of_flames_debuff') and not bCoFCarrierVisible)
				or (allyHero:HasModifier('modifier_item_giants_ring_visual') and not bGRCarrierVisible)
				or (allyHero:HasModifier('modifier_sandking_sand_storm_slow') and not bSandKingVisible)
				then
					return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
				end
			end
		end
	else
		for _, enemyHero in pairs(nInRangeEnemy) do
			if  J.IsValidHero(enemyHero)
			and J.IsUnitWillGoInvisible(enemyHero)
			and not J.HasInvisCounterBuff(enemyHero)
			and not J.IsSuspiciousIllusion(enemyHero)
			then
				local nAllyTowers = bot:GetNearbyTowers(1600, false)
				if #nAllyTowers == 0
				or (J.IsValidBuilding(nAllyTowers[1]) and not J.IsInRange(enemyHero, nAllyTowers[1], 700))
				or enemyHero:HasModifier('modifier_invisible')
				then
					if J.IsChasingTarget(bot, enemyHero)
					or J.IsGoingOnSomeone(bot)
					or J.IsInTeamFight(bot, nRadius)
					or J.GetHP(enemyHero) < 0.25
					then
						return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
					end
				end
			end	
		end	
	end

	for _, id in pairs(GetTeamPlayers(GetOpposingTeam())) do
		if IsHeroAlive(id) then
			local info = GetHeroLastSeenInfo(id)
			if info ~= nil then
				local dInfo = info[1]
				if  dInfo ~= nil 
				and dInfo.time_since_seen > 0.2
				and dInfo.time_since_seen < 1.2
				and GetUnitToLocationDistance(bot, dInfo.location) <= nRadius 
				then
					if J.IsGoingOnSomeone(bot)
					or J.IsInTeamFight(bot, nRadius)
					then
						return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
					end
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

X.ConsiderItemDesire["item_enchanted_mango"] = function( hItem )
	local nReplenishMana = hItem:GetSpecialValueInt('replenish_amount')

	if (J.IsGoingOnSomeone(bot) and botMP < 0.5)
	or (not J.IsInLaningPhase())
	then
		return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
	end

	return BOT_ACTION_DESIRE_NONE
end

X.ConsiderItemDesire["item_ethereal_blade"] = function( hItem )

	local nCastRange = hItem:GetCastRange()

	for _, enemyHero in pairs(nEnemyHeroes) do
		if J.IsValidHero(enemyHero)
		and J.CanBeAttacked(enemyHero)
		and J.IsInRange(bot, enemyHero, nCastRange + 300)
		and J.CanCastOnNonMagicImmune(enemyHero)
		and J.CanCastOnTargetAdvanced(enemyHero)
		and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			local nAllyHeroesAttackingTarget = J.GetHeroesTargetingUnit(nAllyHeroes, enemyHero)
			if enemyHero:HasModifier('modifier_abaddon_borrowed_time') then
				return BOT_ACTION_DESIRE_HIGH, enemyHero, ITEM_TARGET_TYPE_UNIT
			end

			if J.IsGoingOnSomeone(bot) then
				if  not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
				and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
				and J.GetHP(enemyHero) < 0.5
				and #nAllyHeroesAttackingTarget == 0
				then
					return BOT_ACTION_DESIRE_HIGH, enemyHero, ITEM_TARGET_TYPE_UNIT
				end
			end

			if J.IsInRange(bot, enemyHero, nCastRange) then
				if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
					if (bot:WasRecentlyDamagedByHero(enemyHero, 2.0))
					or (bot:WasRecentlyDamagedByHero(enemyHero, 5.0) and botHP < 0.15)
					then
						if enemyHero:IsFacingLocation(bot:GetLocation(), 20) and #nAllyHeroesAttackingTarget == 0 then
							return BOT_ACTION_DESIRE_HIGH, enemyHero, ITEM_TARGET_TYPE_UNIT
						end
					end
				end
			end
		end
	end

	if J.GetAttackProjectileDamageByRange(bot, 800) > bot:GetHealth() then
		return BOT_ACTION_DESIRE_HIGH, bot, ITEM_TARGET_TYPE_UNIT
	end

	return BOT_ACTION_DESIRE_NONE
end

X.ConsiderItemDesire["item_cyclone"] = function( hItem )

	local nCastRange = hItem:GetCastRange()

	local bDontUseOnEnemy = false
	for i = 1, 5 do
		local member = GetTeamMember(i)
		if J.IsValidHero(member)
		and GetUnitToUnitDistance(bot, member) < 1200
		and member:GetUnitName() == 'npc_dota_hero_invoker'
		then
			local nInRangeEnemy = J.GetEnemiesNearLoc(member:GetLocation(), 1200)
			if #nInRangeEnemy > 0
			and (  member:IsCastingAbility()
				or member:IsUsingAbility()
				or J.HasQueuedAction(member))
			then
				bDontUseOnEnemy = true
			end
		end
	end

	if bDontUseOnEnemy then return BOT_ACTION_DESIRE_NONE end

	for _, enemyHero in pairs(nEnemyHeroes) do
		if J.IsValidHero(enemyHero)
		and J.CanBeAttacked(enemyHero)
		and J.IsInRange(bot, enemyHero, nCastRange + 200)
		and J.CanCastOnNonMagicImmune(enemyHero)
		and J.CanCastOnTargetAdvanced(enemyHero)
		and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			if enemyHero:HasModifier('modifier_teleporting')
			or (enemyHero:HasModifier('modifier_abaddon_borrowed_time') and J.GetHP(enemyHero) < 0.5)
			or enemyHero:HasModifier('modifier_muerta_pierce_the_veil_buff')
			or enemyHero:HasModifier('modifier_troll_warlord_battle_trance')
			or enemyHero:HasModifier('modifier_ursa_enrage')
			or enemyHero:HasModifier('modifier_item_satanic_unholy')
			or enemyHero:IsChanneling()
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero, ITEM_TARGET_TYPE_UNIT
			end

			if J.IsGoingOnSomeone(bot) then
				if J.IsChasingTarget(bot, enemyHero)
				and not J.IsInRange(bot, enemyHero, botAttackRange)
				and enemyHero:GetCurrentMovementSpeed() > bot:GetCurrentMovementSpeed()
				then
					return BOT_ACTION_DESIRE_HIGH, enemyHero, ITEM_TARGET_TYPE_UNIT
				end
			end

			if J.IsRetreating(bot)
			and J.IsRunning(bot)
			and not J.IsRealInvisible(bot)
			and not J.IsInTeamFight(bot, 1200)
			then
				if bot:WasRecentlyDamagedByHero(enemyHero, 3.0) then
					return BOT_ACTION_DESIRE_HIGH, enemyHero, ITEM_TARGET_TYPE_UNIT
				end
			end

			if not J.IsRetreating(bot) and not bot:IsMagicImmune() then
				if bot:IsRooted() or bot:IsSilenced() then
					return BOT_ACTION_DESIRE_HIGH, bot, ITEM_TARGET_TYPE_UNIT
				end
			end
		end
	end

	for _, allyHero in pairs(nAllyHeroes) do
		if J.IsValidHero(allyHero)
		and J.CanBeAttacked(allyHero)
		and J.IsInRange(bot, allyHero, nCastRange + 300)
		and not allyHero:IsIllusion()
		and not allyHero:HasModifier('modifier_teleporting')
		and not allyHero:IsChanneling()
		then
			local bIsGoingOnSomeone = J.IsGoingOnSomeone(allyHero)
			local bIsRetreating = J.IsRetreating(allyHero)

			if (allyHero:HasModifier('modifier_faceless_void_chronosphere_freeze'))
			or (allyHero:HasModifier('modifier_enigma_black_hole_pull') and J.IsCore(allyHero))
			or (allyHero:HasModifier('modifier_legion_commander_duel'))
			or (allyHero:HasModifier('modifier_necrolyte_reapers_scythe'))
			or (allyHero:HasModifier('modifier_pugna_life_drain') and not bIsRetreating)
			then
				return BOT_ACTION_DESIRE_HIGH, allyHero, ITEM_TARGET_TYPE_UNIT
			end

			if bIsGoingOnSomeone and not allyHero:IsMagicImmune() then
				if allyHero:IsSilenced() then
					return BOT_ACTION_DESIRE_HIGH, allyHero, ITEM_TARGET_TYPE_UNIT
				end
			end

			if not bIsRetreating and J.GetAttackProjectileDamageByRange(allyHero, 450) > allyHero:GetHealth() then
				return BOT_ACTION_DESIRE_HIGH, allyHero, ITEM_TARGET_TYPE_UNIT
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

X.ConsiderItemDesire["item_faerie_fire"] = function( hItem )

	if bot:HasModifier('modifier_fountain_aura_buff') then
		return BOT_ACTION_DESIRE_NONE
	end

	if DotaTime() > 1 and not J.IsInLaningPhase() then
		return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
	end

	local nProjectiles = bot:GetIncomingTrackingProjectiles()
	for _, proj in pairs(nProjectiles) do
		if proj
		and proj.is_attack
		and not proj.is_dodgeable
		and GetUnitToLocationDistance(bot, proj.location) <= 550
		then
			local hCaster = proj.caster
			if J.IsValidHero(hCaster) then
				if bot:GetActualIncomingDamage(hCaster:GetAttackDamage(), DAMAGE_TYPE_PHYSICAL) > bot:GetHealth() then
					return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
				end
			end
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and botHP < 0.3
		and bot:WasRecentlyDamagedByAnyHero(3.0)
		then
			return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
		end
	end

	if J.IsRunning(bot) and botHP < 0.1 and #nEnemyHeroes > 0 then
		return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
	end

	return BOT_ACTION_DESIRE_NONE
end

X.ConsiderItemDesire["item_force_staff"] = function( hItem )

	local nCastRange = hItem:GetCastRange()
	local bIsHurricanePike = hItem:GetName() == 'item_hurricane_pike'

	if  bot:HasModifier('modifier_batrider_flaming_lasso_self')
	and bot:IsFacingLocation(J.GetTeamFountain(), 30)
	then
		return BOT_ACTION_DESIRE_HIGH, bot, ITEM_TARGET_TYPE_UNIT
	end

	for _, allyHero in pairs(nAllyHeroes) do
		if J.IsValidHero(allyHero)
		and J.CanBeAttacked(allyHero)
		and J.IsInRange(bot, allyHero, nCastRange)
		and not J.IsRealInvisible(allyHero)
		and not J.IsSuspiciousIllusion(allyHero)
		and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
		and not allyHero:HasModifier('modifier_teleporting')
		and not allyHero:IsChanneling()
		then
			local nInRangeAlly = J.GetAlliesNearLoc(allyHero:GetLocation(), 1200)
			local nInRangeEnemy = J.GetEnemiesNearLoc(allyHero:GetLocation(), 1200)
			if J.IsGoingOnSomeone(allyHero) then
				local allyHeroTarget = J.GetProperTarget(allyHero)

				if J.IsValidHero(allyHeroTarget)
				and not J.IsSuspiciousIllusion(allyHeroTarget)
				and GetUnitToUnitDistance(allyHero, allyHeroTarget) > allyHero:GetAttackRange() + 150
				and GetUnitToUnitDistance(allyHero, allyHeroTarget) < allyHero:GetAttackRange() + 700
				and allyHero:IsFacingLocation(allyHeroTarget:GetLocation(), 15)
				and not allyHeroTarget:IsFacingLocation(allyHero:GetLocation(), 40)
				and not allyHeroTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
				then
					if #nInRangeAlly >= #nInRangeEnemy then
						return BOT_ACTION_DESIRE_HIGH, allyHero, ITEM_TARGET_TYPE_UNIT
					end
				end
			end

			if J.IsRetreating(allyHero) then
				for _, enemyHero in pairs(nInRangeEnemy) do
					if J.IsValidHero(enemyHero)
					and J.IsInRange(bot, enemyHero, 1200)
					and not J.IsDisabled(enemyHero)
					and not enemyHero:IsDisarmed()
					and allyHero:DistanceFromFountain() > 600
					and allyHero:WasRecentlyDamagedByHero(enemyHero, 3.0)
					and allyHero:IsFacingLocation(J.GetTeamFountain(), 30)
					then
						return BOT_ACTION_DESIRE_HIGH, allyHero, ITEM_TARGET_TYPE_UNIT
					end
				end
			end

			if J.IsStuck(allyHero) then
				return BOT_ACTION_DESIRE_HIGH, allyHero, ITEM_TARGET_TYPE_UNIT
			end
		end
	end

	for _, allyHero in pairs(nAllyHeroes) do
		if  J.IsValidHero(allyHero)
		and allyHero ~= bot
		and J.CanBeAttacked(allyHero)
		and J.IsInRange(bot, allyHero, nCastRange)
		and not J.IsSuspiciousIllusion(allyHero)
		and allyHero:HasModifier('modifier_crystal_maiden_freezing_field')
		then
			local nInRangeAlly = J.GetAlliesNearLoc(allyHero:GetLocation(), 1200)
			local nInRangeEnemy = J.GetEnemiesNearLoc(allyHero:GetLocation(), 1200)
			for _, enemyHero in pairs(nInRangeEnemy) do
				if J.IsValidHero(enemyHero)
				and J.CanBeAttacked(enemyHero)
				and J.CanCastOnNonMagicImmune(enemyHero)
				and not J.IsInRange(allyHero, enemyHero, 600)
				and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
				and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
				and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
				and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
				and allyHero:IsFacingLocation(enemyHero:GetLocation(), 20)
				then
					if #nInRangeAlly >= #nInRangeEnemy then
						return BOT_ACTION_DESIRE_HIGH, allyHero, ITEM_TARGET_TYPE_UNIT
					end
				end
			end
		end
	end

	if bot:DistanceFromFountain() < 2600 and not bIsHurricanePike then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and J.CanCastOnTargetAdvanced(enemyHero)
			and enemyHero:IsFacingLocation(J.GetTeamFountain(), 20)
			and GetUnitToLocationDistance(enemyHero, J.GetTeamFountain()) < 1400
			and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero, ITEM_TARGET_TYPE_UNIT
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

X.ConsiderItemDesire["item_ghost"] = function( hItem )
	if J.IsRetreating(bot) then
		local nInRangeEnemy = bot:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
		if (bot:WasRecentlyDamagedByAnyHero(2.0) and #nInRangeEnemy > 0)
		or (bot:WasRecentlyDamagedByAnyHero(5.0) and botHP < 0.15)
		then
			return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
		end
	end

	if J.GetAttackProjectileDamageByRange(bot, 800) > bot:GetHealth() then
		return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
	end

	return BOT_ACTION_DESIRE_NONE
end

X.ConsiderItemDesire["item_gungir"] = function( hItem )

	return X.ConsiderItemDesire["item_rod_of_atos"]( hItem )

end

X.ConsiderItemDesire["item_glimmer_cape"] = function( hItem )

	local nCastRange = hItem:GetCastRange()

	for _, allyHero in pairs(nAllyHeroes) do
        if J.IsValidHero(allyHero)
		and J.CanBeAttacked(allyHero)
		and J.IsInRange(bot, allyHero, nCastRange)
		and allyHero:DistanceFromFountain() > 600
        and not J.IsRealInvisible(allyHero)
		and not J.IsSuspiciousIllusion(allyHero)
		and not allyHero:IsMagicImmune()
		and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        then
			local allyHeroHP = J.GetHP(allyHero)

			if J.IsStunProjectileIncoming(allyHero, 600)
			or J.IsUnitTargetProjectileIncoming(allyHero, 400)
			or (not allyHero:HasModifier('modifier_sniper_assassinate') and J.IsWillBeCastUnitTargetSpell(allyHero, 400))
			or J.IsDisabled(allyHero)
			or (allyHero:IsSilenced() and allyHeroHP < 0.2)
			then
				return BOT_ACTION_DESIRE_HIGH, allyHero, ITEM_TARGET_TYPE_UNIT
			end

			if J.IsRetreating(allyHero) and not J.IsAttacking(allyHero) then
				if allyHeroHP < 0.4 and (#nEnemyHeroes > #nAllyHeroes or bot:WasRecentlyDamagedByAnyHero(4.0)) then
					return BOT_ACTION_DESIRE_HIGH, allyHero, ITEM_TARGET_TYPE_UNIT
				end
			end
        end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and not bAttacking then
		if not bot:HasModifier('modifier_fountain_aura_buff') and #nEnemyHeroes > 0 then
			return BOT_ACTION_DESIRE_HIGH, bot, ITEM_TARGET_TYPE_UNIT
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

X.ConsiderItemDesire["item_guardian_greaves"] = function( hItem )

	local nRadius = hItem:GetSpecialValueInt('aura_radius')

	for _, allyHero in pairs(nAllyHeroes)  do
		if J.IsValidHero(allyHero)
		and J.CanBeAttacked(allyHero)
		and J.GetHP(allyHero) < 0.45
		and #nEnemyHeroes > 0
		and not allyHero:HasModifier('modifier_ice_blast')
		and not allyHero:HasModifier('modifier_abaddon_borrowed_time')
		and not allyHero:HasModifier('modifier_doom_bringer_doom_aura_enemy')
		and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
		and not allyHero:HasModifier('modifier_teleporting')
		and not allyHero:HasModifier('modifier_item_mekansm_noheal')
		then
			return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
		end
	end

	local needHPCount = 0
	for _, allyHero in pairs(nAllyHeroes) do
		if J.IsValidHero(npcAlly)
		and J.CanBeAttacked(allyHero)
		and not allyHero:HasModifier('modifier_ice_blast')
		and not allyHero:HasModifier('modifier_abaddon_borrowed_time')
		and not allyHero:HasModifier('modifier_doom_bringer_doom_aura_enemy')
		and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
		and not allyHero:HasModifier('modifier_teleporting')
		and not allyHero:HasModifier('modifier_item_mekansm_noheal')
		and (allyHero:GetMaxHealth()- allyHero:GetHealth() > 400)
		then
			needHPCount = needHPCount + 1
			if needHPCount >= 2 and J.GetHP(allyHero) < 0.5 then
				return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
			end
		end
	end

	if needHPCount >= 3 then
		return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
	end

	if not bot:HasModifier('modifier_item_mekansm_noheal') then
		if (botHP < 0.5 and bot:WasRecentlyDamagedByAnyHero(1.0))
		or bot:IsSilenced()
		or bot:IsRooted()
		or bot:HasModifier('modifier_item_urn_damage')
		or bot:HasModifier('modifier_item_spirit_vessel_damage')
		then
			return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
		end
	end

	local nNeedMPCount = 0
	for _, allyHero in pairs(nAllyHeroes) do
		if J.IsValidHero(npcAlly)
		and J.CanBeAttacked(allyHero)
		and not allyHero:HasModifier('modifier_ice_blast')
		and not allyHero:HasModifier('modifier_abaddon_borrowed_time')
		and not allyHero:HasModifier('modifier_doom_bringer_doom_aura_enemy')
		and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
		and not allyHero:HasModifier('modifier_teleporting')
		and not allyHero:HasModifier('modifier_item_mekansm_noheal')
		and (allyHero:GetMaxMana()- allyHero:GetMana() > 400)
		then
			nNeedMPCount = nNeedMPCount + 1
		end
	end

	if (nNeedMPCount >= 2 and botMP < 0.2)
	or (nNeedMPCount >= 3)
	then
		return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
	end

	return BOT_ACTION_DESIRE_NONE
end

X.ConsiderItemDesire["item_hand_of_midas"] = function( hItem )

	local nCastRange = hItem:GetCastRange()

	local nEnemyCreeps = bot:GetNearbyCreeps(nCastRange, true)
	local targetCreep = nil
	local targetCreepLevel = 0
	for _, creep in pairs(nEnemyCreeps) do
		if J.IsValid(creep)
		and J.CanCastOnNonMagicImmune(creep)
		and J.CanCastOnTargetAdvanced(creep)
		and not creep:IsAncientCreep()
		and creep:GetHealth() > 0
		then
			if creep:GetLevel() > targetCreepLevel then
				targetCreep = creep
				targetCreepLevel = creep:GetLevel()
			end
		end
	end

	if targetCreep ~= nil then
		return BOT_ACTION_DESIRE_HIGH, targetCreep, ITEM_TARGET_TYPE_UNIT
	end

	return BOT_ACTION_DESIRE_NONE
end

X.ConsiderItemDesire['item_harpoon'] = function( hItem )

	local nCastRange = hItem:GetCastRange()

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.CanCastOnTargetAdvanced(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and not J.IsInRange(bot, botTarget, botAttackRange)
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget, ITEM_TARGET_TYPE_UNIT
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

X.ConsiderItemDesire["item_flask"] = function( hItem )

	if bot:DistanceFromFountain() < 4000 then
		return BOT_ACTION_DESIRE_NONE
	end

	local nCastRange = hItem:GetCastRange()
	local nDuration = hItem:GetSpecialValueInt('buff_duration')

	if bot:GetMaxHealth() - bot:GetHealth() > 500
	and #nEnemyHeroes == 0
	and not bot:WasRecentlyDamagedByAnyHero(4.0)
	and not bot:HasModifier('modifier_filler_heal')
	and not bot:HasModifier('modifier_elixer_healing')
	and not bot:HasModifier('modifier_flask_healing')
	and not bot:HasModifier('modifier_juggernaut_healing_ward_heal')
	and not bot:HasModifier('modifier_doom_bringer_doom_aura_enemy')
	and not bot:HasModifier('modifier_ice_blast')
	then
		return BOT_ACTION_DESIRE_HIGH, bot, ITEM_TARGET_TYPE_UNIT
	end

	if J.HasItemInInventory('item_trusty_shovel') then
		return BOT_ACTION_DESIRE_HIGH, bot, ITEM_TARGET_TYPE_UNIT
	end

	local hNeedHealAlly = nil
	local nNeedHealAllyHealth = 99999
	for _, allyHero in pairs(nAllyHeroes) do
		if J.IsValidHero(allyHero)
		and allyHero ~= bot
		and J.IsInRange(bot, allyHero, nCastRange + 450)
		and not allyHero:IsIllusion()
		and not allyHero:IsChanneling()
		and not allyHero:HasModifier('modifier_filler_heal')
		and not allyHero:HasModifier('modifier_elixer_healing')
		and not allyHero:HasModifier('modifier_flask_healing')
		and not allyHero:HasModifier('modifier_juggernaut_healing_ward_heal')
		and not allyHero:HasModifier('modifier_doom_bringer_doom_aura_enemy')
		and not allyHero:HasModifier('modifier_ice_blast')
		and not allyHero:HasModifier('modifier_teleporting')
		and not allyHero:WasRecentlyDamagedByAnyHero(4.0)
		then
			local allyHeroHealth = allyHero:GetHealth() + allyHero:GetHealthRegen() * nDuration
			if allyHero:GetMaxHealth() - allyHeroHealth > 550 and allyHeroHealth < nNeedHealAllyHealth then
				hNeedHealAlly = allyHero
				nNeedHealAllyHealth = allyHeroHealth
			end
		end
	end

	if hNeedHealAlly and #nEnemyHeroes == 0 then
		return BOT_ACTION_DESIRE_HIGH, hNeedHealAlly, ITEM_TARGET_TYPE_UNIT
	end

	return BOT_ACTION_DESIRE_NONE
end

X.ConsiderItemDesire["item_heavens_halberd"] = function( hItem )

	local nCastRange = hItem:GetCastRange()

	if J.IsGoingOnSomeone(bot) or (J.IsRetreating(bot) and not J.IsRealInvisible(bot)) then
		local hTarget = nil
		local hTargetDamage = 0
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and J.CanCastOnTargetAdvanced(enemyHero)
			and not J.IsChasingTarget(bot, enemyHero)
			and not J.IsDisabled(enemyHero)
			and not enemyHero:IsDisarmed()
			then
				local enemyHeroDamage = enemyHero:GetAttackDamage() * enemyHero:GetAttackSpeed()
				if enemyHeroDamage > hTargetDamage then
					hTarget = enemyHero
					hTargetDamage = hTargetDamage
				end
			end
		end
		
		if hTarget then
			return BOT_ACTION_DESIRE_HIGH, hTarget, ITEM_TARGET_TYPE_UNIT
		end
	end

	if J.IsDoingRoshan(bot) then
		if J.IsRoshan(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and not J.IsDisabled(botTarget)
		and not botTarget:IsDisarmed()
		and not botTarget:HasModifier('modifier_roshan_spell_block')
		and bAttacking
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget, ITEM_TARGET_TYPE_UNIT
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

local bGoodCreepToDominate = {
	['npc_dota_neutral_alpha_wolf'] = true,
	['npc_dota_neutral_centaur_khan'] = true,
	['npc_dota_neutral_polar_furbolg_ursa_warrior'] = true,
	['npc_dota_neutral_dark_troll_warlord'] = true,
	['npc_dota_neutral_satyr_hellcaller'] = true,
	['npc_dota_neutral_enraged_wildkin'] = true,
	['npc_dota_neutral_warpine_raider'] = true,
	['npc_dota_neutral_satyr_soulstealer'] = true,
	['npc_dota_neutral_ogre_mauler'] = true,
	['npc_dota_neutral_ogre_magi'] = true,
	['npc_dota_neutral_mud_golem'] = true,
	['npc_dota_neutral_grown_frog'] = true,
	['npc_dota_neutral_grown_frog_mage'] = true,
}
X.ConsiderItemDesire["item_helm_of_the_dominator"] = function( hItem )

	local nCastRange = hItem:GetCastRange()
	local bIsOverlord = hItem:GetName() == 'item_helm_of_the_overlord'

	local unitList = GetUnitList(UNIT_LIST_ALLIES)
	for _, unit in pairs(unitList) do
		if  J.IsValid(unit)
		and unit ~= bot
		and unit:IsDominated()
		and unit:IsAncientCreep()
		and (bot:GetPlayerID() == unit:GetPlayerID())
		then
			return BOT_ACTION_DESIRE_NONE
		end
	end

	local nEnemyCreeps = bot:GetNearbyCreeps(Min(nCastRange + 300, 1600), true)
	for _, creep in pairs(nEnemyCreeps) do
		if  J.IsValid(creep)
		and J.CanBeAttacked(creep)
		and J.CanCastOnTargetAdvanced(creep)
		and J.GetHP(creep) >= 0.75
		and not creep:IsDominated()
		and not creep:HasModifier('modifier_chen_holy_persuasion')
		and not J.IsRoshan(creep)
		and not J.IsTormentor(creep)
		then
			local sCreepName = creep:GetUnitName()
			if not (string.find(sCreepName, 'siege') or string.find(sCreepName, 'range') or string.find(sCreepName, 'melee') or string.find(sCreepName, 'flagbearer')) then
				if (bGoodCreepToDominate[sCreepName])
				or (bIsOverlord and creep:IsAncientCreep())
				then
					return BOT_ACTION_DESIRE_HIGH, creep, ITEM_TARGET_TYPE_UNIT
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

X.ConsiderItemDesire["item_helm_of_the_overlord"] = function( hItem )

	return X.ConsiderItemDesire["item_helm_of_the_dominator"]( hItem )

end

X.ConsiderItemDesire["item_holy_locket"] = function( hItem )

	local nCastRange = hItem:GetCastRange()
	local nCharges = hItem:GetCurrentCharges()
	local nLostHP = bot:GetMaxHealth() - bot:GetHealth()
	local nLostMP = bot:GetMaxMana() - bot:GetMana()

	if bot:HasModifier('modifier_fountain_aura_buff')
	or bot:HasModifier('modifier_doom_bringer_doom_aura_enemy')
	or bot:HasModifier('modifier_ice_blast')
	or nCharges == 0
	then
		return BOT_ACTION_DESIRE_NONE
	end

	if nCharges >= 10 then
		for _, allyHero in pairs(nAllyHeroes) do
			if J.IsValidHero(allyHero)
			and allyHero ~= bot
			and J.CanBeAttacked(allyHero)
			and J.IsInRange(bot, allyHero, nCastRange + 300)
			and not J.IsSuspiciousIllusion(allyHero)
			and not allyHero:HasModifier('modifier_doom_bringer_doom_aura_enemy')
			and not allyHero:HasModifier('modifier_ice_blast')
			and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			and not allyHero:HasModifier('modifier_fountain_aura_buff')
			and allyHero:GetUnitName() ~= 'npc_dota_hero_huskar'
			and allyHero:GetUnitName() ~= 'npc_dota_hero_medusa'
			and allyHero:WasRecentlyDamagedByAnyHero(4.0)
			then
				local allyHP = J.GetHP(allyHero)
				local allyMP = J.GetMP(allyHero)
	
				if (J.IsRetreating(allyHero) and allyHP < 0.25)
				or (J.IsInTeamFight(allyHero, 1200) and allyHP < 0.25)
				then
					return BOT_ACTION_DESIRE_HIGH, allyHero, ITEM_TARGET_TYPE_UNIT
				end
			end
		end
	end

	if botHP < 0.8 and nCharges >= 3 and bot:HasModifier('modifier_maledict') then
		return BOT_ACTION_DESIRE_HIGH, bot, ITEM_TARGET_TYPE_UNIT
	end

	if (botHP < 0.4 or botMP < 0.3) and #nEnemyHeroes >= 1 and nCharges >= 5 then
		if bot:WasRecentlyDamagedByAnyHero(1.0) then
			return BOT_ACTION_DESIRE_HIGH, bot, ITEM_TARGET_TYPE_UNIT
		end
	end

	if (botHP < 0.7 and botMP < 0.7) and nCharges >= 12 and #nEnemyHeroes >= 1 then
		return BOT_ACTION_DESIRE_HIGH, bot, ITEM_TARGET_TYPE_UNIT
	end

	if (nCharges == 20 and #nEnemyHeroes >= 1 and nLostHP > 350 and nLostMP > 350) then
		return BOT_ACTION_DESIRE_HIGH, bot, ITEM_TARGET_TYPE_UNIT
	end

	return BOT_ACTION_DESIRE_NONE
end

X.ConsiderItemDesire["item_hurricane_pike"] = function( hItem )

	local nCastRange = hItem:GetCastRange()
	local nCastRange_Enemy = hItem:GetSpecialValueInt('cast_range_enemy') + (nCastRange - hItem:GetSpecialValueInt('AbilityCastRange'))

	for _, enemyHero in pairs(nEnemyHeroes) do
		if J.IsValidHero(enemyHero)
		and J.CanBeAttacked(enemyHero)
		and J.IsInRange(bot, enemyHero, nCastRange_Enemy)
		and J.CanCastOnNonMagicImmune(enemyHero)
		and J.CanCastOnTargetAdvanced(enemyHero)
		then
			if J.GetTotalEstimatedDamageToTarget(nEnemyHeroes, bot, 5.0) > bot:GetHealth() then
				bot:SetTarget(enemyHero)
				return BOT_ACTION_DESIRE_HIGH, enemyHero, ITEM_TARGET_TYPE_UNIT
			end
		end
	end

	return X.ConsiderItemDesire["item_force_staff"]( hItem )
end

X.ConsiderItemDesire["item_sphere"] = function( hItem )

	local nCastRange = hItem:GetCastRange()

	for _, allyHero in pairs(nAllyHeroes) do
		if J.IsValidHero(allyHero)
		and allyHero ~= bot
		and J.CanBeAttacked(allyHero)
		and J.IsInRange(bot, allyHero, nCastRange + 150)
		and allyHero:DistanceFromFountain() > 1200
		and not allyHero:IsIllusion()
		and not allyHero:HasModifier('modifier_antimage_spell_shield')
		and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
		and not allyHero:HasModifier('modifier_spirit_breaker_planar_pocket_aura')
		and not allyHero:HasModifier('modifier_item_lotus_orb_active')
		and not allyHero:HasModifier('modifier_item_sphere_target')
		then
			if J.IsUnitTargetProjectileIncoming(allyHero, 800)
			or J.IsWillBeCastUnitTargetSpell(allyHero, 800)
			or J.IsStunProjectileIncoming(allyHero, 550)
			then
				return BOT_ACTION_DESIRE_HIGH, allyHero, ITEM_TARGET_TYPE_UNIT
			end

			if J.IsGoingOnSomeone(allyHero) or J.IsRetreating(allyHero) then
				if J.IsUnitNearby(allyHero, nEnemyHeroes, 550, 'npc_dota_hero_doom_bringer', true) then
					return BOT_ACTION_DESIRE_HIGH, allyHero, ITEM_TARGET_TYPE_UNIT
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

X.ConsiderItemDesire["item_lotus_orb"] = function( hItem )

	local nCastRange = hItem:GetCastRange()

	for _, allyHero in pairs(nAllyHeroes) do
		if J.IsValidHero(allyHero)
		and J.CanBeAttacked(allyHero)
		and J.IsInRange(bot, allyHero, nCastRange + 150)
		and allyHero:DistanceFromFountain() > 1200
		and not allyHero:IsIllusion()
		and not allyHero:HasModifier('modifier_antimage_spell_shield')
		and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
		and not allyHero:HasModifier('modifier_spirit_breaker_planar_pocket_aura')
		and not allyHero:HasModifier('modifier_item_lotus_orb_active')
		and not allyHero:HasModifier('modifier_item_sphere_target')
		then
			if J.IsUnitTargetProjectileIncoming(allyHero, 800)
			or J.IsWillBeCastUnitTargetSpell(allyHero, 800)
			or J.IsStunProjectileIncoming(allyHero, 550)
			then
				return BOT_ACTION_DESIRE_HIGH, allyHero, ITEM_TARGET_TYPE_UNIT
			end

			if (allyHero:IsRooted())
			or (allyHero:IsSilenced() and not allyHero:HasModifier('modifier_item_mask_of_madness_berserk'))
			or (allyHero:IsDisarmed() and not allyHero:HasModifier('modifier_oracle_fates_edict'))
			or (J.IsDisabled(allyHero))
			then
				return BOT_ACTION_DESIRE_HIGH, allyHero, ITEM_TARGET_TYPE_UNIT
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

X.ConsiderItemDesire["item_magic_stick"] = function( hItem )
	
	local nCharges = hItem:GetCurrentCharges()

	if bot:HasModifier('modifier_fountain_aura_buff')
	or bot:HasModifier('modifier_doom_bringer_doom_aura_enemy')
	or bot:HasModifier('modifier_ice_blast')
	or nCharges == 0
	then
		return BOT_ACTION_DESIRE_NONE
	end


	if botHP < 0.8 and nCharges >= 3 and bot:HasModifier('modifier_maledict') then
		return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
	end

	if (botHP < 0.5 or botMP < 0.3) and #nEnemyHeroes >= 1 and nCharges >= 5 then
		return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
	end

	if (botHP + botMP < 1) and nCharges >= 7 and #nEnemyHeroes >= 1 then
		return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
	end

	return BOT_ACTION_DESIRE_NONE
end

X.ConsiderItemDesire["item_magic_wand"] = function( hItem )

	local nCharges = hItem:GetCurrentCharges()
	local nLostHP = bot:GetMaxHealth() - bot:GetHealth()
	local nLostMP = bot:GetMaxMana() - bot:GetMana()

	if bot:HasModifier('modifier_fountain_aura_buff')
	or bot:HasModifier('modifier_doom_bringer_doom_aura_enemy')
	or bot:HasModifier('modifier_ice_blast')
	or nCharges == 0
	then
		return BOT_ACTION_DESIRE_NONE
	end

	if botHP < 0.8 and nCharges >= 3 and bot:HasModifier('modifier_maledict') then
		return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
	end

	if (botHP < 0.4 or botMP < 0.3) and #nEnemyHeroes >= 1 and nCharges >= 5 then
		return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
	end

	if (botHP < 0.7 and botMP < 0.7) and nCharges >= 12 and #nEnemyHeroes >= 1 then
		return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
	end

	if (nCharges == 20 and #nEnemyHeroes >= 1 and nLostHP > 350 and nLostMP > 350) then
		return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
	end

	return BOT_ACTION_DESIRE_NONE
end

X.ConsiderItemDesire["item_manta"] = function( hItem )

	local bIsGoingOnSomeone = J.IsGoingOnSomeone(bot)
	local bIsRetreating = J.IsRetreating(bot)

	if bIsGoingOnSomeone or bIsRetreating then
		if (bot:IsRooted() and bot:WasRecentlyDamagedByAnyHero(5.0))
		or (bot:IsSilenced() and not bot:HasModifier('modifier_item_mask_of_madness_berserk'))
		or (bot:HasModifier('modifier_item_solar_crest_armor_reduction'))
		or (bot:HasModifier('modifier_item_medallion_of_courage_armor_reduction'))
		or (bot:HasModifier('modifier_item_spirit_vessel_damage'))
		or (bot:HasModifier('modifier_dragonknight_breathefire_reduction') and bIsGoingOnSomeone)
		or (bot:HasModifier('modifier_slardar_amplify_damage'))
		or (bot:HasModifier('modifier_item_dustofappearance') and bIsRetreating)
		or (bot:HasModifier('modifier_axe_battle_hunger'))
		or (bot:HasModifier('modifier_bristleback_viscous_nasal_goo') and J.IsRunning(allyHero))
		or (bot:HasModifier('modifier_earth_spirit_magnetize') and not bIsGoingOnSomeone)
		or (bot:HasModifier('modifier_phoenix_fire_spirit_burn') and bIsGoingOnSomeone)
		or (bot:HasModifier('modifier_life_stealer_open_wounds') and bIsRetreating)
		or (bot:HasModifier('modifier_faceless_void_time_dilation_slow') and bIsGoingOnSomeone)
		or (bot:HasModifier('modifier_warlock_fatal_bonds'))
		or (bot:HasModifier('modifier_arc_warden_flux') and bIsRetreating)
		or (bot:HasModifier('modifier_venomancer_venomous_gale') and bIsRetreating)
		or (bot:HasModifier('modifier_stunned'))
		then
			return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
		end
	end

	if  not bot:IsMagicImmune()
	and not bot:HasModifier('modifier_antimage_spell_shield')
	and not bot:HasModifier('modifier_item_sphere_target')
	and not bot:HasModifier('modifier_item_lotus_orb_active')
	then
		if J.IsNotAttackProjectileIncoming(bot, 100)
		or J.IsStunProjectileIncoming(bot, 250)
		then
			return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
		end
	end

	if (J.IsPushing(bot) or J.IsDefending(bot) or J.IsFarming(bot)) and #nAllyHeroes <= 1 and #nEnemyHeroes == 0 then
		local nEnemyCreeps = bot:GetNearbyCreeps(1000, true)
		if #nEnemyCreeps >= 5 then
			return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
		end
		
		if J.IsValidBuilding(botTarget)
		and J.CanBeAttacked(botTarget)
		and not botTarget:HasModifier('modifier_backdoor_protection_active')
		then
			if bAttacking or botTarget:GetHealthRegen() == 0 then
				return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
			end
		end
	end

	if bot:WasRecentlyDamagedByAnyHero(5.0) and botHP < 0.2 and bot:HasModifier('modifier_fountain_aura_buff') then
		return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
	end

	if J.IsDoingRoshan(bot) then
		if J.IsRoshan(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, 1200)
		and J.GetHP(botTarget) > 0.25
		and not J.IsLateGame()
		and bAttacking
		then
			return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
		end
	end

	if J.IsDoingTormentor(bot) then
		if J.IsTormentor(botTarget)
		and J.IsInRange(bot, botTarget, 1200)
		and not J.IsLateGame()
		and bAttacking
		then
			return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

X.ConsiderItemDesire["item_mask_of_madness"] = function( hItem )

	local nDuration = hItem:GetSpecialValueInt('berserk_duration')

	for i = 0, 7 do
		local hAbility = bot:GetAbilityInSlot(i)
		if  J.CanCastAbilitySoon(hAbility, nDuration)
		and not J.CanCastAbility(hAbility)
		and hAbility:GetCooldown() > nDuration
		then
			return BOT_ACTION_DESIRE_NONE
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, botAttackRange + 150)
		and not J.IsSuspiciousIllusion(botTarget)
		and bAttacking
		then
			return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
		end
	end

	if (J.IsPushing(bot) or J.IsDefending(bot) or J.IsFarming(bot)) then
		local nEnemyCreeps = bot:GetNearbyCreeps(Min(botAttackRange + 300, 1600), true)
		if #nAllyHeroes <= 2 and #nEnemyHeroes == 0 and bAttacking then
			if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
				if (#nEnemyCreeps >= 2 or nEnemyCreeps[1]:GetHealth() > 800)
				or (string.find(nEnemyCreeps[1]:GetUnitName(), 'warlock_golem'))
				then
					return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
				end
			end

			if J.IsValidBuilding(botTarget) and J.CanBeAttacked(botTarget) and botHP > 0.25 then
				return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
			end
		end
	end

	if J.IsDoingRoshan(bot) then
		if J.IsRoshan(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, botAttackRange + 150)
		and bAttacking
		then
			return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
		end
	end

	if J.IsDoingTormentor(bot) then
		if J.IsTormentor(botTarget)
		and J.IsInRange(bot, botTarget, botAttackRange + 150)
		and bAttacking
		then
			return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

X.ConsiderItemDesire["item_mekansm"] = function( hItem )

	local nRadius = hItem:GetSpecialValueInt('aura_radius')

	for _, allyHero in pairs(nAllyHeroes)  do
		if J.IsValidHero(allyHero)
		and J.CanBeAttacked(allyHero)
		and J.GetHP(allyHero) < 0.45
		and #nEnemyHeroes > 0
		and not allyHero:HasModifier('modifier_ice_blast')
		and not allyHero:HasModifier('modifier_abaddon_borrowed_time')
		and not allyHero:HasModifier('modifier_doom_bringer_doom_aura_enemy')
		and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
		and not allyHero:HasModifier('modifier_teleporting')
		and not allyHero:HasModifier('modifier_item_mekansm_noheal')
		then
			return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
		end
	end

	local needHPCount = 0
	for _, allyHero in pairs(nAllyHeroes) do
		if J.IsValidHero(npcAlly)
		and J.CanBeAttacked(allyHero)
		and not allyHero:HasModifier('modifier_ice_blast')
		and not allyHero:HasModifier('modifier_abaddon_borrowed_time')
		and not allyHero:HasModifier('modifier_doom_bringer_doom_aura_enemy')
		and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
		and not allyHero:HasModifier('modifier_teleporting')
		and not allyHero:HasModifier('modifier_item_mekansm_noheal')
		and (allyHero:GetMaxHealth()- allyHero:GetHealth() > 400)
		then
			needHPCount = needHPCount + 1
			if needHPCount >= 2 and J.GetHP(allyHero) < 0.5 then
				return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
			end
		end
	end

	if needHPCount >= 3 then
		return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
	end

	if not bot:HasModifier('modifier_item_mekansm_noheal') then
		if (botHP < 0.5 and bot:WasRecentlyDamagedByAnyHero(1.0)) then
			return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

X.ConsiderItemDesire["item_meteor_hammer"] = function( hItem )

	local nCastRange = hItem:GetCastRange()
	local nRadius = hItem:GetSpecialValueInt('impact_radius')
	local nChannelTime = hItem:GetSpecialValueInt('AbilityChannelTime')
	local nLandTime = hItem:GetSpecialValueFloat('land_time')

	local bIsFallenSky = hItem:GetName() == 'item_fallen_sky'

	if not bIsFallenSky then
		if (J.IsStunProjectileIncoming(bot, 800) and not bot:IsMagicImmune())
		or (J.GetTotalEstimatedDamageToTarget(nEnemyHeroes, bot, nChannelTime) > bot:GetHealth())
		then
			return BOT_ACTION_DESIRE_NONE
		end
	end

	for _, enemyHero in pairs(nEnemyHeroes) do
		if  J.IsValidHero(enemyHero)
		and J.CanBeAttacked(enemyHero)
		and J.IsInRange(bot, enemyHero, nCastRange)
		and J.CanCastOnNonMagicImmune(enemyHero)
		and enemyHero:HasModifier('modifier_teleporting')
		then
			local eta = (bIsFallenSky and nLandTime) or (nChannelTime + nLandTime)
			if J.GetModifierTime(enemyHero, 'modifier_teleporting') > eta then
				return BOT_ACTION_DESIRE_HIGH, enemyHero:GetLocation(), ITEM_TARGET_TYPE_POINT
			end
		end
	end

	if J.IsInTeamFight(bot, 1200) then
		local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
		local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)
		if #nInRangeEnemy >= 2 then
			local count = 0
			for _, enemyHero in pairs(nEnemyHeroes) do
				if J.IsValidHero(enemyHero)
				and J.CanBeAttacked(enemyHero)
				and J.CanCastOnNonMagicImmune(enemyHero)
				and GetUnitToLocationDistance(enemyHero, J.GetEnemyFountain()) > 1500
				and not J.IsChasingTarget(bot, enemyHero)
				and not enemyHero:HasModifier('modifier_faceless_void_chronosphere_freeze')
				then
					if J.IsDisabled(enemyHero)
					or enemyHero:GetCurrentMovementSpeed() <= 275
					or not J.IsMoving(enemyHero)
					then
						count = count + 1
					end
				end
			end

			if count >= 2 then
				return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, ITEM_TARGET_TYPE_POINT
			end
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange)
        and J.CanCastOnNonMagicImmune(botTarget)
		and J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			if bIsFallenSky then
				local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), 1200)
				local nInRangeEnemy = J.GetAlliesNearLoc(bot:GetLocation(), 1200)
				if #nInRangeAlly >= #nInRangeEnemy then
					return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation(), ITEM_TARGET_TYPE_POINT
				end
			else
				return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation(), ITEM_TARGET_TYPE_POINT
			end
		end
	end

	if J.IsPushing(bot) then
		if J.IsValidBuilding(botTarget)
		and J.CanBeAttacked(botTarget)
		and not botTarget:HasModifier('modifier_backdoor_protection_active')
		and not string.find(botTarget:GetUnitName(), 'fillers')
		then
			if bAttacking or botTarget:GetHealthRegen() == 0 then
				return BOT_ACTION_DESIRE_HIGH, botTarget:GetLocation(), ITEM_TARGET_TYPE_POINT
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

X.ConsiderItemDesire["item_mjollnir"] = function( hItem )

	local nCastRange = hItem:GetCastRange()
	local nRadius = hItem:GetSpecialValueInt('static_primary_radius')

	if J.IsGoingOnSomeone(bot) then
		local targetAlly = nil
		local targetAllyTargetingCount = 1
		for _, allyHero in pairs(nAllyHeroes) do
			if J.IsValidHero(allyHero)
			and J.CanBeAttacked(allyHero)
			and J.IsInRange(bot, allyHero, nCastRange)
			and J.IsGoingOnSomeone(allyHero)
			and J.GetHP(allyHero) > 0.4
			and not allyHero:IsIllusion()
			and not allyHero:HasModifier('modifier_item_mjollnir_static')
			and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			then
				local targetingCount = 0
				local nInRangeEnemy = allyHero:GetNearbyHeroes(nRadius, true, BOT_MODE_NONE)
				local nEnemyCreeps = allyHero:GetNearbyCreeps(nRadius, true)

				for _, enemyHero in pairs(nInRangeEnemy) do
					if J.IsValidHero(enemyHero) then
						if (enemyHero:GetAttackTarget() == allyHero)
						or (allyHero:WasRecentlyDamagedByHero(enemyHero, 2.0))
						or (enemyHero:IsFacingLocation(allyHero:GetLocation(), 15))
						then
							targetingCount = targetingCount + 1
						end
					end
				end
				
				for _, creep in pairs(nEnemyCreeps) do
					if J.IsValid(creep) then
						if (creep:GetAttackTarget() == allyHero)
						or (creep:IsFacingLocation(allyHero:GetLocation(), 15))
						then
							targetingCount = targetingCount + 1
						end
					end
				end

				if targetingCount > targetAllyTargetingCount then
					targetAlly = allyHero
					targetAllyTargetingCount = targetingCount
				end
			end
		end

		if targetAlly ~= nil then
			return BOT_ACTION_DESIRE_HIGH, targetAlly, ITEM_TARGET_TYPE_UNIT
		end
	end

	if #nEnemyHeroes == 0 then
		local nAllyLaneCreeps = bot:GetNearbyLaneCreeps(1000, false)
		local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(1000, true)
		if #nAllyLaneCreeps >= 3 and #nEnemyLaneCreeps == 0 then
			local targetCreep = nil
			local targetCreepDistance = math.huge
			for _, creep in pairs(nAllyLaneCreeps) do
				if J.IsValid(creep) then
					local creepDistance = creep:DistanceFromFountain()
					if creepDistance < targetCreepDistance then
						targetCreep = creep
						targetCreepDistance = creepDistance
					end
				end
			end

			if targetCreep ~= nil then
				return BOT_ACTION_DESIRE_HIGH, targetCreep, ITEM_TARGET_TYPE_UNIT
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

local fConsumeMoonshardTime = nil
X.ConsiderItemDesire["item_moon_shard"] = function( hItem )

	if  bot:GetItemInSlot(6) == nil
	and bot:GetItemInSlot(7) == nil
	and bot:GetItemInSlot(8) == nil
	then
		return BOT_ACTION_DESIRE_NONE
	end

	if not bot:HasModifier('modifier_item_moon_shard_consumed') then
		if  fConsumeMoonshardTime == nil then
			fConsumeMoonshardTime = DotaTime()
		elseif fConsumeMoonshardTime < DotaTime() - 3.0 then
			fConsumeMoonshardTime = nil
			return BOT_ACTION_DESIRE_HIGH, bot, ITEM_TARGET_TYPE_UNIT
		end
	end

	local targetMember = nil
	local targetMemberDamage = 0
	for i = 1, 5 do
		local member = GetTeamMember(i)
		if  J.IsValidHero(member)
		and bot ~= member
		and not member:HasModifier('modifier_item_moon_shard_consumed')
		then
			local memberAttackDamage = member:GetAttackDamage()
			if memberAttackDamage > targetMemberDamage then
				targetMember = member
				targetMemberDamage = memberAttackDamage
			end
		end
	end

	if targetMember ~= nil then
		if  fConsumeMoonshardTime == nil then
			fConsumeMoonshardTime = DotaTime()
		elseif fConsumeMoonshardTime < DotaTime() - 3.0 then
			fConsumeMoonshardTime = nil
			return BOT_ACTION_DESIRE_HIGH, targetMember, ITEM_TARGET_TYPE_UNIT
		end
	end


	return BOT_ACTION_DESIRE_NONE
end

X.ConsiderItemDesire["item_nullifier"] = function( hItem )

	local nCastRange = hItem:GetCastRange()

	if J.IsGoingOnSomeone(bot) then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and J.CanCastOnTargetAdvanced(enemyHero)
			and not J.IsDisabled(enemyHero)
			and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			and not enemyHero:HasModifier('modifier_item_nullifier_mute')
			then
				local sEnemyHeroName = enemyHero:GetUnitName()
				if sEnemyHeroName == 'npc_dota_hero_necrolyte'
				or sEnemyHeroName == 'npc_dota_hero_pugna'
				or sEnemyHeroName == 'npc_dota_hero_omniknight'
				or sEnemyHeroName == 'npc_dota_hero_windrunner'
				or J.HasItem(enemyHero, 'item_cyclone')
				or J.HasItem(enemyHero, 'item_wind_waker')
				then
					return BOT_ACTION_DESIRE_HIGH, enemyHero, ITEM_TARGET_TYPE_UNIT
				end
			end
		end

		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange )
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.CanCastOnTargetAdvanced(botTarget)
		and not botTarget:HasModifier('modifier_item_nullifier_mute')
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget, ITEM_TARGET_TYPE_UNIT
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

X.ConsiderItemDesire["item_ward_dispenser"] = function( hItem )
	return X.ConsiderItemDesire["item_ward_sentry"]( hItem )
end

X.ConsiderItemDesire["item_orchid"] = function( hItem )

	local nCastRange = hItem:GetCastRange()

	for _, enemyHero in pairs(nEnemyHeroes) do
		if J.IsValidHero(enemyHero)
		and J.CanBeAttacked(enemyHero)
		and J.CanCastOnNonMagicImmune(enemyHero)
		and J.CanCastOnTargetAdvanced(enemyHero)
		and not J.IsDisabled(enemyHero)
		and not enemyHero:IsSilenced()
		then
			if (enemyHero:IsChanneling() and not enemyHero:HasModifier('modifier_teleporting'))
			or (enemyHero:IsCastingAbility())
			then
				return BOT_ACTION_DESIRE_HIGH, enemyHero, ITEM_TARGET_TYPE_UNIT
			end
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.CanCastOnTargetAdvanced(botTarget)
		and not J.IsDisabled(botTarget)
		and not botTarget:IsSilenced()
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget, ITEM_TARGET_TYPE_UNIT
		end
	end

    if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnNonMagicImmune(enemyHero)
			and J.CanCastOnTargetAdvanced(enemyHero)
            and not J.IsDisabled(enemyHero)
			and not enemyHero:IsSilenced()
            and bot:WasRecentlyDamagedByHero(enemyHero, 2.0)
            then
                return BOT_ACTION_DESIRE_HIGH, enemyHero, ITEM_TARGET_TYPE_UNIT
            end
        end
	end

	return BOT_ACTION_DESIRE_NONE
end

X.ConsiderItemDesire["item_overwhelming_blink"] = function( hItem )

	return X.ConsiderItemDesire["item_blink"]( hItem )

end

X.ConsiderItemDesire['item_pavise'] = function( hItem )

	local nCastRange = hItem:GetCastRange()

    for _, allyHero in pairs(nAllyHeroes) do
        if  J.IsValidHero(allyHero)
        and J.CanBeAttacked(allyHero)
        and J.IsInRange(bot, allyHero, nCastRange + 300)
        and not allyHero:IsIllusion()
        and not allyHero:HasModifier('modifier_abaddon_aphotic_shield')
        and not allyHero:HasModifier("modifier_abaddon_borrowed_time")
        and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
        and not allyHero:HasModifier('modifier_fountain_aura_buff')
		and not allyHero:HasModifier('modifier_item_pavise_shield')
        then
            local allyHP = J.GetHP(allyHero)

            if allyHero:HasModifier('modifier_legion_commander_duel') 
			or J.IsUnitTargetProjectileIncoming(allyHero, 800)
			or J.IsWillBeCastUnitTargetSpell(allyHero, 1200)
			or J.IsDisabled(allyHero)
			or (allyHP < 0.2 and allyHero:WasRecentlyDamagedByAnyHero(2.0))
			then
                return BOT_ACTION_DESIRE_HIGH, allyHero, ITEM_TARGET_TYPE_UNIT
            end

            if J.IsGoingOnSomeone(allyHero) then
                local allyHeroTarget = J.GetProperTarget(allyHero)
                if J.IsValidHero(allyHeroTarget)
                and J.IsInRange(allyHero, allyHeroTarget, allyHero:GetAttackRange() + 300)
                and not J.IsSuspiciousIllusion(allyHeroTarget)
                then
                    if allyHP < 0.4
					or allyHero:WasRecentlyDamagedByAnyHero(1.0)
					or J.IsInTeamFight(allyHero, 1200)
					or J.IsHumanPlayer(allyHero)
					then
                        return BOT_ACTION_DESIRE_HIGH, allyHero, ITEM_TARGET_TYPE_UNIT
                    end
                end
            end

            if J.IsRetreating(allyHero) and not J.IsRealInvisible(allyHero) then
                if allyHero:WasRecentlyDamagedByAnyHero(2.0) and allyHP < 0.75 then
                    return BOT_ACTION_DESIRE_HIGH, allyHero, ITEM_TARGET_TYPE_UNIT
                end
            end

            if J.IsDoingRoshan(bot) then
                if  J.IsRoshan(botTarget)
                and J.IsInRange(bot, botTarget, 800)
                and bAttacking
                then
                    if allyHP < 0.5 then
                        return BOT_ACTION_DESIRE_HIGH, allyHero, ITEM_TARGET_TYPE_UNIT
                    end
                end
            end

            if J.IsDoingTormentor(bot) then
                if  J.IsTormentor(botTarget)
                and J.IsInRange(bot, botTarget, 800)
                and bAttacking
                then
                    if allyHP < 0.5 then
                        return BOT_ACTION_DESIRE_HIGH, allyHero, ITEM_TARGET_TYPE_UNIT
                    end
                end
            end

            if allyHero:WasRecentlyDamagedByAnyHero(2.0) and allyHP < 0.4 then
                return BOT_ACTION_DESIRE_HIGH, allyHero, ITEM_TARGET_TYPE_UNIT
            end
        end
	end

	if not bot:HasModifier('modifier_abaddon_aphotic_shield')
	and not bot:HasModifier('modifier_abaddon_borrowed_time')
	and not bot:HasModifier('modifier_item_pavise_shield')
	then
		if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
			if bot:WasRecentlyDamagedByAnyHero(2.0) and botHP < 0.75 then
				return BOT_ACTION_DESIRE_HIGH, bot, ITEM_TARGET_TYPE_UNIT
			end
		end
	
		if (J.IsPushing(bot) or J.IsDefending(bot) or J.IsFarming(bot)) and bAttacking and #nEnemyHeroes <= 1 then
			local nEnemyCreeps = bot:GetNearbyCreeps(1600, true)
			if #nEnemyCreeps > 0 and botHP < 0.3 then
				return BOT_ACTION_DESIRE_HIGH, bot, ITEM_TARGET_TYPE_UNIT
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

X.ConsiderItemDesire["item_phase_boots"] = function( hItem )

	if J.IsRunning(bot)
	and not J.IsRealInvisible(bot)
	and not bot:HasModifier('modifier_fountain_aura_buff')
	then
		if J.IsGoingOnSomeone(bot) then
			if J.IsValidHero(botTarget)
			and J.CanBeAttacked(botTarget)
			and not J.IsInRange(bot, botTarget, botAttackRange + 150)
			and not J.IsSuspiciousIllusion(botTarget)
			then
				return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
			end
		end

		if J.IsRetreating(bot) then
			return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
		end

		if J.IsPushing(bot) then
			local nLane = LANE_MID
			if bot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP then nLane = LANE_TOP end
			if bot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT then nLane = LANE_BOT end
	
			local vLaneFrontLocation = GetLaneFrontLocation(GetTeam(), nLane, 0)
			if GetUnitToLocationDistance(bot, vLaneFrontLocation) > 1200 then
				return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
			end
		end
	
		if J.IsDefending(bot) then
			local nLane = LANE_MID
			if bot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP then nLane = LANE_TOP end
			if bot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT then nLane = LANE_BOT end
	
			local vLaneFrontLocation = GetLaneFrontLocation(GetTeam(), nLane, 0)
			if GetUnitToLocationDistance(bot, vLaneFrontLocation) > 1200 then
				return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
			end
		end
	
		if J.IsFarming(bot)  then
			if bot.farm and bot.farm.location and GetUnitToLocationDistance(bot, bot.farm.location) > botAttackRange then
				return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
			end
		end
	
		if J.IsLaning(bot) and J.IsInLaningPhase() and DotaTime() > 0 then
			local vLaneFrontLocation = GetLaneFrontLocation(GetTeam(), bot:GetAssignedLane(), 0)
			if GetUnitToLocationDistance(bot, vLaneFrontLocation) > botAttackRange then
				return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
			end
		end
	
		if J.IsGoingToRune(bot) then
			if bot.rune and bot.rune.location and GetUnitToLocationDistance(bot, bot.rune.location) > botAttackRange then
				return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
			end
		end
	
		if J.IsDoingRoshan(bot) then
			local vRoshanLocation = J.GetCurrentRoshanLocation()
			if GetUnitToLocationDistance(bot, vRoshanLocation) > 800 then
				return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
			end
		end
	
		if J.IsDoingTormentor(bot) then
			local vTormentorLocation = J.GetTormentorLocation(GetTeam())
			if GetUnitToLocationDistance(bot, vTormentorLocation) > 800 then
				return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

X.ConsiderItemDesire["item_pipe"] = function( hItem )

	local nRadius = hItem:GetSpecialValueInt('aura_radius')

	local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), nRadius)

	for _, allyHero in pairs(nAllyHeroes) do
		if J.IsValidHero(allyHero)
		and J.CanBeAttacked(allyHero)
		and J.IsInRange(bot, allyHero, nRadius)
		and not allyHero:IsIllusion()
		and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
		and not allyHero:HasModifier('modifier_item_pipe_barrier')
		and not allyHero:HasModifier('modifier_teleporting')
		and J.IsInTeamFight(allyHero, 1200)
		and #nInRangeAlly >= 2
		then
			return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and not J.IsInTeamFight(bot, 1200) then
		if  bot:WasRecentlyDamagedByAnyHero(2.0)
		and bot:DistanceFromFountain() > 4000
		and botHP > 0.3
		and #nInRangeAlly >= 2
		then
			return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

local fLastSwitchPtTime = -90
X.ConsiderItemDesire["item_power_treads"] = function( hItem )

	local nCurrentStat = hItem:GetPowerTreadsStat()

	if  nCurrentStat == ATTRIBUTE_INTELLECT then
		nCurrentStat = ATTRIBUTE_AGILITY
	elseif nCurrentStat == ATTRIBUTE_AGILITY then
		nCurrentStat = ATTRIBUTE_INTELLECT
	end

	if (   bot:HasModifier('modifier_flask_healing')
		or bot:HasModifier('modifier_clarity_potion')
		or bot:HasModifier('modifier_item_urn_heal')
		or bot:HasModifier('modifier_item_spirit_vessel_heal')
		or bot:HasModifier('modifier_bottle_regeneration'))
	and not J.IsGoingOnSomeone(bot)
	and not J.IsRetreating(bot)
	and not bot:WasRecentlyDamagedByAnyHero(5.0)
	then
		if nCurrentStat ~= ATTRIBUTE_AGILITY then
			fLastSwitchPtTime = DotaTime()
			if nCurrentStat == ATTRIBUTE_STRENGTH then
				return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
			else
				return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
			end
		end
	elseif (J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:GetActiveModeDesire() > BOT_MODE_DESIRE_MODERATE)
		or (J.IsNotAttackProjectileIncoming(bot, 1200))
		or (botActiveMode == BOT_MODE_EVASIVE_MANEUVERS)
		or (bot:HasModifier('modifier_sniper_assassinate'))
		or (botHP < 0.2)
		or (nCurrentStat == ATTRIBUTE_STRENGTH and botHP < 0.3)
		then
			if nCurrentStat ~= ATTRIBUTE_STRENGTH then
				fLastSwitchPtTime = DotaTime()
				if nCurrentStat == ATTRIBUTE_AGILITY then
					return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
				else
					return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
				end
			end
	elseif J.IsGoingOnSomeone(bot) then
		if J.ShouldSwitchPTStat(bot, hItem) and fLastSwitchPtTime < DotaTime() - 0.2 then
			return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
		end
	elseif J.ShouldSwitchPTStat(bot, hItem) and fLastSwitchPtTime < DotaTime() - 0.2 then
		return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
	end

	return BOT_ACTION_DESIRE_NONE
end

local bIsMonkeyPerching = { mk = false, morph = false, rubick = false }
X.ConsiderItemDesire["item_quelling_blade"] = function( hItem )

	if J.GetAbility(bot, 'monkey_king_tree_dance') ~= nil then
		return BOT_ACTION_DESIRE_NONE
	end

	local nCastRange = hItem:GetCastRange()

	if DotaTime() < 0 and not bIsMonkeyPerching then
		for _, enemyID in pairs(GetTeamPlayers(GetOpposingTeam())) do
			if GetSelectedHeroName(enemyID) == 'npc_dota_hero_monkey_king' then bIsMonkeyPerching.mk = true end

			for _, teamID in pairs(GetTeamPlayers(GetTeam())) do
				if GetSelectedHeroName(teamID) == 'npc_dota_hero_monkey_king' then
					if GetSelectedHeroName(enemyID) == 'npc_dota_hero_morphling' then bIsMonkeyPerching.morph = true end
					if GetSelectedHeroName(enemyID) == 'npc_dota_hero_rubick' then bIsMonkeyPerching.rubick = true end
				end
			end
		end
	end

	local nTrees = bot:GetNearbyTrees(Min(nCastRange, 1600))

	for _, enemyHero in pairs(nEnemyHeroes) do
		if J.IsValidHero(enemyHero)
		and J.IsInRange(bot, enemyHero, nCastRange + 150)
		and not J.IsSuspiciousIllusion(enemyHero)
		then
			local sEnemyHeroName = enemyHero:GetUnitName()
			if (string.find(sEnemyHeroName, 'monkey_king') and bIsMonkeyPerching.mk)
			or (string.find(sEnemyHeroName, 'morphling') and bIsMonkeyPerching.morph)
			or (string.find(sEnemyHeroName, 'rubick') and bIsMonkeyPerching.rubick)
			then
				for _, tree in pairs(nTrees) do
					if tree then
						local vLocationTree = GetTreeLocation(tree)
						if GetUnitToLocationDistance(enemyHero, vLocationTree) < 30 then
							return BOT_ACTION_DESIRE_HIGH, tree, ITEM_TARGET_TYPE_TREE
						end
					end
				end
			end
		end
	end

	if (J.IsGoingOnSomeone(bot) or J.IsFarming(bot) or J.IsRetreating(bot)) and not J.IsRealInvisible(bot) then
		for _, tree in pairs(nTrees) do
			if tree then
				local vLocationTree = GetTreeLocation(tree)
				if bot:IsFacingLocation(vLocationTree, 10) then
					return BOT_ACTION_DESIRE_HIGH, tree, ITEM_TARGET_TYPE_TREE
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

X.ConsiderItemDesire["item_radiance"] = function( hItem )

	local bIsToggled = hItem:GetToggleState()

	if bot:HasModifier('modifier_smoke_of_deceit') then
		if not bIsToggled then
			return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
		else
			return BOT_ACTION_DESIRE_NONE
		end
	end

	if bIsToggled then
		return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
	end

	return BOT_ACTION_DESIRE_NONE
end

X.ConsiderItemDesire["item_refresher"] = function( hItem )

	local nManaCost = hItem:GetManaCost()
	local botManaRegen = Max(bot:GetManaRegen(), 1.0)
	local botMaxMana = bot:GetMaxMana()
	local fManaAfter = J.GetManaAfter(nManaCost)
	local fManaThreshold1 = 0

	for i = 0, 7 do
		local hAbility = bot:GetAbilityInSlot(i)
		if hAbility then
			local abilityManaCost = hAbility:GetManaCost()
			if J.CanCastAbilitySoon(hAbility, nManaCost / botManaRegen) then
				fManaThreshold1 = fManaThreshold1 + (abilityManaCost / botMaxMana)
			end
		end
	end

	local idx = {0, 1, 2, 3, 4, 5, 16}
	for _, i in ipairs(idx) do
		local hItem__ = bot:GetItemInSlot(i)
		if hItem__ and hItem__ ~= hItem and J.CanCastAbilitySoon(hAbility, nManaCost / botManaRegen) then
			fManaThreshold1 = fManaThreshold1 + (hItem__:GetManaCost() / botMaxMana)
		end
	end

	if fManaAfter > fManaThreshold1 then
		if J.IsGoingOnSomeone(bot) then
			if J.IsValidHero(botTarget)
			and J.IsInRange(bot, botTarget, 1600)
			and not J.IsSuspiciousIllusion(botTarget)
			then
				for i = 0, 5 do
					local hAbility = bot:GetAbilityInSlot(i)
					if hAbility and hAbility:IsTrained() then
						local sAbilityName = hAbility:GetName()
						local nCooldown = hAbility:GetCooldown()
						local nCooldownTimeRemaining = hAbility:GetCooldownTimeRemaining()
		
						if sAbilityName == 'life_stealer_rage'
						or sAbilityName == 'broodmother_insatiable_hunger'
						or sAbilityName == 'gyrocopter_flak_cannon'
						or sAbilityName == 'lone_druid_spirit_bear'
						or sAbilityName == 'terrorblade_metamorphosis'
						then
							if nCooldownTimeRemaining >= (nCooldown / 2) and bAttacking then
								return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
							end
						else
							if i == 5 and nCooldownTimeRemaining >= (nCooldown / 2) then
								return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
							end
						end
					end
				end

				for i = 0, 5 do
					local hItem__ = bot:GetItemInSlot(i)
					if hItem__ and hItem__ ~= hItem then
						local sItemName = hItem__:GetName()
						local nCooldown = hItem__:GetCooldown()
						local nCooldownTimeRemaining = hItem__:GetCooldownTimeRemaining()
						if sItemName == 'item_black_king_bar' then
							if nCooldownTimeRemaining >= (nCooldown / 2) and bAttacking then
								return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
							end
						end
					end
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

X.ConsiderItemDesire["item_refresher_shard"] = function( hItem )

	return X.ConsiderItemDesire["item_refresher"]( hItem )

end

X.ConsiderItemDesire["item_rod_of_atos"] = function( hItem )

	local nCastRange = hItem:GetCastRange()
	local nRadius = hItem:GetSpecialValueInt('radius')

	local bIsGleipnir = hItem:GetName() == 'item_gungir'

    for _, enemyHero in pairs(nEnemyHeroes) do
        if  J.IsValidHero(enemyHero)
        and J.CanBeAttacked(enemyHero)
        and J.IsInRange(bot, enemyHero, nCastRange + nRadius)
        and J.CanCastOnNonMagicImmune(enemyHero)
		and enemyHero:HasModifier('modifier_teleporting')
        then
			if bIsGleipnir then
				local distance = Min(GetUnitToUnitDistance(bot, enemyHero), nCastRange)
				return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(bot:GetLocation(), enemyHero:GetLocation(), distance), ITEM_TARGET_TYPE_POINT
			else
				if J.CanCastOnTargetAdvanced(enemyHero) and J.IsInRange(bot, enemyHero, nCastRange) then
					return BOT_ACTION_DESIRE_HIGH, enemyHero, ITEM_TARGET_TYPE_UNIT
				end
			end
        end
    end

	if bIsGleipnir then
		if J.IsInTeamFight(bot, 1200) then
			local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
			local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)
			if #nInRangeEnemy >= 2 then
				local count = 0
				for _, enemyHero in pairs(nEnemyHeroes) do
					if J.IsValidHero(enemyHero)
					and J.CanBeAttacked(enemyHero)
					and J.CanCastOnNonMagicImmune(enemyHero)
					and not J.IsDisabled(enemyHero)
					then
						count = count + 1
					end
				end
	
				if count >= 2 then
					return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, ITEM_TARGET_TYPE_POINT
				end
			end
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.CanCastOnNonMagicImmune(botTarget)
        and J.IsInRange(bot, botTarget, nCastRange + nRadius)
		and J.IsMoving(botTarget)
		and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		and not botTarget:HasModifier('modifier_bloodseeker_rupture')
		then
			if bIsGleipnir then
				local distance = Min(GetUnitToUnitDistance(bot, botTarget), nCastRange)
				return BOT_ACTION_DESIRE_HIGH, J.VectorTowards(bot:GetLocation(), botTarget:GetLocation(), distance), ITEM_TARGET_TYPE_POINT
			else
				if J.CanCastOnTargetAdvanced(botTarget) and J.IsInRange(bot, botTarget, nCastRange) then
					return BOT_ACTION_DESIRE_HIGH, botTarget, ITEM_TARGET_TYPE_UNIT
				end
			end
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnNonMagicImmune(enemyHero)
			and not J.IsDisabled(enemyHero)
            and not enemyHero:IsDisarmed()
			and not enemyHero:HasModifier('modifier_bloodseeker_rupture')
			and bot:WasRecentlyDamagedByHero(enemyHero, 3.0)
            then
				if bIsGleipnir then
					local nLocationAoE = bot:FindAoELocation(true, true, enemyHero:GetLocation(), 0, nRadius, 0, 0)
					if nLocationAoE.count >= 2 or botHP < 0.5 then
						return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, ITEM_TARGET_TYPE_POINT
					end
				else
					if J.CanCastOnTargetAdvanced(enemyHero) then
						return BOT_ACTION_DESIRE_HIGH, enemyHero, ITEM_TARGET_TYPE_UNIT
					end
				end
            end
        end
    end

	return BOT_ACTION_DESIRE_NONE
end

X.ConsiderItemDesire["item_satanic"] = function( hItem )

	if J.IsGoingOnSomeone(bot) then
		if J.IsValid(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, botAttackRange + 150)
		and not J.IsChasingTarget(bot, botTarget)
		and not bot:IsDisarmed()
		and botHP < 0.65
		and bAttacking
		then
			if J.IsValidHero(botTarget) and not J.IsSuspiciousIllusion(botTarget) then
				return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
			end

			if botTarget:IsCreep() and botHP < 0.2 then
				return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

X.ConsiderItemDesire["item_sheepstick"] = function( hItem )

	local nCastRange = hItem:GetCastRange()

	for _, enemyHero in pairs(nEnemyHeroes) do
		if J.IsValidHero(enemyHero)
		and J.CanBeAttacked(enemyHero)
		and J.IsInRange(bot, enemyHero, nCastRange + 300)
		and J.CanCastOnNonMagicImmune(enemyHero)
		and J.CanCastOnTargetAdvanced(enemyHero)
		and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			if enemyHero:IsChanneling() or enemyHero:IsCastingAbility() then
				return BOT_ACTION_DESIRE_HIGH, enemyHero, ITEM_TARGET_TYPE_UNIT
			end

			if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
				if J.IsValidHero(enemyHero)
				and J.CanBeAttacked(enemyHero)
				and J.IsInRange(bot, enemyHero, nCastRange)
				and not J.IsDisabled(enemyHero)
				and not enemyHero:IsDisarmed()
				and bot:WasRecentlyDamagedByHero(enemyHero, 2.0)
				then
					return BOT_ACTION_DESIRE_HIGH, enemyHero, ITEM_TARGET_TYPE_UNIT
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
		and not J.IsDisabled(botTarget)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget, ITEM_TARGET_TYPE_UNIT
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

X.ConsiderItemDesire["item_ward_sentry"] = function( hItem )

	local nCastRange = hItem:GetCastRange() 

	if J.IsGoingOnSomeone(bot) then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if J.IsValidHero(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange)
			and X.HasInvisibilityOrItem(enemyHero)
			and not J.IsSuspiciousIllusion(enemyHero)
			and not enemyHero:HasModifier('modifier_truesight')
			and not enemyHero:HasModifier('modifier_slardar_amplify_damage')
			and not enemyHero:HasModifier('modifier_item_dustofappearance')
			then
				local vLocation = enemyHero:GetLocation()
				if not J.Site.IsLocationHaveTrueSight(vLocation) then
					return BOT_ACTION_DESIRE_HIGH, vLocation, ITEM_TARGET_TYPE_POINT
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

X.ConsiderItemDesire["item_shadow_amulet"] = function( hItem )

	local nCastRange = hItem:GetCastRange()

	if not J.IsRealInvisible(bot) then
		for _, enemy in pairs(nEnemyHeroes) do
			if  J.IsValidHero(enemy)
			and (enemy:GetAttackTarget() == bot
				or enemy:IsFacingLocation(bot:GetLocation(), 30)
				or bot:WasRecentlyDamagedByHero(enemy, 3.0))
			then
				if not J.IsGoingOnSomeone(bot) and not bAttacking then
					return BOT_ACTION_DESIRE_HIGH, bot, ITEM_TARGET_TYPE_UNIT
				end
			end
		end

		if bot:IsRooted()
		or J.IsStunProjectileIncoming(bot, 1000)
		then
			return BOT_ACTION_DESIRE_HIGH, bot, ITEM_TARGET_TYPE_UNIT
		end

		for _, allyHero in pairs(nAllyHeroes) do
			if J.IsValidHero(allyHero)
			and J.CanBeAttacked(allyHero)
			and allyHero ~= bot
			and J.IsInRange(bot, allyHero, nCastRange)
			and not J.IsRealInvisible(allyHero)
			and not allyHero:IsIllusion()
			and not allyHero:IsMagicImmune()
			and not allyHero:HasModifier('modifier_abaddon_borrowed_time')
			and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			then
				if J.IsDisabled(allyHero)
				or J.IsStunProjectileIncoming(allyHero, 1000)
				or (allyHero:HasModifier('modifier_teleporting') and allyHero:WasRecentlyDamagedByAnyHero(8.0))
				then
					return BOT_ACTION_DESIRE_HIGH, allyHero, ITEM_TARGET_TYPE_UNIT
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

X.ConsiderItemDesire["item_invis_sword"] = function( hItem )

	if J.IsRealInvisible(bot)
	or bot:DistanceFromFountain() < 1200
	then
		return BOT_ACTION_DESIRE_NONE
	end

	local bIsSilverEdge = hItem:GetName() == 'item_silver_edge'

	if J.IsRetreating(bot) and #nEnemyHeroes > 0 and not bAttacking then
		return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
	end

	if botHP < 0.2 and not bAttacking then
		if #nEnemyHeroes > 0 or bot:WasRecentlyDamagedByAnyHero(5.0) then
			return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if 	J.IsValidHero(botTarget)
		and J.IsInRange(bot, botTarget, 3200)
		and not J.IsSuspiciousIllusion(botTarget)
		then
			if not J.IsInRange(bot, botTarget, botTarget:GetCurrentVisionRange()) then
				local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(800, true)
				local nEnemyTowers = bot:GetNearbyTowers(800, true)
				if #nEnemyHeroes == 0 and #nEnemyLaneCreeps == 0 and #nEnemyTowers == 0 then
					return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
				end
			end

			if bIsSilverEdge and bAttacking then
				if  J.CanBeAttacked(botTarget)
				and J.IsInRange(bot, botTarget, botAttackRange + 150)
				and J.IsCore(botTarget)
				and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
				and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
				and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
				and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
				then
					local sBotTargetName = botTarget:GetUnitName()
					if (sBotTargetName == 'npc_dota_hero_bristleback')
					or (sBotTargetName == 'npc_dota_hero_dragon_knight')
					or (sBotTargetName == 'npc_dota_hero_elder_titan')
					or (sBotTargetName == 'npc_dota_hero_huskar')
					or (sBotTargetName == 'npc_dota_hero_life_stealer')
					or (sBotTargetName == 'npc_dota_hero_sven')
					or (sBotTargetName == 'npc_dota_hero_tidehunter')
					or (sBotTargetName == 'npc_dota_hero_shredder')
					or (sBotTargetName == 'npc_dota_hero_abyssal_underlord')
					or (sBotTargetName == 'npc_dota_hero_monkey_king')
					or (sBotTargetName == 'npc_dota_hero_phantom_assassin')
					or (sBotTargetName == 'npc_dota_hero_spectre')
					or (sBotTargetName == 'npc_dota_hero_troll_warlord')
					or (sBotTargetName == 'npc_dota_hero_ursa')
					or (sBotTargetName == 'npc_dota_hero_abaddon')
					or (botTarget:GetCurrentMovementSpeed() >= 450)
					then
						return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
					end
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

X.ConsiderItemDesire["item_shivas_guard"] = function( hItem )

	local nRadius = hItem:GetSpecialValueInt('blast_radius')

	local nInRangeEnemy = J.GetEnemiesNearLoc(botLocation, nRadius)

	if J.IsInTeamFight(bot, 1200) then
        if #nInRangeEnemy >= 2 then
            local count = 0
            for _, enemyHero in pairs(nInRangeEnemy) do
                if J.IsValidHero(enemyHero)
                and J.CanBeAttacked(enemyHero)
                and J.CanCastOnNonMagicImmune(enemyHero)
				and not enemyHero:HasModifier('modifier_doom_bringer_doom_aura_enemy')
				and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
				and not enemyHero:HasModifier('modifier_ice_blast')
				and not enemyHero:HasModifier('modifier_item_spirit_vessel_damage')
                then
                    count = count + 1
                end
            end

            if count >= 2 then
                return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
            end
        end
    end

    if J.IsGoingOnSomeone(bot) then
        if  J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nRadius * 0.5)
        and J.CanCastOnNonMagicImmune(botTarget)
        and not J.IsDisabled(botTarget)
        and not botTarget:HasModifier('modifier_doom_bringer_doom_aura_enemy')
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		and not botTarget:HasModifier('modifier_ice_blast')
		and not botTarget:HasModifier('modifier_item_spirit_vessel_damage')
        then
			if J.IsChasingTarget(bot, botTarget) or #nInRangeEnemy >= 2 then
				return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
			end
        end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
        for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
            and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nRadius * 0.8)
            and J.CanCastOnNonMagicImmune(enemyHero)
			and not J.IsDisabled(enemyHero)
            and not enemyHero:IsDisarmed()
			and bot:WasRecentlyDamagedByHero(enemyHero, 3.0)
            then
                return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
            end
        end
    end

	local nEnemyCreeps = bot:GetNearbyCreeps(nRadius, true)

	if (J.IsPushing(bot) or J.IsDefending(bot)) and bAttacking and #nAllyHeroes <= 1 and #nInRangeEnemy == 0 then
		if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
			if #nEnemyCreeps >= 5 then
				return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
			end
		end
	end

	if J.IsFarming(bot) and bAttacking and #nAllyHeroes <= 1 and #nInRangeEnemy == 0 then
		if J.IsValid(nEnemyCreeps[1]) and J.CanBeAttacked(nEnemyCreeps[1]) then
			if (#nEnemyCreeps >= 3)
			or (#nEnemyCreeps >= 2 and nEnemyCreeps[1]:IsAncientCreep())
			then
				return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

X.ConsiderItemDesire["item_silver_edge"] = function( hItem )

	return X.ConsiderItemDesire["item_invis_sword"]( hItem )

end

X.ConsiderItemDesire['item_smoke_of_deceit'] = function( hItem )
	local nRadius = hItem:GetSpecialValueInt('application_radius')

	local bEnemyNearby = false
	local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), nRadius)
	local nEnemyTowers = bot:GetNearbyTowers(1600, true)

	if DotaTime() > -60 and DotaTime() < 0 then
		return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
	end

	if #nEnemyHeroes == 0 and #nEnemyTowers == 0 then
		for _, allyHero in pairs(nInRangeAlly) do
			if J.IsValidHero(allyHero) then
				local nInRangeEnemy = allyHero:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
				local nInRangeTower = allyHero:GetNearbyTowers(1600, true)

				if (#nInRangeEnemy >= 1)
				or (#nInRangeTower >= 1)
				then
					bEnemyNearby = true
					break
				end
			end
		end
	end

	if not bEnemyNearby then
		if #nInRangeAlly >= 2 and (botActiveMode == BOT_MODE_ROAM or botActiveMode == BOT_MODE_GANK) then
			if J.IsValidHero(nInRangeAlly[2])
			and J.IsRunning(nInRangeAlly[2])
			then
				return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
			end
		end
		
		if GetUnitToLocationDistance(bot, vLocationRoshan) <= 550 and not J.IsRoshanAlive() then
			return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
		end
		
		local nAliveEnemies = J.GetNumOfAliveHeroes(true)

		if J.IsDoingRoshan(bot) and #nInRangeAlly >= 2 then
			if J.IsValidHero(nInRangeAlly[2])
			and J.IsRunning(nInRangeAlly[2])
			and nAliveEnemies >= 3
			then
				if GetUnitToLocationDistance(bot, vLocationRoshan) > 3000 then
					return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
				end
			end
		end
	end
	
	return BOT_ACTION_DESIRE_NONE
end

X.ConsiderItemDesire["item_solar_crest"] = function( hItem )

	return X.ConsiderItemDesire["item_pavise"]( hItem )

end

X.ConsiderItemDesire['item_soul_ring'] = function( hItem )

	local nHealthCost = hItem:GetSpecialValueInt('AbilityHealthCost')
	local fHealthAfter = J.GetHealthAfter(nHealthCost)

	if fHealthAfter > 0.25 and botMP < 0.5 and not J.IsRealInvisible(bot) and bot:DistanceFromFountain() > 3500 then
		return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
	end

	return BOT_ACTION_DESIRE_NONE
end

X.ConsiderItemDesire["item_spirit_vessel"] = function( hItem )

	local nCastRange = hItem:GetCastRange()
	local nCharges = hItem:GetCurrentCharges()

	if nCharges == 0 then
		return BOT_ACTION_DESIRE_NONE
	end

	if J.IsInTeamFight(bot, 1200) then
		for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
			and J.IsInRange(bot, enemyHero, nCastRange + 150)
			and J.CanCastOnNonMagicImmune(enemyHero)
			and J.CanCastOnTargetAdvanced(enemyHero)
			and not enemyHero:HasModifier('modifier_arc_warden_tempest_double')
			and not enemyHero:HasModifier('modifier_doom_bringer_doom_aura_enemy')
            and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
            and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
			and not enemyHero:HasModifier('modifier_ice_blast')
            and not enemyHero:HasModifier('modifier_item_aeon_disk_buff')
			and not enemyHero:HasModifier('modifier_item_urn_damage')
			and not enemyHero:HasModifier('modifier_item_spirit_vessel_damage')
			and not enemyHero:HasModifier('modifier_teleporting')
            then
				local sEnemyHeroName = enemyHero:GetUnitName()
				if sEnemyHeroName == 'npc_dota_hero_bristleback'
				or sEnemyHeroName == 'npc_dota_hero_huskar'
				or sEnemyHeroName == 'npc_dota_hero_dragon_knight'
				or sEnemyHeroName == 'npc_dota_hero_tidehunter'
				or sEnemyHeroName == 'npc_dota_hero_morphling'
				or sEnemyHeroName == 'npc_dota_hero_mars'
				or sEnemyHeroName == 'npc_dota_hero_centaur'
				or sEnemyHeroName == 'npc_dota_hero_necrolyte'
				or enemyHero:HasModifier('modifier_alchemist_chemical_rage')
				or enemyHero:HasModifier('modifier_enchantress_natures_attendants')
				or enemyHero:HasModifier('modifier_legion_commander_press_the_attack')
				or enemyHero:HasModifier('modifier_pugna_life_drain')
				or enemyHero:HasModifier('modifier_item_bloodstone_active')
				or enemyHero:HasModifier('modifier_item_satanic_unholy')
				then
					return BOT_ACTION_DESIRE_HIGH, enemyHero, ITEM_TARGET_TYPE_UNIT
				end
            end
        end
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange + 300)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.CanCastOnTargetAdvanced(botTarget)
		and not botTarget:HasModifier('modifier_arc_warden_tempest_double')
		and not botTarget:HasModifier('modifier_doom_bringer_doom_aura_enemy')
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
		and not botTarget:HasModifier('modifier_ice_blast')
		and not botTarget:HasModifier('modifier_item_urn_damage')
		and not botTarget:HasModifier('modifier_item_spirit_vessel_damage')
		and not botTarget:HasModifier('modifier_item_aeon_disk_buff')
		and not botTarget:HasModifier('modifier_teleporting')
		then
			if J.GetHP(botTarget) > 0.4 then
				return BOT_ACTION_DESIRE_HIGH, botTarget, ITEM_TARGET_TYPE_UNIT
			end
		end
	end

	if nCharges >= 2 then
		local hNeedHealAlly = nil
		local hNeedHealAllyHP = 99999
		for _, allyHero in pairs(nAllyHeroes) do
			if J.IsValidHero(allyHero)
			and J.CanBeAttacked(allyHero)
			and J.IsInRange(bot, allyHero, nCastRange + 300)
			and allyHero:DistanceFromFountain() > 3200
			and not allyHero:IsIllusion()
			and not allyHero:WasRecentlyDamagedByAnyHero(5.0)
			and not allyHero:HasModifier('modifier_alchemist_chemical_rage')
			and not allyHero:HasModifier('modifier_arc_warden_tempest_double')
			and not allyHero:HasModifier('modifier_doom_bringer_doom_aura_enemy')
			and not allyHero:HasModifier('modifier_enchantress_natures_attendants')
			and not allyHero:HasModifier('modifier_juggernaut_healing_ward_heal')
			and not allyHero:HasModifier('modifier_legion_commander_press_the_attack')
			and not allyHero:HasModifier('modifier_naga_siren_song_of_the_siren_healing')
			and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			and not allyHero:HasModifier('modifier_oracle_false_promise_timer')
			and not allyHero:HasModifier('modifier_pugna_life_drain')
			and not allyHero:HasModifier('modifier_ice_blast')
			and not allyHero:HasModifier('modifier_item_urn_damage')
			and not allyHero:HasModifier('modifier_item_spirit_vessel_damage')
			and not allyHero:HasModifier('modifier_item_aeon_disk_buff')
			and not allyHero:HasModifier('modifier_item_bloodstone_active')
			and not allyHero:HasModifier('modifier_item_satanic_unholy')
			and not allyHero:HasModifier('modifier_flask_healing')
			and not allyHero:HasModifier('modifier_fountain_aura_buff')
			and not allyHero:HasModifier('modifier_rune_regen')
			and bot:GetAbilityByName('slark_shadow_dance') == nil
			and #nEnemyHeroes == 0
			then
				local allyHeroHP = J.GetHP(allyHero)
				if allyHeroHP < hNeedHealAllyHP and allyHeroHP < 0.6 then
					hNeedHealAlly = allyHero
					hNeedHealAllyHP = allyHeroHP
				end
			end
		end

		if hNeedHealAlly then
			return BOT_ACTION_DESIRE_HIGH, hNeedHealAlly, ITEM_TARGET_TYPE_UNIT
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

X.ConsiderItemDesire["item_swift_blink"] = function( hItem )

	return X.ConsiderItemDesire["item_blink"]( hItem )

end

X.ConsiderItemDesire["item_tango"] = function( hItem )

	local nCastRange = hItem:GetCastRange()
	local nDuration = hItem:GetSpecialValueInt('buff_duration')
	local nRegen = hItem:GetSpecialValueInt('health_regen')

	local nCharges = hItem:GetCurrentCharges()
	local sItemName = hItem:GetName()

	if nCharges > 0 and DotaTime() > 0 and sItemName == 'item_tango' then
		if J.IsInLaningPhase() and (#nEnemyHeroes == 0 or J.IsLaning(bot)) then
			for _, allyHero in pairs(nAllyHeroes) do
				if J.IsValidHero(allyHero)
				and allyHero ~= bot
				and J.IsInRange(bot, allyHero, nCastRange + 500)
				and not J.IsSuspiciousIllusion(allyHero)
				and not J.IsMeepoClone(allyHero)
				and not allyHero:HasModifier('modifier_doom_bringer_doom_aura_enemy')
				and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
				and not allyHero:HasModifier('modifier_ice_blast')
				and not allyHero:HasModifier('modifier_tango_heal')
				and not allyHero:HasModifier('modifier_teleporting')
				and not allyHero:HasModifier('modifier_fountain_aura_buff')
				and J.Item.GetEmptyInventoryAmount(allyHero) >= 4
				then
					local tangoSlot = allyHero:FindItemSlot('item_tango')
					if  tangoSlot == -1 then
						tangoSlot = allyHero:FindItemSlot('item_tango_single')
						if tangoSlot == -1 then
							if allyHero:GetMaxHealth() - allyHero:GetHealth() > (nRegen * nDuration * 2) then
								return BOT_ACTION_DESIRE_HIGH, allyHero, ITEM_TARGET_TYPE_UNIT
							end
						end
					end
				end
			end
		end
	end

	if bot:HasModifier('modifier_doom_bringer_doom_aura_enemy')
	or bot:HasModifier('modifier_ice_blast')
	or bot:HasModifier('modifier_tango_heal')
	or bot:HasModifier('modifier_fountain_aura_buff')
	or bot:DistanceFromFountain() < 4000
	then
		return BOT_ACTION_DESIRE_NONE
	end

	if bot:GetMaxHealth() - bot:GetHealth() > (nRegen * nDuration * 2) then
		local nTrees = bot:GetNearbyTrees(Min(nCastRange + 500, 1600))
		local nEnemyTowers = bot:GetNearbyTowers(1600, true)

		for _, tree in pairs(nTrees) do
			if tree then
				local vLocation = GetTreeLocation(tree)
				if IsLocationPassable(vLocation) and IsLocationVisible(vLocation) then
					if (#nEnemyHeroes == 0 or (J.IsValidHero(nEnemyHeroes[1]) and (GetUnitToLocationDistance(bot, vLocation) * 1.6 < GetUnitToUnitDistance(bot, nEnemyHeroes[1]))))
					or (#nEnemyTowers == 0 or (J.IsValidBuilding(nEnemyTowers[1]) and GetUnitToLocationDistance(nEnemyTowers[1], vLocation) > 900))
					then
						return BOT_ACTION_DESIRE_HIGH, tree, ITEM_TARGET_TYPE_TREE
					end
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

X.ConsiderItemDesire["item_tango_single"] = function( hItem )

	return X.ConsiderItemDesire["item_tango"]( hItem )

end

X.ConsiderItemDesire["item_tpscroll"] = function( hItem )
	if (J.IsGoingToRune(bot))
	or (bot:IsRooted())
	or (bot:HasModifier('modifier_item_armlet_unholy_strength'))
	or (bot:HasModifier('modifier_kunkka_x_marks_the_spot'))
	or (bot:HasModifier('modifier_sniper_assassinate'))
	or (bot:HasModifier('modifier_viper_nethertoxin'))
	or (bot:HasModifier('modifier_item_helm_of_the_undying_active'))
	or (bot:HasModifier('modifier_spirit_breaker_charge_of_darkness'))
	or (bot:HasModifier('modifier_arc_warden_tempest_double') and bot:GetRemainingLifespan() < 3.3)
	or (bot:HasModifier('modifier_oracle_false_promise_timer') and J.GetModifierTime(bot, "modifier_oracle_false_promise_timer" ) <= 3.2)
	or (J.GetModifierTime(bot, 'modifier_jakiro_macropyre_burn') >= 1.4)
	or (J.IsRoshanAlive() and GetUnitToLocationDistance(bot, vLocationRoshan) <= 1600)
	then
		return BOT_ACTION_DESIRE_NONE
	end

	if not bot:IsMagicImmune() then
		if J.IsStunProjectileIncoming(bot, 1200)
		or bot:HasModifier('modifier_enigma_malefice')
		then
			return BOT_ACTION_DESIRE_NONE
		end
	end

	local hAbility = bot:GetAbilityByName('alchemist_unstable_concoction')
	if hAbility and hAbility:IsTrained() then
		if hAbility:GetCooldown() - hAbility:GetCooldownTimeRemaining() < 5 then
			return BOT_ACTION_DESIRE_NONE
		end
	end

	hAbility = bot:GetAbilityByName('ancient_apparition_ice_blast_release')
	if J.CanCastAbility(hAbility) then
		return BOT_ACTION_DESIRE_NONE
	end

	local botHealth = bot:GetHealth()

	if botHealth < 500 then
		local damage = J.GetAttackProjectileDamageByRange(bot, 1600) * 2
		if botHealth < bot:GetActualIncomingDamage(damage, DAMAGE_TYPE_PHYSICAL) then
			return BOT_ACTION_DESIRE_NONE
		end
	end

	local nEnemyTowers = bot:GetNearbyTowers(900, true)
	if #nEnemyTowers > 0 and bot:WasRecentlyDamagedByTower(4.0) then
		return BOT_ACTION_DESIRE_NONE
	end

	-- stunning creep
	local nEnemyCreeps = bot:GetNearbyCreeps(800, true)
	local bAnnoyingCreep = false
	for _, creep in pairs(nEnemyCreeps) do
		if J.IsValid(creep) then
			if creep:GetAttackTarget() == bot
			or J.IsChasingTarget(creep, bot)
			then
				local sCreepName = creep:GetUnitName()
				if sCreepName == 'npc_dota_neutral_ogre_mauler' then
					bAnnoyingCreep = true
				end
			end
		end
	end

	if bAnnoyingCreep and bot:WasRecentlyDamagedByCreep(6.0) then
		return BOT_ACTION_DESIRE_NONE
	end

	-- might get killed by units attacking me
	local unitListAttacking = {}
	local unitList = GetUnitList(UNIT_LIST_ALL)
    for _, unit in pairs(unitList) do
        if J.IsValid(unit) and GetTeam() ~= unit:GetTeam() and J.IsInRange(bot, unit, 1600) then
			if unit:GetAttackTarget() == bot
			or J.IsChasingTarget(unit, bot)
			or (unit:IsHero() and bot:WasRecentlyDamagedByHero(unit, 3.0))
			then
				table.insert(unitListAttacking, unit)
			end
		end
    end

	local unitListAttackDamage = J.GetUnitListTotalAttackDamage(unitListAttacking, 5.0)
	if J.WillKillTarget(bot, unitListAttackDamage, DAMAGE_TYPE_PHYSICAL, 5.0) then
		return BOT_ACTION_DESIRE_NONE
	end

	local vLocation = nil
	local nMinTPDistance = 5500
	local botActiveModeDesire = bot:GetActiveModeDesire()
	local botLevel = bot:GetLevel()
	local nEnemyCount = X.GetNumHeroWithinRange(1600)
	local nAllyCount = J.GetAllyCount(bot, 1600)

	local Salve = J.IsItemAvailable('item_flask')

	if J.IsRetreating(bot)
	and botActiveModeDesire > BOT_MODE_DESIRE_MODERATE
	and botActiveModeDesire <= BOT_MODE_DESIRE_ABSOLUTE
	and bot:GetLevel() >= 3
	and not bot:HasModifier('modifier_arc_warden_tempest_double')
	then
		if botHP < 0.19
		and (bot:WasRecentlyDamagedByAnyHero(8.0) or botHP < 0.12)
		and (botName ~= 'npc_dota_hero_slark' or bot:GetLevel() <= 5)
		and botName ~= 'npc_dota_hero_huskar'
		and nEnemyCount == 0
		and Salve == nil
		and not bot:HasModifier('modifier_tango_heal')
		and not bot:HasModifier('modifier_flask_healing')
		and not bot:HasModifier('modifier_juggernaut_healing_ward_heal')
		and not bot:HasModifier('modifier_item_urn_heal')
		and not bot:HasModifier('modifier_item_spirit_vessel_heal')
		and not bot:HasModifier('modifier_fountain_aura_buff')
		and bot:DistanceFromFountain() > nMinTPDistance
		then
			return BOT_ACTION_DESIRE_HIGH, J.GetTeamFountain(), ITEM_TARGET_TYPE_POINT
		end

		local nInRangeAlly_Attacking = J.GetSpecialModeAllies(bot, 1200, BOT_MODE_ATTACK)
		if botHP < (0.15 + 0.24 * nEnemyCount)
		and #nInRangeAlly_Attacking == 0
		and bot:WasRecentlyDamagedByAnyHero(6.0)
		and nEnemyCount <= (botHP < 0.4 and 2 or 3)
		and nAllyCount <= 2
		and Salve == nil
		and not bot:HasModifier('modifier_tango_heal')
		and not bot:HasModifier('modifier_flask_healing')
		and not bot:HasModifier('modifier_item_urn_heal')
		and not bot:HasModifier('modifier_item_spirit_vessel_heal')
		and not bot:HasModifier('modifier_juggernaut_healing_ward_heal')
		and bot:DistanceFromFountain() > nMinTPDistance - 600
		then
			return BOT_ACTION_DESIRE_HIGH, J.GetTeamFountain(), ITEM_TARGET_TYPE_POINT
		end

		if (botHP < 0.34 or botHP + botMP < 0.43)
		and #nInRangeAlly_Attacking == 0
		and not J.IsInLaningPhase()
		and nEnemyCount <= 1
		and nAllyCount <= 2
		and Salve == nil
		and botTarget == nil
		and botName ~= 'npc_dota_hero_huskar'
		and botName ~= 'npc_dota_hero_slark'
		and not bot:HasModifier('modifier_flask_healing')
		and not bot:HasModifier('modifier_clarity_potion')
		and not bot:HasModifier('modifier_filler_heal')
		and not bot:HasModifier('modifier_item_urn_heal')
		and not bot:HasModifier('modifier_item_spirit_vessel_heal')
		and not bot:HasModifier('modifier_juggernaut_healing_ward_heal')
		and not bot:HasModifier('modifier_bottle_regeneration')
		and not bot:HasModifier('modifier_tango_heal')
		and not bot:HasModifier('modifier_fountain_aura_buff')
		and bot:DistanceFromFountain() > nMinTPDistance - 600
		then
			return BOT_ACTION_DESIRE_HIGH, J.GetTeamFountain(), ITEM_TARGET_TYPE_POINT
		end

		if  ((botHP + botMP) < 0.3 or botHP < 0.2)
		and bot:GetLevel() >= 6
		and botName ~= 'npc_dota_hero_huskar'
		and botName ~= 'npc_dota_hero_slark'
		and bot:IsFacingLocation(J.GetTeamFountain(), 25)
		and not bot:HasModifier('modifier_arc_warden_tempest_double')
		and J.IsRunning(bot)
		then
			if	bot:DistanceFromFountain() > nMinTPDistance
			and nEnemyCount <= 1 and nAllyCount <= 1
			and botTarget == nil
			and Salve == nil
			and bot:GetAttackTarget() == nil
			and not bot:HasModifier('modifier_flask_healing')
			and not bot:HasModifier('modifier_clarity_potion')
			and not bot:HasModifier('modifier_filler_heal')
			and not bot:HasModifier('modifier_item_urn_heal')
			and not bot:HasModifier('modifier_item_spirit_vessel_heal')
			and not bot:HasModifier('modifier_juggernaut_healing_ward_heal')
			and not bot:HasModifier('modifier_bottle_regeneration')
			and not bot:HasModifier('modifier_tango_heal')
			and not bot:HasModifier('modifier_fountain_aura_buff')
			then
				return BOT_ACTION_DESIRE_HIGH, J.GetTeamFountain(), ITEM_TARGET_TYPE_POINT
			end
		end
	end

	if J.IsPushing(bot)
	and botActiveModeDesire >= BOT_MODE_DESIRE_MODERATE
	and nEnemyCount == 0
	then
		local nPushLane = LANE_MID
		if botActiveMode == BOT_MODE_PUSH_TOWER_TOP then nPushLane = LANE_TOP end
		if botActiveMode == BOT_MODE_PUSH_TOWER_BOT then nPushLane = LANE_BOT end

		vLocation = nil
		local nAmountAlongLane = GetAmountAlongLane(nPushLane, botLocation)
		local fLaneFrontAmount = GetLaneFrontAmount(GetTeam(), nPushLane, false)
		if nAmountAlongLane.distance > nMinTPDistance
		or nAmountAlongLane.amount < fLaneFrontAmount / 5
		then
			vLocation = X.GetPushTPLocation(nPushLane)
		end

		if vLocation and GetUnitToLocationDistance(bot, vLocation) > nMinTPDistance - 600 then
			return BOT_ACTION_DESIRE_HIGH, vLocation, ITEM_TARGET_TYPE_POINT
		end
	end

	if J.IsDefending(bot)
	and botActiveModeDesire >= BOT_MODE_DESIRE_MODERATE
	and nEnemyCount == 0
	then
		local nDefendLane = LANE_MID
		if botActiveMode == BOT_MODE_DEFEND_TOWER_TOP then nDefendLane = LANE_TOP end
		if botActiveMode == BOT_MODE_DEFEND_TOWER_BOT then nDefendLane = LANE_BOT end

		vLocation = X.GetDefendTPLocation(nDefendLane)

		if vLocation and GetUnitToLocationDistance(bot, vLocation) > nMinTPDistance - 500 then
			return BOT_ACTION_DESIRE_HIGH, vLocation, ITEM_TARGET_TYPE_POINT
		end
	end

	if J.IsFarming(bot)
	and not X.IsBaseTowerDestroyed()
	and botHP > 0.75
	and botMP > 0.75
	then
		local nLane, nDesire = J.GetMostFarmLaneDesire()
		if nDesire >= BOT_MODE_DESIRE_HIGH then
			local vLaneFrontLocation = GetLaneFrontLocation(GetTeam(), nLane, 0)
			vLocation = J.GetNearbyLocationToTp(vLaneFrontLocation)
			if vLocation and GetUnitToLocationDistance(bot, vLocation) > nMinTPDistance then
				local nInRangeAlly = J.GetAlliesNearLoc(vLaneFrontLocation, 1200)
				if #nInRangeAlly == 0 then
					if J.GetDistance(vLocation, vLaneFrontLocation) <= 1200 then
						return BOT_ACTION_DESIRE_HIGH, vLocation, ITEM_TARGET_TYPE_POINT
					end

					if J.IsItemAvailable('item_travel_boots')
					or J.IsItemAvailable('item_travel_boots_2')
					then
						return BOT_ACTION_DESIRE_HIGH, vLaneFrontLocation, ITEM_TARGET_TYPE_POINT
					end
				end
			end
		end
	end

	if J.IsLaning(bot) and J.IsInLaningPhase() then
		vLocation = X.GetLaningTPLocation(bot, nMinTPDistance, botLocation)
		if vLocation then
			return BOT_ACTION_DESIRE_HIGH, vLocation, ITEM_TARGET_TYPE_POINT
		end
	end

	if J.IsDoingRoshan(bot)
	and nEnemyCount == 0
	and not J.IsRoshanCloseToChangingSides()
	then
		vLocation = J.GetNearbyLocationToTp(vLocationRoshan)
		local location1 = GetUnitToLocationDistance(bot, vLocation)
		local location2 = GetUnitToLocationDistance(bot, vLocationRoshan)
		local location3 = J.GetDistance(vLocation, vLocationRoshan)

		if  location1 > 5000
		and location2 > 5000
		and location2 > location1
		and location3 <= 4500
		then
			return BOT_ACTION_DESIRE_HIGH, vLocation, ITEM_TARGET_TYPE_POINT
		end
	end

	if  J.IsDoingTormentor(bot)
	and nEnemyCount == 0
	and   (not J.IsInTeamFight(bot, 1200)
		or not J.IsGoingOnSomeone(bot)
		or not J.IsDefending(bot))
	then
		vLocation = J.GetNearbyLocationToTp(vLocationTormentor)
		local location1 = GetUnitToLocationDistance(bot, vLocation)
		local location2 = GetUnitToLocationDistance(bot, vLocationTormentor)
		local location3 = J.GetDistance(vLocation, vLocationTormentor)

		if location1 > 4500 and location2 > location3 then
			return BOT_ACTION_DESIRE_HIGH, vLocation, ITEM_TARGET_TYPE_POINT
		end
	end

	if botActiveMode == BOT_MODE_DEFEND_ALLY
	and botActiveModeDesire >= BOT_MODE_DESIRE_HIGH
	and nEnemyCount == 0
	and (not J.IsCore(bot) or J.IsLateGame())
	then
		if J.IsValidHero(botTarget)
		and not J.IsInRange(bot, botTarget, nMinTPDistance)
		and not J.IsSuspiciousIllusion(botTarget)
		then
			vLocation = J.GetNearbyLocationToTp(botTarget:GetLocation())
			if vLocation and GetUnitToLocationDistance(bot, vLocation) > nMinTPDistance - 800 then
				return BOT_ACTION_DESIRE_HIGH, vLocation, ITEM_TARGET_TYPE_POINT
			end
		end
	end

	if  not J.IsEarlyGame()
	and not J.IsDoingRoshan(bot)
	and not J.IsDoingTormentor(bot)
	then
		if botName == 'npc_dota_hero_spectre' then
			local ShadowStep = bot:GetAbilityByName('spectre_shadow_step')
			local Haunt = bot:GetAbilityByName('spectre_haunt')
			if (J.CanCastAbility(ShadowStep))
			or (J.CanCastAbility(Haunt))
			then
				return BOT_ACTION_DESIRE_NONE
			end
		end

		local KeenConveyance = bot:GetAbilityByName('tinker_keen_teleport')

		local bCanTravelFast = false
		if (J.IsItemAvailable('item_travel_boots_2'))
		or (J.CanCastAbility(KeenConveyance) and KeenConveyance:GetLevel() >= 3)
		then
			bCanTravelFast = true
		end

		for i = 1, 5 do
			local allyHero = GetTeamMember(i)
			if J.IsValidHero(allyHero) and bot ~= allyHero and J.IsInTeamFight(allyHero, 1200) then
				local allyHeroLocation = allyHero:GetLocation()

				if #nEnemyHeroes == 0 and GetUnitToLocationDistance(bot, allyHeroLocation) > 3200 then
					if bCanTravelFast then
						return BOT_ACTION_DESIRE_HIGH, allyHeroLocation, ITEM_TARGET_TYPE_POINT
					end
		
					vLocation = J.GetNearbyLocationToTp(allyHeroLocation)
					if vLocation
					and J.GetDistance(vLocation, allyHeroLocation) < 1800
					and GetUnitToLocationDistance(bot, vLocation) > nMinTPDistance - 1200
					then
						return BOT_ACTION_DESIRE_HIGH, vLocation, ITEM_TARGET_TYPE_POINT
					end
				end
			end
		end
	end

	if  J.GetModifierTime(bot, 'modifier_bloodseeker_rupture') >= 3.1
	and bot:WasRecentlyDamagedByAnyHero(3.0)
	and nEnemyCount >= 1
	and nAllyCount <= 1
	then
		return BOT_ACTION_DESIRE_HIGH, J.GetTeamFountain(), ITEM_TARGET_TYPE_POINT
	end

	if J.IsStuck(bot) then
		vLocation = J.GetNearbyLocationToTp(botLocation)
		if vLocation then
			local nInRangeEnemy = J.GetEnemiesNearLoc(vLocation, 1600)
			if #nInRangeEnemy > 0 then
				vLocation = J.GetTeamFountain()
			end

			return BOT_ACTION_DESIRE_HIGH, vLocation, ITEM_TARGET_TYPE_POINT
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

X.ConsiderItemDesire["item_urn_of_shadows"] = function( hItem )

	local nCastRange = hItem:GetCastRange()
	local nCharges = hItem:GetCurrentCharges()

	if nCharges == 0 then
		return BOT_ACTION_DESIRE_NONE
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange + 150)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.CanCastOnTargetAdvanced(botTarget)
		and not botTarget:HasModifier('modifier_arc_warden_tempest_double')
		and not botTarget:HasModifier('modifier_doom_bringer_doom_aura_enemy')
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		and not botTarget:HasModifier('modifier_oracle_false_promise_timer')
		and not botTarget:HasModifier('modifier_ice_blast')
		and not botTarget:HasModifier('modifier_item_urn_damage')
		and not botTarget:HasModifier('modifier_item_spirit_vessel_damage')
		and not botTarget:HasModifier('modifier_item_aeon_disk_buff')
		and not botTarget:HasModifier('modifier_teleporting')
		then
			if J.GetHP(botTarget) > 0.4 then
				return BOT_ACTION_DESIRE_HIGH, botTarget, ITEM_TARGET_TYPE_UNIT
			end
		end
	end

	if nCharges >= 2 then
		local hNeedHealAlly = nil
		local hNeedHealAllyHP = 99999
		for _, allyHero in pairs(nAllyHeroes) do
			if J.IsValidHero(allyHero)
			and J.CanBeAttacked(allyHero)
			and J.IsInRange(bot, allyHero, nCastRange + 150)
			and allyHero:DistanceFromFountain() > 3200
			and not allyHero:IsIllusion()
			and not allyHero:WasRecentlyDamagedByAnyHero(5.0)
			and not allyHero:HasModifier('modifier_alchemist_chemical_rage')
			and not allyHero:HasModifier('modifier_arc_warden_tempest_double')
			and not allyHero:HasModifier('modifier_doom_bringer_doom_aura_enemy')
			and not allyHero:HasModifier('modifier_enchantress_natures_attendants')
			and not allyHero:HasModifier('modifier_juggernaut_healing_ward_heal')
			and not allyHero:HasModifier('modifier_legion_commander_press_the_attack')
			and not allyHero:HasModifier('modifier_naga_siren_song_of_the_siren_healing')
			and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
			and not allyHero:HasModifier('modifier_oracle_false_promise_timer')
			and not allyHero:HasModifier('modifier_pugna_life_drain')
			and not allyHero:HasModifier('modifier_ice_blast')
			and not allyHero:HasModifier('modifier_item_urn_damage')
			and not allyHero:HasModifier('modifier_item_spirit_vessel_damage')
			and not allyHero:HasModifier('modifier_item_aeon_disk_buff')
			and not allyHero:HasModifier('modifier_item_bloodstone_active')
			and not allyHero:HasModifier('modifier_item_satanic_unholy')
			and not allyHero:HasModifier('modifier_flask_healing')
			and not allyHero:HasModifier('modifier_fountain_aura_buff')
			and not allyHero:HasModifier('modifier_rune_regen')
			and bot:GetAbilityByName('slark_shadow_dance') == nil
			and #nEnemyHeroes == 0
			then
				local allyHeroHP = J.GetHP(allyHero)
				if allyHeroHP < hNeedHealAllyHP and allyHeroHP < 0.6 then
					hNeedHealAlly = allyHero
					hNeedHealAllyHP = allyHeroHP
				end
			end
		end

		if hNeedHealAlly then
			return BOT_ACTION_DESIRE_HIGH, hNeedHealAlly, ITEM_TARGET_TYPE_UNIT
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

X.ConsiderItemDesire["item_veil_of_discord"] = function( hItem )

	local nRadius = hItem:GetSpecialValueInt('debuff_radius')

	local nInRangeEnemy = J.GetEnemiesNearLoc(botLocation, nRadius)

	if J.IsInTeamFight(bot, 1200) then
        if #nInRangeEnemy >= 2 then
            local count = 0
            for _, enemyHero in pairs(nInRangeEnemy) do
                if J.IsValidHero(enemyHero)
                and J.CanBeAttacked(enemyHero)
                and J.CanCastOnNonMagicImmune(enemyHero)
				and not enemyHero:HasModifier('modifier_doom_bringer_doom_aura_enemy')
				and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
				and not enemyHero:HasModifier('modifier_ice_blast')
				and not enemyHero:HasModifier('modifier_item_spirit_vessel_damage')
                then
                    count = count + 1
                end
            end

            if count >= 2 then
                return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
            end
        end
    end

    if J.IsGoingOnSomeone(bot) then
        if  J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        and J.CanCastOnNonMagicImmune(botTarget)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_dazzle_shallow_grave')
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        then
			return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
        end
	end

	return BOT_ACTION_DESIRE_NONE
end

X.ConsiderItemDesire["item_wind_waker"] = function( hItem )

	return X.ConsiderItemDesire["item_cyclone"]( hItem )

end

--------------------------------
-- Neutral Items
--------------------------------

X.ConsiderItemDesire["item_ash_legion_shield"] = function( hItem )
	local nRadius = hItem:GetSpecialValueInt('block_radius')
	local unitList = GetUnitList(UNIT_LIST_ALLIES)

	local countControlledCreep = 0
	local countControlledHero = 0

	for _, unit in pairs(unitList) do
		if J.IsValid(unit) and J.IsInRange(bot, unit, nRadius) then
			local sUnitName = unit:GetUnitName()

			if unit:IsHero() and (unit:IsIllusion() or string.find(sUnitName, 'bear')) then
				countControlledHero = countControlledHero + 1
			end

			if string.find(sUnitName, 'golem') then
				return BOT_ACTION_DESIRE_HIGH, bot, 'none', nil
			end

			if string.find(sUnitName, 'spiderlings')
			or string.find(sUnitName, 'forge_spirit')
			or string.find(sUnitName, 'golem')
			or string.find(sUnitName, 'boar')
			or string.find(sUnitName, 'furion_treant')
			or string.find(sUnitName, 'familiars')
			or unit:IsDominated()
			or unit:HasModifier('modifier_chen_holy_persuasion')
			then
				countControlledCreep = countControlledCreep + 1
			end
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if bot:WasRecentlyDamagedByAnyHero(2.0) and (countControlledCreep >= 2 or countControlledHero >= 2) then
			return BOT_ACTION_DESIRE_HIGH, bot, 'none', nil
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

X.ConsiderItemDesire["item_demonicon"] = function(hItem)

    if J.IsGoingOnSomeone(bot) then
        if  J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, 1200)
        and not J.IsSuspiciousIllusion(botTarget)
		and not botTarget:HasModifier('modifier_abaddon_borrowed_time')
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
        then
			return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
        end
	end

	if J.IsPushing(bot) then
		local nEnemyTowers = bot:GetNearbyTowers(1200, true)
		local nAllyLaneCreeps = bot:GetNearbyLaneCreeps(1200, false)

		if (#nEnemyTowers >= 1 and #nAllyLaneCreeps >= 3) then
			return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

X.ConsiderItemDesire["item_crippling_crossbow"] = function( hItem )

	local nCastRange = hItem:GetCastRange()

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.CanCastOnTargetAdvanced(botTarget)
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			if J.IsChasingTarget(bot, botTarget) or botTarget:GetHealthRegen() >= 40 then
				return BOT_ACTION_DESIRE_HIGH, botTarget, ITEM_TARGET_TYPE_UNIT
			end
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
		for _, enemyHero in pairs(nEnemyHeroes) do
            if  J.IsValidHero(enemyHero)
			and J.CanBeAttacked(enemyHero)
            and J.IsInRange(bot, enemyHero, nCastRange)
            and J.CanCastOnNonMagicImmune(enemyHero)
            and J.CanCastOnTargetAdvanced(enemyHero)
            and not J.IsDisabled(enemyHero)
			and not enemyHero:IsDisarmed()
			and bot:WasRecentlyDamagedByHero(enemyHero, 3.0)
			and enemyHero:IsFacingLocation(bot:GetLocation(), 25)
            then
				return BOT_ACTION_DESIRE_HIGH, botTarget, ITEM_TARGET_TYPE_UNIT
            end
        end
	end

	if J.IsDoingRoshan(bot)	then
		if J.IsRoshan(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, nCastRange)
		and bAttacking
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget, ITEM_TARGET_TYPE_UNIT
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

X.ConsiderItemDesire["item_essence_ring"] = function( hItem )

	local nHealthBonus = hItem:GetSpecialValueInt('health_gain')
	local nManaCost = hItem:GetManaCost()
	local fManaAfter = J.GetManaAfter(nManaCost)

	if (bot:GetMaxHealth() - bot:GetHealth()) > nHealthBonus * 2.5 and fManaAfter > 0.4 and #nEnemyHeroes > 0 then
		return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
	end

	return BOT_ACTION_DESIRE_NONE
end

X.ConsiderItemDesire["item_fallen_sky"] = function( hItem )

	local nCastRange = hItem:GetCastRange()

	if  J.IsRetreating(bot)
	and not J.IsRealInvisible(bot)
	and not bot:HasModifier('modifier_fountain_aura_buff')
	and bot:GetActiveModeDesire() > BOT_MODE_DESIRE_MODERATE
	then
		local vLocation = J.VectorTowards(botLocation, J.GetTeamFountain(), nCastRange)
		if IsLocationPassable(vLocation) and J.IsRunning(bot) then
			return BOT_ACTION_DESIRE_HIGH, vLocation, ITEM_TARGET_TYPE_POINT
		end
	end

	return X.ConsiderItemDesire["item_meteor_hammer"]( hItem )
end

X.ConsiderItemDesire["item_flayers_bota"] = function( hItem )

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and not J.IsSuspiciousIllusion(botTarget)
		and bAttacking
		then
			return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
		end
	end

	if J.IsDoingRoshan(bot) then
		if J.IsRoshan(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, botAttackRange + 150)
		and #nEnemyHeroes == 0
		and bAttacking
		then
			return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
		end
	end

	if J.IsDoingTormentor(bot) then
		if J.IsTormentor(botTarget)
		and J.IsInRange(bot, botTarget, botAttackRange + 150)
		and #nEnemyHeroes == 0
		and bAttacking
		then
			return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

X.ConsiderItemDesire["item_idol_of_screeauk"] = function( hItem )

	if J.IsGoingOnSomeone(bot) then
		if bot:WasRecentlyDamagedByAnyHero(2.0) and J.IsRunning(bot) then
			return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

X.ConsiderItemDesire["item_jidi_pollen_bag"] = function( hItem )

	local nRadius = hItem:GetSpecialValueInt('debuff_radius')

	local nInRangeEnemy = J.GetEnemiesNearLoc(botLocation, nRadius)

	if J.IsInTeamFight(bot, 1200) then
        if #nInRangeEnemy >= 2 then
            local count = 0
            for _, enemyHero in pairs(nInRangeEnemy) do
                if J.IsValidHero(enemyHero)
                and J.CanBeAttacked(enemyHero)
                and J.CanCastOnNonMagicImmune(enemyHero)
				and not enemyHero:HasModifier('modifier_doom_bringer_doom_aura_enemy')
				and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
				and not enemyHero:HasModifier('modifier_ice_blast')
				and not enemyHero:HasModifier('modifier_item_spirit_vessel_damage')
                then
                    count = count + 1
                end
            end

            if count >= 2 then
                return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
            end
        end
    end

    if J.IsGoingOnSomeone(bot) then
        if  J.IsValidHero(botTarget)
        and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        and J.CanCastOnNonMagicImmune(botTarget)
        and not botTarget:HasModifier('modifier_doom_bringer_doom_aura_enemy')
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		and not botTarget:HasModifier('modifier_ice_blast')
		and not botTarget:HasModifier('modifier_item_spirit_vessel_damage')
        then
			return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
        end
	end

	return BOT_ACTION_DESIRE_NONE
end

X.ConsiderItemDesire["item_mana_draught"] = function( hItem )

	if (#nEnemyHeroes == 0)
	or (J.IsValidHero(nEnemyHeroes[1]) and not J.IsInRange(bot, nEnemyHeroes[1], nEnemyHeroes[1]:GetAttackRange() + 800) and not bot:WasRecentlyDamagedByAnyHero(5.0))
	then
		if botMP < 0.5 then
			return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

X.ConsiderItemDesire["item_metamorphic_mandible"] = function( hItem )

	local nDuration = hItem:GetSpecialValueInt('duration')

	if J.IsGoingOnSomeone(bot) then
		if bot:WasRecentlyDamagedByAnyHero(2.0) then
			local enemyDamage = 0
			for _, enemyHero in pairs(nEnemyHeroes) do
				if  J.IsValidHero(enemyHero)
				and not J.IsSuspiciousIllusion(enemyHero)
				and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
				and not enemyHero:IsChanneling()
				then
					if enemyHero:GetAttackTarget() == bot
					or J.IsChasingTarget(enemyHero, bot)
					or enemyHero:IsFacingLocation(bot:GetLocation(), 15)
					or bot:WasRecentlyDamagedByHero(enemyHero, 3.0)
					then
						enemyDamage = enemyDamage + (enemyHero:GetAttackDamage() * enemyHero:GetAttackSpeed() * nDuration)
					end
				end
			end

			if bot:GetActualIncomingDamage(enemyDamage * 1.5, DAMAGE_TYPE_PHYSICAL) < bot:GetHealth() then
				return BOT_ACTION_DESIRE_HIGH, bot, 'none', nil
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

X.ConsiderItemDesire["item_minotaur_horn"] = function( hItem )

    if bot:HasModifier('modifier_jakiro_macropyre_burn')
    or bot:HasModifier('modifier_lich_chainfrost_slow')
    or bot:HasModifier('modifier_crystal_maiden_freezing_field_slow')
    or bot:HasModifier('modifier_skywrath_mystic_flare_aura_effect')
    or bot:HasModifier('modifier_snapfire_magma_burn_slow')
    or bot:HasModifier('modifier_sand_king_epicenter_slow')
    then
        return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
    end

	return X.ConsiderItemDesire["item_black_king_bar"]( hItem )
end

X.ConsiderItemDesire["item_polliwog_charm"] = function( hItem )

	local nCastRange = hItem:GetCastRange()
	local nHealthRegen = hItem:GetSpecialValueInt('regen_boost')
	local nDuration = hItem:GetSpecialValueInt('duration')

	local hNeedHealAlly = nil
	local hNeedHealAllyHealth = 99999
	for _, allyHero in pairs(nAllyHeroes) do
		if J.IsValidHero(allyHero)
		and J.CanBeAttacked(allyHero)
		and J.IsInRange(bot, allyHero, nCastRange)
		and not J.IsSuspiciousIllusion(allyHero)
		and not allyHero:HasModifier('modifier_abaddon_borrowed_time')
		and not allyHero:HasModifier('modifier_juggernaut_healing_ward_heal')
		and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
		and not allyHero:HasModifier('modifier_filler_heal')
		and not allyHero:HasModifier('modifier_elixer_healing')
		and not allyHero:HasModifier('modifier_flask_healing')
		and not allyHero:HasModifier('modifier_fountain_aura_buff')
		and (allyHero:GetMaxHealth() - allyHero:GetHealth() > nHealthRegen * nDuration)
		then
			if allyHero:GetHealth() < hNeedHealAllyHealth then
				hNeedHealAlly = allyHero
				hNeedHealAllyHealth = allyHero:GetHealth()
			end
		end
	end

	if hNeedHealAlly ~= nil then
		return BOT_ACTION_DESIRE_HIGH, hNeedHealAlly, ITEM_TARGET_TYPE_UNIT
	end

	return BOT_ACTION_DESIRE_NONE
end

X.ConsiderItemDesire["item_psychic_headband"] = function( hItem )

	local nCastRange = hItem:GetCastRange()
	local nPushDistance = hItem:GetSpecialValueInt('push_length')

	for _, allyHero in ipairs(nAllyHeroes) do
		if J.IsValidHero(allyHero)
		and bot ~= allyHero
		and J.CanBeAttacked(allyHero)
		and not J.IsSuspiciousIllusion(allyHero)
		and not allyHero:HasModifier('modifier_necrolyte_reapers_scythe')
		and not allyHero:HasModifier('modifier_teleporting')
		and not allyHero:IsChanneling()
		then
			local allyHeroTarget = J.GetProperTarget(allyHero)
			local nInRangeAlly = J.GetAlliesNearLoc(allyHero:GetLocation(), 1200)
			local nInRangeEnemy = J.GetEnemiesNearLoc(allyHero:GetLocation(), 1200)

			if J.IsGoingOnSomeone(allyHero) and bot ~= allyHero then
				if J.IsValidHero(allyHeroTarget)
				and not J.IsSuspiciousIllusion(allyHeroTarget)
				and GetUnitToUnitDistance(allyHero, allyHeroTarget) > allyHero:GetAttackRange() + 150
				and GetUnitToUnitDistance(allyHero, allyHeroTarget) < allyHero:GetAttackRange() + 700
				and allyHero:IsFacingLocation(allyHeroTarget:GetLocation(), 15)
				and not allyHeroTarget:IsFacingLocation(allyHero:GetLocation(), 40)
				and not allyHeroTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
				then
					if #nInRangeAlly >= #nInRangeEnemy then
						local tResult = PointToLineDistance(bot:GetLocation(), allyHeroTarget:GetLocation(), allyHero:GetLocation())
						if tResult and tResult.within and tResult.distance <= nPushDistance then
							return BOT_ACTION_DESIRE_HIGH, allyHero, ITEM_TARGET_TYPE_UNIT
						end
					end
				end
			end

			if J.IsRetreating(allyHero) and not J.IsRealInvisible(allyHero) then
				for _, enemyHero in pairs(nEnemyHeroes) do
					if J.IsValidHero(enemyHero)
					and J.IsInRange(bot, enemyHero, nCastRange)
					and J.IsInRange(allyHero, enemyHero, 1200)
					and J.CanCastOnNonMagicImmune(enemyHero)
					and J.CanCastOnTargetAdvanced(enemyHero)
					and not J.IsDisabled(enemyHero)
					and allyHero:WasRecentlyDamagedByHero(enemyHero, 4.0)
					then
						local distance1 = GetUnitToLocationDistance(bot, J.GetTeamFountain())
						local distance2 = GetUnitToLocationDistance(allyHero, J.GetTeamFountain())
						local distance3 = GetUnitToLocationDistance(enemyHero, J.GetTeamFountain())
						if distance1 < distance3 and distance2 and distance3 then
							return BOT_ACTION_DESIRE_HIGH, enemyHero, ITEM_TARGET_TYPE_UNIT
						end
					end
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

X.ConsiderItemDesire["item_riftshadow_prism"] = function( hItem )
	local fHealthCostPct = hItem:GetSpecialValueInt('health_cost')

	if J.IsGoingOnSomeone(bot) then
		if bot:WasRecentlyDamagedByAnyHero(2.0) and J.GetHealthAfter(bot:GetHealth() * fHealthCostPct) > 0.2 then
			return BOT_ACTION_DESIRE_HIGH, bot, 'none', nil
		end
	end
end

X.ConsiderItemDesire["item_spider_legs"] = function( hItem )

	return X.ConsiderItemDesire["item_phase_boots"]( hItem )

end

X.ConsiderItemDesire["item_pogo_stick"] = function( hItem )

	if bot:IsRooted() then return BOT_ACTION_DESIRE_NONE end

	if J.IsGoingOnSomeone(bot) then
		if  J.IsValidTarget(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.IsInRange(bot, botTarget, botAttackRange + 150)
		and bot:IsFacingLocation(botTarget:GetLocation(), 15)
		and not J.IsSuspiciousIllusion(botTarget)
		and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
		then
			return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) and bot:IsFacingLocation(J.GetTeamFountain(), 30) then
		for _, enemyHero in pairs(nEnemyHeroes) do
			if  J.IsValidHero(enemyHero)
			and J.IsInRange(bot, enemyHero, 1200)
			and not J.IsSuspiciousIllusion(enemyHero)
			and not enemyHero:IsDisarmed()
			and not J.IsDisabled(enemyHero)
			and J.IsRunning(bot)
			and bot:WasRecentlyDamagedByAnyHero(3.0)
			then
				return BOT_ACTION_DESIRE_HIGH, nil, ITEM_TARGET_TYPE_NONE
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

--挑战
X.ConsiderItemDesire["item_hood_of_defiance"] = function( hItem )

	if bot:HasModifier( 'modifier_item_pipe_barrier' )
		or J.GetHP( bot ) > 0.88
	then return BOT_ACTION_DESIRE_NONE end

	local nCastRange = 1000
	local sCastType = 'none'
	local hEffectTarget = nil
	local sCastMotive = nil
	local nInRangeEnmyList = bot:GetNearbyHeroes( nCastRange, true, BOT_MODE_NONE )


	if #nInRangeEnmyList > 0
	then
		hEffectTarget = bot
		sCastMotive = '套盾'
		return BOT_ACTION_DESIRE_HIGH, hEffectTarget, sCastType, sCastMotive
	end

	return BOT_ACTION_DESIRE_NONE

end


--勋章
X.ConsiderItemDesire["item_medallion_of_courage"] = function( hItem )

	local nCastRange = 900 
	local sCastType = 'unit'
	local hEffectTarget = nil
	local sCastMotive = nil
	local nInRangeEnmyList = bot:GetNearbyHeroes( nCastRange, true, BOT_MODE_NONE )


	if J.IsGoingOnSomeone( bot )
	then
		if J.IsValidHero( botTarget )
			and not botTarget:HasModifier( 'modifier_item_solar_crest_armor_reduction' )
			and not botTarget:HasModifier( 'modifier_item_medallion_of_courage_armor_reduction' )
			and J.CanCastOnNonMagicImmune( botTarget )
			and not botTarget:IsAncientCreep()
			and ( J.IsInRange( bot, botTarget, bot:GetAttackRange() + 150 )
				or ( J.IsInRange( bot, botTarget, 1000 )
					and J.GetAroundTargetOtherAllyHeroCount( bot, botTarget, 600 ) >= 1 ) )
		then
			hEffectTarget = botTarget
			sCastMotive = '进攻:'..J.Chat.GetNormName( hEffectTarget )
			return BOT_ACTION_DESIRE_HIGH, hEffectTarget, sCastType, sCastMotive
		end
	end

	if #hNearbyEnemyHeroList == 0
	then
		if J.IsValid( botTarget )
			and not botTarget:HasModifier( 'modifier_item_solar_crest_armor_reduction' )
			and not botTarget:HasModifier( 'modifier_item_medallion_of_courage_armor_reduction' )
			and not botTarget:HasModifier( "modifier_fountain_glyph" )
			and not J.CanKillTarget( botTarget, bot:GetAttackDamage() * 2.38, DAMAGE_TYPE_PHYSICAL )
			and J.IsInRange( bot, botTarget, bot:GetAttackRange() + 150 )
		then
			hEffectTarget = botTarget
			sCastMotive = '刷小兵:'..J.Chat.GetNormName( hEffectTarget )
			return BOT_ACTION_DESIRE_HIGH, hEffectTarget, sCastType, sCastMotive
		end
	end

	--------
	local hAllyList = bot:GetNearbyHeroes( 1000, false, BOT_MODE_NONE )
	for _, npcAlly in pairs( hAllyList )
	do
		if npcAlly ~= bot
			and J.IsValidHero( npcAlly )
			and not npcAlly:IsIllusion()
			and J.CanCastOnNonMagicImmune( npcAlly )
			and not npcAlly:HasModifier( 'modifier_item_solar_crest_armor_addition' )
			and not npcAlly:HasModifier( 'modifier_item_medallion_of_courage_armor_addition' )
			and not npcAlly:HasModifier( "modifier_arc_warden_tempest_double" )
			and ( ( J.IsDisabled( npcAlly ) )
				or ( J.GetHP( npcAlly ) < 0.35 and #hNearbyEnemyHeroList > 0 and npcAlly:WasRecentlyDamagedByAnyHero( 2.0 ) )
				or ( J.IsValidHero( npcAlly:GetAttackTarget() ) and GetUnitToUnitDistance( npcAlly, npcAlly:GetAttackTarget() ) <= npcAlly:GetAttackRange() and #hNearbyEnemyHeroList == 0 ) )
		then
			hEffectTarget = npcAlly
			sCastMotive = '救队友:'..J.Chat.GetNormName( hEffectTarget )
			return BOT_ACTION_DESIRE_HIGH, hEffectTarget, sCastType, sCastMotive
		end
	end

	return BOT_ACTION_DESIRE_NONE

end

--死灵书
X.ConsiderItemDesire["item_necronomicon"] = function( hItem )

	local nCastRange = 750
	local sCastType = 'none'
	local hEffectTarget = nil
	local sCastMotive = nil
	local nInRangeEnmyList = bot:GetNearbyHeroes( nCastRange, true, BOT_MODE_NONE )


	if botTarget ~= nil and botTarget:IsAlive()
		and J.IsInRange( bot, botTarget, 1000 )
	then
		hEffectTarget = botTarget
		sCastMotive = "进攻"
		return BOT_ACTION_DESIRE_HIGH, hEffectTarget, sCastType, sCastMotive
	end

	return BOT_ACTION_DESIRE_NONE

end

X.ConsiderItemDesire["item_necronomicon_2"] = function( hItem )

	return X.ConsiderItemDesire["item_necronomicon"]( hItem )

end

X.ConsiderItemDesire["item_necronomicon_3"] = function( hItem )

	return X.ConsiderItemDesire["item_necronomicon"]( hItem )

end


--肉山A杖
X.ConsiderItemDesire["item_ultimate_scepter_roshan"] = function( hItem )

	local nCastRange = 300
	local sCastType = 'none'
	local hEffectTarget = nil
	local sCastMotive = nil
	local nInRangeEnmyList = bot:GetNearbyHeroes( nCastRange, true, BOT_MODE_NONE )

	if hItem:IsFullyCastable()
	then
		hEffectTarget = bot
		sCastMotive = '吃A杖'
		return BOT_ACTION_DESIRE_HIGH, hEffectTarget, sCastType, sCastMotive
	end

	return BOT_ACTION_DESIRE_NONE

end

--经验书
X.ConsiderItemDesire["item_tome_of_knowledge"] = function( hItem )

	local nCastRange = 300
	local sCastType = 'none'
	local hEffectTarget = nil
	local sCastMotive = nil
	local nInRangeEnmyList = bot:GetNearbyHeroes( nCastRange, true, BOT_MODE_NONE )

	if hItem:IsFullyCastable()
	then
		hEffectTarget = bot
		sCastMotive = '读书'
		return BOT_ACTION_DESIRE_HIGH, hEffectTarget, sCastType, sCastMotive
	end

	return BOT_ACTION_DESIRE_NONE

end


function X.GetLaningTPLocation(bot, nMinTPDistance, vLocation)
	local laneMap = {
		[TEAM_RADIANT] = {
			[1] = LANE_BOT,
			[2] = LANE_MID,
			[3] = LANE_TOP,
			[4] = LANE_TOP,
			[5] = LANE_BOT,
		},
		[TEAM_DIRE] = {
			[1] = LANE_TOP,
			[2] = LANE_MID,
			[3] = LANE_BOT,
			[4] = LANE_BOT,
			[5] = LANE_TOP,
		}
	}
	
	local nLane = laneMap[GetTeam()][J.GetPosition(bot)]

	local nAmountAlongLane = GetAmountAlongLane(nLane, vLocation)
	local fLaneFrontAmount = GetLaneFrontAmount(GetTeam(), nLane, false)
	if nAmountAlongLane.distance > nMinTPDistance
	or nAmountAlongLane.amount < fLaneFrontAmount / 5
	then
		return GetLaneFrontLocation(GetTeam(), nLane, RandomInt(-700, 0))
	end

	return nil
end

function X.GetDefendTPLocation(nLane)
	local hBuildingList = {
		[LANE_TOP] = {
			TOWER_TOP_1,
			TOWER_TOP_2,
			TOWER_TOP_3,
			TOWER_BASE_1,
			TOWER_BASE_2,
			BARRACKS_TOP_MELEE,
			BARRACKS_TOP_RANGED,
		},
		[LANE_MID] = {
			TOWER_MID_1,
			TOWER_MID_2,
			TOWER_MID_3,
			TOWER_BASE_1,
			TOWER_BASE_2,
			BARRACKS_MID_MELEE,
			BARRACKS_MID_RANGED,
		},
		[LANE_BOT] = {
			TOWER_BOT_1,
			TOWER_BOT_2,
			TOWER_BOT_3,
			TOWER_BASE_1,
			TOWER_BASE_2,
			BARRACKS_BOT_MELEE,
			BARRACKS_BOT_RANGED,
		}
	}

	for i = 1, #hBuildingList[nLane] do
		local hBuilding = nil
		if i <= 5 then
			hBuilding = GetTower(GetTeam(), hBuildingList[nLane][i])
		else
			hBuilding = GetBarracks(GetTeam(), hBuildingList[nLane][i])
		end

		if J.IsValidBuilding(hBuilding) then
			local nInRangeAlly = J.GetAlliesNearLoc(hBuilding:GetLocation(), 1200)
			local nInRangeEnemy = J.GetEnemiesNearLoc(hBuilding:GetLocation(), 1200)
			if #nInRangeAlly > #nInRangeEnemy + 1 then
				return hBuilding:GetLocation() + RandomVector(400)
			else
				local vLocation = J.VectorTowards(hBuilding:GetLocation(), J.GetTeamFountain(), 700)
				return vLocation
			end
		end
	end

	local hAncient = GetAncient(GetTeam())
	if J.IsValidBuilding(hAncient) and J.CanBeAttacked(hAncient) then
		local vLocation = J.VectorTowards(hAncient:GetLocation(), J.GetTeamFountain(), 700)
		return vLocation
	end

	return GetLaneFrontLocation(GetTeam(), nLane, -950)
end

function X.GetPushTPLocation(nLane)
	local vLaneFrontLocation = GetLaneFrontLocation(GetTeam(), nLane, 0)
	local vLocation = J.GetNearbyLocationToTp(vLaneFrontLocation)
	if J.GetDistance(vLocation, vLaneFrontLocation) < 2000 then
		return vLocation
	end
end

function X.GetNumHeroWithinRange(nRadius)
	local count = 0
	for _, id in pairs(GetTeamPlayers(GetOpposingTeam())) do
		if IsHeroAlive(id) then
			local info = GetHeroLastSeenInfo(id)
			if info ~= nil then
				local dInfo = info[1]
				if  dInfo ~= nil
				and dInfo.time_since_seen < 2.0
				and GetUnitToLocationDistance(bot, dInfo.location) < nRadius
				then
					count = count + 1
				end
			end
		end
	end

	return count
end

function X.IsFarmingAlways( bot )

	local nTarget = bot:GetAttackTarget()
	if J.IsValid( nTarget )
		and nTarget:GetTeam() == TEAM_NEUTRAL
		and not J.IsRoshan( nTarget )
		and not J.IsKeyWordUnit( "warlock", nTarget )
		and X.GetNumEnemyNearby( GetAncient( GetTeam() ) ) >= 2
	then
		return true
	end

	local nNearAllyList = bot:GetNearbyHeroes( 800, false, BOT_MODE_NONE )
	if J.IsValid( nTarget )
		and nTarget:IsAncientCreep()
		and not J.IsRoshan( nTarget )
		and not J.IsKeyWordUnit( "warlock", nTarget )
		and bot:GetPrimaryAttribute() == ATTRIBUTE_INTELLECT
		and bot:GetUnitName() ~= 'npc_dota_hero_ogre_magi'
		and #nNearAllyList < 2
	then
		return true
	end

	if X.GetNumEnemyNearby( GetAncient( GetTeam() ) ) >= 4
		and bot:DistanceFromFountain() >= 4800
		and #nNearAllyList < 2
	then
		return true
	end

	return false
end

function X.IsBaseTowerDestroyed()
	local nTowerList = {
		TOWER_BASE_1,
		TOWER_BASE_2,
	}

	for i = 1, #nTowerList do
		local tower = GetTower( GetTeam(), nTowerList[i])
		if tower == nil
		or (J.IsValidBuilding(tower) and J.GetHP(tower) <= 0.12)
		then
			return true
		end
	end

	return false
end

function X.HasInvisibilityOrItem( npcEnemy )

	if J.IsValidHero(npcEnemy)
	and (npcEnemy:HasInvisibility( false )
		or J.HasItem( npcEnemy, "item_shadow_amulet" )
		or J.HasItem( npcEnemy, "item_glimmer_cape" )
		or J.HasItem( npcEnemy, "item_invis_sword" )
		or J.HasItem( npcEnemy, "item_silver_edge" ))
	then
		return true
	end

	return false

end

--GG树
local lastKACount = -1
X.ConsiderItemDesire["item_ironwood_tree"] = function( hItem )

	local nCastRange = 600
	local sCastType = 'ground'
	local hEffectTarget = nil
	local sCastMotive = nil

	if lastKACount == -1 then lastKACount = GetHeroKills( bot:GetPlayerID() ) + GetHeroAssists( bot:GetPlayerID() ) end

	if lastKACount < GetHeroKills( bot:GetPlayerID() ) + GetHeroAssists( bot:GetPlayerID() )
	then
		lastKACount = -1
		hEffectTarget = J.GetFaceTowardDistanceLocation( bot, nCastRange )
		sCastMotive = 'GG'
		return BOT_ACTION_DESIRE_HIGH, hEffectTarget, sCastType, sCastMotive
	end

	return BOT_ACTION_DESIRE_NONE

end

--闪灵
X.ConsiderItemDesire["item_flicker"] = function( hItem )

	if bot:DistanceFromFountain() < 600 or bot:IsRooted() then return BOT_ACTION_DESIRE_NONE end

	local nCastRange = 600
	local sCastType = 'none'
	local hEffectTarget = nil
	local sCastMotive = nil
	local nInRangeEnmyList = bot:GetNearbyHeroes( 800, true, BOT_MODE_NONE )

	if J.IsGoingOnSomeone( bot )
	then
		if J.IsValidHero( botTarget )
			and ( bot:IsSilenced() or bot:IsRooted() )
		then
			hEffectTarget = bot
			sCastMotive = '驱散沉默或缠绕'
			return BOT_ACTION_DESIRE_HIGH, hEffectTarget, sCastType, sCastMotive
		end
	end


	if J.IsRetreating( bot )
		and bot:WasRecentlyDamagedByAnyHero( 3.0 )
		and #nInRangeEnmyList >= 1
	then
		hEffectTarget = bot
		sCastMotive = "撤退"
		return BOT_ACTION_DESIRE_HIGH, hEffectTarget, sCastType, sCastMotive
	end


	return BOT_ACTION_DESIRE_NONE

end

--幻术师披风
X.ConsiderItemDesire["item_illusionsts_cape"] = function( hItem )

	local nCastRange = 800
	local sCastType = 'none'
	local hEffectTarget = nil
	local sCastMotive = nil

	if J.IsValid( botTarget )
		and J.IsInRange( bot, botTarget, nCastRange )
	then
		hEffectTarget = botTarget
		sCastMotive = "辅助攻击"
		return BOT_ACTION_DESIRE_HIGH, hEffectTarget, sCastType, sCastMotive
	end

	return X.ConsiderItemDesire["item_manta"]( hItem )

end


--林地神行靴
X.ConsiderItemDesire["item_woodland_striders"] = function( hItem )

	if bot:DistanceFromFountain() < 600 then return 0 end

	local nCastRange = 800
	local sCastType = 'none'
	local hEffectTarget = nil
	local sCastMotive = nil

	if J.IsRetreating( bot )
		and bot:WasRecentlyDamagedByAnyHero( 4.0 )
	then
		hEffectTarget = bot
		sCastMotive = "撤退"
		return BOT_ACTION_DESIRE_HIGH, hEffectTarget, sCastType, sCastMotive
	end

	return BOT_ACTION_DESIRE_NONE

end

--机械之心
X.ConsiderItemDesire["item_ex_machina"] = function( hItem )

	local nCastRange = 800
	local sCastType = 'none'
	local hEffectTarget = nil
	local sCastMotive = nil
	local nInRangeEnmyList = bot:GetNearbyHeroes( nCastRange, true, BOT_MODE_NONE )


	if J.IsGoingOnSomeone( bot )
	then
		if J.IsValidHero( botTarget )
		then
			local nSoltList = { 0, 1, 2, 3, 4, 5 }
			local nRemainTime = 0
			for _, nSlot in pairs( nSoltList )
			do
				local hItem = bot:GetItemInSlot( nSlot )
				if hItem ~= nil and hItem:GetName() ~= 'item_refresher'
				then
					local nCooldownTime = hItem:GetCooldownTimeRemaining()
					nRemainTime = nRemainTime + nCooldownTime
				end
			end

			if nRemainTime >= 30
			then
				hEffectTarget = botTarget
				sCastMotive = "刷新CD"
				return BOT_ACTION_DESIRE_HIGH, hEffectTarget, sCastType, sCastMotive
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE

end

--风暴宝器
X.ConsiderItemDesire["item_stormcrafter"] = function( hItem )

	local nCastRange = 300 
	local sCastType = 'unit'
	local hEffectTarget = nil
	local sCastMotive = nil
	local nInRangeEnmyList = bot:GetNearbyHeroes( 1600, true, BOT_MODE_NONE )


	if J.CanCastOnNonMagicImmune( bot )
		and #nInRangeEnmyList > 0
	then
		if bot:IsRooted()
			or ( bot:GetPrimaryAttribute() == ATTRIBUTE_INTELLECT and bot:IsSilenced() )
		then
			hEffectTarget = bot
			sCastMotive = '解缠绕:'..J.Chat.GetNormName( hEffectTarget )
			return BOT_ACTION_DESIRE_HIGH, hEffectTarget, sCastType, sCastMotive
		end

		if J.IsUnitTargetProjectileIncoming( bot, 400 )
		then
			hEffectTarget = bot
			sCastMotive = '防御弹道:'..J.Chat.GetNormName( hEffectTarget )
			return BOT_ACTION_DESIRE_HIGH, hEffectTarget, sCastType, sCastMotive
		end
	end

	return BOT_ACTION_DESIRE_NONE

end

--仙灵榴弹
X.ConsiderItemDesire["item_paintball"] = function( hItem )

	local nCastRange = 900 
	local sCastType = 'unit'
	local hEffectTarget = nil
	local sCastMotive = nil
	local nInRangeEnmyList = bot:GetNearbyHeroes( nCastRange, true, BOT_MODE_NONE )


	if J.IsValidHero( botTarget )
		and J.CanCastOnNonMagicImmune( botTarget )
		and J.CanCastOnTargetAdvanced( botTarget )
		and J.IsInRange( botTarget, bot, nCastRange )
	then
		hEffectTarget = botTarget
		sCastMotive = '仙灵榴弹:'..J.Chat.GetNormName( hEffectTarget )
		return BOT_ACTION_DESIRE_HIGH, hEffectTarget, sCastType, sCastMotive
	end

	return BOT_ACTION_DESIRE_NONE

end


--行巫之祸
X.ConsiderItemDesire["item_heavy_blade"] = function( hItem )

	local nCastRange = 500
	local sCastType = 'unit'
	local hEffectTarget = nil
	local sCastMotive = nil
	local nInRangeEnmyList = bot:GetNearbyHeroes( nCastRange, true, BOT_MODE_NONE )


	--驱散友军
	for i = 1, 5
	do 
		local npcAlly = GetTeamMember( i )
		if J.IsValidHero( npcAlly )
			and J.IsInRange( bot, npcAlly, nCastRange + 100 )
		then
			if ( J.IsGoingOnSomeone( npcAlly ) or J.IsRetreating( npcAlly ) )
				and npcAlly:WasRecentlyDamagedByAnyHero( 2.0 )
				and J.GetHP( npcAlly ) < 0.85
			then
				local nEnemyList = npcAlly:GetNearbyHeroes( 300, true, BOT_MODE_NONE )
				local npcEnemy = nEnemyList[1]
				if J.IsValidHero( npcEnemy )
					and J.CanCastOnMagicImmune( npcEnemy )
				then
					hEffectTarget = npcAlly
					sCastMotive = "行巫之祸驱散友军:"..J.Chat.GetNormName( npcAlly )
					return BOT_ACTION_DESIRE_HIGH, hEffectTarget, sCastType, sCastMotive
				end
			end
		end	
	end
	
		
	--驱散敌军
	if J.IsGoingOnSomeone( bot )
	then
		if J.IsValidHero( botTarget )
			and J.IsInRange( bot, botTarget, nCastRange )
			and J.CanCastOnNonMagicImmune( botTarget )
		then
			-- if botTarget:HasModifier("")
				-- or botTarget:HasModifier("")
			if botTarget:WasRecentlyDamagedByAnyHero( 3.0 )
				and J.GetHP( botTarget ) < 0.7
			then
				hEffectTarget = botTarget
				sCastMotive = "行巫之祸驱散敌军:"..J.Chat.GetNormName( botTarget )
				return BOT_ACTION_DESIRE_HIGH, hEffectTarget, sCastType, sCastMotive
			end
		end
	end
	

	return BOT_ACTION_DESIRE_NONE

end

--亡魂胸针
X.ConsiderItemDesire["item_revenants_brooch"] = function( hItem )

	local nCastRange = bot:GetAttackRange() + 100
	local sCastType = 'none'
	local hEffectTarget = nil
	local sCastMotive = nil
	local nInRangeEnmyList = bot:GetNearbyHeroes( nCastRange, true, BOT_MODE_NONE )


	if J.IsGoingOnSomeone( bot )
	then
		if J.IsValidHero( botTarget )
			and J.IsInRange( bot, botTarget, nCastRange )
		then
			hEffectTarget = bot
			sCastMotive = "亡魂胸针进攻:"..J.Chat.GetNormName( botTarget )
			return BOT_ACTION_DESIRE_HIGH, hEffectTarget, sCastType, sCastMotive
		end
	end

	return BOT_ACTION_DESIRE_NONE

end


--怨灵之契
X.ConsiderItemDesire["item_wraith_pact"] = function( hItem )

	local nCastRange = 200 
	local sCastType = 'ground'
	local hEffectTarget = nil
	local sCastMotive = nil
	local nInRangeEnmyList = bot:GetNearbyHeroes( nCastRange, true, BOT_MODE_NONE )


	if J.IsGoingOnSomeone( bot )
	then
		if J.IsValidHero( botTarget )
			and botTarget:GetAttackTarget() ~= nil
			and J.IsInRange( bot, botTarget, 900 )
			and J.CanCastOnNonMagicImmune( botTarget )
		then
			hEffectTarget = J.GetFaceTowardDistanceLocation( bot, 200 )
			sCastMotive = "怨灵之契进攻:"..J.Chat.GetNormName( botTarget )
			return BOT_ACTION_DESIRE_HIGH, hEffectTarget, sCastType, sCastMotive
		end
	end

	return BOT_ACTION_DESIRE_NONE

end


--新物品
X.ConsiderItemDesire["item_new"] = function( hItem )

	local nCastRange = 300 
	local sCastType = 'unit'
	local hEffectTarget = nil
	local sCastMotive = nil
	local nInRangeEnmyList = bot:GetNearbyHeroes( nCastRange, true, BOT_MODE_NONE )


	if J.IsGoingOnSomeone( bot )
	then
		if J.IsValidHero( botTarget )
		then
			hEffectTarget = botTarget
			sCastMotive = "进攻:"..J.Chat.GetNormName( botTarget )
			return BOT_ACTION_DESIRE_HIGH, hEffectTarget, sCastType, sCastMotive
		end
	end

	return BOT_ACTION_DESIRE_NONE

end

----------------
-- Neutral Items
----------------

-- TIER 1

-- Trusty Shovel
X.ConsiderItemDesire["item_trusty_shovel"] = function(hItem)
	local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1600)
	if nInRangeEnemy ~= nil and #nInRangeEnemy == 0
	then
		return BOT_ACTION_DESIRE_HIGH, bot:GetLocation(), 'ground', nil
	end

	return BOT_ACTION_DESIRE_NONE
end

-- Arcane Ring
X.ConsiderItemDesire["item_arcane_ring"] = function(hItem)
	return X.ConsiderItemDesire["item_arcane_boots"](hItem)
end

-- Pig Pole
X.ConsiderItemDesire["item_unstable_wand"] = function(hItem)
	local nCastRange = 1600
	local nInRangeEnemy = bot:GetNearbyHeroes(nCastRange, true, BOT_MODE_NONE)

	if  nInRangeEnemy ~= nil and #nInRangeEnemy == 0
	and J.GetMP(bot) > 0.5
	and (J.IsRetreating(bot) or J.IsGoingOnSomeone(bot))
	then
		return BOT_ACTION_DESIRE_HIGH, bot, 'none', nil
	end

	return BOT_ACTION_DESIRE_NONE
end

-- Seeds of Serenity
X.ConsiderItemDesire["item_seeds_of_serenity"] = function(hItem)
	local nRadius = 400
	local nInRangeEnemy = bot:GetNearbyHeroes(nRadius, true, BOT_MODE_NONE)
	local nInRangeTower = bot:GetNearbyTowers(888, true)

	if J.IsFarming(bot)
	then	
		if J.IsAttacking(bot)
		then
			local nNeutralCreeps = bot:GetNearbyNeutralCreeps(nRadius)
			if J.IsValid(nNeutralCreeps[1])
			and ((#nNeutralCreeps >= 3)
				or (#nNeutralCreeps >= 2 and nNeutralCreeps[1]:IsAncientCreep()))
			then
				return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
			end

			local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(nRadius, true)
			if nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 3
			then
				return BOT_ACTION_DESIRE_HIGH, bot:GetLocation()
			end
		end
	end

	if J.IsPushing(bot)
	then
		if  nInRangeTower ~= nil and #nInRangeTower >= 1
		and J.IsValidBuilding(botTarget)
		and J.IsValidBuilding(nInRangeTower[1])
		and J.IsAttacking(bot)
		and botTarget == nInRangeTower[1]
		then
			return BOT_ACTION_DESIRE_HIGH, bot:GetLocation(), 'ground', nil
		end
	end

	if J.IsDoingRoshan(bot)
    then
        if  J.IsRoshan(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH, bot:GetLocation(), 'ground', nil
        end
    end

    if J.IsDoingTormentor(bot)
    then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH, bot:GetLocation(), 'ground', nil
        end
    end

	return BOT_ACTION_DESIRE_NONE
end

-- Royal Jelly
local royalJellyTime = nil
X.ConsiderItemDesire["item_royal_jelly"] = function(hItem)
	if royalJellyTime == nil
	then
		royalJellyTime = DotaTime()
	else
		if royalJellyTime < DotaTime() - 2.0
		then
			local targetAlly = nil

			for i = 1, 5
			do
				local allyHero = GetTeamMember(i)

				if  J.IsValidHero(allyHero)
				and J.IsCore(allyHero)
				and not allyHero:IsIllusion()
				and not allyHero:HasModifier('modifier_royal_jelly')
				then
					targetAlly = allyHero
				end
			end

			if targetAlly ~= nil
			then
				royalJellyTime = nil
				return BOT_ACTION_DESIRE_HIGH, targetAlly, 'unit', nil
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

-- TIER 2

-- Vambrace
-- X.ConsiderItemDesire["item_vambrace"] = function(hItem)
-- 	return X.ConsiderItemDesire["item_power_treads"](hItem)
-- end

-- Bullwhip
X.ConsiderItemDesire["item_bullwhip"] = function(hItem)
	local nCastRange = 850 

	if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidHero(botTarget)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.IsChasingTarget(bot, botTarget)
		and not J.IsDisabled(botTarget)
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget, 'unit', nil
		end
	end

	local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), nCastRange)
	for _, allyHero in pairs(nInRangeAlly)
	do
		if  J.IsValidHero(allyHero)
		and J.CanCastOnNonMagicImmune(allyHero)
		then
			local nAllyInRangeEnemy = allyHero:GetNearbyHeroes(1200, true, BOT_MODE_NONE)

			if  nAllyInRangeEnemy ~= nil and #nAllyInRangeEnemy >= 1
			and J.IsRetreating(allyHero)
			and allyHero:DistanceFromFountain() > 1200
			and not J.IsRealInvisible(allyHero)
			and not J.IsDisabled(allyHero)
			then
				return BOT_ACTION_DESIRE_HIGH, allyHero, 'unit', nil
			end
		end
	end

	if hItem:IsFullyCastable()
	then
		return BOT_ACTION_DESIRE_HIGH, bot, 'unit', nil
	end

	return BOT_ACTION_DESIRE_NONE
end

-- Light Collector
X.ConsiderItemDesire["item_light_collector"] = function(hItem)
	local nRadius = 325
	local nInRangeTrees = bot:GetNearbyTrees(nRadius)

	if J.IsGoingOnSomeone(bot)
	then
		if nInRangeTrees ~= nil and #nInRangeTrees >= 3
		then
			return BOT_ACTION_DESIRE_HIGH, bot, 'none', nil
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

-- Iron Talon
X.ConsiderItemDesire["item_iron_talon"] = function(hItem)
	local nCastRange = 350
	
	-- Only use it for creeps
	local nCreep = bot:GetNearbyNeutralCreeps(nCastRange)
	if J.IsFarming(bot)
	and #nCreep > 0
	then
		local creepTarget = J.GetMostHpUnit(nCreep)
		if J.CanBeAttacked(creepTarget)
		and J.GetHP(creepTarget) > 0.5
		then
			return BOT_ACTION_DESIRE_HIGH, creepTarget, 'unit', nil
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

-- TIER 3

-- Craggy Coat
X.ConsiderItemDesire["item_craggy_coat"] = function(hItem)
	local nRadius = 1200

	if J.IsInTeamFight(bot)
	then
		local realEnemyCount = J.GetEnemiesNearLoc(bot:GetLocation(), nRadius)

        if  realEnemyCount ~= nil and #realEnemyCount >= 2
		and bot:WasRecentlyDamagedByAnyHero(1.5)
        then
            return BOT_ACTION_DESIRE_HIGH, bot, 'none', nil
        end
	end

    if J.IsGoingOnSomeone(bot)
	then
		local nInRangeAlly = bot:GetNearbyHeroes(1200, false, BOT_MODE_NONE)

        if  J.IsValidTarget(botTarget)
        and J.IsAttacking(botTarget)
		and bot:WasRecentlyDamagedByAnyHero(1.3)
        and J.IsInRange(bot, botTarget, 600)
        and not J.IsSuspiciousIllusion(botTarget)
        then
            local nTargetInRangeAlly = botTarget:GetNearbyHeroes(1200, false, BOT_MODE_NONE)

            if  nInRangeAlly ~= nil and nTargetInRangeAlly ~= nil
            and #nInRangeAlly >= #nTargetInRangeAlly
            then
                return BOT_ACTION_DESIRE_HIGH, bot, 'none', nil
            end
        end
	end

	if J.IsDoingRoshan(bot)
    then
        if  J.IsRoshan(botTarget)
        and J.IsInRange(bot, botTarget, 500)
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH, bot, 'none', nil
        end
    end

    if J.IsDoingTormentor(bot)
    then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, 500)
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH, bot, 'none', nil
        end
    end

	return BOT_ACTION_DESIRE_NONE
end

-- Ogre Seal Totem
X.ConsiderItemDesire["item_ogre_seal_totem"] = function(hItem)
	local nFlopRadius = 275
	local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), nFlopRadius * 2)

	if J.IsGoingOnSomeone(bot)
	then
		local nInRangeAlly = bot:GetNearbyHeroes(1000, false, BOT_MODE_NONE)

		if  J.IsValidTarget(botTarget)
		and J.CanCastOnNonMagicImmune(botTarget)
		and bot:IsFacingLocation(botTarget:GetLocation(), 5)
		and J.IsInRange(bot, botTarget, nFlopRadius * 2)
		and not J.IsInRange(bot, botTarget, nFlopRadius - 75)
		and not bot:HasModifier('modifier_abaddon_borrowed_time')
		and not bot:HasModifier('modifier_necrolyte_reapers_scythe')
		and not J.IsLocationInChrono(botTarget:GetLocation())
		and not J.IsLocationInBlackHole(botTarget:GetLocation())
		then
			local nTargetInRangeAlly = botTarget:GetNearbyHeroes(1000, false, BOT_MODE_NONE)

			if  nInRangeAlly ~= nil and nTargetInRangeAlly ~= nil
			and #nInRangeAlly >= #nTargetInRangeAlly
			then
				return BOT_ACTION_DESIRE_HIGH, bot, 'unit', nil
			end
		end
	end

	if J.IsRetreating(bot)
	then	
		if  J.IsValidHero(nInRangeEnemy[1])
		and J.IsRunning(nInRangeEnemy[1])
		and bot:IsFacingLocation(J.GetEscapeLoc(), 15)
		and nInRangeEnemy[1]:IsFacingLocation(bot:GetLocation(), 30)
		then
			return BOT_ACTION_DESIRE_HIGH, bot, 'none', nil
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

-- Doubloon
local currState = 'health'
X.ConsiderItemDesire["item_doubloon"] = function(hItem)
	local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1000)

	if J.IsGoingOnSomeone(bot)
	then
		local nInRangeAlly = bot:GetNearbyHeroes(1000, false, BOT_MODE_NONE)

		if  J.IsValidTarget(botTarget)
		and J.IsInRange(bot, botTarget, 1000)
		and J.GetHP(bot) > 0.8
		and J.GetMP(bot) < 0.5
		and currState == 'mana'
		and not J.IsSuspiciousIllusion(botTarget)
		then
			currState = 'health'
			return BOT_ACTION_DESIRE_HIGH, bot, 'none', nil
		end
	end

	if J.IsRetreating(bot)
	then	
		if  J.IsValidHero(nInRangeEnemy[1])
		and J.IsRunning(nInRangeEnemy[1])
		and nInRangeEnemy[1]:IsFacingLocation(bot:GetLocation(), 30)
		and bot:WasRecentlyDamagedByAnyHero(1.5)
		and J.GetHP(bot) < 0.5
		and J.GetMP(bot) > 0.75
		and currState == 'health'
		then
			currState = 'mana'
			return BOT_ACTION_DESIRE_HIGH, bot, 'none', nil
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

-- TIER 4

-- Ninja Gear
X.ConsiderItemDesire["item_ninja_gear"] = function(hItem)
	local nCastRange = 1600

	if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
		and J.CanCastOnMagicImmune(botTarget)
		and J.IsInRange(bot, botTarget, 2800)
		and not J.IsInRange(bot, botTarget, botTarget:GetCurrentVisionRange() + 200)
		then
			local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(800, true)
			local nEnemyTowers = bot:GetNearbyTowers(888, true)

			if  nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps == 0
			and nEnemyTowers ~= nil and #nEnemyTowers == 0
			then
				return BOT_ACTION_DESIRE_HIGH, bot, 'none', nil
			end
		end
	end

	if J.IsDefending(bot)
	then
		local nMode = bot:GetActiveMode()
		local nLane = LANE_MID

		if nMode == BOT_MODE_PUSH_TOWER_TOP then nLane = LANE_TOP end
		if nMode == BOT_MODE_PUSH_TOWER_BOT then nLane = LANE_BOT end

		local nPushLoc = GetLaneFrontLocation(GetTeam(), nLane, 0)
		if GetUnitToLocationDistance(bot, nPushLoc) > 3200
		then
			return BOT_ACTION_DESIRE_HIGH, bot, 'none', nil
		end
	end

	if J.IsDoingRoshan(bot)
    then
        if  J.CheckTimeOfDay() == 'day'
        and GetUnitToLocationDistance(bot, roshanRadiantLoc) > 3200
        then
            return BOT_ACTION_DESIRE_HIGH, bot, 'none', nil
		end

		if  J.CheckTimeOfDay() == 'night'
        and GetUnitToLocationDistance(bot, roshanDireLoc) > 3200
        then
            return BOT_ACTION_DESIRE_HIGH, bot, 'none', nil
        end
    end

	return BOT_ACTION_DESIRE_NONE
end

-- Trickster Cloak
X.ConsiderItemDesire["item_trickster_cloak"] = function(hItem)
	return X.ConsiderItemDesire["item_invis_sword"](hItem)
end

-- Havoc Hammer
X.ConsiderItemDesire["item_havoc_hammer"] = function(hItem)
	local nRadius = 400
	local nDamage = 175 + bot:GetAttributeValue(ATTRIBUTE_STRENGTH) * 1.5

	local nEnemyHeroes = bot:GetNearbyHeroes(nRadius, true, BOT_MODE_NONE)
    for _, enemyHero in pairs(nEnemyHeroes)
    do
        if  J.IsValidHero(enemyHero)
        and J.CanCastOnNonMagicImmune(enemyHero)
        and J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
        and not enemyHero:HasModifier('modifier_abaddon_borrowed_time')
        and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
        and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
        and not enemyHero:HasModifier('modifier_templar_assassin_refraction_absorb')
        then
            return BOT_ACTION_DESIRE_HIGH, bot, 'none', nil
        end
    end

	if J.IsInTeamFight(bot, 1200)
	then
		local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1000)

		if J.IsValidHero(nInRangeEnemy[1]) and #nInRangeEnemy >= 2 
        then
            local realEnemyCount = J.GetEnemiesNearLoc(bot:GetLocation(), nRadius)

            if  realEnemyCount ~= nil and #realEnemyCount >= 2
            and not J.IsLocationInChrono(nInRangeEnemy[1]:GetLocation())
            and not J.IsLocationInBlackHole(nInRangeEnemy[1]:GetLocation())
            then
                return BOT_ACTION_DESIRE_HIGH, bot, 'none', nil
            end
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		local nInRangeAlly = bot:GetNearbyHeroes(1000, false, BOT_MODE_NONE)

		if  J.IsValidTarget(botTarget)
		and J.CanCastOnNonMagicImmune(botTarget)
		and J.IsInRange(bot, botTarget, nRadius)
		and J.IsRunning(botTarget)
		and bot:IsFacingLocation(botTarget:GetLocation(), 30)
		and not botTarget:IsFacingLocation(bot:GetLocation(), 90)
		and not J.IsDisabled(botTarget)
		then
			return BOT_ACTION_DESIRE_HIGH, bot, 'none', nil
		end
	end

	if J.IsDoingRoshan(bot)
    then
        if  J.IsRoshan(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH, bot, 'none', nil
        end
    end

    if J.IsDoingTormentor(bot)
    then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH, bot, 'none', nil
        end
    end

	return BOT_ACTION_DESIRE_NONE
end

-- Martyrdom
X.ConsiderItemDesire["item_martyrs_plate"] = function(hItem)
	local nRadius = 900

	if J.IsInTeamFight(bot)
	then
		local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), nRadius)
		local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), nRadius)

		if nInRangeEnemy ~= nil and #nInRangeEnemy >= 2
		then
			if  J.IsValidHero(nInRangeEnemy[1])
			and J.IsValidHero(nInRangeEnemy[2])
			and J.IsAttacking(nInRangeEnemy[1])
			and J.IsAttacking(nInRangeEnemy[2])
			and J.GetHP(bot) > 0.88
			and bot:GetHealth() >= 3800
			and not bot:WasRecentlyDamagedByAnyHero(0.8)
			then
				return BOT_ACTION_DESIRE_HIGH, bot, 'none', nil
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

-- TIER 5

-- Force Boots
X.ConsiderItemDesire["item_force_boots"] = function( hItem )
	local nCastRange = 700 
	local nInRangeEnemy = bot:GetNearbyHeroes(nCastRange, true, BOT_MODE_NONE)

	if J.IsStuck(bot)
	then
		return BOT_ACTION_DESIRE_HIGH, bot, 'unit', nil
	end

	if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidTarget(botTarget)
		and J.IsInRange(bot, botTarget, 900)
		and X.IsWithoutSpellShield(botTarget)
		and not J.IsSuspiciousIllusion(botTarget)
		and not botTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
		and not botTarget:HasModifier('modifier_enigma_black_hole_pull')
		and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			local nInRangeAlly = bot:GetNearbyHeroes(1200, false, BOT_MODE_NONE)
			local nTargetInRangeAlly = botTarget:GetNearbyHeroes(1200, false, BOT_MODE_NONE)

			if  nInRangeAlly ~= nil and nTargetInRangeAlly ~= nil
			and #nInRangeAlly >= #nTargetInRangeAlly
			then
				if  bot:IsFacingLocation(botTarget:GetLocation(), 15)
				and #nInRangeAlly >= #nTargetInRangeAlly + 1
				then
					return BOT_ACTION_DESIRE_HIGH, bot, 'unit', nil
				end

				local allyCenterLocation = J.GetCenterOfUnits(nInRangeAlly)
				if  botTarget:IsFacingLocation(allyCenterLocation, 15)
				and GetUnitToLocationDistance(bot, allyCenterLocation ) >= 750
				then
					return BOT_ACTION_DESIRE_HIGH, botTarget, 'unit', nil
				end	
			end		
		end
	end

	if J.IsRetreating(bot)
	then
		if  nInRangeEnemy ~= nil and #nInRangeEnemy >= 1
		and bot:IsFacingLocation(J.GetEscapeLoc(), 30)
		and bot:DistanceFromFountain() > 600
		and not J.IsRealInvisible(bot)
		then
			return BOT_ACTION_DESIRE_HIGH, bot, 'unit', nil
		end
	end

	local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), nCastRange)
	for _, allyHero in pairs(nInRangeAlly)
	do
		if  J.IsValidHero(allyHero)
		and J.CanCastOnNonMagicImmune(allyHero)
		then
			local nAllyInRangeEnemy = allyHero:GetNearbyHeroes(1200, true, BOT_MODE_NONE)

			if  nAllyInRangeEnemy ~= nil and #nAllyInRangeEnemy >= 1
			and J.IsRetreating(allyHero)
			and allyHero:IsFacingLocation(J.GetEscapeLoc(), 30)
			and allyHero:DistanceFromFountain() > 600
			and allyHero:WasRecentlyDamagedByAnyHero(2.2)
			and not J.IsRealInvisible(allyHero)
			then
				return BOT_ACTION_DESIRE_HIGH, allyHero, 'unit', nil
			end

			if J.IsGoingOnSomeone(allyHero)
			then
				local allyTarget = J.GetProperTarget(allyHero)

				if  J.IsValidHero(allyTarget)
				and J.CanCastOnNonMagicImmune(allyTarget)
				and allyHero:IsFacingLocation(allyTarget:GetLocation(), 15 )
				and GetUnitToUnitDistance(allyHero, allyTarget) > allyHero:GetAttackRange() + 50
				and GetUnitToUnitDistance(allyHero, allyTarget) < allyHero:GetAttackRange() + 700
				and J.IsRunning(allyTarget)
				and J.GetEnemyCount(allyHero, 1600) <= 3
				and not allyTarget:IsFacingLocation(allyHero:GetLocation(), 40)
				then
					return BOT_ACTION_DESIRE_HIGH, allyHero, 'unit', nil
				end
			end

			if J.IsStuck(allyHero)
			then
				return BOT_ACTION_DESIRE_HIGH, allyHero, 'unit', nil
			end
		end

	end

	if bot:DistanceFromFountain() < 2800
	then
		for _, enemyHero in pairs(nInRangeEnemy)
		do
			if  J.IsValidHero(enemyHero)
			and J.CanCastOnMagicImmune(enemyHero)
			and enemyHero:IsFacingLocation(GetAncient(GetTeam()):GetLocation(), 30)
			and GetUnitToLocationDistance(enemyHero, GetAncient(GetTeam()):GetLocation()) < 1600
			then
				local nInRangeAlly = bot:GetNearbyHeroes(1000, false, BOT_MODE_NONE)
				local nTargetInRangeAlly = enemyHero:GetNearbyHeroes(1000, false, BOT_MODE_NONE)

				if  nInRangeAlly ~= nil and nTargetInRangeAlly ~= nil
				and #nInRangeAlly >= #nTargetInRangeAlly
				then
					return BOT_ACTION_DESIRE_HIGH, enemyHero, 'unit', nil
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

-- Seer Stone
X.ConsiderItemDesire["item_seer_stone"] = function(hItem)
	local nRadius = 800

	-- In Fights
	if J.IsGoingOnSomeone(bot)
	then
		local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), 1600, nRadius, 0, 0)
		local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius)

		local targetHero = nil
		for _, enemyHero in pairs(nInRangeEnemy)
		do
			if J.IsValidHero(enemyHero)
			and J.IsInRange(bot, enemyHero, nRadius)
			and J.CanCastOnMagicImmune(enemyHero)
			and X.HasInvisibilityOrItem(enemyHero)
			and not enemyHero:HasModifier('modifier_slardar_amplify_damage')
			and not enemyHero:HasModifier('modifier_item_dustofappearance')
			and not J.Site.IsLocationHaveTrueSight(enemyHero:GetLocation())
			then
				return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, 'ground', nil
			end
		end

	end

	-- For Roshan Scout
	local nInSightEnemy = 0
	for _, enemyHero in pairs(GetUnitList(UNIT_LIST_ENEMY_HEROES))
	do
		if  J.IsValidHero(enemyHero)
		and not J.IsSuspiciousIllusion(enemyHero)
		then
			nInSightEnemy = nInSightEnemy + 1
		end
	end

	if  J.IsRoshanAlive()
	and nInSightEnemy == 0
	then
		if  J.CheckTimeOfDay() == 'day'
		and GetUnitToLocationDistance(bot, roshanRadiantLoc) > 1600
		then
			return BOT_ACTION_DESIRE_HIGH, roshanRadiantLoc, 'ground', nil
		end

		if  J.CheckTimeOfDay() == 'night'
		and GetUnitToLocationDistance(bot, roshanDireLoc) > 1600
		then
			return BOT_ACTION_DESIRE_HIGH, roshanDireLoc, 'ground', nil
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

-- Arcanist's Armor
X.ConsiderItemDesire["item_force_field"] = function(hItem)
	local nRadius = 1200
	local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), nRadius)


	for _, enemyHero in pairs(nInRangeEnemy)
	do
		if  J.IsValidHero(enemyHero)
		and enemyHero:GetAttackTarget() == bot
		and (bot:WasRecentlyDamagedByHero(enemyHero, 5)
			or J.IsAttackProjectileIncoming(bot, 500))
		and not J.IsSuspiciousIllusion(enemyHero)
		then
			return BOT_ACTION_DESIRE_HIGH, bot, 'none', nil
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

-- Pirate Hat
-- X.ConsiderItemDesire['item_pirate_hat'] = function(hItem)
-- 	return X.ConsiderItemDesire["item_trusty_shovel"](hItem)
-- end

-- Book of Shadows
X.ConsiderItemDesire["item_book_of_shadows"] = function( hItem )
	local nCastRange = 700 
	local nInRangeAlly = J.GetAlliesNearLoc(bot:GetLocation(), nCastRange)
	local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), 1200)

	for _, allyHero in pairs(nInRangeAlly)
	do
		if  J.IsValidHero(allyHero)
		and J.CanCastOnNonMagicImmune(allyHero)
		and allyHero:WasRecentlyDamagedByAnyHero(3)
		then
			local nAllyInRangeEnemy = allyHero:GetNearbyHeroes(1200, true, BOT_MODE_NONE)

			if nAllyInRangeEnemy ~= nil and #nAllyInRangeEnemy >= 1
			and J.IsRetreating(allyHero)
			and not J.IsRealInvisible(allyHero)
			and not J.IsDisabled(allyHero)
			and allyHero:DistanceFromFountain() > 1200
			then
				return BOT_ACTION_DESIRE_HIGH, allyHero, 'unit', nil
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

-- Ripper's Lash
X.ConsiderItemDesire["item_rippers_lash"] = function( hItem )
	local nCastRange = 700
	local nRadius = 200

	local nAllyHeroes = J.GetAlliesNearLoc(bot:GetLocation(), nCastRange)
	for _, allyHero in pairs(nAllyHeroes) do
		if J.IsValidHero(allyHero) and not allyHero:IsIllusion() then
			local hAllyTarget = allyHero:GetAttackTarget()
			if J.IsGoingOnSomeone(allyHero) and J.IsAttacking(allyHero) then
				if J.IsValidHero(hAllyTarget)
				and J.CanBeAttacked(hAllyTarget)
				and J.IsInRange(allyHero, hAllyTarget, allyHero:GetAttackRange() + 50)
				and J.IsInRange(bot, hAllyTarget, nCastRange)
				and not J.IsSuspiciousIllusion(hAllyTarget)
				and not hAllyTarget:HasModifier('modifier_abaddon_borrowed_time')
				and not hAllyTarget:HasModifier('modifier_necrolyte_reapers_scythe')
				and not hAllyTarget:HasModifier('modifier_dazzle_shallow_grave')
				then
					local nLocationAoE = bot:FindAoELocation(true, true, hAllyTarget:GetLocation(), 0, nRadius, 0, 0)
					if nLocationAoE.count >= 2 then
						return BOT_ACTION_DESIRE_HIGH, nLocationAoE.targetloc, 'point', nil
					else
						return BOT_ACTION_DESIRE_HIGH, hAllyTarget:GetLocation(), 'point', nil
					end
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

-- Gale Guard
X.ConsiderItemDesire["item_gale_guard"] = function( hItem )
    local nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	if bot:HasModifier('modifier_abaddon_aphotic_shield') or not J.CanBeAttacked(bot) then
		return BOT_ACTION_DESIRE_NONE
	end

	if bot:IsRooted() and #nEnemyHeroes > 0 then
		return BOT_ACTION_DESIRE_HIGH, bot, 'none', nil
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.IsInRange(bot, botTarget, bot:GetAttackRange() + 300)
		and (J.GetHP(bot) < 0.65 and bot:WasRecentlyDamagedByAnyHero(3.0))
		and not J.IsSuspiciousIllusion(botTarget)
		then
			return BOT_ACTION_DESIRE_HIGH, bot, 'none', nil
		end
	end

	if J.IsRetreating(bot) and not J.IsRealInvisible(bot) then
		for _, enemyHero in pairs(nEnemyHeroes) do
            if J.IsValidHero(enemyHero)
            and J.IsInRange(bot, enemyHero, 800)
            and J.IsChasingTarget(enemyHero, bot)
			and not J.IsSuspiciousIllusion(enemyHero)
            then
                if #nEnemyHeroes > #nAllyHeroes or (J.GetHP(bot) < 0.55 and bot:WasRecentlyDamagedByAnyHero(3.0)) then
                    return BOT_ACTION_DESIRE_HIGH, bot, 'none', nil
                end
            end
        end
	end

    if J.IsFarming(bot) then
        local nEnemyCreeps = bot:GetNearbyCreeps(1600, true)
        if  J.IsValid(nEnemyCreeps[1])
        and J.CanBeAttacked(nEnemyCreeps[1])
        and J.GetHP(bot) < 0.25
        and J.IsAttacking(bot)
        then
            return BOT_ACTION_DESIRE_HIGH, bot, 'none', nil
        end
    end

    if J.IsDoingRoshan(bot) then
        if  J.IsRoshan(botTarget)
		and J.CanBeAttacked(botTarget)
        and J.IsInRange(bot, botTarget, 500)
        and J.IsAttacking(bot)
		and J.GetHP(bot) < 0.5
        then
			return BOT_ACTION_DESIRE_HIGH, bot, 'none', nil
        end
    end

    if J.IsDoingTormentor(bot) then
        if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, 400)
        and J.IsAttacking(bot)
		and J.GetHP(bot) < 0.5
        then
			return BOT_ACTION_DESIRE_HIGH, bot, 'none', nil
        end
    end

	return BOT_ACTION_DESIRE_NONE
end

-- Pyrrhic Cloak
X.ConsiderItemDesire["item_pyrrhic_cloak"] = function( hItem )
	local nCastRange = J.GetProperCastRange(false, bot, hItem:GetCastRange())

    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	if J.IsNotAttackProjectileIncoming(bot, 400)
	and J.IsValidHero(nEnemyHeroes[1])
	and J.IsInRange(bot, nEnemyHeroes[1], nCastRange)
	and J.CanCastOnNonMagicImmune(nEnemyHeroes[1])
	and J.CanCastOnTargetAdvanced(nEnemyHeroes[1])
	then
		return BOT_ACTION_DESIRE_HIGH, nEnemyHeroes[1], 'unit', nil
	end

	for _, enemyHero in pairs(nEnemyHeroes)do
		if J.IsValidHero(enemyHero)
		and J.IsInRange(bot, enemyHero, nCastRange)
		and J.CanCastOnNonMagicImmune(enemyHero)
		and J.CanCastOnTargetAdvanced(enemyHero)
		and (enemyHero:GetAttackTarget() == bot)
		and (bot:WasRecentlyDamagedByHero(enemyHero, 3.0) or J.IsAttackProjectileIncoming(bot, 1000))
		then
			return BOT_ACTION_DESIRE_HIGH, enemyHero, 'unit', nil
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

-- Kobold Cup
X.ConsiderItemDesire["item_kobold_cup"] = function( hItem )
	local nRadius = hItem:GetSpecialValueInt('buff_radius')

	if J.IsInTeamFight(bot, 1200) then
		local nInRangeEnemy = J.GetEnemiesNearLoc(bot:GetLocation(), nRadius)
		if #nInRangeEnemy >= 2 then
			return BOT_ACTION_DESIRE_HIGH, bot, 'none', nil
		end
	end

	if J.IsGoingOnSomeone(bot) then
		if J.IsValidHero(botTarget)
		and J.CanBeAttacked(botTarget)
		and J.CanCastOnNonMagicImmune(botTarget)
		and not J.IsSuspiciousIllusion(botTarget)
		and J.IsChasingTarget(botTarget)
		and not J.IsInRange(bot, botTarget, bot:GetAttackRange())
		then
			return BOT_ACTION_DESIRE_HIGH, bot, 'none', nil
		end
	end

	local nEnemyHeroes = bot:GetNearbyHeroes(nRadius, true, BOT_MODE_NONE)
	if J.IsRetreating(bot) then
		for _, enemy in ipairs(nEnemyHeroes) do
			if J.IsValidHero(enemy)
			and J.CanCastOnNonMagicImmune(enemy)
			and not J.IsSuspiciousIllusion(enemy)
			then
				if J.IsChasingTarget(enemy, bot) and enemy:GetCurrentMovementSpeed() > bot:GetCurrentMovementSpeed() + 30 then
					return BOT_ACTION_DESIRE_HIGH, bot, 'none', nil
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

-- Outworld Staff
X.ConsiderItemDesire["item_outworld_staff"] = function( hItem )
	local fHealthPctDamage = hItem:GetSpecialValueInt('self_dmg_pct') / 100
	local fHealthAfter = J.GetHealthAfter(bot:GetMaxHealth() * fHealthPctDamage)

	if fHealthAfter > 0.2 then
		local tableChased = {false, nil}
		local nEnemyHeroes = bot:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
		for _, enemy in ipairs(nEnemyHeroes) do
			if J.IsValidHero(enemy) and not J.IsSuspiciousIllusion(enemy) and J.IsChasingTarget(enemy, bot) then
				tableChased = {true, enemy}
				break
			end
		end

		local attackerCount = 0
		for _, enemy in ipairs(nEnemyHeroes) do
			if J.IsValidHero(enemy)
			and not J.IsSuspiciousIllusion(enemy)
			and not enemy:HasModifier('modifier_necrolyte_reapers_scythe')
			then
				if enemy:GetAttackTarget() == bot then
					attackerCount = attackerCount + 1
				end
			end
		end

		if J.IsInTeamFight(bot, 1200) then
			if attackerCount >= 3 then
				return BOT_ACTION_DESIRE_HIGH, bot, 'none', nil
			end
		end
	
		if (J.IsUnitTargetProjectileIncoming(bot, 400) and (not tableChased[1] or (tableChased[1] and not J.IsInRange(bot, tableChased[2], tableChased[2]:GetAttackRange() + 200))))
		or (J.IsStunProjectileIncoming(bot, 400) and (not tableChased[1] or (tableChased[1] and not J.IsInRange(bot, tableChased[2], tableChased[2]:GetAttackRange() + 200))))
		or (not bot:HasModifier('modifier_sniper_assassinate') and not bot:IsMagicImmune() and J.IsWillBeCastUnitTargetSpell(bot, 400))
		then
			return BOT_ACTION_DESIRE_HIGH, bot, 'none', nil
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

function X.IsTargetedByEnemy( building )

	local heroList = GetUnitList( UNIT_LIST_ENEMY_HEROES )
	for _, hero in pairs( heroList )
	do
		if J.IsValidHero(hero)
		and ( GetUnitToUnitDistance( building, hero ) <= hero:GetAttackRange() + 200
			and hero:GetAttackTarget() == building )
		then
			return true
		end
	end

	return false

end

function X.IsHeroVisible(hHeroList, nRadius, sHeroName)
	for _, hero in pairs(hHeroList) do
		if J.IsValidHero(hero) and not J.IsSuspiciousIllusion(hero) then
			if hero:GetUnitName() == sHeroName then
				return true
			end
		end
	end

	return false
end

function X.IsItemCarrierVisible(hHeroList, nRadius, sItemName)
	for _, hero in pairs(hHeroList) do
		if J.IsValidHero(enemy) and not J.IsSuspiciousIllusion(enemy) then
			local slot = enemy:FindItemSlot(hItemName)
			if sItemName == 'item_giants_ring' and slot == 16 then
				return true
			end

			if slot >= 0 and slot <= 5 then
				return true
			end
		end
	end

	return false
end

local function UseGlyph()

	if GetGlyphCooldown( ) > 0
		or DotaTime() < 60
		or bot ~= GetTeamMember( 1 )
		or not GetTeamMember( 2 ):IsBot()
		or not GetTeamMember( 3 ):IsBot()
		or not GetTeamMember( 4 ):IsBot()
		or not GetTeamMember( 5 ):IsBot()
	then
		return
	end

	local T1 = {
		TOWER_TOP_1,
		TOWER_MID_1,
		TOWER_BOT_1,
		TOWER_TOP_2,
		TOWER_MID_2,
		TOWER_BOT_2,
		TOWER_TOP_3,
		TOWER_MID_3,
		TOWER_BOT_3,
		TOWER_BASE_1,
		TOWER_BASE_2
	}

	for _, t in pairs( T1 )
	do
		local tower = GetTower( GetTeam(), t )
		if tower ~= nil and tower:GetHealth() > 0
			and tower:GetHealth() / tower:GetMaxHealth() < 0.36
			and tower:CanBeSeen()
			and X.IsTargetedByEnemy(tower)
		then
			bot:ActionImmediate_Glyph( )
			return
		end
	end


	local MeleeBarrack = {
		BARRACKS_TOP_MELEE,
		BARRACKS_MID_MELEE,
		BARRACKS_BOT_MELEE
	}

	for _, b in pairs( MeleeBarrack )
	do
		local barrack = GetBarracks( GetTeam(), b )
		if barrack ~= nil and barrack:GetHealth() > 0
			and barrack:GetHealth() / barrack:GetMaxHealth() < 0.5
			and X.IsTargetedByEnemy( barrack )
		then
			bot:ActionImmediate_Glyph( )
			return
		end
	end

	local Ancient = GetAncient( GetTeam() )
	if Ancient ~= nil and Ancient:GetHealth() > 0
		and Ancient:GetHealth() / Ancient:GetMaxHealth() < 0.5
		and X.IsTargetedByEnemy( Ancient )
	then
		bot:ActionImmediate_Glyph( )
		return
	end

end

-- store some bot values for last n sec
local history = {}
local timeDelta = 10
local currIdx = 0

for i = 1, timeDelta do history[i] = {health = 0, location = bot:GetLocation()} end

function X.UpdateBotHistory()
	currIdx = (currIdx % timeDelta) + 1
	history[timeDelta + 1 - currIdx] = {
		health = bot:GetHealth(),
		location = bot:GetLocation(),
	}

	if bot.history == nil then bot.history = {} end

	bot.history = history
end

function ItemUsageThink()
	if bot.farm and bot.farm.state == 2 then return end

	ItemUsageComplement()

	BotBuild.SkillsComplement()
end

function AbilityUsageThink()

end

local fLastTime = 0
function BuybackUsageThink()
	local fCurrTime = DotaTime()
	if fCurrTime - fLastTime >= 1.0 then
		X.UpdateBotHistory()
		fLastTime = fCurrTime
	end

	-- BotBuild.SkillsComplement()

	-- ItemUsageComplement()

	BuybackUsageComplement()

	UseGlyph()

end

function CourierUsageThink()

	CourierUsageComplement()

end

function AbilityLevelUpThink()

	AbilityLevelUpComplement()

end
