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
mod.toggleoptions = {"chain", "overload", "whirl", "tendrils", -1, "punch", "overwhelm", -1, "shield", "power", "death", "summoning", -1, "icon", "berserk", "bosskill"}
local bandages = {
	[34722] = true, -- Heavy Frostweave Bandage
	[34721] = true, -- Frostweave Bandage
	[21991] = true, -- Heavy Netherweave Bandage
	[21990] = true, -- Netherweave Bandage
	[14530] = true, -- Heavy Runecloth Bandage
	[14529] = true, -- Runecloth Bandage
	[8545] = true, -- Heavy Mageweave Bandage
	[8544] = true, -- Mageweave Bandage
	[6451] = true, -- Heavy Silk Bandage
	[6450] = true, -- Silk Bandage
	[3531] = true, -- Heavy Wool Bandage
	[3530] = true, -- Wool Bandage
	[2581] = true, -- Heavy Linen Bandage
	[1251] = true, -- Linen Bandage
}
mod.proximityCheck = function( unit )
	for k, v in pairs( bandages ) do
		if IsItemInRange( k, unit) == 1 then
			return true
		end
	end
	return false
end

------------------------------
--      Are you local?      --
------------------------------

local db = nil
local previous = nil
local deaths = 0
local overwhelmTime = 25
local pName = UnitName("player")
local fmt = string.format

----------------------------
--      Localization      --
----------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

L:RegisterTranslations("enUS", function() return {
	cmd = "IronCouncil",

	engage_trigger1 = "You will not defeat the Assembly of Iron so easily, invaders!",
	engage_trigger2 = "Nothing short of total decimation will suffice!",
	engage_trigger3 = "Whether the world's greatest gnats or the world's greatest heroes, you're still only mortal!",

	chain = "Chain Lightning",
	chain_desc = "Warn when Brundir casts a Chain Lightning.",
	chain_message = "Chain Lightning!",

	overload = "Overload",
	overload_desc = "Warn when Brundir casts a Overload.",
	overload_message = "Overload Explosion in 6sec!",

	power = "Rune of Power",
	power_desc = "Warn when Molgeim casts Rune of Power.",
	power_message = "Rune of Power!",

	punch = "Fusion Punch",
	punch_desc = "Warn when Steelbreaker casts a Fusion Punch.",
	punch_message = "Fusion Punch!",

	death = "Rune of Death on You",
	death_desc = "Warn when you are in a Rune of Death.",
	death_message = "Rune of Death on YOU!",

	summoning = "Rune of Summoning",
	summoning_desc = "Warn when Molgeim casts a Rune of Summoning.",
	summoning_message = "Rune of Summoning - Elementals Incoming!",

	tendrils = "Lightning Tendrils",
	tendrils_desc = "Warn who is targeted during Lightning Tendrils.",
	tendrils_other = "%s is being chased!",
	tendrils_you = "YOU are being chased!",
	tendrils_message = "Landing in ~5sec!",

	overwhelm = "Overwhelming Power",
	overwhelm_desc = "Warn when a player has Overwhelming Power.",
	overwhelm_you = "You have Overwhelming Power!",
	overwhelm_other = "Overwhelming Power: %s",

	whirl = "Lightning Whirl",
	whirl_desc = "Warn when Brundir starts channeling Lightning Whirl.",
	whirl_message = "Lightning Whirl!",

	shield = "Shield of Runes",
	shield_desc = "Warn when Molgeim casts Shield of Runes.",
	shield_message = "Shield of Runes Up!",

	icon = "Raid Target Icon",
	icon_desc = "Place a Raid Target Icon on the player targeted by Lightning Tendrils or Overwhelming Power (requires promoted or higher).",

	council_dies = "%s dead",
} end )
 
