-------------------------------------------------------------------------------
-- Module Declaration
--

local plugin = BigWigs:NewPlugin("BossReset")
if not plugin then return end

-------------------------------------------------------------------------------
-- Locals
--

local L = {} -- LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Plugins")
L.bossRespawn = "%s respawns"

-------------------------------------------------------------------------------
-- Initialization
--
 
function plugin:OnPluginEnable()
	self:RegisterMessage("BigWigs_EncounterEnd")
	self:RegisterMessage("BigWigs_OnBossEngage")
end

-------------------------------------------------------------------------------
-- Event Handlers
--

function plugin:BigWigs_EncounterEnd(event, module, id, name, difficulty, size, status)
	if module.resetTime and status == 0 then
		self:SendMessage("BigWigs_StartBar", self, nil, L.bossRespawn:format(name), module.resetTime, "Interface\\Icons\\spell_nature_reincarnation")
	end
end

function plugin:BigWigs_OnBossEngage(event, module)
	self:SendMessage("BigWigs_StopBars", self)
end

