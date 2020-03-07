local edgeOffsetX = 0.08 --Distance from right screen edge in percent
local edgeOffsetY = 0.10 --Distance from bottom screen edge in percent
local cursorOffsetX = 25 --X offset to cursor (scaled) pixel 
local cursorOffsetY = 25 --Y offset to cursor (scaled) pixel
local PARENT_UPDATE_TIME = 0.2
local parentUpdateTime = 0

local resX
local resY

local function mouseAnchor(tooltip)
	local scale = tooltip:GetEffectiveScale()
	if tooltip.lastPos ~= "mouse" then tooltip:SetOwner(tooltip:GetParent(), "ANCHOR_CURSOR") end
	local x, y = GetCursorPosition()
	x, y = x / scale + cursorOffsetX, y / scale + cursorOffsetY
	tooltip:ClearAllPoints()
	tooltip:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", x, y)
	tooltip.lastPos = "mouse"
end

local function BetterTooltip_OnUpdate(tooltip, elapsed)
	--Preserve Auction House Tooltip Behavior
	if AuctionFrame and AuctionFrame:IsShown() then
		return
	end

	--Set the Tooltip position, if we're on WorldFrame, anchor to the mouse; if we're on a UnitFrame anchor to that.
	local mouseFocus=GetMouseFocus()
	if mouseFocus == nil then return; end
	if mouseFocus==WorldFrame then
		if UnitAffectingCombat("player") then
			tooltip.lastPos = "hidden"
			tooltip:Hide()
			return
		elseif not UnitPlayerControlled("mouseover")
			and (tooltip.lastPos == "mouse" or tooltip.lastPos == "") then
			mouseAnchor(tooltip)
			tooltip:SetAlpha(0.84)
			return
		elseif (tooltip.lastPos == "bottom" or  tooltip.lastPos == "") then
			if tooltip.lastPos ~= "bottom" then tooltip:SetOwner(tooltip:GetParent(), "ANCHOR_NONE") end
			tooltip:ClearAllPoints()
			tooltip:SetPoint("BOTTOMRIGHT",UIParent,"BOTTOMRIGHT", resX*edgeOffsetX, resY*edgeOffsetY)
			tooltip.lastPos = "bottom"
			return
		end
	else
		mouseAnchor(tooltip)
		return
	end
end

local function BetterTooltip_OnParentUpdate(self, elapsed)
	parentUpdateTime = parentUpdateTime + elapsed
	if parentUpdateTime > PARENT_UPDATE_TIME then
		parentUpdateTime = 0
		if GameTooltip:IsMouseOver() then
			GameTooltip:Show()
		end		
	end
	
end

function BetterTooltip_OnLoad()
	------------------ Register game event handlers ---------------------------
	GameTooltip:HookScript("OnUpdate", BetterTooltip_OnUpdate);
	GameTooltip:GetParent():HookScript("OnUpdate", BetterTooltip_OnParentUpdate);
	-------------------- Register game event handlers ---------------------------
	
	-------------------- something stuff --------------------------------
	print("BetterTooltip loaded")
	-------------------- something stuff --------------------------------
end

function GameTooltip_SetDefaultAnchor(tooltip, parent)
	tooltip:Show()
	resX = GetScreenHeight() * -1
	resY = GetScreenHeight()
	tooltip.lastPos = ""
	
	tooltip:SetOwner(tooltip:GetParent(), "ANCHOR_NONE")
	BetterTooltip_OnUpdate(tooltip, 0);
	tooltip.default = 1
end