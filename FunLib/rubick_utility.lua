local X = {}

local Abaddon = require(GetScriptDirectory()..'/FunLib/rubick_hero/abaddon')
local AbyssalUnderlord = require(GetScriptDirectory()..'/FunLib/rubick_hero/abyssal_underlord')
local Alchemist = require(GetScriptDirectory()..'/FunLib/rubick_hero/alchemist')
local AncientApparition = require(GetScriptDirectory()..'/FunLib/rubick_hero/ancient_apparition')
local Antimage = require(GetScriptDirectory()..'/FunLib/rubick_hero/antimage')
local ArcWarden = require(GetScriptDirectory()..'/FunLib/rubick_hero/arc_warden')
local Axe = require(GetScriptDirectory()..'/FunLib/rubick_hero/axe')
local Bane = require(GetScriptDirectory()..'/FunLib/rubick_hero/bane')
local Batrider = require(GetScriptDirectory()..'/FunLib/rubick_hero/batrider')
local Beastmaster = require(GetScriptDirectory()..'/FunLib/rubick_hero/beastmaster')
local Bloodseeker = require(GetScriptDirectory()..'/FunLib/rubick_hero/bloodseeker')
local BountyHunter = require(GetScriptDirectory()..'/FunLib/rubick_hero/bounty_hunter')
local Brewmaster = require(GetScriptDirectory()..'/FunLib/rubick_hero/brewmaster')
local Bristleback = require(GetScriptDirectory()..'/FunLib/rubick_hero/bristleback')
local Broodmother = require(GetScriptDirectory()..'/FunLib/rubick_hero/broodmother')

function X.ConsiderStolenSpell(ability)
    Abaddon.ConsiderStolenSpell(ability)
    AbyssalUnderlord.ConsiderStolenSpell(ability)
    Alchemist.ConsiderStolenSpell(ability)
    AncientApparition.ConsiderStolenSpell(ability)
    Antimage.ConsiderStolenSpell(ability)
    ArcWarden.ConsiderStolenSpell(ability)
    Axe.ConsiderStolenSpell(ability)
    Bane.ConsiderStolenSpell(ability)
    Batrider.ConsiderStolenSpell(ability)
    Beastmaster.ConsiderStolenSpell(ability)
    Bloodseeker.ConsiderStolenSpell(ability)
    BountyHunter.ConsiderStolenSpell(ability)
    Brewmaster.ConsiderStolenSpell(ability)
    Bristleback.ConsiderStolenSpell(ability)
    Broodmother.ConsiderStolenSpell(ability)
    --C's next
end

return X