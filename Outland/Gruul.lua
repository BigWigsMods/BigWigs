------------------------------
--      Are you local?      --
------------------------------

local boss = BB["Gruul the Dragonkiller"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local growcount = 1
local silence = nil
local IsItemInRange = IsItemInRange
local pName = UnitName("player")
local db = nil

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

L:RegisterTranslations("enUS", function() return {
	cmd = "Gruul",

	engage_trigger = "Come.... and die.",
	engage_message = "%s Engaged!",

	grow = "Grow",
	grow_desc = "Count and warn for Grull's grow.",
	grow_message = "Grows: (%d)",
	grow_bar = "Grow (%d)",

	grasp = "Grasp",
	grasp_desc = "Grasp warnings and timers.",
	grasp_message = "Ground Slam - Shatter in ~10sec!",
	grasp_warning = "Ground Slam Soon",
	grasp_bar = "~Ground Slam Cooldown",

	cavein = "Cave In on You",
	cavein_desc = "Warn for a Cave In on You.",
	cavein_message = "Cave In on YOU!",

	silence = "Silence",
	silence_desc = "Warn when Gruul casts AOE Silence (Reverberation).",
	silence_message = "AOE Silence",
	silence_warning = "AOE Silence soon!",
	silence_bar = "~Silence Cooldown",

	shatter_message = "Shatter!",
} end)

L:RegisterTranslations("frFR", function() return {
	engage_trigger = "Venez… mourir.",
	engage_message = "%s engagé !",

	grow = "Croissance",
	grow_desc = "Compte les croissances de Grull et prévient de ses arrivées.",
	grow_message = "Croissance : (%d)",
	grow_bar = "Croissance (%d)",

	grasp = "Emprise",
	grasp_desc = "Avertissements et délais pour Emprise du seigneur gronn.",
	grasp_message = "Heurt terrestre - Emprise dans ~10 sec !",
	grasp_warning = "Heurt terrestre imminent",
	grasp_bar = "~Cooldown Heurt terrestre",

	cavein = "Eboulement sur vous",
	cavein_desc = "Prévient quand vous subissez les effets de l'Eboulement.",
	cavein_message = "Eboulement sur VOUS !",

	silence = "Silence",
	silence_desc = "Prévient quand Gruul lance son Silence de zone (Réverbération).",
	silence_message = "Silence de zone",
	silence_warning = "Silence de zone imminent !",
	silence_bar = "~Recharge Silence",

	shatter_message = "Fracasser !",
} end)

L:RegisterTranslations("deDE", function() return {
	engage_trigger = "Kommt und sterbt.",
	engage_message = "%s gepullt!",

	grow = "Wachstum", 
	grow_desc = "Warnt wenn Gruul Wachstum bekommt", 
	grow_message = "Wachstum: (%d)",
	grow_bar = "Wachstum (%d)",

	grasp = "Griff des Gronnlords",
	grasp_desc = "Griff des Gronnlords warnung und Zeitanzeige", 
	grasp_message = "Erde ersch\195\188tert - Griff kommt", 
	grasp_warning = "Erde ersch\195\188tern bald!",
	grasp_bar = "~Erde ersch\195\188tern Cooldown",

	cavein = "H\195\182hleneinst\195\188rz",
	cavein_desc = "Warnt beim H\195\182hleneinst\195\188rz auf dir",
	cavein_message = "H\195\182hleneinst\195\188rz auf dir!",

	silence = "Stille",
	silence_desc = "Warnt wenn Gruul stille (Nachwirken) wirkt",
	silence_message = "AOE Stille",
	silence_warning = "AOE Stille bald!",
	silence_bar = "~Stille Cooldown",

	shatter_message = "Zertr\195\188mmern!",
} end)

L:RegisterTranslations("koKR", function() return {
	engage_trigger = "와서... 죽어라.",
	engage_message = "%s 전투 개시!",

	grow = "성장",
	grow_desc = "그룰의 성장에 대한 카운트와 경고입니다.",
	grow_message = "성장: (%d)",
	grow_bar = "(%d) 성장",

	grasp = "손아귀",
	grasp_desc = "손아귀 경고와 타이머입니다.",
	grasp_message = "땅 울리기 - 약 10초 이내 산산조각!",
	grasp_warning = "잠시 후 땅 울리기",
	grasp_bar = "~땅 울리기 대기시간",

	cavein = "당신의 함몰",
	cavein_desc = "당신의 함몰에 대한 경고입니다.",
	cavein_message = "당신은 함몰!",

	silence = "침묵 경고",
	silence_desc = "그룰이 광역 침묵(산울림) 시전 시 경고합니다.",
	silence_message = "광역 침묵",
	silence_warning = "잠시 후 광역 침묵!",
	silence_bar = "~침묵 대기시간",

	shatter_message = "산산조각!",
} end)

L:RegisterTranslations("zhTW", function() return {
	engage_trigger = "來……受死吧。",
	engage_message = "%s 進入戰鬥",

	grow = "成長警告",
	grow_desc = "計算並當戈魯爾成長時發送警告",
	grow_message = "成長: (%d)",
	grow_bar = "成長 (%d)",

	grasp = "破碎警告",
	grasp_desc = "當戈魯爾施放大地猛擊跟破碎時發送警告並顯示計時條",
	grasp_message = "大地猛擊 - 10 秒內破碎",
	grasp_warning = "大地猛擊即將來臨!",
	grasp_bar = "<大地猛擊>",

	cavein = "塌下警告",
	cavein_desc = "當你在塌下的範圍時發送警告",
	cavein_message = "你在塌下的範圍",

	silence = "沉默警告",
	silence_desc = "當戈魯爾施放範圍沉默時發送警告 (迴響)",
	silence_message = "迴響 - 範圍沉默",
	silence_warning = "戈魯爾即將施放迴響",
	silence_bar = "<迴響>",

	shatter_message = "破碎",
} end)

L:RegisterTranslations("zhCN", function() return {
	engage_trigger = "来了……就得死。",
	engage_message = "%s 激活！",

	grow = "成长",
	grow_desc = "计算并当成长时发出警告。",
	grow_message = "成长：>%d<！",
	grow_bar = "<成长：%d>",

	grasp = "碎裂",
	grasp_desc = "碎裂警报计时条。",
	grasp_message = "大地冲击！约10秒后，破碎！",
	grasp_warning = "即将 大地冲击！",
	grasp_bar = "<大地冲击 冷却>",

	cavein = "洞穴震颤",
	cavein_desc = "当你受到洞穴震颤时发出警报。",
	cavein_message = ">你< 洞穴震颤！",

	silence = "沉默",
	silence_desc = "当群体沉默时发出警报。",
	silence_message = "群体沉默！",
	silence_warning = "即将 群体沉默！",
	silence_bar = "<沉默>",

	shatter_message = "碎裂！",
} end)

L:RegisterTranslations("esES", function() return {
	engage_trigger = "Venid... y morid.",
	engage_message = "¡%s Activado!",

	grow = "Crecimiento (Grow)",
	grow_desc = "Cuenta y avisa de los crecimientos de Gruul",
	grow_message = "Crece: (%d)",
	grow_bar = "~Crecimiento (%d)",

	grasp = "Embate en el suelo (Ground Slam)",
	grasp_desc = "Avisos de Embate en el suelo y trizar (Shatter).",
	grasp_message = "¡Embate en el suelo! - Trizar en ~10seg",
	grasp_warning = "Posible Embate",
	grasp_bar = "~Embate",

	cavein = "Sepultar (Cave In)",
	cavein_desc = "Avisa cuando Gruul utiliza Sepultar.",
	cavein_message = "¡Sepultar!",

	silence = "Reverberación (Silencio área)",
	silence_desc = "Avisa cuando Gruul lanza silencio de área. (Reverberación)",
	silence_message = "¡Reverberación - Silencio de área!",
	silence_warning = "Posible Reverberación",
	silence_bar = "~Reverberación",

	shatter_message = "Trizar",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = BZ["Gruul's Lair"]
mod.otherMenu = "Outland"
mod.enabletrigger = boss
mod.toggleoptions = {"grasp", "grow", -1, "cavein", "silence", "proximity", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))
mod.proximityCheck = function(unit)
	for k, v in pairs(bandages) do
		if IsItemInRange(k, unit) == 1 then
			return true
		end
	end
	return false
end
mod.proximitySilent = true

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_AURA_APPLIED", "CaveIn", 36240)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Grow", 36300)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Silence", 36297)
	self:AddCombatListener("SPELL_CAST_START", "Shatter", 33654)
	self:AddCombatListener("SPELL_CAST_START", "Slam", 33525)
	self:AddCombatListener("UNIT_DIED", "GenericBossDeath")

	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	db = self.db.profile
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:CaveIn(player)
	if player == pName and db.cavein then
		self:LocalMessage(L["cavein_message"], "Personal", 36240, "Alarm")
	end
end

function mod:Grow(_, spellID)
	if db.grow then
		self:IfMessage(L["grow_message"]:format(growcount), "Important", spellID)
		growcount = growcount + 1
		self:Bar(L["grow_bar"]:format(growcount), 30, spellID)
	end
end

function mod:Silence(_, spellID)
	if db.silence then
		self:IfMessage(L["silence_message"], "Attention", spellID)
		self:DelayedMessage(28, L["silence_warning"], "Urgent")
		self:Bar(L["silence_bar"], 31, spellID)
	end
end

function mod:Shatter()
	self.proximitySilent = true

	if db.grasp then
		self:IfMessage(L["shatter_message"], "Positive", 33654)
		self:DelayedMessage(56, L["grasp_warning"], "Urgent")
		self:Bar(L["grasp_bar"], 62, 33525)
	end
end

function mod:Slam(_, spellID)
	self.proximitySilent = nil

	if db.grasp then
		self:IfMessage(L["grasp_message"], "Attention", spellID)
		self:Bar(L["shatter_message"], 10, 33654)
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L["engage_trigger"] then
		silence = nil
		growcount = 1
		self.proximitySilent = true
		self:TriggerEvent("BigWigs_ShowProximity", self)

		self:Message(L["engage_message"]:format(boss), "Attention")

		if db.grasp then
			self:DelayedMessage(30, L["grasp_warning"], "Urgent")
			self:Bar(L["grasp_bar"], 33, 33525)
		end
		if db.silence then
			self:DelayedMessage(97, L["silence_warning"], "Urgent")
			self:Bar(L["silence_bar"], 102, 36297)
		end
		if db.grow then
			self:Bar(L["grow_bar"]:format(growcount), 30, 36300)
		end
	end
end

