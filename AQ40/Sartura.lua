BigWigsSartura = AceAddon:new({
	name          = "BigWigsSartura",
	cmd           = AceChatCmd:new({}, {}),

	zonename = "AQ40",
	enabletrigger = "Battleguard Sartura",

	loc = {
		bossname = "Battleguard Sartura",
		disabletrigger = "I served to the last!",
		bosskill = "Battleguard Sartura has been defeated!",

		starttrigger = "You will be judged for defiling these sacred grounds! The laws of the Ancients will not be challenged! Trespassers will be annihilated!",
		startwarn = "Sartura engaged - 10 minutes until Enrage",
		enragetrigger = "becomes enraged",
		enragewarn = "Enrage - Enrage - Enrage",
		bartext = "Enrage",
		warn1 = "Enrage in 8 minutes",
		warn2 = "Enrage in 5 minutes",
		warn3 = "Enrage in 3 minutes",
		warn4 = "Enrage in 90 seconds",
		warn5 = "Enrage in 60 seconds",
		warn6 = "Enrage in 30 seconds",
		warn7 = "Enrage in 10 seconds",
		whirlwindon = "Battleguard Sartura gains Whirlwind.",
		whirlwindoff = "Whirlwind fades from Battleguard Sartura.",
		whirlwindonwarn = "Whirlwind - Battleguard Sartura - Whirlwind",
		whirlwindoffwarn = "Whirlwind faded. Spank! Spank! Spank!",
	},
})


function BigWigsSartura:Initialize()
	self.disabled = true
	BigWigs:RegisterModule(self)
end

function BigWigsSartura:Enable()
	self.disabled = nil
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
end


function BigWigsSartura:Disable()
	self.disabled = true
	self:UnregisterEvent("CHAT_MSG_MONSTER_YELL")
	self:UnregisterEvent("CHAT_MSG_MONSTER_EMOTE")
	self:UnregisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
end

function BigWigsSartura:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS()
	if( arg1 == self.loc.whirlwindon ) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.whirlwindonwarn, "Red" )
	elseif( arg1 == self.loc.whirlwindoff ) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.whirlwindoffwarn, "Yellow")
	end
end

function BigWigsSartura:CHAT_MSG_MONSTER_YELL()
	if( arg1 ) then
		if( arg1 == self.loc.starttrigger ) then
			self:BeginTimers()
		elseif( string.find(arg1, self.loc.disabletrigger ) ) then
			self:StopTimers()
			self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green")
			self:Disable()
		end
	end
end


function BigWigsSartura:CHAT_MSG_MONSTER_EMOTE()
	if( arg1 ) then 
		if( arg2 == self.loc.bossname and string.find(arg1, self.loc.enragetrigger) ) then
			self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.enragewarn, "Yellow")
		end
	end
end

function BigWigsSartura:StopTimers()
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.warn1 )
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.warn2 )
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.warn3 )
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.warn4 )
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.warn5 )
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.warn6 )
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.warn7 )
end

function BigWigsSartura:BeginTimers()
	self:TriggerEvent("BIGWIGS_BAR_START", self.loc.bartext, 600, 1, "Green", "Interface\\Icons\\Spell_Shadow_UnholyFrenzy")
	self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.startwarn, "Red")
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.warn1, 120, "Green")
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.warn2, 300, "Yellow")
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.warn3, 420, "Yellow")
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.warn4, 510, "Orange")
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.warn5, 540, "Orange")
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.warn6, 570, "Red")
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.warn7, 590, "Red")
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR", self.loc.bartext, 300, "Yellow")
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR", self.loc.bartext, 510, "Orange")
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR", self.loc.bartext, 570, "Red")
end


--------------------------------
--			Load this bitch!			--
--------------------------------
BigWigsSartura:RegisterForLoad()
