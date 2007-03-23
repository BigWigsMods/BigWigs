------------------------------
--      Are you local?      --
------------------------------

local eyeofcthun = AceLibrary("Babble-Boss-2.2")["Eye of C'Thun"]
local cthun = AceLibrary("Babble-Boss-2.2")["C'Thun"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs" .. cthun)

local timeP1Tentacle = 45      -- tentacle timers for phase 1
local timeP1TentacleStart = 45 -- delay for first tentacles from engage onwards
local timeP1GlareStart = 48    -- delay for first dark glare from engage onwards
local timeP1Glare = 86         -- interval for dark glare
local timeP1GlareDuration = 40 -- duration of dark glare
local timeP2Offset = 12        -- delay for all timers to restart after the Eye dies
local timeP2Tentacle = 30      -- tentacle timers for phase 2
local timeReschedule = 60      -- delay from the moment of weakening for timers to restart
local timeTarget = 0.2         -- delay for target change checking on Eye of C'Thun
local timeWeakened = 45        -- duration of a weaken

local gianteye = nil
local cthunstarted = nil
local phase2started = nil
local firstGlare = nil
local firstWarning = nil
local target = nil
local tentacletime = timeP1Tentacle

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Cthun",

	tentacle = "Tentacle Alert",
	tentacle_desc = "Warn for Tentacles",

	glare = "Dark Glare Alert",
	glare_desc = "Warn for Dark Glare",

	group = "Dark Glare Group Warning",
	group_desc = "Warn for Dark Glare on Group X",

	giant = "Giant Eye Alert",
	giant_desc = "Warn for Giant Eyes",

	weakened = "Weakened Alert",
	weakened_desc = "Warn for Weakened State",

	rape = "Rape jokes are funny",
	rape_desc = "Some people like hentai jokes.",

	weakenedtrigger = "%s is weakened!",

	tentacle1	= "Tentacle Rape Party - Pleasure!",
	tentacle2	= "Tentacle Rape Party - 5 sec",

	norape1		= "Tentacles Spawned!",
	norape2		= "Tentacles in 5sec!",


	weakened		= "C'Thun is weakened for 45 sec",
	invulnerable2	= "Party ends in 5 seconds",
	invulnerable1	= "Party over - C'Thun invulnerable",

	giant3		= "Giant Eye - 10 sec",
	giant2		= "Giant Eye - 5 sec",
	giant1		= "Giant Eye - Poke it!",

	startwarn	= "C'Thun engaged! - 45 sec until Dark Glare and Eyes",

	glare2		= "Dark glare - 5 sec",
	glare1		= "Dark glare!",

	barTentacle	= "Tentacle rape party!",
	barNoRape	= "Tentacle party!",
	barWeakened	= "C'Thun is weakened!",
	barGlare	= "Dark glare!",
	barGiant	= "Giant Eye!",
	barGreenBeam	= "Green Beam!",

	eyebeam		= "Eye Beam",
	glarewarning	= "DARK GLARE ON YOU!",
	groupwarning	= "Dark Glare on group %s (%s)",
	positions1	= "Green Beam coming",
	positions2	= "Dark Glare ends in 5 sec",
	phase2starting	= "The Eye is dead! Body incoming!",
} end )

