local bot
local J = require(GetScriptDirectory()..'/FunLib/jmz_func')
local X = {}

local CullingBlade

function X.Cast()
    bot = GetBot()
    CullingBlade = bot:GetAbilityByName('axe_culling_blade')

    Desire, Target = X.Consider()
    if Desire > 0
    then
        J.SetQueuePtToINT(bot, false)
        bot:ActionQueue_UseAbilityOnEntity(CullingBlade, Target)
        return
    end
end

function X.Consider()
    if not CullingBlade:IsFullyCastable() then return BOT_ACTION_DESIRE_NONE, nil end

	local nCastRange = CullingBlade:GetCastRange()
	local nKillDamage = CullingBlade:GetSpecialValueInt('damage')

    if bot:GetUnitName() == 'npc_dota_hero_axe'
    then
        CullingBladeDamageTalent = bot:GetAbilityByName('special_bonus_unique_axe_5')
        if CullingBladeDamageTalent:IsTrained()
        then
            nKillDamage = nKillDamage + CullingBladeDamageTalent:GetSpecialValueInt('value')
        end
    end

	local nInBonusEnemyList = J.GetAroundEnemyHeroList(nCastRange + 300)

	for _, enemyHero in pairs(nInBonusEnemyList)
	do
		if  J.IsValidHero(enemyHero)
        and enemyHero:GetHealth() + enemyHero:GetHealthRegen() * 0.8 < nKillDamage
        and not J.IsHaveAegis(enemyHero)
        and not enemyHero:IsInvulnerable()
        and not enemyHero:IsMagicImmune() --V BUG
        and not J.IsSuspiciousIllusion(enemyHero)
        and not X.HasSpecialModifier(enemyHero)
        and not X.IsKillBotAntiMage(enemyHero)
		then
			return BOT_ACTION_DESIRE_HIGH, enemyHero
		end
	end

	return BOT_ACTION_DESIRE_NONE, nil
end

function X.HasSpecialModifier(npcEnemy)
	if npcEnemy:HasModifier('modifier_winter_wyvern_winters_curse')
    or npcEnemy:HasModifier('modifier_winter_wyvern_winters_curse_aura')
    or npcEnemy:HasModifier('modifier_antimage_spell_shield')
    or npcEnemy:HasModifier('modifier_item_lotus_orb_active')
    or npcEnemy:HasModifier('modifier_item_aeon_disk_buff')
    or npcEnemy:HasModifier('modifier_item_sphere_target')
    or npcEnemy:HasModifier('modifier_illusion')
    or npcEnemy:HasModifier('modifier_necrolyte_reapers_scythe')
	then
		return true
	else
		return false
	end
end


function X.IsKillBotAntiMage(npcEnemy)
	if not npcEnemy:IsBot()
    or npcEnemy:GetUnitName() ~= 'npc_dota_hero_antimage'
    or npcEnemy:IsStunned()
    or npcEnemy:IsHexed()
    or npcEnemy:IsNightmared()
    or npcEnemy:IsChanneling()
    or J.IsTaunted(npcEnemy)
	then
		return false
	end

	return true
end

return X