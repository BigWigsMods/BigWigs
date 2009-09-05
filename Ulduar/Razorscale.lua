----------------------------------
--      Module Declaration      --
----------------------------------

local boss = "Razorscale"

local mod = BigWigs:NewBoss(boss, "$Revision$")
if not mod then return end
mod.displayName = "Razorscale"
-- mod.bossName set below localization
mod.zoneName = "Ulduar"
--[[
	33233 = Razorscale Controller
	33210 = Expidition Commander
	33185 = Razorscale
--]]
mod.enabletrigger = {33185, 33210, 33233}
mod.guid = 33186
mod.toggleOptions = {"phase", 64021, 64704, "harpoon", "berserk", "bosskill"}
mod.consoleCmd = "Razorscale"

------------------------------
--      Are you local?      --
------------------------------

local db = nil
local p2 = nil
local pName = UnitName("player")
local started = nil
local count = 0
local totalHarpoons = 4
local phase = nil

----------------------------
--      Localization      --
----------------------------

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Razorscale", "enUS", true)
if L then
	-- <nevcairiel> at least in german, the "Controller" isnt translated, so its "<boss> Controller"
	-- <nevcairiel> in ruRU the whole thing isnt localized
	-- <nevcairiel> in french they translated the whole thing, ha
	-- XXX So translators make sure that the Razorscale Controller is actually
	-- translated in your language before adding it to your locale below.
	L["Razorscale Controller"] = true

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
L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Razorscale")
mod.locale = L

------------------------------
--      Initialization      --
------------------------------

mod.bossName = { boss, "Expedition Commander", L["Razorscale Controller"]}

function mod:OnRegister()
	boss = mod.bossName[1]
end

function mod:OnBossEnable()
	self:AddCombatListener("SPELL_DAMAGE", "Flame", 64704, 64733)
	self:AddCombatListener("UNIT_DIED", "BossDeath")

	self:RegisterEvent("UNIT_HEALTH")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	totalHarpoons = GetRaidDifficulty() == 1 and 2 or 4
	db = self.db.profile
	started = nil
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Flame(player)
	if player == pName then
		self:LocalMessage(L["flame_message"], "Personal", 64733, "Alarm")
	end
end

function mod:UNIT_HEALTH(event, msg)
	if not db.phase then return end
	if UnitName(msg) == razorscale then
		local hp = UnitHealth(msg)
		if hp > 51 and hp <= 55 and not p2 then
			self:IfMessage(L["phase2_warning"], "Positive")
			p2 = true
		elseif hp > 70 and p2 then
			p2 = nil
		end
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(event, msg)
	if msg == L["phase2_trigger"] and db.phase then
		phase = 2
		self:SendMessage("BigWigs_StopBar", self, L["stun_bar"])
		self:IfMessage(L["phase2_message"], "Attention")
	elseif msg == L["breath_trigger"] and self:GetOption(64021) then
		self:IfMessage(L["breath_message"], "Attention", 64021)
		if phase == 2 then
			self:Bar(L["breath_bar"], 21, 64021)
		end
	elseif msg == L["harpoon_trigger"] and db.harpoon then
		count = count + 1
		self:IfMessage(L["harpoon_message"]:format(count), "Attention", "Interface\\Icons\\INV_Spear_06")
		if count < totalHarpoons then
			self:Bar(L["harpoon_nextbar"]:format(count+1), 18, "INV_Spear_06")
		end
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L["ground_trigger"] then
		if db.phase then
			self:IfMessage(L["ground_message"], "Attention", nil, "Long")
			self:Bar(L["stun_bar"], 38, 20170) --20170, looks like a stun :p
		end
		count = 0
	elseif msg == L["air_trigger"] then
		p2 = nil
		count = 0
		if db.harpoon then
			self:Bar(L["harpoon_nextbar"]:format(1), 55, "INV_Spear_06")
		end
		if not started then
			if db.berserk then
				self:Enrage(900, true)
			end
			started = true
			phase = 1
		else
			self:SendMessage("BigWigs_StopBar", self, L["stun_bar"])
			if db.phase then
				self:IfMessage(L["air_message"], "Attention", nil, "Info")
			end
		end
	-- for 10man, has a different yell, and different timing <.<
	-- it happens alot later then the 25m yell, so a "Takeoff" warning isn't really appropriate anymore.
	-- just a bar for the next harpoon
	elseif msg == L["air_trigger2"] then
		p2 = nil
		count = 0
		if db.harpoon then
			self:Bar(L["harpoon_nextbar"]:format(1), 22, "INV_Spear_06")
		end
		self:SendMessage("BigWigs_StopBar", self, L["stun_bar"])
		--self:IfMessage(L["air_message"], "Attention", nil, "Info")
	end
end

