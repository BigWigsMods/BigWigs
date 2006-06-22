BigWigsBugFamily = AceAddon:new({
	name          = "BigWigsBugFamily",
	cmd           = AceChatCmd:new({}, {}),

	zonename = "AQ40",
	enabletrigger = GetLocale() == "koKR" and { "군주 크리", "공주 야우즈", "벰" }
		or GetLocale() == "zhCN" and { "克里勋爵", "亚尔基公主", "维姆" }
		or GetLocale() == "deDE" and { "Lord Kri", "Prinzessin Yauj", "Vem" } or { "Lord Kri", "Princess Yauj", "Vem" },

	loc = GetLocale() == "koKR" and {
		bossname = "벌레 무리 - 군주 크리, 공주 야우즈, 벰",
		disabletrigger1 = "군주 크리|1이;가; 죽었습니다.",
		disabletrigger2 = "공주 야우즈|1이;가; 죽었습니다.",
		disabletrigger3 = "벰|1이;가; 죽었습니다.",
		bosskill = "벌레 무리 중 하나를 물리쳤습니다!",

		healtrigger = "공주 야우즈|1이;가; 상급 치유|1을;를; 시전합니다.",
		healwarn = "치유 시전 - 시전 방해!",					
		
		feartrigger = "공포에 걸렸습니다.",
   	fearbar = "공포",
   	fearwarn1 = "공포 시전! 다음 시전 20초후!",
   	fearwarn2 = "5초후 공포!",
	} 
		or GetLocale() == "zhCN" and 
	{ 
		bossname = "虫子一家 - 克里勋爵、亚尔基公主、维姆",
		disabletrigger1 = "克里勋爵死亡了。",
		disabletrigger2 = "亚尔基公主死亡了。",
		disabletrigger3 = "维姆死亡了。",
		bosskill = "虫子一家被击败了！",

		healtrigger = "亚尔基公主开始施放强效治疗术。",
		healwarn = "亚尔基公主正在施放治疗 - 迅速打断！",

		feartrigger = "受到了恐慌效果的影响。",
		fearbar = "群体恐惧",
		fearwarn1 = "群体恐惧 - 20秒后再次发动",
		fearwarn2 = "5秒后发动群体恐惧！",
	}
	 or GetLocale() == "deDE" and {
		bossname = "K\195\164ferfamilie - Lord Kri, Prinzessin Yauj und Vem",
		disabletrigger1 = "Lord Kri stirbt.",
		disabletrigger2 = "Prinzessin Yauj stirbt.",
		disabletrigger3 = "Vem stirbt.",
		bosskill = "Die K\195\164ferfamilie wurde besiegt!",

		healtrigger = "Prinzessin Yauj beginnt Gro\195\159e Heilung zu wirken.",
		healwarn = "Zaubert Heilung - unterbrechen!",
		
		feartrigger = "ist betroffen von Furcht%.",
		fearbar = "AE Furcht",
		fearwarn1 = "AE Furcht! N\195\164chster in 20 Sekunden!",
		fearwarn2 = "AE Furcht in 5 Sekunden!",


	} or 
	{
		bossname = "Bug Family - Lord Kri, Princess Yauj and Vem",
		disabletrigger1 = "Lord Kri dies.",
		disabletrigger2 = "Princess Yauj dies.",
		disabletrigger3 = "Vem dies.",
		bosskill = "The Bug Family has been defeated!",

		healtrigger = "Princess Yauj begins to cast Great Heal.",
		healwarn = "Casting heal - interrupt it!",

		feartrigger = "is afflicted by Fear%.",
		fearbar = "AE Fear",
		fearwarn1 = "AE Fear! Next in 20 Seconds!",
		fearwarn2 = "AE Fear in 5 Seconds!",
	},
})

function BigWigsBugFamily:Initialize()
	self.disabled = true
	BigWigs:RegisterModule(self)
end

function BigWigsBugFamily:Enable()
	self.disabled = nil
	self.deaths = 0
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "FearEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "FearEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "FearEvent")
	self:RegisterEvent("BIGWIGS_MESSAGE")
end

function BigWigsBugFamily:Disable()
	self.disabled = true
	self:UnregisterAllEvents()
end

function BigWigsBugFamily:FearEvent()
	if (not self.fearstatus and string.find(arg1, self.loc.feartrigger)) then
		self.fearstatus = true
		self:TriggerEvent("BIGWIGS_BAR_START", self.loc.fearbar, 20, 2, "Green", "Interface\\Icons\\Spell_Shadow_Possession")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.fearbar, 10, "Yellow")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.fearbar, 15, "Red")
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.fearwarn1, "Red")
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.fearwarn2, 15, "Orange")
	end
end

function BigWigsBugFamily:BIGWIGS_MESSAGE(txt)
	if (self.fearstatus and txt == self.loc.fearwarn2) then
		self.fearstatus = false
	end
end

function BigWigsBugFamily:CHAT_MSG_COMBAT_HOSTILE_DEATH()
	if (arg1 == self.loc.disabletrigger1
	or arg1 == self.loc.disabletrigger2
	or arg1 == self.loc.disabletrigger3) then
		self.deaths = self.deaths + 1
		if (self.deaths == 3) then
			self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green", nil, "Victory")
			self:Disable()
		end
	end
end

function BigWigsBugFamily:PLAYER_REGEN_ENABLED()
	self.deaths = 0
end

function BigWigsBugFamily:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF()
	if (arg1 == self.loc.healtrigger) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.healwarn, "Orange")
	end
end
--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsBugFamily:RegisterForLoad()