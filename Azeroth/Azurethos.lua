
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Azurethos, The Winged Typhoon", -895, 2199)
if not mod then return end
mod:RegisterEnableMob(136385)
mod.otherMenu = -947
mod.worldBoss = 136385

--------------------------------------------------------------------------------
-- Initialization
--

local lastGale = 0
local lastBuffet = 0

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		274832, -- Wing Buffet
		274829, -- Gale Force
		{274839, "FLASH"}, -- Azurethos' Fury
	}
end

function mod:OnBossEnable()
	self:ScheduleTimer("CheckForEngage", 1)
	--self:RegisterEvent("BOSS_KILL") -- No event

	self:Log("SPELL_CAST_START", "WingBuffet", 274832)
	self:Log("SPELL_CAST_START", "GaleForce", 274829)
	self:Log("SPELL_CAST_START", "AzurethosFury", 274839)

	self:Death("Win", 136385)
end

function mod:OnEngage()
	lastGale = 0
	lastBuffet = 0

	self:CheckForWipe()
	self:CDBar(274839, 17) -- Azurethos' Fury
end

--------------------------------------------------------------------------------
-- Event Handlers
--

--function mod:BOSS_KILL(_, id)
--	if id == 0000 then
--		self:Win()
--	end
--end

function mod:WingBuffet(args)
	self:Message2(args.spellId, "purple")
	self:PlaySound(args.spellId, "long")
	if lastBuffet == 0 or (args.time - lastBuffet) > 15 then
		self:CDBar(args.spellId, 10.8)
	else
		self:CDBar(args.spellId, 36)
	end
	lastBuffet = args.time
end

function mod:GaleForce(args)
	self:Message2(args.spellId, "red")
	self:PlaySound(args.spellId, "warning")
	if lastGale == 0 or (args.time - lastGale) > 15 then
		self:CDBar(args.spellId, 19.4)
	else
		self:CDBar(args.spellId, 33.2)
	end
	lastGale = args.time
end

function mod:AzurethosFury(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "long")
	self:Flash(args.spellId)
	self:CDBar(args.spellId, 45)
end
