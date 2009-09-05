----------------------------------
--      Module Declaration      --
----------------------------------

local boss = "Kologarn"
local mod = BigWigs:NewBoss(boss, "$Revision$")
if not mod then return end
mod.bossName = boss
mod.zoneName = "Ulduar"
mod.enabletrigger = 32930
mod.guid = 32930
mod.toggleOptions = {64290, "shockwave", "eyebeam", "eyebeamsay", "arm", 63355, "bosskill"}
mod.consoleCmd = "Kologarn"

------------------------------
--      Are you local?      --
------------------------------

local started = nil
local db = nil
local grip = mod:NewTargetList()
local pName = UnitName("player")

----------------------------
--      Localization      --
----------------------------

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Kologarn", "enUS", true)
if L then
	L.arm = "Arm dies"
	L.arm_desc = "Warn for Left & Right Arm dies."
	L.left_dies = "Left Arm dies"
	L.right_dies = "Right Arm dies"
	L.left_wipe_bar = "Respawn Left Arm"
	L.right_wipe_bar = "Respawn Right Arm"

	L.shockwave = "Shockwave"
	L.shockwave_desc = "Warn when the next Shockwave is coming."
	L.shockwave_trigger = "Oblivion!"

	L.eyebeam = "Focused Eyebeam"
	L.eyebeam_desc = "Warn who gets Focused Eyebeam."
	L.eyebeam_trigger = "%s focuses his eyes on you!"
	L.eyebeam_message = "Eyebeam: %s"
	L.eyebeam_bar = "~Eyebeam"
	L.eyebeam_you = "Eyebeam on YOU!"
	L.eyebeam_say = "Eyebeam on ME!"

	L.eyebeamsay = "Eyebeam Say"
	L.eyebeamsay_desc = "Say when you are the target of Focused Eyebeam."

	L.armor_message = "%2$dx Crunch on %1$s"
end
L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Kologarn")
mod.locale = L

------------------------------
--      Initialization      --
------------------------------

function mod:OnBossEnable()
	self:AddCombatListener("SPELL_AURA_APPLIED", "Grip", 64290, 64292)
	self:AddCombatListener("SPELL_AURA_APPLIED_DOSE", "Armor", 63355, 64002)
	self:AddCombatListener("UNIT_DIED", "Deaths")

	self:RegisterEvent("CHAT_MSG_RAID_BOSS_WHISPER")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterMessage("BigWigs_RecvSync")
	self:Throttle(2, "EyeBeamWarn")
	db = self.db.profile
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Armor(player, spellId, _, _, spellName)
	local _, _, icon, stack = UnitDebuff(player, spellName)
	if stack and stack > 1 then
		self:TargetMessage(L["armor_message"], player, "Urgent", icon, "Info", stack)
	end
end

local function gripWarn(spellId, spellName)
	mod:TargetMessage(spellName, grip, "Attention", spellId, "Alert")
end

function mod:Grip(player, spellId, _, _, spellName)
	grip[#grip + 1] = player
	self:ScheduleEvent("BWgripeWarn", gripWarn, 0.2, spellId, spellName)
	self:Bar(spellName, 10, spellId)
end

function mod:CHAT_MSG_RAID_BOSS_WHISPER(event, msg)
	if db.eyebeam and msg == L["eyebeam_trigger"] then
		self:LocalMessage(L["eyebeam_you"], "Personal", 63976, "Long")
		if db.eyebeamsay then
			SendChatMessage(L["eyebeam_say"], "SAY")
		end
		self:Sync("EyeBeamWarn", pName)
	end
end

function mod:Deaths(_, guid)
	guid = tonumber((guid):sub(-12,-7),16)
	if guid == 32933 then
		self:IfMessage(L["left_dies"], "Attention")
		self:Bar(L["left_wipe_bar"], 50, 2062) --2062, looks like a Arms :)
	elseif guid == 32934 then
		self:IfMessage(L["right_dies"], "Attention")
		self:Bar(L["right_wipe_bar"], 50, 2062) --2062, looks like a Arms :)
	elseif guid == self.guid then
		self:BossDeath(nil, guid)
	end
end

function mod:CHAT_MSG_MONSTER_YELL(event, msg)
	if msg == L["shockwave_trigger"] and db.shockwave then
		self:IfMessage(L["shockwave"], "Attention", 63982)
		self:Bar(L["shockwave"], 21, 63982)
	end
end

function mod:BigWigs_RecvSync(event, sync, rest, nick)
	if self:ValidateEngageSync(sync, rest) and not started then
		started = true
		self:UnregisterEvent("PLAYER_REGEN_DISABLED")
	elseif sync == "EyeBeamWarn" and rest and db.eyebeam then
		self:TargetMessage(GetSpellInfo(40620), rest, "Positive", 63976, "Info") --40620 = "Eyebeam"
		self:Bar(L["eyebeam_message"]:format(rest), 11, 63976)
		self:Bar(L["eyebeam_bar"], 20, 63976)
		self:PrimaryIcon(rest, "icon")
		self:ScheduleEvent("BWRemoveEyeIcon", "BigWigs_RemoveRaidIcon", 11, 1)
	end
end

