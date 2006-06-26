local bboss = BabbleLib:GetInstance("Boss 1.2")

BigWigsEbonroc = AceAddon:new({
	name          = "BigWigsEbonroc",
	cmd           = AceChatCmd:new({}, {}),

	zonename = BabbleLib:GetInstance("Zone 1.2")("Blackwing Lair"),
	enabletrigger = bboss("Ebonroc"),
	bossname = bboss("Ebonroc"),

	toggleoptions = {
		notWingBuffet = "Warn for Wing Buffet",
		notShadowFlame = "Warn for Shadow Flame",
		notYouCruse = "Warn when you got Shadow of Ebonroc",
		notElseCruse = "Warn when others got Shadow of Ebonroc",
		notBosskill = "Boss death",
	},
	optionorder = {"notWingBuffet", "notShadowFlame", "notYouCruse", "notElseCruse", "notBosskill"},

	loc = GetLocale() == "koKR" and {
		disabletrigger = "에본로크|1이;가; 죽었습니다.",

		trigger1 = "에본로크|1이;가; 폭풍 날개|1을;를; 시전합니다.",
		trigger2 = "에본로크|1이;가; 암흑의 불길|1을;를; 시전합니다.",
		trigger3 = "(.*)에본로크의 그림자에 걸렸습니다.",

		you = "",
		are = "are",
		whopattern = "(.+)|1이;가; ",

		warn1 = "에본로크가 폭풍 날개를 시전합니다!",
		warn2 = "30초후 폭풍 날개!",
		warn3 = "3초후 폭풍 날개!",
		warn4 = "암흑의 불길 경고!",
		warn5 = "당신은 에본로크의 그림자에 걸렸습니다!",
		warn6 = "님이 에본로크의 그림자에 걸렸습니다!",
		bosskill = "에본로크를 물리쳤습니다!",

		bar1text = "폭풍 날개",
	}
		or GetLocale() == "deDE" and
	{
		disabletrigger = "Schattenschwinge stirbt.",

		trigger1 = "Schattenschwinge beginnt Fl\195\188gelsto\195\159 zu wirken.",
		trigger2 = "Schattenschwinge beginnt Schattenflamme zu wirken.",
		trigger3 = "^([^%s]+) ([^%s]+) betroffen von Schattenschwinges Schatten",

		you = "Ihr",
		are = "seid",

		warn1 = "Schattenschwinge beginnt Fl\195\188gelsto\195\159 zu wirken!",
		warn2 = "30 Sekunden bis zum n\195\164chsten Fl\195\188gelsto\195\159!",
		warn3 = "3 Sekunden bis Schattenschwinge Fl\195\188gelsto\195\159 zaubert!",
		warn4 = "Schattenflamme kommt!",
		warn5 = "Du hast Schattenschwinges Schatten!",
		warn6 = " hat Schattenschwinges Schatten!",
		bosskill = "Schattenschwinge wurde besiegt!",

		bar1text = "Fluegelgelstoss",
	}
		or GetLocale() == "zhCN" and
	{
		disabletrigger = "埃博诺克死亡了。",

		trigger1 = "埃博诺克开始施放龙翼打击。",
		trigger2 = "埃博诺克开始施放暗影烈焰。",
		trigger3 = "^(.+)受(.+)了埃博诺克之影",

		you = "你",
		are = "到",

		warn1 = "埃博诺克开始施放龙翼打击！",
		warn2 = "龙翼打击 - 30秒后再次发动",
		warn3 = "3秒后发动龙翼打击！",
		warn4 = "暗影烈焰发动！",
		warn5 = "你中了埃博诺克之影！",
		warn6 = "中了埃博诺克之影！",
		bosskill = "埃博诺克被击败了！",

		bar1text = "龙翼打击",
	}
		or
	{
		disabletrigger = "Ebonroc dies.",

		trigger1 = "Ebonroc begins to cast Wing Buffet",
		trigger2 = "Ebonroc begins to cast Shadow Flame.",
		trigger3 = "^([^%s]+) ([^%s]+) afflicted by Shadow of Ebonroc",

		you = "You",
		are = "are",

		warn1 = "Ebonroc begins to cast Wing Buffet!",
		warn2 = "30 seconds till next Wing Buffet!",
		warn3 = "3 seconds before Ebonroc casts Wing Buffet!",
		warn4 = "Shadow Flame incoming!",
		warn5 = "You have Shadow of Ebonroc!",
		warn6 = " has Shadow of Ebonroc!",
		bosskill = "Ebonroc has been defeated!",

		bar1text = "Wing Buffet",
	},
})

function BigWigsEbonroc:Initialize()
	self.disabled = true
	self:TriggerEvent("BIGWIGS_REGISTER_MODULE", self)
end

function BigWigsEbonroc:Enable()
	self.disabled = nil
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	self:RegisterEvent("BIGWIGS_MESSAGE")
	self:TriggerEvent("BIGWIGS_SYNC_THROTTLE", "EBONROC_WING_BUFFET", 10)
end

function BigWigsEbonroc:Disable()
	self.disabled = true
	self:UnregisterAllEvents()
	self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.bar1text)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.warn3)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.bar2text, 10)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.bar2text, 20)
end

function BigWigsEbonroc:CHAT_MSG_COMBAT_HOSTILE_DEATH()
	if (arg1 == self.loc.disabletrigger) then
		if (not self:GetOpt("notBosskill")) then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green", nil, "Victory") end
		self:Disable()
	end
end

function BigWigsEbonroc:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE()
	if (string.find(arg1, self.loc.trigger1)) then
		self:TriggerEvent("BIGWIGS_SYNC_SEND", "EBONROC_WING_BUFFET")
	elseif (arg1 == self.loc.trigger2 and not self:GetOpt("notShadowFlame")) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn4, "Red")
	end
end

function BigWigsEbonroc:EBONROC_WING_BUFFET()
	if (not self:GetOpt("notWingBuffet")) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn1, "Red")
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn2, "Yellow")
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.warn3, 29, "Red")
		self:TriggerEvent("BIGWIGS_BAR_START", self.loc.bar1text, 32, 1, "Yellow", "Interface\\Icons\\Spell_Fire_SelfDestruct")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.bar1text, 10, "Orange")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.bar1text, 20, "Red")
	end
end

if (GetLocale() == "koKR") then
	function BigWigsEbonroc:Event()
		local _,_, EPlayer = string.find(arg1, self.loc.trigger3)
		if (EPlayer) then
			if (EPlayer == self.loc.you and not self:GetOpt("notYouCruse")) then
				self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn5, "Red", true)
			elseif (not self:GetOpt("notElseCruse")) then 
				local _,_, EWho = string.find(EPlayer, self.loc.whopattern)
				self:TriggerEvent("BIGWIGS_MESSAGE", EWho .. self.loc.warn6, "Yellow")
				self:TriggerEvent("BIGWIGS_SENDTELL", EWho, self.loc.warn5)
			end
		end
	end
else
	function BigWigsEbonroc:Event()
		local _,_, EPlayer, EType = string.find(arg1, self.loc.trigger3)
		if (EPlayer and EType) then
			if (EPlayer == self.loc.you and EType == self.loc.are and not self:GetOpt("notYouCruse")) then
				self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn5, "Red", true)
			elseif (not self:GetOpt("notElseCruse")) then 
				self:TriggerEvent("BIGWIGS_MESSAGE", EPlayer .. self.loc.warn6, "Yellow")
				self:TriggerEvent("BIGWIGS_SENDTELL", EPlayer, self.loc.warn5)
			end
		end
	end
end
--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsEbonroc:RegisterForLoad()