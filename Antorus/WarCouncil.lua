if not IsTestBuild() then return end -- XXX dont load on live
--------------------------------------------------------------------------------
-- TODO List:
-- - Friendly Pod Warnings/Timers? Have to see how they work out in fight.

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("War Council", nil, 1997, 1712)
if not mod then return end
mod:RegisterEnableMob(126258, 125012, 125014) -- Admiral Svirax, Chief Engineer Ishkar, General Erodus
mod.engageId = 2070
--mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--
local L = mod:GetLocale()
if L then
	L.pod_options = "%s: %s"
end
--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		--[[ In Pod: Admiral Svirax ]] --
		244625, -- Fusillade
		245292, -- Withering Fire

		--[[ In Pod: Chief Engineer Ishkar ]] --
		245161, -- Entropic Mine

		--[[ In Pod: General Erodus ]] --
		245546, -- Summon Reinforcements
		246505, -- Pyroblast
		253037, -- Demonic Charge

		--[[ Out of Pod: Admiral Svirax ]] --
		244737, -- Shock Grenade

		--[[ Out of Pod: Chief Engineer Ishkar ]] --
		244824, -- Warp Field

		--[[ Out of Pod: General Erodus ]] --
		244892, -- Sundering Claws

		--[[ Stealing Power ]]--
		244902, -- Felshield Emitter
	},{
		[244625] = L.pod_options:format(mod:SpellName(-16099), mod:SpellName(-16100)), -- In Pod: Admiral Svirax
		[245161] = L.pod_options:format(mod:SpellName(-16099), mod:SpellName(-16116)), -- In Pod: Chief Engineer Ishkar
		[245546] = L.pod_options:format(mod:SpellName(-16099), mod:SpellName(-16121)), -- In Pod: General Erodus
		[244737] = L.pod_options:format(mod:SpellName(-16098), mod:SpellName(-16100)), -- Out of Pod: Admiral Svirax
		[244824] = L.pod_options:format(mod:SpellName(-16098), mod:SpellName(-16116)), -- Out of Pod: Chief Engineer Ishkar
		[244892] = L.pod_options:format(mod:SpellName(-16098), mod:SpellName(-16121)), -- Out of Pod: General Erodus
		[244902] = mod:SpellName(-16125), -- Stealing Power
	}
end

function mod:OnBossEnable()
	--[[ In Pod: Admiral Svirax ]] --
	self:Log("SPELL_CAST_START", "Fusillade", 244625)
	self:Log("SPELL_CAST_SUCCESS", "WitheringFire", 245292)

	--[[ In Pod: Chief Engineer Ishkar ]] --
	self:Log("SPELL_CAST_SUCCESS", "EntropicMine", 245161)

	--[[ In Pod: General Erodus ]] --
	self:Log("SPELL_CAST_SUCCESS", "SummonReinforcements", 245546)
	self:Log("SPELL_CAST_START", "Pyroblast", 246505)
	self:Log("SPELL_CAST_SUCCESS", "DemonicCharge", 253037)

	--[[ Out of Pod: Admiral Svirax ]] --
	self:Log("SPELL_AURA_APPLIED", "ShockGrenade", 244737)
	self:Log("SPELL_AURA_REMOVED", "ShockGrenadeRemoved", 244737)

	--[[ Out of Pod: Chief Engineer Ishkar ]] --
	self:Log("SPELL_CAST_SUCCESS", "WarpField", 244824)

	--[[ Out of Pod: General Erodus ]] --
	self:Log("SPELL_CAST_SUCCESS", "SunderingClaws", 244892)
	self:Log("SPELL_AURA_APPLIED", "SunderingClawsApplied", 244892)

	--[[ Stealing Power ]]--
	self:Log("SPELL_CAST_SUCCESS", "FelshieldEmitter", 244902)
end

function mod:OnEngage()
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Fusillade(args)
	self:Message(args.spellId, "Urgent", "Warning")
	self:CastBar(args.spellId, 5)
end

function mod:WitheringFire(args)
	self:Message(args.spellId, "Attention", "Alert")
end

function mod:EntropicMine(args)
	self:Message(args.spellId, "Attention", "Alarm")
end

function mod:SummonReinforcements(args)
	self:Message(args.spellId, "Neutral", "Info")
end

function mod:Pyroblast(args)
	self:Message(args.spellId, "Urgent", "Warning")
end

function mod:DemonicCharge(args)
	self:Message(args.spellId, "Attention", "Alert")
end

do
	local playerList = mod:NewTargetList()
	function mod:ShockGrenade(args)
		if self:Me(args.destGUID) then
			self:Say(args.spellId)
			self:SayCountdown(args.spellId, 5)
		end
		playerList[#playerList+1] = args.destName
		if #playerList == 1 then
			self:ScheduleTimer("TargetMessage", 0.3, args.spellId, playerList, "Personal", "Warning")
		end
	end
end

function mod:ShockGrenadeRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
end

function mod:WarpField(args)
	self:Message(args.spellId, "Important", "Long")
end

function mod:SunderingClaws(args)
	self:Message(args.spellId, "Attention", "Alert")
end

function mod:SunderingClawsApplied(args)
	if self:Me(args.destGUID) then
		self:TargetMessage(args.spellId, args.destName, "Personal", "Alarm")
	end
end

function mod:FelshieldEmitter(args)
	self:Message(args.spellId, "Positive", "Info")
end
