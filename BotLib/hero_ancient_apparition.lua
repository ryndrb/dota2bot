local X = {}
local bot = GetBot()

local SU = dofile( GetScriptDirectory()..'/Spells/spell_usage' )
local Hero = require(GetScriptDirectory()..'/FunLib/bot_builds/'..string.gsub(bot:GetUnitName(), 'npc_dota_hero_', ''))
local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sRole = J.Item.GetRoleItemsBuyList( bot )

local nTalentBuildList = J.Skill.GetTalentBuild(Hero.TalentBuild[sRole][RandomInt(1, #Hero.TalentBuild[sRole])])
local nAbilityBuildList = Hero.AbilityBuild[sRole][RandomInt(1, #Hero.AbilityBuild[sRole])]

local sRand = RandomInt(1, #Hero.BuyList[sRole])
X['sBuyList'] = Hero.BuyList[sRole][sRand]
X['sSellList'] = Hero.SellList[sRole][sRand]

if J.Role.IsPvNMode() or J.Role.IsAllShadow() then X['sBuyList'], X['sSellList'] = { 'PvN_antimage' }, {} end

nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] = J.SetUserHeroInit( nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] )

X['sSkillList'] = J.Skill.GetSkillList( sAbilityList, nAbilityBuildList, sTalentList, nTalentBuildList )

X['bDeafaultAbility'] = false
X['bDeafaultItem'] = false

function X.MinionThink( hMinionUnit )
	if Minion.IsValidUnit( hMinionUnit )
	then
		if hMinionUnit:IsIllusion()
		then
			Minion.IllusionThink( hMinionUnit )
		end
	end
end

local ColdFeet          = bot:GetAbilityByName('ancient_apparition_cold_feet')
local IceVortex         = bot:GetAbilityByName('ancient_apparition_ice_vortex')
local ChillingTouch     = bot:GetAbilityByName('ancient_apparition_chilling_touch')
local IceBlast          = bot:GetAbilityByName('ancient_apparition_ice_blast')
local IceBlastRelease   = bot:GetAbilityByName('ancient_apparition_ice_blast_release')

local ColdFeetAoETalent = bot:GetAbilityByName('special_bonus_unique_ancient_apparition_7')

local ColdFeetDesire, ColdFeetTarget
local IceVortexDesire, IceVortextLocation
local ChillingTouchDesire, ChillingTouchTarget
local IceBlastDesire, IceBlastLocation
local IceBlastReleaseDesire

local IceBlastReleaseLocation

function X.SkillsComplement()
	if J.CanNotUseAbility(bot) then return end

    local sOrder = {'H1','R','W','Q','E'}
    SU.AbilityUsage(sOrder)
end

return X