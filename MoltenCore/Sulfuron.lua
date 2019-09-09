
--------------------------------------------------------------------------------
-- Module declaration
--

local mod = BigWigs:NewBoss("Sulfuron Harbinger", 409)
if not mod then return end
mod:RegisterEnableMob(12098)
mod.engageId = 669

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		19779, -- Inspire
		19775, -- Dark Mending
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "SulfuronHeal", self:SpellName(19775))
	self:Log("SPELL_CAST_SUCCESS", "Inspire", self:SpellName(19779))

	self:Death("Win", 12098)
 end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Inspire(args)
	self:Bar(19779, 10)
	self:Message(19779, "yellow")
end

do
	local prev = 0
	function mod:SulfuronHeal(args)
		local t = GetTime()
		if t - prev > 1 then
			prev = t
			self:Bar(19775, 2)
			self:Message(19775, "red")
		end
	end
end
