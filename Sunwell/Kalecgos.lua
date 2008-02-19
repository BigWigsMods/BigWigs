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

local boss = BB["Kalecgos"]
local sath = BB["Sathrovarr the Corruptor"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

local db = nil
local enrageWarn = nil
local wipe = nil

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

	engage_trigger = "Aggh!! No longer will I be a slave to Malygos! Challenge me and you will be destroyed!",
	wipe_trigger = "CHAT_MSG_MONSTER_SAY?", -- transcript or /chatlog at a wipe

	wipe_bar = "Respawn",

	portal = "Portal",
	portal_desc = "Warn when the Spectral Blast cooldown is up.",
	portal_bar = "Next portal",
	portal_message = "Possible portal in 5 seconds!",

	realm = "Spectral Realm",
	realm_desc = "Tells you who is in the Spectral Realm.",
	realm_message = "Spectral Realm: %s (Group %d)",

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

	buffet = "Arcane Buffet",
	buffet_desc = "Show the Arcane Buffet timer bar.",

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
	engage_trigger = "Aggh!! No longer will I be a slave to Malygos! Challenge me and you will be destroyed!",
	wipe_trigger = "CHAT_MSG_MONSTER_SAY?", -- transcript or /chatlog at a wipe

	wipe_bar = "Respawn",

	portal = "차원문",
	portal_desc = "공허 폭발의 재사용 대기시간에 대해 알립니다.",
	portal_bar = "다음 차원문",
	portal_message = "약 5초이내 차원문!",

	realm = "공허 영역",
	realm_desc = "공허 영역 내부에 들어간 플레이어를 알립니다.",
	realm_message = "영역 내부: %s (%d)",

	curse = "무한한 고통의 저주",
	curse_desc = "무한한 고통의 저주에 걸린 플레이어를 알립니다.",
	curse_bar = "저주: %s",

	magichealing = "마법 폭주 (힐량 증가)",
	magichealing_desc = "당신이 마법 폭주에 의해 힐량이 증가할때 알려줍니다.",
	magichealing_you = "마법 폭주 - 힐량 증가!",

	magiccast = "마법 폭주 (시전시간 증가)",
	magiccast_desc = "힐러가 마법 폭주에 의해 시전시간이 증가할때 알려줍니다.",
	magiccast_you = "마법 폭주 - 당신은 시전시간 증가!",
	magiccast_other = "마법 폭주 - %s 시전시간 증가!",

	magichit = "마법 폭주 (적중률 감소)",
	magichit_desc = "탱커가 마법 폭주에 의해 적중률이 감소할때 알려줍니다.",
	magichit_you = "마법 폭주 - 당신은 적중률 감소!",
	magichit_other = "마법 폭주 - %s 적중률 감소!",

	magicthreat = "마법 폭주 (위협수준 증가)",
	magicthreat_desc = "당신이 마법 폭주에 의해 위협수준이 증가할때 알려줍니다.",
	magicthreat_you = "마법 폭주 - 위협 생성 증가!",

	spectral_realm = "공허 영역",

	buffet = "비전 강타",
	buffet_desc = "비전 강타의 타이머 바를 표시합니다.",

	enrage_warning = "곧 격노!",
	enrage_message = "10% - 격노!",
	enrage_trigger = "사스로바르가 칼렉고스를 억제할 수 없는 분노의 소용돌이에 빠뜨립니다!",
} end )

