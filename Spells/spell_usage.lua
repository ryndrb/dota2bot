local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local S = require(GetScriptDirectory()..'/Spells/spell_list')
local C = require(GetScriptDirectory()..'/Spells/spell_combos')

local X = {}
local ConsiderAbility = {}

local function GetSpellList()
    local sAbilityList = J.Skill.GetAbilityList(GetBot())
    local abilities = {}
    for i = 1, 9
    do
        abilities[i] = sAbilityList[i]
    end

    return abilities
end

local abilities = GetSpellList()

local nAbilityPair = {
    ['Q'] = abilities[1],
    ['W'] = abilities[2],
    ['E'] = abilities[3],
    ['D'] = abilities[4],
    ['F'] = abilities[5],
    ['R'] = abilities[6],
    ['H1'] = abilities[7],
    ['H2'] = abilities[8],
    ['H3'] = abilities[9],
}

local function HasSpell(spellList, ability)
    return spellList[ability] ~= nil
end

local function LoadAbility(ability)
    if HasSpell(S['spells'], ability) and xpcall(function(spell) require(GetScriptDirectory()..'/Spells/Abilities/'..spell) end, function(err) print(err) end, ability) and not string.find(ability, 'rubick_empty')
    then
        return require(GetScriptDirectory()..'/Spells/Abilities/'..ability)
    else
        return nil
    end
end

local function InitConsiderAbility()
    for key, ability in pairs(nAbilityPair)
    do
        ConsiderAbility[key] = LoadAbility(ability)
    end
end

local function UpdateRubickAbilities()
    if GetBot():GetUnitName() == 'npc_dota_hero_rubick'
    then
        abilities = GetSpellList()
        ConsiderAbility['Q'] = LoadAbility(abilities[1])
        ConsiderAbility['D'] = LoadAbility(abilities[4])
        ConsiderAbility['F'] = LoadAbility(abilities[5])
    end
end

InitConsiderAbility()

function X.AbilityUsage(SpellOrder)
    UpdateRubickAbilities()

    for _, key in pairs(SpellOrder)
    do
        if string.find(key, 'Combo')
        then
            C.SpellCombos()
        else
            if J.CanNotUseAbility(GetBot()) then return end
            if ConsiderAbility[key] ~= nil then ConsiderAbility[key].Cast() end
        end
    end
end

return X