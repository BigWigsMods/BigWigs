--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("The Iron Council", "Ulduar")
if not mod then return end
-- steelbreaker = 32867, molgeim = 32927, brundir = 32857
mod:RegisterEnableMob(32867, 32927, 32857)
mod.toggleOptions = {61869, 63483, {61887, "WHISPER", "ICON", "FLASHSHAKE"}, 61903, {64637, "WHISPER", "ICON", "FLASHSHAKE"}, "proximity", 62274, 61974, {62269, "FLASHSHAKE"}, 62273, "berserk", "bosskill" }

mod.optionHeaders = {
	[61869] = "Stormcaller Brundir",
	[61903] = "Steelbreaker",
	[62274] = "Runemaster Molgeim",
	berserk = "general",
}

--------------------------------------------------------------------------------
-- Locals
--

local previous = nil
local deaths = 0
local overwhelmTime = 35
local tendrilscanner = nil

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.engage_trigger1 = "You will not defeat the Assembly of Iron so easily, invaders!"
	L.engage_trigger2 = "Nothing short of total decimation will suffice."
	L.engage_trigger3 = "Whether the world's greatest gnats or the world's greatest heroes, you are still only mortal."

	L.overload_message = "Overload in 6sec!"
	L.death_message = "Rune of Death on YOU!"
	L.summoning_message = "Elementals Incoming!"

	L.chased_other = "%s is being chased!"
	L.chased_you = "YOU are being chased!"

	L.overwhelm_other = "Overwhelming Power: %s"

	L.shield_message = "Rune shield!"

	L.council_dies = "%s dead"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "Punch", 61903, 63493) -- Steelbreaker
	self:Log("SPELL_AURA_APPLIED", "Overwhelm", 64637, 61888) -- Steelbreaker +2
	self:Log("SPELL_AURA_REMOVED", "OverRemove", 64637, 61888)

	self:Log("SPELL_AURA_APPLIED", "Shield", 62274, 63489) -- Molgeim
	self:Log("SPELL_CAST_SUCCESS", "RunePower", 61974) -- Molgeim
	self:Log("SPELL_CAST_SUCCESS", "RuneDeathCD", 62269, 63490) -- Molgeim +1
	self:Log("SPELL_AURA_APPLIED", "RuneDeath", 62269, 63490) -- Molgeim +1
	self:Log("SPELL_CAST_START", "RuneSummoning", 62273) -- Molgeim +2

	self:Log("SPELL_CAST_SUCCESS", "Overload", 61869, 63481) -- Brundir
	self:Log("SPELL_CAST_SUCCESS", "Whirl", 63483, 61915) -- Brundir +1
	self:Log("SPELL_AURA_APPLIED", "Tendrils", 61887, 63486) -- Brundir +2
	self:Log("SPELL_AURA_REMOVED", "TendrilsRemoved", 61887, 63486) -- Brundir +2

	self:Death("Deaths", 32867, 32927, 32857)
	self:Yell("Engage", L["engage_trigger1"], L["engage_trigger2"], L["engage_trigger3"])
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
end

function mod:OnEngage(diff)
	previous = nil
	deaths = 0
	overwhelmTime = diff == 1 and 60 or 35
	self:Berserk(900)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Punch(_, spellId, _, _, spellName)
	self:Message(61903, spellName, "Urgent", spellId)
end

function mod:Overwhelm(player, spellId, _, _, spellName)
	if UnitIsUnit(player, "player") then
		self:OpenProximity(15)
		self:FlashShake(64637)
	end
	self:TargetMessage(64637, spellName, player, "Personal", spellId, "Alert")
	self:Whisper(64637, player, spellName)
	self:Bar(64637, L["overwhelm_other"]:format(player), overwhelmTime, spellId)
	self:PrimaryIcon(64637, player)
end

function mod:OverRemove(player)
	if UnitIsUnit(player, "player") then
		self:CloseProximity()
	end
	self:SendMessage("BigWigs_StopBar", self, L["overwhelm_other"]:format(player))
end

function mod:Shield(_, spellId, _, _, _, _, _, _, _, dGUID)
	local target = tonumber(dGUID:sub(-12, -7), 16)
	if target and target == 32927 then
		self:Message(62274, L["shield_message"], "Attention", spellId)
	end
end

function mod:RunePower(_, spellId, _, _, spellName)
	self:Message(61974, spellName, "Positive", spellId)
	self:Bar(61974, spellName, 30, spellId)
end

function mod:RuneDeathCD(_, spellId, _, _, spellName)
	self:Bar(62269, spellName, 30, spellId)
end

function mod:RuneDeath(player, spellId)
	if UnitIsUnit(player, "player") then
		self:LocalMessage(62269, L["death_message"], "Personal", spellId, "Alarm")
		self:FlashShake(62269)
	end
end

function mod:RuneSummoning(_, spellId)
	self:Message(62273, L["summoning_message"], "Attention", spellId)
end

function mod:Overload(_, spellId, _, _, spellName)
	self:Message(61869, L["overload_message"], "Attention", spellId, "Long")
	self:Bar(61869, spellName, 6, spellId)
end

function mod:Whirl(_, spellId, _, _, spellName)
	self:Message(63483, spellName, "Attention", spellId)
end

local function targetCheck()
	local bossId = mod:GetUnitIdByGUID(32857)
	if not bossId then return end
	local target = UnitName(bossId .. "target")
	if target ~= previous then
		if target then
			if UnitIsUnit(target, "player") then
				mod:LocalMessage(61887, L["chased_you"], "Personal", nil, "Alarm")
				mod:FlashShake(61887)
			else
				mod:Message(61887, L["chased_other"]:format(target), "Attention")
				mod:Whisper(61887, target, L["chased_you"])
			end
			mod:PrimaryIcon(61887, target)
			previous = target
		else
			previous = nil
		end
	end
end

function mod:TendrilsRemoved()
	self:CancelTimer(tendrilscanner)
	tendrilscanner = nil
	self:PrimaryIcon(61887, false)
end

do
	local last = nil
	function mod:Tendrils(_, spellId, _, _, spellName)
		local t = GetTime()
		if not last or (t > last + 2) then
			self:Message(61887, spellName, "Attention", spellId)
			self:Bar(61887, spellName, 25, spellId)
			if not tendrilscanner then
				tendrilscanner = self:ScheduleRepeatingTimer(targetCheck, 0.2)
			end
		end
	end
end

function mod:Deaths(_, _, unitName)
	deaths = deaths + 1
	if deaths < 3 then
		self:Message("bosskill", L["council_dies"]:format(unitName), "Positive")
	else
		self:Win()
	end
end

