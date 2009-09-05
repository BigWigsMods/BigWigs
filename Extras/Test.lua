local plugin = BigWigs:NewPlugin("Test", "$Revision$")
if not plugin then return end
plugin.external = true
local spells = nil
local colors = {"Important", "Personal", "Urgent", "Attention", "Positive", "Bosskill", "Core"}
local sounds = {"Long", "Info", "Alert", "Alarm", "Victory", false, false, false, false, false, false}
local messageFormat = "%s: %s"

function plugin:OnPluginEnable()
	self:RegisterMessage("BigWigs_Test")
end

local tests = {}

function plugin:SendTestMessage( message )
	if tests[message] then
		self:SendMessage( unpack(tests[message]) )
		wipe(tests[message])
	end
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
	local name, rank, icon = GetSpellInfo(spell.."()")
	local time = math.random(11, 45)
	local color = colors[math.random(1, #colors)]
	local sound = sounds[math.random(1, #sounds)]
	self:SendMessage("BigWigs_StartBar", self, name, time, icon)
	-- FIXME: ScheduleTimer only allows for one argument
	tests[messageFormat:format(color, name)] = { "BigWigs_Message", messageFormat:format(color, name), color, true, sound, nil, icon }
	self:ScheduleTimer("SendTestMessage", time, messageFormat:format(color, name) )
end

