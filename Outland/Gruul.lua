------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Gruul the Dragonkiller"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local growcount = 1
local silence = nil

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
	cmd = "Gruul",

	engage_trigger = "Come.... and die.",
	engage_message = "%s Engaged!",

	grow = "Grow",
	grow_desc = "Count and warn for Grull's grow.",
	grow_trigger = "%s grows in size!",
	grow_message = "Grows: (%d)",
	grow_bar = "Grow (%d)",

	grasp = "Grasp",
	grasp_desc = "Grasp warnings and timers.",
	grasp_trigger1 = "Scurry.",
	grasp_trigger2 = "No escape.",
	grasp_message = "Ground Slam - Shatter in ~10sec!",
	grasp_warning = "Ground Slam Soon",
	grasp_bar = "~Ground Slam Cooldown",

	cavein = "Cave In on You",
	cavein_desc = "Warn for a Cave In on You.",
	cavein_trigger = "You are afflicted by Cave In.",
	cavein_message = "Cave In on YOU!",

	silence = "Silence",
	silence_desc = "Warn when Gruul casts AOE Silence (Reverberation).",
	silence_trigger = "afflicted by Reverberation",
	silence_message = "AOE Silence",
	silence_warning = "AOE Silence soon!",
	silence_bar = "~Silence Cooldown",

	shatter_trigger = "%s roars!",
	shatter_message = "Shatter!",
} end)

L:RegisterTranslations("frFR", function() return {
	engage_trigger = "Venez… mourir.",
	engage_message = "%s engagé !",

	grow = "Croissance",
	grow_desc = "Compte les croissances de Grull et préviens de ses arrivées.",
	grow_trigger = "%s grandit !",
	grow_message = "Croissance : (%d)",
	grow_bar = "Croissance (%d)",

	grasp = "Emprise",
	grasp_desc = "Avertissements et délais pour Emprise du seigneur gronn.",
	grasp_trigger1 = "Cavalez.",
	grasp_trigger2 = "On ne s'échappe pas.",
	grasp_message = "Heurt terrestre - Emprise dans ~10 sec !",
	grasp_warning = "Heurt terrestre imminent",
	grasp_bar = "~Cooldown Heurt terrestre",

	cavein = "Eboulement sur vous",
	cavein_desc = "Préviens quand vous êtes sous un éboulement.",
	cavein_trigger = "Vous subissez les effets de Eboulement.",
	cavein_message = "Eboulement sur VOUS !",

	silence = "Silence",
	silence_desc = "Préviens quand Gruul lance son Silence de zone (Réverbération).",
	silence_trigger = "les effets .* Réverbération",
	silence_message = "Silence de zone",
	silence_warning = "Silence de zone imminent !",
	silence_bar = "~Cooldown Silence",

	shatter_trigger = "%s rugit !",
	shatter_message = "Fracasser !",
} end)

L:RegisterTranslations("deDE", function() return {
	grow = "Wachstum", 
	grow_desc = "Warnt wenn Gruul Wachstum bekommt", 

	grasp = "Griff des Gronnlords",
	grasp_desc = "Griff des Gronnlords warnung und Zeitanzeige", 

	cavein = "H\195\182hleneinst\195\188rz",
	cavein_desc = "Warnt beim H\195\182hleneinst\195\188rz auf dir",

	silence = "Stille",
	silence_desc = "Warnt wenn Gruul stille (Nachwirken) wirkt",

	engage_trigger = "Kommt und sterbt.",
	engage_message = "%s gepullt!",

	grow_trigger = "%s wird gr\195\182\195\159er!",
	grow_message = "Wachstum: (%d)",
	grow_bar = "Wachstum (%d)",

	--grasp_trigger1 = "von Erde ersch\195\188ttern betroffen", --yell 1
	--grasp_trigger2 = "von Griff des Gronnlords betroffen", --yell 2
	grasp_message = "Erde ersch\195\188tert - Griff kommt", 
	grasp_warning = "Erde ersch\195\188tern bald!", 

	shatter_trigger = "%s br\195\188llt!",
	shatter_message = "Zertr\195\188mmern!",

	silence_trigger = "von Nachklingen betroffen",
	silence_message = "AOE Stille",
	silence_warning = "AOE Stille bald!",


	cavein_trigger = "Ihr seid von H\195\182hleneinst\195\188rz betroffen.",
	cavein_message = "H\195\182hleneinst\195\188rz auf dir!",
} end)

