
local metro = Metrognome:GetInstance("1")

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
		
			combat		= "C'Thun event started - 45 sec untill Dark Glare and Eyes",
		
			phase1		= "Eye of C'Thun dies.",
		
			glare2		= "PEWPEW Dark glare - 5 sec!",
			glare1		= "PEWPEW Dark glare - MOVE IT!",
		
			barTentacle	= "ëë¬ë¦° ì´ì!",
			barWeakend	= "ì¨ ì½í!",	
			barGlare	= "Dark glare!",

			eyebeam		= "Eye Beam",
			cthun		= "C'Thun",

	} or {
			bossname 	= "Eye of C'Thun",
			cthun		= "C'Thun",
			disabletrigger 	= "C'Thun dies.",
			bosskill 	= "C'Thun has been defeated.",
			
			weakendtrigger 	= "is weakened!",
			
			tentacle1	= "Incoming Tentacle Rape Party - Pleasure~~!",
			tentacle2	= "Incoming Tentacle Rape Party - 5~ sec!",
			tentacle3	= "Incoming Tentacle Rape Party - 10~ sec!",
			weakend		= "C'Thun is weakened - DPS Party for 45~ sec!",
		
			combat		= "C'Thun event started - 45 sec untill Dark Glare and Eyes",
		
			phase1		= "Eye of C'Thun dies.",
		
			glare2		= "PEWPEW Dark glare - 5 sec!",
			glare1		= "PEWPEW Dark glare - MOVE IT!",
		
			barTentacle	= "Tentacle rape party!",
			barWeakend	= "C'Thun is weakened!",
			barGlare	= "Dark glare!",

			eyebeam		= "Eye Beam",
	},

	timeP1Tentacle	 = 44,
	timeP1GlareStart = 44,
	timeP1Glare	 = 87,
	
	timeP2Start     = 42,
	timeP2Tentacle  = 29,

	timeReschedule	= 48,
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
	self:RegisterEvent("PLAYER_REGEN_ENABLED")

	metro:Unregister("BigWigs Cthun Tentacles")
	metro:Unregister("BigWigs Cthun Tentacles Reschedule")
	metro:Unregister("BigWigs Cthun Tentacles Phase2")
	metro:Unregister("BigWigs Cthun Dark Glare")

	metro:Register("BigWigs Cthun Tentacles", self.TentacleRape, self.timeP1Tentacle, self )
	metro:Register("BigWigs Cthun Tentacles Reschedule", self.StartTentacleRape, self.timeReschedule, self )
	metro:Register("BigWigs Cthun Tentacles Phase2", self.StartTentacleRape, self.timeP2Start, self)
	metro:Register("BigWigs Cthun Dark Glare", self.DarkGlare, self.timeP1GlareStart, self)
end

function BigWigsCThun:TentacleRape() 
	local nexttime = self.timeP1Tentacle
	if( self.phase2 ) then
		nexttime = self.timeP2Tentacle
	end
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.tentacle1, nexttime, "Red")
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.tentacle2, nexttime - 5, "Orange")
	self:TriggerEvent("BIGWIGS_BAR_START", self.loc.barTentacle, nexttime, 1, "Green", "Interface\\Icons\\Spell_Nature_CallStorm" )
end

function BigWigsCThun:DarkGlare()
	if ( self.firstGlare ) then 
		metro:ChangeRate("BigWigs Cthun Dark Glare", self.timeP1Glare )
		self.firstGlare = nil
	end	
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.glare1, self.timeP1Glare, "Red")
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.glare2, self.timeP1Glare-1, "Orange")
	self:TriggerEvent("BIGWIGS_BAR_START", self.loc.barGlare, self.timeP1Glare, 2, "Red", "Interface\\Icons\\Spell_Shadow_ShadowBolt")
end

function BigWigsCThun:StartTentacleRape()
	metro:Start("BigWigs Cthun Tentacles")
end


