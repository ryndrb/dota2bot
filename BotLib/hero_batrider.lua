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

local Firefly       = bot:GetAbilityByName('batrider_firefly')
local FlamingLasso  = bot:GetAbilityByName('batrider_flaming_lasso')

local BlackKingBar

local Blink
local BlinkLocation

local BlinkLassoDesire, BlinkLassoTarget

if bot.shouldBlink == nil then bot.shouldBlink = false end

function X.SkillsComplement()
	if J.CanNotUseAbility(bot)
    then
        return
    end

    BlinkLassoDesire, BlinkLassoTarget = X.ConsiderBlinkLasso()
    if BlinkLassoDesire > 0
    then
        bot:Action_ClearActions(false)

        if  Firefly:IsFullyCastable()
        and J.GetManaAfter(Firefly:GetManaCost()) * bot:GetMana() > FlamingLasso:GetManaCost()
        then
            bot:ActionQueue_UseAbility(Firefly)
        end

        if X.CanBKB()
        then
            bot:ActionQueue_UseAbility(BlackKingBar)
            bot:ActionQueue_Delay(0.1)
        end

        bot:ActionQueue_UseAbilityOnLocation(Blink, BlinkLocation)
        bot:ActionQueue_Delay(0.1)
        bot:ActionQueue_UseAbilityOnEntity(FlamingLasso, BlinkLassoTarget)
        return
    end

    local sOrder = {'E','R','W','Q'}
    SU.AbilityUsage(sOrder)
end

function X.ConsiderBlinkLasso()
    if X.CanDoBlinkLasso()
    then
        local nDuration = FlamingLasso:GetSpecialValueInt('duration')

        if J.IsGoingOnSomeone(bot)
        then
            local nInRangeAlly = bot:GetNearbyHeroes(1199, false, BOT_MODE_NONE)
            local strongestTarget = J.GetStrongestUnit(1199, bot, true, false, nDuration)

            if strongestTarget == nil
            then
                strongestTarget = J.GetStrongestUnit(1199, bot, true, true, nDuration)
            end

            if  J.IsValidTarget(strongestTarget)
            and J.CanCastOnMagicImmune(strongestTarget)
            and J.CanCastOnTargetAdvanced(strongestTarget)
            and J.IsInRange(bot, strongestTarget, 1199)
            and not J.IsDisabled(strongestTarget)
            and not J.IsHaveAegis(strongestTarget)
            and not strongestTarget:HasModifier('modifier_abaddon_borrowed_time')
            and not strongestTarget:HasModifier('modifier_dazzle_shallow_grave')
            and not strongestTarget:HasModifier('modifier_enigma_black_hole_pull')
            and not strongestTarget:HasModifier('modifier_faceless_void_chronosphere_freeze')
            and not strongestTarget:HasModifier('modifier_legion_commander_duel')
            and not strongestTarget:HasModifier('modifier_necrolyte_reapers_scythe')
            then
                local nTargetInRangeAlly = strongestTarget:GetNearbyHeroes(1199, false, BOT_MODE_NONE)

                if  nInRangeAlly ~= nil and nTargetInRangeAlly ~= nil
                and (#nInRangeAlly >= #nTargetInRangeAlly or J.WeAreStronger(bot, 1200))
                then
                    bot.shouldBlink = true
                    BlinkLocation = strongestTarget:GetLocation()
                    return BOT_ACTION_DESIRE_HIGH, strongestTarget
                end
            end
        end
    end

    bot.shouldBlink = false
    return BOT_ACTION_DESIRE_NONE, nil
end

function X.CanDoBlinkLasso()
    if  FlamingLasso:IsFullyCastable()
    and X.HasBlink()
    then
        local nManaCost = FlamingLasso:GetManaCost()

        if bot:GetMana() >= nManaCost
        then
            return true
        end
    end

    return false
end

function X.HasBlink()
    local blink = nil

    for i = 0, 5
    do
		local item = bot:GetItemInSlot(i)

		if  item ~= nil
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

function X.CanBKB()
    local bkb = nil

    for i = 0, 5
    do
		local item = bot:GetItemInSlot(i)

		if  item ~= nil
        and item:GetName() == "item_black_king_bar"
        then
			bkb = item
			break
		end
	end

    if  bkb ~= nil
    and bkb:IsFullyCastable()
	then
        BlackKingBar = bkb
        return true
	end

    return false
end

return X