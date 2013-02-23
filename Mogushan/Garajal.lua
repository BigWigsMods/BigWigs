
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

	L.totem_message = "Totem (%d)"
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
		-5759,
		-6698, "berserk", "bosskill",
	}, {
		[122151] = CL["phase"]:format(1),
		[-5759] = CL["phase"]:format(2),
		[-6698] = "general",
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
	self:AddSyncListener("Frenzy")
	self:AddSyncListener("Banish")

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")
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
	self:Bar(116174, totemTime, L["totem_message"]:format(totemCounter))
	self:Bar(116272, self:Heroic() and 71 or 65, L["banish_message"])
	if not self:LFR() then
		self:Berserk(360)
	end
	if self:Heroic() then
		self:Bar(-6698, 6.7, L["shadowy_message"]:format(shadowCounter), 117222)
	end
	self:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", "FrenzyCheck", "boss1")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, _, spellId)
	if spellId == 116964 then
		self:Sync("Totem") -- LFR only, no combat log event for some reason
	elseif (spellId == 117215 or spellId == 117218 or spellId == 117219 or spellId == 117222) and self:Heroic() then
		self:Sync("Shadowy")
	end
end

do
	local voodooDollList = mod:NewTargetList()
	function mod:OnSync(sync, rest)
		if sync == "DollsApplied" and rest then
			for player in string.gmatch(rest, "%S+") do
				voodooDollList[#voodooDollList+1] = player
			end
			self:TargetMessage(122151, voodooDollList, "Important")
		elseif sync == "Totem" then
			self:Message(116174, "Attention", nil, L["totem_message"]:format(totemCounter))
			totemCounter = totemCounter + 1
			self:Bar(116174, totemTime, L["totem_message"]:format(totemCounter))
		elseif sync == "Shadowy" then
			shadowCounter = shadowCounter + 1
			self:Bar(-6698, 8.3, L["shadowy_message"]:format(shadowCounter), 117222)
		elseif sync == "Frenzy" then
			self:Message(-5759, "Positive", "Long", CL["other"]:format(CL["phase"]:format(2), self:SpellName(-5759)))
			if not self:LFR() then
				self:StopBar(L["totem_message"]:format(totemCounter))
				self:StopBar(L["banish_message"])
			end
			self:UnregisterUnitEvent("UNIT_HEALTH_FREQUENT", "boss1")
		elseif sync == "Banish" and rest then
			self:Bar(116272, self:Heroic() and 70 or 65, L["banish_message"])
			self:Message(116272, "Urgent", self:Tank() and "Alarm" or nil, L["banish_message"])
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
	function mod:VoodooDollsApplied(args)
		listTbl[#listTbl+1] = args.destName
		if not scheduled then
			scheduled = self:ScheduleTimer(createList, 0.1)
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
	function mod:VoodooDollsRemoved(args)
		-- Used in 3rd party modules
		listTbl[#listTbl+1] = args.destName
		if not scheduled then
			scheduled = self:ScheduleTimer(createList, 0.1)
		end
	end
end

function mod:CrossedOver(args)
	if self:Me(args.destGUID) then
		self:Bar(116161, 30)
	end
end

function mod:CrossedOverRemoved(args)
	if self:Me(args.destGUID) then
		self:StopBar(args.spellName)
	end
end

function mod:SpiritTotem()
	self:Sync("Totem")
end

function mod:Banishment(args)
	if self:Me(args.destGUID) then
		self:Bar(args.spellId, 30, CL["you"]:format(args.spellName))
	end
	self:Sync("Banish", args.destName)
end

function mod:SoulSeverRemoved(args)
	if self:Me(args.destGUID) then
		self:StopBar(116272, CL["you"]:format(self:SpellName(116272))) -- Banish
	end
end

function mod:FrenzyCheck(unitId)
	local hp = UnitHealth(unitId) / UnitHealthMax(unitId) * 100
	if hp < 25 then -- phase starts at 20
		self:Message(-5759, "Positive", "Info", CL["soon"]:format(self:SpellName(-5759)))
		self:UnregisterUnitEvent("UNIT_HEALTH_FREQUENT", unitId)
	end
end

function mod:Frenzy()
	self:Sync("Frenzy")
end

