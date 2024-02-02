local X             = {}
local bot           = GetBot()

local J             = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion        = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList   = J.Skill.GetTalentList( bot )
local sAbilityList  = J.Skill.GetAbilityList( bot )
local sOutfitType   = J.Item.GetOutfitType( bot )

local tTalentTreeList = {
						{--pos2
                            ['t25'] = {0, 10},
                            ['t20'] = {0, 10},
                            ['t15'] = {0, 10},
                            ['t10'] = {10, 0},
                        },
                        {--pos3
                            ['t25'] = {0, 10},
                            ['t20'] = {0, 10},
                            ['t15'] = {0, 10},
                            ['t10'] = {10, 0},
                        }
}

local tAllAbilityBuildList = {
						{1,2,1,2,1,6,2,2,1,3,6,3,3,3,6},--pos2
                        {2,1,2,3,2,6,2,1,1,1,6,3,3,3,6},--pos3
}

local nAbilityBuildList
local nTalentBuildList

if sOutfitType == "outfit_mid"
then
    nAbilityBuildList   = tAllAbilityBuildList[1]
    nTalentBuildList    = J.Skill.GetTalentBuild(tTalentTreeList[1])
elseif sOutfitType == "outfit_tank"
then
    nAbilityBuildList   = tAllAbilityBuildList[2]
    nTalentBuildList    = J.Skill.GetTalentBuild(tTalentTreeList[2])
end

local sUtility = {"item_crimson_guard", "item_pipe", "item_lotus_orb", "item_heavens_halberd"}
local nUtility = sUtility[RandomInt(1, #sUtility)]

local tOutFitList = {}

tOutFitList['outfit_carry'] = tOutFitList['outfit_carry']

tOutFitList['outfit_mid'] = tOutFitList['outfit_carry']

tOutFitList['outfit_tank'] = tOutFitList['outfit_carry']

tOutFitList['outfit_priest'] = {

}

tOutFitList['outfit_mage'] = {
    
}

X['sBuyList'] = tOutFitList[sOutfitType]

Pos4SellList = {
	"item_magic_wand",
}

Pos3SellList = {
	"item_quelling_blade",
    "item_helm_of_iron_will",
    "item_magic_wand",
}

X['sSellList'] = {}

if sOutfitType == "outfit_mid"
then
    X['sSellList'] = Pos2SellList
elseif sOutfitType == "outfit_tank"
then
    X['sSellList'] = Pos3SellList
end

if J.Role.IsPvNMode() or J.Role.IsAllShadow() then X['sBuyList'], X['sSellList'] = { 'PvN_antimage' }, {} end

nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] = J.SetUserHeroInit( nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] )

X['sSkillList'] = J.Skill.GetSkillList( sAbilityList, nAbilityBuildList, sTalentList, nTalentBuildList )

X['bDeafaultAbility'] = false
X['bDeafaultItem'] = false

function X.MinionThink(hMinionUnit)
    Minion.MinionThink(hMinionUnit)
end

local Devour        = bot:GetAbilityByName('doom_bringer_devour')
local ScorchedEarth = bot:GetAbilityByName('doom_bringer_scorched_earth')
local InfernalBlade = bot:GetAbilityByName('doom_bringer_infernal_blade')
local Doom          = bot:GetAbilityByName('doom_bringer_doom')

local DevourAbility1 = bot:GetAbilityByName('doom_bringer_empty1')
local DevourAbility2 = bot:GetAbilityByName('doom_bringer_empty2')

local DevourAncientTalent = bot:GetAbilityByName('special_bonus_unique_doom_4')

local DevourDesire, DevourTarget
local ScorchedEarthDesire
local InfernalBladeDesire, InfernalBladeTarget
local DoomDesire, DoomTarget

function X.SkillsComplement()
	if J.CanNotUseAbility(bot)
    then
        return
    end

    DoomDesire, DoomTarget = X.ConsiderDoom()
    if DoomDesire > 0
    then
        bot:Action_UseAbilityOnEntity(Doom, DoomTarget)
        return
    end

    InfernalBladeDesire, InfernalBladeTarget = X.ConsiderInfernalBlade()
    if InfernalBladeDesire > 0
    then
        bot:Action_UseAbilityOnEntity(InfernalBlade, InfernalBladeTarget)
        return
    end

    ScorchedEarthDesire = X.ConsiderScorchedEarth()
    if ScorchedEarthDesire > 0
    then
        bot:Action_UseAbility(ScorchedEarth)
        return
    end

    DevourDesire, DevourTarget = X.ConsiderDevour()
    if DevourDesire > 0
    then
        bot:Action_UseAbilityOnEntity(Devour, DevourTarget)
        return
    end
end