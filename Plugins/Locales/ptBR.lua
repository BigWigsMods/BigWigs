local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Plugins", "ptBR")
if not L then return end

-----------------------------------------------------------------------
-- Bars.lua
--

L["Style"] = "Estilo"
L.bigWigsBarStyleName_Default = "Padrão"

L["Clickable Bars"] = "Barras clicaveis"
L.clickableBarsDesc = "As barras do Big Wigs são clicaveis por padrão. Desta forma você pode mirar em objetos e lançar feitiços AoE atrás deles, trocar o ângulo da câmera, e assim sucessivamente, sem precisar do cursor estar em cima das barras. |cffff4411Se habilitar as barras clicaveis, isto deixará de funcionar.|r as barras interceptarão qualquer clique do mouse que chegar a elas.\n"
L["Enables bars to receive mouse clicks."] = "Ativa as barras para receber cliques do mouse"
L["Modifier"] = "Modificação"
L["Hold down the selected modifier key to enable click actions on the timer bars."] = "Segure a tecla de modificação selecionada para ativar ações de cliques nas barras de tempo."
L["Only with modifier key"] = "Somente com uma tecla de modificação"
L["Allows bars to be click-through unless the specified modifier key is held down, at which point the mouse actions described below will be available."] = "Permite que as barras sejão clicaveis se estiver com a tecla de modificação pressionada, deste jeito as ações do mouse descritas abaixo estarão disponíveis."

L["Temporarily Super Emphasizes the bar and any messages associated with it for the duration."] = "Temporariamente Super Enfatiza a barra e as mensagens associadas para a duração."
L["Report"] = "Reportar"
--L["Reports the current bars status to the active group chat; either instance chat, raid, party or say, as appropriate."] = "Reports the current bars status to the active group chat; either instance chat, raid, party or say, as appropriate."
L["Remove"] = "Remover"
L["Temporarily removes the bar and all associated messages."] = "Temporariamente fecha a barra e todas as mensagens associadas"
L["Remove other"] = "Remover outro"
L["Temporarily removes all other bars (except this one) and associated messages."] = "Temporariamente fecha todas as barras (exceto esta) e as mensagens associadas."
L.disable = "Desativar"
L["Permanently disables the boss encounter ability option that spawned this bar."] = "Desativa permanentemente a habilidade de encontro para que não de opção de que reapareça esta barra"

--L["Emphasize at... (seconds)"] = "Emphasize at... (seconds)"
L["Scale"] = "Escala"
L["Grow upwards"] = "Aumentar crescentemente"
L["Toggle bars grow upwards/downwards from anchor."] = "Alterna entre aumentar as barras crescentemente/decrescentemente des do encaixe."
L["Texture"] = "Textura"
L["Emphasize"] = "Enfatizar"
L["Enable"] = "Habilitar"
L["Move"] = "Mover"
--L.moveDesc = "Moves emphasized bars to the Emphasize anchor. If this option is off, emphasized bars will simply change scale and color."
L["Regular bars"] = "Barras regulares"
L["Emphasized bars"] = "Barras enfatizadas"
L["Align"] = "Alinhação"
L["Left"] = "Esquerda"
L["Center"] = "Centro"
L["Right"] = "Direita"
L["Time"] = "Tempo"
L["Whether to show or hide the time left on the bars."] = "Oculta ou mostra o tempo restante nas barras."
L["Icon"] = "Icono"
L["Shows or hides the bar icons."] = "Mostra ou oculta os icones das barras."
L.font = "Fonte"
L["Restart"] = "Reiniciar"
L["Restarts emphasized bars so they start from the beginning and count from 10."] = "Reinicia as barras enfatizadas para que comecem desde o principio e conta desde 10."
L["Fill"] = "Completar"
L["Fills the bars up instead of draining them."] = "Completa as barras ao envés de drenar."

L["Local"] = "Local"
L["%s: Timer [%s] finished."] = "%s: Contador [%s] terminado."



-- These localization strings are translated on WoWAce: http://www.wowace.com/addons/big-wigs/localization/
--@localization(locale="ptBR", namespace="Plugins", format="lua_additive_table", handle-unlocalized="ignore")@