L:RegisterTranslations("frFR", function() return {
	engage_trigger = "Aggh!! No longer will I be a slave to Malygos! Challenge me and you will be destroyed!", -- not yet translated on french client.
	wipe_trigger = "CHAT_MSG_MONSTER_SAY?", -- transcript or /chatlog at a wipe

	wipe_bar = "Réapparition",

	portal = "Portail",
	portal_desc = "Préviens quand le temps de recharge de la Déflagration spectrale est terminé.",
	portal_bar = "Prochain portail",
	portal_message = "Portail probable dans 5 sec. !",

	realm = "Royaume spectral",
	realm_desc = "Préviens quand un joueur est dans le Royaume spectral.",
	realm_message = "Dans le royaume : %s (%d)",

	curse = "Malédiction d'agonie infinie",
	curse_desc = "Préviens quand un joueur subit les effets de la Malédiction d'agonie infinie.",
	curse_bar = "Malédiction : %s",

	magichealing = "Magie sauvage (Soins prodigués augmentés)",
	magichealing_desc = "Préviens quand les effets de vos soins sont augmentés par la Magie sauvage.",
	magichealing_you = "Magie sauvage - Effets des soins augmentés !",

	magiccast = "Magie sauvage (Temps d'incantation augmenté)",
	magiccast_desc = "Préviens quand un soigneur a son temps d'incantation augmenté par la Magie sauvage.",
	magiccast_you = "Magie sauvage - Temps d'incantation augmenté pour VOUS !",
	magiccast_other = "Magie sauvage - Temps d'incantation augmenté pour %s !",

	magichit = "Magie sauvage (Chances de toucher réduites)",
	magichit_desc = "Préviens quand les chances de toucher d'un tank sont réduites par la Magie sauvage.",
	magichit_you = "Magie sauvage - Chances de toucher réduites pour VOUS !",
	magichit_other = "Magie sauvage - Chances de toucher réduites pour %s !",

	magicthreat = "Magie sauvage (Menace générée augmentée)",
	magicthreat_desc = "Préviens quand la menace que vous générez est augmentée par la Magie sauvage.",
	magicthreat_you = "Magie sauvage - Menace générée augmentée !",

	spectral_realm = "Royaume spectral",

	buffet = "Rafale des arcanes",
	buffet_desc = "Affiche une barre temporelle pour la Rafale des arcanes.",

	enrage_warning = "Enrager imminent !",
	enrage_message = "10% - Enragé !",
	enrage_trigger = "Sathrovarr drives Kalecgos into a crazed rage!",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = BZ["Sunwell Plateau"]
mod.enabletrigger = { boss, sath }
mod.toggleoptions = {"portal", "buffet", "realm", "curse", -1, "magichealing", "magiccast", "magichit", "magicthreat", "enrage", "proximity", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))
mod.proximityCheck = function( unit ) return CheckInteractDistance( unit, 3 ) end
mod.proximitySilent = true

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("UNIT_HEALTH")
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	self:AddCombatListener("SPELL_AURA_APPLIED", "Realm", 46021)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Curse", 45032, 45034)
	self:AddCombatListener("SPELL_AURA_APPLIED", "WildMagic", 44978, 45001, 45002, 45006)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Buffet", 45018)
	self:AddCombatListener("SPELL_AURA_APPLIED_DOSE", "Buffet", 45018)
	self:AddCombatListener("SPELL_AURA_REMOVED", "CurseRemoved", 45032, 45034)
	self:AddCombatListener("UNIT_DIED", "GenericBossDeath")

	self:RegisterEvent("BigWigs_RecvSync")
	self:Throttle(3, "KalecgosMagicCast", "KalecgosMagicHit", "KaleBuffet")
	self:Throttle(0, "KalecgosCurse", "KaleCurseRemv")
	self:Throttle(15, "KalecgosRealm")

	db = self.db.profile
	if wipe and BigWigs:IsModuleActive(boss) then
		self:Bar(L["wipe_bar"], 90, 44670)
		wipe = nil
	end
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Realm(player)
	self:Sync("KalecgosRealm", player)
end

function mod:Curse(player)
	self:Sync("KalecgosCurse", player)
end

function mod:CurseRemoved(player)
	self:Sync("KaleCurseRemv", player)
end

function mod:Buffet(player)
	self:Sync("KaleBuffet", player)
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L["engage_trigger"] then
		wipe = true
		if db.portal then
			self:Bar(L["portal_bar"], 20, 46021)
			self:DelayedMessage(15, L["portal_message"], "Urgent", nil, "Alert")
		end
		self:TriggerEvent("BigWigs_ShowProximity", self)
	end
end

function mod:WildMagic(player, spellId, spellName, event)
	if spellId == 44978 and player == pName and db.magichealing then -- Wild Magic - Healing done by spells and effects increased by 100%.
		self:Message(L["magichealing_you"], "Attention", true, "Long", nil, spellId)
	elseif spellId == 45001 then -- Wild Magic - Casting time increased by 100%.
		if self:IsPlayerHealer(player) then
			self:Sync("KalecgosMagicCast", player)
		end
	elseif spellId == 45002 then -- Wild Magic - Chance to hit with melee and ranged attacks reduced by 50%.
		if self:IsPlayerTank(player) then
			self:Sync("KalecgosMagicHit", player)
		end
	elseif spellId == 45006 and player == pName and db.magicthreat then -- Wild Magic - Increases threat generated by 100%.
		self:Message(L["magicthreat_you"], "Personal", true, "Long", nil, spellId)
	end
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if sync == "KalecgosRealm" and rest then
		if db.portal then
			self:Bar(L["portal_bar"], 20, 46021)
			self:DelayedMessage(15, L["portal_message"], "Urgent", nil, "Alert")
		end
		if db.realm then
			local groupNo = self:GetGroupNumber(rest)
			self:Message(fmt(L["realm_message"], rest, groupNo), "Urgent", nil, "Alert", nil, 44866)
		end
	elseif sync == "KalecgosCurse" and rest and db.curse then
		self:Bar(fmt(L["curse_bar"], rest), 30, 45032)
	elseif sync == "KaleBuffet" and db.buffet then
		self:Bar(L["buffet"], 8, 45018)
	elseif sync == "KaleCurseRemv" and rest and db.curse then
		self:TriggerEvent("BigWigs_StopBar", self, fmt(L["curse_bar"], rest))
	elseif sync == "KalecgosMagicCast" and rest and db.magiccast then
		local other = fmt(L["magiccast_other"], rest)
		if rest == pName then
			self:Message(L["magiccast_you"], "Positive", true, "Long", nil, 45001)
			self:Message(other, "Attention", nil, nil, true)
		else
			self:Message(other, "Attention", nil, nil, nil, 45001)
		end
	elseif sync == "KalecgosMagicHit" and rest and db.magichit then
		local other = fmt(L["magichit_other"], rest)
		if rest == pName then
			self:Message(L["magichit_you"], "Personal", true, "Long", nil, 45002)
			self:Message(other, "Attention", nil, nil, true)
		else
			self:Message(other, "Attention", nil, nil, nil, 45002)
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
		self:Message(L["enrage_message"], "Important", nil, nil, nil, 44806)
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

function mod:GetGroupNumber(player)
	for i=1, GetNumRaidMembers() do
		local name, rank, subGroup = GetRaidRosterInfo(i)
		if name == player then return subGroup end
	end
end
