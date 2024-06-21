local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local BerserkPotion

function X.Cast()
	bot = GetBot()
	BerserkPotion = bot:GetAbilityByName('alchemist_berserk_potion')

	Desire, Target = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(BerserkPotion, Target)
		return
    end
end

function X.Consider()
    if not BerserkPotion:IsTrained()
	or not BerserkPotion:IsFullyCastable()
	then
		return BOT_ACTION_DESIRE_NONE, nil
	end

	local nCastRange = BerserkPotion:GetCastRange()

	local nAllyHeroes = bot:GetNearbyHeroes(nCastRange, false, BOT_MODE_NONE)
	for _, allyHero in pairs(nAllyHeroes)
	do
		if  J.IsValidHero(allyHero)
		and J.IsInRange(bot, allyHero, nCastRange)
		and not allyHero:HasModifier('modifier_legion_commander_press_the_attack')
		and not allyHero:HasModifier('modifier_item_satanic_unholy')
		and not allyHero:IsMagicImmune()
		and not allyHero:IsInvulnerable()
		and not allyHero:IsIllusion()
		and allyHero:CanBeSeen()
		then
			if J.IsDisabled(allyHero)
			then
				return BOT_ACTION_DESIRE_HIGH, allyHero
			end

			if  J.IsRetreating(allyHero)
			and J.IsRunning(allyHero)
			and J.GetHP(allyHero) < 0.6
			and allyHero:WasRecentlyDamagedByAnyHero(2.5)
			and allyHero:IsFacingLocation(GetAncient(GetTeam()):GetLocation(), 45)
			then
				return BOT_ACTION_DESIRE_HIGH, allyHero
			end

			if J.IsGoingOnSomeone(allyHero)
			then
				local allyTarget = J.GetProperTarget(allyHero)

				if  J.IsValidHero(allyTarget)
				and allyHero:IsFacingLocation( allyTarget:GetLocation(), 20)
				and J.IsInRange(allyHero, allyTarget, allyHero:GetAttackRange() + 100)
				then
					return BOT_ACTION_DESIRE_HIGH, allyHero
				end

				if J.GetHP(allyHero) < 0.33
				then
					return BOT_ACTION_DESIRE_HIGH, allyHero
				end
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

return X