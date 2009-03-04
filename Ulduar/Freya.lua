----------------------------------
--      Module Declaration      --
----------------------------------

local boss = BB["Freya"]
local mod = BigWigs:New(boss, tonumber(("$Revision$"):sub(12, -3)))
if not mod then return end
mod.zonename = BZ["Ulduar"]
mod.enabletrigger = boss
mod.guid = 0	--Unknown
mod.toggleoptions = {"phase", -1, "add", "attuned", "fury", "icon", "bosskill"}

------------------------------
--      Are you local?      --
------------------------------

local db = nil
local attunedcount = 150
local dcount = 1
local ecount = 1
local pName = UnitName("player")
local fmt = string.format

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
	
	engage_trigger = "The Conservatory must be protected",
	
	phase = "Phases",
	phase_desc = "Warn for phase changes.",
	phase2_message = "Phase 2 !",
	phase2_soon = "Phase 2 soon",

	add = "Add Warnings",
	add_desc = "Warn for adds",
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
	fury_you = "You are Nature's Fury!",
	fury_other = "Fury: %s!",
	
	icon = "Place Icon",
	icon_desc = "Place a raid icon on an Nature's Fury. (Requires promoted or higher)",
	
	--end_trigger = "His hold on me dissipates. I can see clearly once more. Thank you, heroes.",
	
	log = "|cffff0000"..boss.."|r: This boss needs data, please consider turning on your /combatlog or transcriptor and submit the logs.",
} end )

L:RegisterTranslations("koKR", function() return {
	["Snaplasher"] = "Snaplasher",
	["Storm Lasher"] = "Storm Lasher",
	["Ancient Water Spirit"] = "Ancient Water Spirit",
	["Detonating Lasher"] = "Detonating Lasher",
	["Ancient Conservator"] = "Ancient Conservator",
	
	--engage_trigger = "The Conservatory must be protected",
	
	phase = "단계",
	phase_desc = "단계 변화를 알립니다.",
	phase2_message = "2 단계 !",
	phase2_soon = "곧 2 단계",
	
	add = "몹 추가 알림",
	add_desc = "몹이 추가되는 것을 알립니다.",
	--conservator_trigger = "Eonar, your servant requires aid!",
	--detonate_trigger = "The swarm of the elements shall overtake you!",
	--elementals_trigger = "Children, assist me!",
	--tree_trigger = "A Lifebinder's Gift begins to grow!",
	conservator_message = "보존자 소환",
	detonate_message = "폭파꽃 소환",
	elementals_message = "정령들 소환",
	tree_message = "생명결속자의 선물 소환",
	
	attuned = "자연의 조화",
	attuned_desc = "자연의 조화를 알립니다.",
	attuned_message = "조화: (%d)",

	fury = "자연의 분노",
	fury_desc = "자연의 분노에 걸린 플레이어를 알립니다.",
	fury_you = "당신은 자연의 분노!",
	fury_other = "분노: %s!",
	
	icon = "전술 표시",
	icon_desc = "자연의 분노 대상이된 플레이어에게 전술 표시를 지정합니다. (승급자 이상 권한 필요)",
	
	--end_trigger = "His hold on me dissipates. I can see clearly once more. Thank you, heroes.",
	
	log = "|cffff0000"..boss.."|r: 해당 보스의 데이터가 필요합니다. 채팅창에 /전투기록 , /대화기록 을 입력하여 기록된 데이터나 transcriptor로 저장된 데이터 보내주시기 바랍니다.",
} end )

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_AURA_APPLIED", "Fury", 62589, 63571)
	self:AddCombatListener("SPELL_AURA_REMOVED", "FuryRemove", 62589, 63571)
	self:AddCombatListener("SPELL_AURA_REMOVED", "AttunedRemove", 62519)
	self:AddCombatListener("UNIT_DIED", "Deaths")
	
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	attunedcount = 150
	dcount = 1
	ecount = 1
	db = self.db.profile
	
	BigWigs:Print(L["log"])
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Fury(player, spellID)
	if db.fury then
		local other = L["fury_other"]:format(player)
		if player == pName then
			self:Message(L["fury_you"], "Personal", true, "Alert", nil, spellID)
			self:Message(other, "Attention", nil, nil, true)
		else
			self:Message(other, "Attention", nil, nil, nil, spellID)
			self:Whisper(player, L["fury_you"])
		end
		self:Icon(player, "icon")
		self:Bar(other, 10, spellID)
	end
end

function mod:FuryRemove(player)
	if db.fury then
		self:TriggerEvent("BigWigs_StopBar", self, L["fury_other"]:format(player))
	end
end

function mod:AttunedRemove()
	if db.phase then
		self:Message(L["phase2_message"], "Attention")
	end
end

function mod:Deaths(unit)
	if unit == L["Detonating Lasher"] then
		attunedcount = attunedcount - 2
		if dcount == 12 then
			dcount = 0
			self:AttunedWarn()
		end
		dcount = dcount + 1
	elseif unit == L["Storm Lasher"] or unit == L["Ancient Water Spirit"] or unit == L["Snaplasher"] then
		attunedcount = attunedcount - 10
		if ecount == 3 then
			ecount = 0
			self:AttunedWarn()
		end
		ecount = ecount + 1
	elseif unit == L["Ancient Conservator"] then
		attunedcount = attunedcount - 25
		self:AttunedWarn()
	elseif unit == boss then
		self:BossDeath(nil, self.guid)
	end
end

function mod:AttunedWarn()
	if db.attuned then
		if attunedcount > 3 then
			self:Message(L["attuned_message"]:format(attunedcount), "Attention", 62519)
		elseif attunedcount > 1 and attunedcount <= 10 and db.phase then
			self:Message(L["phase2_soon"], "Attention")
		end
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg)
	if msg == L["tree_trigger"] and db.add then
		self:Message(L["tree_message"], "Positive")
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L["engage_trigger"] then
		attunedcount = 150
		dcount = 1
		ecount = 1
	elseif msg == L["conservator_trigger"] and db.add then
		self:Message(L["conservator_message"], "Positive")
	elseif msg == L["detonate_trigger"] and db.add then
		self:Message(L["detonate_message"], "Positive")
	elseif msg == L["elementals_trigger"] and db.add then
		self:Message(L["elementals_message"], "Positive")
	--[[elseif msg == L["end_trigger"] then
		if db.bosskill then
			self:Message(L["end_message"]:format(boss), "Bosskill", nil, "Victory")
		end
		BigWigs:ToggleModuleActive(self, false)
	]]
	end
end
