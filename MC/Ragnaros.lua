BigWigsRagnaros = AceAddon:new({
	name          = "BigWigsRagnaros",
	cmd           = AceChatCmd:new({}, {}),

	zonename = "MC",
	enabletrigger = GetLocale() == "koKR" and "라그나로스"
		or GetLocale() == "zhCN" and "拉格纳罗斯"
		or "Ragnaros",

	loc = GetLocale() == "deDE" and 
	{ 
		bossname = "Ragnaros",
		disabletrigger = "Ragnaros stirbt.",

		trigger1 = "^SP\195\156RT",
		trigger2 = "^VORW\195\134RTS,",
		trigger3 = "^UND JETZT ZU EUCH,",

		warn1 = "AoE Knockback!",
		warn2 = "5 Sekunden bis AoE Knockback!",
		warn3 = "Ragnaros ist f\105\188r 90 Sekunden untergetaucht. S\195\162hne der Flamme kommen!",
		warn4 = "15 Sekunden bis Ragnaros auftaucht!",
		warn5 = "Ragnaros ist aufgetaucht. 3 Minuten bis zum Untertuachen!",
		warn6 = "60 Sekunden bis Ragnaros untertaucht & S\195\162hne der Flamme!",
		warn7 = "20 Sekunden bis Ragnaros untertaucht & S\195\162hne der Flamme!",
		bosskill = "Ragnaros wurde besiegt!",

		bar1text = "AoE Knockback",
		bar2text = "Auftauchen Ragnaros",
		bar3text = "Untertauchen Ragnaros",
	}
		or GetLocale() == "koKR" and 
	{	
		bossname = "라그나로스",
		disabletrigger = "라그나로스|1이;가; 죽었습니다.",

		trigger1 = "설퍼론의 유황",
		trigger2 = "이제 너희,",
		trigger3 = "나의 종들아,",

		warn1 = "광역 튕겨냄!",
		warn2 = "5초후 광역 튕겨냄!",
		warn3 = "90초간 라그나로스 사라짐. 피조물 등장!",
		warn4 = "15초후 라고나로스 재등장!",
		warn5 = "라그나로스가 등장했습니다. 3분후 피조물 등장!",
		warn6 = "60초후 피조물 등장 & 라그나로스 사라짐!",
		warn7 = "20초후 피조물 등장 & 라그라로스 사라짐!",
		bosskill = "라고르나로스를 물리쳤습니다!",

		bar1text = "광역 튕겨냄",
		bar2text = "라그나로스 등장",
		bar3text = "피조물 등장",
	} 
		or GetLocale() == "zhCN" and
	{
		bossname = "拉格纳罗斯",
		disabletrigger = "拉格纳罗斯死亡了。",

		trigger1 = "^尝尝萨弗隆的火焰吧",
		trigger2 = "^出现吧，我的奴仆",
		trigger3 = "^现在轮到你们了",

		warn1 = "群体击退！",
		warn2 = "5秒后发动群体击退！",
		warn3 = "拉格纳罗斯消失90秒。烈焰之子出现！",
		warn4 = "15秒后拉格纳罗斯重新出现！",
		warn5 = "拉格纳罗斯已经激活，将在3分钟后暂时消失并召唤烈焰之子！",
		warn6 = "60秒后拉格纳罗斯将暂时消失并召唤烈焰之子！",
		warn7 = "20秒后拉格纳罗斯将暂时消失并召唤烈焰之子！",
		bosskill = "拉格纳罗斯被击败了！",

		bar1text = "群体击退",
		bar2text = "拉格纳罗斯出现",
		bar3text = "拉格纳罗斯消失",
	}
		or 
	{
		bossname = "Ragnaros",
		disabletrigger = "Ragnaros dies.",

		trigger1 = "^TASTE",
		trigger2 = "^COME FORTH,",
		trigger3 = "^NOW FOR YOU,",

		warn1 = "AoE Knockback!",
		warn2 = "5 seconds until AoE Knockback!",
		warn3 = "Ragnaros Down for 90 Seconds. Incoming Sons of Flame!",
		warn4 = "15 seconds until Ragnaros emerges!",
		warn5 = "Ragnaros has emerged. 3 minutes until submerge!",
		warn6 = "60 seconds until Ragnaros submerge & Sons of Flame!",
		warn7 = "20 seconds until Ragnaros submerge & Sons of Flame!",
		bosskill = "Ragnaros has been defeated!",

		bar1text = "AoE Knockback",
		bar2text = "Ragnaros emerge",
		bar3text = "Ragnaros submerge",
	},
})

