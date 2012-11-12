
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
local phase, phase2warned = 1, false
local amberMonstrosoty = EJ_GetSectionInfo(6254)
local parasiteAllowed = true
local lastExpire = 0
local primaryIcon

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.explosion_by_other = "Amber Explosion by anything but you!"
	L.explosion_by_other_desc = "Cooldown type warning for Amber Explosion for anything but you! (Mainly the Amber Monstrosity, but also works for focus target.)"
	L.explosion_by_other_icon = 122398

	L.explosion_casting_by_other = "Explosion casting by anything but you"
	L.explosion_casting_by_other_desc = "Warning for when any of the Amber Explosions are being casted that is not done by you. (Mainly the Amber Monstrosity, but also works for focus target.) Cast start message warnings are associated to this option. Emphasizing this is highly recommended!"
	L.explosion_casting_by_other_icon = 122398

	L.willpower = "Willpower"
	L.willpower_desc = "When Willpower runs out, the player dies and the Mutated Construct continues to act, uncontrolled."
	L.willpower_icon = 124824
	L.willpower_message = "Your willpower is: %d"

	L.explosion_by_you = "Amber Explosion by you!"
	L.explosion_by_you_desc = "Cooldown type warning for Amber Explosion by you!"
	L.explosion_by_you_icon = 122398

	L.explosion_casting_by_you = "Explosion casting by YOU"
	L.explosion_casting_by_you_desc = "Warning for when any of the Amber Explosions are being casted by YOU. Cast start message warnings are associated to this option. Emphasizing this is highly recommended!"
	L.explosion_casting_by_you_icon = 122398

	L.parasite = "Parasite"

	L.boss_is_casting = "BOSS is casting!"
	L.you_are_casting = "YOU are casting"
	L.other_is_casting = "%s is casting!"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{"ej:6548", "FLASHSHAKE", "ICON"},
		122784, { "explosion_by_you" }, { "explosion_casting_by_you", "FLASHSHAKE" }, 123060, "willpower", 123059,
		"ej:6246", "explosion_by_other", {"explosion_casting_by_other", "FLASHSHAKE" },
		122556,
		{121995, "FLASHSHAKE", "SAY"}, 123020, {121949, "FLASHSHAKE"},
		"berserk", "bosskill",
	}, {
		["ej:6548"] = "heroic",
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
	self:Log("SPELL_INTERRUPT", "ExplosionInterrupt", 122402, 122398, 123060) -- amber explosion, amber explosion, break free
	self:Log("SPELL_CAST_APPLIED", "ExplosionInterrupt", 122395) -- Struggle for Control
	self:Log("SPELL_CAST_SUCCESS", "AmberGlobule", 125502)
	self:Log("SPELL_CAST_REMOVED", "AmberGlobuleRemoved", 125502)
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Death("Win", 62511)
end

function mod:OnEngage(diff)
	self:Bar(122784, reshapeLife, 20, 122784)
	self:Berserk(480) -- assume
	phase = 1
	self:RegisterEvent("UNIT_HEALTH_FREQUENT")
	self:RegisterEvent("UNIT_AURA")
	lastExpire = 0
	phase2warned = false
	parasiteAllowed = true
	primaryIcon = false
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:AmberGlobule(player, _, _, _, spellName)
	self:TargetMessage("ej:6548", spellName, player, "Important", 125502, "Alert")
	if UnitIsUnit(player, "player") then
		self:FlashShake("ej:6548")
	end
	if not primaryIcon then
		self:PrimaryIcon("ej:6548", player)
		primaryIcon = player
	else
		self:SecondaryIcon("ej:6548", player)
	end

end

function mod:AmberGlobuleRemoved(player)
	if primaryIcon == player then
		self:PrimaryIcon("ej:6548")
		primaryIcon = nil
	else
		self:SecondaryIcon("ej:6548")
	end
end

do
	local function allowParasiteWarning()
		parasiteAllowed = true
	end
	function mod:UNIT_AURA(_, unitId) -- everything in here was not working with normal CLEU events
		if unitId:match("boss") then
			local name, rank, icon, count, dispelType, duration, expires = UnitDebuff(unitId, self:SpellName(123059)) -- destabilize
			if name then
				if expires ~= lastExpire then
					lastExpire = expires
					self:Bar(123059, ("%s - %s"):format(self:SpellName(123059), unitId), (expires - GetTime()), 123059)
				end
			end
		elseif UnitIsUnit("player", unitId) and UnitDebuff("player", self:SpellName(121949)) and parasiteAllowed then
			parasiteAllowed = false
			self:LocalMessage(121949, CL["you"]:format(L["parasite"]), "Personal", 121949, "Long")
			self:FlashShake(121949)
			self:ScheduleTimer(allowParasiteWarning, 35)
		end
	end
end

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

function mod:ExplosionInterrupt(player) -- XXX DOES NOT WORK
	if UnitIsUnit("player", player) then
		self:StopBar(CL["cast"]:format(CL["you"]:format(explosion)))
	elseif UnitIsUnit("boss2", player) then -- Monstrosity
		self:StopBar(L["boss_is_casting"])
	elseif UnitIsUnit("focus", player) then
		self:StopBar(CL["cast"]:format(CL["other"]:format((UnitName(player)),explosion)))
	end
end

do
	local function warningSpam()
		if UnitCastingInfo("boss2") == amberExplosion and UnitDebuff("player", reshapeLife) then
			mod:LocalMessage("explosion_casting_by_other", L["boss_is_casting"], "Important", 122398, "Alert")
			mod:ScheduleTimer(warningSpam, 0.5)
		end
	end
	function mod:AmberExplosionMonstrosity(_, _, _, _, spellName)
		if UnitDebuff("player", reshapeLife) then
			self:FlashShake("explosion_casting_by_other")
		end
		self:DelayedMessage("explosion_by_other", 25, CL["custom_sec"]:format(explosion, 20), "Attention", 122402)
		self:DelayedMessage("explosion_by_other", 30, CL["custom_sec"]:format(explosion, 15), "Attention", 122402)
		self:DelayedMessage("explosion_by_other", 35, CL["custom_sec"]:format(explosion, 10), "Attention", 122402)
		self:Bar("explosion_casting_by_other", L["boss_is_casting"], self:Heroic() and 2.5 or 6, 122398)
		--self:Bar("explosion_casting_by_other", "1111111111111", self:Heroic() and 2.5 or 6, 122398)
		self:Bar("explosion_by_other", "~"..CL["onboss"]:format(explosion), 45, 122402) -- cooldown, don't move this
		warningSpam()
	end
end

function mod:ConcentratedMutation(_, _, _, _, spellName)
	phase = 3
	self:Message(122556, spellName, "Attention", 122556)
	self:StopBar("~"..CL["onboss"]:format(explosion))
end

function mod:AmberCarapace()
	phase = 2
	self:Message("ej:6246", amberMonstrosoty, "Attention", 122540)
	self:DelayedMessage("explosion_by_other", 38, CL["custom_sec"]:format(explosion, 20), "Attention", 122402)
	self:DelayedMessage("explosion_by_other", 43, CL["custom_sec"]:format(explosion, 15), "Attention", 122402)
	self:DelayedMessage("explosion_by_other", 48, CL["custom_sec"]:format(explosion, 10), "Attention", 122402)
	self:Bar("explosion_by_other", CL["onboss"]:format(explosion), 58, 122402) -- this is for the Monstrosity
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
		self:Bar("explosion_by_you", CL["you"]:format(explosion), 15, 122398)
	end
end

function mod:ReshapeLifeRemoved(player)
	if UnitIsUnit("player", player) then
		self:UnregisterEvent("UNIT_POWER")
		self:StopBar(CL["you"]:format(explosion))
	end
end

do
	local timer, fired = nil, 0
	local function beamWarn(spellName)
		fired = fired + 1
		local player = UnitName("boss1targettarget")--Boss targets an invisible mob, which targets player. Calling boss1targettarget allows us to see it anyways
		if player and not UnitIsUnit("boss1targettarget", "boss1") then--target target is himself, so he's not targeting off scalple mob yet
			mod:TargetMessage(121995, spellName, player, "Attention", 121995, "Long")
			mod:CancelTimer(timer, true)
			timer = nil
			if UnitIsUnit("boss1targettarget", "player") then
				mod:FlashShake(121995)
				mod:Say(121995, CL["say"]:format(spellName))
			end
			return
		end
		-- 19 == 0.95sec
		-- Safety check if the unit doesn't exist or boss never targets anything but himself
		if fired > 18 then
			mod:CancelTimer(timer, true)
			timer = nil
			self:TargetMessage(121995, spellName, "Attention", 121995)--Give generic warning as a backup
		end
	end
	function mod:Beam(_, _, _, _, spellName)
		fired = 0
		if not timer then
			timer = self:ScheduleRepeatingTimer(beamWarn, 0.05, spellName)
		end
	end
end

do
	local function warningSpam()
		if UnitCastingInfo("player") == amberExplosion then
			mod:LocalMessage("explosion_casting_by_you", L["you_are_casting"], "Personal", 122398, "Info")
			mod:ScheduleTimer(warningSpam, 0.5)
		end
	end
	function mod:AmberExplosion(_, _, player, _, spellName)
		if UnitIsUnit("player", player) then
			self:FlashShake("explosion_casting_by_you")
			self:Bar("explosion_casting_by_you", CL["cast"]:format(CL["you"]:format(explosion)), 2.5, 122398)
			--self:Bar("explosion_casting_by_you", "2222222222222", 2.5, 122398)
			self:Bar("explosion_by_you", CL["you"]:format(explosion), 13, 122398) -- cooldown
			warningSpam()
		elseif UnitIsUnit("focus", player) then
			self:FlashShake("explosion_casting_by_other")
			self:Bar("explosion_casting_by_other", CL["cast"]:format(CL["other"]:format((UnitName(player)),explosion)), 2.5, 122398)
			self:Bar("explosion_by_other", CL["other"]:format((UnitName(player)),explosion), 13, 122398) -- cooldown
			self:LocalMessage("explosion_casting_by_other", CL["other"]:format((UnitName(player)),explosion), "Important", 122398, "Alert") -- associate the message with the casting toggle option
		end
	end
end

do
	local prev = 0
	function mod:UNIT_POWER(_, unitId)
		if unitId == "player" then
			local t = GetTime()
			if t-prev > 2 then
				local willpower = UnitPower("player", 10)
				if willpower < 20 then
					prev = t
					self:LocalMessage("willpower", L["willpower_message"]:format((UnitPower("player", 10)), willpower), "Personal", 124824)
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
				if hp < 20 then
					prev = t
					self:LocalMessage(123060, breakFree, "Positive", 123060)
				end
			end
		end
	end
end