L:RegisterTranslations("koKR", function() return {
	engage_trigger1 = "무쇠 평의회가 그리 쉽게 무너질 거 같으냐, 침입자들아!",	--check
	engage_trigger2 = "남김없이 쓸어 버려야 속이 시원하겠군!",	--check
	engage_trigger3 = "세상에서 가장 큰 무기건 세상에서 가장 위대한 영웅이건, 너희는 어차피 필멸의 존재야!",	--check

	chain = "연쇄 번개",
	chain_desc = "브룬디르의 연쇄 번개 시전을 알립니다.",
	chain_message = "연쇄 번개!",

	overload = "과부하",
	overload_desc = "브룬디르의 과부하 시전을 알립니다.",
	overload_message = "6초 후 폭발!",

	power = "마력의 룬",
	power_desc = "몰가임의 마력의 룬을 알립니다.",
	power_message = "마력의 룬 생성!",

	punch = "융해의 주먹",
	punch_desc = "융해의 주먹 시전을 알립니다.",
	punch_message = "융해의 주먹 시전!",

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

	overwhelm = "압도적인 힘",
	overwhelm_desc = "압도적인 힘에 걸린 플레이어를 알립니다.",
	overwhelm_you = "당신은 압도적인 힘!",
	overwhelm_other = "압도적인 힘: %s",
	
	whirl = "번개 소용돌이",
	whirl_desc = "브룬디르의 번개 소용돌이 시작을 알립니다.",
	whirl_message = "번개 소용돌이!",

	shield = "룬의 보호막",
	shield_desc = "몰가임의 룬의 보호막 시전을 알립니다.",
	shield_message = "룬의 보호막!",

	icon = "전술 표시",
	icon_desc = "추적 중인 플레이어에게 전술 표시를 지정합니다. (승급자 이상 권한 필요)",

	council_dies = "%s 죽음",
} end )

L:RegisterTranslations("frFR", function() return {
	engage_trigger1 = "Vous ne vaincrez pas si facilement l'assemblée du Fer, envahisseurs !",
	engage_trigger2 = "Seule votre extermination complète me conviendra.",
	engage_trigger3 = "Que vous soyez les plus grandes punaises ou les plus grands héros de ce monde, vous n'êtes jamais que des mortels.",

	chain = "Chaîne d'éclairs",
	chain_desc = "Prévient quand Brundir incante une Chaîne d'éclairs.",
	chain_message = "Chaîne d'éclairs !",

	overload = "Surcharge",
	overload_desc = "Prévient quand Brundir incante une Surcharge.",
	overload_message = "Explosion de la Surcharge dans 6 sec. !",

	power = "Rune de puissance",
	power_desc = "Prévient quand Molgeim incante une Rune de puissance.",
	power_message = "Rune de puissance !",

	punch = "Coup de poing fusion",
	punch_desc = "Prévient quand Brise-acier incante un Coup de poing fusion.",
	punch_message = "Coup de poing fusion !",

	death = "Rune de mort sur vous",
	death_desc = "Prévient quand vous vous trouvez sur une Rune de mort.",
	death_message = "Rune de puissance sur VOUS !",

	summoning = "Rune d'invocation",
	summoning_desc = "Prévient quand Molgeim incante une Rune d'invocation.",
	summoning_message = "Rune d'invocation - Arrivée d'élémentaires !",

	tendrils = "Vrilles d'éclair",
	tendrils_desc = "Indique qui est poursuivi pendant la phase de Vrille d'éclair.",
	tendrils_other = "%s est poursuivi(e) !",
	tendrils_you = "VOUS êtes poursuivi(e) !",
	tendrils_message = "Atterrissage dans ~5 sec. !",

	overwhelm = "Puissance accablante",
	overwhelm_desc = "Prévient quand un joueur subit les effets d'une Puissance accablante.",
	overwhelm_you = "Puissance accablante sur VOUS !",
	overwhelm_other = "Puissance accablante : %s",

	whirl = "Eclair tourbillonnant",
	whirl_desc = "Prévient quand Brundir commence à canaliser un Eclair tourbillonnant.",
	whirl_message = "Eclair tourbillonnant !",

	shield = "Bouclier des runes",
	shield_desc = "Prévient quand Molgeim incante un Bouclier des runes.",
	shield_message = "Bouclier des runes actif !",

	icon = "Icône",
	icon_desc = "Place une icône de raid sur le dernier joueur poursuivi (nécessite d'être assistant ou mieux).",

	council_dies = "%s éliminé",
} end )

