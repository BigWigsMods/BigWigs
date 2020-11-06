
--------------------------------------------------------------------------------
-- Module declaration
--

local mod, CL = BigWigs:NewBoss("High Priest Thekal", 309)
if not mod then return end
mod:RegisterEnableMob(14509, 11347, 11348)
mod:SetAllowWin(true)
mod.engageId = 789

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.bossName = "High Priest Thekal"
	L.lorkhan = "Zealot Lor'Khan"
	L.zath = "Zealot Zath"

	L.tigers_message = "Incoming Tigers!"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		-- Thekal
		{22859, "TANK_HEALER"}, -- Mortal Cleave
		22666, -- Silence
		-- Lor'Khan
		24208, -- Great Heal
		24185, -- Bloodlust
		-- Zath
		21060, -- Blind
		12540, -- Gouge
		-- Phase 2
		24189, -- Force Punch
		24183, -- Summon Zulian Guardians
		8269, -- Enrage
	}, {
		[22859] = L.bossName,
		[24208] = L.lorkhan,
		[21060] = L.zath,
		[24189] = CL.phase:format(2),
	}
end

function mod:OnRegister()
	self.displayName = L.bossName
end

function mod:OnBossEnable()
	-- Thekal
	self:Log("SPELL_AURA_APPLIED", "MortalCleave", 22859)
	self:Log("SPELL_AURA_APPLIED", "Silence", 22666)
	-- Lor'Khan
	self:Log("SPELL_CAST_START", "GreatHeal", 24208)
	self:Log("SPELL_AURA_APPLIED", "Bloodlust", 24185)
	-- Zath
	self:Log("SPELL_AURA_APPLIED", "Blind", 21060)
	self:Log("SPELL_AURA_APPLIED", "Gouge", 12540)
	-- Phase 2
	self:Log("SPELL_CAST_SUCCESS", "ForcePunch", 24189)
	self:Log("SPELL_SUMMON", "Tigers", 24183)
	self:Log("SPELL_AURA_APPLIED", "Enrage", 8269)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- Thekal

function mod:MortalCleave(args)
	self:TargetMessage(22859, "purple", args.destName)
	self:TargetBar(22859, 5, args.destName)
	self:PlaySound(22859, "alarm")
end

function mod:Silence(args)
	self:TargetMessage(22666, "yellow", args.destName)
	if self:Dispeller("magic") then
		self:PlaySound(22666, "alert")
	end
end

-- Lor'Khan

function mod:GreatHeal(args)
	self:Message(24208, "red", CL.other:format(args.sourceName, CL.casting:format(args.spellName)))
	self:PlaySound(24208, "alert")
end

function mod:Bloodlust(args)
	self:Message(24185, "orange", CL.on:format(args.spellName, args.destName))
	if self:Dispeller("magic") then
		self:PlaySound(24185, "alert")
	end
end

-- Zath

function mod:Blind(args)
	self:TargetMessage(21060, "purple", args.destName)
	self:TargetBar(21060, 10, args.destName)
	if self:Tank() then
		self:PlaySound(21060, "warning")
	end
end

function mod:Gouge(args)
	self:TargetMessage(12540, "purple", args.destName)
	self:TargetBar(12540, 4, args.destName)
	if self:Tank() then
		self:PlaySound(12540, "warning")
	end
end

-- Phase 2

function mod:ForcePunch(args)
	self:Message(24189, "orange")
	if self:Tank() then
		self:PlaySound(12540, "warning")
	end
end

function mod:Tigers(args)
	self:Message(24183, "yellow", L.tigers_message)
	self:PlaySound(24183, "info")
end

function mod:Enrage(args)
	self:Message(8269, "red")
	self:PlaySound(8269, "alarm")
end
