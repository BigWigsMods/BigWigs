BigWigsCThun = AceAddon:new({
	name          	= "BigWigsCThun",
	cmd           	= AceChatCmd:new({}, {}),

	zonename 	= "AQ40",
	enabletrigger	= GetLocale() == "koKR" and "ì¨ì ë"
		or "Eye of C'Thun",

	loc 		= GetLocale() == "koKR" and {
			bossname 	= "ì¨ì ë",
			disabletrigger 	= "ì¨|1ì´;ê°; ì£½ììµëë¤.",
			bosskill 	= "ì¨ì ë¬¼ë¦¬ì³¤ìµëë¤.",
			
			weakendtrigger 	= "ì½í´ì¡ìµëë¤!",
			
			tentacle1	= "ëë¬ë¦° ì´ì ë±ì¥ - ì´ì ì²ë¦¬!",
			tentacle2	= "5ì´í ëë¬ë¦° ì´ì ë±ì¥!",
			tentacle3	= "10ì´í ëë¬ë¦° ì´ì ë±ì¥!",
			weakend		= "ì¨ì´ ì½íëììµëë¤ - 45ì´ê° ìµë ê³µê²©!",
		
			combat		= "C'Thun event started - 40 sec untill Dark Glare and Eyes",
		
			phase1		= "Eye of C'Thun dies.",
		
			glare2		= "PEWPEW Dark glare - 5 sec!",
			glare1		= "PEWPEW Dark glare - MOVE IT!",
		
			barTentacle	= "ëë¬ë¦° ì´ì!",
			barWeakend	= "ì¨ ì½í!",	
			barGlare	= "Dark glare!",
	} or {
			bossname 	= "Eye of C'Thun",
			disabletrigger 	= "C'Thun dies.",
			bosskill 	= "C'Thun has been defeated.",
			
			weakendtrigger 	= "is weakened!",
			
			tentacle1	= "Incoming Tentacle Rape Party - Pleasure~~!",
			tentacle2	= "Incoming Tentacle Rape Party - 5~ sec!",
			tentacle3	= "Incoming Tentacle Rape Party - 10~ sec!",
			weakend		= "C'Thun is weakened - DPS Party for 45~ sec!",
		
			combat		= "C'Thun event started - 40 sec untill Dark Glare and Eyes",
		
			phase1		= "Eye of C'Thun dies.",
		
			glare2		= "PEWPEW Dark glare - 5 sec!",
			glare1		= "PEWPEW Dark glare - MOVE IT!",
		
			barTentacle	= "Tentacle rape party!",
			barWeakend	= "C'Thun is weakened!",
			barGlare	= "Dark glare!",
	},
})

function BigWigsCThun:Initialize()
	self.disabled = true
	BigWigs:RegisterModule(self)
end

function BigWigsCThun:Enable()
	self.disabled = nil
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", "CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE")
	self:RegisterEvent("BIGWIGS_MESSAGE")
end

function BigWigsCThun:CHAT_MSG_MONSTER_EMOTE()
	if( arg1 == self.loc.weakendtrigger ) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.weakend, "red")
		self:TriggerEvent("BIGWIGS_BAR_START", self.loc.barWeakend, 45, 3, "Red", "Interface\\Icons\\INV_ValentinesCandy")
	end
end

function BigWigsCThun:CHAT_MSG_COMBAT_HOSTILE_DEATH()
		if(arg1 == self.loc.phase1) then
			self.phase2 = 1
		end
end

function BigWigsCThun:CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE()
	if arg1 and string.find(arg1, "Eye Beam") then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.combat, "Yellow")
		
		self:TriggerEvent("BIGWIGS_BAR_START", self.loc.barTentacle, 44, 1, "Green", "Interface\\Icons\\Spell_Nature_CallStorm")
		self:TriggerEvent("BIGWIGS_BAR_START", self.loc.barGlare, 44, 2, "Red", "Interface\\Icons\\Spell_Shadow_ShadowBolt")
		
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.glare2, 39, "Orange")
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.tentacle2, 39, "Orange")
		
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.glare1, 44, "Red")
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.tentacle1, 44, "Red")
		
		self:UnregisterEvent("CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE")
		self:UnregisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	end
end

function BigWigsCThun:BIGWIGS_MESSAGE(text)
	if (text == self.loc.glare1 and not self.phase2 ) then
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.glare1, 87, "Red")
		
		self:TriggerEvent("BIGWIGS_BAR_START", self.loc.barGlare, 87, 2, "Red", "Interface\\Icons\\Spell_Shadow_ShadowBolt")
	elseif (text == self.loc.tentacle1 and not self.phase2 ) then
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.tentacle1, 45, "Red")
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.tentacle2, 40, "Orange")
	
		self:TriggerEvent("BIGWIGS_BAR_START", self.loc.barTentacle, 45, 1, "Green", "Interface\\Icons\\Spell_Nature_CallStorm")
	end
end

function BigWigsCThun:Disable()
	self.disabled = true
	self.phase2 = nil
	self:UnregisterAllEvents()
end

--------------------------------
--			Load this bitch!			--
--------------------------------
BigWigsCThun:RegisterForLoad()