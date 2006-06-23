local metro = Metrognome:GetInstance("1")

BigWigsCThun = AceAddon:new({
	name          	= "BigWigsCThun",
	cmd           	= AceChatCmd:new({}, {}),

	zonename 	= "AQ40",
	enabletrigger	= GetLocale() == "koKR" and "쑨의 눈"
		or GetLocale() == "zhCN" and "克苏恩之眼"
		or "Eye of C'Thun",

	loc 		= GetLocale() == "koKR" and {			
			bossname 	= "쑨의 눈",
			cthun		= "쑨",
			disabletrigger 	= "쑨|1이;가; 죽었습니다.",
			bosskill 	= "쑨을 물리쳤습니다.",
			
			weakendtrigger 	= "약해졌습니다!",
			
			tentacle1	= "눈달린 촉수 등장 - 촉수 처리~~!",
			tentacle2	= "눈달린 촉수 등장 - 5초전!",
			tentacle3	= "눈달린 촉수 등장 - 10초전!",
			weakend		= "쑨이 약화되었습니다 - 45초간 최대 공격!",
		
			combat		= "쑨 시작 - 45초후 암흑의 주시",
		
			phase1		= "쑨의 눈|1이;가; 죽었습니다.",
		
			glare2		= "암흑의 주시 - 5초전!",
			glare1		= "암흑의 주시 - 이동!이동!",
		
			barTentacle	= "눈달린 촉수!",
			barWeakend	= "쑨 약화!",
			barGlare	= "암흑의 주시!",
			barGiant	= "Giant Eye!",

			eyebeam		= "안광",				
			glarewarning	= "암흑의 주시를 당하고 있습니다! 이동!",
			groupwarning	= "암흑의 주시 %s (%s)",
			invulnerable2	= "Party ends in 5 seconds!",
			invulnerable1	= "Party over! C'Thun is now invulnerable!",
			positions	= "Assume the position! Green Beam coming!",
	} 
		or GetLocale() == "zhCN" and 
	{
			bossname 	= "克苏恩之眼",
			cthun		= "克苏恩",
			disabletrigger 	= "克苏恩死亡了。",
			bosskill 	= "克苏恩被击败了！",
			
			weakendtrigger 	= "被削弱了！",
			
			tentacle1	= "眼球触须出现！",
			tentacle2	= "5秒后眼球触须出现！",
			tentacle3	= "10秒后眼球触须出现！",
			weakend		= "克苏恩被削弱了 - 45秒内全力输出伤害！",

			giant3		= "Incoming Giant Eye - 10 sec!",
			giant2		= "Incoming Giant Eye - 5 sec!",
			giant1		= "Incoming Giant Eye - Poke it!",			
			
			combat		= "克苏恩事件开始 - 45秒后发动黑暗闪耀与眼棱光",
			
			phase1		= "克苏恩之眼死亡了。",
			
			glare2		= "5秒后发动黑暗闪耀！",
			glare1		= "黑暗闪耀发动 - 跑位！",
			
			barTentacle	= "眼球触须！",
			barWeakend	= "克苏恩被削弱了！",
			barGlare	= "黑暗闪耀！",
			barGiant	= "Giant Eye!",
			
			eyebeam		= "眼棱光",
			glarewarning	= "DARK GLARE ON YOU! MOVE!",
			groupwarning	= "Dark Glare on group %s (%s)" ,
			invulnerable2	= "Party ends in 5 seconds!",
			invulnerable1	= "Party over! C'Thun is now invulnerable!",
			positions	= "Assume the position! Green Beam coming!",
	}
		or 
	{
			bossname 	= "Eye of C'Thun",
			cthun		= "C'Thun",
			disabletrigger 	= "C'Thun dies.",
			bosskill 	= "C'Thun has been defeated.",
			
			weakendtrigger 	= "is weakened!",
			
			tentacle1	= "Incoming Tentacle Rape Party - Pleasure!",
			tentacle2	= "Incoming Tentacle Rape Party - 5 sec!",
			tentacle3	= "Incoming Tentacle Rape Party - 10 sec!",
			weakend		= "C'Thun is weakened - DPS Party for 45 sec!",
			invulnerable2	= "Party ends in 5 seconds!",
			invulnerable1	= "Party over! C'Thun is now invulnerable!",

			giant3		= "Incoming Giant Eye - 10 sec!",
			giant2		= "Incoming Giant Eye - 5 sec!",
			giant1		= "Incoming Giant Eye - Poke it!",			
		
			combat		= "C'Thun event started - 45 sec until Dark Glare and Eyes",
		
			phase1		= "Eye of C'Thun dies.",
		
			glare2		= "PEWPEW Dark glare - 5 sec!",
			glare1		= "PEWPEW Dark glare - MOVE IT!",
		
			barTentacle	= "Tentacle rape party!",
			barWeakend	= "C'Thun is weakened!",
			barGlare	= "Dark glare!",
			barGiant	= "Giant Eye!",

			eyebeam		= "Eye Beam",
			glarewarning	= "DARK GLARE ON YOU! MOVE!",
			groupwarning	= "Dark Glare on group %s (%s)",
			positions	= "Assume the position! Green Beam coming!",
	},

	timeP1Tentacle	 = 45,
	timeP1TentacleStart = 45,
	timeP1GlareStart = 45,
	timeP1Glare	 = 87,
	timeP1GlareDuration = 34,
	
	timeP2Offset    = 12,
	timeP2Tentacle  = 30,

	timeReschedule	= 45,
})

