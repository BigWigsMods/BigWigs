--------------------------------------------------------------------------------
-- TODO List:
-- - Friendly Pod Warnings/Timers? Have to see how they work out in fight.

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Antoran High Command", nil, 1997, 1712)
if not mod then return end
mod:RegisterEnableMob(122367, 122369, 122333) -- Admiral Svirax, Chief Engineer Ishkar, General Erodus
mod.engageId = 2070
mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

local assumeCommandCount = 1
local incomingBoss = {
	[0] = mod:SpellName(-16100), -- Admiral Svirax
	[1] = mod:SpellName(-16116), -- Chief Engineer Ishkar
	[2] = mod:SpellName(-16118), -- General Erodus
}

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		--[[ In Pod: Admiral Svirax ]] --
		244625, -- Fusillade

		--[[ In Pod: Chief Engineer Ishkar ]] --
		245161, -- Entropic Mine

		--[[ In Pod: General Erodus ]] --
		245546, -- Summon Reinforcements
		246505, -- Pyroblast

		--[[ Out of Pod ]] --
		245227, -- Assume Command
		{244892, "TANK"}, -- Sundering Claws

		--[[ Stealing Power ]]--
		244910, -- Felshield

		--[[ Mythic ]]--
		244737, -- Shock Grenade
	},{
		[244625] = CL.other:format(mod:SpellName(-16099), mod:SpellName(-16100)), -- In Pod: Admiral Svirax
		[245161] = CL.other:format(mod:SpellName(-16099), mod:SpellName(-16116)), -- In Pod: Chief Engineer Ishkar
		[245546] = CL.other:format(mod:SpellName(-16099), mod:SpellName(-16118)), -- In Pod: General Erodus
		[245227] = mod:SpellName(-16098), -- Out of Pod
		[244910] = mod:SpellName(-16125), -- Stealing Power
		[244737] = "mythic",
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1", "boss2", "boss3")

	--[[ In Pod: Admiral Svirax ]] --
	self:Log("SPELL_CAST_START", "Fusillade", 244625)

	--[[ In Pod: General Erodus ]] --
	self:Log("SPELL_CAST_START", "Pyroblast", 246505)

	--[[ Out of Pod ]] --
	self:Log("SPELL_CAST_START", "AssumeCommand", 245227)
	self:Log("SPELL_CAST_SUCCESS", "SunderingClaws", 244892)
	self:Log("SPELL_AURA_APPLIED", "SunderingClawsApplied", 244892)
	self:Log("SPELL_AURA_APPLIED_DOSE", "SunderingClawsApplied", 244892)

	--[[ Stealing Power ]]--
	self:Log("SPELL_AURA_APPLIED", "Felshield", 244910)

	--[[ Mythic ]]--
	self:Log("SPELL_CAST_START", "ShockGrenadeStart", 244722)
	self:Log("SPELL_AURA_APPLIED", "ShockGrenade", 244737)
	self:Log("SPELL_AURA_REMOVED", "ShockGrenadeRemoved", 244737)

end

function mod:OnEngage()
	assumeCommandCount = 1

	self:Bar(244892, 8.4) -- Sundering Claws
	self:Bar(245227, 93, incomingBoss[assumeCommandCount]) -- Chief Engineer Ishkar (Assume Command Bar)
end

--------------------------------------------------------------------------------
-- Event Handlers
--
function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, _, spellId)
	if spellId == 245304 then -- Entropic Mines
		self:Message(245161, "Attention", "Alert")
		self:Bar(245161, 10)
	elseif spellId == 245546 then -- Summon Reinforcements
		self:Message(245546, "Neutral", "Info")
		self:Bar(245546, 35)
	end
end

function mod:AssumeCommand(args)
	self:Message(args.spellId, "Neutral", "Long", CL.incoming:format(incomingBoss[assumeCommandCount % 3]))

	if assumeCommandCount % 3 == 1 then -- Chief Engineer Ishkar
		self:StopBar(245161) -- Entropic Mines
		self:Bar(244625, 18.3) -- Fusillade
	elseif assumeCommandCount % 3 == 2 then -- General Erodus
		self:StopBar(245546) -- Summon Reinforcements
		self:Bar(245161, 11) -- Entropic Mines
	else -- Admiral Svirax
		self:StopBar(244625) -- Fusillade
		self:Bar(245546, 35) -- Summon Reinforcements
	end
	self:CDBar(244892, 13.5) -- Sundering Claws

	assumeCommandCount = assumeCommandCount + 1
	self:Bar(args.spellId, 93, incomingBoss[assumeCommandCount % 3])
end

function mod:SunderingClaws(args)
	self:Bar(args.spellId, 8.5)
end

function mod:SunderingClawsApplied(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, args.destName, amount, "Urgent", amount > 1 and "Warning") -- Swap on 2
end

function mod:Pyroblast(args)
	if self:Interrupter(args.sourceGUID) then
		self:Message(args.spellId, "Urgent", "Warning")
	end
end

function mod:Fusillade(args)
	self:Message(args.spellId, "Urgent", "Warning")
	self:CastBar(args.spellId, 5)
	self:CDBar(args.spellId, 30) -- ~29.8-33.2s
end


function mod:ShockGrenadeStart(args)
	self:Message(244737, "Attention", "Alert", CL.incoming:format(args.spellName))
	self:Bar(244737, 20)
end

function mod:ShockGrenade(args)
	if self:Me(args.destGUID) then
		self:Say(args.spellId)
		self:SayCountdown(args.spellId, 5)
		self:TargetMessage(args.spellId, args.destName, "Personal", "Alarm")
	end
end

function mod:ShockGrenadeRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
end

function mod:Felshield(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "Positive", "Info")
	end
end
