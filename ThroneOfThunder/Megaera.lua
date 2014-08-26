
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Megaera", 930, 821)
if not mod then return end
mod:RegisterEnableMob(70248, 70212, 70235, 70247, 68065) -- Arcane Head, Flaming Head, Frozen Head, Venomous Head, Megaera

--------------------------------------------------------------------------------
-- Locals
--
local breathCounter, headCounter = 0, 0
local deadHeads, cindersCounter, torrentCounter, netherCounter, acidRainCounter = 0, 1, 1, 1, 1

-- ability timers for specific kill orders. wtb blizzard maths ;[
-- (need transcripts for torrent times, no CLEU entries)
-- 1 = green, 2 = blue, 3 = red, 4 = purple
local timers_normal = {
	[0] = { -- [0]
		[139822] = {28, 25, 25}, -- cinders
	},

	--grgr
	[1] = {	 -- [1] g
		[139850] = {45, 12, 12}, -- acid rain
	},
	[31] = { -- [2] gr
		[139822] = {38, 25, 25, 25, 25}, -- cinders
		[139850] = {49, 27}, -- acid rain
	},
	[131] = { -- [3] grg
		[139822] = {35, 30, 30}, -- cinders
		[139850] = {46, 7, 7, 14}, -- acid rain
	},
	[3131] = { -- [4] grgr
		[139822] = {34, 10, 15, 10}, -- cinders
		[139850] = {42, 10, 15, 10}, -- acid rain
	},
	--grgrgr
	[13131] = { -- [5] grgrg
		[139822] = {34, 10, 10, 10} ,-- cinders
		[139850] = {42, 10, 5, 5, 10, 10, 5}, -- acid rain
	},
	[313131] = { -- [6] grgrgr
		[139822] = {33, 12, 8, 4, 4, 12}, -- cinders
		[139850] = {40, 8, 7, 12, 8}, -- acid rain
	},
	--grgrbr
	[23131] = { -- [5] grgrb
		[139822] = {34, 30, 30}, -- cinders
		[139857] = {41, 14, 14, 14}, -- torrent
		[139850] = {47, 14, 16 }, -- acid rain
	},
	[323131] = { -- [6] grgrbr
		[139822] = {32, 12, 8, 8, 12}, -- cinders
		[139857] = {33, 27, 27, 27}, -- torrent
		[139850] = {44, 8, 19}, -- acid rain
	},

	--brg
	[2] = { -- [1] b
		[139857] = {39.5, 13, 13}, -- torrent
	},
	[32] = { -- [2] br
		[139822] = {38, 18, 9, 18, 9}, -- cinders
		[139857] = {44, 27, 27}, -- torrent
	},
	[132] = { -- [3] brg
		[139822] = {36, 28}, -- cinders
		[139857] = {40, 18}, -- torrent
		[139850] = {54, 7}, -- acid rain
	},
	--brgrbr
	[3132] = { -- [4] brgr
		[139822] = {34, 15, 5, 5, 15, 5}, -- cinders
		[139857] = {36, 25, 25}, -- torrent
		--[139850] = {}, -- acid rain
	},
	[23132] = { -- [5] brgrb
		[139822] = {34, 15, 15, 15} ,-- cinders
		[139857] = {36, 15, 5, 11, 15}, -- torrent
		--[139850] = {}, -- acid rain
	},
	[323132] = { -- [6] brgrbr
		[139822] = {33, 12, 8, 4, 4, 12}, -- cinders
		[139857] = {35, 12, 16, 12}, -- torrent
		--[139850] = {}, -- acid rain
	},
	--brgbrg
	[2132] = { -- [4] brgb
		[139822] = {34, 25, 25}, -- cinders
		--[139857] = {36, 25, 25}, -- torrent
		[139850] = {46, 25}, -- acid rain
	},
	[32132] = { -- [5] brgbr
		[139822] = {34, 15, 10, 5} ,-- cinders
		--[139857] = {36, 15, 5, 11, 15}, -- torrent
		[139850] = {47, }, -- acid rain
	},
	[132132] = { -- [6] brgbrg
		[139822] = {33, 12, 16, 12, 15, 12}, -- cinders
		--[139857] = {35, 12, 16, 12}, -- torrent
		[139850] = {44, 12, 4.5, 11, 12, 4.5}, -- acid rain
	},
}
local timers_heroic = {
	[0] = { -- [0]
		[139822] = {16, 26, 26, 26}, -- cinders
		[140138] = {26, 26, 26, 26}, -- nether
	},

	--brpbrp
	[2] = {  -- [1] b
		[139857] = {35, 18, 9, 18, 9}, -- torrent
		[140138] = {44, 27, 27}, -- nether
	},
	[32] = {  -- [2] br
		[139822] = {35, 14, 14, 14, 14}, -- cinders
		[139857] = {41, 14, 14, 14, 14}, -- torrent
	},
	[432] = { -- [3] brp
		[139822] = {34, 15, 10, 15, 10, 15}, -- cinders
		[139857] = {37, 14, 14, 14, 14}, -- torrent
		[140138] = {42, 10, 15, 10, 15}, -- nether
	},
	[2432] = { -- [4] brpb
		[139822] = {34, 30, 30}, -- cinders
		[139857] = {36, 10, 10, 10, 10, 10, 10}, -- torrent
		[140138] = {41, 10, 20, 10, 20}, -- nether
	},
	[32432] = { -- [5] brpbr
		[139822] = {32, 12, 8, 8, 12, 8, 12}, -- cinders
		[139857] = {34, 12, 8, 12, 8, 12, 8, 12}, -- torrent
		[140138] = {38, 27, 27, 27}, -- nether
	},
	[432432] = { -- [6] brpbrp
		[139822] = {33, 12, 12, 8, 12, 12, 8}, -- cinders
		[139857] = {35, 12, 19, 12, 19}, -- torrent
		[140138] = {38, 12, 8, 12, 12, 10}, -- nether
	},
}
local timers = {}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.breaths = "Breaths"
	L.breaths_desc = "Warnings related to all the different types of breaths."
	L.breaths_icon = 105050

	L.arcane_adds = "Arcane adds"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		140138, 140179, {139993, "HEALER"},
		{139822, "FLASH", "ICON", "SAY"}, {137731, "HEALER"},
		{139866, "FLASH", "ICON", "SAY"}, {139909, "FLASH"}, {139843, "TANK"},
		{139840, "HEALER"}, 139850,
		139458, {"breaths", "FLASH"}, "proximity", "berserk", "bosskill",
	}, {
		[140138] = ("%s (%s)"):format(mod:SpellName(-7005), CL["heroic"]), -- Arcane Head
		[139822] = -6998, -- Fire Head
		[139866] = -7002, -- Frost Head
		[139840] = -7004, -- Poison Head
		[139458] = "general",
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	-- Arcane
	self:Log("SPELL_AURA_APPLIED", "Suppression", 140179)
	self:Log("SPELL_CAST_SUCCESS", "NetherTear", 140138)
	-- Frost
	self:Log("SPELL_PERIODIC_DAMAGE", "IcyGround", 139909)
	self:Log("SPELL_AURA_APPLIED_DOSE", "ArcticFreeze", 139843)
	-- Fire
	self:Log("SPELL_DAMAGE", "CindersDamage", 139836)
	self:Log("SPELL_MISSED", "CindersDamage", 139836)
	self:Log("SPELL_AURA_APPLIED", "CindersApplied", 139822)
	self:Log("SPELL_AURA_REMOVED", "CindersRemoved", 139822)
	-- Poison
	self:Log("SPELL_DAMAGE", "AcidRainDamage", 139850)
	self:Log("SPELL_MISSED", "AcidRainDamage", 139850)
	-- General
	self:Log("SPELL_DAMAGE", "BreathDamage", 137730, 139842, 139839, 139992)
	self:Log("SPELL_MISSED", "BreathDamage", 137730, 139842, 139839, 139992)
	self:Log("SPELL_CAST_START", "Breaths", 137729, 139841, 139838, 139991)
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "Rampage", "boss1")
	self:Log("SPELL_AURA_APPLIED", "TankDebuffApplied", 137731, 139840, 139993) -- Ignite Flesh, Rot Armor, Diffusion
	self:Log("SPELL_AURA_APPLIED_DOSE", "TankDebuffApplied", 137731, 139840, 139993)
	self:Log("SPELL_AURA_REMOVED", "TankDebuffRemoved", 137731, 139840, 139993)

	self:Death("Deaths", 70248, 70212, 70235, 70247) -- Arcane Head, Flaming Head, Frozen Head, Venomous Head
	self:Death("Win", 68065) -- Megaera
