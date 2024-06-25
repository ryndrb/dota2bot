local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local RealityRift

function X.Cast()
    bot = GetBot()
    RealityRift = bot:GetAbilityByName('chaos_knight_reality_rift')

    Desire, Target = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(RealityRift, Target)
        return
    end
end

function X.Consider()
    if not RealityRift:IsFullyCastable() or bot:IsRooted() then return BOT_ACTION_DESIRE_NONE, nil end

	local nCastRange = J.GetProperCastRange(false, bot, RealityRift:GetCastRange())
	local bIgnoreMagicImmune = false

    local botTarget = J.GetProperTarget( bot )

    if bot:GetUnitName() == 'npc_dota_hero_chaos_knight'
    then
        local PierceSpellImmunityTalent = bot:GetAbilityByName('special_bonus_unique_chaos_knight')
        if PierceSpellImmunityTalent ~= nil and PierceSpellImmunityTalent:IsTrained()
        then
            bIgnoreMagicImmune = true
        end
    end

    local nEnemyHeroes = bot:GetNearbyHeroes(1600, true, BOT_MODE_NONE )

	if J.IsGoingOnSomeone( bot )
	then
		if J.IsValidHero( botTarget )
        and J.IsInRange( botTarget, bot, nCastRange + 50 )
        and ( not J.IsInRange( bot, botTarget, 200 ) or not botTarget:HasModifier( 'modifier_chaos_knight_reality_rift' ) )
        and ((bIgnoreMagicImmune and J.CanCastOnMagicImmune(botTarget)) or J.CanCastOnNonMagicImmune(botTarget))
        and J.CanCastOnTargetAdvanced( botTarget )
        and not J.IsDisabled( botTarget )
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	if J.IsRetreating( bot )
    and not J.IsRealInvisible(bot)
	then
		local creeps = bot:GetNearbyCreeps( nCastRange, true )

		if J.IsValidHero(nEnemyHeroes[1])
        and J.IsInRange(bot, nEnemyHeroes[1], 800)
		then
			for _, creep in pairs( creeps )
			do
				if J.IsValid(creep)
                and nEnemyHeroes[1]:IsFacingLocation( bot:GetLocation(), 30 )
					and bot:IsFacingLocation( creep:GetLocation(), 30 )
					and GetUnitToUnitDistance( bot, creep ) >= 650
				then
					return BOT_ACTION_DESIRE_HIGH, creep
				end
			end
		end
	end


	if nEnemyHeroes ~= nil and #nEnemyHeroes == 0
		and bot:GetAttackDamage() >= 150
	then
		local nCreeps = bot:GetNearbyLaneCreeps( 1000, true )
		for i=1, #nCreeps
		do
			local creep = nCreeps[#nCreeps -i + 1]
			if J.IsValid( creep )
            and J.CanBeAttacked(creep)
            and J.IsKeyWordUnit( "ranged", creep )
            and GetUnitToUnitDistance( bot, creep ) >= 350
			then
				return BOT_ACTION_DESIRE_HIGH, creep
			end
		end
	end

	if J.IsDoingRoshan(bot)
	then
		if J.IsRoshan(botTarget)
        and not J.IsDisabled( botTarget )
        and not botTarget:IsDisarmed()
		then
			return BOT_ACTION_DESIRE_HIGH, botTarget
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

return X