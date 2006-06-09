BigWigsMagmadar = AceAddon:new({
	name          = "BigWigsMagmadar",
	cmd           = AceChatCmd:new({}, {}),

	zonename = "MC",
	enabletrigger = GetLocale() == "koKR" and "마그마다르"
		or GetLocale() == "zhCN" and "玛格曼达"
		or "Magmadar",

	loc = GetLocale() == "koKR" and {
		bossname = "마그마다르",
		disabletrigger = "마그마다르|1이;가; 죽었습니다.",

		trigger1 = "살기를 띤 듯한 광란의 상태에 빠집니다!",
		trigger2 = "공황에 걸렸습니다.",

		warn1 = "광폭화 경보 - 사냥꾼의 평정 사격을 쏘세요!",
		warn2 = "5초후 광역 공포!",
		warn3 = "광역 공포 경보 - 다음 공포까지 30초!",

		bar1text = "광역 공포",	
	} 
		or GetLocale() == "zhCN" and
	{
		bossname = "玛格曼达",
		disabletrigger = "玛格曼达死亡了。",

		trigger1 = "变得极为狂暴！",
		trigger2 = "受到了恐慌",

		warn1 = "狂暴警报 - 猎人立刻使用宁神射击！",
		warn2 = "5秒后发动群体恐惧！",
		warn3 = "群体恐惧 - 30秒后再次发动",

		bar1text = "群体恐惧",
	} or {
		bossname = "Magmadar",
		disabletrigger = "Magmadar dies.",

		trigger1 = "goes into a killing frenzy!",
		trigger2 = "by Panic.",

		warn1 = "Frenzy alert - Hunter Tranq shot now!",
		warn2 = "5 second until AoE Fear!",
		warn3 = "AoE Fear alert - 30 seconds till next!",

		bar1text = "AoE Fear",
	},
})

function BigWigsMagmadar:Initialize()
	self.disabled = true
	BigWigs:RegisterModule(self)
end

function BigWigsMagmadar:Enable()
	self.disabled = nil
	self:RegisterEvent("BIGWIGS_MESSAGE")
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Fear")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Fear")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Fear")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
end

function BigWigsMagmadar:Disable()
	self.disabled = true
	self:UnregisterAllEvents()
	self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.bar1text)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.warn2)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.bar1text, 10)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.bar1text, 20)
	self.prior = nil
end

function BigWigsMagmadar:CHAT_MSG_COMBAT_HOSTILE_DEATH()
	if (arg1 == self.loc.disabletrigger) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green")
		self:Disable()
	end
end

function BigWigsMagmadar:CHAT_MSG_MONSTER_EMOTE()
	if (arg1 == self.loc.trigger1) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn1, "Red")
	end
end

function BigWigsMagmadar:Fear()
	if (not self.prior and string.find(arg1, self.loc.trigger2)) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn3, "Red")
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.warn2, 25, "Orange")
		self:TriggerEvent("BIGWIGS_BAR_START", self.loc.bar1text, 30, 1, "Yellow", "Interface\\Icons\\Spell_Shadow_PsychicScream")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.bar1text, 10, "Orange")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.bar1text, 20, "Red")
		self.prior = true
	end
end

function BigWigsMagmadar:BIGWIGS_MESSAGE(text)
	if text == self.loc.warn2 then self.prior = nil end
end
--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsMagmadar:RegisterForLoad()