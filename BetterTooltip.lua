local resX = nil
local resY = nil
local scale = nil
local edgeOffsetX = 0.08 --Distance from right screen edge in percent
local edgeOffsetY = 0.10 --Distance from bottom screen edge in percent
local cursorOffsetX = 25 --X offset to cursor (scaled) pixel 
local cursorOffsetY = 25 --Y offset to cursor (scaled) pixel
--Move it with the mouse updates, but not too often so we don't waste CPU
local mousePressed = false

function BetterTooltip_OnLoad()
	------------------ Register game event handlers ---------------------------
	--BetterTooltipFrame:RegisterEvent("UPDATE_MOUSEOVER_UNIT");
	-------------------- Register game event handlers ---------------------------
	print("Better Tooltip loaded")
	-------------------- something stuff --------------------------------
	resX = GetScreenHeight() * -1
	resY = GetScreenHeight()
	scale = GameTooltip:GetEffectiveScale()
	-------------------- something stuff --------------------------------
end

function mouseAnchor(tooltip, parent)
	tooltip:ClearAllPoints()
	local x, y = GetCursorPosition()
	x, y = x / scale + cursorOffsetX, y / scale + cursorOffsetY
	tooltip:SetPoint("BOTTOMLEFT", parent, "BOTTOMLEFT", x, y)
	tooltip.lastPos = "mouse"
	--tooltip:SetScript("OnShow", tooltip.Show);
	--tooltip:Show()
end

function BetterTooltip_OnMouseDown()
--print("mouse down")
	mousePressed = true
end

function BetterTooltip_OnMouseUp()
--print("mouse up")
	mousePressed = false
end

local function BetterTooltip_OnUpdate(tooltip, elapsed)
	parent=tooltip:GetParent();
	--Preserve Auction House Tooltip Behavior
	if AuctionFrame and AuctionFrame:IsShown() then
		return
	end

	--Set the Tooltip position, if we're on WorldFrame, anchor to the mouse; if we're on a UnitFrame anchor to that.
	local mouseFocus=GetMouseFocus()
	if mouseFocus == nil then return; end;
	if mouseFocus==WorldFrame then
		if UnitAffectingCombat("player") then
			tooltip.lastPos = "hidden"
			tooltip:Hide()
			return
		elseif not UnitPlayerControlled("mouseover")
			and not mousePressed
			and (tooltip.lastPos == "") then
			mouseAnchor(tooltip, parent)
		--elseif not UnitExists("mouseover") then
		--	mouseAnchor(tooltip, parent)
		elseif (tooltip.lastPos == "bottom" or  tooltip.lastPos == "") then
			tooltip:ClearAllPoints()
			tooltip:SetPoint("BOTTOMRIGHT",parent,"BOTTOMRIGHT", resX*edgeOffsetX, resY*edgeOffsetY)
			tooltip.lastPos = "bottom"
			--tooltip:SetScript("OnShow", tooltip.Show);
			--tooltip:Show()
			--UIFrameFadeOut(tooltip, 1, 0, 1)
		end
	else
		mouseAnchor(tooltip, parent)
		--UIFrameFadeOut(tooltip, 1, 0, 1)
	end
	--print(GameTooltip.TimeSinceLastUpdate)
	--print(UnitName("mouseover"))
	--print(mouseFocus:GetName())
end

function GameTooltip_SetDefaultAnchor(tooltip, parent)
	tooltip.lastPos = ""
	tooltip:SetOwner(parent, "ANCHOR_NONE");
	tooltip.default = 1
	WorldFrame:HookScript("OnMouseDown", BetterTooltip_OnMouseDown);
	WorldFrame:HookScript("OnMouseUp", BetterTooltip_OnMouseUp);
	BetterTooltip_OnUpdate(tooltip, 0);
	tooltip:HookScript("OnUpdate", BetterTooltip_OnUpdate);
end