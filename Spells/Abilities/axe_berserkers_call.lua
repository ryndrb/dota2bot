local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local BerserkersCall

function X.Cast()
    bot = GetBot()
    BerserkersCall = bot:GetAbilityByName('axe_berserkers_call')

    Desire = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbility(BerserkersCall)

        local BladeMail = J.IsItemAvailable('item_blade_mail')
        if BladeMail ~= nil and BladeMail:IsFullyCastable()
        then
            bot:ActionQueue_Delay(0.3 + 0.5)
            bot:ActionQueue_UseAbility(BladeMail)
        end

        return
    end
end

function X.Consider()
    if not BerserkersCall:IsFullyCastable() then return 0 end

    local nAllyHeroes = bot:GetNearbyHeroes(1600, false, BOT_MODE_NONE)
    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
    local botTarget = J.GetProperTarget(bot)

	local nRadius = BerserkersCall:GetSpecialValueInt( 'radius' )
	if bot:GetUnitName() == 'npc_dota_hero_axe'
    then
        local CallRadiusTalent = bot:GetAbilityByName('special_bonus_unique_axe_2')
        if CallRadiusTalent:IsTrained()
        then
            nRadius = nRadius + CallRadiusTalent:GetSpecialValueInt('value')
        end
    end

	local nManaCost = BerserkersCall:GetManaCost()
	local nInRangeEnemyList = J.GetAroundEnemyHeroList(nRadius - 50)

	for _, enemyHero in pairs(nInRangeEnemyList)
	do
		if  J.IsValidHero(enemyHero)
        and enemyHero:IsChanneling()
		and not enemyHero:IsMagicImmune()
        and not enemyHero:HasModifier('modifier_legion_commander_duel')
        and not enemyHero:HasModifier('modifier_necrolyte_reapers_scythe')
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	if J.IsGoingOnSomeone(bot)
	then
		if  J.IsValidHero(botTarget)
        and J.IsInRange(bot, botTarget, nRadius - 75)
        and J.CanCastOnNonMagicImmune(botTarget)
        and not J.IsDisabled(botTarget)
		then
            if  nInRangeEnemyList ~= nil and #nInRangeEnemyList == 1
            and not botTarget:HasModifier('modifier_legion_commander_duel')
            and not botTarget:HasModifier('modifier_necrolyte_reapers_scythe')
            then
                return BOT_ACTION_DESIRE_HIGH
            else
                return BOT_ACTION_DESIRE_HIGH
            end
		end
	end

	if  (J.IsPushing(bot) or J.IsDefending(bot))
    and J.GetManaAfter(nManaCost) > 0.35
    and bot:GetAttackTarget() ~= nil
    and DotaTime() > 6 * 60
    and nAllyHeroes ~= nil and #nAllyHeroes <= 2
    and nEnemyHeroes ~= nil and #nEnemyHeroes == 0
	then
		local nEnemyLaneCreeps = bot:GetNearbyLaneCreeps(nRadius - 50, true)
		if  nEnemyLaneCreeps ~= nil and #nEnemyLaneCreeps >= 4
        and J.CanBeAttacked(nEnemyLaneCreeps[1])
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

    if  J.IsFarming(bot)
    and J.GetManaAfter(nManaCost) > 0.75
    and bot:GetAttackTarget() ~= nil
    and nEnemyHeroes ~= nil and #nEnemyHeroes == 0
    then
        local nCreeps = bot:GetNearbyCreeps(nRadius - 50, true)
		if  nCreeps ~= nil and #nCreeps >= 2
        and J.CanBeAttacked(nCreeps[1])
		then
			return BOT_ACTION_DESIRE_HIGH
		end
    end

	if J.IsDoingRoshan(bot)
	then
		if  J.IsRoshan(botTarget)
        and not J.IsDisabled(botTarget)
        and not botTarget:IsDisarmed()
        and J.IsInRange(bot, botTarget, nRadius)
        and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

    if J.IsDoingTormentor(bot)
	then
		if  J.IsTormentor(botTarget)
        and J.IsInRange(bot, botTarget, nRadius)
        and J.IsAttacking(bot)
		then
			return BOT_ACTION_DESIRE_HIGH
		end
	end

	return BOT_ACTION_DESIRE_NONE
end

return X