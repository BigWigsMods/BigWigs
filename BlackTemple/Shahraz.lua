------------------------------
--      Are you local?      --
------------------------------

local boss = BB["Mother Shahraz"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")

local pName = UnitName("player")
local db = nil
local attracted = {}
local GetPlayerBuff = GetPlayerBuff
local UnitDebuff = UnitDebuff
local GetPlayerBuffName = GetPlayerBuffName
local GetPlayerBuffTimeLeft = GetPlayerBuffTimeLeft
local GetPlayerBuffTexture = GetPlayerBuffTexture
local sub = string.sub
local enrageWarn = nil
local started = nil
local restype = nil
local timer = nil

--debuffs
local shadow = "INV_Misc_Gem_Amethyst_01"
local holy = "INV_Misc_Gem_Topaz_01"
local arcane = "INV_Misc_Gem_Sapphire_01"
local nature = "INV_Misc_Gem_Emerald_01"
local fire = "INV_Misc_Gem_Opal_01"
local frost = "INV_Misc_Gem_Crystal_02"

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Shahraz",

	engage_trigger = "So... business or pleasure?",

	attraction = "Fatal Attraction",
	attraction_desc = "Warn who has Fatal Attraction.",
	attraction_message = "Attraction: %s",

	debuff = "Debuff Timers",
	debuff_desc = "Show the current debuff and the time until the next one.",

	enrage_warning = "Enrage soon!",
	enrage_message = "10% - Enraged",
} end )

L:RegisterTranslations("zhCN", function() return {
	engage_trigger = "是办正事还是找乐子呢？",

	attraction = "致命吸引",
	attraction_desc = "当玩家受到致命吸引时发出警报。",
	attraction_message = "致命吸引：>%s<！",

	debuff = "负面效果计时",
	debuff_desc = "显示负面效果直到下一个的计时。",

	enrage_warning = "即将狂暴！",
	enrage_message = "10% - 狂暴！",
} end )

L:RegisterTranslations("zhTW", function() return {
	engage_trigger = "是辦正事還找樂子呢?",

	attraction = "致命的吸引力",
	attraction_desc = "當玩家中致命的吸引力發出警報",
	attraction_message = "致命的吸引力：%s",

	debuff = "Debuff 計時",
	debuff_desc = "顯示debuff直到下一個計時",

	enrage_warning = "即將狂怒!",
	enrage_message = "10% - 狂怒",
} end )

L:RegisterTranslations("koKR", function() return {
	engage_trigger = "흥... 관광하러 온 거야?",

	attraction = "치명적인 매력",
	attraction_desc = "치명적인 매력에 걸린 사람을 알립니다.",
	attraction_message = "매력: %s",

	debuff = "디버프 타이머",
	debuff_desc = "변화의 보호막으로 인한 디버프와 다음 디버프 시간을 보여줍니다.",

	enrage_warning = "곧 격노!",
	enrage_message = "10% - 격노",
} end )

L:RegisterTranslations("frFR", function() return {
	engage_trigger = "Alors... Vous êtes en vacances ?",

	attraction = "Liaison fatale",
	attraction_desc = "Préviens quand un joueur subit les effets de la Liaison fatale.",
	attraction_message = "Liaison : %s",

	debuff = "Affaiblissements",
	debuff_desc = "Affiche l'affaiblissement actuel et le délai avant le prochain.",

	enrage_warning = "Enrager imminent !",
	enrage_message = "10% - Enragée",
} end )

L:RegisterTranslations("deDE", function() return {
	engage_trigger = "Also... Geschäft oder Vergnügen?",

	attraction = "Verhängnisvolle Affäre",
	attraction_desc = "Warnt wer die Verhängnisvolle Affäre hat.",
	attraction_message = "Affäre: %s",

	debuff = "Debuff Timer",
	debuff_desc = "Zeigt den gegenwärtigen Debuff und die Zeit bis zum nächsten an.",

	enrage_warning = "Wütend bald!",
	enrage_message = "10% - Wütend",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = BZ["Black Temple"]
mod.enabletrigger = boss
mod.toggleoptions = {"attraction", "debuff", "berserk", "enrage", "bosskill"}
mod.revision = tonumber(sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("UNIT_DIED", "GenericBossDeath")
	self:AddCombatListener("SPELL_AURA_APPLIED", "Attraction", 41001)

	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
	self:RegisterEvent("PLAYER_AURAS_CHANGED")
	self:RegisterEvent("UNIT_HEALTH")

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("BigWigs_RecvSync")
	started = nil

	db = self.db.profile
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Attraction(player)
	if db.attraction then
		attracted[player] = true
		self:ScheduleEvent("BWAttractionWarn", self.AttractionWarn, 0.3, self)
	end
end

function mod:Berserk()
	started = true

	if db.berserk then
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

	if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then
		self:UnregisterEvent("PLAYER_REGEN_DISABLED")
	end
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if self:ValidateEngageSync(sync, rest) and not started then
		self:Berserk()
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L["engage_trigger"] then
		for k in pairs(attracted) do attracted[k] = nil end
		restype = nil
		self:Berserk()
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(_, unit)
	if unit == boss and db.enrage then
		self:Message(L["enrage_message"], "Important")
	end
end

local function killTime()
	timer = nil
end

function mod:PLAYER_AURAS_CHANGED()
	--don't even scan anything if we don't want it on
	if timer then return end
	if not db.debuff then return end

	local i = 1 --setup counter
	while UnitDebuff("player", i) do --loop debuff scan
		local id = GetPlayerBuff(i,"HARMFUL")
		local texture = GetPlayerBuffTexture(id)
		texture = sub(texture, 17, -1) --remove the crap and leave the icon name
		--If we find a known texture(debuff Prismatic Aura: Resistance) continue
		if texture == shadow or texture == holy or texture == arcane
		or texture == nature or texture == fire or texture == frost then
			local name = GetPlayerBuffName(id) --get the name
			local timeleft = GetPlayerBuffTimeLeft(id) --get the duration

			--show a countdown bar and create a message with the name of the debuff
			--if the timeleft is high enough (to prevent spam)
			if timeleft and timeleft > 13 then
				self:Message(name, "Attention")
				self:Bar(name, timeleft, texture)
				timer = true
				self:ScheduleEvent("BWShahrazAllowScan", killTime, 10)
			end
		end
		i = i + 1 --increment counter
	end
end

function mod:AttractionWarn()
	local msg = nil
	for k in pairs(attracted) do
		if not msg then
			msg = k
		else
			msg = msg .. ", " .. k
		end
	end
	self:IfMessage(L["attraction_message"]:format(msg), "Important", 41001, "Alert")
	for k in pairs(attracted) do attracted[k] = nil end
end

function mod:UNIT_HEALTH(msg)
	if not db.enrage then return end
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

