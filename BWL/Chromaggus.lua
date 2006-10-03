------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.0")("Chromaggus")
local L = AceLibrary("AceLocale-2.0"):new("BigWigs"..boss)
local twenty

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Chromaggus",

	enrage_cmd = "enrage",
	enrage_name = "Enrage",
	enrage_desc = "Warn before Enrage at 20%",

	frenzy_cmd = "frenzy",
	frenzy_name = "Frenzy Alert",
	frenzy_desc = "Warn for Frenzy",

	breath_cmd = "breath",
	breath_name = "Breath Alerts",
	breath_desc = "Warn for Breaths",

	vulnerability_cmd = "vulnerability",
	vulnerability_name = "Vulnerability Alerts",
	vulnerability_desc = "Warn for Vulnerability changes",

	breath_trigger = "^Chromaggus begins to cast ([%w ]+)\.",
	vulnerability_test = "^[%w']+ [%w' ]+ ([%w]+) Chromaggus for ([%d]+) ([%w ]+) damage%..*",
	frenzy_trigger = "%s goes into a killing frenzy!",
	vulnerability_trigger = "%s flinches as its skin shimmers.",

	hit = "hits",
	crit = "crits",

	breath_warning = "%s in 10 seconds!",
	breath_message = "%s is casting!",
	vulnerability_message = "Vulnerability: %s!",
	vulnerability_warning = "Spell vulnerability changed!",
	frenzy_message = "Frenzy Alert!",
	enrage_warning = "Enrage soon!",

	breath1 = "Time Lapse",
	breath2 = "Corrosive Acid",
	breath3 = "Ignite Flesh",
	breath4 = "Incinerate",
	breath5 = "Frost Burn",

	iconunknown = "Interface\\Icons\\INV_Misc_QuestionMark",
	icon1 = "Interface\\Icons\\Spell_Arcane_PortalOrgrimmar",
	icon2 = "Interface\\Icons\\Spell_Nature_Acid_01",
	icon3 = "Interface\\Icons\\Spell_Fire_Fire",
	icon4 = "Interface\\Icons\\Spell_Shadow_ChillTouch",
	icon5 = "Interface\\Icons\\Spell_Frost_ChillingBlast",

	castingbar = "Cast %s",

} end )

L:RegisterTranslations("deDE", function() return {
	enrage_name = "Wutanfall",
	enrage_desc = "Warnung, wenn Chromaggus w\195\188tend wird. (ab 20%).",

	frenzy_name = "Raserei",
	frenzy_desc = "Warnung, wenn Chromaggus in Raserei ger\195\164t.",

	breath_name = "Atem",
	breath_desc = "Warnung, wenn Chromaggus seinen Atem wirkt.",

	vulnerability_name = "Zauber-Verwundbarkeiten",
	vulnerability_desc = "Warnung, wenn Chromagguss Zauber-Verwundbarkeit sich \195\164ndert.",

	breath_trigger = "^Chromaggus beginnt (.+) zu wirken%.",
	vulnerability_test = "^[^%s]+ .* trifft Chromaggus(.+)f\195\188r ([%d]+) ([%w ]+)'schaden%..*", -- ?
	frenzy_trigger = "%s ger\195\164t in t\195\182dliche Raserei!",
	vulnerability_trigger = "%s weicht zur\195\188ck, als die Haut schimmert.",

	hit = "trifft",
	crit = "kritisch",

	breath_warning = "%s in 10 Sekunden!",
	breath_message = "Chromaggus wirkt: %s Atem!",
	vulnerability_message = "Neue Zauber-Verwundbarkeit: %s",
	vulnerability_warning = "Zauber-Verwundbarkeit ge\195\164ndert!",
	frenzy_message = "Raserei - Einlullender Schuss!",
	enrage_warning = "Wutanfall steht kurz bevor!",

	breath1 = "Zeitraffer",
	breath2 = "\195\132tzende S\195\164ure",
	breath3 = "Fleisch entz\195\188nden",
	breath4 = "Verbrennen",
	breath5 = "Frostbeulen",
} end )

