------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Baron Geddon"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	bomb_trigger = "^([^%s]+) ([^%s]+) afflicted by Living Bomb",
	inferno_trigger = "Baron Geddon gains Inferno.",
	service_trigger = "%s performs one last service for Ragnaros.",

	you = "You",
	are = "are",

	bomb_message_you = "You are the bomb!",
	bomb_message_other = "%s is the bomb!",

	bombtimer_bar = "%s: Living Bomb",
	inferno_bar = "Inferno",
	service_bar = "Last Service",

	service_message = "Last Service, Geddon exploding in 5sec!",
	inferno_message = "Inferno for 10sec!",

	cmd = "Baron",

	service_cmd = "service",
	service_name = "Last service",
	service_desc = "Timer bar for Geddon's last service.",

	inferno_cmd = "inferno",
	inferno_name = "Inferno",
	inferno_desc = "Timer bar for Geddons Inferno.",

	bombtimer_cmd = "bombtimer",
	bombtimer_name = "Bar for when the bomb goes off",
	bombtimer_desc = "Shows a 10 second bar for when the bomb goes off at the target.",

	youbomb_cmd = "youbomb",
	youbomb_name = "You are the bomb alert",
	youbomb_desc = "Warn when you are the bomb",

	elsebomb_cmd = "elsebomb",
	elsebomb_name = "Someone else is the bomb alert",
	elsebomb_desc = "Warn when others are the bomb",

	icon_cmd = "icon",
	icon_name = "Raid Icon on bomb",
	icon_desc = "Put a Raid Icon on the person who's the bomb. (Requires promoted or higher)",
} end)

L:RegisterTranslations("zhCN", function() return {
	bomb_trigger = "^(.+)受(.+)了活化炸弹",
	inferno_trigger = "迦顿男爵获得了地狱火的效果。",
	service_trigger = "%s为拉格纳罗斯做最后一次服务",

	you = "你",
	are = "到",

	bomb_message_you = "你是炸弹人！向着夕阳奔跑吧！",
	bomb_message_other = "%s是炸弹人！向着夕阳奔跑吧！",

	bombtimer_bar = "%s: 活化炸弹",
	inferno_bar = "地狱火",
	service_bar = "最后自爆",

	service_message = "最后一次服务，5秒后迦顿爆炸！",
	inferno_message = "10秒后地狱火！",

	service_name = "最后自爆计时条",
	service_desc = "显示迦顿男爵最后自爆的计时条.",

	inferno_name = "地狱火计时条",
	inferno_desc = "显示迦顿男爵地狱火的计时条.",

	youbomb_name = "玩家炸弹警报",
	youbomb_desc = "你成为炸弹时发出警报",

	youbomb_name = "玩家炸弹警报",
	youbomb_desc = "你成为炸弹时发出警报",

	elsebomb_name = "队友炸弹警报",
	elsebomb_desc = "队友成为炸弹时发出警报",

	icon_cmd = "icon",
	icon_name = "炸弹图标",
	icon_desc = "在成为炸弹的队友头上标记骷髅图标（需要助理或领袖权限）",
} end)

L:RegisterTranslations("zhTW", function() return {
	-- Baron Geddon 迦頓男爵
	bomb_trigger = "^(.+)受到(.*)活化炸彈",
	inferno_trigger = "迦頓男爵獲得了地獄火的效果。",
	service_trigger = "%s為拉格納羅斯做最後一件事……",

	you = "你",
	are = "了",

	bomb_message_you = "你是炸彈人！遠離人群！",
	bomb_message_other = "%s是炸彈人！遠離人群！",

	bombtimer_bar = "%s: 活化炸彈",
	inferno_bar = "地獄火",
	service_bar = "最後自爆",

	service_message = "5 秒後迦頓爆炸！",
	inferno_message = "施放地獄火10秒！",

	service_name = "最後自爆計時條",
	service_desc = "顯示迦頓男爵最後自爆的計時條.",

	inferno_name = "地獄火計時條",
	inferno_desc = "顯示迦頓男爵地獄火的計時條.",

	youbomb_name = "玩家炸彈警報",
	youbomb_desc = "你成為炸彈時發出警報",

	youbomb_name = "玩家炸彈警報",
	youbomb_desc = "你成為炸彈時發出警報",

	elsebomb_name = "隊友炸彈警報",
	elsebomb_desc = "隊友成為炸彈時發出警報",

	icon_name = "炸彈標記",
	icon_desc = "在成為炸彈的隊友頭上標記（需要助理或領隊權限）",
} end)

