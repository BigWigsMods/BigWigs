------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Archimonde"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")
local db = nil

local UnitName = UnitName
local pName = nil
local IsItemInRange = IsItemInRange
local fmt = string.format
local bandages = {
	[21991] = true, -- Heavy Netherweave Bandage
	[21990] = true, -- Netherweave Bandage
	[14530] = true, -- Heavy Runecloth Bandage
	[14529] = true, -- Runecloth Bandage
	[8545] = true, -- Heavy Mageweave Bandage
	[8544] = true, -- Mageweave Bandage
	[6451] = true, -- Heavy Silk Bandage
	[6450] = true, -- Silk Bandage
	[3531] = true, -- Heavy Wool Bandage
	[3530] = true, -- Wool Bandage
	[2581] = true, -- Heavy Linen Bandage
	[1251] = true, -- Linen Bandage
}

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Archimonde",

	engage_trigger = "Your resistance is insignificant.",

	grip = "Grip of the Legion",
	grip_desc = "Warn who has Grip of the Legion.",
	grip_trigger = "^(%S+) (%S+) afflicted by Grip of the Legion%.$",
	grip_you = "Grip on you!",
	grip_other = "Grip on %s!",
	grip_fade = "^Grip of the Legion fades from (%S+)%.$",

	icon = "Raid Icon",
	icon_desc = "Place a Raid Icon on the player with Grip of the Legion.",

	fear = "Fear",
	fear_desc = "Fear Timers.",
	fear_message = "Fear, next in ~ 42sec!",
	fear_bar = "~Fear Cooldown",
	fear_warning = "Fear Cooldown Over - Inc Soon!",

	burst = "Air Burst",
	burst_desc = "Warn who Air Burst is being cast on.",
	burst_other = "Air Burst on -%s-",
	burst_you = "Air Burst on YOU!",

	burstsay = "Air Burst Say",
	burstsay_desc = "Print in say when you are targetted for Air Burst, can help nearby members with speech bubbles on.",
	burstsay_message = "Air Burst on me!",
} end )

L:RegisterTranslations("frFR", function() return {
	engage_trigger = "Votre résistance est futile.",

	grip = "Poigne de la Légion",
	grip_desc = "Préviens quand un joueur subit les effets de la Poigne de la Légion.",
	grip_trigger = "^(%S+) (%S+) les effets .* Poigne de la Légion%.$",
	grip_you = "Poigne sur VOUS !",
	grip_other = "Poigne sur %s !",
	grip_fade = "^Poigne de la Légion sur (%S+) vient de se dissiper%.$",

	icon = "Icône",
	icon_desc = "Place une icône de raid sur le dernier joueur affecté par la Poigne de la Légion.",

	fear = "Peur",
	fear_desc = "Délais concernant les Peurs.",
	fear_message = "Peur, prochain dans ~42 sec. !",
	fear_bar = "~Cooldown Peur",
	fear_warning = "Fin du cooldown Peur - Imminent !",

	burst = "Jaillissement d'air",
	burst_desc = "Préviens sur qui le Jaillissement d'air est incanté.",
	burst_other = "Jaillissement d'air sur -%s-",
	burst_you = "Jaillissement d'air sur VOUS !",

	burstsay = "Dire - Jaillissement d'air",
	burstsay_desc = "Fais dire à votre personnage que vous êtes ciblé par le Jaillissement d'air quand c'est le cas, afin d'aider les membres proches ayant les bulles de dialogue d'activés.",
	burstsay_message = "Jaillissement d'air sur moi !",
} end )

L:RegisterTranslations("koKR", function() return {
	engage_trigger = "아무리 저항해도 소용없다!",

	grip = "군단의 손아귀",
	grip_desc = "군단의 손아귀에 걸린 사람을 알립니다.",
	grip_trigger =  "^([^|;%s]*)(.*)군단의 손아귀에 걸렸습니다%.$",
	grip_you = "당신에 손아귀!",
	grip_other = "%s에 손아귀!",
	--grip_fade = "^Grip of the Legion fades from (%S+)%.$",

	icon = "전술 표시",
	icon_desc = "군단의 손아귀에 걸린 플레이어에 전술 표시를 지정합니다.",

	fear = "공포",
	fear_desc = "공포 타이머입니다.",
	fear_message = "공포, 다음은 약 ~42초 이내!",
	fear_bar = "~공포 대기시간",
	fear_warning = "공포 대기시간 종료 - 잠시 후 공포!",

	burst = "대기 파열",
	burst_desc = "대기 파열 시전 대상을 알립니다.",
	burst_other = "-%s- 대기 파열",
	burst_you = "당신에 대기 파열!",

	burstsay = "대기 파열 알림",
	burstsay_desc = "자신이 대기 파열의 대상이 되었을 때 일반 대화로 알립니다.",
	burstsay_message = "저! 대기 파열! 피하세요!!",
} end )

