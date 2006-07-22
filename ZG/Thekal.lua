local bboss = BabbleLib:GetInstance("Boss 1.2")

BigWigsThekal = AceAddon:new({
	name          = "BigWigsThekal",
	cmd           = AceChatCmd:new({}, {}),

	zonename = BabbleLib:GetInstance("Zone 1.2")("Zul'Gurub"),
	enabletrigger = bboss("High Priest Thekal"),
	bossname = bboss("High Priest Thekal"),

	toggleoptions = GetLocale() == "koKR" and {
		notTigers = "호랑이 소환 경고",
		notHeal = "치유 시전 방해 경고",
		notBosskill = "보스 사망 알림",
	} or {
		notTigers = "Warn on incoming tigers",
		notHeal = "Show heal interrupt warnings",
		notBosskill = "Boss death",
	},

	optionorder = { "notTigers", "notHeal", "notBosskill" },

	loc = GetLocale() == "koKR" and {
		trigger1 = "대사제 데칼|1이;가; 줄리안 수호표범 소환|1을;를; 사용했습니다.",
		trigger2 = "광신도 로르칸|1이;가; 상급 치유|1을;를; 시전합니다.",
		warn1 = "호랑이 소환!!!",
		warn2 = "로르칸, 상급 치유 시전!!!",

		disabletrigger = "대사제 데칼|1이;가; 죽었습니다.",

		bosskill = "대사제 데칼을 물리쳤습니다!!!",
	} or GetLocale() == "deDE" and { 
		trigger1 = "Hohepriester Thekal wirkt Zulianische W\195\164chter beschw\195\182ren.",
		trigger2 = "Zealot Lor'Khan beginnt Gro\195\159e Heilung zu wirken.", -- CHECK
		warn1 = "Tiger beschworen!",
		warn2 = "Lor'Khan Heilt - Unterbrechen!",

		disabletrigger = "High Priest Thekal dies.",

		bosskill = "High Priest Thekal has been defeated!",
	} or { 
		trigger1 = "High Priest Thekal performs Summon Zulian Guardians.",
		trigger2 = "Zealot Lor'Khan begins to cast Great Heal.",
		warn1 = "Incoming Tigers!",
		warn2 = "Lor'Khan Casting Heal - Interrupt it!",

		disabletrigger = "High Priest Thekal dies.",

		bosskill = "High Priest Thekal has been defeated!",
	},
})

function BigWigsThekal:Initialize()
	self.disabled = true
	self:TriggerEvent("BIGWIGS_REGISTER_MODULE", self)
end

function BigWigsThekal:Enable()
	self.disabled = nil
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
end

function BigWigsThekal:Disable()
	self.disabled = true
	self:UnregisterAllEvents()
end

function BigWigsThekal:CHAT_MSG_COMBAT_HOSTILE_DEATH()
	if arg1 == self.loc.disabletrigger then
		if not self:GetOpt("notBosskill") then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green", nil, "Victory") end
		self:Disable()
	end
end

function BigWigsThekal:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF()
	if (arg1 == self.loc.trigger1) and not self:GetOpt("notTigers") then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn1, "Yellow")
	elseif (arg1 == self.loc.trigger2) and not self:GetOpt("notHeal") then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn2, "Orange")
	end
end

--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsThekal:RegisterForLoad()