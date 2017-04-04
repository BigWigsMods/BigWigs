
--------------------------------------------------------------------------------
-- TODO List:

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

local dischargeComing = nil
local drawInCasting = nil

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.custom_on_fixate_plates = "Fixate icon on Enemy Nameplate"
	L.custom_on_fixate_plates_desc = "Show an icon on the target nameplate that is fixating on you.\nRequires the use of Enemy Nameplates. This feature is currently only supported by KuiNameplates."
	L.custom_on_fixate_plates_icon = 234128

	L.darkscale_taskmaster = "Darkscale Taskmaster (Heroic, Mythic)"
	L.darkscale_taskmaster_desc = "Summons a Darkscale Taskmaster from the throne."
	L.darkscale_taskmaster_icon = 233951
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
		"darkscale_taskmaster", -- Darkscale Taskmaster
		{231729, "SAY", "FLASH"}, -- Aqueous Burst
		{234128, "SAY", "FLASH"}, -- Driven Assault
		"custom_on_fixate_plates",
		240319, -- Hatching
		{241600, "SAY", "FLASH"} -- Sickly Fixate
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

	-- Boss
	self:Log("SPELL_AURA_APPLIED", "JaggedAbrasion", 231998)
	self:Log("SPELL_AURA_APPLIED_DOSE", "JaggedAbrasion", 231998)
	self:Log("SPELL_CAST_START", "UncheckedRage", 231854)
	self:Log("SPELL_AURA_APPLIED", "DrawIn", 232061)
	self:Log("SPELL_AURA_REMOVED", "DrawInSuccess", 232061)
	self:Log("SPELL_AURA_APPLIED", "FrigidBlowsApplied", 233429)
	self:Log("SPELL_AURA_REMOVED_DOSE", "FrigidBlows", 233429)
	self:Log("SPELL_CAST_START", "FrostyDischarge", 232174)

	-- Adds
	self:Log("SPELL_AURA_APPLIED", "AqueousBurst", 231729)
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
	self:Bar(232192, 17.5) -- Commanding Roar
	self:Bar(231854, 21) -- Unchecked Rage
	self:Bar(232061, 60) -- Draw In
	if self:Heroic() or self:Mythic() then
		self:Bar("darkscale_taskmaster", 41.6, self:SpellName(-14725), L.darkscale_taskmaster_icon) -- Darkscale Taskmaster
	end
	if self:Mythic() then
		self:Bar(240319, 30) -- Hatching
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
function mod:UNIT_SPELLCAST_SUCCEEDED(unit, spellName, _, _, spellId)
	if spellId == 232192 then -- Commanding Roar
		self:Message(spellId, "Important", "Alert", spellName)
		self:Bar(spellId, 32.8)
	elseif spellId == 241736 then -- Darkscale Taskmaster
		self:Message("darkscale_taskmaster", "Attention", "Alert", CL.incoming:format(self:SpellName(-14725)), L.darkscale_taskmaster_icon)
		self:Bar("darkscale_taskmaster", 60.5, self:SpellName(-14725), L.darkscale_taskmaster_icon) -- Darkscale Taskmaster
	end
end

function mod:RAID_BOSS_WHISPER(event, msg)
	if msg:find("240319", nil, true) then -- Hatching
		self:Message(240319, "Important", "Warning")
		self:Bar(240319, 41.5)
	end
end

function mod:JaggedAbrasion(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, args.destName, amount, "Urgent", amount > 4 and "Warning") -- Swap on 4~5
end

function mod:UncheckedRage(args)
	self:Message(args.spellId, "Urgent", "Warning")
	self:Bar(args.spellId, 20.5)
end

function mod:DrawIn(args)
	drawInCasting = true
	self:Message(args.spellId, "Important", "Alert", CL.casting:format(args.spellName))
	self:CastBar(args.spellId, 10)
end

function mod:DrawInSuccess(args)
	if not dischargeComing then
		self:Bar(args.spellId, 50.5)
	end
	dischargeComing = nil
	drawInCasting = nil
end

function mod:FrigidBlowsApplied(args)
	if drawInCasting then
		dischargeComing = true
		-- Cooldowns resetting after Frost Discharge now
		self:StopBar(232192) -- Commanding Roar
		self:StopBar(231854) -- Unchecked Rage
		self:StopBar(240319) -- Hatching
	end
end

function mod:FrigidBlows(args)
	local amount = args.amount or 1
	if amount < 4 then -- Start warnings last 3 stacks
		self:StackMessage(args.spellId, args.destName, amount, "Urgent", amount < 2 and "Alert") -- Add sound on last stack
	end
end

function mod:FrostyDischarge(args)
	self:Message(args.spellId, "Urgent", "Warning", args.spellName)
	self:Bar(232192, 18.2)	-- Commanding Roar
	self:Bar(231854, 21.4) -- Unchecked Rage
	if self:Mythic() then
		self:Bar(240319, 32) -- Hatching
	end
	self:Bar(232061, 60) -- Draw In
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