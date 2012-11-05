
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Gara'jal the Spiritbinder", 896, 682)
mod:RegisterEnableMob(60143, 60385) -- Gara'jal, Zandalari War Wyvern

local totemCounter, shadowCounter = 1, 1
local totemTime = 36.5

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.engage_yell = "It be dyin' time, now!"

	L.totem = "Totem (%d)"

	L.frenzy, L.frenzy_desc = EJ_GetSectionInfo(5759)
	L.frenzy_icon = 117752

	L.shadowy, L.shadowy_desc = EJ_GetSectionInfo(6698)
	L.shadowy_icon = 117222
	L.shadowy_message = "Attack (%d)"

	L.banish_message = "Tank Banished"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		122151, 116174, 116272, 116161,
		"frenzy",
		"shadowy", "berserk", "bosskill",
	}, {
		[122151] = CL["phase"]:format(1),
		frenzy = CL["phase"]:format(2),
		shadowy = "general",
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "Frenzy", 117752)
	self:Log("SPELL_AURA_APPLIED", "VoodooDollsApplied", 122151)
	self:Log("SPELL_AURA_REMOVED", "VoodooDollsRemoved", 122151) -- Used in 3rd party modules
	self:Log("SPELL_CAST_SUCCESS", "SpiritTotem", 116174)
	self:Log("SPELL_CAST_SUCCESS", "Banishment", 116272)
	self:Log("SPELL_AURA_REMOVED", "SoulSeverRemoved", 116278)
	self:Log("SPELL_AURA_APPLIED", "CrossedOver", 116161, 116260) -- Norm/Hc, LFR
	self:Log("SPELL_AURA_REMOVED", "CrossedOverRemoved", 116161, 116260)

	self:AddSyncListener("DollsApplied")
	self:AddSyncListener("DollsRemoved")
	self:AddSyncListener("Totem")
	self:AddSyncListener("Shadowy")

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	self:Death("Win", 60143)
end

function mod:OnEngage(diff)
	totemCounter, shadowCounter = 1, 1
	if diff == 3 or diff == 5 then
		totemTime = 36.5 -- 10
	elseif diff == 4 or diff == 6 then
		totemTime = 20.5 -- 25
	elseif diff == 7 then
		totemTime = 30 -- LFR
	end
	self:Bar(116174, L["totem"]:format(totemCounter), totemTime, 116174)
	self:Bar(116272, L["banish_message"], self:Heroic() and 71 or 65, 116272)
	if not self:LFR() then
		self:Berserk(360)
	end
	if self:Heroic() then
		self:Bar("shadowy", L["shadowy_message"]:format(shadowCounter), 6.7, 117222)
	end
	self:RegisterEvent("UNIT_HEALTH_FREQUENT")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_SPELLCAST_SUCCEEDED(_, unit, _, _, _, spellId)
	if unit == "boss1" then
		if spellId == 116964 then
			self:Sync("Totem") -- LFR only, no combat log event for some reason
		elseif (spellId == 117215 or spellId == 117218 or spellId == 117219 or spellId == 117222) and self:Heroic() then
			self:Sync("Shadowy")
		end
	end
end

do
	local voodooDoll = GetSpellInfo(122151)
	local voodooDollList = mod:NewTargetList()
	function mod:OnSync(sync, rest)
		if sync == "DollsApplied" and rest then
			for player in string.gmatch(rest, "%S+") do
				voodooDollList[#voodooDollList+1] = player
			end
			self:TargetMessage(122151, voodooDoll, voodooDollList, "Important", 122151)
		elseif sync == "Totem" then
			self:Message(116174, L["totem"]:format(totemCounter), "Attention", 116174)
			totemCounter = totemCounter + 1
			self:Bar(116174, L["totem"]:format(totemCounter), totemTime, 116174)
		elseif sync == "Shadowy" and self:Heroic() then -- XXX temp heroic check for out of date users transmitting
			shadowCounter = shadowCounter + 1
			self:Bar("shadowy", L["shadowy_message"]:format(shadowCounter), 8.3, L["shadowy_icon"])
		end
	end
end

do
	local scheduled = nil
	local listTbl = {}
	local function createList()
		mod:Sync("DollsApplied", unpack(listTbl))
		wipe(listTbl)
		scheduled = nil
	end
	function mod:VoodooDollsApplied(player)
		listTbl[#listTbl+1] = player
		if not scheduled then
			scheduled = true
			self:ScheduleTimer(createList, 0.1)
		end
	end
end

do
	local scheduled = nil
	local listTbl = {}
	local function createList()
		mod:Sync("DollsRemoved", unpack(listTbl))
		wipe(listTbl)
		scheduled = nil
	end
	function mod:VoodooDollsRemoved(player)
		-- Used in 3rd party modules
		listTbl[#listTbl+1] = player
		if not scheduled then
			scheduled = true
			self:ScheduleTimer(createList, 0.1)
		end
	end
end

function mod:CrossedOver(player, spellId, _, _, spellName)
	if UnitIsUnit("player", player) then
		self:Bar(116161, spellName, 30, spellId)
	end
end

function mod:CrossedOverRemoved(player, spellId, _, _, spellName)
	if UnitIsUnit("player", player) then
		self:StopBar(spellName)
	end
end

function mod:SpiritTotem()
	self:Sync("Totem")
end

function mod:Banishment(player, spellId, _, _, spellName)
	if UnitIsUnit("player", player) then
		self:Bar(spellId, CL["you"]:format(spellName), 30, spellId)
	end
	self:Bar(spellId, L["banish_message"], self:Heroic() and 70 or 65, spellId)
	if self:Tank() then
		self:LocalMessage(spellId, L["banish_message"], "Urgent", spellId, "Alarm", player)
	end
end

function mod:SoulSeverRemoved(player)
	if UnitIsUnit("player", player) then
		self:StopBar(116272, player) -- Banish
	end
end

function mod:UNIT_HEALTH_FREQUENT(_, unitId)
	if unitId == "boss1" then
		local hp = UnitHealth(unitId) / UnitHealthMax(unitId) * 100
		if hp < 25 then -- phase starts at 20
			self:Message("frenzy", CL["soon"]:format(L["frenzy"]), "Positive", L["frenzy_icon"], "Info")
			self:UnregisterEvent("UNIT_HEALTH_FREQUENT")
		end
	end
end

function mod:Frenzy()
	self:Message("frenzy", CL["phase"]:format(2) ..": ".. L["frenzy"], "Positive", L["frenzy_icon"], "Long")
	if not self:LFR() then
		self:StopBar(L["totem"]:format(totemCounter))
	end
end

