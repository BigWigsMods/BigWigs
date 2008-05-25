------------------------------
--      Are you local?      --
------------------------------

local boss = BB["Kil'jaeden"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local CheckInteractDistance = CheckInteractDistance

local db = nil
local started = nil
local deaths = 0
local pName = UnitName("player")
local bloomed = {}

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "KilJaeden",

	bomb = "Darkness",
	bomb_desc = "Warn when Darkness of a Thousand Souls is being cast.",
	bomb_cast = "Incoming Big Bomb!",
	bomb_bar = "Explosion!",
	bomb_nextbar = "~Possible Bomb",
	bomb_warning = "Possible bomb in ~10sec",
	kalec_yell = "I will channel my powers into the orbs! Be ready!",

	orb = "Shield Orb",
	orb_desc = "Warn when a Shield Orb is shadowbolting.",
	orb_shooting = "Orb Alive - Shooting People!",

	bloom = "Fire Bloom",
	bloom_desc = "Tells you who has been hit by Fire Bloom.",
	bloom_other = "Fire Bloom on %s!",
	bloom_bar = "Fire Blooms",
	bloom_message = "Next Fire Bloom in 5 seconds!",

	bloomsay = "Fire Bloom Say",
	bloomsay_desc = "Place a msg in say notifying that you have Fire Bloom",
	bloom_say = "Fire Bloom on ME!",

	bloomwhisper = "Fire Bloom Whisper",
	bloomwhisper_desc = "Whisper players with Fire Bloom.",
	bloom_you = "Fire Bloom on YOU!",

	icons = "Bloom Icons",
	icons_desc = "Place random Raid Icons on players with Fire Bloom (requires promoted or higher)",

	shadow = "Shadow Spike",
	shadow_desc = "Raid warn of casting of Shadow Spike.",
	shadow_message = "Shadow Spikes Inc For 28sec! WATCH OUT!",
	shadow_bar = "Shadow Spikes Expire",
	shadow_warning = "Shadow Spikes Done in 5 seconds!",
	shadow_debuff_bar = "Reduced Healing on %s",

	flame = "Flame Dart",
	flame_desc = "Show Flame Dart timer bar.",
	flame_bar = "Next Flame Dart",
	flame_message = "Next Flame Dart in 5 seconds!",

	sinister = "Sinister Reflections",
	sinister_desc = "Warns on Sinister Reflection spawns.",
	sinister_message = "Sinister Reflections Up!",

	shield_up = "Shield is UP!",

	deceiver_dies = "Deciever #%d Killed",
	["Hand of the Deceiver"] = true,
} end )

L:RegisterTranslations("koKR", function() return {
	bomb = "어둠의 영혼",
	bomb_desc = "무수한 어둠의 영혼 시전 시 알립니다.",
	bomb_cast = "잠시 후 큰 폭탄!",
	bomb_bar = "폭발!",
	bomb_nextbar = "~폭탄 가능",
	bomb_warning = "약 10초 이내 폭탄 가능!",
	kalec_yell = "수정구에 힘을 쏟겠습니다! 준비하세요!",	--check

	orb = "보호막 보주",
	orb_desc = "보호막 보주의 어둠의 화살을 알립니다.",
	orb_shooting = "보주 활동 - 어활 공격!",

	bloom = "화염 불꽃",
	bloom_desc = "화염 불꽃에 걸린 플레이어를 알립니다.",
	bloom_other = "%s 화염 불꽃!",
	bloom_bar = "화염 불꽃",
	bloom_message = "5초 후 다음 화염 불꽃!",
	
	bloomsay = "화염 불꽃 대화",
	bloomsay_desc = "자신이 화염 불꽃이 걸렸을시 일반 대화로 출력합니다.",
	bloom_say = "나에게 화염 불꽃!",

	bloomwhisper = "화염 불꽃 귓속말",
	bloomwhisper_desc = "화염 불꽃에 걸린 플레이어에게 귓속말로 알립니다.",
	bloom_you = "당신은 화염 불꽃!",
	
	icons = "불꽃 전술 표시",
	icons_desc = "화염 불꽃에 걸린 플레이어에게 전술 표시를 지정합니다. (승급자 이상 권한 필요)",

	shadow = "어둠의 쐐기",
	shadow_desc = "어둠의 쐐기에 대하여 공격대에 알립니다.",
	shadow_message = "잠시 후 28초간 어둠의 쐐기! 조심하세요!",
	shadow_bar = "어둠의 쐐기 종료",
	shadow_warning = "5초 후 어둠의 쐐기 종료!",
	shadow_debuff_bar = "%s 치유효과 감소",
	
	flame = "불꽃 화살",
	flame_desc = "불꽃 화살 타이머 바를 표시합니다.",
	flame_bar = "다음 불꽃 화살",
	flame_message = "5초 후 다음 불꽃 화살!",

	sinister = "사악한 환영 복제",
	sinister_desc = "사악한 환영 복제를 알립니다.",
	sinister_message = "사악한 환영 복제!",

	shield_up = "푸른용의 보호막!",

	deceiver_dies = "심복 #%d 처치",
	["Hand of the Deceiver"] = "기만자의 심복",
} end )

