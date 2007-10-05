------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Mother Shahraz"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")

local pName = nil
local attracted = {}
local UnitDebuff = UnitDebuff
local enrageWarn = nil
local restype = nil
local stop

--debuffs
local shadow
local holy
local arcane
local nature
local fire
local frost
local all

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Shahraz",

	engage_trigger = "So... business or pleasure?",

	attraction = "Fatal Attraction",
	attraction_desc = "Warn who has Fatal Attraction.",
	attraction_trigger = "^(%S+) (%S+) afflicted by Fatal Attraction%.$",
	attraction_message = "Attraction: %s",

	debuff = "Debuff Timers",
	debuff_desc = "Show the current debuff and the time until the next one.",
	debuff_bar = "Next Debuff",

	berserk = "Berserk",
	berserk_desc = "Warn for berserk after 10min.",
	berserk_start = "%s engaged, 10 min to berserk!",
	berserk_min = "Berserk in %d min",
	berserk_sec = "Berserk in %d sec",
	berserk_end = "%s goes Berserk!",

	enrage_warning = "Enrage soon!",
	enrage_message = "10% - Enraged",
	enrage_trigger = "Stop toying with my emotions!",
} end )

L:RegisterTranslations("koKR", function() return {
	engage_trigger = "흥... 관광하러 온 거야?",

	attraction = "치명적인 매력",
	attraction_desc = "치명적인 매력에 걸린 사람을 알립니다.",
	attraction_trigger = "^([^|;%s]*)(.*)치명적인 매력에 걸렸습니다%.$",
	attraction_message = "매력: %s",

	debuff = "디버프 타이머",
	debuff_desc = "변화의 보호막으로 인한 디버프와 다음 디버프 시간을 보여줍니다.",
	debuff_bar = "다음 디버프",

	berserk = "광폭화",
	berserk_desc = "10분후 광폭화에 대한 경고입니다.",
	berserk_start = "%s 시작, 10분후 광폭화!",
	berserk_min = "%d 분 이내 광폭화",
	berserk_sec = "%d 초 이내 광폭화",
	berserk_end = "%s 광폭화!",

	enrage_warning = "곧 격노!",
	enrage_message = "10% - 격노",
	--enrage_trigger = "Stop toying with my emotions!",
} end )

L:RegisterTranslations("frFR", function() return {
	engage_trigger = "Alors... vous êtes en vacances ?", -- à vérifier

	attraction = "Liaison fatale",
	attraction_desc = "Préviens quand un joueur subit les effets de la Liaison fatale.",
	attraction_trigger = "^(%S+) (%S+) les effets .* Liaison fatale%.$",
	attraction_message = "Liaison : %s",

	debuff = "Affaiblissements",
	debuff_desc = "Affiche l'affaiblissement actuel et le délai avant le prochain.",
	debuff_bar = "Prochain affaiblissement",

	berserk = "Berserk",
	berserk_desc = "Préviens quand Mère Shahraz passe en berserker après 10 min.",
	berserk_start = "%s engagée, 10 min. avant berserk !",
	berserk_min = "Berserk dans %d min.",
	berserk_sec = "Berserk dans %d sec.",
	berserk_end = "%s passe en berserk !",

	enrage_warning = "Enrager imminent !",
	enrage_message = "10% - Enragée",
	enrage_trigger = "Arrêtez de jouer aves mes sentiments !", -- à vérifier
} end )

