--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Ouro"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

local berserkannounced
local started 

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Ouro",

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

	berserk_cmd = "berserk",
	berserk_name = "Berserk",
	berserk_desc = "Warn for when Ouro goes berserk",

	sweeptrigger = "Ouro begins to cast Sweep",
	sweepannounce = "Sweep!",
	sweepwarn = "5 seconds until Sweep!",
	sweepbartext = "Sweep",

	sandblasttrigger = "Ouro begins to perform Sand Blast",
	sandblastannounce = "Incoming Sand Blast!",
	sandblastwarn = "5 seconds until Sand Blast!",
	sandblastbartext = "Sand Blast",

	engage_message = "Ouro engaged! Possible Submerge in 90sec!",
	possible_submerge_bar = "Possible submerge",

	emergetrigger = "Dirt Mound casts Summon Ouro Scarabs.",
	emergeannounce = "Ouro has emerged!",
	emergewarn = "15 sec to possible submerge!",
	emergewarn2 = "15 sec to Ouro sumberge!",
	emergebartext = "Ouro submerge",

	scarabdespawn = "Scarabs despawn in 10 Seconds",
	scarabbar = "Scarabs despawn",

	submergetrigger = "Ouro casts Summon Ouro Mounds.",
	submergeannounce = "Ouro has submerged!",
	submergewarn = "5 seconds until Ouro Emerges!",
	submergebartext = "Ouro Emerge",

	berserktrigger = "%s goes into a berserker rage!",
	berserkannounce = "Berserk - Berserk!",
	berserksoonwarn = "Berserk Soon - Get Ready!",
} end )

L:RegisterTranslations("deDE", function() return {
	sweep_name = "Feger",
	sweep_desc = "Warnung, wenn Ouro Feger wirkt.",

	sandblast_name = "Sandsto\195\159",
	sandblast_desc = "Warnung, wenn Ouro Sandsto\195\159 wirkt.",

	emerge_name = "Auftauchen",
	emerge_desc = "Warnung, wenn Ouro auftaucht.",

	submerge_name = "Untertauchen",
	submerge_desc = "Warnung, wenn Ouro untertaucht.",

	scarab_name = "Scarab Despawn Alert", -- ?
	scarab_desc = "Warn for Scarab Despawn", -- ?

	berserk_name = "Berserk",
	berserk_desc = "Warn for when Ouro goes berserk",

	sweeptrigger = "Ouro begins to cast Sweep", -- ?
	sweepannounce = "Feger!",
	sweepwarn = "5 Sekunden bis Feger!",
	sweepbartext = "Feger",

	sandblasttrigger = "Ouro begins to perform Sand Blast", -- ?
	sandblastannounce = "Sandsto\195\159 in K\195\188rze!",
	sandblastwarn = "5 Sekunden bis Sandsto\195\159!",
	sandblastbartext = "Sandsto\195\159",

	engage_message = "Ouro engaged! Possible Submerge in 90sec!",
	possible_submerge_bar = "Possible submerge",

	emergetrigger = "Dirt Mound casts Summon Ouro Scarabs.", -- ?
	emergeannounce = "Ouro ist aufgetaucht!",
	emergewarn = "15 sec to possible submerge!",
	emergewarn2 = "15 sec to Ouro sumberge!",
	emergebartext = "Untertauchen",

	scarabdespawn = "Scarabs verschwinden in 10 Sekunden", -- ?
	scarabbar = "Scarabs despawn", -- ?

	submergetrigger = "Ouro casts Summon Ouro Mounds.", -- ?
	submergeannounce = "Ouro ist aufgetaucht!",
	submergewarn = "5 Sekunden bis Ouro auftaucht!",
	submergebartext = "Auftauchen",

	berserktrigger = "%s goes into a berserker rage!",
	berserkannounce = "Berserk - Berserk!",
	berserksoonwarn = "Berserkerwut in K\195\188rze - Bereit machen!",
} end )

