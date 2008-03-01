------------------------------
--      Are you local?      --
------------------------------

local lady = BB["Lady Sacrolash"]
local lock = BB["Grand Warlock Alythess"]
local boss = BB["The Eredar Twins"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

local db = nil
local wipe = nil

local pName = UnitName("player")

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "EredarTwins",

	engage_trigger = "",
	wipe_bar = "Respawn",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = BZ["Sunwell Plateau"]
mod.enabletrigger = {lady, lock}
mod.toggleoptions = {"bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

local temp = true --remove sometime
function mod:OnEnable()
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	--self:AddCombatListener("UNIT_DIED", "GenericBossDeath")

	db = self.db.profile
	if wipe and BigWigs:IsModuleActive(boss) then
		self:Bar(L["wipe_bar"], 90, 44670)
		wipe = nil
	end
end

------------------------------
--      Event Handlers      --
------------------------------

