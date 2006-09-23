------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.0")("Ossirian the Unscarred")
local L = AceLibrary("AceLocale-2.0"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Ossirian",

	supreme_cmd = "supreme",
	supreme_name = "Supreme Alert",
	supreme_desc = "Warn for Supreme Mode",

	debuff_cmd = "debuff",
	debuff_name = "Debuff Alert",
	debuff_desc = "Warn for Defuff",

	supremetrigger = "Ossirian the Unscarred gains Strength of Ossirian.",
	supremewarn = "Ossirian Supreme Mode!",
	supremedelaywarn = "Supreme in %d seconds!",
	debufftrigger = "^Ossirian the Unscarred is afflicted by (.+) Weakness%.$",
	debuffwarn = "Ossirian now weak to %s!",
	bartext = "Supreme",
	expose = "Expose",

	["Shadow"] = true,
	["Fire"] = true,
	["Frost"] = true,
	["Nature"] = true,
	["Arcane"] = true,
} end )

L:RegisterTranslations("frFR", function() return {
	supremetrigger = "Ossirian l'Intouch\195\169 gagne Force d'Ossirian%.",
	debufftrigger = "^Ossirian l'Intouch\195\169 subit les effets de Sensibilit\195\169 .* l?'?(.+)%.$",

	supremewarn = "Ossirian est en mode Supr\195\170me !",
	debuffwarn = "Ossirian est sensible pour 45 secondes : %s",
	supremedelaywarn = "Supr\195\170me dans %d secondes !",
	bartext = "Supr\195\170me",

	["Shadow"] = "Ombre",
	["Fire"] = "Feu",
	["Frost"] = "Froid",
	["Nature"] = "Nature",
	["Arcane"] = "Arcane",
} end )

L:RegisterTranslations("deDE", function() return {
	supreme_name = "St\195\164rke des Ossirian",
	supreme_desc = "Warnung vor St\195\164rke des Ossirian.",

	debuff_name = "Debuff",
	debuff_desc = "Warnung vor Debuff.",

	supremetrigger = "Ossirian der Narbenlose bekommt 'St\195\164rke des Ossirian'.",
	supremewarn = "St\195\164rke des Ossirian!",
	supremedelaywarn = "St\195\164rke des Ossirian in %d Sekunden!",
	debufftrigger = "Ossirian der Narbenlose ist von (.*)schw\195\164che betroffen%.$",
	debuffwarn = "Ossirian f\195\188r 45 Sekunden anf\195\164llig gegen: %s",
	bartext = "St\195\164rke des Ossirian",
	expose = "Schw\195\164che",
} end )

L:RegisterTranslations("zhCN", function() return {
	supreme_name = "无敌警报",
	supreme_desc = "奥斯里安进入无敌状态时发出警报",

	debuff_name = "不良效果警报",
	debuff_desc = "奥斯里安受到虚弱效果影响时发出警报",

	supremetrigger = "无疤者奥斯里安获得了奥斯里安之力的效果。",
	supremewarn = "无疤者奥斯里安无敌了！速退！",
	supremedelaywarn = "%d秒后奥斯里安无敌",
	debufftrigger = "^无疤者奥斯里安受到了(.+)虚弱效果的影响。$",
	debuffwarn = "奥斯里安新法术弱点: %s",
	bartext = "无敌",
	expose = "Expose",	
} end )

L:RegisterTranslations("koKR", function() return {
	supreme_name = "무적 경고",
	supreme_desc = "무적 모드에 대한 경고",

	debuff_name = "약화마법 경고",
	debuff_desc = "약화마법에 대한 경고",

	supremetrigger = "무적의 오시리안|1이;가; 오시리안의 힘 효과를 얻었습니다.",
	supremewarn = "오시리안 무적 상태!",
	supremedelaywarn = "%d초후 무적 상태 돌입!",
	debufftrigger = "무적의 오시리안|1이;가; (.+) 약점에 걸렸습니다.",
	debuffwarn = "오시리안이 %s 계열 마법에 약해졌습니다.",
	bartext = "무적 상태",
	expose = "노출",	-- CHECK

} end )


----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsOssirian = BigWigs:NewModule(boss)
BigWigsOssirian.zonename = AceLibrary("Babble-Zone-2.0")("Ruins of Ahn'Qiraj")
BigWigsOssirian.enabletrigger = boss
BigWigsOssirian.toggleoptions = {"supreme", "debuff", "bosskill"}
BigWigsOssirian.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsOssirian:OnEnable()
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE")
	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "OssirianWeakness", 10)
end

function BigWigsOssirian:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS( msg )
	if self.db.profile.supreme and arg1 == L["supremetrigger"] then
		self:TriggerEvent("BigWigs_Message", L["supremewarn"], "Yellow")
	end
end

function BigWigsOssirian:CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE( msg )
	local _, _, debuffName = string.find(msg, L["debufftrigger"])
	if debuffName and debuffName ~= L["expose"] then
		if L:HasReverseTranslation(debuffName) then
			self:TriggerEvent("BigWigs_SendSync", "OssirianWeakness "..L:GetReverseTranslation(debuffName))
		end
	end
end

function BigWigsOssirian:BigWigs_RecvSync(sync, debuffKey)
	if sync ~= "OssirianWeakness" then return end

	if self.db.profile.debuff and debuffKey then
		self:TriggerEvent("BigWigs_Message", format(L["debuffwarn"], debuffKey), "Red")
	end

	self:CancelScheduledEvent("bwossiriansupreme1")
	self:CancelScheduledEvent("bwossiriansupreme2")
	self:CancelScheduledEvent("bwossiriansupreme3")
	self:TriggerEvent("BigWigs_BarStop", L["bartext"])

	if self.db.profile.supreme then
		self:ScheduleEvent("bwossiriansupreme1", "BigWigs_Message", 30, format(L["supremedelaywarn"], 15), "Yellow")
		self:ScheduleEvent("bwossiriansupreme2", "BigWigs_Message", 35, format(L["supremedelaywarn"], 10), "Orange")
		self:ScheduleEvent("bwossiriansupreme3", "BigWigs_Message", 40, format(L["supremedelaywarn"], 5), "Red")
		self:TriggerEvent("BigWigs_StartBar", self, L["bartext"], 45, "Interface\\Icons\\Spell_Shadow_CurseOfTounges", "Green", "Yellow", "Orange", "Red")
	end
end

