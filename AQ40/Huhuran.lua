BigWigsHuhuran = AceAddon:new({
	name          = "BigWigsHuhuran",
	cmd           = AceChatCmd:new({}, {}),

	zonename = "AQ40",
	enabletrigger = "Princess Huhuran",

	loc = {
		bossname = "Princess Huhuran",
		disabletrigger = "Princess Huhuran dies.",
		bosskill = "Princess Huhuran has been defeated.",

		frenzytrigger = "goes into a frenzy!",
		berserktrigger = "goes into a berserker rage!",
		frenzywarn = "Frenzy - Tranq Shot!",
		berserkwarn = "Berserk - Give it all you got!",
		berserksoonwarn = "Berserk Soon - Get Ready!",
		stingtrigger = "^([^%s]+) ([^%s]+) afflicted by Wyvern Sting",
		stingwarn = "Wyvern Sting - Dispel Tanks!",
		stingdelaywarn = "Possible Wyvern Sting in 3 seconds!",
		bartext = "Wyvern Sting",
	},
})

function BigWigsHuhuran:Initialize()
	self.disabled = true
	BigWigs:RegisterModule(self)
end

function BigWigsHuhuran:Enable()
	self.disabled = nil
	self:RegisterEvent("BIGWIGS_MESSAGE")
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	self:RegisterEvent("UNIT_HEALTH")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "checkSting")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "checkSting")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "checkSting")
end


function BigWigsHuhuran:Disable()
	self.disabled = true
	self.berserkannounced = nil
	self.prior = nil
	self:UnregisterAllEvents()
	
end

function BigWigsHuhuran:CHAT_MSG_COMBAT_HOSTILE_DEATH()
    if ( arg1 == self.loc.disabletrigger ) then
        self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green")
        self:Disable()
    end
end


function BigWigsHuhuran:CHAT_MSG_MONSTER_EMOTE()
	if( arg2 == self.loc.bossname ) then
		if( arg1 == self.loc.frenzytrigger ) then
			self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.frenzywarn, "Orange")
		elseif( arg1 == self.loc.berserktrigger ) then
			self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.berserkwarn, "Red")
		end
	end
end

function BigWigsHuhuran:UNIT_HEALTH()
	if( arg1 and UnitName( arg1 ) == self.loc.bossname ) then
		local health = UnitHealth( arg1 )
		if( health > 30 and health <= 33 ) then
			self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.berserksoonwarn, "Red")
			self.berserkannounced = true
		elseif( health > 40 and self.berserkannounced ) then
			self.berserkannounced = nil
		end
	end
end

function BigWigsHuhuran:checkSting()
	if not self.prior and arg1 and string.find( arg1, self.loc.stingtrigger ) then
		self.prior = true
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.stingwarn, "Orange")
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.stingdelaywarn, 22, "Orange")
		self:TriggerEvent("BIGWIGS_BAR_START", self.loc.bartext, 25, 1, "Green", "Interface\\Icons\\INV_Spear_02")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.bartext, 10, "Orange")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.bartext, 20, "Red")
	end
end

function BigWigsHuhuran:BIGWIGS_MESSAGE(text)
	if text == self.loc.stingdelaywarn then self.prior = nil end
end

--------------------------------
--			Load this bitch!			--
--------------------------------
BigWigsHuhuran:RegisterForLoad()
