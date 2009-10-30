--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Sindragosa", "Icecrown Citadel")
if not mod then return end

mod:RegisterEnableMob(36853)
mod.toggleOptions = {69846, 71047, 71056, {70126, "ICON"}, "bosskill"}

-- 69846 = Frost Bomb (Fires a missile towards a random target. When this missile lands, it deals 5655 to 6345 Shadow damage to all enemies within 10 yards of that location.)
-- 70126= Frost Beacon (mark for 70157 frost tomb)
-- 71056 = Frostbreath (Frost damage to enemies in a 60 yard cone in front of the caster. In addition, the targets' attack speed and chance to dodge are decreased by 50% for 6 sec.)
 --71047 = Blistering Cold/ 5 sec cast /Deals 35000 Frost damage to enemies within 25 yards.

--------------------------------------------------------------------------------
-- Locals
--

local pName = UnitName("player")

--------------------------------------------------------------------------------
-- Locals
--

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Sindragosa", "enUS", true)
if L then

end
local L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Sindragosa")
mod.locale = L
--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnRegister()
	boss = BigWigs:Translate(boss)
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "FrostBeacon", 70126)
	self:Log("SPELL_CAST_START", "BlisteringCold", 71047) 

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:Death("Win", 36853)
end

--------------------------------------------------------------------------------
-- Event Handlers
--
