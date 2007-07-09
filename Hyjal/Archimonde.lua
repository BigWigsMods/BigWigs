------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Archimonde"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Archimonde",

	engage_trigger = "Your resistance is insignificant.",

	grip = "Grip of the Legion",
	grip_desc = "Warn who has Grip of the Legion.",
	grip_trigger = "^([^%s]+) ([^%s]+) afflicted by Grip of the Legion.$",
	grip_you = "Grip on you!",
	grip_other = "Grip on %s!",

	icon = "Raid Icon",
	icon_desc = "Place a Raid Icon on the player with Grip of the Legion.",

	fear = "Fear",
	fear_desc = "Fear Timers.",
	fear_message = "Fear, next in ~30sec!",
	fear_bar = "~Fear Cooldown",
	fear_warning = "Fear Soon!",
} end )

L:RegisterTranslations("frFR", function() return {
	engage_trigger = "Votre résistance est futile.", -- à vérifier

	grip = "Poigne de la Légion",
	grip_desc = "Préviens quand un joueur subit les effets de la Poigne de la Légion.",
	grip_trigger = "^([^%s]+) ([^%s]+) les effets .* Poigne de la Légion.$",
	grip_you = "Poigne sur VOUS !",
	grip_other = "Poigne sur %s !",

	icon = "Icône",
	icon_desc = "Place une icône de raid sur le dernier joueur affecté par la Poigne de la Légion.",

	fear = "Fear",
	fear_desc = "Délais concernant les fears.",
	fear_message = "Fear, prochain dans ~30 sec. !",
	fear_bar = "~Cooldown Fear",
	fear_warning = "Fear imminent !",
} end )

L:RegisterTranslations("koKR", function() return {
	engage_trigger = "아무리 저항해도 소용없다!",

	grip = "군단의 손아귀",
	grip_desc = "군단의 손아귀에 걸린 사람을 알립니다.",
	grip_trigger =  "^([^|;%s]*)(.*)군단의 손아귀에 걸렸습니다.$",
	grip_you = "당신에 손아귀!",
	grip_other = "%s에 손아귀!",

	icon = "전술 표시",
	icon_desc = "군단의 손아귀에 걸린 플레이어에 전술 표시를 지정합니다.",

	fear = "공포",
	fear_desc = "공포 타이머입니다.",
	fear_message = "공포, 다음은 약 30초 이내!",
	fear_bar = "~공포 대기시간",
	fear_warning = "잠시 후 공포!",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Hyjal Summit"]
mod.enabletrigger = boss
mod.toggleoptions = {"grip", "icon", "fear", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))
mod.proximityCheck = function( unit ) return CheckInteractDistance( unit, 3 ) end
mod.proximitySilent = true

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "ArchGrip", 2)
	self:TriggerEvent("BigWigs_ThrottleSync", "ArchFear", 5)
	self:TriggerEvent("BigWigs_ShowProximity", self)

	self:RegisterEvent("UNIT_SPELLCAST_START")
	
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "GripEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "GripEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "GripEvent")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:BigWigs_RecvSync(sync, rest, nick)
	if sync == "ArchGrip" and rest and self.db.profile.grip then
		local other = L["grip_other"]:format(rest)
		if rest == UnitName("player") then
			self:Message(L["grip_you"], "Personal", true, "Long")
			self:Message(other, "Attention", nil, nil, true)
			self:Bar(other, 10, "Spell_Shadow_SoulLeech_3")
		else
			self:Message(other, "Attention")
			self:Bar(other, 10, "Spell_Shadow_SoulLeech_3")
		end
		if self.db.profile.icon then
			self:Icon(rest)
		end
	elseif sync == "ArchFear" and self.db.profile.fear then
		self:Bar(L["fear_bar"], 30, "Spell_Shadow_DeathScream")
		self:Message(L["fear_message"], "Important")
		self:DelayedMessage(25, L["fear_warning"], "Urgent")
	end
end

function mod:GripEvent(msg)
	local gplayer, gtype = select(3, msg:find(L["grip_trigger"]))
	if gplayer and gtype then
		if gplayer == L2["you"] and gtype == L2["are"] then
			gplayer = UnitName("player")
		end
		self:Sync("ArchGrip "..gplayer)
	end
end

function mod:UNIT_SPELLCAST_START(msg)
	if UnitName(msg) == boss and (UnitCastingInfo(msg)) == L["fear"] then
		self:Sync("ArchFear")
	end
end

