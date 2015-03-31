
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Tarlna the Ageless", 949, 1211)
if not mod then return end
mod:RegisterEnableMob(81535)
mod.otherMenu = 962
mod.worldBoss = 81535

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		175973, -- Colossal Blow
		175979, -- Genesis
		176013, -- Grow Untamed Mandragora
		{176001, "DISPEL"}, -- Savage Vines
		{176037, "FLASH"}, -- Noxious Spit
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "ColossalBlow", 175973)
	self:Log("SPELL_CAST_START", "Genesis", 175979, 169613)
	self:Log("SPELL_CAST_SUCCESS", "GrowMandragora", 176013)
	self:Log("SPELL_CAST_SUCCESS", "SavageVines", 176001)

	self:Log("SPELL_AURA_APPLIED", "NoxiousSpit", 176037)
	self:Log("SPELL_PERIODIC_DAMAGE", "NoxiousSpit", 176037)
	self:Log("SPELL_PERIODIC_MISSED", "NoxiousSpit", 176037)

	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:Death("Win", 81535)
end

function mod:OnEngage()
	self:CDBar(175979, 25)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:ColossalBlow(args)
	self:Message(args.spellId, "Important", "Alarm")
end

function mod:Genesis(args)
	self:Message(175979, "Attention", "Long")
	self:Bar(175979, 14, CL.cast:format(args.spellName)) -- 2 sec cast, 12 sec channel
	self:CDBar(175979, 45)
end

function mod:GrowMandragora(args)
	self:Message(args.spellId, "Urgent", nil, CL.spawning:format(CL.big_add))
end

function mod:SavageVines(args)
	if self:Dispeller("magic", nil, args.spellId) then
		self:Message(args.spellId, "Personal", "Alert")
	end
end

do
	local prev = 0
	function mod:NoxiousSpit(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 1.5 then
			prev = t
			self:Flash(args.spellId)
			self:Message(args.spellId, "Personal", "Alert", CL.underyou:format(args.spellName))
		end
	end
end

