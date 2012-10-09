--[[ TO DO

might want to try and report people with debuff closest to totem when it is about to die

--]]
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Gara'jal the Spiritbinder", 896, 682)
mod:RegisterEnableMob(60143)

--------------------------------------------------------------------------------
-- Locales
--

local voodooDollList = mod:NewTargetList()
local spiritTotem, voodooDoll = (GetSpellInfo(116174)), (GetSpellInfo(122151))
local totemCounter = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.frenzy = "Frenzy soon!"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		122151, 116174, 116272, 116161,
		"ej:5759",
		"berserk", "bosskill",
	}, {
		[122151] = CL["phase"]:format(1),
		["ej:5759"] = CL["phase"]:format(2),
		berserk = "general",
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "Frenzy", 117752)
	self:Log("SPELL_AURA_APPLIED", "VoodooDollsApplied", 122151)
	self:Log("SPELL_AURA_REMOVED", "VoodooDollsRemoved", 122151) -- Used in 3rd party modules
	self:Log("SPELL_CAST_SUCCESS", "SpiritTotem", 116174)
	self:Log("SPELL_CAST_SUCCESS", "Banishment", 116272)
	self:Log("SPELL_AURA_APPLIED", "CrossedOver", 116161)

	self:AddSyncListener("DollsApplied")
	self:AddSyncListener("DollsRemoved")
	self:AddSyncListener("Totem")

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Death("Win", 60143)
end

function mod:OnEngage()
	totemCounter = 1
	if self:Heroic() then
		self:Bar(116174, spiritTotem, 20, 116174)
	else
		self:Bar(116174, spiritTotem, 36, 116174)
	end
	self:Berserk(360)
	self:RegisterEvent("UNIT_HEALTH_FREQUENT")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:OnSync(sync, rest)
	if sync == "DollsApplied" and rest then
		for player in string.gmatch(rest, "%S+") do
			voodooDollList[#voodooDollList+1] = player
		end
		self:TargetMessage(122151, voodooDoll, voodooDollList, "Important", 122151)
	elseif sync == "Totem" and rest then
		self:Message(116174, ("%s (%d)"):format(rest, totemCounter), "Attention", 116174)
		totemCounter = totemCounter + 1
		if self:Heroic() then
			self:Bar(116174, ("%s (%d)"):format(rest, totemCounter), 20, 116174)
		else
			self:Bar(116174, ("%s (%d)"):format(rest, totemCounter), 36, 116174)
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

function mod:SpiritTotem(_, _, _, _, spellName)
	self:Sync("Totem", spellName)
end

do
	local function fireNext(spellName)
		mod:Bar(116272, spellName, 35, 116272)
	end
	function mod:Banishment(player, spellId, _, _, spellName)
		-- maybe this should be a tank only warning
		if UnitIsUnit("player", player) then
			self:Bar(116272, CL["you"]:format(spellName), 30, spellId) -- this is rather soul sever, but not sure if timer starts exactly when banishment starts
		end
		self:ScheduleTimer(fireNext, 30, spellName)
		self:TargetMessage(116272, spellName, player, "Urgent", spellId)  -- maybe this should be just :Message with a sound, so the other tank gets sound notification too
	end
end

function mod:UNIT_HEALTH_FREQUENT(_, unitId)
	if unitId == "boss1" then
		local hp = UnitHealth(unitId) / UnitHealthMax(unitId) * 100
		if hp < 25 then -- phase starts at 20
			self:Message("ej:5759", L["frenzy"], "Positive", 55663, "Info") -- the corrent icon
			self:UnregisterEvent("UNIT_HEALTH_FREQUENT")
		end
	end
end

function mod:Frenzy()
	self:Message("ej:5759", CL["phase"]:format(2), "Positive", 117752, "Long")
	self:SendMessage("BigWigs_StopBar", self, spiritTotem)
end

