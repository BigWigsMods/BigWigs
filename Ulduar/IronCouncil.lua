----------------------------------
--      Module Declaration      --
----------------------------------

local boss = BB["The Iron Council"]
local mod = BigWigs:New(boss, "$Revision$")
if not mod then return end
local breaker = BB["Steelbreaker"]
local molgeim = BB["Runemaster Molgeim"]
local brundir = BB["Stormcaller Brundir"]
mod.zonename = BZ["Ulduar"]
mod.enabletrigger = {breaker, molgeim, brundir, boss}
mod.guid = 32867
mod.toggleoptions = {61869, 63483, 61887, -1, 61903, 64637, -1, 62274, 61974, 62269, 62273, -1, "proximity", "icon", "berserk", "bosskill"}
mod.proximityCheck = "bandage"
mod.consoleCmd = "Council"

------------------------------
--      Are you local?      --
------------------------------

local db = nil
local previous = nil
local deaths = 0
local overwhelmTime = 35
local pName = UnitName("player")
local fmt = string.format

----------------------------
--      Localization      --
----------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

L:RegisterTranslations("enUS", function() return {
	engage_trigger1 = "You will not defeat the Assembly of Iron so easily, invaders!",
	engage_trigger2 = "Nothing short of total decimation will suffice.",
	engage_trigger3 = "Whether the world's greatest gnats or the world's greatest heroes, you are still only mortal.",

	overload_message = "Overload in 6sec!",
	death_message = "Rune of Death on YOU!",
	summoning_message = "Elementals Incoming!",

	tendrils_other = "%s is being chased!",
	tendrils_you = "YOU are being chased!",

	overwhelm_you = "You have Overwhelming Power!",
	overwhelm_other = "Overwhelming Power: %s",

	shield_message = "Rune shield!",

	icon = "Raid Target Icon",
	icon_desc = "Place a Raid Target Icon on the player targeted by Lightning Tendrils or Overwhelming Power (requires promoted or higher).",

	council_dies = "%s dead",
} end )
 
L:RegisterTranslations("koKR", function() return {
	engage_trigger1 = "무쇠 평의회가 그리 쉽게 무너질 것 같으냐, 침입자들아!",
	engage_trigger2 = "남김없이 쓸어버려야 속이 시원하겠군.",
	engage_trigger3 = "세상에서 가장 큰 모기건 세상에서 가장 위대한 영웅이건, 너흰 어차피 필멸의 존재야.",

	overload_message = "6초 후 과부하!",
	death_message = "당신은 죽음의 룬!",
	summoning_message = "소환의 룬 - 곧 정령 등장!",

	tendrils_other = "%s 추적 중!",
	tendrils_you = "당신을 추적 중!",

	overwhelm_you = "당신은 압도적인 힘!",
	overwhelm_other = "압도적인 힘: %s",

	shield_message = "룬의 보호막!",

	icon = "전술 표시",
	icon_desc = "추적 중인 플레이어에게 전술 표시를 지정합니다. (승급자 이상 권한 필요)",

	council_dies = "%s 죽음",
} end )

L:RegisterTranslations("frFR", function() return {
	engage_trigger1 = "Vous ne vaincrez pas si facilement l'assemblée du Fer, envahisseurs !",
	engage_trigger2 = "Seule votre extermination complète me conviendra.",
	engage_trigger3 = "Que vous soyez les plus grandes punaises ou les plus grands héros de ce monde, vous n'êtes jamais que des mortels.",

	overload_message = "Surcharge dans 6 sec. !",
	death_message = "Rune de mort sur VOUS !",
	summoning_message = "Arrivée des élémentaires !",

	tendrils_other = "%s est poursuivi(e) !",
	tendrils_you = "VOUS êtes poursuivi(e) !",

	overwhelm_you = "Puissance accablante sur VOUS !",
	overwhelm_other = "P. accablante : %s",

	shield_message = "Bouclier des runes !",

	icon = "Icône",
	icon_desc = "Place une icône de raid sur le dernier joueur affecté par une Puissance accablante ou ciblé par un Eclair tourbillonnant (nécessite d'être assistant ou mieux).",

	council_dies = "%s éliminé",
} end )

