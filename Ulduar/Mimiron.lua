--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Mimiron", "Ulduar")
if not mod then return end
--  Leviathan Mk II(33432), VX-001(33651), Aerial Command Unit(33670),
mod:RegisterEnableMob(33350, 33432, 33651, 33670)
mod.toggleOptions = {62997, 63631, {63274, "FLASHSHAKE"}, 64444, 63811, 64623, 64570, "phase", "proximity", "berserk", "bosskill" }
mod.optionHeaders = {
	[62997] = "normal",
	[64623] = "hard",
	phase = "general",
}

--------------------------------------------------------------------------------
-- Locals
--

local ishardmode = nil
local phase = nil

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
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

	L.hardmode_trigger = "^Now, why would you go and do something like that?"

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
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "Plasma", 62997, 64529)
	self:Log("SPELL_CAST_START", "Suppressant", 64570)
	self:Log("SPELL_CAST_START", "FBomb", 64623)
	self:Log("SPELL_CAST_START", "Shock", 63631)
	self:Log("SPELL_CAST_SUCCESS", "Spinning", 63414)
	self:Log("SPELL_SUMMON", "Magnetic", 64444)
	self:Log("SPELL_SUMMON", "Bomb", 63811)
	self:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("CHAT_MSG_LOOT")
	self:Yell("Yells", L["engage_trigger"], L["hardmode_trigger"], L["phase2_trigger"], L["phase3_trigger"], L["phase4_trigger"])
	self:Yell("Win", L["end_trigger"])
	self:AddSyncListener("MimiLoot")
	self:AddSyncListener("MimiBarrage")
end

function mod:VerifyEnable(unit)
	return (UnitIsEnemy(unit, "player") and UnitCanAttack(unit, "player")) and true or false
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Bomb(_, spellId, _, _, spellName)
	self:Message(63811, L["bomb_message"], "Important", 63811, "Alert")
end

function mod:Suppressant(_, spellId, _, _, spellName)
	self:Message(64570, L["suppressant_warning"], "Important", spellId)
	self:Bar(64570, spellName, 3, spellId)
end

function mod:FBomb(_, spellId, _, _, spellName)
	self:Message(64623, spellName, "Important", spellId)
	self:Bar(64623, spellName, 2, spellId)
	self:Bar(64623, L["fbomb_bar"], 30, spellId)
end

function mod:Plasma(_, spellId, _, _, spellName)
	self:Message(62997, L["plasma_warning"], "Important", spellId)
	self:Bar(62997, L["plasma_warning"], 3, spellId)
	self:Bar(62997, L["plasma_bar"], 30, spellId)
end

function mod:Shock(_, spellId, _, _, spellName)
	self:Message(63631, spellName, "Important", spellId)
	self:Bar(63631, spellName, 3.5, spellId)
	self:Bar(63631, L["shock_next"], 34, spellId)
end

function mod:Spinning(_, spellId)
	self:Message(63274, L["laser_soon"], "Personal", spellId, "Long")
	self:FlashShake(63274)
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
	self:Message(64444, L["magnetic_message"], "Important", spellId)
	self:Bar(64444, spellName, 15, spellId)
end

local function start()
	ishardmode = nil
	phase = 1
	mod:Message("phase", L["engage_warning"], "Attention")
	mod:Bar("phase", L["phase_bar"]:format(phase), 7, "INV_Gizmo_01")

	mod:Bar(63631, L["shock_next"], 30, 63631)
	mod:Bar(62997, L["plasma_bar"], 20, 62997)
	mod:DelayedMessage(62997, 17, L["plasma_soon"], "Attention")
end

function mod:Yells(msg)
	if msg:find(L["hardmode_trigger"]) then
		start()
		ishardmode = true
		self:Berserk(600, true)
		self:OpenProximity(5)
		self:Engage()
	elseif msg:find(L["engage_trigger"]) then
		start()
		self:Berserk(900, true)
		self:Engage()
	elseif msg:find(L["phase2_trigger"]) then
		phase = 2
		self:SendMessage("BigWigs_StopBar", self, L["plasma_bar"])
		self:SendMessage("BigWigs_StopBar", self, L["shock_next"])
		self:Message("phase", L["phase2_warning"], "Attention")
		self:Bar("phase", L["phase_bar"]:format(phase), 40, "INV_Gizmo_01")
		if ishardmode then
			self:Bar(64623, L["fbomb_bar"], 45, 64623)
		end
		self:CloseProximity()
	elseif msg:find(L["phase3_trigger"]) then
		phase = 3
		self:Message("phase", L["phase3_warning"], "Attention")
		self:Bar("phase", L["phase_bar"]:format(phase), 25, "INV_Gizmo_01")
	elseif msg:find(L["phase4_trigger"]) then
		phase = 4
		self:Message("phase", L["phase4_warning"], "Attention")
		self:Bar("phase", L["phase_bar"]:format(phase), 25, "INV_Gizmo_01")
		if ishardmode then
			self:Bar(64623, L["fbomb_bar"], 30, 64623)
		end
		self:Bar(63631, L["shock_next"], 48, 63631)
	end
end

do
	local lootItem = '^' .. LOOT_ITEM:gsub("%%s", "(.-)") .. '$'
	local lootItemSelf = '^' .. LOOT_ITEM_SELF:gsub("%%s", "(.*)") .. '$'
	function mod:CHAT_MSG_LOOT(event, msg)
		local player, item = select(3, msg:find(lootItem))
		if not player then
			item = select(3, msg:find(lootItemSelf))
			if item then
				player = UnitName("player")
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

function mod:OnSync(sync, rest, nick)
	if sync == "MimiLoot" and rest then
		self:TargetMessage(64444, GetSpellInfo(64444), rest, "Positive", "Interface\\Icons\\INV_Gizmo_KhoriumPowerCore", "Info")
	elseif sync == "MimiBarrage" then
		self:Message(63274, L["laser_bar"], "Important", 63274)
		self:Bar(63274, L["laser_bar"], 60, 63274)
	end
end