function BigWigsCThun:CHAT_MSG_MONSTER_EMOTE()
	if( arg1 == self.loc.weakendtrigger ) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.weakend, "red")
		self:TriggerEvent("BIGWIGS_BAR_START", self.loc.barWeakend, 45, 3, "Red", "Interface\\Icons\\INV_ValentinesCandy")

		-- cancel tentacle timers
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.tentacle1)
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.tentacle2)
		self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.barTentacle)

		metro:Stop("BigWigs Cthun Tentacles")
		metro:Start("BigWigs Cthun Tentacles Reschedule", 1)

	end
end

function BigWigsCThun:CHAT_MSG_COMBAT_HOSTILE_DEATH()
		if(arg1 == self.loc.phase1) then
			self.phase2 = 1

			-- cancel tentacle timers
			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.tentacle1)
			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.tentacle2)
			self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.barTentacle)

			-- change to phase 2 rate
			metro:Stop("BigWigs Cthun Tentacles")
			metro:ChangeRate("BigWigs Cthun Tentacles", self.timeP2Tentacle )
			
			-- schedule first rape into phase 2
			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.tentacle1, self.timeP2Start, "Red")
			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.tentacle2, self.timeP2Start-5, "Orange")
			self:TriggerEvent("BIGWIGS_BAR_START", self.loc.barTentacle, self.loc.timeP2Start, 1, "Green", "Interface\\Icons\\Spell_Nature_CallStorm")

			-- this metro schedule will restart the tentacle rapes again.
			metro:Start("BigWigs Cthun Phase2", 1)
			-- no Dark glaring in phase 2
			metro:Stop("BigWigs Cthun Dark Glare")

		elseif( arg1 == self.loc.disabletrigger) then
			self:Disable()
		end
end

function BigWigsCThun:Scan()
	if (UnitName("target") == (self.loc.bossname or self.loc.cthun) and UnitAffectingCombat("target")) then
		return true
	elseif (UnitName("playertarget") == (self.loc.bossname or self.loc.cthun) and UnitAffectingCombat("playertarget")) then
		return true
	else
		local i
		for i = 1, GetNumRaidMembers(), 1 do
			if (UnitName("Raid"..i.."target") == (self.loc.cthun or self.loc.bossname) and UnitAffectingCombat("Raid"..i.."target")) then
				return true
			end
		end
	end
	return false
end

function BigWigsCThun:PLAYER_REGEN_ENABLED()
	local go = self:Scan()
	if (not go) then
		self:Disable()
	end
end

function BigWigsCThun:CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE()
	if arg1 and string.find(arg1, self.loc.eyebeam) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.combat, "Yellow")
		
		self:TriggerEvent("BIGWIGS_BAR_START", self.loc.barTentacle, self.timeP1GlareStart, 1, "Green", "Interface\\Icons\\Spell_Nature_CallStorm")
		self:TriggerEvent("BIGWIGS_BAR_START", self.loc.barGlare, self.timeP1Tentacle, 2, "Red", "Interface\\Icons\\Spell_Shadow_ShadowBolt")
		
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.glare2, self.timeP1GlareStart - 5, "Orange")
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.tentacle2, self.timeP1Tentacle - 5, "Orange")
		
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.glare1, self.timeP1GlareStart, "Red")
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.tentacle1, self.timeP1Tentacle, "Red")
		
		self:UnregisterEvent("CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE")
		self:UnregisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
		
		self.firstGlare = true
		-- start our tentacle rape and dark glare schedules
		metro:Start("BigWigs Cthun Tentacles")
		metro:Start("BigWigs Cthun Dark Glare")
	end
end

function BigWigsCThun:Disable()
	self.disabled = true
	self.phase2 = nil
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.tentacle1)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.tentacle2)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.glare1)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.glare2)
	self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.barGlare)
	self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.barTentacle)
	metro:Unregister("BigWigs Cthun Tentacles")
	metro:Unregister("BigWigs Cthun Tentacles Reschedule")
	metro:Unregister("BigWigs Cthun Tentacles Phase2")
	metro:Unregister("BigWigs Cthun Dark Glare")
	
	self:UnregisterAllEvents()
end

--------------------------------
--			Load this bitch!			--
--------------------------------
BigWigsCThun:RegisterForLoad()