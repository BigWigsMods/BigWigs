--------------------------------------------------------------------------------
-- TODO:
--
--

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Il'gynoth, Corruption Reborn", 2217, 2374)
if not mod then return end
mod:RegisterEnableMob(158328) -- l'gynoth <Corruption Reborn>
mod.engageId = 2345
--mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.custom_on_fixate_plates = "Fixate icon on Enemy Nameplate"
	L.custom_on_fixate_plates_desc = "Show an icon on the target nameplate that is fixating on you.\nRequires the use of Enemy Nameplates. This feature is currently only supported by KuiNameplates."
	L.custom_on_fixate_plates_icon = 315094
end

--------------------------------------------------------------------------------
-- Locals
--

local stage = 1
--local organsKilled = 0
local touchCount = 1
local gazeCount = 1
--local cursedBloodCount = 1

--------------------------------------------------------------------------------
-- Initialization
--

local cursedBloodMarker = mod:AddMarkerOption(false, "player", 1, 313759, 1, 2, 3) -- Cursed Blood
function mod:GetOptions()
	return {
		"stages",
		309961, -- Eye of N'Zoth
		311401, -- Touch of the Corruptor
		310433, -- Corruptor's Gaze
		310322, -- Nightmare Corruption
		{315094, "FLASH"}, -- Fixate
		"custom_on_fixate_plates",
		{313759, "FLASH", "SAY"}, -- Cursed Blood
		cursedBloodMarker,
	}, {
		[309961] = "general",
		[313759] = "mythic",
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")

	self:Log("SPELL_CAST_START", "EyeofNZoth", 309961)
	self:Log("SPELL_CAST_START", "TouchoftheCorruptor", 311401)
	self:Log("SPELL_AURA_APPLIED", "FixateApplied", 315094)
	self:Log("SPELL_AURA_REMOVED", "FixateRemoved", 315094)

	if self:GetOption("custom_on_fixate_plates") then
		self:ShowPlates()
	end

	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 310322) -- Nightmare Corruption
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 310322)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 310322)

	-- Mythic
	self:Log("SPELL_AURA_APPLIED", "CursedBloodApplied", 313759)
	self:Log("SPELL_AURA_REMOVED", "CursedBloodRemoved", 313759)
end

function mod:OnEngage()
	stage = 1
	--organsKilled = 0
	gazeCount = 1
	touchCount = 1

	self:Bar(309961, 5.5) -- Eye of N'Zoth
	self:Bar(310433, 12.5, CL.count:format(self:SpellName(310433), gazeCount)) -- Corruptor's Gaze
	self:Bar(311401, 47.5, CL.count:format(self:SpellName(311401), touchCount)) -- Touch of the Corruptor
end

function mod:OnBossDisable()
	if self:GetOption("custom_on_fixate_plates") then
		self:HidePlates()
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--
do
	local prev = 0
	function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, spellId)
		if spellId == 310433 then -- Corruptor's Gaze
			self:PlaySound(spellId, "long")
			self:Message2(spellId, "orange", CL.count:format(self:SpellName(310433), gazeCount))
			gazeCount = gazeCount + 1
			self:CDBar(spellId, 32, CL.count:format(self:SpellName(310433), gazeCount))
		elseif spellId == 110470 then -- Reduce Parry and Block Chance 100% / Intermission Start
			local t = GetTime()
			if t-prev > 2 then
				stage = 2
				self:Message2("stages", "cyan", CL.stage:format(stage), false)
				self:PlaySound("stages", "long")
				self:StopBar(309961) -- Eye of N'Zoth
				self:StopBar(CL.count:format(self:SpellName(311401), touchCount)) -- Touch of the Corruptor
				self:StopBar(CL.count:format(self:SpellName(310433), gazeCount)) -- Corruptor's Gaze
			end
		elseif spellId == 311577 then -- Damaged Organ
			stage = 1
			gazeCount = 1
			touchCount = 1
			--organsKilled = organsKilled + 1
			self:Message2("stages", "cyan", CL.stage:format(stage), false)
			self:PlaySound("stages", "long")
			self:Bar(309961, 10.3) -- Eye of N'Zoth
			self:Bar(310433, 16.5, CL.count:format(self:SpellName(310433), gazeCount)) -- Corruptor's Gaze
			self:Bar(311401, 52.9, CL.count:format(self:SpellName(311401), touchCount)) -- Touch of the Corruptor
		end
	end
end

function mod:EyeofNZoth(args)
	self:Message2(args.spellId, "purple")
	self:PlaySound(args.spellId, "warning")
	self:Bar(args.spellId, 17)
end

function mod:TouchoftheCorruptor(args)
	self:Message2(args.spellId, "yellow", CL.count:format(args.spellName, touchCount))
	self:PlaySound(args.spellId, "long")
	touchCount = touchCount + 1
	self:Bar(args.spellId, 64.5, CL.count:format(args.spellName, touchCount))
end

function mod:FixateApplied(args)
	if self:Me(args.destGUID) then
		self:Flash(args.spellId)
		if self:GetOption("custom_on_fixate_plates") then
			self:AddPlateIcon(args.spellId, args.sourceGUID)
		end
	end
end

function mod:FixateRemoved(args)
	if self:GetOption("custom_on_fixate_plates") and self:Me(args.destGUID) then
		self:RemovePlateIcon(args.spellId, args.sourceGUID)
	end
end

do
	local prev = 0
	function mod:GroundDamage(args)
		if self:Me(args.destGUID) then
			local t = args.time
			if t-prev > 2 then
				prev = t
				self:PlaySound(args.spellId, "alarm")
				self:PersonalMessage(args.spellId, "underyou")
			end
		end
	end
end

-- Mythic
do
	local playerList = mod:NewTargetList()
	function mod:CursedBloodApplied(args)
		playerList[#playerList+1] = args.destName
		if self:Me(args.destGUID) then
			self:Say(args.spellId)
			self:Flash(args.spellId)
			self:PlaySound(args.spellId, "warning")
		end
		self:TargetsMessage(args.spellId, "yellow", playerList)
		if self:GetOption(cursedBloodMarker) then
			SetRaidTarget(args.destName, #playerList)
		end
	end

	function mod:CursedBloodRemoved(args)
		if self:GetOption(cursedBloodMarker) then
			SetRaidTarget(args.destName, 0)
		end
	end
end
