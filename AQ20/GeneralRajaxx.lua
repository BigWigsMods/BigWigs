

BigWigsGeneralRajaxx = AceAddon:new({
	name          = "BigWigsGeneralRajaxx",
	cmd           = AceChatCmd:new({}, {}),

	zonename = "AQ20",
	enabletrigger = "General Rajaxx",

	loc = {
		bossname = "General Rajaxx",
		disabletrigger = "General Rajaxx dies.",

--		lieutenant = "Lieutenant General Andorov",
--		general = "General Rajaxx",

		trigger1 = "They come now. Try not to get yourself killed, young blood.",
		trigger2 = "?????",  -- There is no callout for wave 2 ><
		trigger3 = "The time of our retribution is at hand! Let darkness reign in the hearts of our enemies!",
		trigger4 = "No longer will we wait behind barred doors and walls of stone! No longer will our vengeance be denied! The dragons themselves will tremble before our wrath!",
		trigger5 = "Fear is for the enemy! Fear and death!",
		trigger6 = "Staghelm will whimper and beg for his life, just as his whelp of a son did! One thousand years of injustice will end this day!",
		trigger7 = "Fandral! Your time has come! Go and hide in the Emerald Dream and pray we never find you!",
		trigger8 = "Impudent fool! I will kill you myself!",

		warn1 = "Wave 1/8",
		warn2 = "Wave 2/8",
		warn3 = "Wave 3/8",
		warn4 = "Wave 4/8",
		warn5 = "Wave 5/8",
		warn6 = "Wave 6/8",
		warn7 = "Wave 7/8",
		warn8 = "Incoming General Rajaxx",

		bosskill = "General Rajaxx has been defeated!",
	},
})


function BigWigsGeneralRajaxx:Initialize()
	self.disabled = true
	BigWigs:RegisterModule(self)
end


function BigWigsGeneralRajaxx:Enable()
	self.disabled = nil
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")

	self.warnsets = {}
	for i=1,8 do self.warnsets[self.loc["trigger"..i]] = self.loc["warn"..i] end
end


function BigWigsGeneralRajaxx:Disable()
	self.disabled = true
	self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.bar1text)
	self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.bar2text)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.warn1)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.warn2)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.warn3)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.bar2text, 30)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.bar2text, 45)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.bar2text, 75)
	self:UnregisterEvent("CHAT_MSG_MONSTER_YELL")
	self:UnregisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	self.warnsets = nil
end


function BigWigsGeneralRajaxx:CHAT_MSG_COMBAT_HOSTILE_DEATH()
	if arg1 == self.loc.disabletrigger then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green")
		self:Disable()
	end
end


function BigWigsGeneralRajaxx:CHAT_MSG_MONSTER_YELL()
	if arg1 and self.warnsets[arg1] then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.warnsets[arg1], "Orange")
	end
end


--------------------------------
--			Load this bitch!			--
--------------------------------
BigWigsGeneralRajaxx:RegisterForLoad()