function BigWigsCThun:Initialize()
	self.disabled = true
	self:TriggerEvent("BIGWIGS_REGISTER_MODULE", self)
end

function BigWigsCThun:Enable()
	self.disabled = nil
	self.target = nil
	self.gianteye = nil
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", "CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")

	metro:Unregister("BigWigs Cthun Tentacles")
	metro:Unregister("BigWigs Cthun Tentacles Reschedule")
	metro:Unregister("BigWigs Cthun Tentacles Phase2")
	metro:Unregister("BigWigs Cthun Dark Glare")
	metro:Unregister("BigWigs Cthun Dark Glare Group Warning")
	metro:Unregister("BigWigs Cthun Target")

	metro:Register("BigWigs Cthun CheckWipe", self.PLAYER_REGEN_ENABLED, 2, self)
	
	metro:Register("BigWigs Cthun Tentacles", self.TentacleRape, self.timeP1Tentacle, self )
	metro:Register("BigWigs Cthun Tentacles Reschedule", self.StartTentacleRape, self.timeReschedule, self )
	metro:Register("BigWigs Cthun Tentacles Phase2", self.StartTentacleRape, self.timeP2Tentacle + self.timeP2Offset, self )
	metro:Register("BigWigs Cthun Dark Glare", self.DarkGlare, self.timeP1GlareStart, self)

	-- we warn which group will be dark glared 2 second before it hits.
	metro:Register("BigWigs Cthun Group Warning", self.GroupWarning, self.timeP1GlareStart - 2, self)
	metro:Register("BigWigs Cthun Target", self.CheckTarget, 0.2, self)

end

function BigWigsCThun:CheckTarget()
	local i
	local newtarget = nil
	if( UnitName("playertarget") == self.loc.bossname ) then
		newtarget = UnitName("playertargettarget")
	else
		for i = 1, GetNumRaidMembers(), 1 do
			if UnitName("Raid"..i.."target") == self.loc.bossname then
				newtarget = UnitName("Raid"..i.."targettarget")
				break
			end
		end		
	end
	if( newtarget ) then
		self.target = newtarget
	end
end

function BigWigsCThun:GroupWarning()
	if( self.firstWarning ) then
		metro:ChangeRate("BigWigs Cthun Group Warning", self.timeP1Glare )
		self.firstWarning = nil
	end
	if( self.target ) then
		local i, name, group
		for i = 1, GetNumRaidMembers(), 1 do 
			name, _, group, _, _, _, _, _ = GetRaidRosterInfo(i)
			if( name == self.target ) then break end
		end
		self:TriggerEvent("BIGWIGS_MESSAGE", string.format( self.loc.groupwarning, group, self.target), "Red")
		self:TriggerEvent("BIGWIGS_SENDTELL", self.target, self.loc.glarewarning ) 
	end
end

function BigWigsCThun:TentacleRape() 
	local nexttime = self.timeP1Tentacle
	if( self.phase2 ) then
		nexttime = self.timeP2Tentacle
		if( self.gianteye ) then
			self.gianteye = nil
			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.giant1, nexttime, "Red")
			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.giant2, nexttime - 5, "Orange")
			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.giant3, nexttime - 10, "Yellow")
			self:TriggerEvent("BIGWIGS_BAR_START", self.loc.barGiant, nexttime, 3, "Orange", "Interface\\Icons\\Ability_EyeOfTheOwl" )
		else
			self.gianteye = true
		end
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
	-- we announce just before the glare to give people time, hence the -1 
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.glare1, self.timeP1Glare-1, "Red")
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.glare2, self.timeP1Glare-5, "Orange")
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.positions, self.timeP1Glare + self.timeP1GlareDuration, "Green")
	self:TriggerEvent("BIGWIGS_BAR_START", self.loc.barGlare, self.timeP1Glare, 2, "Red", "Interface\\Icons\\Spell_Shadow_ShadowBolt")
end

function BigWigsCThun:StartTentacleRape()
	self:TentacleRape()
	metro:Start("BigWigs Cthun Tentacles")
end

