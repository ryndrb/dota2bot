-- CanAbilityBeUpgraded
-- GetAbilityDamage
-- GetAutoCastState
-- GetBehavior
-- GetCaster
-- GetCastPoint
-- GetCastRange
local o_GetCastRange = CDOTABaseAbility_BotScript.GetCastRange
function CDOTABaseAbility_BotScript:GetCastRange() -- wasn't giving the added range bonuses
    local bot = GetBot()

    if self then
        local nCastRange = self:GetSpecialValueInt('AbilityCastRange')

        if bot then
            for i = 0, 7 do
                local hAbility = bot:GetAbilityInSlot(i)
                if hAbility and hAbility:IsTrained() then
                    local sAbilityName = hAbility:GetName()

                    if sAbilityName == 'keeper_of_the_light_spirit_form' then
                        if bot:HasModifier('modifier_keeper_of_the_light_spirit_form') then
                            nCastRange = nCastRange + hAbility:GetSpecialValueInt('cast_range')
                        end
                    end

                    if sAbilityName == 'rubick_arcane_supremacy' then
                        nCastRange = nCastRange + hAbility:GetSpecialValueInt('cast_range')
                    end
                end
            end

            local itemSlots = { 0, 1, 2, 3, 4, 5, 16, 17 }
            for i = 1, #itemSlots do
                local hItem = bot:GetItemInSlot(itemSlots[i])
                if hItem then
                    local sItemName = hItem:GetName()

                    if sItemName == 'item_aether_lens' then
                        nCastRange = nCastRange + hItem:GetSpecialValueInt('cast_range_bonus')
                    end

                    if sItemName == 'item_ethereal_blade' then
                        nCastRange = nCastRange + hItem:GetSpecialValueInt('bonus_cast_range')
                    end

                    if sItemName == 'item_magnifying_monocle' then
                        nCastRange = nCastRange + hItem:GetSpecialValueInt('bonus_cast_range')
                    end

                    if sItemName == 'item_enhancement_keen_eyed' then
                        nCastRange = nCastRange + hItem:GetSpecialValueInt('cast_range_bonus')
                    end

                    if sItemName == 'item_enhancement_mystical' then
                        nCastRange = nCastRange + hItem:GetSpecialValueInt('bonus_cast_range')
                    end

                    if sItemName == 'item_enhancement_boundless' then
                        nCastRange = nCastRange + hItem:GetSpecialValueInt('bonus_cast_range')
                    end

                end
            end
        end

        return nCastRange
    end

    return o_GetCastRange(self)
end

-- GetChannelledManaCostPerSecond
-- GetChannelTime
-- GetDuration
-- GetCooldownTimeRemaining - Only works on yourself and allies
-- GetCurrentCharges
-- GetDamageType
-- GetHeroLevelRequiredToUpgrade
-- GetInitialCharges
-- GetLevel
-- GetManaCost
-- GetMaxLevel
-- GetName
-- GetSecondaryCharges
-- GetSpecialValueFloat
-- GetSpecialValueInt
-- GetTargetFlags
-- GetTargetTeam
-- GetTargetType
-- GetToggleState
-- IsActivated
-- IsAttributeBonus
-- IsChanneling
-- IsCooldownReady - Only works on yourself and allies
-- IsFullyCastable
-- IsHidden
-- IsInAbilityPhase
-- IsItem
-- IsOwnersManaEnough
-- IsPassive
-- IsStealable
-- IsStolen
-- IsToggle
-- IsTrained
-- ProcsMagicStick
-- ToggleAutoCast
-- CanBeDisassembled
-- IsCombineLocked