L:RegisterTranslations("deDE", function() return {
	engage_trigger1 = "So leicht werdet Ihr die Versammlung des Eisens nicht bezwingen, Eindringlinge!",
	engage_trigger2 = "Nur vollständige Dezimierung wird mich zufriedenstellen.",
	engage_trigger3 = "Selbst wenn Ihr die größten Helden der Welt seid, so seid Ihr doch nichts weiter als Sterbliche.",

	overload_message = "Überladen in 6 sek!",
	death_message = "Todesrune auf DIR!",
	summoning_message = "Elementare!",

	tendrils_other = "%s wird verfolgt!",
	tendrils_you = "DU wirst verfolgt!",

	overwhelm_you = "Überwältigende Kraft auf DIR!",
	overwhelm_other = "Überwältigende Kraft: %s!",

	shield_message = "Runenschild!",

	icon = "Schlachtzugs-Symbol",
	icon_desc = "Platziert ein Schlachtzugs-Symbol auf Spielern, die während der Blitzrankenphase verfolgt werden oder von Überwältigende Kraft betroffen sind (benötigt Assistent oder höher).",

	council_dies = "%s getötet!",
} end )

L:RegisterTranslations("zhCN", function() return {
--	engage_trigger1 = "You will not defeat the Assembly of Iron so easily, invaders!",
--	engage_trigger2 = "Nothing short of total decimation will suffice!",
--	engage_trigger3 = "Whether the world's greatest gnats or the world's greatest heroes, you're still only mortal!",

	overload_message = "6秒后，过载！",
	death_message = ">你< 死亡符文！",
	summoning_message = "闪电元素即将出现！",

	tendrils_other = "闪电之藤：>%s<！",
	tendrils_you = ">你< 闪电之藤！",

	overwhelm_you = ">你< 压倒能量！",
	overwhelm_other = "压倒能量：>%s<！",

	shield_message = "符文之盾！",

	icon = "团队标记",
	icon_desc = "为中了闪电之藤的队员打上团队标记。（需要权限）",

	council_dies = "%s被击败了！",
} end )

L:RegisterTranslations("zhTW", function() return {
	engage_trigger1 = "你們別妄想擊潰鐵之集會，入侵者!",
	engage_trigger2 = "只有全面屠殺才能滿足我。",
	engage_trigger3 = "不管你是世界第一流的小卒，或是首屈一指的英雄人物，充其量也不過是個凡人罷了。",

	overload_message = "6秒後，超載！",
	death_message = ">你< 死亡符文！",
	summoning_message = "閃電元素即將出現！",

	tendrils_other = "閃電觸鬚：>%s<！",
	tendrils_you = ">你< 閃電觸鬚！",

	overwhelm_you = ">你< 極限威能！",
	overwhelm_other = "極限威能：>%s<！",

	shield_message = "符文護盾！",

	icon = "團隊標記",
	icon_desc = "為中了閃電觸鬚的隊員打上團隊標記。（需要權限）",

	council_dies = "%s被擊敗了！",
} end )

L:RegisterTranslations("ruRU", function() return {
	engage_trigger1 = "Чужаки! Вам не одолеть Железное Собрание!",
	engage_trigger2 = "Я буду спокоен, лишь когда окончательно истреблю вас.",
	engage_trigger3 = "Кто бы вы ни были - жалкие бродяги или великие герои... Вы всего лишь смертные!",

	overload_message = "Взрыв через 6сек!",
	death_message = "На ВАС Руна СМЕРТИ!",
	summoning_message = "Руна призыва - приход Элементалей!",

	tendrils_other = "Преследует |3-3(%s)!",
	tendrils_you = "ВАС преследуют!",

	overwhelm_you = "На ВАС Переполняющая энергия!",
	overwhelm_other = "Переполняющая энергия на |3-5(%s)",

	shield_message = "Применён Рунический щит!",

	icon = "Помечать иконкой",
	icon_desc = "Помечать рейдовой иконкой игрока, которого преследует Светящиеся придатки или Переполняющая энергия (необходимо быть лидером группы или рейда).",

	council_dies = "%s умер",
} end )

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_CAST_START", "Punch", 61903, 63493) -- Steelbreaker
	self:AddCombatListener("SPELL_AURA_APPLIED", "Overwhelm", 64637, 61888) -- Steelbreaker +2
	self:AddCombatListener("SPELL_AURA_REMOVED", "OverRemove", 64637, 61888)

	self:AddCombatListener("SPELL_AURA_APPLIED", "Shield", 62274, 63489) -- Molgeim
	self:AddCombatListener("SPELL_CAST_SUCCESS", "RunePower", 61974) -- Molgeim
	self:AddCombatListener("SPELL_CAST_SUCCESS", "RuneDeathCD", 62269, 63490) -- Molgeim +1
	self:AddCombatListener("SPELL_AURA_APPLIED", "RuneDeath", 62269, 63490) -- Molgeim +1
	self:AddCombatListener("SPELL_CAST_START", "RuneSummoning", 62273) -- Molgeim +2

	self:AddCombatListener("SPELL_CAST_SUCCESS", "Overload", 61869, 63481) -- Brundir
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Whirl", 63483, 61915) -- Brundir +1
	self:AddCombatListener("SPELL_AURA_APPLIED", "Tendrils", 61887, 63486) -- Brundir +2

	self:AddCombatListener("UNIT_DIED", "Deaths")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	db = self.db.profile
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Punch(_, spellId, _, _, spellName)
	self:IfMessage(spellName, "Urgent", spellId)
