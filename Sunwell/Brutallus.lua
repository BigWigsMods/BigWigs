------------------------------
--      Are you local?      --
------------------------------

local boss = BB["Brutallus"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

local started = nil
local pName = UnitName("player")
local db = nil

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

	burnresist = "Burn Resist",
	burnresist_desc = "Warn who resists burn.",
	burn_resist = "%s resisted burn",

	meteor = "Meteor Slash",
	meteor_desc = "Show a Meteor Slash timer bar.",
	meteor_bar = "Next Meteor Slash",

	stomp = "Stomp",
	stomp_desc = "Warn for Stomp and show a bar.",
	stomp_warning = "Stomp in 5 sec",
	stomp_message = "Stomp: %s",
	stomp_bar = "Next Stomp",
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
	
	burnresist = "불사르기 저항",
	burnresist_desc = "불사르기에 저항한 플레이어를 알립니다.",
	burn_resist = "%s 불사르기 저항",

	meteor = "유성 베기",
	meteor_desc = "유성 베기 타이머 바를 표시합니다.",
	meteor_bar = "다음 유성 베기",

	stomp = "발 구르기",
	stomp_desc = "발 구르기에 대한 알림과 바를 표시합니다.",
	stomp_warning = "5초 이내 발 구르기",
	stomp_message = "발 구르기: %s",
	stomp_bar = "다음 발 구르기",
} end )

L:RegisterTranslations("frFR", function() return {
	burn = "Brûler",
	burn_desc = "Préviens quand un joueur subit les effets de Brûler et quand arrivera le prochain.",
	burn_you = "Brûler sur VOUS !",
	burn_other = "Brûler sur %s !",
	burn_bar = "Prochain Brûler",
	burn_message = "Prochain Brûler dans 5 sec. !",

	burnresist = "Résistances à Brûler",
	burnresist_desc = "Préviens quand un joueur a résisté à Brûler.",
	burn_resist = "%s a résisté à Brûler",

	meteor = "Attaque météorique",
	meteor_desc = "Affiche une barre temporelle pour l'Attaque météorique.",
	meteor_bar = "Prochaine Attaque météorique",

	stomp = "Piétinement",
	stomp_desc = "Préviens l'arrivée des Piétinements et affiche une barre.",
	stomp_warning = "Piétinement dans 5 sec.",
	stomp_message = "Piétinement : %s",
	stomp_bar = "Prochain Piétinement",
} end )

L:RegisterTranslations("deDE", function() return {
	burn = "Brand",
	burn_desc = "Sagt dir wer von Brand betroffen ist und wann der nächste Brand zu erwarten ist.",
	burn_you = "Brand auf DIR!",
	burn_other = "Brand auf %s!",
	burn_bar = "Nächster Brand",
	burn_message = "Nächster Brand in 5 Sekunden!",

	burnresist = "Brand wiederstanden",
	burnresist_desc = "Warnt wer Brand weiderstanden hat.",
	burn_resist = "%s hat Brand wiederstanden",

	meteor = "Meteor Slash",
	meteor_desc = "Zeigt einen Meteor Slash Zeitbalken an.",
	meteor_bar = "Nächster Meteor Slash",

	stomp = "Stampfen",
	stomp_desc = "Warnt vor Stampfen und zeigt einen Balken an.",
	stomp_warning = "Stampfen in 5 sek",
	stomp_message = "Stampfen: %s",
	stomp_bar = "Nächstes Stampfen",
} end )

L:RegisterTranslations("zhCN", function() return {
	burn = "燃烧",
	burn_desc = "当队员(或者你)中了燃烧发出警报,和下一个燃烧记时条",
	burn_you = "燃烧 > 你 <!",
	burn_other = "燃烧 > %s <!",
	burn_bar = "下一个 燃烧",
	burn_message = "Next Burn in 5 seconds!",

	burnresist = "燃烧抵抗",
	burnresist_desc = "当队员抵抗了燃烧攻击发出警报",
	burn_resist = "%s 抵抗了> 燃烧 <",

	meteor = "流行命令",--Meteor Slash check
	meteor_desc = "显示Meteor Slash记时条.",
	meteor_bar = "下一个Meteor Slash",

	stomp = "践踏",
	stomp_desc = "践踏警报和记时条",
	stomp_warning = "5秒后 践踏",
	stomp_message = "践踏: %s",
	stomp_bar = "下一个践踏",
} end )


----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = BZ["Sunwell Plateau"]
mod.enabletrigger = boss
mod.toggleoptions = {"burn", "burnresist", "meteor", "stomp", "enrage", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	started = nil

	self:AddCombatListener("SPELL_MISSED", "BurnResist", 45141)
	self:AddCombatListener("SPELL_CAST_START", "Meteor", 45150)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Burn", 46394)
	self:AddCombatListener("SPELL_AURA_REMOVED", "BurnRemove", 46394)
	self:AddCombatListener("SPELL_DAMAGE", "Stomp", 45185)
	self:AddCombatListener("UNIT_DIED", "GenericBossDeath")

	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	self:RegisterEvent("BigWigs_RecvSync")
	self:Throttle(300, "BrutallusBurn", "BrutallusBurnJump") --remove after brut is disabled on ptr

	db = self.db.profile
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Burn(player, spellID)
	if db.burn then
		local other = L["burn_other"]:format(player)
		if player == pName then
			self:Message(L["burn_you"], "Personal", true, "Alert", nil, spellID)
			self:Message(other, "Attention", nil, nil, true)
		else
			self:Message(other, "Attention", nil, nil, nil, spellID)
		end
		self:Bar(other, 60, spellID)
	end
end

function mod:Meteor()
	if db.meteor then
		self:Bar(L["meteor_bar"], 12, 45150)
	end
end

function mod:BurnRemove(player)
	if db.burn then
		self:TriggerEvent("BigWigs_StopBar", self, L["burn_other"]:format(player))
	end
end

function mod:BurnResist(player)
	if db.burnresist then
		self:Message(L["burn_resist"]:format(player), "Positive", nil, nil, nil, 45141)
	end
end

function mod:Stomp(player, spellID)
	if db.stomp then
		self:Message(L["stomp_message"]:format(player), "Urgent", nil, nil, nil, spellID)
		self:DelayedMessage(25, L["stomp_warning"], "Attention")
		self:Bar(L["stomp_bar"], 30, spellID)
	end
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if self:ValidateEngageSync(sync, rest) and not started then
		started = true
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end
		if db.burn then
			self:Bar(L["burn_bar"], 20, 45141)
			self:DelayedMessage(15, L["burn_message"], "Attention")
		end
		if db.enrage then
			self:Enrage(360)
		end
	end
end