L:RegisterTranslations("deDE", function() return {
	tentacle = "Tentakel",
	tentacle_desc = "Warnung vor Tentakeln.",

	glare = "Dunkles Starren",
	glare_desc = "Warnung vor Dunklem Starren.",

	group = "Dunkles Starren Gruppe",
	group_desc = "Warnung vor Dunklem Starren auf Gruppe X.",

	giant = "Riesiges Auge",
	giant_desc = "Riesiges Auge", -- ?

	weakened = "Geschw\195\164cht",
	weakened_desc = "Warnung, wenn C'Thun geschw\195\164cht ist.",

	weakenedtrigger = "%s ist geschw\195\164cht!",

	tentacle1	= "Tentacle Rape Party - Pleasure!", -- ?
	tentacle2	= "Tentacle Rape Party - 5 sec", -- ?

	norape1		= "Tentacle Party! - What's that in your pants?", -- ?
	norape2		= "Tentacle Party! - 5 sec", -- ?

	weakened		= "C'Thun ist geschw\195\164cht f\195\188r 45 Sekunden",
	invulnerable2	= "C'Thun unverwundbar in 5 Sekunden",
	invulnerable1	= "C'Thun ist unverwundbar!",

	giant3		= "Riesiges Auge - 10 Sekunden",
	giant2		= "Riesiges Auge - 5 Sekunden",
	giant1		= "Riesiges Auge - Angriff!",

	startwarn	= "C'Thun angegriffen! - 45 Sekunden bis Dunkles Starren und Augen!",

	glare2		= "Dunkles Starren - 5 Sekunden",
	glare1		= "Dunkles Starren - BEWEGUNG!",

	barTentacle	= "Tentacle rape party!", -- ?
	barNoRape	= "Tentacle party!", -- ?
	barWeakened	= "C'Thun ist geschw\195\164cht!",
	barGlare	= "Dunkles Starren",
	barGiant	= "Riesiges Auge", -- ?
	barGreenBeam	= "Green Beam!", -- ?

	eyebeam		= "Augenstrahl", 
	glarewarning	= "Dunkles Starren auf Dir! BEWEGUNG!",
	groupwarning	= "Dunkles Starren auf Gruppe %s (%s)",
	positions1	= "Green Beam coming", -- ?
	positions2	= "Dunkles Starren endet in 5 Sekunden",
	phase2starting	= "Das Auge ist tot! - Phase 2 beginnt!",
} end )

L:RegisterTranslations("koKR", function() return {
	tentacle = "촉수 경고",
	tentacle_desc = "촉수에 대한 경고",

	glare = "암흑의 주시 경고",
	glare_desc = "암흑의 주시에 대한 경고",

	group = "암흑의 주시 파티 경고",
	group_desc = "파티 X 에 암흑의 주시에 대한 경고",

	giant = "거대한 눈 경고",
	giant_desc = "거대한 눈에 대한 경고",

	weakened = "약화 경고",
	weakened_desc = "약화 상태에 대한 경고",

	weakenedtrigger 	= "%s|1이;가; 약해집니다!",

	tentacle1	= "눈달린 촉수 등장 - 촉수 처리~~!",
	tentacle2	= "눈달린 촉수 등장 - 5초전!",

	norape1		= "작은 눈달린 촉수 등장 - 처리~~(마반,스턴)!",
	norape2		= "작은 눈달린 촉수 - 5초전!",

	weakened		= "쑨이 약화되었습니다 - 45초간 최대 공격!",
	invulnerable2	= "쑨 약화 종료 5초전!",
	invulnerable1	= "쑨 공격 불가 상태로 전환!",

	giant3		= "거대한 발톱 촉수 - 10 초전",
	giant2		= "거대한 발톱 촉수 - 5초전!",
	giant1		= "거대한 발톱 촉수 등장 - 눈촉수 처리후 처리!!!",

	startwarn	= "쑨 시작 - 45초후 암흑의 주시",

	glare2		= "암흑의 주시 - 5초전!",
	glare1		= "암흑의 주시 - 눈촉수 처리하면서 이동!",

	barTentacle	= "눈달린 촉수!",
	barNoRape	= "작은 눈달린 촉수!",
	barWeakened	= "쑨 약화!",
	barGlare	= "암흑의 주시!",
	barGiant	= "거대한 눈!",
	barGreenBeam	= "녹색 안광!",

	eyebeam		= "안광",
	glarewarning	= "암흑의 주시를 당하고 있습니다! 이동!",
	groupwarning	= "암흑의 주시 %s파티 (%s님 바로 이동!!!!!!)",
	positions1	= "빠른 진형 재정비 - 녹색 안광이 시작됩니다!",
	positions2	= "암흑의 주시 종료 5초전!",
	phase2starting	= "쑨의 눈 처치, 본체가 등장합니다. 준비!",
} end )

