
local L = BigWigs:NewBossLocale("Protectors of the Endless", "itIT")
if not L then return end
if L then
	L.under = "%s sotto %s!"
	L.heal = "%s cura"
end

L = BigWigs:NewBossLocale("Tsulong", "itIT")
if L then
	L.engage_yell = " Questo non è il vostro posto! Le acque devono essere protette... vi allontanerò... o vi ucciderò!"
	L.kill_yell = "Grazie, stranieri. Sono stato liberato."

	L.phases = "Fasi"
	L.phases_desc = "Avviso per cambio di fase."

	L.sunbeam_spawn = "Nuovo Raggio di Sole!"
end

L = BigWigs:NewBossLocale("Lei Shi", "itIT")
if L then
	L.hp_to_go = "%d%% alla fine"

	L.special = "Prossima abilità speciale"
	L.special_desc = "Avviso per prossima abilità speciale"
end

L = BigWigs:NewBossLocale("Sha of Fear", "itIT")
if L then
	L.fading_soon = "%s si dissolve tra poco"

	L.swing = "Colpo"
	L.swing_desc = "Conta i colpi che precedono Falciata."

	L.throw = "Lancio!"
	L.ball_dropped = "Globo rilasciato!"
	L.ball_you = "Hai il Globo!"
	L.ball = "Globo"

	L.cooldown_reset = "I tempi di recupero delle tue abilità sono stati reimpostati!"

	L.ability_cd = "Recupero delle abilità"
	L.ability_cd_desc = "Mostra la successiva possibile (o possibili) abilità."

	--L.huddle_or_spout = "Ammasso o Manifestazione" There isnt anymore this entry into boss file, commented out
	--L.huddle_or_strike = "Ammasso o Assalto" There isnt anymore this entry into boss file, commented out
	L.strike_or_spout = "Assalto o Manifestazione"
	L.huddle_or_spout_or_strike = "Ammasso o Manifestazione o Assalto"
end