L:RegisterTranslations("koKR", function() return {
	engage_trigger = "와서... 죽어라.",
	engage_message = "%s 전투 개시!",

	grow = "성장",
	grow_desc = "그룰의 성장에 대한 카운트와 경고.",
	grow_trigger = "%s|1이;가; 점점 커집니다!",
	grow_message = "성장: (%d)",
	grow_bar = "(%d) 성장",

	grasp = "손아귀",
	grasp_desc = "손아귀 경고와 타이머.",
	grasp_trigger1 = "꺼져라.",
	grasp_trigger2 = "숨을 곳은 없다.",
	grasp_message = "땅 울리기 - 약 10초 이내 석화!",
	grasp_warning = "잠시 후 땅 울리기",
	grasp_bar = "~땅 울리기 대기시간",

	cavein = "당신의 함몰",
	cavein_desc = "당신의 함몰에 대한 경고.",
	cavein_trigger = "당신은 함몰에 걸렸습니다.",
	cavein_message = "당신은 함몰!",

	silence = "침묵 경고",
	silence_desc = "그룰이 광역 침묵(산울림) 시전 시 경고.",
	silence_trigger = "산울림에 걸렸습니다.",
	silence_message = "광역 침묵",
	silence_warning = "잠시 후 광역 침묵!",
	silence_bar = "~침묵 대기시간",

	shatter_trigger = "%s|1이;가; 포효합니다!",
	shatter_message = "석화!",
} end)

L:RegisterTranslations("zhTW", function() return {
	engage_trigger = "來……受死吧。",
	engage_message = "%s 進入戰鬥",

	grow = "成長警告",
	grow_desc = "計算並當戈魯爾成長時發送警告",
	grow_trigger = "%s 變大了!",
	grow_message = "成長 : (%d)",
	grow_bar = "成長 (%d)",

	grasp = "破碎警告",
	grasp_desc = "當戈魯爾施放大地猛擊跟破碎時發送警告並顯示計時條",
	grasp_trigger1 = "快跑。",
	grasp_trigger2 = "待在這裡。",
	grasp_message = "大地猛擊 - 10 秒內破碎",
	grasp_warning = "戈魯爾即將施放大地猛擊",
	grasp_bar = "大地猛擊",

	cavein = "塌下警告",
	cavein_desc = "當你在塌下的範圍時發送警告",
	cavein_trigger = "你受到塌下的傷害",
	cavein_message = "你在塌下的範圍",

	silence = "沉默警告",
	silence_desc = "當戈魯爾施放範圍沉默時發送警告 (迴響)",
	silence_trigger = "受到迴響的傷害",
	silence_message = "迴響 - 範圍沉默",
	silence_warning = "戈魯爾即將施放迴響",
	silence_bar = "迴響",

	shatter_trigger = "%s 吼叫!",
	shatter_message = "破碎",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Gruul's Lair"]
mod.otherMenu = "Outland"
mod.enabletrigger = boss
mod.toggleoptions = {"grasp", "grow", -1, "cavein", "silence", "proximity", "bosskill"}
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
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Event")

	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L["engage_trigger"] then
		silence = nil
		growcount = 1
		self.proximitySilent = true
		self:TriggerEvent("BigWigs_ShowProximity", self)

		self:Message(L["engage_message"]:format(boss), "Attention")

		if self.db.profile.grasp then
			self:DelayedMessage(35, L["grasp_warning"], "Urgent")
			self:Bar(L["grasp_bar"], 40, "Ability_ThunderClap")
		end
		if self.db.profile.silence then
			self:DelayedMessage(97, L["silence_warning"], "Urgent")
			self:Bar(L["silence_bar"], 102, "Spell_Holy_ImprovedResistanceAuras")
		end
		if self.db.profile.grow then
			self:Bar(L["grow_bar"]:format(growcount), 30, "Spell_Shadow_Charm")
		end
	elseif msg == L["grasp_trigger1"] or msg == L["grasp_trigger2"] then
		self.proximitySilent = nil

		if self.db.profile.grasp then
			self:Message(L["grasp_message"], "Attention")
			self:Bar(L["shatter_message"], 10, "Ability_ThunderClap")
		end
	end
end

function mod:CHAT_MSG_MONSTER_EMOTE(msg)
	if self.db.profile.grow and msg == L["grow_trigger"] then
		self:Message(L["grow_message"]:format(growcount), "Important")
		growcount = growcount + 1
		self:Bar(L["grow_bar"]:format(growcount), 30, "Spell_Shadow_Charm")
	elseif msg == L["shatter_trigger"] then
		self.proximitySilent = true

		if self.db.profile.grasp then
			self:Message(L["shatter_message"], "Positive")
			self:DelayedMessage(64, L["grasp_warning"], "Urgent")
			self:Bar(L["grasp_bar"], 70, "Ability_ThunderClap")
		end
	end
end

function mod:Event(msg)
	if self.db.profile.cavein and msg == L["cavein_trigger"] then
		self:Message(L["cavein_message"], "Personal", true, "Alarm")
	elseif not silence and self.db.profile.silence and msg:find(L["silence_trigger"]) then
		self:Message(L["silence_message"], "Attention")
		self:DelayedMessage(41, L["silence_warning"], "Urgent")
		self:Bar(L["silence_bar"], 45, "Spell_Holy_ImprovedResistanceAuras")
		silence = true
		self:ScheduleEvent("BWGrullNilSilence", function() silence = nil end, 10, self)
	end
end
