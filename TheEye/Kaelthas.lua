------------------------------
--      Are you local?      --
------------------------------

local BB = AceLibrary("Babble-Boss-2.2")

local boss = BB["Kael'thas Sunstrider"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")

local capernian = BB["Grand Astromancer Capernian"]
local sanguinar = BB["Lord Sanguinar"]
local telonicus = BB["Master Engineer Telonicus"]
local thaladred = BB["Thaladred the Darkener"]

BB = nil

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Kael'thas",

	phase = "Phase warnings",
	phase_desc = "Warn about the various phases of the encounter.",

	conflag = "Conflagration",
	conflag_desc = "Warn about Conflagration on a player.",

	temperament = "Chaotic Temperament",
	temperament_desc = "Warn about Chaotic Temperament on a player.",

	gaze = "Gaze",
	gaze_desc = "Warn when Thaladred focuses on a player.",

	icon = "Raid Icon",
	icon_desc = "Place a Raid Icon over the player that Thaladred sets eyes on.",

	fear = "Fear",
	fear_desc = "Warn when about Bellowing Roar.",

	thaladred_inc_trigger = "Impressive. Let us see how your nerves hold up against the Darkener, Thaladred!",
	sanguinar_inc_trigger = "You have persevered against some of my best advisors... but none can withstand the might of the Blood Hammer. Behold, Lord Sanguinar!",
	capernian_inc_trigger = "Capernian will see to it that your stay here is a short one.",
	telonicus_inc_trigger = "Well done, you have proven worthy to test your skills against my master engineer, Telonicus.",
	weapons_inc_trigger = "As you see, I have many weapons in my arsenal....",
	phase2_trigger = "Perhaps I underestimated you. It would be unfair to make you fight all four advisors at once, but... fair treatment was never shown to my people. I'm just returning the favor.",
	phase3_trigger = "Alas, sometimes one must take matters into one's own hands. Balamore shanal!",

	weapons_inc_message = "Weapons incoming!",
	phase2_message = "Phase 2 - Advisors and Weapons!",
	phase3_message = "Phase 3 - Kael inc!",

	afflicted_trigger = "^(%S+) (%S+) afflicted by (.*).$",

	temperament_spell = "Chaotic Temperament",
	temperament_message = "Temperament on %s!",

	conflag_spell = "Conflagration",
	conflag_message = "Conflag on %s!",

	gaze_trigger = "sets eyes on ([^%s]+)!$",
	gaze_message = "Gaze on %s!",

	fear_soon_message = "Fear soon!",
	fear_message = "Fear!",
	fear_bar = "Fear Cooldown",

	fear_soon_trigger = "Lord Sanguinar begins to cast Bellowing Roar.",
	fear_trigger1 = "^Lord Sanguinar's Bellowing Roar was resisted by %S+.$",
	fear_trigger2 = "^Lord Sanguinar's Bellowing Roar fails. %S+ is immune.$",
	fear_spell = "Bellowing Roar",

	-- Weapons
	["Devastation"] = true, -- Axe
	["Cosmic Infuser"] = true, -- Staff
	["Infinity Blade"] = true, -- Dagger
	["Staff of Disintegration"] = true, -- Healer/druid staff
	["Warp Slicer"] = true, -- Sword
	["Netherstrand Longbow"] = true, -- Bow
	["Phaseshift Bulwark"] = true, -- Shield
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Tempest Keep"]
mod.otherMenu = "The Eye"
mod.enabletrigger = { boss, capernian, sanguinar, telonicus, thaladred }
mod.wipemobs = {
	L["Devastation"], L["Cosmic Infuser"], L["Infinity Blade"], L["Staff of Disintegration"],
	L["Warp Slicer"], L["Netherstrand Longbow"], L["Phaseshift Bulwark"]
}

mod.toggleoptions = { "phase", -1, "temperament", "conflag", "gaze", "icon", "fear", "bosskill" }
mod.revision = 4

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Afflicted")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Afflicted")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Afflicted")

	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")

	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "KaelTemper", 6)
	self:TriggerEvent("BigWigs_ThrottleSync", "KaelConflag", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "KaelFearSoon", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "KaelFear", 5)
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if type(self[sync]) == "function" then
		self[sync](self, rest, nick)
	end
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if msg == L["fear_soon_trigger"] then
		self:Sync("KaelFearSoon")
	elseif msg:find(L["fear_trigger2"]) or msg:find(L["fear_trigger1"]) then
		self:Sync("KaelFear")
	end
end

function mod:CHAT_MSG_MONSTER_EMOTE(msg)
	local player = select(3, msg:find(L["gaze_trigger"]))
	if player then
		if self.db.profile.gaze then
			self:Message(L["gaze_message"]:format(player), "Important")
		end
		if self.db.profile.icon then
			self:Icon(player)
		end
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if not self.db.profile.phase then return end

	if msg == L["thaladred_inc_trigger"] then
		self:Message(thaladred, "Positive")
	elseif msg == L["sanguinar_inc_trigger"] then
		self:Message(sanguinar, "Positive")
	elseif msg == L["capernian_inc_trigger"] then
		self:Message(capernian, "Positive")
	elseif msg == L["telonicus_inc_trigger"] then
		self:Message(telonicus, "Positive")
	elseif msg == L["weapons_inc_trigger"] then
		self:Message(L["weapons_inc_message"], "Positive")
	elseif msg == L["phase2_trigger"] then
		self:Message(L["phase2_message"], "Positive")
	elseif msg == L["phase3_trigger"] then
		self:Message(L["phase3_message"], "Positive")
	end
end

function mod:Afflicted(msg)
	local tPlayer, tType, tSpell = select(3, msg:find(L["afflicted_trigger"]))
	if tPlayer and tType then
		if tPlayer == L2["you"] and tType == L2["are"] then
			tPlayer = UnitName("player")
		end
		if tSpell == L["conflag_spell"] then
			self:Sync("KaelConflag " .. tPlayer)
		elseif tSpell == L["temperament_spell"] then
			self:Sync("KaelTemper " .. tPlayer)
		elseif tSpell == L["fear_spell"] then
			self:Sync("KaelFear")
		end
	end
end

function mod:KaelTemper(rest, nick)
	if not rest or not self.db.profile.temperament then return end

	local msg = L["temperament_message"]:format(rest)
	self:Message(msg, "Attention")
	self:Bar(msg, 8, "Spell_Arcane_ArcanePotency")
end

function mod:KaelConflag(rest, nick)
	if not rest or not self.db.profile.conflag then return end

	local msg = L["conflag_message"]:format(rest)
	self:Message(msg, "Attention")
	self:Bar(msg, 10, "Spell_Fire_Incinerate")
end

function mod:KaelFearSoon(rest, nick)
	if not self.db.profile.fear then return end

	self:Message(L["fear_soon_message"], "Urgent")
end

function mod:KaelFear(rest, nick)
	if not self.db.profile.fear then return end

	self:Message(L["fear_message"], "Attention")
	self:Bar(L["fear_bar"], 30, "Spell_Shadow_Charm")
end

