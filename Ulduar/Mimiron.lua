----------------------------------
--      Module Declaration      --
----------------------------------

local boss = BB["Mimiron"]
local mod = BigWigs:New(boss, "$Revision$")
if not mod then return end
mod.zonename = BZ["Ulduar"]
mod.enabletrigger = boss
mod.guid = 33350		-- Most of the fight you fight vehicles .. does that matter..?
--  Leviathan MKII(33432), VX-001(33651), Aerial Command Unit(33670), 
mod.toggleoptions = {"phase", "hardmode", -1, "plasma", "shock", "laser", "bosskill"}

------------------------------
--      Are you local?      --
------------------------------

local db = nil
local phase = nil
local pName = UnitName("player")
local fmt = string.format

----------------------------
--      Localization      --
----------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

L:RegisterTranslations("enUS", function() return {
	["MKII"] = "Leviathan MKII",
	["VX-001"] = "VX-001",
	["Aerial"] = "Aerial Command Unit",

	cmd = "Mimiron",

	phase = "Phases",
	phase_desc = "Warn for phase changes.",
	starttrigger = "^We haven't much time, friends!",
	phase2_warning = "Phase 2!",
	phase2_trigger = "Behold, the VX-001 Anti-personnel Assault Cannon! You might want to take cover.",
	phase3_warning = "Phase 3!",
	phase3_trigger = "Mwahahahaha! Isn't it beautiful! I call it the magnificent Aerial Command Unit!",
	phase4_warning = "Phase 4!",
	phase4_trigger = "Gaze upon its magnificence! Bask in its glorious...um...glory! I present you with...V0-L7R-0N!",

	hardmode = "Hard Mode Timer",
	hardmode_desc = "Show Timer for Hard Mode.",
	hardmode_trigger = "^Now why would you go and do something like that?",
	hardmode_message = "Hard Mode activated!",
	hardmode_warning = "Hard Mode ends",
	
	plasma = "Plasma Blast",
	plasma_desc = "Warns when Plasma Blast is casting.",
	plasma_warning = "Casting Plasma Blast!",
	plasma_soon = "Plasma Blast soon!",

	shock = "Shock Blast",
	shock_desc = "Warns when Shock Blast is casting.",
	shock_warning = "Casting Shock Blast!",

	laser = "Laser Barrage",
	laser_desc = "Warn when Laser Barrage is active!",
	laser_soon = "Laser Barrage soon!",
	laser_bar = "Next Laser Barrage",

	end_trigger = "^It would appear that I made a slight miscalculation.",
	end_message = "%s has been defeated!",

	log = "|cffff0000"..boss.."|r: This boss needs data, please consider turning on your /combatlog or transcriptor and submit the logs.",
} end )

L:RegisterTranslations("koKR", function() return {
	["MKII"] = "거대전차 MKII",	--check
	["VX-001"] = "VX-001",
	["Aerial"] = "공중 지휘기",	--check

	phase = "단계",
	phase_desc = "단계 변화를 알립니다.",
	starttrigger = "^시간이 없어, 친구들!",
	phase2_warning = "2 단계!",
	phase2_trigger = "보아라, VX-001 대인-공격포의 아름다운 자태를! You might want to take cover.",	--check
	phase3_warning = "3 단계!",
	phase3_trigger = "정말 아름답지? 난 이걸 위대한 공중 지휘기라 부르지!",
	phase4_warning = "4 단계!",
	phase4_trigger = "그 장엄함을 느껴라! 영광을 흠뻑 취해...아니...영광에 취해라! I present you with...V0-L7R-0N!",	--check
	
	hardmode = "도전 모드 시간",
	hardmode_desc = "도전 모드의 시간을 표시합니다.",
	hardmode_trigger = "^아니 대체 왜 그런짓을 한거지?",	--check
	hardmode_message = "도전 모드 활성화!",
	hardmode_warning = "도전 모드 종료",
	
	plasma = "플라스마 폭발",
	plasma_desc = "플라스마 폭발 시전을 알립니다.",
	plasma_warning = "플라스마 폭발 시전!",
	plasma_soon = "곧 플라스마 폭발!",

	shock = "충격파",
	shock_desc = "충격파 시전을 알립니다.",
	shock_warning = "충격파 시전!",

	laser = "레이저 탄막",
	laser_desc = "레이저 탄막 활동을 알립니다!",
	laser_soon = "곧 레이저 탄막!",
	laser_bar = "디음 레이저 탄막",

	end_trigger = "^정상이야. 내가 계산을",
	end_message = "%s 물리침!",

	log = "|cffff0000"..boss.."|r: 해당 보스의 데이터가 필요합니다. 채팅창에 /전투기록 , /대화기록 을 입력하여 기록된 데이터나 transcriptor로 저장된 데이터 보내주시기 바랍니다.",
} end )

