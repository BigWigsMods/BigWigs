------------------------------
--     Are you local?     --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Hydross the Unstable"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")
local BZ = AceLibrary("Babble-Zone-2.2")

local inTomb = {}
local debuff = {0, 10, 25, 50, 100, 250}
local currentPerc
local count = 1

local tooltip

----------------------------
--      Localization     --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Hydross",

	mark = "Mark",
	mark_desc = "Show warnings and counters for marks",

	enrage = "Enrage",
	enrage_desc = "Warn for enrage",

	stance = "Stance changes",
	stance_desc = ("Warn when %s changes stances"):format(boss),

	sludge = "Vile Sludge",
	sludge_desc = "Notify of players afflicted by Vile Sludge",

	icon = "Vile Sludge Icon",
	icon_desc = "Place a Raid Icon on the player afflicted by Vile Sludge",

	tomb = "Water Tomb",
	tomb_desc = "Notify of players afflicted by Water Tomb",

	start_trigger = "I cannot allow you to interfere!",

	hydross_trigger = "Mark of Hydross",
	corruption_trigger = "Mark of Corruption",

	hydross_bar = "Mark of Hydross - %s%%",
	corruption_bar = "Mark of Corruption - %s%%",

	debuff_warn = "Mark at %s%%!",

	poison_stance_trigger = "Aaghh, the poison...",
	water_stance_trigger = "Better, much better.",

	poison_stance = "Hydross is now poisoned!",
	water_stance = "Hydross is now cleaned again!",

	sludge_trigger = "^([^%s]+) ([^%s]+) afflicted by Vile Sludge",
	sludge_message = "Vile Sludge: %s",

	tomb_trigger = "^([^%s]+) ([^%s]+) afflicted by Water Tomb",
	tomb_message = "Water Tomb: %s",
} end)

L:RegisterTranslations("deDE", function() return {
	start_trigger = "Ich kann nicht zulassen, dass ihr Euch einmischt!",

	mark = "Mal",
	mark_desc = "Zeigt Warnungen und Anzahl des Mals.",

	enrage = "Wutanfall",
	enrage_desc = "Warnt vor Wutanfall.",

	stance = "Phasenwechsel",
	stance_desc = ("Warnt wenn %s seine Phase wechselt."):format(boss),

	sludge = "\195\156bler Schlamm",
	sludge_desc = "Warnt welche Spieler von \195\156bler Schlamm betroffen sind.",

	icon = "\195\156bler Schlamm Icon",
	icon_desc = "Platziert ein Schlachtzugssymbol auf dem Spieler, welcher von \195\156bler Schlamm betroffen ist (ben\195\182tigt 'bef\195\182rdert' oder h\195\182her)",

	tomb = "Wassergrab",
	tomb_desc = "Warnt welche Spieler von Wassergrab betroffen sind.",

	start_trigger = "Ich kann nicht zulassen, dass Ihr Euch einmischt!",

	hydross_trigger = "Mal von Hydross",
	corruption_trigger = "Mal der der Verderbnis",

	hydross_bar = "Mal von Hydross - %s%%",
	corruption_bar = "Mal der Verderbnis - %s%%",

	debuff_warn = "Mal bei %s%%!",

	poison_stance_trigger = "Aahh, das Gift...",
	water_stance_trigger = "Besser, viel besser.",

	poison_stance = "Hydross ist nun vergiftet!",
	water_stance = "Hydross ist wieder gereinigt!",

	sludge_trigger = "^([^%s]+) ([^%s]+) von \195\156bler Schlamm betroffen",
	sludge_message = "\195\156bler Schlamm: %s",

	tomb_trigger = "^([^%s]+) ([^%s]+) von Wassergrab betroffen",
	tomb_message = "Wassergrab: %s",
} end)

