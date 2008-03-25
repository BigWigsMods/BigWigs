------------------------------
--      Are you local?      --
------------------------------

local boss = BB["Kaz'rogal"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local db = nil

local pName = UnitName("player")
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
} end )

L:RegisterTranslations("deDE", function() return {
	range = "Reichweite Überprüfen",
	range_desc = "Aktiviert die Nähe Anzeige wenn du wenig Mana und das Mal von Kaz'rogal hast.",
} end )

L:RegisterTranslations("frFR", function() return {
	range = "Vérification de portée",
	range_desc = "Affiche la fenêtre de proximité quand votre mana est faible et que vous avez la Marque de Kaz'rogal.",
} end )

L:RegisterTranslations("koKR", function() return {
	range = "거리 확인",
	range_desc = "카즈로갈의 징표가 걸렸을 때 마나가 낮은 상태가 되면 접근 경고창을 띄웁니다.",
} end )

L:RegisterTranslations("zhTW", function() return {
	range = "距離檢查",
	range_desc = "當你低量法力且受到卡茲洛加的印記時顯示距離框",
} end )

L:RegisterTranslations("zhCN", function() return {
	range = "范围检测",
	range_desc = "当你低法力以及中了卡兹洛加印记，显示范围检测列表。",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = BZ["Hyjal Summit"]
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
	local class = select(2, UnitClass("player"))
	if class ~= "WARRIOR" and class ~= "ROGUE" then
		self:AddCombatListener("SPELL_AURA_APPLIED", "Mark", 31447)
		self:AddCombatListener("SPELL_AURA_REMOVED", "MarkRemoved", 31447)
	end

	self:AddCombatListener("UNIT_DIED", "GenericBossDeath")

	db = self.db.profile
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Mark(player)
	if player == pName and db.range and UnitMana("player") < 4000 then
		self:TriggerEvent("BigWigs_ShowProximity", self)
	end
end

function mod:MarkRemoved(player)
	if player == pName and db.range then
		self:TriggerEvent("BigWigs_HideProximity", self)
	end
end

