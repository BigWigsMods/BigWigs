--------------------------------------------------------------------------------
-- TODO:
--
--

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Wrathion", 2217, 2368)
if not mod then return end
mod:RegisterEnableMob(156818) -- Wrathion
mod.engageId = 2329
--mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

local stage = 1
local nextCataclysm = 0
local incinerationCount = 1
local cataclysmCount = 1

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"stages",
		305978, -- Searing Breath
		{306163, "SAY", "SAY_COUNTDOWN", "FLASH"}, -- Incineration
		306289, -- Gale Blast
		306735, -- Burning Cataclysm
		307013, -- Burning Madness
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE") -- Burning Cataclysm, Burning Madness

	self:Log("SPELL_CAST_START", "SearingBreath", 305978)
	self:Log("SPELL_AURA_APPLIED", "SearingArmorApplied", 306015) -- Searing Armor
	self:Log("SPELL_AURA_APPLIED_DOSE", "SearingArmorApplied", 306015) -- Searing Armor
	self:Log("SPELL_CAST_SUCCESS", "IncinerationSuccess", 306111)
	self:Log("SPELL_AURA_APPLIED", "IncinerationApplied", 306163)
	self:Log("SPELL_AURA_REMOVED", "IncinerationRemoved", 306163)
	self:Log("SPELL_CAST_START", "GaleBlast", 306289)
	self:Log("SPELL_CAST_START", "BurningCataclysm", 306735)

	self:Log("SPELL_CAST_SUCCESS", "SmokeandMirrors", 306995)
	self:Log("SPELL_AURA_REMOVED", "SmokeandMirrorsRemoved", 306995)
end

function mod:OnEngage()
	stage = 1
	nextCataclysm = GetTime() + 60
	incinerationCount = 1
	cataclysmCount = 1

	self:Bar(305978, 7.1) -- Searing Breath
	self:Bar(306163, 14.2, CL.count:format(self:SpellName(306163), incinerationCount)) -- Incineration
	self:Bar(306289, 48) -- Gale Blast
	self:Bar(306735, 53) -- Burning Cataclysm
	self:Bar("stages", 160, CL.stage:format(2), 306995) -- Smoke and Mirrors
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:CHAT_MSG_RAID_BOSS_EMOTE(_, msg)
	if msg:find("306735", nil, true) then -- Burning Cataclysm
		self:Message2(306735, "red")
		self:PlaySound(306735, "alert")
		cataclysmCount = cataclysmCount + 1
		if cataclysmCount < 3 then -- Casted 2x before stage 2
			nextCataclysm = GetTime() + 77.7
			self:Bar(306735, 77.7)
		end
	elseif msg:find("307013", nil, true) then -- Burning Madness
		self:Message2(307013, "red")
		self:PlaySound(307013, "warning")
		self:CastBar(307013, 8)
	end
end

function mod:SearingBreath(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
	if nextCataclysm > GetTime() + 7.3 then
		self:Bar(args.spellId, 7.3) -- XX Why is it delayed to 14s sometimes?
	end
end

function mod:SearingArmorApplied(args)
	if self:Me(args.destGUID) or (self:Tank() and self:Tank(args.destName)) then
		local amount = args.amount or 1
		self:StackMessage(305978, args.destName, amount, "purple", self:Tank() and (amount > 1 and "Warning") or not self:Tank() and "Warning") -- Warning sound for non-tanks, 2+ stacks warning for tanks
	end
end

function mod:IncinerationSuccess(args)
	incinerationCount = incinerationCount + 1
	if nextCataclysm > GetTime() + 24.3 then
		self:Bar(306163, 24.3, CL.count:format(args.spellName, incinerationCount))
	end
end

do
	local playerList = mod:NewTargetList()
	function mod:IncinerationApplied(args)
		playerList[#playerList+1] = args.destName
		if self:Me(args.destGUID) then
			self:Say(args.spellId)
			self:SayCountdown(args.spellId, 8)
			self:Flash(args.spellId)
			self:PlaySound(args.spellId, "warning")
		end
		self:TargetsMessage(args.spellId, "orange", playerList, CL.count:format(args.spellName, incinerationCount-1))
	end

	function mod:IncinerationRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
		end
	end
end

function mod:GaleBlast(args)
	self:Message2(args.spellId, "red")
	self:PlaySound(args.spellId, "alarm")
end

function mod:BurningCataclysm(args)
	self:CastBar(args.spellId, 8)
	if cataclysmCount < 3 then -- Stage 2 isn't coming yet, so start bars
		self:Bar(306289, 60) -- Gale Blast
		self:Bar(306163, 24.1, CL.count:format(self:SpellName(306163), incinerationCount)) -- Incineration
		self:Bar(305978, 26.8) -- Searing Breath
	end
end

function mod:SmokeandMirrors(args)
	stage = 2
	self:Message2("stages", "cyan", CL.stage:format(2), false)
	self:PlaySound("stages", "long")
end

function mod:SmokeandMirrorsRemoved(args)
	stage = 1
	self:Message2("stages", "cyan", CL.stage:format(1), false)
	self:PlaySound("stages", "long")
	incinerationCount = 1

	self:Bar(306163, 10.2, CL.count:format(self:SpellName(306163), incinerationCount)) -- Incineration
	self:Bar(305978, 14.1) -- Searing Breath
	self:Bar(306289, 45) -- Gale Blast
	self:Bar(306735, 50) -- Burning Cataclysm
	self:Bar("stages", 160, CL.stage:format(2), 306995) -- Smoke and Mirrors
end
