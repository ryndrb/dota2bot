local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local U = require(GetScriptDirectory()..'/FunLib/MinionLib/utils')

local X = {}

function X.Think(bot, hMinionUnit)
	local minionAttackRange = hMinionUnit:GetAttackRange()

	local target = U.GetWeakestHero(minionAttackRange, hMinionUnit)
	if target == nil then
		target = U.GetWeakestCreep(minionAttackRange, hMinionUnit)
		if target == nil then
			target = U.GetWeakestTower(minionAttackRange, hMinionUnit)
		end
	end

	if target ~= nil and not U.IsNotAllowedToAttack(target) then
		hMinionUnit:Action_AttackUnit(target, true)
		return
	end
end

return X