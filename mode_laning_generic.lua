---------------------------------------------------------------------------
--- The Creation Come From: A Beginner AI 
--- Author: 决明子 Email: dota2jmz@163.com 微博@Dota2_决明子
--- Link:http://steamcommunity.com/sharedfiles/filedetails/?id=1573671599
--- Link:http://steamcommunity.com/sharedfiles/filedetails/?id=1627071163
---------------------------------------------------------------------------
if GetBot():IsInvulnerable() or not GetBot():IsHero() or not string.find(GetBot():GetUnitName(), "hero") or GetBot():IsIllusion() then
	return
end

local X = {}
local bot = GetBot()
local J = require( GetScriptDirectory()..'/FunLib/jmz_func')


function GetDesire()

	local currentTime = DotaTime()
	local botLV = bot:GetLevel()
	local networth = bot:GetNetWorth()
	local isBotCore = J.IsCore(bot)

	local e = bot:GetNearbyHeroes(1000, true, BOT_MODE_NONE)

	if (networth < 4500
	or botLV <= 8)
	and isBotCore
	then
		return BOT_MODE_DESIRE_HIGH
	end

	if DotaTime() > 0 and DotaTime() <= 10 * 60 then
		return BOT_ACTION_DESIRE_MODERATE
	end

	return BOT_MODE_DESIRE_NONE

	-- if currentTime <= 10
	-- then
	-- 	return 0.268
	-- end
	
	-- if currentTime <= 9 * 60
	-- 	and botLV <= 7
	-- then
	-- 	return 0.446
	-- end
	
	-- if currentTime <= 12 * 60
	-- 	and botLV <= 11
	-- then
	-- 	return 0.369
	-- end
	
	-- if botLV <= 17
	-- then
	-- 	return 0.228
	-- end

	-- return 0

end
-- dota2jmz@163.com QQ:2462331592..
