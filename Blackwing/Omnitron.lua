if not GetSpellInfo(90000) then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Omnitron Defense System", "Blackwing Descent")
if not mod then return end
mod:RegisterEnableMob(42166, 42179, 42178, 42180) -- Arcanotron, Electron, Magmatron, Toxitron
mod.toggleOptions = {{79501, "ICON", "FLASHSHAKE"}, 79582, {79888, "ICON", "FLASHSHAKE"}, "proximity", 79900, 79729, {80161, "FLASHSHAKE"}, 79835, "bosskill"}
mod.optionHeaders = {
	bosskill = "general",
	[79501] = "Magmatron",
	[79888] = "Electron",
	[79729] = "Arcanotron",
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
	L.acquiring_target = "Acquiring Target"
	L.chemical_cloud_message = "Chemical Cloud on YOU!"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "AcquiringTarget", 79501)
	self:Log("SPELL_CAST_START", "Barrier", 79582)
	
	self:Log("SPELL_CAST_SUCCESS", "LightningConductor", 79888)
	self:Log("SPELL_CAST_START", "UnstableShield", 79900)
	
	self:Log("SPELL_CAST_START", "PowerConversion", 79729)
	
	self:Log("SPELL_AURA_APPLIED", "ChemicalCloud", 80161)
	self:Log("SPELL_CAST_START", "PoisonSoakedShell", 79835)
	
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	self:Death("Deaths", 42166, 42179, 42178, 42180)
end


function mod:OnEngage(diff)
	
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:AcquiringTarget(player, spellId, _, _, spellName)
	if UnitIsUnit(player, "player") then
		self:FlashShake(79501)
	end
	self:TargetMessage(79501, L["acquiring_target"], player, "Urgent", spellId, "Long")
	self:SecondaryIcon(79501, player)
end

function mod:Barrier(_, spellId, _, _, spellName)
	self:Message(79582, spellName, "Important", spellId, "Alert")
end

function mod:LightningConductor(player, spellId, _, _, spellName)
	if UnitIsUnit(player, "player") then
		self:FlashShake(79888)
		self:OpenProximity(15) --assumed
		self:ScheduleTimer(self.CloseProximity, 10, self)
	end
	self:SecondaryIcon(79888, player)
end

function mod:UnstableShield(_, spellId, _, _, spellName)
	self:Message(79900, spellName, "Important", spellId, "Alert")
end

function mod:PowerConversion(_, spellId, _, _, spellName)
	self:Message(79729, spellName, "Important", spellId, "Alert")
end

function mod:ChemicalCloud(player, spellId)
	local time = GetTime()
	if (time - last) > 2 then
		last = time
		if UnitIsUnit(player, "player") then
			self:LocalMessage(80161, L["chemical_cloud_message"], "Personal", spellId, "Info")
			self:FlashShake(80161)
		end
	end
end

function mod:PoisonSoakedShell(_, spellId, _, _, spellName)
	self:Message(79835, spellName, "Important", spellId, "Alert")
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

