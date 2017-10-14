--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Imonar the Soulhunter", nil, 2009, 1712)
if not mod then return end
mod:RegisterEnableMob(124158)
mod.engageId = 2082
mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

local stage = 1
local empoweredSchrapnelBlastCount = 1
local timers = {
	--[[ Empowered Shrapnel Blast ]]--
	[248070] = {15.3, 22, 19.5, 18, 16, 16, 13.5, 10}, -- XXX Need more data to confirm
}
--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"stages",
		"berserk",

		--[[ Stage One: Attack Force ]]--
		{247367, "TANK"}, -- Shock Lance
		{254244, "SAY", "FLASH"}, -- Sleep Canister
		247376, -- Pulse Grenade

		--[[ Stage Two: Contract to Kill ]]--
		{247687, "TANK"}, -- Sever
		248254, -- Charged Blasts
		247923, -- Shrapnel Blast

		--[[ Stage Three: The Perfect Weapon ]]--
		{250255, "TANK"}, -- Empowered Shock Lance
		248068, -- Empowered Pulse Grenade
		248070, -- Empowered Shrapnel Blast

		--[[ Intermission: On Deadly Ground ]]--
		253302, -- Conflagration

	},{
		["stages"] = "general",
		[247367] = -16577, -- Stage One: Attack Force
		[247687] = -16206, -- Stage Two: Contract to Kill
		[250255] = -16208, -- Stage Three: The Perfect Weapon
		[253302] = -16205, -- Intermission: On Deadly Ground
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("RAID_BOSS_WHISPER")
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")
	self:Log("SPELL_AURA_REMOVED", "IntermissionOver", 248233, 250135) -- Conflagration: Intermission 1, Intermission 2

	--[[ Stage One: Attack Force ]]--
	self:Log("SPELL_AURA_APPLIED", "ShockLance", 247367)
	self:Log("SPELL_AURA_APPLIED_DOSE", "ShockLance", 247367)
	self:Log("SPELL_CAST_SUCCESS", "ShockLanceSuccess", 247367)
	self:Log("SPELL_CAST_SUCCESS", "SleepCanister", 254244)
	self:Log("SPELL_CAST_START", "PulseGrenade", 247376)

	--[[ Stage Two: Contract to Kill ]]--
	self:Log("SPELL_AURA_APPLIED", "Sever", 247687)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Sever", 247687)
	self:Log("SPELL_CAST_SUCCESS", "SeverSuccess", 247687)
	self:Log("SPELL_CAST_SUCCESS", "ChargedBlasts", 248254)
	self:Log("SPELL_CAST_START", "ShrapnelBlast", 247923)

	--[[ Stage Three: The Perfect Weapon ]]--
	self:Log("SPELL_AURA_APPLIED", "EmpoweredShockLance", 250255)
	self:Log("SPELL_AURA_APPLIED_DOSE", "EmpoweredShockLance", 250255)
	self:Log("SPELL_CAST_SUCCESS", "EmpoweredShockLanceSuccess", 250255)
	self:Log("SPELL_CAST_START", "EmpoweredPulseGrenade", 248068)
	self:Log("SPELL_CAST_START", "EmpoweredShrapnelBlast", 248070)

	--[[ Intermission: On Deadly Ground ]]--
end

function mod:OnEngage()
	stage = 1
	self:CDBar(247367, 4.5) -- Shock Lance
	self:CDBar(247552, 7.3) -- Sleep Canister
	self:CDBar(247376, 12.2) -- Pulse Grenade

	self:Berserk(420)
end

--------------------------------------------------------------------------------
-- Event Handlers
--
function mod:RAID_BOSS_WHISPER(_, msg)
	if msg:find("254244", nil, true) then -- Sleep Canister
		self:Message(254244, "Personal", "Alarm", CL.you:format(self:SpellName(254244)))
		self:Flash(254244)
		self:Say(254244)
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, _, spellId)
	if spellId == 248995 or spellId == 248194 then -- Jetpacks (Intermission 1), Jetpacks (Intermission 2)
		self:Message("stages", "Positive", "Long", CL.intermission, false)
		-- Stage 1 timers
		self:StopBar(247367) -- Shock Lance
		self:StopBar(254244) -- Sleep Canister
		self:StopBar(247376) -- Pulse Grenade
		-- Stage 2 timers
		self:StopBar(247687) -- Sever
		self:StopBar(248254) -- Charged Blast
		self:StopBar(247923) -- Shrapnel Blast
	end
end


function mod:IntermissionOver()
	stage = stage + 1
	self:Message("stages", "Positive", "Long", CL.stage:format(stage), false)
	if stage == 2 then
		self:CDBar(247687, 7.7) -- Sever
		self:CDBar(248254, 10.6) -- Charged Blast
		self:CDBar(247923, 12.8) -- Shrapnel Blast
	elseif stage == 3 then
		empoweredSchrapnelBlastCount = 1
		self:CDBar(250255, 4.3) -- Empowered Shock Lance
		self:CDBar(248068, 6.8) -- Empowered Pulse Grenade
		self:CDBar(248070, timers[248070][empoweredSchrapnelBlastCount]) -- Empowered Shrapnel Blast
	end
end

--[[ Stage One: Attack Force ]]--
function mod:ShockLance(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, args.destName, amount, "Important", amount > 6 and "Warning" or amount > 4 and "Alarm") -- Swap on 5, increase warning at 7
end

function mod:ShockLanceSuccess(args)
	self:Bar(args.spellId, 4.9)
end

function mod:SleepCanister(args)
	self:Message(args.spellId, "Important") -- Play sound only if targetted: See RAID_BOSS_WHISPER
	self:Bar(args.spellId, 10.9)
end

function mod:PulseGrenade(args)
	self:Message(args.spellId, "Attention", "Alert")
	self:Bar(args.spellId, 17.0)
end

--[[ Stage Two: Contract to Kill ]]--
function mod:Sever(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, args.destName, amount, "Important", amount > 3 and "Warning" or amount > 1 and "Alarm") -- Swap on 2
end

function mod:SeverSuccess(args)
	self:Bar(args.spellId, 7.3)
end

function mod:ChargedBlasts(args)
	self:Message(args.spellId, "Urgent", "Warning", CL.incoming:format(args.spellName))
	self:CastBar(args.spellId, 5.5)
	self:Bar(args.spellId, 18.2)
end

function mod:ShrapnelBlast(args)
	self:Message(args.spellId, "Attention", "Alert")
	self:Bar(args.spellId, 13.4)
end

--[[ Stage Three: The Perfect Weapon ]]--
function mod:EmpoweredShockLance(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, args.destName, amount, "Important", amount % 2 == 0 and "Alarm")
end

function mod:EmpoweredShockLanceSuccess(args)
	self:Bar(args.spellId, 9.7)
end

function mod:EmpoweredPulseGrenade(args)
	self:Message(args.spellId, "Attention", "Alert")
	self:Bar(args.spellId, 26.7)

end

function mod:EmpoweredShrapnelBlast(args)
	self:Message(args.spellId, "Urgent", "Warning")
	empoweredSchrapnelBlastCount = empoweredSchrapnelBlastCount + 1
	self:CDBar(args.spellId, timers[args.spellId][empoweredSchrapnelBlastCount])
end
