if GetBot():IsInvulnerable() or not GetBot():IsHero() or not string.find(GetBot():GetUnitName(), "hero") or  GetBot():IsIllusion() then
	return;
end

local BotBuild = require( GetScriptDirectory() .. "/BotLib/" .. string.gsub(GetBot():GetUnitName(), "npc_dota_", "" ) )
if BotBuild == nil then return end
local sItemSellList = BotBuild['sSellList']

local J = require( GetScriptDirectory()..'/FunLib/jmz_func')
local Item = require( GetScriptDirectory()..'/FunLib/aba_item' )
local bot = GetBot();
local X = {}
local preferedShop = nil;
local RAD_SECRET_SHOP = GetShopLocation(GetTeam(), SHOP_SECRET )
local DIRE_SECRET_SHOP = GetShopLocation(GetTeam(), SHOP_SECRET2 )
local hasItemToSell = false;
local itemSlot = nil
local itemSlotFromSellList = {nil, -1}

local sell_time = -90

function GetDesire()
	preferedShop = X.GetPreferedSecretShop()

	if not bot:IsAlive() or J.IsModeTurbo() or not X.IsSuitableToBuy() then
		return BOT_MODE_DESIRE_NONE;
	end
	
	local invFull = true;
	
	for i=0,8 do 
		if bot:GetItemInSlot(i) == nil then
			invFull = false;
		end	
	end

	if DotaTime() > 0 and not J.IsInLaningPhase() then
		if (bot:GetItemInSlot( 6 ) ~= nil or bot:GetItemInSlot( 7 ) ~= nil or bot:GetItemInSlot( 8 ) ~= nil) then
			if bot.sItemSellList ~= nil then
				for i = #bot.sItemSellList , 2, -2 do
					local nItemToSellSlot = bot:FindItemSlot( bot.sItemSellList[i - 1] )
					local nItemToCheckSlot = bot:FindItemSlot( bot.sItemSellList[i] )

					local nItemToCheckSlot_lastComponent = -1
					local tItemComponent = GetItemComponents(bot.sItemSellList[i])[1]
					if tItemComponent ~= nil then
						nItemToCheckSlot_lastComponent = bot:FindItemSlot(tItemComponent[#tItemComponent])
					end

					if (nItemToCheckSlot >= 0 or nItemToCheckSlot_lastComponent >= 0) and nItemToSellSlot >= 0
					then
						itemSlotFromSellList = {nItemToSellSlot, i}
						return RemapValClamped(GetUnitToLocationDistance(bot, preferedShop), 6000, 0, 0.75, 0.95 );
					end
				end
			end

			if ( Item.HasItem( bot, "item_travel_boots" ) or Item.HasItem( bot, "item_travel_boots_2" ) )
			then
				for i = 1, #Item['tEarlyBoots'] do
					local bootsSlot = bot:FindItemSlot( Item['tEarlyBoots'][i] )
					if bootsSlot >= 0 then
						itemSlot = bootsSlot
						return RemapValClamped(  GetUnitToLocationDistance(bot, preferedShop), 6000, 0, 0.75, 0.95)
					end
				end
			end

			if Item.HasItem(bot, 'item_mask_of_madness') and Item.HasItem(bot, 'item_satanic') then
				itemSlot = bot:FindItemSlot('item_mask_of_madness')
				return RemapValClamped(GetUnitToLocationDistance(bot, preferedShop), 6000, 0, 0.75, 0.95)
			end
		end

		if Item['tEarlyItem'] ~= nil then
			for _,item in pairs(Item['tEarlyItem']) do
				local slot = bot:FindItemSlot(item)
				if slot >= 6 and slot <= 8 then
					if preferedShop ~= nil then
						itemSlot = slot
						return RemapValClamped(GetUnitToLocationDistance(bot, preferedShop), 6000, 0, 0.75, 0.90)
					end	
				end
			end
		end

		if J.IsLateGame() then
			local smokeSlot = bot:FindItemSlot('item_smoke_of_deceit')
			if smokeSlot >= 6 and smokeSlot <= 8 then
				itemSlot = smokeSlot
				return RemapValClamped(GetUnitToLocationDistance(bot, preferedShop), 6000, 0, 0.75, 0.90)
			end
		end
	end

	if invFull then
		if bot:GetLevel() >= 6 and bot:FindItemSlot("item_aegis") < 0 then
			hasItemToSell, itemSlot = X.HaveItemToSell();
			if hasItemToSell then
				if  preferedShop ~= nil then
					return RemapValClamped(  GetUnitToLocationDistance(bot, preferedShop), 6000, 0, 0.75, 0.95 );
				end	
			end
		end
		return BOT_MODE_DESIRE_NONE;
	end
	
	local npcCourier = bot.theCourier
	local cState = GetCourierState( npcCourier );
	
	if bot.SecretShop and cState ~= COURIER_STATE_MOVING  then
		if  preferedShop ~= nil and cState == COURIER_STATE_DEAD then
			return RemapValClamped(  GetUnitToLocationDistance(bot, preferedShop), 6000, 0, 0.7, 0.85 );
		else
			if preferedShop ~= nil and GetUnitToLocationDistance(bot, preferedShop) <= 3200 then
				return RemapValClamped(  GetUnitToLocationDistance(bot, preferedShop), 3200, 0, 0.7, 0.85 );
			end
		end
	end
	
	return BOT_MODE_DESIRE_NONE

end

function OnStart()

end

function OnEnd()

end

function Think()

	if  bot:IsChanneling() 
		or bot:NumQueuedActions() > 0
		or bot:IsCastingAbility()
		or bot:IsUsingAbility()
	then 
		return
	end

	if bot:DistanceFromSecretShop() <= 200 and DotaTime() > sell_time + 1.0 then
		if bot.sItemSellList ~= nil then
			if itemSlotFromSellList[1] ~= nil and bot:GetItemInSlot(itemSlotFromSellList[1]) ~= nil then
				bot:ActionImmediate_SellItem(bot:GetItemInSlot(itemSlotFromSellList[1]))
				if bot.secret_shop_succesful == true then
					table.remove(sItemSellList, itemSlotFromSellList[2])
					table.remove(sItemSellList, itemSlotFromSellList[2] - 1)
				end
				itemSlot = nil
				itemSlotFromSellList = {nil, -1}
				return
			end
		end
	
		if itemSlot ~= nil and bot:GetItemInSlot(itemSlot) ~= nil then
			bot:ActionImmediate_SellItem(bot:GetItemInSlot(itemSlot))
			itemSlot = nil
			itemSlotFromSellList = {nil, -1}
			return
		end
		sell_time = DotaTime()
	
		-- if itemSlot ~= nil and itemSlot >= 0 and bot:DistanceFromSecretShop() <= 200 then
		-- 	print('debug 2', itemSlot, bot:GetUnitName())
		-- 	bot:ActionImmediate_SellItem(bot:GetItemInSlot(itemSlot))
		-- 	itemSlot = nil
		-- 	return
		-- end
	end

	if bot:DistanceFromSecretShop() > 0
	then
		bot:Action_MoveToLocation(preferedShop + RandomVector(20));
		return;
	end
	
end

function X.HaveItemToSell()
	if Item['tEarlyItem'] ~= nil then
		for _,item in pairs(Item['tEarlyItem'])
		do
			local slot = bot:FindItemSlot(item)
			if slot >= 0 and slot <= 8 then
				return true, slot
			end
		end
	end

	return false, nil
end

function X.GetPreferedSecretShop()
	if GetTeam() == TEAM_RADIANT then
		if GetUnitToLocationDistance(bot, DIRE_SECRET_SHOP) <= 3800 then
			return DIRE_SECRET_SHOP;
		else
			return RAD_SECRET_SHOP;
		end
	elseif GetTeam() == TEAM_DIRE then
		if GetUnitToLocationDistance(bot, RAD_SECRET_SHOP) <= 3800 then
			return RAD_SECRET_SHOP;
		else
			return DIRE_SECRET_SHOP;
		end
	end
	return nil;
end

function X.IsSuitableToBuy()
	local mode = bot:GetActiveMode();
	local Enemies = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE);
	if not bot:IsAlive() 
		or bot:HasModifier("modifier_item_shadow_amulet_fade")
		or ( mode == BOT_MODE_RETREAT and bot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH )
		or mode == BOT_MODE_ATTACK
		or mode == BOT_MODE_DEFEND_ALLY
		or ( Enemies ~= nil and #Enemies >= 2 )
		or ( J.IsValid(Enemies[1]) and X.IsStronger(bot, Enemies[1]) )
		or GetUnitToUnitDistance(bot, GetAncient(GetTeam())) < 2300 
		or GetUnitToUnitDistance(bot, GetAncient(GetOpposingTeam())) < 3500  
	then
		return false;
	end
	return true;
end

function X.IsStronger(bot, enemy)
	local BPower = bot:GetEstimatedDamageToTarget(true, enemy, 4.0, DAMAGE_TYPE_ALL);
	local EPower = enemy:GetEstimatedDamageToTarget(true, bot, 4.0, DAMAGE_TYPE_ALL);
	return EPower > BPower;
end