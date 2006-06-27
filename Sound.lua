
local dewdrop = DewdropLib:GetInstance("1.0")
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
	Long = "Interface\\AddOns\\BigWigs\\Sounds\\Long.mp3",
	Info = "Interface\\AddOns\\BigWigs\\Sounds\\Info.mp3",
	Alert = "Interface\\AddOns\\BigWigs\\Sounds\\Alert.mp3",
	Alarm = "Interface\\AddOns\\BigWigs\\Sounds\\Alarm.mp3",
	Victory = "Interface\\AddOns\\BigWigs\\Sounds\\Victory.mp3",
}


BigWigsSound = AceAddon:new({
	name          = "BigWigsSound",
	cmd           = AceChatCmd:new({}, {}),
	cmdOptions    = cmdopt,

	loc = {
		menutitle = "Sounds",
		menutoggle = "Use sounds",
	},
})


function BigWigsSound:Initialize()
	self:TriggerEvent("BIGWIGS_REGISTER_MODULE", self)
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
	if not text or sound == false then return end

	if sounds[sound] then PlaySoundFile(sounds[sound])
	else PlaySound("RaidWarning") end
end


------------------------------
--      Menu Functions      --
------------------------------

function BigWigsSound:MenuSettings(level, value)
	dewdrop:AddLine("text", self.loc.menutoggle, "func", self.Toggle, "arg1", self, "checked", not self.disabled)
end


--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsSound:RegisterForLoad()

