------------------------------
--      Are you local?      --
------------------------------

local boss = BB["Anetheron"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local db = nil
local fmt = string.format

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Anetheron",

	engage_trigger = "You are defenders of a doomed world! Flee here, and perhaps you will prolong your pathetic lives!",

	inferno = "Inferno",
	inferno_desc = "Approximate Inferno cooldown timers.",
	inferno_message = "Casting Inferno on %s!",
	inferno_you = "Casting Inferno on YOU!",
	inferno_warning = "Inferno Soon!",
	inferno_bar = "~Inferno Cooldown",

	icon = "Raid Target Icon",
	icon_desc = "Place a Raid Target Icon on the player that Inferno is being cast on(requires promoted or higher).",

	swarm = "Carrion Swarm",
	swarm_desc = "Approximate Carrion Swarm cooldown timers.",
	swarm_message = "Swarm! - Next in ~11sec",
	swarm_bar = "~Swarm Cooldown",
} end )

L:RegisterTranslations("esES", function() return {
	engage_trigger = "¡Sois defensores de un mundo condenado! ¡Huid y quizá prolonguéis vuestras patéticas vidas!",

	inferno = "Averno (Inferno)",
	inferno_desc = "Contadores aproximados de Averno.",
	inferno_message = "¡Lanzando Averno en %s!",
	inferno_you = "¡Lanzando Averno en TI!",
	inferno_warning = "Averno en breve",
	inferno_bar = "~Averno",

	icon = "Icono de banda",
	icon_desc = "Poner un icono de banda sobre los jugadores que reciben Averno. (Requiere derechos de banda)",

	swarm = "Enjambre de carroña (Carrion Swarm)",
	swarm_desc = "Contadores aproximados para Enjambre de carroña.",
	swarm_message = "¡Enjambre! - Sig. en ~11sec",
	swarm_bar = "~Enjambre",
} end )

L:RegisterTranslations("frFR", function() return {
	engage_trigger = "Vous défendez un monde condamné ! Fuyez si vous voulez avoir une chance de faire durer vos vies pathétiques !",

	inferno = "Inferno",
	inferno_desc = "Temps de recharge approximatif pour l'Inferno.",
	inferno_message = "Incante un inferno sur %s !",
	inferno_you = "Incante un inferno sur VOUS !",
	inferno_warning = "Inferno imminent !",
	inferno_bar = "~Recharge Inferno",

	icon = "Icône",
	icon_desc = "Place une icône de raid sur le dernier joueur sur qui un inferno est incanté (nécessite d'être promu ou mieux).",

	swarm = "Vol de charognards",
	swarm_desc = "Temps de recharge approximatif pour le Vol de charognards.",
	swarm_message = "Essaim ! - Prochain dans ~11 sec.",
	swarm_bar = "~Recharge Essaim",
} end )

L:RegisterTranslations("koKR", function() return {
	engage_trigger = "멸망에 처한 세계의 수호자들이여, 구차한 목숨이라도 건지려면 어서 달아나라!",

	inferno = "불지옥",
	inferno_desc = "대략적인 불지옥 대기시간 타이머입니다.",
	inferno_message = "%s에게 불지옥 시전 중!",
	inferno_you = "당신에게 불지옥 시전 중!",
	inferno_warning = "잠시 후 불지옥!",
	inferno_bar = "~불지옥 대기시간",

	icon = "전술 표시",
	icon_desc = "불지옥의 시전 대상의 플레이어에게 전술 표시를 지정합니다. (승급자 이상 권한 요구)",

	swarm = "흡혈박쥐 떼",
	swarm_desc = "대략적인 흡혈박쥐 떼 대기시간 타이머입니다.",
	swarm_message = "박쥐 떼! - 다음은 약 11초 이내",
	swarm_bar = "~박쥐 떼 대기시간",
} end )

