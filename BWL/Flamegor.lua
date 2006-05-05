BigWigsFlamegor = AceAddon:new({
	name          = "BigWigsFlamegor",
	cmd           = AceChatCmd:new({}, {}),

	zonename = "BWL",
	enabletrigger = GetLocale() == "deDE" and "Flammenmaul" or "Flamegore",

	loc = GetLocale() == "deDE" and {
		bossname = "Flammenmaul",
		disabletrigger = "Flammenmaul stirbt.",

		trigger1 = "Flammenmaul beginnt Fl\195\188gelsto\195\159 zu wirken.",
		trigger2 = "Flammenmaul beginnt Schattenflamme zu wirken.",
		trigger3 = "ger\195\164t in Raserei!",

		warn1 = "Flammenmaul beginnt Fl\195\188gelsto\195\159 zu wirken!",
		warn2 = "30 Sekunden bis zum n\195\64chsten Fl\195\188gelsto\195\159!",
		warn3 = "3 Sekunden bis Flammenmaul Fl\195\188gelsto\195\159 wirkt!",
		warn4 = "Schattenflamme kommt!",
		warn5 = "Raserei - Einlullender Schuss!",
		bosskill = "Flammenmaul wurde besiegt!",

		bar1text = "Fluegelgelstoss",
	}	or {
		bossname = "Flamegor",
		disabletrigger = "Flamegor dies.",

		trigger1 = "Flamegor begins to cast Wing Buffet",
		trigger2 = "Flamegor begins to cast Shadow Flame.",
		trigger3 = "goes into a frenzy!",

		warn1 = "Flamegor begins to cast Wing Buffet!",
		warn2 = "30 seconds till next Wing Buffet!",
		warn3 = "3 seconds before Flamegor casts Wing Buffet!",
		warn4 = "Shadow Flame incoming!",
		warn5 = "Frenzy - Tranq Shot!",
		bosskill = "Flamegor has been defeated!",

		bar1text = "Wing Buffet",
	},
})

function BigWigsFlamegor:Initialize()
	self.disabled = true
	BigWigs:RegisterModule(self)
end

function BigWigsFlamegor:Enable()
	self.disabled = nil
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	self:RegisterEvent("BIGWIGS_MESSAGE")
end

function BigWigsFlamegor:Disable()
	self.disabled = true
	self:UnregisterAllEvents()
	self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.bar1text)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.warn3)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.bar1text, 10)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.bar1text, 20)
end

function BigWigsFlamegor:CHAT_MSG_COMBAT_HOSTILE_DEATH()
	if (arg1 == self.loc.disabletrigger) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green")
		self:Disable()
	end
end

function BigWigsFlamegor:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE()
	if (string.find(arg1, self.loc.trigger1)) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn1, "Red")
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn2, "Yellow")
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.warn3, 27, "Red")
		self:TriggerEvent("BIGWIGS_BAR_START", self.loc.bar1text, 30, 1, "Yellow", "Interface\\Icons\\Spell_Fire_SelfDestruct")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.bar1text, 10, "Orange")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.bar1text, 20, "Red")
	elseif (arg1 == self.loc.trigger2) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn4, "Red")
	end
end

function BigWigsFlamegor:CHAT_MSG_MONSTER_EMOTE()
	if (arg1 == self.loc.trigger3) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn5, "Red")
	end
end
--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsFlamegor:RegisterForLoad()