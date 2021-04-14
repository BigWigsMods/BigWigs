
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Reliquary of Souls", 564, 1587)
if not mod then return end
mod:RegisterEnableMob(23420, 23419, 23418) -- Essence of Anger, Essence of Desire, Essence of Suffering
mod.engageId = 606
mod.respawnTime = 11

--------------------------------------------------------------------------------
-- Locals
--

local playerList = mod:NewTargetList()
local castCollector = {}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.zero_mana = "Zero Mana"
	L.zero_mana_desc = "Show the time it will take until the Essence of Desire has reduced everyones maximum mana to 0."
	L.zero_mana_icon = "spell_shadow_manaburn"
	L.desire_start = "Essence of Desire - Zero Mana in 160 sec"

	L[-15665] = "Stage One: Essence of Suffering"
	L[-15673] = "Stage Two: Essence of Desire"
	L[-15681] = "Stage Three: Essence of Anger"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"stages",

		--[[ Essence of Suffering ]]--
		41303, -- Soul Drain
		41305, -- Frenzy
		{41294, "ICON"}, -- Fixate

		--[[ Essence of Desire ]]--
		41431, -- Rune Shield
		41410, -- Deaden
		"zero_mana",
		{41426, "TANK"}, -- Spirit Shock

		--[[ Essence of Anger ]]--
		41376, -- Spite
		41545, -- Soul Scream
	}, {
		[41303] = -15665, -- Stage One: Essence of Suffering
		[41431] = -15673, -- Stage Two: Essence of Desire
		[41376] = -15681, -- Stage Three: Essence of Anger
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	self:RegisterMessage("BigWigs_BossComm")

	--[[ Essence of Suffering ]]--
	self:Log("SPELL_CAST_SUCCESS", "AuraOfSuffering", 41292)
	self:Log("SPELL_CAST_SUCCESS", "SoulDrain", 41303)
	self:Log("SPELL_AURA_APPLIED", "SoulDrainApplied", 41303)
	self:Log("SPELL_AURA_APPLIED", "Frenzy", 41305)
	self:Log("SPELL_AURA_REMOVED", "FrenzyRemoved", 41305)
	self:Log("SPELL_AURA_APPLIED", "Fixate", 41294)

	--[[ Essence of Desire ]]--
	self:Log("SPELL_CAST_SUCCESS", "AuraOfDesire", 41350)
	self:Log("SPELL_CAST_SUCCESS", "RuneShield", 41431)
	self:Log("SPELL_CAST_START", "Deaden", 41410)
	self:Log("SPELL_AURA_APPLIED", "SpiritShock", 41426)

	--[[ Essence of Anger ]]--
	self:Log("SPELL_CAST_SUCCESS", "AuraOfAnger", 41337)
	self:Log("SPELL_CAST_SUCCESS", "Spite", 41376)
	self:Log("SPELL_AURA_APPLIED", "SpiteApplied", 41376)
	self:Log("SPELL_CAST_SUCCESS", "SoulScream", 41545)
end

function mod:OnEngage()
	playerList = self:NewTargetList()
	castCollector = {}
	self:CDBar(41305, 48) -- Frenzy
	self:CDBar(41303, 21.6) -- Soul Drain
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, castGUID, spellId)
	if spellId == 28819 then -- Submerge Visual
		if not next(castCollector) then -- Kill first
			castCollector[castGUID] = true
			self:Sync("Kill1")
		elseif not castCollector[castGUID] then -- Kill second
			castCollector[castGUID] = true
			self:Sync("Kill2")
		end
	end
end

do
	local times = {
		["Kill1"] = 0,
		["Kill2"] = 0,
	}
	function mod:BigWigs_BossComm(_, msg)
		if times[msg] then
			local t = GetTime()
			if t-times[msg] > 5 then
				times[msg] = t
				if msg == "Kill1" then
					self:PrimaryIcon(41294) -- Fixate
					self:StopBar(41305) -- Frenzy
					self:StopBar(41303) -- Soul Drain
					self:Bar("stages", 40, CL.intermission, 83601) -- spell_holy_borrowedtime / icon 237538
				elseif msg == "Kill2" then
					self:StopBar(41410) -- Deaden
					self:StopBar(41431) -- Rune Shield
					self:StopBar(L.zero_mana) -- Soul Drain
					self:Bar("stages", 40, CL.intermission, 83601) -- spell_holy_borrowedtime / icon 237538
				end
			end
		end
	end
end

--[[ Essence of Suffering ]]--
function mod:AuraOfSuffering() -- Start of Stage 1
	if not self.isEngaged then
		self:Engage()
	end
end

function mod:SoulDrain(args)
	self:Bar(args.spellId, 21.3)
end

function mod:SoulDrainApplied(args)
	playerList[#playerList+1] = args.destName
	if #playerList == 1 then
		self:ScheduleTimer("TargetMessageOld", 0.3, args.spellId, playerList, "yellow", "alert")
	end
end

function mod:Frenzy(args)
	self:MessageOld(args.spellId, "orange", "info")
	self:CastBar(args.spellId, 8)
end

function mod:FrenzyRemoved(args)
	self:MessageOld(args.spellId, "green", "info", CL.over:format(args.spellName))
	self:Bar(args.spellId, 40.5)
end

function mod:Fixate(args)
	self:TargetMessageOld(args.spellId, args.destName, "red", "warning")
	self:PrimaryIcon(args.spellId, args.destName)
end

--[[ Essence of Desire ]]--
function mod:AuraOfDesire() -- Start of Stage 2
	self:MessageOld("zero_mana", "cyan", nil, L.desire_start, L.zero_mana_icon)
	self:Bar("zero_mana", 160, L.zero_mana, L.zero_mana_icon)
	self:CDBar(41410, 27.6) -- Deaden
	self:CDBar(41431, 13) -- Rune Shield
end

function mod:RuneShield(args)
	self:MessageOld(args.spellId, "orange", self:Dispeller("magic", true) and "warning")
	self:Bar(args.spellId, 15.7)
end

function mod:Deaden(args)
	self:MessageOld(args.spellId, "red", self:Interrupter() and "info", CL.casting:format(args.spellName))
	self:Bar(args.spellId, 31.5)
end

function mod:SpiritShock(args)
	self:TargetMessageOld(args.spellId, args.destName, "yellow", "alarm", nil, nil, self:Tank())
end

--[[ Essence of Anger ]]--
function mod:AuraOfAnger() -- Start of Stage 3
	self:CDBar(41376, 18.2) -- Spite
	self:CDBar(41545, 8.5) -- Soul Scream
end

function mod:Spite(args)
	self:Bar(args.spellId, 20.5)
end

function mod:SpiteApplied(args)
	playerList[#playerList+1] = args.destName
	if #playerList == 1 then
		self:ScheduleTimer("TargetMessageOld", 0.3, args.spellId, playerList, "red", "alert")
	end
end

function mod:SoulScream(args)
	self:Bar(args.spellId, 10)
end
