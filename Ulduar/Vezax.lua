----------------------------------
--      Module Declaration      --
----------------------------------

local boss = BB["General Vezax"]
local mod = BigWigs:New(boss, "$Revision$")
if not mod then return end
mod.zonename = BZ["Ulduar"]
mod.enabletrigger = boss
mod.guid = 33271
mod.toggleoptions = {"crash", "mark", "flame", "surge", "vapor", "spawn", "icon", "bosskill"}

------------------------------
--      Are you local?      --
------------------------------

local db = nil
started = true
add = nil
local pName = UnitName("player")
local fmt = string.format

----------------------------
--      Localization      --
----------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

L:RegisterTranslations("enUS", function() return {
	cmd = "Vezax",

	flame = "Searing Flames",
	flame_desc = "Warn when Vezax casts a Searing Flames.",
	flame_message = "Searing Flames!",

	surge = "Surge of Darkness",
	surge_desc = "Warn when Vezax gains Surge of Darkness.",
	surge_message = "Surge of Darkness!",
	surge_cast = "Surge of Darkness casting!",
	surge_end = "Surge of Darkness faded!",

	spawn = "spawn Warnings",
	spawn_desc = "Warn for adds",
	spawn_warning = "spawn soon",

	vapor = "Saronite Vapors",
	vapor_desc = "Warn for Saronite Vapors spawn.",
	vapor_bar = "Next Saronite Vapors",

	crash = "Shadow Crash",
	crash_desc = "Warn who Vezax casts Shadow Crash on.",
	crash_you = "Shadow Crash on You!",
	crash_other = "Shadow Crash on %s",

	mark = "Mark of the Faceless",
	mark_desc = "Place Icon for Mark of the Faceless.",
	mark_message_you = "You have Mark of the Faceless!",
	mark_message_other = "%s has Mark of the Faceless!",

	icon = "Place Icon",
	icon_desc = "Place a Raid Target Icon on the player targetted by Shadow Crash. (requires promoted or higher)",

	log = "|cffff0000"..boss.."|r: This boss needs data, please consider turning on your /combatlog or transcriptor and submit the logs.",
} end )

L:RegisterTranslations("koKR", function() return {
	flame = "이글거리는 불길",
	flame_desc = "이글거리는 불길의 시전을 알립니다.",
	flame_message = "이글거리는 불길!",

	surge = "어둠 쇄도",
	surge_desc = "베작스의 어둠 쇄도 획득을 알립니다.",
	surge_message = "어둠 쇄도!",
	surge_cast = "어둠 쇄도 시전!",
	surge_end = "어둠 쇄도 사라짐!",

	spawn = "소환 경고",
	spawn_desc = "소환을 알립니다",
	spawn_warning = "곧 소환!",

	vapor = "사로나이트 증기",
	vapor_desc = "사로나이트 증기 소환을 알립니다.",
	vapor_bar = "다음 증기",

	crash = "어둠 붕괴",
	crash_desc = "어둠 붕괴의 대상 플레이어를 알립니다.",
	crash_you = "당신은 어둠 붕괴!",
	crash_other = "어둠 붕괴: %s",

	mark = "얼굴 없는 자의 징표",
	mark_desc = "얼굴 없는 자의 징표 대상 플레이어에게 전술 표시를 합니다.",
	mark_message_you = "당신은 얼굴 없는 자의 징표!",
	mark_message_other = "얼굴 없는 자의 징표: %s",

	icon = "전술 표시",
	icon_desc = "어둠 붕괴 또는 얼굴 없는 자의 징표의 대상 플레이어에게 전술 표시를 지정합니다. (승급자 이상 권한 필요)",

	log = "|cffff0000"..boss.."|r: 해당 보스의 데이터가 필요합니다. 채팅창에 /전투기록 , /대화기록 을 입력하여 기록된 데이터나 transcriptor로 저장된 데이터 보내주시기 바랍니다.",
} end )

