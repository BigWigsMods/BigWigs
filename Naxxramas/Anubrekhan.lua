local bboss = BabbleLib:GetInstance("Boss 1.2")
local metro = Metrognome:GetInstance("1")

BigWigsAnubrekhan = AceAddon:new({
	name          = "BigWigsAnubrekhan",
	cmd           = AceChatCmd:new({}, {}),

	zonename = BabbleLib:GetInstance("Zone 1.2")("Naxxramas"),
	enabletrigger = bboss("Anub'Rekhan"),
	bossname = bboss("Anub'Rekhan"),

	toggleoptions = GetLocale() == "koKR" and {
		notSwarmWarn = "메뚜기 떼 종료 알림",
		notLocustInc = "다음 메뚜기 떼 경고",
		notSwarmBar = "메뚜기 떼 종료 타이머 바 보이기",
		notLocustIncBar = "다음 메뚜기 떼 타이머 바 보이기",
		notBosskill = "보스 사망 알림",
	} or {
		notSwarmWarn = "Warn when the current Locust Swarm ends",
		notLocustInc = "Warn for the incoming Locust Swarm",
		notSwarmBar = "Show the Time Bar of the current Locust Swarm",
		notLocustIncBar = "Show the Time Bar for the incoming Locust Swarm",
		notBosskill = "Boss death",
	},
	optionorder = {"notLocustInc", "notLocustIncBar", "notSwarmWarn", "notSwarmBar", "notBosskill"},

	loc = GetLocale() == "koKR" and { 
		disabletrigger = "아눕레칸|1이;가; 죽었습니다.",
		bosskill = "아눕레칸을 물리쳤습니다!",

		starttrigger1 = "어디 맛 좀 볼까...",
		starttrigger2 = "그래, 도망쳐! 더 신선한 피가 솟구칠 테니!",
		starttrigger3 = "나가는 길은 없다.",
		engagewarn = "아눕레칸 격노. 대략 90초후 첫번째 메뚜기 떼.",
				
		gaintrigger = "아눕레칸|1이;가; 메뚜기 떼 효과를 얻었습니다.",
		gainendwarn = "메뚜기 떼 종료!",
		gainnextwarn = "다음 메뚜기 떼 대략 95초후.",
		gainwarn10sec = "10초후 메뚜기 떼",
		gainincbar = "다음 메뚜기 떼",
		gainbar = "메뚜기 떼",				
		 
		casttrigger = "아눕레칸|1이;가; 메뚜기 떼|1을;를; 시전합니다.",
		castwarn = "메뚜기 떼 소환!",
	} or GetLocale() == "deDE" and { 
		disabletrigger = "Anub'Rekhan stirbt.",		
		bosskill = "Anub'Rekhan ist besiegt!",

		starttrigger1 = "Nur einmal kosten...",
		starttrigger2 = "Rennt! Das bringt das Blut in Wallung!",
		starttrigger3 = "Es gibt kein Entkommen.",
		engagewarn = "Heuschreckenschwarm in ca. 90 s.",
		
		gaintrigger = "Anub'Rekhan bekommt Heuschreckenschwarm.",
		gainendwarn = "Heuschreckenschwarm beendet!",
		gainnextwarn = "N\195\164chster Schwarm in ca. 90 s.",
		gainwarn10sec = "10 s BIS SCHWARM",
		gainincbar = "Schwarm",
		gainbar = "Heuschreckenschwarm",
		
		casttrigger = "Anub'Rekhan beginnt Heuschreckenschwarm zu wirken.",
		castwarn = "SCHWARM incoming!",
	} or {
		disabletrigger = "Anub'Rekhan dies.",		
		bosskill = "Anub'Rekhan has been defeated!",

		starttrigger1 = "Just a little taste...",
		starttrigger2 = "Yes, run! It makes the blood pump faster!",
		starttrigger3 = "There is no way out.",
		engagewarn = "Anub'Rekhan engaged. First Locust Swarm in about 90 seconds.",
		
		gaintrigger = "Anub'Rekhan gains Locust Swarm.",
		gainendwarn = "Locust Swarm ended!",
		gainnextwarn = "Next Locust Swarm in about 90 seconds.",
		gainwarn10sec = "10 Seconds until Locust Swarm",
		gainincbar = "Next Locust Swarm",
		gainbar = "Locust Swarm",
		
		casttrigger = "Anub'Rekhan begins to cast Locust Swarm.",
		castwarn = "Incoming Locust Swarm!",
	},
})

