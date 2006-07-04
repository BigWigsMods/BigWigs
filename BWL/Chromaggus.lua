local bboss = BabbleLib:GetInstance("Boss 1.2")

BigWigsChromaggus = AceAddon:new({
	name          = "BigWigsChromaggus",
	cmd           = AceChatCmd:new({}, {}),

	zonename = BabbleLib:GetInstance("Zone 1.2")("Blackwing Lair"),
	enabletrigger = bboss("Chromaggus"),
	bossname = bboss("Chromaggus"),
	
	toggleoptions = GetLocale() == "koKR" and {
		notBreaths = "브레스 경고",
		notVulnerability = "취약 속성 변경 경고",
		notFrenzy = "광폭화 시간 경고",
		notBosskill = "보스 사망 알림",
	} or {
		notBreaths = "Warn for Chromaggus his breaths",
		notVulnerability = "Warn when Chromaggus his vulnerability changes",
		notFrenzy = "Warn when Chromaggus goes into a killing frenzy",
		notBosskill = "Boss death",
	},
	optionorder = {"notBreaths", "notVulnerability", "notFrenzy", "notBosskill"},

	loc = GetLocale() == "koKR" and {
		disabletrigger = "크로마구스|1이;가; 죽었습니다.",

		trigger1 = "크로마구스|1이;가; (.+)|1을;를; 시전합니다.",
		trigger2 = "(.+)|1이;가; (.+)|1으로;로; 크로마구스에게 (%d+)의 (.+) 입혔습니다.",
		trigger3 = "크로마구스|1이;가; 시간의 쇠퇴|1으로;로; (.+)|1을;를; 공격했지만 저항했습니다.",		
		trigger4 = "광란의 상태에 빠집니다!",
		trigger5 = "가죽이 점점 빛나면서 물러서기 시작합니다.",

		hit = "피해를",
		crit = "치명상을",

		warn1 = "%s 10초전!",
		warn2 = "%s를 시전합니다!",
		warn3 = "새로운 취약 속성: %s",
		warn4 = "취약 속성이 변경되었습니다!",
		warn5 = "광폭화 - 평정 사격!",
		bosskill = "크로마구스를 물리쳤습니다!",

		breathsicons = {
			["시간의 쇠퇴"] = "Interface\\Icons\\Spell_Arcane_PortalOrgrimmar",
			["부식성 산"] = "Interface\\Icons\\Spell_Nature_Acid_01",
			["살점 태우기"] = "Interface\\Icons\\Spell_Fire_Fire",
			["소각"] = "Interface\\Icons\\Spell_Shadow_ChillTouch",
			["동결"] = "Interface\\Icons\\Spell_Frost_ChillingBlast",
		}
	}
		or GetLocale() == "deDE" and
	{
		disabletrigger = "Chromaggus stirbt.",

		trigger1 = "^Chromaggus beginnt ([%w ]+)\ zu wirken.",
		trigger2 = "^[%w']+ [%w' ]+ ([%w]+) Chromaggus f\195\188r ([%d]+) ([%w ]+) Schaden%..*",
		trigger3 = "Chromagguss Zeitraffer wurde von ([%w]+)% wiederstanden.",
		trigger4 = "ger\195\164t in t\195\182dliche Raserei!",
		trigger5 = "als die Haut schimmert",

		hit = "trifft",
		crit = "trifft kritisch",

		warn1 = "%s in 10 Sekunden!",
		warn2 = "%s wirkt!",
		warn3 = "Neue Zauberspruchverwundbarkeit: %s",
		warn4 = "Zauberspruchverwundbarkeit hat sich ge\195\164ndert!",
		warn5 = "Raserei - Einlullender Schuss!",
		bosskill = "Chromaggus wurde besiegt!",

		breathsicons = {
			["Zeitraffer"] = "Interface\\Icons\\Spell_Arcane_PortalOrgrimmar",
			["Corrosive Acid"] = "Interface\\Icons\\Spell_Nature_Acid_01",
			["Fleisch entz\195\188nden"] = "Interface\\Icons\\Spell_Fire_Fire",
			["Verbrennen"] = "Interface\\Icons\\Spell_Shadow_ChillTouch",
			["Frostbeulen"] = "Interface\\Icons\\Spell_Frost_ChillingBlast",
		}
	}
		or GetLocale() == "zhCN" and
	{
		disabletrigger = "克洛玛古斯死亡了。",

		trigger1 = "^克洛玛古斯开始施放(.+)。",
		trigger2 = "^.+的(.+)克洛玛古斯造成(%d+)点(.+)伤害。",
		trigger3 = "^克洛玛古斯的时间流逝被(.+)抵抗了。",
		trigger4 = "变得极为狂暴！",
		trigger5 = "的皮肤闪着光芒",

		hit = "击中",
		crit = "致命一击",

		warn1 = "%s - 10秒后施放！",
		warn2 = "正在施放 %s！",
		warn3 = "新法术弱点：%s",
		warn4 = "法术弱点已改变！",
		warn5 = "狂暴警报 - 猎人立刻使用宁神射击！",
		bosskill = "克洛玛古斯被击败了！",

		breathsicons = {
			["时间流逝"] = "Interface\\Icons\\Spell_Arcane_PortalOrgrimmar",
			["腐蚀酸液"] = "Interface\\Icons\\Spell_Nature_Acid_01",
			["Ignite Flesh"] = "Interface\\Icons\\Spell_Fire_Fire",
			["Incinerate"] = "Interface\\Icons\\Spell_Shadow_ChillTouch",
			["冰霜灼烧"] = "Interface\\Icons\\Spell_Frost_ChillingBlast",
		}
	}	or {
		disabletrigger = "Chromaggus dies.",

		trigger1 = "^Chromaggus begins to cast ([%w ]+)\.",
		trigger2 = "^[%w']+ [%w' ]+ ([%w]+) Chromaggus for ([%d]+) ([%w ]+) damage%..*",
		trigger3 = "Chromaggus's Time Lapse was resisted by ([%w]+)%.",
		trigger4 = "goes into a killing frenzy!",
		trigger5 = "flinches as its skin shimmers.",

		hit = "hits",
		crit = "crits",

		warn1 = "%s in 10 seconds!",
		warn2 = "%s is casting!",
		warn3 = "New spell vulnerability: %s",
		warn4 = "Spell vulnerability changed!",
		warn5 = "Frenzy - Tranq Shot!",
		bosskill = "Chromaggus has been defeated!",

		breathsicons = {
			["Time Lapse"] = "Interface\\Icons\\Spell_Arcane_PortalOrgrimmar",
			["Corrosive Acid"] = "Interface\\Icons\\Spell_Nature_Acid_01",
			["Ignite Flesh"] = "Interface\\Icons\\Spell_Fire_Fire",
			["Incinerate"] = "Interface\\Icons\\Spell_Shadow_ChillTouch",
			["Frost Burn"] = "Interface\\Icons\\Spell_Frost_ChillingBlast",
		},
	},
})