end

function mod:OnEngage()
	breathCounter, headCounter = 0, 0
	self:Bar("breaths", 5, L["breaths"], L.breaths_icon)
	self:Message("breaths", "Attention", nil, CL["custom_start_s"]:format(self.displayName, L["breaths"], 5), false)

	deadHeads, cindersCounter, torrentCounter, netherCounter, acidRainCounter = 0, 1, 1, 1, 1
	timers = self:Heroic() and timers_heroic or not self:LFR() and timers_normal or {}
	local t = timers[deadHeads]
	if t then
		for spellId, v in next, t do
			self:Bar(spellId, v[1])
		end
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

--------------------------------------------------------------------------------
-- General
--

function mod:TankDebuffApplied(args)
	if self:Tank(args.destName) then
		self:TargetBar(args.spellId, 45, args.destName)
	end
end

function mod:TankDebuffRemoved(args)
	self:StopBar(args.spellId, args.destName)
end

do
	local prev = 0
	function mod:Breaths(args)
		local t = GetTime()
		if t-prev > 6 then
			prev = t
			breathCounter = breathCounter + 1
			self:Message("breaths", "Attention", nil, CL["count"]:format(L["breaths"], breathCounter), L.breaths_icon) -- neutral breath icon
			self:Bar("breaths", 16.5, L["breaths"], L.breaths_icon)
		end
	end
