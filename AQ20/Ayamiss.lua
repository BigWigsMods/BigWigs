BigWigsAyamiss = AceAddon:new({
	name          = "BigWigsAyamiss",
	cmd           = AceChatCmd:new({}, {}),

	zonename = "AQ20",
	enabletrigger = "Ayamiss the Hunter",

	loc = {
		bossname = "Ayamiss the Hunter",
		disabletrigger = "Ayamiss the Hunter dies.",
		bosskill = "Ayamiss the Hunter has been defeated.",

		sacrificetrigger = "^([^%s]+) ([^%s]+) afflicted by Paralyze",
		sacrificewarn = " is being Sacrificed!",
		you = "You",
	},
})


function BigWigsAyamiss:Initialize()
    self.disabled = true
    BigWigs:RegisterModule(self)
end

function BigWigsAyamiss:Enable()
	self.disabled = nil
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH" )
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE","checkSacrifice")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE","checkSacrifice")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE","checkSacrifice")
end


function BigWigsAyamiss:Disable()
	self.disabled = true
	self:UnregisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH" )
	self:UnregisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE")
	self:UnregisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE")
	self:UnregisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE")
end

function BigWigsAyamiss:checkSacrifice()
	if( arg1 and arg1 ~= nil ) then
		local _, _, player, isare = string.find(arg1, self.loc.sacrificetrigger);
		if( player and isare  ) then	
			local text = ""
			if( player == self.loc.you ) then
				text = UnitName("player")
			else
				text = player
			end
			text = text .. self.loc.sacrificewarn
			self:TriggerEvent("BIGWIGS_MESSAGE", text, "Red")
		end
	end
end

function BigWigsAyamiss:CHAT_MSG_COMBAT_HOSTILE_DEATH()
	if ( arg1 == self.loc.disabletrigger ) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green")
		self:Disable()
	end
end


--------------------------------
--			Load this bitch!			--
--------------------------------
BigWigsAyamiss:RegisterForLoad()
