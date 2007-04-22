------------------------------
--      Are you local?    --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Gruul the Dragonkiller"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local grasp
local slam
local growcount

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
--      Localization     --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Gruul",

	engage = "Engage",
	engage_desc = "Warn when Grull is pulled",

	grow = "Grow",
	grow_desc = "Count and warn for Grull's grow",

	grasp = "Grasp",
	grasp_desc = "Grasp warnings and timers",

	cavein = "Cave In on You",
	cavein_desc = "Warn for a Cave In on You",

	silence = "Silence",
	silence_desc = "Warn when Gruul casts AOE Silence (Reverberation)",

	engage_trigger = "Come.... and die.",
	engage_message = "%s Engaged!",

	grow_trigger = "%s grows in size!",
	grow_message = "Grows: (%d)",
	grow_bar = "Grow (%d)",

	grasp_trigger1 = "afflicted by Ground Slam",
	grasp_trigger2 = "afflicted by Gronn Lord's Grasp",
	grasp_message1 = "Ground Slam - Grasp Incoming",
	grasp_message2 = "Grasp Stacking - Shatter in ~5sec",
	grasp_warning = "Ground Slam Soon",

	shatter_trigger = "%s roars!",
	shatter_message = "Shatter!",

	silence_trigger = "afflicted by Reverberation",
	silence_message = "AOE Silence",
	silence_warning = "AOE Silence soon!",

	cavein_trigger = "You are afflicted by Cave In.",
	cavein_message = "Cave In on YOU!",
} end)

L:RegisterTranslations("frFR", function() return {
	engage = "Engagement",
	engage_desc = "Pr\195\169viens quand Grull est engag\195\169.",

	grow = "Croissance",
	grow_desc = "Compte et les croissances de Grull et préviens de ses arriv\195\169es.",

	grasp = "Emprise",
	grasp_desc = "Avertissement et d\195\169lais pour Emprise du seigneur gronn.",

	cavein = "Eboulement sur vous",
	cavein_desc = "Pr\195\169viens quand vous \195\170tes sous un \195\169boulement.",

	silence = "Silence",
	silence_desc = "Pr\195\169viens quand Gruul lance son Silence de zone (R\195\169verb\195\169ration).",

	engage_trigger = "Venez\226\128\166 mourir.",
	engage_message = "%s engag\195\169 !",

	grow_trigger = "%s grandit\194\160!",
	grow_message = "Croissance : (%d)",
	grow_bar = "Croissance (%d)",

	grasp_trigger1 = "les effets .* Heurt terrestre",
	grasp_trigger2 = "les effets .* Emprise du seigneur gronn",
	grasp_message1 = "Heurt terrestre - Emprise imminente",
	grasp_message2 = "Emprise - Fracasser dans ~5 sec.",
	grasp_warning = "Heurt terrestre imminent",

	shatter_trigger = "%s rugit\194\160!",
	shatter_message = "Fracasser !",

	silence_trigger = "les effets .* R\195\169verb\195\169ration.",
	silence_message = "Silence de zone",
	silence_warning = "Silence de zone imminent !",

	cavein_trigger = "Vous subissez les effets de Eboulement.",
	cavein_message = "Eboulement sur VOUS !",
} end)

