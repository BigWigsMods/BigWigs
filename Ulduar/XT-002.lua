----------------------------------
--      Module Declaration      --
----------------------------------

local boss = BB["XT-002 Deconstructor"]
local mod = BigWigs:New(boss, "$Revision$")
if not mod then return end
mod.zonename = BZ["Ulduar"]
mod.enabletrigger = boss
mod.guid = 33293
mod.toggleoptions = {"exposed", "gravitybomb", "lightbomb", "tympanic", "voidzone", "heartbreak", "bosskill"}
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
local phase = nil
local started = nil
local exposed1 = nil
local exposed2 = nil
local exposed3 = nil
local bandages = {
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

----------------------------
--      Localization      --
----------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

L:RegisterTranslations("enUS", function() return {
	cmd = "XT-002",

	exposed = "Exposed Heart",
	exposed_desc = "Warn when XT-002 gains Exposed Heart.",
	exposed_warning = "Exposed Heart Soon!",
	exposed_message = "Exposed Heart - adds incoming!",

	gravitybomb = "Gravity Bomb",
	gravitybomb_desc = "Tells you who has been hit by Gravity Bomb.",
	gravitybomb_you = "Gravity Bomb on YOU!",
	gravitybomb_other = "Gravity Bomb on %s!",

	lightbomb = "Light Bomb",
	lightbomb_desc = "Tells you who has been hit by Light Bomb.",
	lightbomb_you = "Light Bomb on YOU!",
	lightbomb_other = "Light Bomb on %s!",

	tympanic = "Tympanic Tantrum",
	tympanic_desc = "Warn when XT-002 casts a Tympanic Tantrum.",
	tympanic_message = "Tympanic Tantrum!",

	voidzone = "Void Zone",
	voidzone_desc = "Warn for Void Zone spawn.",
	voidzone_message = "Void Zone!",

	heartbreak = "Heartbreak",
	heartbreak_desc = "Warn when XT-002 gains Heartbreak",
	heartbreak_message = "Heartbreak!",

	icon = "Raid Icon",
	icon_desc = "Place a Raid Icon on players with Bomb. (requires promoted or higher)",

	log = "|cffff0000"..boss.."|r: This boss needs data, please consider turning on your /combatlog or transcriptor and submit the logs.",
} end )

L:RegisterTranslations("koKR", function() return {
	exposed = "심장 노출",
	exposed_desc = "XT-002의 심장 노출 획득을 알립니다.",
	exposed_warning = "잠시 후 심장 노출!",
	exposed_message = "심장 노출 - 로봇들 추가!",

	gravitybomb = "중력 폭탄",
	gravitybomb_desc = "중력 폭탄에 걸린 플레이어를 알립니다.",
	gravitybomb_you = "당신은 중력 폭탄!",
	gravitybomb_other = "중력 폭탄: %s!",

	lightbomb = "빛의 폭탄",
	lightbomb_desc = "빛의 폭탄에 걸린 플레이어를 알립니다.",
	lightbomb_you = "당신은 빛의 폭탄!",
	lightbomb_other = "빛의 폭탄: %s!",

	tympanic = "격분의 땅울림",
	tympanic_desc = "XT-002의 격분의 땅울림 시전을 알립니다.",
	tympanic_message = "격분의 땅울림!",

	voidzone = "공허의 지대",
	voidzone_desc = "공허의 지대 생성을 알립니다.",
	voidzone_message = "공허의 지대!",

	heartbreak = "부서진 심장",
	heartbreak_desc = "XT-002의 부서진 심장 획득을 알립니다.",
	heartbreak_message = "심장 파괴됨!",

	icon = "전술 표시",
	icon_desc = "폭탄에 걸린 플레이어에게 전술 표시를 지정합니다. (승급자 이상 권한 필요)",

	log = "|cffff0000"..boss.."|r: 해당 보스의 데이터가 필요합니다. 채팅창에 /전투기록 , /대화기록 을 입력하여 기록된 데이터나 transcriptor로 저장된 데이터 보내주시기 바랍니다.",
} end )

L:RegisterTranslations("frFR", function() return {
	exposed = "Coeur exposé",
	exposed_desc = "Prévient quand le coeur du XT-002 est exposé.",
	exposed_warning = "Coeur exposé imminent !",
	exposed_message = "Coeur exposé - arrivée des renforts !",

	gravitybomb = "Bombe à gravité",
	gravitybomb_desc = "Prévient quand un joueur subit les effets d'une Bombe à gravité.",
	gravitybomb_you = "Bombe à gravité sur VOUS !",
	gravitybomb_other = "Bombe à gravité sur %s !",

	lightbomb = "Bombe de lumière",
	lightbomb_desc = "Prévient quand un joueur subit les effets d'une Bombe de lumière.",
	lightbomb_you = "Bombe de lumière sur VOUS !",
	lightbomb_other = "Bombe de lumière sur %s !",

	tympanic = "Colère assourdissante",
	tympanic_desc = "Prévient quand XT-002 incante une Colère assourdissante.",
	tympanic_message = "Colère assourdissante !",

	voidzone = "Zone de Vide",
	voidzone_desc = "Prévient quand une Zone de Vide apparaît.",
	voidzone_message = "Zone de Vide !",

	heartbreak = "Bris du coeur",
	heartbreak_desc = "Prévient quand XT-002 gagne Bris du coeur.",
	heartbreak_message = "Bris du coeur !",

	icon = "Icône",
	icon_desc = "Place une icône de raid sur le dernier joueur affecté par une bombe (nécessite d'être assistant ou mieux).",

	log = "|cffff0000"..boss.."|r : ce boss a besoin de données, merci d'activer votre /combatlog ou Transcriptor et de nous transmettre les logs.",
} end )

L:RegisterTranslations("deDE", function() return {
	exposed = "Freigelegtes Herz",
	exposed_desc = "Warnen wenn der XT-002 ein Freigelegtes Herz hat.",
	exposed_warning = "Freigelegtes Herz bald!",
	exposed_message = "Freigelegtes Herz - Adds!",

	gravitybomb = "Gravitationsbombe",
	gravitybomb_desc = "Warnt wer von Gravitationsbombe getroffen wurde.",
	gravitybomb_you = "Gravitationsbombe auf DIR!",
	gravitybomb_other = "Gravitationsbombe auf %s!",

	lightbomb = "Lichtbombe",
	lightbomb_desc = "Warnt wer von Lichtbombe getroffen wurde.",
	lightbomb_you = "Lichtbombe auf DIR!",
	lightbomb_other = "Lichtbombe auf %s!",

	tympanic = "Betäubender Koller",
	tympanic_desc = "Warnt wenn XT-002 Betäubender Koller wirkt.",
	tympanic_message = "Betäubender Koller!",
	
	--voidzone = "Void Zone",
	--voidzone_desc = "Warn for Void Zone spawn.",
	--voidzone_message = "Void Zone!",

	heartbreak = "Gebrochenes Herz",
	heartbreak_desc = "Warnt wenn der XT-002 Gebrochenes Herz bekommt",
	heartbreak_message = "Gebrochenes Herz!",

	icon = "Schlachtzugs-Symbol",
	icon_desc = "Platziert ein Schlachtzugs-Symbol auf Spielern, die von einer Bombe getroffen werden (benötigt Assistent oder höher).",

	log = "|cffff0000"..boss.."|r: This boss needs data, please consider turning on your /combatlog or transcriptor and submit the logs.",
} end )

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_CAST_START", "Tympanic", 62775, 62776)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Exposed", 63849)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Heartbreak", 64193)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Bomb", 63018, 63024, 64234)
	self:AddCombatListener("SPELL_AURA_REMOVED", "BombRemoved", 63018, 63024, 64234)
	self:AddCombatListener("SPELL_SUMMON", "VoidZone", 64203, 64235)
	self:AddCombatListener("UNIT_DIED", "BossDeath")

	self:RegisterEvent("UNIT_HEALTH")

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("BigWigs_RecvSync")

	db = self.db.profile

	BigWigs:Print(L["log"])
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Exposed(_, spellID)
	if db.exposed then
		self:IfMessage(L["exposed_message"], "Attention", spellID)
		self:Bar(L["exposed"], 30, spellID)
	end
