local cmdopt = {
	option = "test",
	desc   = "Some useful test events.",
	input  = true,
	args   = {
		{
			option = "local",
			desc   = "Fire off some test events locally.",
			method = "BIGWIGS_TEST",
		},
		{
			option = "sync",
			desc   = "Fire off a test sync message to the raid.",
			method = "Send",
		},
	},
}

BigWigsTest = AceAddon:new({
	name          = "BigWigsTest",
	cmd           = AceChatCmd:new({}, {}),
	cmdOptions    = cmdopt,

	loc = {},
})

function BigWigsTest:Initialize()
	self:TriggerEvent("BIGWIGS_REGISTER_MODULE", self)
end

function BigWigsTest:Enable()
	self:RegisterEvent("BIGWIGS_SYNC_SYNCTEST")
	self:RegisterEvent("BIGWIGS_TEST")
	self:TriggerEvent("BIGWIGS_SYNC_THROTTLE", "SYNCTEST", 4)
end

function BigWigsTest:Disable()
	self:UnregisterAllEvents()
end

function BigWigsTest:Send()
	self:TriggerEvent("BIGWIGS_SYNC_SEND", "SYNCTEST")
end

function BigWigsTest:BIGWIGS_SYNC_SYNCTEST(msg)
	self:TriggerEvent("BIGWIGS_MESSAGE", "Testing Sync", "Green")
	self:TriggerEvent("BIGWIGS_BAR_START", "Testing Sync", 10, 1, "Green", "Interface\\Icons\\Spell_Frost_FrostShock")
end

function BigWigsTest:BIGWIGS_TEST()
	self:TriggerEvent("BIGWIGS_BAR_START", "Test Bar", 15, 1, "Green", "Interface\\Icons\\Spell_Nature_ResistNature")
	self:TriggerEvent("BIGWIGS_MESSAGE", "Test", "Green", nil, "Long")
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", "OMG Bear!", 5, "Yellow", nil, "Alert")
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", "*RAWR*", 10, "Orange", nil, "Alarm")
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", "Victory!", 15, "Green", nil, "Victory")
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", "Test Bar", 5, "Yellow")
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", "Test Bar", 7, "Orange")
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", "Test Bar", 10, "Red")

	self:TriggerEvent("BIGWIGS_BAR_START", "Test Bar 2", 10, 2, "Green", "Interface\\Icons\\Spell_Nature_ResistNature")
	self:TriggerEvent("BIGWIGS_BAR_START", "Test Bar 3", 5, 3, "Yellow", "Interface\\Icons\\Spell_Nature_ResistNature")
	self:TriggerEvent("BIGWIGS_BAR_START", "Test Bar 4", 3, 4, "Red", "Interface\\Icons\\Spell_Nature_ResistNature")
end
--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsTest:RegisterForLoad()