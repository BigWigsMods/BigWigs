------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Kaz'rogal"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

local UnitMana = UnitMana
local IsItemInRange = IsItemInRange
local class = select(2, UnitClass("player"))
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
	cmd = "Kazrogal",

	range = "Range Check",
	range_desc = "Show the proximity box when you are low on mana and have the Mark of Kaz'rogal.",
	range_gain = "You are afflicted by Mark of Kaz'rogal.",
	range_fade = "Mark of Kaz'rogal fades from you.",

	--marks, enrage?
} end )

L:RegisterTranslations("deDE", function() return {
	range = "Reichweite Überprüfen",
	range_desc = "Aktiviert die Nähe Anzeige wenn du wenig Mana und das Mal von Kaz'rogal hast.",
	range_gain = "Ihr seid von Mal von Kaz'rogal betroffen.",
	range_fade = "Mal von Kaz'rogal schwindet von Euch.",

	--marks, enrage?
} end )

L:RegisterTranslations("frFR", function() return {
	range = "Vérification de portée",
	range_desc = "Affiche la fenêtre de proximité quand votre mana est faible et que vous avez la Marque de Kaz'rogal.",
	range_gain = "Vous subissez les effets de Marque de Kaz'rogal.",
	range_fade = "Marque de Kaz'rogal vient de se dissiper.",
} end )

L:RegisterTranslations("koKR", function() return {
	range = "거리 확인",
	range_desc = "카즈로갈의 징표가 걸렸을 때 마나가 낮은 상태가 되면 접근 경고창을 띄웁니다.",
	range_gain = "당신은 카즈로갈의 징표에 걸렸습니다.", -- check
	range_fade = "당신의 몸에서 카즈로갈의 징표 효과가 사라졌습니다.", --check

	--marks, enrage?
} end )

L:RegisterTranslations("zhTW", function() return {
	range = "距離檢查",
	range_desc = "當你低量法力且受到卡茲洛加的印記時顯示距離框",
	range_gain = "你受到了卡茲洛加的印記效果的影響。",
	range_fade = "卡茲洛加的印記效果從你身上消失了。",
} end )

--卡兹洛加
--Ananhaid Updated 10/31 23:00
L:RegisterTranslations("zhCN", function() return {
	range = "范围检测",
	range_desc = "当你低发力以及中了卡兹洛加印记,显示范围检测表.",
	range_gain = "你受到了卡兹洛加印记效果的影响。$",
	range_fade = "卡兹洛加印记效果从你身上消失了。$",--Updated 10/31,check

} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Hyjal Summit"]
mod.enabletrigger = boss
mod.toggleoptions = {"range", "proximity", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))
mod.proximityCheck = function( unit )
	for k, v in pairs( bandages ) do
		if IsItemInRange( k, unit) == 1 then
			return true
		end
	end
	return false
end

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	if class ~= "WARRIOR" and class ~= "ROGUE" then
		self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE")
	end

	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
end

------------------------------
--      Event Handlers      --
------------------------------

local function HideProx()
	mod:UnregisterEvent("CHAT_MSG_SPELL_AURA_GONE_SELF")
	mod:TriggerEvent("BigWigs_HideProximity", self)
end

function mod:CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE(msg)
	if self.db.profile.range and msg == L["range_gain"] and UnitMana("player") < 4000 then
		self:TriggerEvent("BigWigs_ShowProximity", self)
		self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_SELF")
		self:ScheduleEvent("BWHideProx", HideProx, 5)
	end
end

function mod:CHAT_MSG_SPELL_AURA_GONE_SELF(msg)
	if self.db.profile.range and msg == L["range_fade"] then
		self:CancelScheduledEvent("BWHideProx")
		self:UnregisterEvent("CHAT_MSG_SPELL_AURA_GONE_SELF")
		self:TriggerEvent("BigWigs_HideProximity", self)
	end
end