end

function mod:Heartbreak(_, spellID)
	phase = 2
	if db.heartbreak then
		self:IfMessage(L["heartbreak_message"], "Attention", spellID)
	end
end

function mod:Bomb(player, spellID)
	if spellId == 63024 or spellId == 64234 and db.gravitybomb then
		local other = L["gravitybomb_other"]:format(player)
		if player == pName then
			self:Message(L["gravitybomb_you"], "Personal", true, "Alert", nil, spellID)
			self:Message(other, "Attention", nil, nil, true)
			self:TriggerEvent("BigWigs_ShowProximity", self)
		else
			self:Message(other, "Attention", nil, nil, nil, spellID)
			self:Whisper(player, L["gravitybomb_you"])
		end
		self:Bar(other, 9, spellID)
	elseif spellId == 63018 and db.lightbomb then
		local other = L["lightbomb_other"]:format(player)
		if player == pName then
			self:Message(L["lightbomb_you"], "Personal", true, "Alert", nil, spellID)
			self:Message(other, "Attention", nil, nil, true)
			self:TriggerEvent("BigWigs_ShowProximity", self)
		else
			self:Message(other, "Attention", nil, nil, nil, spellID)
			self:Whisper(player, L["lightbomb_you"])
		end
		self:Bar(other, 9, spellID)
	end
	self:Icon(player, "icon")
end

function mod:BombRemoved(player, spellID)
	if db.lightbomb then
		self:TriggerEvent("BigWigs_HideProximity", self)
	end
end

function mod:Tympanic(_, spellID)
	if db.tympanic then
		self:IfMessage(L["tympanic_message"], "Attention", spellID)
	end
end

function mod:VoidZone(_, spellID)
	if db.voidzone then
		self:IfMessage(L["voidzone_message"], "Attention", 64235)
	end
end

function mod:UNIT_HEALTH(msg)
	if UnitName(msg) == boss and db.exposed then
		if phase == 1 then
			local health = UnitHealth(msg)
			if not exposed1 and health > 86 and health <= 88 then
				exposed1 = true
				self:Message(L["exposed_warning"], "Attention")
			elseif not exposed2 and health > 56 and health <= 58 then
				exposed2 = true
				self:Message(L["exposed_warning"], "Attention")
			elseif not exposed3 and health > 26 and health <= 28 then
				exposed3 = true
				self:Message(L["exposed_warning"], "Attention")
			end
		end
	end
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if self:ValidateEngageSync(sync, rest) and not started then
		started = true
		phase = 1
		exposed1 = nil
		exposed2 = nil
		exposed3 = nil
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end
	end
end

