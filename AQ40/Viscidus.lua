BigWigsViscidus = AceAddon:new({
	name          	= "BigWigsViscidus",
	cmd           	= AceChatCmd:new({}, {}),

	zonename 	= "AQ40",
	enabletrigger 	= GetLocale() == "koKR" and "비시디우스"
		or "Viscidus",

	loc = GetLocale() == "koKR" and {
			bossname = "비시디우스",
			disabletrigger = "비시디우스|1이;가; 죽었습니다.",
			bosskill = "비시디우스를 물리쳤습니다.",
			
			--You suffer 1545 Nature damage from Toxic Slime's Toxin.
			
			trigger1 	= "begins to slow!",
			trigger2 	= "is freezing up!",
			trigger3 	= "is frozen solid!",
			trigger4 	= "begins to crack!",
			trigger5 	= "looks ready to shatter!",
			trigger6	= "afflicted by Poison Bolt Volley",
			trigger7 	= "(.*)독소에 걸렸습니다.",			
			
			you 		= "",
			are 		= "are",
			whopattern = "(.+)|1이;가; ",
			
			warn1 		= "First freeze phase!",
			warn2 		= "Second freeze phase - GET READY",
			warn3 		= "Third freeze phase - DPS DPS DPS",
			warn4 		= "Cracking up - little more now!",
			warn5 		= "Cracking up - almost there!",
			warn6		= "Poison Bolt Volley - Cleanse Poison!",
			warn7		= "Incoming Poison Bolt Volley in 3~ sec!",
			warn8		= "님이 독소에 걸렸습니다 - 대피!",
			
			bar1text	= "Poison Bolt Volley",
	} or {
			bossname = "Viscidus",
			disabletrigger = "Viscidus dies.",
			bosskill = "Viscidus has been defeated.",
			
			--You suffer 1545 Nature damage from Toxic Slime's Toxin.
			
			trigger1 	= "begins to slow!",
			trigger2 	= "is freezing up!",
			trigger3 	= "is frozen solid!",
			trigger4 	= "begins to crack!",
			trigger5 	= "looks ready to shatter!",
			trigger6	= "afflicted by Poison Bolt Volley",
			trigger7 	= "^([^%s]+) ([^%s]+) afflicted by Toxin%.$",
			
			you 		= "You",
			are 		= "are",
			
			warn1 		= "First freeze phase!",
			warn2 		= "Second freeze phase - GET READY",
			warn3 		= "Third freeze phase - DPS DPS DPS",
			warn4 		= "Cracking up - little more now!",
			warn5 		= "Cracking up - almost there!",
			warn6		= "Poison Bolt Volley - Cleanse Poison!",
			warn7		= "Incoming Poison Bolt Volley in 3~ sec!",
			warn8		= "is in a toxin cloud - MOVE!",
			warn9		= "You are in the toxin cloud - Move it!",
			
			bar1text	= "Poison Bolt Volley",
	},
})

function BigWigsViscidus:Initialize()
	self.disabled = true
	BigWigs:RegisterModule(self)
end

function BigWigsViscidus:Enable()
	self.disabled = nil
	self:RegisterEvent("BIGWIGS_MESSAGE")
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "CheckSting")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "CheckSting")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "CheckSting")
end

function BigWigsViscidus:Disable()
	self.disabled = true
	self.prior1 = nil
	self:UnregisterAllEvents()
end

if (GetLocale() == "koKR") then 
	function BigWigsViscidus:CheckSting()
		if (not self.prior1 and string.find(arg1, self.loc.trigger6)) then
			self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn6, "Orange")
			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.warn7, 7, "Orange")
			self:TriggerEvent("BIGWIGS_BAR_START", self.loc.bar1text, 10, 1, "Green", "Interface\\Icons\\Spell_Nature_CorrosiveBreath")
			self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.bar1text, 5, "Orange")
			self:TriggerEvent("BIGWGS_BAR_DELAYEDSETCOLOR_START", self.loc.bar1text, 3, "Red")
			self.prior1 = true
		elseif (string.find(arg1, self.loc.trigger7)) then
			local _,_, pl = string.find(arg1, self.loc.trigger7)
			if (pl) then	
				if (pl == self.loc.you) then
					pl = UnitName("player")
				end
				self:TriggerEvent("BIGWIGS_MESSAGE", pl .. self.loc.warn8, "Red")
			end	
		end
	end
else
	function BigWigsViscidus:CheckSting()
		if (not self.prior1 and string.find(arg1, self.loc.trigger6)) then
			self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn6, "Orange")
			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.warn7, 7, "Orange")
			self:TriggerEvent("BIGWIGS_BAR_START", self.loc.bar1text, 10, 1, "Green", "Interface\\Icons\\Spell_Nature_CorrosiveBreath")
			self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.bar1text, 5, "Orange")
			self:TriggerEvent("BIGWGS_BAR_DELAYEDSETCOLOR_START", self.loc.bar1text, 3, "Red")
			self.prior1 = true
		elseif (string.find(arg1, self.loc.trigger7)) then
			local _,_, pl, ty = string.find(arg1, self.loc.trigger7)
			if (pl and ty) then	
				if (pl == self.loc.you and ty == self.loc.are) then
					pl = UnitName("player")
					self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn9, "Red", true)
				else
					self:TriggerEvent("BIGWIGS_MESSAGE", pl .. self.loc.warn8, "Red")
					self:TriggerEvent("BIGWIGS_SENDTELL", pl, self.loc.warn9)
				end
			end	
		end
	end
end 

function BigWigsViscidus:CHAT_MSG_MONSTER_EMOTE()
	if (arg1 == self.loc.trigger1) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn1, "Yellow")
	elseif (arg1 == self.loc.trigger2) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn2, "Orange")
	elseif (arg1 == self.loc.trigger3) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn3, "Red")
	elseif (arg1 == self.loc.trigger4) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn4, "Orange")
	elseif (arg1 == self.loc.trigger5) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn5, "Red")
	end
end

function BigWigsViscidus:BIGWIGS_MESSAGE(text)
	if text == self.loc.warn6 then self.prior1 = nil end
end
--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsViscidus:RegisterForLoad()