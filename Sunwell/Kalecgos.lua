------------------------------
--      Are you local?      --
------------------------------

-- TODO:
--	Clean up some localization issues
--	Figure out a clean way to handle curse jumps without spamming
--	Expand Wild Magic handling.  Perhaps warn about spellID 45001 on priests/paladins, 45006 on anyone, etc.
--	Maybe a timer bar showing how long until people in the realm leave?
--	Verify enrage: 19:08:34 Sathrovarr drives Kalecgos into a crazed rage! (also: 2/12 19:08:39.843  SPELL_AURA_APPLIED,0x0000000000000000,nil,0x80000000,0xF13000613C00F8E6,Sathrovarr the Corruptor,0x10a48,44806,Crazed Rage,0x1,BUFF)

local boss = AceLibrary("Babble-Boss-2.2")["Kalecgos"]
local sath = "Sathrovarr the Corruptor"
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")

local started = nil
local pName = nil
local db = nil
local blasted = { }
local inRealm = { }
local enrageWarn = nil
local portalNum = nil

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

	magic = "Wild Magic",
	magic_desc = "Tells you when you are afflicted by Wild Magic.",
	magic_you = "Wild Magic on YOU!",

	spectral_realm = "Spectral Realm",
	spectral_exhaustion = "Spectral Exhaustion",
	wild_magic = "Wild Magic",

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

	magic = "마법 폭주",
	magic_desc = "마법 폭주에 걸린 플레이어를 알립니다.",
	magic_you = "당신은 마법 폭주!",

	spectral_realm = "Spectral Realm",
	spectral_exhaustion = "Spectral Exhaustion",
	wild_magic = "마법 폭주",

	enrage_warning = "곧 격노!",
	enrage_message = "10% - 격노!",
	enrage_trigger = "Sathrovarr drives Kalecgos into a crazed rage!",
} end )

L:RegisterTranslations("frFR", function() return {
	blast = "D챕flagration spectrale",
	blast_desc = "Pr챕viens quand un joueur a 챕t챕 touch챕 par la D챕flagration spectrale.",
	blast_message = "D챕flagration spectrale sur %s !",

	portal = "Portail",
	portal_desc = "Pr챕viens quand le temps de recharge de la D챕flagration spectrale est termin챕.",
	portal_bar = "Prochain portail",
	portal_message = "Portail probable dans 5 sec. !",

	realm = "Royaume spectral",
	realm_desc = "Pr챕viens quand un joueur est dans le Royaume spectral.",
	realm_message = "Dans le royaume : %s",

	curse = "Mal챕diction d'agonie infinie",
	curse_desc = "Pr챕viens quand un joueur subit les effets de la Mal챕diction d'agonie infinie.",

	magic = "Magie sauvage",
	magic_desc = "Pr챕viens quand vous subissez les effets de Magie sauvage.",
	magic_you = "Magie sauvage sur VOUS !",

	spectral_realm = "Royaume spectral",
	spectral_exhaustion = "Epuisement spectral",
	wild_magic = "Magie sauvage",

	enrage_warning = "Enrager imminent !",
	enrage_message = "10% - Enrag챕 !",
	enrage_trigger = "Sathrovarr drives Kalecgos into a crazed rage!",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Sunwell Plateau"]
mod.enabletrigger = boss
mod.toggleoptions = {"blast", "portal", -1, "realm", "magic", "enrage", "proximity", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))
mod.proximityCheck = function( unit ) return CheckInteractDistance( unit, 3 ) end
mod.proximitySilent = true

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	started = nil
	portalNum = 1

	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED", "ProcessCombatLog")
	self:RegisterEvent("UNIT_HEALTH")
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "KalecgosBlast", 3)
	self:TriggerEvent("BigWigs_ThrottleSync", "KalecgosRealm", 0)
--	self:TriggerEvent("BigWigs_ThrottleSync", "KalecgosCurse", 3)

	pName = UnitName("player")
	db = self.db.profile
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:ProcessCombatLog(_, event, _, _, _, _, player, _, spellID, spellName)
	if event == "SPELL_DAMAGE" and spellID == 44866 then -- Spectral Blast
		self:Sync("KalecgosBlast", player)
	elseif event == "SPELL_AURA_APPLIED" then
		if spellID == 46021 then -- Spectral Realm
			self:Sync("KalecgosRealm", player)
		elseif spellID == 45032 or spellID == 45034 then -- Curse of Boundless Agony
--			self:Sync("KalecgosCurse", player)
		elseif spellName == L["wild_magic"] and db.magic then
			if player == pName then
				self:Message(L["magic_you"], "Personal", true, "Long")
			end
		end
	elseif event == "UNIT_DIED" and player == boss then
		self:Sync("BossDeath", boss)
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
	elseif self:ValidateEngageSync(sync, rest) and not started then
		started = true
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end
		if db.portal then
			self:Bar(L["portal_bar"], 20, "Spell_Shadow_Twilight")
			self:DelayedMessage(15, L["portal_message"]:format(portalNum), "Attention")
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
		self:Message(string.format(L["blast_message"], msg), "Important", nil, "Alert")
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
		self:Message(string.format(L["realm_message"], msg), "Important", nil, "Alert")
	end
	for k in pairs(inRealm) do inRealm[k] = nil end
end

function mod:NextPortalWarn()
	if db.portal then
		local hasValidTarget = nil
		for i = 1, GetNumRaidMembers() do
			local hasDebuff = nil
			local curDebuff = 1
			while UnitDebuff("raid" .. i, curDebuff) do
				local name = UnitDebuff("raid" .. i, curDebuff)
				if name == L["spectral_realm"] or name == L["spectral_exhaustion"] then
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
			self:Message(L["portal_message"]:format(portalNum), "Important", nil, "Alert")
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

