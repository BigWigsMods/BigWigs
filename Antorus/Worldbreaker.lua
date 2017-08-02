if not IsTestBuild() then return end -- XXX dont load on live
--------------------------------------------------------------------------------
-- TODO:
-- -- Apocalypse soon warning - 65% and 25% (warnings 67% & 27%)
-- -- Schedule Surging Fel bars
-- -- Annihilation impact bars
-- -- Double check how weapon systems and their abilities work
-- -- Do we need a say on Decimation? Many people are targetted, and it has a short duration.

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Gorothi Worldbreaker", nil, 1992, 1712)
if not mod then return end
mod:RegisterEnableMob(122450) -- Garothi Worldbreaker
mod.engageId = 2076
mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

local stage = 1
local annihilatorAlive = true
local decimatorAlive = true

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{246220, "TANK", "SAY"}, -- Locked On
		240277, -- Apocalypse Drive
		244969, -- Eradication
		244106, -- Carnage
		{244410, "SAY"}, -- Decimation
		244761, -- Annihilation
	},{
		[246220] = "general",
		[244410] = -15915, -- Decimator
		[244761] = -15917, -- Annihilator
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("RAID_BOSS_WHISPER") -- Decimation
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1", "boss2", "boss3")

	self:Log("SPELL_AURA_APPLIED", "LockedOn", 246220) -- Locked On pre-debuff
	self:Log("SPELL_AURA_REMOVED", "LockedOnRemoved", 246220) -- Locked On pre-debuff
	self:Log("SPELL_CAST_START", "ApocalypseDrive", 240277)
	self:Log("SPELL_AURA_REMOVED", "ApocalypseDriveOver", 240277)
	self:Death("WeaponDeath", 122778, 122773) -- Interupts Apocalypse Drive, id: Annihilator, Decimator
	self:Log("SPELL_CAST_START", "Eradication", 244969)
	self:Log("SPELL_CAST_SUCCESS", "Carnage", 244106)
end

function mod:OnEngage()
	stage = 1
	annihilatorAlive = true
	decimatorAlive = true

	self:Bar(244761, 8) -- Annihilation
	self:Bar(246220, 9.5) -- Locked On
end

--------------------------------------------------------------------------------
-- Event Handlers
--
function mod:RAID_BOSS_WHISPER(_, msg)
	if msg:find("244410", nil, true) then -- Decimation
		self:Message(244410, "Personal", "Warning", CL.you:format(self:SpellName(244410)))
		self:Say(244410)
		self:SayCountdown(244410, 3)
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, _, spellId)
	if spellId == 245124 then -- Cannon Chooser
		if stage == 1 or annihilatorAlive then -- In stage 1 it's always Annihilation being cast
			self:Message(244761, "Attention", "Alert") -- Annihilation
			self:Bar(244761, 15.8)
		elseif decimatorAlive then
			self:Message(244410, "Attention", "Alert") -- Decimation
			self:Bar(244410, 8.5)
		end
	end
end

function mod:LockedOn(args)
	self:TargetMessage(args.spellId, args.destName, "Urgent", "Warning", nil, nil, true)
	self:Bar(args.spellId, 20.7)
	if self:Me(args.destGUID) then
		self:Say(args.spellId)
		self:SayCountdown(args.spellId, 7)
		self:TargetBar(args.spellId, 7, args.destName)
	end
end

function mod:LockedOnRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
		self:StopBar(args.spellId, args.destName)
	end
end

function mod:ApocalypseDrive(args)
	self:StopBar(244410) -- Decimation
	self:StopBar(244761) -- Annihilation
	self:StopBar(246220) -- Locked On

	self:Message(args.spellId, "Important", "Long", CL.casting:format(args.spellName))
	self:CastBar(args.spellId, 20)
end

function mod:ApocalypseDriveSuccess(args)
	self:Message(args.spellId, "Urgent", "Alarm")
end

function mod:WeaponDeath(args)
	stage = stage + 1
	self:Message(240277, "Positive", "Info", CL.interrupted:format(self:SpellName(240277)))
	self:StopBar(CL.cast:format(self:SpellName(240277)))

	self:Bar(244969, 7.2) -- Eradication
	self:Bar(246220, 23.1) -- Locked On

	if args.mobId == 122778 then -- Annihilator death
		annihilatorAlive = false
		self:Bar(244410, 21.9) -- Decimation
	elseif args.mobId == 122773 then -- Decimator death
		decimatorAlive = false
		self:Bar(244761, 21.9) -- Annihilation
	end
end

function mod:Eradication(args)
	self:Message(args.spellId, "Urgent", "Warning", CL.casting:format(args.spellName))
end

function mod:Carnage(args)
	self:Message(args.spellId, "Urgent", "Alarm")
end
