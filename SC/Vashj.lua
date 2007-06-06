------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Lady Vashj"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")

local deformat = nil
local checkedForDeformat = nil

local delayedElementalMessage = nil
local delayedStriderMessage = nil

local shieldsFaded = 0
local playerName = nil
local phaseTwoAnnounced = nil

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	deformat = "You need the Deformat-2.0 library in order to get loot warnings in phase 2. You can download it from http://files.wowace.com/Deformat/.",

	["Tainted Elemental"] = true,

	cmd = "Vashj",

	engage_trigger1 = "I did not wish to lower myself by engaging your kind, but you leave me little choice...",
	engage_trigger2 = "I spit on you, surface filth!",
	engage_trigger3 = "Victory to Lord Illidan! ",
	engage_trigger4 = "I'll split you from stem to stern!",
	engage_trigger5 = "Death to the outsiders!",
	engage_message = "Entering Phase 1",

	phase = "Phase warnings",
	phase_desc = "Warn when Vashj goes into the different phases.",
	phase2_trigger = "The time is now! Leave none standing!",
	phase2_soon_message = "Phase 2 soon!",
	phase2_message = "Phase 2, adds incoming!",
	phase3_message = "Phase 3 - Enrage in 4min!",

	static = "Static Charge",
	static_desc = "Warn about Static Charge on players.",
	static_charge_trigger = "^([^%s]+) ([^%s]+) afflicted by Static Charge.$",
	static_charge_message = "Static Charge on %s!",
	static_fade = "Static Charge fades from you.",

	icon = "Icon",
	icon_desc = "Put an icon on players with Static Charge and those who loot cores.",

	elemental = "Tainted Elemental spawn",
	elemental_desc = "Warn when the Tainted Elementals spawn during phase 2.",
	elemental_bar = "Tainted Elemental Incoming",
	elemental_soon_message = "Tainted Elemental soon!",

	strider = "Coilfang Strider spawn",
	strider_desc = "Warn when the Coilfang Striders spawn during phase 2.",
	strider_bar = "Strider Incoming",
	strider_soon_message = "Strider soon!",

	barrier = "Barrier down",
	barrier_desc = "Alert when the barriers go down.",
	barrier_down_message = "Barrier %d/4 down!",
	barrier_fades_trigger = "Magic Barrier fades from Lady Vashj.",

	loot = "Tainted Core",
	loot_desc = "Warn who loots the Tainted Cores.",
	loot_message = "%s looted a core!",
} end )

L:RegisterTranslations("koKR", function() return {
	deformat = "2 단계에서 획득 경고를 위해 Deformat-2.0 라이브러리가 필요합니다. http://files.wowace.com/Deformat/ 에서 다운로드 할 수 있습니다.",

	["Tainted Elemental"] = "오염된 정령",

	engage_trigger1 = "천한 놈들을 상대하며 품위를 손상시키고 싶진 않았는데... 제 손으로 무덤을 파는구나.",
	engage_trigger2 = "육지에 사는 더러운 놈들같으니!",
	engage_trigger3 = "일리단 군주님께 승리를!",
	engage_trigger4 = "머리부터 발끝까지 성치 못할 줄 알아라!",
	engage_trigger5 = "침입자들에게 죽음을!",
	engage_message = "1단계 시작",

	phase = "단계 경고",
	phase_desc = "바쉬가 다음 단계로 변경 시 알림.",
	phase2_trigger = "때가 왔다! 한 놈도 살려두지 마라!",
 	phase2_soon_message = "잠시 후 2 단계!",
	phase2_message = "2 단계, 애드 주의!",
	phase3_message = "3 단계 - 4분 이내 격노!",

	static = "전하 충전",
	static_desc = "전하 충전에 걸린 플레이어 알림.",
	static_charge_trigger = "^([^|;%s]*)(.*)전하 충전에 걸렸습니다%.$",
	static_charge_message = "%s 전하 충전!",

	icon = "아이콘",
	icon_desc = "전하 충전에 걸린 플레이어와 핵을 획득한 플레이어에 아이콘 지정.",

	elemental = "오염된 정령 등장",
	elemental_desc = "단계 2에서 오염된 정령 등장 시 경고.",
	elemental_bar = "오염된 정령 등장",
	elemental_soon_message = "잠시 후 오염된 정령!",

	strider = "포자손 등장",
	strider_desc = "단계 2에서 포자손 등장 시 경고.",
	strider_bar = "포자손 등장",
	strider_soon_message = "잠시 후 포자손!",

	barrier = "보호막 손실",
	barrier_desc = "보호막 손실 시 알림",
	barrier_down_message = "보호막 %d/4 손실!",
	barrier_fades_trigger = "여군주 바쉬의 몸에서 마법 보호막 효과가 사라졌습니다.", -- check

	loot = "오염된 핵",
	loot_desc = "오염된 핵을 획득한 플레이어 알림",
	loot_message = "%s 핵 획득!",
} end )

