------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.0")("Razorgore the Untamed")
local controller = AceLibrary("Babble-Boss-2.0")("Grethok the Controller")
local L = AceLibrary("AceLocale-2.0"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Razorgore",

	start_trigger = "Intruders have breached",
	start_message = "Razorgore engaged, 30 eggs to go!",

	mindcontrol_trigger = "Foolish ([^%s]+).",
	mindcontrol_message = "%s has been mind controlled!",

	egg_trigger = "Razorgore the Untamed casts Destroy (.*)%.",
	egg_message = "%d/30 eggs destroyed!",

	phase2_message = "All eggs destroyed, Razorgore lose!",

	mc_cmd = "mindcontrol",
	mc_name = "Mind Control",
	mc_desc = "Warn when players are mind controlled",

	eggs_cmd = "eggs",
	eggs_name = "Egg countdown",
	eggs_desc = "Count down the remaining eggs",

	phase_cmd = "phase",
	phase_name = "Phases",
	phase_desc = "Alert on phase 1 and 2",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsRazorgore = BigWigs:NewModule(boss)
BigWigsRazorgore.zonename = AceLibrary("Babble-Zone-2.0")("Blackwing Lair")
BigWigsRazorgore.enabletrigger = { boss, controller }
BigWigsRazorgore.toggleoptions = { "mc", "eggs", "phase", "bosskill"}
BigWigsRazorgore.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsRazorgore:OnEnable()
	self.eggs = 0

	self:RegisterEvent("CHAT_MSG_MONSTER_YELL");
	self:RegisterEvent("CHAT_MSG_SPELL_FRIENDLYPLAYER_BUFF");

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "RazorgoreEgg", 8)
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsRazorgore:CHAT_MSG_MONSTER_YELL(msg)
	if string.find(msg, L"start") then
		if self.db.profile.phase then self:TriggerEvent("BigWigs_Message", L"start_message", "Orange") end
		self.eggs = 0
	elseif self.db.profile.mc then
		local _, _, player = string.find(msg, L"mindcontrol_trigger");
		if player then
			self:TriggerEvent("BigWigs_Message", string.format(L"mindcontrol_message", player), "Red")
		end
	end
end

function BigWigsRazorgore:CHAT_MSG_SPELL_FRIENDLYPLAYER_BUFF(msg)
	local _, _, egg = string.find(msg, L"egg_trigger");
	if egg then
		self:TriggerEvent("BigWigs_SendSync", "RazorgoreEgg "..tostring(self.eggs + 1))
	end
end

function BigWigsRazorgore:BigWigs_RecvSync(sync, rest)
	if sync ~= "RazorgoreEgg" or not rest then return end
	rest = tonumber(rest)

	if rest == (self.eggs + 1) then
		self.eggs = self.eggs + 1
		if self.db.profile.eggs then
			self:TriggerEvent("BigWigs_Message", string.format(L"egg_message", self.eggs), "Orange")
		end

		if self.eggs == 30 and self.db.profile.phase then
			self:TriggerEvent("BigWigs_Message", L"phase2_message", "Red")
		end
	end
end

