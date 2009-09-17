----------------------------------
--      Module Declaration      --
----------------------------------
local mod = BigWigs:NewBoss("XT-002 Deconstructor", "Ulduar")
if not mod then return end
mod:RegisterEnableMob(33293)
mod.toggleOptions = {63024, "gravitybombicon", 63018, "lighticon", 62776, 64193, 63849, "proximity", "berserk", "bosskill"}
mod.optionHeaders = {
	[63024] = "normal",
	[64193] = "hard",
	proximity = "general",
}
mod.proximityCheck = "bandage"

------------------------------
--      Are you local?      --
------------------------------

local pName = UnitName("player")
local phase = nil
local exposed1 = nil
local exposed2 = nil
local exposed3 = nil

----------------------------
--      Localization      --
----------------------------

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: XT-002", "enUS", true)
if L then
	L.exposed_warning = "Exposed soon"
	L.exposed_message = "Heart exposed!"

	L.gravitybomb_other = "Gravity on %s!"

	L.gravitybombicon = "Gravity Bomb Icon"
	L.gravitybombicon_desc = "Place a Blue Square icon on the player effected by Gravity Bomb. (requires promoted or higher)"

	L.lighticon = "Searing Light Icon"
	L.lighticon_desc = "Place a Skull icon on the player with Searing Light. (requires promoted or higher)"

	L.lightbomb_other = "Light on %s!"

	L.tantrum_bar = "~Tantrum Cooldown"
end
L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: XT-002")
mod.locale = L

------------------------------
--      Initialization      --
------------------------------

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "Exposed", 63849)
	self:Log("SPELL_AURA_APPLIED", "Heartbreak", 64193, 65737)
	self:Log("SPELL_AURA_APPLIED", "GravityBomb", 63024, 64234)
	self:Log("SPELL_AURA_APPLIED", "LightBomb", 63018, 65121)
	self:Log("SPELL_AURA_REMOVED", "GravityRemoved", 63024, 64234)
	self:Log("SPELL_AURA_REMOVED", "LightRemoved", 63018, 65121)
	self:Log("SPELL_CAST_START", "Tantrum", 62776)
	self:Death("Win", 33293)
	self:RegisterEvent("UNIT_HEALTH")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
end

function mod:OnEngage()
	phase = 1
	exposed1 = nil
	exposed2 = nil
	exposed3 = nil
	if self.db.profile.berserk then
		self:Berserk(600)
	end
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Exposed(_, spellId, _, _, spellName)
	self:IfMessage(L["exposed_message"], "Attention", spellId)
	self:Bar(spellName, 30, spellId)
end

function mod:Heartbreak(_, spellId, _, _, spellName)
	phase = 2
	self:IfMessage(spellName, "Important", spellId)
end

function mod:Tantrum(_, spellId, _, _, spellName)
	if phase == 2 then
		self:IfMessage(spellName, "Attention", spellId)
		self:Bar(L["tantrum_bar"], 65, spellId)
	end
end

function mod:GravityBomb(player, spellId, _, _, spellName)
	if player == pName then
		self:SendMessage("BigWigs_ShowProximity", self)
	end
	self:TargetMessage(spellName, player, "Personal", spellId, "Alert")
	self:Whisper(player, spellName)
	self:Bar(L["gravitybomb_other"]:format(player), 9, spellId)
	self:SecondaryIcon(player, "gravitybombicon")
end

function mod:LightBomb(player, spellId, _, _, spellName)
	if player == pName then
		self:SendMessage("BigWigs_ShowProximity", self)
	end
	self:TargetMessage(spellName, player, "Personal", spellId, "Alert")
	self:Whisper(player, spellName)
	self:Bar(L["lightbomb_other"]:format(player), 9, spellId)
	self:PrimaryIcon(player, "lighticon")
end

function mod:GravityRemoved(player)
	if player == pName then
		self:SendMessage("BigWigs_HideProximity", self)
	end
	self:SecondaryIcon(false)
end

function mod:LightRemoved(player)
	if player == pName then
		self:SendMessage("BigWigs_HideProximity", self)
	end
	self:PrimaryIcon(false)
end

function mod:UNIT_HEALTH(event, msg)
	if phase == 1 and UnitName(msg) == mod.displayName and self:GetOption(63849) then
		local health = UnitHealth(msg)
		if not exposed1 and health > 86 and health <= 88 then
			exposed1 = true
			self:IfMessage(L["exposed_warning"], "Attention")
		elseif not exposed2 and health > 56 and health <= 58 then
			exposed2 = true
			self:IfMessage(L["exposed_warning"], "Attention")
		elseif not exposed3 and health > 26 and health <= 28 then
			exposed3 = true
			self:IfMessage(L["exposed_warning"], "Attention")
		end
	end
end

