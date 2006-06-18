BigWigsTwins = AceAddon:new({
	name          = "BigWigsTwins",
	cmd           = AceChatCmd:new({}, {}),

	zonename = "AQ40",
	enabletrigger = GetLocale() == "koKR" and {"제왕 베클로어", "제왕 베크닐라쉬"}
		or GetLocale() == "zhCN" and {"维克洛尔大帝", "维克尼拉斯大帝"}
		or {"Emperor Vek'lor", "Emperor Vek'nilash"},

	loc = GetLocale() == "koKR" and {
		bossname = "쌍둥이 제왕 - 제왕 베클로어, 제왕 베크닐라쉬",
		veklor = "제왕 베클로어",
		veknilash = "제왕 베크닐라쉬",
		disabletrigger = "|1이;가; 죽었습니다.",
		bosskill = "쌍둥이 제왕을 물리쳤습니다!",

		porttrigger = "(.+)|1이;가; 쌍둥이 순간이동|1을;를; 시전합니다.",
		portwarn = "순간 이동!",
		portdelaywarn = "5초후 순간 이동!",
		bartext = "순간 이동",
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
	}
		or GetLocale() == "zhCN" and
	{
		bossname = "双子皇帝 - 维克洛尔大帝与维克尼拉斯大帝",
		veklor = "维克洛尔大帝",
		veknilash = "维克尼拉斯大帝",
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
		bossname = "Twin Emperors - Emperor Vek'lor and Emperor Vek'nilash",
		veklor = "Emperor Vek'lor",
		veknilash = "Emperor Vek'nilash",
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
	BigWigs:RegisterModule(self)
end

function BigWigsTwins:Enable()
	self.disabled = nil
	self.enrageStarted = nil
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	self:RegisterEvent("PLAYER_REGEN_DISABLED")
	self:RegisterEvent("CHAT_MSG_COMBAT_FRIENDLY_DEATH", "PLAYER_REGEN_ENABLED")
	self:RegisterEvent("BIGWIGS_SYNC_TWINSENRAGE")
	self:RegisterEvent("BIGWIGS_SYNC_TWINSTELEPORT")
	self:TriggerEvent("BIGWIGS_SYNC_THROTTLE", "TWINSENRAGE", 10 )
	self:TriggerEvent("BIGWIGS_SYNC_THROTTLE", "TWINSTELEPORT", 10 )
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
	if (not go) then
		self:StopEnrage()
	end
end

function BigWigsTwins:Scan()
	if (UnitName("target") == (self.loc.veklor or self.loc.veknilash) and UnitAffectingCombat("target")) then
		return true
	elseif (UnitName("playertarget") == (self.loc.veklor or self.loc.veknilash) and UnitAffectingCombat("playertarget")) then
		return true
	else
		local i
		for i = 1, GetNumRaidMembers(), 1 do
			if (UnitName("Raid"..i.."target") == (self.loc.veklor or self.loc.veknilash) and UnitAffectingCombat("Raid"..i.."target")) then
				return true
			end
		end
	end
	return false
end

function BigWigsTwins:StartEnrage()
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
    if (arg1 == self.loc.veklor .. self.loc.disabletrigger or arg1 == self.loc.veknilash .. self.loc.disabletrigger) then
        self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green", nil, "Victory")
        self:Disable()
    end
end

function BigWigsTwins:BIGWIGS_SYNC_TWINSTELEPORT(rest, nick)
	self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.portwarn, "Yellow")
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.portdelaywarn, 25, "Red")
	self:TriggerEvent("BIGWIGS_BAR_START", self.loc.bartext, 30, 1, "Yellow", "Interface\\Icons\\Spell_Arcane_Blink")
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.bartext, 10, "Orange")
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.bartext, 20, "Red")
end

function BigWigsTwins:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE()
	if (string.find(arg1, self.loc.porttrigger)) then
		self:TriggerEvent("BIGWIGS_SYNC_SEND", "TWINSTELEPORT")
	end
end

function BigWigsTwins:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS()
	if (string.find(arg1, self.loc.explodebugtrigger)) then
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
	if (string.find(arg1, self.loc.enragetrigger)) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.enragewarn, "Red")
	end
end

function BigWigsTwins:BIGWIGS_SYNC_TWINSENRAGE(rest, nick)
	if( not self.enrageStarted ) then
		self:StartEnrage()
	end
end
--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsTwins:RegisterForLoad()
