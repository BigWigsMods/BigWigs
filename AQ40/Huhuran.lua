BigWigsHuhuran = AceAddon:new({
	name          = "BigWigsHuhuran",
	cmd           = AceChatCmd:new({}, {}),

	zonename = "AQ40",
	enabletrigger = GetLocale() == "koKR" and "공주 후후란"
		or GetLocale() == "zhCN" and "哈霍兰公主"
		or "Princess Huhuran",

	loc = GetLocale() == "koKR" and {
		bossname = "공주 후후란",
		disabletrigger = "공주 후후란|1이;가; 죽었습니다.",
		bosskill = "공주 후후란을 물리쳤습니다.",

		frenzytrigger = "광란의 상태에 빠집니다!",
		berserktrigger = "광폭해집니다!",
		frenzywarn = "광폭화 - 평정 사격!",
		berserkwarn = "광기 - 독 빈도 증가!",
		berserksoonwarn = "광폭화 경보 - 준비!",
		stingtrigger = "공주 후후란|1이;가; 비룡 쐐기|1으로;로;",
		stingwarn = "비룡 쐐기 - 메인탱커 해제!",
		stingdelaywarn = "비룡 쐐기 3초전!",
		bartext = "비룡 쐐기",
	}
		or GetLocale() == "zhCN" and
	{
		bossname = "哈霍兰公主",
		disabletrigger = "哈霍兰公主死亡了。",
		bosskill = "哈霍兰公主被击败了！",

		frenzytrigger = "变得狂暴起来！",
		berserktrigger = "变得极度狂暴而愤怒！",
		frenzywarn = "狂暴警报 - 猎人立刻使用宁神射击！",
		berserkwarn = "狂暴模式 - 治疗注意！",
		berserksoonwarn = "即将狂暴 - 做好准备！",
		stingtrigger = "受到了致命剧毒效果的影响。",
		stingwarn = "毒性之箭 - 给TANK驱散！",
		stingdelaywarn = "3秒后哈霍兰可能施放毒性之箭！",
		bartext = "毒性之箭",
	}
		or
	{
		bossname = "Princess Huhuran",
		disabletrigger = "Princess Huhuran dies.",
		bosskill = "Princess Huhuran has been defeated.",

		frenzytrigger = "goes into a frenzy!",
		berserktrigger = "goes into a berserker rage!",
		frenzywarn = "Frenzy - Tranq Shot!",
		berserkwarn = "Berserk - Give it all you got!",
		berserksoonwarn = "Berserk Soon - Get Ready!",
		stingtrigger = "afflicted by Wyvern Sting",
		stingwarn = "Wyvern Sting - Dispel Tanks!",
		stingdelaywarn = "Possible Wyvern Sting in 3 seconds!",
		bartext = "Wyvern Sting",
	},
})

function BigWigsHuhuran:Initialize()
	self.disabled = true
	BigWigs:RegisterModule(self)
end

function BigWigsHuhuran:Enable()
	self.disabled = nil
	self:RegisterEvent("BIGWIGS_MESSAGE")
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	self:RegisterEvent("UNIT_HEALTH")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "checkSting")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "checkSting")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "checkSting")
end

function BigWigsHuhuran:Disable()
	self.disabled = true
	self.berserkannounced = nil
	self.prior = nil
	self:UnregisterAllEvents()
	self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.bartext)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.stingdelaywarn)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.bartext, 10)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.bartext, 20)
end

function BigWigsHuhuran:CHAT_MSG_COMBAT_HOSTILE_DEATH()
    if (arg1 == self.loc.disabletrigger) then
        self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green", nil, "Victory")
        self:Disable()
    end
end

function BigWigsHuhuran:CHAT_MSG_MONSTER_EMOTE()
	if (arg1 == self.loc.frenzytrigger) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.frenzywarn, "Orange")
	elseif (arg1 == self.loc.berserktrigger) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.berserkwarn, "Red")
	end
end

function BigWigsHuhuran:UNIT_HEALTH()
	if (UnitName(arg1) == self.loc.bossname) then
		local health = UnitHealth(arg1)
		if (health > 30 and health <= 33) then
			self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.berserksoonwarn, "Red")
			self.berserkannounced = true
		elseif (health > 40 and self.berserkannounced) then
			self.berserkannounced = nil
		end
	end
end

function BigWigsHuhuran:checkSting()
	if (not self.prior and string.find(arg1, self.loc.stingtrigger)) then
		DEFAULT_CHAT_FRAME:AddMessage("BWMessage CheckSting" )
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.stingwarn, "Orange")
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.stingdelaywarn, 22, "Orange")
		self:TriggerEvent("BIGWIGS_BAR_START", self.loc.bartext, 25, 1, "Green", "Interface\\Icons\\INV_Spear_02")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.bartext, 10, "Orange")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.bartext, 20, "Red")
		self.prior = true
	end
end

function BigWigsHuhuran:BIGWIGS_MESSAGE(text)
	if text == self.loc.stingdelaywarn then self.prior = nil end
end
--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsHuhuran:RegisterForLoad()