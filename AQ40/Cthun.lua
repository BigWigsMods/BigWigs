BigWigsCThun = AceAddon:new({
	name          	= "BigWigsCThun",
	cmd           	= AceChatCmd:new({}, {}),

	zonename 	= "AQ40",
	enabletrigger 	= "Eye of C'Thun",

	loc 		= {
			bossname 	= "Eye of C'Thun",
			disabletrigger 	= "C'Thun dies.",
			bosskill 	= "C'Thun has been defeated.",
			
			trigger1 	= "Eye Tentacle's Ground Rupture",
			trigger2 	= "is weakened!",
			
			warn1		= "Incoming Tentacle Rape Party - Pleasure~~!",
			warn2		= "Incoming Tentacle Rape Party - 5~ sec!",
			warn3		= "Incoming Tentacle Rape Party - 10~ sec!",
			warn4		= "C'Thun is weakened - DPS Party for 45~ sec!",
			
			bar1text	= "Tentacle rape party!",
			bar2text	= "C'Thun is weakened!",
	},
})

function BigWigsCThun:Initialize()
	self.disabled = true
	BigWigs:RegisterModule(self)
end

function BigWigsCThun:Enable()
	self.disabled = nil
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	self:RegisterEvent("BIGWIGS_MESSAGE")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", "CheckString")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE", "CheckString")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE", "CheckString")
end


function BigWigsCThun:Disable()
	self.disabled = true
	self.prior = nil
	self:UnregisterAllEvents()
end

function BigWigsCThun:CheckString()
	if (not self.prior and string.find(arg1, self.loc.trigger1)) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn1, "Red")
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.warn2, 40, "Orange")
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.warn2, 35, "Orange")
		self:TriggerEvent("BIGWIGS_BAR_START", self.loc.bar1text, 45, 1, "Green", "Interface\\Icons\\Spell_Nature_CorrosiveBreath")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.bar1text, 15, "Orange")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.bar1text, 30, "Red")
		self.prior = true
	end
end

function BigWigsCThun:BIGWIGS_MESSAGE(text)
	if text == self.loc.warn1 then
		self.prior = nil
	elseif text == self.loc.warn2 then
		self.prior = nil
	end
end

function BigWigsCThun:CHAT_MSG_MONSTER_EMOTE()
	if( arg1 == self.loc.trigger2 ) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn4, "red")
		self:TriggerEvent("BIGWIGS_BAR_START", self.loc.bar2text, 45, 1, "Red", "Interface\\Icons\\Spell_Nature_CorrosiveBreath")
	end
end

--------------------------------
--			Load this bitch!			--
--------------------------------
BigWigsCThun:RegisterForLoad()