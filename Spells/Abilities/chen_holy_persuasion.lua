local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local HolyPersuasion

function X.Cast()
    bot = GetBot()
    HolyPersuasion = bot:GetAbilityByName('chen_holy_persuasion')

    if bot.ChenCreepList == nil then bot.ChenCreepList = {} end

    Desire, Target = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(HolyPersuasion, Target)
        return
    end
end

function X.Consider()
    if not HolyPersuasion:IsFullyCastable()
    then
		return BOT_ACTION_DESIRE_NONE, nil
	end

    local nCastRange = J.GetProperCastRange(false, bot, HolyPersuasion:GetCastRange())
    local nMaxUnit = HolyPersuasion:GetSpecialValueInt('max_units')
    local nMaxLevel = HolyPersuasion:GetSpecialValueInt('level_req')
	local nNeutralCreeps = bot:GetNearbyNeutralCreeps(nCastRange)

    local unitTable = {}
    for _, unit in pairs(GetUnitList(UNIT_LIST_ALLIES))
    do
        if string.find(unit:GetUnitName(), 'neutral')
        and unit:HasModifier('modifier_chen_holy_persuasion')
        then
            table.insert(unitTable, unit)
        end
    end

    bot.ChenCreepList = unitTable

    local nGoodCreep = {
        "npc_dota_neutral_alpha_wolf",
        "npc_dota_neutral_centaur_khan",
        "npc_dota_neutral_polar_furbolg_ursa_warrior",
        "npc_dota_neutral_dark_troll_warlord",
        "npc_dota_neutral_satyr_hellcaller",
        "npc_dota_neutral_enraged_wildkin",
        "npc_dota_neutral_warpine_raider",
    }

    if nMaxLevel < 5
    then
        for _, creep in pairs(nNeutralCreeps)
        do
            if J.IsValid(creep)
            then
                return BOT_ACTION_DESIRE_HIGH, creep
            end
        end
    else
        if bot.ChenCreepList ~= nil and #bot.ChenCreepList < nMaxUnit
        then
            for _, creep in pairs(nNeutralCreeps)
            do
                if J.IsValid(creep)
                and creep:GetLevel() <= nMaxLevel
                then
                    for _, gCreep in pairs(nGoodCreep)
                    do
                        if creep:GetUnitName() == gCreep
                        then
                            return BOT_ACTION_DESIRE_HIGH, creep
                        end
                    end
                end
            end
        end
    end

	return BOT_ACTION_DESIRE_NONE, nil
end

return X