--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("King Rastakhan", 2070, 2335)
if not mod then return end
-- King Rastakhan, Siegebreaker Roka, Headhunter Gal'wana, Prelate Za'lan, Bwonsamdi
mod:RegisterEnableMob(145616, 146322, 146326, 146320, 145644)
mod.engageId = 2272
mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

local stage = 1
local toadCount = 1
local zombieDustTotemCount = 1
local detonationCount = 1
local deathlyWitheringList = {}

--------------------------------------------------------------------------------
-- Localization
--

--local L = mod:GetLocale()
--if L then
--
--end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"stages",
		-- Stage 1
		284831, -- Scorching Detonation
		284933, -- Plague of Toads
		285172, -- Greater Serpent Totem
		{290450, "SAY", "FLASH"}, -- Seal of Purification
		284686, -- Meteor Leap
		284719, -- Crushing Leap
		284781, -- Grievous Axe
		-- Stage 2
		{285195, "INFOBOX"}, -- Deathly Withering
		{285346, "SAY"}, -- Plague of Fire
		285003, -- Zombie Dust Totem
		{285213, "TANK_HEALER"}, -- Caress of Death
		{288449, "SAY", "SAY_COUNTDOWN"}, -- Death's Door
		-- Stage 3
		287333, -- Inevitable End
		286742, -- Necrotic Smash
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")

	-- Stage 1
	self:Log("SPELL_CAST_SUCCESS", "ScorchingDetonationSuccess", 284831)
	self:Log("SPELL_CAST_START", "PlagueofToads", 284933)
	self:Log("SPELL_CAST_SUCCESS", "GreaterSerpentTotem", 285172)
	self:Log("SPELL_AURA_APPLIED", "SealofPurificationApplied", 290450, 284662) -- Heroic, Mythic
	self:Log("SPELL_CAST_START", "MeteorLeap", 284686)
	self:Log("SPELL_CAST_SUCCESS", "CrushingLeap", 284719)
	self:Log("SPELL_CAST_START", "GrievousAxe", 284781)
	self:Log("SPELL_AURA_APPLIED", "GrievousAxeApplied", 284781)

	-- Stage 2
	self:Log("SPELL_AURA_APPLIED", "DeathsPresence", 284376)
	self:Log("SPELL_AURA_APPLIED", "DeathlyWithering", 285195)
	self:Log("SPELL_AURA_APPLIED_DOSE", "DeathlyWithering", 285195)
	self:Log("SPELL_AURA_REMOVED", "DeathlyWitheringRemoved", 285195)
	self:Log("SPELL_CAST_SUCCESS", "PlagueofFire", 285346)
	self:Log("SPELL_AURA_APPLIED", "PlagueofFireApplied", 285349)
	self:Log("SPELL_CAST_SUCCESS", "ZombieDustTotem", 285003)
	self:Log("SPELL_CAST_START", "CaressofDeath", 285213)
	self:Log("SPELL_CAST_START", "DeathsDoor", 288449)
	self:Log("SPELL_AURA_APPLIED", "DeathsDoorApplied", 288449)

	-- Stage 3
	self:Log("SPELL_CAST_START", "InevitableEnd", 287333)
	self:Log("SPELL_CAST_START", "NecroticSmash", 286742)
end

function mod:OnEngage()
	toadCount = 1
	zombieDustTotemCount = 1
	stage = 1
	detonationCount = 1
	deathlyWitheringList = {}

	self:Bar(284781, 8.5) -- Grievous Axe
	self:Bar(290450, 8.5) -- Seal of Purification
	self:Bar(284686, 15.5) -- Meteor Leap
	self:Bar(284933, 20.5, CL.count:format(self:SpellName(284933), toadCount)) -- Plague of Toads
	self:Bar(284831, 26.5, CL.count:format(self:SpellName(284831), detonationCount)) -- Scorching Detonation
	self:Bar(285172, 31.5) -- Greater Serpent Totem
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_SPELLCAST_SUCCEEDED(_, unit, _, spellId)
	if spellId == 290801 then -- King Rastakhan P2 -> P3 Conversation
		stage = 3
		self:PlaySound("stages", "long")
		self:Message2("stages", "cyan", CL.stage:format(stage), false)

		self:StopBar(284933, CL.count:format(self:SpellName(284933), toadCount)) -- Plague of Toads
		self:StopBar(285213) -- Caress of Death
		self:StopBar(288449) -- Death's Door
		self:StopBar(CL.count:format(self:SpellName(285003), zombieDustTotemCount)) -- Zombie Dust Totem

		self:CDBar(286742, 28.5) -- Necrotic Smash
		self:CDBar(287333, 44) -- Inevitable End
	elseif spellId == 290852 then -- King Rastakhan P3 -> P4 Conversation
		stage = 4
		toadCount = 1
		self:CloseInfo(285195) -- Deathly Withering

		self:PlaySound("stages", "long")
		self:Message2("stages", "cyan", CL.stage:format(stage), false)

		self:Bar(284933, 20.5, CL.count:format(self:SpellName(284933), toadCount)) -- Plague of Toads
		self:Bar(287333, 25.5) -- Inevitable End
	end
end

