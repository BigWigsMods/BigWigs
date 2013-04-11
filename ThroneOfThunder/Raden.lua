--[[
TODO:
	fix timers, need longer logs
	use boss power to update the tank ability bars maybe
	restrict tank abilities with option key flag once sure that timers are accurate
	make intelligent proximity warnings
]]--
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Ra-den", 930, 831)
if not mod then return end
mod:RegisterEnableMob(69473)

--------------------------------------------------------------------------------
-- Locals
--

local animaCounter = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.vita_abilities = "Vita abilities"
	L.anima_abilities = "Anima abilities"
	L.worm = "Worm"
	L.worm_desc = "Summon worm"
	L.worm_icon = 138338
	L.balls = "Balls"
	L.balls_desc = "Anima (red) and Vita (blue) balls, that determine which abilities will Ra-den gain"
	L.balls_icon = 138321
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"worm", 138333, {138288, "FLASH", "ICON"},
		138339, 138334, {138297, "FLASH", "ICON"}, {138372, "FLASH"},
		"balls", "berserk", "bosskill",
	}, {
		["worm"] = L.anima_abilities,
		[138339] = L.vita_abilities,
		["balls"] = "general",
	}
end

function mod:OnBossEnable()
	-- Anima abilities
	self:Log("SPELL_CAST_START", "Worm", 138338)
	self:Log("SPELL_CAST_SUCCESS", "MurderousStrike", 138333)
	self:Log("SPELL_AURA_APPLIED", "UnstableAnima", 138288)
	self:Log("SPELL_DAMAGE", "UnstableAnimaRepeatedDamage", 138295)
	-- Vita abilities
	self:Log("SPELL_CAST_START", "CracklingStalker", 138339)
	self:Log("SPELL_CAST_SUCCESS", "FatalStrike", 138334)
	self:Log("SPELL_AURA_APPLIED", "UnstableVita", 138297, 138308) -- initial cast, jumps
	self:Log("SPELL_AURA_APPLIED", "VitaSensitivity", 138372)
	-- General
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")
	self:Log("SPELL_AURA_APPLIED", "Anima", 138331) -- on boss to start/stop timers
	self:Log("SPELL_AURA_APPLIED", "Vita", 138332)  -- on boss to start/stop timers
	self:Log("SPELL_CAST_START", "Balls", 138321)
	self:Death("Win", 69473) -- XXX this is probably not the proper win event
end

function mod:OnEngage()
	self:Bar("balls", 2, L["balls"], 138321)
	self:Berserk(600) -- XXX assumed
	animaCounter = 1
end

--------------------------------------------------------------------------------
-- Event Handlers
--

----------------------------------------
-- Anima Abilities
--

function mod:Anima(args)
	self:StopBar(138339) -- Crackling Stalker
	self:StopBar(138334) -- Fatal Strike
	self:StopBar(138297) -- Unstable Vita
	self:Bar("worm", 8, L["worm"], 138338)
	self:Bar(138333, 35) -- Murderous Strike
end

do
	local prev = 0
	function mod:UnstableAnimaRepeatedDamage(args)
		local t = GetTime()
		if t-prev > 1 then
			prev = t
			self:Message(138288, "Attention", nil, CL["count"]:format(args.spellName, animaCounter))
			animaCounter = animaCounter + 1
			self:Bar(138288, 15, CL["count"]:format(args.spellName, animaCounter))
		end
	end
end

function mod:UnstableAnima(args)
	if self:Me(args.destGUID) then
		self:Flash(args.spellId)
	end
	self:SecondaryIcon(args.spellId, args.destName) -- XXX should not conflict, but to be safe for now just use different for this
	self:TargetMessage(args.spellId, args.destName, "Attention")
	animaCounter = animaCounter + 1
	self:Bar(args.spellId, 15, CL["count"]:format(args.spellName, animaCounter))
end

function mod:Worm(args)
	self:Message("worm", "Urgent", nil, L["worm"], args.spellId)
end

function mod:MurderousStrike(args)
	self:Message(args.spellId, "Attention")
	self:Bar(args.spellId, 35)
end

----------------------------------------
-- Vita abilities
--

function mod:Vita(args)
	self:StopBar(CL["count"]:format(self:SpellName(138288), animaCounter)) -- Unstable Anima
	self:StopBar(L["worm"]) -- Worm
	self:StopBar(138333) -- Murderous Strike
	self:Bar(138339, 8) -- Summon Craclking Stalker -- XXX shorten maybe?
	self:CDBar(138334, 10) -- Fatal Strike
end

function mod:CracklingStalker(args)
	self:Message(args.spellId, "Attention")
	self:Bar(args.spellId, 60)
end

function mod:VitaSensitivity(args)
	if self:Me(args.destGUID) then
		self:Flash(args.spellId)
		self:Message(args.spellId, "Personal", "Info")
	end
end

function mod:UnstableVita(args)
	if self:Me(args.destGUID) then
		self:Flash(args.spellId)
	end
	self:TargetMessage(args.spellId, args.destName, "Personal", "Info") -- XXX might be too spammy? leave it in for now people can just tick "Only on me"
	self:Bar(args.spellId, 5)
	self:PrimaryIcon(args.spellId, args.destName)
end

function mod:FatalStrike(args)
	self:TargetMessage(args.spellId, args.destName, "Neutral")
	self:CDBar(args.spellId, 10)
end

----------------------------------------
-- General
--

function mod:Balls(args)
	self:Message("balls", "Important", "Warning", L["balls"], args.spellId)
	self:Bar("balls", 33, L["balls"], args.spellId)
end

