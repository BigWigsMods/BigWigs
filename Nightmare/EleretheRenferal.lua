
--------------------------------------------------------------------------------
-- TODO List:
-- - Tuning sounds / message colors
-- - Remove beta engaged message
-- - All the timers
-- - Mythic abilitys
-- - 212993 Shimmering Feather is not in the combat log (yet)?
-- - Necrotic Venom is missing stuff from combat log. 1. debuff = run out, 2. debuff = you spawn puddles
--   we currently only warn on 2. debuff

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Elerethe Renferal", 1094, 1744)
if not mod then return end
mod:RegisterEnableMob(106087)
mod.engageId = 1876
--mod.respawnTime = 0

--------------------------------------------------------------------------------
-- Locals
--

local twistingShadowsCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.isLinkedWith = "%s is linked with %s"
	L.yourLink = "You are linked with %s"
	L.yourLinkShort = "Linked with %s"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		--[[ Spider Form ]]--
		215300, -- Web of Pain
		212364, -- Feeding Time
		214348, -- Vile Ambush
		{215460, "SAY", "FLASH"}, -- Necrotic Venom

		--[[ Roc Form ]]--
		212707, -- Gathering Clouds
		210948, -- Dark Storm
		{210864, "SAY", "FLASH"}, -- Twisting Shadows
		210547, -- Razor Wing
		{215582, "TANK"}, -- Raking Talons

		--[[ General ]]--
		"stages",
		213124, -- Venomous Pool
		"berserk",
	},{
		[215300] = -13259, -- Spider Form
		[212707] = -13263, -- Roc Form
		["stages"] = "general",
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")

	--[[ Spider Form ]]--
	--self:Log("SPELL_CAST_SUCCESS", "WebOfPain", 215288) -- i think we can handle everythin with the auras
	self:Log("SPELL_AURA_APPLIED", "WebOfPainApplied", 215300) -- 215307 is applied to the other player
	self:Log("SPELL_CAST_SUCCESS", "VileAmbush", 214348)
	--self:Log("SPELL_CAST_START", "NecroticVenom", 215443) -- i think we can handle everythin with the auras
	self:Log("SPELL_AURA_APPLIED", "NecroticVenomApplied", 215460)

	--[[ Roc Form ]]--
	self:Log("SPELL_CAST_START", "GatheringCloudsStart", 212707)
	self:Log("SPELL_CAST_START", "DarkStorm", 210948)
	self:Log("SPELL_CAST_START", "TwistingShadows", 210864) -- lets see if start or success is better
	self:Log("SPELL_AURA_APPLIED", "TwistingShadowsApplied", 210850)
	self:Log("SPELL_CAST_START", "RazorWing", 210547)
	self:Log("SPELL_CAST_START", "RakingTalons", 215582)
	--self:Log("SPELL_AURA_APPLIED", "RakingTalonsApplied", 215582) -- do we need this?

	--[[ General ]]--
	self:Log("SPELL_AURA_APPLIED", "PoolDamage", 213124, 215489)
	self:Log("SPELL_AURA_APPLIED_DOSE", "PoolDamage", 213124, 215489)
	self:Log("SPELL_PERIODIC_DAMAGE", "PoolDamage", 213124, 215489)
	self:Log("SPELL_PERIODIC_MISSED", "PoolDamage", 213124, 215489)
end

function mod:OnEngage()
	self:Message("berserk", "Neutral", nil, "Elerethe Renferal Engaged (Beta v2)", "inv_spidermount")

	twistingShadowsCount = 1

	self:Bar(215300, 6)
	self:Bar(212364, 16)
	self:Bar("stages", 90, self:SpellName(-13263), "inv_ravenlordmount")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

local function timeToTransform()
	local spiderFormIn = mod:BarTimeLeft(mod:SpellName(-13259))
	return spiderFormIn > 0 and spiderFormIn or mod:BarTimeLeft(mod:SpellName(-13263))
end

--[[ Spider Form ]]--
function mod:UNIT_SPELLCAST_SUCCEEDED(unit, spellName, _, _, spellId)
	if spellId == 212364 then -- Feeding Time, there is also 214305, fires about 1.2s later
		self:Message(spellId, "Important", "Info")
		self:Bar(214348, 8.2) -- Vile Ambush
		if timeToTransform() > 51 then
			self:Bar(spellId, 51)
		end
	elseif spellId == 226039 then -- Bird Transform => Roc Form
		self:Message("stages", "Neutral", "Info", self:SpellName(-13263), "inv_ravenlordmount") -- Roc Form
		-- stop some timers
		twistingShadowsCount = 1
		self:CDBar(210864, 8)
		self:Bar(210948, 27)
		self:Bar(215582, 53)
		self:Bar(210547, 60)
		self:Bar("stages", 134, self:SpellName(-13259), "inv_spidermount")
	elseif spellId == 226055 then -- Spider Transform => Spider Form
		self:Message("stages", "Neutral", "Info", self:SpellName(-13259), "inv_spidermount") -- Spider Form
		-- stop some timers
		self:Bar(215300, 6)
		self:Bar(212364, 16)
		self:Bar("stages", 90, self:SpellName(-13263), "inv_ravenlordmount")
	end
end

--[[
function mod:WebOfPain(args)
	self:Message(args.spellId, "Attention", nil)
	self:Bar(args.spellId, duration)
end
--]]

function mod:WebOfPainApplied(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "Personal", "Warning", L.yourLink:format(self:ColorName(args.sourceName)))
		local _, _, _, _, _, _, expires = UnitDebuff(args.destName, args.spellName)
		local remaining = expires-GetTime()
		self:Bar(args.spellId, remaining, L.yourLinkShort:format(self:ColorName(args.sourceName)))
	elseif self:Me(args.sourceGUID) then
		self:Message(args.spellId, "Personal", "Warning", L.yourLink:format(self:ColorName(args.destName)))
		local _, _, _, _, _, _, expires = UnitDebuff(args.sourceName, args.spellName)
		local remaining = expires-GetTime()
		self:Bar(args.spellId, remaining, L.yourLinkShort:format(self:ColorName(args.sourceName)))
	else
		self:Message(args.spellId, "Attention", nil, L.isLinkedWith:format(self:ColorName(args.sourceName), self:ColorName(args.destName)))
	end
end

function mod:VileAmbush(args)
	self:Message(args.spellId, "Attention", "Alarm")
end

do
	local list = mod:NewTargetList()
	function mod:NecroticVenomApplied(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.5, args.spellId, list, "Urgent", "Alert")

			if timeToTransform() > 26 then -- skips the one before the transformation
				self:Bar(args.spellId, 22)
			end
		end

		if self:Me(args.destGUID) then
			self:Flash(args.spellId)
			self:Say(args.spellId)

			local _, _, _, _, _, _, expires = UnitDebuff(args.destName, args.spellName)
			local remaining = expires-GetTime()
			self:ScheduleTimer("Say", remaining-3, args.spellId, 3, true)
			self:ScheduleTimer("Say", remaining-2, args.spellId, 2, true)
			self:ScheduleTimer("Say", remaining-1, args.spellId, 1, true)
		end
	end
end

function mod:GatheringCloudsStart(args)
	self:Message(args.spellId, "Attention", "Alarm", CL.casting:format(args.spellName))
	self:Bar(args.spellId, 10.5, CL.cast:format(args.spellName)) -- 2.5s cast + 8s duration = 10.5s total
end

--[[ Roc Form ]]--

function mod:DarkStorm(args)
	self:Message(args.spellId, "Neutral", "Info")
end


function mod:TwistingShadows(args)
	self:Message(args.spellId, "Urgent", "Alert")
	twistingShadowsCount = twistingShadowsCount + 1
	local next = twistingShadowsCount == 2 and 40 or twistingShadowsCount == 4 and 33 or 22
	if timeToTransform() > next then
		self:CDBar(args.spellId, next)
	end
end

function mod:TwistingShadowsApplied(args)
	if self:Me(args.destGUID) then
		self:Flash(210864)
		self:Say(210864)

		local _, _, _, _, _, _, expires = UnitDebuff(args.destName, args.spellName)
		local remaining = expires-GetTime()
		--self:ScheduleTimer("Say", remaining-3, 210864, 3, true)  -- counting from 3 is too much with 4s duration
		self:ScheduleTimer("Say", remaining-2, 210864, 2, true)
		self:ScheduleTimer("Say", remaining-1, 210864, 1, true)
	end
end

function mod:RazorWing(args)
	self:Message(args.spellId, "Important", "Alarm")
	self:Bar(args.spellId, 4.5, CL.cast:format(args.spellName))
	if timeToTransform() > 32.9 then
		self:Bar(args.spellId, 32.9)
	end
end

function mod:RakingTalons(args)
	self:Message(args.spellId, "Attention", "Long")
	if timeToTransform() > 32.9 then
		self:Bar(args.spellId, 32.9)
	end
end


--[[ General ]]--
do
	local prev = 0
	function mod:PoolDamage(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 1.5 then
			prev = t
			self:Message(213124, "Personal", "Alert", CL.underyou:format(args.spellName))
		end
	end
end
