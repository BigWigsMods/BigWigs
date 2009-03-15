----------------------------------
--      Module Declaration      --
----------------------------------

local boss = BB["Hodir"]
local mod = BigWigs:New(boss, tonumber(("$Revision$"):sub(12, -3)))
if not mod then return end
mod.zonename = BZ["Ulduar"]
mod.enabletrigger = boss
mod.guid = 32845
mod.toggleoptions = {"flash", "frozenblow", "berserk", "bosskill"}

------------------------------
--      Are you local?      --
------------------------------

local db = nil
local started = nil
local FF = {}
local fmt = string.format

----------------------------
--      Localization      --
----------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

L:RegisterTranslations("enUS", function() return {
	cmd = "Hodir",
	
	flash = "Flash Freeze",
	flash_desc = "Tells you who has been hit by Flash Freeze and when the Flash Freeze is casting.",
	flash_message = "%s is Flash Freeze!",
	flash_warning = "Casting Flash Freeze!",
	flash_soon = "Flash Freeze in 5sec!",
	flash_bar = "Next Flash",
	
	frozenblow = "Frozen Blow",
	frozenblow_desc = "Warn when Hodir gains Frozen Blow.",
	frozenblow_message = "Hodir gained Frozen Blow!",
	frozenblow_warning = "Frozen Blow removed in 5sec!",
	frozenblow_bar = "Frozen Blow",
	
	--end_trigger = "",	--check
	--end_message = "%s has been defeated!",
	
	log = "|cffff0000"..boss.."|r: This boss needs data, please consider turning on your /combatlog or transcriptor and submit the logs.",
} end )

L:RegisterTranslations("koKR", function() return {
	flash = "급속 냉동",
	flash_desc = "급속 냉동 시전과 급속 냉동에 걸린 플레이어를 알립니다.",
	flash_message = "급속 냉동: %s!",
	flash_warning = "급속 냉동 시전!",
	flash_soon = "5초 후 급속 냉동",
	flash_bar = "다음 급속 냉동",
	
	frozenblow = "극한의 숨결",
	frozenblow_desc = "호디르의 극한의 숨결 획득을 알립니다.",
	frozenblow_message = "호디르 극한의 숨결!",
	frozenblow_warning = "극한의 숨결 5초 후 사라짐!",
	frozenblow_bar = "극한의 숨결",
	
	--end_trigger = "",	--check
	--end_message = "%s 물리침!",
	
	log = "|cffff0000"..boss.."|r: 해당 보스의 데이터가 필요합니다. 채팅창에 /전투기록 , /대화기록 을 입력하여 기록된 데이터나 transcriptor로 저장된 데이터 보내주시기 바랍니다.",
} end )

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	started = nil
	db = self.db.profile

	BigWigs:Print(L["log"])

	self:AddCombatListener("SPELL_CAST_START", "FlashCast", 61968)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Flash", 61969)
	self:AddCombatListener("SPELL_AURA_APPLIED", "FrozenBlow", 62478, 63512)
	self:AddCombatListener("UNIT_DIED", "BossDeath")

	--self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("BigWigs_RecvSync")
end

------------------------------
--      Event Handlers      --
------------------------------

--[[
function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L["end_trigger"] then
		if db.bosskill then
			self:Message(L["end_message"]:format(boss), "Bosskill", nil, "Victory")
		end
		BigWigs:ToggleModuleActive(self, false)
	end
end]]

function mod:FlashCast(_, spellID)
	if db.flash then
		self:IfMessage(L["flash_warning"], "Attention", spellID)
		self:Bar(L["flash"], 9, spellID)
		self:Bar(L["flash_bar"], 35, spellID)
		self:DelayedMessage(30, L["flash_soon"], "Attention")
	end
end

function mod:Flash(player)
	if db.flash then
		FF[player] = true
		self:ScheduleEvent("BWFFWarn", self.FlashWarn, 0.5, self)
	end
end

function mod:FlashWarn()
	if db.flash then
		local msg = nil
		for k in pairs(FF) do
			if not msg then
				msg = k
			else
				msg = msg .. ", " .. k
			end
		end
		self:IfMessage(fmt(L["flash_message"], msg), "Attention", 61969, "Alert")
	end
	for k in pairs(FF) do FF[k] = nil end
end

function mod:FrozenBlow(_, spellID)
	if db.frozenblow then
		self:IfMessage(L["frozenblow_message"], "Attention", spellID)
		self:DelayedMessage(15, L["frozenblow_warning"], "Attention")
		self:Bar(L["frozenblow_bar"], 20, spellID)
	end
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if self:ValidateEngageSync(sync, rest) and not started then
		started = true
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then 
			self:UnregisterEvent("PLAYER_REGEN_DISABLED") 
		end
		if db.flash then
			self:Bar(L["flash_bar"], 35, 61968)
		end
		if db.berserk then
			self:Enrage(540, true)
		end
	end
end