L:RegisterTranslations("frFR", function() return {
	deformat = "Vous avez besoin de la bibliothèque Deformat-2.0 afin de recevoir les avertissements du butin en phase 2. Vous pouvez la télécharger à l'adresse suivante : http://files.wowace.com/Deformat/.",

	["Tainted Elemental"] = "Elémentaire souillé",

	engage_trigger1 = "J'espérais ne pas devoir m'abaisser à affronter des créatures de la surface, mais vous ne me laissez pas le choix…", -- à vérifier
	engage_trigger2 = "Je te crache dessus, racaille de la surface !", -- à vérifier
	engage_trigger3 = "Victoire au seigneur Illidan ! ", -- à vérifier
	engage_trigger4 = "Je vais te déchirer de part en part !", -- à vérifier
	engage_trigger5 = "Mort aux étrangers !", -- à vérifier
	engage_message = "Début de la phase 1",

	phase = "Phases",
	phase_desc = "Préviens quand la rencontre entre dans une nouvelle phase.",
	phase2_trigger = "L'heure est venue ! N'épargnez personne !", -- à vérifier
	phase2_soon_message = "Phase 2 imminente !",
	phase2_message = "Phase 2, arrivée des adds !",
	phase3_message = "Phase 3 - Enragée dans 4 min. !",

	static = "Charge statique",
	static_desc = "Préviens quand la Charge statique affecte un joueur.",
	static_charge_trigger = "^([^%s]+) ([^%s]+) les effets Charge statique.$",
	static_charge_message = "Charge statique sur %s !",
	static_fade = "Charge statique vient de se dissiper.",

	icon = "Icône",
	icon_desc = "Place une icône de raid sur les joueurs affectés par la Charge statique et sur ceux qui ramassent les noyaux.",

	elemental = "Elémentaires souillés",
	elemental_desc = "Préviens quand les Elémentaires souillés apparaissent durant la phase 2.",
	elemental_bar = "Arrivée d'un Elémentaire souillé",
	elemental_soon_message = "Elémentaire souillé imminent !",

	strider = "Trotteurs de Glissecroc",
	strider_desc = "Préviens quans les Trotteurs de Glissecroc apparaissent durant la phase 2.",
	strider_bar = "Arrivée d'un trotteur",
	strider_soon_message = "Trotteur imminent !",

	barrier = "Dissipation des barrières",
	barrier_desc = "Préviens quand les barrières se dissipent.",
	barrier_down_message = "Barrière %d/4 dissipée !",
	barrier_fades_trigger = "Barrière magique sur Dame Vashj vient de se dissiper.",

	loot = "Noyau contaminé",
	loot_desc = "Préviens quand un joueur ramasse un Noyau contaminé.",
	loot_message = "%s a ramassé un noyau !",
} end )

