
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Amber-Shaper Un'sok", 897, 737)
if not mod then return end
mod:RegisterEnableMob(62511)

--------------------------------------------------------------------------------
-- Locales
--

local reshapeLife, amberExplosion, breakFree = (GetSpellInfo(122784)), (GetSpellInfo(122398)), (GetSpellInfo(123060))
local explosion = mod:SpellName(106966)
local phase, phase2warned
local amberMonstrosoty = EJ_GetSectionInfo(6254)

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.explosion_casting = "Explosion casting"
	L.explosion_casting_desc = "Warning for when any of the Amber Explosions are being casted. Cast start message warnings are associated to this option. Emphasizing this is highly recommended!"
	L.explosion_casting_icon = 122398

	L.willpower = "Willpower"
	L.willpower_desc = "When Willpower runs out, the player dies and the Mutated Construct continues to act, uncontrolled."
	L.willpower_icon = 124824
	L.willpower_message = "Your willpower is: %d (%d)"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		122784, { 122398, "FLASHSHAKE" }, 123060, "willpower",
		"ej:6246", { 122402, "FLASHSHAKE" },
		122556,
		121995, "explosion_casting", 123020,
		"berserk", "bosskill",
	}, {
		[122784] = "ej:6248",
		["ej:6246"] = "ej:6246",
		[122556] = "ej:6247",
		[121995] = "general",
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_SUCCESS", "ReshapeLife", 122784)
	self:Log("SPELL_CAST_REMOVED", "ReshapeLifeRemoved", 122784)
	self:Log("SPELL_CAST_SUCCESS", "Beam", 121995)
	self:Log("SPELL_CAST_START", "AmberExplosion", 122398)
	self:Log("SPELL_CAST_START", "AmberExplosionMonstrosity", 122402)
	self:Log("SPELL_CAST_SUCCESS", "AmberCarapace", 122540)
	self:Log("SPELL_CAST_APPLIED", "ConcentratedMutation", 122556)
	self:Log("SPELL_DAMAGE", "BurningAmber", 122504)
	self:Log("SPELL_INTERRUPT", "ExplosionInterrupt", 122402, 122398)

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Death("Win", 62511)
end

function mod:OnEngage(diff)
	self:Bar(122784, reshapeLife, 20, 122784)
	self:Berserk(480) -- assume
	phase = 1
	self:RegisterEvent("UNIT_HEALTH_FREQUENT")
	phase2warned = false
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local prev = 0
	function mod:BurningAmber(player, _, _, _, spellName)
		if not UnitIsUnit(player, "player") then return end
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:LocalMessage(123020, CL["underyou"]:format(spellName), "Personal", 123020, "Alarm")
		end
	end
end

function mod:ExplosionInterrupt(player)
	if UnitIsUnit("player", player) then
		self:StopBar(CL["cast"]:format(CL["you"]:format(explosion)))
	elseif UnitIsUnit("boss2", player) then -- Monstrosity ( double check if it is always boss2 )
		self:StopBar(CL["onboss"]:format(explosion))
	end
end

function mod:AmberExplosionMonstrosity(_, _, _, _, spellName)
	if UnitDebuff("player", reshapeLife) then
		self:FlashShake(122402)
	end
	self:DelayedMessage(122402, 25, CL["custom_sec"]:format(explosion, 20), "Attention", 122402)
	self:DelayedMessage(122402, 30, CL["custom_sec"]:format(explosion, 15), "Attention", 122402)
	self:DelayedMessage(122402, 35, CL["custom_sec"]:format(explosion, 10), "Attention", 122402)
	self:Bar("explosion_casting", CL["cast"]:format(explosion), 6, 122398)
	self:Bar(122402, "~"..CL["onboss"]:format(explosion), 45, 122402) -- cooldown, don't move this
	self:Message("explosion_casting", CL["onboss"]:format(explosion), "Important", 122402, "Alert") -- associate the message with the casting toggle option
end

function mod:ConcentratedMutation(_, _, _, _, spellName)
	phase = 3
	self:Message(122556, spellName, "Attention", 122556)
	self:StopBar("~"..CL["onboss"]:format(explosion))
end

function mod:AmberCarapace()
	phase = 2
	self:Message("ej:6246", amberMonstrosoty, "Attention", 122540)
	self:DelayedMessage(122402, 38, CL["custom_sec"]:format(explosion, 20), "Attention", 122402)
	self:DelayedMessage(122402, 43, CL["custom_sec"]:format(explosion, 15), "Attention", 122402)
	self:DelayedMessage(122402, 48, CL["custom_sec"]:format(explosion, 10), "Attention", 122402)
	self:Bar(122402, CL["onboss"]:format(explosion), 58, 122402) -- this is for the Monstrosity
end

function mod:ReshapeLife(player, _, _, _, spellName)
	self:TargetMessage(122784, spellName, player, "Urgent", 122784, "Alarm")
	if phase < 3 then
		self:Bar(122784, spellName, 50, 122784)
	else
		self:Bar(122784, spellName, 15, 122784) -- might be too short for a bar
	end
	if UnitIsUnit("player", player) then
		self:RegisterEvent("UNIT_POWER")
		self:Bar(122398, CL["you"]:format(explosion), 15, 122398)
	end
end

function mod:ReshapeLifeRemoved(player)
	if UnitIsUnit("player", player) then
		self:UnregisterEvent("UNIT_POWER")
		self:StopBar(CL["you"]:format(explosion))
	end
end

function mod:Beam(_, _, _, _, spellName)
	-- don't think this needs a bar
	self:TargetMessage(121995, spellName, "Attention", 121995)
end

function mod:AmberExplosion(_, _, player, _, spellName)
	if UnitIsUnit("player", player) then
		self:FlashShake(122398)
		self:Bar("explosion_casting", CL["cast"]:format(CL["you"]:format(explosion)), 2.5, 122398)
		self:Bar(122398, CL["you"]:format(explosion), 13, 122398) -- cooldown
		self:LocalMessage("explosion_casting", CL["you"]:format(explosion), "Personal", 122398, "Info") -- associate the message with the casting toggle option
	end
end

do
	local prev = 0
	function mod:UNIT_POWER(_, unitId)
		if unitId == "player" then
			local t = GetTime()
			if t-prev > 2 then
				local willpower = UnitPower("player", 10) / UnitPowerMax("player", 10) * 100 -- XXX 10 is supposed to be alternate power, but need to doubble check it
				if willpower < 20 then
					prev = t
					self:LocalMessage("willpower", L["willpower_message"]:format((UnitPower("player", 10)), willpower), "Personal", 124824) -- XXX 10 here too, but might just use % dependaing on values
				end
			end
		end
	end
end

do
	local prev = 0
	function mod:UNIT_HEALTH_FREQUENT(_, unitId)
		if unitId == "boss1" then
			local hp = UnitHealth(unitId) / UnitHealthMax(unitId) * 100
			if hp < 75 and not phase2warned then -- phase starts at 70
				phase2warned = true
				self:Message("ej:6246", CL["soon"]:format(amberMonstrosoty), "Positive", 122540, "Long") -- somewhat relevant icon
			end
		elseif unitId == "player" then
			local t = GetTime()
			if t-prev > 2 then
				if not UnitDebuff("player", reshapeLife) then return end
				local hp = UnitHealth("player") / UnitHealthMax("player") * 100
				-- don't know how useful, since your hp might bounce up and down
				if hp < 20 then
					prev = t
					self:LocalMessage(123060, breakFree, "Personal", 123060)
				end
			end
		end
	end
end

