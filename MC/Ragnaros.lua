BigWigsRagnaros = AceAddon:new({
	name          = "BigWigsRagnaros",
	cmd           = AceChatCmd:new({}, {}),

	zonename = "MC",
	enabletrigger = "Ragnaros",

	loc = {
		bossname = "Ragnaros",
		disabletrigger = "Ragnaros dies.",

		trigger1 = "^TASTE",
		trigger2 = "^COME FORTH,",
		trigger3 = "^NOW FOR YOU,",

		warn1 = "AoE Knockback!",
		warn2 = "5 seconds until AoE Knockback!",
		warn3 = "Ragnaros Down for 90 Seconds. Incoming Sons of Flame!",
		warn4 = "15 seconds until Ragnaros emerges!",
		warn5 = "Ragnaros has emerged. 3 minutes until submerge!",
		warn6 = "60 seconds until Ragnaros submerge & Sons of Flame!",
		warn7 = "20 seconds until Ragnaros submerge & Sons of Flame!",
		bosskill = "Ragnaros has been defeated!",

		bar1text = "AoE Knockback",
		bar2text = "Ragnaros emerge",
		bar3text = "Ragnaros submerge",
	},
})

function BigWigsRagnaros:Initialize()
	self.disabled = true
	BigWigs:RegisterModule(self)
end

function BigWigsRagnaros:Enable()
	self.disabled = nil
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_PARTY_HITS", "Event")
	self:RegisterEvent("CHAT_MSG_COMBAT_FRIENDLYPLAYER_HITS", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PET_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PARTY_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_FRIENDLYPLAYER_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
end

function BigWigsRagnaros:Disable()
	self.disabled = true
	self:UnregisterAllEvents()
	self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.bar1text)
	self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.bar2text)
	self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.bar3text)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.warn2)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.warn4)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.warn6)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.warn7)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.bar1text, 10)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.bar1text, 20)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.bar2text, 30)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.bar2text, 60)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.bar3text, 60)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.bar3text, 120)
	Timex:DeleteSchedule("BigWigsRagnarosEmerge")
end

function BigWigsRagnaros:CHAT_MSG_COMBAT_HOSTILE_DEATH()
	if (arg1 == self.loc.disabletrigger) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green")
		self:Disable()
	end
end

function BigWigsRagnaros:CHAT_MSG_MONSTER_YELL()
	if string.find(arg1, self.loc.trigger1) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn1, "Red")
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.warn2, 23, "Red")
		self:TriggerEvent("BIGWIGS_BAR_START", self.loc.bar1text, 28, 1, "Yellow", "Interface\\Icons\\Spell_Fire_SoulBurn")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.bar1text, 10, "Orange")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.bar1text, 20, "Red")
		self:ResetResetTimer()
	elseif string.find(arg1, self.loc.trigger2) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn3, "Red")
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.warn4, 75, "Red")
		self:TriggerEvent("BIGWIGS_BAR_START", self.loc.bar2text, 90, 2, "Yellow", "Interface\\Icons\\Spell_Fire_Volcano")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.bar2text, 30, "Orange")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.bar2text, 60, "Red")
		Timex:AddSchedule("BigWigsRagnarosEmerge", 90, false, 1, self.Emerge, self)
		self:ResetResetTimer()
	elseif string.find(arg1, self.loc.trigger3) then
		self:Emerge()
	end
end

function BigWigsRagnaros:Emerge()
	self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn5, "Yellow")
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.warn6, 120, "Red")
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.warn7, 160, "Red")
	self:TriggerEvent("BIGWIGS_BAR_START", self.loc.bar3text, 180, 3, "Yellow", "Interface\\Icons\\Spell_Fire_SelfDestruct")
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.bar3text, 60, "Orange")
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.bar3text, 120, "Red")
	self:ResetResetTimer()
end

function BigWigsRagnaros:Event()
	if (string.find(arg1, self.loc.bossname)) then
		if (not Timex:ScheduleCheck("BigWigsRagnarosReset")) then
			self:Emerge()
			Timex:AddSchedule("BigWigsRagnarosReset", 90, false, 1, function() Timex:DeleteNamedSchedule("BigWigsRagnarosEmerge") end)
		else
			self:ResetResetTimer()
		end
	end
end

function BigWigsRagnaros:ResetResetTimer()
	Timex:DeleteSchedule("BigWigsRagnarosReset")
	Timex:AddSchedule("BigWigsRagnarosReset", 95, false, 1, self.Reset, self)
end
--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsRagnaros:RegisterForLoad()