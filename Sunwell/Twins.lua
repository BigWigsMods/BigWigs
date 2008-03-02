------------------------------
--      Are you local?      --
------------------------------

local lady = BB["Lady Sacrolash"]
local lock = BB["Grand Warlock Alythess"]
local boss = BB["The Eredar Twins"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

local db = nil
local wipe = nil
local started = nil

local pName = UnitName("player")

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "EredarTwins",

	engage_trigger = "",
	wipe_bar = "Respawn",

	nova = "Shadow Nova",
	nova_desc = "Warn for Shadow Nova being cast.",
	nova_message = "Shadow Nova on %s",

	conflag = "Conflagration",
	conflag_desc = "Warn for Conflagration being cast.",
	conflag_message = "Conflag on %s",

	pyro = "Pyrogenics",
	pyro_desc = "Warn who gains and removes Pyrogenics.",
	pyro_gain = "%s gained Pyrogenics",
	pyro_remove = "%s removed Pyrogenics",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = BZ["Sunwell Plateau"]
mod.enabletrigger = {lady, lock}
mod.toggleoptions = {"nova", "conflag", -1, "pyro", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_AURA_APPLIED", "PyroGain", 45230)
	self:AddCombatListener("SPELL_AURA_STOLEN", "PyroRemove")
	self:AddCombatListener("SPELL_AURA_DISPELLED", "PyroRemove")

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("BigWigs_RecvSync")
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")

	--self:AddCombatListener("UNIT_DIED", "GenericBossDeath")

	db = self.db.profile
	if wipe and BigWigs:IsModuleActive(boss) then
		self:Bar(L["wipe_bar"], 90, 44670)
		wipe = nil
	end
	started = nil
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:CHAT_MSG_RAID_BOSS_EMOTE(_, unit, _, _, player)
	if unit == lady and player and db.nova then
		self:Message(L["nova_message"]:format(player), "Urgent", nil, nil, nil, 45329)
	elseif unit == lock and player and db.conflag then
		self:Message(L["conflag_message"]:format(player), "Attention", nil, nil, nil, 45333)
	end
end

function mod:PyroGain(unit, spellID)
	if unit == lock and db.pyro then
		self:Message(L["pyro_gain"]:format(unit), "Positive", nil, nil, nil, spellID)
		self:Bar(L["pyro"], 15, spellID)
	end
end

function mod:PyroRemove(_, _, source, spellID)
	if spellID and spellID == 45230 then
		if db.pyro then
			self:Message(L["pyro_remove"]:format(source), "Positive")
			self:TriggerEvent("BigWigs_StopBar", self, L["pyro"])
		end
	end
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if self:ValidateEngageSync(sync, rest) and not started then
		started = true
		wipe = true
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end
	end
end

