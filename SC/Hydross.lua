------------------------------
--      Are you local?      --
------------------------------

local boss = BB["Hydross the Unstable"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

local inTomb = {}
local curPerc = 10
local stance = 1
local fmt = string.format
local CheckInteractDistance = CheckInteractDistance
local db = nil
local pName = UnitName("player")
local allowed = nil

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Hydross",

	start_trigger = "I cannot allow you to interfere!",

	mark = "Mark",
	mark_desc = "Show warnings and counters for marks.",

	stance = "Stance changes",
	stance_desc = "Warn when Hydross changes stances.",
	poison_stance = "Hydross is now poisoned!",
	water_stance = "Hydross is now cleaned again!",

	sludge = "Vile Sludge",
	sludge_desc = "Notify of players afflicted by Vile Sludge.",
	sludge_message = "Vile Sludge: %s",

	tomb = "Water Tomb",
	tomb_desc = "Notify of players afflicted by Water Tomb.",
	tomb_message = "Water Tomb: %s",

	icon = "Vile Sludge Icon",
	icon_desc = "Place a Raid Icon on the player afflicted by Vile Sludge(requires promoted or higher).",

	debuff_warn = "Mark at %s%%!",
} end)

L:RegisterTranslations("esES", function() return {
	start_trigger = "¡No puedo permitir que interferáis!",

	mark = "Marca de Hydross",
	mark_desc = "Mostrar avisos y contadores de Marca de Hydross.",

	stance = "Cambios de Actitud",
	stance_desc = "Avisar cuando Hydross cambia de actitud. (Corrupto/Purificado)",
	poison_stance = "¡Hydross - Actitud corrupta!",
	water_stance = "¡Hydross - Actitud purificada!",

	sludge = "Fango vil (Vile Sludge)",
	sludge_desc = "Avisar quién tiene Fango vil.",
	sludge_message = "Fango vil: %s",

	tomb = "Tumba de agua (Water Tomb)",
	tomb_desc = "Avisar quién tiene Tumba de agua.",
	tomb_message = "Tumba de agua: %s",

	icon = "Icono para Fango vil",
	icon_desc = "Poner un icono de banda sobre jugadores afectados por Fango vil. (Requiere derechos de banda)",

	debuff_warn = "¡Marca - %s%%!",
} end)

L:RegisterTranslations("deDE", function() return {
	start_trigger = "Ich kann nicht zulassen, dass Ihr Euch einmischt!",

	mark = "Mal",
	mark_desc = "Zeigt Warnungen und Anzahl des Mals.",

	stance = "Phasenwechsel",
	stance_desc = "Warnt wenn Hydross der Unstete seine Phase wechselt.",

	sludge = "\195\156bler Schlamm",
	sludge_desc = "Warnt welche Spieler von \195\156bler Schlamm betroffen sind.",

	icon = "\195\156bler Schlamm Icon",
	icon_desc = "Platziert ein Schlachtzugssymbol auf dem Spieler, welcher von \195\156bler Schlamm betroffen ist (ben\195\182tigt 'bef\195\182rdert' oder h\195\182her)",

	tomb = "Wassergrab",
	tomb_desc = "Warnt welche Spieler von Wassergrab betroffen sind.",

	debuff_warn = "Mal bei %s%%!",

	poison_stance = "Hydross ist nun vergiftet!",
	water_stance = "Hydross ist wieder gereinigt!",

	sludge_message = "\195\156bler Schlamm: %s",
	tomb_message = "Wassergrab: %s",
} end)

L:RegisterTranslations("koKR", function() return {
	start_trigger = "방해하도록 놔두지 않겠습니다!",

	mark = "징표",
	mark_desc = "징표에 대한 경고와 카운터를 표시합니다.",

	stance = "태세 변경",
	stance_desc = "불안정한 히드로스의 태세 변경 시 경고합니다.",
	poison_stance = "히드로스 오염!",
	water_stance = "히드로스 정화!",

	sludge = "타락의 진흙",
	sludge_desc = "타락의 진흙에 걸린 플레이어를 알립니다.",
	sludge_message = "타락의 진흙: %s",

	tomb = "수중 무덤",
	tomb_desc = "수중 무덤에 걸린 플레이어를 알립니다.",
	tomb_message = "수중 무덤: %s",

	icon = "전술 표시",
	icon_desc = "타락의 진흙에 걸린 플레이어에 전술 표시를 지정합니다. (승급자 이상 권한 필요)",

	debuff_warn = "징표 - %s%%!",
} end)

L:RegisterTranslations("frFR", function() return {
	start_trigger = "Je ne peux pas vous laisser nous gêner !",

	mark = "Marque",
	mark_desc = "Affiche les alertes et les compteurs des marques.",

	stance = "Changements d'état",
	stance_desc = "Prévient quand Hydross l'Instable change d'état.",
	poison_stance = "Hydross est maintenant empoisonné !",
	water_stance = "Hydross est de nouveau sain !",

	sludge = "Vase abominable",
	sludge_desc = "Prévient quand un joueur est affecté par la Vase abominable.",
	sludge_message = "Vase abominable : %s",

	tomb = "Tombe aquatique",
	tomb_desc = "Prévient quand des joueurs sont affectés par la Tombe aquatique.",
	tomb_message = "Tombe aquatique : %s",

	icon = "Icône Vase abominable",
	icon_desc = "Place une icône de raid sur le joueur affecté par la Vase abominable (nécessite d'être promu ou mieux).",

	debuff_warn = "Marque à %s%% !",
} end)

