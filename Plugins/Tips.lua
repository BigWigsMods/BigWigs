-- XXX The tip window needs a "Show tips next raid" checkbox that can be toggled off,
-- XXX but I don't know where to put it without making the window look overcrowded and crappy ><

local plugin = BigWigs:NewPlugin("Tip of the Raid")
if not plugin then return end

local L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Plugins")

-------------------------------------------------------------------------------
-- Options
--

local colorize = nil
do
	local r, g, b
	colorize = setmetatable({}, { __index =
		function(self, key)
			if not r then r, g, b = GameFontNormal:GetTextColor() end
			self[key] = "|cff" .. string.format("%02x%02x%02x", r * 255, g * 255, b * 255) .. key .. "|r"
			return self[key]
		end
	})
end

plugin.defaultDB = {
	show = true,
	automatic = true,
	manual = true,
	chat = false,
}

local function get(info) return plugin.db.profile[info[#info]] end
local function set(info, value) plugin.db.profile[info[#info]] = value end
local function disable() return not plugin.db.profile.show end

plugin.pluginOptions = {
	type = "group",
	name = L["Tips"],
	desc = L["Configure how the raiding tips should be displayed."],
	get = get,
	set = set,
	args = {
		description = {
			type = "description",
			name = L["Tip of the raid will show by default when you zone in to a raid instance, you are not in combat, and your raid group has more than 9 players in it. Only one tip will be shown per session, typically.\n\nHere you can tweak how to display that tip, either using the pimped out window (default), or outputting it to chat. If you play with raid leaders who overuse the |cffff4411/sendtip command|r, you might want to show them in chat frame instead!"],
			order = 1,
			width = "full",
			fontSize = "medium",
		},
		header = {
			type = "description",
			name = " ",
			order = 2,
			width = "full",
		},
		show = {
			type = "toggle",
			name = colorize[L["Enable"]],
			desc = L["If you don't want to see any tips, ever, you can toggle them off here. Tips sent by your raid leader will also be blocked by this, so be careful."],
			order = 3,
			width = "full",
			descStyle = "inline",
		},
		separator = {
			type = "description",
			name = " ",
			order = 10,
			width = "full",
		},
		automatic = {
			type = "toggle",
			name = colorize[L["Automatic tips"]],
			desc = L["If you don't want to see the awesome tips we have, contributed by some of the best PvE players in the world, pop up when you zone in to a raid instance, you can disable this option."],
			order = 11,
			width = "full",
			-- XXX Disabled for this release!
			get = function() return false end,
			disabled = true,
		},
		manual = {
			type = "toggle",
			name = colorize[L["Manual tips"]],
			desc = L["Raid leaders have the ability to show the players in the raid a manual tip with the /sendtip command. If you have a raid leader who spams these things, or for some other reason you just don't want to see them, you can disable it with this option."],
			order = 12,
			width = "full",
			disabled = disable,
		},
		separator2 = {
			type = "description",
			name = " ",
			order = 20,
			width = "full",
		},
		chat = {
			type = "toggle",
			name = colorize[L["Output to chat frame"]],
			desc = L["By default the tips will be shown in their own, awesome window in the middle of your screen. If you toggle this, however, the tips will ONLY be shown in your chat frame as pure text, and the window will never bother you again."],
			order = 21,
			width = "full",
			descStyle = "inline",
			disabled = disable,
		},
	},
}

-------------------------------------------------------------------------------
-- Tips
--

local footers = {
	"Premonition @ Sen'jin US - |cff9999ffwww.premoguild.com|r",
	"|cff9999ffwww.wowace.com/projects/bigwigs|r",
}

--[[
DEATHKNIGHT
DRUID
HUNTER
MAGE
PALADIN
PRIEST
ROGUE
SHAMAN
WARLOCK
WARRIOR
]]

------------[[
-- READ ME:
-- You are NOT ALLOWED to put in your own tips (in the mainline BigWigs repository)
-- without first asking Rabbit!
-- Locally you can do whatever you want, of course. Or in a branch.
-------------------------------------------------------------------------------------]]

-- XXX need to try some zlib compression when we have all the tips, perhaps it'll save us some bytes
local tips = {
	"Rabbit##Turn off warnings and bars for encounter events that you do not care about. That way you won't be spammed, and you can concentrate more on what matters.#2",
	"Rabbit##Remember which sound goes with which message during an encounter. Then, next time, you won't even have to look at the messages.#2",
	"Rabbit##Move the bars around. At least get the non-emphasized ones out of the way - they are mostly useless.#2",
	"Rabbit##/bwcb 15m AFK eating pizza!#2",
	"Rabbit##/bwlcb 20m Oven warm, put in pizza!#2",
	"Rabbit##You can open the proximity monitor manually with /proximity <range>. Can be useful on new fights or if you use a special strategy for a encounter.#2",
	"Rabbit##If your raid leader is spamming you with tips, you can make them output to the chat frame or turn them off completely. Just visit the 'Customize ...' section under the Big Wigs interface options!#2",
	"Rabbit##Sometimes you'll want to remove a bar from the screen while in combat, so you can focus more on some other ability. Clicking your middle mouse button over a bar will stop it -- but next time the ability is used, it will reappear.#2",
}

-------------------------------------------------------------------------------
-- Tip window
--

local showTip = nil
do
	local window, editbox, header, text, footer = nil, nil, nil, nil, nil
	local coolButton = nil
	local function getURL() return select(3, footer:GetText():find("cff9999ff(.*)|r")) end
	local function textChanged(self)
		self:SetText(getURL())
		self:HighlightText()
	end
	local function hideEditbox()
		if not editbox then return end
		editbox:Hide()
		footer:Show()
	end
	local function footerClicked(self)
		local url = getURL()
		if not url then return end
		if not editbox then
			editbox = CreateFrame("EditBox", nil, self, "InputBoxTemplate")
			editbox:SetPoint("BOTTOM", self)
			editbox:SetPoint("TOP", self)
			editbox:SetPoint("LEFT", window, "LEFT", 22, 0)
			editbox:SetPoint("RIGHT", window, "RIGHT", -18, 0)
			editbox:Hide()
			editbox:SetFontObject("GameFontHighlight")
			editbox:SetScript("OnEscapePressed", editbox.ClearFocus)
			editbox:SetScript("OnEnterPressed", editbox.ClearFocus)
			editbox:SetScript("OnEditFocusLost", hideEditbox)
			editbox:SetScript("OnEditFocusGained", editbox.HighlightText)
			editbox:SetScript("OnTextChanged", textChanged)
		end
		editbox:SetText(url)
		editbox:Show()
		footer:Hide()
	end
	local function closeWindow()
		hideEditbox()
		window:Hide()
	end

	local function createTipFrame()
		window = CreateFrame("Frame", nil, UIParent)
		window:SetWidth(240)
		window:SetHeight(175)
		window:SetPoint("CENTER")
		window:SetMovable(true)
		window:EnableMouse(true)
		window:SetClampedToScreen(true)
		window:RegisterForDrag("LeftButton")
		window:SetScript("OnDragStart", window.StartMoving)
		window:SetScript("OnDragStop", window.StopMovingOrSizing)

		local titlebg = window:CreateTexture(nil, "BACKGROUND")
		titlebg:SetTexture("Interface\\PaperDollInfoFrame\\UI-GearManager-Title-Background")
		titlebg:SetPoint("TOPLEFT", 9, -6)
		titlebg:SetPoint("BOTTOMRIGHT", window, "TOPRIGHT", -28, -24)

		local dialogbg = window:CreateTexture(nil, "BACKGROUND")
		dialogbg:SetTexture("Interface\\Tooltips\\UI-Tooltip-Background")
		dialogbg:SetPoint("TOPLEFT", 8, -24)
		dialogbg:SetPoint("BOTTOMRIGHT", -6, 8)
		dialogbg:SetVertexColor(0, 0, 0, .75)

		local topleft = window:CreateTexture(nil, "BORDER")
		topleft:SetTexture("Interface\\PaperDollInfoFrame\\UI-GearManager-Border")
		topleft:SetWidth(64)
		topleft:SetHeight(64)
		topleft:SetPoint("TOPLEFT")
		topleft:SetTexCoord(0.501953125, 0.625, 0, 1)

		local topright = window:CreateTexture(nil, "BORDER")
		topright:SetTexture("Interface\\PaperDollInfoFrame\\UI-GearManager-Border")
		topright:SetWidth(64)
		topright:SetHeight(64)
		topright:SetPoint("TOPRIGHT")
		topright:SetTexCoord(0.625, 0.75, 0, 1)

		local top = window:CreateTexture(nil, "BORDER")
		top:SetTexture("Interface\\PaperDollInfoFrame\\UI-GearManager-Border")
		top:SetHeight(64)
		top:SetPoint("TOPLEFT", topleft, "TOPRIGHT")
		top:SetPoint("TOPRIGHT", topright, "TOPLEFT")
		top:SetTexCoord(0.25, 0.369140625, 0, 1)

		local bottomleft = window:CreateTexture(nil, "BORDER")
		bottomleft:SetTexture("Interface\\PaperDollInfoFrame\\UI-GearManager-Border")
		bottomleft:SetWidth(64)
		bottomleft:SetHeight(64)
		bottomleft:SetPoint("BOTTOMLEFT")
		bottomleft:SetTexCoord(0.751953125, 0.875, 0, 1)

		local bottomright = window:CreateTexture(nil, "BORDER")
		bottomright:SetTexture("Interface\\PaperDollInfoFrame\\UI-GearManager-Border")
		bottomright:SetWidth(64)
		bottomright:SetHeight(64)
		bottomright:SetPoint("BOTTOMRIGHT")
		bottomright:SetTexCoord(0.875, 1, 0, 1)

		local bottom = window:CreateTexture(nil, "BORDER")
		bottom:SetTexture("Interface\\PaperDollInfoFrame\\UI-GearManager-Border")
		bottom:SetHeight(64)
		bottom:SetPoint("BOTTOMLEFT", bottomleft, "BOTTOMRIGHT")
		bottom:SetPoint("BOTTOMRIGHT", bottomright, "BOTTOMLEFT")
		bottom:SetTexCoord(0.376953125, 0.498046875, 0, 1)

		local left = window:CreateTexture(nil, "BORDER")
		left:SetTexture("Interface\\PaperDollInfoFrame\\UI-GearManager-Border")
		left:SetWidth(64)
		left:SetPoint("TOPLEFT", topleft, "BOTTOMLEFT")
		left:SetPoint("BOTTOMLEFT", bottomleft, "TOPLEFT")
		left:SetTexCoord(0.001953125, 0.125, 0, 1)

		local right = window:CreateTexture(nil, "BORDER")
		right:SetTexture("Interface\\PaperDollInfoFrame\\UI-GearManager-Border")
		right:SetWidth(64)
		right:SetPoint("TOPRIGHT", topright, "BOTTOMRIGHT")
		right:SetPoint("BOTTOMRIGHT", bottomright, "TOPRIGHT")
		right:SetTexCoord(0.1171875, 0.2421875, 0, 1)

		local close = CreateFrame("Button", nil, window, "UIPanelCloseButton")
		close:SetPoint("TOPRIGHT", 2, 1)
		close:SetScript("OnClick", closeWindow)

		local title = window:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		title:SetAllPoints(titlebg)
		title:SetJustifyH("CENTER")
		title:SetText("Tip of the Raid")

		header = window:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
		header:SetPoint("TOPLEFT", 16, -32)
		header:SetPoint("TOPRIGHT", -16, -32)
		header:SetJustifyH("LEFT")

		local nextButton = CreateFrame("Button", nil, window)
		nextButton:SetPoint("BOTTOMLEFT", 16, 16)
		nextButton:SetWidth(16)
		nextButton:SetHeight(16)
		nextButton:SetScript("OnClick", function() plugin:RandomTip() end)
		nextButton:SetNormalTexture("Interface\\Buttons\\UI-GroupLoot-Dice-Up")
		nextButton:SetPushedTexture("Interface\\Buttons\\UI-GroupLoot-Dice-Down")
		nextButton:SetHighlightTexture("Interface\\Buttons\\UI-GroupLoot-Dice-Highlight")

		coolButton = CreateFrame("Button", "BWTipCloseButton", window, "UIPanelButtonTemplate2")
		coolButton:SetPoint("BOTTOMLEFT", nextButton, "BOTTOMRIGHT", 4, 0)
		coolButton:SetPoint("RIGHT", window, "RIGHT", -16, 0)
		coolButton:SetHeight(22)
		coolButton:SetScript("OnClick", closeWindow)
		coolButton:SetText(L["Cool!"])

		footer = window:CreateFontString(nil, "ARTWORK", "GameFontDisable")
		footer:SetPoint("BOTTOMLEFT", nextButton, "TOPLEFT", 0, 10)
		footer:SetPoint("BOTTOMRIGHT", coolButton, "TOPRIGHT", 0, 6)
		footer:SetShadowColor(0, 0, 0, 0)
		footer:SetShadowOffset(1.5, -1.5)

		local button = CreateFrame("Button", nil, window)
		button:SetAllPoints(footer)
		button:SetScript("OnClick", footerClicked)
		button:SetScript("OnEnter", function() footer:SetShadowColor(0.2, 0.2, 1, 0.6) end)
		button:SetScript("OnLeave", function() footer:SetShadowColor(0, 0, 0, 0) end)

		text = window:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
		text:SetPoint("TOPLEFT", header, "BOTTOMLEFT", 0, -4)
		text:SetPoint("BOTTOMRIGHT", footer, "TOPRIGHT", 0, 4)
		text:SetJustifyH("LEFT")
		text:SetJustifyV("TOP")
	end

	function showTip(h, t, f)
		if not window then createTipFrame() end
		header:SetText(h)
		text:SetText(t)
		if f then
			footer:SetText(f)
			footer:Show()
		else
			footer:Hide()
		end
		window:Show()
	end
end

-------------------------------------------------------------------------------
-- Plugin init
--

local function check()
	if not InCombatLockdown() and GetNumRaidMembers() > 9 and select(2, IsInInstance()) == "raid" then
		plugin:UnregisterEvent("PLAYER_REGEN_ENABLED")
		plugin:UnregisterEvent("RAID_ROSTER_UPDATE")
		plugin:UnregisterEvent("PLAYER_ENTERING_WORLD")
		if plugin.db.profile.show and plugin.db.profile.automatic then
			plugin:RandomTip()
		end
	end
end

function plugin:OnPluginEnable()
	--self:RegisterEvent("PLAYER_REGEN_ENABLED", check)
	--self:RegisterEvent("RAID_ROSTER_UPDATE", check)
	--self:RegisterEvent("PLAYER_ENTERING_WORLD", check)
	self:RegisterEvent("CHAT_MSG_ADDON")
end

-------------------------------------------------------------------------------
-- Events
--

function plugin:CHAT_MSG_ADDON(event, prefix, message, distribution, sender)
	if prefix ~= "BWTIP" or not self.db.profile.manual then return end
	if not UnitIsRaidOfficer(sender) then return end
	self:ShowTip(message)
end

-------------------------------------------------------------------------------
-- API
--

do
	local headerFormat = "|cff%s%s|r says:"
	local DEVELOPER_COLOR = { -- XXX Find a better color, this one looks crap!
		r = 0.4,
		g = 0.7,
		b = 0.4,
	}

	function plugin:RandomTip()
		self:ShowTip(tips[math.random(1, #tips)])
	end

	function plugin:ShowTip(tipString)
		local player, class, text, footerInput = strsplit("#", tipString, 4)
		if not player or not text then return end
		local c = RAID_CLASS_COLORS[class] or DEVELOPER_COLOR
		local header = headerFormat:format(string.format("%02x%02x%02x", c.r * 255, c.g * 255, c.b * 255), player)
		local footer = nil
		if tonumber(footerInput) then
			footer = footers[tonumber(footerInput)]
		elseif type(footerInput) == "string" and footerInput:trim():len() > 0 then
			footer = footerInput
		end
		showTip(header, text, footer)
	end
end

-------------------------------------------------------------------------------
-- Slash command
--

SlashCmdList.BigWigs_TipOfTheRaid = function(input)
	if not plugin:IsEnabled() then BigWigs:Enable() end
	plugin:RandomTip()
end
SLASH_BigWigs_TipOfTheRaid1 = "/raidtip"
SLASH_BigWigs_TipOfTheRaid2 = "/tipoftheraid"
SLASH_BigWigs_TipOfTheRaid3 = "/tip"

local pName = UnitName("player")
local _, pClass = UnitClass("player")
SlashCmdList.BigWigs_SendRaidTip = function(input)
	if not plugin:IsEnabled() then BigWigs:Enable() end
	input = input:trim()
	if not UnitInRaid("player") or not IsRaidLeader() or not tonumber(input) or #input < 5 then
		print(L["Usage: /sendtip <index|\"Custom tip\">"])
		print(L["You must be the raid leader to broadcast a tip."])
		return
	end
	if tonumber(input) then
		local index = tonumber(input)
		if tips[index] then
			SendAddonMessage("BWTIP", tips[index], "RAID")
		else
			print(L["Tip index out of bounds, accepted indexes range from 1 to %d."]:format(#tips))
		end
	else
		local guildName = IsInGuild() and (GetGuildInfo("player")) or ""
		local tip = pName .. "#" .. pClass .. "#" .. input .. "#" .. guildName
		SendAddonMessage("BWTIP", tip, "RAID")
	end
end
SLASH_BigWigs_SendRaidTip1 = "/sendtip"

