----------------------------------
--      Module Declaration      --
----------------------------------

local breaker = BB["Steelbreaker"]
local molgeim = BB["Runemaster Molgeim"]
local brundir = BB["Stormcaller Brundir"]
local boss = BB["The Iron Council"]
local mod = BigWigs:New(boss, "$Revision$")
if not mod then return end
mod.zonename = BZ["Ulduar"]
mod.enabletrigger = {breaker, molgeim, brundir, boss}
mod.guid = 32867
mod.toggleoptions = {"chain", "overload", "power", -1, "death", "summoning", "tendrils", -1, "icon", "berserk", "bosskill"}

------------------------------
--      Are you local?      --
------------------------------

local db = nil
local started = nil
local previous = nil
local deaths = 0
local pName = UnitName("player")
local fmt = string.format

----------------------------
--      Localization      --
----------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

L:RegisterTranslations("enUS", function() return {
	cmd = "IronCouncil",

	chain = "Chain Lightning",
	chain_desc = "Warn when Brundir casts a Chain Lightning.",
	chain_message = "Chain Lightning!",

	overload = "Overload",
	overload_desc = "Warn when Brundir casts a Overload.",
	overload_message = "Explosion in 10sec!",

	power = "Rune of Power",
	power_desc = "Warn when Molgeim a Rune of Power.",
	power_message = "Rune of Power!",

	death = "Rune of Death on You",
	death_desc = "Warn when you are in a Rune of Death.",
	death_message = "Rune of Death on YOU!",

	summoning = "Rune of Summoning",
	summoning_desc = "Warn when molgeim casts a Rune of Summoning.",
	summoning_message = "Rune of Summoning - Elementals Inc!",

	tendrils = "Lightning Tendrils",
	tendrils_desc = "Warn who he targets during the Lightning Tendrils phase, and put a raid icon on them.",
	tendrils_other = "%s being chased!",
	tendrils_you = "YOU are being chased!",
	tendrils_message = "Landing in ~5sec!",

	icon = "Raid Target Icon",
	icon_desc = "Place a Raid Target Icon on the player being chased(requires promoted or higher).",

	council_dies = "%s dead",

	log = "|cffff0000"..boss.."|r: This boss needs data, please consider turning on your /combatlog or transcriptor and submit the logs.",
} end )
 
L:RegisterTranslations("koKR", function() return {
	chain = "연쇄 번개",
	chain_desc = "브룬디르의 연쇄 번개 시전을 알립니다.",
	chain_message = "연쇄 번개!",

	overload = "과부하",
	overload_desc = "브룬디르의 과부하 시전을 알립니다.",
	overload_message = "10초 후 폭발!",

	power = "마력의 룬",
	power_desc = "몰가임의 마력의 룬을 알립니다.",
	power_message = "마력의 룬 생성!",

	death = "자신의 죽음의 룬",
	death_desc = "자신이 죽음의 룬에 걸렸을 때 알립니다.",
	death_message = "당신은 죽음의 룬!",

	summoning = "소환의 룬",
	summoning_desc = "몰가임의 소환의 룬 시전을 알립니다.",
	summoning_message = "소환의 룬 - 곧 정령 등장!",

	tendrils = "번개 덩굴",
	tendrils_desc = "번개 덩굴 단계에서 대상을 알리고 전술 표시를 지정합니다.",
	tendrils_other = "%s 추적 중!",
	tendrils_you = "당신을 추적 중!",
	tendrils_message = "약 5초 후 착지!",

	icon = "전술 표시",
	icon_desc = "추적 중인 플레이어에게 전술 표시를 지정합니다. (승급자 이상 권한 필요)",

	council_dies = "%s 죽음",

	log = "|cffff0000"..boss.."|r: 해당 보스의 데이터가 필요합니다. 채팅창에 /전투기록 , /대화기록 을 입력하여 기록된 데이터나 transcriptor로 저장된 데이터 보내주시기 바랍니다.",
} end )

