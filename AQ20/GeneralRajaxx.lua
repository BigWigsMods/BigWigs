

BigWigsGeneralRajaxx = AceAddon:new({
	name          = "BigWigsGeneralRajaxx",
	cmd           = AceChatCmd:new({}, {}),

	zonename = "AQ20",
	enabletrigger = GetLocale() == "koKR" and "사령관 안도로브"
		or "Lieutenant General Andorov",

	loc = GetLocale() == "koKR" and {
		bossname = "장군 라작스",
		disabletrigger = "장군 라작스|1이;가; 죽었습니다.",

--		lieutenant = "Lieutenant General Andorov",
--		general = "General Rajaxx",

		trigger1 = "그들이 오고 있다. 자신의 몸을 지키도록 하라!",
		trigger2 = "?????",  -- 2단계 외침은 없음 ><
		trigger3 = "응보의 날이 다가왔다! 암흑이 적들의 마음을 지배하게 되리라!",
		trigger4 = "‘더는’ 돌벽과 성문 뒤에서 기다릴 수 없다! 복수의 기회를 놓칠 수 없다. 우리가 분노를 터뜨리는 날 용족은 두려움에 떨리라.",
		trigger5 = "적에게 공포와 죽음의 향연을!",
		trigger6 = "스테그헬름은 흐느끼며 목숨을 구걸하리라. 그 아들놈이 그랬던 것처럼! 천 년의 한을 풀리라! 오늘에서야!",
		trigger7 = "판드랄! 때가 왔다! 에메랄드의 꿈속에 숨어서 기도나 올려라!",
		trigger8 = "건방진...  내 친히 너희를 처치해주마!",

		warn1 = "1/8 단계",
		warn2 = "2/8 단계",
		warn3 = "3/8 단계",
		warn4 = "4/8 단계",
		warn5 = "5/8 단계",
		warn6 = "6/8 단계",
		warn7 = "7/8 단계",
		warn8 = "장군 라작스 등장",

		bosskill = "장군 라작스를 물리쳤습니다!",	
	} or {
		bossname = "General Rajaxx",
		disabletrigger = "General Rajaxx dies.",

--		lieutenant = "Lieutenant General Andorov",
--		general = "General Rajaxx",

		trigger1 = "They come now. Try not to get yourself killed, young blood.",
		trigger2 = "?????",  -- There is no callout for wave 2 ><
		trigger3 = "The time of our retribution is at hand! Let darkness reign in the hearts of our enemies!",
		trigger4 = "No longer will we wait behind barred doors and walls of stone! No longer will our vengeance be denied! The dragons themselves will tremble before our wrath!",
		trigger5 = "Fear is for the enemy! Fear and death!",
		trigger6 = "Staghelm will whimper and beg for his life, just as his whelp of a son did! One thousand years of injustice will end this day!",
		trigger7 = "Fandral! Your time has come! Go and hide in the Emerald Dream and pray we never find you!",
		trigger8 = "Impudent fool! I will kill you myself!",

		warn1 = "Wave 1/8",
		warn2 = "Wave 2/8",
		warn3 = "Wave 3/8",
		warn4 = "Wave 4/8",
		warn5 = "Wave 5/8",
		warn6 = "Wave 6/8",
		warn7 = "Wave 7/8",
		warn8 = "Incoming General Rajaxx",

		bosskill = "General Rajaxx has been defeated!",
	},
})

function BigWigsGeneralRajaxx:Initialize()
	self.disabled = true
	BigWigs:RegisterModule(self)
end

function BigWigsGeneralRajaxx:Enable()
	self.disabled = nil
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")

	self.warnsets = {}
	for i=1,8 do self.warnsets[self.loc["trigger"..i]] = self.loc["warn"..i] end
end

function BigWigsGeneralRajaxx:Disable()
	self.disabled = true
	self:UnregisterAllEvents()
	self.warnsets = nil
end

function BigWigsGeneralRajaxx:CHAT_MSG_COMBAT_HOSTILE_DEATH()
	if (arg1 == self.loc.disabletrigger) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green")
		self:Disable()
	end
end

function BigWigsGeneralRajaxx:CHAT_MSG_MONSTER_YELL()
	if (arg1 and self.warnsets[arg1]) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.warnsets[arg1], "Orange")
	end
end
--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsGeneralRajaxx:RegisterForLoad()