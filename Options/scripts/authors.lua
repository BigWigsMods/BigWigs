--
-- HOW TO USE THE SCRIPT
--
-- Note that you need the liblua5.1-expat0 library for this script to work.
-- (or at least the lxp lua module, but I haven't tested it with 5.0 or earlier)
--
-- 1. svn log --xml svn://svn.wowace.com/wow/big-wigs/mainline > svn-log.xml
-- 2. remove "<?xml version="1.0" encoding="UTF-8"?>" from the top of the xml file
-- 2. lua authors.lua [OR] dofile(".\\authors.lua")
-- 3. rm svn-log.xml
-- 4. copy newly generated author-list.lua file
--

require("lxp")
local file = assert(io.open("svn-log.xml", "r"))
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

-- Remove authors, we don't need to be listed twice!
numberOfCommits.funkydude = nil
numberOfCommits.nebula169 = nil


-- Maat has two logins
numberOfCommits.Maat = numberOfCommits.maat + numberOfCommits.Maat
numberOfCommits.maat = nil
-- Wetxius has two logins
numberOfCommits.Wetxius = numberOfCommits.Wetxius + numberOfCommits.wetxius
numberOfCommits.wetxius = nil
-- MysticalOS has two logins
numberOfCommits.MysticalOS = numberOfCommits.MysticalOS + numberOfCommits.mysticalos
numberOfCommits.mysticalos = nil
-- Merge Gnarfoz's old login
numberOfCommits.gnarfoz = numberOfCommits.gnarfoz + numberOfCommits["8timer"]
numberOfCommits["8timer"] = nil

local sorted = {}
for k, v in next, numberOfCommits do
	if v > 2 then sorted[#sorted + 1] = k end
end
table.sort(sorted, function(a, b) return numberOfCommits[a] > numberOfCommits[b] end)

local output = assert(io.open("author-list.lua", "w"))
output:write("local BIGWIGS_AUTHORS = \"")
output:write(table.concat(sorted, ", "))
output:write(".\"\n")
output:close()

