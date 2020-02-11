--------------------------------------------------------------------------------
-- Module declaration
--

local mod, CL = BigWigs:NewBoss("Chromaggus", 469)
if not mod then return end
mod:RegisterEnableMob(14020)
mod:SetAllowWin(true)
mod.engageId = 616

--------------------------------------------------------------------------------
-- Locals
--

local barcount = 2
local debuffCount = 0
local icons = {
	[mod:SpellName(23170)] = 23170,
	[mod:SpellName(23154)] = 23154,
	[mod:SpellName(23155)] = 23155,
	[mod:SpellName(23169)] = 23169,
	[mod:SpellName(23153)] = 23153,
	[mod:SpellName(23310)] = 23310,
	[mod:SpellName(23313)] = 23313,
	[mod:SpellName(23315)] = 23315,
	[mod:SpellName(23308)] = 23308,
	[mod:SpellName(23187)] = 23187,
	[mod:SpellName(23312)] = 23312,
	[mod:SpellName(23314)] = 23314,
	[mod:SpellName(23316)] = 23316,
	[mod:SpellName(23309)] = 23309,
	[mod:SpellName(23189)] = 23189,
	[mod:SpellName(33551)] = 33551,
}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.breath = "Breaths"
	L.breath_desc = "Warn for Breaths."

	L.debuffs = "{23174} ({605})" -- Chromatic Mutation (Mind Control)
	L.debuffs_desc = 23174
	L.debuffs_icon = 23174
	L.debuffs_message = "3/5 debuffs, carefull!"
	L.debuffs_warning = "4/5 debuffs, %s on 5th!"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		23128, -- Enrage
		23537, -- Frenzy
		"breath",
		"debuffs",
		--"vulnerability",
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Log("SPELL_AURA_APPLIED", "Enrage", self:SpellName(23128))
	self:Log("SPELL_AURA_APPLIED", "Frenzy", self:SpellName(23537))
	self:Log("SPELL_AURA_APPLIED", "Debuffs",
		self:SpellName(23170),
		self:SpellName(23154),
		self:SpellName(23155),
		self:SpellName(23169),
		self:SpellName(23153)) -- Brood Affliction: Bronze, Black, Red, Green, Blue
	self:Log("SPELL_AURA_REMOVED", "DebuffsRemoved",
		self:SpellName(23170),
		self:SpellName(23154),
		self:SpellName(23155),
		self:SpellName(23169),
		self:SpellName(23153)) -- Brood Affliction: Bronze, Black, Red, Green, Blue
	self:Log("SPELL_CAST_START", "Breath",
		self:SpellName(23310), self:SpellName(23312), -- Time Lapse
		self:SpellName(23313), self:SpellName(23314), self:SpellName(33551), -- Corrosive Acid
		self:SpellName(23315), self:SpellName(23316), -- Ignite Flesh
		self:SpellName(23308), self:SpellName(23309), -- Incinerate
		self:SpellName(23187), self:SpellName(23189) -- Frost Burn
	)

	self:Death("Win", 14020)
end

function mod:OnEngage()
	barcount = 2
	debuffCount = 0

	local b1 = CL.count:format(self:SpellName(18617), 1) -- Breath (1)
	local b2 = CL.count:format(self:SpellName(18617), 2) -- Breath (2)
	self:Bar("breath", 30, b1, 212812) -- INV_Misc_QuestionMark / icon 134400
	self:Bar("breath", 60, b2, 212812)
	self:DelayedMessage("breath", 20, "green", CL.custom_sec:format(b1, 10))
	self:DelayedMessage("breath", 50, "green", CL.custom_sec:format(b2, 10))
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Enrage(args)
	self:Message(23128, "yellow")
end

function mod:Frenzy(args)
	self:Message(23537, "red", nil, "20% - ".. args.spellName)
end

function mod:Debuffs(args)
	if self:Me(args.destGUID) then
		debuffCount = debuffCount + 1
		if debuffCount == 3 then
			self:Message("debuffs", "red", "Alarm", L.debuffs_message, icons[args.spellName] or false)
		elseif debuffCount == 4 then
			self:Message("debuffs", "orange", "Warning", L.debuffs_warning:format(self:SpellName(605)), icons[args.spellName] or false) -- 605 = Mind Control
		elseif debuffCount == 5 then
			self:Message("debuffs", "orange", "Warning", 605, icons[args.spellName] or false) -- 605 = Mind Control
		end
	end
end

function mod:DebuffsRemoved(args)
	if self:Me(args.destGUID) then
		debuffCount = debuffCount - 1
	end
end

function mod:Breath(args)
	if barcount == 2 then
		barcount = 1
		self:StopBar(CL.count:format(self:SpellName(18617), 1)) -- Breath (1)
	elseif barcount == 1 then
		barcount = 0
		self:StopBar(CL.count:format(self:SpellName(18617), 2)) -- Breath (2)
	end

	self:Bar("breath", 2, CL.cast:format(args.spellName), icons[args.spellName])
	self:Message("breath", "yellow", nil, CL.casting:format(args.spellName), icons[args.spellName])
	self:DelayedMessage("breath", 50, "red", CL.custom_sec:format(args.spellName, 10))
	self:Bar("breath", 60, icons[args.spellName])
