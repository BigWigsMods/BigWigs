if not GetNumGroupMembers then return end
--[[ TO DO

might want to try and report people with debuff closest to totem when it is about to die
sync the voodoo dolls, or maybe have a bar with the 3 names on it like Dolls: Pupper, Master, String

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
		122151, 116174, "ej:5759", 116272, 116161,
		"berserk", "bosskill",
	}, {
		[122151] = CL["phase"]:format(1),
		["ej:5759"] = CL["phase"]:format(2),
		berserk = "general",
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "VoodooDollsApplied", 122151)
	self:Log("SPELL_CAST_SUCCESS", "SpiritTotem", 116174)
	self:Log("SPELL_CAST_SUCCESS", "Banishment", 116272)
	self:Log("SPELL_AURA_APPLIED", "CrossedOver", 116161)

	self:AddSyncListener("VoodooDolls")

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Death("Win", 60143)
end

function mod:OnEngage(diff)
	self:Bar(116174, spiritTotem, 40, 116174)
	self:Berserk(480) -- assume
	self:RegisterEvent("UNIT_HEALTH_FREQUENT")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:OnSync(sync, rest, nick)
	if sync == "VoodooDolls" and rest then
		for player in string.gmatch(rest, "%a+") do
			voodooDollList[#voodooDollList+1] = player
		end
		self:TargetMessage(122151, voodooDoll, voodooDollList, "Important", 122151)
	end
end

do
	local scheduled = nil
	local listTbl = {}
	local function createList(spellName)
		local playerString = table.concat(listTbl, ", ")
		mod:Sync("VoodooDolls", playerString)
		wipe(listTbl)
		scheduled = nil
	end
	function mod:VoodooDollsApplied(player, _, _, _, spellName)
		listTbl[#listTbl+1] = player
		if not scheduled then
			scheduled = true
			self:ScheduleTimer(createList, 0.1, spellName)
		end
	end
end

function mod:CrossedOver(player, _, _, _, spellName)
	if UnitIsUnit("player", player) then
		self:Bar(116161, spellName, 30, 116161)
	end
end

function mod:SpiritTotem(_, _, _, _, spellName)
	self:Bar(116174, spellName, 36, 116174)
	self:Message(116174, spellName, "Attention", 116174)
end

function mod:Banishment(player, _, _, _, spellName)
	-- maybe this should be a tank only warning
	if UnitIsUnit("player", player) then
		self:Bar(116272, spellName, 30, 116272) -- this is rather soul sever, but not sure if timer starts exactly when banishment starts
	end
	self:TargetMessage(116272, spellName, player, "Urgent", 116272)  -- maybe this should be just :Message with a sound, so the other tank gets sound notification too
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

