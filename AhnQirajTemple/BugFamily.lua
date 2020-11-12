
--------------------------------------------------------------------------------
-- Module declaration
--

local mod, CL = BigWigs:NewBoss("Silithid Royalty", 531)
if not mod then return end
mod:RegisterEnableMob(15543, 15544, 15511) -- Princess Yauj, Vem, Lord Kri
mod:SetAllowWin(true)
mod.engageId = 710

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.bossName = "Silithid Royalty"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		25807, -- Great Heal
		26580, -- Fear
		25812, -- Toxic Volley
		25786, -- Toxic Vapors
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "GreatHeal", 25807)
	self:Log("SPELL_CAST_SUCCESS", "Fear", 26580)
	self:Log("SPELL_CAST_SUCCESS", "ToxicVolley", 25812)

	self:Log("SPELL_PERIODIC_DAMAGE", "ToxicVaporsDamage", 25786)
	self:Log("SPELL_PERIODIC_MISSED", "ToxicVaporsDamage", 25786)
	self:Log("SPELL_AURA_APPLIED", "ToxicVaporsDamage", 25786)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:GreatHeal(args)
	self:Message(25807, "orange", CL.casting:format(args.spellName))
	self:CastBar(25807, 2)
end

function mod:Fear(args)
	self:Message(26580, "red")
	self:Bar(26580, 20)
	self:DelayedMessage(26580, 15, "orange", CL.custom_sec:format(args.spellName, 5))
end

function mod:ToxicVolley(args)
	self:Message(25812, "yellow")
end

do
	local prev = 0
	function mod:ToxicVaporsDamage(args)
		local t = GetTime()
		if t-prev > 2 and self:Me(args.destGUID) then
			prev = t
			self:Message(25786, "blue", CL.underyou:format(args.spellName))
			self:PlaySound(25786, "alarm")
		end
	end
end