L:RegisterTranslations("koKR", function() return {
	mark = "징표",
	mark_desc = "징표 경고",

	enrage = "격노",
	enrage_desc = "격노 경고",

	stance = "태세 변경",
	stance_desc = ("%s의 태세 변경 경고"):format(boss),

	start_trigger = "방해하도록 놔두지 않겠습니다!",

	hydross_trigger = "히드로스의 징표",
	corruption_trigger = "타락의 징표",

	hydross_bar = "다음 히드로스의 징표 - %s%%",
	corruption_bar = "다음 타락의 징표 - %s%%",

	debuff_warn = "징표 %s%%!",

	poison_stance_trigger = "으아아, 독이...",
	water_stance_trigger = "아... 기분이 훨씬 좋군.",

	poison_stance = "히드로스 오염!",
	water_stance = "히드로스 정화!",
} end)

L:RegisterTranslations("frFR", function() return {
	mark = "Marque",
	mark_desc = "Afficher les alertes et les compteurs des marques",

	enrage = "Enrager",
	enrage_desc = "Pr\195\169venir de l'enrage",

	stance = "Changements d'\195\169tat",
	stance_desc = ("Alerte quand %s change d'\195\169tat"):format(boss),

	start_trigger = "Je ne peux pas vous laisser nous g\195\170ner\194\160!",

	hydross_trigger = "Marque d'Hydross",
	corruption_trigger = "Marque de corruption",

	hydross_bar = "Prochaine Marque d'Hydross - %s%%",
	corruption_bar = "Prochaine Marque de Corruption - %s%%",

	debuff_warn = "Marque \195\160 %s%%!",

	poison_stance_trigger = "Aaarrgh, le poison\226\128\166",
	water_stance_trigger = "\195\135a va mieux. Beaucoup mieux.",

	poison_stance = "Hydross est maintenant empoisonn\195\169 !",
	water_stance = "Hydross est de nouveau sain !",
} end)