end

do
	local prev = 0
	function mod:BreathDamage(args)
		if not self:Me(args.destGUID) or self:Tank() then return end
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:Message("breaths", "Personal", "Info", CL["you"]:format(args.spellName), args.spellId)
			self:Flash("breaths", args.spellId)
		end
	end
end

do
	local function rampageOver(spellId, spellName)
		mod:Message(spellId, "Positive", nil, CL["over"]:format(spellName))
		if not mod:LFR() and tostring(deadHeads):find("[23]") then
			mod:OpenProximity("proximity", 5)
		end
		if tostring(deadHeads):find("2", nil, true) then
			mod:RegisterEvent("UNIT_AURA")
		end
	end
	function mod:Rampage(unit, spellName, _, _, spellId)
		if spellId == 139458 then
			self:UnregisterEvent("UNIT_AURA")
			self:Bar("breaths", 30, L["breaths"], L.breaths_icon)
			self:Message(spellId, "Important", "Long", CL["count"]:format(spellName, headCounter))
			self:Bar(spellId, 20, CL["count"]:format(spellName, headCounter))
			self:ScheduleTimer(rampageOver, 20, spellId, spellName)
			breathCounter = 0

			cindersCounter, torrentCounter, netherCounter, acidRainCounter = 1, 1, 1, 1
			self:StopBar(139822) -- cinders
			self:StopBar(139866) -- torrent
			self:StopBar(140138) -- nether
			self:StopBar(139850) -- acid rain
			local t = timers[deadHeads]
			if t then
				for spellId, v in next, t do
					-- time-5 because moved from :Deaths due to late torrent and poison overwriting timers
					if spellId == 139850 then
						self:CDBar(spellId, v[1] - 5) -- travel distance
					else
						self:Bar(spellId, v[1] - 5)
					end
				end
			end
		end
	end
end

function mod:Deaths(args)
	local head = 0
	if args.mobId == 70247 then
		head = 1
	elseif args.mobId == 70235 then
		head = 2
	elseif args.mobId == 70212 then
		head = 3
	elseif args.mobId == 70248 then
		head = 4
	end
	deadHeads = deadHeads + 10^headCounter * head
	headCounter = headCounter + 1

	self:CloseProximity("proximity")
	self:StopBar(L["breaths"])
	self:Message(139458, "Attention", nil, CL["soon"]:format(CL["count"]:format(self:SpellName(139458), headCounter))) -- Rampage
	self:Bar(139458, 5, CL["incoming"]:format(self:SpellName(139458)))
