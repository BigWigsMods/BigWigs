------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Mother Shahraz"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")

local pName = nil
local attracted = {}
local UnitDebuff = UnitDebuff
local sub = string.sub
local enrageWarn = nil
local started = nil
local restype = nil
local stop

--debuffs
local shadow, holy, arcane, nature, fire, frost

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

	enrage_warning = "Enrage soon!",
	enrage_message = "10% - Enraged",
	enrage_trigger = "Stop toying with my emotions!",
} end )

--莎赫拉丝主母
L:RegisterTranslations("zhCN", function() return {
	engage_trigger = "是办正事还是找乐子呢？",

	attraction = "致命吸引",
	attraction_desc = "中了致命吸引发出警报",
	attraction_trigger = "^(%S+)受(%S+)了致命吸引效果的影响。$",
	attraction_message = "致命吸引: %s",

	debuff = "Debuff计时",
	debuff_desc = "显示 Debuff 直到下一个的计时.",

	enrage_warning = "即将狂暴!",
	enrage_message = "10% - 狂暴",
	enrage_trigger = "不要浪费我的感情了！",--Stop toying with my emotions!  Check
} end )

L:RegisterTranslations("zhTW", function() return {
	engage_trigger = "是辦正事還找樂子呢?",

	attraction = "致命的吸引力",
	attraction_desc = "當玩家中致命的吸引力發出警報",
	attraction_trigger = "^(.+)受(到[了]*)致命的吸引力效果的影響。",
	attraction_message = "致命的吸引力：: %s",

	debuff = "Debuff 計時",
	debuff_desc = "顯示debuff直到下一個計時",

	enrage_warning = "即將狂怒!",
	enrage_message = "10% - 狂怒",
	enrage_trigger = "不要浪費我的感情了！",
} end )

L:RegisterTranslations("koKR", function() return {
	engage_trigger = "흥... 관광하러 온 거야?",

	attraction = "치명적인 매력",
	attraction_desc = "치명적인 매력에 걸린 사람을 알립니다.",
	attraction_trigger = "^([^|;%s]*)(.*)치명적인 매력에 걸렸습니다%.$",
	attraction_message = "매력: %s",

	debuff = "디버프 타이머",
	debuff_desc = "변화의 보호막으로 인한 디버프와 다음 디버프 시간을 보여줍니다.",

	enrage_warning = "곧 격노!",
	enrage_message = "10% - 격노",
	enrage_trigger = "날 화나게 하지 마라!",
} end )

L:RegisterTranslations("frFR", function() return {
	engage_trigger = "Alors... Vous êtes en vacances ?",

	attraction = "Liaison fatale",
	attraction_desc = "Préviens quand un joueur subit les effets de la Liaison fatale.",
	attraction_trigger = "^(%S+) (%S+) les effets .* Liaison fatale%.$",
	attraction_message = "Liaison: %s",

	debuff = "Affaiblissements",
	debuff_desc = "Affiche l'affaiblissement actuel et le délai avant le prochain.",

	enrage_warning = "Enrager imminent !",
	enrage_message = "10% - Enragée",
	enrage_trigger = "Arrêtez de jouer avec mes sentiments !",
} end )

