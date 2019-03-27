
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Battle of Dazar'alor Trash", 2070)
if not mod then return end
mod.displayName = CL.trash
mod:RegisterEnableMob(
	147497, -- Prelate Akk'al
	147830, -- Rastari Flamespeaker
	148221, -- Risen Hulk
	149556, -- Eternal Enforcer
	148667, -- Rastari Punisher
	148673 -- Vessel of Bwonsamdi
)

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.prelate = "Prelate Akk'al"
	L.flamespeaker = "Rastari Flamespeaker"
	L.hulk = "Risen Hulk"
	L.enforcer = "Eternal Enforcer"
	L.punisher = "Rastari Punisher"
	L.vessel = "Vessel of Bwonsamdi"

	L.victim = "%s stabbed YOU with %s!"
	L.witness = "%s stabbed %s with %s!"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		288808, -- Consecration
		288815, -- Breath of Fire
		{288959, "SAY"}, -- Spectral Charge
		{289772, "SAY"}, -- Impale
		289937, -- Thundering Slam
		289917, -- Bwonsamdi's Pact
		290578, -- Bwonsamdi's Knife
	}, {
		[288808] = L.prelate,
		[288815] = L.flamespeaker,
		[288959] = L.hulk,
		[289772] = L.enforcer,
		[289937] = L.punisher,
		[289917] = L.vessel,
	}
end

function mod:OnBossEnable()
	--[[ General ]]--
	self:RegisterMessage("BigWigs_OnBossEngage", "Disable")

	self:Log("SPELL_AURA_APPLIED", "ConsecrationDamage", 288808)
	self:Log("SPELL_PERIODIC_DAMAGE", "ConsecrationDamage", 288808)
	self:Log("SPELL_PERIODIC_MISSED", "ConsecrationDamage", 288808)

	self:Log("SPELL_CAST_START", "BreathOfFire", 288815)
	self:Log("SPELL_CAST_START", "SpectralCharge", 288959)
	self:Log("SPELL_AURA_APPLIED", "Impale", 289772)
	self:Log("SPELL_AURA_REMOVED", "ImpaleRemoved", 289772)
	self:Log("SPELL_CAST_START", "ThunderingSlam", 289937)
	self:Log("SPELL_AURA_APPLIED", "BwonsamdisPact", 289917)
	self:Log("SPELL_CAST_SUCCESS", "BwonsamdisKnife", 290578)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local prev = 0
	function mod:ConsecrationDamage(args)
		if self:Me(args.destGUID) then
			local t = args.time
			if t-prev > 2 then
				prev = t
				self:PlaySound(args.spellId, "alarm")
				self:PersonalMessage(args.spellId, "underyou")
			end
		end
	end
end

function mod:BreathOfFire(args)
	self:Message2(args.spellId, "red", CL.casting:format(args.spellName))
	local _, ready = self:Interrupter()
	if ready then
		self:PlaySound(args.spellId, "long")
	end
end

do
	local function printTarget(self, player, guid)
		if self:Me(guid) then
			self:Say(288959)
			self:PlaySound(288959, "warning")
		end
		self:TargetMessage2(288959, "yellow", player)
	end
	function mod:SpectralCharge(args)
		self:GetUnitTarget(printTarget, 0.3, args.sourceGUID)
	end
end

function mod:Impale(args)
	if self:Me(args.destGUID) then
		self:Say(args.spellId)
	end
	self:PlaySound(args.spellId, "long")
	self:TargetMessage2(args.spellId, "red", args.destName)
	self:TargetBar(args.spellId, 15, args.destName)
end

function mod:ImpaleRemoved(args)
	self:StopBar(args.spellId, args.destName)
end

function mod:ThunderingSlam(args)
	self:PlaySound(args.spellId, "long")
	self:Message2(args.spellId, "yellow", CL.casting:format(args.spellName))
end

function mod:BwonsamdisPact(args)
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "warning")
	end
	self:TargetMessage2(args.spellId, "orange", args.destName)
end

function mod:BwonsamdisKnife(args)
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "warning") -- Only if you were the target, the caster already knows
		self:Message2(args.spellId, "blue", L.victim:format(self:ColorName(args.sourceName), args.spellName))
	else
		self:Message2(args.spellId, "red", L.witness:format(self:ColorName(args.sourceName), self:ColorName(args.destName), args.spellName))
	end
end
