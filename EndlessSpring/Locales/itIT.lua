
local L = BigWigs:NewBossLocale("Protectors of the Endless", "itIT")
if not L then return end
if L then
	L.under = "%s sotto %s!"
	L.heal = "%s cura"
end

L = BigWigs:NewBossLocale("Tsulong", "itIT")
if L then
	L.engage_yell = " Questo non è il vostro posto! Le acque devono essere protette... vi allontanerò o vi ucciderò!"
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

	L.custom_off_addmarker = "Marcatore Protettori"
	L.custom_off_addmarker_desc = "Marca i Protettori Rianimati durante la Protezione di Lei Shi, richiede capogruppo o assistente.\n|cFFFF0000Solo 1 persona nell'incursione dovrebbe attivare questa opzione per evitare conflitti di marcamento.|r\n|cFFADFF2FTIP: Se l'incursione ha scelto te attivalo, e muovi velocemente il mouse sopra OGNI Protettore per marcarli più velocemente possibile.|r"
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

	L.strike_or_spout = "Assalto o Manifestazione"
	L.huddle_or_spout_or_strike = "Ammasso o Manifestazione o Assalto"

	L.custom_off_huddle = "Marcatore Ammasso di Terrore"
	L.custom_off_huddle_desc = "Per aiutare l'assegnazione delle cure, evidenzia i giocatori che hanno Ammasso di Terrore con {rt1}{rt2}{rt3}{rt4}{rt5}{rt6}, richiede capo incursione o assistente."
end

