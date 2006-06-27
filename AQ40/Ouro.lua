local bboss = BabbleLib:GetInstance("Boss 1.2")

BigWigsOuro = AceAddon:new({
	name          = "BigWigsOuro",
	cmd           = AceChatCmd:new({}, {}),


	zonename = BabbleLib:GetInstance("Zone 1.2")("Ahn'Qiraj"),
	enabletrigger = bboss("Ouro"),
	bossname = bboss("Ouro"),

	toggleoptions = {
		notBosskill = "Boss death",
		notBerserkSoon = "Berserk soon warning",
		notSweepBar = "Sweep timerbar",
		notSweep5Sec = "Sweep 5-sec warning",
		notSweepWarn = "Sweep warning",
		notBlastBar = "Sand Blast timerbar",
		notBlast5Sec = "Sand Blast 5-sec warning",
		notBlastWarn = "Sand Blast warning",
		notEmergeBar = "Emerge timerbar",
		notEmerge5Sec = "Emerge 5-sec warning",
		notEmergeWarn = "Emerge warning",
		notSubmergeBar = "Emerge timerbar",
		notSubmerge5Sec = "Emerge 5-sec warning",
		notSubmergeWarn = "Emerge warning",
		notScarabWarn = "Scarab Despawn Warning",
		notScarabBar = "Scarab despawn timebar",
		
	},

	optionorder = {"notSweepBar", "notSweep5Sec", "notSweepWarn", "notBlastBar", "notBlast5Sec", "notBlastWarn", "notEmergeBar", "notEmerge5Sec", "notEmergeWarn", "notSubmergeBar", "notSubmerge5Sec", "notSubmergeWarn","notScarabWarn", "notScarabBar", "notBerserkSoon", "notBosskill"},

	loc = GetLocale() == "koKR" and {
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
		
		scarabdespawn = "Scarbs Despawn in 10 Seconds", --Translate me
		scarabbar	= "Scarabs despawn", -- Translate Me

		berserksoonwarn = "광폭화 예고 - 준비하세요!",
		bosskill = "아우로를 물리쳤습니다!",
	}
		or GetLocale() == "zhCN" and
	{
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
		
		scarabdespawn = "Scarbs Despawn in 10 Seconds", --Translate me
		scarabbar	= "Scarabs despawn", -- Translate Me

		berserksoonwarn = "即将狂暴 - 做好准备！",
		bosskill = "奥罗被击败了！",
	}
		or
	{
		disabletrigger = "Ouro dies.",

		sweeptrigger = "Ouro begins to cast Sweep",
		sweepannounce = "Sweep!",
		sweepwarn = "5 seconds until Sweep! Get out!",
		sweepbartext = "Sweep",

		sandblasttrigger = "Ouro begins to perform Sand Blast",
		sandblastannounce = "Incoming Sand Blast!",
		sandblastwarn = "5 seconds until Sand Blast!",
		sandblastbartext = "Sand Blast",

		emergetrigger = "Dirt Mound casts Summon Ouro Scarabs.",
		emergeannounce = "Ouro has emerged!",
		emergewarn1 = "15 seconds until Ouro submerges!",
		emergebartext = "Ouro submerge",
		
		scarabdespawn = "Scarbs Despawn in 10 Seconds",
		scarabbar	= "Scarabs despawn",
		
		submergetrigger = "Ouro casts Summon Ouro Mounds.",
		submergeannounce = "Ouro has submerged!",
		submergewarn1 = "5 seconds until Ouro Emerges!",
		submergebar = "Ouro Emerge",
		
		berserksoonwarn = "Berserk Soon - Get Ready!",
		bosskill = "Ouro has been defeated!",
	},
})

function BigWigsOuro:Initialize()
	self.disabled = true
	self.berserkannounced = nil
	self:TriggerEvent("BIGWIGS_REGISTER_MODULE", self)
end

function BigWigsOuro:Enable()
	self.disabled = nil
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")
	self:RegisterEvent("UNIT_HEALTH")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	self:RegisterEvent("BIGWIGS_SYNC_OUROSWEEP")
	self:RegisterEvent("BIGWIGS_SYNC_OUROSANDBLAST")
	self:RegisterEvent("BIGWIGS_SYNC_OUROEMERGE")
	self:RegisterEvent("BIGWIGS_SYNC_OUROSUBMERGE")
	self:TriggerEvent("BIGWIGS_SYNC_THROTTLE", "OUROSWEEP", 10)
	self:TriggerEvent("BIGWIGS_SYNC_THROTTLE", "OUROSANDBLAST", 10)
	self:TriggerEvent("BIGWIGS_SYNC_THROTTLE", "OUROEMERGE", 10)
	self:TriggerEvent("BIGWIGS_SYNC_THROTTLE", "OUROSUBMERGE", 10)
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
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.emergebartext, 75)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.emergebartext, 135)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.emergebartext, 165)
	self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.scarabbar)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.scarabbar, 30)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.scarabbar, 45)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.scarabdespawn)
