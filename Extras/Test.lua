local plugin = BigWigs:New("Test", "$Revision$")
if not plugin then return end
plugin.external = true
local spells = nil
local colors = {"Important", "Personal", "Urgent", "Attention", "Positive", "Bosskill", "Core"}
local sounds = {"Long", "Info", "Alert", "Alarm", "Victory", false, false, false, false, false, false}
local messageFormat = "%s: %s"

function plugin:OnEnable()
	self:RegisterEvent("BigWigs_Test")
end

function plugin:BigWigs_Test()
	if not spells then
		spells = {}
		for i = 2, MAX_SKILLLINE_TABS do
			local _, _, offset, numSpells = GetSpellTabInfo(i)
			if not offset then break end
			for s = offset + 1, offset + numSpells do
				local spell = GetSpellName(s, BOOKTYPE_SPELL)
				tinsert(spells, spell)
			end
		end
	end
	local spell = spells[math.random(1, #spells)]
	local name, rank, icon = GetSpellInfo(spell)
	local time = math.random(11, 45)
	local color = colors[math.random(1, #colors)]
	local sound = sounds[math.random(1, #sounds)]
	self:TriggerEvent("BigWigs_StartBar", self, name, time, icon)
	self:DelayedMessage(time, messageFormat:format(color, name), color, true, sound, nil, icon)
end

