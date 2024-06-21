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

local Fissure       = bot:GetAbilityByName('earthshaker_fissure')
local EnchantTotem  = bot:GetAbilityByName('earthshaker_enchant_totem')
local Aftershock    = bot:GetAbilityByName('earthshaker_aftershock')
local EchoSlam      = bot:GetAbilityByName('earthshaker_echo_slam')

local FissureDesire, FissureLocation
local EnchantTotemDesire, EnchantTotemLocation, WantToJump
local EchoSlamDesire

local BlinkSlamDesire, BlinkSlamLocation
local TotemSlamDesire, TotemSlamLocation

local Blink

function X.SkillsComplement()
	if J.CanNotUseAbility(bot)
    or bot:NumQueuedActions() > 0
    then return end

    BlinkSlamDesire, BlinkSlamLocation = X.ConsiderBlinkSlam()
    if BlinkSlamDesire > 0
    then
        bot:Action_ClearActions(false)

        bot:ActionQueue_UseAbilityOnLocation(Blink, BlinkSlamLocation)
        bot:ActionQueue_Delay(0.1)
        bot:ActionQueue_UseAbility(EchoSlam)
        return
    end

    TotemSlamDesire, TotemSlamLocation = X.ConsiderTotemSlam()
    if TotemSlamDesire > 0
    then
        local nLeapDuration = EnchantTotem:GetSpecialValueFloat('scepter_leap_duration')

        bot:Action_ClearActions(false)
        bot:ActionQueue_UseAbilityOnLocation(EnchantTotem, TotemSlamLocation)
        bot:ActionQueue_Delay(nLeapDuration + 0.1)
        bot:ActionQueue_UseAbility(EchoSlam)
        return
    end

    local sOrder = {'R','W','Q'}
    SU.AbilityUsage(sOrder)
end

-- Blink > Echo
function X.ConsiderBlinkSlam()
    if X.CanDoBlinkSlam()
    then
        local nCastRange = 1199
        local nRadius = EchoSlam:GetSpecialValueInt('echo_slam_echo_range')

        if J.IsGoingOnSomeone(bot)
        then
            local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nCastRange, nRadius, 0, 0)
            local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius / 2)

            if nInRangeEnemy ~= nil and #nInRangeEnemy >= 2
            then
                return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nInRangeEnemy)
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.CanDoBlinkSlam()
    if  X.HasBlink()
    and EchoSlam:IsFullyCastable()
    then
        local nManaCost = EchoSlam:GetManaCost()

        if  bot:GetMana() >= nManaCost
        then
            bot.shouldBlink = true
            return true
        end
    end

    bot.shouldBlink = false
    return false
end

-- Enchant Totem > Echo
function X.ConsiderTotemSlam()
    if X.CanDoTotemSlam()
    then
        local nETCastRange = EnchantTotem:GetSpecialValueInt('distance_scepter')
        local nETLeapDuration = EnchantTotem:GetSpecialValueFloat('scepter_leap_duration')
        local nRadius = EchoSlam:GetSpecialValueInt('echo_slam_echo_range')

        if J.IsInTeamFight(bot, 1200)
        then
            local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nETCastRange, nRadius, nETLeapDuration, 0)
            local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nRadius / 2)

            if nInRangeEnemy ~= nil and #nInRangeEnemy >= 2
            then
                return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nInRangeEnemy)
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE, 0
end

function X.CanDoTotemSlam()
    if  bot:HasScepter()
    and EnchantTotem:IsFullyCastable()
    and EchoSlam:IsFullyCastable()
    then
        local nManaCost = EnchantTotem:GetManaCost() + EchoSlam:GetManaCost()

        if  bot:GetMana() >= nManaCost
        then
            return true
        end
    end

    return false
end

function X.CanJump()
    if  bot:HasScepter()
    and EnchantTotem:IsFullyCastable()
    then
        return true
    end

    return false
end

function X.HasBlink()
    local blink = nil

    for i = 0, 5
    do
		local item = bot:GetItemInSlot(i)

		if item ~= nil
        and (item:GetName() == "item_blink" or item:GetName() == "item_overwhelming_blink" or item:GetName() == "item_arcane_blink" or item:GetName() == "item_swift_blink")
        then
			blink = item
			break
		end
	end

    if  blink ~= nil
    and blink:IsFullyCastable()
	then
        Blink = blink
        return true
	end

    return false
end

return X