----------------------------------
--    Module Declaration   --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = {BZ["Coilfang Reservoir"], BZ["Serpentshrine Cavern"]}
mod.otherMenu = "Serpentshrine Cavern"
mod.enabletrigger = boss
mod.toggleoptions = {"stance", "mark", "enrage", -1, "sludge", "icon", "tomb", "proximity", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

mod.proximityCheck = function( unit ) 
	if CheckInteractDistance(unit, 3) then
		return true
	end
	return false
end
mod.proximitySilent = true

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	for k in pairs(inTomb) do inTomb[k] = nil end

	if not tooltip then
		tooltip = CreateFrame("GameTooltip", "HydrossTooltip", UIParent, "GameTooltipTemplate")
		tooltip:SetOwner(UIParent, "ANCHOR_NONE")
	end

	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	self:RegisterEvent("PLAYER_AURAS_CHANGED", "DebuffCheck")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Event")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "HydrossTomb", 0)
end

------------------------------
--     Event Handlers    --
------------------------------

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L["start_trigger"] then
		count = 1
		currentPerc = nil
		if self.db.profile.stance then
			self:Bar(string.format(L["hydross_bar"], debuff[count+1]), 15, "Spell_Frost_FrostBolt02")
		end
		if self.db.profile.enrage then
			self:Message(L2["enrage_start"]:format(boss, 10), "Attention")
			self:DelayedMessage(300, L2["enrage_min"]:format(5), "Positive")
			self:DelayedMessage(420, L2["enrage_min"]:format(3), "Positive")
			self:DelayedMessage(540, L2["enrage_min"]:format(1), "Positive")
			self:DelayedMessage(570, L2["enrage_sec"]:format(30), "Positive")
			self:DelayedMessage(590, L2["enrage_sec"]:format(10), "Urgent")
			self:DelayedMessage(600, L2["enrage_end"]:format(boss), "Attention", nil, "Alarm")
			self:Bar(L2["enrage"], 600, "Spell_Shadow_UnholyFrenzy")
		end
	elseif msg == L["poison_stance_trigger"] then
		self:TriggerEvent("BigWigs_StopBar", self, string.format(L["hydross_bar"], debuff[count+1] and debuff[count+1] or 250))
		count = 1
		currentPerc = nil
		if self.db.profile.stance then
			self:Message(string.format(L["poison_stance"], match), "Important")
		end
		if self.db.profile.mark then
			self:Bar(string.format(L["corruption_bar"], debuff[count+1]), 15, "Spell_Shadow_AbominationExplosion")
		end
		self:TriggerEvent("BigWigs_HideProximity", self)
	elseif msg == L["water_stance_trigger"] then
		self:TriggerEvent("BigWigs_StopBar", self, string.format(L["corruption_bar"], debuff[count+1] and debuff[count+1] or 250))
		count = 1
		currentPerc = nil
		if self.db.profile.stance then
			self:Message(string.format(L["water_stance"], match), "Important")
		end
		if self.db.profile.mark then
			self:Bar(string.format(L["hydross_bar"], debuff[count+1]), 15, "Spell_Frost_FrostBolt02")
		end
		self:TriggerEvent("BigWigs_ShowProximity", self)
	end
end

-- returns the index of the mark in the debuff table, or the index of the last mark ( should not happen )
local function getMark(match)
	for i,v in ipairs(debuff) do
		if v == tonumber(match) then
			return i
		end
	end
	return #debuff
end

function mod:IncrementHydross(match)
	count = getMark(match)
	self:TriggerEvent("BigWigs_StopBar", self, string.format(L["hydross_bar"], debuff[count] and debuff[count] or 250))
	if self.db.profile.mark then
		self:Message(string.format(L["debuff_warn"], match), "Important", nil, "Alert")
		self:Bar(string.format(L["hydross_bar"], debuff[count+1] and debuff[count+1] or 250), 15, "Spell_Frost_FrozenCore")
	end
end

function mod:IncrementCorruption(match)
	count = getMark(match)
	self:TriggerEvent("BigWigs_StopBar", self, string.format(L["corruption_bar"], debuff[count] and debuff[count] or 250))
	if self.db.profile.mark then
		self:Message(string.format(L["debuff_warn"], match), "Important", nil, "Alert")
		self:Bar(string.format(L["corruption_bar"], debuff[count+1] and debuff[count+1] or 250), 15, "Spell_Nature_ElementalShields")
	end
end

function mod:DebuffCheck()
	local i = 1
	while true do
		buffIndex = GetPlayerBuff(i, "HARMFUL")
		if buffIndex == 0 then break end
		tooltip:SetPlayerBuff(buffIndex)
		local bName = HydrossTooltipTextLeft1:GetText()
		if bName == L["hydross_trigger"] then
			local match = select(3, HydrossTooltipTextLeft2:GetText():find("(%d+)"))
			if match ~= currentPerc then
				currentPerc = match
				self:IncrementHydross(match)
			end
		elseif bName == L["corruption_trigger"] then
			local match = select(3, HydrossTooltipTextLeft2:GetText():find("(%d+)"))
			if match ~= currentPerc then
				currentPerc = match
				self:IncrementCorruption(match)
			end
		end
		i = i + 1
	end
end

function mod:Event(msg)
	local gplayer, gtype = select(3, msg:find(L["sludge_trigger"]))
	if gplayer and gtype then
		if gplayer == L2["you"] and gtype == L2["are"] then
			gplayer = UnitName("player")
		end
		self:Sync("HydrossSludge "..gplayer)
	end

	local tplayer, ttype = select(3, msg:find(L["tomb_trigger"]))
	if tplayer and ttype then
		if tplayer == L2["you"] and ttype == L2["are"] then
			tplayer = UnitName("player")
		end
		self:Sync("HydrossTomb " ..tplayer)
	end

end

function mod:TombWarn()
	if self.db.profile.tomb then
		local msg = nil
		for k in pairs(inTomb) do
			if not msg then
				msg = k
			else
				msg = msg .. ", " .. k
			end
		end
		self:Message(L["tomb_message"]:format(msg), "Attention")

	end
	for k in pairs(inTomb) do inTomb[k] = nil end
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if sync == "HydrossSludge" and rest and self.db.profile.sludge then
		self:Message(L["sludge_message"]:format(rest), "Attention")
		self:Bar(L["sludge_message"]:format(rest), 24, "Spell_Nature_AbolishMagic")
		if self.db.profile.icon then
			self:Icon(rest)
		end
	elseif sync == "HydrossTomb" and rest then
		inTomb[rest] = true
		self:ScheduleEvent("Tomb", self.TombWarn, 1.5, self)
	end
end
