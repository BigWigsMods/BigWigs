
--------------------------------------------------------------------------------
-- TODO List:
-- - Add more timers, if they are more reliable in the future

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Demonic Inquisition", 1147, 1867)
if not mod then return end
mod:RegisterEnableMob(116689, 116691)
mod.engageId = 2048
mod.respawnTime = 15

--------------------------------------------------------------------------------
-- Locals
--

local pangsofGuiltCounter = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		236283, -- Belac's Prisoner
		"altpower",
		233426, -- Scythe Sweep
		{233431, "SAY"}, -- Calcified Quills
		233441, -- Bone Saw
		239401, -- Pangs of Guilt
		{233983, "FLASH", "SAY", "PROXIMITY"}, -- Echoing Anguish
		233895, -- Suffocating Dark
		234015, -- Tormenting Burst
		235230, -- Fel Squall
	},{
		[236283] = "general",
		[233426] = -14645, -- Atrigan
		[239401] = -14646, -- Belac
	}
end

function mod:OnBossEnable()
	-- General
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1", "boss2")
	self:Log("SPELL_AURA_APPLIED", "BelacsPrisoner", 236283)

	-- Atrigan
	self:Log("SPELL_CAST_START", "ScytheSweep", 233426)
	self:Log("SPELL_CAST_SUCCESS", "CalcifiedQuills", 233431)
	self:Log("SPELL_CAST_SUCCESS", "BoneSaw", 233441)

	-- Belac
	self:Log("SPELL_CAST_START", "PangsofGuilt", 239401)
	self:Log("SPELL_CAST_START", "EchoingAnguish", 233983)
	self:Log("SPELL_AURA_APPLIED", "EchoingAnguishApplied", 233983)
	self:Log("SPELL_AURA_REMOVED", "EchoingAnguishRemoved", 233983)
	self:Log("SPELL_CAST_START", "TormentingBurst", 234015)
	self:Log("SPELL_CAST_SUCCESS", "FelSquall", 235230)
end

function mod:OnEngage()
	pangsofGuiltCounter = 0
	self:OpenAltPower("altpower", 233104, nil, true) -- Torment, Sync for those far away

	-- Atrigan
	self:Bar(233426, 6) -- Scythe Sweep
	self:Bar(233431, 11) -- Calcified Quills
	self:Bar(233441, 61.5) -- Bone Saw

	-- Belac
	self:Bar(235230, 31.5) -- Fel Squall
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_SPELLCAST_SUCCEEDED(unit, spellName, _, _, spellId)
	if spellId == 233895 then -- Suffocating Dark
		self:Message(spellId, "Attention", "Info")
	end
end

function mod:BelacsPrisoner(args)
	if self:Me(args.destGUID)then
		self:TargetMessage(args.spellId, args.destName, "Personal", "Alert")
	end
end

function mod:ScytheSweep(args)
	self:Message(args.spellId, "Attention", "Info")
	self:CDBar(args.spellId, 23)
end

do
	local function printTarget(self, name, guid)
		self:TargetMessage(233431, name, "Urgent", "Alert", nil, nil, true)
		if self:Me(guid) then
			self:Say(233431)
		end
	end
	function mod:CalcifiedQuills(args)
		self:GetBossTarget(printTarget, 0.7, args.sourceGUID)
		self:CastBar(args.spellId, 3)
		self:Bar(args.spellId, 21.5)
	end
end

function mod:BoneSaw(args)
	self:Message(args.spellId, "Important", "Warning")
	self:CastBar(args.spellId, 15)
	self:Bar(args.spellId, 60.5)
end

function mod:PangsofGuilt(args) -- Interuptable
	pangsofGuiltCounter = pangsofGuiltCounter + 1
	if pangsofGuiltCounter == 4 then -- 1, 2, 3 counter
		pangsofGuiltCounter = 1
	end
	self:Message(args.spellId, "Important", "Alert", CL.casting:format(CL.count:format(args.spellName, pangsofGuiltCounter)))
end

function mod:EchoingAnguish(args)
	self:Message(args.spellId, "Important", "Alert")
	self:OpenProximity(args.spellId, 8) -- Open proximity a bit before
end

do
	local proxList = {}

	function mod:EchoingAnguishApplied(args)
		proxList[#proxList+1] = args.destName
		if self:Me(args.destGUID) then
			self:Flash(args.spellId)
			self:Say(args.spellId)
		end
		self:OpenProximity(args.spellId, 8, proxList) -- Don't stand near others if they have the debuff
	end

	function mod:EchoingAnguishRemoved(args)
		tDeleteItem(proxList, args.destName)
		if #proxList == 0 then -- If there are no debuffs left, close proximity
			self:CloseProximity(args.spellId)
		else
			self:OpenProximity(args.spellId, 8, proxList) -- Refresh list
		end
	end
end

function mod:TormentingBurst(args)
	self:Message(args.spellId, "Attention", "Info")
end

function mod:FelSquall(args)
	self:Message(args.spellId, "Important", "Warning")
	self:CastBar(args.spellId, 15)
	self:Bar(args.spellId, 60.5)
end
