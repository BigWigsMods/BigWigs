----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:New("Custom Bars", "$Revision$")
if not mod then return end
mod.external = true

----------------------------
--   Are you local?       --
----------------------------

local times = nil
local fmt = string.format

local L = LibStub("AceLocale-3.0"):GetLocale("BigWigs:Extras")

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self.enabled = true
	times = {}

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "BWCustomBar", 0)
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:BigWigs_RecvSync(sync, rest, nick)
	if sync ~= "BWCustomBar" or not rest or not nick or not self.enabled then return end

	if UnitInRaid("player") then
		local num = GetNumRaidMembers()
		for i = 1, num do
			local name, rank = GetRaidRosterInfo(i)
			if name == nick then
				if rank == 0 then
					return
				else
					break
				end
			end
		end
	end

	self:StartBar(rest, nick, false)
end

------------------------------
--      Utility             --
------------------------------

local function parseTime(input)
	if type(input) == "nil" then return end
	if tonumber(input) then return tonumber(input) end
	if type(input) == "string" then
		input = input:trim()
		if input:find(":") then
			local m, s = select(3, input:find("^(%d+):(%d+)$"))
			if not tonumber(m) or not tonumber(s) then return end
			return (tonumber(m) * 60) + tonumber(s)
		elseif input:find("^%d+m$") then
			return tonumber(select(3, input:find("^(%d+)m$"))) * 60
		end
	end
end

function mod:StartBar(bar, nick, localOnly)
	local time, barText = select(3, bar:find("(%S+) (.*)"))
	local seconds = parseTime(time)
	if type(seconds) ~= "number" or type(barText) ~= "string" then
		BigWigs:Print(L["Invalid time (|cffff0000%q|r) or missing bar text in a custom bar started by |cffd9d919%s|r. <time> can be either a number in seconds, a M:S pair, or Mm. For example 5, 1:20 or 2m."]:format(tostring(time), nick or UnitName("player")))
		return
	end

	if not nick then nick = L["Local"] end
	if seconds == 0 then
		self:CancelScheduledEvent("bwcb"..nick..barText)
		self:TriggerEvent("BigWigs_StopBar", self, nick..": "..barText)
	else
		self:ScheduleEvent("bwcb"..nick..barText, "BigWigs_Message", seconds, fmt(L["%s: Timer [%s] finished."], nick, barText), "Attention", localOnly)
		self:TriggerEvent("BigWigs_StartBar", self, nick..": "..barText, seconds, "Interface\\Icons\\INV_Misc_PocketWatch_01")
	end
end

-- For easy use in macros.
local function BWCB(input)
	local t = GetTime()
	if not times[input] or (times[input] and (times[input] + 2) < t) then
		times[input] = t
		mod:TriggerEvent("BigWigs_SendSync", "BWCustomBar "..input)
	end
end

local function BWLCB(input)
	mod:StartBar(input, nil, true)
end

-- Shorthand slashcommand
_G["SlashCmdList"]["BWCB_SHORTHAND"] = BWCB
_G["SLASH_BWCB_SHORTHAND1"] = "/bwcb"
_G["SlashCmdList"]["BWLCB_SHORTHAND"] = BWLCB
_G["SLASH_BWLCB_SHORTHAND1"] = "/bwlcb"

