if not GetNumGroupMembers then return end
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
local phase, phase2warned, breakFreeWarned
local amberMonstrosoty = EJ_GetSectionInfo(6254)

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.explosion_boss = "Explosion on BOSS!"
	L.explosion_you = "Explosion on YOU!"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		122784, { 122398, "FLASHSHAKE" }, 123060,
		"ej:6246", { 122402, "FLASHSHAKE" },
		122556,
		121995,
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
	self:Log("SPELL_CAST_SUCCESS", "Beam", 121995)
	self:Log("SPELL_CAST_START", "AmberExplosion", 122398)
	self:Log("SPELL_CAST_START", "AmberExplosionMonstrosity", 122402)
	self:Log("SPELL_CAST_SUCCESS", "AmberCarapace", 122540)
	self:Log("SPELL_CAST_APPLIED", "ConcentratedMutation", 122556)

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Death("Win", 62511)
end

function mod:OnEngage(diff)
	self:Bar(122784, reshapeLife, 20, 122784)
	self:Berserk(360) -- assume
	phase = 1
	self:RegisterEvent("UNIT_HEALTH_FREQUENT")
	phase2warned, breakFreeWarned = false, false
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:AmberExplosionMonstrosity(_, _, _, _, spellName)
	if UnitDebuff("player", reshapeLife) then
		self:FlashShake(122402)
	end
	self:DelayedMessage(122402, 25, CL["custom_sec"]:format(L["explosion_boss"],20), "Attention", 122402)
	self:DelayedMessage(122402, 30, CL["custom_sec"]:format(L["explosion_boss"],15), "Attention", 122402)
	self:DelayedMessage(122402, 35, CL["custom_sec"]:format(L["explosion_boss"],10), "Attention", 122402)
	self:Bar(122402, "~"..L["explosion_boss"], 45, 122402) -- cooldown, don't move this
	self:Message(122402, L["explosion_boss"], "Important", 122402, "Alert") -- might want to move this next to FNS, so it only warns for people who can do something about it
end

function mod:ConcentratedMutation(_, _, _, _, spellName)
	phase = 3
	self:Message(122556, spellName, "Attention", 122556)
	self:SendMessage("BigWigs_StopBar", self, "~"..L["explosion_boss"])
end

function mod:AmberCarapace()
	phase = 2
	self:Message("ej:6246", amberMonstrosoty, "Attention", 122540)
	self:DelayedMessage(122402, 38,CL["custom_sec"]:format(L["explosion_boss"],20), "Attention", 122402)
	self:DelayedMessage(122402, 43,CL["custom_sec"]:format(L["explosion_boss"],15), "Attention", 122402)
	self:DelayedMessage(122402, 48,CL["custom_sec"]:format(L["explosion_boss"],10), "Attention", 122402)
	self:Bar(122402, L["explosion_boss"], 58, 122402) -- this is for the Monstrosity
end

function mod:ReshapeLife(player, _, _, _, spellName)
	self:TargetMessage(122784, spellName, player, "Urgent", 122784, "Alarm")
	if phase < 3 then
		self:Bar(122784, spellName, 50, 122784)
	else
		self:Bar(122784, spellName, 15, 122784) -- might be too short for a bar
	end
	if UnitIsUnit("player", player) then
		self:Bar(122398, ("%s (%s)"):format(L["explosion_you"], player), 13, 122398)
	end
end

function mod:Beam(_, _, _, _, spellName)
	-- don't think this needs a bar
	self:TargetMessage(121995, spellName, "Attention", 121995)
end

function mod:AmberExplosion(_, _, player, _, spellName)
	if UnitIsUnit("player", player) then
		self:FlashShake(122398)
		self:Bar(122398, ("%s (%s)"):format(L["explosion_you"], player), 13, 122398) -- cooldown
		self:LocalMessage(122398, CL["you"]:format(L["explosion_you"]), "Personal", 122398, "Info")
	end
end

function mod:UNIT_HEALTH_FREQUENT(_, unitId)
	if unitId == "boss1" then
		local hp = UnitHealth(unitId) / UnitHealthMax(unitId) * 100
		if hp < 75 and not phase2warned then -- phase starts at 70
			phase2warned = true
			self:Message("ej:6246", CL["soon"]:format(amberMonstrosoty), "Positive", 122540, "Long") -- somewhat relevant icon
		end
	elseif unitId == "player" then
		if not UnitDebuff("player", reshapeLife) then return end
		local hp = UnitHealth("player") / UnitHealthMax("player") * 100
		-- don't know how useful, since your hp might bounce up and down
		if hp < 20 and not breakFreeWarned then
			breakFreeWarned = true
			self:LocalMessage(123060, breakFree, "Personal", 123060)
		else
			breakFreeWarned = false
		end
	end
end

