----------------------------------
--      Module Declaration      --
----------------------------------

local boss = BB["XT-002 Deconstructor"]
local mod = BigWigs:New(boss, "$Revision$")
if not mod then return end
mod.zonename = BZ["Ulduar"]
mod.enabletrigger = boss
mod.guid = 33293
mod.toggleoptions = {"heartbreak", "gravitybombicon", "exposed", -1, "gravitybomb", "lightbomb", "proximity", "berserk", "tantrum", "bosskill"}
mod.proximityCheck = "bandage"

------------------------------
--      Are you local?      --
------------------------------

local pName = UnitName("player")
local db = nil
local phase = nil
local started = nil
local exposed1 = nil
local exposed2 = nil
local exposed3 = nil

----------------------------
--      Localization      --
----------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

L:RegisterTranslations("enUS", function() return {
	cmd = "XT-002",

	exposed = "Exposed Heart",
	exposed_desc = "Warn when XT-002 gains Exposed Heart.",
	exposed_warning = "Exposed soon",
	exposed_message = "Heart exposed!",

	gravitybomb = "Gravity Bomb",
	gravitybomb_desc = "Tells you who has been hit by Gravity Bomb.",
	gravitybomb_you = "Gravity on YOU!",
	gravitybomb_other = "Gravity on %s!",

	gravitybombicon = "Gravity Bomb Icon",
	gravitybombicon_desc = "Place a Blue Square icon on the player effected by Gravity Bomb. (requires promoted or higher)",

	lightbomb = "Light Bomb",
	lightbomb_desc = "Tells you who has been hit by Light Bomb.",
	lightbomb_you = "Light on YOU!",
	lightbomb_other = "Light on %s!",

	heartbreak = "Heartbreak",
	heartbreak_desc = "Warn when XT-002 gains Heartbreak",
	heartbreak_message = "Heartbreak!",

	tantrum = "Tympanic Tantrum",
	tantrum_desc = "Warn when XT-002 casts Tympanic Tantrum in Hard Mode",
	tantrum_message = "Tympanic Tantrum!",
	tantrum_bar = "~Tantrum Cooldown",

	icon = "Raid Icon",
	icon_desc = "Place a Raid Icon on players with Bomb. (requires promoted or higher)",
} end )

L:RegisterTranslations("koKR", function() return {
	exposed = "심장 노출",
	exposed_desc = "XT-002의 심장 노출 획득을 알립니다.",
	exposed_warning = "잠시 후 심장 노출!",
	exposed_message = "심장 노출 - 로봇들 추가!",

	gravitybomb = "중력 폭탄",
	gravitybomb_desc = "중력 폭탄에 걸린 플레이어를 알립니다.",
	gravitybomb_you = "당신은 중력 폭탄!",
	gravitybomb_other = "중력 폭탄: %s!",

	gravitybombicon = "중력 폭탄 아이콘",
	gravitybombicon_desc = "중력 폭탄에 걸린 플레이어를 네모 전술로 지정합니다. (승급자 이상 권한 필요)",

	lightbomb = "빛의 폭탄",
	lightbomb_desc = "빛의 폭탄에 걸린 플레이어를 알립니다.",
	lightbomb_you = "당신은 빛의 폭탄!",
	lightbomb_other = "빛의 폭탄: %s!",

	heartbreak = "부서진 심장",
	heartbreak_desc = "XT-002의 부서진 심장 획득을 알립니다.",
	heartbreak_message = "심장 파괴됨!",

	tantrum = "격분의 땅울림",
	tantrum_desc = "XT-002의 도전 모드시에 격분의 땅울림 시전을 알립니다.",
	tantrum_message = "격분의 땅울림!",
	tantrum_bar = "~땅울림 대기시간",

	icon = "전술 표시",
	icon_desc = "폭탄에 걸린 플레이어에게 전술 표시를 지정합니다. (승급자 이상 권한 필요)",
} end )