L:RegisterTranslations("zhCN", function() return {
	tentacle = "触须警报",
	tentacle_desc = "触须出现时发出警报",

	glare = "黑暗闪耀警报",
	glare_desc = "黑暗闪耀发动时发出警报",

	group = "黑暗闪耀小队警报",
	group_desc = "黑暗闪耀发动时对小队X发出警报",

	giant = "巨眼警报",
	giant_desc = "巨眼出现时发出警报",

	weakened = "虚弱警报",
	weakened_desc = "克苏恩被削弱时发出警报",

	weakenedtrigger = "%s的力量被削弱了！",

	tentacle1	= "眼球触须出现！",
	tentacle2	= "5秒后眼球触须出现！",

	norape1		= "巨眼、巨爪触须出现！",
	norape2		= "5秒后巨眼、巨爪触须出现！",

	weakened	= "克苏恩被削弱了 - 45秒内全力输出伤害！",
	invulnerable2	= "削弱状态还有5秒结束",
	invulnerable1	= "削弱状态结束 - 停止攻击克苏恩！",

	giant3		= "巨眼出现 - 10 秒",
	giant2		= "巨眼出现 - 5 秒",
	giant1		= "巨眼出现！",

	startwarn	= "克苏恩已激活 - 45秒后发动黑暗闪耀, 出现眼球",

	glare2		= "5秒后发动黑暗闪耀！",
	glare1		= "黑暗闪耀发动 - 跑位！",

	barTentacle	= "眼球触须！",
	barNoRape	= "巨眼触须！",
	barWeakened	= "克苏恩被削弱了！",
	barGlare	= "黑暗闪耀！",
	barGiant	= "巨眼！",
	barGreenBeam	= "绿光！",

	eyebeam		= "眼棱",
	glarewarning	= "黑暗闪耀在你身上发动了!",
	groupwarning	= "黑暗闪耀在%s小队发动了！（%s小队移动！！）",
	positions1	= "黑暗闪耀结束，绿光发动，请注意保持距离",
	positions2	= "5秒后黑暗闪耀结束",
	phase2starting	= "克苏恩之眼已死亡 - 进入第二阶段！",
} end )

L:RegisterTranslations("zhTW", function() return {
	tentacle = "觸鬚警報",
	tentacle_desc = "觸鬚出現時發出警報",

	glare = "黑暗閃耀警報",
	glare_desc = "黑暗閃耀發動時發出警報",

	group = "黑暗閃耀小隊警報",
	group_desc = "黑暗閃耀發動時對小隊X發出警報",

	giant = "巨眼警報",
	giant_desc = "巨眼出現時發出警報",

	weakened = "虛弱警報",
	weakened_desc = "克蘇恩被削弱時發出警報",

	weakenedtrigger 	= "變弱了！",

	tentacle1	= "眼球觸鬚出現！",
	tentacle2	= "5秒後眼球觸鬚出現！",

	norape1		= "巨眼、巨爪觸鬚出現！",
	norape2		= "5秒後巨眼、巨爪觸鬚出現！",

	weakened		= "克蘇恩被削弱了 - 45秒內全力輸出傷害！",
	invulnerable2	= "削弱狀態還有5秒結束",
	invulnerable1	= "削弱狀態結束 - 停止攻擊克蘇恩！",

	giant3		= "巨眼 10 秒後出現",
	giant2		= "巨眼 5 秒後出現",
	giant1		= "巨眼出現！",

	startwarn	= "克蘇恩已進入戰鬥 - 45秒後發動黑暗閃耀, 出現巨眼",

	glare2		= "黑暗閃耀 5 秒後發動！",
	glare1		= "黑暗閃耀發動 - 跑位！",

	barTentacle	= "眼球觸鬚！",
	barNoRape	= "巨眼、巨爪觸鬚！",
	barWeakened	= "克蘇恩被削弱了！",
	barGlare	= "黑暗閃耀！",
	barGiant	= "巨眼！",
	barGreenBeam	= "綠光！",

	eyebeam		= "眼棱",
	glarewarning	= "黑暗閃耀在你身上發動了！",
	groupwarning	= "黑暗閃耀在%s小隊發動了！ %s 小隊移動！",
	positions1	= "綠光發動",
	positions2	= "5 秒後黑暗閃耀結束",
	phase2starting	= "克蘇恩之眼已死亡 - 進入第二階段！",
} end )