function BigWigsChromaggus:Initialize()
	self.disabled = true
	self:TriggerEvent("BIGWIGS_REGISTER_MODULE", self)
end

function BigWigsChromaggus:Enable()
	self.disabled = nil
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	self:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE", "PlayerDamageEvents")
	self:RegisterEvent("CHAT_MSG_SPELL_PET_DAMAGE", "PlayerDamageEvents")
	self:RegisterEvent("CHAT_MSG_SPELL_PARTY_DAMAGE", "PlayerDamageEvents")
	self:RegisterEvent("CHAT_MSG_SPELL_FRIENDLYPLAYER_DAMAGE", "PlayerDamageEvents")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	self:RegisterEvent("BIGWIGS_SYNC_CHROMAGGUS_BREATH")
	self:TriggerEvent("BIGWIGS_SYNC_THROTTLE", "CHROMAGGUS_BREATH", 10)
end

function BigWigsChromaggus:Disable()
	self.disabled = true
	self:UnregisterAllEvents()
	self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.breath1)
	self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.breath2)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", format(self.loc.warn1, self.loc.breath1))
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", format(self.loc.warn1, self.loc.breath2))
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.breath1, 30)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.breath1, 50)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.breath2, 30)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.breath2, 50)
	self.loc.vulnerability = nil
	self.loc.breath1 = nil
	self.loc.breath2 = nil
