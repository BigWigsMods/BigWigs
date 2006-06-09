BigWigsCThun = AceAddon:new({
	name          	= "BigWigsCThun",
	cmd           	= AceChatCmd:new({}, {}),

	zonename 	= "AQ40",
	enabletrigger	= GetLocale() == "koKR" and "쑨의 눈"
		or GetLocale() == "zhCN" and "克苏恩之眼"
		or "Eye of C'Thun",

	loc = GetLocale() == "koKR" and {
			bossname 	= "쑨의 눈",
			disabletrigger 	= "쑨|1이;가; 죽었습니다.",
			bosskill 	= "쑨을 물리쳤습니다.",
			
			trigger1 	= "눈 달린 거대한 촉수|1이;가; 지표 균열|1으로;로;",
			trigger2 	= "약해졌습니다!",
			
			warn1		= "눈달린 촉수 등장 - 촉수 처리!",
			warn2		= "5초후 눈달린 촉수 등장!",
			warn3		= "10초후 눈달린 촉수 등장!",
			warn4		= "쑨이 약화되었습니다 - 45초간 최대 공격!",
			
			bar1text	= "눈달린 촉수!",
			bar2text	= "쑨 약화!",	
	} 	
		or GetLocale() == "zhCN" and 
	{
			bossname 	= "克苏恩之眼",
			disabletrigger 	= "克苏恩死亡了。",
			bosskill 	= "克苏恩被击败了！",
			
			trigger1 	= "巨眼触须的大地破裂",
			trigger2 	= "被削弱了！",
			
			warn1		= "巨眼触须出现！",
			warn2		= "5秒后巨眼触须出现！",
			warn3		= "10秒后巨眼触须出现！",
			warn4		= "克苏恩被削弱了 - 45秒内全力输出伤害！",
			
			bar1text	= "巨眼触须",
			bar2text	= "克苏恩被削弱了！",
	}	
		or 
	{
			bossname 	= "Eye of C'Thun",
			disabletrigger 	= "C'Thun dies.",
			bosskill 	= "C'Thun has been defeated.",
			
			trigger1 	= "Eye Tentacle's Ground Rupture",
			trigger2 	= "is weakened!",
			
			warn1		= "Incoming Tentacle Rape Party - Pleasure!",
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
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.warn3, 35, "Orange")
		self:TriggerEvent("BIGWIGS_BAR_START", self.loc.bar1text, 45, 1, "Green", "Interface\\Icons\\Spell_Nature_CorrosiveBreath")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.bar1text, 15, "Orange")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.bar1text, 30, "Red")
		self.prior = true
	end
end

function BigWigsCThun:BIGWIGS_MESSAGE(text)
	if text == self.loc.warn1 or text == self.loc.warn2 then
		self.prior = nil
	end
end

function BigWigsCThun:CHAT_MSG_MONSTER_EMOTE()
	if (arg1 == self.loc.trigger2) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn4, "red")
		self:TriggerEvent("BIGWIGS_BAR_START", self.loc.bar2text, 45, 1, "Red", "Interface\\Icons\\Spell_Nature_CorrosiveBreath")
	end
end
--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsCThun:RegisterForLoad()