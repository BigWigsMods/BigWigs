
--------------------------------------------------------------------------------
-- TODO List:

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Kil'jaeden", 1147, 1898)
if not mod then return end
mod:RegisterEnableMob(117269)
mod.engageId = 2051
mod.respawnTime = 30 -- XXX Unconfirmed

--------------------------------------------------------------------------------
-- Locals
--

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{239932, "TANK"}, -- Felclaws
		235059, -- Rupturing Singularity
		240910, -- Armageddon
		{236378, "SAY", "FLASH"}, -- Shadow Reflection: Wailing
		{236710, "SAY", "FLASH"}, -- Shadow Reflection: Erupting		
		{238505, "SAY"}, -- Focused Dreadflame
		{237590, "SAY", "FLASH"}, -- Shadow Reflection: Hopeless
		236555, -- Deceiver's Veil
		241721, -- Illidan's Sightless Gaze
		238999, -- Darkness of a Thousand Souls
		239785, -- Demonic Obelisk
		239130, -- Tear Rift
		239253, -- Flaming Orb
	},{
		[239932] = -14921, -- Stage One: The Betrayer
		[238505] = -15221, -- Intermission: Eternal Flame 
		[237590] = -15229, -- Stage Two: Reflected Souls 
		[236555] = -15394, -- Intermission: Deceiver's Veil
		[238999] = -15255, -- Stage Three: Darkness of A Thousand Souls 
	}
end

function mod:OnBossEnable()
	-- Stage One: The Betrayer
	self:Log("SPELL_CAST_START", "Felclaws", 239932)
	self:Log("SPELL_AURA_APPLIED", "FelclawsApplied", 239932)
	self:Log("SPELL_CAST_SUCCESS", "RupturingSingularity", 235059)
	self:Log("SPELL_CAST_START", "Armageddon", 240910)
	
	self:Log("SPELL_AURA_APPLIED", "ShadowReflectionWailing", 239932) -- Shadow Reflection: Wailing
	self:Log("SPELL_AURA_APPLIED", "ShadowReflectionErupting", 236710) -- Shadow Reflection: Erupting
	
		-- Intermission: Eternal Flame 
	self:Log("SPELL_AURA_APPLIED", "FocusedDreadflame", 238505) -- Shadow Reflection: Erupting
	
	-- Stage Two: Reflected Souls 
	self:Log("SPELL_AURA_APPLIED", "ShadowReflectionHopeless", 236710) -- Shadow Reflection: Hopeless	
	
	-- Intermission: Deceiver's Veil
	self:Log("SPELL_AURA_APPLIED", "DeceiversVeil", 236555) -- Deceiver's Veil
	self:Log("SPELL_AURA_APPLIED", "IllidansSightlessGaze", 241721) -- Illidan's Sightless Gaze
	
	-- Stage Three: Darkness of A Thousand Souls 
	self:Log("SPELL_CAST_START", "DarknessofaThousandSouls", 238999) -- Darkness of a Thousand Souls
	self:Log("SPELL_CAST_SUCCESS", "DemonicObelisk", 239785) -- Demonic Obelisk	
	self:Log("SPELL_CAST_SUCCESS", "TearRift", 239130) -- Tear Rift
	self:Log("SPELL_CAST_SUCCESS", "FlamingOrb", 239253) -- Tear Rift
end

function mod:OnEngage()
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- Stage One: The Betrayer
function mod:Felclaws(args)
	self:Message(args.spellId, "Important", "Alarm", CL.casting:format(args.spellName)) -- Water Elemental icon
end

function mod:FelclawsApplied(args)
	self:Message(args.spellId, "Important", "Info")
end

function mod:RupturingSingularity(args)
	self:Message(args.spellId, "Attention", "Info")
end

function mod:Armageddon(args)
	self:Message(args.spellId, "Important", "Warning")
end

do
	local playerList = mod:NewTargetList()
	function mod:ShadowReflectionWailing(args)		
		if self:Me(args.destGUID) then
			local _, _, _, _, _, _, expires = UnitDebuff(args.destName, args.spellName)
			local remaining = expires-GetTime()
			self:Flash(args.spellId)
			self:Say(args.spellId)
			self:ScheduleTimer("Say", remaining-3, args.spellId, 3, true)
			self:ScheduleTimer("Say", remaining-2, args.spellId, 2, true)
			self:ScheduleTimer("Say", remaining-1, args.spellId, 1, true)
		end

		playerList[#playerList+1] = args.destName

		if #playerList == 1 then
			self:ScheduleTimer("TargetMessage", 0.1, args.spellId, playerList, "Urgent", "Alert")
		end
	end
end

do
	local playerList = mod:NewTargetList()
	function mod:ShadowReflectionErupting(args)		
		if self:Me(args.destGUID) then
			local _, _, _, _, _, _, expires = UnitDebuff(args.destName, args.spellName)
			local remaining = expires-GetTime()
			self:Flash(args.spellId)
			self:Say(args.spellId)
			self:ScheduleTimer("Say", remaining-3, args.spellId, 3, true)
			self:ScheduleTimer("Say", remaining-2, args.spellId, 2, true)
			self:ScheduleTimer("Say", remaining-1, args.spellId, 1, true)
		end

		playerList[#playerList+1] = args.destName

		if #playerList == 1 then
			self:ScheduleTimer("TargetMessage", 0.1, args.spellId, playerList, "Urgent", "Alert")
		end
	end
end

function mod:FocusedDreadflame(args)	
	if self:Me(args.destGUID) then
		self:Say(args.spellId)
	end
	self:TargetMessage(args.spellId, args.destName, "Urgent", "Warning")
end

do
	local playerList = mod:NewTargetList()
	function mod:ShadowReflectionHopeless(args)		
		if self:Me(args.destGUID) then
			local _, _, _, _, _, _, expires = UnitDebuff(args.destName, args.spellName)
			local remaining = expires-GetTime()
			self:Flash(args.spellId)
			self:Say(args.spellId)
			self:ScheduleTimer("Say", remaining-3, args.spellId, 3, true)
			self:ScheduleTimer("Say", remaining-2, args.spellId, 2, true)
			self:ScheduleTimer("Say", remaining-1, args.spellId, 1, true)
		end

		playerList[#playerList+1] = args.destName

		if #playerList == 1 then
			self:ScheduleTimer("TargetMessage", 0.1, args.spellId, playerList, "Urgent", "Alert")
		end
	end
end

function mod:DeceiversVeil(args)	
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "Attention", "Info")
	end
end

function mod:IllidansSightlessGaze(args)	
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "Personal", "Long")
	end
end

function mod:DarknessofaThousandSouls(args)	
	self:Message(args.spellId, "Urgent", "Long", CL.casting:format(args.spellName))
	self:CastBar(args.spellId, 9)
end

function mod:DemonicObelisk(args)	
	self:Message(args.spellId, "Attention", "Warning")
end

function mod:TearRift(args)	
	self:Message(args.spellId, "Important", "Alarm")
end

function mod:FlamingOrb(args)	
	self:Message(args.spellId, "Attention", "Alert")
end

