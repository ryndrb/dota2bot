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

local Vacuum            = bot:GetAbilityByName('dark_seer_vacuum')
local WallOfReplica     = bot:GetAbilityByName('dark_seer_wall_of_replica')

local VacuumWallDesire, VacuumwallLocation
local Blink

if bot.shouldBlink == nil then bot.shouldBlink = false end

function X.SkillsComplement()
	if J.CanNotUseAbility(bot) then return end

    VacuumWallDesire, VacuumwallLocation = X.ConsiderVacuumWall()
    if VacuumWallDesire > 0
    then
        bot:Action_ClearActions(false)
        bot:ActionQueue_UseAbilityOnLocation(Blink, VacuumwallLocation)
        bot:ActionQueue_Delay(0.1)
        bot:ActionQueue_UseAbilityOnLocation(Vacuum, VacuumwallLocation)
        bot:ActionQueue_Delay(0.8)
        bot:ActionQueue_UseAbilityOnLocation(WallOfReplica, VacuumwallLocation)
        return
    end

    local sOrder = {'Q','R','E','W'}
    SU.AbilityUsage(sOrder)
end

function X.ConsiderVacuumWall()
    if X.CanDoVacuumWall()
    then
        local nWallOfReplicaCastPoint = WallOfReplica:GetCastPoint() + 0.73
        local nVacuumCastRange = J.GetProperCastRange(false, bot, Vacuum:GetCastRange())
        local nVacuumRadius = Vacuum:GetSpecialValueInt('radius')

        if J.IsInTeamFight(bot, 1600)
        then
            local nLocationAoE = bot:FindAoELocation(true, true, bot:GetLocation(), nVacuumCastRange, nVacuumRadius, nWallOfReplicaCastPoint, 0)
            local nInRangeEnemy = J.GetEnemiesNearLoc(nLocationAoE.targetloc, nVacuumRadius)

            if nInRangeEnemy ~= nil and #nInRangeEnemy >= 2
            then
                return BOT_ACTION_DESIRE_HIGH, J.GetCenterOfUnits(nInRangeEnemy)
            end
        end
    end

    return BOT_ACTION_DESIRE_NONE
end

function X.CanDoVacuumWall()
    if  Vacuum:IsFullyCastable()
    and WallOfReplica:IsFullyCastable()
    and X.HasBlink()
    then
        local manaCost = Vacuum:GetManaCost() + WallOfReplica:GetManaCost()

        if bot:GetMana() >= manaCost
        then
            bot.shouldBlink = true
            return true
        end
    end

    bot.shouldBlink = true
    return false
end

function X.HasBlink()
    local blink = nil

    for i = 0, 5 do
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