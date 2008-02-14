------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Brutallus"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")

local started = nil
local pName = nil
local db = nil
local prevBurnTarget = nil
local burning = { }

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Brutallus",

	burn = "Burn",
	burn_desc = "Tells you who has been hit by Burn and when the next Burn is coming.",
	burn_you = "Burn on YOU!",
	burn_other = "Burn on %s!",
	burn_bar = "Next Burn",
	burn_message = "Next Burn in 5 seconds!",

	icon = "Raid Icon",
	icon_desc = "Place a Raid Icon on players hit by Burn.",

	burnjump = "Burn Jump",
	burnjump_desc = "Warns when people not hit by Burn are afflicted by the DoT.",
	burnjump_you = "Burn jumped to YOU!",
	burnjump_other = "Burn jumped to %s!",
} end )

--[[
	Sunwell modules are PTR beta, as so localization is not supportd in any way
	This gives the authors the freedom to change the modules in way that
	can potentially break localization.
	Feel free to localize, just be aware that you may need to change it frequently.
]]--

L:RegisterTranslations("koKR", function() return {
	burn = "불사르기",
	burn_desc = "불사르기에 적중된 플레이어와 다음 불사르기가 올때를 알립니다.",
	burn_you = "당신에 불사르기!",
	burn_other = "%s에게 불사르기!",
	burn_bar = "다음 불사르기",
	burn_message = "다음 불사르기 5초전!",

	icon = "전술 표시",
	icon_desc = "불사르기에 적중된 플레이어에게 전술 표시를 지정합니다 (승급자 이상 권한 요구).",

	burnjump = "불사르기 이동",
	burnjump_desc = "불사르기에 적중된것이 아닌 도트 디버프가 걸린 플레이어를 알립니다.",
	burnjump_you = "당신에 불사르기 이동!",
	burnjump_other = "%s에게 불사르기 이동!",
} end )

L:RegisterTranslations("frFR", function() return {
	burn = "Brûler",
	burn_desc = "Préviens quand un joueur subit les effets de Brûler et quand arrivera le prochain.",
	burn_you = "Brûler sur VOUS !",
	burn_other = "Brûler sur %s !",
	burn_bar = "Prochain Brûler",
	burn_message = "Prochain Brûler dans 5 sec. !",

	icon = "Icône",
	icon_desc = "Place une icône de raid sur le dernier joueur affecté par Brûler (nécessite d'être promu ou mieux).",

	burnjump = "Saut de Brûler",
	burnjump_desc = "Préviens quand un joueur non affecté par Brûler subit les effets du DoT.",
	burnjump_you = "Brûler a sauté sur YOU !",
	burnjump_other = "Brûler a sauté sur %s !",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Sunwell Plateau"]
mod.enabletrigger = boss
mod.toggleoptions = {"burn", "icon", "burnjump", "enrage", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	started = nil
	prevBurnTarget = nil

	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED", "ProcessCombatLog")

	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "BrutallusBurn", 3)
	self:TriggerEvent("BigWigs_ThrottleSync", "BrutallusBurnJump", 0)

	pName = UnitName("player")
	db = self.db.profile
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:ProcessCombatLog(_, event, _, _, _, _, player, _, spellID)
	if event == "SPELL_DAMAGE" and spellID == 45141 then -- Burn
		prevBurnTarget = player
		self:Sync("BrutallusBurn", player)
	elseif event == "SPELL_AURA_APPLIED" and spellID == 46394 then -- Burn
		self:Sync("BrutallusBurnJump", player)
	elseif event == "UNIT_DIED" and player == boss then
		self:Sync("BossDeath", "Brutallus")
	end
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if sync == "BrutallusBurn" and rest and db.burn then
		local other = L["burn_other"]:format(rest)
		if rest == pName then
			self:Message(L["burn_you"], "Personal", true, "Long")
			self:Message(other, "Attention", nil, nil, true)
		else
			self:Message(other, "Attention")
		end
		self:Bar(L["burn_bar"], 20, "Spell_Fire_Burnout")
		self:DelayedMessage(15, L["bar_message"], "Attention")
		if db.icon then
			self:Icon(rest)
		end
	elseif sync == "BrutallusBurnJump" and rest and db.burnjump then
		if rest ~= prevBurnTarget then
			burning[rest] = true
		end
		self:ScheduleEvent("BurnJumpCheck", self.BurnJumpWarn, 1, self)
	elseif self:ValidateEngageSync(sync, rest) and not started then
		started = true
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end
		if db.burn then
			self:Bar(L["burn_bar"], 20, "Spell_Fire_Burnout")
			self:DelayedMessage(15, L["bar_message"], "Attention")
		end
		if db.enrage then
			self:Message(string.format(L2["enrage_start"], boss, 6), "Attention")
			self:DelayedMessage(180, string.format(L2["enrage_min"], 3), "Positive")
			self:DelayedMessage(240, string.format(L2["enrage_min"], 2), "Positive")
			self:DelayedMessage(300, string.format(L2["enrage_min"], 1), "Positive")
			self:DelayedMessage(330, string.format(L2["enrage_sec"], 30), "Positive")
			self:DelayedMessage(350, string.format(L2["enrage_sec"], 10), "Urgent")
			self:DelayedMessage(355, string.format(L2["enrage_sec"], 5), "Urgent")
			self:DelayedMessage(360, string.format(L2["enrage_end"], boss), "Attention", nil, "Alarm")
			self:Bar(L2["enrage"], 360, "Spell_Shadow_UnholyFrenzy")
		end
	end
end

function mod:BurnJumpWarn()
	if db.burnjump then
		local msg = nil
		for k in pairs(burning) do
			if not msg then
				msg = k
			else
				msg = msg .. ", " .. k
			end
			if k == pName then
				self:Message(L["burnjump_you"], "Personal", true, "Long")
			end
		end
		if msg ~= nil then
			self:Message(string.format(L["burnjump_other"], msg), "Important", nil, "Alert")
		end
	end
	for k in pairs(burning) do burning[k] = nil end
	prevBurnTarget = nil
end

