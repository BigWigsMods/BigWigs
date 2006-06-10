
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
	PlaySoundFile("Interface\\AddOns\\BigWigs\\msg.wav")
end


--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsSound:RegisterForLoad()

