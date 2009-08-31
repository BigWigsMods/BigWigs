local L = LibStub("AceLocale-3.0"):NewLocale("BigWigs", "esES")

if not L then return end

-- Core.lua
L["%s has been defeated"] = "%s ha sido derrotado"     -- "<boss> has been defeated"
L["%s have been defeated"] = "%s han sido derrotados"    -- "<bosses> have been defeated"

L["Bosses"] = "Jefes"
L["Options for bosses in %s."] = "Opciones para jefes de %s." -- "Options for bosses in <zone>"
L["Options for %s (r%d)."] = "Opciones para %s (r%d)."     -- "Options for <boss> (<revision>)"
L["Plugins"] = "Plugins"
L["Plugins handle the core features of Big Wigs - like displaying messages, timer bars, and other essential features."] = "Los plugins administran las características de BigWigs sobre cómo mostrar mensajes, barras de tiempo y otras características esenciales."
L["Extras"] = "Extras"
L["Extras are 3rd party and bundled plugins that Big Wigs will function properly without."] = "Extras son utilidades y plugins de terceros. BigWigs puede funcionar con o sin ellos."
L["Active"] = "Activo"
L["Activate or deactivate this module."] = "Activa o desactiva este módulo."
L["Reboot"] = "Reiniciar"
L["Reboot this module."] = "Reiniciar el módulo."
L["Options"] = "Opciones"

L.bosskill = "Derrota del jefe"
L.bosskill_desc = "Avisa cuando el jefe ha sido derrotado."
L.enrage = "Enfurecer (Enrage)"
L.enrage_desc = "Avisa cuando el jefe entra en un estado enfurecido."
L.berserk = "Rabia (Berserk)"
L.berserk_desc = "Avisa cuando el jefe entra en un estado rabioso."

L["Load"] = "Cargar"
L["Load All"] = "Cargar todo"
L["Load all %s modules."] = "Cargar todos los módulos de %s."


-- Options.lua
L["|cff00ff00Module running|r"] = "|cff00ff00Módulo activo|r"
L["|cffeda55fClick|r to reset all running modules. |cffeda55fAlt-Click|r to disable them."] = "|cffeda55fClic|r para reiniciar los módulos activos.|n|cffeda55fAlt+Clic|r para desactivarlos.|n|cffeda55fCtrl-Alt+Clic|r para desactivar por completo BigWigs.|n"
L["Active boss modules:"] = "Módulos de jefe activos :"
L["All running modules have been reset."] = "Todos los módulos activos han sido reiniciados."
L["Menu"] = "Menú"
L["Menu options."] = "Opciones del menú."

-- Prototype.lua common words
L.you = "%s on YOU"
L.other = "%1$s on %2$s"

L.phase = "Phase %d"

L.enrage_start = "%s Iniciado - Enfurecimiento en %d min"
L.enrage_end = "%s Enfurecido"
L.enrage_min = "Enfurecimiento en %d min"
L.enrage_sec = "Enfurecimiento en %d seg"
L.enrage = "Enfurecer"

L.berserk_start = "%s Iniciado - Rabia en %d min"
L.berserk_end = "%s entra en Rabia"
L.berserk_min = "Rabia en %d min"
L.berserk_sec = "Rabia en %d seg"
L.berserk = "Rabia"


