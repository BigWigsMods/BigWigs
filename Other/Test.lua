
BigWigsSyncTest = AceAddon:new({
	name          = "BigWigsSyncTest",
	cmd           = AceChatCmd:new({}, {}),

	loc = {
		bossname = "SyncTest",

		bartext = "Testing Sync",
		texture = "Interface\\Icons\\Spell_Frost_FrostShock",

		warn1 = "Testing Sync",
	}
})


function BigWigsSyncTest:Initialize()
	BigWigs:RegisterModule(self)
end


function BigWigsSyncTest:Enable()
	self:RegisterEvent("BIGWIGS_SYNC_SYNCTEST")
	self:RegisterEvent("BIGWIGS_TEST")
end


function BigWigsSyncTest:Disable()
	self.disabled = true
	self:UnregisterAllEvents()
end


function BigWigsSyncTest:Send()
	self:TriggerEvent("BIGWIGS_SYNC_SEND", "SYNCTEST")
end


function BigWigsSyncTest:BIGWIGS_SYNC_SYNCTEST(msg)
	self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn1, "Green")
	self:TriggerEvent("BIGWIGS_BAR_START", self.loc.bartext, 10, 1, "Green", self.loc.texture)
end


function BigWigsSyncTest:BIGWIGS_TEST()
	self:TriggerEvent("BIGWIGS_BAR_START", "Test Bar", 15, 1, "Green", "Interface\\Icons\\Spell_Nature_ResistNature")
	self:TriggerEvent("BIGWIGS_MESSAGE", "Test", "Green")
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", "OMG Bear!", 5, "Yellow")
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", "*RAWR*", 10, "Orange")
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", "Test Bar", 5, "Yellow")
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", "Test Bar", 7, "Orange")
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", "Test Bar", 10, "Red")

	self:TriggerEvent("BIGWIGS_BAR_START", "Test Bar 2", 6, 2, "Green", "Interface\\Icons\\Spell_Nature_ResistNature")
	self:TriggerEvent("BIGWIGS_BAR_START", "Test Bar 3", 7, 3, "Yellow", "Interface\\Icons\\Spell_Nature_ResistNature")
	self:TriggerEvent("BIGWIGS_BAR_START", "Test Bar 4", 7, 4, "Red", "Interface\\Icons\\Spell_Nature_ResistNature")
end


--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsSyncTest:RegisterForLoad()