L:RegisterTranslations("deDE", function() return {
	engage = "Pull Warnung",
	engage_desc = "Warnt, wenn Gruul gepulled wird",

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

	grasp_trigger1 = "von Erde ersch\195\188ttern betroffen",
	grasp_trigger2 = "von Griff des Gronnlords betroffen",
	grasp_message1 = "Erde ersch\195\188tert - Griff kommt", 
	grasp_message2 = "Griff - Zert\195\188mmern in ~5 sek",
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
	engage = "전투 개시",
	engage_desc = "전투 개시 알림",

	grow = "성장",
	grow_desc = "그룰의 성장에 대한 카운트와 경고",

	grasp = "손아귀",
	grasp_desc = "손아귀 경고와 타이머",

	cavein = "당신의 함몰",
	cavein_desc = "당신의 함몰에 대한 경고",

	silence = "침묵 경고",
	silence_desc = "그룰이 광역 침묵(산울림) 시전 시 경고",

	engage_trigger = "이리 와서... 죽어.",
	engage_message = "%s 전투 개시!",

	grow_trigger = "%s|1이;가; 점점 커집니다!",
	grow_message = "성장: (%d)",
	grow_bar = "(%d) 성장",

	grasp_trigger1 = "땅 울리기에 걸렸습니다%.$",
	grasp_trigger2 = "우두머리 그론의 손아귀에 걸렸습니다%.$",
	grasp_message1 = "땅 울리기 - 잠시 후 손아귀",
	grasp_message2 = "손아귀 대기 - 약 5초 후 석화",
	grasp_warning = "잠시 후 땅 울리기",

	shatter_trigger = "%s|1이;가; 포효합니다!",
	shatter_message = "석화!",

	silence_trigger = "산울림에 걸렸습니다.",
	silence_message = "광역 침묵",
	silence_warning = "잠시 후 광역 침묵!",

	cavein_trigger = "당신은 함몰에 걸렸습니다.",
	cavein_message = "당신은 함몰!",
} end)

----------------------------------
--    Module Declaration   --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Gruul's Lair"]
mod.otherMenu = "Outland"
mod.enabletrigger = boss
mod.toggleoptions = {"engage", "grasp", "grow", -1, "cavein", "silence", "proximity", "bosskill"}
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
	slam = nil
	grasp = nil
	silence = nil
	growcount = 1
	self.proximitySilent = true

	self:RegisterEvent("BigWigs_Message")
	self:RegisterEvent("CHAT_MSG_MONSTER_SAY")
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Event")

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
end

------------------------------
--    Event Handlers     --
------------------------------

function mod:CHAT_MSG_MONSTER_SAY(msg)
	if msg == L["engage_trigger"] then
		if self.db.profile.engage then
			self:Message(L["engage_message"]:format(boss), "Attention")
			self:DelayedMessage(35, L["grasp_warning"], "Urgent")
			self:Bar(L["grasp_warning"], 40, "Ability_ThunderClap")
			self:DelayedMessage(95, L["silence_warning"], "Urgent")
			self:Bar(L["silence_message"], 100, "Spell_Holy_ImprovedResistanceAuras")
		end
		self:TriggerEvent("BigWigs_ShowProximity", self)
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
		end
	end
end

function mod:Event(msg)
	if not slam and msg:find(L["grasp_trigger1"]) then
		if self.db.profile.grasp then
			self:Message(L["grasp_message1"], "Attention")
			self:DelayedMessage(67, L["grasp_warning"], "Urgent")
			self:Bar(L["grasp_warning"], 72, "Ability_ThunderClap")
		end
		self.proximitySilent = nil
		slam = true
	elseif not grasp and self.db.profile.grasp and msg:find(L["grasp_trigger2"]) then
		self:Message(L["grasp_message2"], "Urgent")
		self:Bar(L["shatter_message"], 5, "Ability_ThunderClap")
		grasp = true
	elseif self.db.profile.cavein and msg == L["cavein_trigger"] then
		self:Message(L["cavein_message"], "Personal", true, "Alarm")
	elseif not silence and self.db.profile.silence and msg:find(L["silence_trigger"]) then
		self:Message(L["silence_message"], "Attention")
		self:DelayedMessage(40, L["silence_warning"], "Urgent")
		self:Bar(L["silence_message"], 45, "Spell_Holy_ImprovedResistanceAuras")
		silence = true
	end
end

function mod:BigWigs_Message(text)
	if text == L["grasp_warning"] then
		slam = nil
		grasp = nil
	end
	if text == L["silence_warning"] then
		silence = nil
	end
end