L:RegisterTranslations("koKR", function() return {
	sweep_name = "휩쓸기 경고",
	sweep_desc = "휩쓸기에 대한 경고",
	
	sandblast_name = "모래돌풍 경고",
	sandblast_desc = "모래돌풍에 대한 경고",
	
	emerge_name = "등장 경고",
	emerge_desc = "등장에 대한 경고",
	
	submerge_name = "잠수 경고",
	submerge_desc = "잠수에 대한 경고",
	
	scarab_name = "스카라베 소환 경고",
	scarab_desc = "스카라베 소환에 대한 경고",

	berserk_name = "광폭화",
	berserk_desc = "아우로 광폭화 경고",

	sweeptrigger = "아우로|1이;가; 휩쓸기|1을;를; 시전합니다.",
	sweepannounce = "휩쓸기!",
	sweepwarn = "5초후 휩쓸기! 대피",
	sweepbartext = "휩쓸기",

	sandblasttrigger = "아우로|1이;가; 모래 돌풍|1을;를; 사용합니다.",
	sandblastannounce = "모래 돌풍 경보!",
	sandblastwarn = "5초후 모래 돌풍",
	sandblastbartext = "모래 돌풍",

	engage_message = "아우로 전투개시! 90초후 잠수 가능!",
	possible_submerge_bar = "잠수 가능",

	emergetrigger = "흙더미|1이;가; 아우로 스카라베 소환|1을;를; 시전합니다.",
	emergeannounce = "아우로 등장! 벌레들 제거!",
	emergewarn = "15초후 아우로 잠수 가능!",
	emergewarn2 = "15초 후 아우로 잠수!",
	emergebartext = "아우로 잠수",

	scarabdespawn = "스카라베 소환 10초전",
	scarabbar = "스카라베 소환",

	submergetrigger = "아우로|1이;가; 아우로 흙더미 소환|1을;를; 시전합니다.",
	submergeannounce = "아우로 잠수!",
	submergewarn = "5초후 아우로 재등장!",
	submergebartext = "아우로 재등장",

	berserktrigger = "%s|1이;가; 광폭해집니다!", -- check
	berserkannounce = "광폭화 - 광폭화!",
	berserksoonwarn = "광폭화 예고 - 준비하세요!",
} end )

L:RegisterTranslations("zhCN", function() return {
	sweep_name = "横扫警报",
	sweep_desc = "横扫警报",
	
	sandblast_name = "沙尘爆裂警报",
	sandblast_desc = "沙尘爆裂警报",
	
	emerge_name = "钻地警报",
	emerge_desc = "钻地警报",
	
	submerge_name = "钻出警报",
	submerge_desc = "钻出警报",
	
	scarab_name = "甲虫消失警报",
	scarab_desc = "甲虫消失警报",
	
	berserk_name = "狂暴警报",
	berserk_desc = "当奥罗变得狂暴发出警报",

	sweeptrigger = "奥罗开始施放横扫。",
	sweepannounce = "横扫发动！",
	sweepwarn = "5秒后发动横扫！快退！",
	sweepbartext = "横扫",

	sandblasttrigger = "奥罗开始施展沙尘爆裂。",
	sandblastannounce = "沙尘爆裂发动！",
	sandblastwarn = "5秒后发动沙尘爆裂！",
	sandblastbartext = "沙尘爆裂",
	
	engage_message = "奥罗激活！可能90秒后潜入地下！",
	possible_submerge_bar = "潜入地下",

	emergetrigger = "土堆施放了召唤奥罗甲虫。",
	emergeannounce = "奥罗钻出了地面！",
	emergewarn = "15秒后潜入地下",
	emergewarn2 = "15 sec to Ouro sumberge!",
	emergebartext = "钻出地面",

	scarabdespawn = "10秒后甲虫消失", --Translate me
	scarabbar = "甲虫消失", -- Translate Me
	
	submergetrigger = "奥罗施放了召唤奥罗土堆。",
	submergeannounce = "奥罗潜入地下！杀光虫子！",
	submergewarn = "5秒后奥罗将钻出地面！",
	submergebartext = "潜入地下",

	berserktrigger = "%s goes into a berserker rage!",
	berserkannounce = "Berserk - Berserk!",
	berserksoonwarn = "即将狂暴 - 做好准备！",
} end )