L:RegisterTranslations("deDE", function() return {
	deformat = "Ihr ben\195\182tigt die Deformat-2.0 Library um Loot Warnungen in Phase 2 zu erhalten. Download m\195\182glich auf http://files.wowace.com/Deformat/.",

	["Tainted Elemental"] = "Besudelter Elementar",

	phase = "Phasen Warnung",
	phase_desc = "Warnt, wenn Vashj ihre Phase wechselt.",

	static = "Statische Aufladung",
	static_desc = "Warnt vor Statischer Aufladung auf Spielern.",

	icon = "Icon",
	icon_desc = "Plaziert ein Icon auf Spielern mit Statische Aufladung und denen, die einen Besudelten Kern looten.",

	elemental = "Besudelter Elementar spawn",
	elemental_desc = "Warnt, wenn ein Besudelter Elementar w\195\164rend Phase 2 spawnt.",

	strider = "Schreiter des Echsenkessels spawn",
	strider_desc = "Warnt, wenn ein Schreiter des Echsenkessels w\195\164rend Phase 2 spawnt.",

	barrier = "Barriere zerst\195\182rt",
	barrier_desc = "Alarmiert, wenn die Barrieren in Phase 2 zerst\195\182rt werden.",

	loot = "Besudelter Kern",
	loot_desc = "Warnt wer einen Besudelten Kern lootet.",

	static_charge_trigger = "^([^%s]+) ([^%s]+) von Statische Aufladung betroffen.$",
	static_charge_message = "Statische Aufladung auf %s!",

	loot_message = "%s hat einen Kern gelootet!",

	phase2_trigger = "Die Zeit ist gekommen! Lasst keinen am Leben!",

	phase2_soon_message = "Phase 2 bald!",
	phase2_message = "Phase 2, Adds kommen!",
	phase3_message = "Phase 3 - Wutanfall in 4min!",

	barrier_down_message = "Barriere %d/4 zerst\195\182rt!",
	barrier_fades_trigger = "Magiebarriere schwindet von Lady Vashj.",

	elemental_bar = "Besudelter Elementar kommt",
	elemental_soon_message = "Besudelter Elementar bald!",

	strider_bar = "Schreiter kommt",
	strider_soon_message = "Schreiter bald!",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Serpentshrine Cavern"]
mod.enabletrigger = boss
mod.toggleoptions = {"phase", -1, "static", "icon", -1, "elemental", "strider", "loot", "barrier", "proximity", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))
mod.proximityCheck = function( unit ) return CheckInteractDistance( unit, 3 ) end

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()

	-- Check if the player has Deformat.
	if not deformat then
		if AceLibrary:HasInstance("Deformat-2.0") then
			deformat = AceLibrary("Deformat-2.0")
		elseif not checkedForDeformat then
			self:ScheduleEvent(function()
				self:Sync("VashjDeformatCheck")
				self:ScheduleEvent("VashjNoDeformat", function()
					BigWigs:Print(L["deformat"])
				end, 5)
			end, 5)
			checkedForDeformat = true
		end
	end

	if deformat then
		self:RegisterEvent("CHAT_MSG_LOOT")
	end

	playerName = UnitName("player")

	--the following 2 will be removed soon, im keeping it in just now for non enUS clients to translate the yells
	--we are using yells instead to avoid any possible problems with CheckForWipe
	phaseTwoAnnounced = nil
	shieldsFaded = 0

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("UNIT_HEALTH")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Charge")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Charge")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Charge")

	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_SELF")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "VashjStatic", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "VashjLoot", 2)
	self:TriggerEvent("BigWigs_ThrottleSync", "VashjDeformatCheck", 0)
	self:TriggerEvent("BigWigs_ThrottleSync", "VashjDeformat", 0)
	self:TriggerEvent("BigWigs_ThrottleSync", "VashjBarrier", 4)
	self:TriggerEvent("BigWigs_ThrottleSync", "VashjElemDied", 5)
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:CHAT_MSG_LOOT(msg)
	local player, item = deformat(msg, LOOT_ITEM)
	if not player then
		item = deformat(msg, LOOT_ITEM_SELF)
		if item then
			player = playerName
		end
	end

	if type(item) == "string" and type(player) == "string" then
		local itemLink, itemRarity = select(2, GetItemInfo(item))
		if itemRarity and itemRarity == 1 and itemLink then
			local itemId = select(3, itemLink:find("item:(%d+):"))
			if not itemId then return end
			itemId = tonumber(itemId:trim())
			if type(itemId) ~= "number" or itemId ~= 31088 then return end -- Tainted Core
			self:Sync("VashjLoot " .. player)
		end
	end
end

function mod:CHAT_MSG_SPELL_AURA_GONE_OTHER(msg)
	if msg == L["barrier_fades_trigger"] then
		self:Sync("VashjBarrier")
	end
end

function mod:CHAT_MSG_SPELL_AURA_GONE_SELF(msg)
	if msg == L["static_fade"] then
		self:TriggerEvent("BigWigs_HideProximity", self)
	end
end

local elemDies = UNITDIESOTHER:format(L["Tainted Elemental"])
function mod:CHAT_MSG_COMBAT_HOSTILE_DEATH(msg)
	if msg == elemDies then
		self:Sync("VashjElemDied")
	else
		self:GenericBossDeath(msg)
	end
end