L:RegisterTranslations("frFR", function() return {
	bomb = "Ténèbres des mille âmes",
	bomb_desc = "Prévient quand les Ténèbres des mille âmes sont incantés.",
	bomb_cast = "Arrivée d'une énorme bombe !",
	bomb_bar = "Explosion !",
	bomb_nextbar = "~Bombe probable",
	bomb_warning = "Bombe probable dans ~10 sec.",
	kalec_yell = "Je vais canaliser mon énergie vers les orbes ! Préparez-vous !", -- à vérifier

	orb = "Orbe bouclier",
	orb_desc = "Prévient quand une Orbe bouclier lance des Traits de l'ombre.",
	orb_shooting = "Orbe en vie !",

	bloom = "Fleur du feu",
	bloom_desc = "Prévient quand des joueurs subissent les effets de la Fleur du feu.",
	bloom_other = "Fleur du feu sur %s !",
	bloom_bar = "Fleurs du feu",
	bloom_message = "Prochaine Fleur du feu dans 5 sec. !",

	bloomsay = "Dire - Fleur du feu",
	bloomsay_desc = "Fait dire à votre personnage qu'il est ciblé par la Fleur du feu quand c'est le cas, afin d'aider les membres proches ayant les bulles de dialogue activées.",
	bloom_say = "Fleur du feu sur MOI !",

	bloomwhisper = "Chuchoter",
	bloomwhisper_desc = "Prévient par chuchotement les derniers joueurs affectés par la Fleur du feu (nécessite d'être promu ou mieux).",
	bloom_you = "Fleur du feu sur VOUS !",

	icons = "Icônes",
	icons_desc = "Place une icône de raid sur les derniers joueurs affectés par la Fleur du feu (nécessite d'être promu ou mieux).",

	shadow = "Pointe de l'ombre",
	shadow_desc = "Prévient quand les Pointes de l'ombre sont incantées.",
	shadow_message = "Pointes de l'ombre pendant 28 sec. !",
	shadow_bar = "Fin des Pointes",
	shadow_warning = "Pointes de l'ombre terminées dans 5 sec. !",
	shadow_debuff_bar = "Soins réduits sur %s",

	flame = "Fléchette des flammes",
	flame_desc = "Affiche une barre temporelle pour la Flèchette des flammes.",
	flame_bar = "Prochaine Fléchette",
	flame_message = "Prochaine Fléchette des flammes dans 5 sec. !",

	sinister = "Reflet sinistre",
	sinister_desc = "Prévient quand les Reflets sinistres apparaissent.",
	sinister_message = "Reflets sinistres actifs !",

	shield_up = "Bouclier ACTIF !",

	deceiver_dies = "Trompeur #%d tué",
	["Hand of the Deceiver"] = "Main du Trompeur", -- à vérifier
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local deceiver = L["Hand of the Deceiver"]
local mod = BigWigs:NewModule(boss)
mod.zonename = BZ["Sunwell Plateau"]
mod.enabletrigger = {deceiver, boss}
mod.toggleoptions = {"bomb", "orb", "flame", -1, "bloom", "bloomwhisper","bloomsay", "icons", -1, "sinister", "shadow", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))
mod.proximityCheck = function( unit ) return CheckInteractDistance( unit, 3 ) end
mod.proximitySilent = true

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Sinister", 45892)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Shield", 45848)
	self:AddCombatListener("SPELL_DAMAGE", "Orb", 45680)
	self:AddCombatListener("SPELL_MISSED", "Orb", 45680)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Bloom", 45641)
	self:AddCombatListener("SPELL_CAST_START", "Shadow", 45885)
	self:AddCombatListener("UNIT_DIED", "Deaths")

	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("BigWigs_RecvSync")

	db = self.db.profile
	started = nil
	deaths = 0
	for i = 1, #bloomed do bloomed[i] = nil end
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Sinister()
	if db.sinister then
		self:IfMessage(L["sinister_message"], "Attention", 45892)
	end
	if db.flame then
		self:Bar(L["flame_bar"], 60, 45737)
		self:DelayedMessage(55, L["flame_message"], "Attention")
	end
