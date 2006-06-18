BigWigsOuro = AceAddon:new({
	name          = "BigWigsOuro",
	cmd           = AceChatCmd:new({}, {}),

	zonename = "AQ40",
	enabletrigger = GetLocale() == "koKR" and "아우로"
		or GetLocale() == "zhCN" and "奥罗"
		or "Ouro",

	loc = GetLocale() == "koKR" and {
		bossname = "아우로",
		disabletrigger = "아우로|1이;가; 죽었습니다.",

		sweeptrigger = "아우로|1이;가; 휩쓸기|1을;를; 시전합니다.",
		sweepannounce = "휩쓸기!",
		sweepwarn = "5초후 휩쓸기! 대피",
		sweepbartext = "휩쓸기",

		sandblasttrigger = "아우로|1이;가; 모래 돌풍|1을;를; 시전합니다.",
		sandblastannounce = "모래 돌풍 경보!",
		sandblastwarn = "5초후 모래 돌풍",
		sandblastbartext = "모래 돌풍",

		emergetrigger = "흙더미|1이;가; 아우로 스카라베 소환|1을;를; 시전합니다.",
		emergeannounce = "아우로 등장! 벌레들 제거!",
		emergewarn1 = "15초후 아우로 잠수!",
		emergebartext = "아우로 잠수",

		berserksoonwarn = "광폭화 예고 - 준비하세요!",
		bosskill = "아우로를 물리쳤습니다!",
	}
		or GetLocale() == "zhCN" and
	{
		bossname = "奥罗",
		disabletrigger = "奥罗死亡了。",

		sweeptrigger = "奥罗开始施放横扫。",
		sweepannounce = "横扫发动！",
		sweepwarn = "5秒后发动横扫！快退！",
		sweepbartext = "横扫",

		sandblasttrigger = "奥罗开始施展沙尘爆裂。",
		sandblastannounce = "沙尘爆裂发动！",
		sandblastwarn = "5秒后发动沙尘爆裂！",
		sandblastbartext = "沙尘爆裂",

		emergetrigger = "土堆施放了召唤奥罗甲虫。",
		emergeannounce = "奥罗潜入地下！杀光虫子！",
		emergewarn1 = "15秒后奥罗将钻出地面！",
		emergebartext = "奥罗钻出地面",

		berserksoonwarn = "即将狂暴 - 做好准备！",
		bosskill = "奥罗被击败了！",
	}
		or
	{
		bossname = "Ouro",
		disabletrigger = "Ouro dies.",

		sweeptrigger = "Ouro begins to cast Sweep",
		sweepannounce = "Sweep!",
		sweepwarn = "5 seconds until Sweep! Get out!",
		sweepbartext = "Sweep",

		sandblasttrigger = "Ouro begins to cast Sand Blast",
		sandblastannounce = "Incoming Sand Blast!",
		sandblastwarn = "5 seconds until Sand Blast!",
		sandblastbartext = "Sand Blast",

		emergetrigger = "Dirt Mound casts Summon Ouro Scarabs.",
		emergeannounce = "Ouro has emerged! Kill them bugs!",
		emergewarn1 = "15 seconds until Ouro submerges!",
		emergebartext = "Ouro submerge",

		berserksoonwarn = "Berserk Soon - Get Ready!",
		bosskill = "Ouro has been defeated!",
	},
})

function BigWigsOuro:Initialize()
	self.disabled = true
	self.berserkannounced = nil
	BigWigs:RegisterModule(self)
end

function BigWigsOuro:Enable()
	self.disabled = nil
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("UNIT_HEALTH")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
end

function BigWigsOuro:Disable()
	self.disabled = true
	self.berserkannounced = nil
	self:UnregisterAllEvents()
	self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.sweepbartext)
	self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.sandblastbartext)
	self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.emergebartext)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.sweepwarn)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.sandblastwarn)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.emergewarn)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.sweepbartext, 10)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.sweepbartext, 15)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.sandblastbartext, 5)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.sandblastbartext, 10)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.emergebartext, 30)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.emergebartext, 40)
end

function BigWigsOuro:CHAT_MSG_COMBAT_HOSTILE_DEATH()
	if (arg1 == self.loc.disabletrigger) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green", nil, "Victory")
		self:Disable()
	end
end

function BigWigsOuro:UNIT_HEALTH()
	if (UnitName(arg1) == self.loc.bossname) then
		local health = UnitHealth(arg1)
		if (health > 20 and health <= 23) then
			self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.berserksoonwarn, "Red")
			self.berserkannounced = true
		elseif (health > 30 and self.berserkannounced) then
			self.berserkannounced = nil
		end
	end
end

function BigWigsOuro:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE()
	if (string.find(arg1, self.loc.sweeptrigger)) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.sweepannounce, "Red")
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.sweepwarn, 15, "Red")
		self:TriggerEvent("BIGWIGS_BAR_START", self.loc.sweepbartext, 20, 1, "Yellow", "Interface\\Icons\\Spell_Fire_SoulBurn")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.sweepbartext, 10, "Orange")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.sweepbartext, 15, "Red")
	elseif (string.find(arg1, self.loc.sandblasttrigger)) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.sandblastannounce, "Red")
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.sandblastwarn, 15, "Red")
		self:TriggerEvent("BIGWIGS_BAR_START", self.loc.sandblastbartext, 20, 1, "Yellow", "Interface\\Icons\\Spell_Fire_SoulBurn")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.sandblastbartext, 10, "Orange")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.sandblastbartext, 15, "Red")
	elseif (string.find(arg1, self.loc.emergetrigger)) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.emergeannounce, "Red")
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.emergewarn, 15, "Red")
		self:TriggerEvent("BIGWIGS_BAR_START", self.loc.emergebartext, 20, 1, "Yellow", "Interface\\Icons\\Spell_Fire_SoulBurn")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.emergebartext, 10, "Orange")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.emergebartext, 15, "Red")
	end
end
--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsOuro:RegisterForLoad()