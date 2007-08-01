------------------------------
--      Are you local?      --
------------------------------

local BB = AceLibrary("Babble-Boss-2.2")
local boss = BB["The Illidari Council"]
local malande = BB["Lady Malande"]
local gathios = BB["Gathios the Shatterer"]
local zerevor = BB["High Nethermancer Zerevor"]
local veras = BB["Veras Darkshadow"]
BB = nil

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")

local pName = nil

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "TheIllidariCouncil",

	immune = "Immunity Warning",
	immune_desc = "Warn when Malande becomes immune to spells or melee attacks.",
	immune_spell_trigger = "Lady Malande gains Blessing of Spell Warding.",
	immune_melee_trigger = "Lady Malande gains Blessing of Protection.",
	immune_message = "Malande: %s Immune for 15sec!",
	immune_bar = "%s Immune!",

	spell = "Spell",
	melee = "Melee",

	shield = "Reflective Shield",
	shield_desc = "Warn when Malande Gains Reflective Shield.",
	shield_trigger = "Lady Malande gains Reflective Shield.",
	shield_message = "Reflective Shield on Malande!",

	poison = "Deadly Poison",
	poison_desc = "Warn for Deadly Poison on players.",
	poison_trigger = "^([^%s]+) ([^%s]+) afflicted by Deadly Poison%.$",
	poison_other = "%s has Deadly Poison!",
	poison_you = "Deadly Poison on YOU!",

	icon = "Raid Icon",
	icon_desc = "Place a Raid Icon on the player with Deadly Poison.",

	circle = "Circle of Healing",
	circle_desc = "Warn when Malande begins to cast Circle of Healing.",
	circle_trigger = "Lady Malande begins to cast Circle of Healing.",
	circle_message = "Casting Circle of Healing!",
	circle_heal_trigger = "^Lady Malande 's Circle of Healing heals",
	circle_fail_trigger = "^([^%s]+) interrupts? Lady Malande's Circle of Healing%.$",
	circle_heal_message = "Healed! - Next in ~20sec",
	circle_fail_message = "Interrupted! - Next in ~12sec",
	circle_bar = "~Circle of Healing Cooldown",

	strike = "Flamestrike",
	strike_desc = "Warn who is targetted for Flamestrike.",
	strike_trigger = "High Nethermancer Zerevor begins to cast Flamestrike.",
	strike_you = "Flame Strike on YOU!",
	strike_other = "Flame strike on %s",

	strikesay = "Flamestrike Say",
	strikesay_desc = "Print in say when you are targeted for Flamestrike. (Can help nearby members with speech bubbles on)",
	strikesay_message = "Flamestrike on me!",
} end )

L:RegisterTranslations("frFR", function() return {
	immune = "Immunité",
	immune_desc = "Préviens quand Malande devient insernsible aux sorts ou aux attaques de melée.",
	immune_spell_trigger = "Dame Malande gagne Bénédiction de protection contre les sorts.",
	immune_melee_trigger = "Dame Malande gagne Bénédiction de protection.",
	immune_message = "Malande : insensible %s pendant 15 sec. !",
	immune_bar = "Insensible %s !",

	spell = "aux sorts",
	melee = "en melée",

	shield = "Bouclier réflecteur",
	shield_desc = "Préviens quand Malande gagne son Bouclier réflecteur.",
	shield_trigger = "Dame Malande gagne Bouclier réflecteur.",
	shield_message = "Bouclier réflecteur sur Malande !",

	poison = "Poison mortel",
	poison_desc = "Préviens quand un joueur subit les effets du Poison mortel.",
	poison_trigger = "^([^%s]+) ([^%s]+) les effets .* Poison mortel%.$",
	poison_other = "%s a le Poison mortel !",
	poison_you = "Poison mortel sur VOUS !",

	icon = "Icône",
	icon_desc = "Place une icône de raid sur le dernier joueur affecté par le Poison mortel (nécessite d'être promu ou mieux).",

	circle = "Cercle de soins",
	circle_desc = "Préviens quand Malande commence à lancer son Cercle de soins.",
	circle_trigger = "Dame Malande commence à lancer Cercle de soins.",
	circle_message = "Cercle de soins en incantation !",
	circle_heal_trigger = "^Cercle de soins .* Dame Malande soigne",
	circle_fail_trigger = "^([^%s]+) interrompt Dame Malande qui lance Cercle de soins%.$", -- + "Dame Malande lance un Cercle de soins que vous interrompez." ?
	circle_heal_message = "Soigné ! - Prochain dans ~20 sec.",
	circle_fail_message = "Interrompu ! - Prochain dans ~12 sec.",
	circle_bar = "~Cooldown Cercle de soins",

	strike = "Choc de flammes",
	strike_desc = "Préviens quand un joueur est ciblé par le Choc de flammes.",
	strike_trigger = "Grand néantomancien Zerevor commence à lancer Choc de flammes.",
	strike_you = "Choc de flammes sur VOUS !",
	strike_other = "Choc de flammes sur %s",

	strikesay = "Dire - Choc de flammes",
	strikesay_desc = "Fais dire à votre personnage que vous êtes ciblé par le Choc de flammes quand c'est le cas, afin d'aider les membres proches ayant les bulles de dialogue d'activés.",
	strikesay_message = "Choc de flammes sur moi !",
} end )