L:RegisterTranslations("zhCN", function() return {
	start_trigger = "我不能允许你们介入！",

	mark = "印记",
	mark_desc = "显示印记警报及计数。",

	stance = "形态改变",
	stance_desc = "当毒性改变时发出警报。",
	poison_stance = "毒形态！",
	water_stance = "水形态！",

	sludge = "肮脏的淤泥怪",
	sludge_desc = "当玩家变成肮脏的淤泥怪时发出警报。",
	sludge_message = "肮脏的淤泥怪：>%s<！",

	tomb = "水之墓",
	tomb_desc = "当玩家成为水之墓时发出警报。",
	tomb_message = "水之墓：>%s<！",

	icon = "肮脏的淤泥怪标记",
	icon_desc = "为受到肮脏的淤泥怪的玩家打上标记。（需要权限）",

	debuff_warn = "印记施放于 %s%%！",
} end)

L:RegisterTranslations("zhTW", function() return {
	start_trigger = "我不准你涉入這件事!",

	mark = "印記",
	mark_desc = "印記警報及計數",

	stance = "形態改變",
	stance_desc = "當 不穩定者海卓司 改變型態時發出警報",
	poison_stance = "海卓司轉為毒型態!",
	water_stance = "海卓司轉為水狀態!",

	sludge = "混濁污泥",
	sludge_desc = "當隊友受到混濁污泥時提示",
	sludge_message = "混濁污泥: [%s]",

	tomb = "水之墳",
	tomb_desc = "通報玩家受到水之墳",
	tomb_message = "水之墳: [%s]",

	icon = "混濁污泥標記",
	icon_desc = "對受到混濁污泥的目標設置標記（需要權限）",

	debuff_warn = "印記施放於 %s%%",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = BZ["Serpentshrine Cavern"]
mod.enabletrigger = boss
mod.toggleoptions = {"stance", "mark", "enrage", -1, "sludge", "icon", "tomb", "proximity", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))
mod.proximityCheck = function( unit ) return CheckInteractDistance( unit, 3 ) end
mod.proximitySilent = true

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_AURA_APPLIED", "Tomb", 38235)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Sludge", 38246)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Mark",
		38215, 38216, 38217, 38218, 38231, 40584, --Mark of Hydross - 10, 25, 50, 100, 250, 500
		38219, 38220, 38221, 38222, 38230, 40583 --Mark of Corruption - 10, 25, 50, 100, 250, 500
	)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Stance", 25035)
	self:AddCombatListener("UNIT_DIED", "GenericBossDeath")

	for k in pairs(inTomb) do inTomb[k] = nil end
	curPerc = 10
	stance = 1
	allowed = nil

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

	db = self.db.profile
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Tomb(player)
	if db.tomb then
		inTomb[player] = true
		self:ScheduleEvent("BWTombWarn", self.TombWarn, 0.3, self)
	end
end

function mod:Sludge(player, spellID)
	if db.sludge then
		self:IfMessage(fmt(L["sludge_message"], player), "Attention", spellID)
		self:Bar(fmt(L["sludge_message"], player), 24, spellID)
		self:Icon(player, "icon")
	end
end

local debuffBar = "%d%% - %s"
local poisonName = GetSpellInfo(38219)
local cleanName = GetSpellInfo(38215)
function mod:Mark(_, spellID, _, _, spellName)
	self:TriggerEvent("BigWigs_StopBar", self, fmt(debuffBar, curPerc, poisonName))
	self:TriggerEvent("BigWigs_StopBar", self, fmt(debuffBar, curPerc, cleanName))
	if db.mark then
		self:IfMessage(fmt(L["debuff_warn"], curPerc), "Important", spellID, "Alert")
		if spellID == 38215 or spellID == 38219 then
			curPerc = 25
		elseif spellID == 38216 or spellID == 38220 then
			curPerc = 50
		elseif spellID == 38217 or spellID == 38221 then
			curPerc = 100
		elseif spellID == 38218 or spellID == 38222 then
			curPerc = 250
		elseif spellID == 38231 or spellID == 38230 then
			curPerc = 500
		end
		self:Bar(fmt(debuffBar, curPerc, spellName), 15, spellID)
	end
end

local last = 0
--stance: 1=clean 2=poison
function mod:Stance()
	local time = GetTime()
	if (time - last) > 10 and allowed then
		last = time
		if stance == 1 then
			stance = 2
			self:TriggerEvent("BigWigs_StopBar", self, fmt(debuffBar, curPerc, cleanName))
			curPerc = 10
			if db.stance then
				self:IfMessage(L["poison_stance"], "Important", 38219)
			end
			if db.mark then
				self:Bar(fmt(debuffBar, curPerc, poisonName), 15, 38219)
			end
			self:TriggerEvent("BigWigs_HideProximity", self)
		else
			stance = 1
			self:TriggerEvent("BigWigs_StopBar", self, fmt(debuffBar, curPerc, poisonName))
			curPerc = 10
			self:TriggerEvent("BigWigs_RemoveRaidIcon")
			if db.stance then
				self:IfMessage(L["water_stance"], "Important", 38215)
			end
			if db.mark then
				self:Bar(fmt(debuffBar, curPerc, cleanName), 15, 38215)
			end
			self:TriggerEvent("BigWigs_ShowProximity", self)
		end
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L["start_trigger"] then
		curPerc = 10
		stance = 1
		allowed = true
		if db.mark then
			self:Bar(fmt(debuffBar, curPerc, cleanName), 15, 38215)
		end
		if db.enrage then
			self:Enrage(600)
		end
		self:TriggerEvent("BigWigs_ShowProximity", self)
	end
end

function mod:TombWarn()
	local msg = nil
	for k in pairs(inTomb) do
		if not msg then
			msg = k
		else
			msg = msg .. ", " .. k
		end
	end
	self:IfMessage(fmt(L["tomb_message"], msg), "Attention", 45574)
	for k in pairs(inTomb) do inTomb[k] = nil end
end

