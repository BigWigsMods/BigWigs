--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Durumu the Forgotten", 930, 818)
if not mod then return end
mod:RegisterEnableMob(68036)

--------------------------------------------------------------------------------
-- Locals
--
local redAddDead = 0
local lifeDrainCasts = 0
local lingeringGaze = {}
local openedForMe = nil
local blueController, redController

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.red_spawn_trigger = "The Infrared Light reveals a Crimson Fog!"
	L.blue_spawn_trigger = "The Blue Rays reveal an Azure Fog!"
	L.yellow_spawn_trigger = "The Bright Light reveals an Amber Fog!"

	L.adds = "Reveal Adds"
	L.adds_desc = "Warnings for when you reveal a Crimson, Amber, or Azure Fog and for how many Crimson Fogs remain."

	L.custom_off_ray_controllers = "Ray controllers"
	L.custom_off_ray_controllers_desc = "Use the %s%s%s raid markers to mark people who will control the ray spawn positions and movement."

	L.rays_spawn = "Rays spawn"
	L.red_add = "|cffff0000Red|r add"
	L.blue_add = "|cff0000ffBlue|r add"
	L.yellow_add = "|cffffff00Yellow|r add"
	L.death_beam = "Death beam"
	L.red_beam = "|cffff0000Red|r beam"
	L.blue_beam = "|cff0000ffBlue|r beam"
	L.yellow_beam = "|cffffff00Yellow|r beam"
end
L = mod:GetLocale()