L:RegisterTranslations("deDE", function() return {
	engage_trigger = "Also... Geschäft oder Vergnügen?",

	attraction = "Verhängnisvolle Affäre",
	attraction_desc = "Warnt wer die Verhängnisvolle Affäre hat.",
	attraction_trigger = "^([^%s]+) ([^%s]+) ist von Verhängnisvolle Affäre betroffen%.$",
	attraction_message = "Affäre: %s",

	debuff = "Debuff Timer",
	debuff_desc = "Zeigt den gegenwärtigen Debuff und die Zeit bis zum nächsten an.",

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
mod.revision = tonumber(sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
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
	started = nil

	--setup debuffs
	shadow = "Interface\\Icons\\INV_Misc_Gem_Amethyst_01"
	holy = "Interface\\Icons\\INV_Misc_Gem_Topaz_01"
	arcane = "Interface\\Icons\\INV_Misc_Gem_Sapphire_01"
	nature = "Interface\\Icons\\INV_Misc_Gem_Emerald_01"
	fire = "Interface\\Icons\\INV_Misc_Gem_Opal_01"
	frost = "Interface\\Icons\\INV_Misc_Gem_Crystal_02"
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Berserk()
	started = true
	self:Message(L2["berserk_start"]:format(boss, 10), "Attention")
	--Don't use :DelayedMessage as we get mutiple messages on rare occasions :CheckForWipe doesn't kick in due to the enounter style
	self:ScheduleEvent("en1", "BigWigs_Message", 300, L2["berserk_min"]:format(5), "Positive")
	self:ScheduleEvent("en2", "BigWigs_Message", 420, L2["berserk_min"]:format(3), "Positive")
	self:ScheduleEvent("en3", "BigWigs_Message", 540, L2["berserk_min"]:format(1), "Positive")
	self:ScheduleEvent("en4", "BigWigs_Message", 570, L2["berserk_sec"]:format(30), "Positive")
	self:ScheduleEvent("en5", "BigWigs_Message", 590, L2["berserk_sec"]:format(10), "Urgent")
	self:ScheduleEvent("en6", "BigWigs_Message", 595, L2["berserk_sec"]:format(5), "Urgent")
	self:ScheduleEvent("en7", "BigWigs_Message", 600, L2["berserk_end"]:format(boss), "Attention", nil, "Alarm")
	self:Bar(L2["berserk"], 600, "Spell_Nature_Reincarnation")
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if sync == "ShaAttra" and rest then
		attracted[rest] = true
		self:ScheduleEvent("BWAttractionWarn", self.AttractionWarn, 0.3, self)
	elseif self:ValidateEngageSync(sync, rest) and not started then
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end
		if self.db.profile.berserk then
			self:Berserk()
		end
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L["engage_trigger"] then
		for k in pairs(attracted) do attracted[k] = nil end
		restype = nil
		stop = nil
		if self.db.profile.berserk then
			self:Berserk()
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
		self:Sync("ShaAttra", aplayer)
	end
end

function mod:PLAYER_AURAS_CHANGED(msg)
	--don't even scan anything if we don't want it on
	if not self.db.profile.debuff then return end

	local i = 1 --setup counter
	local rpt = nil
	while UnitDebuff("player", i) do --loop debuff scan
		local name, _, texture = UnitDebuff("player", i) --save name & texture

		if texture ~= restype then --spam protection
			--If we find a known texture(debuff Prismatic Aura: Resistance)
			--show a countdown bar and create a message with the name of the debuff
			if texture == shadow then
				self:Message(name, "Attention")
				self:TriggerEvent("BigWigs_StopBar", self, name)
				self:Bar(name, 15, sub(shadow, 17, -1))
				restype = texture
				rpt = true
			elseif texture == holy then
				self:Message(name, "Attention")
				self:TriggerEvent("BigWigs_StopBar", self, name)
				self:Bar(name, 15, sub(holy, 17, -1))
				restype = texture
				rpt = true
			elseif texture == arcane then
				self:Message(name, "Attention")
				self:TriggerEvent("BigWigs_StopBar", self, name)
				self:Bar(name, 15, sub(arcane, 17, -1))
				restype = texture
				rpt = true
			elseif texture == nature then
				self:Message(name, "Attention")
				self:TriggerEvent("BigWigs_StopBar", self, name)
				self:Bar(name, 15, sub(nature, 17, -1))
				restype = texture
				rpt = true
			elseif texture == fire then
				self:Message(name, "Attention")
				self:TriggerEvent("BigWigs_StopBar", self, name)
				self:Bar(name, 15, sub(fire, 17, -1))
				restype = texture
				rpt = true
			elseif texture == frost then
				self:Message(name, "Attention")
				self:TriggerEvent("BigWigs_StopBar", self, name)
				self:Bar(name, 15, sub(frost, 17, -1))
				restype = texture
				rpt = true
			end
		end
		i = i + 1 --increment counter
	end

	--If we don't have a recognised debuff, clear the spam filter,
	--this should be a fix for getting the same debuff twice,
	--assuming every time we do get 2 in a row, we loose the previous one first
	if not rpt then
		restype = nil
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
