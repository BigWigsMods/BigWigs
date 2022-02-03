--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Anetheron", 534, 1578)
if not mod then return end
mod:RegisterEnableMob(17808)
mod:SetAllowWin(true)
mod:SetEncounterID(2469)

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		31298, -- Sleep
		{31299, "ICON"}, -- Inferno
		31306, -- Swarm
		"berserk"
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_SUCCESS", "Sleep", 31298)
	self:Log("SPELL_CAST_SUCCESS", "Swarm", 31306)
	self:Log("SPELL_CAST_START", "Inferno", 31299)

	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:Death("Win", 17808)
end

function mod:OnEngage()
	self:Berserk(600)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Sleep(args)
	self:MessageOld(args.spellId, "orange", "alert")
	self:CDBar(args.spellId, 19.5) -- 19.5~45s No idea what causes it to hold it so long.
end

function mod:Swarm(args)
	self:MessageOld(args.spellId, "yellow")
	self:CDBar(args.spellId, 11)
end

do
	local function infernoCheck(sGUID, spellId)
		local mobId = mod:GetUnitIdByGUID(sGUID)
		if mobId then
			local target = mod:UnitName(mobId.."target")
			if not target then return end
			mod:TargetMessageOld(spellId, target, "red", "alert")
			mod:PrimaryIcon(spellId, target)
			mod:ScheduleTimer("PrimaryIcon", 5, spellId)
		end
	end

	function mod:Inferno(args)
		self:DelayedMessage(args.spellId, 45, "green", CL["soon"]:format(args.spellName))
		self:CDBar(args.spellId, 50)
		self:ScheduleTimer(infernoCheck, 0.7, args.sourceGUID, args.spellId)
	end
end