L:RegisterTranslations("deDE", function() return {
	engage_trigger = "Ihr verteidigt eine verlorene Welt! Flieht! Vielleicht verlängert dies Euer erbärmliches Leben!",

	inferno = "Inferno",
	inferno_desc = "Geschätzter Inferno Cooldown Timer.",
	inferno_message = "zaubert Inferno auf %s!",
	inferno_you = "Zaubert Inferno auf DICH!",
	inferno_warning = "Inferno bald!",
	inferno_bar = "~Inferno Cooldown",

	icon = "Schlachtzug Symbol",
	icon_desc = "Plaziere ein Schlachtzug Symbol auf Spielern die von Inferno betroffen sind (benötigt Assistent oder höher).",

	swarm = "Aasschwarm",
	swarm_desc = "Geschätzter Aasschwarm Cooldown Timer.",
	swarm_message = "Aasschwarm! - Nächster in ~11sec",
	swarm_bar = "~Aasschwarm Cooldown",
} end )

L:RegisterTranslations("zhTW", function() return {
	engage_trigger = "你們要守護的世界躲不了毀滅的命運!逃離這兒，也許可以延長你們那可悲的生命!",

	inferno = "地獄火",
	inferno_desc = "地獄火冷卻計時器",
	inferno_message = "地獄火: [%s]",
	inferno_you = "你中了地獄火!",
	inferno_warning = "地獄火即將到來!",
	inferno_bar = "<地獄火冷卻>",

	icon = "團隊標記",
	icon_desc = "在受到地獄火的隊友頭上標記 (需要權限)",

	swarm = "腐肉成群",
	swarm_desc = "腐肉成群冷卻計時器",
	swarm_message = "腐肉成群! - 11 秒後下一次",
	swarm_bar = "<腐肉成群冷卻>",
} end )

L:RegisterTranslations("zhCN", function() return {
	engage_trigger = "你们在守护一个注定要毁灭的世界！逃跑吧，那样也许你们还能多活几天！",

	inferno = "地狱火",
	inferno_desc = "显示地狱火冷却记时条。",
	inferno_message = "地狱火：>%s<！",
	inferno_you = ">你< 地狱火！",
	inferno_warning = "即将 地狱火！",
	inferno_bar = "<地狱火 冷却>",

	icon = "团队标记",
	icon_desc = "为在玩家上施放地狱火的玩家打上团队标记。（需要权限）",

	swarm = "腐臭虫群",
	swarm_desc = "腐臭虫群冷却计时。",
	swarm_message = "腐臭虫群！ 约11秒后下一波。",
	swarm_bar = "<虫群 冷却>",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = BZ["Hyjal Summit"]
mod.enabletrigger = boss
mod.guid = 17808
mod.toggleoptions = {"inferno", "icon", "swarm", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Swarm", 31306)
	self:AddCombatListener("SPELL_CAST_START", "Inferno", 31299)
	self:AddCombatListener("UNIT_DIED", "BossDeath")

	db = self.db.profile
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Swarm(_, spellID)
	if db.swarm then
		self:IfMessage(L["swarm_message"], "Attention", spellID)
		self:Bar(L["swarm_bar"], 11, spellID)
	end
end

function mod:Inferno()
	if db.inferno then
		self:DelayedMessage(45, L["inferno_warning"], "Positive")
		self:Bar(L["inferno_bar"], 50, 31299)
		self:ScheduleEvent("BWInfernoToTScan", self.InfernoCheck, 0.5, self)
	end
end

function mod:InfernoCheck()
	local target
	if UnitName("target") == boss then
		target = UnitName("targettarget")
	elseif UnitName("focus") == boss then
		target = UnitName("focustarget")
	else
		local num = GetNumRaidMembers()
		for i = 1, num do
			if UnitName(fmt("%s%d%s", "raid", i, "target")) == boss then
				target = UnitName(fmt("%s%d%s", "raid", i, "targettarget"))
				break
			end
		end
	end
	if target then
		if UnitIsUnit(target, "player") then
			self:LocalMessage(L["inferno_you"], "Personal", 31299, "Long")
		else
			self:IfMessage(fmt(L["inferno_message"], target), "Important", 31299, "Alert")
		end
		if db.icon then
			self:Icon(target)
			self:ScheduleEvent("ClearIcon", "BigWigs_RemoveRaidIcon", 5, self)
		end
	end
end

