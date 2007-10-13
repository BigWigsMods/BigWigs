------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Jan'alai"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local fmt = string.format
local UnitName = UnitName

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Jan'alai",

	engage_trigger = "Spirits of da wind be your doom!",

	flame = "Flame Breath",
	flame_desc = "Warn who Jan'alai casts Flame Strike on.",
	flame_trigger = "Jan'alai begins to cast Flame Breath.",
	flame_message = "Flame Breath on %s!",

	bomb = "Fire Bomb",
	bomb_desc = "Show timers for Fire Bomb.",
	bomb_trigger = "I burn ya now!",
	bomb_message = "Incoming Fire Bombs!",

	adds = "Adds",
	adds_desc = "Warn for Incoming Adds.",
	adds_trigger = "Where ma hatcha? Get to work on dem eggs!",
	adds_message = "Incoming Adds!",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Zul'Aman"]
mod.enabletrigger = boss
mod.toggleoptions = {"bomb", "adds", "flame", "icon", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if self.db.profile.flame and msg == L["flame_trigger"] then
		local target
		if UnitName("target") == boss then
			target = UnitName("targettarget")
		elseif UnitName("focus") == boss then
			target = UnitName("focustarget")
		else
			local num = GetNumRaidMembers()
			for i = 1, num do
				if UnitName(fmt("%s%d%s", "raid", i, "target")) == boss then
					target = UnitName(fmt("%s%d%s", "raid", i, "targettarget"))
					break
				end
			end
		end
		if target then
			self:Message(fmt(L["flame_message"], target), "Attention")
			if self.db.profile.icon then
				self:Icon(target)
			end
		end
	end
end


function mod:CHAT_MSG_MONSTER_YELL(msg)
	if self.db.profile.bomb and msg == L["bomb_trigger"] then
		self:Message(L["bomb_message"], "Attention")
		self:Bar(L["bomb"], 12, "Spell_Fire_Fire")
	elseif self.db.profile.adds and msg == L["adds_trigger"] then
		self:Message(L["adds_message"], "Positive")
	end
end
