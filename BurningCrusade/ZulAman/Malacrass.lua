-------------------------------------------------------------------------------
--  Module Declaration
--

local mod, CL = BigWigs:NewBoss("Hex Lord Malacrass", 568, 190)
if not mod then return end
mod:RegisterEnableMob(24239)
mod:SetEncounterID(1193) -- it works, but... it returns status 0 on a kill triggering the respawn timer
mod:SetRespawnTime(30)

--------------------------------------------------------------------------------
--  Locals
--

local concCount = 1

-------------------------------------------------------------------------------
--  Initialization
--

function mod:GetOptions()
	return {
		43436, -- Fire Nova Totem
		43429, -- Consecration
		43383, -- Spirit Bolts
		43501, -- Siphon Soul
		43421, -- Lifebloom
		43548, -- Healing Wave
		43451, -- Holy Light
		43431, -- Flash Heal
	}, {
		[43436] = "general",
		[43421] = 43501, -- Siphon Soul
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_SUCCESS", "SpiritBolts", 43383)
	self:Log("SPELL_AURA_APPLIED", "SoulSiphon", 43501)
	self:Log("SPELL_CAST_START", "HealingCasts", 43548, 43451, 43431) -- Healing Wave, Holy Light, Flash Heal
	self:Log("SPELL_AURA_APPLIED", "Lifebloom", 43421)
	self:Log("SPELL_SUMMON", "FireNovaTotem", 43436)
	self:Log("SPELL_CAST_SUCCESS", "Consecration", 43429)

	self:Death("Win", 24239)
end

function mod:OnEngage()
	concCount = 1
	self:CDBar(43383, 30) -- Spirit Bolts
end

-------------------------------------------------------------------------------
--  Event Handlers
--

function mod:SpiritBolts(args)
	self:MessageOld(args.spellId, "red")
	self:CDBar(args.spellId, 40)
end

function mod:SoulSiphon(args)
	self:TargetMessageOld(args.spellId, args.destName, "yellow")
	self:CDBar(args.spellId, 60)
end

function mod:HealingCasts(args)
	self:MessageOld(args.spellId, "orange", "alarm", CL.casting:format(args.spellName))
end

function mod:Lifebloom(args)
	self:TargetMessageOld(args.spellId, args.destName, "orange", "alarm", nil, nil, self:Dispeller("magic", true))
end

function mod:FireNovaTotem(args)
	self:MessageOld(args.spellId, "yellow", "alert")
end

function mod:Consecration(args)
	self:MessageOld(args.spellId, "red", "info", CL.count:format(args.spellName, concCount))
	concCount = concCount + 1
	self:Bar(args.spellId, 20, CL.count:format(args.spellName, concCount))
end