end

function mod:Shield()
	self:IfMessage(L["shield_up"], "Urgent", 45848)
end

local last = 0
function mod:Orb()
	local time = GetTime()
	if (time - last) > 10 then
		last = time
		if db.orb then
			self:IfMessage(L["orb_shooting"], "Attention", 45680, "Alert")
		end
	end
end

function mod:Deaths(unit)
	if unit == deceiver then
		deaths = deaths + 1
		self:IfMessage(L["deceiver_dies"]:format(deaths), "Positive")
		if deaths == 3 then
			self:Bar(boss, 10, "Spell_Shadow_Charm")
			self:TriggerEvent("BigWigs_ShowProximity", self)
		end
	elseif unit == boss then
		self:GenericBossDeath(unit)
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(_, unit)
	if unit == boss and db.bomb then
		self:Bar(L["bomb_bar"], 8, "Spell_Shadow_BlackPlague")
		self:IfMessage(L["bomb_cast"], "Positive")
		self:Bar(L["bomb_nextbar"], 46, "Spell_Shadow_BlackPlague")
		self:DelayedMessage(36, L["bomb_warning"], "Attention")
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L["kalec_yell"] and db.bomb then
		self:Bar(L["bomb_nextbar"], 40, "Spell_Shadow_BlackPlague")
		self:DelayedMessage(30, L["bomb_warning"], "Attention")
	end
end

function mod:Shadow()
	if db.shadow then
		self:Bar(L["shadow_bar"], 28, 45885)
		self:DelayedMessage(0.1, L["shadow_message"], "Attention")
		self:DelayedMessage(23, L["shadow_warning"], "Attention")
	end
end

function mod:Bloom(player)
	if db.bloom then
		tinsert(bloomed, player)
		self:Whisper(player, L["bloom_you"], "bloomwhisper")
		self:ScheduleEvent("BWBloomWarn", self.BloomWarn, 0.4, self)
		if player == pName and db.bloomsay then
			SendChatMessage(L["bloom_say"], "SAY")
		end
	end
end

function mod:BloomWarn()
	local msg = nil
	table.sort(bloomed)

	for i,v in ipairs(bloomed) do
		if not msg then
			msg = v
		else
			msg = msg .. ", " .. v
		end
		if db.icons then
			SetRaidTarget(v, i)
		end
	end

	self:IfMessage(L["bloom_other"]:format(msg), "Important", 45641, "Alert")
	self:Bar(L["bloom_bar"], 20, 45641)
	for i = 1, #bloomed do bloomed[i] = nil end
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if self:ValidateEngageSync(sync, rest) and not started then
		started = true
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end
	end
end
