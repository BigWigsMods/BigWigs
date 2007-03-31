------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Lady Vashj"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")

local deformat = nil
local checkedForDeformat = nil

local delayedElementalMessage = nil
local delayedStriderMessage = nil

local shieldsFaded = 0
local playerName = nil
local phaseTwoAnnounced = nil

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	deformat = "You need the Deformat-2.0 library in order to get loot warnings in phase 2. You can download it from http://files.wowace.com/Deformat/.",

	["Tainted Elemental"] = true,

	cmd = "Vashj",

	phase = "Phase warnings",
	phase_desc = "Warn when Vashj goes into the different phases.",

	static = "Static Charge",
	static_desc = "Warn about Static Charge on players.",

	icon = "Icon",
	icon_desc = "Put an icon on players with Static Charge and those who loot cores.",

	elemental = "Tainted Elemental spawn",
	elemental_desc = "Warn when the Tainted Elementals spawn during phase 2.",

	strider = "Coilfang Strider spawn",
	strider_desc = "Warn when the Coilfang Striders spawn during phase 2 (timer not checked, could be inaccurate).",

	barrier = "Barrier down",
	barrier_desc = "Alert when the barriers go down.",

	loot = "Tainted Core",
	loot_desc = "Warn who loots the Tainted Cores.",

	static_charge_trigger = "^(%S+) %S+ afflicted by Static Charge.$",
	static_charge_message = "Static Charge on %s!",

	loot_message = "%s looted a core!",

	phase2_trigger = "The time is now! Leave none standing!",

	phase2_soon_message = "Phase 2 soon!",
	phase2_message = "Phase 2, adds incoming!",
	phase3_message = "Phase 3!",

	barrier_down_message = "Barrier %d/4 down!",
	barrier_fades_trigger = "Magic Barrier fades from Lady Vashj.",

	elemental_bar = "Tainted Elemental Incoming",
	elemental_soon_message = "Tainted Elemental soon!",

	strider_bar = "Strider Incoming",
	strider_soon_message = "Strider soon!",
} end )

----------------------------------
--    Module Declaration        --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Coilfang Reservoir"]
mod.otherMenu = "Serpentshrine Cavern"
mod.enabletrigger = boss
mod.toggleoptions = {"phase", -1, "static", "icon", -1, "elemental", "strider", "loot", "barrier", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

--[[

Maybe add in spawn timers in phase 2;

The first Poison Elemental spawns exactly 1min into P2,
and the following Poison Elementals spawn exactly 1min
after the *death* of the previous Poison Elemental.
Problem is that they despawn if not killed within a certain timer, and we can't really catch that.

Coilfang Elites (nagas)  spawn every 50 seconds
Coilfang Striders spawn every 1:03

Also we might need some warnings for phase 3, specifically the Persuasion.

]]

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()

	-- Check if the player has Deformat.
	if not deformat then
		if AceLibrary:HasInstance("Deformat-2.0") then
			deformat = AceLibrary("Deformat-2.0")
		elseif not checkedForDeformat then
			self:ScheduleEvent(function()
				self:Sync("VashjDeformatCheck")
				self:ScheduleEvent("VashjNoDeformat", function()
					BigWigs:Print(L["deformat"])
				end, 5)
			end, 5)
			checkedForDeformat = true
		end
	end

	if deformat then
		self:RegisterEvent("CHAT_MSG_LOOT")
	end

	playerName = UnitName("player")
	phaseTwoAnnounced = nil
	shieldsFaded = 0

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("UNIT_HEALTH")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Charge")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Charge")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Charge")

	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "VashjStatic", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "VashjLoot", 2)
	self:TriggerEvent("BigWigs_ThrottleSync", "VashjDeformatCheck", 0)
	self:TriggerEvent("BigWigs_ThrottleSync", "VashjDeformat", 0)
	self:TriggerEvent("BigWigs_ThrottleSync", "VashjBarrier", 4)
end

------------------------------
--    Event Handlers        --
------------------------------

