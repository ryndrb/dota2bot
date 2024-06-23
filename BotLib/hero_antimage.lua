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

local Blink 			= bot:GetAbilityByName('antimage_blink')
local ManaVoid 			= bot:GetAbilityByName('antimage_mana_void')

local BlinkVoidDesire, BlinkVoidLocation, BlinkVoidTarget

function X.SkillsComplement()
	if J.CanNotUseAbility(bot) then return end

	BlinkVoidDesire, BlinkVoidLocation, BlinkVoidTarget = X.ConsiderBlinkVoid()
	if BlinkVoidDesire > 0
	then
		J.SetQueuePtToINT( bot, false )
		bot:ActionQueue_UseAbilityOnLocation(Blink, BlinkVoidLocation)
		bot:ActionQueue_Delay(0.1)
		bot:ActionQueue_UseAbilityOnEntity(ManaVoid, BlinkVoidTarget)
		return
	end

	local sOrder = {'E','F','W','R','D'}
    SU.AbilityUsage(sOrder)
end

function X.ConsiderBlinkVoid()
	if not Blink:IsFullyCastable()
	or not ManaVoid:IsFullyCastable()
	then
		return BOT_ACTION_DESIRE_NONE, 0, nil
	end

	if Blink:GetManaCost() + ManaVoid:GetManaCost() > bot:GetMana()
	then
		return BOT_ACTION_DESIRE_NONE, 0, nil
	end

	local nCastRange = Blink:GetSpecialValueInt('AbilityCastRange')
	local nDamagaPerHealth = ManaVoid:GetSpecialValueFloat('mana_void_damage_per_mana')
	local nCastTarget = nil

	local nMaxRange = ManaVoid:GetCastRange() + nCastRange

	local nEnemysHerosCanSeen = GetUnitList(UNIT_LIST_ENEMY_HEROES)
	for _, enemyHero in pairs(nEnemysHerosCanSeen)
	do
		if  J.IsValidHero(enemyHero)
		and J.IsInRange(bot, enemyHero, nMaxRange)
		and J.CanCastOnNonMagicImmune(enemyHero)
		and J.CanCastOnTargetAdvanced(enemyHero)
		and not enemyHero:HasModifier('modifier_arc_warden_tempest_double')
		and not enemyHero:HasModifier('modifier_dazzle_shallow_grave')
		and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
		and not enemyHero:HasModifier('modifier_oracle_false_promise_timer')
		then
			local nInRangeAlly = enemyHero:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
			local nInRangeEnemy = enemyHero:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
			local nDamage = nDamagaPerHealth * (enemyHero:GetMaxMana() - enemyHero:GetMana())

			if  nInRangeAlly ~= nil and nInRangeEnemy ~= nil
			and #nInRangeAlly >= #nInRangeEnemy
			then
				if J.CanKillTarget(enemyHero, nDamage, DAMAGE_TYPE_MAGICAL)
				then
					nCastTarget = enemyHero
				end
			end
		end
	end

	if nCastTarget ~= nil
	then
		return BOT_ACTION_DESIRE_HIGH, nCastTarget:GetLocation(), nCastTarget
	end

	return BOT_ACTION_DESIRE_NONE, 0, nil
end

return X