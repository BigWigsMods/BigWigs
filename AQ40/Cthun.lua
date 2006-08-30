------------------------------
--      Are you local?      --
------------------------------

local eyeofcthun = AceLibrary("Babble-Boss-2.0")("Eye of C'Thun")
local cthun = AceLibrary("Babble-Boss-2.0")("C'Thun")
local L = AceLibrary("AceLocale-2.0"):new("BigWigs" .. cthun)

local timeP1Tentacle = 45      -- tentacle timers for phase 1
local timeP1TentacleStart = 33 -- delay for first tentacles from engage onwards, adjusted 12 seconds for 1.12
local timeP1GlareStart = 38    -- delay for first dark glare from engage onwards, adjusted 12 seconds for 1.12
local timeP1Glare = 87         -- interval for dark glare
local timeP1GlareDuration = 38 -- duration of dark glare
local timeP2Offset = 12        -- delay for all timers to restart after the Eye dies
local timeP2Tentacle = 30      -- tentacle timers for phase 2
local timeReschedule = 53      -- delay from the moment of weakening for timers to restart
local timeTarget = 0.2         -- delay for target change checking on Eye of C'Thun
local timeWeakened = 45        -- duration of a weaken

local gianteye = nil
local cthunstarted = nil
local phase2started = nil
local firstglare = nil
local firstwarning = nil
local target = nil
local tentacletime = timeP1Tentacle

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "cthun",

	tentacle_cmd = "tentacle",
	tentacle_name = "Tentacle Alert",
	tentacle_desc = "Warn for Tentacles",

	glare_cmd = "glare",
	glare_name = "Dark Glare Alert",
	glare_desc = "Warn for Dark Glare",

	group_cmd = "group",
	group_name = "Dark Glare Group Warning",
	group_desc = "Warn for Dark Glare on Group X",

	giant_cmd = "giant",
	giant_name = "Giant Eye Alert",
	giant_desc = "Warn for Giant Eyes",

	weakened_cmd = "weakened",
	weakened_name = "Weakened Alert",
	weakened_desc = "Warn for Weakened State",

	rape_cmd = "rape",
	rape_name = "Rape is never funny",
	rape_desc = "Some people just don't get hentai jokes, the bastards",

	weakenedtrigger = "%s is weakened!",

	tentacle1	= "Tentacle Rape Party - Pleasure!",
	tentacle2	= "Tentacle Rape Party - 5 sec",

	norape1		= "Tentacle Party! - What's that in your pants?",
	norape2		= "Tentacle Party! - 5 sec",


	weakened		= "C'Thun is weakened for 45 sec",
	invulnerable2	= "Party ends in 5 seconds",
	invulnerable1	= "Party over - C'Thun invulnerable",

	giant3		= "Giant Eye - 10 sec",
	giant2		= "Giant Eye - 5 sec",
	giant1		= "Giant Eye - Poke it!",

	startwarn	= "C'Thun engaged! - 33 sec until Dark Glare and Eyes",

	glare2		= "Dark glare - 5 sec",
	glare1		= "Dark glare - MOVE IT!",

	barTentacle	= "Tentacle rape party!",
	barNoRape	= "Tentacle party!",
	barWeakened	= "C'Thun is weakened!",
	barGlare	= "Dark glare!",
	barGiant	= "Giant Eye!",
	barGreenBeam	= "Green Beam!",

	eyebeam		= "Eye Beam",
	glarewarning	= "DARK GLARE ON YOU! MOVE!",
	groupwarning	= "Dark Glare on group %s (%s)",
	positions1	= "Green Beam coming",
	positions2	= "Dark Glare ends in 5 sec",
	phase2starting	= "The Eye is dead! Body incoming!",
} end )

