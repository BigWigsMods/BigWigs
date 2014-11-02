--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Durumu the Forgotten", 930, 818)
if not mod then return end
mod:RegisterEnableMob(68036)

--------------------------------------------------------------------------------
-- Locals
--

local deadAdds = 0
local lifeDrainCasts = 0
local lingeringGaze = {}
local openedForMe = nil
local blueController, redController, yellowController
local marksUsed = {}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.red_spawn_trigger = "Crimson Fog"
	L.blue_spawn_trigger = "Azure Fog"
	L.yellow_spawn_trigger = "Amber Fog"

	L.adds = "Reveal Adds"
	L.adds_desc = "Warnings for when you reveal a Crimson, Amber, or Azure Fog and for how many Fogs remain."

	L.custom_off_ray_controllers = "Ray controllers"
	L.custom_off_ray_controllers_desc = "Use the {rt1}{rt7}{rt6} raid markers to mark people who will control the ray spawn positions and movement, requires promoted or leader."

	L.custom_off_parasite_marks = "Dark parasite marker"
	L.custom_off_parasite_marks_desc = "To help healing assignments, mark the people who have dark parasite on them with {rt3}{rt4}{rt5}, requires promoted or leader."

	L.initial_life_drain = "Initial Life Drain cast"
	L.initial_life_drain_desc = "Message for the initial Life Drain cast to help with keeping up a reduced healing received debuff."
	L.initial_life_drain_icon = 133798

	L.life_drain_say = "%dx Drain"

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

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		-6889, {133597, "FLASH"}, "custom_off_parasite_marks",
		"custom_off_ray_controllers",
		{133767, "TANK_HEALER"}, {133768, "TANK_HEALER"}, {134626, "PROXIMITY", "FLASH"}, {-6905, "FLASH", "SAY"}, {-6891, "FLASH"}, "adds",
		{133798, "ICON", "SAY"}, {"initial_life_drain", "FLASH"}, -6882, 140502,
		"berserk", "bosskill",
	}, {
		[-6889] = "heroic",
		custom_off_ray_controllers = L.custom_off_ray_controllers,
		[133767] = "general",
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Log("SPELL_AURA_REMOVED", "DarkParasiteRemoved", 133597)
	self:Log("SPELL_AURA_APPLIED", "DarkParasiteApplied", 133597)
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
	self:Log("SPELL_AURA_APPLIED_DOSE", "ArterialCut", 133768)
	self:Log("SPELL_CAST_SUCCESS", "ForceOfWill", 136932)
	self:Log("SPELL_CAST_SUCCESS", "BeamJump", 139202, 139204) -- Blue Ray Tracking, Infrared Tracking (for beam jumping on deaths)
	self:Log("SPELL_CAST_SUCCESS", "BlueBeam", 134122)
	self:Log("SPELL_CAST_SUCCESS", "RedBeam", 134123)
	self:Log("SPELL_CAST_SUCCESS", "YellowBeam", 134124)

	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")

	self:Death("Deaths", 69050, 69051, 69052) -- Crimson Fog, Amber Fog, Azure Fog
	self:Death("Win", 68036) -- Boss
end

function mod:OnEngage()
	self:Berserk(600)
	self:CDBar(134626, 15) -- Lingering Gaze
	self:Bar(-6905, 33) -- Force of Will
	self:Bar(-6891, 41) -- Light Spectrum
	self:Bar(-6882, self:LFR() and 161 or 135, L["death_beam"])
	if self:Heroic() then
		self:Bar(-6889, 127) -- Ice Wall
		self:Bar(133597, 60) -- Dark Parasite
		wipe(marksUsed)
	end
	lifeDrainCasts = 0
	wipe(lingeringGaze)
	openedForMe = nil
	deadAdds = 0
	blueController, redController, yellowController = nil, nil, nil
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	-- Parasite marking
	function mod:DarkParasiteRemoved(args)
		if self.db.profile.custom_off_parasite_marks then
			for i = 3, 5 do
				if marksUsed[i] == args.destName then
					marksUsed[i] = false
					SetRaidTarget(args.destName, 0)
				end
			end
		end
	end

	local function markParasite(destName)
		for i = 3, 5 do
			if not marksUsed[i] then
				SetRaidTarget(destName, i)
				marksUsed[i] = destName
				return
			end
		end
	end
	function mod:DarkParasiteApplied(args)
		self:CDBar(args.spellId, 60)
		if self:Me(args.destGUID) then
			self:Message(args.spellId, "Personal", "Info", CL["you"]:format(args.spellName))
			self:Flash(args.spellId)
		end
		if self.db.profile.custom_off_parasite_marks then
			markParasite(args.destName)
		end
	end
end

local function mark(unit, mark)
	if not unit or not mark or not mod.db.profile.custom_off_ray_controllers then return end
	SetRaidTarget(unit, mark)
end

-- Clear icons on wipe/win
function mod:OnBossDisable()
	mark(blueController, 0)
	mark(redController, 0)
	mark(yellowController, 0)

	if self:Heroic() and self.db.profile.custom_off_parasite_marks then
		for i = 3, 5 do
			local n = marksUsed[i]
			if n then
				SetRaidTarget(n, 0)
			end
		end
	end
end

do
	local prev = 0
	function mod:IceWall(args)
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:Message(-6889, "Urgent")
			self:Bar(-6889, 95)
		end
	end
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
	if lifeDrainCasts == 1 and not self:Heroic() then
		self:CDBar(133798, self:LFR() and 75 or 50)
	else
		self:CDBar(133798, 41) -- 41-46 not sure why this one varies, doesn't look like its based on end of color
	end
end

function mod:LifeDrainStunApplied(args)
	self:PrimaryIcon(133798, args.destName)
	self:TargetMessage(133798, args.destName, "Important", "Alert", nil, nil, true)
end

function mod:LifeDrainStunRemoved(args)
	self:PrimaryIcon(133798)
end

function mod:LifeDrainDose(args)
	self:StackMessage(133798, args.destName, args.amount, "Important")
	if self:Me(args.destGUID) and not self:LFR() then
		self:Say(args.spellId, L["life_drain_say"]:format(args.amount)) -- this spams but is needed, hack even yell would be better
	end
end

do
	-- The tracking spells are cast when first going active (10s after emote) and when the beam jumps after someone dies.
	-- Even though they're SPELL_CAST_SUCCESS, they don't provide the target ;[
	local function findDebuff(spellName, spellId)
		for unit in mod:IterateGroup() do
			if UnitDebuff(unit, spellName) then
				local name = mod:UnitName(unit)
				if spellId == 139202 then
					if blueController ~= name then
						mod:TargetMessage(-6891, name, "Neutral", "Warning", L["blue_beam"], spellId, true)
						mark(unit, 6)
						blueController = name
						if UnitIsUnit(unit, "player") then
							mod:Flash(-6891)
						end
					end
				elseif spellId == 139204 then
					if redController ~= name then
						mod:TargetMessage(-6891, name, "Neutral", "Warning", L["red_beam"], spellId, true)
						mark(unit, 7)
						redController = name
						if UnitIsUnit(unit, "player") then
							mod:Flash(-6891)
						end
					end
				end
				return
			end
		end
		mod:ScheduleTimer(findDebuff, 0.1, spellName, spellId) -- just in case
	end

	function mod:BeamJump(args)
		self:ScheduleTimer(findDebuff, 0.1, args.spellName, args.spellId)
	end
end


function mod:YellowBeam(args)
	-- this is our start of color phase setup, too
	self:StopBar(-6905) -- Force of Will

	deadAdds = 0
	if self:Heroic() then
		self:Bar(-6891, 80, 137747) -- Obliterate
	end
	self:Bar(-6891, 10, L["rays_spawn"], "inv_misc_gem_variety_02")
	self:Bar(-6891, self:LFR() and 240 or 190) -- Light Spectrum

	yellowController = args.destName
	self:ScheduleTimer(mark, 10, yellowController, 0)
	mark(yellowController, 1)
	if self:Me(args.destGUID) then
		self:Message(-6891, "Personal", "Warning", CL["you"]:format(L["yellow_beam"]), args.spellId)
		self:Flash(-6891)
	end
end

function mod:BlueBeam(args)
	blueController = args.destName
	mark(blueController, 6)
	if self:Me(args.destGUID) then
		self:Message(-6891, "Personal", "Warning", CL["you"]:format(L["blue_beam"]), args.spellId)
		self:Flash(-6891)
	end
end

function mod:RedBeam(args)
	redController = args.destName
	mark(redController, 7)
	if self:Me(args.destGUID) then
		self:Message(-6891, "Personal", "Warning", CL["you"]:format(L["red_beam"]), args.spellId)
		self:Flash(-6891)
	end
end

function mod:ForceOfWill(args)
	if self:Me(args.destGUID) then
		self:Message(-6905, "Personal", "Long", CL["you"]:format(self:SpellName(-6905)))
		self:Flash(-6905)
		self:Say(-6905)
	elseif self:Range(args.destName) < 6 then
		self:RangeMessage(-6905)
	else
		self:Message(-6905, "Attention")
	end
	self:CDBar(-6905, 20)
end

function mod:CHAT_MSG_MONSTER_EMOTE(_, msg, _, _, _, target)
	if msg:find("133795") then -- Life Drain (gets target faster than CLEU)
		local name = self:UnitName(target)
		self:PrimaryIcon(133798, name)
		self:TargetMessage("initial_life_drain", name, "Urgent", "Long", 133798, nil, true)
		self:Flash("initial_life_drain", 133798)

	elseif msg:find(L["red_spawn_trigger"]) then
		local sound = (UnitIsUnit("player", redController) or self:Damager()) and "Warning" or nil
		self:Message("adds", "Urgent", sound, L["red_add"], 134123)

	elseif msg:find(L["blue_spawn_trigger"]) then
		local sound = (UnitIsUnit("player", blueController) or self:Damager()) and "Warning" or nil
		self:Message("adds", "Attention", sound, L["blue_add"], 134122)

	elseif msg:find(L["yellow_spawn_trigger"]) then
		self:Message("adds", "Attention", nil, L["yellow_add"], 134124)

	elseif msg:find("134169") then -- Disintegration Beam
		lifeDrainCasts = 0
		self:CDBar(133798, 66) -- Life Drain
		self:CDBar(134626, 76) -- Lingering Gaze
		self:CDBar(-6905, 78) -- Force of Will
		self:Bar(-6882, 54, CL["cast"]:format(L["death_beam"]))
		self:Bar(-6882, self:LFR() and 241 or 191, L["death_beam"])
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
	local amount = args.amount or 1
	self:StackMessage(args.spellId, args.destName, amount, "Attention", amount > 4 and "Info")
end

function mod:ArterialCut(args)
	self:StackMessage(args.spellId, args.destName, args.amount, "Urgent", "Alarm")
end

function mod:Deaths(args)
	if args.mobId == 69050 then -- Red
		deadAdds = deadAdds + 1
		self:Message("adds", "Positive", nil, CL["mob_killed"]:format(L["red_add"], deadAdds, 3), 136154)
	elseif self:LFR() then
		deadAdds = deadAdds + 1
		if args.mobId == 69052 then -- Blue
			self:Message("adds", "Positive", nil, CL["mob_killed"]:format(L["blue_add"], deadAdds, 3), 136177)
		elseif args.mobId == 69051 then -- Yellow
			self:Message("adds", "Positive", nil, CL["mob_killed"]:format(L["yellow_add"], deadAdds, 3), 136175)
		end
	end
	if deadAdds == 3 then
		self:PlaySound("adds", "Info")
		self:StopBar(137747) -- Obliterate (heroic)
		self:CDBar(-6905, 20) -- Force of Will
		mark(blueController, 0)
		mark(redController, 0)
	end
end

