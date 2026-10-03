
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Vorasius", 2912, 2734)
if not mod then return end
mod:RegisterEnableMob(240434) -- Vorasius
mod:SetEncounterID(3177)
mod:SetRespawnTime(30)
mod:SetPrivateAuraSounds({
	-- {1243016, sound = "alarm"}, -- Blisterburst (15s debuff) still used?
	1259186, -- Blisterburst
	1254113, -- Fixate
	{1272527, sound = "none"}, -- Creep Spit
	{1243220, 1243270, sound = "underyou"}, -- Dark Goo
	1241844, -- Smashed
})
mod:UseCustomTimers(true)

--------------------------------------------------------------------------------
-- Locals
--

local breathCount = 1
local parasiteCount = 1
local slamCount = 1
local roarCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:SetDefaultLocale({ -- SetOption:skip-locale
	shadowclaw_slam = "Slams",
})

--------------------------------------------------------------------------------
-- Renames
--

mod:SetRenames({
	[1256855] = {CL.breath}, -- Void Breath (Breath)
	[1254199] = {CL.adds}, -- Parasite Expulsion (Adds)
	[1241692] = {L.shadowclaw_slam}, -- Shadowclaw Slam (Slams)
	[1260052] = {CL.roar}, -- Primordial Roar (Roar)
})

--------------------------------------------------------------------------------
-- Initialization
--
function mod:GetOptions()
	return {
		1256855, -- Void Breath
		1254199, -- Parasite Expulsion
		1241692, -- Shadowclaw Slam
		1260052, -- Primordial Roar
		"berserk",
	}
end

function mod:OnBossEnable()
	self:SetTimelineHandler("Timers")
end

function mod:OnEncounterStart()
	breathCount = 1
	parasiteCount = 1
	slamCount = 1
	roarCount = 1

	self:Berserk(372, true)
end

--------------------------------------------------------------------------------
-- Timeline Event Handlers
--

function mod:Timers(eventInfo)
	local durationRounded = self:RoundNumber(eventInfo.duration, 0)
	if durationRounded == 16 or durationRounded == 136 or durationRounded == 240 then
		return self:ShadowclawSlam(durationRounded)
	elseif durationRounded == 57 or durationRounded == 123 then
		return self:ParasiteExpulsion()
	elseif durationRounded == 6 or durationRounded == 120 then
		return self:PrimordialRoar(durationRounded)
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:VoidBreath()
	local barText = CL.count:format(self:GetRename(1256855), breathCount)
	breathCount = breathCount + 1
	return {
		msg = barText,
		key = 1256855,
		exact = true,
		onFinished = function()
			self:Message(1256855, "red", barText)
			self:PlaySound(1256855, "warning")
		end
	}
end

function mod:ParasiteExpulsion()
	local barText = CL.count:format(self:GetRename(1254199), parasiteCount)
	parasiteCount = parasiteCount + 1
	return {
		msg = barText,
		key = 1254199,
		exact = true,
		onFinished = function()
			self:Message(1254199, "cyan", barText)
			self:PlaySound(1254199, "long")
		end
	}
end

function mod:ShadowclawSlam(durationRounded)
	local count = slamCount
	if durationRounded == 16 then -- 136 and 16 are started on the pull but possibly out of order, correct count here.
		count = 1
	elseif durationRounded == 136 then
		count = 2
	end
	local barText = CL.count:format(self:GetRename(1241692), count)
	slamCount = slamCount + 1
	return {
		msg = barText,
		key = 1241692,
		exact = true,
		onFinished = function()
			self:Message(1241692, "yellow", barText)
			self:PlaySound(1241692, "alert")
		end
	}
end

do
	local function StopBarOnWarning(barText, severity)
		mod:ScheduleTimer(function() mod:UnregisterEvent("ENCOUNTER_WARNING") mod:StopBar(barText) end, 10) -- the encounter message sometimes doesn't show, so this fails for now
		mod:RegisterEvent("ENCOUNTER_WARNING", function(event, info)
			--mod:Error(("Elapsed %s, severity was %s"):format(GetTime()-t, info.severity), true)
			if not severity or info.severity == severity then
				mod:StopBar(barText)
				mod:UnregisterEvent(event)
			end
		end)
	end
	function mod:PrimordialRoar(durationRounded)
		if durationRounded == 120 and self:ShouldShowBars() then
			-- Void Breath: boss is bugged and doesn't gain energy? which doesn't fire breath bars?
			local barText = CL.count:format(self:GetRename(1256855), breathCount)
			self:CDBar(1256855, 89, barText)
			breathCount = breathCount + 1
			self:ScheduleTimer(function() StopBarOnWarning(barText, 2) end, 85)
		end

		local barText = CL.count:format(self:GetRename(1260052), roarCount)
		roarCount = roarCount + 1
		return {
			msg = barText,
			key = 1260052,
			exact = true,
			onFinished = function()
				self:Message(1260052, "orange", barText)
				self:PlaySound(1260052, "alarm")
			end
		}
	end
end