L:RegisterTranslations("deDE", function() return {
	--engage_trigger1 = "You will not defeat the Assembly of Iron so easily, invaders!", --NEED!
	--engage_trigger2 = "Nothing short of total decimation will suffice!", --NEED!
	--engage_trigger3 = "Whether the world's greatest gnats or the world's greatest heroes, you're still only mortal!", --NEED!

	chain = "Kettenblitz",
	chain_desc = "Warnt, wenn Brundir Kettenblitz wirkt.",
	chain_message = "Kettenblitz!",

	overload = "Überladen",
	overload_desc = "Warnt, wenn Brundir Überladen wirkt.",
	overload_message = "Überladen Explosion in 6 sek!",

	power = "Rune der Kraft",
	power_desc = "Warnt, wenn Molgeim Rune der Kraft wirkt.",
	power_message = "Rune der Kraft!",

	punch = "Fusionshaken",
	punch_desc = "Warnt, wenn Stahlbrecher Fusionshaken wirkt.",
	punch_message = "Fusionshaken!",

	death = "Rune des Todes",
	death_desc = "Warnt, wenn du in einer Rune des Todes stehst.",
	death_message = "Rune des Todes auf DIR!",

	summoning = "Rune der Beschwörung",
	summoning_desc = "Warnt, wenn Molgeim Rune der Beschwörung wirkt.",
	summoning_message = "Rune der Beschwörung - Elementare!",

	tendrils = "Blitzranken",
	tendrils_desc = "Warnt, wer das Ziel während der Blitzrankenphase ist.",
	tendrils_other = "%s wird verfolgt!",
	tendrils_you = "DU wirst verfolgt!",
	tendrils_message = "Landet in ~5 sek!",

	overwhelm = "Überwältigende Kraft",
	overwhelm_desc = "Warnt, wenn ein Spieler von Überwältigende Kraft betroffen ist.",
	overwhelm_you = "DU hast Überwältigende Kraft!",
	overwhelm_other = "Überwältigende Kraft: %s!",

	whirl = "Blitzwirbel",
	whirl_desc = "Warnt, wenn Brundir beginnt, Blitzwirbel zu kanalisieren.",
	whirl_message = "Blitzwirbel!",

	shield = "Runenschild",
	shield_desc = "Warnt, wenn Molgeim Runenschild wirkt.",
	shield_message = "Runenschild!",

	icon = "Schlachtzugs-Symbol",
	icon_desc = "Platziert ein Schlachtzugs-Symbol auf Spielern, die während der Blitzrankenphase verfolgt werden oder von Überwältigende Kraft betroffen sind (benötigt Assistent oder höher).",

	council_dies = "%s stirbt", --needs verification!
} end )

L:RegisterTranslations("zhCN", function() return {
--[[
	engage_trigger1 = "You will not defeat the Assembly of Iron so easily, invaders!",
	engage_trigger2 = "Nothing short of total decimation will suffice!",
	engage_trigger3 = "Whether the world's greatest gnats or the world's greatest heroes, you're still only mortal!",

	chain = "闪电链",
	chain_desc = "当布隆迪尔施放闪电链时发出警报。",
	chain_message = "闪电链！",

	overload = "过载",
	overload_desc = "当布隆迪尔施放过载时发出警报。",
	overload_message = "10秒后，爆炸！",

	power = "能量符文",
	power_desc = "当莫尔基姆施放能量符文时发出警报。",
	power_message = "能量符文！",

	death = "自身死亡符文",
	death_desc = "当你中了死亡符文时发出警报。",
	death_message = ">你< 死亡符文！",

	summoning = "召唤符文",
	summoning_desc = "当莫尔基姆施放召唤符文时发出警报。",
	summoning_message = "召唤符文 - 闪电元素即将出现！",

	tendrils = "闪电之藤",
	tendrils_desc = "当闪电之藤阶段时为目标玩家发出警报，并给他打上团队标记。",
	tendrils_other = "闪电之藤：>%s<！",
	tendrils_you = ">你< 闪电之藤！",
	tendrils_message = "约5秒后，降落！",

	overwhelm = "Overwhelming Power",
	overwhelm_desc = "当玩家中了Overwhelming Power时发出警报。",
	overwhelm_you = ">你< Overwhelming Power！",
	overwhelm_other = "Overwhelming Power：>%s<！",

	icon = "团队标记",
	icon_desc = "为中了闪电之藤的队员打上团队标记。（需要权限）",

	council_dies = "%s被击败了！",
]]
} end )

