if not IsTestBuild() then return end -- XXX dont load on live
--------------------------------------------------------------------------------
-- TODO:
-- -- Apocalypse soon warning - 65% and 25% (warnings 67% & 27%)
-- -- Annihilation impact bars
-- -- Split Cannon ability bars in mythic and phase 1's after asking what is cast first?

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
-- Localization
--

local L = mod:GetLocale()
if L then
	L.cannon_ability = mod:SpellName(52541) -- Cannon Assault
	L.cannon_ability_desc = "Display Messages and Bars related to the 2 cannons on the Gorothi Worldbreaker's back."
	L.cannon_ability_icon = 57610 -- Cannon icon
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{246220, "TANK", "SAY"}, -- Fel Bombardment
		240277, -- Apocalypse Drive
		244969, -- Eradication
		244106, -- Carnage
		"cannon_ability", -- Cannon Assault
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

	self:Log("SPELL_AURA_APPLIED", "FelBombardment", 246220) -- Fel Bombardment pre-debuff
	self:Log("SPELL_AURA_REMOVED", "FelBombardmentRemoved", 246220) -- Fel Bombardment pre-debuff
	self:Log("SPELL_CAST_START", "ApocalypseDrive", 240277)
	self:Log("SPELL_CAST_SUCCESS", "ApocalypseDriveSuccess", 240277)
	self:Death("WeaponDeath", 122778, 122773) -- Interupts Apocalypse Drive, id: Annihilator, Decimator
	self:Log("SPELL_CAST_START", "Eradication", 244969)
	self:Log("SPELL_CAST_SUCCESS", "Carnage", 244106)

	--[[ Mythic ]] --
	self:Log("SPELL_AURA_APPLIED", "Haywire", 246897, 246965) -- Decimator Hayware, Annihilator Hayware
end

function mod:OnEngage()
	stage = 1
	annihilatorAlive = true
	decimatorAlive = true

	self:Bar("cannon_ability", 8, L.cannon_ability, L.cannon_ability_icon)
	self:Bar(246220, 9.4) -- Fel Bombardment
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
		if stage == 1 or self:Mythic() then -- Alternates, First one random // In Mythic Cannons are empowered, not killed
			self:Message("cannon_ability", "Attention", "Alert", L.cannon_ability, L.cannon_ability_icon)
			self:Bar("cannon_ability", 15.8, L.cannon_ability, L.cannon_ability_icon)
		elseif decimatorAlive then
			self:Message(244410, "Attention", "Alert") -- Decimation
			self:Bar(244410, 8.5) -- XXX Stage 2 timer was faster in first heroic test, in mythic it didn't change
		elseif annihilatorAlive then
			self:Message(244761, "Attention", "Alert") -- Annihilation
			self:Bar(244761, 8.5) -- XXX Stage 2 timer was faster in first heroic test, in mythic it didn't change
		end
	end
end

function mod:FelBombardment(args)
	self:TargetMessage(args.spellId, args.destName, "Neutral", "Info", nil, nil, true)
	self:Bar(args.spellId, self:Mythic() and 15.8 or 20.7)
	if self:Me(args.destGUID) then
		self:Say(args.spellId)
		self:SayCountdown(args.spellId, 7)
		self:TargetBar(args.spellId, 7, args.destName)
	end
end

function mod:FelBombardmentRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
		self:StopBar(args.spellId, args.destName)
	end
end

function mod:ApocalypseDrive(args)
	self:StopBar(L.cannon_ability)
	self:StopBar(244410) -- Decimation
	self:StopBar(244761) -- Annihilation
	self:StopBar(246220) -- Fel Bombardment

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
	self:Bar(246220, 23.1) -- Fel Bombardment

	if args.mobId == 122778 then -- Annihilator death
		annihilatorAlive = false
		if stage == 2 then
			self:Bar(244410, 21.9) -- Decimation
		end
	elseif args.mobId == 122773 then -- Decimator death
		decimatorAlive = false
		if stage == 2 then
			self:Bar(244761, 21.9) -- Annihilation
		end
	end
end

function mod:Eradication(args)
	self:Message(args.spellId, "Urgent", "Warning", CL.casting:format(args.spellName))
	self:CastBar(args.spellId, 5.5)
end

function mod:Carnage(args)
	self:Message(args.spellId, "Urgent", "Alarm")
end

--[[ Mythic ]]--
function mod:Haywire()
	stage = stage + 1
	self:Message(240277, "Positive", "Long", CL.interrupted:format(self:SpellName(240277)))
	self:StopBar(CL.cast:format(self:SpellName(240277)))

	self:Bar(244969, 4.1) -- Eradication
	self:Bar("cannon_ability", 19.8, L.cannon_ability, L.cannon_ability_icon)
	self:Bar(246220, 21.1) -- Fel Bombardment
end
