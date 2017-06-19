
--------------------------------------------------------------------------------
-- TODO: REMEMBER TO UNCOMMENT THE MODULE IN modules.xml!
-- TODO: REMEMBER TO UNCOMMENT THE MODULE IN modules.xml!
-- TODO: REMEMBER TO UNCOMMENT THE MODULE IN modules.xml!
--

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Tomb of Sargeras Trash", 1147)
if not mod then return end
mod.displayName = CL.trash
mod:RegisterEnableMob(
	--[[ Pre Goroth ]]--

	--[[ Goroth -> Demonic Inquisition ]]--

	--[[ Goroth -> Harjatan ]]--

	--[[ Goroth -> Sisters of the Moon ]]--

	--[[ Harjatan -> Mistress Sassz'ine ]]--

	--[[ Sisters of the Moon -> The Desolate Host ]]--

	--[[ Pre Maiden of Vigilance ]]--

	--[[ Maiden of Vigilance -> Fallen Avatar ]]--

	--[[ Fallen Avatar -> Kil'jaeden ]]--

)

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	--
end

--------------------------------------------------------------------------------
-- Initialization
--
function mod:GetOptions()
	return {
		--[[ Pre Goroth ]]--

		--[[ Goroth -> Demonic Inquisition ]]--

		--[[ Goroth -> Harjatan ]]--

		--[[ Goroth -> Sisters of the Moon ]]--

		--[[ Harjatan -> Mistress Sassz'ine ]]--

		--[[ Sisters of the Moon -> The Desolate Host ]]--

		--[[ Pre Maiden of Vigilance ]]--

		--[[ Maiden of Vigilance -> Fallen Avatar ]]--

		--[[ Fallen Avatar -> Kil'jaeden ]]--

	}, {
		--[] = ,
	}
end

function mod:OnBossEnable()
	--[[ General ]]--
	self:RegisterMessage("BigWigs_OnBossEngage", "Disable")
	--self:Log("SPELL_AURA_APPLIED", "GroundEffectDamage", ) --
	--self:Log("SPELL_PERIODIC_DAMAGE", "GroundEffectDamage", )
	--self:Log("SPELL_PERIODIC_MISSED", "GroundEffectDamage", )
	--self:Log("SPELL_DAMAGE", "GroundEffectDamage", ) --
	--self:Log("SPELL_MISSED", "GroundEffectDamage", )

	--[[ Pre Goroth ]]--


	--[[ Goroth -> Demonic Inquisition ]]--


	--[[ Goroth -> Harjatan ]]--


	--[[ Goroth -> Sisters of the Moon ]]--


	--[[ Harjatan -> Mistress Sassz'ine ]]--


	--[[ Sisters of the Moon -> The Desolate Host ]]--


	--[[ Pre Maiden of Vigilance ]]--


	--[[ Maiden of Vigilance -> Fallen Avatar ]]--


	--[[ Fallen Avatar -> Kil'jaeden ]]--

end

--------------------------------------------------------------------------------
-- Event Handlers
--

--[[ General ]]--
do
	local prev = 0
	function mod:GroundEffectDamage(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 1.5 then
			prev = t
			self:Message(args.spellId, "Personal", "Alert", CL.underyou:format(args.spellName))
		end
	end
end

--[[ Pre Goroth ]]--


--[[ Goroth -> Demonic Inquisition ]]--


--[[ Goroth -> Harjatan ]]--


--[[ Goroth -> Sisters of the Moon ]]--


--[[ Harjatan -> Mistress Sassz'ine ]]--


--[[ Sisters of the Moon -> The Desolate Host ]]--


--[[ Pre Maiden of Vigilance ]]--


--[[ Maiden of Vigilance -> Fallen Avatar ]]--


--[[ Fallen Avatar -> Kil'jaeden ]]--
