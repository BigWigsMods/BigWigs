--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Nalak", 928, 814)
if not mod then return end
mod:RegisterEnableMob(69099)
mod.otherMenu = 6
mod.worldBoss = 69099

--------------------------------------------------------------------------------
-- Locals
--


--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.ability = "Next ability"
	L.ability_desc = "Cooldown timer for the next ability."
	L.ability_icon = "spell_nature_lightning" -- generic lightning icon
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		136338, {136339, "FLASH"}, {136340, "SAY"}, "ability", "proximity", "bosskill",
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "ArcNova", 136338)
	self:Log("SPELL_AURA_APPLIED", "LightningTether", 136339)
	self:Log("SPELL_CAST_START", "StormcloudCast", 136340)
	self:Log("SPELL_AURA_APPLIED", "Stormcloud", 136340)
	self:Log("SPELL_DAMAGE", "StormcloudDamage", 136345)
	self:Log("SPELL_MISSED", "StormcloudDamage", 136345)

	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:Death("Win", 69099)
end

function mod:OnEngage()
	self:CDBar("ability", 12, L["ability"], L.ability_icon) -- 12-22s, seems to go out in a random order then stay in that order
	self:OpenProximity("proximity", 10)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:ArcNova(args)
	self:Message(args.spellId, "Important", "Alarm")
	self:Bar(args.spellId, 3, CL["cast"]:format(args.spellName))
	self:CDBar("ability", 12, L["ability"], L.ability_icon)
end

do
	local targets, scheduled = mod:NewTargetList(), nil
	local function warnTether(spellId)
		mod:TargetMessage(spellId, targets, "Attention", "Alert")
		mod:CDBar("ability", 12, L["ability"], L.ability_icon)
		scheduled = nil
	end
	function mod:LightningTether(args)
		targets[#targets+1] = args.destName
		if self:Me(args.destGUID) then
			self:Bar(args.spellId, 15, CL["you"]:format(args.spellName))
			self:Flash(args.spellId)
			--maybe use CheckInteractDistance("target/focus/raid target scan", 4) (28yd check) and spam when you're too far away?
		end
		if not scheduled then
			scheduled = self:ScheduleTimer(warnTether, 0.2, args.spellId)
		end
	end
end

function mod:StormcloudCast(args)
	self:Message(args.spellId, "Attention", nil, CL["soon"]:format(args.spellName))
end

do
	local targets, scheduled = mod:NewTargetList(), nil
	local function warnStormcloud(spellId)
		mod:TargetMessage(spellId, targets, "Urgent", "Info") -- three targets
		mod:CDBar("ability", 12, L["ability"], L.ability_icon)
		scheduled = nil
	end
	function mod:Stormcloud(args)
		targets[#targets+1] = args.destName
		if self:Me(args.destGUID) then
			self:Say(args.spellId)
		end
		if not scheduled then
			scheduled = self:ScheduleTimer(warnStormcloud, 0.2, args.spellId)
		end
	end
end

do
	local prev = 0
	function mod:StormcloudDamage(args)
		if self:Me(args.destGUID) and not self:Me(args.sourceGUID) then
			local t = GetTime()
			if t-prev > 3 then
				self:Message(136340, "Personal", "Alarm", CL["under"]:format(args.spellName))
			end
		end
	end
end

