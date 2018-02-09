
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Antorus Trash", nil, nil, 1712)
if not mod then return end
mod.displayName = CL.trash
mod:RegisterEnableMob(
	-- [[ Before Antoran High Command ]] --
	127233, -- Flameweaver
	127723, -- Imperator Deconix
	127732, -- Clobex

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
	-- [[ Before Antoran High Command ]] --
	L.flameweaver = "Flameweaver"
	L.deconix = "Imperator Deconix"
	L.clobex = "Clobex"

	L.isLinkedWith = "%s is linked with %s"
	L.yourLink = "You are linked with %s"

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
		-- [[ Before Antoran High Command ]] --
		252621, -- Bound by Fel
		254500, -- Fearsome Leap
		{253600, "SAY"}, -- Soulburn

		-- [[ Imonar to Kin'garoth ]] --
		{252760, "SAY"}, -- Demolish

		-- [[ Before Varimathras / Coven of Shivarra ]] --
		{249297, "SAY"}, -- Flames of Reorigination
		{254122, "SAY"}, -- Cloud of Confusion

		-- [[ Before Aggramar ]] --
		246209, -- Punishing Flame
	}, {
		[252621] = L.flameweaver,
		[254500] = L.deconix,
		[253600] = L.clobex,
		[252760] = -16145, -- Garothi Demolisher
		[249297] = L.tarneth,
		[254122] = L.priestess,
		[246209] = L.aedis,
	}
end

function mod:OnBossEnable()
	--[[ General ]]--
	self:RegisterMessage("BigWigs_OnBossEngage", "Disable")

	-- [[ Before Antoran High Command ]] --
	self:Log("SPELL_AURA_APPLIED", "BoundByFel", 252621)
	self:Log("SPELL_CAST_START", "FearsomeLeap", 254500)
	self:Log("SPELL_AURA_APPLIED", "Soulburn", 253600)
	self:Log("SPELL_AURA_REMOVED", "SoulburnRemoved", 253600)

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

-- [[ Before Antoran High Command ]] --
do
	local targets = {}

	local function printTargets(self, spellId)
		if #targets == 2 then
			if self:Me(targets[1].guid) then
				self:Message(spellId, "Personal", "Warning", L.yourLink:format(self:ColorName(targets[2].name)))
			elseif self:Me(targets[2].guid) then
				self:Message(spellId, "Personal", "Warning", L.yourLink:format(self:ColorName(targets[1].name)))
			elseif not self:CheckOption(args.spellId, "ME_ONLY") then
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

function mod:FearsomeLeap(args)
	self:Message(args.spellId, "Important", self:Melee() and "Warning" or "Long", CL.casting:format(args.spellName))
	self:CastBar(args.spellId, 3)
end

do
	local expires = 0
	function mod:Soulburn(args)
		if self:Me(args.destGUID) then
			self:Say(args.spellId)
			self:SayCountdown(args.spellId, 6)
			expires = GetTime() + 6
		end
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.3, args.spellId, list, "Urgent", "Warning", nil, nil, self:Dispeller("magic"))
		end
	end
	function mod:SoulburnRemoved(args)
		if self:Me(args.destGUID) and expires - GetTime() > 1 then -- dispelled
			self:CancelSayCountdown(args.spellId)
			self:Message(args.spellId, "Positive", "Info", CL.removed(args.spellName))
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
function mod:FlamesOfReorigination(args)
	if self:Me(args.destGUID) then
		self:Say(args.spellId)
		self:Message(args.spellId, "Personal", "Warning", CL.you(args.spellName))
	elseif self:MobId(args.sourceGUID) == 123533 then -- don't announce those that were spread by players
		self:TargetMessage(args.spellId, args.destName, "Important", nil)
	end
end

function mod:CloudOfConfusion(args)
	if self:Me(args.destGUID) then
		self:Say(args.spellId)
	end
	self:TargetMessage(args.spellId, args.destName, "Urgent", "Warning")
end

-- [[ Before Aggramar ]] --
function mod:PunishingFlames(args)
	self:Message(args.spellId, "Attention", "Long", CL.casting:format(args.spellName))
	self:CastBar(args.spellId, 5)
end