L:RegisterTranslations("frFR", function() return {
	exposed = "Cœur exposé",
	exposed_desc = "Prévient quand le cœur du XT-002 est exposé.",
	exposed_warning = "Cœur exposé imminent",
	exposed_message = "Cœur exposé !",

	gravitybomb = "Bombe à gravité",
	gravitybomb_desc = "Prévient quand un joueur subit les effets d'une Bombe à gravité.",
	gravitybomb_you = "Bombe à gravité sur VOUS !",
	gravitybomb_other = "Bombe à gravité : %s",

	gravitybombicon = "Bombe à gravité - Icône",
	gravitybombicon_desc = "Place une icône de raid bleue sur le dernier joueur affecté par une Bombe à gravité (nécessite d'être assistant ou mieux).",

	lightbomb = "Lumière incendiaire",
	lightbomb_desc = "Prévient quand un joueur subit les effets d'une Lumière incendiaire.",
	lightbomb_you = "Lumière incendiaire sur VOUS !",
	lightbomb_other = "Lumière incendiaire : %s",

	heartbreak = "Bris du cœur",
	heartbreak_desc = "Prévient quand le cœur du XT-002 est brisé.",
	heartbreak_message = "Bris du cœur !",

	tantrum = "Colère assourdissante",
	tantrum_desc = "Prévient quand le XT-002 incante une Colère assourdissante en mode difficile.",
	tantrum_message = "Colère assourdissante!",
	tantrum_bar = "~Recharge Colère assourdissante",

	icon = "Icône",
	icon_desc = "Place une icône de raid sur le dernier joueur affecté par une bombe (nécessite d'être assistant ou mieux).",
} end )

L:RegisterTranslations("deDE", function() return {
	exposed = "Freigelegtes Herz",
	exposed_desc = "Warnt, wenn XT-002 ein Freigelegtes Herz hat.",
	exposed_warning = "Freigelegtes Herz bald!",
	exposed_message = "Herz freigelegt!",

	gravitybomb = "Gravitationsbombe",
	gravitybomb_desc = "Warnt, wer von Gravitationsbombe getroffen wurde.",
	gravitybomb_you = "Gravitationsbombe auf DIR!",
	gravitybomb_other = "Gravitationsbombe: %s!",
	
	gravitybombicon = "Gravitationsbombe: Symbol",
	gravitybombicon_desc = "Platziert ein blaues Quadrat auf Spielern, die von Gravitationsbombe getroffen werden (benötigt Assistent oder höher).",

	lightbomb = "Lichtbombe",
	lightbomb_desc = "Warnt, wer von Lichtbombe getroffen wurde.",
	lightbomb_you = "Lichtbombe auf DIR!",
	lightbomb_other = "Lichtbombe: %s!",

	heartbreak = "Gebrochenes Herz",
	heartbreak_desc = "Warnt, wenn der XT-002 Gebrochenes Herz bekommt.",
	heartbreak_message = "Gebrochenes Herz!",

	tantrum = "Betäubender Koller",
	tantrum_desc = "Warnung und Timer für Betäubender Koller im Hard Mode.",
	tantrum_message = "Betäubender Koller!",
	tantrum_bar = "~Betäubender Koller",

	icon = "Schlachtzugs-Symbol",
	icon_desc = "Platziert ein Schlachtzugs-Symbol auf Spielern, die von einer Bombe getroffen werden (benötigt Assistent oder höher).",
} end )

