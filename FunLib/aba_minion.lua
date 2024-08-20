local X = {}

local bot = GetBot()
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local U = require(GetScriptDirectory()..'/FunLib/MinionLib/utils')

local AttackingWards = require(GetScriptDirectory()..'/FunLib/MinionLib/attacking_wards')
local BrewLink = require(GetScriptDirectory()..'/FunLib/MinionLib/brew_link')
local Familiars = require(GetScriptDirectory()..'/FunLib/MinionLib/familiars')
local Illusion = require(GetScriptDirectory()..'/FunLib/MinionLib/illusions')
local MinionWithSkill = require(GetScriptDirectory()..'/FunLib/MinionLib/minion_with_skill')
local VengefulSprit = require(GetScriptDirectory()..'/FunLib/MinionLib/vengeful_spirit')

local nTeamAncient = GetAncient(GetTeam());
local vTeamAncientLoc = nil;
if nTeamAncient ~= nil then vTeamAncientLoc = nTeamAncient:GetLocation() end;

function X.HealingWardThink(minion)

	local nEnemyHeroes = minion:GetNearbyHeroes( 1200, true, BOT_MODE_DESIRE_NONE )

	local targetLocation = nil
	local weakestHero = nil
	local weakestHP = 0.99
	for i = 1, 5
	do 
		local allyHero = GetTeamMember( i )
		if allyHero ~= nil
			and allyHero:IsAlive()
			and GetUnitToUnitDistance( allyHero, minion ) <= 1200
		then
			local allyHP = allyHero:GetHealth()/allyHero:GetMaxHealth()
			if allyHP < weakestHP
			then
				weakestHP = allyHP
				weakestHero = allyHero
			end
		end
	end

	if #nEnemyHeroes == 0
	then
	
		local nAoeHeroTable = minion:FindAoELocation( false, true, minion:GetLocation(), 1000, 400 , 0, 0);
		if nAoeHeroTable.count >= 2
		then
			targetLocation = nAoeHeroTable.targetloc
		end
		
		if targetLocation == nil
		then			
			if weakestHero ~= nil
			then
				targetLocation = weakestHero:GetLocation()
			end
		end

		if targetLocation == nil
		then			
			local nAoeCreepTable = minion:FindAoELocation( false, false, minion:GetLocation(), 800, 400 , 0, 0);
			if nAoeCreepTable.count >= 1
			then
				targetLocation = nAoeCreepTable.targetloc
			end			
		end
		
	else
		if weakestHero ~= nil
		then
			targetLocation = weakestHero:GetLocation()
		end	
	end

	

	if targetLocation ~= nil
	then
		if targetLocation == GetBot():GetLocation()
		then
		--自动人棒合一
			return
		else
			minion:Action_MoveToLocation( targetLocation )
		end
	else
		minion:Action_MoveToLocation( vTeamAncientLoc )
	end

end

-- For now
function X.IllusionThink(hMinionUnit)
	return X.MinionThink(hMinionUnit)
end

function X.IsValidUnit(hMinionUnit)
	return U.IsValidUnit(hMinionUnit)
end

-- MINION THINK
function X.MinionThink(hMinionUnit)
	if bot == nil then bot = GetBot() end

	if U.IsValidUnit(hMinionUnit)
	then
		if U.CantBeControlled(hMinionUnit)
		or U.IsShamanFowlPlayChicken(hMinionUnit)
		then
			return
		end

		-- Illusions; No Spells
		if (hMinionUnit:IsHero() and hMinionUnit:IsIllusion() and hMinionUnit:GetUnitName() ~= 'npc_dota_hero_vengefulspirit')
		or U.IsMinionWithNoSkill(hMinionUnit)
		then
			Illusion.Think(bot, hMinionUnit)
		end

		-- Vengeful Spirit Aghanim's Scepter Illusion
		if hMinionUnit:IsHero() and hMinionUnit:IsIllusion()
		and hMinionUnit:GetUnitName() == 'npc_dota_hero_vengefulspirit'
		then
			VengefulSprit.Think(bot, hMinionUnit)
		end

		-- Attacking Wards
		if U.IsAttackingWard(hMinionUnit) then AttackingWards.Think(bot, hMinionUnit) end

		-- Spell Casting Minions
		if U.IsMinionWithSkill(hMinionUnit) then MinionWithSkill.Think(bot, hMinionUnit) end

		-- Brewmaster's BrewLink
		if U.IsBrewLink(hMinionUnit) then BrewLink.Think(bot, hMinionUnit) end

		-- [BROKEN (7.37+)] Visage's Familiars
		if U.IsFamiliar(hMinionUnit) then Familiars.Think(bot, hMinionUnit) end
	end
end

return X
