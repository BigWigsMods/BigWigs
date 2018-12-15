
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Uldir Trash", 1861)
if not mod then return end
mod.displayName = CL.trash
mod:RegisterEnableMob(
	136493, -- Corrupted Watcher
	136499, -- Nazmani Ascendant
	142802 -- Nazmani Dominator
)

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.watcher = "Corrupted Watcher"
	L.ascendant = "Nazmani Ascendant"
	L.dominator = "Nazmani Dominator"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{277047, "SAY"}, -- Corrupting Gaze
		276540, -- Blood Shield
		278990, -- Bloodshot Rage
	}, {
		[277047] = L.watcher,
		[276540] = L.ascendant,
		[278990] = L.dominator,
	}
end

function mod:OnBossEnable()
	--[[ General ]]--
	self:RegisterMessage("BigWigs_OnBossEngage", "Disable")

	self:Log("SPELL_CAST_START", "CorruptingGaze", 277047)
	self:Log("SPELL_CAST_START", "BloodShield", 276540)
	self:Log("SPELL_AURA_APPLIED", "BloodshotRage", 278990)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local function printTarget(self, player, guid)
		if self:Me(guid) then
			self:Say(277047)
			self:PlaySound(277047, "warning")
		end
		self:TargetMessage2(277047, "yellow", player)
	end
	function mod:CorruptingGaze(args)
		self:GetUnitTarget(printTarget, 0.3, args.sourceGUID)
	end
end

function mod:BloodShield(args)
	self:PlaySound(args.spellId, "long")
	self:Message2(args.spellId, "red", CL.casting:format(args.spellName))
end

function mod:BloodshotRage(args)
	self:PlaySound(args.spellId, "long")
	self:Message2(args.spellId, "red", CL.other:format(args.spellName, L.dominator))
end