L:RegisterTranslations("zhTW", function() return {
	sweep_name = "橫掃警報",
	sweep_desc = "奧羅施放橫掃時發出警報",
	
	sandblast_name = "沙塵爆裂警報",
	sandblast_desc = "奧羅施放沙塵爆裂時發出警報",
	
	emerge_name = "鑽地警報",
	emerge_desc = "奧羅鑽地時發出警報",
	
	submerge_name = "鑽出警報",
	submerge_desc = "奧羅鑽出時發出警報",
	
	scarab_name = "甲蟲消失警報",
	scarab_desc = "甲蟲消失時發出警報",
	
	berserk_name = "狂暴警報",
	berserk_desc = "當奧羅變得狂暴發出警報",

	sweeptrigger = "奧羅開始施放橫掃。",
	sweepannounce = "橫掃發動！",
	sweepwarn = "5 秒後發動橫掃！快退！",
	sweepbartext = "橫掃",

	sandblasttrigger = "奧羅開始施展沙塵爆裂。",
	sandblastannounce = "沙塵爆裂！",
	sandblastwarn = "5 秒後發動沙塵爆裂！",
	sandblastbartext = "沙塵爆裂",
	
	engage_message = "奧羅已進入戰鬥 - 90 秒後可能潛入地下！",
	possible_submerge_bar = "潛入地下",

	emergetrigger = "土堆施放了召喚奧羅甲蟲。",
	emergeannounce = "奧羅鑽出了地面！",
	emergewarn = "15 秒後潛入地下",
	emergewarn2 = "15 sec to Ouro sumberge!",
	emergebartext = "鑽出地面",

	scarabdespawn = "10 秒後甲蟲消失", --Translate me
	scarabbar = "甲蟲消失", -- Translate Me
	
	submergetrigger = "奧羅施放了召喚奧羅土堆。",
	submergeannounce = "奧羅潛入地下！殺光蟲子！",
	submergewarn = "5 秒後將鑽出地面！",
	submergebartext = "潛入地下",

	berserktrigger = "%s goes into a berserker rage!",
	berserkannounce = "Berserk - Berserk!",
	berserksoonwarn = "即將狂暴 - 做好準備！",
} end )

