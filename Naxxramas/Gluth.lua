--------------------------------------------------------------------------------
-- Module declaration
--

local mod, CL = BigWigs:NewBoss("Gluth", 533)
if not mod then return end
mod:RegisterEnableMob(15932)
mod:SetAllowWin(true)
mod.engageId = 1108

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.bossName = "Gluth"

	L.startwarn = "Gluth engaged, ~105 sec to Decimate!"

	L.decimate = 28375 -- Decimate
	L.decimate_icon = "inv_shield_01"
	L.decimate_bar = "Decimate Zombies"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		28371, -- Frenzy
		29685, -- Terrifying Roar
		"decimate", -- Decimate
		"berserk",
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_SUCCESS", "Frenzy", 28371)
	self:Log("SPELL_CAST_SUCCESS", "Fear", 29685)
	self:Log("SPELL_DAMAGE", "Decimate", 28375)
	self:Log("SPELL_MISSED", "Decimate", 28375)
end

function mod:OnEngage(diff)
	self:Berserk(360, true)
	self:Message("berserk", "yellow", L.startwarn, false)
	self:CDBar("decimate", 105, L.decimate_bar, L.decimate_icon)
	self:DelayedMessage("decimate", 100, "orange", CL.soon:format(self:SpellName(28375)), L.decimate_icon)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Frenzy(args)
	self:Message(28371, "red")
	self:Bar(28371, 9.7)
end

function mod:Fear(args)
	self:Message(29685, "red")
	self:CDBar(29685, 21)
end

local prev = 0
function mod:Decimate(args)
	local t = GetTime()
	if t-prev > 5 then
		prev = t
		self:Message("decimate", "yellow", L.decimate, L.decimate_icon)
		self:PlaySound("decimate", "alert")
		self:CDBar("decimate", 105, L.decimate_bar, L.decimate_icon)
		self:DelayedMessage("decimate", 100, "orange", CL.soon:format(self:SpellName(28375)), L.decimate_icon, "alarm")
	end
end
