--
-- HOW TO USE THE SCRIPT
--
-- Note that you need the liblua5.1-expat0 library for this script to work.
-- (or at least the lxp lua module, but I haven't tested it with 5.0 or earlier)
--
-- 1. svn log --xml svn://svn.wowace.com/wow/big-wigs/mainline > svn-log.xml
-- 2. lua authors.lua svn-log.xml ../author-list.lua
-- 3. rm svn-log.xml
--

require("lxp")
local file = assert(io.open(arg[1], "r"))
if not file then return end
local data = file:read("*all")

local grab = nil
local numberOfCommits = {}
local callback = {
	StartElement = function(parser, name, attributes)
		grab = (name == "author")
	end,
	Default = function(parser, author)
		if grab then
			if not numberOfCommits[author] then
				numberOfCommits[author] = 1
			else
				numberOfCommits[author] = numberOfCommits[author] + 1
			end
		end
	end,
	EndElement = function(parser)
		grab = nil
	end,
}
local p = lxp.new(callback)
p:parse(data)
p:close()

-- We don't recognize roots efforts! Muhaha!
numberOfCommits.root = nil
-- Remove ourselves, we don't need to be listed twice!
numberOfCommits.rabbit = nil
numberOfCommits.ammo = nil
numberOfCommits.funkydude = nil

local uniqueAuthors = {}
for k, v in pairs(numberOfCommits) do
	if v > 2 then uniqueAuthors[#uniqueAuthors + 1] = k end
end
table.sort(uniqueAuthors, function(a, b) return numberOfCommits[a] > numberOfCommits[b] end)

local output = assert(io.open(arg[2], "w"))
output:write("_G.BIGWIGS_AUTHORS = \"")
output:write(table.concat(uniqueAuthors, ", "))
output:write(".\"\n")
output:close()

