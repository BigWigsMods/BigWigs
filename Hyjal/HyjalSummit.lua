------------------------------
--      Are you local?      --
------------------------------

local name = AceLibrary("Babble-Zone-2.2")["Hyjal Summit"]
local allianceBase = AceLibrary("Babble-Zone-2.2")["Alliance Base"]
local hordeEncampment = AceLibrary("Babble-Zone-2.2")["Horde Encampment"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..name)

local winterchill = AceLibrary("Babble-Boss-2.2")["Rage Winterchill"]
local anatheron = AceLibrary("Babble-Boss-2.2")["Anetheron"]
local kazrogal = AceLibrary("Babble-Boss-2.2")["Kaz'rogal"]
local azgalor = AceLibrary("Babble-Boss-2.2")["Azgalor"]

local fmt = string.format
local match = string.match
local GetRealZoneText = GetRealZoneText
local GetSubZoneText = GetSubZoneText
local tonumber = tonumber

local nextBoss = nil
local currentWave = 0
local waveBar = nil
local allianceWaveTimes = {127.5, 127.5, 127.5, 127.5, 127.5, 127.5, 127.5, 140}
local RWCwaveTimes = allianceWaveTimes --need more accurate times
local KRwaveTimes = {135, 160, 190, 165, 140, 130, 195, 225} --need more accurate times
local hordeWaveTimes = {135, 190, 190, 195, 140, 165, 195, 225}

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "summit",

	waves = "Wave Warnings",
	waves_desc = "Announce approximate warning messages for the next wave.",

	["~%s spawn"] = true,
	["~Wave %d spawn"] = true,
	["Wave %d incoming!"] = true,
	["Wave %d! %d %s"] = true, --1 set of mobs
	["Wave %d! %d %s, %d %s"] = true, --2 sets of mobs
	["Wave %d! %d %s, %d %s, %d %s"] = true, --3 sets of mobs
	["Wave %d! %d %s, %d %s, %d %s, %d %s"] = true, --4 sets of mobs
	["Wave %d! %d %s, %d %s, %d %s, %d %s, %d %s"] = true, --5 sets of mobs
	["%s in ~%d sec!"] = true,
	["Wave %d in ~%d sec!"] = true,

	["Boss"] = true,
	["Thrall"] = true,
	["Lady Jaina Proudmoore"] = true,

	["My companions and I are with you, Lady Proudmoore."] = true, -- Rage Winterchill
	["We are ready for whatever Archimonde might send our way, Lady Proudmoore."] = true, -- Anatheron
	["I am with you, Thrall."] = true, -- Kaz'Rogal
	["We have nothing to fear."] = true, -- Az'Galor

	["Please remove BigWigs_WaveTimers, it is deprecated."] = true,

	["Ghouls"] = true,
	["Crypt Fiends"] = true,
	["Abominations"] = true,
	["Necromancers"] = true,
	["Banshees"] = true,
	["Gargoyles"] = true,
	["Frost Wyrm"] = true,
	["Fel Stalkers"] = true,
	["Infernals"] = true,
} end )

L:RegisterTranslations("koKR", function() return {
	waves = "공격 경고",
	waves_desc = "다음 공격에 대한 접근 경고 메세지를 알립니다.",

	["~%s spawn"] = "~%s 등장",
	["~Wave %d spawn"] = "%d번째 공격 등장",
	["Wave %d incoming!"] = "%d번째 공격 시작!",
	["Wave %d! %d %s"] = "%d번째 공격! %d %s", --1 set of mobs
	["Wave %d! %d %s, %d %s"] = "%d번째 공격! %d %s, %d %s", --2 sets of mobs
	["Wave %d! %d %s, %d %s, %d %s"] = "%d번째 공격! %d %s, %d %s, %d %s", --3 sets of mobs
	["Wave %d! %d %s, %d %s, %d %s, %d %s"] = "%d번째 공격! %d %s, %d %s, %d %s, %d %s", --4 sets of mobs
	["Wave %d! %d %s, %d %s, %d %s, %d %s, %d %s"] = "%d번째 공격! %d %s, %d %s, %d %s, %d %s, %d %s", --5 sets of mobs
	["%s in ~%d sec!"] = "약 %2$d초 이내 %1$s!",
	["Wave %d in ~%d sec!"] = "약 %2$d초 후 %1$d번째 공격!",

	["Boss"] = "보스",
	["Thrall"] = "스랄",
	["Lady Jaina Proudmoore"] = "여군주 제이나 프라우드무어",

	["My companions and I are with you, Lady Proudmoore."] = "제 동료와 저는 프라우드무어님, 당신과 함께 하겠습니다.", -- Rage Winterchill
	["We are ready for whatever Archimonde might send our way, Lady Proudmoore."] = "아키몬드가 어떤 군대를 보내던 우리는 준비가 되어 있습니다. 프라우드무어 님.", -- Anatheron
	["I am with you, Thrall."] = "당신과 함께 하겠습니다. 대족장님.", -- Kaz'Rogal
	["We have nothing to fear."] = "두려워할 것은 아무것도 없습니다.", -- Az'Galor
	
	["Please remove BigWigs_WaveTimers, it is deprecated."] = "이것을 비난한다면, BigWigs_WaveTimers를 제거하십시요.",

	["Ghouls"] = "구울",
	["Crypt Fiends"] = "지하마귀",
	["Abominations"] = "누더기골렘",
	["Necromancers"] = "어둠의 강령술사",
	["Banshees"] = "벤쉬",
	["Gargoyles"] = "가고일",
	["Frost Wyrm"] = "서리고룡",
	["Fel Stalkers"] = "지옥사냥개",
	["Infernals"] = "거대한 지옥불정령",
} end )

