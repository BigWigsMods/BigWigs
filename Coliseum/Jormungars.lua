--------------------------------------------------------------------------------
-- Module Declaration
--

local acidmaw = BB["Acidmaw"]
local dreadscale = BB["Dreadscale"]
local boss = BB["Jormungars"]	--need the add name translated, maybe add to BabbleBoss.
local mod = BigWigs:New(boss, "$Revision$")
if not mod then return end
mod.zonename = BZ["Trial of the Crusader"]	--need the add name translated, maybe add to BabbleZone.
mod.otherMenu = "The Argent Coliseum"
mod.enabletrigger = { acidmaw, dreadscale }
mod.guid = 34799--Dreadscale, 35144 = Acidmaw
mod.toggleoptions = {"slime", "spew", "toxin", "burn", "enrage", "bosskill"}

--------------------------------------------------------------------------------
-- Locals
--
local db = nil
local deaths = 0
local burn = mod:NewTargetList()
local toxin = mod:NewTargetList()
local pName = UnitName("player")
local fmt = string.format

--------------------------------------------------------------------------------
-- Localization
--

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
L:RegisterTranslations("enUS", function() return {
	cmd = "Jormungars",
	
	spew = "Acidic/Molten Spew",
	spew_desc = "Warn for Acidic/Molten Spew.",
	acidic_message = "Acidic Spew!",
	molten_message = "Molten Spew!",
	
	toxin = "Paralytic Toxin",
	toxin_desc = "Warn who has Paralytic Toxin.",
	toxin_you = "Paralytic Toxin on you!",
	toxin_other = "Paralytic Toxin: %s",
	
	burn = "Burning Bile",
	burn_desc = "Warn who has Burning Bile.",
	burn_you = "Burning Bile on you!",
	burn_other = "Burning Bile: %s",
	
	slime = "Slime Pool",
	slime_desc = "Warn for Slime Pool.",
	--slime_message = "Slime Pool on you!",
	slime_warning = "Slime Pool!",
	
	enrage = "Enrage",
	enrage_desc = "Warn for Enrage.",
	enrage_message = "Enrage!",
	
	jormungars_dies = "%s dead",
} end)
L:RegisterTranslations("koKR", function() return {
	spew = "산성/용암 내뿜기",
	spew_desc = "산성/용암 내뿜기를 알립니다.",
	acidic_message = "산성 내뿜기!",
	molten_message = "용암 내뿜기!",
	
	toxin = "마비 독",
	toxin_desc = "마비독에 걸린 플레이어를 알립니다.",
	toxin_you = "당신은 마비 독!",
	toxin_other = "마비 독: %s",
	
	burn = "불타는 담즙",
	burn_desc = "불타는 담즙에 걸린 플레이어를 알립니다.",
	burn_you = "당신은 불타는 담즙!",
	burn_other = "불타는 담즙: %s",
	
	slime = "진흙 웅덩이",
	slime_desc = "진흙 웅덩이를 알립니다.",
	--slime_message = "당신은 진흙 웅덩이!",
	slime_warning = "진흙 웅덩이!",
	
	enrage = "격노",
	enrage_desc = "격노를 알립니다.",
	enrage_message = "격노!",
	
	jormungars_dies = "%s 죽음",
} end)
L:RegisterTranslations("frFR", function() return {
} end)
L:RegisterTranslations("deDE", function() return {
} end)
L:RegisterTranslations("zhCN", function() return {
} end)
L:RegisterTranslations("zhTW", function() return {
} end)
L:RegisterTranslations("ruRU", function() return {
} end)

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnEnable()
	self:AddCombatListener("SPELL_CAST_SUCCESS", "SlimeCast", 67641)
	--self:AddCombatListener("SPELL_DAMAGE", "Slime", 67638)
	self:AddCombatListener("SPELL_CAST_START", "Acidic", 66818)
	self:AddCombatListener("SPELL_CAST_START", "Molten", 66821)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Toxin", 67618)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Burn", 66869)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Enraged", 68335)
	self:AddCombatListener("UNIT_DIED", "Deaths")
	
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	db = self.db.profile
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:SlimeCast(_, spellID)
	if db.slime then
		self:IfMessage(L["slime_warning"], "Attention", spellID)
	end
end
--[[
do
	local last = nil
	function mod:Slime(player, spellID)
		if player == pName and db.slime then
			local t = GetTime()
			if not last or (t > last + 4) then
				self:LocalMessage(L["slime_message"], "Personal", spellID, last and nil or "Alarm")
				last = t
			end
		end
	end
end
--]]
function mod:Molten(_, spellID)
	if db.spew then
		self:IfMessage(L["molten_message"], "Attention", spellID)
	end
end

function mod:Acidic(_, spellID)
	if db.spew then
		self:IfMessage(L["acidic_message"], "Attention", spellID)
	end
end

local function toxinWarn()
	mod:TargetMessage(L["toxin_other"], toxin, "Urgent", 64292, "Alert")
end

function mod:Toxin(player, spellID)
	if db.toxin then
		toxin[#toxin + 1] = player
		self:ScheduleEvent("BWtoxinWarn", toxinWarn, 0.2)
		if player == pName then
			mod:LocalMessage(L["toxin_you"], "Positive", spellID, "Info")
		end
	end
end

local function burnWarn()
	mod:TargetMessage(L["burn_other"], burn, "Urgent", 64292, "Alert")
end

function mod:Burn(player, spellID)
	if db.burn then
		burn[#burn + 1] = player
		self:ScheduleEvent("BWburnWarn", burnWarn, 0.2)
		if player == pName then
			mod:LocalMessage(L["burn_you"], "Positive", spellID, "Info")
		end
	end
end

function mod:Enraged(_, spellID)
	if db.enrage then
		self:IfMessage(L["enrage_message"], "Attention", spellID, "Long")
	end
end

function mod:Deaths(unit, guid)
	guid = tonumber((guid):sub(-12,-7),16)
	if guid == self.guid or guid == 35144 then
		deaths = deaths + 1
		if deaths < 2 then
			self:IfMessage(L["jormungars_dies"]:format(unit), "Positive")
		end
	end
	if deaths == 2 then
		self:BossDeath(nil, self.guid)
	end
end