end

function BigWigsOuro:CHAT_MSG_COMBAT_HOSTILE_DEATH()
	if (arg1 == self.loc.disabletrigger) then
		if not self:GetOpt("notBosskill") then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green", nil, "Victory") end
		self:Disable()
	end
end

function BigWigsOuro:UNIT_HEALTH()
	if (UnitName(arg1) == self.loc.bossname) then
		local health = UnitHealth(arg1)
		if (health > 20 and health <= 23) then
			if not self:GetOpt("notBerserkSoon") then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.berserksoonwarn, "Red") end
			self.berserkannounced = true
		elseif (health > 30 and self.berserkannounced) then
			self.berserkannounced = nil
		end
	end
end
function BigWigsOuro:BIGWIGS_SYNC_OUROSWEEP()
	if not self:GetOpt("notSweepWarn") then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.sweepannounce, "Red") end
	if not self:GetOpt("notSweep5Sec") then self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.sweepwarn, 18, "Red") end
	if not self:GetOpt("notSweepBar") then
		self:TriggerEvent("BIGWIGS_BAR_START", self.loc.sweepbartext, 23, 1, "Yellow", "Interface\\Icons\\Spell_Nature_Thorns")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.sweepbartext, 10, "Orange")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.sweepbartext, 15, "Red")
	end
end

function BigWigsOuro:BIGWIGS_SYNC_OUROSANDBLAST()
	if not self:GetOpt("notBlastWarn") then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.sandblastannounce, "Red") end
	if not self:GetOpt("notBlast5Sec") then self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.sandblastwarn, 18, "Red") end
	if not self:GetOpt("notBlastBar") then
		self:TriggerEvent("BIGWIGS_BAR_START", self.loc.sandblastbartext, 23, 2, "Yellow", "Interface\\Icons\\Spell_Nature_Cyclone")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.sandblastbartext, 10, "Orange")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.sandblastbartext, 15, "Red")
	end
end

function BigWigsOuro:BIGWIGS_SYNC_OUROEMERGE()
	if not self:GetOpt("notEmergeWarn") then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.emergeannounce, "Red") end
	if not self:GetOpt("notEmerge5Sec") then self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.emergewarn, 165, "Red") end
	if not self:GetOpt("notEmergeBar") then
		self:TriggerEvent("BIGWIGS_BAR_START", self.loc.emergebartext, 180, 3, "Green", "Interface\\Icons\\Spell_Nature_Earthquake")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.emergebartext, 75, "Yellow")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.emergebartext, 135, "Orange")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.emergebartext, 165, "Red")
	end
	if not self:GetOpt("notScarabWarn") then self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.scarabdespawn, 50, "Red") end
	if not self:GetOpt("notScarabBar") then
		self:TriggerEvent("BIGWIGS_BAR_START", self.loc.scarabbar, 60, 4, "Orange", "Interface\\Icons\\INV_Scarab_Clay")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.scarabbar, 30, "Yellow")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.scarabbar, 45, "Green")
	end
end

function BigWigsOuro:BIGWIGS_SYNC_OUROSUBMERGE()
	if not self:GetOpt("notSubmergeWarn") then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.submergeannounce, "Red") end
		if not self:GetOpt("notSubmerge5Sec") then self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.submergewarn, 25, "Red") end
		if not self:GetOpt("notSubmergeBar") then
			self:TriggerEvent("BIGWIGS_BAR_START", self.loc.submergebar, 30, 3, "Yellow", "Interface\\Icons\\Spell_Nature_Earthquake")
			self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.submergebartext, 10, "Orange")
			self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.submergebartext, 20, "Red")
		end
	end
end

function BigWigsOuro:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF()	
	if (string.find(arg1, self.loc.emergetrigger)) then
		self:TriggerEvent("BIGWIGS_SYNC_SEND", "OUROEMERGE")
	end
end

function BigWigsOuro:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE()
	if (string.find(arg1, self.loc.sweeptrigger)) then
		self:TriggerEvent("BIGWIGS_SYNC_SEND", "OUROSWEEP")
	elseif (string.find(arg1, self.loc.sandblasttrigger)) then
		self:TriggerEvent("BIGWIGS_SYNC_SEND", "OUROSANDBLAST")
	elseif (string.find(arg1, self.loc.submergetrigger)) then
		self:TriggerEvent("BIGWIGS_SUNC_SEND", "OUROSUBMERGE")
	end
end
--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsOuro:RegisterForLoad()