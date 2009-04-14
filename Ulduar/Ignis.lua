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

	engage_trigger = "Insolent whelps! Your blood will temper the weapons used to reclaim this world!",

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
	engage_trigger = "건방진 젖먹이들이! 세상을 되찾는데 쓸 무기를 네놈들의 피로 담금질하겠다!",	--check

	flame = "화염 분출",
	flame_desc = "이그니스의 화염 분출를 알립니다.",
	flame_message = "화염 분출!",
	flame_warning = "잠시후 화염 분출!",
	flame_bar = "~분출 대기시간",

	scorch = "불태우기",
	scorch_desc = "자신의 불태우기와 불태우기 시전을 알립니다.",
	scorch_message = "불태우기: %s",
	scorch_warning = "불태우기 시전!",
	scorch_soon = "약 5초 후 불태우기!",
	scorch_bar = "다음 불태우기",

	slagpot = "용암재 단지",
	slagpot_desc = "용암재 단지의 플레이어를 알립니다.",
	slagpot_message = "용암재 단지: %s",

	log = "|cffff0000"..boss.."|r: 해당 보스의 데이터가 필요합니다. 채팅창에 보스들의 외침, 감정표현의 스샷등을 http://cafe.daum.net/SCU15 통해 알려주세요.",
} end )

L:RegisterTranslations("frFR", function() return {
	engage_trigger = "Chiots insolents ! Les lames qui serviront à reconquérir ce monde seront trempés dans votre sang !", -- à vérifier

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

L:RegisterTranslations("deDE", function() return {
	--engage_trigger = "Insolent whelps! Your blood will temper the weapons used to reclaim this world!", -- need

	flame = "Flammenstrahlen",
	flame_desc = "Warnung vor Flammenstrahlen.",
	flame_message = "Flammenstrahlen!",
	flame_warning = "Flammenstrahlen bald!",
	flame_bar = "~Strahlen Cooldown",

	scorch = "Versengen",
	scorch_desc = "Warnung vor Versengen.",
	scorch_message = "Versengen: %s",
	scorch_warning = "Wirkt Versengen!",
	scorch_soon = "Versengen in ~5sec!",
	scorch_bar = "Nächstes Versengen",

	slagpot = "Schlackentopf",
	slagpot_desc = "Warnung wer von Schlackentopf getroffen wird.",
	slagpot_message = "Schlackentopf: %s",

	log = "|cffff0000"..boss.."|r: Dieser Boss benötigt Daten, wenn möglich schalte bitte deinen /combatlog oder Transcriptor an, und übermittle die Daten.",
} end )

L:RegisterTranslations("zhCN", function() return {
--[[
	engage_trigger = "Insolent whelps! Your blood will temper the weapons used to reclaim this world!",

	flame = "Flame Jets",
	flame_desc = "当伊格尼斯施放Flame Jets时发出警报。",
	flame_message = "Flame Jets！",
	flame_warning = "即将 Flame Jets！",
	flame_bar = "<Jets 冷却>",

	scorch = "灼烧",
	scorch_desc = "当正在施放灼烧和你中了灼烧时发出警报。",
	scorch_message = "灼烧：>%s<！",
	scorch_warning = "正在施放 灼烧！",
	scorch_soon = "约5秒后，灼烧！",
	scorch_bar = "<下一灼烧>",

	slagpot = "熔渣炉",
	slagpot_desc = "当玩家中了熔渣炉时发出警报。",
	slagpot_message = "熔渣炉：>%s<！",
]]
	log = "|cffff0000"..boss.."|r：缺乏数据，请考虑开启战斗记录（/combatlog）或 Transcriptor 记录并提交战斗记录，谢谢！",
} end )

L:RegisterTranslations("zhTW", function() return {
--	engage_trigger = "Insolent whelps! Your blood will temper the weapons used to reclaim this world!",

	flame = "烈焰噴洩",
	flame_desc = "當伊格尼司施放烈焰噴洩時發出警報。",
	flame_message = "烈焰噴洩！",
	flame_warning = "即將 烈焰噴洩！",
	flame_bar = "<烈焰噴洩 冷卻>",

	scorch = "灼燒",
	scorch_desc = "當正在施放灼燒和你中了灼燒時發出警報。",
	scorch_message = "灼燒：>%s<！",
	scorch_warning = "正在施放 灼燒！",
	scorch_soon = "約5秒后，灼燒！",
	scorch_bar = "<下一灼燒>",

	slagpot = "熔渣之盆",
	slagpot_desc = "當玩家中了熔渣之盆時發出警報。",
	slagpot_message = "熔渣之盆：>%s<！",

	log = "|cffff0000"..boss.."|r：缺乏數據，請考慮開啟戰斗記錄（/combatlog）或 Transcriptor 記錄并提交戰斗記錄，謝謝！",
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
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")

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

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L["engage_trigger"] then
		if db.flame then
			self:Bar(L["flame_bar"], 28, 62680)
			self:DelayedMessage(23, L["flame_soon"], "Attention")
		end
	end
end

