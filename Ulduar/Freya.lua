----------------------------------
--      Module Declaration      --
----------------------------------

local boss = BB["Freya"]
local mod = BigWigs:New(boss, "$Revision$")
if not mod then return end
mod.zonename = BZ["Ulduar"]
mod.enabletrigger = boss
mod.guid = 32906
mod.toggleoptions = {"phase", -1, "wave", "attuned", "fury", "sunbeam", "icon", "bosskill"}
mod.proximityCheck = function( unit )
	for k, v in pairs( bandages ) do
		if IsItemInRange( k, unit) == 1 then
			return true
		end
	end
	return false
end

------------------------------
--      Are you local?      --
------------------------------

local db = nil
local attunedCount = 150
local dCount = 1
local eCount = 1
local pName = UnitName("player")
local fmt = string.format
local bandages = {
	[21991] = true, -- Heavy Netherweave Bandage
	[21990] = true, -- Netherweave Bandage
	[14530] = true, -- Heavy Runecloth Bandage
	[14529] = true, -- Runecloth Bandage
	[8545] = true, -- Heavy Mageweave Bandage
	[8544] = true, -- Mageweave Bandage
	[6451] = true, -- Heavy Silk Bandage
	[6450] = true, -- Silk Bandage
	[3531] = true, -- Heavy Wool Bandage
	[3530] = true, -- Wool Bandage
	[2581] = true, -- Heavy Linen Bandage
	[1251] = true, -- Linen Bandage
}

----------------------------
--      Localization      --
----------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

L:RegisterTranslations("enUS", function() return {
	["Snaplasher"] = "Snaplasher",
	["Storm Lasher"] = "Storm Lasher",
	["Ancient Water Spirit"] = "Ancient Water Spirit",
	["Detonating Lasher"] = "Detonating Lasher",
	["Ancient Conservator"] = "Ancient Conservator",

	cmd = "Freya",

	engage_trigger = "The Conservatory must be protected!",
	engage_message = "%s Engaged!",

	phase = "Phases",
	phase_desc = "Warn for phase changes.",
	phase2_message = "Phase 2 !",
	phase2_soon = "Phase 2 soon",

	wave = "Waves",
	wave_desc = "Warn for Waves.",
	wave_bar = "Next Wave",
	conservator_trigger = "Eonar, your servant requires aid!",
	detonate_trigger = "The swarm of the elements shall overtake you!",
	elementals_trigger = "Children, assist me!",
	tree_trigger = "A Lifebinder's Gift begins to grow!",
	conservator_message = "Conservator spawn",
	detonate_message = "Detonate spawn",
	elementals_message = "Elementals spawn",
	tree_message = "Eonar's Gift spawn",

	attuned = "Attuned to Nature",
	attuned_desc = "Warn for Attuned to Nature.",
	attuned_message = "Attuned: (%d)",

	fury = "Nature's Fury",
	fury_desc = "Tells you who has been hit by Nature's Fury.",
	fury_you = "Fury on You!",
	fury_other = "Fury: %s",

	sunbeam = "Sunbeam",
	sunbeam_desc = "Warn who Freya casts Sunbeam on.",
	sunbeam_you = "Sunbeam on You!",
	sunbeam_other = "Sunbeam on %s",

	icon = "Place Icon",
	icon_desc = "Place a Raid Target Icon on the player targetted by Sunbeam. (requires promoted or higher)",

	end_trigger = "His hold on me dissipates. I can see clearly once more. Thank you, heroes.",
	end_message = "%s has been defeated!",

	log = "|cffff0000"..boss.."|r: This boss needs data, please consider turning on your /combatlog or transcriptor and submit the logs.",
} end )

