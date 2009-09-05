----------------------------------
--      Module Declaration      --
----------------------------------

local boss = BB["Mimiron"]
local mod = BigWigs:NewBoss(boss, "$Revision$")
if not mod then return end
local CL = LibStub("AceLocale-3.0"):GetLocale("BigWigs:Common")
mod.zoneName = BZ["Ulduar"]
mod.enabletrigger = {boss, BB["Leviathan Mk II"], BB["VX-001"], BB["Aerial Command Unit"]}
mod.guid = 33350
--  Leviathan Mk II(33432), VX-001(33651), Aerial Command Unit(33670),
mod.toggleOptions = {62997, 63631, 63274, 64444, 63811, 64623, 64570, "phase", "hardmode", "proximity", "berserk", "bosskill"}
mod.optionHeaders = {
	[62997] = CL.normal,
	[64623] = CL.hard,
	phase = CL.general,
}
mod.proximityCheck = function(unit) return CheckInteractDistance(unit, 3) end
mod.consoleCmd = "Mimiron"

------------------------------
--      Are you local?      --
------------------------------

local db = nil
local phase = nil
local pName = UnitName("player")

----------------------------
--      Localization      --
----------------------------

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Mimiron", "enUS", true)
if L then
	L.phase = "Phases"
	L.phase_desc = "Warn for phase changes."
	L.engage_warning = "Phase 1"
	L.engage_trigger = "^We haven't much time, friends!"
	L.phase2_warning = "Phase 2 incoming"
	L.phase2_trigger = "^WONDERFUL! Positively marvelous results!"
	L.phase3_warning = "Phase 3 incoming"
	L.phase3_trigger = "^Thank you, friends!"
	L.phase4_warning = "Phase 4 incoming"
	L.phase4_trigger = "^Preliminary testing phase complete"
	L.phase_bar = "Phase %d"

	L.hardmode = "Hard mode timer"
	L.hardmode_desc = "Show timer for hard mode."
	L.hardmode_trigger = "^Now, why would you go and do something like that?"
	L.hardmode_message = "Hard mode activated!"
	L.hardmode_warning = "BOOM!"

	L.plasma_warning = "Casting Plasma Blast!"
	L.plasma_soon = "Plasma soon!"
	L.plasma_bar = "Plasma"

	L.shock_next = "Next Shock Blast"

	L.laser_soon = "Spinning up!"
	L.laser_bar = "Barrage"

	L.magnetic_message = "ACU Rooted!"

	L.suppressant_warning = "Suppressant incoming!"

	L.fbomb_soon = "Possible Frost Bomb soon!"
	L.fbomb_bar = "Next Frost Bomb"

	L.bomb_message = "Bomb Bot spawned!"

	L.end_trigger = "^It would appear that I've made a slight miscalculation."
end
L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Mimiron")
mod.locale = L

------------------------------
--      Initialization      --
------------------------------

function mod:OnBossEnable()
	self:AddCombatListener("SPELL_CAST_START", "Plasma", 62997, 64529)
	self:AddCombatListener("SPELL_CAST_START", "Suppressant", 64570)
	self:AddCombatListener("SPELL_CAST_START", "FBomb", 64623)
	self:AddCombatListener("SPELL_CAST_START", "Shock", 63631)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Spinning", 63414)
	--self:AddCombatListener("SPELL_AURA_APPLIED", "Shell", 63666, 65026)
	self:AddCombatListener("SPELL_SUMMON", "Magnetic", 64444)
	self:AddCombatListener("SPELL_SUMMON", "Bomb", 63811)
	self:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("CHAT_MSG_LOOT")
	self:RegisterEvent("BigWigs_RecvSync")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:Throttle(2, "MimiLoot")
	self:Throttle(10, "MimiBarrage")
	db = self.db.profile
end

function mod:VerifyEnable(unit)
	return (UnitIsEnemy(unit, "player") and UnitCanAttack(unit, "player")) and true or false
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Bomb(_, spellId, _, _, spellName)
	self:IfMessage(L["bomb_message"], "Important", 63811, "Alert")
end

function mod:Suppressant(_, spellId, _, _, spellName)
	self:IfMessage(L["suppressant_warning"], "Important", spellId)
	self:Bar(spellName, 3, spellId)
end

function mod:FBomb(_, spellId, _, _, spellName)
	self:IfMessage(spellName, "Important", spellId)
	self:Bar(spellName, 2, spellId)
	self:Bar(L["fbomb_bar"], 30, spellId)
	self:ScheduleEvent("fbombWarning", "BigWigs_Message", 28, L["fbomb_soon"], "Attention")
end

function mod:Plasma(_, spellId, _, _, spellName)
	self:IfMessage(L["plasma_warning"], "Important", spellId)
	self:Bar(L["plasma_warning"], 3, spellId)
	self:Bar(L["plasma_bar"], 30, spellId)
	self:ScheduleEvent("plasmaWarning", "BigWigs_Message", 27, L["plasma_soon"], "Attention")
