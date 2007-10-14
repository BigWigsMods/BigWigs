------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Zul'jin"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")

local pName = nil

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Zul'jin",

	engage_trigger = "Nobody badduh dan me!",

	form = "Form Shift",
	form_desc = "Warn when Zul'jin changes form.",
	form_bear_trigger = "Got me some new tricks... like me brudda bear....",
	form_bear_message = "Bear Form!",
	form_eagle_trigger = "Dere be no hidin' from da eagle!",
	form_eagle_message = "Eagle Form!",
	form_lynx_trigger = "Let me introduce you to me new bruddas: fang and claw!",
	form_lynx_message = "Lynx Form!",
	form_dragonhawk_trigger = "Ya don' have to look to da sky to see da dragonhawk!",
	form_dragonhawk_message = "Dragonhawk Form!",

	paralysis = "Paralysis",
	paralysis_desc = "Warn who is afflicted by Creeping Paralysis.",
	paralysis_trigger = "^(%S+) (%S+) afflicted by Creeping Paralysis%.$",
	paralysis_message = "Paralysis: %s",

	icon = "Raid Icon",
	icon_desc = "Place a Raid Target Icon on the player with Creeping Paralysis. (requires promoted or higher)",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Zul'Aman"]
mod.enabletrigger = boss
mod.toggleoptions = {"form", -1, "paralysis", "icon", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "CreepPara")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "CreepPara")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "CreepPara")

	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	pName = UnitName("player")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if not self.db.profile.form then return end

	if msg == L["form_bear_trigger"] then
		self:Message(L["form_bear_message"], "Positive")
	elseif msg == L["form_eagle_trigger"] then
		self:Message(L["form_eagle_message"], "Positive")
	elseif msg == L["form_lynx_trigger"] then
		self:Message(L["form_lynx_message"], "Positive")
	elseif msg == L["form_dragonhawk_trigger"] then
		self:Message(L["form_dragonhawk_message"], "Positive")
	end
end

function mod:CreepPara(msg)
	if not self.db.profile.paralysis then return end

	local pplayer, ptype = select(3, msg:find(L["paralysis_trigger"]))
	if pplayer and ptype then
		if pplayer == L2["you"] and ptype == L2["are"] then
			pplayer = pName
		end
		self:Message(L["paralysis_message"]:format(pplayer), "Urgent")
		if self.db.profile.icon then
			self:Icon(pplayer)
		end
	end
end