L:RegisterTranslations("zhTW", function() return {
--	engage_trigger1 = "You will not defeat the Assembly of Iron so easily, invaders!",
--	engage_trigger2 = "Nothing short of total decimation will suffice!",
--	engage_trigger3 = "Whether the world's greatest gnats or the world's greatest heroes, you're still only mortal!",

	chain = "閃電鏈",
	chain_desc = "當布倫迪爾施放閃電鏈時發出警報。",
	chain_message = "閃電鏈！",

	overload = "超載",
	overload_desc = "當布倫迪爾施放超載時發出警報。",
	overload_message = "10秒后，爆炸！",

	power = "力之符文",
	power_desc = "當墨吉姆施放力之符文時發出警報。",
	power_message = "力之符文！",

	death = "自身死亡符文",
	death_desc = "當你中了死亡符文時發出警報。",
	death_message = ">你< 死亡符文！",

	summoning = "召喚符文",
	summoning_desc = "當墨吉姆施放召喚符文時發出警報。",
	summoning_message = "召喚符文 - 閃電元素即將出現！",

	tendrils = "閃電觸鬚",
	tendrils_desc = "當閃電觸鬚階段時為目標玩家發出警報，并給他打上團隊標記。",
	tendrils_other = "閃電觸須：>%s<！",
	tendrils_you = ">你< 閃電觸須！",
	tendrils_message = "約5秒后，降落！",

	overwhelm = "極限威能",
	overwhelm_desc = "當玩家中了極限威能時發出警報。",
	overwhelm_you = ">你< 極限威能！",
	overwhelm_other = "極限威能：>%s<！",

	icon = "團隊標記",
	icon_desc = "為中了閃電觸須的隊員打上團隊標記。（需要權限）",

	council_dies = "%s被擊敗了！",
} end )

L:RegisterTranslations("ruRU", function() return {
--	engage_trigger1 = "You will not defeat the Assembly of Iron so easily, invaders!",
--	engage_trigger2 = "Nothing short of total decimation will suffice!",
--	engage_trigger3 = "Whether the world's greatest gnats or the world's greatest heroes, you're still only mortal!",

	chain = "Цепная молния",
	chain_desc = "Сообщает когда Брундир применяет Цепную молнию.",
	chain_message = "Цепная молния!",

	overload = "Перегрузка",
	overload_desc = "Сообщает когда Брундир применяет Перегрузку.",
	overload_message = "Взрыв через 6сек!",

	power = "Руна мощи",
	power_desc = "Сообщает когда Молгейм применяет Руну мощи.",
	power_message = "Руна мощи!",

	punch = "Энергетический удар",
	punch_desc = "Сообщает когда Сталелом применяет Энергетический удар.",
	punch_message = "Применяется Энергетический удар!",

	death = "Руна смерти на ВАС",
	death_desc = "Сообщает когда вы поподаете под воздействие Руны смерти.",
	death_message = "На ВАС Руна СМЕРТИ!",

	summoning = "Руна призыва",
	summoning_desc = "Сообщает когда Молгейм применяет Руну призыва.",
	summoning_message = "Руна призыва - приход Элементалей!",

	tendrils = "Светящиеся придатки",
	tendrils_desc = "Сообщает кого приследуют светящиеся придатки, и помещает на него иконку.",
	tendrils_other = "Приследуют |3-1(%s)!",
	tendrils_you = "ВАС приследуют!",
	tendrils_message = "Выгрузка через ~5сек!",

	overwhelm = "Переполняющая энергия",
	overwhelm_desc = "Сообщает когда игрок подвергается воздействию Переполняющей энергии.",
	overwhelm_you = "На ВАС Переполняющая энергия!",
	overwhelm_other = "Переполняющая энергия на |3-5(%s)",

	icon = "Помечать иконкой",
	icon_desc = "Помечать рейдовой иконкой игрока, being chased(необходимо быть лидером группы или рейда).",

	council_dies = "%s умер",
} end )

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_CAST_START", "Punch", 61903, 63493) -- Steelbreaker
	self:AddCombatListener("SPELL_AURA_APPLIED", "Overwhelm", 64637, 61888) -- Steelbreaker +2

	self:AddCombatListener("SPELL_AURA_APPLIED", "Shield", 62274, 63489) -- Molgeim
	self:AddCombatListener("SPELL_CAST_START", "RunePower", 61973) -- Molgeim ... hmm, catch on cast start or success? SPELL_CAST_SUCCESS 61974
	self:AddCombatListener("SPELL_AURA_APPLIED", "RuneDeath", 62269, 63490) -- Molgeim +1
	self:AddCombatListener("SPELL_CAST_START", "RuneSummoning", 62273) -- Molgeim +2

	self:AddCombatListener("SPELL_CAST_START", "Chain", 61879, 63479) -- Brundir 
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Overload", 61869) -- Brundir
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Whirl", 63483, 61915) -- Brundir +1
	self:AddCombatListener("SPELL_AURA_APPLIED", "Tendrils", 61887, 63486) -- Brundir +2

	self:AddCombatListener("UNIT_DIED", "Deaths")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

	started = nil
	previous = nil
	deaths = 0
	db = self.db.profile
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Punch(_, spellID)
	if db.punch then
		self:IfMessage(L["punch_message"], "Urgent", spellID)
	end
