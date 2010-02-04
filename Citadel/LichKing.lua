--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("The Lich King", "Icecrown Citadel")
if not mod then return end
mod:RegisterEnableMob(36597)
mod.toggleOptions = {{72743, "SAY", "ICON", "WHISPER", "FLASHSHAKE"}, 70337, 69037, 68980, {74270, "FLASHSHAKE"}, {72262, "FLASHSHAKE"}, "proximity", "bosskill"}

--------------------------------------------------------------------------------
-- Locals
--

local phase = 0

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.warmup_trigger = "So the Light's vaunted justice has finally arrived"
	L.engage_trigger = "So be it. Champions. attack!"
	L.engage_bar = "Incoming!"

	L.defile_bar = "Defile"
	L.necroticplague_bar = "Necrotic Plague"
	L.valkyr_bar = "Next Val'kyr wave"
	L.valkyr_message = "Val'kyr"
	L.harvestsoul_message = "Harvest Soul"
	L.remorselesswinter_message = "Remorseless Winter Casting"
	L.quake_message = "Quake Casting"
	L.vilespirits_bar = "Vile Spirits"
	L.defile_say = "Defile on ME!"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--


function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "DefileCast", 72762)
	self:Log("SPELL_AURA_APPLIED", "Defile", 72743, 73708)
	self:Log("SPELL_CAST_SUCCESS", "NecroticPlague", 70337, 73912)
	self:Log("SPELL_SUMMON", "Valkyr", 69037)
	self:Log("SPELL_CAST_SUCCESS", "HarvestSoul", 68980)
	self:Log("SPELL_CAST_START", "RemorselessWinter", 74270)
	self:Log("SPELL_CAST_START", "Quake", 72262)

	self:Death("Win", 36597)

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:Yell("Warmup", L["warmup_trigger"])
	self:Yell("Engage", L["engage_trigger"])
end

function mod:Warmup(msg)
	if msg == L["warmup_trigger"] then
		self:Bar(69037, self.displayName, 47, "achievement_boss_lichking")
	end
end

function mod:OnEngage()
	print("Note that none of the timers in this bossfight have been verified by the Big Wigs team, so things might be a little off at this point. Nevertheless enjoy the fight!")
	self:OpenProximity(10)
	self:Bar(72743, L["necroticplague_bar"], 30, spellId)
	self:Bar(69037, L["engage_bar"], 4)
	phase = 1
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:NecroticPlague(player, spellId)
	self:Bar(73912, L["necroticplague_bar"], 30, spellId)
end

function mod:Defile(player, spellId)
	self:Bar(73708, L["defile_bar"], 30, spellId)
	self:PrimaryIcon(73708, player)
end

function mod:Valkyr(_, spellId)
	self:Bar(69037, L["valkyr_bar"], 48, spellId)
end

function mod:HarvestSoul(player, spellId)
	self:Bar(68980, L["harvestsoul_message"], 75, spellId)
	self:TargetMessage(68980, L["harvestsoul_message"], player, "Attention", 68980)
end

function mod:RemorselessWinter(_, spellId)
	phase = phase + 1
	self:LocalMessage(74270, L["remorselesswinter_message"], "Urgent", spellId, "Alert")
	self:Bar(72262, L["quake_message"], 60, spellId)
end

function mod:Quake(_, spellId)
	phase = phase + 1
	self:LocalMessage(72262, L["quake_message"], "Urgent", spellId, "Alert")
	self:Bar(73708, L["defile_bar"], 30, spellId)
	if phase == 2 then 
		self:Bar(69037, L["valkyr_bar"], 20, spellId)
	elseif phase == 4 then
		self:Bar(70498, L["vilespirits_bar"], 20, spellId)
	end
end

do
	local id, name, handle = nil, nil, nil
	local function scanTarget()
		local bossId = mod:GetUnitIdByGUID(36597)
		if not bossId then return end
		local target = UnitName(bossId .. "target")
		if target then
			if UnitIsUnit(target, "player") then
				mod:FlashShake(72743)
				if bit.band(mod.db.profile[(GetSpellInfo(72743))], BigWigs.C.SAY) == BigWigs.C.SAY then
					SendChatMessage(L["defile_say"], "SAY")
				end
			end
			mod:TargetMessage(72743, name, target, "Personal", id, "Alert")
			mod:Whisper(72743, target, name)
			mod:SecondaryIcon(72743, target)
		end
		handle = nil
	end

	function mod:DefileCast(player, spellId, _, _, spellName)
		id, name = spellId, spellName
		self:CancelTimer(handle, true)
		handle = self:ScheduleTimer(scanTarget, 0.1)
	end
end

