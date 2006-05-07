BigWigsChromaggus = AceAddon:new({
	name          = "BigWigsChromaggus",
	cmd           = AceChatCmd:new({}, {}),

	zonename = "BWL",
	enabletrigger = "Chromaggus",

	loc = GetLocale() == "deDE" and {
		bossname = "Chromaggus",
		disabletrigger = "Chromaggus stirbt.",

		trigger1 = "^Chromaggus beginnt ([%w ]+) zu wirken.",
		trigger2 = "^[%w']+ [%w' ]+ ([%w]+) Chromaggus f\195\188r ([%d]+) ([%w ]+) Schaden%..*",
		trigger3 = "Chromaggus's Zeitraffer wurde von ([%w]+)% wiederstanden.",
		trigger4 = "ger\195\164t in t\195\182dliche Raserei!",
		trigger5 = "als die Haut schimmert",

		hit = "trifft",
		crit = "trifft kritisch",

		warn1 = "%s in 10 Sekunden!",
		warn2 = "%s wirkt!",
		warn3 = "Neue Zauberspruchverwundbarkeit: %s",
		warn4 = "Zauberspruchverwundbarkeit hat sich ge\195\164ndert!",
		warn5 = "Raserei - Einlullender Schuss!",
		bosskill = "Chromaggus wurde besiegt!",

		breathsicons = {
			["Zeitraffer"] = "Interface\\Icons\\Spell_Arcane_PortalOrgrimmar",
			["Corrosive Acid"] = "Interface\\Icons\\Spell_Nature_Acid_01",
			["Fleisch entz\195\188nden"] = "Interface\\Icons\\Spell_Fire_Fire",
			["Incinerate"] = "Interface\\Icons\\Spell_Shadow_ChillTouch",
			["Frostbeulen"] = "Interface\\Icons\\Spell_Frost_ChillingBlast",
		}
	}	or {
		bossname = "Chromaggus",
		disabletrigger = "Chromaggus dies.",

		trigger1 = "^Chromaggus begins to cast ([%w ]+)\.",
		trigger2 = "^[%w']+ [%w' ]+ ([%w]+) Chromaggus for ([%d]+) ([%w ]+) damage%..*",
		trigger3 = "Chromaggus's Time Lapse was resisted by ([%w]+)%.",
		trigger4 = "goes into a killing frenzy!",
		trigger5 = "flinches as its skin shimmers.",

		hit = "hits",
		crit = "crits",

		warn1 = "%s in 10 seconds!",
		warn2 = "%s is casting!",
		warn3 = "New spell vulnerability: %s",
		warn4 = "Spell vulnerability changed!",
		warn5 = "Frenzy - Tranq Shot!",
		bosskill = "Chromaggus has been defeated!",

		breathsicons = {
			["Time Lapse"] = "Interface\\Icons\\Spell_Arcane_PortalOrgrimmar",
			["Corrosive Acid"] = "Interface\\Icons\\Spell_Nature_Acid_01",
			["Ignite Flesh"] = "Interface\\Icons\\Spell_Fire_Fire",
			["Incinerate"] = "Interface\\Icons\\Spell_Shadow_ChillTouch",
			["Frost Burn"] = "Interface\\Icons\\Spell_Frost_ChillingBlast",
		},
	},
})

function BigWigsChromaggus:Initialize()
	self.disabled = true
	BigWigs:RegisterModule(self)
end

function BigWigsChromaggus:Enable()
	self.disabled = nil
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	self:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE", "PlayerDamageEvents")
	self:RegisterEvent("CHAT_MSG_SPELL_PET_DAMAGE", "PlayerDamageEvents")
	self:RegisterEvent("CHAT_MSG_SPELL_PARTY_DAMAGE", "PlayerDamageEvents")
	self:RegisterEvent("CHAT_MSG_SPELL_FRIENDLYPLAYER_DAMAGE", "PlayerDamageEvents")
end

function BigWigsChromaggus:Disable()
	self.disabled = true
	self:UnregisterAllEvents()
	self:Reset()
	self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.breath1)
	self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.breath2)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", format(self.loc.warn1, self.loc.breath1))
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", format(self.loc.warn1, self.loc.breath2))
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.breath1, 30)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.breath1, 50)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.breath2, 30)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.breath2, 50)
end

function BigWigsChromaggus:CHAT_MSG_COMBAT_HOSTILE_DEATH()
	if (arg1 == self.loc.disabletrigger) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green")
		self:Disable()
	end
end

function BigWigsChromaggus:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE()
	local _,_, SpellName = string.find(arg1, self.loc.trigger1)
	if (SpellName) then
		if (not self.loc.breath1) then
			self.loc.breath1 = SpellName
		elseif (not self.loc.breath2) then
			self.loc.breath2 = SpellName
		end

		Timex:ChangeDuration("BigWigsChromaggusResetTimer", 60)
		self:TriggerEvent("BIGWIGS_MESSAGE", format(self.loc.warn2, SpellName), "Red")

		if (self.loc.breath1 == SpellName) then
			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", format(self.loc.warn1, SpellName), 50, "Red")
			self:TriggerEvent("BIGWIGS_BAR_START", self.loc.breath1, 60, 1, "Yellow", self.loc.breathsicons[SpellName])
			self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.breath1, 30, "Orange")
			self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.breath1, 50, "Red")
		elseif (self.loc.breath2 == SpellName) then
			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", format(self.loc.warn1, SpellName), 50, "Red")
			self:TriggerEvent("BIGWIGS_BAR_START", self.loc.breath2, 60, 2, "Yellow", self.loc.breathsicons[SpellName])
			self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.breath2, 30, "Orange")
			self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.breath2, 50, "Red")
		end
	end
end

function BigWigsChromaggus:CHAT_MSG_MONSTER_EMOTE()
	if (arg1 == self.loc.trigger4 and arg2 == self.loc.bossname) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn5, "Red")
		Timex:ChangeDuration("BigWigsChromaggusResetTimer", 60)
	elseif (arg1 == self.loc.trigger5 and arg2 == self.loc.bossname) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn4, "White")
		Timex:AddNamedSchedule("BigWigsChromaggusSpellVulnerability", 2.5, false, 1, function() BigWigsChromaggus.loc.vulnerability = nil end)
		Timex:ChangeDuration("BigWigsChromaggusResetTimer", 60)
	end
end

function BigWigsChromaggus:PlayerDamageEvents()
	if (not self.loc.vulnerability) then
		local _,_, Type, Dmg, School = string.find(arg1, self.loc.trigger2)
		if (Type == (self.loc.hit or self.loc.crit) and tonumber(Dmg or "") and School) then
			if ((tonumber(Dmg) >= 550 and Type == self.loc.hit) or (tonumber(Dmg) >= 1100 and Type == self.loc.crit)) then
				self.loc.vulnerability = School
				self:TriggerEvent("BIGWIGS_MESSAGE", format(self.loc.warn3, School), "White")
			end
		end
		Timex:ChangeDuration("BigWigsChromaggusResetTimer", 60)
	end
end

function BigWigsChromaggus:Reset()
	self.loc.vulnerability = nil
	self.loc.breath1 = nil
	self.loc.breath2 = nil
end
--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsChromaggus:RegisterForLoad()