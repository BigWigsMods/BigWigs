--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.0")("Ouro")
local L = AceLibrary("AceLocale-2.0"):new("BigWigs"..boss)

local berserkannounced

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {

	cmd = "ouro",
	
	sweep_cmd = "sweep",
	sweep_name = "Sweep Alert",
	sweep_desc = "Warn for Sweeps",
	
	sandblast_cmd = "sandblast",
	sandblast_name = "Sandblast Alert",
	sandblast_desc = "Warn for Sandblasts",
	
	emerge_cmd = "emerge",
	emerge_name = "Emerge Alert",
	emerge_desc = "Warn for Emerge",
	
	submerge_cmd = "submerge",
	submerge_name = "Submerge Alert",
	submerge_desc = "Warn for Submerge",
	
	scarab_cmd = "scarab",
	scarab_name = "Scarab Despawn Alert",
	scarab_desc = "Warn for Scarab Despawn",

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

	scarabdespawn = "Scarabs despawn in 10 Seconds",
	scarabbar	= "Scarabs despawn",

	submergetrigger = "Ouro casts Summon Ouro Mounds.",
	submergeannounce = "Ouro has submerged!",
	submergewarn1 = "5 seconds until Ouro Emerges!",
	submergebar = "Ouro Emerge",

	berserksoonwarn = "Berserk Soon - Get Ready!",
} end )

L:RegisterTranslations("koKR", function() return {
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

	scarabdespawn = "스카라베 소환 10초전",
	scarabbar	= "스카라베 소환",

	submergetrigger = "아우로|1이;가; 아우로 더미 소환|1을;를; 시전합니다.",
	submergeannounce = "아우로 잠수!",
	submergewarn1 = "5초후 아우로 재등장!",
	submergebar = "아우로 재등장",

	berserksoonwarn = "광폭화 예고 - 준비하세요!",
} end )

L:RegisterTranslations("zhCN", function() return {
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
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsOuro = BigWigs:NewModule(boss)
BigWigsOuro.zonename = AceLibrary("Babble-Zone-2.0")("Ahn'Qiraj")
BigWigsOuro.enabletrigger = boss
BigWigsOuro.toggleoptions = {"sweep", "sandblast", "scarab", "emerge", "submerge", "bosskill"}
BigWigsOuro.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsOuro:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("UNIT_HEALTH")

	self:RegisterEvent("BigWigs_RecvSync")

	self:TriggerEvent("BigWigs_ThrottleSync", "OuroSweep", 10)
	self:TriggerEvent("BigWigs_ThrottleSync", "OuroSandblast", 10)
	self:TriggerEvent("BigWigs_ThrottleSync", "OuroEmerge", 10)
	self:TriggerEvent("BigWigs_ThrottleSync", "OuroSubmerge", 10)
end

function BigWigsOuro:UNIT_HEALTH( msg )
	if UnitName(msg) == boss then
		local health = UnitHealth(msg)
		if (health > 20 and health <= 23) then
			self:TriggerEvent("BigWigs_Message", L"berserksoonwarn", "Red")
			berserkannounced = true
		elseif (health > 30 and berserkannounced) then
			berserkannounced = nil
		end
	end
end

function BigWigsOuro:BigWigs_RecvSync( sync )
	if sync == "OuroSweep" then
		self:Sweep()
	elseif sync == "OuroSandblast" then
		self:Sandblast()
	elseif sync == "OuroEmerge" then
		self:Emerge()
	elseif sync == "OuroSubmerge" then
		self:Submerge()
	end
end

function BigWigsOuro:Sweep()
	if self.db.profile.sweep then
		self:TriggerEvent("BigWigs_Message", L"sweepannounce", "Red")
		self:ScheduleEvent("bwourosweepwarn", "BigWigs_Message", 18, L"sweepwarn", "Red")
		self:TriggerEvent("BigWigs_StartBar", self, L"sweepbartext", 23, 1, "Interface\\Icons\\Spell_Nature_Thorns", "Yellow", "Orange", "Red")
	end
end

function BigWigsOuro:Sandblast()
	if self.db.profile.sandblast then
		self:TriggerEvent("BigWigs_Message", L"sandblastannounce", "Red")
		self:ScheduleEvent("bwouroblastwarn", "BigWigs_Message", 18, L"sandblastwarn", "Red")
		self:TriggerEvent("BigWigs_StartBar", self, L"sandblastbartext", 23, 2, "Interface\\Icons\\Spell_Nature_Cyclone", "Yellow", "Orange", "Red")
	end
end

function BigWigsOuro:Emerge()
	if self.db.profile.emerge then
		self:TriggerEvent("BigWigs_Message", L"emergeannounce", "Red")
		self:ScheduleEvent("bwouroemergewarn", "BigWigs_Message", 165, L"emergewarn", "Red")
		self:TriggerEvent("BigWigs_StartBar", self, L"emergebartext", 180, 3, "Interface\\Icons\\Spell_Nature_Earthquake", "Green", "Yellow", "Orange", "Red")
	end

	if self.db.profile.scarab then
		self:ScheduleEvent("bwscarabdespawn", "BigWigs_Message", 50, L"scarabdespawn", "Red")
		self:TriggerEvent("BigWigs_StartBar", self, L"scarabbar", 60, 5, "Interface\\Icons\\INV_Scarab_Clay", "Red", "Orange", "Yellow", "Green" )
	end
end

function BigWigsOuro:Submerge()
	if self.db.profile.submerge then
		self:TriggerEvent("BigWigs_Message", L"submergeannounce", "Red")
		self:ScheduleEvent("bwsubmergewarn", "BigWigs_Message", 25, L"submergewarn", "Red" )
		self:TriggerEvent("BigWigs_StartBar", self, L"submergebar", 30, 4, "Interface\\Icons\\Spell_Nature_Earthquake", "Yellow", "Orange", "Red")
	end
end

function BigWigsOuro:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF( msg )
	if string.find(msg, L"emergetrigger") then
		self:TriggerEvent("BigWigs_SendSync", "OuroEmerge")
	elseif string.find(msg, L"submergetrigger") then
		self:TriggerEvent("BigWigs_SendSync", "OuroSubmerge")
	end
end

function BigWigsOuro:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE( msg )
	if string.find(msg, L"sweeptrigger") then
		self:TriggerEvent("BigWigs_SendSync", "OuroSweep")
	elseif string.find(msg, L"sandblasttrigger") then
		self:TriggerEvent("BigWigs_SendSync", "OuroSandblast")
	elseif string.find(msg, L"submergetrigger") then
		self:TriggerEvent("BigWigs_SendSync", "OuroSubmerge")
	end
end
