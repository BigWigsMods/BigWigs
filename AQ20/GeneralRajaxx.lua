------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.0")("General Rajaxx")
local andorov = AceLibrary("Babble-Boss-2.0")("Lieutenant General Andorov")
local L = AceLibrary("AceLocale-2.0"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "rajaxx",
	
	wave_cmd = "wave",
	wave_name = "Wave Alert",
	wave_desc = "Warn for incoming waves",

	trigger1 = "Kill first, ask questions later... Incoming!",
	trigger2 = "?????",  -- There is no callout for wave 2 ><
	trigger3 = "The time of our retribution is at hand! Let darkness reign in the hearts of our enemies!",
	trigger4 = "No longer will we wait behind barred doors and walls of stone! No longer will our vengeance be denied! The dragons themselves will tremble before our wrath!",
	trigger5 = "Fear is for the enemy! Fear and death!",
	trigger6 = "Staghelm will whimper and beg for his life, just as his whelp of a son did! One thousand years of injustice will end this day!",
	trigger7 = "Fandral! Your time has come! Go and hide in the Emerald Dream and pray we never find you!",
	trigger8 = "Impudent fool! I will kill you myself!",
	trigger9 = "Remember, Rajaxx, when I said I'd kill you last?",

	warn1 = "Wave 1/8",
	warn2 = "Wave 2/8",
	warn3 = "Wave 3/8",
	warn4 = "Wave 4/8",
	warn5 = "Wave 5/8",
	warn6 = "Wave 6/8",
	warn7 = "Wave 7/8",
	warn8 = "Incoming General Rajaxx",	
	warn9 = "Wave 1/8", -- trigger for starting the event by pulling the first wave instead of talking to andorov
	
} end )

L:RegisterTranslations("deDE", function() return {
	trigger1 = "Hier kommen sie. Bleibt am Leben, Welpen.",
	trigger2 = "?????",  -- There is no callout for wave 2 ><
	trigger3 = "Die Zeit der Vergeltung ist gekommen! Lasst uns die Herzen unserer Feinde mit Dunkelheit f\195\188llen!",
	trigger4 = "Wir werden nicht l\195\164nger hinter verbarrikatierten Toren und Mauern aus Stein ausharren! Die Rache wird unser sein! Selbst die Drachen werden im Angesicht unseres Zornes erzittern!",
	trigger5 = "Wir kennen keine Furcht! Und wir werden unseren Feinden den Tod bringen!",
	trigger6 = "Staghelm wird winseln und um sein Leben betteln, genau wie sein r\195\164udiger Sohn! Eintausend Jahre der Ungerechtigkeit werden heute enden!",
	trigger7 = "Fandral! Deine Zeit ist gekommen! Geh und verstecke dich im Smaragdgr\195\188nen Traum, und bete, dass wir dich nie finden werden!",
	trigger8 = "Unversch\195\164mter Narr! Ich werde Euch h\195\182chstpers\195\182nlich t\195\182ten!",

	warn1 = "Welle 1/8",
	warn2 = "Welle 2/8",
	warn3 = "Welle 3/8",
	warn4 = "Welle 4/8",
	warn5 = "Welle 5/8",
	warn6 = "Welle 6/8",
	warn7 = "Welle 7/8",
	warn8 = "General Rajaxx kommt!",
} end )

L:RegisterTranslations("zhCN", function() return {
	trigger1 = "它们来了。尽量别被它们干掉，新兵。",
	trigger2 = "?????",  -- There is no callout for wave 2 ><
	trigger3 = "我们复仇的时刻到了！让敌人的内心被黑暗吞噬吧！",
	trigger4 = "我们不用再呆在这座石墙里面了！我们很快就能报仇了！在我们的怒火面前，就连那些龙也会战栗！",
	trigger5 = "让敌人胆战心惊吧！让他们在恐惧中死去！",
	trigger6 = "鹿盔将会呜咽着哀求我饶他一命，就像他那懦弱的儿子一样！一千年来的屈辱会在今天洗清！",
	trigger7 = "范达尔！你的死期到了！藏到翡翠梦境里去吧，祈祷我们永远都找不到你！",
	trigger8 = "无礼的蠢货！我会亲自要了你们的命！",

	warn1 = "第 1/8 批敌人来了！顶住！",
	warn2 = "第 2/8 批敌人来了！顶住！",
	warn3 = "第 3/8 批敌人来了！顶住！",
	warn4 = "第 4/8 批敌人来了！顶住！",
	warn5 = "第 5/8 批敌人来了！顶住！",
	warn6 = "第 6/8 批敌人来了！顶住！",
	warn7 = "第 7/8 批敌人来了！顶住！",
	warn8 = "拉贾克斯将军亲自上阵！",
} end )

L:RegisterTranslations("koKR", function() return {
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
} end )


----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsGeneralRajaxx = BigWigs:NewModule(boss)
BigWigsGeneralRajaxx.zonename = AceLibrary("Babble-Zone-2.0")("Ruins of Ahn'Qiraj")
BigWigsGeneralRajaxx.enabletrigger = andorov
BigWigsGeneralRajaxx.toggleoptions = {"wave", "bosskill"}
BigWigsGeneralRajaxx.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsGeneralRajaxx:OnEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self.warnsets = {}
	for i=1,8 do self.warnsets[L("trigger"..i)] = L("warn"..i) end
end

function BigWigsGeneralRajaxx:CHAT_MSG_MONSTER_YELL( msg )
	if self.db.profile.wave and msg and self.warnsets[msg] then
		self:TriggerEvent("BigWigs_Message", self.warnsets[arg1], "Orange")
	end
end