L:RegisterTranslations("frFR", function() return {
	waves = "Avertissements des vagues",
	waves_desc = "Préviens quand la prochaine vague est susceptible d'arriver.",

	["~%s spawn"] = "~Apparition %s",
	["~Wave %d spawn"] = "~Apparition vague %d",
	["Wave %d incoming!"] = "Arrivée de la vague %d !",
	["%s in ~%d sec!"] = "%s dans ~%d sec. !",
	["Wave %d in ~%d sec!"] = "Vague %d dans ~%d sec. !",

	["Boss"] = "Boss",
	["Thrall"] = "Thrall",
	["Lady Jaina Proudmoore"] = "Dame Jaina Portvaillant",

	["My companions and I are with you, Lady Proudmoore."] = "Mes compagnons et moi sommes à vos côtés, dame Portvaillant.", -- Rage Winterchill
	--["We are ready for whatever Archimonde might send our way, Lady Proudmoore."] = true, -- Anatheron
	--["I am with you, Thrall."] = true, -- Kaz'Rogal
	["We have nothing to fear."] = "Nous n'avons rien à craindre.", -- Az'Galor

	["Please remove BigWigs_WaveTimers, it is deprecated."] = "Veuillez enlever BigWigs_WaveTimers, qui est obsolète.",
} end )

L:RegisterTranslations("deDE", function() return {
	waves = "Wellen Warnungen",
	waves_desc = "Ausgeben von Warnungs Nachrichten für die nächste Welle.",

	["~%s spawn"] = "~%s spawnt.",
	["~Wave %d spawn"] = "~Welle %d spawnt.",
	["Wave %d incoming!"] = "Welle %d kommt!",
	["%s in ~%d sec!"] = "%s in ~%d sek!",
	["Wave %d in ~%d sec!"] = "Welle %d in ~%d sek!",

	["Boss"] = "Boss",
	["Thrall"] = "Thrall",
	["Lady Jaina Proudmoore"] = "Lady Jaina Prachtmeer",

	["My companions and I are with you, Lady Proudmoore."] = "Meine Gefhrten und ich werden Euch zur Seite stehen, Lady Prachtmeer.", -- Rage Winterchill
	["We are ready for whatever Archimonde might send our way, Lady Proudmoore."] = "Was auch immer Archimonde gegen uns ins Feld schicken mag, wir sind bereit, Lady Prachtmeer.", -- Anatheron
	["I am with you, Thrall."] = "Ich werde Euch zur Seite stehen, Thrall!", -- Kaz'Rogal
	["We have nothing to fear."] = "Wir haben nichts zu befrchten.", -- Az'Galor
} end )

