------------------------------
--      Are you local?      --
------------------------------

if not GetSpellInfo then return end

-- TODO:
--	Clean up some localization issues
--	Figure out a clean way to handle curse jumps without spamming
--	Maybe a timer bar showing how long until people in the realm leave?
--	Verify enrage: 19:08:34 Sathrovarr drives Kalecgos into a crazed rage! (also: 2/12 19:08:39.843  SPELL_AURA_APPLIED,0x0000000000000000,nil,0x80000000,0xF13000613C00F8E6,Sathrovarr the Corruptor,0x10a48,44806,Crazed Rage,0x1,BUFF)
--	Warn for next enrage 10 seconds after the first

local boss = AceLibrary("Babble-Boss-2.2")["Kalecgos"]
local sath = "Sathrovarr the Corruptor"
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

local started = nil
local db = nil
local blasted = { }
local inRealm = { }
local enrageWarn = nil
local portalNum = nil

local fmt = string.format
local GetNumRaidMembers = GetNumRaidMembers
local pName = UnitName("player")
local UnitDebuff = UnitDebuff
local UnitBuff = UnitBuff
local GetSpellInfo = GetSpellInfo
local UnitPowerType = UnitPowerType
local UnitClass = UnitClass

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Kalecgos",

	blast = "Spectral Blast",
	blast_desc = "Tells you who has been hit by Spectral Blast.",
	blast_message = "Spectral Blast on %s!",

	portal = "Portal",
	portal_desc = "Warn when the Spectral Blast cooldown is up.",
	portal_bar = "Next portal",
	portal_message = "Possible portal (#%d) in 5 seconds!",

	realm = "Spectral Realm",
	realm_desc = "Tells you who is in the Spectral Realm.",
	realm_message = "In the realm: %s",

	curse = "Curse of Boundless Agony",
	curse_desc = "Tells you who is afflicted by Curse of Boundless Agony.",
	curse_bar = "Curse: %s",

	magichealing = "Wild Magic (Increased healing)",
	magichealing_desc = "Tells you when you get increased healing from Wild Magic.",
	magichealing_you = "Wild Magic - Healing effects increased!",

	magiccast = "Wild Magic (Increased cast time)",
	magiccast_desc = "Tells you when a healer gets incrased cast time from Wild Magic.",
	magiccast_you = "Wild Magic - Increased casting time on YOU!",
	magiccast_other = "Wild Magic - Increased casting time on %s!",

	magichit = "Wild Magic (Decreased chance to hit)",
	magichit_desc = "Tells you when a tank's chance to hit is reduced by Wild Magic.",
	magichit_you = "Wild Magic - Decreased chance to hit on YOU!",
	magichit_other = "Wild Magic - Decreased chance to hit on %s!",

	magicthreat = "Wild Magic (Increased threat)",
	magicthreat_desc = "Tells you when you get increased threat from Wild Magic.",
	magicthreat_you = "Wild Magic - Threat generation increased!",

	spectral_realm = "Spectral Realm",

	enrage_warning = "Enrage soon!",
	enrage_message = "10% - Enraged!",
	enrage_trigger = "Sathrovarr drives Kalecgos into a crazed rage!",
} end )

--[[
	Sunwell modules are PTR beta, as so localization is not supportd in any way
	This gives the authors the freedom to change the modules in way that
	can potentially break localization.
	Feel free to localize, just be aware that you may need to change it frequently.
]]--