end

function BigWigsChromaggus:CHAT_MSG_COMBAT_HOSTILE_DEATH()
	if (arg1 == self.loc.disabletrigger) then
		if (not self:GetOpt("notBosskill")) then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green", nil, "Victory") end
		self:Disable()
	end
end

function BigWigsChromaggus:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE()
	local _,_, SpellName = string.find(arg1, self.loc.trigger1)
	if (SpellName) then
		self:TriggerEvent("BIGWIGS_SYNC_SEND", "CHROMAGGUS_BREATH "..SpellName)
	end
end

function BigWigsChromaggus:BIGWIGS_SYNC_CHROMAGGUS_BREATH(SpellName)
--	local _,_, SpellName = string.find(arg1, self.loc.trigger1)
	if (SpellName) then
		if (not self.loc.breath1) then
			self.loc.breath1 = SpellName
		elseif (not self.loc.breath2) and (self.loc.breath1 ~= SpellName) then
			self.loc.breath2 = SpellName
		end

		self:TriggerEvent("BIGWIGS_MESSAGE", format(self.loc.warn2, SpellName), "Red")

		if (self.loc.breath1 == SpellName and not self:GetOpt("notBreaths")) then
			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", format(self.loc.warn1, SpellName), 50, "Red")
			self:TriggerEvent("BIGWIGS_BAR_START", self.loc.breath1, 60, 1, "Yellow", self.loc.breathsicons[SpellName])
			self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.breath1, 30, "Orange")
			self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.breath1, 50, "Red")
		elseif (self.loc.breath2 == SpellName and not self:GetOpt("notBreaths")) then
			self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", format(self.loc.warn1, SpellName), 50, "Red")
			self:TriggerEvent("BIGWIGS_BAR_START", self.loc.breath2, 60, 2, "Yellow", self.loc.breathsicons[SpellName])
			self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.breath2, 30, "Orange")
			self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.breath2, 50, "Red")
		end
	end
end

function BigWigsChromaggus:CHAT_MSG_MONSTER_EMOTE()
	if (arg1 == self.loc.trigger4) then
		if (not self:GetOpt("notFrenzy")) then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn5, "Red") end
	elseif (arg1 == self.loc.trigger5) then
		if (not self:GetOpt("notVulnerability")) then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn4, "White") end
		Timex:AddNamedSchedule("BigWigsChromaggusSpellVulnerability", 2.5, false, 1, function() BigWigsChromaggus.loc.vulnerability = nil end)
	end
end

if (GetLocale() == "koKR") then
	function BigWigsChromaggus:PlayerDamageEvents()
		if (not self.loc.vulnerability) then
			local _, _, _, School, Dmg, Type = string.find(arg1, self.loc.trigger2)
			if (Type == (self.loc.hit or self.loc.crit) and tonumber(Dmg or "") and School) then
				if ((tonumber(Dmg) >= 550 and Type == self.loc.hit) or (tonumber(Dmg) >= 1100 and Type == self.loc.crit)) then
					self.loc.vulnerability = School
					if (not self:GetOpt("notVulnerability")) then self:TriggerEvent("BIGWIGS_MESSAGE", format(self.loc.warn3, School), "White") end
				end
			end
		end
	end
else
	function BigWigsChromaggus:PlayerDamageEvents()
		if (not self.loc.vulnerability) then
			local _,_, Type, Dmg, School = string.find(arg1, self.loc.trigger2)
			if (Type == (self.loc.hit or self.loc.crit) and tonumber(Dmg or "") and School) then
				if ((tonumber(Dmg) >= 550 and Type == self.loc.hit) or (tonumber(Dmg) >= 1100 and Type == self.loc.crit)) then
					self.loc.vulnerability = School
					if (not self:GetOpt("notVulnerability")) then self:TriggerEvent("BIGWIGS_MESSAGE", format(self.loc.warn3, School), "White") end
				end
			end
		end
	end
end
--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsChromaggus:RegisterForLoad()