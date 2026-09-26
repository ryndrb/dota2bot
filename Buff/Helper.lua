if Helper == nil
then
    Helper = {}
end

function Helper.IsCore(hero, team)
    local position = Helper.GetPosition(hero, team)
    return position >= 1 and position <= 3
end

function Helper.GetPosition(hero, team)
    local posMap = {
        [1] = 2, [2] = 3, [3] = 1, [4] = 5, [5] = 4,
    }
    for i = 1, 5 do
        if team[i] and hero == team[i] then
            return posMap[i]
        end
    end

    return -1
end

function Helper.DotaTime()
    local time = GameRules:GetDOTATime(false, false)
    if time == nil or time < 0 then return 0 end
    return time
end

function Helper.IsTurboMode()
    local courier = Entities:FindByName(nil, 'npc_dota_courier')
    local moveSpeed = courier:GetMoveSpeedModifier(courier:GetBaseMoveSpeed(), true)

    if moveSpeed == 1100
    then
        return true
    end

    return false
end

function Helper.CanCastAbility(hAbility)
	if hAbility == nil
	or hAbility:IsNull()
	or hAbility:GetName() == ''
	or hAbility:IsPassive()
	or hAbility:IsHidden()
	or not hAbility:IsTrained()
	or not hAbility:IsFullyCastable()
	or not hAbility:IsActivated()
	then
		return false
	end

	return true
end

return Helper