L:RegisterTranslations("koKR", function() return {
	blast = "Spectral Blast",
	blast_desc = "Spectral Blast에 적중된 플레이어를 알립니다.",
	blast_message = "%s에게 Spectral Blast!",

	portal = "차원문",
	portal_desc = "Spectral Blast 재사용 대기시간에 대해 알립니다.",
	portal_bar = "다음 차원문",
	portal_message = "약 5초이내 (#%d) 차원문!",

	realm = "Spectral Realm",
	realm_desc = "Spectral Realm에 있는 플레이어를 알립니다.",
	realm_message = "영역 내부: %s",

	curse = "Curse of Boundless Agony",
	curse_desc = "Curse of Boundless Agony에 걸린 플레이어를 알립니다.",
	curse_bar = "Curse: %s",

	magichealing = "Wild Magic (Increased healing)",
	magichealing_desc = "Tells you when you get increased healing from Wild Magic.",
	magichealing_you = "Wild Magic - Healing effects increased!",

	magiccast = "Wild Magic (Increased cast time)",
	magiccast_desc = "Tells you when a healer gets incrased cast time from Wild Magic.",
	magiccast_you = "Wild Magic - Increased casting time on YOU!",
	magiccast_other = "Wild Magic - Increased casting time on %s!",

	magichit = "Wild Magic (Decreased chance to hit)",
	magichit_desc = "Tells you when a tank's chance to hit is reduced by Wild Magic.",
	magichit_you = "Wild Magic - Decreased chance to hit on YOU!",
	magichit_other = "Wild Magic - Decreased chance to hit on %s!",

	magicthreat = "Wild Magic (Increased threat)",
	magicthreat_desc = "Tells you when you get increased threat from Wild Magic.",
	magicthreat_you = "Wild Magic - Threat generation increased!",

	spectral_realm = "Spectral Realm",

	enrage_warning = "곧 격노!",
	enrage_message = "10% - 격노!",
	enrage_trigger = "사스로바르가 칼렉고스를 억제할 수 없는 분노의 소용돌이에 빠뜨립니다!",
} end )

