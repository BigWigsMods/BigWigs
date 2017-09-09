--------------------------------------------------------------------------------
-- TODO List:
-- List the important adds each wave of Warp In
-- Target messages if blizzard adds support

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Eonar the Life-Binder", nil, 2025, 1712)
if not mod then return end
mod:RegisterEnableMob(122500) -- Essence of Eonar
mod.engageId = 2075
--mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--
local rainOfFelCount = 1
local warpInCount = 1
local lifeForceCount = 1
local lifeForceNeeded = 5

local timersNormal = {
	--[[ Rain of Fel ]]--
	[248332] = {21, 24, 24, 24, 48, 24, 96, 12},

	--[[ Warp In ]]--
	[246888] = {5, 16, 24},
}

local timersHeroic = {
	--[[ Rain of Fel ]]--
	[248332] = {15, 24, 9, 24, 12, 52, 12, 21, 12, 24, 9, 24, 12},

	--[[ Warp In ]]--
	[246888] = {5, 10, 24, 21, 24, 19, 45, 21, 45, 24, 24},
}

local timers = mod:Heroic() and timersHeroic or timersNormal

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.warp_in = mod:SpellName(246888)
	L.warp_in_desc = "Shows timers and messages for each Warp In." -- [and the special add coming with it]. XXX Implement specifics when certain
	L.warp_in_icon = "inv_artifact_dimensionalrift"

	L.lifeforce_casts = "%s (%d/%d)"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"warp_in",
		250048, -- Life Force
		248861, -- Spear of Doom
		248332, -- Rain of Fel
		246305, -- Artillery Strike
	},{
		["warp_in"] = "general",
		[246305] = CL.adds,
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss2")
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
	self:Log("SPELL_CAST_SUCCESS", "WarpIn", 246888, 246896) -- XXX Both no icons or spell info, might be replaced
	self:RegisterUnitEvent("UNIT_POWER", nil, "boss1")
	self:Log("SPELL_CAST_START", "LifeForce", 250048)
	self:Log("SPELL_CAST_SUCCESS", "LifeForceSuccess", 250048)
	self:Log("SPELL_CAST_START", "ArtilleryStrike", 246305)
end

function mod:OnEngage()
	rainOfFelCount = 1
	warpInCount = 1
	lifeForceCount = 1
	timers = self:Heroic() and timersHeroic or timersNormal

	self:Bar(248332, timers[248332][rainOfFelCount]) -- Rain of Fel
	self:Bar("warp_in", timers[246888][warpInCount], CL.count:format(L.warp_in, warpInCount), "inv_artifact_dimensionalrift") -- Warp In
	if self:Heroic() then
		self:CDBar(248861, 27) -- Spear of Doom
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, _, spellId)
	if spellId == 248332 then -- Rain of Fel
		self:Message(spellId, "Urgent", "Warning")
		rainOfFelCount = rainOfFelCount + 1
		self:Bar(spellId, timers[spellId][rainOfFelCount])
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(_, msg)
	if msg:find("248861") then -- Spear of Doom
		self:Message(248861, "Important", "Alarm")
		self:CDBar(248861, 33)
	end
end

do
	local prev = 0
	function mod:WarpIn(args)
		local t = GetTime()
		if t-prev > 2 then -- 2 waves can spawn at the same time, we count them as 1
			prev = t
			self:Message("warp_in", "Neutral", "Info", CL.count:format(args.spellName, warpInCount), false)
			warpInCount = warpInCount + 1
			self:Bar("warp_in", timers[246888][warpInCount] or self:Normal() and 24, CL.count:format(args.spellName, warpInCount), L.warp_in_icon)
		end
	end
end

function mod:UNIT_POWER(unit)
	local power = UnitPower(unit)
	if power >= 80 then
		self:Message(250048, "Neutral", "Info", L.lifeforce_casts:format(CL.soon:format(self:SpellName(250048)), lifeForceCount, lifeForceNeeded)) -- Life Force
		self:UnregisterUnitEvent("UNIT_POWER", unit)
	end
end

function mod:LifeForce(args)
	self:Message(args.spellId, "Positive", "Long", L.lifeforce_casts:format(CL.casting:format(args.spellName), lifeForceCount, lifeForceNeeded))
	lifeForceCount = lifeForceCount + 1
end

function mod:LifeForceSuccess(args)
	self:RegisterUnitEvent("UNIT_POWER", nil, "boss1")
end

function mod:ArtilleryStrike(args)
	if self:Interrupter(args.sourceGUID) then
		self:Message(args.spellId, "Attention", "Alert")
	end
end
