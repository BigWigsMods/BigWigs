if not IsTestBuild() then return end -- XXX dont load on live
--------------------------------------------------------------------------------
-- TODO List:

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Maiden of Vigilance", 1147, 1897)
if not mod then return end
mod:RegisterEnableMob(118289) -- Maiden of Vigilance
mod.engageId = 2052
--mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

local shieldActive = false

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.custom_on_infusion_plates = "Display Infusion debuffs on friendly nameplates"
	L.custom_on_infusion_plates_desc = "This feature is currently only supported by KuiNameplates."
	L.custom_on_infusion_plates_icon = 235271
end
--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		240209, -- Unstable Soul
		236420, -- Aegwynn's Ward
		{235271, "PROXIMITY"}, -- Infusion
		"custom_on_infusion_plates",
		235569, -- Hammer of Creation
		235573, -- Hammer of Obliteration
		235267, -- Mass Instability
		237722, -- Blowback
		235028, -- Titanic Bulwark
		234891, -- Wrath of the Creators
	},{
		[240209] = "general",
		[235271] = -14974, -- Stage One: Divide and Conquer
		[237722] = -14975, -- Stage Two: Watcher's Wrath
	}
end

function mod:OnBossEnable()
	-- General
	self:Log("SPELL_AURA_APPLIED", "UnstableSoul", 240209) -- Unstable Soul
	self:Log("SPELL_AURA_APPLIED", "AegwynnsWardApplied", 236420) -- Aegwynn's Ward

	-- Stage One: Divide and Conquer
	self:Log("SPELL_AURA_APPLIED", "FelInfusion", 235240) -- Fel Infusion
	self:Log("SPELL_AURA_APPLIED", "LightInfusion", 235213) -- Light Infusion
	self:Log("SPELL_CAST_SUCCESS", "HammerofCreation", 235569) -- Hammer of Creation
	self:Log("SPELL_CAST_SUCCESS", "HammerofObliteration", 235573) -- Hammer of Obliteration
	self:Log("SPELL_CAST_SUCCESS", "MassInstability", 235267) -- Mass Instability

	-- Stage Two: Watcher's Wrath
	self:Log("SPELL_CAST_SUCCESS", "Blowback", 237722) -- Blowback
	self:Log("SPELL_CAST_START", "TitanicBulwark", 235028) -- Titanic Bulwark
	self:Log("SPELL_AURA_REMOVED", "TitanicBulwarkRemoved", 235028) -- Light Infusion
	self:Log("SPELL_CAST_START", "WrathoftheCreators", 234891) -- Wrath of the Creators


	if 	self:GetOption("custom_on_infusion_plates") then
		self:ShowFriendlyNameplates()
	end
end

function mod:OnEngage()
	shieldActive = false
end

function mod:OnBossDisable()
	self:HideFriendlyNameplates()
end
--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UnstableSoul(args)
	if self:Me(args.destGUID) then
		self:TargetMessage(args.spellId, args.destName, "Personal", "Alarm")
	end
end

function mod:AegwynnsWardApplied(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "Positive", "Info")
	end
end

do
	local lightList, felList = {}, {}

	function mod:FelInfusion(args)
		felList[#felList+1] = args.destName
		if 	self:GetOption("custom_on_infusion_plates") then
			self:AddPlate(args.spellId, args.destName)
		end
		if self:Me(args.destGUID) then
			self:TargetMessage(args.spellId, args.destName, "Personal", "Alert")
			self:Flash(args.spellId)
			self:Say(args.spellId)
			self:OpenProximity(args.spellId, 5, lightList) -- Avoid people with Light debuff
		end
	end

	function mod:LightInfusion(args)
		lightList[#lightList+1] = args.destName
		if 	self:GetOption("custom_on_infusion_plates") then
			self:AddPlate(args.spellId, args.destName)
		end
		if self:Me(args.destGUID) then
			self:TargetMessage(args.spellId, args.destName, "Personal", "Alert")
			self:Flash(args.spellId)
			self:Say(args.spellId)
			self:OpenProximity(args.spellId, 5, felList) -- Avoid people with Fel debuff
		end
	end

	function mod:FelInfusionRemoved(args)
		if self:Me(args.destGUID) then
			self:CloseProximity(args.spellId)
		end
		if 	self:GetOption("custom_on_infusion_plates") then
			self:RemovePlate(args.spellId, args.destName)
		end
		tDeleteItem(felList, args.destName)
	end

	function mod:LightInfusionRemoved(args)
		if self:Me(args.destGUID) then
			self:CloseProximity(args.spellId)
		end
		if 	self:GetOption("custom_on_infusion_plates") then
			self:RemovePlate(args.spellId, args.destName)
		end
		tDeleteItem(lightList, args.destName)
	end
end

function mod:HammerofCreation(args)
	self:Message(args.spellId, "Urgent", "Alert", args.spellName)
	--self:Bar(args.spellId, 10)
end

function mod:HammerofObliteration(args)
	self:Message(args.spellId, "Urgent", "Alert", args.spellName)
	--self:Bar(args.spellId, 10)
end

function mod:MassInstability(args)
	self:Message(args.spellId, "Important", "Warning", args.spellName)
	--self:Bar(args.spellId, 10)
end

function mod:Blowback(args)
	self:Message(args.spellId, "Attention", "Info", args.spellName)
end

function mod:TitanicBulwark(args)
	self:Message(args.spellId, "Important", "Warning", CL.casting:format(args.spellName))
	--self:Bar(args.spellId, 10)
end

function mod:TitanicBulwarkApplied(args)
	shieldActive = true
end

function mod:TitanicBulwarkRemoved(args)
	shieldActive = false
	self:Message(args.spellId, "Positive", "Info", CL.removed:format(args.spellName))
end

function mod:WrathoftheCreators(args)
	if self:Interrupter(args.sourceGUID) and not shieldActive then
		self:Message(args.spellId, "Important", "Alert")
	end
end