L:RegisterTranslations("deDE", function() return {
	engage_trigger = "Euer Widerstand ist sinnlos!",

	grip = "Würgegriff der Legion",
	grip_desc = "Warnt wer den Würgegriff der Legion hat.",
	grip_trigger = "^([^%s]+) ([^%s]+) ist von Würgegriff der Legion betroffen%.$",
	grip_you = "Würgegriff auf DIR!",
	grip_other = "Würgegriff auf %s!",
	--grip_fade = "^Grip of the Legion fades from (%S+)%.$",

	icon = "Schlachtzug Symbol",
	icon_desc = "Plaziert ein Schlachtzug Symbol auf Spielern mit Würgegriff der Legion Debuff.",

	fear = "Furcht",
	fear_desc = "Furcht Timer.",
	fear_message = "Furcht, nächster in ~ 42sek!",
	fear_bar = "~Furcht Cooldown",
	fear_warning = "Furcht Cooldown Vorbei - Neue Furcht Bald!",

	burst = "Windbö",
	burst_desc = "Warnt auf wen Windbö gezaubert wird.",
	burst_other = "Windbö auf -%s-",
	burst_you = "Windbö auf DIR!",

	burstsay = "Windbö Sagen",
	burstsay_desc = "Schreibe in /sagen wenn du das Ziel von Windbö bist, dies kann angrenzenden Membern mit aktivierten Sprechblasen helfen.",
	burstsay_message = "Windbö auf mir!",
} end )

L:RegisterTranslations("zhCN", function() return {
	engage_trigger = "你们的抵抗是毫无意义的。$",

	grip = "军团之握",
	grip_desc = "警报谁中了军团之握",
	grip_trigger = "^(%S+)受(%S+)了军团之握效果的影响。$",
	grip_you = "你中了 军团之握!",
	grip_other = "%s中了 军团之握!",
	--grip_fade = "^Grip of the Legion fades from (%S+)%.$",

	icon = "团队标记",
	icon_desc = "给中了军团之握的队友打上团队标记.",

	fear = "恐惧",
	fear_desc = "恐惧计时.",
	fear_message = "恐惧, ~ 42秒后再次发动!",
	fear_bar = "~恐惧 冷却",
	fear_warning = "恐惧冷却结束 - 即将发动!",

	burst = "空气爆裂",
	burst_desc = "当开始施放空气爆裂时发出警报.",
	burst_other = "空气爆裂 -%s-",
	burst_you = "空气爆裂 >你<!",

	burstsay = "空气爆裂(说)",
	burstsay_desc = "当你为空气爆裂目标时警报周围,以帮助附近的队友远离.",
	burstsay_message = "我中了 空气爆裂! 离开我....",
} end )

