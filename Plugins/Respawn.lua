-------------------------------------------------------------------------------
-- Module Declaration
--

local plugin = BigWigs:NewPlugin("Respawn")
if not plugin then return end

-------------------------------------------------------------------------------
-- Locals
--

local L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Plugins")

-------------------------------------------------------------------------------
-- Initialization
--
 
function plugin:OnPluginEnable()
	self:RegisterMessage("BigWigs_EncounterEnd")
end

-------------------------------------------------------------------------------
-- Event Handlers
--

function plugin:BigWigs_EncounterEnd(event, module, id, name, difficulty, size, status)
	if status == 0 and module.respawnTime then
		self:SendMessage("BigWigs_StartBar", self, nil, L.respawn, module.respawnTime, "Interface\\Icons\\achievement_bg_returnxflags_def_wsg")
	end
end