end

--function mod:CHAT_MSG_MONSTER_EMOTE(msg)
--	if msg == L["vulnerability_trigger"] then
--		if self.db.profile.vulnerability then
--			self:Message(L["vulnerability_warning"], "green")
--		end
--		--self:ScheduleEvent("BWChromNilSurv", function() mod.vulnerability = nil end, 2.5)
--	end
--end

--if (GetLocale() == "koKR") or (GetLocale() == "zhCN") then
--	function mod:PlayerDamageEvents(msg)
--		if (not self.vulnerability) then
--			local dmg, school, type = select(4, msg:find(L["vulnerability_test"]))
--			if ( type == L["hit"] or type == L["crit"] ) and tonumber(dmg or "") and school then
--				if (tonumber(dmg) >= 550 and type == L["hit"]) or (tonumber(dmg) >= 1100 and type == L["crit"]) then
--					self.vulnerability = school
--					if self.db.profile.vulnerability then self:Message(format(L["vulnerability_message"], school), "green") end
--				end
--			end
--		end
--	end
--else
--	function mod:PlayerDamageEvents(msg)
--		if (not self.vulnerability) then
--			local type, dmg, school = select(3, msg:find(L["vulnerability_test"]))
--			if ( type == L["hit"] or type == L["crit"] ) and tonumber(dmg or "") and school then
--				if (tonumber(dmg) >= 550 and type == L["hit"]) or (tonumber(dmg) >= 1100 and type == L["crit"]) then
--					self.vulnerability = school
--					if self.db.profile.vulnerability then self:Message(format(L["vulnerability_message"], school), "green") end
--				end
--			end
--		end
--	end
--end

--L:RegisterTranslations("enUS", function() return {
--	vulnerability = "Vulnerability Change",
--	vulnerability_desc = "Warn for Vulnerability changes.",
--	vulnerability_trigger = "%s flinches as its skin shimmers.",
--	vulnerability_message = "Vulnerability: %s!",
--	vulnerability_warning = "Spell vulnerability changed!",
--} end )

--L:RegisterTranslations("ruRU", function() return {
--	vulnerability = "Изменение уязвимости",
--	vulnerability_desc = "Сообщать когда уязвимость изменяется.",
--	vulnerability_trigger = "%s отступает как мерцания его кожи.",
--	vulnerability_message = "Уязвимость: %s!",
--	vulnerability_warning = "УЯЗВИМОСТЬ К СПЕЛАМ ИЗМЕНЕНА!",
--} end )

--L:RegisterTranslations("deDE", function() return {
--	vulnerability = "Zauber-Verwundbarkeiten",
--	vulnerability_desc = "Warnung, wenn Chromagguss Zauber-Verwundbarkeit sich ändert.",
--	vulnerability_trigger = "%s weicht zurück, als die Haut schimmert.",
--	vulnerability_message = "Neue Zauber-Verwundbarkeit: %s",
--	vulnerability_warning = "Zauber-Verwundbarkeit geändert!",
--} end )

--L:RegisterTranslations("zhCN", function() return {
--	vulnerability = "弱点警报",
--	vulnerability_desc = "克洛玛古斯弱点改变时发出警报",
--	vulnerability_trigger = "%s的皮肤闪着微光，它畏缩了。",
--	vulnerability_message = "克洛玛古斯新弱点：%s",
--	vulnerability_warning = "克洛玛古斯弱点改变",
--} end )

--L:RegisterTranslations("zhTW", function() return {
--	vulnerability = "弱點改變警報",
--	vulnerability_desc = "當克洛瑪古斯弱點改變時發出警報",
--	vulnerability_trigger = "%s因皮膚閃著微光而驚訝退縮。", --完全比對
--	vulnerability_message = "克洛瑪古斯新弱點：%s ！",
--	vulnerability_warning = "克洛瑪古斯弱點改變",
--} end )

--L:RegisterTranslations("koKR", function() return {
--	vulnerability = "약화 속성 경고",
--	vulnerability_desc = "약화 속성 변경에 대한 경고",
--	vulnerability_trigger = "%s|1이;가; 주춤하면서 물러나면서 가죽이 빛납니다.", --"가죽이 점점 빛나면서 물러서기 시작합니다.",
--	vulnerability_message = "새로운 취약 속성: %s",
--	vulnerability_warning = "취약 속성이 변경되었습니다!",
--} end )

--L:RegisterTranslations("frFR", function() return {
--	vulnerability = "Changement de vulnérabilité",
--	vulnerability_desc = "Préviens quand la vulnérabilité change.",
--	vulnerability_trigger = "%s grimace lorsque sa peau se met à briller.",
--	vulnerability_message = "Vulnerabilité : %s !",
--	vulnerability_warning = "Vulnérabilité aux sorts changée !",
--} end )