function mod:CHAT_MSG_LOOT(msg)
	local player, item = deformat(msg, LOOT_ITEM)
	if not player then
		item = deformat(msg, LOOT_ITEM_SELF)
		if item then
			player = playerName
		end
	end

	if type(item) == "string" and type(player) == "string" then
		local itemLink, itemRarity = select(2, GetItemInfo(item))
		if itemRarity and itemRarity == 1 and itemLink then
			local itemId = select(3, itemLink:find("item:(%d+):"))
			if not itemId then return end
			itemId = tonumber(itemId:trim())
			if type(itemId) ~= "number" or itemId ~= 31088 then return end -- Tainted Core
			self:Sync("VashjLoot " .. player)
		end
	end
end

function mod:CHAT_MSG_SPELL_AURA_GONE_OTHER(msg)
	if msg == L["barrier_fades_trigger"] then
		self:Sync("VashjBarrier")
	end
end

local elemDies = UNITDIESOTHER:format(L["Tainted Elemental"])
function mod:CHAT_MSG_COMBAT_HOSTILE_DEATH(msg)
	if msg == elemDies then
		if self.db.profile.elemental then
			self:Bar(L["elemental_bar"], 60, "Spell_Nature_ElementalShields")
			delayedElementalMessage = self:DelayedMessage(55, L["elemental_soon_message"], "Important")
		end
	else
		self:GenericBossDeath(msg)
	end
end

function mod:RepeatStrider()
	if self.db.profile.strider then
		self:Bar(L["strider_bar"], 63, "Spell_Nature_AstralRecal")
		delayedStriderMessage = self:DelayedMessage(58, L["strider_soon_message"], "Attention")
	end
	self:ScheduleEvent("Strider", self.RepeatStrider, 63, self)
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg:find(L["phase2_trigger"]) then
		if self.db.profile.phase then
			self:Message(L["phase2_message"], "Important", nil, "Alarm")
		end
		shieldsFaded = 0
		if self.db.profile.elemental then
			self:Bar(L["elemental_bar"], 60, "Spell_Nature_ElementalShields")
			delayedElementalMessage = self:DelayedMessage(55, L["elemental_soon_message"], "Important")
		end
		self:RepeatStrider()
	end
end

function mod:UNIT_HEALTH(msg)
	if not self.db.profile.phase then return end
	if UnitName(msg) == boss then
		local hp = UnitHealth(msg)
		if hp > 70 and hp < 75 and not phaseTwoAnnounced then
			self:Message(L["phase2_soon_message"], "Attention")
			phaseTwoAnnounced = true
		elseif hp > 80 and phaseTwoAnnounced then
			phaseTwoAnnounced = nil
		end
	end
end

function mod:Charge(msg)
	local splayer = select(3, msg:find(L["static_charge_trigger"]))
	if splayer then
		if splayer == L2["you"] then
			splayer = playerName
		end
		self:Sync("VashjStatic " .. splayer)
	end
end

function mod:BigWigs_RecvSync( sync, rest, nick )
	if sync == "VashjStatic" and rest and self.db.profile.static then
		local msg = L["static_charge_message"]:format(rest)
		self:Message(msg, "Important", nil, "Alert")
		self:Bar(msg, 20, "Spell_Nature_LightningOverload")
		if self.db.profile.icon then
			self:Icon(rest)
		end
	elseif sync == "VashjLoot" and rest and self.db.profile.loot then
		self:Message(L["loot_message"]:format(rest), "Positive", nil, "Info")
		if self.db.profile.icon then
			self:Icon(rest)
		end
	elseif sync == "VashjDeformatCheck" and deformat then
		self:Sync("VashjDeformat")
	elseif sync == "VashjDeformat" and self:IsEventScheduled("VashjNoDeformat") then
		self:CancelScheduledEvent("VashjNoDeformat")
	elseif sync == "VashjBarrier" then
		shieldsFaded = shieldsFaded + 1
		if shieldsFaded == 4 and self.db.profile.phase then
			self:Message(L["phase3_message"], "Important", nil, "Alarm")

			if delayedElementalMessage and self:IsEventScheduled(delayedElementalMessage) then
				self:CancelScheduledEvent(delayedElementalMessage)
			end
			if delayedStriderMessage and self:IsEventScheduled(delayedStriderMessage) then
				self:CancelScheduledEvent(delayedStriderMessage)
			end
			self:CancelScheduledEvent("Strider")
			self:TriggerEvent("BigWigs_StopBar", self, L["elemental_bar"])
		elseif shieldsFaded < 4 and self.db.profile.barrier then
			self:Message(L["barrier_down_message"]:format(shieldsFaded), "Attention")
		end
	end
end