function mod:ScorchingDetonationSuccess(args)
	self:TargetMessage2(args.spellId, "purple", args.destName, CL.count:format(args.spellName, detonationCount))
	self:PlaySound(args.spellId, "warning", nil, args.destName)
	self:CastBar(args.spellId, 5, CL.count:format(args.spellName, detonationCount))
	detonationCount = detonationCount + 1
	self:CDBar(args.spellId, stage == 2 and 41 or stage == 3 and 33 or stage == 4 and 27 or 22, CL.count:format(args.spellName, detonationCount))
end

function mod:PlagueofToads(args)
	self:Message2(args.spellId, "yellow", CL.count:format(args.spellName, toadCount))
	self:PlaySound(args.spellId, "alert")
	toadCount = toadCount + 1
	self:Bar(args.spellId, stage == 2 and 44 or 20, CL.count:format(args.spellName, toadCount))
end

function mod:GreaterSerpentTotem(args)
	self:Message2(args.spellId, "cyan")
	self:PlaySound(args.spellId, "info")
	self:Bar(args.spellId, 31.5)
end

function mod:SealofPurificationApplied(args)
	self:TargetMessage2(290450, "yellow", args.destName)
	if self:Me(args.destGUID) then
		self:PlaySound(290450, "warning")
		self:Flash(290450)
		self:Say(290450)
	end
	self:Bar(290450, 25.5)
end

function mod:MeteorLeap(args)
	self:Message2(args.spellId, "orange")
	self:PlaySound(args.spellId, "alarm")
	self:CastBar(args.spellId, 5)
	self:Bar(args.spellId, 34)
end

function mod:CrushingLeap(args)
	self:Message2(args.spellId, "cyan")
	self:PlaySound(args.spellId, "info")
end

do
	local warned = nil
	local function printTarget(self, name, guid)
		if warned ~= true then
			warned = true
			self:TargetMessage2(284781, "yellow", name)
			if self:Me(guid) then
				self:PlaySound(284781, "warning")
			end
		end
	end

	function mod:GrievousAxe(args)
		warned = nil
		self:GetBossTarget(printTarget, 0.4, args.sourceGUID)
	end

	function mod:GrievousAxeApplied(args) -- Fallback
		if warned ~= true then
			warned = true
			self:TargetMessage2(args.spellId, "yellow", args.destName)
			if self:Me(args.destGUID) then
				self:PlaySound(args.spellId, "warning")
			end
		end
	end
end

function mod:DeathsPresence(args)
	if stage < 2 then
		stage = 2
		self:PlaySound("stages", "long")
		self:Message2("stages", "cyan", CL.stage:format(stage), false)
		self:StopBar(284781) -- Grievous Axe
		self:StopBar(290450) -- Seal of Purification
		self:StopBar(284686) -- Meteor Leap
		self:StopBar(CL.count:format(self:SpellName(284933), toadCount)) -- Plague of Toads
		self:StopBar(284831) -- Scorching Detonation
		self:StopBar(285172) -- Greater Serpent Totem

		self:OpenInfo(285195, self:SpellName(285195)) -- Deathly Withering
		self:Bar(285003, 19, CL.count:format(self:SpellName(285003), zombieDustTotemCount)) -- Zombie Dust Totem
		self:Bar(285213, 24.3) -- Caress of Death
		self:Bar(284831, 27.3) -- Scorching Detonation
		self:Bar(285346, 35) -- Plague of Fire
		self:Bar(284933, 41, CL.count:format(self:SpellName(284933), toadCount)) -- Plague of Toads
		self:Bar(288449, 43.8) -- Death's Door
	end
end

function mod:DeathlyWithering(args)
	deathlyWitheringList[args.destName] = args.amount or 1
	self:SetInfoByTable(args.spellId, deathlyWitheringList)
end

function mod:DeathlyWitheringRemoved(args)
	deathlyWitheringList[args.destName] = nil
	self:SetInfoByTable(args.spellId, deathlyWitheringList)
end

function mod:PlagueofFire(args)
	self:Message2(args.spellId, "orange")
	self:PlaySound(args.spellId, "alarm")
	self:Bar(args.spellId, 25.5)
end

function mod:PlagueofFireApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(285346)
		self:PlaySound(285346, "warning")
		self:Say(285346, self:SpellName(177849)) -- Fire on X
	end
end

function mod:ZombieDustTotem(args)
	self:Message2(args.spellId, "cyan", CL.count:format(args.spellName, zombieDustTotemCount))
	self:PlaySound(args.spellId, "info")
	zombieDustTotemCount = zombieDustTotemCount + 1
	self:Bar(args.spellId, 45, CL.count:format(args.spellName, zombieDustTotemCount))
end

function mod:CaressofDeath(args)
	self:Message2(args.spellId, "purple")
	self:PlaySound(args.spellId, "alarm")
	self:Bar(args.spellId, 43)
end

function mod:DeathsDoor(args)
	self:CDBar(args.spellId, stage == 4 and 20 or 28)
end

function mod:DeathsDoorApplied(args)
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "warning")
		self:SayCountdown(args.spellId, 8)
	end
	self:TargetMessage2(args.spellId, "orange", args.destName)
end

function mod:InevitableEnd(args)
	self:Message2(args.spellId, "orange")
	self:PlaySound(args.spellId, "warning")
	self:CDBar(args.spellId, stage == 4 and 62.5 or 52.5)
	self:CastBar(args.spellId, 6)
end

function mod:NecroticSmash(args)
	self:Message2(args.spellId, "red")
	self:PlaySound(args.spellId, "alarm")
	self:Bar(args.spellId, 34)
end