end

function mod:Shock(_, spellId, _, _, spellName)
	self:IfMessage(spellName, "Important", spellId)
	self:Bar(spellName, 3.5, spellId)
	self:Bar(L["shock_next"], 34, spellId)
end

function mod:Spinning(_, spellId)
	if self:GetOption(63274) then
		self:IfMessage(L["laser_soon"], "Personal", spellId, "Long")
	end
end

do
	local laser = GetSpellInfo(63274)
	function mod:UNIT_SPELLCAST_CHANNEL_START(unit, spell)
		if spell == laser then
			self:Sync("MimiBarrage")
		end
	end
end

function mod:Magnetic(_, spellId, _, _, spellName)
	self:IfMessage(L["magnetic_message"], "Important", spellId)
	self:Bar(spellName, 15, spellId)
end

local function start()
	ishardmode = nil
	phase = 1
	if db.phase then
		mod:IfMessage(L["engage_warning"], "Attention")
		mod:Bar(L["phase_bar"]:format(phase), 7, "INV_Gizmo_01")
	end
	if mod:GetOption(63631) then
		mod:Bar(L["shock_next"], 30, 63631)
	end
	if mod:GetOption(62997) then
		mod:Bar(L["plasma_bar"], 20, 62997)
		mod:DelayedMessage(17, L["plasma_soon"], "Attention")
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg:find(L["hardmode_trigger"]) then
		start()
		ishardmode = true
		if db.hardmode then
			self:Bar(L["hardmode"], 600, 64582)
			self:IfMessage(L["hardmode_message"], "Attention", 64582)
			self:DelayedMessage(600, L["hardmode_warning"], "Important")
		end
		self:TriggerEvent("BigWigs_ShowProximity", self)
	elseif msg:find(L["engage_trigger"]) then
		start()
		if db.berserk then
			self:Enrage(900, true, true)
		end
	elseif msg:find(L["phase2_trigger"]) then
		phase = 2
		self:CancelScheduledEvent("plasmaWarning")
		self:TriggerEvent("BigWigs_StopBar", L["plasma_bar"])
		self:TriggerEvent("BigWigs_StopBar", L["shock_next"])
		if db.phase then
			self:IfMessage(L["phase2_warning"], "Attention")
			self:Bar(L["phase_bar"]:format(phase), 40, "INV_Gizmo_01")
		end
		if self:GetOption(64623) and ishardmode then
			self:Bar(L["fbomb_bar"], 45, 64623)
		end
		self:TriggerEvent("BigWigs_HideProximity", self)
	elseif msg:find(L["phase3_trigger"]) then
		self:CancelScheduledEvent("fbombWarning")
		phase = 3
		if db.phase then
			self:IfMessage(L["phase3_warning"], "Attention")
			self:Bar(L["phase_bar"]:format(phase), 25, "INV_Gizmo_01")
		end
	elseif msg:find(L["phase4_trigger"]) then
		phase = 4
		if db.phase then
			self:IfMessage(L["phase4_warning"], "Attention")
			self:Bar(L["phase_bar"]:format(phase), 25, "INV_Gizmo_01")
		end
		if self:GetOption(64623) and ishardmode then
			self:Bar(L["fbomb_bar"], 30, 64623)
		end
		if self:GetOption(63631) then
			self:Bar(L["shock_next"], 48, 63631)
		end
	elseif msg:find(L["end_trigger"]) then
		self:BossDeath(nil, self.guid)
	end
end

do
	local lootItem = '^' .. LOOT_ITEM:gsub("%%s", "(.-)") .. '$'
	local lootItemSelf = '^' .. LOOT_ITEM_SELF:gsub("%%s", "(.*)") .. '$'
	function mod:CHAT_MSG_LOOT(msg)
		local player, item = select(3, msg:find(lootItem))
		if not player then
			item = select(3, msg:find(lootItemSelf))
			if item then
				player = pName
			end
		end

		if type(item) == "string" and type(player) == "string" then
			local itemLink, itemRarity = select(2, GetItemInfo(item))
			if itemRarity and itemRarity == 1 and itemLink then
				local itemId = select(3, itemLink:find("item:(%d+):"))
				if not itemId then return end
				itemId = tonumber(itemId:trim())
				if type(itemId) ~= "number" or itemId ~= 46029 then return end
				self:Sync("MimiLoot", player)
			end
		end
	end
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if sync == "MimiLoot" and rest and self:GetOption(64444) then
		self:TargetMessage(GetSpellInfo(64444), rest, "Positive", "Interface\\Icons\\INV_Gizmo_KhoriumPowerCore", "Info")
	elseif sync == "MimiBarrage" and self:GetOption(63274) then
		self:IfMessage(L["laser_bar"], "Important", 63274)
		self:Bar(L["laser_bar"], 60, 63274)
	end
end

