
assert(BigWigs, "BigWigs not found!")

----------------------------
--      Localization      --
----------------------------

local L = AceLibrary("AceLocale-2.0"):new("BigWigsTranq")

L:RegisterTranslations("enUS", function() return {
	CHAT_MSG_SPELL_SELF_BUFF = "You fail to dispel (.+)'s Frenzy.",
	CHAT_MSG_SPELL_SELF_DAMAGE = "You cast Tranquilizing Shot on (.+).",

	["Tranq - "] = true,
	["%s's Tranq failed!"] = true,
} end)

L:RegisterTranslations("zhCN", function() return {
	CHAT_MSG_SPELL_SELF_BUFF = "你未能驱散(.+)的狂乱。",
	CHAT_MSG_SPELL_SELF_DAMAGE = "你对(.+)施放了宁神射击。",

	["Tranq - "] = "宁神射击 - ",
	["%s's Tranq failed!"] = "%s的宁神射击失败了！",
} end)

L:RegisterTranslations("deDE", function() return {
	CHAT_MSG_SPELL_SELF_BUFF = "(.+) kann dies nicht bannen: Raserei", -- ?
	CHAT_MSG_SPELL_SELF_DAMAGE = "Ihr wirkt Einlullender Schuss auf (.+)",

	["Tranq - "] = "Einlullender Schuss - ",
	["%s's Tranq failed!"] = "%s's Einlullender Schuss verfehlt", -- ?
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsTranq = BigWigs:NewModule("Tranq")
BigWigsTranq.revision = tonumber(string.sub("$Revision$", 12, -3))
--~~ BigWigsTranq.consoleCmd = L"msg"
--~~ BigWigsTranq.consoleOptions = {
--~~ 	type = "group",
--~~ 	name = "Tranq",
--~~ 	desc = L"Options for the message frame.",
--~~ 	args   = {
--~~ 		[L"anchor"] = {
--~~ 			type = "execute",
--~~ 			name = "Anchor",
--~~ 			desc = L"Show the message anchor frame.",
--~~ 			func = function() BigWigsTranq.anchorframe:Show() end,
--~~ 			hidden = function() return BigWigsTranq.db.profile.useraidwarn end,
--~~ 		},
--~~ 		[L"rw"] = {
--~~ 			type = "toggle",
--~~ 			name = "Use RaidWarning",
--~~ 			desc = L"Toggle sending messages to the RaidWarnings frame.",
--~~ 			get = function() return BigWigsTranq.db.profile.useraidwarn end,
--~~ 			set = function(v)
--~~ 				BigWigsTranq.db.profile.useraidwarn = v
--~~ 				frame = v and RaidWarningFrame or BigWigsTranq.msgframe or BigWigsTranq:CreateMsgFrame()
--~~ 			end,
--~~ 			message = L"Messages are now sent to the %2$s",
--~~ 			current = L"Messages are currently sent to the %2$s",
--~~ 			map = {[true] = L"RaidWarning frame", [false] = L"BigWigs frame"},
--~~ 		},
--~~ 		[L"color"] = {
--~~ 			type = "toggle",
--~~ 			name = "Use colors",
--~~ 			desc = L"Toggles white only messages ignoring coloring.",
--~~ 			get = function() return BigWigsTranq.db.profile.usecolors end,
--~~ 			set = function(v) BigWigsTranq.db.profile.usecolors = v end,
--~~ 			map = {[true] = L"|cffff0000Co|cffff00fflo|cff00ff00r|r", [false] = L"White"},
--~~ 		},
--~~ 		[L"scale"] = {
--~~ 			type = "range",
--~~ 			name = "Message frame scale",
--~~ 			desc = L"Set the message frame scale.",
--~~ 			min = 0.2,
--~~ 			max = 2.0,
--~~ 			step = 0.1,
--~~ 			get = function() return BigWigsTranq.db.profile.scale end,
--~~ 			set = function(v)
--~~ 				BigWigsTranq.db.profile.scale = v
--~~ 				if BigWigsTranq.msgframe then BigWigsTranq.msgframe:SetScale(v) end
--~~ 			end,
--~~ 			hidden = function() return BigWigsTranq.db.profile.useraidwarn end,
--~~ 		},
--~~ 	},
--~~ }


------------------------------
--      Initialization      --
------------------------------

function BigWigsTranq:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_SELF_BUFF")
	self:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE")

	self:RegisterEvent("BigWigs_RecvSync")
	self:RegisterEvent("BigWigs_TranqFired", 5)
	self:RegisterEvent("BigWigs_TranqFail", 5)
end


------------------------------
--      Event Handlers      --
------------------------------

function BigWigsTranq:CHAT_MSG_SPELL_SELF_BUFF(msg)
	if string.find(msg, L"CHAT_MSG_SPELL_SELF_BUFF") then
		self:TriggerEvent("BigWigs_SendSync", "TranqShotFail "..UnitName("player"))
	end
end


function BigWigsTranq:CHAT_MSG_SPELL_SELF_DAMAGE(msg)
	if string.find(msg, L"CHAT_MSG_SPELL_SELF_DAMAGE") then
		self:TriggerEvent("BigWigs_SendSync", "TranqShotFired "..UnitName("player"))
	end
end


function BigWigsTranq:BigWigs_RecvSync(sync, details, sender)
	if sync == "TranqShotFired" then self:TriggerEvent("BigWigs_TranqFired", details)
	elseif sync == "TranqShotFail" then self:TriggerEvent("BigWigs_TranqFail", details) end
end


function BigWigsTranq:BigWigs_TranqFired(unitname)
	self:TriggerEvent("BigWigs_StartBar", self, L"Tranq - "..unitname, 20, "Interface\\Icons\\Spell_Nature_Drowsy", "Green")
end


function BigWigsTranq:BigWigs_TranqFail(unitname)
	self:SetCandyBarColor(L"Tranq - "..unitname, "Red")
	self:TriggerEvent("BigWigs_Message", format(l"%s's Tranq failed!", unitname), "Red", nil, "Alarm")
end
