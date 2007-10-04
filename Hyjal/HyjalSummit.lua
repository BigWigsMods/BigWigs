------------------------------
--      Are you local?      --
------------------------------

local name = AceLibrary("Babble-Zone-2.2")["Hyjal Summit"]
local allianceBase = AceLibrary("Babble-Zone-2.2")["Alliance Base"]
local hordeEncampment = AceLibrary("Babble-Zone-2.2")["Horde Encampment"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..name)

local winterchill = AceLibrary("Babble-Boss-2.2")["Rage Winterchill"]
local anatheron = AceLibrary("Babble-Boss-2.2")["Anetheron"]
local kazrogal = AceLibrary("Babble-Boss-2.2")["Kaz'rogal"]
local azgalor = AceLibrary("Babble-Boss-2.2")["Azgalor"]

local fmt = string.format
local strmatch = string.match
local GetRealZoneText = GetRealZoneText
local GetSubZoneText = GetSubZoneText
local tonumber = tonumber

local nextBoss = nil
local currentWave = 0
local allianceWaveTimes = {127.5, 127.5, 127.5, 127.5, 127.5, 127.5, 127.5, 140}
local RWCwaveTimes = allianceWaveTimes --need more accurate times
local hordeWaveTimes = {135, 190, 190, 195, 140, 165, 195, 225}
local KRwaveTimes = hordeWaveTimes --need more accurate times

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "summit",

	wave = "Wave Warnings",
	wave_desc = "Announce approximate warning messages for the next wave.",

	["~%s spawn."] = true,
	["~Wave %d spawn."] = true,
	["Wave %d incoming."] = true,
	["%s in ~%d sec"] = true,
	["Wave %d in ~%d sec"] = true,

	["Boss"] = true,
	["Thrall"] = true,
	["Lady Jaina Proudmoore"] = true,

	["My companions and I are with you, Lady Proudmoore."] = true, -- Rage Winterchill
	["We are ready for whatever Archimonde might send our way, Lady Proudmoore."] = true, -- Anatheron
	["I am with you, Thrall."] = true, -- Kaz'Rogal
	["We have nothing to fear."] = true, -- Az'Galor
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local thrall = L["Thrall"]
local proudmoore = L["Lady Jaina Proudmoore"]

local mod = BigWigs:NewModule(name)
mod.zonename = name
mod.enabletrigger = { thrall, proudmoore }
mod.toggleoptions = {"wave"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))
mod.synctoken = name

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	currentWave = 0
	nextBoss = L["Boss"]
	self:RegisterEvent("UPDATE_WORLD_STATES")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	self:RegisterEvent("GOSSIP_SHOW")
	self:RegisterEvent("QUEST_PROGRESS", "GOSSIP_SHOW")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "SummitWave", 2)
	self:TriggerEvent("BigWigs_ThrottleSync", "SummitNext", 2)
--~ 	throttling these 2 will cause an errant 'wave 1' message when thrall/jaina die
--~ 	self:TriggerEvent("BigWigs_ThrottleSync", "SummitReset", 2)
--~ 	self:TriggerEvent("BigWigs_ThrottleSync", "SummitClear", 2)
end

function mod:GOSSIP_SHOW()
	local target = UnitName("target")
	local gossip = GetGossipOptions()
	if gossip and target == thrall or target == proudmoore then
		if gossip == L["My companions and I are with you, Lady Proudmoore."] then
			self:Sync("SummitNext RWC") -- Rage Winterchill is next
		elseif gossip == L["We are ready for whatever Archimonde might send our way, Lady Proudmoore."] then
			self:Sync("SummitNext Anatheron") -- Anatheron is next
		elseif gossip == L["I am with you, Thrall."] then
			self:Sync("SummitNext KazRogal") -- Kaz'Rogal is next
		elseif gossip == L["We have nothing to fear."] then
			self:Sync("SummitNext AzGalor") -- Az'Galor is next
		end
	end
end

