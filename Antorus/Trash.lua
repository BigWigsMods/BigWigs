
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Antorus Trash", nil, nil, 1712)
if not mod then return end
mod.displayName = CL.trash
mod:RegisterEnableMob(
	-- [[ Before Garothi Worldbreaker ]] --
	123478, -- Antoran Felguard

	-- [[ After Garothi Worldbreaker ]] --
	127233, -- Flameweaver

	-- [[ Before Antoran High Command ]] --
	126764, -- Bladesworn Ravager
	127723, -- Imperator Deconix
	127732, -- Clobex

	-- [[ Before Portal Keeper Hasabel ]] --
	125549, -- Hungering Stalker

	-- [[ Imonar to Kin'garoth ]] --
	127235, -- Garothi Demolisher

	-- [[ Before Varimathras / Coven of Shivarra ]] --
	123533, -- Tarneth
	128060, -- Priestess of Delirium

	-- [[ Before Aggramar ]] --
	123680 -- Dark Keeper Aedis
)

--------------------------------------------------------------------------------
-- Locals
--

local list = mod:NewTargetList()

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	-- [[ Before Garothi Worldbreaker ]] --
	L.felguard = "Antoran Felguard"

	-- [[ After Garothi Worldbreaker ]] --
	L.flameweaver = "Flameweaver"

	-- [[ Before Antoran High Command ]] --
	L.ravager = "Bladesworn Ravager"
	L.deconix = "Imperator Deconix"
	L.clobex = "Clobex"

	L.isLinkedWith = "%s is linked with %s"
	L.yourLink = "You are linked with %s"

	-- [[ Before Portal Keeper Hasabel ]] --
	L.stalker = "Hungering Stalker"

	-- [[ Before Varimathras / Coven of Shivarra ]] --
	L.tarneth = "Tarneth"
	L.priestess = "Priestess of Delirium"

	-- [[ Before Aggramar ]] --
	L.aedis = "Dark Keeper Aedis"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		-- [[ Before Garothi Worldbreaker ]] --
		245861, -- Searing Rend

		-- [[ After Garothi Worldbreaker ]] --
		{252621, "ME_ONLY"}, -- Bound by Fel

		-- [[ Before Antoran High Command ]] --
		251612, -- Bladestorm (Felsworn Ravager)
		254500, -- Fearsome Leap
		254512, -- Bladestorm (Imperator Deconix)
		{253600, "SAY"}, -- Soulburn

		-- [[ Before Portal Keeper Hasabel ]] --
		249212, -- Howling Shadows

		-- [[ Imonar to Kin'garoth ]] --
		{252760, "SAY"}, -- Demolish

		-- [[ Before Varimathras / Coven of Shivarra ]] --
		{249297, "SAY"}, -- Flames of Reorigination
		{254122, "SAY"}, -- Cloud of Confusion

		-- [[ Before Aggramar ]] --
		246209, -- Punishing Flame
		246199, -- Burning Winds
	}, {
		[245861] = L.felguard,
		[252621] = L.flameweaver,
		[251612] = L.ravager,
		[254500] = L.deconix,
		[253600] = L.clobex,
		[249212] = L.stalker,
		[252760] = -16145, -- Garothi Demolisher
		[249297] = L.tarneth,
		[254122] = L.priestess,
		[246209] = L.aedis,
	}
end

function mod:OnBossEnable()
	--[[ General ]]--
	self:RegisterMessage("BigWigs_OnBossEngage", "Disable")

	-- Searing Rend, Burning Winds
	self:Log("SPELL_AURA_APPLIED", "GroundEffectDamage", 245861, 246199)
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundEffectDamage", 245861, 246199)
	self:Log("SPELL_PERIODIC_MISSED", "GroundEffectDamage", 245861, 246199)
	-- Bladestorm (Felsworn Ravager, Imperator Deconix)
	self:Log("SPELL_DAMAGE", "GroundEffectDamage", 251612, 254512)
	self:Log("SPELL_MISSED", "GroundEffectDamage", 251612, 254512)

	-- [[ After Garothi Worldbreaker ]] --
	self:Log("SPELL_AURA_APPLIED", "BoundByFel", 252621)

	-- [[ Before Antoran High Command ]] --
	self:Log("SPELL_CAST_START", "FearsomeLeap", 254500)
	self:Log("SPELL_CAST_SUCCESS", "SoulburnCastSuccess", 253599)
	self:Log("SPELL_AURA_APPLIED", "Soulburn", 253600)
	self:Log("SPELL_AURA_REMOVED", "SoulburnRemoved", 253600)

	-- [[ Before Portal Keeper Hasabel ]] --
	self:Log("SPELL_CAST_START", "HowlingShadows", 249212)

	-- [[ Imonar to Kin'garoth ]] --
	self:Log("SPELL_AURA_APPLIED", "Demolish", 252760)

	-- [[ Before Varimathras / Coven of Shivarra ]] --
	self:Log("SPELL_AURA_APPLIED", "FlamesOfReorigination", 249297)
	self:Log("SPELL_AURA_APPLIED", "CloudOfConfusion", 254122)

	-- [[ Before Aggramar ]] --
	self:Log("SPELL_CAST_START", "PunishingFlames", 246209)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

--[[ General ]]--
do
	local prev = 0
	function mod:GroundEffectDamage(args)
		if self:Me(args.destGUID) then
			local t = GetTime()
			if t-prev > 1.5 then
				prev = t
				self:Message(args.spellId, "Personal", "Alert", CL.underyou:format(args.spellName))
			end
		end
	end
end

-- [[ After Garothi Worldbreaker ]] --
do
	local targets = {}

	local function printTargets(self, spellId)
		if #targets == 2 then
			if self:Me(targets[1].guid) then
				self:Message(spellId, "Personal", "Alarm", L.yourLink:format(self:ColorName(targets[2].name)))
			elseif self:Me(targets[2].guid) then
				self:Message(spellId, "Personal", "Alarm", L.yourLink:format(self:ColorName(targets[1].name)))
			elseif not self:CheckOption(spellId, "ME_ONLY") then
				self:Message(spellId, "Attention", nil, L.isLinkedWith:format(self:ColorName(targets[1].name), self:ColorName(targets[2].name)))
			end
		end
		wipe(targets)
	end

	function mod:BoundByFel(args)
		targets[#targets + 1] = { guid = args.destGUID, name = args.destName }
		if #targets == 1 then
			self:ScheduleTimer(printTargets, 0.3, self, args.spellId)
		end
	end
end

-- [[ Before Antoran High Command ]] --
function mod:FearsomeLeap(args)
	self:Message(args.spellId, "Important", self:Melee() and "Warning" or "Long", CL.casting:format(args.spellName))
	self:CastBar(args.spellId, 3)
end

do
	local expiresOnMe, lastCast = 0, 0

	function mod:SoulburnCastSuccess(args)
		lastCast = GetTime()
	end

	function mod:Soulburn(args)
		local appliedByTheBoss = GetTime() - lastCast < 0.3 -- unfortunately sourceGUID can't be used here
		if self:Me(args.destGUID) then
			self:Say(args.spellId)
			self:SayCountdown(args.spellId, 6)
			expiresOnMe = GetTime() + 6
			if not appliedByTheBoss then
				self:Message(args.spellId, "Personal", "Alarm", CL.you:format(args.destName)) -- personal warning regardless of the source
			end
		end
		if appliedByTheBoss then -- don't announce those that were spread by players
			list[#list+1] = args.destName
			if #list == 1 then
				self:ScheduleTimer("TargetMessage", 0.3, args.spellId, list, "Urgent", "Alarm", nil, nil, self:Dispeller("magic"))
			end
		end
	end

	function mod:SoulburnRemoved(args)
		if self:Me(args.destGUID) and expiresOnMe - GetTime() > 1 then -- dispelled
			self:CancelSayCountdown(args.spellId)
			self:Message(args.spellId, "Positive", "Info", CL.removed:format(args.spellName))
		end
	end
end

do
	local prev = 0
	function mod:HowlingShadows(args)
		local t = GetTime()
		if t-prev > 0.5 then
			prev = t
			self:Message(args.spellId, "Important", "Warning", CL.casting:format(args.spellName))
		end
	end
end

-- [[ Imonar to Kin'garoth ]] --
function mod:Demolish(args)
	if self:Me(args.destGUID) then
		self:Say(args.spellId)
		self:SayCountdown(args.spellId, 6)
	end
	list[#list+1] = args.destName
	if #list == 1 then
		self:ScheduleTimer("TargetMessage", 0.3, args.spellId, list, "Urgent", "Warning")
	end
end

-- [[ Before Varimathras / Coven of Shivarra ]] --
do
	local prev = 0
	function mod:FlamesOfReorigination(args)
		if self:Me(args.destGUID) then
			local t = GetTime()
			if t-prev > 6 then -- reapplications fire _APPLIED instead of _REFRESH for some reason
				prev = t
				self:Say(args.spellId)
				self:Message(args.spellId, "Personal", "Warning", CL.you:format(args.spellName))
			end
			self:TargetBar(args.spellId, 6, args.destName)
		elseif self:MobId(args.sourceGUID) == 123533 then -- don't announce those that were spread by players
			self:TargetMessage(args.spellId, args.destName, "Important", nil)
		end
	end
end

function mod:CloudOfConfusion(args)
	if self:Me(args.destGUID) then
		self:Say(args.spellId)
		self:SayCountdown(args.spellId, 6)
	end
	self:TargetBar(args.spellId, 6, args.destName)
	self:TargetMessage(args.spellId, args.destName, "Urgent", "Alarm")
end

-- [[ Before Aggramar ]] --
function mod:PunishingFlames(args)
	self:Message(args.spellId, "Attention", "Long", CL.casting:format(args.spellName))
	self:CastBar(args.spellId, 5)
end