function BigWigsAnubrekhan:Initialize()
	self.disabled = true
	self:TriggerEvent("BIGWIGS_REGISTER_MODULE", self)
end

function BigWigsAnubrekhan:Enable()
	self.disabled = nil
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	self:RegisterEvent("BIGWIGS_SYNC_LOCUSTINC")
	self:RegisterEvent("BIGWIGS_SYNC_LOCUSTSWARM")
	self:TriggerEvent("BIGWIGS_SYNC_THROTTLE", "LOCUSTINC", 10)
	self:TriggerEvent("BIGWIGS_SYNC_THROTTLE", "LOCUSTSWARM", 10)
	metro:Register("BigWigs AnubRekhan LocustInc", self.BIGWIGS_SYNC_LOCUSTSWARM, 3.25, self)
end

function BigWigsAnubrekhan:Disable()
	self.disabled = true
	self:UnregisterAllEvents()
	metro:Unregister("BigWigs AnubRekhan LocustInc")
	self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.gainincbar)
	self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.gainbar)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.gainendwarn)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.gainwarn10sec)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.gainbar, 5)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.gainbar, 10)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.gainincbar, 65)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.gainincbar, 80)
end


function BigWigsAnubrekhan:CHAT_MSG_COMBAT_HOSTILE_DEATH()
	if (arg1 == self.loc.disabletrigger) then
		if (not self:GetOpt("notBosskill")) then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green", nil, "Victory") end
		self:Disable()
	end
end

function BigWigsAnubrekhan:CHAT_MSG_MONSTER_YELL()
	if (arg1 == self.loc.starttrigger1 or arg1 == self.loc.starttrigger2 or arg1 == self.loc.starttrigger3) then
		if (not self:GetOpt("notLocustInc")) then 
			self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.engagewarn, "Orange")
			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.gainwarn10sec, 80, "Red")
		end
		if (not self:GetOpt("notLocustIncBar")) then 
			self:TriggerEvent("BIGWIGS_BAR_START", self.loc.gainincbar, 90, 1, "Yellow", "Interface\\Icons\\Spell_Nature_InsectSwarm")
			self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.gainincbar, 65, "Orange")
			self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.gainincbar, 80, "Red")
		end
	end
end

function BigWigsAnubrekhan:BIGWIGS_SYNC_LOCUSTSWARM()
	metro:Stop("BigWigs AnubRekhan LocustInc")
	if (not self:GetOpt("notSwarmWarn")) then self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.gainendwarn, 20, "Red") end
	if (not self:GetOpt("notSwarmBar")) then 
		self:TriggerEvent("BIGWIGS_BAR_START", self.loc.gainbar, 20, 2, "Yellow", "Interface\\Icons\\Spell_Nature_InsectSwarm")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.gainbar, 10, "Orange")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.gainbar, 5, "Red")
	end
	if (not self:GetOpt("notLocustInc")) then 
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.gainnextwarn, "Orange")
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.gainwarn10sec, 80, "Red")
	end
	if (not self:GetOpt("notLocustIncBar")) then 
		self:TriggerEvent("BIGWIGS_BAR_START", self.loc.gainincbar, 90, 1, "Yellow", "Interface\\Icons\\Spell_Nature_InsectSwarm")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.gainincbar, 65, "Orange")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.gainincbar, 80, "Red")
	end
end

function BigWigsAnubrekhan:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS()
	if (arg1 == self.loc.gaintrigger) then
		self:TriggerEvent("BIGWIGS_SYNC_SEND", "LOCUSTSWARM")
	end
end

function BigWigsAnubrekhan:BIGWIGS_SYNC_LOCUSTINC()
	metro:Start("BigWigs AnubRekhan LocustInc", 1)
	if (not self:GetOpt("notLocustInc")) then 
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.castwarn, "Orange")
	end
end

function BigWigsAnubrekhan:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF()
	if (arg1 == self.loc.casttrigger) then
		self:TriggerEvent("BIGWIGS_SYNC_SEND", "LOCUSTINC")
	end
end
--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsAnubrekhan:RegisterForLoad()