L:RegisterTranslations("zhCN", function() return {
	waves = "阶段警报",
	waves_desc = "通告下一波来临警报信息",

	["~%s spawn"] = "~%s 出现.",
	["~Wave %d spawn"] = "~第%d波 出现.",
	["Wave %d incoming!"] = "第%d波 来临!",
	["Wave %d! %d %s"] = "第%d波! %d %s", --1 set of mobs
	["Wave %d! %d %s, %d %s"] = "第%d波! %d %s, %d %s", --2 sets of mobs
	["Wave %d! %d %s, %d %s, %d %s"] = "第%d波! %d %s, %d %s, %d %s", --3 sets of mobs
	["Wave %d! %d %s, %d %s, %d %s, %d %s"] = "第%d波! %d %s, %d %s, %d %s, %d %s", --4 sets of mobs
	["Wave %d! %d %s, %d %s, %d %s, %d %s, %d %s"] = "第%d波! %d %s, %d %s, %d %s, %d %s, %d %s", --5 sets of mobs
	["%s in ~%d sec!"] = "在~%d秒后 %s !",
	["Wave %d in ~%d sec!"] = "在~%d秒后 第%d波!",

	["Boss"] = "首领",
	["Thrall"] = "萨尔",
	["Lady Jaina Proudmoore"] = "吉安娜·普罗德摩尔",

	["My companions and I are with you, Lady Proudmoore."] = "My companions and I are with you, Lady Proudmoore.", -- Rage Winterchill
	["We are ready for whatever Archimonde might send our way, Lady Proudmoore."] = "We are ready for whatever Archimonde might send our way, Lady Proudmoore.", -- Anatheron
	["I am with you, Thrall."] = "I am with you, Thrall.", -- Kaz'Rogal
	["We have nothing to fear."] = "We have nothing to fear.", -- Az'Galor

	["Please remove BigWigs_WaveTimers, it is deprecated."] = "请移除 BigWigs_WaveTimers， 此插件已经失效了。",

	["Ghouls"] = "食尸鬼",
	["Crypt Fiends"] = "地穴恶魔",
	["Abominations"] = "憎恶",
	["Necromancers"] = "阴暗通灵师",--check
	["Banshees"] = "女妖",
	["Gargoyles"] = "石像鬼",
	["Frost Wyrm"] = "冰霜巨龙",
	["Fel Stalkers"] = "恐狼",--check
	["Infernals"] = "地狱火",
} end )

