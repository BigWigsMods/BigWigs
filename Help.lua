_G["SlashCmdList"]["BWHELP"] = function(msg)
	msg = string.lower(msg)
	if msg == "what" then
		BigWigs:Print("We need logs of boss encounters, see http://www.wowace.com/forums/index.php?topic=12106")
	elseif msg == "how" then
		BigWigs:Print("Type /combatlog before starting a boss, then again after you kill it. Then type /rl and post a log on the forum post. See [/bwhelp what] for more info.")
	elseif msg == "why" then
		BigWigs:Print("The 2.4 patch completely changed the combat log system which means every single BigWigs module had to be re-written.")
	else
		BigWigs:Print("Commands are /bwhelp [what, how, why]")
	end
end
_G["SLASH_BWHELP1"] = "/bwhelp"