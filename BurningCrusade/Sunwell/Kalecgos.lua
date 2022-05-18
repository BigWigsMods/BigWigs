--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Kalecgos", 580, 1591)
if not mod then return end
mod:RegisterEnableMob(24850, 24892) -- Kalecgos, Sathrovarr
mod:SetAllowWin(true)
mod:SetEncounterID(724)
mod:SetRespawnTime(30)

--------------------------------------------------------------------------------
-- Locals
--

local portalCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.engage_trigger = "Aggh!! No longer will I be a slave to Malygos! Challenge me and you will be destroyed!"
	L.enrage_trigger = "Sathrovarr drives Kalecgos into a crazed rage!"

	L.sathrovarr = "Sathrovarr the Corruptor"

	L.portal = "Portal"
	L.portal_message = "Possible portal in 5 sec!"

	L.realm = 46021
	L.realm_desc = "Tells you who is in the Spectral Realm."
	L.realm_icon = 46021
	L.realm_message = "Spectral Realm: %s (Group %d)"
	L.nobody = "Nobody"

	L.curse = "Curse"

	L.wild_magic_healing = "Wild Magic (Increased healing)"
	L.wild_magic_healing_desc = "Tells you when you get increased healing from Wild Magic."
	L.wild_magic_healing_icon = 44978
	L.wild_magic_healing_you = "Wild Magic - Healing increased!"

	L.wild_magic_casting = "Wild Magic (Increased cast time)"
	L.wild_magic_casting_desc = "Tells you when a healer gets incrased cast time from Wild Magic."
	L.wild_magic_casting_icon = 45001
	L.wild_magic_casting_you = "Wild Magic - Cast time increased!"
	L.wild_magic_casting_other = "Wild Magic - Cast time increased on %s!"

	L.wild_magic_hit = "Wild Magic (Decreased hit chance)"
	L.wild_magic_hit_desc = "Tells you when a tank's chance to hit is reduced by Wild Magic."
	L.wild_magic_hit_icon = 45002
	L.wild_magic_hit_you = "Wild Magic - Hit chance decreased!"
	L.wild_magic_hit_other = "Wild Magic - Hit chance decreased on %s!"

	L.wild_magic_threat = "Wild Magic (Increased threat)"
	L.wild_magic_threat_desc = "Tells you when you get increased threat from Wild Magic."
	L.wild_magic_threat_icon = 45006
	L.wild_magic_threat_you = "Wild Magic - Threat increased!"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"proximity",
		44806, -- Crazed Rage

		-- [[ Kalecgos ]]
		45018, -- Arcane Buffet
		44799, -- Frost Breath
		"wild_magic_healing", -- Wild Magic (Increased healing) (You)
		"wild_magic_casting", -- Wild Magic (Increased cast time) (Healers)
		"wild_magic_hit", -- Wild Magic (Decreased hit chance) (Tanks)
		"wild_magic_threat", -- Wild Magic (Increased threat) (You)
		44866, -- Spectral Blast

		-- [[ Sathrovarr ]]
		{"realm", "INFOBOX"}, -- Spectral Realm
		45029, -- Corrupting Strike
		45032, -- Curse of Boundless Agony
	}, {
		[45018] = mod.displayName,
		["realm"] = L.sathrovarr,
	}, {
		[44866] = L.portal, -- Spectral Blast (Portal)
		[45032] = L.curse, -- Curse of Boundless Agony (Curse)
	}
end

function mod:VerifyEnable(unit)
	return UnitCanAttack("player", unit)
end

function mod:OnBossEnable()
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	self:Log("SPELL_AURA_APPLIED", "CrazedRage", 44806)
	self:Log("SPELL_AURA_APPLIED", "ArcaneBuffetApplied", 45018)
	self:Log("SPELL_AURA_APPLIED_DOSE", "ArcaneBuffetApplied", 45018)
	self:Log("SPELL_CAST_START", "FrostBreath", 44799)
	self:Log("SPELL_AURA_APPLIED", "WildMagic", 44978, 45001, 45002, 45006)
	self:Log("SPELL_AURA_APPLIED", "SpectralRealmApplied", 46021)
	self:Log("SPELL_AURA_REMOVED", "SpectralRealmRemoved", 46021)
	self:Log("SPELL_CAST_SUCCESS", "CorruptingStrike", 45029)
	self:Log("SPELL_AURA_APPLIED", "CurseOfBoundlessAgonyApplied", 45032, 45034)
	self:Log("SPELL_AURA_REMOVED", "CurseOfBoundlessAgonyRemoved", 45032, 45034)

	self:BossYell("Engage", L.engage_trigger)
	self:Emote("CrazedRage", L.enrage_trigger)
	self:RegisterMessage("BigWigs_BossComm")

	self:Death("Win", 24892) -- Sathrovarr
