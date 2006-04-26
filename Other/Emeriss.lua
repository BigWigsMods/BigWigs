BigWigsEmeriss = AceAddon:new({
	name          = "BigWigsEmeriss",
	cmd           = AceChatCmd:new({}, {}),

	zonename = {"Duskwood", "Hinterlands", "Ashenvale", "Feralas"},
	enabletrigger = "Emeriss",

	loc = {
		bossname = "Emeriss",
		disabletrigger = "Emeriss dies.",

		trigger1 = "^([^%s]+) ([^%s]+) afflicted by Volatile Infection",
		trigger2 = "afflicted by Noxious Breath",

		warn1 = "You are afflicted by Volatile Infection!",
		warn2 = " is afflicted by Volatile Infection!",
		warn3 = "5 seconds until Noxious Breath!",
		warn4 = "Noxious Breath - 30 seconds till next!",
		bosskill = "Emeriss has been defeated!",

		bar1text = "Noxious Breath",
	},
})

function BigWigsEmeriss:Initialize()
	self.disabled = true
	BigWigs:RegisterModule(self)
end

function BigWigsEmeriss:Enable()
	self.disabled = nil
	self:RegisterEvent("BIGWIGS_MESSAGE")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
end

function BigWigsEmeriss:Disable()
	self.disabled = true
	self:UnregisterAllEvents()
	self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.bar1text)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.warn3)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.bar1text, 10)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.bar1text, 20)
	self.prior = nil
end

function BigWigsEmeriss:CHAT_MSG_COMBAT_HOSTILE_DEATH()
	if (arg1 == self.loc.disabletrigger) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green")
		self:Disable()
	end
end

function BigWigsEmeriss:Event()
	if (not self.prior and string.find(arg1, self.loc.trigger2)) then
		self.prior = true
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn4, "Red")
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.warn3, 25, "Red")
		self:TriggerEvent("BIGWIGS_BAR_START", self.loc.bar1text, 30, 1, "Yellow", "Interface\\Icons\\Spell_Shadow_LifeDrain02")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.bar1text, 10, "Orange")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.bar1text, 20, "Red")
	else
		local _,_, EPlayer, EType = string.find(arg1, self.loc.trigger1)
		if (EPlayer and EType) then
			if (EPlayer == "You" and EType == "are") then
				self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn1, "Red", true)
				self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn1, "Red", true)
			else
				self:TriggerEvent("BIGWIGS_MESSAGE", EPlayer .. self.loc.warn2, "Yellow")
			end
		end
	end
end

function BigWigsLucifron:BIGWIGS_MESSAGE(text)
	if text == self.loc.warn3 then self.prior = nil end
end
--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsEmeriss:RegisterForLoad()