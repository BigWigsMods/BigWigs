
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Emerald Nightmare Trash", 1094)
if not mod then return end
mod.displayName = CL.trash
mod:RegisterEnableMob(
	111004 -- Gelatinized Decay
)

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.gelatinizedDecay = "Gelatinized Decay"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		--[[ Gelatinized Decay ]]--
		221059, -- Wave of Decay
		{221028, "SAY"}, -- Unstable Decay
	}, {
		[221059] = L.gelatinizedDecay,
	}
end

function mod:OnBossEnable()
	self:RegisterMessage("BigWigs_OnBossEngage", "Disable")

	--[[ Gelatinized Decay ]]--
	self:Log("SPELL_CAST_START", "WaveofDecay", 221059)
	self:Log("SPELL_AURA_APPLIED", "UnstableDecay", 221028)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

--[[ Gelatinized Decay ]]--

function mod:WaveofDecay(args)
	self:Message(args.spellId, "Urgent", self:Interrupter(args.sourceGUID) and "Info", CL.casting:format(args.spellName))
end

function mod:UnstableDecay(args)
	if self:Me(args.destGUID) then
		self:Say(args.spellId)
		self:TargetBar(args.spellId, 9, args.destName)
		self:TargetMessage(args.spellId, args.destName, "Personal", "Warning")
	end
end