L:RegisterTranslations("frFR", function() return {
	sweep_name = "Sweep Alert",
	sweep_desc = "Warn for Sweeps",

	sandblast_name = "Sandblast Alert",
	sandblast_desc = "Warn for Sandblasts",

	emerge_name = "Emerge Alert",
	emerge_desc = "Warn for Emerge",

	submerge_name = "Submerge Alert",
	submerge_desc = "Warn for Submerge",

	scarab_name = "Scarab Despawn Alert",
	scarab_desc = "Warn for Scarab Despawn",

	berserk_name = "Berserk",
	berserk_desc = "Warn for when Ouro goes berserk",

	sweeptrigger = "Ouro commence \195\160 lancer Balayer.",
	sweepannounce = "balayage!",
	sweepwarn = "balayage dans 5 sec!",
	sweepbartext = "Sweep",

	sandblasttrigger = "Ouro commence \195\160 ex\195\169cuter Explosion de sable.",
	sandblastannounce = "explosion de sable!",
	sandblastwarn = "5 seconds until Sand Blast!",
	sandblastbartext = "Sand Blast",

	engage_message = "Ouro engaged! Possible Submerge in 90sec!",
	possible_submerge_bar = "Possible submerge",

	emergetrigger = "Tas de terre lance Invocation de Scarab\195\169es d'Ouro.",
	emergeannounce = "Ouro apparait!",
	emergewarn = "15 sec to possible submerge!",
	emergewarn2 = "15 sec to Ouro sumberge!",
	emergebartext = "Ouro submerge",

	scarabdespawn = "Depop des scarab\195\169s dans 10 sec",
	scarabbar = "Scarabs despawn",

	submergetrigger = "Ouro lance Invocation de Monticules d'Ouro.",
	submergeannounce = "Ouro disparait!",
	submergewarn = "5 seconds until Ouro Emerges!",
	submergebartext = "Ouro Emerge",

	berserktrigger = "%s goes into a berserker rage!",
	berserkannounce = "Berserk - Berserk!",
	berserksoonwarn = "Berserk Soon - Get Ready!",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsOuro = BigWigs:NewModule(boss)
BigWigsOuro.zonename = AceLibrary("Babble-Zone-2.2")["Ahn'Qiraj"]
BigWigsOuro.enabletrigger = boss
BigWigsOuro.toggleoptions = {"sweep", "sandblast", "scarab", -1, "emerge", "submerge", -1, "berserk", "bosskill"}
BigWigsOuro.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsOuro:OnEnable()
	berserkannounced = nil
	started = nil

	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")

	self:RegisterEvent("UNIT_HEALTH")

	self:RegisterEvent("BigWigs_RecvSync")

	self:TriggerEvent("BigWigs_ThrottleSync", "OuroSweep", 10)
	self:TriggerEvent("BigWigs_ThrottleSync", "OuroSandblast", 10)
	self:TriggerEvent("BigWigs_ThrottleSync", "OuroEmerge2", 10)
	self:TriggerEvent("BigWigs_ThrottleSync", "OuroSubmerge", 10)
	self:TriggerEvent("BigWigs_ThrottleSync", "OuroBerserk", 10)
end

function BigWigsOuro:UNIT_HEALTH( msg )
	if UnitName(msg) == boss then
		local health = UnitHealth(msg)
		if health > 20 and health <= 23 and not berserkannounced then
			if self.db.profile.berserk then
				self:TriggerEvent("BigWigs_Message", L["berserksoonwarn"], "Important")
			end
			berserkannounced = true
		elseif health > 30 and berserkannounced then
			berserkannounced = nil
		end
	end
end

function BigWigsOuro:BigWigs_RecvSync( sync, rest, nick )
	if sync == self:GetEngageSync() and rest and rest == boss and not started then
		started = true
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then self:UnregisterEvent("PLAYER_REGEN_DISABLED") end
		if self.db.profile.emerge then
			self:TriggerEvent("BigWigs_Message", L["engage_message"], "Attention")
			self:PossibleSubmerge()
		end
	elseif sync == "OuroSweep" then
		self:Sweep()
	elseif sync == "OuroSandblast" then
		self:Sandblast()
	elseif sync == "OuroEmerge2" then
		self:Emerge()
	elseif sync == "OuroSubmerge" then
		self:Submerge()
	elseif sync == "OuroBerserk" then
		self:Berserk()
	end
end

function BigWigsOuro:PossibleSubmerge()
	if self.db.profile.emerge then
		self:ScheduleEvent("bwouroemergewarn", "BigWigs_Message", 75, L["emergewarn"], "Important")
		self:TriggerEvent("BigWigs_StartBar", self, L["possible_submerge_bar"], 90, "Interface\\Icons\\Spell_Nature_Earthquake")
		self:ScheduleEvent("bwouroemergewarn2", "BigWigs_Message", 165, L["emergewarn2"], "Important")
		self:TriggerEvent("BigWigs_StartBar", self, L["emergebartext"], 180, "Interface\\Icons\\Spell_Nature_Earthquake")
	end
end

function BigWigsOuro:Berserk()
	self:CancelScheduledEvent("bwouroemergewarn")
	self:CancelScheduledEvent("bwouroemergewarn2")
	self:TriggerEvent("BigWigs_StopBar", self, L["emergebartext"])
	self:TriggerEvent("BigWigs_StopBar", self, L["possible_submerge_bar"])
	self:UnregisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")

	if self.db.profile.berserk then
		self:TriggerEvent("BigWigs_Message", L["berserkannounce"], "Important")
	end
end

function BigWigsOuro:Sweep()
	if self.db.profile.sweep then
		self:TriggerEvent("BigWigs_Message", L["sweepannounce"], "Important")
		self:ScheduleEvent("bwourosweepwarn", "BigWigs_Message", 16, L["sweepwarn"], "Important")
		self:TriggerEvent("BigWigs_StartBar", self, L["sweepbartext"], 21, "Interface\\Icons\\Spell_Nature_Thorns")
	end
end

function BigWigsOuro:Sandblast()
	if self.db.profile.sandblast then
		self:TriggerEvent("BigWigs_Message", L["sandblastannounce"], "Important")
		self:ScheduleEvent("bwouroblastwarn", "BigWigs_Message", 17, L["sandblastwarn"], "Important")
		self:TriggerEvent("BigWigs_StartBar", self, L["sandblastbartext"], 22, "Interface\\Icons\\Spell_Nature_Cyclone")
	end
end

function BigWigsOuro:Emerge()
	if self.db.profile.emerge then
		self:TriggerEvent("BigWigs_Message", L["emergeannounce"], "Important")
		self:PossibleSubmerge()
	end

	if self.db.profile.sweep then
		self:ScheduleEvent("bwourosweepwarn", "BigWigs_Message", 16, L["sweepwarn"], "Important")
		self:TriggerEvent("BigWigs_StartBar", self, L["sweepbartext"], 21, "Interface\\Icons\\Spell_Nature_Thorns")
	end	

	if self.db.profile.sandblast then
		self:ScheduleEvent("bwouroblastwarn", "BigWigs_Message", 17, L["sandblastwarn"], "Important")
		self:TriggerEvent("BigWigs_StartBar", self, L["sandblastbartext"], 22, "Interface\\Icons\\Spell_Nature_Cyclone")
	end

	if self.db.profile.scarab then
		self:ScheduleEvent("bwscarabdespawn", "BigWigs_Message", 50, L["scarabdespawn"], "Important")
		self:TriggerEvent("BigWigs_StartBar", self, L["scarabbar"], 60, "Interface\\Icons\\INV_Scarab_Clay")
	end
end

function BigWigsOuro:Submerge()
	self:CancelScheduledEvent("bwourosweepwarn")
	self:CancelScheduledEvent("bwouroblastwarn")
	self:CancelScheduledEvent("bwouroemergewarn")
	self:CancelScheduledEvent("bwouroemergewarn2")

	self:TriggerEvent("BigWigs_StopBar", self, L["sweepbartext"])
	self:TriggerEvent("BigWigs_StopBar", self, L["sandblastbartext"])
	self:TriggerEvent("BigWigs_StopBar", self, L["emergebartext"])
	self:TriggerEvent("BigWigs_StopBar", self, L["possible_submerge_bar"])

	if self.db.profile.submerge then
		self:TriggerEvent("BigWigs_Message", L["submergeannounce"], "Important")
		self:ScheduleEvent("bwsubmergewarn", "BigWigs_Message", 25, L["submergewarn"], "Important" )
		self:TriggerEvent("BigWigs_StartBar", self, L["submergebartext"], 30, "Interface\\Icons\\Spell_Nature_Earthquake")
	end
end

function BigWigsOuro:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF( msg )
	if string.find(msg, L["emergetrigger"]) then
		self:TriggerEvent("BigWigs_SendSync", "OuroEmerge2")
	elseif string.find(msg, L["submergetrigger"]) then
		self:TriggerEvent("BigWigs_SendSync", "OuroSubmerge")
	end
end

function BigWigsOuro:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE( msg )
	if string.find(msg, L["sweeptrigger"]) then
		self:TriggerEvent("BigWigs_SendSync", "OuroSweep")
	elseif string.find(msg, L["sandblasttrigger"]) then
		self:TriggerEvent("BigWigs_SendSync", "OuroSandblast")
	elseif string.find(msg, L["submergetrigger"]) then
		self:TriggerEvent("BigWigs_SendSync", "OuroSubmerge")
	end
end

function BigWigsOuro:CHAT_MSG_MONSTER_EMOTE( msg )
	if msg == L["berserktrigger"] then
		self:TriggerEvent("BigWigs_SendSync", "OuroBerserk")
	end
end