
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Harjatan the Bludger", 1147, 1856)
if not mod then return end
mod:RegisterEnableMob(116407)
mod.engageId = 2036
mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

local rageCounter = 0
local roarCounter = 0
local skipDrawIn = true
local nextDrawIn = 0
local drawInCheck = nil

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.custom_on_fixate_plates = "Fixate icon on Enemy Nameplate"
	L.custom_on_fixate_plates_desc = "Show an icon on the target nameplate that is fixating on you.\nRequires the use of Enemy Nameplates. This feature is currently only supported by KuiNameplates."
	L.custom_on_fixate_plates_icon = 234128
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{231998, "TANK"}, -- Jagged Abrasion
		231854, -- Unchecked Rage
		232192, -- Commanding Roar
		232061, -- Draw In
		233429, -- Frigid Blows
		232174, -- Frosty Discharge
		{231729, "SAY", "FLASH"}, -- Aqueous Burst
		231768, -- Drenching Waters
		{234128, "SAY", "FLASH"}, -- Driven Assault
		"custom_on_fixate_plates",
		240319, -- Hatching
		{241600, "SAY", "FLASH"}, -- Sickly Fixate
		"berserk",
	},{
		[231998] = "general",
		[231729] = -14555,
		[234128] = -14722,
		[240319] = "mythic",
	}
end

function mod:OnBossEnable()
	-- General
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1", "boss2", "boss3", "boss4", "boss5")
	self:RegisterEvent("RAID_BOSS_WHISPER")

	self:Log("SPELL_AURA_APPLIED", "GroundEffectDamage", 231768) -- Drenching Waters
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundEffectDamage", 231768)
	self:Log("SPELL_PERIODIC_MISSED", "GroundEffectDamage", 231768)

	-- Boss
	self:Log("SPELL_AURA_APPLIED", "JaggedAbrasion", 231998)
	self:Log("SPELL_AURA_APPLIED_DOSE", "JaggedAbrasion", 231998)
	self:Log("SPELL_CAST_START", "UncheckedRage", 231854)
	self:Log("SPELL_AURA_APPLIED", "DrawIn", 232061)
	self:Log("SPELL_AURA_REMOVED_DOSE", "FrigidBlows", 233429)
	self:Log("SPELL_CAST_START", "FrostyDischarge", 232174)

	-- Adds
	self:Log("SPELL_AURA_APPLIED", "AqueousBurst", 231729)
	self:Log("SPELL_AURA_REMOVED", "AqueousBurstRemoved", 231729)
	self:Log("SPELL_AURA_APPLIED", "DrivenAssault", 234016)
	self:Log("SPELL_AURA_REMOVED", "DrivenAssaultRemoved", 234016)

	-- Mythic
	self:Log("SPELL_AURA_APPLIED", "SicklyFixate", 241600)
	self:Log("SPELL_AURA_REMOVED", "SicklyFixateRemoved", 241600)

	if self:GetOption("custom_on_fixate_plates") then
		self:ShowPlates()
	end
end

function mod:OnEngage()
	roarCounter = 1
	rageCounter = 1
	skipDrawIn = true -- True until you get Drenching Waters on the floor
	nextDrawIn = GetTime() + 58

	self:CDBar(232192, 17.5) -- Commanding Roar
	self:CDBar(231854, 20.7) -- Unchecked Rage
	self:CDBar(232061, 58) -- Draw In
	self:ScheduleTimer("drawInCheck", 58, self)
	if self:Mythic() then
		self:Bar(240319, 30) -- Hatching
	end
	if not self:LFR() then
		self:Berserk(self:Mythic() and 360 or 480)
	end
end

function mod:OnBossDisable()
	if self:GetOption("custom_on_fixate_plates") then
		self:HidePlates()
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:drawInCheck(self)
	if skipDrawIn then
		self:Message(232061, "Urgent", "Alarm", CL.interrupted:format(self:SpellName(232061))) -- Draw In Interrupted
		nextDrawIn = GetTime() + 58
		self:CDBar(232061, 58) -- Draw In
		self:ScheduleTimer("drawInCheck", 58, self)
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(_, spellName, _, _, spellId)
	if spellId == 232192 then -- Commanding Roar
		self:Message(spellId, "Important", "Alert", spellName)
		roarCounter = roarCounter + 1
		if (nextDrawIn > GetTime() + 32.8) or skipDrawIn then
			self:Bar(spellId, 32.8)
		end
	end