L.custom_off_ray_controllers_desc = L.custom_off_ray_controllers_desc:format(
	"|TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcon_1.blp:15|t",
	"|TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcon_7.blp:15|t",
	"|TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcon_6.blp:15|t"
)

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		-6889,
		"custom_off_ray_controllers",
		{133767, "TANK_HEALER"}, {134626, "PROXIMITY", "FLASH"}, {-6905, "FLASH", "SAY"}, {-6891, "FLASH"}, "adds",
		{133798, "ICON"}, -6882, 140502,
		"berserk", "bosskill",
	}, {
		[-6889] = "heroic",
		custom_off_ray_controllers = L.custom_off_ray_controllers,
		[133767] = "general",
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Log("SPELL_CAST_START", "IceWall", 134587)
	self:Log("SPELL_PERIODIC_DAMAGE", "EyeSoreDamage", 134755)
	self:Log("SPELL_PERIODIC_MISSED", "EyeSoreDamage", 134755)
	self:Log("SPELL_CAST_SUCCESS", "LifeDrainCast", 133795)
	self:Log("SPELL_AURA_APPLIED", "LifeDrainStunApplied", 137727)
	self:Log("SPELL_AURA_REMOVED", "LifeDrainStunRemoved", 137727)
	self:Log("SPELL_AURA_APPLIED_DOSE", "LifeDrainDose", 133798)
	self:Log("SPELL_DAMAGE", "LingeringGazeDamage", 134044)
	self:Log("SPELL_AURA_REMOVED", "LingeringGazeRemoved", 134626)
	self:Log("SPELL_AURA_APPLIED", "LingeringGazeApplied", 134626)
	self:Log("SPELL_CAST_START", "HardStare", 133765)
	self:Log("SPELL_AURA_APPLIED", "SeriousWound", 133767)
	self:Log("SPELL_AURA_APPLIED_DOSE", "SeriousWound", 133767)
	self:Log("SPELL_CAST_SUCCESS", "Tracking", 139202) -- for beam jumping on deaths
	self:Log("SPELL_CAST_SUCCESS", "Tracking", 139204)

	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")

	self:Death("Deaths", 69050) -- Crimson Fog
	self:Death("Win", 68036) -- Boss
end

function mod:OnEngage()
	self:Berserk(600)
	self:CDBar(134626, 15) -- Lingering Gaze
	self:Bar(-6905, 33) -- Force of Will
	self:Bar(-6891, 41) -- Light Spectrum
	self:Bar(-6882, 135, L["death_beam"])
	if self:Heroic() then
		self:Bar(-6889, 127) -- Ice Wall
	end
	lifeDrainCasts = 0
	wipe(lingeringGaze)
	openedForMe = nil
	redAddDead = 0
end

--------------------------------------------------------------------------------
-- Event Handlers
--

local function mark(unit, mark)
	if not unit or not mark or not mod.db.profile.custom_off_ray_controllers then return end
	SetRaidTarget(unit, mark)
end

function mod:IceWall(args)
	self:Message(-6889, "Urgent")
	self:Bar(-6889, 95)
end

do
	local prev = 0
	function mod:EyeSoreDamage(args)
		if not self:Me(args.destGUID) then return end
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:Message(args.spellId, "Personal", "Info", CL["underyou"]:format(args.spellName))
			self:Flash(args.spellId)
		end
	end
end

function mod:LifeDrainCast(args)
	lifeDrainCasts = lifeDrainCasts + 1
	self:Bar(133798, 15, CL["cast"]:format(args.spellName))
	self:DelayedMessage(133798, 15, "Positive", CL["over"]:format(args.spellName))
	if lifeDrainCasts == 1 then
		self:CDBar(133798, 50)
	else
		self:CDBar(133798, 41) -- XXX 41-46 not sure why this one varies, doesn't look like its based on end of color
	end
end

function mod:LifeDrainStunApplied(args)
	self:PrimaryIcon(133798, args.destName)
	self:TargetMessage(133798, args.destName, "Important", "Alert", true)
end

function mod:LifeDrainStunRemoved(args)
	self:PrimaryIcon(133798)
end

function mod:LifeDrainDose(args)
	if args.amount % 2 == 0 or args.amount > 4 then -- assuming you want to be soaking for ~5s each
		self:StackMessage(133798, args.destName, args.amount, "Important")
	end
end

do
	-- The tracking spells are cast when first going active (10s after emote) and when the beam jumps after someone dies.
	-- Even though they're SPELL_CAST_SUCCESS, they don't provide the target ;[
	local function findDebuff(spellName, spellId)
		local found
		for i=1, GetNumGroupMembers() do
			local unit = ("raid%d"):format(i)
			if UnitDebuff(unit, spellName) then
				local name, server = UnitName(unit)
				if server then name = name.."-"..server end
				found = true
				if spellId == 139202 then
					if blueController ~= name then
						mod:TargetMessage(-6891, name, "Neutral", "Warning", L["blue_beam"], spellId, true)
						mark(name, 6)
						blueController = name
					end
				elseif spellId == 139204 then
					if redController ~= name then
						mod:TargetMessage(-6891, name, "Neutral", "Warning", L["red_beam"], spellId, true)
						mark(name, 7)
						redController = name
					end
				end
				break
			end
		end
		if not found then -- just in case
			mod:ScheduleTimer(findDebuff, 0.1, spellName, spellId)
		end
	end

	function mod:Tracking(args)
		self:ScheduleTimer(findDebuff, 0.1, args.spellName, args.spellId)
	end
end

function mod:CHAT_MSG_MONSTER_EMOTE(_, msg, _, _, _, target)
	-- get full name if needed (hope everyone has a unique name!)
	local name, server = UnitName(target)
	if server then target = name.."-"..server end

	if msg:find("134124") then -- Yellow
		self:StopBar(-6905) -- Force of Will

		redAddDead = 0
		if self:Heroic() then
			self:Bar(-6891, 80, 137747) -- Obliterate
		end
		self:Bar(-6891, 10, L["rays_spawn"], "inv_misc_gem_variety_02")
		self:Bar(-6891, 190) -- Light Spectrum

		self:ScheduleTimer(mark, 10, target, 0)
		mark(target, 1)
		if UnitIsUnit("player", target) then
			self:Message(-6891, "Personal", "Alert", CL["you"]:format(L["yellow_beam"]), 134124)
		end
	elseif msg:find("134123") then -- Red
		redController = target
		mark(target, 7)
		if UnitIsUnit("player", target) then
			self:Message(-6891, "Personal", "Alert", CL["you"]:format(L["red_beam"]), 139204)
		end
	elseif msg:find("134122") then -- Blue
		blueController = target
		mark(target, 6)
		if UnitIsUnit("player", target) then
			self:Message(-6891, "Personal", "Alert", CL["you"]:format(L["blue_beam"]), 139202)
		end
	elseif msg:find("133795") then -- Life Drain (gets target faster than CLEU)
		self:TargetMessage(133798, target, "Important", "Alert")
		self:PrimaryIcon(133798, target)
	elseif msg:find(L["red_spawn_trigger"]) then
		self:Message("adds", "Urgent", UnitIsUnit("player", redController) and "Warning", L["red_add"], 136154)
	elseif msg:find(L["blue_spawn_trigger"]) then
		self:Message("adds", "Attention", UnitIsUnit("player", blueController) and "Warning", L["blue_add"], 136177)
	elseif msg:find(L["yellow_spawn_trigger"]) then
		self:Message("adds", "Attention", nil, L["yellow_add"], 136175)
	elseif msg:find("136932") then -- Force of Will
		if UnitIsUnit("player", target) then
			self:Message(-6905, "Personal", "Long", CL["you"]:format(self:SpellName(-6905)))
			self:Flash(-6905)
			self:Say(-6905)
		elseif self:Range(target) < 6 then
			self:RangeMessage(-6905)
		else
			self:Message(-6905, "Attention")
		end
		self:CDBar(-6905, 20)
	elseif msg:find("134169") then -- Disintegration Beam
		lifeDrainCasts = 0
		self:CDBar(133798, 66) -- Life Drain
		self:CDBar(134626, 76) -- Lingering Gaze
		self:CDBar(-6905, 78) -- Force of Will
		self:Bar(-6882, 63, CL["cast"]:format(L["death_beam"])) -- Exactly 60 sec, a good place to start other timers
		self:Bar(-6882, 191, L["death_beam"])
		self:Message(-6882, "Attention", nil, L["death_beam"])
	end
end

do
	local prev = 0
	function mod:LingeringGazeDamage(args)
		if not self:Me(args.destGUID) then return end
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:Message(134626, "Personal", "Info", CL["underyou"]:format(args.spellName))
			self:Flash(134626)
		end
	end
end

function mod:LingeringGazeRemoved(args)
	if self:Me(args.destGUID) then
		openedForMe = nil
	end
	-- don't close if someone uses bubble/cloak/etc to remove it
	for i,v in next, lingeringGaze do
		if v == args.destName then
			tremove(lingeringGaze, i)
			break
		end
	end
	if #lingeringGaze == 0 then
		self:CloseProximity(args.spellId)
	elseif not openedForMe then
		self:CloseProximity(args.spellId)
		self:OpenProximity(args.spellId, 15, lingeringGaze)
	end
end

function mod:LingeringGazeApplied(args)
	self:CDBar(args.spellId, 25)
	if self:Me(args.destGUID) then
		self:Flash(args.spellId)
		self:Message(args.spellId, "Urgent", "Alarm", CL["you"]:format(args.spellName))
		self:OpenProximity(args.spellId, 15)
		openedForMe = true
	else
		lingeringGaze[#lingeringGaze+1] = args.destName
		if not openedForMe then
			self:OpenProximity(args.spellId, 15, lingeringGaze)
		end
	end
end

function mod:HardStare(args)
	self:ScheduleTimer("Bar", 1, 133767, 12) -- end the bar when the cast ends
end

function mod:SeriousWound(args)
	self:StackMessage(args.spellId, args.destName, args.amount, "Attention", "Info")
end

function mod:Deaths(args)
	if args.mobId == 69050 then -- Red add
		redAddDead = redAddDead + 1
		self:Message("adds", "Positive", redAddDead == 3 and "Info", CL["add_killed"]:format(redAddDead, 3), 136154)
		if redAddDead == 3 then
			self:StopBar(137747) -- Obliterate (heroic)
			self:CDBar(-6905, 20) -- Force of Will
			mark(blueController, 0)
			mark(redController, 0)
		end
	end
end

