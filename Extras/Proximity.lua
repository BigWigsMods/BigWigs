assert( BigWigs, "BigWigs not found!")

-----------------------------------------------------------------------
--      Are you local?
-----------------------------------------------------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigsProximity")

local RL
local paintchips = AceLibrary("PaintChips-2.0")
local proximityCheck = {}
local active
local anchor
local lastplayed = 0
local playername

local coloredNames = setmetatable({}, {__index =
	function(self, key)
		if RL then
			local obj = RL:GetUnitObjectFromName(key)
			if not obj then return key end
			self[key] = "|cff" .. paintchips:GetHex(obj.class) .. key .. "|r"
		else
			local num = GetNumRaidMembers()
			local found
			for i = 1, num do
				if UnitExists("raid"..i) and UnitName("raid"..i) == key then
					local class = select(2, UnitClass("raid"..i) )
					self[key] = "|cff" .. paintchips:GetHex(class) .. key .."|r"
					found = true
				end
			end
			if not found then
				return key
			end
		end
		return self[key]
	end
})

-----------------------------------------------------------------------
--      Localization
-----------------------------------------------------------------------

L:RegisterTranslations("enUS", function() return {
	["Proximity"] = true,
	["Options for the Proximity Display."] = true,
	["Nobody"] = true,
	["Sound"] = true,
	["Play sound on proximity."] = true,
	["Disabled"] = true,
	["Disable the proximity display."] = true,

	proximity = "Proximity Alert",
	proximity_desc = "Show the proximity window.",
} end)

L:RegisterTranslations("koKR", function() return {
	--["Proximity"] = true,
	--["Options for the Proximity Display."] = true,
	["Nobody"] = "아무도 없음",
	["Sound"] = "경고음",
	--["Play sound on proximity."] = true,
	--["Disabled"] = true,
	--["Disable the proximity display."] = true,
} end )

L:RegisterTranslations("frFR", function() return {
	["Proximity"] = "Proximité",
	["Options for the Proximity Display."] = "Options concernant l'affichage de proximité.",
	["Nobody"] = "Personne",
	["Sound"] = "Son",
	["Play sound on proximity."] = "Joue un son quand à proximité.",
	["Disabled"] = "Désactivé",
	["Disable the proximity display."] = "Désactive l'affichage de proximité.",
} end)

-----------------------------------------------------------------------
--      Module Declaration
-----------------------------------------------------------------------

local plugin = BigWigs:NewModule("Proximity")
plugin.revision = tonumber(("$Revision$"):sub(12, -3))
plugin.defaultDB = {
	posx = nil,
	posy = nil,
	sound = true,
	disabled = nil,
}
plugin.external = true

plugin.consoleCmd = L["Proximity"]
plugin.consoleOptions = {
	type = "group",
	name = L["Proximity"],
	desc = L["Options for the Proximity Display."],
	handler = plugin,
	pass = true,
	get = function( key )
		return plugin.db.profile[key]
	end,
	set = function( key, value )
		plugin.db.profile[key] = value
		if key == "disabled" then
			if value then
				plugin:CloseProximity()
			else
				plugin:OpenProximity()
			end
		end
	end,
	args = {
		sound = {
			type = "toggle",
			name = L["Sound"],
			desc = L["Play sound on proximity."],
			order = 1,
		},
		disabled = {
			type = "toggle",
			name = L["Disabled"],
			desc = L["Disable the proximity display."],
			order = 2,
		}
	}
}

-----------------------------------------------------------------------
--      Initialization
-----------------------------------------------------------------------

function plugin:OnRegister()
	BigWigs:RegisterBossOption("proximity", L["proximity"], L["proximity_desc"])
end

function plugin:OnEnable()
	self:RegisterEvent("Ace2_AddonEnabled")
	self:RegisterEvent("Ace2_AddonDisabled")
	playername = UnitName("player")
	if AceLibrary:HasInstance("Roster-2.1") then
		RL = AceLibrary("Roster-2.1")
	end
end

-----------------------------------------------------------------------
--      Event Handlers
-----------------------------------------------------------------------

function plugin:Ace2_AddonDisabled(module)
	if active == module then
		self:CloseProximity()
	end
end

function plugin:Ace2_AddonEnabled(module)
	if type( module.proximityCheck ) == "function" then
		proximityCheck[module] = module.proximityCheck
		active = module
		self:OpenProximity()
	end
end

function plugin:CloseProximity()
	if anchor then anchor:Hide() end
	self:CancelScheduledEvent("bwproximityupdate")
end

function plugin:OpenProximity()
	if self.db.profile.disabled or not active or not type( proximityCheck[active] ) == "function" or not active.db.profile.proximity then return end
	self:SetupFrames()
	local text = L["Proximity"]
	if active.name then
		text = text .. " ".. active.name
	end
	anchor.cheader:SetText(text)
	anchor:Show()
	if not self:IsEventScheduled("bwproximityupdate") then
		self:ScheduleRepeatingEvent("bwproximityupdate", function() self:UpdateProximity() end, .1)
	end
