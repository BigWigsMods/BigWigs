--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Razorscale", "Ulduar")
if not mod then return end
--[[
	33287 = Expedition Engineer
	33816 = Expedition Defender
	33210 = Expidition Commander
	33186 = Razorscale
--]]
mod:RegisterEnableMob(33186, 33210, 33816, 33287)
mod.toggleOptions = {"phase", 64021, {64704, "FLASHSHAKE"}, "harpoon", "berserk", "bosskill"}

--------------------------------------------------------------------------------
-- Locals
--

local p2 = nil
local started = nil
local count = 0
local totalHarpoons = 4
local phase = nil

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.phase = "Phases"
	L.phase_desc = "Warn when Razorscale switches between phases."
	L.ground_trigger = "Move quickly! She won't remain grounded for long!"
	L.ground_message = "Razorscale Chained up!"
	L.air_trigger = "Give us a moment to prepare to build the turrets."
	L.air_trigger2 = "Fires out! Let's rebuild those turrets!"
	L.air_message = "Takeoff!"
	L.phase2_trigger = "%s grounded permanently!"
	L.phase2_message = "Phase 2!"
	L.phase2_warning = "Phase 2 Soon!"
	L.stun_bar = "Stun"

	L.breath_trigger = "%s takes a deep breath..."
	L.breath_message = "Flame Breath!"
	L.breath_bar = "~Breath Cooldown"

	L.flame_message = "Flame on YOU!"

	L.harpoon = "Harpoons"
	L.harpoon_desc = "Announce when the harpoons are ready for use."
	L.harpoon_message = "Harpoon %d ready!"
	L.harpoon_trigger = "Harpoon Turret is ready for use!"
	L.harpoon_nextbar = "Harpoon %d"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	self:Log("SPELL_DAMAGE", "Flame", 64704, 64733)
	self:Death("Win", 33186)

	self:Emote("Phase2", L["phase2_trigger"])
	self:Emote("Breath", L["breath_trigger"])
	self:Emote("Harpoon", L["harpoon_trigger"])

	self:Yell("Grounded", L["ground_trigger"])
	self:Yell("Airphase", L["air_trigger"])
	self:Yell("Airphase10", L["air_trigger2"])

	self:RegisterEvent("UNIT_HEALTH")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	totalHarpoons = GetRaidDifficulty() == 1 and 2 or 4
	started = nil
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Flame(player)
	if UnitIsUnit(player, "player") then
		self:LocalMessage(64704, L["flame_message"], "Personal", 64733, "Alarm")
		self:FlashShake(64704)
	end
end

function mod:UNIT_HEALTH(event, msg)
	if UnitName(msg) == self.displayName then
		local hp = UnitHealth(msg) / UnitHealthMax(msg) * 100
		if hp > 51 and hp <= 55 and not p2 then
			self:Message("phase", L["phase2_warning"], "Positive")
			p2 = true
		elseif hp > 70 and p2 then
			p2 = nil
		end
	end
end

function mod:Phase2()
	phase = 2
	self:SendMessage("BigWigs_StopBar", self, L["stun_bar"])
	self:Message("phase", L["phase2_message"], "Attention")
end

function mod:Breath()
	self:Message(64021, L["breath_message"], "Attention", 64021)
	if phase == 2 then
		self:Bar(64021, L["breath_bar"], 21, 64021)
	end
end

function mod:Harpoon()
	count = count + 1
	self:Message("harpoon", L["harpoon_message"]:format(count), "Attention", "Interface\\Icons\\INV_Spear_06")
	if count < totalHarpoons then
		self:Bar("harpoon", L["harpoon_nextbar"]:format(count+1), 18, "INV_Spear_06")
	end
end

function mod:Grounded()
	self:Message("phase", L["ground_message"], "Attention", nil, "Long")
	self:Bar("phase", L["stun_bar"], 38, 20170) --20170, looks like a stun :p
	count = 0
end

function mod:Airphase()
	p2 = nil
	count = 0
	self:Bar("harpoon", L["harpoon_nextbar"]:format(1), 55, "INV_Spear_06")
	if not started then
		self:Engage()
		self:Berserk(900)
		started = true
		phase = 1
	else
		self:SendMessage("BigWigs_StopBar", self, L["stun_bar"])
		self:Message("phase", L["air_message"], "Attention", nil, "Info")
	end
end

-- for 10man, has a different yell, and different timing <.<
-- it happens alot later then the 25m yell, so a "Takeoff" warning isn't really appropriate anymore.
-- just a bar for the next harpoon
function mod:Airphase10()
	p2 = nil
	count = 0
	self:Bar("harpoon", L["harpoon_nextbar"]:format(1), 22, "INV_Spear_06")
	self:SendMessage("BigWigs_StopBar", self, L["stun_bar"])
	--self:Message(L["air_message"], "Attention", nil, "Info")
end

