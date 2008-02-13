------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Brutallus"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")

local started = nil
local pName = nil
local db = nil
local prevBurnTarget = nil
local burning = { }

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Brutallus",

	burn = "Burn",
	burn_desc = "Tells you who has been hit by Burn and when the next Burn is coming.",
	burn_you = "Burn on YOU!",
	burn_other = "Burn on %s!",
	burn_bar = "Next Burn",
	burn_message = "Next Burn in 5 seconds!",

	icon = "Raid Icon",
	icon_desc = "Place a Raid Icon on players hit by Burn.",

	burnjump = "Burn Jump",
	burnjump_desc = "Warns when people not hit by Burn are afflicted by the DoT.",
	burnjump_you = "Burn jumped to YOU!",
	burnjump_other = "Burn jumped to %s!",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Sunwell Plateau"]
mod.enabletrigger = boss
mod.toggleoptions = {"burn", "icon", "burnjump", "enrage", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	started = nil
	prevBurnTarget = nil

	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED", "ProcessCombatLog")

	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "BrutallusBurn", 3)
	self:TriggerEvent("BigWigs_ThrottleSync", "BrutallusBurnJump", 0)

	pName = UnitName("player")
	db = self.db.profile
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:ProcessCombatLog()
	if arg2 == "SPELL_DAMAGE" then
		local _, _, _, _, _, _, player, _, spellID, spellName = arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10
		if spellID == 45141 then		-- Burn
			prevBurnTarget = player
			self:Sync("BrutallusBurn", player)
		end
	elseif arg2 == "SPELL_AURA_APPLIED" then
		local _, _, _, _, _, _, player, _, spellID, spellName = arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10
		if spellID == 46394 then		-- Burn
			self:Sync("BrutallusBurnJump", player)
		end
	end
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if sync == "BrutallusBurn" and rest and db.burn then
		local other = L["burn_other"]:format(rest)
		if rest == pName then
			self:Message(L["burn_you"], "Personal", true, "Long")
			self:Message(other, "Attention", nil, nil, true)
		else
			self:Message(other, "Attention")
		end
		self:Bar(L["burn_bar"], 20, "Spell_Fire_Burnout")
		self:DelayedMessage(15, L["bar_message"], "Attention")
		if db.icon then
			self:Icon(rest)
		end
	elseif sync == "BrutallusBurnJump" and rest and db.burnjump then
		if rest ~= prevBurnTarget then
			burning[rest] = true
		end
		self:ScheduleEvent("BurnJumpCheck", self.BurnJumpWarn, 1, self)
	elseif self:ValidateEngageSync(sync, rest) and not started then
		started = true
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end
		if db.burn then
			self:Bar(L["burn_bar"], 20, "Spell_Fire_Burnout")
			self:DelayedMessage(15, L["bar_message"], "Attention")
		end
		if db.enrage then
			self:Message(string.format(L2["enrage_start"], boss, 6), "Attention")
			self:DelayedMessage(180, string.format(L2["enrage_min"], 3), "Positive")
			self:DelayedMessage(240, string.format(L2["enrage_min"], 2), "Positive")
			self:DelayedMessage(300, string.format(L2["enrage_min"], 1), "Positive")
			self:DelayedMessage(330, string.format(L2["enrage_sec"], 30), "Positive")
			self:DelayedMessage(350, string.format(L2["enrage_sec"], 10), "Urgent")
			self:DelayedMessage(355, string.format(L2["enrage_sec"], 5), "Urgent")
			self:DelayedMessage(360, string.format(L2["enrage_end"], boss), "Attention", nil, "Alarm")
			self:Bar(L2["enrage"], 360, "Spell_Shadow_UnholyFrenzy")
		end
	end
end

function mod:BurnJumpWarn()
	if db.burnjump then
		local msg = nil
		for k in pairs(burning) do
			if not msg then
				msg = k
			else
				msg = msg .. ", " .. k
			end
			if k == pName then
				self:Message(L["burnjump_you"], "Personal", true, "Long")
			end
		end
		if msg ~= nil then
			self:Message(string.format(L["burnjump_other"], msg), "Important", nil, "Alert")
		end
	end
	for k in pairs(burning) do burning[k] = nil end
	prevBurnTarget = nil
end