L:RegisterTranslations("koKR", function() return {
	bomb_trigger = "^([^|;%s]*)(.*)살아있는 폭탄에 걸렸습니다%.$",
	inferno_trigger = "남작 게돈|1이;가; 불지옥 효과를 얻었습니다.", -- check
	service_trigger = "%s|1이;가; 라그나로스를 위한 마지막 임무를 수행합니다...", -- check

	you = "",
	are = "",

	bomb_message_you = "당신은 폭탄입니다!",
	bomb_message_other = "%s님이 폭탄입니다!",

	bombtimer_bar = "%s: 살아있는 폭탄",
	inferno_bar = "불지옥",
	service_bar = "마지막 임무",

	service_message = "마지막 임무, 게돈 폭발 5초전!",
	inferno_message = "10초동안 불지옥!",


	service_name = "마지막 임무",
	service_desc = "게돈의 마지막 임무에 대한 타이머 바",

	inferno_name = "불지옥",
	inferno_desc = "게돈 불지옥에 대한 타이머 바.",

	bombtimer_name = "폭탄에 대한 바",
	bombtimer_desc = "대상에서 폭탄이 사라질 때에 대한 10초 바를 표시합니다.",

	youbomb_name = "자신의 폭탄 경고",
	youbomb_desc = "자신이 폭탄 일때 경고",
	
	elsebomb_name = "타인의 폭탄 경고",
	elsebomb_desc = "타인이 폭탄 일때 경고",
	
	icon_name = "폭탄에 공격대 아이콘 표시",
	icon_desc = "폭탄인 사람에게 공격대 아이콘 표시. (승급자 이상 요구)",
} end)

L:RegisterTranslations("deDE", function() return {
	bomb_trigger = "^([^%s]+) ([^%s]+) von Lebende Bombe betroffen",
	inferno_trigger = "Baron Geddon bekommt 'Inferno'.",
	service_trigger = "%s erweist Ragnaros einen letzten Dienst.", -- ?

	you = "Ihr",
	are = "seid",

	bomb_message_you = "Du bist die Bombe!",
	bomb_message_other = "%s ist die Bombe!",

	bombtimer_bar = "%s: Lebende Bombe",
	inferno_bar = "Inferno",
	service_bar = "Letzter Dienst",

	service_message = "Letzter Dienst! Baron Geddon explodiert in 5 Sekunden!",
	inferno_message = "Inferno f\195\188r 10 Sekunden!",

	service_name = "Letzter Dienst",
	service_desc = "Timer Balken f\195\188r Baron Geddons letzten Dienst.",

	inferno_name = "Inferno",
	inferno_desc = "Timer Balken f\195\188r Baron Geddons Inferno.",

	bombtimer_name = "Bomben Timer",
	bombtimer_desc = "Zeigt einen 10 Sekunden Timer f\195\188r die Explosion der Lebenden Bombe.",

	youbomb_name = "Du bist die Bombe",
	youbomb_desc = "Warnung, wenn Du die Bombe bist.",
	
	elsebomb_name = "X ist die Bombe",
	elsebomb_desc = "Warnung, wenn andere Spieler die Bombe sind",
	
	icon_name = "Symbol",
	icon_desc = "Platziert ein Symbol \195\188ber dem Spieler, der die Bombe ist. (Ben\195\182tigt Anf\195\188hrer oder Bef\195\182rdert Status.)",
} end)