L:RegisterTranslations("koKR", function() return {
	["Snaplasher"] = "악어덩굴손",
	["Storm Lasher"] = "폭풍덩굴손",
	["Ancient Water Spirit"] = "고대 물의 정령",
	["Detonating Lasher"] = "폭발 덩굴손",	--check
	["Ancient Conservator"] = "고대의 수호자",	--check

	engage_trigger = "어떻게 해서든 정원을 수호해야 한다!",	--check
	engage_message = "%s 전투 시작!",

	phase = "단계",
	phase_desc = "단계 변화를 알립니다.",
	phase2_message = "2 단계 !",
	phase2_soon = "곧 2 단계",

	wave = "웨이브",
	wave_desc = "웨이브에 대해 알립니다.",
	wave_bar = "다음 웨이브",
	conservator_trigger = "이오나여, 당신의 종이 도움을 청합니다!",	--check
	detonate_trigger = "정령의 무리가 너희를 덮치리라!",	--check
	elementals_trigger = "얘들아, 날 도와라!",	--check
	tree_trigger = "A Lifebinder's Gift begins to grow!",	--check
	conservator_message = "보존자 소환",
	detonate_message = "폭파꽃 소환",
	elementals_message = "정령들 소환",
	tree_message = "생명결속자의 선물 소환",

	attuned = "자연 조화",
	attuned_desc = "자연 조화를 알립니다.",
	attuned_message = "조화: (%d)",

	fury = "자연의 격노",
	fury_desc = "자연의 격노에 걸린 플레이어를 알립니다.",
	fury_you = "당신은 자연의 격노!",
	fury_other = "자연의 격노: %s!",

	sunbeam = "일광",
	sunbeam_desc = "프레이야의 일광 시전 대상을 알립니다.",
	sunbeam_you = "당신에게 일광!",
	sunbeam_other = "일광: %s",

	icon = "전술 표시",
	icon_desc = "일광 대상이된 플레이어에게 전술 표시를 지정합니다. (승급자 이상 권한 필요)",

	end_trigger = "내게서 그의 지배력이 거쳤다. 다시 온전한 정신을 찾았도다. 영웅들이여, 고맙다.",	--check
	end_message = "%s 물리침!",

	log = "|cffff0000"..boss.."|r: 해당 보스의 데이터가 필요합니다. 채팅창에 /전투기록 , /대화기록 을 입력하여 기록된 데이터나 transcriptor로 저장된 데이터 보내주시기 바랍니다.",
} end )

L:RegisterTranslations("frFR", function() return {
	--["Snaplasher"] = "Snaplasher",
	--["Storm Lasher"] = "Storm Lasher",
	--["Ancient Water Spirit"] = "Ancient Water Spirit",
	--["Detonating Lasher"] = "Detonating Lasher",
	--["Ancient Conservator"] = "Ancient Conservator",

	engage_trigger = "Le jardin doit être protégé !", -- à vérifier
	engage_message = "%s engagée !",

	phase = "Phases",
	phase_desc = "Prévient quand la recontre entre dans une nouvelle phase.",
	phase2_message = "Phase 2 !",
	phase2_soon = "Phase 2 imminente",

	wave = "Vagues",
	wave_desc = "Prévient de l'arrivée des vagues.",
	wave_bar = "Prochaine vague",
	conservator_trigger = "Eonar, ta servante a besoin d'aide !", -- à vérifier
	detonate_trigger = "La nuée des éléments va vous submerger !", -- à vérifier
	elementals_trigger = "Mes enfants, venez m'aider !", -- à vérifier
	--tree_trigger = "A Lifebinder's Gift begins to grow!",
	conservator_message = "Conservateur apparu",
	detonate_message = "Detonate apparu",
	elementals_message = "Élémentaires apparu",
	tree_message = "Don d'Eonar apparu",

	attuned = "En harmonie avec la Nature",
	attuned_desc = "Warn for Attuned to Nature.",
	attuned_message = "En harmonie : (%d)",

	fury = "Fureur de la nature",
	fury_desc = "Prévient quand un joueur subit les effets de la Fureur de la nature.",
	fury_you = "Fureur sur vous !",
	fury_other = "Fureur : %s",

	sunbeam = "Rayon de soleil",
	sunbeam_desc = "Prévient quand un joueur subit les effets du Rayon de soleil.",
	sunbeam_you = "Rayon de soleil sur vous !",
	sunbeam_other = "Rayon de soleil sur %s",

	icon = "Icône",
	icon_desc = "Place une icône de raid sur le dernier joueur affecté par le Rayon de soleil (nécessite d'être assistant ou mieux).",

	end_trigger = "Son emprise sur moi se dissipe. J'y vois à nouveau clair. Merci, héros.", -- à vérifier
	end_message = "%s a été vaincu !",

	log = "|cffff0000"..boss.."|r : ce boss a besoin de données, merci d'activer votre /combatlog ou Transcriptor et de nous transmettre les logs.",
} end )

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_CAST_START", "Sunbeam", 62623, 62872)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Fury", 62589, 63571)
	self:AddCombatListener("SPELL_AURA_REMOVED", "FuryRemove", 62589, 63571)
	self:AddCombatListener("SPELL_AURA_REMOVED", "AttunedRemove", 62519)
	self:AddCombatListener("UNIT_DIED", "Deaths")

	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	attunedCount = 150
	dCount = 1
	eCount = 1
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
		local other = L["sunbeam_other"]:format(target)
		if target == pName then
			mod:Message(L["sunbeam_you"], "Personal", true, "Alert", nil, 62872)
			mod:Message(other, "Attention", nil, nil, true)
		else
			mod:Message(other, "Attention", nil, nil, nil, 62872)
			mod:Whisper(player, L["sunbeam_you"])
		end
		if mod.db.profile.icon then
			mod:Icon(target)
		end
	end