L:RegisterTranslations("frFR", function() return {
	blast = "Déflagration spectrale",
	blast_desc = "Préviens quand un joueur a été touché par la Déflagration spectrale.",
	blast_message = "Déflagration spectrale sur %s !",

	portal = "Portail",
	portal_desc = "Préviens quand le temps de recharge de la Déflagration spectrale est terminé.",
	portal_bar = "Prochain portail",
	portal_message = "Portail probable dans 5 sec. !",

	realm = "Royaume spectral",
	realm_desc = "Préviens quand un joueur est dans le Royaume spectral.",
	realm_message = "Dans le royaume : %s",

	curse = "Malédiction d'agonie infinie",
	curse_desc = "Préviens quand un joueur subit les effets de la Malédiction d'agonie infinie.",
	curse_bar = "Curse: %s",

	magichealing = "Wild Magic (Increased healing)",
	magichealing_desc = "Tells you when you get increased healing from Wild Magic.",
	magichealing_you = "Wild Magic - Healing effects increased!",

	magiccast = "Wild Magic (Increased cast time)",
	magiccast_desc = "Tells you when a healer gets incrased cast time from Wild Magic.",
	magiccast_you = "Wild Magic - Increased casting time on YOU!",
	magiccast_other = "Wild Magic - Increased casting time on %s!",

	magichit = "Wild Magic (Decreased chance to hit)",
	magichit_desc = "Tells you when a tank's chance to hit is reduced by Wild Magic.",
	magichit_you = "Wild Magic - Decreased chance to hit on YOU!",
	magichit_other = "Wild Magic - Decreased chance to hit on %s!",

	magicthreat = "Wild Magic (Increased threat)",
	magicthreat_desc = "Tells you when you get increased threat from Wild Magic.",
	magicthreat_you = "Wild Magic - Threat generation increased!",

	spectral_realm = "Spectral Realm",

	enrage_warning = "Enrager imminent !",
	enrage_message = "10% - Enragé !",
	enrage_trigger = "Sathrovarr drives Kalecgos into a crazed rage!",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Sunwell Plateau"]
mod.enabletrigger = boss
mod.toggleoptions = {"blast", "portal", "realm", -1, "magichealing", "magiccast", "magichit", "magicthreat", "enrage", "proximity", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))
mod.proximityCheck = function( unit ) return CheckInteractDistance( unit, 3 ) end
mod.proximitySilent = true

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	started = nil
	portalNum = 1

	self:RegisterEvent("UNIT_HEALTH")
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	self:RegisterCombatLogEvent("SPELL_DAMAGE", "SpectralBlast", 44866)
	self:RegisterCombatLogEvent("SPELL_AURA_APPLIED", "Realm", 46021)
	self:RegisterCombatLogEvent("SPELL_AURA_APPLIED", "Curse", 45032, 45034)
	self:RegisterCombatLogEvent("SPELL_AURA_APPLIED", "WildMagic", 44978, 45001, 45002, 45006)
	self:RegisterCombatLogEvent("SPELL_AURA_REMOVED", "CurseRemoved", 45032, 45034)
	self:RegisterCombatLogEvent("UNIT_DIED", "GenericBossDeath")

	self:RegisterEvent("BigWigs_RecvSync")
	self:Throttle(3, "KalecgosBlast", "KalecgosMagicCast", "KalecgosMagicHit")
	self:Throttle(0, "KalecgosRealm", "KalecgosCurse", "KaleCurseRemv")

	db = self.db.profile
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:SpectralBlast(player)
	self:Sync("KalecgosBlast", player)
end

function mod:Realm(player)
	self:Sync("KalecgosRealm", player)
end

function mod:Curse(player)
	self:Sync("KalecgosCurse", player)
end

function mod:CurseRemoved(player)
	self:Sync("KaleCurseRemv", player)
end

function mod:WildMagic(player, spellId, spellName, event)
	if spellId == 44978 and player == pName and db.magichealing then -- Wild Magic - Healing done by spells and effects increased by 100%.
		self:Message(L["magichealing_you"], "Attention", true, "Long")
	elseif spellId == 45001 then -- Wild Magic - Casting time increased by 100%.
		if self:IsPlayerHealer(player) then
			self:Sync("KalecgosMagicCast", player)
		end
	elseif spellId == 45002 then -- Wild Magic - Chance to hit with melee and ranged attacks reduced by 50%.
		if self:IsPlayerTank(player) then
			self:Sync("KalecgosMagicHit", player)
		end
	elseif spellId == 45006 and player == pName and db.magicthreat then -- Wild Magic - Increases threat generated by 100%.
		self:Message(L["magicthreat_you"], "Personal", true, "Long")
	end
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if sync == "KalecgosBlast" and rest then
		if db.blast then
			blasted[rest] = true
			self:ScheduleEvent("BlastCheck", self.BlastWarn, 1, self)
		end
		if db.portal then
			self:Bar(L["portal_bar"], 20, "Spell_Shadow_Twilight")
			self:ScheduleEvent("PortalTargetCheck", self.NextPortalWarn, 15, self)
		end
	elseif sync == "KalecgosRealm" and rest and db.realm then
		inRealm[rest] = true
		self:ScheduleEvent("RealmCheck", self.RealmWarn, 2, self)
	elseif sync == "KalecgosCurse" and rest and db.curse then
		self:Bar(fmt(L["curse_bar"], rest), 30, "Spell_Shadow_CurseOfSargeras")
	elseif sync == "KaleCurseRemv" and rest and db.curse then
		self:TriggerEvent("BigWigs_StopBar", self, fmt(L["curse_bar"], rest))
	elseif sync == "KalecgosMagicCast" and rest and db.magiccast then
		local other = fmt(L["magiccast_other"], rest)
		if rest == pName then
			self:Message(L["magiccast_you"], "Positive", true, "Long")
			self:Message(other, "Attention", nil, nil, true)
		else
			self:Message(other, "Attention")
		end
	elseif sync == "KalecgosMagicHit" and rest and db.magichit then
		local other = fmt(L["magichit_other"], rest)
		if rest == pName then
			self:Message(L["magichit_you"], "Personal", true, "Long")
			self:Message(other, "Attention", nil, nil, true)
		else
			self:Message(other, "Attention")
		end
	elseif self:ValidateEngageSync(sync, rest) and not started then
		started = true
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end
		if db.portal then
			self:Bar(L["portal_bar"], 20, "Spell_Shadow_Twilight")
			self:DelayedMessage(15, fmt(L["portal_message"], portalNum), "Attention")
			portalNum = portalNum + 1
		end
		self:TriggerEvent("BigWigs_ShowProximity", self)
	end
end

function mod:BlastWarn()
	if db.blast then
		local msg = nil
		for k in pairs(blasted) do
			if not msg then
				msg = k
			else
				msg = msg .. ", " .. k
			end
		end
		self:Message(fmt(L["blast_message"], msg), "Urgent", nil, "Alert")
	end
	for k in pairs(blasted) do blasted[k] = nil end
end

function mod:RealmWarn()
	if db.realm then
		local msg = nil
		for k in pairs(inRealm) do
			if not msg then
				msg = k
			else
				msg = msg .. ", " .. k
			end
		end
		self:Message(fmt(L["realm_message"], msg), "Important", nil, "Alert")
	end
	for k in pairs(inRealm) do inRealm[k] = nil end
end

function mod:NextPortalWarn()
	if db.portal then
		local hasValidTarget = nil
		for i = 1, GetNumRaidMembers() do
			local hasDebuff = nil
			local curDebuff = 1
			local unit = fmt("%s%d", "raid", i)
			while UnitDebuff(unit, curDebuff) do
				local name = UnitDebuff(unit, curDebuff)
				local realmID = GetSpellInfo(46021) --Spectral Realm
				local exhID = GetSpellInfo(44867) --Spectral Exhaustion
				if name == realmID or name == exhID then --ID's not confirmed!! give feedback
					hasDebuff = true
					break
				end
				curDebuff = curDebuff + 1
			end
			if hasDebuff ~= nil then
				hasValidTarget = true
				break
			end
		end
		if hasValidTarget ~= nil then
			portalNum = portalNum + 1
			if portalNum == 5 then portalNum = 1 end
			self:Message(fmt(L["portal_message"], portalNum), "Urgent", nil, "Alert")
		end
	end
end

function mod:UNIT_HEALTH(msg)
	if db.enrage then
		if msg == sath then
			local health = UnitHealth(msg)
			if health > 12 and health <= 14 and not enrageWarn then
				self:Message(L["enrage_warning"], "Positive")
				enrageWarn = true
			elseif health > 50 and enrageWarn then
				enrageWarn = false
			end
		end
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg)
	if db.enrage and msg == L["enrage_trigger"] then
		self:Message(L["enrage_message"], "Important")
	end