function BigWigsCThun:CHAT_MSG_MONSTER_EMOTE()
	if( arg1 == self.loc.weakendtrigger ) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.weakend, "Green")
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.invulnerable2, 40, "Orange")
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.invulnerable1, 45, "Red")
		self:TriggerEvent("BIGWIGS_BAR_START", self.loc.barWeakend, 45, 4, "Red", "Interface\\Icons\\INV_ValentinesCandy")

		-- cancel tentacle timers
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.tentacle1)
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.tentacle2)
		self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.barTentacle)

		-- cancel giant timers
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.giant1)
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.giant2)
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.log.giant3)
		self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.barGiant)

		-- stop the timer, and reschedule.
		metro:Stop("BigWigs Cthun Tentacles")
		metro:Start("BigWigs Cthun Tentacles Reschedule", 1)

	end
end

function BigWigsCThun:CHAT_MSG_COMBAT_HOSTILE_DEATH()
		if(arg1 == self.loc.phase1) then
			self.phase2 = true

			-- cancel tentacle timers
			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.tentacle1)
			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.tentacle2)
			self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.barTentacle)

			-- Cancel Existing Glare Timers
			self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.barGlare)
			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.glare1)
			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.glare2)
			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.positions)

			-- change to phase 2 rate
			metro:Stop("BigWigs Cthun Tentacles")
			metro:ChangeRate("BigWigs Cthun Tentacles", self.timeP2Tentacle )
			
			-- schedule first rape into phase 2
			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.tentacle1, self.timeP2Tentacle + self.timeP2Offset, "Red")
			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.tentacle2, self.timeP2Tentacle + self.timeP2Offset - 5, "Orange")
			self:TriggerEvent("BIGWIGS_BAR_START", self.loc.barTentacle, self.timeP2Tentacle + self.timeP2Offset, 1, "Green", "Interface\\Icons\\Spell_Nature_CallStorm")

			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.giant1, self.timeP2Tentacle + self.timeP2Offset, "Red")
			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.giant2, self.timeP2Tentacle + self.timeP2Offset - 5, "Orange")
			self:TriggerEvent("BIGWIGS_BAR_START", self.loc.barGiant, self.timeP2Tentacle + self.timeP2Offset, 3, "Orange", "Interface\\Icons\\Ability_EyeOfTheOwl" )		

			-- this metro schedule will restart the tentacle rapes again.
			metro:Start("BigWigs Cthun Tentacles Phase2", 1)
			-- no Dark glaring in phase 2
			metro:Stop("BigWigs Cthun Dark Glare")
			metro:Stop("BigWigs Cthun Group Warning")
			metro:Stop("BigWigs Cthun Target")

		elseif( arg1 == self.loc.disabletrigger) then
			self:Disable()
			self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green", nil, "Victory")
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
		metro:Stop("BigWigs Cthun CheckWipe")
	elseif (not metro:Status("BigWigs Cthun CheckWipe")) then
		metro:Start("BigWigs Cthun CheckWipe")
	end
end

function BigWigsCThun:CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE()
	if arg1 and string.find(arg1, self.loc.eyebeam) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.combat, "Yellow")
		
		self:TriggerEvent("BIGWIGS_BAR_START", self.loc.barTentacle, self.timeP1GlareStart, 1, "Green", "Interface\\Icons\\Spell_Nature_CallStorm")
		self:TriggerEvent("BIGWIGS_BAR_START", self.loc.barGlare, self.timeP1TentacleStart, 2, "Red", "Interface\\Icons\\Spell_Shadow_ShadowBolt")
		
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.glare2, self.timeP1GlareStart - 5, "Orange")
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.tentacle2, self.timeP1TentacleStart - 5, "Orange")
		
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.glare1, self.timeP1GlareStart, "Red")
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.tentacle1, self.timeP1TentacleStart, "Red")

		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.positions, self.timeP1GlareStart + self.timeP1GlareDuration, "Green")
		
		self:UnregisterEvent("CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE")
		self:UnregisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
		
		self.firstGlare = true
		self.firstWarning = true
		-- start our tentacle rape and dark glare schedules
		metro:Start("BigWigs Cthun Tentacles")
		metro:Start("BigWigs Cthun Dark Glare")
		-- start group warning schedules
		metro:Start("BigWigs Cthun Group Warning")
		metro:Start("BigWigs Cthun Target")
	end
end

function BigWigsCThun:Disable()
	self.disabled = true
	self.phase2 = nil
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.tentacle1)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.tentacle2)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.giant1)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.giant2)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.giant3)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.glare1)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.glare2)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.positions)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.invulnerable1)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.invulnerable2)
	self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.barGlare)
	self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.barTentacle)
	self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.barGiant)
	self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.barWeakened)
	metro:Unregister("BigWigs Cthun Tentacles")
	metro:Unregister("BigWigs Cthun Tentacles Reschedule")
	metro:Unregister("BigWigs Cthun Tentacles Phase2")
	metro:Unregister("BigWigs Cthun Dark Glare")
	metro:Unregister("BigWigs Cthun Group Warning")
	metro:Unregister("BigWigs Cthun Target")
	metro:Unregister("Bigwigs Cthun CheckWipe")
	
	self:UnregisterAllEvents()
end
--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsCThun:RegisterForLoad()