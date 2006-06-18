

BigWigsVenoxis = AceAddon:new({
	name          = "BigWigsVenoxis",
	cmd           = AceChatCmd:new({}, {}),

	zonename = "ZG",
	enabletrigger = GetLocale() == "koKR" and "대사제 베녹시스"
		or GetLocale() == "zhCN" and "高阶祭司温诺希斯"
		or "High Priest Venoxis",

	loc = GetLocale() == "koKR" and {
		bossname = "대사제 베녹시스",
		disabletrigger = "대사제 베녹시스|1이;가; 죽었습니다.",
		-- "이제서야... 안식을...!"

		trigger1 = "대사제 베녹시스|1이;가; 소생 효과를 얻었습니다.",
		trigger2 = "Let the coils of hate unfurl!",

		warn1 = "소생 - 마법 해제해주세요!",
		warn2 = "2단계 시작 - 독구름을 조심하세요!",

		bosskill = "대사제 베녹시스를 물리쳤습니다!",
	}
		or GetLocale() == "zhCN" and
	{
		bossname = "高阶祭司温诺希斯",
		disabletrigger = "高阶祭司温诺希斯死亡了。",

		trigger1 = "高阶祭司温诺希斯获得了恢复的效果。",
		trigger2 = "让仇恨的",

		warn1 = "恢复 - 立即驱散！",
		warn2 = "进入第二阶段，小心毒云！",

		bosskill = "高阶祭司温诺希斯被击败了！",
	}
		or
	{
		bossname = "High Priest Venoxis",
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
	BigWigs:RegisterModule(self)
end


function BigWigsVenoxis:Enable()
	self.disabled = nil
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
end


function BigWigsVenoxis:Disable()
	self.disabled = nil
	self:UnregisterAllEvents()
end


function BigWigsVenoxis:CHAT_MSG_COMBAT_HOSTILE_DEATH()
	if arg1 == self.loc.disabletrigger then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green", nil, "Victory")
		self:Disable()
	end
end


function BigWigsVenoxis:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS()
	if arg1 == self.loc.trigger1 then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn1, "Orange")
	end
end

function BigWigsVenoxis:CHAT_MSG_MONSTER_YELL()
	if string.find(arg1, self.loc.trigger2) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn2, "Yellow")
	end
end

--------------------------------
--			Load this bitch!			--
--------------------------------
BigWigsVenoxis:RegisterForLoad()