end

-- Assumptions made:
--	Paladins and Shaman are always counted as healers
--	Druids are counted as healers if they have a mana bar
--	Priests are counted as healers if they aren't in Shadowform
local sfID = GetSpellInfo(15473) --Shadowform
local mkID = GetSpellInfo(24905) --Moonkin
function mod:IsPlayerHealer(player)
	local _, class = UnitClass(player)

	-- is paladin, is shaman
	if class == "PALADIN" or class == "SHAMAN" then
		return true
	end

	--is druid and has mana, isn't Moonkin
	if class == "DRUID" and UnitPowerType(player) == 0 then
		local i = 1
		while UnitBuff(player, i) do
			local name = UnitBuff(player, i)
			if name == mkID then
				return false
			end
			i = i + 1 --increment counter
		end
		return true
	end

	--is priest without shadowform
	if class == "PRIEST" then
		local i = 1
		while UnitBuff(player, i) do
			local name = UnitBuff(player, i)
			if name == sfID then
				return false
			end
			i = i + 1 --increment counter
		end
		return true
	end
	return false
end

-- Assumptions made:
--	Anyone with a rage bar is counted as a tank
--	Paladins with Righteous Fury are counted as tanks
local rfID = GetSpellInfo(25780) --Righteous Fury
function mod:IsPlayerTank(player)
	if UnitPowerType(player) == 1 then --has rage
		return true
	end

	local i = 1
	while UnitBuff(player, i) do
		local name = UnitBuff(player, i)
		if name == rfID then
			return true
		end
		i = i + 1 --increment counter
	end
	return false
end

