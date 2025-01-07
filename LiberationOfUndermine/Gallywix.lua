if not BigWigsLoader.isTestBuild then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Chrome King Gallywix", 2769, 2646)
if not mod then return end
-- mod:RegisterEnableMob(0)
mod:SetEncounterID(3016)
mod:SetRespawnTime(30)

--------------------------------------------------------------------------------
-- Locals
--

--------------------------------------------------------------------------------
-- Localization
--

-- local L = mod:GetLocale()
-- if L then
-- end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"stages",
	},{ -- Sections

	},{ -- Renames

	}
end

function mod:OnRegister()
	--self:SetSpellRename(999999, CL.renameMe) -- Spell (Rename)
end

function mod:OnBossEnable()

end

function mod:OnEngage()
	self:Message("stages", "yellow", "Dummy Message", false)
end

--------------------------------------------------------------------------------
-- Event Handlers
--