L:RegisterTranslations("zhCN", function() return {
	enrage_name = "激怒警报",
	enrage_desc = "20%生命激怒前发出警报。",

	frenzy_name = "狂暴警报",
	frenzy_desc = "狂暴警报",

	breath_name = "吐息警报",
	breath_desc = "吐息警报",

	vulnerability_name = "弱点警报",
	vulnerability_desc = "克洛玛古斯弱点改变时发出警报",

	breath_trigger = "^克洛玛古斯开始施放(.+)。",
	vulnerability_test = "^.+的(.+)克洛玛古斯造成(%d+)点(.+)伤害。",
	frenzy_trigger = "变得极为狂暴！",
	vulnerability_trigger = "的皮肤闪着光芒",

	hit = "击中",
	crit = "致命一击",

	breath_warning = "%s - 10秒后施放！",
	breath_message = "克洛玛古斯 %s！",
	vulnerability_message = "克洛玛古斯新弱点：%s",
	vulnerability_warning = "克洛玛古斯弱点改变",
	frenzy_message = "狂暴警报 - 猎人立刻使用宁神射击！",
	enrage_warning = "即将激怒！",

	breath1 = "时间流逝",
	breath2 = "腐蚀酸液",
	breath3 = "点燃肉体",
	breath4 = "焚化",
	breath5 = "冰霜灼烧",
} end )

L:RegisterTranslations("koKR", function() return {
	
	enrage_name = "격노",
	enrage_desc = "20% 격노 전 경고",

	frenzy_name = "광폭화 경고",
	frenzy_desc = "광폭화에 대한 경고",
	
	breath_name = "브레스 경고",
	breath_desc = "브레스에 대한 경고",
	
	vulnerability_name = "약화 속성 경고",
	vulnerability_desc = "약화 속성 변경에 대한 경고",
	
	breath_trigger = "크로마구스|1이;가; (.+)|1을;를; 시전합니다.",
	vulnerability_test = "(.+)|1으로;로; 크로마구스에게 (%d+)의 ([^%s]+) (.*)피해를 입혔습니다.",
	frenzy_trigger = "%s|1이;가; 살기를 띤 듯한 광란의 상태에 빠집니다!",
	vulnerability_trigger = "%s|1이;가; 주춤하면서 물러나면서 가죽이 빛납니다.", --"가죽이 점점 빛나면서 물러서기 시작합니다.",

	hit = "",
	crit = "치명상 ",

	breath_warning = "%s 10초전!",
	breath_message = "%s를 시전합니다!",
	vulnerability_message = "새로운 취약 속성: %s",
	vulnerability_warning = "취약 속성이 변경되었습니다!",
	frenzy_message = "광폭화 - 평정 사격!",
	enrage_warning = "격노 경고!",

	breath1 = "시간의 쇠퇴",
	breath2 = "부식성 산",
	breath3 = "살점 태우기",
	breath4 = "소각",
	breath5 = "동결",

} end )

