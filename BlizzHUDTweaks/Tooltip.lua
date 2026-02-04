local addon = LibStub("AceAddon-3.0"):GetAddon("BlizzHUDTweaks")
local Tooltip = addon:GetModule("Tooltip")

local Original_GameTooltip_SetDefaultAnchor = GameTooltip_SetDefaultAnchor
Tooltip.spellIdHookInstalled = false

local function addSpellID(tooltip, spellID)
    if not spellID then return end

    tooltip:AddLine(" ")
    tooltip:AddLine("|cff00ff00Spell ID:|r " .. spellID)
    tooltip:Show()
end

local function anchorTooltipToMouse()
    GameTooltip_SetDefaultAnchor = function(tooltip, parent)
        tooltip:SetOwner(parent, "ANCHOR_CURSOR")
    end
end

local function showSpellID()
    if not Tooltip.spellIdHookInstalled then
        hooksecurefunc(GameTooltip, "SetSpellByID", function(self, spellID)
            addSpellID(self, spellID)
        end)

        hooksecurefunc(GameTooltip, "SetSpellBookItem", function(self, slot, bookType)
            local spellBookItemInfo = C_SpellBook.GetSpellBookItemInfo(slot, bookType)
            if spellBookItemInfo and spellBookItemInfo.spellID then
                addSpellID(self, spellBookItemInfo.spellID)
            end
        end)
    end

    Tooltip.spellIdHookInstalled = true
end


-------------------------------------------------------------------------------
-- Public API

function Tooltip:ShowSpellID()
    if Tooltip:IsEnabled() then
        local profile = addon:GetProfileDB()
        if profile["TooltipShowSpellID"] then
            showSpellID()
        end
    end
end

function Tooltip:HideSpellID()
    if Tooltip:IsEnabled() then
        addon:Print("You have to /reload for this option to take effect.", addon:ColoredString("Tooltip", "fcba03"))
    end
end

function Tooltip:AnchorTooltipToMouse()
    if Tooltip:IsEnabled() then
        local profile = addon:GetProfileDB()
        if profile["TooltipAnchorToMouse"] then
            anchorTooltipToMouse()
        end
    end
end

function Tooltip:ResetTooltipAnchor()
    if Tooltip:IsEnabled() then
        GameTooltip_SetDefaultAnchor = Original_GameTooltip_SetDefaultAnchor
    end
end

function Tooltip:InstallHooks()
    if Tooltip:IsEnabled() then
        Tooltip:AnchorTooltipToMouse()
        Tooltip:ShowSpellID()
    end
end

function Tooltip:Disable()
    --@debug@
    addon:Print("Disabled Module", addon:ColoredString("Tooltip", "fcba03"))
    --@end-debug@
    Tooltip:ResetTooltipAnchor()
end

function Tooltip:Enable()
    Tooltip:AnchorTooltipToMouse()
    --@debug@
    addon:Print("Enabled Module", addon:ColoredString("Tooltip", "fcba03"))
    --@end-debug@
end

function Tooltip:IsEnabled()
  local enabled = addon:GetProfileDB()["GlobalOptionsTooltipEnabled"] or false
  return enabled
end
