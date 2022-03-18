
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("High Warlord Naj'entus", 564, 1582)
if not mod then return end
mod:RegisterEnableMob(22887)
mod:SetEncounterID(601)
mod:SetAllowWin(true)
--mod:SetRespawnTime(0) -- Resets, doesn't respawn

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.start_trigger = "You will die in the name of Lady Vashj!"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{39837, "SAY", "ICON"}, -- Impaling Spine
		39872, -- Tidal Shield
		{39835, "PROXIMITY"}, -- Needle Spine
		"berserk",
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "TidalShield", 39872)
	self:Log("SPELL_AURA_REMOVED", "TidalShieldRemoved", 39872)
	self:Log("SPELL_CAST_SUCCESS", "ImpalingSpine", 39837) -- Faster than APPLIED due to travel time.
	self:Log("SPELL_AURA_REMOVED", "ImpalingSpineRemoved", 39837)

	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
end

function mod:CHAT_MSG_MONSTER_YELL(_, msg)
	if msg == L["start_trigger"] then
		self:Engage() -- No boss frame to engage
	end
end

function mod:OnEngage()
	self:DelayedMessage(39872, 45, "yellow", CL.custom_sec:format(self:SpellName(39872), 10)) -- Tidal Shield
	self:CDBar(39872, 55) -- Tidal Shield. 55-60
	self:Berserk(480)
	self:OpenProximity(39835, 8) -- Needle Spine
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:TidalShield(args)
	self:MessageOld(args.spellId, "red", "alert")
	self:DelayedMessage(args.spellId, 50, "yellow", CL.custom_sec:format(args.spellName, 10))
	self:CDBar(args.spellId, 56) -- 56-60
end

function mod:TidalShieldRemoved(args)
	self:MessageOld(args.spellId, "green", nil, CL.removed:format(args.spellName))
end

function mod:ImpalingSpine(args)
	if self:Me(args.destGUID) then
		self:Say(args.spellId)
	end
	self:TargetMessageOld(args.spellId, args.destName, "red", "warning", nil, nil, true)
	self:PrimaryIcon(args.spellId, args.destName)
end

function mod:ImpalingSpineRemoved(args)
	self:PrimaryIcon(args.spellId)
end
