BigWigsNefarian = AceAddon:new({
	name          = "BigWigsNefarian",
	cmd           = AceChatCmd:new({}, {}),

	zonename = "BWL",
	enabletrigger = {"Lord Victor Nefarius", "Nefarian"},

	loc = {
		bossname = "Nefarian",
		disabletrigger = "Nefarian dies.",

		trigger1 = "Well done, my minions",
		trigger2 = "BURN! You wretches",
		trigger3 = "Impossible! Rise my",
		trigger4 = "Nefarian begins to cast Bellowing Roar",
		trigger5 = "Nefarian begins to cast Shadow Flame",
		triggershamans	= "Shamans, show me",
		triggerdruid	= "Druids and your silly",
		triggerwarlock	= "Warlocks, you shouldn't be playing",
		triggerpriest	= "Priests! If you're going to keep",
		triggerhunter	= "Hunters and your annoying",
		triggerwarrior	= "Warriors, I know you can hit harder",
		triggerrogue	= "Rogues%? Stop hiding",
		triggerpaladin	= "Paladins",
		triggermage		= "Mages too%?",

		warn1 = "Nefarian landing in 10 seconds!",
		warn2 = "Nefarian is landing!",
		warn3 = "Zerg incoming!",
		warn4 = "Fear in 2 seconds!",
		warn5 = "Shadow Flame incoming!",
		warn6 = "Class call incoming!",
		warnshaman	= "Shamans - Totems spawned!",
		warndruid	= "Druids - Stuck in cat form!",
		warnwarlock	= "Warlocks - Incoming Infernals!",
		warnpriest	= "Priests - Stop Healing!",
		warnhunter	= "Hunters - Bows/Guns broken!",
		warnwarrior	= "Warriors - Stuck in berserking stance!",
		warnrogue	= "Rogues - Ported and rooted!",
		warnpaladin	= "Paladins - Blessing of Protection!",
		warnmage	= "Mages - Incoming polymorphs!",
		bosskill = "Nefarian has been defeated!",

		bar1text = "Class call",
	},
})

function BigWigsNefarian:Initialize()
	self.disabled = true
	BigWigs:RegisterModule(self)
end

function BigWigsNefarian:Enable()
	self.disabled = nil
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
end

function BigWigsNefarian:Disable()
	self.disabled = true
	self:UnregisterAllEvents()
	self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.bar1text)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.warn6)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.bar1text, 10)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.bar1text, 20)
end

function BigWigsNefarian:CHAT_MSG_COMBAT_HOSTILE_DEATH()
	if (arg1 == self.loc.disabletrigger) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green")
		self:Disable()
	end
end

function BigWigsNefarian:CHAT_MSG_MONSTER_YELL()
	if not self.warnpairs then self.warnpairs = {
		[self.loc.triggershamans] = {self.loc.warnshaman, true},
		[self.loc.triggerdruid] = {self.loc.warndruid, true},
		[self.loc.triggerwarlock] = {self.loc.warnwarlock, true},
		[self.loc.triggerpriest] = {self.loc.warnpriest, true},
		[self.loc.triggerhunter] = {self.loc.warnhunter, true},
		[self.loc.triggerwarrior] = {self.loc.warnwarrior, true},
		[self.loc.triggerrogue] = {self.loc.warnrogue, true},
		[self.loc.triggerpaladin] = {self.loc.warnpaladin, true},
		[self.loc.triggermage] = {self.loc.warnmage, true},
		[self.loc.trigger1] = {self.loc.warn1},
		[self.loc.trigger2] = {self.loc.warn2},
		[self.loc.trigger3] = {self.loc.warn3},
	} end

	for i,v in pairs(self.warnpairs) do
		if string.find(arg1, i) then
			self:TriggerEvent("BIGWIGS_MESSAGE", v[1], "Red")
			if v[2] then self:ClassCallBar()end
			return
		end
	end
end

function BigWigsNefarian:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE()
	if (string.find(arg1, self.loc.trigger4)) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn4, "Red")
	elseif (string.find(arg1, self.loc.trigger5)) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn5, "Red")
	end
end

function BigWigsNefarian:ClassCallBar()
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.warn6, 27, "Red")
	self:TriggerEvent("BIGWIGS_BAR_START", self.loc.bar1text, 30, 1, "Yellow", "Interface\\Icons\\Spell_Shadow_Charm")
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.bar1text, 10, "Orange")
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.bar1text, 20, "Red")
end
--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsNefarian:RegisterForLoad()