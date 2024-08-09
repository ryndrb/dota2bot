require(GetScriptDirectory()..'/API/api_ability')
require(GetScriptDirectory()..'/API/api_global')
require(GetScriptDirectory()..'/API/api_unit')

local bot = GetBot()
local botName = bot:GetUnitName()

if bot:IsInvulnerable() 
	or not bot:IsHero() 
	or bot:IsIllusion()
	or not string.find( botName, "hero" )
then
	return
end


local BotBuild = dofile(GetScriptDirectory() .. "/BotLib/" .. string.gsub(bot:GetUnitName(), "npc_dota_", ""));


if BotBuild == nil
then
	return
end	


function MinionThink(hMinionUnit)

	BotBuild.MinionThink(hMinionUnit)
	
end