L:RegisterTranslations("frFR", function() return {
	bomb_trigger = "^(.+) (.+) les effets de Bombe vivante%.",
	inferno_trigger = "Baron Geddon gagne Inferno.",
	service_trigger = "%s accomplit un dernier service pour Ragnaros...",

	you = "Vous",
	are = "subissez",

	bomb_message_you = "Tu es la bombe !",
	bomb_message_other = "%s est la bombe !",

	bombtimer_bar = "%s : Bombe vivante",
	inferno_bar = "Inferno",
	service_bar = "Dernier service",

	service_message = "Dernier Service, Geddon explose dans 5 secondes !",
	inferno_message = "Inferno pendant 10 secondes !",

	service_name = "Alerte Dernier Service",
	service_desc = "Pr\195\169viens du dernier service de Geddon.",

	inferno_name = "Alerte Inferno",
	inferno_desc = "Pr\195\169viens des Inferno de Geddon.",

	bombtimer_name = "Barre Bombes Vivantes",
	bombtimer_desc = "Affiche une barre pour chaque Bombe vivante.",

	youbomb_name = "Alerte quand vous \195\170tes la bombe",
	youbomb_desc = "Pr\195\169viens quand vous \195\170tes la bombe.",

	elsebomb_name = "Alerte quand d'autres sont la bombe",
	elsebomb_desc = "Pr\195\169viens quand d'autres joueurs sont la bombe.",

	icon_name = "Ic\195\180ne de raid",
	icon_desc = "Place une ic\195\180ne de raid sur la derni\195\168re personne qui est la bombe (requiert d'\195\170tre promus ou plus)",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsBaronGeddon = BigWigs:NewModule(boss)
BigWigsBaronGeddon.zonename = AceLibrary("Babble-Zone-2.2")["Molten Core"]
BigWigsBaronGeddon.enabletrigger = boss
BigWigsBaronGeddon.toggleoptions = {"inferno", "service", -1, "bombtimer", "youbomb", "elsebomb", "icon", "bosskill"}
BigWigsBaronGeddon.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsBaronGeddon:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "GeddonBomb", 1)
	self:TriggerEvent("BigWigs_ThrottleSync", "GeddonInferno", 5)
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsBaronGeddon:Event(msg)
	local _, _, EPlayer, EType = string.find(msg, L["bomb_trigger"])
	if EPlayer and EType then
		if EPlayer == L["you"] and EType == L["are"] then
			EPlayer = UnitName("player")
		end
		self:TriggerEvent("BigWigs_SendSync", "GeddonBomb "..EPlayer)
	end
end

function BigWigsBaronGeddon:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(msg)
	if msg == L["inferno_trigger"] then
		self:TriggerEvent("BigWigs_SendSync", "GeddonInferno")
	end
end

function BigWigsBaronGeddon:CHAT_MSG_MONSTER_EMOTE(msg)
	if msg == L["service_trigger"] and self.db.profile.service then
		self:TriggerEvent("BigWigs_StartBar", self, L["service_bar"], 5, "Interface\\Icons\\Spell_Shadow_MindBomb", "Red")
		self:TriggerEvent("BigWigs_Message", L["service_message"], "Important")
	end
end

function BigWigsBaronGeddon:BigWigs_RecvSync(sync, rest, nick)
	if sync == "GeddonBomb" and rest then
		local player = rest
		
		if player == UnitName("player") and self.db.profile.youbomb then
			self:TriggerEvent("BigWigs_Message", L["bomb_message_you"], "Personal", true)
			self:TriggerEvent("BigWigs_Message", string.format(L["bomb_message_other"], player), "Attention", nil, nil, true )
		elseif self.db.profile.elsebomb then
			self:TriggerEvent("BigWigs_Message", string.format(L["bomb_message_other"], player), "Attention")
			self:TriggerEvent("BigWigs_SendTell", player, L["bomb_message_you"])
		end

		if self.db.profile.bombtimer then
			self:TriggerEvent("BigWigs_StartBar", self, string.format(L["bombtimer_bar"], player), 10, "Interface\\Icons\\Spell_Shadow_MindBomb", "Red")
		end

		if self.db.profile.icon then
			self:TriggerEvent("BigWigs_SetRaidIcon", player)
		end
	elseif sync == "GeddonInferno" and self.db.profile.inferno then
		self:TriggerEvent("BigWigs_StartBar", self, L["inferno_bar"], 10, "Interface\\Icons\\Spell_Fire_SealOfFire", "Orange")
		self:TriggerEvent("BigWigs_Message", L["inferno_message"], "Important")
	end
end