L:RegisterTranslations("frFR", function() return {
	breath_trigger = "^Chromaggus commence \195\160 lancer (.+)%.",
	vulnerability_test = "^.+ lance .+ et (.+) \195\160 Chromaggus %(([%d]+) points de d\195\169g\195\162ts .+ (.+)%)%.";
	frenzy_trigger = "%s entre dans une fr\195\169n\195\169sie sanglante !",
	vulnerability_trigger = "%s grimace lorsque sa peau se met \195\160 briller.",

	hit = "lui inflige",
	crit = "inflige un coup critique",

	breath_warning = "%s dans 10 seconde!",
	breath_message = "incantation de %s !",
	vulnerability_message = "Nouvelle vulnerabiliter: %s",
	vulnerability_warning = "la vulnerabiliter au sort a changer!",
	frenzy_message = "Frenzy Alert!",
	enrage_warning = "Enrage imminent!",

	breath1 = "Trou de temps",
	breath2 = "Acide corrosif",
	breath3 = "Enflammer la chair",
	breath4 = "Incin\195\169rer",
	breath5 = "Br\195\187lure de givre",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsChromaggus = BigWigs:NewModule(boss)
BigWigsChromaggus.zonename = AceLibrary("Babble-Zone-2.0")("Blackwing Lair")
BigWigsChromaggus.enabletrigger = boss
BigWigsChromaggus.toggleoptions = { "enrage", "frenzy", "breath", "vulnerability", "bosskill"}
BigWigsChromaggus.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsChromaggus:OnEnable()
	-- in the module itself for resetting via schedule
	self.vulnerability = nil
	twenty = nil

	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	self:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE", "PlayerDamageEvents")
	self:RegisterEvent("CHAT_MSG_SPELL_PET_DAMAGE", "PlayerDamageEvents")
	self:RegisterEvent("CHAT_MSG_SPELL_PARTY_DAMAGE", "PlayerDamageEvents")
	self:RegisterEvent("CHAT_MSG_SPELL_FRIENDLYPLAYER_DAMAGE", "PlayerDamageEvents")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("UNIT_HEALTH")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "ChromaggusBreath", 10)
end

function BigWigsChromaggus:UNIT_HEALTH( msg )
	if self.db.profile.enrage and UnitName(msg) == boss then
		local health = UnitHealth(msg)
		if health > 20 and health <= 23 and not twenty then
			if self.db.profile.enrage then self:TriggerEvent("BigWigs_Message", L["enrage_warning"], "Red") end
			twenty = true
		elseif health > 40 and twenty then
			twenty = nil
		end
	end
end

function BigWigsChromaggus:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE( msg )
	local _,_, spellName = string.find(msg, L["breath_trigger"])
	if spellName then
		local breath = L:HasReverseTranslation(spellName) and L:GetReverseTranslation(spellName) or nil
		if not breath then return end
		breath = string.sub(breath, -1)
		self:TriggerEvent("BigWigs_SendSync", "ChromaggusBreath "..breath)
	end
end

function BigWigsChromaggus:BigWigs_RecvSync(sync, spellId)
	if sync ~= "ChromaggusBreath" or not spellId or not self.db.profile.breath then return end

	local spellName = L:HasTranslation("breath"..spellId) and L["breath"..spellId] or nil
	if not spellName then return end

	self:TriggerEvent("BigWigs_StartBar", self, string.format( L["castingbar"], spellName), 2 )
	self:TriggerEvent("BigWigs_Message", string.format(L["breath_message"], spellName), "Red")
	self:ScheduleEvent("bwchromaggusbreath"..spellName, "BigWigs_Message", 50, string.format(L["breath_warning"], spellName), "Red")
	self:TriggerEvent("BigWigs_StartBar", self, spellName, 60, L["icon"..spellId], "Green", "Yellow", "Orange", "Red")
end

function BigWigsChromaggus:CHAT_MSG_MONSTER_EMOTE(msg)
	if msg == L["frenzy_trigger"] and self.db.profile.frenzy then
		self:TriggerEvent("BigWigs_Message", L["frenzy_message"], "Red")
	elseif msg == L["vulnerability_trigger"] then
		if self.db.profile.vulnerability then
			self:TriggerEvent("BigWigs_Message", L["vulnerability_warning"], "White")
		end
		self:ScheduleEvent(function() BigWigsChromaggus.vulnerability = nil end, 2.5)
	end
end

if (GetLocale() == "koKR") then
	function BigWigsChromaggus:PlayerDamageEvents(msg)
		if (not self.vulnerability) then
			local _,_,_, dmg, school, type = string.find(msg, L["vulnerability_test"])
			if ( type == L["hit"] or type == L["crit"] ) and tonumber(dmg or "") and school then
				if (tonumber(dmg) >= 550 and type == L["hit"]) or (tonumber(dmg) >= 1100 and type == L["crit"]) then
					self.vulnerability = school
					if self.db.profile.vulnerability then self:TriggerEvent("BigWigs_Message", format(L["vulnerability_message"], school), "White") end
				end
			end
		end
	end
else
	function BigWigsChromaggus:PlayerDamageEvents(msg)
		if (not self.vulnerability) then
			local _,_, type, dmg, school = string.find(msg, L["vulnerability_test"])
			if ( type == L["hit"] or type == L["crit"] ) and tonumber(dmg or "") and school then
				if (tonumber(dmg) >= 550 and type == L["hit"]) or (tonumber(dmg) >= 1100 and type == L["crit"]) then
					self.vulnerability = school
					if self.db.profile.vulnerability then self:TriggerEvent("BigWigs_Message", format(L["vulnerability_message"], school), "White") end
				end
			end
		end
	end
end