L:RegisterTranslations("zhTW", function() return {
	waves = "階段警報",
	waves_desc = "通報下一波小怪來臨訊息",

	["~%s spawn"] = "~%s 出現",
	["~Wave %d spawn"] = "~第 %d 波 出現",
	["Wave %d incoming!"] = "第 %d 波 即將來臨!",
	["%s in ~%d sec!"] = "%s 在 ~%d 秒!",
	["Wave %d in ~%d sec!"] = "第 %d 波在 ~%d 秒後!",

	["Boss"] = "首領",
	["Thrall"] = "索爾",
	["Lady Jaina Proudmoore"] = "珍娜·普勞德摩爾女士",

	["My companions and I are with you, Lady Proudmoore."] = "我和我的同伴都與你同在，普勞德摩爾女士。", -- Rage Winterchill
	["We are ready for whatever Archimonde might send our way, Lady Proudmoore."] = "不管阿克蒙德要派誰來對付我們，我們都已經準備好了，普勞德摩爾女士。", -- Anatheron
	["I am with you, Thrall."] = "我與你同在，索爾。", -- Kaz'Rogal
	["We have nothing to fear."] = "我們無所畏懼。", -- Az'Galor
	["Please remove BigWigs_WaveTimers, it is deprecated."] = "請移除 BigWigs_WaveTimer，他已經過期了。",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local thrall = L["Thrall"]
local proudmoore = L["Lady Jaina Proudmoore"]

local mod = BigWigs:NewModule(name)
mod.zonename = name
mod.enabletrigger = { thrall, proudmoore }
mod.toggleoptions = {"waves"}
mod.revision = tonumber(match("$Revision$", "%d+"))
mod.synctoken = name

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	currentWave = 0
	nextBoss = L["Boss"]
	waveBar = ""
	self:RegisterEvent("UPDATE_WORLD_STATES")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	self:RegisterEvent("GOSSIP_SHOW")
	self:RegisterEvent("QUEST_PROGRESS", "GOSSIP_SHOW")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "SummitWave", 2)
	self:TriggerEvent("BigWigs_ThrottleSync", "SummitNext", 2)
--~ 	throttling these 2 will cause an errant 'wave 1' message when thrall/jaina die
--~ 	self:TriggerEvent("BigWigs_ThrottleSync", "SummitReset", 2)
--~ 	self:TriggerEvent("BigWigs_ThrottleSync", "SummitClear", 2)
	if IsAddOnLoaded("BigWigs_WaveTimers") then
		BigWigs:Print(L["Please remove BigWigs_WaveTimers, it is deprecated."])
	end
end

function mod:GOSSIP_SHOW()
	local target = UnitName("target")
	local gossip = GetGossipOptions()
	if gossip and target == thrall or target == proudmoore then
		if gossip == L["My companions and I are with you, Lady Proudmoore."] then
			self:Sync("SummitNext RWC") -- Rage Winterchill is next
		elseif gossip == L["We are ready for whatever Archimonde might send our way, Lady Proudmoore."] then
			self:Sync("SummitNext Anatheron") -- Anatheron is next
		elseif gossip == L["I am with you, Thrall."] then
			self:Sync("SummitNext KazRogal") -- Kaz'Rogal is next
		elseif gossip == L["We have nothing to fear."] then
			self:Sync("SummitNext AzGalor") -- Az'Galor is next
		end
	end
end

function mod:UPDATE_WORLD_STATES()
	if self.zonename ~= GetRealZoneText() then return end -- bail out in case we were left running in another zone
	local uiType, state, text = GetWorldStateUIInfo(3)
	local num = tonumber(match(text or "", "(%d)") or nil)
	if num == 0 then
		self:Sync("SummitClear")  --reseting wave here will clear nextBoss, clear instead
	elseif num and num > currentWave then
		self:Sync(fmt("%s%d %s", "SummitWave ", num, GetSubZoneText()))
	end
end

do
	local proudmooreDies = fmt(UNITDIESOTHER, proudmoore)
	local thrallDies = fmt(UNITDIESOTHER, thrall)
	function mod:CHAT_MSG_COMBAT_HOSTILE_DEATH(msg)
		if msg == proudmooreDies or msg == thrallDies then
			self:Sync("SummitReset")
		end
	end
end

function mod:BigWigs_RecvSync( sync, rest )
	if not self.db.profile.waves then return end

	if sync == "SummitNext" and rest then
		if rest == "RWC" then
			nextBoss = winterchill
		elseif rest == "Anatheron" then
			nextBoss = anatheron
		elseif rest == "KazRogal" then
			nextBoss = kazrogal
		elseif rest == "AzGalor" then
			nextBoss = azgalor
		end
	elseif sync == "SummitWave" and rest then
		local wave, zone = match(rest, "(%d+) (.*)")
		if not wave or not zone then return end
		local waveTimes
		if zone == allianceBase then
			if nextBoss == winterchill then
				waveTimes = RWCwaveTimes
			else
				waveTimes = allianceWaveTimes
			end
		elseif zone == hordeEncampment then
			if nextBoss == kazrogal then
				waveTimes = KRwaveTimes
			else
				waveTimes = hordeWaveTimes
			end
		else
			return
		end
		wave = tonumber(wave)
		if wave and wave > currentWave and waveTimes[wave] then
			currentWave = wave

			self:Message(fmt(L["Wave %d incoming!"], wave), "Important")

			self:CancelScheduledEvent("BigWigsSummitTimersDM90")
			self:CancelScheduledEvent("BigWigsSummitTimersDM60")
			self:CancelScheduledEvent("BigWigsSummitTimersDM30")
			self:TriggerEvent("BigWigs_StopBar", self, waveBar )
			-- self:TriggerEvent("BigWigs_StopBar", self, fmt(L["~Wave %d spawn"], currentWave))

			local wtime = waveTimes[wave]
			if wave == 8 then
				local msg = L["%s in ~%d sec!"]
				self:ScheduleEvent("BigWigsSummitTimersDM90", "BigWigs_Message", wtime - 90, fmt(msg, nextBoss, 90), "Attention")
				self:ScheduleEvent("BigWigsSummitTimersDM60", "BigWigs_Message", wtime - 60, fmt(msg, nextBoss, 60), "Attention")
				self:ScheduleEvent("BigWigsSummitTimersDM30", "BigWigs_Message", wtime - 30, fmt(msg, nextBoss, 30), "Urgent")
				waveBar = fmt(L["~%s spawn"], nextBoss)
				self:Bar(waveBar, wtime, "Spell_Fire_FelImmolation")
			else
				local msg = L["Wave %d in ~%d sec!"]
				self:ScheduleEvent("BigWigsSummitTimersDM90", "BigWigs_Message", wtime - 90, fmt(msg, wave + 1, 90), "Attention")
				self:ScheduleEvent("BigWigsSummitTimersDM60", "BigWigs_Message", wtime - 60, fmt(msg, wave + 1, 60), "Attention")
				self:ScheduleEvent("BigWigsSummitTimersDM30", "BigWigs_Message", wtime - 30, fmt(msg, wave + 1, 30), "Urgent")
				waveBar = fmt(L["~Wave %d spawn"], wave + 1)
				self:Bar(waveBar, wtime, "Spell_Holy_Crusade")
			end
		end
	elseif sync == "SummitReset" then
		self:TriggerEvent("BigWigs_RebootModule", self)
	elseif sync == "SummitClear" then
		--not sure how to cancel bars since they have different names
		self:TriggerEvent("BigWigs_StopBar", self, waveBar)
		currentWave = 0
		self:CancelScheduledEvent("BigWigsSummitTimersDM90")
		self:CancelScheduledEvent("BigWigsSummitTimersDM60")
		self:CancelScheduledEvent("BigWigsSummitTimersDM30")
	end
end
