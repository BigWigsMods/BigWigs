--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Valinor", -1533, 2430)
if not mod then return end
mod:RegisterEnableMob(167524)
mod.otherMenu = -1647
mod.worldBoss = 167524

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		327274, -- Unleashed Anima
		327246, -- Anima Charge
		327280, -- Recharge Anima
		{327262, "ICON", "ME_ONLY_EMPHASIZE"}, -- Charged Anima Blast
		{327255, "TANK"}, -- Mark of Penitence
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("BOSS_KILL")

	self:Log("SPELL_CAST_START", "UnleashedAnima", 327274)
	self:Log("SPELL_CAST_START", "AnimaCharge", 327246)
	self:Log("SPELL_CAST_SUCCESS", "RechargeAnima", 327280)
	self:Log("SPELL_CAST_START", "ChargedAnimaBlast", 327262)
	self:Log("SPELL_CAST_SUCCESS", "ChargedAnimaBlastSuccess", 327262)
	self:Log("SPELL_AURA_APPLIED", "MarkOfPenitence", 327255)
	self:Log("SPELL_AURA_APPLIED_DOSE", "MarkOfPenitence", 327255)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:BOSS_KILL(_, id)
	if id == 2411 then
		self:Win()
	end
end

function mod:UnleashedAnima(args)
	self:Message(args.spellId, "yellow", CL.incoming:format(args.spellName))
	self:PlaySound(args.spellId, "warning")
	self:CastBar(args.spellId, 5) -- 2s cast + 3s channel
end

function mod:AnimaCharge(args)
	self:Message(args.spellId, "red", CL.incoming:format(args.spellName))
	self:PlaySound(args.spellId, "alert")
end

function mod:RechargeAnima(args)
	self:Message(args.spellId, "cyan", CL.percent:format(50, args.spellName))
	self:CastBar(args.spellId, 30)
	self:PlaySound(args.spellId, "long")
	self:StopBar(327262) -- Charged Anima Blast
end

function mod:ChargedAnimaBlast(args)
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
	self:RegisterEvent("UNIT_TARGET")
	self:CastBar(args.spellId, 4)
	self:CDBar(args.spellId, 35)
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(event, _, _, _, _, target) -- Fallback check
	self:UnregisterEvent(event)
	self:UnregisterEvent("UNIT_TARGET")
	self:TargetMessage(327262, "orange", target)
	local guid = self:UnitGUID(target)
	if self:Me(guid) then
		self:PlaySound(327262, "alarm")
	end
end

function mod:UNIT_TARGET(event, unit) -- Primary target check
	local sourceGUID = self:UnitGUID(unit)
	local mobId = self:MobId(sourceGUID)
	if mobId == 167524 then -- Valinor
		self:UnregisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
		self:UnregisterEvent(event)

		local id = unit.."target"
		local guid = self:UnitGUID(id)
		local name = self:UnitName(id)
		self:TargetMessage(327262, "orange", name)
		self:PrimaryIcon(327262, name)
		if self:Me(guid) then
			self:PlaySound(327262, "alarm")
		end
	end
end

function mod:ChargedAnimaBlastSuccess(args)
	self:UnregisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
	self:UnregisterEvent("UNIT_TARGET")
	self:PrimaryIcon(args.spellId)
end

function mod:MarkOfPenitence(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, args.destName, amount, "purple") -- Mostly a pointless warning?
end