L:RegisterTranslations("frFR", function() return {
	flame = "Flammes incendiaires",
	flame_desc = "Prévient quand Vezax incante des Flammes incendiaires.",
	flame_message = "Flammes incendiaires !",

	surge = "Vague de ténèbres",
	surge_desc = "Prévient quand Vezax gagne une Vague de ténèbres.",
	surge_message = "Vague de ténèbres !",
	surge_cast = "Vague de ténèbres en incantation !",
	surge_end = "Vague de ténèbres estompée !",

	spawn = "Renforts",
	spawn_desc = "Prévient quand les renforts arrivent.",
	spawn_warning = "Renforts imminents",

	vapor = "Vapeurs de saronite",
	vapor_desc = "Prévient quand des Vapeurs de saronite apparaissent.",
	vapor_bar = "Prochaines Vapeurs",

	crash = "Déferlante d'ombre",
	crash_desc = "Prévient quand un joueur subit les effets d'une Déferlante d'ombre.",
	crash_you = "Déferlante d'ombre sur VOUS !",
	crash_other = "Déferlante d'ombre sur %s",

	mark = "Marque du Sans-visage",
	mark_desc = "Display Place Icon for Mark of the Faceless.",
	mark_message_you = "You have Mark of the Faceless!",
	mark_message_other = "%s has Mark of the Faceless!",

	icon = "Icône",
	icon_desc = "Place une icône de raid sur le dernier joueur affecté par une Déferlante d'ombre ou une Marque du Sans-visage (nécessite d'être assistant ou mieux).",

	log = "|cffff0000"..boss.."|r : ce boss a besoin de données, merci d'activer votre /combatlog ou Transcriptor et de nous transmettre les logs.",
} end )

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_CAST_START", "Flame", 62661)
	self:AddCombatListener("SPELL_CAST_START", "Surge", 62662)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Target", 60835, 62660)
	self:AddCombatListener("SPELL_AURA_APPLIED", "SurgeGain", 62662)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Mark", 63276)
	self:AddCombatListener("UNIT_DIED", "BossDeath")

	self:RegisterEvent("UNIT_HEALTH")

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")

	self:RegisterEvent("BigWigs_RecvSync")

	db = self.db.profile

	BigWigs:Print(L["log"])
end

------------------------------
--      Event Handlers      --
------------------------------

local function ScanTarget()
	local target
	if UnitName("target") == boss then
		target = UnitName("targettarget")
	elseif UnitName("focus") == boss then
		target = UnitName("focustarget")
	else
		local num = GetNumRaidMembers()
		for i = 1, num do
			if UnitName(fmt("%s%d%s", "raid", i, "target")) == boss then
				target = UnitName(fmt("%s%d%s", "raid", i, "targettarget"))
				break
			end
		end
	end
	if target then
		local other = L["crash_other"]:format(target)
		if target == pName then
			mod:Message(L["crash_you"], "Personal", true, "Alert", nil, 62660)
			mod:Message(other, "Attention", nil, nil, true)
		else
			mod:Message(other, "Attention", nil, nil, nil, 62660)
			mod:Whisper(target, L["crash_you"])
		end
		if db.icon then
			mod:Icon(target, "icon")
		end
	end
end

function mod:Mark(player, spellID)
	if db.mark then
		local other = L["mark_message_other"]:format(player)
		if player == pName then
			self:Message(L["mark_message_you"], "Personal", true, "Alert", nil, spellID)
			self:Message(other, "Attention", nil, nil, true)
		else
			self:Message(other, "Attention", nil, nil, nil, spellID)
			self:Whisper(player, L["mark_message_you"])
		end
		self:Bar(other, 10, spellID)
		if db.icon then
			self:Icon(player, "icon")
			self:ScheduleEvent("BWRemovebeamIcon", "BigWigs_RemoveRaidIcon", 10, self)
		end
	end
end

function mod:Target(player, spellId)
	if spellId == 60835 or spellId == 62660 and db.crash then
		self:ScheduleEvent("BWCrashToTScan", ScanTarget, 0.1)
		self:ScheduleEvent("BWRemovebeamIcon", "BigWigs_RemoveRaidIcon", 4, self)
	end
end

function mod:Flame(_, spellID)
	if db.flame then
		self:IfMessage(L["flame_message"], "Attention", spellID)
	end
end

function mod:Surge(_, spellID)
	if db.surge then
		self:IfMessage(L["surge_message"], "Attention", spellID)
		self:Bar(L["surge_cast"], 3, spellID)
	end
end

function mod:SurgeGain(_, spellID)
	if db.surge then
		self:Bar(L["surge"], 10, spellID)
		self:DelayedMessage(10, L["surge_end"], "Attention")
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg)
	if msg == L["vapor_trigger"] and db.vapor then
		self:IfMessage(L["vapor"], "Attention", 63322)
		self:Bar(L["vapor_bar"], 30, 63322)
	end
end

function mod:UNIT_HEALTH(msg)
	if not db.spawn then return end
	if UnitName(msg) == boss then
		local hp = UnitHealth(msg)
		if hp > 26 and hp <= 29 and not add then
			self:Message(L["spawn_warning"], "Positive")
			add = true
		elseif hp > 40 and add then
			add = false
		end
	end
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if self:ValidateEngageSync(sync, rest) and not started then
		started = true
		add = nil
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then 
			self:UnregisterEvent("PLAYER_REGEN_DISABLED") 
		end
	end
end
