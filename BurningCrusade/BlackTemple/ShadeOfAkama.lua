
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Shade of Akama", 564, 1584)
if not mod then return end
mod:RegisterEnableMob(23191, 22841) -- Akama, Shade of Akama
mod:SetEncounterID(2475)
mod:SetAllowWin(true)
mod:SetRespawnTime(120)

--------------------------------------------------------------------------------
-- Locals
--

local defender, sorcerer, left, right = nil, nil, nil, nil

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.wipe_trigger = "No! Not yet!"
	L.defender = "Defender" -- Ashtongue Defender
	L.sorcerer = "Sorcerer" -- Ashtongue Sorcerer
	L.adds_right = "Adds (Right)"
	L.adds_left = "Adds (Left)"

	L.engaged = "Shade of Akama Engaged"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		42023, -- Rain of Fire
		"stages",
	}
end

function mod:VerifyEnable(unit, mobId)
	if mobId == 22841 or UnitHealth(unit) == UnitHealthMax(unit) then -- Enable if shade, or if Akama at 100% hp
		return true
	end
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_REMOVED", "StealthRemoved", 34189)
	self:RegisterMessage("BigWigs_BossComm")

	self:Log("SPELL_AURA_APPLIED", "RainOfFireDamage", 42023)
	self:Log("SPELL_PERIODIC_DAMAGE", "RainOfFireDamage", 42023)
	self:Log("SPELL_PERIODIC_MISSED", "RainOfFireDamage", 42023)

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
end

function mod:OnEngage()
	self:MessageOld("stages", "cyan", "info", L.engaged, false)
	self:Bar("stages", 13, L.defender, 159241) -- ability_parry / icon 132269
	self:ScheduleTimer("Bar", 13, "stages", 32, L.defender, 159241)
	defender = self:ScheduleTimer("RepeaterDefender", 45)
	self:Bar("stages", 13, L.sorcerer, 193473) -- spell_shadow_siphonmana / icon 136208
	sorcerer = self:ScheduleTimer("RepeaterSorcerer", 13)
	self:Bar("stages", 13, L.adds_right, 87219) -- misc_arrowright / icon 450908
	right = self:ScheduleTimer("RepeaterAddsRight", 13)
	self:Bar("stages", 28, L.adds_left, 87217) -- misc_arrowleft / icon 450906
	left = self:ScheduleTimer("RepeaterAddsLeft", 28)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:StealthRemoved(args)
	-- Stealth is removed when you speak to him, starting the encounter
	if self:MobId(args.destGUID) == 23191 then -- Akama
		self:Sync("Akama") -- There seems to be range problems with this, sync for now.
	end
end

function mod:BigWigs_BossComm(_, msg)
	if msg == "Akama" and not self.isEngaged then
		self:Engage()
	end
end

function mod:RepeaterDefender()
	self:Bar("stages", 29.7, L.defender, 159241) -- ability_parry / icon 132269
	defender = self:ScheduleTimer("RepeaterDefender", 29.7)
end

function mod:RepeaterSorcerer()
	self:Bar("stages", 25.5, L.sorcerer, 193473) -- spell_shadow_siphonmana / icon 136208
	sorcerer = self:ScheduleTimer("RepeaterSorcerer", 25.5)
end

function mod:RepeaterAddsRight()
	self:Bar("stages", 45, L.adds_right, 87219) -- misc_arrowright / icon 450908
	right = self:ScheduleTimer("RepeaterAddsRight", 45)
end

function mod:RepeaterAddsLeft()
	self:Bar("stages", 52, L.adds_left, 87217) -- misc_arrowleft / icon 450906
	left = self:ScheduleTimer("RepeaterAddsLeft", 52)
end

do
	local prev = 0
	function mod:RainOfFireDamage(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 1.5 then
			prev = t
			self:MessageOld(args.spellId, "blue", "alert", CL.you:format(args.spellName))
		end
	end
end

function mod:INSTANCE_ENCOUNTER_ENGAGE_UNIT()
	if self:MobId(self:UnitGUID("boss1")) == 22841 then -- Shade of Akama
		self:CancelTimer(defender)
		self:CancelTimer(sorcerer)
		self:CancelTimer(right)
		self:CancelTimer(left)
		defender, sorcerer, left, right = nil, nil, nil, nil
		self:UnregisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")
		self:StopBar(L.defender)
		self:StopBar(L.sorcerer)
		self:StopBar(L.adds_right)
		self:StopBar(L.adds_left)
		self:MessageOld("stages", "cyan", "info", CL.stage:format(2), false)
	end
end

function mod:CHAT_MSG_MONSTER_YELL(_, msg)
	if msg == L.wipe_trigger then
		self:EncounterEnd(nil, self.engageId, self.displayName, 0, 0, 0) -- XXX Hack for missing ENCOUNTER_END
	end
end
