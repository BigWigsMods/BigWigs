------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Illidan Stormrage"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")
local pName = nil

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Illidan",

	parasite = "Parasitic Shadowfiend",
	parasite_desc = "Warn who has Parasitic Shadowfiend.",
	parasite_trigger = "^([^%s]+) ([^%s]+) afflicted by Parasitic Shadowfiend%.$",
	parasite_you = "You have a Parasite!",
	parasite_other = "%s has a Parasite!",

	icon = "Raid Icon",
	icon_desc = "Place a Raid Icon on the player with Parasitic Shadowfiend.",

	barrage = "Dark Barrage",
	barrage_desc = "Warn who has Dark Barrage.",
	barrage_trigger = "^([^%s]+) ([^%s]+) afflicted by Dark Barrage%.$",
	barrage_message = "%s is being Barraged!",

	eyeblast = "Eye Blast",
	eyeblast_desc = "Warn when Eye Blast is cast.",
	eyeblast_trigger = "Stare into the eyes of the Betrayer!",
	eyeblast_message = "Eye Blast!",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Black Temple"]
mod.enabletrigger = boss
mod.toggleoptions = {"parasite", "eyeblast", "barrage", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "IliPara", 2)
	self:TriggerEvent("BigWigs_ThrottleSync", "IliBara", 2)

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "AfflictEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "AfflictEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "AfflictEvent")

	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	pName = UnitName("player")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:BigWigs_RecvSync(sync, rest, nick)
	if sync == "IliPara" and rest and self.db.profile.parasite then 
		local other = L["parasite_other"]:format(rest)
		if rest == UnitName("player") then
			self:Message(L["parasite_you"], "Personal", true, "Long")
			self:Message(other, "Attention", nil, nil, true)
			self:Bar(other, 10, "Spell_Shadow_SoulLeech_3")
		else
			self:Message(other, "Attention")
			self:Bar(other, 10, "Spell_Shadow_SoulLeech_3")
		end
		if self.db.profile.icon then
			self:Icon(rest)
		end
	elseif sync == "IliBara" and rest and self.db.profile.barrage then
		self:Message(L["barrage_message"]:format(rest), "Important", nil, "Alert")
	end
end

function mod:AfflictEvent(msg)
	local pplayer, ptype = select(3, msg:find(L["parasite_trigger"]))
	if pplayer and ptype then
		if pplayer == L2["you"] and ptype == L2["are"] then
			pplayer = pName
		end
		self:Sync("IliPara "..pplayer)
	end

	local bplayer, btype = select(3, msg:find(L["barrage_trigger"]))
	if bplayer and btype then
		if bplayer == L2["you"] and btype == L2["are"] then
			bplayer = pName
		end
		self:Sync("IliBara "..bplayer)
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L["eyeblast_trigger"] then
		self:Message(L["eyeblast_message"], "Important", nil, "Alert")
	end
end
