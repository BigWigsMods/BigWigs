local bboss = BabbleLib:GetInstance("Boss 1.2")

BigWigsVenoxis = AceAddon:new({
	name          = "BigWigsVenoxis",
	cmd           = AceChatCmd:new({}, {}),

	zonename = BabbleLib:GetInstance("Zone 1.2")("Zul'Gurub"),
	enabletrigger = bboss("High Priest Venoxis"),
	bossname = bboss("High Priest Venoxis"),

	toggleoptions = GetLocale() == "koKR" and {
		notRenew = "소생 해제 경고",
		notPhase2 = "2단계 경보",
		notBosskill = "보스 사망 알림",
	} or {
		notRenew = "Show Renew dispel warnings",
		notPhase2 = "Announce Phase 2 transition",
		notBosskill = "Boss death",
	},
	optionorder = { "notRenew", "notPhase2", "notBosskill" },

	loc = GetLocale() == "koKR" and {
		disabletrigger = "대사제 베녹시스|1이;가; 죽었습니다.",		

		trigger1 = "대사제 베녹시스|1이;가; 소생 효과를 얻었습니다.",
		trigger2 = "증오의 또아리를 틀 시간이다!",

		warn1 = "소생 - 마법 해제해주세요!",
		warn2 = "2단계 시작 - 독구름을 조심하세요!",

		bosskill = "대사제 베녹시스를 물리쳤습니다!",
	} or GetLocale() == "zhCN" and {
		disabletrigger = "高阶祭司温诺希斯死亡了。",

		trigger1 = "高阶祭司温诺希斯获得了恢复的效果。",
		trigger2 = "让仇恨的",

		warn1 = "恢复 - 立即驱散！",
		warn2 = "进入第二阶段，小心毒云！",

		bosskill = "高阶祭司温诺希斯被击败了！",
	} or GetLocale() == "deDE" and {
		disabletrigger = "Hohepriester Venoxis stirbt.",

		trigger1 = "Hohepriester Venoxis bekommt 'Erneuerung'.",
		trigger2 = "Lasst das Schlachten beginnen!", -- CHECK

		warn1 = "Erneuerung - schnell entfernen!",
		warn2 = "Phase 2, auf Giftwolken aufpassen!",

		bosskill = "High Priest Venoxis has been defeated!",
	} or {
		disabletrigger = "High Priest Venoxis dies.",

		trigger1 = "High Priest Venoxis gains Renew.",
		trigger2 = "Let the coils of hate unfurl!",

		warn1 = "Renew - Dispel it now!",
		warn2 = "Incoming phase 2, watch the poison clouds!",

		bosskill = "High Priest Venoxis has been defeated!",
	},
})

function BigWigsVenoxis:Initialize()
	self.disabled = true
	self:TriggerEvent("BIGWIGS_REGISTER_MODULE", self)
end

function BigWigsVenoxis:Enable()
	self.disabled = nil
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
end

function BigWigsVenoxis:Disable()
	self.disabled = true
	self:UnregisterAllEvents()
end

function BigWigsVenoxis:CHAT_MSG_COMBAT_HOSTILE_DEATH()
	if arg1 == self.loc.disabletrigger then
		if not self:GetOpt("notBosskill") then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green", nil, "Victory") end
		self:Disable()
	end
end

function BigWigsVenoxis:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS()
	if arg1 == self.loc.trigger1 and not self:GetOpt("notRenew") then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn1, "Orange")
	end
end

function BigWigsVenoxis:CHAT_MSG_MONSTER_YELL()
	if string.find(arg1, self.loc.trigger2) and not self:GetOpt("notPhase2") then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn2, "Yellow")
	end
end
--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsVenoxis:RegisterForLoad()