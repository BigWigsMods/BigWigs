------------------------------
--      Are you local?      --
------------------------------

local boss = BB["Netherspite"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local started = nil
local voidcount = 1

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Netherspite",

	phase = "Phases",
	phase_desc = "Warns when Netherspite changes from one phase to another.",
	phase1_message = "Withdrawal - Netherbreaths Over",
	phase1_bar = "~Possible Withdrawal",
	phase1_trigger = "%s cries out in withdrawal, opening gates to the nether.",
	phase2_message = "Rage - Incoming Netherbreaths!",
	phase2_bar = "~Possible Rage",
	phase2_trigger = "%s goes into a nether-fed rage!",

	voidzone = "Voidzones",
	voidzone_desc = "Warn for Voidzones.",
	voidzone_warn = "Void Zone (%d)!",

	netherbreath = "Netherbreath",
	netherbreath_desc = "Warn for Netherbreath.",
	netherbreath_warn = "Incoming Netherbreath!",
} end )

L:RegisterTranslations("deDE", function() return {
	phase = "Phase",
	phase_desc = "Warnt wenn Nethergroll von einer Phase zur anderen wechselt",

	voidzone = "Zone der Leere",
	voidzone_desc = "Warnt vor Zone der Leere",

	netherbreath = "Netheratem",
	netherbreath_desc = "Warnt vor Netheratem",

	phase1_message = "Withdrawal - Netheratem vorbei",
	phase1_bar = "Next Withdrawal",
	phase1_trigger = "%s schreit auf und \195\182ffnet Tore zum Nether.",
	phase2_message = "Rage - Incoming Netheratem!",
	phase2_bar = "N\195\164chste Rage",
	phase2_trigger = "Netherenergien versetzen %s in rasende Wut!",

	voidzone_warn = "Zone der Leere (%d)!",

	netherbreath_warn = "Netheratem kommt!",
} end )

L:RegisterTranslations("koKR", function() return {
	phase = "단계",
	phase_desc = "황천의 원령의 다음 단계로 변화 시 경고합니다.",
	phase1_message = "물러남 - 황천의 숨결 종료!",
	phase1_bar = "~물러남 주의",
	phase1_trigger = "%s|1이;가; 물러나며 고함을 지르더니 황천의 문을 엽니다.",
	phase2_message = "분노 - 황천의 숨결 시전!",
	phase2_bar = "분노 주의",
	phase2_trigger = "%s|1이;가; 황천의 기운을 받고 분노에 휩싸입니다!",

	voidzone = "공허의 지대",
	voidzone_desc = "공허의 지대에 대한 경고입니다.",
	voidzone_warn = "공허의 지대 (%d)!",

	netherbreath = "황천의 숨결",
	netherbreath_desc = "황천의 숨결에 대한 경고입니다.",
	netherbreath_warn = "황천의 숨결 시전!",
} end )

L:RegisterTranslations("frFR", function() return {
	phase = "Phases",
	phase_desc = "Prévient quand Dédain-du-Néant passe d'une phase à l'autre.",
	phase1_message = "Retrait - Fin des Souffles du Néant",
	phase1_bar = "~Retrait probable",
	phase1_trigger = "%s se retire avec un cri en ouvrant un portail vers le Néant.",
	phase2_message = "Rage - Souffles de Néant imminent !",
	phase2_bar = "~Rage probable",
	phase2_trigger = "%s entre dans une rage nourrie par le Néant !",

	voidzone = "Zones du vide",
	voidzone_desc = "Prévient quand les Zones du vide apparaissent.",
	voidzone_warn = "Zone du vide (%d) !",

	netherbreath = "Souffle de Néant",
	netherbreath_desc = "Prévient de l'arrivée des Souffles du Néant.",
	netherbreath_warn = "Souffle du Néant imminent !",
} end )

L:RegisterTranslations("zhCN", function() return {
	phase = "阶段警报",
	phase_desc = "当进入下一阶段时发出警报。",
	phase1_message = "快撤！- 虚空吐息来临！",
	phase1_bar = "<虚空吐息 - 撤退>",
	phase1_trigger = "%s在撤退中大声呼喊着，打开了回到虚空的传送门。",
	phase2_message = "狂怒！- 地狱吐息来临！",
	phase2_bar = "<地狱吐息 - 狂怒>",
	phase2_trigger = "%s的怒火甚至可以充满整个虚空！",

	voidzone = "虚空领域",
	voidzone_desc = "当玩家受到虚空领域时发出警报。",
	voidzone_warn = "虚空领域：>%d<！",

	netherbreath = "虚空吐息",
	netherbreath_desc = "当施放虚空吐息时发出警报。",
	netherbreath_warn = "虚空吐息来临！",
} end )

