local resX = nil
local resY = nil
local scale = nil
local edgeOffsetX = 0.08 --Distance from right screen edge in percent
local edgeOffsetY = 0.10 --Distance from bottom screen edge in percent
local cursorOffsetX = 25 --X offset to cursor (scaled) pixel 
local cursorOffsetY = 75 --Y offset to cursor (scaled) pixel
local count = 0

function BetterTooltip_OnLoad()
	------------------ Register game event handlers ---------------------------
	BetterTooltipFrame:RegisterEvent("UPDATE_MOUSEOVER_UNIT");
	-------------------- Register game event handlers ---------------------------
	print("GameTooltip loaded")
	-------------------- something stuff --------------------------------
	resX = GetScreenHeight() * -1
	resY = GetScreenHeight()
	scale = GameTooltip:GetEffectiveScale()
	-------------------- something stuff --------------------------------
end

local function BetterTooltip_OnUpdate(tooltip, elapsed)
	--print("test")
	local parent = tooltip:GetParent()
	if UnitAffectingCombat("player") then
		--print("combat")
		--tooltip:SetScript("OnShow", tooltip.Hide);
		--tooltip:SetScript("OnUpdate", tooltip.Update);
		tooltip:Hide()
	elseif UnitPlayerControlled("mouseover") or not UnitExists("mouseover") then
		--print("player")
		tooltip:ClearAllPoints()
		tooltip:SetPoint("BOTTOMRIGHT",parent,"BOTTOMRIGHT", resX*edgeOffsetX, resY*edgeOffsetY)
		tooltip:SetScript("OnShow", tooltip.Show);
	else
		--print("npc")
		tooltip:ClearAllPoints()
		local x, y = GetCursorPosition()
		x, y = x / scale + cursorOffsetX, y / scale + cursorOffsetY
		tooltip:SetPoint("BOTTOMLEFT", parent, "BOTTOMLEFT", x, y)
		tooltip:SetScript("OnShow", tooltip.Show);
	end
end

function BetterTooltip_OnEvent(event, ...)
	--print(event)
	if(event == "UPDATE_MOUSEOVER_UNIT") then
		--GameTooltip:SetOwner(GameTooltip:GetParent(), "ANCHOR_NONE");
		BetterTooltip_OnUpdate(GameTooltip, nil);
		GameTooltip:SetScript("OnUpdate", BetterTooltip_OnUpdate);
	end
end