L:RegisterTranslations("frFR", function() return {
	weakenedtrigger = "%s est affaibli !",
	eyebeam		= "Rayon de l'Oeil",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(cthun)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Ahn'Qiraj"]
mod.enabletrigger = { eyeofcthun, cthun }
mod.toggleoptions = { "rape", -1, "tentacle", "glare", "group", -1, "giant", "weakened", "bosskill" }
mod.revision = tonumber(string.sub("$Revision$", 12, -3))

function mod:OnEnable()
	target = nil
	gianteye = nil
	cthunstarted = nil
	firstGlare = nil
	firstWarning = nil
	phase2started = nil

	tentacletime = timeP1Tentacle

	-- register events
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE") -- engage of Eye of C'Thun
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", "CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE") -- engage of Eye of C'Thun
	-- Not sure about this, since we get out of combat between the phases.
	--self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	self:RegisterEvent("BigWigs_RecvSync")

	self:TriggerEvent("BigWigs_ThrottleSync", "CThunStart", 10)
	self:TriggerEvent("BigWigs_ThrottleSync", "CThunP2Start", 10)
	self:TriggerEvent("BigWigs_ThrottleSync", "CThunWeakened", 10)
end

----------------------
--  Event Handlers  --
----------------------

function mod:CHAT_MSG_MONSTER_EMOTE( arg1 )
	if arg1 == L["weakenedtrigger"] then self:TriggerEvent("BigWigs_SendSync", "CThunWeakened") end
end

function mod:CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE( arg1 )
	if not cthunstarted and arg1 and arg1:find(L["eyebeam"]) then self:TriggerEvent("BigWigs_SendSync", "CThunStart") end
end

function mod:CHAT_MSG_COMBAT_HOSTILE_DEATH(msg)
	if (msg == string.format(UNITDIESOTHER, eyeofcthun)) then
		self:TriggerEvent("BigWigs_SendSync", "CThunP2Start")
	elseif (msg == string.format(UNITDIESOTHER, cthun)) then
		if self.db.profile.bosskill then self:TriggerEvent("BigWigs_Message", string.format(AceLibrary("AceLocale-2.2"):new("BigWigs")["%s has been defeated"], cthun), "Bosskill", nil, "Victory") end
		BigWigs:ToggleModuleActive(self, false)
	end
end

function mod:BigWigs_RecvSync( sync )
	if sync == "CThunStart" then
		self:CThunStart()
	elseif sync == "CThunP2Start" then
		self:CThunP2Start()
	elseif sync == "CThunWeakened" then
		self:CThunWeakened()
	end
end

-----------------------
--   Sync Handlers   --
-----------------------

function mod:CThunStart()
	if not cthunstarted then
		cthunstarted = true

		self:UnregisterEvent("CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE")
		self:UnregisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")

		self:TriggerEvent("BigWigs_Message", L["startwarn"], "Attention")

		if self.db.profile.tentacle then
			self:TriggerEvent("BigWigs_StartBar", self, self.db.profile.rape and L["barTentacle"] or L["barNoRape"], timeP1TentacleStart, "Interface\\Icons\\Spell_Nature_CallStorm")
			self:ScheduleEvent("bwcthuntentacle2", "BigWigs_Message", timeP1TentacleStart - 5, self.db.profile.rape and L["tentacle2"] or L["norape2"], "Urgent" )
			self:ScheduleEvent("bwcthuntentacle1", "BigWigs_Message", timeP1TentacleStart, self.db.profile.rape and L["tentacle1"] or L["norape1"], "Important" )
		end

		if self.db.profile.glare then
			self:TriggerEvent("BigWigs_StartBar", self, L["barGlare"], timeP1GlareStart, "Interface\\Icons\\Spell_Shadow_ShadowBolt")
			self:ScheduleEvent("bwcthunglare2", "BigWigs_Message", timeP1GlareStart - 5, L["glare2"], "Urgent" )
			self:ScheduleEvent("bwcthunglare1", "BigWigs_Message", timeP1GlareStart, L["glare1"], "Important" )
		end

		firstGlare = true
		firstWarning = true

		self:ScheduleEvent("bwcthuntentaclesstart", self.StartTentacleRape, timeP1TentacleStart, self )
		self:ScheduleEvent("bwcthundarkglarestart", self.DarkGlare, timeP1GlareStart, self )
		self:ScheduleEvent("bwcthungroupwarningstart", self.GroupWarning, timeP1GlareStart - 3, self )
		self:ScheduleRepeatingEvent("bwcthuntarget", self.CheckTarget, timeTarget, self )
	end
end

function mod:CThunP2Start()
	if not phase2started then
		phase2started = true
		tentacletime = timeP2Tentacle

		self:TriggerEvent("BigWigs_Message", L["phase2starting"], "Bosskill")

		self:TriggerEvent("BigWigs_StopBar", self, L["barGlare"] )
		self:TriggerEvent("BigWigs_StopBar", self, L["barTentacle"] )
		self:TriggerEvent("BigWigs_StopBar", self, L["barNoRape"] )
		self:TriggerEvent("BigWigs_StopBar", self, L["barGreenBeam"] )

		self:CancelScheduledEvent("bwcthuntentacle2")
		self:CancelScheduledEvent("bwcthuntentacle1")

		self:CancelScheduledEvent("bwcthunglare2")
		self:CancelScheduledEvent("bwcthunglare1")

		self:CancelScheduledEvent("bwcthunpositions2")
		self:CancelScheduledEvent("bwcthunpositions1")

		-- cancel the repeaters
		self:CancelScheduledEvent("bwcthuntentacles")
		self:CancelScheduledEvent("bwcthundarkglare")
		self:CancelScheduledEvent("bwcthungroupwarning")
		self:CancelScheduledEvent("bwcthuntarget")

		if self.db.profile.tentacle then
			self:ScheduleEvent("bwcthuntentacle1", "BigWigs_Message", timeP2Tentacle + timeP2Offset -.1, self.db.profile.rape and L["tentacle1"] or L["norape1"], "Important")
			self:ScheduleEvent("bwcthuntentacle2", "BigWigs_Message", timeP2Tentacle + timeP2Offset - 5, self.db.profile.rape and L["tentacle2"] or L["norape2"], "Urgent")
			self:TriggerEvent("BigWigs_StartBar", self, self.db.profile.rape and L["barTentacle"] or L["barNoRape"], timeP2Tentacle + timeP2Offset, "Interface\\Icons\\Spell_Nature_CallStorm")
		end

		if self.db.profile.giant then
			self:ScheduleEvent("bwcthungiant1", "BigWigs_Message", timeP2Tentacle + timeP2Offset -.1, L["giant1"], "Important")
			self:ScheduleEvent("bwcthungiant2", "BigWigs_Message", timeP2Tentacle + timeP2Offset - 5, L["giant2"], "Urgent")
			self:TriggerEvent("BigWigs_StartBar", self, L["barGiant"], timeP2Tentacle + timeP2Offset, "Interface\\Icons\\Ability_EyeOfTheOwl")
		end

		self:ScheduleEvent("bwcthunstarttentacles", self.StartTentacleRape, timeP2Tentacle + timeP2Offset, self )
	end

end

function mod:CThunWeakened()
	if self.db.profile.weakened then
		self:TriggerEvent("BigWigs_Message", L["weakened"], "Positive" )
		self:TriggerEvent("BigWigs_StartBar", self, L["barWeakened"], timeWeakened, "Interface\\Icons\\INV_ValentinesCandy")
		self:ScheduleEvent("bwcthunweaken2", "BigWigs_Message", timeWeakened - 5, L["invulnerable2"], "Urgent")
		self:ScheduleEvent("bwcthunweaken1", "BigWigs_Message", timeWeakened, L["invulnerable1"], "Important" )
	end

	-- cancel tentacle timers
	self:CancelScheduledEvent("bwcthuntentacle1")
	self:CancelScheduledEvent("bwcthuntentacle2")

	self:CancelScheduledEvent("bwcthungiant1")
	self:CancelScheduledEvent("bwcthungiant2")
	self:CancelScheduledEvent("bwcthungiant3")

	self:TriggerEvent("BigWigs_StopBar", self, L["barTentacle"])
	self:TriggerEvent("BigWigs_stopBar", self, L["barNoRape"])
	self:TriggerEvent("BigWigs_StopBar", self, L["barGiant"])

	-- flipflop the giant eye flag
	gianteye = not gianteye

	self:CancelScheduledEvent("bwcthuntentacles")
	self:ScheduleEvent("bwcthunstarttentacles", self.OutOfWeaken, timeReschedule, self )
end

-----------------------
-- Utility Functions --
-----------------------

function mod:OutOfWeaken()
	self:StartTentacleRape()
	-- Also fires up a big claw here, but we don't warn for them?
end

function mod:StartTentacleRape()
	self:TentacleRape()
	self:ScheduleRepeatingEvent("bwcthuntentacles", self.TentacleRape, tentacletime, self )
end

function mod:CheckTarget()
	local i
	local newtarget = nil
	if( UnitName("playertarget") == eyeofcthun ) then
		newtarget = UnitName("playertargettarget")
	else
		for i = 1, GetNumRaidMembers(), 1 do
			if UnitName("Raid"..i.."target") == eyeofcthun then
				newtarget = UnitName("Raid"..i.."targettarget")
				break
			end
		end
	end
	if( newtarget ) then
		target = newtarget
	end
end

function mod:GroupWarning()
	if target then
		local i, name, group
		for i = 1, GetNumRaidMembers(), 1 do
			name, _, group, _, _, _, _, _ = GetRaidRosterInfo(i)
			if name == target then break end
		end
		if self.db.profile.group then
			self:TriggerEvent("BigWigs_Message", string.format( L["groupwarning"], group, target), "Important")
			self:TriggerEvent("BigWigs_SendTell", target, L["glarewarning"])
		end
	end
	if firstWarning then
		self:CancelScheduledEvent("bwcthungroupwarning")
		self:ScheduleRepeatingEvent("bwcthungroupwarning", self.GroupWarning, timeP1Glare, self )
		firstWarning = nil
	end
end

function mod:TentacleRape()
	if phase2started then
		if gianteye then
			gianteye = nil
			if self.db.profile.giant then
				self:TriggerEvent("BigWigs_StartBar", self, L["barGiant"], tentacletime, "Interface\\Icons\\Ability_EyeOfTheOwl")
				self:ScheduleEvent("bwcthungiant1", "BigWigs_Message", tentacletime -.1, L["giant1"], "Important")
				self:ScheduleEvent("bwcthungiant2", "BigWigs_Message", tentacletime - 5, L["giant2"], "Urgent")
				self:ScheduleEvent("bwcthungiant3", "BigWigs_Message", tentacletime - 10, L["giant3"], "Attention")
			end
		else
			gianteye = true
		end
	end
	if self.db.profile.tentacle then
		self:TriggerEvent("BigWigs_StartBar", self, self.db.profile.rape and L["barTentacle"] or L["barNoRape"], tentacletime, "Interface\\Icons\\Spell_Nature_CallStorm")
		self:ScheduleEvent("bwcthuntentacle1", "BigWigs_Message", tentacletime -.1, self.db.profile.rape and L["tentacle1"] or L["norape1"], "Important")
		self:ScheduleEvent("bwcthuntentacle2", "BigWigs_Message", tentacletime -5, self.db.profile.rape and L["tentacle2"] or L["norape2"], "Urgent")
	end
end

function mod:DarkGlare()
	if self.db.profile.glare then
		self:TriggerEvent("BigWigs_StartBar", self, L["barGreenBeam"], timeP1GlareDuration, "Interface\\Icons\\Spell_Nature_CallStorm")
		self:TriggerEvent("BigWigs_StartBar", self, L["barGlare"], timeP1Glare, "Interface\\Icons\\Spell_Shadow_ShadowBolt")
		self:ScheduleEvent("bwcthunglare1", "BigWigs_Message", timeP1Glare - .1, L["glare1"], "Important")
		self:ScheduleEvent("bwcthunglare2", "BigWigs_Message", timeP1Glare - 5, L["glare2"], "Urgent")
		self:ScheduleEvent("bwcthunpositions1", "BigWigs_Message", timeP1GlareDuration, L["positions1"], "Important")
		self:ScheduleEvent("bwcthunpositions2", "BigWigs_Message", timeP1GlareDuration - 5, L["positions2"], "Urgent")
	end
	if firstGlare then
		self:CancelScheduledEvent("bwcthundarkglare")
		self:ScheduleRepeatingEvent("bwcthundarkglare", self.DarkGlare, timeP1Glare, self )
		firstGlare = nil
	end
end
