if not IsTestBuild() then return end -- XXX dont load on live

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Imonar the Soulhunter", nil, 2009, 1712)
if not mod then return end
mod:RegisterEnableMob(125055, 124158, 125692) -- XXX Remove unused ID's
mod.engageId = 2082
--mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		--[[ Stage One: Attack Force ]]--
		{247367, "TANK"}, -- Shock Lance
		{247552, "SAY"}, -- Sleep Canister
		247376, -- Pulse Grenade

		--[[ Stage Two: Contract to Kill ]]--
		{247687, "TANK"}, -- Sever
		247716, -- Charged Blasts
		247923, -- Shrapnel Blast

		--[[ Stage Three: The Perfect Weapon ]]--
		{250255, "TANK"}, -- Empowered Shock Lance
		248068, -- Empowered Pulse Grenade
		248070, -- Empowered Shrapnel Blast

		--[[ Intermission: On Deadly Ground ]]--
		253302, -- Conflagration

	},{
		[247367] = -16577, -- Stage One: Attack Force
		[247687] = -16206, -- Stage Two: Contract to Kill
		[250255] = -16208, -- Stage Three: The Perfect Weapon
		[253302] = -16205, -- Intermission: On Deadly Ground
	}
end

function mod:OnBossEnable()
	--[[ Stage One: Attack Force ]]--
	self:Log("SPELL_AURA_APPLIED", "ShockLance", 247367)
	self:Log("SPELL_AURA_APPLIED_DOSE", "ShockLance", 247367)
	self:Log("SPELL_AURA_APPLIED", "SleepCanister", 247552, 254244) -- XXX Remove Unused id's
	self:Log("SPELL_CAST_START", "PulseGrenade", 247376)

	--[[ Stage Two: Contract to Kill ]]--
	self:Log("SPELL_AURA_APPLIED", "Sever", 247687)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Sever", 247687)
	self:Log("SPELL_CAST_SUCCESS", "ChargedBlasts", 247716)
	self:Log("SPELL_CAST_START", "ShrapnelBlast", 247923)

	--[[ Stage Three: The Perfect Weapon ]]--
	self:Log("SPELL_AURA_APPLIED", "EmpoweredShockLance", 250255)
	self:Log("SPELL_AURA_APPLIED_DOSE", "EmpoweredShockLance", 250255)
	self:Log("SPELL_CAST_START", "EmpoweredPulseGrenade", 248068)
	self:Log("SPELL_CAST_START", "EmpoweredShrapnelBlast", 248068)

	--[[ Intermission: On Deadly Ground ]]--
	self:Log("SPELL_CAST_SUCCESS", "Conflagration", 253302, 248321)
end

function mod:OnEngage()
end

--------------------------------------------------------------------------------
-- Event Handlers
--

--[[ Stage One: Attack Force ]]--
function mod:ShockLance(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, args.destName, amount, "Important", amount > 2 and "Alarm") -- Swap on 3
end

do
	local playerList = mod:NewTargetList()
	function mod:SleepCanister(args)
		if self:Me(args.destGUID) then
			self:Say(args.spellId)
		end
		playerList[#playerList+1] = args.destName
		if #playerList == 1 then
			self:ScheduleTimer("TargetMessage", 0.3, args.spellId, playerList, "Urgent", "Warning", nil, nil, true)
		end
	end
end

function mod:PulseGrenade(args)
	self:Message(args.spellId, "Attention", "Alert")
end

--[[ Stage Two: Contract to Kill ]]--
function mod:Sever(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, args.destName, amount, "Important", amount > 2 and "Alarm") -- Swap on 3
end

function mod:ChargedBlasts(args)
	self:Message(args.spellId, "Urgent", "Warning", CL.casting:format(args.spellName))
	self:CastBar(args.spellId, 5.5)
end

function mod:ShrapnelBlast(args)
	self:Message(args.spellId, "Attention", "Alert")
end

--[[ Stage Three: The Perfect Weapon ]]--
function mod:EmpoweredShockLance(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, args.destName, amount, "Important", "Alarm") -- They last until death, sound on every cast?
end

function mod:EmpoweredPulseGrenade(args)
	self:Message(args.spellId, "Attention", "Alert")
end

function mod:EmpoweredShrapnelBlast(args)
	self:Message(args.spellId, "Urgent", "Warning")
end

--[[ Intermission: On Deadly Ground ]]--
function mod:Conflagration(args)
	self:Message(args.spellId, "Neutral", "Long")
end