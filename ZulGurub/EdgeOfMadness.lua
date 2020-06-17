
--------------------------------------------------------------------------------
-- Module declaration
--

local mod = BigWigs:NewBoss("Edge of Madness", 309)
if not mod then return end
mod:RegisterEnableMob(15082, 15083, 15084, 15085) -- Gri'lek, Hazza'rah, Renataki, Wushoolay
mod:SetAllowWin(true)
mod.engageId = 788

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.bossName = "Edge of Madness"
	L.grilek = "Gri'lek"
	L.hazzarah = "Hazza'rah"
	L.renataki = "Renataki"
	L.wushoolay = "Wushoolay"

end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		24646, -- Avatar (Gri'lek)
		24729, -- Summon Nightmare Illusions (Hazza'rah)
		24699, -- Vanish (Renataki)
		26550, -- Lightning Cloud (Wushoolay)
	}, {
		[24646] = L.grilek,
		[24729] = L.hazzarah,
		[24699] = L.renataki,
		[26550] = L.wushoolay,
	}
end

function mod:OnRegister()
	self.displayName = L.bossName
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "Avatar", 24646)
	self:Log("SPELL_CAST_SUCCESS", "Vanish", 24699)
	self:Log("SPELL_SUMMON", "NightmareIllusions", 24729)
	self:Log("SPELL_CAST_SUCCESS", "LightningCloud", 26550)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Avatar(args)
	self:Message2(24646, "orange")
	self:PlaySound(24646, "alarm")
end

function mod:Vanish(args)
	self:Message2(24699, "orange")
	self:PlaySound(24699, "alert")
end

function mod:NightmareIllusions(args)
	self:Message2(24729, "orange")
	self:PlaySound(24729, "alarm")
end

function mod:LightningCloud(args)
	self:Message2(26550, "yellow")
	self:PlaySound(26550, "info")
end
