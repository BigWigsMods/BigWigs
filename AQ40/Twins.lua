local Metro = Metrognome:GetInstance("1")
local bboss = BabbleLib:GetInstance("Boss 1.2")

BigWigsTwins = AceAddon:new({
	name          = "BigWigsTwins",
	cmd           = AceChatCmd:new({}, {}),

	zonename = BabbleLib:GetInstance("Zone 1.2")("Ahn'Qiraj"),
	veklor = bboss("Emperor Vek'lor"),
	veknilash = bboss("Emperor Vek'nilash"),
	enabletrigger = {bboss("Emperor Vek'lor"), bboss("Emperor Vek'nilash")},
	bossname = GetLocale() == "koKR" 
		and format("쌍둥이 황제 - %s and %s", bboss("Emperor Vek'lor"), bboss("Emperor Vek'nilash"))
		or format("The Twin Emperors - %s and %s", bboss("Emperor Vek'lor"), bboss("Emperor Vek'nilash")),

	toggleoptions = GetLocale() == "koKR" and {
		notTeleport = "순간이동 경고",
		notEnrage = "쌍둥이 격노 경고",
		notBug = "벌레 폭발 경고",
		notBosskill = "보스 사망 알림",
	} or {
		notTeleport = "Warn for Teleport",
		notEnrage = "Warn when the Twins become enraged",
		notBug = "Warn for exploding bugs",
		notBosskill = "Boss death",
	},
	optionorder = {"notTeleport", "notEnrage", "notBug", "notBosskill"},

	loc = GetLocale() == "koKR" and {
		disabletrigger = "|1이;가; 죽었습니다.",
		bosskill = "쌍둥이 제왕을 물리쳤습니다!",

		porttrigger = "(.+)|1이;가; 쌍둥이 순간이동|1을;를; 시전합니다.",
		portwarn = "순간 이동!",
		portdelaywarn = "5초후 순간 이동!",
		bartext = "순간 이동",
		explodebugtrigger = "(.+)|1이;가; 벌레 폭발 효과를 얻었습니다.",
		explodebugwarn = "벌레 폭발!",
		enragetrigger = "becomes enraged.",
		enragewarn = "Twins are Enraged",			
		healtrigger1 = "(.+)|1이;가; 형제 치유|1을;를; 시전합니다.",
		healtrigger2 = "(.+)|1이;가; 형제 치유|1을;를; 시전합니다.",
		healwarn = "형제치유 시전중 - 쌍둥이 분리!",
		startwarn = "Twin Emperors Engaged! Enrage in 15 minutes!",
		enragebartext = "Enrage",
		warn1 = "Enrage in 10 minutes",
		warn2 = "Enrage in 5 minutes",
		warn3 = "Enrage in 3 minutes",
		warn4 = "Enrage in 90 seconds",
		warn5 = "Enrage in 60 seconds",
		warn6 = "Enrage in 30 seconds",
		warn7 = "Enrage in 10 seconds",
	}
		or GetLocale() == "zhCN" and
	{
		disabletrigger = "死亡了。",
		bosskill = "双子皇帝被击败了！",

		porttrigger = "施放了双子传送。",
		portwarn = "双子传送发动！",
		portdelaywarn = "5秒后发动双子传送！",
		bartext = "双子传送",
		explodebugtrigger = "获得了爆炸虫的效果。$",
		explodebugwarn = "爆炸虫即将出现！",
		enragetrigger = "获得了激怒的效果。",
		enragewarn = "双子皇帝获得了激怒的效果！",
		healtrigger1 = "的治疗兄弟为",
		healtrigger2 = "的治疗兄弟为",
		healwarn = "正在施放治疗兄弟 - 快将他们分开！",
		startwarn = "双子皇帝已激活 - 15分钟后进入激怒状态",
		enragebartext = "激怒",
		warn1 = "10分钟后激怒",
		warn2 = "5分钟后激怒",
		warn3 = "3分钟后激怒",
		warn4 = "90秒后激怒",
		warn5 = "60秒后激怒",
		warn6 = "30秒后激怒",
		warn7 = "10秒后激怒",
	}
		or
	{
		disabletrigger = " dies.",
		bosskill = "Twin Emperors have been defeated!",

		porttrigger = "casts Twin Teleport.",
		portwarn = "Teleport!",
		portdelaywarn = "Teleport in 5 seconds!",
		bartext = "Teleport",
		explodebugtrigger = "gains Explode Bug%.$",
		explodebugwarn = "Bug Exploding Nearby!",
		enragetrigger = "becomes enraged.",
		enragewarn = "Twins are Enraged",
		healtrigger1 = "'s Heal Brother heals",
		healtrigger2 = " Heal Brother heals",
		healwarn = "Casting Heal Brother - Separate them fast!",
		startwarn = "Twin Emperors Engaged! Enrage in 15 minutes!",
		enragebartext = "Enrage",
		warn1 = "Enrage in 10 minutes",
		warn2 = "Enrage in 5 minutes",
		warn3 = "Enrage in 3 minutes",
		warn4 = "Enrage in 90 seconds",
		warn5 = "Enrage in 60 seconds",
		warn6 = "Enrage in 30 seconds",
		warn7 = "Enrage in 10 seconds",
	},
})

function BigWigsTwins:Initialize()
	self.disabled = true
	self:TriggerEvent("BIGWIGS_REGISTER_MODULE", self)
