if Helper == nil
then
    Helper = {}
end

function Helper.IsCore(hero, team)
    if hero == team[1]
    or hero == team[2]
    or hero == team[3]
    then
        return true
    end

    return false
end

function Helper.DotaTime()
    local time = GameRules:GetDOTATime(false, false)
    if time == nil or time < 0 then return 0 end
    return time
end

function Helper.IsTurboMode()
    if GameRules:State_Get() == 10
    then
        return true
    end

    return false
end

return Helper