end

function mod:RAID_BOSS_WHISPER(event, msg)
	if msg:find("240319", nil, true) then -- Hatching
		self:Message(240319, "Important", "Warning")
		self:CastBar(240319, 22)
		if (nextDrawIn > GetTime() + 40) or skipDrawIn then
			self:Bar(240319, 40)
		end
	end
end

do
	local prev = 0
	function mod:GroundEffectDamage(args)
		skipDrawIn = false -- Drenching Waters confirmed, no more skipping
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 1.5 then
			prev = t
			self:Message(args.spellId, "Personal", "Alert", CL.underyou:format(args.spellName))
		end
	end
end

function mod:JaggedAbrasion(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, args.destName, amount, "Urgent", amount > 4 and "Warning") -- Swap on 4~5
end

function mod:UncheckedRage(args)
	self:Message(args.spellId, "Urgent", "Warning")
	rageCounter = rageCounter + 1
	if (nextDrawIn > GetTime() + 20.5) or skipDrawIn then
		self:Bar(args.spellId, 20.5)
	end
end

function mod:DrawIn(args)
	self:Message(args.spellId, "Important", "Alert", CL.casting:format(args.spellName))
	self:CastBar(args.spellId, 10)
end

function mod:FrigidBlows(args)
	local amount = args.amount or 1
	if amount < 5 or amount % 5 == 0 then -- Every 5 stacks or when below 5.
		self:StackMessage(args.spellId, args.destName, amount, "Urgent", amount < 4 and "Alarm") -- Add sound on last 3 stacks as pre-warning that the phase is ending
	end
end

function mod:FrostyDischarge(args)
	roarCounter = 1
	rageCounter = 1
	self:Message(args.spellId, "Urgent", "Warning", args.spellName)
	self:CDBar(232192, 17) -- Commanding Roar
	self:CDBar(231854, 21.4) -- Unchecked Rage
	if self:Mythic() then
		self:Bar(240319, 32) -- Hatching
	end
	nextDrawIn = GetTime() + 59.1
	self:CDBar(232061, 59.1) -- Draw In
end

do
	local playerList = mod:NewTargetList()
	function mod:AqueousBurst(args)
		if self:Me(args.destGUID) then
			self:Flash(args.spellId)
			self:Say(args.spellId)
		end

		playerList[#playerList+1] = args.destName

		if #playerList == 1 then
			self:ScheduleTimer("TargetMessage", 0.3, args.spellId, playerList, "Important", "Alarm")
		end
	end
end

function mod:AqueousBurstRemoved()
	skipDrawIn = false -- Drenching Waters confirmed, no more skipping
end

function mod:DrivenAssault(args)
	if self:Me(args.destGUID) then
		self:Flash(234128)
		self:Say(234128)
		if self:GetOption("custom_on_fixate_plates") then
			self:AddPlateIcon(234128, args.sourceGUID, 10) -- Show the target that is fixating on you more clear
		end
	end
end

function mod:DrivenAssaultRemoved(args)
	if self:GetOption("custom_on_fixate_plates") and self:Me(args.destGUID) then
		self:RemovePlateIcon(234128, args.sourceGUID) -- Clear fixate plate incase it's removed early
	end
end

function mod:SicklyFixate(args)
	if self:Me(args.destGUID) then
		self:Flash(args.spellId)
		self:Say(args.spellId)
		if self:GetOption("custom_on_fixate_plates") then
			self:AddPlateIcon(args.spellId, args.sourceGUID, 10) -- Show the target that is fixating on you more clear
		end
	end
end

function mod:SicklyFixateRemoved(args)
	if self:GetOption("custom_on_fixate_plates") and self:Me(args.destGUID) then
		self:RemovePlateIcon(args.spellId, args.sourceGUID) -- Clear fixate plate incase it's removed early
	end
end