function mod:UPDATE_WORLD_STATES()
	if self.zonename ~= GetRealZoneText() then return end -- bail out in case we were left running in another zone
	local uiType, state, text = GetWorldStateUIInfo(3)
	local num = tonumber((text or ""):match("(%d)") or nil)
	if num == 0 then
		self:Sync("SummitClear")  --reseting wave here will clear nextBoss, clear instead
	elseif num and num > currentWave then
		self:Sync(fmt("%s%d %s", "SummitWave ", num, GetSubZoneText()))
	end
end

do
	local proudmooreDies = fmt(UNITDIESOTHER, proudmoore)
	local thrallDies = fmt(UNITDIESOTHER, thrall)
	function mod:CHAT_MSG_COMBAT_HOSTILE_DEATH(msg)
		if msg == proudmooreDies or msg == thrallDies then
			self:Sync("SummitReset")
		end
	end
end

function mod:BigWigs_RecvSync( sync, rest )
	if sync == "SummitNext" and rest then
		if rest == "RWC" then
			nextBoss = winterchill
		elseif rest == "Anatheron" then
			nextBoss = anatheron
		elseif rest == "KazRogal" then
			nextBoss = kazrogal
		elseif rest == "AzGalor" then
			nextBoss = azgalor
		end
	elseif sync == "SummitWave" and rest then
		local wave, zone = strmatch(rest, "(%d+) (.*)")
		if not wave or not zone then return end
		local waveTimes
		if zone == allianceBase then
			if nextBoss == winterchill then
				waveTimes = RWCwaveTimes
			else
				waveTimes = allianceWaveTimes
			end
		elseif zone == hordeEncampment then
			if nextBoss == kazrogal then
				waveTimes = KRwaveTimes
			else
				waveTimes = hordeWaveTimes
			end
		else
			return
		end
		wave = tonumber(wave)
		if wave and wave > currentWave and waveTimes[wave] then
			currentWave = wave

			self:Message(fmt(L["Wave %d incoming."], wave), "Attention")

			self:CancelScheduledEvent("BigWigsSummitTimersDM90")
			self:CancelScheduledEvent("BigWigsSummitTimersDM60")
			self:CancelScheduledEvent("BigWigsSummitTimersDM30")

			local wtime = waveTimes[wave]
			if wave == 8 then
				local msg = L["%s in ~%d sec"]
				self:ScheduleEvent("BigWigsSummitTimersDM90", "BigWigs_Message", wtime - 90, fmt(msg, nextBoss, 90), "Urgent")
				self:ScheduleEvent("BigWigsSummitTimersDM60", "BigWigs_Message", wtime - 60, fmt(msg, nextBoss, 60), "Urgent")
				self:ScheduleEvent("BigWigsSummitTimersDM30", "BigWigs_Message", wtime - 30, fmt(msg, nextBoss, 30), "Urgent")
				self:Bar(fmt(L["~%s spawn."], nextBoss), wtime)
			else
				local msg = L["Wave %d in ~%d sec"]
				self:ScheduleEvent("BigWigsSummitTimersDM90", "BigWigs_Message", wtime - 90, fmt(msg, wave + 1, 90), "Urgent")
				self:ScheduleEvent("BigWigsSummitTimersDM60", "BigWigs_Message", wtime - 60, fmt(msg, wave + 1, 60), "Urgent")
				self:ScheduleEvent("BigWigsSummitTimersDM30", "BigWigs_Message", wtime - 30, fmt(msg, wave + 1, 30), "Urgent")
				self:Bar(fmt(L["~Wave %d spawn."], wave + 1), wtime)
			end
		end
	elseif sync == "SummitReset" then
		self:TriggerEvent("BigWigs_RebootModule", self)
	elseif sync == "SummitClear" then
		--not sure how to cancel bars since they have different names
		self:TriggerEvent("BigWigs_StopBar", self, fmt(L["~%s spawn."], nextBoss))
		self:TriggerEvent("BigWigs_StopBar", self, fmt(L["~Wave %d spawn."], currentWave + 1))
		currentWave = 0
		self:CancelScheduledEvent("BigWigsSummitTimersDM90")
		self:CancelScheduledEvent("BigWigsSummitTimersDM60")
		self:CancelScheduledEvent("BigWigsSummitTimersDM30")
	end
end

