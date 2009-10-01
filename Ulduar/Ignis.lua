----------------------------------
--      Module Declaration      --
----------------------------------
local mod = BigWigs:NewBoss("Ignis the Furnace Master", "Ulduar")
if not mod then return end
mod:RegisterEnableMob(33118)
mod.toggleOptions = { 62488, 62382, 62680, {62546, "FLASHNSHAKE"}, {62717, "FLASHNSHAKE"}, "bosskill"}

------------------------------
--      Are you local?      --
------------------------------

local pName = UnitName("player")
local spawnTime = 30

----------------------------
--      Localization      --
----------------------------

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Ignis", "enUS", true)
if L then
	L.engage_trigger = "Insolent whelps! Your blood will temper the weapons used to reclaim this world!"

	L.construct_message = "Add incoming!"
	L.construct_bar = "Next add"
	L.brittle_message = "Construct is Brittle!"
	L.flame_bar = "~Jets cooldown"
	L.scorch_message = "Scorch on you!"
	L.scorch_soon = "Scorch in ~5sec!"
	L.scorch_bar = "Next Scorch"
	L.slagpot_message = "Slag Pot: %s"
end
L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Ignis")
mod.locale = L

------------------------------
--      Initialization      --
------------------------------

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "Construct", 62488)
	self:Log("SPELL_CAST_SUCCESS", "ScorchCast", 62546, 63474)
	self:Log("SPELL_CAST_START", "Jets", 62680, 63472)
	self:Log("SPELL_DAMAGE", "Scorch", 62548, 63475)
	self:Log("SPELL_AURA_APPLIED", "SlagPot", 62717, 63477)
	self:Log("SPELL_AURA_APPLIED", "Brittle", 62382)
	self:Death("Win", 33118)
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Brittle(_, spellId)
	self:IfMessage(62382, L["brittle_message"], "Positive", spellId)
end

function mod:Construct()
	self:IfMessage(62488, L["construct_message"], "Important", "Interface\\Icons\\INV_Misc_Statue_07")
	self:Bar(62488, L["construct_bar"], spawnTime, "INV_Misc_Statue_07")
end

function mod:ScorchCast(_, spellId, _, _, spellName)
	self:IfMessage(62546, spellName, "Attention", spellId)
	self:Bar(62546, L["scorch_bar"], 25, spellId)
	self:DelayedMessage(62546, 20, L["scorch_soon"], "Urgent", nil, nil, nil, spellId)
end

do
	local last = nil
	function mod:Scorch(player, spellId)
		if player == pName then
			local t = GetTime()
			if not last or (t > last + 4) then
				self:LocalMessage(62546, L["scorch_message"], "Personal", spellId, last and nil or "Alarm")
				last = t
			end
		end
	end
end

function mod:SlagPot(player, spellId, _, _, spellName)
	self:TargetMessage(62717, spellName, player, "Important", spellId)
	self:Bar(62717, L["slagpot_message"]:format(player), 10, spellId)
end

do
	local _, class = UnitClass("player")
	local function isCaster()
		local power = UnitPowerType("player")
		if power ~= 0 then return end
		if class == "PALADIN" then
			local _, _, points = GetTalentTabInfo(1)
			-- If a paladin has less than 20 points in Holy, he's not a caster.
			-- And so it shall forever be, said the Lord.
			if points < 20 then return end
		end
		return true
	end

	function mod:Jets(_, spellId, _, _, spellName)
		local caster = isCaster()
		local color = caster and "Personal" or "Attention"
		local sound = caster and "Long" or nil
		self:IfMessage(62680, spellName, color, spellId, sound)
		self:Bar(62680, L["flame_bar"], 25, spellId)
		if caster then self:Bar(62680, spellName, 2.7, spellId) end
	end
end

function mod:CHAT_MSG_MONSTER_YELL(event, msg)
	if msg == L["engage_trigger"] then
		spawnTime = GetRaidDifficulty() == 1 and 40 or 30
		self:Bar(62680, L["flame_bar"], 21, 62680)
		self:Bar(62488, L["construct_bar"], 10, "INV_Misc_Statue_07")
	end
end