function mod:RepeatStrider()
	if self.db.profile.strider then
		self:Bar(L["strider_bar"], 63, "Spell_Nature_AstralRecal")
		delayedStriderMessage = self:DelayedMessage(58, L["strider_soon_message"], "Attention")
	end
	self:ScheduleEvent("Strider", self.RepeatStrider, 63, self)
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg:find(L["phase2_trigger"]) then
		if self.db.profile.phase then
			self:Message(L["phase2_message"], "Important", nil, "Alarm")
		end
		shieldsFaded = 0
		if self.db.profile.elemental then
			self:Bar(L["elemental_bar"], 60, "Spell_Nature_ElementalShields")
			delayedElementalMessage = self:DelayedMessage(55, L["elemental_soon_message"], "Important")
		end
		self:RepeatStrider()
	elseif msg == L["engage_trigger1"] or msg == L["engage_trigger2"] or msg == L["engage_trigger3"]
		or msg == L["engage_trigger4"] or msg == L["engage_trigger5"] then

		phaseTwoAnnounced = nil
		shieldsFaded = 0
		self:Message(L["engage_message"], "Attention")
	end
end

function mod:UNIT_HEALTH(msg)
	if not self.db.profile.phase then return end
	if UnitName(msg) == boss then
		local hp = UnitHealth(msg)
		if hp > 70 and hp < 75 and not phaseTwoAnnounced then
			self:Message(L["phase2_soon_message"], "Attention")
			phaseTwoAnnounced = true
		elseif hp > 80 and phaseTwoAnnounced then
			phaseTwoAnnounced = nil
		end
	end
end

function mod:Charge(msg)
	local splayer, stype = select(3, msg:find(L["static_charge_trigger"]))
	if splayer and stype then
		if splayer == L2["you"] and stype == L2["are"] then
			splayer = playerName
			self:TriggerEvent("BigWigs_ShowProximity", self)
		end
		self:Sync("VashjStatic " .. splayer)
	end
end

function mod:BigWigs_RecvSync( sync, rest, nick )
	if sync == "VashjStatic" and rest and self.db.profile.static then
		local msg = L["static_charge_message"]:format(rest)
		self:Message(msg, "Important", nil, "Alert")
		self:Bar(msg, 20, "Spell_Nature_LightningOverload")
		if self.db.profile.icon then
			self:Icon(rest)
		end
	elseif sync == "VashjElemDied" and self.db.profile.elemental then
		self:Bar(L["elemental_bar"], 60, "Spell_Nature_ElementalShields")
		delayedElementalMessage = self:DelayedMessage(55, L["elemental_soon_message"], "Important")
	elseif sync == "VashjLoot" and rest and self.db.profile.loot then
		self:Message(L["loot_message"]:format(rest), "Positive", nil, "Info")
		if self.db.profile.icon then
			self:Icon(rest)
		end
	elseif sync == "VashjDeformatCheck" and deformat then
		self:Sync("VashjDeformat")
	elseif sync == "VashjDeformat" and self:IsEventScheduled("VashjNoDeformat") then
		self:CancelScheduledEvent("VashjNoDeformat")
	elseif sync == "VashjBarrier" then
		shieldsFaded = shieldsFaded + 1
		if shieldsFaded == 4 then
			if self.db.profile.phase then
				self:Message(L["phase3_message"], "Important", nil, "Alarm")

				self:Bar(L2["enrage"], 240, "Spell_Shadow_UnholyFrenzy")
				self:DelayedMessage(180, L2["enrage_min"]:format(1), "Positive")
				self:DelayedMessage(210, L2["enrage_sec"]:format(30), "Positive")
				self:DelayedMessage(230, L2["enrage_sec"]:format(10), "Urgent")
				self:DelayedMessage(240, L2["enrage_end"]:format(boss), "Attention", nil, "Alarm")
			end

			if delayedElementalMessage and self:IsEventScheduled(delayedElementalMessage) then
				self:CancelScheduledEvent(delayedElementalMessage)
			end
			if delayedStriderMessage and self:IsEventScheduled(delayedStriderMessage) then
				self:CancelScheduledEvent(delayedStriderMessage)
			end
			self:CancelScheduledEvent("Strider")
			self:TriggerEvent("BigWigs_StopBar", self, L["elemental_bar"])
		elseif shieldsFaded < 4 and self.db.profile.barrier then
			self:Message(L["barrier_down_message"]:format(shieldsFaded), "Attention")
		end
	end
end

