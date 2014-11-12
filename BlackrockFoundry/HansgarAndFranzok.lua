
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Hans'gar and Franzok", 988, 1155)
if not mod then return end
mod:RegisterEnableMob(76973, 76974) -- Hans'gar, Franzok
mod.engageId = 1693

--------------------------------------------------------------------------------
-- Locals
--



--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then

end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		160838, {153470, "HEALER"}, {158166, "HEALER"}, 156938, 157139, {155818, "FLASH"}, "bosskill"
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Log("SPELL_CAST_START", "CripplingSuplex", 156938)
	self:Log("SPELL_AURA_APPLIED", "ShatteredVertebrae", 157139)
	self:Log("SPELL_AURA_APPLIED_DOSE", "ShatteredVertebrae", 157139)
	-- Franzok
	self:Log("SPELL_CAST_START", "DisruptingRoar", 160838, 160845, 160847, 160848)
	self:Log("SPELL_CAST_START", "Skullcracker", 153470)
	-- Hans'gar
	self:Log("SPELL_CAST_START", "RupturedEardrums", 158166)
	-- Environmental Threats
	self:Log("SPELL_PERIODIC_DAMAGE", "ScorchingBurnsDamage", 155818)
	self:Log("SPELL_PERIODIC_MISSED", "ScorchingBurnsDamage", 155818)
	-- not sure how these work, it's not exactly rage based.. or maybe it is but is delayed
	--   Searing Plates 161570 18-32ish & 78-87ish
	--   Stamping Presses 158139 48-62ish & 87+ with both bosses down
	--   Smart Stampers 162124 (Mythic)

	self:Death("Deaths", 76973, 76974)
end

function mod:OnEngage()
	self:CDBar(160838, 45) -- Disrupting Roar
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:CripplingSuplex(args)
	self:Message(args.spellId, "Urgent", self:Tank() and "Warning" or "Alarm")
	self:Bar(157139, 8) -- Shattered Vertebrae
end

function mod:ShatteredVertebrae(args)
	if self:Tank(args.destName) then
		local amount = args.amount or 1
		if (self:Tank() or self:Healer()) and amount > 2 then
			self:StackMessage(args.spellId, args.destName, args.amount, "Attention")
		end
	elseif self:Me(args.destGUID) then
		self:Message(args.spellId, "Personal", "Alarm", CL.you:format(args.spellName))
	end
end

function mod:DisruptingRoar(args)
	local caster = self:Healer() or self:Damager() == "RANGED"
	self:Message(args.spellId, "Urgent", caster and "Alert")
	self:CDBar(args.spellId, 46)
end

function mod:Skullcracker(args)
	self:Message(args.spellId, "Attention") -- 21-26
end

function mod:RupturedEardrums(args)
	self:Message(args.spellId, "Attention", "Alert") -- lasts 20s
end

do
	local prev = 0
	function mod:ScorchingBurnsDamage(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 2 then
			self:Message(args.spellId, "Personal", "Alarm", CL.you:format(args.spellName))
			self:Flash(args.spellId)
			prev = t
		end
	end
end