L:RegisterTranslations("frFR", function() return {
	chain = "Chaîne d'éclairs",
	chain_desc = "Prévient quand Brundir incante une Chaîne d'éclairs.",
	chain_message = "Chaîne d'éclairs !",

	overload = "Surcharge",
	overload_desc = "Prévient quand Brundir incante une Surcharge.",
	overload_message = "Explosion dans 10 sec. !",

	power = "Rune de puissance",
	power_desc = "Prévient quand Molgeim incante une Rune de puissance.",
	power_message = "Rune de puissance !",

	death = "Rune de mort sur vous",
	death_desc = "Prévient quand vous vous trouvez  sur une Rune de mort.",
	death_message = "Rune de puissance sur VOUS !",

	summoning = "Rune d'invocation",
	summoning_desc = "Prévient quand Molgeim incante une Rune d'invocation.",
	summoning_message = "Rune d'invocation - Arrivée d'élémentaires !",

	tendrils = "Vrilles d'éclair",
	tendrils_desc = "Indique qui est poursuivi pendant la phase de Vrille d'éclair.",
	tendrils_other = "%s est poursuivi(e) !",
	tendrils_you = "VOUS êtes poursuivi(e) !",
	tendrils_message = "Atterrissage dans ~5 sec. !",

	icon = "Icône",
	icon_desc = "Place une icône de raid sur le dernier joueur poursuivi (nécessite d'être assistant ou mieux).",

	council_dies = "%s éliminé",

	log = "|cffff0000"..boss.."|r : ce boss a besoin de données, merci d'activer votre /combatlog ou Transcriptor et de nous transmettre les logs.",
} end )

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_CAST_START", "Chain", 61879, 63479)
	self:AddCombatListener("SPELL_CAST_START", "Overload", 61869, 63481)
	self:AddCombatListener("SPELL_CAST_START", "Power", 61974)
	self:AddCombatListener("SPELL_CAST_START", "Summoning", 62273)	-- Molgeim abiltities plus(2 dead)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Tendrils", 61886, 63485)	-- Brundir abiltities plus(2 dead)
	self:AddCombatListener("SPELL_AURA_APPLIED", "RuneDeath", 62269, 63490)	-- Molgeim abiltities plus(1 dead)
	self:AddCombatListener("UNIT_DIED", "Deaths")

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("BigWigs_RecvSync")

	started = nil
	previous = nil
	deaths = 0
	db = self.db.profile

	BigWigs:Print(L["log"])
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Chain(_, spellID)
	if db.chain then
		self:IfMessage(L["chain_message"], "Attention", spellID)
	end
end

function mod:Overload(_, spellID)
	if db.overload then
		self:IfMessage(L["overload_message"], "Attention", spellID)
		self:Bar(L["overload"], 10, spellID)
	end
end

function mod:Power(_, spellID)
	if db.power then
		self:IfMessage(L["power_message"], "Positive", spellID)
	end
end

function mod:RuneDeath(player)
	if player == pName and db.death then
		self:LocalMessage(L["death_message"], "Personal", 63490, "Alarm")
	end
end

function mod:Summoning()
	if db.summoning then
		self:IfMessage(L["summoning_message"], "Attention", spellID)
	end
end

function mod:Tendrils(_, spellID)
	if db.tendrils then
		self:IfMessage(L["tendrils"], "Attention", spellID)
		self:Bar(L["tendrils"], 35, spellID)
		self:DelayedMessage(30, L["tendrils_message"], "Attention")
		self:ScheduleRepeatingEvent("BWTendrilsToTScan", self.TargetCheck, 0.2, self)
		self:ScheduleEvent("TargetCancel", self.TendrilsRemove, 35, self)
	end
end

function mod:TendrilsRemove()
	if db.tendrils then
		self:CancelScheduledEvent("BWTendrilsToTScan")
		self:TriggerEvent("BigWigs_RemoveRaidIcon")
	end
end

function mod:TargetCheck()
	local target
	if UnitName("target") == brundir then
		target = UnitName("targettarget")
	elseif UnitName("focus") == brundir then
		target = UnitName("focustarget")
	else
		local num = GetNumRaidMembers()
		for i = 1, num do
			if UnitName(fmt("%s%d%s", "raid", i, "target")) == brundir then
				target = UnitName(fmt("%s%d%s", "raid", i, "targettarget"))
				break
			end
		end
	end
	if target ~= previous then
		if target then
			local other = fmt(L["tendrils_other"], target)
			if target == pName then
				self:LocalMessage(L["tendrils_you"], "Personal", nil, "Alarm")
				self:WideMessage(other)
			else
				self:Message(other, "Attention")
			end
			self:Icon(target, "icon")
			previous = target
		else
			previous = nil
		end
	end
end

function mod:Deaths(unit, guid)
	guid = tonumber((guid):sub(-12,-7),16)
	if guid == self.guid or guid == 32927 or guid == 32857 then
		deaths = deaths + 1
		if deaths < 3 then
			self:IfMessage(L["council_dies"]:format(unit), "Positive")
		end
	end
	if deaths == 3 then
		self:BossDeath(nil, self.guid, true)
	end
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if self:ValidateEngageSync(sync, rest) and not started then
		started = true
		deaths = 0
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then 
			self:UnregisterEvent("PLAYER_REGEN_DISABLED") 
		end
		if db.berserk then
			self:Enrage(600, true)
		end
	end
end
