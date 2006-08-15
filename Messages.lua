
assert(BigWigs, "BigWigs not found!")

------------------------------
--      Are you local?      --
------------------------------

local L = AceLibrary("AceLocale-2.0"):new("BigWigsMessages")
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
	["Anchor"] = true,
	["Show the message anchor frame."] = true,
	["Use RaidWarning"] = true,
	["Toggle sending messages to the RaidWarnings frame."] = true,
	["Use colors"] = true,
	["Toggles white only messages ignoring coloring."] = true,
	["Message frame scale"] = true,

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

	["Message frame"] = "메시지 창",
	["Show anchor"] = "앵커 보이기",
	["Send messages to RaidWarning frame"] = "공대경고 창으로 메시지 보내기",
	["Colorize messages"] = "컬러 메시지",
	["Scale"] = "크기",
} end)

L:RegisterTranslations("zhCN", function() return {
	["Messages"] = "信息",

	["Options for the message frame."] = "信息框体设置。",
	["Anchor"] = "锚点",
	["Show the message anchor frame."] = "显示信息框体锚点。",
	["Use RaidWarning"] = "使用团队警告",
	["Toggle sending messages to the RaidWarnings frame."] = "切换是否通过团队警告框体发送信息。",
	["Use colors"] = "发送彩色信息",
	["Toggles white only messages ignoring coloring."] = "切换是否只发送单色信息。",
	["Message frame scale"] = "信息框体缩放",

	["Message frame"] = "信息框体",
	["Show anchor"] = "显示锚点",
	["Send messages to RaidWarning frame"] = "通过团队警告框体发送信息",
	["Set the message frame scale."] = "设置信息框体缩放比例",
	["Colorize messages"] = "彩色信息",
	["Scale"] = "缩放",

	["White"] = "白色",
	["BigWigs frame"] = "BigWigs框体",
	["RaidWarning frame"] = "团队警告框体",
	["Scale is set to %s"] = "缩放比例设置为%s",
	["Messages are now sent to the %2$s"] = "信息设置为发送到%2$s",
	["Messages are currently sent to the %2$s"] = "信息当前设置为发送到%2$s",
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
			name = L"Anchor",
			desc = L"Show the message anchor frame.",
			func = function() BigWigsMessages.anchorframe:Show() end,
			hidden = function() return BigWigsMessages.db.profile.useraidwarn end,
		},
		[L"rw"] = {
			type = "toggle",
			name = L"Use RaidWarning",
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
			name = L"Use colors",
			desc = L"Toggles white only messages ignoring coloring.",
			get = function() return BigWigsMessages.db.profile.usecolors end,
			set = function(v) BigWigsMessages.db.profile.usecolors = v end,
			map = {[true] = L"|cffff0000Co|cffff00fflo|cff00ff00r|r", [false] = L"White"},
		},
		[L"scale"] = {
			type = "range",
			name = L"Message frame scale",
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


function BigWigsMessages:BigWigs_Message(text, type)
	if not text then return end
	local _, r, g, b = paint:GetRGBPercent(self.db.profile.usecolors and BigWigsColors:MsgColor(type) or "white")
	local f = self.db.profile.userwaidwarn and self.msgframe or rwframe
	frame:AddMessage(text, r, g, b, 1, UIERRORS_HOLD_TIME)
end