L:RegisterTranslations("frFR", function() return {
	["MKII"] = "Léviathan Mod. II",
	["VX-001"] = "VX-001",
	["Aerial"] = "Unité de commandement aérien",

	phase = "Phases",
	phase_desc = "Prévient quand la recontre entre dans une nouvelle phase.",
	starttrigger = "^Nous n'avons pas beaucoup de temps, les amis !",
	phase2_warning = "Phase 2 !",
	phase2_trigger = "Je vous présente le canon d'assaut antipersonnel VX-001 ! Il pourrait être judicieux de vous mettre à l'abri.",
	phase3_warning = "Phase 3 !",
	phase3_trigger = "Elle est belle, hein ? Je l'ai appelée la magnifique unité de commandement aérien !",
	phase4_warning = "Phase 4 !",
	--phase4_trigger = "Gaze upon its magnificence! Bask in its glorious...um...glory! I present you with...V0-L7R-0N!",
	
	hardmode = "Délais du mode difficile",
	hardmode_desc = "Affiche les délais du mode difficile.",
	--hardmode_trigger = "^Now why would you go and do something like that?",
	--hardmode_message = "Hard Mode activated!",
	--hardmode_warning = "Hard Mode ends",

	plasma = "Explosion de plasma",
	plasma_desc = "Prévient quand une Explosion de plasma est incantée.",
	plasma_warning = "Explosion de plasma en incantation !",
	plasma_soon = "Explosion de plasma imminente !",

	shock = "Horion explosif",
	shock_desc = "Prévient quand un Horion explosif est incanté.",
	shock_warning = "Horion explosif en incantation !",

	laser = "Barrage laser",
	laser_desc = "Prévient quand un Barrage laser est actif.",
	laser_soon = "Barrage laser imminent !",
	laser_bar = "Prochain Barrage laser",

	end_trigger = "^Il semblerait que j'ai pu faire une minime erreur de calcul.", -- à vérifier
	end_message = "%s a été vaincu !",

	log = "|cffff0000"..boss.."|r : ce boss a besoin de données, merci d'activer votre /combatlog ou Transcriptor et de nous transmettre les logs.",
} end )

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_CAST_START", "Plasma", 62997, 64529)
	self:AddCombatListener("SPELL_CAST_START", "Shock", 63631)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Laser", 63274)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Spinning", 63414)
	
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

	db = self.db.profile

	BigWigs:Print(L["log"])
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Plasma(_, spellID)
	if db.plasma then
		self:IfMessage(L["plasma_warning"], "Important", spellID)
		self:Bar(L["plasma_warning"], 3, spellID)
		self:Bar(L["plasma"], 30, spellID)
		self:DelayedMessage(27, L["plasma_soon"], "Attention")
	end
end

function mod:Shock(_, spellID)
	if db.shock then
		self:IfMessage(L["shock_warning"], "Important", spellID)
		self:Bar(L["shock"], 5, spellID)
	end
end

local last = 0
function mod:Laser(unit, spellID)
	local time = GetTime()
	if (time - last) > 4 then
		last = time
		if unit == L["VX-001"] and db.laser then
			self:IfMessage(L["laser"], "Important", spellID)
			self:Bar(L["laser"], 15, spellID)
			self:Bar(L["laser_bar"], 60, spellID)
		end
	end
end

function mod:Spinning(_, spellID)
	if db.laser then
		self:IfMessage(L["laser_soon"], "Important", spellID)
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg:find(L["hardmode_trigger"]) then
		if db.hardmode then
			self:Bar(L["hardmode"], 480, 64582)
			self:Message(L["hardmode_message"], "Attention", 64582)
			self:DelayedMessage(480, L["hardmode_warning"], "Attention")
		end
	elseif msg:find(L["starttrigger"]) then
		phase = 1
		if db.plasma then
			self:Bar(L["plasma"], 20, spellID)
			self:DelayedMessage(17, L["plasma_soon"], "Attention")
		end
	elseif msg == L["phase2_trigger"] then
		phase = 2
		self:CancelAllScheduledEvents()
		self:TriggerEvent("BigWigs_StopBar", self, L["plasma"])
		if db.phase then
			self:Message(L["phase2_warning"], "Attention")
		end
	elseif msg == L["phase3_trigger"] then
		phase = 3
		self:CancelAllScheduledEvents()
		self:TriggerEvent("BigWigs_StopBar", self, L["plasma"])
		if db.phase then
			self:Message(L["phase3_warning"], "Attention")
		end
	elseif msg == L["phase4_trigger"] then
		phase = 4
		self:CancelAllScheduledEvents()
		self:TriggerEvent("BigWigs_StopBar", self, L["plasma"])
		if db.phase then
			self:Message(L["phase4_warning"], "Attention")
		end
	elseif msg:find(L["end_trigger"]) then
		if db.bosskill then
			self:Message(L["end_message"]:format(boss), "Bosskill", nil, "Victory")
		end
		BigWigs:ToggleModuleActive(self, false)
	end
end
