if not IsTestBuild() then return end
--------------------------------------------------------------------------------
-- TODO:
--
--

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Wrathion", 2217, 2368)
if not mod then return end
mod:RegisterEnableMob(156523) -- Wrathion
mod.engageId = 	2329
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
		313973, -- Searing Breath
		{306163, "SAY", "SAY_COUNTDOWN"}, -- Incineration
		306289, -- Gale Blast
		306735, -- Burning Cataclysm
		307013, -- Burning Madness
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE") -- Burning Cataclysm, Burning Madness

	self:Log("SPELL_CAST_START", "SearingBreath", 313973)
	self:Log("SPELL_AURA_APPLIED", "SearingArmorApplied", 306015) -- Searing Armor
	self:Log("SPELL_AURA_APPLIED_DOSE", "SearingArmorApplied", 306015) -- Searing Armor
	self:Log("SPELL_CAST_SUCCESS", "IncinerationSuccess", 306111)
	self:Log("SPELL_AURA_APPLIED", "IncinerationApplied", 306163)
	self:Log("SPELL_AURA_REMOVED", "IncinerationRemoved", 306163)
	self:Log("SPELL_CAST_START", "GaleBlast", 306289)
	self:Log("SPELL_CAST_START", "BurningCataclysm", 306735)
	self:Log("SPELL_CAST_SUCCESS", "BurningCataclysmSuccess", 306735)

	self:Log("SPELL_CAST_SUCCESS", "SmokeandMirrors", 306995)
	self:Log("SPELL_AURA_REMOVED", "SmokeandMirrorsRemoved", 306995)
end

function mod:OnEngage()
	stage = 1
	nextCataclysm = GetTime() + 70
	incinerationCount = 1
	cataclysmCount = 1

	self:Bar(313973, 8.5) -- Searing Breath
	self:Bar(306163, 33, CL.count:format(self:SpellName(306163), incinerationCount)) -- Incineration
	self:Bar(306735, 70) -- Burning Cataclysm
	self:Bar(306995, 184) -- Smoke and Mirrors
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
			nextCataclysm = GetTime() + 90
			self:Bar(306735, 90)
		end
	elseif msg:find("307013", nil, true) then -- Burning Madness
		self:Message2(307013, "red")
		self:PlaySound(307013, "warning")
		self:CastBar(307013, 5.8)
	end
end

function mod:SearingBreath(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
	if nextCataclysm > GetTime() + 8.5 then
		self:Bar(args.spellId, 8.5) -- XX Why is it delayed to 14s sometimes?
	end
end

function mod:SearingArmorApplied(args)
	if self:Me(args.destGUID) or (self:Tank() and self:Tank(args.destName)) then
		local amount = args.amount or 1
		self:StackMessage(313973, args.destName, amount, "purple", self:Tank() and (amount > 1 and "Warning") or not self:Tank() and "Warning") -- Warning sound for non-tanks, 2+ stacks warning for tanks
	end
end

function mod:IncinerationSuccess(args)
	incinerationCount = incinerationCount + 1
	if nextCataclysm > GetTime() + 47.4 then
		self:Bar(306163, 47.4, CL.count:format(args.spellName, incinerationCount))
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
		self:Bar(306289, 18) -- Gale Blast
		self:Bar(306163, 26.5, CL.count:format(self:SpellName(306163), incinerationCount)) -- Incineration
		self:Bar(313973, 30.5) -- Searing Breath
	end
end

function mod:SmokeandMirrors(args)
	stage = 2
	self:Message2("stages", "cyan", CL.stage:format(2), false)
	self:PlaySound("stages", "long")
end

function mod:SmokeandMirrors(args)
	stage = 1
	self:Message2("stages", "cyan", CL.stage:format(1), false)
	self:PlaySound("stages", "long")
	incinerationCount = 1

	self:Bar(313973, 8.5) -- Searing Breath
	self:Bar(306163, 33, CL.count:format(self:SpellName(306163), incinerationCount)) -- Incineration
	self:Bar(306735, 70) -- Burning Cataclysm
	self:Bar(306995, 184) -- Smoke and Mirrors
end