end

function plugin:UpdateProximity()
	local tooclose = 0
	local text = ""
	local t
	if not active or not type( proximityCheck[active] ) == "function" then return end
	if RL then
		for n, u in pairs(RL.roster) do
			if u and u.name and u.class ~= "PET" and not UnitIsDeadOrGhost(u.unitid) then
				if tooclose < 5 and u.name ~= playername and proximityCheck[active](u.unitid) then
					text = text .. coloredNames[u.name] .. "\n"
					tooclose = tooclose + 1
				end
			end
		end
	else
		local num = GetNumRaidMembers()
		local unit
		for i = 1, num do
			unit = "raid"..i
			if UnitExists(unit) and not UnitIsDeadOrGhost(unit) and UnitName(unit) ~= playername then
				if tooclose < 5 and proximityCheck[active](unit) then
					text = text .. coloredNames[u.name] .. "\n"
					tooclose = tooclose + 1
				end
			end
		end
	end
	if tooclose == 0 then
		anchor.text:SetText("|cff777777"..L["Nobody"].."|r")
	else
		anchor.text:SetText(text)
		t = time()
		if t > lastplayed + 1 then
			lastplayed = t
			if self.db.profile.sound and UnitAffectingCombat("player") and not active.proximitySilent then
				self:TriggerEvent("BigWigs_Sound", "Alarm")
			end
		end
	end
end

------------------------------
--    Create the Anchor     --
------------------------------

function plugin:SetupFrames()
	if anchor then return end

	local frame = CreateFrame("Frame", "BigWigsProximityAnchor", UIParent)
	frame:Hide()

	frame:SetWidth(200)
	frame:SetHeight(100)

	frame:SetBackdrop({
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16,
		edgeFile = "Interface\\AddOns\\BigWigs\\Textures\\otravi-semi-full-border", edgeSize = 32,
		insets = {left = 1, right = 1, top = 20, bottom = 1},
	})

	frame:SetBackdropColor(24/255, 24/255, 24/255)
	frame:ClearAllPoints()
	frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	frame:EnableMouse(true)
	frame:RegisterForDrag("LeftButton")
	frame:SetMovable(true)
	frame:SetScript("OnDragStart", function() this:StartMoving() end)
	frame:SetScript("OnDragStop", function()
		this:StopMovingOrSizing()
		self:SavePosition()
	end)

	local cheader = frame:CreateFontString(nil, "OVERLAY")
	cheader:ClearAllPoints()
	cheader:SetWidth(190)
	cheader:SetHeight(15)
	cheader:SetPoint("TOP", frame, "TOP", 0, -14)
	cheader:SetFont("Fonts\\FRIZQT__.TTF", 12)
	cheader:SetJustifyH("LEFT")
	cheader:SetText(L["Proximity"])
	cheader:SetShadowOffset(.8, -.8)
	cheader:SetShadowColor(0, 0, 0, 1)
	frame.cheader = cheader

	local text = frame:CreateFontString(nil, "OVERLAY")
	text:ClearAllPoints()
	text:SetWidth( 190 )
	text:SetHeight( 80 )
	text:SetPoint( "TOP", frame, "TOP", 0, -35 )
	text:SetJustifyH("CENTER")
	text:SetJustifyV("TOP")
	text:SetFont("Fonts\\FRIZQT__.TTF", 12)
	frame.text = text

	local close = frame:CreateTexture(nil, "ARTWORK")
	close:SetTexture("Interface\\AddOns\\BigWigs\\Textures\\otravi-close")
	close:SetTexCoord(0, .625, 0, .9333)

	close:SetWidth(20)
	close:SetHeight(14)
	close:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -7, -15)

	local closebutton = CreateFrame("Button", nil)
	closebutton:SetParent( frame )
	closebutton:SetWidth(20)
	closebutton:SetHeight(14)
	closebutton:SetPoint("CENTER", close, "CENTER")
	closebutton:SetScript( "OnClick", function() self:CloseProximity() end )

	anchor = frame

	local x = self.db.profile.posx
	local y = self.db.profile.posy
	if x and y then
		local s = anchor:GetEffectiveScale()
		anchor:ClearAllPoints()
		anchor:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x / s, y / s)
	else
		self:ResetAnchor()
	end
end

function plugin:ResetAnchor()
	if not anchor then self:SetupFrames() end
	anchor:ClearAllPoints()
	anchor:SetPoint("CENTER", UIParent, "CENTER")
	self.db.profile.posx = nil
	self.db.profile.posy = nil
end

function plugin:SavePosition()
	if not anchor then self:SetupFrames() end

	local s = anchor:GetEffectiveScale()
	self.db.profile.posx = anchor:GetLeft() * s
	self.db.profile.posy = anchor:GetTop() * s
end

