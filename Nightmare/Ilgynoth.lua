--------------------------------------------------------------------------------
-- TODO List:
-- - Fix mod after testing
-- - Add nicer stage separation comments/options
-- - Respawn time
-- - Tuning sounds / message colors
-- - Remove alpha engaged message

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Il'gynoth", 1520)
if not mod then return end
mod:RegisterEnableMob(105393) -- fix me
--mod.engageId = 1000000
--mod.respawnTime = 0

--------------------------------------------------------------------------------
-- Locals
--

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"berserk",

		-- Stage One
		210099, -- Fixate (Nightmare Ichor)
		209469, -- Touch of Corruption (Nightmare Ichor)

		210984, -- Deathglare (Nightmare Horror)

		215234, -- Nightmarish Fury (Dominator Tentacle)

		-- Stage Two
		210781, -- Dark Reconstitution
		{215143, "SAY", "FLASH", "PROXIMITY"}, -- Cursed Blood
	}
end

function mod:OnBossEnable()
	-- Stage One
	self:Log("SPELL_AURA_APPLIED", "Fixate", 210099)  -- Pre alpha test spellId
	self:Log("SPELL_AURA_APPLIED", "TouchOfCorruption", 209469)  -- Pre alpha test spellId
	self:Log("SPELL_AURA_APPLIED_DOSE", "TouchOfCorruption", 209469)  -- Pre alpha test spellId


	self:Log("SPELL_AURA_APPLIED", "Deathglare", 210984)  -- Pre alpha test spellId

	self:Log("SPELL_CAST_START", "NightmarishFury", 215234)  -- Pre alpha test spellId

	-- Stage Two
	self:Log("SPELL_CAST_START", "DarkReconstitution", 210781)  -- Pre alpha test spellId
	self:Log("SPELL_AURA_APPLIED", "CursedBlood", 215143)  -- Pre alpha test spellId
	self:Log("SPELL_AURA_REMOVED", "CursedBloodRemoved", 215143)  -- Pre alpha test spellId
end

function mod:OnEngage()
	self:Message("berserk", "Neutral", nil, "Xavius (Alpha) Engaged (Pre Alpha Test Mod)")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- This function is from pre alpha testing. Please fix it or remove this comment if it's working
function mod:Fixate(args)
	self:TargetMessage(args.spellId, args.destName, "Attention")
end

-- This function is from pre alpha testing. Please fix it or remove this comment if it's working
function mod:TouchOfCorruption(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, args.destName, amount, "Important", amount > 9 and "Warning") -- XXX fix sound amount, not even alpha
end


-- This function is from pre alpha testing. Please fix it or remove this comment if it's working
function mod:Deathglare(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, args.destName, amount, "Important", amount > 1 and "Warning") -- XXX fix sound amount, not even alpha
end


-- This function is from pre alpha testing. Please fix it or remove this comment if it's working
function mod:NightmarishFury(args)
	self:Message(args.spellId, "Urgent")
end


-- This function is from pre alpha testing. Please fix it or remove this comment if it's working
function mod:DarkReconstitution(args)
	-- add countdown messages?
	self:Bar(args.spellId, 50, CL.cast:format(args.spellName))
end

-- These functions are from pre alpha testing. Please fix them or remove this comment if they are working
do
	local playerList, proxList, isOnMe = mod:NewTargetList(), {}, nil
	function mod:CursedBlood(args)
		if self:Me(args.destGUID) then
			isOnMe = true
			self:Flash(args.spellId)
			self:Say(args.spellId)
			self:TargetBar(args.spellId, 8, args.destName)
			self:OpenProximity(args.spellId, 11)
			self:ScheduleTimer("Say", 5, args.spellId, 3, true)
			self:ScheduleTimer("Say", 6, args.spellId, 2, true)
			self:ScheduleTimer("Say", 7, args.spellId, 1, true)
		end

		proxList[#proxList+1] = args.destName
		if not isOnMe then
			self:OpenProximity(args.spellId, 11, proxList)
		end

		playerList[#playerList+1] = args.destName
		if #playerList == 1 then
			self:ScheduleTimer("TargetMessage", 0.1, args.spellId, playerList, "Important", "Alert")
			rotCount = rotCount + 1
			self:CDBar(args.spellId, rotCount == 2 and 34 or 21)  -- alpha heroic timing, 2. did vary between 34-37, 3. between 20-23
		end
	end

	function mod:CursedBloodRemoved(args)
		if self:Me(args.destGUID) then
			isOnMe = nil
			self:StopBar(args.spellName, args.destName)
			self:CloseProximity(args.spellId)
		end

		tDeleteItem(proxList, args.destName)
		if not isOnMe then -- Don't change proximity if it's on you and expired on someone else
			if #proxList == 0 then
				self:CloseProximity(args.spellId)
			else
				self:OpenProximity(args.spellId, 11, proxList)
			end
		end
	end
end