function BigWigsRagnaros:Initialize()
	self.disabled = true
	BigWigs:RegisterModule(self)
end

function BigWigsRagnaros:Enable()
	self.disabled = nil
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_PARTY_HITS", "Event")
	self:RegisterEvent("CHAT_MSG_COMBAT_FRIENDLYPLAYER_HITS", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PET_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PARTY_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_FRIENDLYPLAYER_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
end

function BigWigsRagnaros:Disable()
	self.disabled = true
	self:UnregisterAllEvents()
	self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.bar1text)
	self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.bar2text)
	self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.bar3text)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.warn2)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.warn4)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.warn6)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.warn7)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.bar1text, 10)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.bar1text, 20)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.bar2text, 30)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.bar2text, 60)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.bar3text, 60)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.bar3text, 120)
	Timex:DeleteSchedule("BigWigsRagnarosEmerge")
end

function BigWigsRagnaros:CHAT_MSG_COMBAT_HOSTILE_DEATH()
	if (arg1 == self.loc.disabletrigger) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green")
		self:Disable()
	end
end

function BigWigsRagnaros:CHAT_MSG_MONSTER_YELL()
	if string.find(arg1, self.loc.trigger1) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn1, "Red")
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.warn2, 23, "Red")
		self:TriggerEvent("BIGWIGS_BAR_START", self.loc.bar1text, 28, 1, "Yellow", "Interface\\Icons\\Spell_Fire_SoulBurn")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.bar1text, 10, "Orange")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.bar1text, 20, "Red")
		self:ResetResetTimer()
	elseif string.find(arg1, self.loc.trigger2) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn3, "Red")
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.warn4, 75, "Red")
		self:TriggerEvent("BIGWIGS_BAR_START", self.loc.bar2text, 90, 2, "Yellow", "Interface\\Icons\\Spell_Fire_Volcano")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.bar2text, 30, "Orange")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.bar2text, 60, "Red")
		Timex:AddSchedule("BigWigsRagnarosEmerge", 90, false, 1, self.Emerge, self)
		self:ResetResetTimer()
	elseif string.find(arg1, self.loc.trigger3) then
		self:Emerge()
	end
end

function BigWigsRagnaros:Emerge()
	self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn5, "Yellow")
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.warn6, 120, "Red")
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.warn7, 160, "Red")
	self:TriggerEvent("BIGWIGS_BAR_START", self.loc.bar3text, 180, 3, "Yellow", "Interface\\Icons\\Spell_Fire_SelfDestruct")
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.bar3text, 60, "Orange")
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.bar3text, 120, "Red")
	self:ResetResetTimer()
end

function BigWigsRagnaros:Event()
	if (string.find(arg1, self.loc.bossname)) then
		if (not Timex:ScheduleCheck("BigWigsRagnarosReset")) then
			self:Emerge()
			Timex:AddSchedule("BigWigsRagnarosReset", 90, false, 1, function() Timex:DeleteNamedSchedule("BigWigsRagnarosEmerge") end)
		else
			self:ResetResetTimer()
		end
	end
end

function BigWigsRagnaros:ResetResetTimer()
	Timex:DeleteSchedule("BigWigsRagnarosReset")
	Timex:AddSchedule("BigWigsRagnarosReset", 95, false, 1, self.Reset, self)
end
--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsRagnaros:RegisterForLoad()