L:RegisterTranslations("deDE", function() return {
	cmd = "cthun",

	tentacle_cmd = "tentacle",
	tentacle_name = "Tentakel",
	tentacle_desc = "Warnung vor Tentakeln.",

	glare_cmd = "glare",
	glare_name = "Dunkles Starren",
	glare_desc = "Warnung vor Dunklem Starren.",

	group_cmd = "group",
	group_name = "Dunkles Starren Gruppe",
	group_desc = "Warnung vor Dunklem Starren auf Gruppe X.",

	giant_cmd = "giant",
	giant_name = "Riesiges Auge",
	giant_desc = "Riesiges Auge", -- ?

	weakened_cmd = "weakened",
	weakened_name = "Geschw\195\164cht",
	weakened_desc = "Warnung, wenn C'Thun geschw\195\164cht ist.",

	rape_cmd = "rape",
	rape_name = "Rape is never funny", -- ?
	rape_desc = "Some people just don't get hentai jokes, the bastards", -- ?

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

	startwarn	= "C'Thun angegriffen! - 33 Sekunden bis Dunkles Starren und Augen!",

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
	weakenedtrigger 	= "약해졌습니다!",

	tentacle1	= "눈달린 촉수 등장 - 촉수 처리~~!",
	tentacle2	= "눈달린 촉수 등장 - 5초전!",
	tentacle3	= "눈달린 촉수 등장 - 10초전!",
	weakened		= "쑨이 약화되었습니다 - 45초간 최대 공격!",

	giant2		= "거대한 눈다린 촉수 - 5초전!",

	startwarn	= "쑨 시작 - 33초후 암흑의 주시",

	glare2		= "암흑의 주시 - 5초전!",
	glare1		= "암흑의 주시 - 이동!이동!",

	barTentacle	= "눈달린 촉수!",
	barweakened	= "쑨 약화!",
	barGlare	= "암흑의 주시!",

	eyebeam		= "안광",
	glarewarning	= "암흑의 주시를 당하고 있습니다! 이동!",
	groupwarning	= "암흑의 주시 %s (%s)",
} end )

