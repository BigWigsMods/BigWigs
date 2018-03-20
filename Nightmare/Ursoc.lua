
--------------------------------------------------------------------------------
-- TODO List:

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Ursoc", 1520, 1667)
if not mod then return end
mod:RegisterEnableMob(100497)
mod.engageId = 1841
mod.respawnTime = 40

--------------------------------------------------------------------------------
-- Locals
--

local cacophonyCount = 1
local focusedGazeCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.custom_on_gaze_assist = "Focused Gaze Assist"
	L.custom_on_gaze_assist_desc = "Show raid icons in bars and messages for Focused Gaze. Using {rt4} for odd, {rt6} for even soaks. Requires promoted or leader."
	L.custom_on_gaze_assist_icon = 4
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{197943, "TANK"}, -- Overwhelm
		{204859, "TANK_HEALER"}, -- Rend Flesh
		{198006, "ICON", "FLASH", "PULSE", "SAY"}, -- Focused Gaze
		"custom_on_gaze_assist",
		198108, -- Momentum
		197969, -- Roaring Cacophony
		205611, -- Miasma
		198388, -- Blood Frenzy
		"berserk",
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "RoaringCacophony", 197969)
	self:Log("SPELL_CAST_SUCCESS", "RoaringCacophonySuccess", 197969)
	self:Log("SPELL_AURA_APPLIED", "Overwhelm", 197943)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Overwhelm", 197943)
	self:Log("SPELL_CAST_START", "RendFleshCast", 197942)
	self:Log("SPELL_AURA_APPLIED", "RendFlesh", 204859)
	self:Log("SPELL_AURA_APPLIED", "FocusedGaze", 198006)
	self:Log("SPELL_AURA_REMOVED", "FocusedGazeRemoved", 198006)
	self:Log("SPELL_AURA_APPLIED", "Momentum", 198108)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Momentum", 198108)
	self:Log("SPELL_AURA_APPLIED", "BloodFrenzy", 198388)

	self:Log("SPELL_AURA_APPLIED", "MiasmaDamage", 205611)
	self:Log("SPELL_DAMAGE", "MiasmaDamage", 212238)
	self:Log("SPELL_MISSED", "MiasmaDamage", 212238)
end

function mod:OnEngage()
	cacophonyCount = 1
	focusedGazeCount = 1

	self:Bar(197943, 10) -- Overwhelm
	self:Bar(204859, 15) -- Rend Flesh, time to _applied
	if not self:LFR() and self:GetOption("custom_on_gaze_assist") then
		self:Bar(198006, 19, CL.count_icon:format(self:SpellName(198006), focusedGazeCount, 4)) -- Focused Gaze, green
	else
		self:Bar(198006, 19, CL.count:format(self:SpellName(198006), focusedGazeCount)) -- Focused Gaze
	end
	self:Bar(197969, self:Mythic() and 20 or 40, CL.count:format(self:SpellName(197969), cacophonyCount)) -- Roaring Cacophony
	self:Berserk(300)

	self:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", nil, "boss1")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:RoaringCacophony(args)
	self:Message(args.spellId, "Urgent", nil, CL.casting:format(CL.count:format(args.spellName, cacophonyCount)))
end

function mod:RoaringCacophonySuccess(args)
	local text = CL.count:format(args.spellName, cacophonyCount)
	if self:Mythic() and cacophonyCount > 2 and cacophonyCount % 2 == 1 then
		text = text.." - ".. CL.spawning:format(CL.add)
	end
	self:Message(args.spellId, "Urgent", "Alarm", text)

	cacophonyCount = cacophonyCount + 1

	local next = cacophonyCount % 2 == 0 and 10 or 30
	if self:Mythic() then
		next = cacophonyCount == 2 and 20 or cacophonyCount % 2 == 0 and 30 or 10
	end
	self:Bar(args.spellId, next, CL.count:format(args.spellName, cacophonyCount))
end

function mod:Overwhelm(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, args.destName, amount, "Important")
	if amount > 1 then
		self:PlaySound(args.spellId, self:Me(args.destGUID) and "Alarm" or "Warning") -- Warning = taunt
	end
	self:Bar(args.spellId, self:LFR() and 20 or 10)
end

function mod:RendFleshCast(args)
	self:Message(204859, "Attention", nil, CL.casting:format(args.spellName))
	if self:Tank() and not UnitDetailedThreatSituation("player", "boss1") then
		local _, _, _, _, _, _, expiration = UnitDebuff("player", self:SpellName(197943)) -- Overwhelm
		if not expiration or expiration-GetTime() < 2.5 then
			self:PlaySound(204859, "Warning") -- Warning = taunt
		end
	end
end

function mod:RendFlesh(args)
	self:TargetMessage(args.spellId, args.destName, "Attention", "Info")
	self:Bar(args.spellId, 20)
end

function mod:FocusedGaze(args)
	local icon = focusedGazeCount % 2 == 0 and 6 or 4 -- blue (even), green (odd)
	local countSay = CL.count:format(args.spellName, focusedGazeCount)
	local countMessage = countSay
	local showingIcons = false

	if not self:LFR() and self:GetOption("custom_on_gaze_assist") then
		showingIcons = true
		countSay = CL.count_rticon:format(args.spellName, focusedGazeCount, icon)
		countMessage = CL.count_icon:format(args.spellName, focusedGazeCount, icon)
	end

	if self:Me(args.destGUID) then
		self:Flash(args.spellId, showingIcons and icon)
		self:Say(args.spellId, countSay)
	end

	self:PrimaryIcon(args.spellId, args.destName)
	self:TargetMessage(args.spellId, args.destName, "Important", "Warning", countMessage, args.spellId, true)
	self:TargetBar(args.spellId, 6, args.destName, countMessage)
	focusedGazeCount = focusedGazeCount + 1
	if showingIcons then
		self:Bar(args.spellId, 40, CL.count_icon:format(args.spellName, focusedGazeCount, focusedGazeCount % 2 == 0 and 6 or 4))
	else
		self:Bar(args.spellId, 40, CL.count:format(args.spellName, focusedGazeCount))
	end
end

function mod:FocusedGazeRemoved(args)
	self:StopBar(args.spellId, args.destName)
	self:PrimaryIcon(args.spellId, nil)
end

function mod:Momentum(args)
	if self:Me(args.destGUID) then
		self:TargetBar(args.spellId, 50, args.destName)
	end
end

do
	local prev = 0
	function mod:MiasmaDamage(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 1.5 then
			prev = t
			self:Message(205611, "Personal", "Alert", CL.underyou:format(args.spellName))
		end
	end
end

function mod:UNIT_HEALTH_FREQUENT(unit)
	local hp = UnitHealth(unit) / UnitHealthMax(unit)
	if hp < 0.35 then -- Blood Frenzy at 30%
		self:UnregisterUnitEvent("UNIT_HEALTH_FREQUENT", unit)
		self:Message(198388, "Neutral", "Info", CL.soon:format(self:SpellName(198388))) -- Blood Frenzy
	end
end

function mod:BloodFrenzy(args)
	self:Message(args.spellId, "Urgent", "Long", "30% - ".. args.spellName)
end