L:RegisterTranslations("zhCN", function() return {
	exposed = "暴露心脏",
	exposed_desc = "当 XT-002拆解者获得暴露心脏时发出警报。",
	exposed_warning = "即将 暴露心脏！",
	exposed_message = "暴露心脏！",

	gravitybomb = "重力炸弹",
	gravitybomb_desc = "当玩家中了重力炸弹时发出警报。",
	gravitybomb_you = ">你< 重力炸弹！",
	gravitybomb_other = "重力炸弹：>%s<！",

	gravitybombicon = "重力炸弹标记",
	gravitybombicon_desc = "为中了重力炸弹的玩家打上蓝色方框标记。（需要权限）",

	lightbomb = "Light Bomb",
	lightbomb_desc = "当玩家中了Light Bomb时发出警报。",
	lightbomb_you = ">你< Light Bomb！",
	lightbomb_other = "Light Bomb：>%s<！",

	heartbreak = "心碎",
	heartbreak_desc = "当 XT-002拆解者获得心碎时发出警报。",
	heartbreak_message = "心碎！",

	tantrum = "Tympanic Tantrum",
	tantrum_desc = "当困难模式 XT-002拆解者施放Tympanic Tantrum时发出警报。",
	tantrum_message = "Tympanic Tantrum！",
	tantrum_bar = "<Tympanic Tantrum 冷却>",

	icon = "团队标记",
	icon_desc = "为中了炸弹的队员打上团队标记。（需要权限）",
} end )

L:RegisterTranslations("zhTW", function() return {
	exposed = "機心外露",
	exposed_desc = "當 XT-002拆解者獲得機心外露時發出警報。",
	exposed_warning = "即將 機心外露！",
	exposed_message = "機心外露！",

	gravitybomb = "重力炸彈",
	gravitybomb_desc = "當玩家中了重力炸彈時發出警報。",
	gravitybomb_you = ">你< 重力炸彈！",
	gravitybomb_other = "重力炸彈：>%s<！",

	gravitybombicon = "重力炸彈標記",
	gravitybombicon_desc = "為中了重力炸彈的玩家打上藍色方框標記。（需要權限）",

	lightbomb = "裂光彈",
	lightbomb_desc = "當玩家中了裂光彈時發出警報。",
	lightbomb_you = ">你< 裂光彈！",
	lightbomb_other = "裂光彈：>%s<！",

	heartbreak = "心碎",
	heartbreak_desc = "當 XT-002拆解者獲得心碎時發出警報。",
	heartbreak_message = "心碎！",

	tantrum = "躁怒",
	tantrum_desc = "當困難模式 XT-002拆解者施放躁怒時發出警報。",
	tantrum_message = "躁怒！",
	tantrum_bar = "<躁怒 冷卻>",

	icon = "團隊標記",
	icon_desc = "為中了炸彈的隊員打上團隊標記。（需要權限）",
} end )

L:RegisterTranslations("ruRU", function() return {
	exposed = "Обнаженное сердце",
	exposed_desc = "Сообщает когда XT-002 Обнажает сердце.",
	exposed_warning = "Скоро сердце станет уязвимо!",
	exposed_message = "Сердце уязвимо!",

	gravitybomb = "Гравитационная бомба",
	gravitybomb_desc = "Сообщает об игроках с Гравитационной Бомбой.",
	gravitybomb_you = "Бомба на ВАС!",
	gravitybomb_other = "Бомба на |3-5(%s)!",
	
	gravitybombicon = "Иконка Гравитационной Бомбы",
	gravitybombicon_desc = "Помечать рейдовой иконкой (синим квадратом) игрока с бомбой. (необходимо быть лидером группы или рейда)",

	lightbomb = "Светлый взрыв",
	lightbomb_desc = "Сообщает об игроках со Светлым взрывом.",
	lightbomb_you = "Взрыв на ВАС!",
	lightbomb_other = "Взрыв на |3-5(%s)!",

	heartbreak = "Разрыв сердца",
	heartbreak_desc = "Сообщает когда XT-002 получает Разрыв сердца",
	heartbreak_message = "Разрыв сердца!",
	
	tantrum = "Раскаты ярости",
	tantrum_desc = "Сообщает когда XT-002 в сложном режиме, применяет Раскаты ярости",
	tantrum_message = "Раскаты ярости!",
	tantrum_bar = "~Раскаты ярости",

	icon = "Помечать иконкой",
	icon_desc = "Помечать рейдовой иконкой игрока с бомбой. (необходимо быть лидером группы или рейда)",
} end )

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_AURA_APPLIED", "Exposed", 63849)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Heartbreak", 64193, 65737)
	self:AddCombatListener("SPELL_AURA_APPLIED", "GravityBomb", 63024, 64234)
	self:AddCombatListener("SPELL_AURA_APPLIED", "LightBomb", 63018, 65121)
	self:AddCombatListener("SPELL_AURA_REMOVED", "BombRemoved", 63018, 63024, 64234, 65121)
	self:AddCombatListener("SPELL_CAST_START", "Tantrum", 62776)
	self:AddCombatListener("UNIT_DIED", "BossDeath")
	self:RegisterEvent("UNIT_HEALTH")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("BigWigs_RecvSync")
	db = self.db.profile
	started = nil
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Exposed(_, spellID)
	if db.exposed then
		self:IfMessage(L["exposed_message"], "Attention", spellID)
		self:Bar(L["exposed"], 30, spellID)
	end