end

function BigWigsTwins:Enable()
	self.disabled = nil
	self.enrageStarted = nil
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	self:RegisterEvent("PLAYER_REGEN_DISABLED")
	self:RegisterEvent("BIGWIGS_SYNC_TWINSENRAGE")
	self:RegisterEvent("BIGWIGS_SYNC_TWINSTELEPORT")
	self:TriggerEvent("BIGWIGS_SYNC_THROTTLE", "TWINSENRAGE", 10)
	self:TriggerEvent("BIGWIGS_SYNC_THROTTLE", "TWINSTELEPORT", 10)
	Metro:Register("BigWigs_Twins_CheckWipe", self.PLAYER_REGEN_ENABLED, 2, self)
end

function BigWigsTwins:Disable()
	self.disabled = true
	self.enrageStarted = nil
	self:UnregisterAllEvents()
	self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.bartext)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.portdelaywarn)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.bartext, 10)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.bartext, 20)
	self:StopEnrage()
end

function BigWigsTwins:PLAYER_REGEN_DISABLED()
	local go = self:Scan()
	if (go) then
		-- Now fires off the SYNC event as recommended by Tekkub
		self:StartEnrage()
		self:TriggerEvent("BIGWIGS_SYNC_SEND", "TWINSENRAGE")
	end
end

function BigWigsTwins:PLAYER_REGEN_ENABLED()
	local go = self:Scan()
	local _,_,running,_ = Metro:Status("BigWigs_Twins_CheckWipe")
	if (not go) then
		self:StopEnrage()
		Metro:Stop("BigWigs_Twins_CheckWipe")
	elseif (not running) then
		Metro:Start("BigWigs_Twins_CheckWipe")
	end
end

function BigWigsTwins:Scan()
	if (UnitName("target") == (self.veklor or self.veknilash) and UnitAffectingCombat("target")) then
		return true
	elseif (UnitName("playertarget") == (self.veklor or self.veknilash) and UnitAffectingCombat("playertarget")) then
		return true
	else
		local i
		for i = 1, GetNumRaidMembers(), 1 do
			if (UnitName("Raid"..i.."target") == (self.veklor or self.veknilash) and UnitAffectingCombat("Raid"..i.."target")) then
				return true
			end
		end
	end
	return false
end

function BigWigsTwins:StartEnrage()
	if (not self:GetOpt("notEnrage")) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.startwarn, "Red")
		self:TriggerEvent("BIGWIGS_BAR_START", self.loc.enragebartext, 900, 2, "Green", "Interface\\Icons\\Spell_Shadow_UnholyFrenzy")
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.warn1, 300, "Green")
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.warn2, 600, "Yellow")
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.warn3, 720, "Yellow")
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.warn4, 810, "Orange")
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.warn5, 840, "Orange")
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.warn6, 870, "Red")
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.warn7, 890, "Red")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR", self.loc.enragebartext, 580, "Yellow")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR", self.loc.enragebartext, 790, "Orange")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR", self.loc.enragebartext, 870, "Red")
	end
	self.enrageStarted = true
end

function BigWigsTwins:StopEnrage()
	self.enrageStarted = nil
	self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.enragebartext)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.warn1)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.warn2)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.warn3)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.warn4)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.warn5)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.warn6)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.warn7)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.enragebartext, 580)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.enragebartext, 790)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.enragebartext, 870)
end

function BigWigsTwins:CHAT_MSG_COMBAT_HOSTILE_DEATH()
    if (arg1 == self.veklor .. self.loc.disabletrigger or arg1 == self.veknilash .. self.loc.disabletrigger) then
        if (not self:GetOpt("notBosskill")) then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green", nil, "Victory") end
        self:Disable()
    end
end

function BigWigsTwins:BIGWIGS_SYNC_TWINSTELEPORT()
	if (not self:GetOpt("notTeleport")) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.portwarn, "Yellow")
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.portdelaywarn, 25, "Red")
		self:TriggerEvent("BIGWIGS_BAR_START", self.loc.bartext, 30, 1, "Yellow", "Interface\\Icons\\Spell_Arcane_Blink")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.bartext, 10, "Orange")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.bartext, 20, "Red")
	end
end

function BigWigsTwins:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE()
	if (string.find(arg1, self.loc.porttrigger)) then
		self:TriggerEvent("BIGWIGS_SYNC_SEND", "TWINSTELEPORT")
	end
end

function BigWigsTwins:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS()
	if (string.find(arg1, self.loc.explodebugtrigger) and not self:GetOpt("notBug")) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.explodebugwarn, "Red", true)
	end
end

function BigWigsTwins:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF()
	if ((string.find(arg1, self.loc.healtrigger1) or string.find(arg1, self.loc.healtrigger2)) and not self.prior) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.healwarn, "Red")
		self.prior = true
		Timex:AddNamedSchedule("BigWigsTwinsHealReset", 10, false, 1, function() BigWigsTwins.prior = nil end)
	end
end

function BigWigsTwins:CHAT_MSG_MONSTER_EMOTE()
	if (string.find(arg1, self.loc.enragetrigger) and not self:GetOpt("notEnrage")) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.enragewarn, "Red")
	end
end

function BigWigsTwins:BIGWIGS_SYNC_TWINSENRAGE()
	if (not self.enrageStarted) then
		self:StartEnrage()
	end
end
--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsTwins:RegisterForLoad()