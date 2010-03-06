--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Ignis the Furnace Master", "Ulduar")
if not mod then return end
mod:RegisterEnableMob(33118)
mod.toggleOptions = { 62488, 62382, {62680, "FLASHSHAKE"}, {62546, "FLASHSHAKE"}, 62717, "bosskill"}

--------------------------------------------------------------------------------
-- Locals
--

local spawnTime = 30

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.engage_trigger = "Insolent whelps! Your blood will temper the weapons used to reclaim this world!"

	L.construct_message = "Add incoming!"
	L.construct_bar = "Next add"
	L.brittle_message = "Construct is Brittle!"
	L.flame_bar = "~Jets cooldown"
	L.scorch_message = "Scorch on you!"
	L.scorch_soon = "Scorch in ~5sec!"
	L.scorch_bar = "Next Scorch"
	L.slagpot_message = "Slag Pot: %s"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "Construct", 62488)
	self:Log("SPELL_CAST_SUCCESS", "ScorchCast", 62546, 63474)
	self:Log("SPELL_CAST_START", "Jets", 62680, 63472)
	self:Log("SPELL_DAMAGE", "Scorch", 62548, 63475)
	self:Log("SPELL_AURA_APPLIED", "SlagPot", 62717, 63477)
	self:Log("SPELL_AURA_APPLIED", "Brittle", 62382)
	self:Death("Win", 33118)
	self:Yell("Engage", L["engage_trigger"])
end

function mod:OnEngage(diff)
	spawnTime = diff == 1 and 40 or 30
	self:Bar(62680, L["flame_bar"], 21, 62680)
	self:Bar(62488, L["construct_bar"], 10, "INV_Misc_Statue_07")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Brittle(_, spellId)
	self:Message(62382, L["brittle_message"], "Positive", spellId)
end

function mod:Construct()
	self:Message(62488, L["construct_message"], "Important", "Interface\\Icons\\INV_Misc_Statue_07")
	self:Bar(62488, L["construct_bar"], spawnTime, "INV_Misc_Statue_07")
end

function mod:ScorchCast(_, spellId, _, _, spellName)
	self:Message(62546, spellName, "Attention", spellId)
	self:Bar(62546, L["scorch_bar"], 25, spellId)
	self:DelayedMessage(62546, 20, L["scorch_soon"], "Urgent", spellId)
end

do
	local last = nil
	function mod:Scorch(player, spellId)
		if UnitIsUnit(player, "player") then
			local t = GetTime()
			if not last or (t > last + 4) then
				self:LocalMessage(62546, L["scorch_message"], "Personal", spellId, last and nil or "Alarm")
				self:FlashShake(62546)
				last = t
			end
		end
	end
end

function mod:SlagPot(player, spellId, _, _, spellName)
	self:TargetMessage(62717, spellName, player, "Important", spellId)
	self:Bar(62717, L["slagpot_message"]:format(player), 10, spellId)
end

do
	local _, class = UnitClass("player")
	local function isCaster()
		local power = UnitPowerType("player")
		if power ~= 0 then return end
		if class == "PALADIN" then
			local _, _, points = GetTalentTabInfo(1)
			-- If a paladin has less than 20 points in Holy, he's not a caster.
			-- And so it shall forever be, said the Lord.
			if points < 20 then return end
		end
		return true
	end

	function mod:Jets(_, spellId, _, _, spellName)
		local caster = isCaster()
		local color = caster and "Personal" or "Attention"
		local sound = caster and "Long" or nil
		if caster then self:FlashShake(62680) end
		self:Message(62680, spellName, color, spellId, sound)
		self:Bar(62680, L["flame_bar"], 25, spellId)
		if caster then self:Bar(62680, spellName, 2.7, spellId) end
	end
end

