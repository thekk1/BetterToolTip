local edgeOffsetX = 0.08 --Distance from right screen edge in percent
local edgeOffsetY = 0.10 --Distance from bottom screen edge in percent
local cursorOffsetX = 25 --X offset to cursor (scaled) pixel 
local cursorOffsetY = 25 --Y offset to cursor (scaled) pixel
local PARENT_UPDATE_TIME = 0.2
local parentUpdateTime = 0
local focusOnTooltip = false
local tooltipPosition = ""
local resX, resY, mouseFocus

local function mouseAnchor(tooltip)
	local scale = tooltip:GetEffectiveScale()
	if tooltipPosition ~= "mouse" then
		tooltip:ClearAllPoints()
		tooltip:SetOwner(tooltip:GetParent(), "ANCHOR_CURSOR")
	end
	local x, y = GetCursorPosition()
	x, y = x / scale + cursorOffsetX, y / scale + cursorOffsetY
	tooltip:SetPoint("BOTTOMLEFT", tooltip:GetParent(), "BOTTOMLEFT", x, y)
	tooltipPosition = "mouse"
end

local function BetterTooltip_OnUpdate(tooltip, elapsed)
	if elapsed ~= 0 and tooltip:NumLines() == 0 then tooltip:ClearAllPoints(); tooltip:Hide(); return end
	if focusOnTooltip then return end
	mouseFocus=GetMouseFocus()
	if not mouseFocus then return end
	
	if mouseFocus==WorldFrame
	then
		if UnitAffectingCombat("player")
		then
			--print("infight")
			tooltip:ClearAllPoints()
			tooltip:Hide()
			tooltipPosition = ""
			return
		elseif not UnitPlayerControlled("mouseover")
			and (tooltipPosition == "mouse" or tooltipPosition == "")
			then
			--print("no player")
			mouseAnchor(tooltip)
			tooltip:SetAlpha(0.84)
			return
		else
			--print("player")
			if tooltipPosition ~= "bottom"
			then
				tooltip:ClearAllPoints()
				tooltip:SetOwner(tooltip:GetParent(), "ANCHOR_NONE")
			end
			tooltip:SetPoint("BOTTOMRIGHT",UIParent,"BOTTOMRIGHT", resX*edgeOffsetX, resY*edgeOffsetY)
			tooltipPosition = "bottom"
			return
		end
	elseif mouseFocus then
		--print("no worldFrame")
		return
	end
end

local function BetterTooltip_OnParentUpdate(self, elapsed)
	parentUpdateTime = parentUpdateTime + elapsed
	if parentUpdateTime > PARENT_UPDATE_TIME then
		parentUpdateTime = 0
		if GameTooltip:IsMouseOver() then
			GameTooltip:Show()
			focusOnTooltip = true
			return
		end
		focusOnTooltip = false
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
	mouseFocus=GetMouseFocus()
	tooltipPosition = ""
	resX = GetScreenHeight() * -1
	resY = GetScreenHeight()
	
	tooltip:ClearAllPoints()
	tooltip:Hide()
	tooltip:SetOwner(parent, "ANCHOR_CURSOR")
	tooltip.default = 1
	BetterTooltip_OnUpdate(tooltip, 0);
end