end

function mod:OnEngage()
	portalCount = 1

	-- self:CDBar(44799, 15) -- Frost Breath 10~19s
	self:Bar(44866, 20, CL.count:format(L.portal, portalCount))
	self:DelayedMessage(44866, 15, "orange", L.portal_message, false, "alert")

	self:OpenProximity("proximity", 9) -- 8 yds for Spectral Blast
	if not self:Solo() then
		self:OpenInfo("realm", self:SpellName(46021), 4) -- Spectral Realm
		self:UpdateInfoBox()
	end

	self:RegisterEvent("UNIT_HEALTH")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_HEALTH(event, unit)
	if self:MobId(unit) == 24892 then -- Sathrovarr
		local hp = self:GetHealth(unit)
		if hp <= 14 then
			self:Message(44806, "orange", CL.soon:format(self:SpellName(44806)), false)
			self:UnregisterEvent(event)
		end
	end
end

function mod:CrazedRage()
	self:Sync("KalecgosEnrage", 1)
end

-- Kalecgos

function mod:ArcaneBuffetApplied(args)
	self:Sync("KaleBuffet", args.destName)
end

function mod:FrostBreath(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "info")
	-- self:CDBar(args.spellId, 15) -- 10~19s
end

do
	-- Assumptions made:
	--	Shaman are always counted as healers
	--	Paladins without Righteous Fury are healers
	--	Druids are counted as healers if they have a mana bar and are not Moonkin
	--	Priests are counted as healers if they aren't in Shadowform
	local function isPlayerHealer(player)
		local _, class = UnitClass(player)
		if class == "SHAMAN" then
			return true
		end
		if class == "DRUID" and UnitPowerType(player) == 0 then
			return not mod:UnitBuff(player, 24858) -- Moonkin Form
		end
		if class == "PALADIN" then
			return not mod:UnitBuff(player, 25780) -- Righteous Fury
		end
		if class == "PRIEST" then
			return not mod:UnitBuff(player, 15473) -- Shadowform
		end
		return false
	end

	-- Assumptions made:
	--	Anyone with a rage bar is counted as a tank
	--	Paladins with Righteous Fury are counted as tanks
	local function isPlayerTank(player)
		local _, class = UnitClass(player)
		if UnitPowerType(player) == 1 then -- has rage
			return true
		end
		if class == "PALADIN" and mod:UnitBuff(player, 25780) then -- Righteous Fury
			return true
		end
		return false
	end

	function mod:WildMagic(args)
		if args.spellId == 44978 then -- Healing done by spells and effects increased by 100%
			if self:Me(args.destGUID) then
				self:Message("wild_magic_healing", "yellow", L.wild_magic_healing_you, L.wild_magic_healing_icon)
				self:PlaySound("wild_magic_healing", "long")
			end
		elseif args.spellId == 45001 then -- Casting time increased by 100%
			if isPlayerHealer(args.destName) then
				self:Sync("KalecgosMagicCast", args.destName)
			end
		elseif args.spellId == 45002 then -- Chance to hit with melee and ranged attacks reduced by 50%
			if isPlayerTank(args.destName) then
				self:Sync("KalecgosMagicHit", args.destName)
			end
		elseif args.spellId == 45006 then -- Increases threat generated by 100%
			if self:Me(args.destGUID) then
				self:Message("wild_magic_threat", "blue", L.wild_magic_threat_you, L.wild_magic_threat_icon)
				self:PlaySound("wild_magic_healing", "long")
			end
		end
	end
end

-- Sathrovarr

function mod:SpectralRealmApplied(args)
	self:Sync("KalecgosRealm", args.destName)
	if self:Me(args.destGUID) then
		self:CloseProximity("proximity")
	end
end

function mod:SpectralRealmRemoved(args)
	if self:Me(args.destGUID) then
		self:OpenProximity("proximity", 9)
	end
end

