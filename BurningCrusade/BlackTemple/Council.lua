
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("The Illidari Council", 564, 1589)
if not mod then return end
mod:RegisterEnableMob(22951, 22952, 22949, 22950) -- Lady Malande, Veras Darkshadow, Gathios the Shatterer, High Nethermancer Zerevor
mod.engageId = 608
--mod.respawnTime = 0 -- Resets, doesn't respawn

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.veras = "Veras: %s"
	L.malande = "Malande: %s"
	L.gathios = "Gathios: %s"
	L.zerevor = "Zerevor: %s"

	L.circle_heal_message = "Healed! - Next in ~20sec"
	L.circle_fail_message = "%s Interrupted! - Next in ~12sec"

	L.magical_immunity = "Immune to magical!"
	L.physical_immunity = "Immune to physical!"

	L[-15704] = "Gathios the Shatterer"
	L[-15716] = "Veras Darkshadow"
	L[-15726] = "Lady Malande"
	L[-15720] = "High Nethermancer Zerevor"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"berserk",

		--[[ Veras Darkshadow ]]--
		41476, -- Vanish
		{41485, "ICON"}, -- Deadly Poison

		--[[ Lady Malande ]]--
		41475, -- Reflective Shield
		41455, -- Circle of Healing

		--[[ Gathios the Shatterer ]]--
		41453, -- Chromatic Resistance Aura
		41450, -- Blessing of Protection
		41451, -- Blessing of Spell Warding

		--[[ High Nethermancer Zerevor ]]--
		41481, -- Flamestrike
		41482, -- Blizzard
	}, {
		[41476] = -15716, -- Veras Darkshadow
		[41475] = -15726, -- Lady Malande
		[41453] = -15704, -- Gathios the Shatterer
		[41481] = -15720, -- High Nethermancer Zerevor
	}
end

function mod:OnBossEnable()
	--[[ Veras Darkshadow ]]--
	self:Log("SPELL_AURA_APPLIED", "Vanish", 41476)
	self:Log("SPELL_AURA_REMOVED", "VanishOver", 41479)
	self:Log("SPELL_AURA_APPLIED", "DeadlyPoison", 41485)
	self:Log("SPELL_AURA_REMOVED", "DeadlyPoisonRemoved", 41485)

	--[[ Lady Malande ]]--
	self:Log("SPELL_AURA_APPLIED", "ReflectiveShield", 41475)
	self:Log("SPELL_AURA_REMOVED", "ReflectiveShieldOver", 41475)
	self:Log("SPELL_CAST_START", "CircleOfHealing", 41455)
	self:Log("SPELL_CAST_SUCCESS", "CircleOfHealingSuccess", 41455)
	self:Log("SPELL_INTERRUPT", "CircleOfHealingInterrupted", "*")

	--[[ Gathios the Shatterer ]]--
	self:Log("SPELL_AURA_APPLIED", "ChromaticResistanceAura", 41453)
	self:Log("SPELL_AURA_REMOVED", "ChromaticResistanceAuraOver", 41453)
	self:Log("SPELL_AURA_APPLIED", "BlessingOfProtection", 41450)
	self:Log("SPELL_AURA_APPLIED", "BlessingOfSpellWarding", 41451)

	--[[ High Nethermancer Zerevor ]]--
	self:Log("SPELL_AURA_APPLIED", "Damage", 41481, 41482) -- Flamestrike, Blizzard
	self:Log("SPELL_PERIODIC_DAMAGE", "Damage", 41481, 41482)
	self:Log("SPELL_PERIODIC_MISSED", "Damage", 41481, 41482)
end

function mod:OnEngage()
	self:Berserk(900)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

--[[ Veras Darkshadow ]]--
function mod:Vanish(args)
	self:MessageOld(args.spellId, "yellow", "alert", L.veras:format(args.spellName))
	self:Bar(args.spellId, 30)
end

function mod:VanishOver(args)
	self:MessageOld(41476, "green", nil, CL.over:format(args.spellName))
end

function mod:DeadlyPoison(args)
	if self:Healer() or self:Me(args.destGUID) then
		self:TargetMessageOld(args.spellId, args.destName, "red", "alarm")
	end
	self:PrimaryIcon(args.spellId, args.destName)
end

function mod:DeadlyPoisonRemoved(args)
	self:PrimaryIcon(args.spellId)
end

--[[ Lady Malande ]]--
function mod:ReflectiveShield(args)
	self:MessageOld(args.spellId, "red", "long", L.malande:format(args.spellName))
	self:Bar(args.spellId, 20)
end

function mod:ReflectiveShieldOver(args)
	self:MessageOld(args.spellId, "green", nil, CL.over:format(args.spellName))
end

function mod:CircleOfHealing(args)
	self:MessageOld(args.spellId, "orange", self:Interrupter() and "warning", L.malande:format(args.spellName))
end

function mod:CircleOfHealingSuccess(args)
	self:MessageOld(args.spellId, "orange", nil, L.circle_heal_message)
	self:CDBar(args.spellId, 20)
end

function mod:CircleOfHealingInterrupted(args)
	if args.extraSpellId == 41455 then
		self:MessageOld(41455, "orange", nil, L.circle_fail_message:format(self:ColorName(args.sourceName)))
		self:CDBar(41455, 12)
	end
end

--[[ Gathios the Shatterer ]]--
function mod:ChromaticResistanceAura(args)
	local res = self:SpellName(19726) -- 19726 = "Resistance Aura"
	self:MessageOld(args.spellId, "yellow", nil, L.gathios:format(res))
	self:Bar(args.spellId, 30, res)
end

function mod:ChromaticResistanceAuraOver(args)
	self:MessageOld(args.spellId, "green", nil, CL.over:format(self:SpellName(19726))) -- 19726 = "Resistance Aura"
end

function mod:BlessingOfProtection(args)
	if self:MobId(args.destGUID) == 22951 and self:MobId(self:UnitGUID("target")) == 22951 and not self:Healer() then -- Lady Malande
		local txt = L.malande:format(L.physical_immunity)
		self:MessageOld(args.spellId, "red", "info", txt)
		self:Bar(args.spellId, 15, txt)
	end
end

function mod:BlessingOfSpellWarding(args)
	if self:MobId(args.destGUID) == 22951 and self:MobId(self:UnitGUID("target")) == 22951 and not self:Healer() then -- Lady Malande
		local txt = L.malande:format(L.magical_immunity)
		self:MessageOld(args.spellId, "red", "info", txt)
		self:Bar(args.spellId, 15, txt)
	end
end

--[[ High Nethermancer Zerevor ]]--
do
	local prev = 0
	function mod:Damage(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 2 then
			prev = t
			self:MessageOld(args.spellId, "blue", "alarm", CL.you:format(args.spellName))
		end
	end
end
