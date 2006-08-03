------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.0")("Gothik the Harvester")
local L = AceLibrary("AceLocale-2.0"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {

	cmd = "gothik",

	room_cmd = "room",
	room_name = "Room Arrival Alerts",
	room_desc = "Warn for Gothik's arrival",

	add_cmd = "add",
	add_name = "Add Warnings",
	add_desc = "Warn for adds",

	disabletrigger = "I... am... undone.",		

	starttrigger1 = "Foolishly you have sought your own demise.",
	starttrigger2 = "Teamanare shi rikk mannor rikk lok karkun",
	startwarn = "Gothik the Harvester engaged! 4:30 till he's in the room.",
	
	riderdietrigger = "Unrelenting Rider dies.",
	dkdietrigger = "Unrelenting Deathknight dies.",
	
	riderdiewarn = "Rider dead!",
	dkdiewarn = "Death Knight dead!",
	
	warn1 = "In room in 3 minutes",
	warn2 = "In room in 90 seconds",
	warn3 = "In room in 60 seconds",
	warn4 = "In room in 30 seconds",
	warn5 = "Gothik Incoming in 10 seconds",
	
	trawarn = "Trainees in 3 seconds",
	dkwarn = "Deathknight in 3 seconds",
	riderwarn = "Rider in 3 seconds",
	dktwarn = "Trainees and DK in 3 seconds",
	rtwarn = "Trainees and Rider in 3 seconds",
	triowarn = "Trainees in 3 seconds",

	trabar = "Trainees",
	dkbar = "Deathknight",
	riderbar = "Rider",
	
	inroomtrigger = "I have waited long enough. Now you face the harvester of souls.",
	inroomwarn = "He's in the room!",
	
	inroombartext = "Till on Room",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsGothik = BigWigs:NewModule(boss)
BigWigsGothik.zonename = AceLibrary("Babble-Zone-2.0")("Naxxramas")
BigWigsGothik.enabletrigger = boss
BigWigsGothik.toggleoptions = { "room", "add", "bosskill"}
BigWigsGothik.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsGothik:OnEnable()
	self.tratime = 25
	self.dktime = 75
	self.ridertime = 135
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
end

function BigWigsGothik:PLAYER_REGEN_ENABLED()
	local go = self:Scan()
	local running = self:IsEventScheduled("Gothik_CheckWipe")
	if (not go) then
		self:TriggerEvent("BigWigs_RebootModule", self)
	elseif (not running) then
		self:ScheduleRepeatingEvent("Gothik_CheckWipe", self.PLAYER_REGEN_ENABLED, 2, self)
	end
end

function BigWigsGothik:Scan()
	if (UnitName("target") == boss and UnitAffectingCombat("target")) then
		return true
	elseif (UnitName("playertarget") == boss and UnitAffectingCombat("playertarget")) then
		return true
	else
		local i
		for i = 1, GetNumRaidMembers(), 1 do
			if (UnitName("raid"..i.."target") == boss and UnitAffectingCombat("raid"..i.."target")) then
				return true
			end
		end
	end
	return false
end

function BigWigsGothik:CHAT_MSG_COMBAT_HOSTILE_DEATH( msg )
	if msg == L"riderdietrigger" and self.db.profile.add then
		self:TriggerEvent("BigWigs_Message", L"riderdiewarn", "Red")
	elseif msg == L"dkdietrigger" and self.db.profile.add  then
		self:TriggerEvent("BigWigs_Message", L"dkdiewarn", "Red")
	end
end


function BigWigsGothik:StopRoom()
	self:TriggerEvent("BigWigs_StopBar", self, L"inroombartext")
	self:CancelScheduledEvent("bwgothikwarn1")
	self:CancelScheduledEvent("bwgothikwarn2")
	self:CancelScheduledEvent("bwgothikwarn3")
	self:CancelScheduledEvent("bwgothikwarn4")
	self:CancelScheduledEvent("bwgothikwarn5")
	self:TriggerEvent("BigWigs_StopBar", self, L"trabar")
	self:TriggerEvent("BigWigs_StopBar", self, L"dkbar")
	self:TriggerEvent("BigWigs_stopBar", self, L"riderbar")
	self:CancelScheduledEvent("bwgothiktrawarn")
	self:CancelScheduledEvent("bwgothikdkwarn")
	self:CancelScheduledEvent("bwgothikriderwarn")
	self:CancelScheduledEvent("bwgothiktrarepop")
	self:CancelScheduledEvent("bwgothiktrarepop2")
	self:CancelScheduledEvent("bwgothikdkrepop")
	self:CancelScheduledEvent("bwgothikdkrepop2")
	self:CancelScheduledEvent("bwgothikriderrepop")
	self:CancelScheduledEvent("bwgothikriderrepop2")

end

function BigWigsGothik:Trainee( first )
	self:TriggerEvent("BigWigs_StartBar", self, L"trabar", self.tratime, 2, nil, "Yellow", "Orange", "Red")	
	self:ScheduleEvent("bwgothiktrawarn", "BigWigs_Message", self.tratime - 3, L"trawarn", "Yellow")
	if first then self:ScheduleRepeatingEvent("bwgothikdkrepop2", self.Rider, self.ridertime, self) end
	
end

function BigWigsGothik:DeathKnight( first )
	self:TriggerEvent("BigWigs_StartBar", self, L"dkbar", self.dktime, 3, nil, "Yellow", "Orange", "Red")
	self:ScheduleEvent("bwgothikdkwarn", "BigWigs_Message", self.dktime - 3, L"dkwarn", "Orange")
	if first then self:ScheduleRepeatingEvent("bwgothikdkrepop2", self.Rider, self.ridertime, self) end
end

function BigWigsGothik:Rider( first )
	self:TriggerEvent("BigWigs_StartBar", self, L"riderbar", self.ridertime, 4, nil, "Yellow", "Orange", "Red")
	self:ScheduleEvent("bwgothikriderwarn", "BigWigs_Message", self.ridertime -3, L"riderwarn", "Red")
	if first then self:ScheduleRepeatingEvent("bwgothikriderrepop2", self.Rider, self.ridertime, self) end
end

function BigWigsGothik:CHAT_MSG_MONSTER_YELL( msg )
	if msg == L"starttrigger1" or msg == L"starttrigger" then
		if self.db.profile.room then
			self:TriggerEvent("BigWigs_Message", L"startwarn", "Red")
			self:TriggerEvent("BigWigs_StartBar", self, L"inroombartext", 270, 1, "Interface\\Icons\\Spell_Magic_LesserInvisibilty", "Green", "Yellow", "Orange", "Red")
			self:ScheduleEvent("bwgothikwarn1", "BigWigs_Message", 90, L"warn1", "Green")
			self:ScheduleEvent("bwgothikwarn2", "BigWigs_Message", 180, L"warn2", "Yellow")
			self:ScheduleEvent("bwgothikwarn3", "BigWigs_Message", 210, L"warn3", "Orange")
			self:ScheduleEvent("bwgothikwarn4", "BigWigs_Message", 240, L"warn4", "Red")
			self:ScheduleEvent("bwgothikwarn5", "BigWigs_Message", 260, L"warn5", "Red")
		end
		if self.db.profile.add then
			-- add bars
			self:TriggerEvent("BigWigs_StartBar", self, L"trabar", self.tratime, 2, nil, "Yellow", "Orange", "Red")
			self:TriggerEvent("BigWigs_StartBar", self, L"dkbar", self.dktime, 3, nil, "Green", "Yellow", "Orange", "Red")
			self:TriggerEvent("BigWigs_StartBar", self, L"riderbar", self.ridertime, 4, nil, "Green", "Yellow", "Orange", "Red")
			-- 3 second warnings
			self:ScheduleEvent("bwgothiktrawarn", "BigWigs_Message", self.tratime - 3, L"trawarn", "Yellow")
			self:ScheduleEvent("bwgothikdkwarn", "BigWigs_Message", self.dktime - 3, L"dkwarn", "Orange")
			self:ScheduleEvent("bwgothikriderwarn", "BigWigs_Message", self.ridertime -3, L"riderwarn", "Red")
			-- repop schedules
			self:ScheduleEvent("bwgothiktrarepop", self.Trainee, self.tratime, self, true )
			self:ScheduleEvent("bwgothiktdkrepop", self.DeathKnight, self.dktime, self, true )
			self:ScheduleEvent("bwgothikriderrepop", self.Rider, self.ridertime, self, true )
			-- set the new times
			self.tratime = 20
			self.dktime = 25
			self.ridertime = 30
		end
	elseif msg == L"inroomtrigger" then
		if self.db.profile.room then self:TriggerEvent("BigWigs_Message", L"inroomwarn", "Red") end
		self:StopRoom()
	elseif string.find(msg, L"disabletrigger") then
		if self.db.profile.bosskill then self:TriggerEvent("BigWigs_Message", string.format(AceLibrary("AceLocale-2.0"):new("BigWigs")("%s has been defeated"), boss), "Green", nil, "Victory") end
		self.core:ToggleModuleActive(self, false)
	end
end