end

function mod:Sunbeam()
	if db.sunbeam then
		self:ScheduleEvent("BWsunbeamToTScan", ScanTarget, 0.1)
		self:ScheduleEvent("BWRemovebeamIcon", "BigWigs_RemoveRaidIcon", 4, self)
	end
end

function mod:Fury(player, spellID)
	if db.fury then
		local other = L["fury_other"]:format(player)
		if player == pName then
			self:Message(L["fury_you"], "Personal", true, "Alert", nil, spellID)
			self:Message(other, "Attention", nil, nil, true)
			self:TriggerEvent("BigWigs_ShowProximity", self)
		else
			self:Message(other, "Attention", nil, nil, nil, spellID)
			self:Whisper(player, L["fury_you"])
		end
		self:Bar(other, 10, spellID)
		self:Icon(player, "icon")
	end
end

function mod:FuryRemove(player)
	if db.fury then
		self:TriggerEvent("BigWigs_StopBar", self, L["fury_message"]:format(player))
	end
end

function mod:AttunedRemove()
	if db.phase then
		self:Message(L["phase2_message"], "Attention")
	end
end

function mod:Deaths(unit)
	if unit == L["Detonating Lasher"] then
		attunedCount = attunedCount - 2
		if dCount == 12 then
			dCount = 0
			self:AttunedWarn()
		end
		dCount = dCount + 1
	elseif unit == L["Storm Lasher"] or unit == L["Ancient Water Spirit"] or unit == L["Snaplasher"] then
		attunedCount = attunedCount - 10
		if eCount == 3 then
			eCount = 0
			self:AttunedWarn()
		end
		eCount = eCount + 1
	elseif unit == L["Ancient Conservator"] then
		attunedCount = attunedCount - 25
		self:AttunedWarn()
	end
end

function mod:AttunedWarn()
	if db.attuned then
		if attunedCount > 3 then
			self:Message(L["attuned_message"]:format(attunedCount), "Attention", 62519)
		elseif attunedCount > 1 and attunedCount <= 10 and db.phase then
			self:Message(L["phase2_soon"], "Attention")
		end
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg)
	if msg == L["tree_trigger"] and db.wave then
		self:Message(L["tree_message"], "Positive")
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L["engage_trigger"] then
		attunedCount = 150
		dCount = 1
		eCount = 1
		self:Message(L["engage_message"]:format(boss), "Attention")
		if db.wave then
			--35594, looks like a wave :)
			Bar(L["wave_bar"], 11, 35594)
		end
	elseif msg == L["conservator_trigger"] and db.wave then
		self:Message(L["conservator_message"], "Positive")
		Bar(L["wave_bar"], 60, 35594)
	elseif msg == L["detonate_trigger"] and db.wave then
		self:Message(L["detonate_message"], "Positive")
		Bar(L["wave_bar"], 60, 35594)
	elseif msg == L["elementals_trigger"] and db.wave then
		self:Message(L["elementals_message"], "Positive")
		Bar(L["wave_bar"], 60, 35594)
	elseif msg == L["end_trigger"] then
		if db.bosskill then
			self:Message(L["end_message"]:format(boss), "Bosskill", nil, "Victory")
		end
		BigWigs:ToggleModuleActive(self, false)
	end
end