L:RegisterTranslations("zhTW", function() return {
	phase = "階段警告",
	phase_desc = "當 尼德斯 進入下一階段時發送警告",
	phase1_message = "撒退 - 第一階段光線門",
	phase1_bar = "地獄吐息 - 撒退",
	phase1_trigger = "%s大聲呼喊撤退，打開通往地獄的門。",
	phase2_message = "狂怒 - 第二階段自我放逐",
	phase2_bar = "地獄吐息 - 狂怒",
	phase2_trigger = "%s陷入一陣狂怒!",

	voidzone = "虛空地區警告",
	voidzone_desc = "當尼德斯施放虛空地區時發送警告",
	voidzone_warn = "虛空地區 (%d)",

	netherbreath = "地獄吐息警告",
	netherbreath_desc = "當尼德斯施放地獄吐息時發送警告",
	netherbreath_warn = "地獄吐息",
} end )

L:RegisterTranslations("esES", function() return {
	phase = "Fases",
	phase_desc = "Avisar cuando Rencor abisal cambia de fase.",
	phase1_message = "Retirada - Aliento abisal terminado",
	phase1_bar = "~Retirada",
	phase1_trigger = "%s grita en retirada, abriendo las puertas al vacío.",
	phase2_message = "Cólera - ¡Aliento abisal en breve!",
	phase2_bar = "~Cólera",
	phase2_trigger = "¡%s monta en cólera alimentada por el vacío!",

	voidzone = "Zonas de vacío",
	voidzone_desc = "Avisa de Zonas de vacío.",
	voidzone_warn = "¡Zona de vacío (%d)!",

	netherbreath = "Aliento abisal (Netherbreath)",
	netherbreath_desc = "Avisa de Aliento abisal.",
	netherbreath_warn = "¡Aliento abisal!",
} end )
-- Translated by wow.playhard.ru translators
L:RegisterTranslations("ruRU", function() return {
	phase = "Фазы",
	phase_desc = "Warns when Netherspite changes from one phase to another.",
	phase1_message = "Withdrawal - Netherbreaths Over",
	phase1_bar = "~Possible Withdrawal",
	phase1_trigger = "%s издает крик, отступая, открывая путь Пустоте.",
	phase2_message = "Rage - Incoming Netherbreaths!",
	phase2_bar = "~Possible Rage",
	phase2_trigger = "%s впадает в предельную ярость!",

	voidzone = "Порталы Бездны",
	voidzone_desc = "Предупреждать о Порталах Бездны.",
	voidzone_warn = "Портал Бездны (%d)!",

	netherbreath = "Дыхание Хаоса",
	netherbreath_desc = "Предупреждать о Дыхании Хаоса.",
	netherbreath_warn = "Надвигается Дыхание Хаоса!",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = BZ["Karazhan"]
mod.enabletrigger = boss
mod.guid = 15689
mod.toggleoptions = {"voidzone", "netherbreath", "phase", "enrage", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_CAST_SUCCESS", "VoidZone", 37063)
	self:AddCombatListener("SPELL_CAST_START", "Netherbreath", 38523)
	self:AddCombatListener("UNIT_DIED", "BossDeath")

	self:RegisterEvent("BigWigs_RecvSync")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")

	started = nil
	voidcount = 1
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:VoidZone()
	if self.db.profile.voidzone then
		self:IfMessage(L["voidzone_warn"]:format(voidcount), "Attention", 30533)
		voidcount = voidcount + 1
	end
end

function mod:Netherbreath(_, spellID)
	if self.db.profile.netherbreath then
		self:Message(L["netherbreath_warn"], "Urgent", spellID)
		self:Bar(L["netherbreath_warn"], 2.5, spellID)
	end
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if self:ValidateEngageSync(sync, rest) and not started then
		started = true
		voidcount = 1
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end
		if self.db.profile.phase then
			self:Bar(L["phase2_bar"], 60, "Spell_ChargePositive")
		end
		if self.db.profile.enrage then
			self:Enrage(540)
		end
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg)
	if not self.db.profile.phase then return end
	if msg == L["phase1_trigger"] then
		self:TriggerEvent("BigWigs_StopBar", self, L["netherbreath_warn"])
		self:Message(L["phase1_message"], "Important")
		self:Bar(L["phase2_bar"], 58, "Spell_ChargePositive")
	elseif msg == L["phase2_trigger"] then
		self:Message(L["phase2_message"], "Important")
		self:Bar(L["phase1_bar"], 30, "Spell_ChargeNegative")
	end
end