L:RegisterTranslations("deDE", function() return {
	engage_trigger = "Also... Geschäft oder Vergnügen?",

	attraction = "Verhängnisvolle Affäre",
	attraction_desc = "Warnt wer die Verhängnisvolle Affäre hat.",
	attraction_trigger = "^([^%s]+) ([^%s]+) ist von Verhängnisvolle Affäre betroffen%.$",
	attraction_message = "Affäre: %s",

	debuff = "Debuff Timer",
	debuff_desc = "Zeigt den gegenwärtigen Debuff und die Zeit bis zum nächsten an.",
	debuff_bar = "Nächster Debuff",

	berserk = "Berserker",
	berserk_desc = "Warnt wann Shahraz zum Berserker wird.",
	berserk_start = "%s gepullt, 10 min bis sie zum Berserker wird!",
	berserk_min = "Berserker in %d min",
	berserk_sec = "Berserker in %d sek",
	berserk_end = "%s wird zum Berserker!",

	enrage_warning = "Wütend bald!",
	enrage_message = "10% - Wütend",
	--enrage_trigger = "Stop toying with my emotions!",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Black Temple"]
mod.enabletrigger = boss
mod.toggleoptions = {"attraction", "debuff", "berserk", "enrage", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "FatalAtt")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "FatalAtt")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "FatalAtt")

	self:RegisterEvent("PLAYER_AURAS_CHANGED")
	self:RegisterEvent("UNIT_HEALTH")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "ShaAttra", 0)
	pName = UnitName("player")
	stop = nil

	--setup debuffs
	shadow = "Interface\\Icons\\INV_Misc_Gem_Amethyst_01"
	holy = "Interface\\Icons\\INV_Misc_Gem_Topaz_01"
	arcane = "Interface\\Icons\\INV_Misc_Gem_Sapphire_01"
	nature = "Interface\\Icons\\INV_Misc_Gem_Emerald_01"
	fire = "Interface\\Icons\\INV_Misc_Gem_Opal_01"
	frost = "Interface\\Icons\\INV_Misc_Gem_Crystal_02"
	all = "INV_Misc_Gem_Variety_02"
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:BigWigs_RecvSync(sync, rest, nick)
	if sync == "ShaAttra" and rest then
		attracted[rest] = true
		self:ScheduleEvent("BWAttractionWarn", self.AttractionWarn, 0.3, self)
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L["engage_trigger"] then
		for k in pairs(attracted) do attracted[k] = nil end
		restype = nil
		stop = nil
		if self.db.profile.berserk then
			self:Message(L["berserk_start"]:format(boss, 10), "Attention")
			--Don't use :DelayedMessage as we get mutiple messages on rare occasions :CheckForWipe doesn't kick in due to the enounter style
			self:ScheduleEvent("en1", "BigWigs_Message", 300, L["berserk_min"]:format(5), "Positive")
			self:ScheduleEvent("en2", "BigWigs_Message", 420, L["berserk_min"]:format(3), "Positive")
			self:ScheduleEvent("en3", "BigWigs_Message", 540, L["berserk_min"]:format(1), "Positive")
			self:ScheduleEvent("en4", "BigWigs_Message", 570, L["berserk_sec"]:format(30), "Positive")
			self:ScheduleEvent("en5", "BigWigs_Message", 590, L["berserk_sec"]:format(10), "Urgent")
			self:ScheduleEvent("en6", "BigWigs_Message", 595, L["berserk_sec"]:format(5), "Urgent")
			self:ScheduleEvent("en7", "BigWigs_Message", 600, L["berserk_end"]:format(boss), "Attention", nil, "Alarm")
			self:Bar(L["berserk"], 600, "Spell_Nature_Reincarnation")
		end
	elseif self.db.profile.enrage and msg == L["enrage_trigger"] then
		self:Message(L["enrage_message"], "Important")
	end
end

function mod:FatalAtt(msg)
	local aplayer, atype = select(3, msg:find(L["attraction_trigger"]))
	if aplayer and atype then
		if aplayer == L2["you"] and atype == L2["are"] then
			aplayer = pName
		end
		self:Sync("ShaAttra "..aplayer)
	end
end

function mod:PLAYER_AURAS_CHANGED(msg)
	--don't even scan anything if we don't want it on
	if not self.db.profile.debuff then return end

	local bar = L["debuff_bar"] --don't need to repeat this in every bar
	local i = 1 --setup counter
	while UnitDebuff("player", i) do --loop debuff scan
		local name, _, texture = UnitDebuff("player", i) --save name & texture

		if texture ~= restype then --spam protection
			--If we find a known texture(debuff Prismatic Aura: Resistance)
			--show a countdown bar and create a message with the name of the debuff
			if texture == shadow then
				self:Message(name, "Attention")
				self:Bar(bar, 15, all)
				restype = texture
			elseif texture == holy then
				self:Message(name, "Attention")
				self:Bar(bar, 15, all)
				restype = texture
			elseif texture == arcane then
				self:Message(name, "Attention")
				self:Bar(bar, 15, all)
				restype = texture
			elseif texture == nature then
				self:Message(name, "Attention")
				self:Bar(bar, 15, all)
				restype = texture
			elseif texture == fire then
				self:Message(name, "Attention")
				self:Bar(bar, 15, all)
				restype = texture
			elseif texture == frost then
				self:Message(name, "Attention")
				self:Bar(bar, 15, all)
				restype = texture
			end
		end
		i = i + 1 --increase counter
	end
end

local function nilStop()
	stop = nil --allow syncs
	for k in pairs(attracted) do attracted[k] = nil end
end

function mod:AttractionWarn()
	if stop then return end
	if self.db.profile.attraction then
		local msg = nil
		for k in pairs(attracted) do
			if not msg then
				msg = k
			else
				msg = msg .. ", " .. k
			end
		end
		self:Message(L["attraction_message"]:format(msg), "Important", nil, "Alert")
	end
	stop = true
	--start accepting syncs again after 6 seconds, by blocking syncs we can
	--warn earlier without caring about latency displaying messages twice
	self:ScheduleEvent("BWShahrazNilStop", nilStop, 6)
end

function mod:UNIT_HEALTH(msg)
	if not self.db.profile.enrage then return end
	if UnitName(msg) == boss then
		local health = UnitHealth(msg)
		if health > 12 and health <= 14 and not enrageWarn then
			self:Message(L["enrage_warning"], "Positive")
			enrageWarn = true
		elseif health > 50 and enrageWarn then
			enrageWarn = false
		end
	end
end