end

--------------------------------------------------------------------------------
-- Arcane Head
--

function mod:Suppression(args)
	self:TargetMessage(args.spellId, args.destName, "Urgent")
end

function mod:NetherTear(args)
	self:Message(args.spellId, "Urgent", "Alarm", L["arcane_adds"])
	self:Bar(args.spellId, 6, CL["cast"]:format(L["arcane_adds"])) -- this is to help so you know when all the adds have spawned

	netherCounter = netherCounter + 1
	local t = timers[deadHeads]
	if t and t[args.spellId] and t[args.spellId][netherCounter] then
		self:Bar(args.spellId, t[args.spellId][netherCounter])
	end
end

--------------------------------------------------------------------------------
-- Frost Head
--

do
	local prev = 0
	function mod:IcyGround(args)
		if not self:Me(args.destGUID) then return end
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:Message(args.spellId, "Personal", "Info", CL["underyou"]:format(args.spellName))
			self:Flash(args.spellId)
		end
	end
end

do
	local iceTorrent, torrentList = mod:SpellName(139857), {}
	local UnitDebuff = UnitDebuff
	local function torrentOver(expires)
		torrentList[expires] = nil
		if not next(torrentList) then
			mod:PrimaryIcon(139866)
		end
	end
	function mod:UNIT_AURA(_, unit)
		local _, _, _, _, _, _, expires = UnitDebuff(unit, iceTorrent)
		if expires and not torrentList[expires] then
			local duration = expires - GetTime() -- EJ says 8, spell tooltip says 11
			local player = self:UnitName(unit)
			if UnitIsUnit(unit, "player") then
				self:TargetMessage(139866, player, "Urgent", "Info")
				self:TargetBar(139866, duration , player)
				self:Flash(139866)
				self:Say(139866)
			elseif self:Range(unit) < 6 then
				self:RangeMessage(139866)
				self:Flash(139866)
			else
				self:TargetMessage(139866, player, "Urgent")
			end
			self:PrimaryIcon(139866, player)
			self:ScheduleTimer(torrentOver, duration + 1, expires)
			torrentList[expires] = true

			torrentCounter = torrentCounter + 1
			local t = timers[deadHeads]
			if t and t[139866] and t[139866][torrentCounter] then
				self:Bar(139866, t[139866][torrentCounter])
			end
		end
	end
end

function mod:ArcticFreeze(args)
	if args.amount > 3 then
		self:StackMessage(args.spellId, args.destName, args.amount, "Urgent", "Warning")
	end
end

--------------------------------------------------------------------------------
-- Fire Head
--

do
	local prev = 0
	function mod:CindersDamage(args)
		if not self:Me(args.destGUID) then return end
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:Message(139822, "Personal", "Info", CL["underyou"]:format(args.spellName))
			self:Flash(139822)
		end
	end
end

function mod:CindersApplied(args)
	self:SecondaryIcon(args.spellId, args.destName)
	self:TargetMessage(args.spellId, args.destName, "Important", "Alert", nil, nil, true)
	self:TargetBar(args.spellId, 30, args.destName)
	if self:Me(args.destGUID) then
		self:Flash(args.spellId)
		self:Say(args.spellId)
	end

	cindersCounter = cindersCounter + 1
	local t = timers[deadHeads]
	if t and t[args.spellId] and t[args.spellId][cindersCounter] then
		self:Bar(args.spellId, t[args.spellId][cindersCounter])
	end
end

function mod:CindersRemoved(args)
	self:SecondaryIcon(args.spellId)
	self:StopBar(args.spellId, args.destName)
end

--------------------------------------------------------------------------------
-- Poison Head
--

do
	local prev = 0
	function mod:AcidRainDamage(args)
		local t = GetTime()
		if t-prev > 2 then
			prev = t

			acidRainCounter = acidRainCounter + 1
			local t = timers[deadHeads]
			if t and t[args.spellId] and t[args.spellId][acidRainCounter] then
				self:CDBar(args.spellId, t[args.spellId][acidRainCounter])
			end
		end
	end
end

