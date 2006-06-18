
local cmdopt = {
	option = "sound",
	desc   = "Options for sounds.",
	input  = true,
	args   = {
		{
			option = "toggle",
			desc   = "Toggle sounds on or off.",
			method = "Toggle",
		},
	},
}
local sounds = {
	Long = "Interface\\AddOns\\BigWigs\\Long.wav",
	Info = "Interface\\AddOns\\BigWigs\\Info.wav",
	Msg = "Interface\\AddOns\\BigWigs\\Msg.wav",
	Alert = "Interface\\AddOns\\BigWigs\\Alert.wav",
	Alarm = "Interface\\AddOns\\BigWigs\\Alarm.wav",
	Victory = "Interface\\AddOns\\BigWigs\\VictoryShort.mp3",
}


BigWigsSound = AceAddon:new({
	name          = "BigWigsSound",
	cmd           = AceChatCmd:new({}, {}),
	cmdOptions    = cmdopt,
})


function BigWigsSound:Initialize()
	BigWigs:RegisterModule(self)
	self.disabled = self:GetOpt("disabled")
end


function BigWigsSound:Enable()
	self.disabled = nil
	self:RegisterEvent("BIGWIGS_MESSAGE")
end


function BigWigsSound:Disable()
	self.disabled = true
	self:UnregisterAllEvents()
end


function BigWigsSound:Toggle()
	local t = self:TogOpt("disabled")
	if t then self:Disable()
	else self:Enable() end
end


function BigWigsSound:BIGWIGS_MESSAGE(text, color, noraidsay, sound)
	if not text or sound == 0 then return end
	PlaySoundFile(sounds[sound] or sounds.Msg)
end


--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsSound:RegisterForLoad()

