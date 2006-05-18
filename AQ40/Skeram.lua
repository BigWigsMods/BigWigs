BigWigsSkeram = AceAddon:new({
	name          = "BigWigsSkeram",
	cmd           = AceChatCmd:new({}, {}),

	zonename = "AQ40",
	enabletrigger = GetLocale() == "koKR" and "예언자 스케람" 
		or "The Prophet Skeram",

	loc = GetLocale() == "koKR" and {
		bossname = "예언자 스케람",
		disabletrigger = "예언자 스케람|1이;가; 죽었습니다.",
		bosskill = "예언자 스케람을 물리쳤습니다.",

		aetrigger = "예언자 스케람|1이;가; 신비한 폭발|1을;를; 시전합니다.",
		mctrigger = "예언자 스케람|1이;가; 예언 실현|1을;를; 시전합니다.",
		aewarn = "신비한 폭발 시전 - 시전 방해!",
		mcwarn = "예언 실현 시전 - 양변 준비!",		
		mcplayer = "(.*)예언 실현에 걸렸습니다.",
		mcplayerwarn = "님이 정신지배되었습니다. 양변! 공포!",
		
		mcyou = "",
		mcare = "are",	
		whopattern = "(.+)|1이;가; ",
	} or {
		bossname = "The Prophet Skeram",
		disabletrigger = "The Prophet Skeram dies.",
		bosskill = "The Prophet Skeram has been defeated.",

		aetrigger = "The Prophet Skeram begins to cast Arcane Explosion.",
		mctrigger = "The Prophet Skeram begins to cast True Fulfillment.",
		aewarn = "Casting Arcane Explosion - interrupt it!",
		mcwarn = "Casting True Fulfillment - prepare to sheep!",
		mcplayer = "^([^%s]+) ([^%s]+) afflicted by True Fulfillment.$",
		mcplayerwarn = " is mindcontrolled! Sheep! Fear!",
		mcyou = "You",
		mcare = "are",
	},
})

function BigWigsSkeram:Initialize()
    self.disabled = true
    BigWigs:RegisterModule(self)
end

function BigWigsSkeram:Enable()
	self.disabled = nil
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
end

function BigWigsSkeram:Disable()
	self.disabled = true
	self:UnregisterAllEvents()
end

function BigWigsSkeram:CHAT_MSG_COMBAT_HOSTILE_DEATH()
	if (arg1 == self.loc.disabletrigger) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green")
		self:Disable()
	end
end

if ( GetLocale() == "koKR" ) then 
	function BigWigsSkeram:CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE()
		local _,_, Player = string.find(arg1, self.loc.mcplayer)
		if (Player) then	
			if (Player == self.loc.mcyou) then
				Player = UnitName("player")
			end
			self:TriggerEvent("BIGWIGS_MESSAGE", Player .. self.loc.mcplayerwarn, "Red")
		end
	end
else
	function BigWigsSkeram:CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE()
		local _,_, Player, Type = string.find(arg1, self.loc.mcplayer)
		if (Player and Type) then	
			if (Player == self.loc.mcyou and Type == self.loc.mcare) then
				Player = UnitName("player")
			end
			self:TriggerEvent("BIGWIGS_MESSAGE", Player .. self.loc.mcplayerwarn, "Red")
		end
	end
end

function BigWigsSkeram:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE()
	if (arg1 == self.loc.aetrigger) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.aewarn, "Orange")
	elseif (arg1 == self.loc.mctrigger) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.mcwarn, "Orange")
	end
end
--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsSkeram:RegisterForLoad()