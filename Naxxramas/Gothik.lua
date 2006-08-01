local bboss = BabbleLib:GetInstance("Boss 1.2")
local metro = Metrognome:GetInstance("1")

BigWigsGothik = AceAddon:new({
	name          = "BigWigsGothik",
	cmd           = AceChatCmd:new({}, {}),

	zonename = BabbleLib:GetInstance("Zone 1.2")("Naxxramas"),
	enabletrigger = bboss("Gothik the Harvester"),
	bossname = bboss("Gothik the Harvester"),

	toggleoptions = {
		notStartWarn = "Start warning",
		notTillRoomBar = "Display room bar",
		notRoomSec = "Room x-sec warnings and adds",
		notRoomWarn = "Warn when is in the room",
		notBosskill = "Boss death",
	},
	optionorder = {"notStartWarn", "notTillRoomBar", "notRoomSec", "notRoomWarn", "notBosskill"},

	loc = {
		disabletrigger = "I... am... undone.",		
		bosskill = "Gothik the Harvester has been defeated!",

		starttrigger1 = "Foolishly you have sought your own demise.",
		starttrigger2 = "Teamanare shi rikk mannor rikk lok karkun",
		startwarn = "Gothik the Harvester engaged! 4:30 till go down",
		
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
		
		inroomtrigger = "I have waited long enough. Now you face the harvester of souls.",
		inroomwarn = "He's in the room!",
		
		inroombartext = "Till on Room",
	},
})

function BigWigsGothik:Initialize()
	self.disabled = true
	self:TriggerEvent("BIGWIGS_REGISTER_MODULE", self)
end

function BigWigsGothik:Enable()
	self.disabled = nil
	self.roomStarted = nil
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	
	self:RegisterEvent("BIGWIGS_MESSAGE")

	metro:Register("BigWigs_Gothik_CheckWipe", self.PLAYER_REGEN_ENABLED, 2, self)
end

function BigWigsGothik:Disable()
	self.disabled = true
	self:UnregisterAllEvents()

	self:StopRoom()
	
	metro:Unregister("BigWigs_Gothik_CheckWipe")
	
	self.prior = nil
end

function BigWigsGothik:CHAT_MSG_COMBAT_HOSTILE_DEATH()
	if (arg1 == self.loc.riderdietrigger) then
		if not self:GetOpt("notRiderWarn") then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.riderdiewarn, "Red") end
	elseif (arg1 == self.loc.dkdietrigger) then
		if not self:GetOpt("notDKWarn") then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.dkdiewarn, "Red") end	
	end
end

function BigWigsGothik:Scan()
	if (UnitName("target") == self.bossname and UnitAffectingCombat("target")) then
		return true
	elseif (UnitName("playertarget") == self.bossname and UnitAffectingCombat("playertarget")) then
		return true
	else
		local i
		for i = 1, GetNumRaidMembers(), 1 do
			if (UnitName("raid"..i.."target") == self.bossname and UnitAffectingCombat("raid"..i.."target")) then
				return true
			end
		end
	end
	return false
end

function BigWigsGothik:PLAYER_REGEN_ENABLED()
	local go = self:Scan()
	local _,_,running = metro:Status("BigWigs_Gothik_CheckWipe")
	if (not go) then
		--self:Disable()
		metro:Stop("BigWigs_Gothik_CheckWipe")
	elseif (not running) then
		metro:Start("BigWigs_Gothik_CheckWipe")
	end
end

function BigWigsGothik:CHAT_MSG_MONSTER_YELL()
	if (arg1 == self.loc.starttrigger1 or arg1 == self.loc.starttrigger2) then
		if not self:GetOpt("notStartWarn") then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.startwarn, "Red") end
		if not self:GetOpt("notTillRoomBar") then 
			self:TriggerEvent("BIGWIGS_BAR_START", self.loc.inroombartext, 270, 2, "Green", "Interface\\Icons\\Spell_Magic_LesserInvisibilty")
			self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR", self.loc.inroombartext, 70, "Yellow")
			self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR", self.loc.inroombartext, 140, "Orange")
			self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR", self.loc.inroombartext, 205, "Red")
		end
		if not self:GetOpt("notRoomSec") then 
			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.trawarn, 22, "Red")
			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.trawarn, 42, "Red")
			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.trawarn, 62, "Red")
			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.dkwarn, 72, "Red")
			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.trawarn, 82, "Red")
			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.warn1, 90, "Green")
			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.dkwarn, 97, "Red")
			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.trawarn, 102, "Red")
			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.dktwarn, 122, "Red")
			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.riderwarn, 132, "Red")
			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.trawarn, 142, "Red")
			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.dkwarn, 147, "Red")
			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.rtwarn, 162, "Red")
			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.dkwarn, 172, "Red")
			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.warn2, 180, "Yellow")
			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.trawarn, 182, "Red")
			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.riderwarn, 192, "Red")
			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.dkwarn, 197, "Red")
			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.trawarn, 202, "Red")
			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.warn3, 210, "Orange")
			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.triowarn, 222, "Red")
			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.warn4, 240, "Red")
			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.warn5, 260, "Red")
		end
		--[[
		 	that was pretty hacky. personally i'd start a 5 second metro timer.
			and do something like this:
			oh and sync it too.
			
			--in init
			self.timers = {
				Trainee = 25,
				Deathknight = 75
				Rider = 135
			}
			self.repoptimers = {
				Trainee = 20,
				Deathknight = 25
				Rider = 30
			}
			--TODO: start the 3 candybars here
			--TODO: set up a 225 second metro timer to stop the 5 second timer.
			
			--in 5 second timer
			local message = ""
			for i,v in self.timers do
				self.timers[i] = self.timers[i] - 5
				if self.timers[i] == 5 then
					message = message..i
				end
				if self.timers[i] == 0 then
					-- TODO: redo the appropriate bar
					self.timers[i] = self.repoptimers[i]
				end
			end
			if message then
				-- give a 3 second warning for the next spawn
				self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc[message], 2, "Red")
			end

		]]--
	elseif (arg1 == self.loc.inroomtrigger) then
		if not self:GetOpt("notRoomWarn") then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.inroomwarn, "Red") end
		self:StopRoom()
	elseif (string.find(arg1, self.loc.disabletrigger)) then
		if not self:GetOpt("notBosskill") then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green", nil, "Victory") end
		self:Disable()
	end
end

function BigWigsGothik:StopRoom()
	self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.inroombartext)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.warn1)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.warn2)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.warn3)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.warn4)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.warn5)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.warn6)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.trawarn)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.dkwarn)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.riderwarn)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.dktwarn)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.rtwarn)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.triowarn)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.inroombartext, 70)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.inroombartext, 140)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.inroombartext, 205)
end
--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsGothik:RegisterForLoad()