function mod:UpdateInfoBox()
	-- should probably add a way to install an OnUpdate function
	if not _G.BigWigsInfoBox:IsShown() then return end

	local t = GetTime()
	local count = 0
	for i = 1, GetNumGroupMembers() do
		local player, _, subgroup = GetRaidRosterInfo(i)
		local debuff, _, duration, expires = self:UnitDebuff(player, 46021) -- Spectral Realm
		if debuff then
			count = count + 1
			if count > 20 then break end -- bit crowded in there, eh?
			local line = count * 2 - 1
			local text = ("[%d] %s"):format(subgroup, self:ColorName(player))
			local remaining = expires - t
			self:SetInfo("realm", line, text)
			self:SetInfo("realm", line + 1, math.ceil(remaining))
			self:SetInfoBar("realm", line, remaining / duration)
		end
	end
	for i = count + 1, 20 do
		local line = i * 2 - 1
		self:SetInfo("realm", line, "")
		self:SetInfo("realm", line + 1, "")
		self:SetInfoBar("realm", line, 0)
	end
	if count == 0 then
		self:SetInfo("realm", 1, ("|cff777777%s|r"):format(L.nobody))
	end

	self:ScheduleTimer("UpdateInfoBox", 0.3)
end

function mod:CorruptingStrike(args)
	self:Sync("KalecgosStrike", args.destName)
end

function mod:CurseOfBoundlessAgonyApplied(args)
	self:Sync("KalecgosCurse", args.destName)
end

function mod:CurseOfBoundlessAgonyRemoved(args)
	self:Sync("KaleCurseRemv", args.destName)
end

-- Yay, I missed phased CLEU !
-- (is this still needed on retail?)

do
	local throttle = {
		KalecgosCurse = 0, KaleCurseRemv = 0, -- throttle by sync+extra?
		KalecgosMagicCast = 3, KalecgosMagicHit = 3, KaleBuffet = 3, KalecgosStrike = 3, KalecgosEnrage = 3,
		KalecgosRealm = 19,
	}
	local prev = {}

	local function getGroup(player)
		for i = 1, GetNumGroupMembers() do
			local name, _, subgroup = GetRaidRosterInfo(i)
			if name == player then
				return subgroup
			end
		end
	end

	function mod:BigWigs_BossComm(_, sync, rest)
		if throttle[sync] == nil or not rest then return end

		local t = GetTime()
		if t - (prev[sync] or 0) < throttle[sync] then return end
		prev[sync] = t

		if sync == "KalecgosRealm" then
			 -- Spectral Blast
			portalCount = portalCount + 1
			self:Bar(44866, 20, CL.count:format(L.portal, portalCount))
			self:DelayedMessage(44866, 15, "orange", L.portal_message, false, "alert")

			-- Spectral Realm
			local group = getGroup(rest) or 0
			self:Message("realm", "orange", L.realm_message:format(rest, group), L.realm_icon)
			self:PlaySound("realm", "alert")

		elseif sync == "KalecgosCurse" then
			self:TargetBar(45032, 30, rest, L.curse) -- Curse of Boundless Agony

		elseif sync == "KaleCurseRemv" then
			self:StopBar(L.curse, rest)

		elseif sync == "KaleBuffet" then
			self:CDBar(45018, 8) -- Arcane Buffet

		elseif sync == "KalecgosMagicCast" then
			if UnitIsUnit(rest, "player") then
				self:Message("wild_magic_casting", "green", L.wild_magic_casting_you, L.wild_magic_casting_icon)
				self:PlaySound("wild_magic_casting", "long")
			elseif not self:CheckOption("wild_magic_casting", "ME_ONLY") then -- since we're not using :TargetMessage, check this manually
				self:Message("wild_magic_casting", "yellow", L.wild_magic_casting_other:format(rest), L.wild_magic_casting_icon)
			end

		elseif sync == "KalecgosMagicHit" then
			if UnitIsUnit(rest, "player") then
				self:Message("wild_magic_hit", "blue", L.wild_magic_hit_you, L.wild_magic_hit_icon)
				self:PlaySound("wild_magic_hit", "long")
			elseif not self:CheckOption("wild_magic_hit", "ME_ONLY") then -- since we're not using :TargetMessage, check this manually
				self:Message("wild_magic_hit", "yellow", L.wild_magic_hit_other:format(rest), L.wild_magic_hit_icon)
			end

		elseif sync == "KalecgosStrike" then
			self:TargetMessage(45029, "orange", rest) -- Corrupting Strike
			if rest ~= self.displayName then
				self:TargetBar(45029, 3, rest)
			end

		elseif sync == "KalecgosEnrage" then
			self:Message(44806, "red", CL.percent:format(10, self:SpellName(44806))) -- Crazed Rage
			self:PlaySound(44806, "alarm")
			self:UnregisterEvent("UNIT_HEALTH")

		end
	end
end
