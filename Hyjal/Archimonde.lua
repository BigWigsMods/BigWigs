------------------------------
--      Are you local?      --
------------------------------

local boss = BB["Archimonde"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local db = nil

local UnitName = UnitName
local pName = UnitName("player")
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
	grip_you = "Grip on you!",
	grip_other = "Grip on %s!",

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
	grip_you = "Poigne sur VOUS !",
	grip_other = "Poigne sur %s !",

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
	grip_you = "당신에 손아귀!",
	grip_other = "%s에 손아귀!",

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
	grip_you = "Würgegriff auf DIR!",
	grip_other = "Würgegriff auf %s!",

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
	engage_trigger = "你们的抵抗是毫无意义的。",

	grip = "军团之握",
	grip_desc = "当玩家受到军团之握时发出警报。",
	grip_you = ">你< 军团之握！",
	grip_other = "军团之握：>%s<！",

	icon = "团队标记",
	icon_desc = "给中了军团之握的队友打上团队标记。（需要权限）",

	fear = "恐惧",
	fear_desc = "恐惧计时。",
	fear_message = "恐惧！约42秒后再次发动。",
	fear_bar = "<恐惧 冷却>",
	fear_warning = "恐惧冷却结束 - 即将发动！",

	burst = "空气爆裂",
	burst_desc = "当开始施放空气爆裂时发出警报。",
	burst_other = "空气爆裂：>%s<！",
	burst_you = ">你< 空气爆裂！",

	burstsay = "空气爆裂（说）",
	burstsay_desc = "当你为空气爆裂目标时警报周围，以帮助附近的队友远离。",
	burstsay_message = "我中了空气爆裂！离开我...",
} end )

L:RegisterTranslations("zhTW", function() return {
	engage_trigger = "你反抗是沒有用的。",

	grip = "軍團之握",
	grip_desc = "受到軍團之握時發送警告",
	grip_you = "軍團之握在你身上!",
	grip_other = "軍團之握：[%s]",

	icon = "團隊標記",
	icon_desc = "在受到軍團之握的隊友頭上標記 (需要權限)",

	fear = "恐懼術",
	fear_desc = "恐懼術計時器",
	fear_message = "恐懼術, 42 秒後再次發動!",
	fear_bar = "~恐懼術冷卻中",
	fear_warning = "恐懼術冷卻完畢 - 即將來臨!",

	burst = "空氣炸裂",
	burst_desc = "當空氣炸裂施放時時發送警告",
	burst_other = "空氣炸裂：[%s]",
	burst_you = "空氣炸裂在你身上!",

	burstsay = "空氣炸裂(說)",
	burstsay_desc = "當你為空氣爆裂目標時警報周圍，以幫助附近的隊友遠離。",
	burstsay_message = "空氣炸裂在我身上!",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = BZ["Hyjal Summit"]
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
	self:AddCombatListener("SPELL_AURA_APPLIED", "Grip", 31972)
	self:AddCombatListener("SPELL_AURA_DISPELLED", "GripRemoved", 31972)
	self:AddCombatListener("SPELL_CAST_START", "Burst", 32014)
	self:AddCombatListener("SPELL_CAST_START", "Fear", 31970)
	self:AddCombatListener("UNIT_DIED", "GenericBossDeath")

	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	db = self.db.profile
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Grip(player, spellID)
	if db.grip then
		local other = fmt(L["grip_other"], player)
		if player == pName then
			self:LocalMessage(L["grip_you"], "Attention", spellID, "Long")
			self:WideMessage(other)
		else
			self:IfMessage(other, "Attention", spellID)
		end
		self:Bar(other, 10, spellID)
		self:Icon(player, "icon")
	end
end

function mod:GripRemoved(player)
	if db.grip then
		self:TriggerEvent("BigWigs_StopBar", self, fmt(L["grip_other"], player))
	end
end

function mod:Burst()
	if db.burst then
		self:ScheduleEvent("BWBurstToTScan", self.TargetCheck, 0.2, self)
	end
end

function mod:Fear(_, spellID)
	if db.fear then
		self:Bar(L["fear_bar"], 41.5, spellID)
		self:IfMessage(L["fear_message"], "Important", spellID)
		self:DelayedMessage(41.5, L["fear_warning"], "Urgent")
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L["engage_trigger"] then
		if db.enrage then
			self:Enrage(600)
		end
		if db.fear then
			self:Bar(L["fear_bar"], 40, "Spell_Shadow_DeathScream")
			self:DelayedMessage(40, L["fear_warning"], "Urgent")
		end
		self:TriggerEvent("BigWigs_ShowProximity", self)
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
			self:LocalMessage(L["burst_you"], "Personal", 32014, "Long")
			self:WideMessage(fmt(L["burst_other"], target))
			if db.burstsay then
				SendChatMessage(L["burstsay_message"], "SAY")
			end
		else
			self:IfMessage(fmt(L["burst_other"], target), "Attention", 32014)
		end
	end
end