L:RegisterTranslations("zhCN", function() return {
	tentacle_name = "触须警报",
	tentacle_desc = "触须出现时发出警报",

	glare_name = "黑暗闪耀警报",
	glare_desc = "黑暗闪耀发动时发出警报",

	group_name = "黑暗闪耀小队警报",
	group_desc = "黑暗闪耀发动时对小队X发出警报",

	giant_name = "巨眼警报",
	giant_desc = "巨眼出现时发出警报",

	weakened_name = "虚弱警报",
	weakened_desc = "克苏恩被削弱时发出警报",

	rape_name = "Rape is never funny",
	rape_desc = "Some people just don't get hentai jokes, the bastards",
	
	weakenedtrigger 	= "被削弱了！",

	tentacle1	= "Tentacle Rape Party - Pleasure!",
	tentacle2	= "Tentacle Rape Party - 5 sec",
	
	norape1		= "Tentacle Party! - What's that in your pants?",
	norape2		= "Tentacle Party! - 5 sec",
	
	weakened		= "克苏恩被削弱了 - 45秒内全力输出伤害！",
	invulnerable2	= "Party ends in 5 seconds",
	invulnerable1	= "Party over - C'Thun invulnerable",
	
	giant3		= "Giant Eye - 10 sec",
	giant2		= "Giant Eye - 5 sec",
	giant1		= "Giant Eye - Poke it!",

	startwarn	= "克苏恩已激活 - 33秒后发动黑暗闪耀、出现巨眼",

	glare2		= "5秒后发动黑暗闪耀！",
	glare1		= "黑暗闪耀发动 - 跑位！",

	barTentacle	= "Tentacle rape party!",
	barNoRape	= "Tentacle party!",
	barWeakened	= "克苏恩被削弱了！",
	barGlare	= "黑暗闪耀",
	barGiant	= "巨眼",
	barGreenBeam	= "绿光",

	eyebeam		= "眼棱光",
	glarewarning	= "DARK GLARE ON YOU! MOVE!",
	groupwarning	= "Dark Glare on group %s (%s)",
	positions1	= "绿光发动",
	positions2	= "5秒后黑暗闪耀结束",
	phase2starting	= "克苏恩之眼已死亡 - 进入第二阶段",
} end )



	L:RegisterTranslations("frFR", function() return {
	
	weakenedtrigger = "%s est affaibli !",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsCThun = BigWigs:NewModule(cthun)
BigWigsCThun.zonename = AceLibrary("Babble-Zone-2.0")("Ahn'Qiraj")
BigWigsCThun.enabletrigger = { eyeofcthun }
BigWigsCThun.toggleoptions = { "rape", -1, "tentacle", "glare", "group", -1, "giant", "weakened", "bosskill" }
BigWigsCThun.revision = tonumber(string.sub("$Revision$", 12, -3))

function BigWigsCThun:OnEnable()
	target = nil
	gianteye = nil
	cthunstarted = nil
	firstglare = nil
	firstwarning = nil
	phase2started = nil

	tentacletime = timeP1Tentacle

	-- register events
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")		-- weakened triggering
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")	-- start of phase2 and kill of C'Thun
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE") -- engage of Eye of C'Thun
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", "CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE") -- engage of Eye of C'Thun

	self:RegisterEvent("BigWigs_RecvSync")

	self:TriggerEvent("BigWigs_ThrottleSync", "CThunStart", 10)
	self:TriggerEvent("BigWigs_ThrottleSync", "CThunP2Start", 10)
	self:TriggerEvent("BigWigs_ThrottleSync", "CThunWeakened", 10)
end

----------------------
--  Event Handlers  --
----------------------

function BigWigsCThun:CHAT_MSG_MONSTER_EMOTE( arg1 )
	if arg1 == L["weakenedtrigger"] then self:TriggerEvent("BigWigs_SendSync", "CThunWeakened") end
end

function BigWigsCThun:CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE( arg1 )
	if not cthunstarted and arg1 and string.find(arg1, L["eyebeam"]) then self:TriggerEvent("BigWigs_SendSync", "CThunStart") end
end

function BigWigsCThun:CHAT_MSG_COMBAT_HOSTILE_DEATH(msg)
	if (msg == string.format(UNITDIESOTHER, eyeofcthun)) then
		self:TriggerEvent("BigWigs_SendSync", "CThunP2Start")
	elseif (msg == string.format(UNITDIESOTHER, cthun)) then
		if self.db.profile.bosskill then self:TriggerEvent("BigWigs_Message", string.format(AceLibrary("AceLocale-2.0"):new("BigWigs")("%s has been defeated"), cthun), "Green", nil, "Victory") end
		self.core:ToggleModuleActive(self, false)
	end
end

function BigWigsCThun:BigWigs_RecvSync( sync )
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

function BigWigsCThun:CThunStart()
	if not cthunstarted then
		cthunstarted = true

		self:UnregisterEvent("CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE")
		self:UnregisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")

		self:TriggerEvent("BigWigs_Message", L["startwarn"], "Yellow")

		if self.db.profile.tentacle then
			self:TriggerEvent("BigWigs_StartBar", self, self.db.profile.rape and L["barTentacle"] or L["barNoRape"], timeP1TentacleStart, "Interface\\Icons\\Spell_Nature_CallStorm", "Yellow", "Orange", "Red")
			self:ScheduleEvent("bwcthuntentacle2", "BigWigs_Message", timeP1TentacleStart - 5, self.db.profile.rape and L["tentacle2"] or L["norape2"], "Orange" )
			self:ScheduleEvent("bwcthuntentacle1", "BigWigs_Message", timeP1TentacleStart, self.db.profile.rape and L["tentacle1"] or L["norape1"], "Red" )
		end

		if self.db.profile.glare then
			self:TriggerEvent("BigWigs_StartBar", self, L["barGlare"], timeP1GlareStart, "Interface\\Icons\\Spell_Shadow_ShadowBolt", "Yellow", "Orange", "Red")
			self:ScheduleEvent("bwcthunglare2", "BigWigs_Message", timeP1GlareStart - 5, L["glare2"], "Orange" )
			self:ScheduleEvent("bwcthunglare1", "BigWigs_Message", timeP1GlareStart, L["glare1"], "Red" )
		end

		firstGlare = true
		firstWarning = true

		self:ScheduleEvent("bwcthuntentaclesstart", self.StartTentacleRape, timeP1TentacleStart, self )
		self:ScheduleEvent("bwcthundarkglare", self.DarkGlare, timeP1GlareStart, self )
		self:ScheduleEvent("bwcthungroupwarning", self.GroupWarning, timeP1GlareStart - 3, self )
		self:ScheduleRepeatingEvent("bwcthuntarget", self.CheckTarget, timeTarget, self )
	end
end

function BigWigsCThun:CThunP2Start()
	if not phase2started then
		phase2started = true
		tentacletime = timeP2Tentacle

		self:TriggerEvent("BigWigs_Message", L["phase2starting"], "Green")

		self:TriggerEvent("BigWigs_StopBar", self, L["barGlare"] )
		self:TriggerEvent("BigWigs_StopBar", self, L["barTentacle"] )
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
			self:ScheduleEvent("bwcthuntentacle1", "BigWigs_Message", timeP2Tentacle + timeP2Offset -.1, self.db.profile.rape and L["tentacle1"] or L["norape1"], "Red")
			self:ScheduleEvent("bwcthuntentacle2", "BigWigs_Message", timeP2Tentacle + timeP2Offset - 5, self.db.profile.rape and L["tentacle2"] or L["norape2"], "Orange")
			self:TriggerEvent("BigWigs_StartBar", self, self.db.profile.rape and L["barTentacle"] or L["barNoRape"], timeP2Tentacle + timeP2Offset, "Interface\\Icons\\Spell_Nature_CallStorm", "Yellow", "Orange", "Red" )
		end

		if self.db.profile.giant then
			self:ScheduleEvent("bwcthungiant1", "BigWigs_Message", timeP2Tentacle + timeP2Offset -.1, L["giant1"], "Red")
			self:ScheduleEvent("bwcthungiant2", "BigWigs_Message", timeP2Tentacle + timeP2Offset - 5, L["giant2"], "Orange")
			self:TriggerEvent("BigWigs_StartBar", self, L["barGiant"], timeP2Tentacle + timeP2Offset, "Interface\\Icons\\Ability_EyeOfTheOwl", "Yellow", "Orange", "Red" )
		end

		self:ScheduleEvent("bwcthunstarttentacles", self.StartTentacleRape, timeP2Tentacle + timeP2Offset, self )
	end

end

function BigWigsCThun:CThunWeakened()
	if self.db.profile.weakened then
		self:TriggerEvent("BigWigs_Message", L["weakened"], "Green" )
		self:TriggerEvent("BigWigs_StartBar", self, L["barWeakened"], timeWeakened, "Interface\\Icons\\INV_ValentinesCandy", "Yellow", "Orange", "Red")
		self:ScheduleEvent("bwcthunweaken2", "BigWigs_Message", timeWeakened - 5, L["invulnerable2"], "Orange")
		self:ScheduleEvent("bwcthunweaken1", "BigWigs_Message", timeWeakened, L["invulnerable1"], "Red" )
	end

	-- cancel tentacle timers
	self:CancelScheduledEvent("bwcthuntentacle1")
	self:CancelScheduledEvent("bwcthuntentacle2")

	self:CancelScheduledEvent("bwcthungiant1")
	self:CancelScheduledEvent("bwcthungiant2")
	self:CancelScheduledEvent("bwcthungiant3")

	self:TriggerEvent("BigWigs_StopBar", self, L["barTentacle"])
	self:TriggerEvent("BigWigs_StopBar", self, L["barGiant"])

	-- flipflop the giant eye flag
	gianteye = not gianteye

	self:CancelScheduledEvent("bwcthuntentacles")
	self:ScheduleEvent("bwcthunstarttentacles", self.StartTentacleRape, timeReschedule, self )
end

-----------------------
-- Utility Functions --
-----------------------

function BigWigsCThun:StartTentacleRape()
	self:TentacleRape()
	self:ScheduleRepeatingEvent("bwcthuntentacles", self.TentacleRape, tentacletime, self )
end


function BigWigsCThun:CheckTarget()
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

function BigWigsCThun:GroupWarning()
	if target then
		local i, name, group
		for i = 1, GetNumRaidMembers(), 1 do
			name, _, group, _, _, _, _, _ = GetRaidRosterInfo(i)
			if name == target then break end
		end
		if self.db.profile.group then
			self:TriggerEvent("BigWigs_Message", string.format( L["groupwarning"], group, target), "Red")
			self:TriggerEvent("BigWigs_SendTell", target, L["glarewarning"])
		end
	end
	if firstWarning then
		self:CancelScheduledEvent("bwcthungroupwarning")
		self:ScheduleRepeatingEvent("bwcthungroupwarning", self.GroupWarning, timeP1Glare, self )
		firstWarning = nil
	end
end

function BigWigsCThun:TentacleRape()
	if phase2started then
		if gianteye then
			gianteye = nil
			if self.db.profile.giant then
				self:TriggerEvent("BigWigs_StartBar", self, L["barGiant"], tentacletime, "Interface\\Icons\\Ability_EyeOfTheOwl", "Yellow", "Orange", "Red")
				self:ScheduleEvent("bwcthungiant1", "BigWigs_Message", tentacletime -.1, L["giant1"], "Red")
				self:ScheduleEvent("bwcthungiant2", "BigWigs_Message", tentacletime - 5, L["giant2"], "Orange")
				self:ScheduleEvent("bwcthungiant3", "BigWigs_Message", tentacletime - 10, L["giant3"], "Yellow")
			end
		else
			gianteye = true
		end
	end
	if self.db.profile.tentacle then
		self:TriggerEvent("BigWigs_StartBar", self, L["barTentacle"], tentacletime, "Interface\\Icons\\Spell_Nature_CallStorm", "Yellow", "Orange", "Red")
		self:ScheduleEvent("bwcthuntentacle1", "BigWigs_Message", tentacletime -.1, self.db.profile.rape and L["tentacle1"] or L["norape1"], "Red")
		self:ScheduleEvent("bwcthuntentacle2", "BigWigs_Message", tentacletime -5, self.db.profile.rape and L["tentacle2"] or L["norape2"], "Orange")
	end
end

function BigWigsCThun:DarkGlare()
	if self.db.profile.glare then
		self:TriggerEvent("BigWigs_StartBar", self, L["barGreenBeam"], timeP1GlareDuration, "Interface\\Icons\\Spell_Nature_CallStorm", "Yellow", "Orange", "Red")
		self:TriggerEvent("BigWigs_StartBar", self, L["barGlare"], timeP1Glare, "Interface\\Icons\\Spell_Shadow_ShadowBolt", "Green", "Yellow", "Orange", "Red")
		self:ScheduleEvent("bwcthunglare1", "BigWigs_Message", timeP1Glare - .1, L["glare1"], "Red")
		self:ScheduleEvent("bwcthunglare2", "BigWigs_Message", timeP1Glare - 5, L["glare2"], "Orange")
		self:ScheduleEvent("bwcthunpositions1", "BigWigs_Message", timeP1GlareDuration, L["positions1"], "Red")
		self:ScheduleEvent("bwcthunpositions2", "BigWigs_Message", timeP1GlareDuration - 5, L["positions2"], "Orange")
	end
	if firstGlare then
		self:CancelScheduledEvent("bwcthundarkglare")
		self:ScheduleRepeatingEvent("bwcthundarkglare", self.DarkGlare, timeP1Glare, self )
		firstGlare = nil
	end
end
