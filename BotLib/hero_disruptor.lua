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

function X.MinionThink(hMinionUnit)
    Minion.MinionThink(hMinionUnit)
end

local KineticField  = bot:GetAbilityByName('disruptor_kinetic_field')
local StaticStorm   = bot:GetAbilityByName('disruptor_static_storm')

local KineticStormDesire, KineticStormLocation

function X.SkillsComplement()
	if J.CanNotUseAbility(bot) then return end

    if bot.KineticFieldTimeLast == nil then bot.KineticFieldTimeLast = -1 end
    if bot.KineticFieldLocation == nil then bot.KineticFieldLocation = bot:GetLocation() end

    KineticStormDesire, KineticStormLocation = X.ConsiderKineticStorm()
    if KineticStormDesire > 0
    then
        bot:Action_ClearActions(false)
        bot:ActionQueue_UseAbilityOnLocation(StaticStorm, KineticStormLocation)
        bot:ActionQueue_Delay(0.05)
        bot:ActionQueue_UseAbilityOnLocation(KineticField, KineticStormLocation)
        return
    end

    local sOrder = {'R','E','Q','W'}
    SU.AbilityUsage(sOrder)
end

function X.ConsiderKineticStorm()
    if X.CanCastKineticStorm()
    then
	    local nCastRange = J.GetProperCastRange(false, bot, KineticField:GetCastRange())
        local nRadius = KineticField:GetSpecialValueInt('radius')

        if J.IsInTeamFight(bot, 1200)
        then
            local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
            local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius - 75)

            if  nInRangeEnemy ~= nil and #nInRangeEnemy >= 2
            and not J.IsLocationInChrono(nLocationAoE.targetloc)
            and not J.IsLocationInBlackHole(nLocationAoE.targetloc)
            then
                return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nInRangeEnemy)
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.CanCastKineticStorm()
    if  KineticField:IsFullyCastable()
    and StaticStorm:IsFullyCastable()
    then
        local nManaCost = KineticField:GetManaCost() + StaticStorm:GetManaCost()

        if bot:GetMana() >= nManaCost
        then
            return true
        end
    end

    return false
end

return X