local resX = GetScreenHeight() * -1
local resY = GetScreenHeight()
local scale = GameTooltip:GetEffectiveScale()
local edgeOffsetX = 0.08 --Distance from right screen edge in percent
local edgeOffsetY = 0.10 --Distance from bottom screen edge in percent
local cursorOffsetX = 25 --X offset to cursor (scaled) pixel 
local cursorOffsetY = 75 --Y offset to cursor (scaled) pixel 

local function BetterTooltip_OnUpdate(tooltip, elapsed)
	local _, unit = tooltip:GetUnit()
	local parent = tooltip:GetParent()
	if not unit and elapsed ~= nil then
		tooltip:SetScript("OnUpdate", tooltip.Update);
		tooltip:Hide()
	elseif UnitAffectingCombat("player") then
		tooltip:SetScript("OnShow", tooltip.Hide);
		tooltip:SetScript("OnUpdate", tooltip.Update);
		tooltip:Hide()
	elseif UnitPlayerControlled("mouseover") then
		tooltip:ClearAllPoints()
		tooltip:SetPoint("BOTTOMRIGHT",parent,"BOTTOMRIGHT", resX*edgeOffsetX, resY*edgeOffsetY)
		tooltip:SetScript("OnShow", tooltip.Show);
	else
		tooltip:ClearAllPoints()
		local x, y = GetCursorPosition()
		x, y = x / scale + cursorOffsetX, y / scale + cursorOffsetY
		tooltip:SetPoint("BOTTOMLEFT", parent, "BOTTOMLEFT", x, y)
		tooltip:SetScript("OnShow", tooltip.Show);
	end
end

function GameTooltip_SetDefaultAnchor(tooltip, parent)
	tooltip:SetOwner(parent, "ANCHOR_NONE");
	BetterTooltip_OnUpdate(tooltip, nil);
	tooltip:HookScript("OnUpdate", BetterTooltip_OnUpdate);
end