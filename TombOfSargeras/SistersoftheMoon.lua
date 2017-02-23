if not IsTestBuild() then return end -- XXX dont load on live
--------------------------------------------------------------------------------
-- TODO List:

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Sisters of the Moon", 1147, 1903)
if not mod then return end
mod:RegisterEnableMob(118523, 118374, 118518, 119205) -- Huntress Kasparian, Captain Yathae Moonstrike, Priestess Lunaspyre, Moontalon
mod.engageId = 2050
--mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

local stageTwo = mod:SpellName(-15510)
local stageThree = mod:SpellName(-15519)
local screechCount = 0

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		--236541, -- Twilight Glaive
		236547, -- Moon Glaive
		236550, -- Discorporate
		236480,	-- Glaive Storm
		--237633, -- Spectral Glaive
		{236305, "ICON"}, -- Incorporeal Shot
		--236516, -- Twilight Volley
		--237630, -- Shadow Shot
		236694, -- Call Moontalon
		236697, -- Deadly Screech
		236603, -- Rapid Shot
		{233263, "PROXIMITY"}, -- Embrace of the Eclipse
		236519, -- Moon Burn
		--237632, -- Lunar Strike
		236712, -- Lunar Beacon
		--239264, -- Lunar Fire
	},{
		[236547] = -15499, -- Huntress Kasparian
		[236480] = stageTwo, -- Stage Two: Bow of the Night
		[236305] = -15502, -- Captain Yathae Moonstrike
		[236694] = stageTwo, -- Stage Two: Bow of the Night
		[233263] = -15506, -- Priestess Lunaspyre
		[236712] = stageThree, -- Stage Three: Wrath of Elune
	}
end

function mod:OnBossEnable()
	-- Huntress Kasparian
	--self:Log("SPELL_CAST_SUCCESS", "TwilightGlaive", 236541) -- Twilight Glaive
	self:Log("SPELL_CAST_SUCCESS", "MoonGlaive", 236547) -- Moon Glaive
	self:Log("SPELL_AURA_APPLIED", "Discorporate", 236550) -- Discorporate
	self:Log("SPELL_AURA_APPLIED", "DiscorporateRemoved", 236550) -- Discorporate
	-- Stage Two: Bow of the Night
	self:Log("SPELL_CAST_SUCCESS", "GlaiveStorm", 236480) -- Glaive Storm
	--self:Log("SPELL_CAST_SUCCESS", "SpectralGlaive", 237633) -- Spectral Glaive

	-- Captain Yathae Moonstrike
	self:Log("SPELL_AURA_APPLIED", "IncorporealShotApplied", 236305) -- Incorporeal Shot
	self:Log("SPELL_AURA_APPLIED", "IncorporealShotRemoved", 236305) -- Incorporeal Shot
	--self:Log("SPELL_CAST_SUCCESS", "TwilightVolley", 236516) -- Twilight Volley
	--self:Log("SPELL_CAST_SUCCESS", "ShadowShot", 237630) -- Shadow Shot
	-- Stage Two: Bow of the Night
	self:Log("SPELL_CAST_START", "CallMoontalon", 236694) -- Call Moontalon
	self:Log("SPELL_CAST_SUCCESS", "DeadlyScreech", 236697) -- Deadly Screech
	self:Log("SPELL_AURA_APPLIED", "RapidShotApplied", 236596) -- Rapid Shot (Debuff)

	-- Priestess Lunaspyre
	self:Log("SPELL_AURA_APPLIED", "EmbraceoftheEclipse", 233263) -- Embrace of the Eclipse
	self:Log("SPELL_AURA_REMOVED", "EmbraceoftheEclipseRemoved", 233263) -- Embrace of the Eclipse
	self:Log("SPELL_AURA_APPLIED", "MoonBurn", 236519) -- Moon Burn
	--self:Log("SPELL_CAST_SUCCESS", "LunarStrike", 237632) -- Lunar Strike
	-- Stage Three: Wrath of Elune
	self:Log("SPELL_CAST_START", "LunarBeacon", 236712) -- Lunar Beacon
	self:Log("SPELL_AURA_APPLIED", "LunarBeaconApplied", 236712) -- Lunar Beacon (Debuff)
	--self:Log("SPELL_CAST_SUCCESS", "LunarFire", 239264) -- Lunar Fire
end

function mod:OnEngage()
	screechCount = 0
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:MoonGlaive(args)
	self:Message(args.spellId, "Attention", "Alert")
	--self:CDBar(args.spellId, 30)
end

function mod:Discorporate(args)
	if self:Me(args.destGUID) then
		self:TargetMessage(args.spellId, args.destName, "Personal", "Warning")
		self:TargetBar(args.spellId, 30, args.destName)
	end
end

function mod:DiscorporateRemoved(args)
	if self:Me(args.destGUID) then
		self:StopBar(args.spellName, args.destName)
	end
end

function mod:GlaiveStorm(args)
	self:Message(args.spellId, "Attention", "Info")
	--self:CDBar(args.spellId, 30)
end

function mod:IncorporealShotApplied(args)
	self:TargetMessage(args.spellId, args.destName, "Important", "Warning", nil, nil, true)
	self:TargetBar(args.spellId, 6, args.destName)
	self:PrimaryIcon(args.spellId, args.destName)
	--self:CDBar(args.spellId, 30)
end

function mod:IncorporealShotRemoved(args)
	self:PrimaryIcon(args.spellId)
end

function mod:CallMoontalon(args)
	screechCount = 0
	self:Message(args.spellId, "Urgent", "Alert", CL.incoming:format(self:spellName(-15064))) -- Moontalon
	--self:CDBar(args.spellId, 30)
end

function mod:DeadlyScreech(args)
	screechCount = screechCount + 1
	self:Message(args.spellId, "Attention", "Alert", CL.count:format(args.spellName, screechCount))
	--self:CDBar(args.spellId, 30)
end

function mod:RapidShotApplied(args)
	self:TargetMessage(236603, args.destName, "Urgent", "Warning", nil, nil, true)
	--self:CDBar(236603, 30)
end

do
	local list = mod:NewTargetList()
	function mod:EmbraceoftheEclipse(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.1, args.spellId, list, "Important", "Warning", nil, nil, true)
		end
		if self:Me(args.destGUID) then
			self:OpenProximity(args.spellId, 8)
		end
	end

	function mod:EmbraceoftheEclipseRemoved(args)
		if self:Me(args.destGUID) then
			self:CloseProximity(args.spellId)
		end
	end
end

function mod:MoonBurn(args)
	if self:Me(args.destGUID) then
		self:TargetMessage(args.spellId, args.destName, "Personal", "Warning")
		self:TargetBar(args.spellId, 30, args.destName)
	end
end

function mod:LunarBeacon(args)
	self:Message(args.spellId, "Urgent", "Alert", CL.incoming:format(args.spellName))
	--self:CDBar(args.spellId, 30)
end

function mod:LunarBeaconApplied(args)
	if self:Me(args.destGUID) then
		self:TargetMessage(args.spellId, args.destName, "Personal", "Warning")
		self:TargetBar(args.spellId, 6, args.destName)
		self:Say(args.spellId)
		self:ScheduleTimer("Say", 3, args.spellId, 3, true)
		self:ScheduleTimer("Say", 4, args.spellId, 2, true)
		self:ScheduleTimer("Say", 5, args.spellId, 1, true)
	else
		self:TargetMessage(args.spellId, args.destName, "Attention", "Info")
	end
end
