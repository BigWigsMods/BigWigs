----------------------------------
--      Module Declaration      --
----------------------------------

local boss = BB["Flame Leviathan"]
local mod = BigWigs:New(boss, "$Revision$")
if not mod then return end
mod.zonename = BZ["Ulduar"]
mod.enabletrigger = boss
mod.guid = 33113
mod.toggleoptions = {"flame", "pursues", "shutdown", "bosskill"}

------------------------------
--      Are you local?      --
------------------------------

local db = nil
local started = nil
local pName = UnitName("player")
local fmt = string.format

----------------------------
--      Localization      --
----------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

L:RegisterTranslations("enUS", function() return {
	cmd = "Leviathan",
	
	engage_trigger = "^Hostile entities detected.",
	engage_message = "%s Engaged!",
	
	flame = "Flame Jet",
	flame_desc = "Warn when Flame Leviathan casts a Flame Jet.",
	flame_message = "Flame Jet!",
	
	pursues = "pursues",
	pursues_desc = "Warn when Flame Leviathan focuses on a player.",
	pursues_other = "pursues on %s!",
	pursues_you = "pursues on YOU!",
	
	shutdown = "Systems Shutdown",
	shutdown_desc = "Warn when Flame Leviathan a Systems Shutdown",
	shutdown_trigger = "System malfunction. Diverting power to support systems.",
	shutdown_message = "Systems Shutdown!",
	
	log = "|cffff0000"..boss.."|r: This boss needs data, please consider turning on your /combatlog or transcriptor and submit the logs.",
} end )

L:RegisterTranslations("koKR", function() return {
	flame = "화염 분출",
	flame_desc = "거대 화염전차으 화염 분출 시전을 알립니다.",
	flame_message = "화염 분출!",
	
	pursues = "추적",
	pursues_desc = "플레이어에게 거대 화염전차의 추적을 알립니다.",
	pursues_other = "%s 추적!",
	pursues_you = "당신을 추적!",
	
	shutdown = "시스템 작동 정지",
	shutdown_desc = "거대 화염전차의 시스템 작동 정지를 알립니다.",
	--shutdown_trigger = "System malfunction. Diverting power to support systems.",
	shutdown_message = "시스템 작동 정지!",
	
	log = "|cffff0000"..boss.."|r: 해당 보스의 데이터가 필요합니다. 채팅창에 /전투기록 , /대화기록 을 입력하여 기록된 데이터나 transcriptor로 저장된 데이터 보내주시기 바랍니다.",
} end )

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Flame", 62396)
	self:AddCombatListener("UNIT_DIED", "BossDeath")
	
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	
	db = self.db.profile
	
	BigWigs:Print(L["log"])
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Flame()
	if db.flame then
		self:IfMessage(L["flame_message"], "Attention", spellID)
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(_, unit, _, _, player)
	if unit == boss and db.pursues then
		--53338, looks like a pursues :)
		local other = fmt(L["pursues_other"], player)
		if player == pName then
			self:LocalMessage(L["pursues_you"], "Important", 53338, "Long")
			self:WideMessage(other)
		else
			self:IfMessage(other, "Attention", 53338)
		end
		self:Bar(other, 30, 53338)
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg:find(L["engage_trigger"]) then
		self:Message(L["engage_message"], "Attention")
	elseif msg == L["shutdown_trigger"] and db.shutdown then
		self:Message(L["shutdown_message"], "Attention")
		self:Bar(L["shutdown"], 20, 62475)
	end
end
