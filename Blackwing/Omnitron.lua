if not GetSpellInfo(90000) then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Omnitron Defense System", "Blackwing Descent")
if not mod then return end
mod:RegisterEnableMob(42166, 42179, 42178, 42180) -- Arcanotron, Electron, Magmatron, Toxitron
mod.toggleOptions = {{79501, "ICON", "FLASHSHAKE"}, {79888, "ICON", "FLASHSHAKE"}, "proximity", {80161, "FLASHSHAKE"}, 91513, {80094, "FLASHSHAKE"}, "switch", "bosskill"}
mod.optionHeaders = {
	switch = "general",
	[79501] = "Magmatron",
	[79888] = "Electron",
--	[] = "Arcanotron",
	[80161] = "Toxitron",
}

--------------------------------------------------------------------------------
-- Locals
--

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.switch = "Switch"
	L.switch_desc = "Warning for Switches"
	
	L.next_switch = "Next Switch"

	L.acquiring_target = "Acquiring Target"

	L.cloud_message = "Cloud on YOU!"

end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "AcquiringTarget", 79501, 92035)
	self:Log("SPELL_CAST_START", "Switch", 79582, 91516, 79900, 91447, 79729, 91543, 79835, 91503, 91501)

	
	self:Log("SPELL_CAST_SUCCESS", "LightningConductor", 79888, 91433, 91431)
	self:Log("SPELL_CAST_SUCCESS", "PoisonProtocol", 91513)
	self:Log("SPELL_CAST_SUCCESS", "Fixate", 80094)

	self:Log("SPELL_AURA_APPLIED", "ChemicalCloud", 80161, 91480)

	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	self:Death("Deaths", 42166, 42179, 42178, 42180)
end


function mod:OnEngage(diff)

end

--------------------------------------------------------------------------------
-- Event Handlers
--
function mod:Switch(_, spellId, _, _, spellName)
	self:Bar(91513, L["next_switch"], 45, 91513)
	self:Message(79582, spellName, "Important", spellId, "Alert")
end

function mod:AcquiringTarget(player, spellId, _, _, spellName)
	if UnitIsUnit(player, "player") then
		self:FlashShake(79501)
	end
	self:TargetMessage(79501, L["acquiring_target"], player, "Urgent", spellId)
	self:SecondaryIcon(79501, player)
end

function mod:Fixate(player)
	if UnitIsUnit(player, "player") then
		self:FlashShake(80094)
	end
end

function mod:LightningConductor(player, spellId, _, _, spellName)
	if UnitIsUnit(player, "player") then
		self:FlashShake(79888)
		self:OpenProximity(15) --assumed
		self:ScheduleTimer(self.CloseProximity, 10, self)
	end
	self:SecondaryIcon(79888, player)
end

function mod:PoisonProtocol(_, spellId, _, _, spellName)
	self:Bar(91513, spellName, 45, 91513)
end

do
	local last = 0
	function mod:ChemicalCloud(player, spellId)
		local time = GetTime()
		if (time - last) > 2 then
			last = time
			if UnitIsUnit(player, "player") then
				self:LocalMessage(80161, L["cloud_message"], "Personal", spellId, "Info")
				self:FlashShake(80161)
			end
		end
	end
end


do
	local deaths = 0
	function mod:Deaths()
		deaths = deaths + 1
		if deaths == 4 then
			self:Win()
		end
	end
end

