
assert(BigWigs, "BigWigs not found!")

------------------------------
--      Are you local?      --
------------------------------

local L = AceLibrary("AceLocale-2.0"):new("BigWigsMessages")
local dewdrop = AceLibrary("Dewdrop-2.0")
local paint = AceLibrary("PaintChips-2.0")

local rwframe, frame
local minscale, maxscale = 0.25, 2


----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	["Messages"] = true,

	["msg"] = true,
	["anchor"] = true,
	["rw"] = true,
	["color"] = true,
	["scale"] = true,

	["Options for the message frame."] = true,
	["Show the message anchor frame."] = true,
	["Toggle sending messages to the RaidWarnings frame."] = true,
	["Toggles white only messages ignoring coloring."] = true,
	["Set the bar scale."] = true,

	["Message frame"] = true,
	["Show anchor"] = true,
	["Send messages to RaidWarning frame"] = true,
	["Set the message frame scale."] = true,
	["Colorize messages"] = true,
	["Scale"] = true,

	["|cffff0000Co|cffff00fflo|cff00ff00r|r"] = true,
	["White"] = true,
	["BigWigs frame"] = true,
	["RaidWarning frame"] = true,
	["Scale is set to %s"] = true,
	["Messages are now sent to the %2$s"] = true,
	["Messages are currently sent to the %2$s"] = true,
} end)


L:RegisterTranslations("koKR", function() return {
	["msg"] = "메시지",
	["anchor"] = "위치",
	["rw"] = "공대경고",
	["scale"] = "크기",

	["Options for the message frame."] = "메시지 창 옵션.",
	["Show the message anchor frame."] = "메시지 위치 조정 프레임 보이기.",
	["Toggle sending messages to the RaidWarnings frame."] = "공대경고 창으로 메시지 보내기.",
	["Toggles white only messages ignoring coloring."] = "메시지를 하얀 색으로 변경.",
	["Set the bar scale."] = "메시지 크기 조정.",

	["Message frame"] = "메시지 창",
	["Show anchor"] = "앵커 보이기",
	["Send messages to RaidWarning frame"] = "공대경고 창으로 메시지 보내기",
	["Colorize messages"] = "컬러 메시지",
	["Scale"] = "크기",
} end)


----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsMessages = BigWigs:NewModule(L"Messages")
BigWigsMessages.defaultDB = {
	useraidwarn = true,
	usecolors = true,
	scale = 1.0,
}
BigWigsMessages.consoleCmd = L"msg"
BigWigsMessages.consoleOptions = {
	type = "group",
	name = L"Messages",
	desc = L"Options for the message frame.",
	args   = {
		[L"anchor"] = {
			type = "execute",
			name = "Anchor",
			desc = L"Show the message anchor frame.",
			func = function() BigWigsMessages.anchorframe:Show() end,
		},
		[L"rw"] = {
			type = "toggle",
			name = "Use RaidWarning",
			desc = L"Toggle sending messages to the RaidWarnings frame.",
			get = function() return BigWigsMessages.db.profile.useraidwarn end,
			set = function(v)
				BigWigsMessages.db.profile.useraidwarn = v
				frame = v and RaidWarningFrame or BigWigsMessages.msgframe or BigWigsMessages:CreateMsgFrame()
			end,
			message = L"Messages are now sent to the %2$s",
			current = L"Messages are currently sent to the %2$s",
			map = {[true] = L"RaidWarning frame", [false] = L"BigWigs frame"},
		},
		[L"color"] = {
			type = "toggle",
			name = "Use colors",
			desc = L"Toggles white only messages ignoring coloring.",
			get = function() return BigWigsMessages.db.profile.usecolors end,
			set = function(v) BigWigsMessages.db.profile.usecolors = v end,
			map = {[true] = L"|cffff0000Co|cffff00fflo|cff00ff00r|r", [false] = L"White"},
		},
		[L"scale"] = {
			type = "range",
			name = "Message frame scale",
			desc = L"Set the message frame scale.",
			min = 0.2,
			max = 2.0,
			step = 0.1,
			get = function() return BigWigsMessages.db.profile.scale end,
			set = function(v)
				BigWigsMessages.db.profile.scale = v
				if BigWigsMessages.msgframe then BigWigsMessages.msgframe:SetScale(v) end
			end,
			hidden = function() return BigWigsMessages.db.profile.useraidwarn end,
		},
	},
}


------------------------------
--      Initialization      --
------------------------------

function BigWigsMessages:OnInitialize()
	self.anchorframe, rwframe = BigWigsMsgAnchorFrame, RaidWarningFrame
	frame = self.db.profile.useraidwarn and RaidWarningFrame or self:CreateMsgFrame()
	dewdrop:Register(BigWigsMsgAnchorFrameMenu, "children", self.core.cmdtable)
end


function BigWigsMessages:OnEnable()
	self:RegisterEvent("BigWigs_Message")
	self:RegisterEvent("BigWigs_ShowAnchors")
	self:RegisterEvent("BigWigs_HideAnchors")
end


function BigWigsMessages:CreateMsgFrame()
	self.msgframe = CreateFrame("MessageFrame")
	self.msgframe:SetWidth(512)
	self.msgframe:SetHeight(80)

	self.msgframe:SetPoint("TOP", self.anchorframe, "BOTTOM", 0, 0)
	self.msgframe:SetScale(self.db.profile.scale or 1)
	self.msgframe:SetInsertMode("TOP")
	self.msgframe:SetFrameStrata("HIGH")
	self.msgframe:SetToplevel(true)
	self.msgframe:SetFontObject(GameFontNormalLarge)
	self.msgframe:Show()

	return self.msgframe
end


------------------------------
--      Event Handlers      --
------------------------------

function BigWigsMessages:BigWigs_ShowAnchors()
	self.anchorframe:Show()
end


function BigWigsMessages:BigWigs_HideAnchors()
	self.anchorframe:Hide()
end


function BigWigsMessages:BigWigs_Message(text, color)
	if not text then return end
	local _, r, g, b = paint:GetRGBPercent(self.db.profile.usecolors and color or "white")
	local f = self.db.profile.userwaidwarn and self.msgframe or rwframe
	frame:AddMessage(text, r, g, b, 1, UIERRORS_HOLD_TIME)
end