end

function mod:Overwhelm(player, spellId)
	if player == pName then
		self:LocalMessage(L["overwhelm_you"], "Personal", spellId, "Alert")
		self:WideMessage(L["overwhelm_other"]:format(player))
		self:TriggerEvent("BigWigs_ShowProximity", self)
	else
		self:TargetMessage(L["overwhelm_other"], player, "Attention", spellId)
		self:Whisper(player, L["overwhelm_you"])
	end
	self:Bar(L["overwhelm_other"]:format(player), overwhelmTime, spellId)
	self:Icon(player, "icon")
end

function mod:OverRemove(player)
	if player == pName then
		self:TriggerEvent("BigWigs_HideProximity", self)
	end
	self:TriggerEvent("BigWigs_StopBar", self, L["overwhelm_other"]:format(player))
end

function mod:Shield(unit, spellId)
	if unit == molgeim then
		self:IfMessage(L["shield_message"], "Attention", spellId)
	end
end

function mod:RunePower(_, spellId, _, _, spellName)
	self:IfMessage(spellName, "Positive", spellId)
	self:Bar(spellName, 30, spellId)
end

function mod:RuneDeathCD(_, spellId, _, _, spellName)
	self:Bar(spellName, 30, spellId)
end

function mod:RuneDeath(player, spellId)
	if player == pName then
		self:LocalMessage(L["death_message"], "Personal", spellId, "Alarm")
	end
end

function mod:RuneSummoning(_, spellId)
	self:IfMessage(L["summoning_message"], "Attention", spellId)
end

function mod:Overload(_, spellId, _, _, spellName)
	self:IfMessage(L["overload_message"], "Attention", spellId, "Long")
	self:Bar(spellName, 6, spellId)
end

function mod:Whirl(_, spellId, _, _, spellName)
	self:IfMessage(spellName, "Attention", spellId)
end

local function targetCheck()
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
			if target == pName then
				mod:LocalMessage(L["tendrils_you"], "Personal", nil, "Alarm")
				mod:WideMessage(L["tendrils_other"]:format(target))
			else
				mod:TargetMessage(L["tendrils_other"], target, "Attention")
				mod:Whisper(player, L["tendrils_you"])
			end
			mod:Icon(target, "icon")
			previous = target
		else
			previous = nil
		end
	end
end

local function tendrilsRemove()
	mod:CancelScheduledEvent("BWTendrilsToTScan")
	mod:TriggerEvent("BigWigs_RemoveRaidIcon")
end

function mod:Tendrils(_, spellId, _, _, spellName)
	self:IfMessage(spellName, "Attention", spellId)
	self:Bar(spellName, 25, spellId)
	self:ScheduleRepeatingEvent("BWTendrilsToTScan", targetCheck, 0.2)
	self:ScheduleEvent("TargetCancel", tendrilsRemove, 25)
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
		self:BossDeath(nil, self.guid)
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg:find(L["engage_trigger1"]) or msg:find(L["engage_trigger2"]) or msg:find(L["engage_trigger3"]) then
		previous = nil
		deaths = 0
		overwhelmTime = GetRaidDifficulty() == 1 and 60 or 35
		if db.berserk then
			self:Enrage(900, true)
		end
	end
end

