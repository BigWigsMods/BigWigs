if not C_ChatInfo then return end -- XXX Don't load outside of 8.0

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Uldir Trash", 1861)
if not mod then return end
mod.displayName = CL.trash
mod:RegisterEnableMob(
	-- [[ XXX ]] --
	136493, -- Corrupted Watcher
)

--------------------------------------------------------------------------------
-- Locals
--

local list = mod:NewTargetList()

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	-- [[ XXX ]] --
	L.watcher = "Corrupted Watcher"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		-- [[ XXX ]] --
		{277047, "SAY"}, -- Corrupting Gaze
	}, {
		[277047] = L.watcher,
	}
end

function mod:OnBossEnable()
	--[[ General ]]--
	self:RegisterMessage("BigWigs_OnBossEngage", "Disable")

	-- [[ XXX ]] --
	self:Log("SPELL_CAST_START", "CorruptingGaze", 277047)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- [[ XXX ]] --
do
	local function printTarget(self, player, guid)
		if self:Me(guid) then
			self:Say(277047)
			self:PlaySound(277047, "warning")
		end
		self:TargetMessage(277047, player, "Attention")
	end
	function mod:CorruptingGaze(args)
		self:GetUnitTarget(printTarget, 0.3, args.sourceGUID)
	end
end
