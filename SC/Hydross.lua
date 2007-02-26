------------------------------
--     Are you local?     --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Hydross the Unstable"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

local debuff = {0, 10, 25, 50, 100}
local currentPerc
local hCount, cCount = 1, 1

local tooltip

----------------------------
--      Localization     --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Hydross",

	mark_cmd = "mark",
	mark_name = "Mark",
	mark_desc = "Show warnings and counters for marks.",

	enrage_cmd = "enrage",
	enrage_name = "Enrage",
	enrage_desc = "Warn about enrage.",

	stance_cmd = "stance",
	stance_name = "Stance changes",
	stance_desc = "Warn when Hydross changes stances.",

	start_trigger = "I cannot allow you to interfere!",
	
	hydross_trigger = "Mark of Hydross",
	corruption_trigger = "Mark of Corruption",
	
	hydross_bar = "Next Mark of Hydross - %s%%",
	corruption_bar = "Next Mark of Corruption - %s%%",
	enrage_bar = "Enrage",
	
	debuff_warn = "Mark at %s%%!",
	
	poison_stance_trigger = "Aaghh, the poison...",
	water_stance_trigger = "Better, much better.",
	
	poison_stance = "Hydross is now poisoned!",
	water_stance = "Hydross is now cleaned again!",
} end)

L:RegisterTranslations("deDE", function() return {
	start_trigger = "Ich kann nicht zulassen, dass ihr Euch einmischt!",
	
	hydross_trigger = "Mal von Hydross",
	corruption_trigger = "Mal der der Verderbnis",
	
	hydross_bar = "Next Mal von Hydross - %s%%",
	corruption_bar = "Next Mal der der Verderbnis - %s%%",
	enrage_bar = "Wutanfall",
	
	debuff_warn = "Mark bei %s%%!",
	
	poison_stance_trigger = "Aahh, das Gift...",
	water_stance_trigger = "Besser, viel besser.",
	
	poison_stance = "Hydross ist nun vergiftet!",
	water_stance = "Hydross ist wieder gereinigt!",
} end)

----------------------------------
--    Module Declaration   --
----------------------------------

BigWigsHydross = BigWigs:NewModule(boss)
BigWigsHydross.zonename = AceLibrary("Babble-Zone-2.2")["Coilfang Reservoir"]
BigWigsHydross.enabletrigger = boss
BigWigsHydross.toggleoptions = {"stance", "mark", "enrage", "bosskill"}
BigWigsHydross.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsHydross:OnEnable()
	if not tooltip then
		tooltip = CreateFrame("GameTooltip", "HydrossTooltip", UIParent, "GameTooltipTemplate")
		tooltip:SetOwner(UIParent, "ANCHOR_NONE")
	end

	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	self:RegisterEvent("PLAYER_AURAS_CHANGED", "DebuffCheck")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
end

------------------------------
--     Event Handlers    --
------------------------------

function BigWigsHydross:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L["start_trigger"] then
		hCount, cCount = 1, 1
		currentPerc = nil
		if self.db.profile.stance then
			self:Bar(string.format(L["hydross_bar"], debuff[hCount+1]), 15, "Spell_Frost_FrostBolt02")
		end
		if self.db.profile.enrage then
			self:Bar(L["enrage_bar"], 600, "Spell_Shadow_UnholyFrenzy")
		end
	elseif msg == L["poison_stance_trigger"] then
		self:TriggerEvent("BigWigs_StopBar", self, string.format(L["corruption_bar"], debuff[cCount] and debuff[cCount] or 250))
		hCount, cCount = 1, 1
		currentPerc = nil
		if self.db.profile.stance then
			self:Message(string.format(L["poison_stance"], match), "Important")
		end
		if self.db.profile.mark then
			self:Bar(string.format(L["corruption_bar"], debuff[cCount+1]), 15, "Spell_Shadow_AbominationExplosion")
		end
	elseif msg == L["water_stance_trigger"] then
		self:TriggerEvent("BigWigs_StopBar", self, string.format(L["hydross_bar"], debuff[hCount] and debuff[hCount] or 250))
		hCount, cCount = 1, 1
		currentPerc = nil
		if self.db.profile.stance then
			self:Message(string.format(L["water_stance"], match), "Important")
		end
		if self.db.profile.mark then
			self:Bar(string.format(L["hydross_bar"], debuff[hCount+1]), 15, "Spell_Frost_FrostBolt02")
		end
	end
end

function BigWigsHydross:DebuffCheck()
	local i = 1
	while true do
		buffIndex = GetPlayerBuff(i, "HARMFUL")
		if buffIndex == 0 then break end
		tooltip:SetPlayerBuff(buffIndex)
		local bName = HydrossTooltipTextLeft1:GetText()
		if bName == L["hydross_trigger"] then
			local match = select(3, HydrossTooltipTextLeft2:GetText():find("(%d+)"))
			if match ~= currentPerc then
				hCount = hCount + 1
				currentPerc = match
				self:TriggerEvent("BigWigs_StopBar", self, string.format(L["hydross_bar"], debuff[hCount] and debuff[hCount] or 250))
				if self.db.profile.mark then
					self:Message(string.format(L["debuff_warn"], match), "Important")
					self:Bar(string.format(L["hydross_bar"], debuff[hCount+1] and debuff[hCount+1] or 250), 15, "Spell_Frost_FrostBolt02")
				end
			end
		elseif bName == L["corruption_trigger"] then
			local match = select(3, HydrossTooltipTextLeft2:GetText():find("(%d+)"))
			if match ~= currentPerc then
				cCount = cCount + 1
				currentPerc = match
				self:TriggerEvent("BigWigs_StopBar", self, string.format(L["corruption_bar"], debuff[cCount] and debuff[cCount] or 250))
				if self.db.profile.mark then
					self:Message(string.format(L["debuff_warn"], match), "Important")
					self:Bar(string.format(L["corruption_bar"], debuff[cCount+1] and debuff[cCount+1] or 250), 15, "Spell_Shadow_AbominationExplosion")
				end
			end
		end
		i = i + 1
	end
end

