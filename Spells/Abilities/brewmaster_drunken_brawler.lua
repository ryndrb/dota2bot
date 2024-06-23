local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local DrunkenBrawler

function X.Cast()
    bot = GetBot()
    DrunkenBrawler = bot:GetAbilityByName('brewmaster_drunken_brawler')

    if bot.drunkenBrawlerState == nil and DotaTime() < 0 then bot.drunkenBrawlerState = 1 end

    Desire, ActionType = X.Consider()
    if Desire > 0
    and DotaTime() > 0
    then
        if ActionType ~= nil
        then
            local curr = bot.drunkenBrawlerState
            local state = 1
            local steps = 0

            if ActionType == 'engage'
            then
                if bot.drunkenBrawlerState == 4 then return end
                state = 4
            elseif ActionType == 'retreat'
            then
                if bot.drunkenBrawlerState == 2 then return end
                state = 2
            elseif ActionType == 'farming'
            then
                if bot.drunkenBrawlerState == 3 then return end
                state = 3
            elseif ActionType == 'weak'
            then
                if bot.drunkenBrawlerState == 1 then return end
                state = 1
            end

            steps = ((state - curr) + 4) % 4
            if steps > 0
            then
                for _ = 1, steps
                do
                    bot:Action_UseAbility(DrunkenBrawler)
                    bot.drunkenBrawlerState = bot.drunkenBrawlerState + 1
                    if bot.drunkenBrawlerState > 4 then bot.drunkenBrawlerState = 1 end
                end
                return
            end
        end
    end
end

function X.Consider()
    if not DrunkenBrawler:IsFullyCastable()
    then
        return BOT_ACTION_DESIRE_NONE, nil
    end

    if J.GetHP(bot) < 0.33
    then
        return BOT_ACTION_DESIRE_HIGH, 'weak'
    end

    if J.IsGoingOnSomeone(bot)
    then
        return BOT_ACTION_DESIRE_HIGH, 'engage'
    end

    if J.IsLaning(bot) or J.IsFarming(bot)
    then
        return BOT_ACTION_DESIRE_HIGH, 'farming'
    end

    if J.IsRetreating(bot)
    and (bot:WasRecentlyDamagedByAnyHero(3))
    and not J.IsRealInvisible(bot)
    then
        return BOT_ACTION_DESIRE_HIGH, 'retreat'
    end

    return BOT_ACTION_DESIRE_NONE, nil
end

return X