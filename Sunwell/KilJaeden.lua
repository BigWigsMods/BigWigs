------------------------------
--      Are you local?      --
------------------------------

local boss = BB["Kil'jaeden"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

local db = nil
local started = nil
local deaths = 0

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "KilJaeden",

	bomb = "Darkness of a Thousand Souls",
	bomb_desc = "Warn when Darkness of a Thousand Souls is being cast.",
	bomb_cast = "Incoming Big Bomb!",
	bomb_bar = "Explosion!",

	shield_up = "Shield is UP!",

	deceiver_dies = "Deciever #%d Killed",
	["Hand of the Deceiver"] = true,
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = BZ["Sunwell Plateau"]
mod.enabletrigger = {L["Hand of the Deceiver"], boss}
mod.toggleoptions = {"bomb", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Shield", 45848)
	self:AddCombatListener("UNIT_DIED", "Deaths")

	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("BigWigs_RecvSync")

	db = self.db.profile
	started = nil
	deaths = 0
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Shield()
	self:IfMessage(L["shield_up"], "Urgent", 45848)
end

function mod:Deaths(unit)
	if unit == L["Hand of the Deceiver"] then
		deaths = deaths + 1
		self:IfMessage(L["deceiver_dies"]:format(deaths), "Positive")
		if deaths == 3 then
			self:Bar(boss, 10, "Spell_Shadow_Charm")
		end
	elseif unit == boss then
		self:GenericBossDeath(unit)
	end
end

function mod:CHAT_MSG_MONSTER_EMOTE(_, unit)
	if unit == boss and db.bomb then
		self:Bar(L["bomb_bar"], 8, "Spell_Shadow_BlackPlague")
		self:IfMessage(L["bomb_cast"], "Important")
	end
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if self:ValidateEngageSync(sync, rest) and not started then
		started = true
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end
	end
end