L:RegisterTranslations("koKR", function() return {
	immune = "면역 경고",
	immune_desc = "말란데가 주문 혹은 근접 공격에 면역 시 알립니다.",
	immune_spell_trigger = "여군주 말란데|1이;가; 주문 수호의 축복 효과를 얻었습니다.",
	immune_melee_trigger = "여군주 말란데|1이;가; 보호의 축복 효과를 얻었습니다.",
	immune_message = "말란데: 15초간 %s 면역!",
	immune_bar = "%s 면역!",

	spell = "주문",
	melee = "근접",

	shield = "반사의 보호막",
	shield_desc = "말란데가 반사의 보호막을 얻었을 때 알립니다.",
	shield_trigger = "여군주 말란데|1이;가; 반사의 보호막 효과를 얻었습니다.",
	shield_message = "말란데에 반사의 보호막!",

	poison = "맹독",
	poison_desc = "맹독에 걸린 플레이어를 알립니다.",
	poison_trigger = "^([^|;%s]*)(.*)맹독에 걸렸습니다%.$",
	poison_other = "%s에 맹독!",
	poison_you = "당신에 맹독!",

	icon = "전술 표시",
	icon_desc = "맹독에 걸린 플레이어에 전술 표시를 지정합니다 (승급자 이상 권한 필요).",

	circle = "치유의 마법진",
	circle_desc = "말란데가 치유의 마법진 시전 시 알립니다.",
	circle_trigger = "여군주 말란데|1이;가; 치유의 마법진 시전을 시작합니다.",
	circle_message = "치유의 마법진 시전!",
	circle_heal_trigger = "^여군주 말란데의 치유의 마법진|1으로;로;",
	circle_fail_trigger = "^([^%s]+)|1이;가; 여군주 말란데의 치유의 마법진|1을;를; 차단했습니다%.$",
	circle_heal_message = "치유됨! - 다음은 약 20초 이내",
	circle_fail_message = "차단됨! - 다음은 약 12초 이내",
	circle_bar = "~치유의 마법진 대기 시간",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Black Temple"]
mod.enabletrigger = {malande, gathios, zerevor, veras}
mod.toggleoptions = {"immune", "shield", "circle", -1, "poison", "icon", -1, "strike", "strikesay", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Poison")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Poison")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Poison")

	self:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE", "Interrupt")
	self:RegisterEvent("CHAT_MSG_SPELL_PARTY_DAMAGE", "Interrupt")
	self:RegisterEvent("CHAT_MSG_SPELL_FRIENDLYPLAYER_DAMAGE", "Interrupt") -- might not be needed?
	self:RegisterEvent("CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE", "Interrupt")

	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "MalSpell", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "MalMelee", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "MalShield", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "MalCCast", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "MalCHeal", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "MalCFail", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "CouncilPoison", 2)
	self:TriggerEvent("BigWigs_ThrottleSync", "ZerFlame", 4)

	pName = UnitName("player")
end

------------------------------
--      Event Handlers      --
------------------------------


function mod:BigWigs_RecvSync(sync, rest, nick)
	if sync == "MalSpell" and self.db.profile.immune then
		self:Message(L["immune_message"]:format(L["spell"]), "Positive", nil, "Alarm")
		self:TriggerEvent("BigWigs_StopBar", self, L["immune_message"]:format(L["melee"]))
		self:Bar(L["immune_bar"]:format(L["spell"]), 15, "Spell_Holy_SealOfRighteousness")
	elseif sync == "MalMelee" and self.db.profile.immune then
		self:Message(L["immune_message"]:format(L["melee"]), "Positive", nil, "Alert")
		self:TriggerEvent("BigWigs_StopBar", self, L["immune_message"]:format(L["spell"]))
		self:Bar(L["immune_bar"]:format(L["melee"]), 15, "Spell_Holy_SealOfProtection")
	elseif sync == "MalShield" and self.db.profile.shield then
		self:Message(L["shield_message"], "Important", nil, "Long")
		self:Bar(L["shield_message"], 20, "Spell_Holy_PowerWordShield")
	elseif sync == "MalCCast" and self.db.profile.circle then
		self:Message(L["circle_message"], "Attention", nil, "Info")
		self:Bar(L["circle"], 2.5, "Spell_Holy_CircleOfRenewal")
	elseif sync == "MalCHeal" and self.db.profile.circle then
		self:Message(L["circle_heal_message"], "Urgent")
		self:Bar(L["circle_bar"], 20, "Spell_Holy_CircleOfRenewal")
	elseif sync == "MalCFail" and self.db.profile.circle then
		self:Message(L["circle_fail_message"], "Urgent")
		self:Bar(L["circle_bar"], 12, "Spell_Holy_CircleOfRenewal")
	elseif sync == "ZerFlame" and self.db.profile.strike then
		self:ScheduleEvent("BWFlameToTScan", self.TargetCheck, 0.3, self)
	elseif sync == "CouncilPoison" and rest and self.db.profile.poison then
		local other = L["poison_other"]:format(rest)
		if rest == pName then
			self:Message(L["poison_you"], "Personal", true, "Long")
			self:Message(other, "Attention", nil, nil, true)
		else
			self:Message(other, "Attention")
		end
		if self.db.profile.icon then
			self:Icon(rest)
		end
	end
end

function mod:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(msg)
	if msg == L["immune_spell_trigger"] then
		self:Sync("MalSpell")
	elseif msg == L["immune_melee_trigger"] then
		self:Sync("MalMelee")
	elseif msg == L["shield_trigger"] then
		self:Sync("MalShield")
	end
end

function mod:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if msg == L["strike_trigger"] then
		self:Sync("ZerFlame")
	end
end

function mod:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF(msg)
	if msg == L["circle_trigger"] then
		self:Sync("MalCCast")
	elseif msg == L["circle_heal_trigger"] then
		self:Sync("MalCHeal")
	end
end

function mod:Poison(msg)
	local pplayer, ptype = select(3, msg:find(L["poison_trigger"]))
	if pplayer and ptype then
		if pplayer == L2["you"] and ptype == L2["are"] then
			pplayer = pName
		end
		self:Sync("CouncilPoison "..pplayer)
	end
end

function mod:Interrupt(msg)
	if msg:find(L["circle_fail_trigger"]) then
		self:Sync("MalCFail")
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
			if UnitName("raid"..i.."target") == boss then
				target = UnitName("raid"..i.."targettarget")
				break
			end
		end
	end
	if target then
		local fstrike = L["strike_other"]:format(target)
		if target == pName then
			self:Message(L["strike_you"], "Personal", true, "Long")
			self:Message(fstrike, "Attention", nil, nil, true)
			if self.db.profile.burstsay then
				SendChatMessage(L["strikesay_message"], "SAY")
			end
		else
			self:Message(fstrike, "Attention")
		end
	end
end