end

function mod:Heartbreak(_, spellID)
	phase = 2
	if db.heartbreak then
		self:IfMessage(L["heartbreak_message"], "Important", spellID)
	end
end

function mod:Tantrum(_, spellID)
	if phase == 2 and db.tantrum then
		self:IfMessage(L["tantrum_message"], "Attention", spellID)
		self:Bar(L["tantrum_bar"], 65, spellID)
	end
end

function mod:GravityBomb(player, spellID)
	if db.gravitybomb then
		if player == pName then
			self:LocalMessage(L["gravitybomb_you"], "Personal", spellID, "Alert")
			self:WideMessage(L["gravitybomb_other"]:format(player))
			self:TriggerEvent("BigWigs_ShowProximity", self)
		else
			self:TargetMessage(L["gravitybomb_other"], player, "Attention", spellID)
			self:Whisper(player, L["gravitybomb_you"])
		end
		self:Bar(L["gravitybomb_other"]:format(player), 9, spellID)
		if db.gravitybombicon then
			SetRaidTarget(player, 6)
		else
			self:Icon(player, "icon")
		end
	end
end

function mod:LightBomb(player, spellID)
	if db.lightbomb then
		if player == pName then
			self:LocalMessage(L["lightbomb_you"], "Personal", spellID, "Alert")
			self:WideMessage(L["lightbomb_other"]:format(player))
			self:TriggerEvent("BigWigs_ShowProximity", self)
		else
			self:TargetMessage(L["lightbomb_other"], player, "Attention", spellID)
			self:Whisper(player, L["lightbomb_you"])
		end
		self:Bar(L["lightbomb_other"]:format(player), 9, spellID)
		self:Icon(player, "icon")
	end
end

function mod:BombRemoved(player)
	if player == pName then
		self:TriggerEvent("BigWigs_HideProximity", self)
	end
end

function mod:UNIT_HEALTH(msg)
	if phase == 1 and UnitName(msg) == boss and db.exposed then
		local health = UnitHealth(msg)
		if not exposed1 and health > 86 and health <= 88 then
			exposed1 = true
			self:IfMessage(L["exposed_warning"], "Attention")
		elseif not exposed2 and health > 56 and health <= 58 then
			exposed2 = true
			self:IfMessage(L["exposed_warning"], "Attention")
		elseif not exposed3 and health > 26 and health <= 28 then
			exposed3 = true
			self:IfMessage(L["exposed_warning"], "Attention")
		end
	end
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if self:ValidateEngageSync(sync, rest) and not started then
		started = true
		phase = 1
		exposed1 = nil
		exposed2 = nil
		exposed3 = nil
		if db.berserk then
			self:Enrage(600, true)
		end
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end
	end
end

