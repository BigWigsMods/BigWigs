--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Nalak", 928, 814)
if not mod then return end
mod:RegisterEnableMob(69099)
mod.otherMenu = 862
mod.worldBoss = 69099

--------------------------------------------------------------------------------
-- Locals
--

local openedForMe = nil
local stormcloudTargets = {}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.engage_yell = "Can you feel a chill wind blow? The storm is coming..."

	L.ability = "Next ability"
	L.ability_desc = "Cooldown timer for the next ability."
	L.ability_icon = "spell_nature_lightning" -- generic lightning icon
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return { 136338, {136339, "FLASH"}, {136340, "PROXIMITY", "SAY"}, "ability", "bosskill" }
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "ArcNova", 136338)
	self:Log("SPELL_AURA_APPLIED", "LightningTether", 136339)
	self:Log("SPELL_AURA_APPLIED", "StormcloudApplied", 136340)
	self:Log("SPELL_AURA_REMOVED", "StormcloudRemoved", 136340)
	self:Log("SPELL_DAMAGE", "StormcloudDamage", 136345)
	self:Log("SPELL_MISSED", "StormcloudDamage", 136345)

	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:Death("Win", 69099)
end

function mod:OnEngage()
	self:CDBar("ability", 10, L["ability"], L.ability_icon)
	openedForMe = nil
	wipe(stormcloudTargets)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:ArcNova(args)
	self:Message(args.spellId, "Important", "Alarm")
	self:Bar(args.spellId, 3, CL["cast"]:format(args.spellName))
	self:CDBar("ability", 10, L["ability"], L.ability_icon)
end

function mod:LightningTether(args)
	self:CDBar("ability", 10, L["ability"], L.ability_icon)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "Personal", "Alert", CL["you"]:format(args.spellName))
		self:Bar(args.spellId, 15, CL["you"]:format(args.spellName))
		self:Flash(args.spellId)
	end
end

do
	local scheduled = nil
	local function warnStormcloud(spellId)
		mod:CDBar("ability", 10, L["ability"], L.ability_icon)
		if not openedForMe then
			mod:Message(spellId, "Attention")
			if #stormcloudTargets > 0 then
				mod:OpenProximity(spellId, 10, stormcloudTargets)
			end
		end
		scheduled = nil
	end

	function mod:StormcloudApplied(args)
		if UnitExists(args.destName) then -- player is in your group
			stormcloudTargets[#stormcloudTargets+1] = args.destName
		end
		if self:Me(args.destGUID) then
			self:Message(args.spellId, "Personal", "Alert", CL["you"]:format(args.spellName))
			self:Say(args.spellId)
			self:OpenProximity(args.spellId, 10)
			openedForMe = true
		end
		if not scheduled then
			scheduled = self:ScheduleTimer(warnStormcloud, 0.2, args.spellId)
		end
	end

	function mod:StormcloudRemoved(args)
		if self:Me(args.destGUID) then
			openedForMe = nil
		end
		for i, player in next, stormcloudTargets do
			if player == args.destName then
				tremove(stormcloudTargets, i)
				break
			end
		end
		if #stormcloudTargets == 0 then
			self:CloseProximity(args.spellId)
		elseif not openedForMe then
			self:OpenProximity(args.spellId, 10, stormcloudTargets)
		end
	end
end

do
	local prev = 0
	function mod:StormcloudDamage(args)
		if self:Me(args.destGUID) then
			local t = GetTime()
			if t-prev > 2 and not UnitDebuff("player", args.spellName) then
				self:Message(136340, "Personal", "Info", CL["underyou"]:format(args.spellName))
				prev = t
			end
		end
	end
end