L:RegisterTranslations("zhTW", function() return {
	engage_trigger = "你反抗是沒有用的。",

	grip = "軍團之握",
	grip_desc = "受到軍團之握時發送警告",
	grip_trigger = "^(.+)受(到[了]*)軍團之握效果的影響。",
	grip_you = "軍團之握在你身上!",
	grip_other = "軍團之握：[%s]",
	--grip_fade = "^Grip of the Legion fades from (%S+)%.$",

	icon = "團隊標記",
	icon_desc = "在受到軍團之握的隊友頭上標記 (需要權限)",

	fear = "恐懼術",
	fear_desc = "恐懼術計時器",
	fear_message = "恐懼術, 下次來臨 ~ 42秒!",
	fear_bar = "~恐懼術冷卻中",
	fear_warning = "恐懼術冷卻完畢 - 即將來臨!",

	burst = "空氣炸裂",
	burst_desc = "當空氣炸裂施放時時發送警告",
	burst_other = "空氣炸裂：[%s]",
	burst_you = "空氣炸裂在你身上!",

	burstsay = "空氣炸裂(說)",
	burstsay_desc = "當你為空氣爆裂目標時警報周圍,以幫助附近的隊友遠離.",
	burstsay_message = "空氣炸裂在我身上!",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Hyjal Summit"]
mod.enabletrigger = boss
mod.toggleoptions = {"grip", "icon", "fear", "burst", "burstsay", "proximity", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))
mod.proximityCheck = function( unit ) 
	for k, v in pairs( bandages ) do
		if IsItemInRange( k, unit) == 1 then
			return true
		end
	end
	return false
end
mod.proximitySilent = true

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "ArchGrip", 2)
	self:TriggerEvent("BigWigs_ThrottleSync", "ArchFear", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "ArchBurst", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "ArchFade", 0.1)

	self:RegisterEvent("UNIT_SPELLCAST_START")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "GripEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "GripEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "GripEvent")

	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_PARTY")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_SELF")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER")

	pName = UnitName("player")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	db = self.db.profile
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:BigWigs_RecvSync(sync, rest, nick)
	if sync == "ArchGrip" and rest and db.grip then
		local other = fmt(L["grip_other"], rest)
		if rest == pName then
			self:Message(L["grip_you"], "Attention", true, "Long")
			self:Message(other, "Attention", nil, nil, true)
			self:Bar(other, 10, "Spell_Shadow_SoulLeech_3")
		else
			self:Message(other, "Attention")
			self:Bar(other, 10, "Spell_Shadow_SoulLeech_3")
		end
		if db.icon then
			self:Icon(rest)
		end
	elseif sync == "ArchFear" and db.fear then
		self:Bar(L["fear_bar"], 41.5, "Spell_Shadow_DeathScream")
		self:Message(L["fear_message"], "Important")
		self:DelayedMessage(41.5, L["fear_warning"], "Urgent")
	elseif sync == "ArchBurst" and db.burst then
		self:ScheduleEvent("BWBurstToTScan", self.TargetCheck, 0.3, self)
	elseif sync == "ArchFade" and rest and db.grip then
		self:TriggerEvent("BigWigs_StopBar", self, fmt(L["grip_other"], rest))
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L["engage_trigger"] then
		if db.enrage then
			self:Message(fmt(L2["enrage_start"], boss, 10), "Attention")
			self:DelayedMessage(300, fmt(L2["enrage_min"], 5), "Positive")
			self:DelayedMessage(420, fmt(L2["enrage_min"], 3), "Positive")
			self:DelayedMessage(540, fmt(L2["enrage_min"], 1), "Positive")
			self:DelayedMessage(570, fmt(L2["enrage_sec"], 30), "Positive")
			self:DelayedMessage(590, fmt(L2["enrage_sec"], 10), "Urgent")
			self:DelayedMessage(595, fmt(L2["enrage_sec"], 5), "Urgent")
			self:DelayedMessage(600, fmt(L2["enrage_end"], boss), "Attention", nil, "Alarm")
			self:Bar(L2["enrage"], 600, "Spell_Shadow_UnholyFrenzy")
		end
		if db.fear then
			self:Bar(L["fear_bar"], 40, "Spell_Shadow_DeathScream")
			self:DelayedMessage(40, L["fear_warning"], "Urgent")
		end
		self:TriggerEvent("BigWigs_ShowProximity", self)
	end
end

function mod:GripEvent(msg)
	local gplayer, gtype = select(3, msg:find(L["grip_trigger"]))
	if gplayer and gtype then
		if gplayer == L2["you"] and gtype == L2["are"] then
			gplayer = pName
		end
		self:Sync("ArchGrip", gplayer)
	end
end

function mod:UNIT_SPELLCAST_START(msg)
	if UnitName(msg) == boss and (UnitCastingInfo(msg)) == L["fear"] then
		self:Sync("ArchFear")
	elseif UnitName(msg) == boss and (UnitCastingInfo(msg)) == L["burst"] then
		self:Sync("ArchBurst")
	end
end

function mod:CHAT_MSG_SPELL_AURA_GONE_PARTY(msg) --grip clearing
	local fplayer = select(3, msg:find(L["grip_fade"]))
	if fplayer then
		self:Sync("ArchFade", fplayer)
	end
end

function mod:CHAT_MSG_SPELL_AURA_GONE_OTHER(msg) --grip clearing
	local ofplayer = select(3, msg:find(L["grip_fade"]))
	if ofplayer then
		self:TriggerEvent("BigWigs_StopBar", self, fmt(L["grip_other"], ofplayer))
	end
end

function mod:CHAT_MSG_SPELL_AURA_GONE_SELF(msg) --grip clearing
	if msg:find(L["grip_fade"]) then
		self:Sync("ArchFade", pName)
	end
end

function mod:TargetCheck()
	local target
	if UnitName("target") == boss then
		target = UnitName("targettarget")
	elseif UnitName("focus") == boss then
		target = UnitName("focustarget")
	else
		local num = GetNumRaidMembers()
		for i = 1, num do
			if UnitName(fmt("%s%d%s", "raid", i, "target")) == boss then
				target = UnitName(fmt("%s%d%s", "raid", i, "targettarget"))
				break
			end
		end
	end
	if target then
		if target == pName then
			self:Message(L["burst_you"], "Personal", true, "Long")
			self:Message(fmt(L["burst_other"], target), "Attention", nil, nil, true)
			if db.burstsay then
				SendChatMessage(L["burstsay_message"], "SAY")
			end
		else
			self:Message(fmt(L["burst_other"], target), "Attention")
		end
	end
end