end

function mod:Overwhelm(player, spellID)
	if db.overwhelm then
		local other = L["overwhelm_other"]:format(player)
		if player == pName then
			self:Message(L["overwhelm_you"], "Personal", true, "Alert", nil, spellID)
			self:Message(other, "Attention", nil, nil, true)
			self:TriggerEvent("BigWigs_ShowProximity", self)
		else
			self:Message(other, "Attention", nil, nil, nil, spellID)
			self:Whisper(player, L["overwhelm_you"])
		end
		self:Bar(other, overwhelmTime, spellID)
		self:Icon(player, "icon")
	end
end

function mod:Shield(_, spellID)
	if db.shield then
		self:IfMessage(L["shield_message"], "Attention", spellID)
	end
end

function mod:RunePower(_, spellID)
	if db.power then
		self:IfMessage(L["power_message"], "Positive", spellID)
	end
end

function mod:RuneDeath(player)
	if player == pName and db.death then
		self:LocalMessage(L["death_message"], "Personal", 63490, "Alarm")
	end
end

function mod:RuneSummoning()
	if db.summoning then
		self:IfMessage(L["summoning_message"], "Attention", spellID)
	end
end

function mod:Chain(_, spellID)
	if db.chain then
		self:IfMessage(L["chain_message"], "Attention", spellID)
	end
end

function mod:Overload(_, spellID)
	if db.overload then
		self:IfMessage(L["overload_message"], "Attention", spellID)
		self:Bar(L["overload"], 6, spellID)
	end
end

function mod:Whirl(_, spellID)
	if db.whirl then
		self:IfMessage(L["whirl_message"], "Attention", spellID)
	end
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
			local other = fmt(L["tendrils_other"], target)
			if target == pName then
				mod:LocalMessage(L["tendrils_you"], "Personal", nil, "Alarm")
				mod:WideMessage(other)
			else
				mod:Message(other, "Attention")
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

function mod:Tendrils(_, spellID)
	if db.tendrils then
		self:IfMessage(L["tendrils"], "Attention", spellID)
		self:Bar(L["tendrils"], 25, spellID)
		self:DelayedMessage(20, L["tendrils_message"], "Info")
		self:ScheduleRepeatingEvent("BWTendrilsToTScan", targetCheck, 0.2)
		self:ScheduleEvent("TargetCancel", tendrilsRemove, 25)
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

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg:find(L["engage_trigger1"]) or msg:find(L["engage_trigger2"]) or msg:find(L["engage_trigger3"]) then
		deaths = 0
		overwhelmTime = GetCurrentDungeonDifficulty() == 1 and 60 or 25
		if db.berserk then
			self:Enrage(600, true)
		end
	end
end

