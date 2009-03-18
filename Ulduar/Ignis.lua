----------------------------------
--      Module Declaration      --
----------------------------------

local boss = BB["Ignis the Furnace Master"]
local mod = BigWigs:New(boss, "$Revision$")
if not mod then return end
mod.zonename = BZ["Ulduar"]
mod.enabletrigger = boss
mod.guid = 33118
mod.toggleoptions = {"flame", "scorch", "slagpot", "bosskill"}

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
	cmd = "Ignis",

	flame = "Flame Jets",
	flame_desc = "Warn when Ignis casts a Flame Jets.",
	flame_message = "Flame Jets!",
	flame_warning = "Flame Jets soon!",
	flame_bar = "~Jets cooldown",

	scorch = "Scorch",
	scorch_desc = "Warn when you are in a Scorch and Scorch is casting.",
	scorch_message = "Scorch: %s",
	scorch_warning = "Casting Scorch!",
	scorch_soon = "Scorch in ~5sec!",
	scorch_bar = "Next Scorch",

	slagpot = "Slag Pot",
	slagpot_desc = "Warn who has Slag Pot.",
	slagpot_message = "Slag Pot: %s",

	log = "|cffff0000"..boss.."|r: This boss needs data, please consider turning on your /combatlog or transcriptor and submit the logs.",
} end )

L:RegisterTranslations("koKR", function() return {
	flame = "화염 분사",
	flame_desc = "이그니스의 화염 분사를 알립니다.",
	flame_message = "화염 분사!",
	flame_warning = "잠시후 화염 분사!",
	flame_bar = "~분사 대기시간",

	scorch = "불태우기",
	scorch_desc = "자신의 불태우기와 불태우기 시전을 알립니다.",
	scorch_message = "불태우기: %s",
	scorch_warning = "불태우기 시전!",
	scorch_soon = "약 5초 후 불태우기!",
	scorch_bar = "다음 불태우기",

	slagpot = "용암재 단지",
	slagpot_desc = "용암재 단지의 플레이어를 알립니다.",
	slagpot_message = "용암재 단지: %s",

	log = "|cffff0000"..boss.."|r: 해당 보스의 데이터가 필요합니다. 채팅창에 /전투기록 , /대화기록 을 입력하여 기록된 데이터나 transcriptor로 저장된 데이터 보내주시기 바랍니다.",
} end )

L:RegisterTranslations("frFR", function() return {
	flame = "Flots de flammes",
	flame_desc = "Prévient quand Ignis incante des Flots de flammes.",
	flame_message = "Flots de flammes !",
	flame_warning = "Flots de flammes imminent !",
	flame_bar = "~Recharge Flots",

	scorch = "Brûlure",
	scorch_desc = "Prévient quand vous vous trouvez dans une Brûlure et quand cette dernière est incantée.",
	scorch_message = "Brûlure : %s",
	scorch_warning = "Brûlure en incantation !",
	scorch_soon = "Brûlure dans ~5 sec. !",
	scorch_bar = "Prochaine Brûlure",

	slagpot = "Marmite de scories",
	slagpot_desc = "Prévient quand un joueur est envoyé dans la Marmite de scories.",
	slagpot_message = "Marmite de scories : %s",

	log = "|cffff0000"..boss.."|r : ce boss a besoin de données, merci d'activer votre /combatlog ou Transcriptor et de nous transmettre les logs.",
} end )

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_CAST_START", "ScorchCast", 62546, 63474)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Scorch", 62548, 63476)
	self:AddCombatListener("SPELL_AURA_APPLIED", "SlagPot", 62717, 63477)
	self:AddCombatListener("UNIT_DIED", "BossDeath")

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

function mod:ScorchCast(_, spellID)
	if db.scorch then
		self:IfMessage(L["scorch_warning"], "Attention", spellID)
		self:Bar(L["scorch_bar"], 25, spellID)
		self:DelayedMessage(20, L["scorch_soon"], "Attention")
	end
end

function mod:Scorch(player, spellID)
	if player == pName and db.scorch then
		self:LocalMessage(L["scorch_message"], "Personal", spellID, "Alarm")
	end
end

function mod:SlagPot(player, spellID)
	if db.slagpot then
		self:IfMessage(L["slagpot_message"]:format(player), "Attention", spellID)
		self:Bar(L["slagpot_message"]:format(player), 10, spellID)
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(_, unit)
	if db.flame and unit == boss then
		self:IfMessage(L["flame_message"], "Attention", 62680)
		self:Bar(L["flame_bar"], 35, 62680)
		self:DelayedMessage(32, L["flame_soon"], "Attention")
	end
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if self:ValidateEngageSync(sync, rest) and not started then
		started = true
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then 
			self:UnregisterEvent("PLAYER_REGEN_DISABLED") 
		end
		if db.flame then
			self:Bar(L["flame_bar"], 28, 62680)
			self:DelayedMessage(23, L["flame_soon"], "Attention")
		end
	end
end
