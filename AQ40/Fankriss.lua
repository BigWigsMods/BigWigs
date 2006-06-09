BigWigsFankriss = AceAddon:new({
	name          = "BigWigsFankriss",
	cmd           = AceChatCmd:new({}, {}),

	zonename = "AQ40",
	enabletrigger = GetLocale() == "koKR" and "불굴의 판크리스"
		or GetLocale() == "zhCN" and "顽强的范克瑞斯"
		or "Fankriss the Unyielding",

	loc = GetLocale() == "koKR" and {	
		bossname = "불굴의 판크리스",
		disabletrigger = "불굴의 판크리스|1이;가; 죽었습니다.",		
		bosskill = "불굴의 판크리스를 물리쳤습니다!",

		wormtrigger = "불굴의 판크리스|1이;가; 벌레 소환|1을;를; 시전합니다.",
		wormwarn = "벌레 소환 - 제거!",
	} 
		or GetLocale() == "zhCN" and 
	{ 
		bossname = "顽强的范克瑞斯",
		disabletrigger = "顽强的范克瑞斯死亡了。",		
		bosskill = "顽强的范克瑞斯被击败了！",

		wormtrigger = "顽强的范克瑞斯施放了召唤虫子。",
		wormwarn = "虫子出现 - 赶快杀掉！",
	}	
		or 
	{ 
		bossname = "Fankriss the Unyielding",
		disabletrigger = "Fankriss the Unyielding dies.",		
		bosskill = "Fankriss the Unyielding has been defeated!",

		wormtrigger = "Fankriss the Unyielding casts Summon Worm.",
		wormwarn = "Incoming Worm - Kill it!",
	},
})

function BigWigsFankriss:Initialize()
	self.disabled = true
	BigWigs:RegisterModule(self)
end

function BigWigsFankriss:Enable()
	self.disabled = nil
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
end

function BigWigsFankriss:Disable()
	self.disabled = true
	self:UnregisterAllEvents()
end

function BigWigsFankriss:CHAT_MSG_COMBAT_HOSTILE_DEATH()
	if (arg1 == self.loc.disabletrigger) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green")
		self:Disable()
	end
end

function BigWigsFankriss:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF()
	if (arg1 == self.loc.wormtrigger) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.wormwarn, "Orange")
	end
end
--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsFankriss:RegisterForLoad()