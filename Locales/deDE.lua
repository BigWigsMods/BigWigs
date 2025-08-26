local _, addonTbl = ...
local L = addonTbl.API:NewLocale("BigWigs", "deDE")
if not L then return end

-- API.lua
L.showAddonBar = "Das Addon '%s' hat die Leiste '%s' erstellt."

-- Core.lua
L.berserk = "Berserker"
L.berserk_desc = "Warnt, wenn der Boss zum Berserker wird."
L.altpower = "Anzeige alternativer Energien"
L.altpower_desc = "Zeigt ein Fenster mit alternativen Energien der einzelnen Gruppenmitglieder."
L.infobox = "Informationsbox"
L.infobox_desc = "Zeigt eine Box mit Informationen zur Bossbegegnung an"
L.stages = "Phasen"
L.stages_desc = "Funktionen für bestimmte Phasen von Bossbegegnungen wie Warnungen zum Phasenwechsel, Leisten für die Phasendauer, etc. aktivieren."
L.warmup = "Bosskampf beginnt"
L.warmup_desc = "Verbleibende Zeit bis zum Start der Bossbegegnung."
L.proximity = "Näherungsanzeige"
L.proximity_desc = "Zeigt, falls für diese Begegnung relevant, das Näherungsfenster an. Es listet alle Spieler auf, die Dir zu nahe stehen."
L.adds = "Adds"
L.adds_desc = "Aktiviert Funktionen für die verschiedenen Adds, die während der Bossbegegnung erscheinen."
L.health = "Gesundheit"
L.health_desc = "Aktiviert Funktionen für die Anzeige verschiedener Gesundheits-Informationen während der Bossbegegnung."
L.energy = "Energie"
L.energy_desc = "Aktiviert Funktionen für die Anzeige von Informationen über die verschiedenen Energielevel während der Bossbegegnung."

L.already_registered = "|cffff0000WARNUNG:|r |cff00ff00%s|r (|cffffff00%s|r) existiert bereits als Modul in BigWigs, aber irgend etwas versucht es erneut anzumelden. Dies bedeutet normalerweise, dass Du zwei Kopien des Moduls aufgrund eines Fehlers beim Aktualisieren in Deinem Addon-Ordner hast. Es wird empfohlen, jegliche BigWigs-Ordner zu löschen und dann von Grund auf neu zu installieren."

-- Loader / Options.lua
L.okay = "OK"
L.officialRelease = "Bei dir läuft ein offizieller Release von BigWigs %s (%s)."
L.alphaRelease = "Bei dir läuft ein ALPHA RELEASE von BigWigs %s (%s)."
L.sourceCheckout = "Bei dir läuft ein Source Code Checkout von BigWigs %s direkt aus dem Repository."
L.littlewigsOfficialRelease = "Bei dir läuft ein offizieller Release von LittleWigs (%s)."
L.littlewigsAlphaRelease = "Bei dir läuft ein ALPHA RELEASE von LittleWigs (%s)."
L.littlewigsSourceCheckout = "Bei dir läuft ein Source Code Checkout von LittleWigs direkt aus dem Repository."
L.guildRelease = "Du nutzt Version %d von BigWigs für Deine Gilde, basierend auf Version %d des offiziellen Addons."
L.getNewRelease = "Dein BigWigs ist veraltet (/bwv), aber Du kannst es mit Hilfe des CurseForge Clients einfach aktualisieren. Alternativ kannst Du es auch von curseforge.com oder addons.wago.io herunterladen und manuell aktualisieren."
L.warnTwoReleases = "Dein BigWigs ist 2 Versionen älter als die neueste Version! Deine Version könnte Fehler, fehlende Funktionen oder völlig falsche Timer beinhalten. Es wird dringend empfohlen, BigWigs zu aktualisieren."
L.warnSeveralReleases = "|cffff0000Dein BigWigs ist um %d Versionen veraltet!! Wir empfehlen Dir DRINGEND, BigWigs zu aktualisieren, um Synchronisationsprobleme zwischen Dir und anderen Spielern zu verhindern!|r"
L.warnOldBase = "Du nutzt eine Gildenversion von BigWigs (%d), aber die Basisversion (%d) ist seit %d Veröffentlichungen veraltet. Dies kann zu Problemen führen."

L.tooltipHint = "|cffeda55fRechtsklick|r, um auf die Optionen zuzugreifen."
L.activeBossModules = "Aktive Bossmodule:"

L.oldVersionsInGroup = "Es gibt Spieler in Deiner Gruppe mit |cffff0000veralteten Versionen|r von BigWigs. Mehr Details mit /bwv."
L.upToDate = "Aktuell:"
L.outOfDate = "Veraltet:"
L.dbmUsers = "DBM-Nutzer:"
L.noBossMod = "Kein Bossmod:"
L.offline = "Offline"

L.missingAddOnPopup = "Das |cFF436EEE%s|r Addon fehlt!"
L.missingAddOnRaidWarning = "Das |cFF436EEE%s|r Addon fehlt! In dieser Zone werden keine Timer angezeigt!"
L.outOfDateAddOnPopup = "Das |cFF436EEE%s|r Addon ist veraltet!"
L.outOfDateAddOnRaidWarning = "Das |cFF436EEE%s|r Addon ist veraltet! Du nutzt v%d.%d.%d doch aktuell ist v%d.%d.%d!"
L.disabledAddOn = "Du hast das Addon |cFF436EEE%s|r deaktiviert, Timer werden nicht angezeigt."
L.removeAddOn = "Bitte entferne '|cFF436EEE%s|r', da es durch '|cFF436EEE%s|r' ersetzt wurde."
L.alternativeName = "%s (|cFF436EEE%s|r)"
L.outOfDateContentPopup = "WARNUNG!\nDu hast |cFF436EEE%s|r aktualisiert, aber Du musst auch das Haupt |cFF436EEEBigWigs|r Addon aktualisieren.\nAndernfalls wird die Funktionalität eingeschränkt sein."
L.outOfDateContentRaidWarning = "|cFF436EEE%s|r benötigt Version %d des Haupt |cFF436EEEBigWigs|r Addons zur korrekten Funktion, allerdings hast Du Version %d."
L.addOnLoadFailedWithReason = "BigWigs konnte das Addon |cFF436EEE%s|r nicht laden wegen %q. Bitte den Entwicklern melden!"
L.addOnLoadFailedUnknownError = "BigWigs hat einen Fehler beim Laden des Addons |cFF436EEE%s|r verursacht. Bitte den Entwicklern melden!"

L.expansionNames = {
	"Classic", -- Classic
	"The Burning Crusade", -- The Burning Crusade
	"Wrath of the Lich King", -- Wrath of the Lich King
	"Cataclysm", -- Cataclysm
	"Mists of Pandaria", -- Mists of Pandaria
	"Warlords of Draenor", -- Warlords of Draenor
	"Legion", -- Legion
	"Battle for Azeroth", -- Battle for Azeroth
	"Schattenlande", -- Shadowlands
	"Dragonflight", -- Dragonflight
	"The War Within", -- The War Within
}
L.littleWigsExtras = {
	["LittleWigs_Delves"] = "Tiefen",
	["LittleWigs_CurrentSeason"] = "Aktuelle Saison",
}

-- Media.lua (These are the names of the sounds in the dropdown list in the "sounds" section)
L.Beware = "Hütet Euch (Algalon)"
L.FlagTaken = "Flagge aufgenommen (PvP)"
L.Destruction = "Zerstörung (Kil'jaeden)"
L.RunAway = "Lauf kleines Mädchen, lauf (Der große böse Wolf)"
L.spell_on_you = "BigWigs: Zauber auf Dir"
L.spell_under_you = "BigWigs: Zauber unter Dir"
L.simple_no_voice = "Einfach (Keine Stimme)"

-- Options.lua
L.options = "Optionen"
L.optionsKey = "ID: %s" -- The ID that messages/bars/options use
L.raidBosses = "Schlachtzugsbosse"
L.dungeonBosses = "Dungeonbosse"
L.introduction = "Willkommen bei BigWigs, dort, wo die Bossbegegnungen rumschwirren. Bitte legen Sie Ihren Sicherheitsgurt an, stellen Sie die Rückenlehne gerade und genießen Sie den Flug. Wir werden Ihnen und Ihrer Raidgruppe bei der Begegnung mit Bossen zur Hand gehen und sie Ihnen als 7-Gänge-Menü zubereiten."
L.sound = "Sound"
L.minimapIcon = "Minikartensymbol"
L.minimapToggle = "Zeigt oder versteckt das Minikartensymbol."
L.compartmentMenu = "Kein Addonmenü Icon"
L.compartmentMenu_desc = "Durch Deaktivieren dieser Option wird BigWigs im Addons Menü an der Minimap angezeigt. Wir empfehlen, diese Option aktiviert zu lassen."
L.configure = "Einstellungen"
L.resetPositions = "Positionen zurücksetzen"
L.selectEncounter = "Wähle Begegnung"
L.privateAuraSounds = "Private Aurasounds"
L.privateAuraSounds_desc = "Private Auren können nicht normal verfolgt werden, aber es kann ein wiederzugebender Sound festgelegt werden, wenn Du von der Fähigkeit betroffen bist."
L.listAbilities = "Fähigkeiten im Chat auflisten"

L.dbmFaker = "Täusche DBM Nutzung vor"
L.dbmFakerDesc = "Wenn ein DBM-Nutzer eine Versionskontrolle ausführt erscheinst Du in der Liste. Nützlich für Gilden die auf DBM bestehen."
L.zoneMessages = "Gebietsmeldungen anzeigen"
L.zoneMessagesDesc = "Wenn Du diese Option deaktivierst, zeigt BigWigs beim Betreten von Gebieten ohne installierte Bossmods keine Meldungen mehr an. Es wird empfohlen, diese Option aktiviert zu lassen, da sie über neu erstellte Timer für neue Gebiete informiert."
L.englishSayMessages = "Sprechblasen immer auf Englisch senden"
L.englishSayMessagesDesc = "Alle 'Sagen' und 'Schreien' Nachrichten, welche Du während eines Bosskampfes sendest, werden immer auf Englisch ausgegeben. Kann in Gruppen mit Spielern verschiedener Sprachen nützlich sein."

L.slashDescTitle = "|cFFFED000Slash-Befehle:|r"
L.slashDescPull = "|cFFFED000/pull:|r Sendet einen Countdown zum Pull an den Raid."
L.slashDescBreak = "|cFFFED000/break:|r Sendet einen Pausentimer an den Schlachtzug."
L.slashDescRaidBar = "|cFFFED000/raidbar:|r Sendet eine benutzerdefinierte Leiste an den Raid."
L.slashDescLocalBar = "|cFFFED000/localbar:|r Erstellt eine benutzerdefinierte Leiste, welche nur Du sehen kannst."
L.slashDescRange = "|cFFFED000/range:|r Öffnet die Näherungsanzeige."
L.slashDescVersion = "|cFFFED000/bwv:|r Führt einen BigWigs Versionscheck durch."
L.slashDescConfig = "|cFFFED000/bw:|r Öffnet die BigWigs Konfiguration."

L.gitHubDesc = "|cFF33FF99BigWigs ist Open-Source-Software auf GitHub. Wir sind immer auf der Suche nach neuen Menschen, die uns helfen, und jeder ist willkommen, unseren Code zu inspizieren, Beiträge zu leisten und Fehlerberichte einzureichen. BigWigs ist hauptsächlich durch die großartige WoW-Gemeinschaft im Laufe der Zeit zu etwas Großem geworden.|r"

L.BAR = "Leisten"
L.MESSAGE = "Nachrichten"
L.ICON = "Symbole"
L.SAY = "Sagen"
L.FLASH = "Aufleuchten"
L.EMPHASIZE = "Hervorheben"
L.ME_ONLY = "Nur anzeigen, wenn ich betroffen bin"
L.ME_ONLY_desc = "Wenn diese Option aktiviert ist wird diese Fähigkeit nur angezeigt, wenn Du betroffen bist. Zum Beispiel wird 'Bombe: Spieler' nur angezeigt, wenn dies Dich betrifft."
L.PULSE = "Impuls"
L.PULSE_desc = "Zusätzlich zum Aufleuchten des Bildschirms kann für diese bestimmte Fähigkeit kurzzeitig ein Symbol in der Bildschirmmitte angezeigt werden, um Deine Aufmerksamkeit zu erlangen."
L.MESSAGE_desc = "Für die meisten Bossfähigkeiten gibt es eine oder mehrere Nachrichten, die BigWigs anzeigt. Wenn Du diese Option deaktivierst, wird keine der zugehörigen Nachrichten angezeigt."
L.BAR_desc = "Leisten werden für Bossfähigkeiten angezeigt, sofern sie sinnvoll sind. Falls diese Fähigkeit eine Leiste besitzt, die Du verstecken möchtest, kannst Du die Option deaktivieren."
L.FLASH_desc = "Einige Fähigkeiten mögen wichtiger sein als andere. Wenn Du bei Auftreten oder kurz vor dieser Fähigkeit den Bildschirm aufleuchten lassen möchtest, aktiviere diese Option."
L.ICON_desc = "BigWigs kann Spieler, die von Fähigkeiten betroffen sind, durch ein Symbol markieren. Das erleichtert das Bemerken."
L.SAY_desc = "Chatblasen sind leicht zu sehen. BigWigs benutzt eine /sagen-Nachricht, um Leute um Dich herum auf Effekte auf Dir aufmerksam zu machen."
L.EMPHASIZE_desc = "Wenn diese Funktion aktiviert wird, werden Nachrichten, die mit dieser Fähigkeit verbunden sind, hervorgehoben. Dadurch werden sie größer und besser sichtbar. Du kannst die Größe und Schriftart von hervorgehobenen Nachrichten in den Haupteinstellungen unter \"Nachrichten\" einstellen."
L.PROXIMITY = "Näherungsanzeige"
L.PROXIMITY_desc = "Fähigkeiten von Begegnungen erfordern manchmal, dass alle Mitspieler auseinander stehen. Die Näherungsanzeige wird speziell für diese Fähigkeit eingestellt, sodass Du auf einen Blick siehst, ob Du sicher bist oder nicht."
L.ALTPOWER = "Anzeige alternativer Energien"
L.ALTPOWER_desc = "Einige Bosse nutzen die alternativen Energien für Mitspieler in der Gruppe. Die Anzeige alternativer Energien bietet einen schnellen Überblick darüber, wer am meisten/wenigsten alternative Energie besitzt. Dies kann bei Taktiken oder Einteilungen helfen."
L.TANK = "Nur Tank"
L.TANK_desc = "Einige Fähigkeiten sind lediglich für Tanks wichtig. Wenn Du Warnungen für diese Fähigkeit unabhägig von Deiner Rolle angezeigt bekommen möchtest, deaktiviere diese Option."
L.HEALER = "Nur Heiler"
L.HEALER_desc = "Einige Fähigkeiten sind lediglich für Heiler wichtig. Wenn Du Warnungen für diese Fähigkeit unabhägig von Deiner Rolle angezeigt bekommen möchtest, deaktiviere diese Option."
L.TANK_HEALER = "Nur Tank & Heiler"
L.TANK_HEALER_desc = "Einige Fähigkeiten sind lediglich für Tanks und Heiler wichtig. Wenn Du Warnungen für diese Fähigkeit unabhägig von Deiner Rolle angezeigt bekommen möchtest, deaktiviere diese Option."
L.DISPEL = "Nur Dispeller"
L.DISPEL_desc = "Wenn Du Warnungen für diese Fähigkeit sehen willst, obwohl Du sie nicht bannen kannst, deaktiviere diese Option."
L.VOICE = "Stimmen"
L.VOICE_desc = "Wenn ein Stimmplugin installiert ist, aktiviert diese Option die Wiedergabe einer Sounddatei, welche die Warnung laut ausspricht."
L.COUNTDOWN = "Countdown"
L.COUNTDOWN_desc = "Wenn aktiviert, wird ein hör- und sichtbarer Countdown für die letzten 5 Sekunden hinzugefügt. Stell Dir vor es zählt jemand runter \"5... 4... 3... 2... 1...\" mit einer großen Zahl in der Mitte des Bildschirms."
L.INFOBOX = L.infobox
L.INFOBOX_desc = L.infobox_desc
L.SOUND = L.sound
L.SOUND_desc = "Bossfähigkeiten nutzen in der Regel Sounds um wahrgenommen zu werden. Wenn diese Option deaktiviert wird, werden die zugehörigen Sounds nicht abgespielt."
L.CASTBAR = "Zauberbalken"
L.CASTBAR_desc = "Manchmal werden Zauberbalken bei diversen Bossen angezeigt um auf wichtige Fähigkeiten aufmerksam zu machen. Wenn diese Zauberbalken nicht angezeigt werden sollen, muss diese Option deaktiviert werden."
L.CASTBAR_COUNTDOWN = "Countdown (nur Zauberbalken)"
L.CASTBAR_COUNTDOWN_desc = "Bei Aktivierung werden ein Stimm- und visueller Countdown für die letzten 5 Sekunden eines Zauberbalkens hinzugefügt."
L.SAY_COUNTDOWN = "Sprechblasen-Countdown"
L.SAY_COUNTDOWN_desc = "Sprechblasen sind gut sichtbar. BigWigs nutzt oftmals Sprechblasen zum Herunterzählen, um Spieler in der Nähe vor auslaufenden Fähigkeiten zu warnen."
L.ME_ONLY_EMPHASIZE = "Hervorheben (nur auf mir)"
L.ME_ONLY_EMPHASIZE_desc = "Die Aktivierung dieser Option hebt Nachrichten zu dieser Fähigkeit NUR DANN hervor, wenn diese auf Dich angewandt wurden. Dadurch werden diese größer und sichtbarer dargestellt."
L.NAMEPLATE = "Namensplaketten"
L.NAMEPLATE_desc = "Wenn aktiviert, werden Funktionen wie Symbole und Text zu dieser spezifischen Fähigkeit an den Namensplaketten dargestellt. Dies macht es einfacher zu erkennen, welcher NPC eine Fähigkeit wirkt, wenn mehrere NPCs diese wirken."
L.PRIVATE = "Private Aura"
L.PRIVATE_desc = "Diese Einstellungen sind nur für allgemeine Zauberwarnungen und Leisten!\n\nDu kannst den abzuspielenden Sound wenn Du von dieser Fähigkeit betroffen bist unter \"Private Aurasounds\" im \"Wähle Begegnung\" Dropdown-Menü oben rechts ändern."

L.advanced_options = "Erweiterte Optionen"
L.back = "<< Zurück"

L.tank = "|cFFFF0000Warnungen nur für Tanks.|r "
L.healer = "|cFFFF0000Warnungen nur für Heiler.|r "
L.tankhealer = "|cFFFF0000Warnungen nur für Tanks und Heiler.|r "
L.dispeller = "|cFFFF0000Warnungen nur für Banner.|r "

-- Sharing.lua
L.import = "Importieren"
L.import_info = "Nach der Eingabe eines Strings kann gewählt werden welche Einstellungen importiert werden sollen.\nWenn Einstellungen im Import-String nicht verfügbar sind, sind diese nicht wählbar.\n\n|cffff4411Dieser Import betrifft nur allgemeine Einstellungen und keine Boss-spezifischen Einstellungen.|r"
L.import_info_active = "Zu importierende Teile auswählen und auf Importieren Button klicken."
L.import_info_none = "|cFFFF0000Der Import-String ist inkompatibel oder veraltet.|r"
L.export = "Exportieren"
L.export_info = "Zu exportierende und zu teilende Einstellungen wählen.\n\n|cffff4411Es können nur allgemeine Einstellungen geteilt werden und keine Boss-spezifischen Einstellungen.|r"
L.export_string = "Export-String"
L.export_string_desc = "BigWigs String kopieren zum Teilen der Einstellungen."
L.import_string = "Import-String"
L.import_string_desc = "BigWigs String zum Importieren hier einfügen."
L.position = "Position"
L.settings = "Einstellungen"
L.other_settings = "Andere Einstellungen"
L.nameplate_settings_import_desc = "Alle Einstellungen der Namensplaketten importieren."
L.nameplate_settings_export_desc = "Alle Einstellungen der Namensplaketten exportieren."
L.position_import_bars_desc = "Die Position (Anker) der Leisten importieren."
L.position_import_messages_desc = "Die Position (Anker) der Nachrichten importieren."
L.position_import_countdown_desc = "Die Position (Anker) des Countdowns importieren."
L.position_export_bars_desc = "Die Position (Anker) der Leisten exportieren."
L.position_export_messages_desc = "Die Position (Anker) der Nachrichten exportieren."
L.position_export_countdown_desc = "Die Position (Anker) des Countdowns exportieren."
L.settings_import_bars_desc = "Allgemeine Einstellungen der Leisten wie Größe, Schriftart, etc. importieren."
L.settings_import_messages_desc = "Allgemeine Einstellungen der Nachrichten wie Größe, Schriftart, etc. importieren."
L.settings_import_countdown_desc = "Allgemeine Einstellungen des Countdowns wie Stimme, Größe, Schriftart, etc. importieren."
L.settings_export_bars_desc = "Allgemeine Einstellungen der Leisten wie Größe, Schriftart, etc. exportieren."
L.settings_export_messages_desc = "Allgemeine Einstellungen der Nachrichten wie Größe, Schriftart, etc. exportieren."
L.settings_export_countdown_desc = "Allgemeine Einstellungen des Countdowns wie Stimme, Größe, Schriftart, etc. exportieren."
L.colors_import_bars_desc = "Die Farben der Leisten importieren."
L.colors_import_messages_desc = "Die Farben der Nachrichten importieren."
L.color_import_countdown_desc = "Die Farbe des Countdowns importieren."
L.colors_export_bars_desc = "Die Farben der Leisten exportieren."
L.colors_export_messages_desc = "Die Farben der Nachrichten exportieren."
L.color_export_countdown_desc = "Die Farbe des Countdowns exportieren."
L.confirm_import = "Die zum Import gewählten Einstellungen überschreiben die Einstellungen im derzteit gewählten Profil:\n\n|cFF33FF99\"%s\"|r\n\nBist Du sicher, dass Du dies tun willst?"
L.confirm_import_addon = "Das Addon |cFF436EEE\"%s\"|r möchte automatisch neue BigWigs Einstellungen importieren, diese überschreiben die Einstellungen im aktuell gewählten BigWigs Profil:\n\n|cFF33FF99\"%s\"|r\n\nBist Du sicher, dass Du dies tun willst?"
L.confirm_import_addon_new_profile = "Das Addon |cFF436EEE\"%s\"|r möchte automatisch das folgende BigWigs Profil erstellen:\n\n|cFF33FF99\"%s\"|r\n\nDas Akzeptieren dieses neuen Profils aktiviert dieses."
L.confirm_import_addon_edit_profile = "Das Addon |cFF436EEE\"%s\"|r möchte automatisch das folgende BigWigs Profil editieren:\n\n|cFF33FF99\"%s\"|r\n\nDas Akzeptieren dieser Änderungen aktiviert diese."
L.no_string_available = "Kein Import-String zum Importieren gespeichert. Zuerst einen String importieren."
L.no_import_message = "Es wurden keine Einstellungen importiert."
L.import_success = "Importiert: %s" -- Imported: Bar Anchors, Message Colors
L.imported_bar_positions = "Leisten Positionen"
L.imported_bar_settings = "Leisten Einstellugen"
L.imported_bar_colors = "Leisten Farben"
L.imported_message_positions = "Nachrichten Positionen"
L.imported_message_settings = "Nachrichten Einstellugen"
L.imported_message_colors = "Nachrichten Farben"
L.imported_countdown_position = "Countdown Position"
L.imported_countdown_settings = "Countdown Einstellungen"
L.imported_countdown_color = "Countdown Farbe"
L.imported_nameplate_settings = "Namensplaketten Einstellungen"
L.imported_mythicplus_settings = "Mythisch+ Einstellungen"
L.mythicplus_settings_import_desc = "Alle Mythisch+ Einstellungen importieren."
L.mythicplus_settings_export_desc = "Alle Mythisch+ Einstellungen exportieren."

-- Statistics
L.statistics = "Statistiken"
L.defeat = "Niederlagen"
L.defeat_desc = "Die Gesamtzahl der Niederlagen dieser Begegnung."
L.victory = "Siege"
L.victory_desc = "Die Gesamtzahl der Siege dieser Begegnung."
L.fastest = "Schnellster"
L.fastest_desc = "Der schellste Sieg und das Datum wann dieser war (Jahr/Monat/Tag)"
L.first = "Erster"
L.first_desc = "Der erste Sieg über diesen Gegner, folgend formatiert:\n[Anzahl der Niederlagen vor dem ersten Sieg] - [Kampfdauer] - [Jahr/Monat/Tag des Sieges]"

-- Difficulty levels for statistics display on bosses
L.unknown = "Unbekannt"
L.LFR = "LFR"
L.normal = "Normal"
L.heroic = "Heroisch"
L.mythic = "Mythisch"
L.timewalk = "Zeitwanderung"
L.solotier8 = "Solo Stufe 8"
L.solotier11 = "Solo Stufe 11"
L.story = "Story"
L.mplus = "Mythisch+ %d"
L.SOD = "Saison der Entdeckungen"
L.hardcore = "Hardcore"
L.level1 = "Stufe 1"
L.level2 = "Stufe 2"
L.level3 = "Stufe 3"
L.N10 = "Normal 10"
L.N25 = "Normal 25"
L.H10 = "Heroisch 10"
L.H25 = "Heroisch 25"

-----------------------------------------------------------------------
-- TOOLS
-----------------------------------------------------------------------

L.tools = "Werkzeuge"
L.toolsDesc = "BigWigs bietet verschiedene Werkzeuge oder Features der \"Lebensqualität\" zur Beschleunigung und Vereinfachung von Bossbegegnungen. Menü durch Klicken des |cFF33FF99+|r Symbols erweitern, um alle zu sehen."

-----------------------------------------------------------------------
-- AutoRole.lua
--

L.autoRoleTitle = "Automatische Rollenwahl"
L.autoRoleExplainer = "Jedes mal, wenn einer Gruppe beigetreten wird, oder die Talentspezialisierung in einer Gruppe geändert wird, passt BigWigs automatisch die Gruppenrolle (Tank, Heiler, Schaden) entsprechend an.\n\n"

-----------------------------------------------------------------------
-- Keystones.lua
--

L.keystoneTitle = "BigWigs Schlüsselsteine"
L.keystoneHeaderParty = "Gruppe"
L.keystoneRefreshParty = "Gruppe aktualisieren"
L.keystoneHeaderGuild = "Gilde"
L.keystoneRefreshGuild = "Gilde aktualisieren"
L.keystoneLevelTooltip = "Schlüsselstein Stufe: |cFFFFFFFF%s|r"
L.keystoneMapTooltip = "Dungeon: |cFFFFFFFF%s|r"
L.keystoneRatingTooltip = "Mythisch+ Wertung: |cFFFFFFFF%d|r"
L.keystoneHiddenTooltip = "Der Spieler hat entschieden diese Information zu verstecken."
L.keystoneTabOnline = "Online"
L.keystoneTabAlts = "Twinks"
L.keystoneTabTeleports = "Teleports"
L.keystoneHeaderMyCharacters = "Meine Charaktere"
L.keystoneTeleportNotLearned = "Der Teleportzauber '|cFFFFFFFF%s|r' wurde noch |cFFFF4411nicht erlernt|r."
L.keystoneTeleportOnCooldown = "Der Teleportzauber '|cFFFFFFFF%s|r' |cFFFF4411klingt ab|r für %d |4Stunde:Stunden; und %d |4Minute:Minuten;."
L.keystoneTeleportReady = "Der Teleportzauber '|cFFFFFFFF%s|r' ist |cFF33FF99bereit|r, klicken zum Wirken."
L.keystoneTeleportInCombat = "Teleportation hierhin im Kampf nicht möglich."
L.keystoneTabHistory = "Verlauf"
L.keystoneHeaderThisWeek = "Diese Woche"
L.keystoneHeaderOlder = "Älter"
L.keystoneScoreTooltip = "Dungeon Wertung: |cFFFFFFFF%d|r"
L.keystoneScoreGainedTooltip = "Erhaltene Wertung: |cFFFFFFFF+%d|r"
L.keystoneCompletedTooltip = "Im Zeitfenster abgeschlossen"
L.keystoneFailedTooltip = "Nicht im Zeitfenster abgeschlossen"
L.keystoneExplainer = "Eine Sammlung verschiedener Werkzeuge zur Verbesserung der Mythisch+ Erfahrung."
L.keystoneAutoSlot = "Schlüsselstein automatisch einsetzen"
L.keystoneAutoSlotDesc = "Setzt den Schlüsselstein automatisch beim Öffnen des Borns der Macht ein."
L.keystoneAutoSlotMessage = "%s wurde automatisch in den Born der Macht eingesetzt."
L.keystoneModuleName = "Mythisch+"
L.keystoneStartBar = "%s +%d" -- Format is SHORT_DUNGEON_NAME +KEYSTONE_LEVEL e.g. "ROOK +12"
L.keystoneStartMessage = "%s +%d beginnt jetzt!" -- Format is LONG_DUNGEON_NAME +KEYSTONE_LEVEL e.g. "The Rookery +12 begins now!"
L.keystoneCountdownExplainer = "Beim Starten eines Mythisch+ Dungeons beginnt ein Countdown. Wiederzugebende Stimme sowie Länge des Countdowns wählen.\n\n"
L.keystoneCountdownBeginsDesc = "Auswählen, ab welcher Restzeit des Mythisch+ Starttimers der Countdown startet."
L.keystoneCountdownBeginsSound = "Einen Sound beim Start des Mythisch+ Countdowns wiedergeben"
L.keystoneCountdownEndsSound = "Einen Sound am Ende des Mythisch+ Countdowns wiedergeben"
L.keystoneViewerTitle = "Schlüsselstein Anzeige"
L.keystoneHideGuildTitle = "Meinen Schlüsselstein vor meinen Gildenmitgliedern verstecken"
L.keystoneHideGuildDesc = "|cffff4411Nicht empfohlen.|r Diese Funktion verhindert die Anzeige Deines Schlüsselsteins für die Gildenmitglieder. Jedes Mitglied der Gruppe kann diesen weiterhin sehen."
L.keystoneHideGuildWarning = "Die Deaktivierung der Anzeige Deines Schlüsselsteins für Deine Gilde wird |cffff4411nicht empfohlen|r.\n\nBist Du sicher?"
L.keystoneAutoShowEndOfRun = "Nach Beenden von Mythisch+ anzeigen"
L.keystoneAutoShowEndOfRunDesc = "Die Schlüsselstein Anzeige automatisch nach Abschluss des Mythisch+ Dungeons anzeigen.\n\n|cFF33FF99Dies kann helfen, die neu erhaltenen Schlüsselsteine der Gruppe zu sehen.|r"
L.keystoneViewerExplainer = "Die Schlüsselstein Anzeige kann durch Nutzung des Befehls |cFF33FF99/key|r oder die untenstehende Schaltfläche geöffnet werden.\n\n"
L.keystoneViewerOpen = "Schlüsselstein Anzeige öffnen"
L.keystoneViewerKeybindingExplainer = "\n\nEs kann eine Tastenbelegung zum Öffnen der Schlüsselstein Anzeige festgelegt werden:\n\n"
L.keystoneViewerKeybindingDesc = "Tastenbelegung zum Öffnen der Schlüsselstein Anzeige wählen."
L.keystoneClickToWhisper = "Zum Anflüstern klicken"
L.keystoneClickToTeleportNow = "\nZum dorthin teleportieren klicken"
L.keystoneClickToTeleportCooldown = "\nTeleport nicht möglich, Zauber klingt ab"
L.keystoneClickToTeleportNotLearned = "\nTeleport nicht möglich, Zauber nicht erlernt"
L.keystoneHistoryRuns = "Gesamt: %d"
L.keystoneHistoryRunsThisWeekTooltip = "Gesamtzahl der Dungeons diese Woche: |cFFFFFFFF%d|r"
L.keystoneHistoryRunsOlderTooltip = "Gesamtzahl der Dungeons vor dieser Woche: |cFFFFFFFF%d|r"
L.keystoneHistoryScore = "Wertung: +%d"
L.keystoneHistoryScoreThisWeekTooltip = "Gesamte diese Woche erhaltene Wertung: |cFFFFFFFF+%d|r"
L.keystoneHistoryScoreOlderTooltip = "Gesamte vor dieser Woche erhaltene Wertung: |cFFFFFFFF+%d|r"

-- It doesn't really matter what you call it as long as it's recognizable and limited to ~6 characters
L.keystoneShortName_TheRookery = "ROOK"
L.keystoneShortName_DarkflameCleft = "DFC"
L.keystoneShortName_PrioryOfTheSacredFlame = "PRIO"
L.keystoneShortName_CinderbrewMeadery = "BREW"
L.keystoneShortName_OperationFloodgate = "FLOOD"
L.keystoneShortName_TheaterOfPain = "TOP"
L.keystoneShortName_TheMotherlode = "ML"
L.keystoneShortName_OperationMechagonWorkshop = "WORK"
L.keystoneShortName_EcoDomeAldani = "ALDANI"
L.keystoneShortName_HallsOfAtonement = "HOA"
L.keystoneShortName_AraKaraCityOfEchoes = "ARAK"
L.keystoneShortName_TazaveshSoleahsGambit = "GAMBIT"
L.keystoneShortName_TazaveshStreetsOfWonder = "STREET"
L.keystoneShortName_TheDawnbreaker = "DAWN"

-- These short names are for the bar that shows during the Mythic+ countdown
-- Use the real dungeon names but make them shorter to fit on the bar better
L.keystoneShortName_TheRookery_Bar = "Brutstätte"
L.keystoneShortName_DarkflameCleft_Bar = "Dunkelflammenspalt"
L.keystoneShortName_PrioryOfTheSacredFlame_Bar = "Priorat"
L.keystoneShortName_CinderbrewMeadery_Bar = "Brauerei"
L.keystoneShortName_OperationFloodgate_Bar = "Schleuse"
L.keystoneShortName_TheaterOfPain_Bar = "Theater"
L.keystoneShortName_TheMotherlode_Bar = "Riesenflöz"
L.keystoneShortName_OperationMechagonWorkshop_Bar = "Werkstatt"
L.keystoneShortName_EcoDomeAldani_Bar = "Al'dani"
L.keystoneShortName_HallsOfAtonement_Bar = "Hallen"
L.keystoneShortName_AraKaraCityOfEchoes_Bar = "Ara-Kara"
L.keystoneShortName_TazaveshSoleahsGambit_Bar = "Schachzug"
L.keystoneShortName_TazaveshStreetsOfWonder_Bar = "Straßen"
L.keystoneShortName_TheDawnbreaker_Bar = "Morgenbringer"

-- Instance Keys "Who has a key?"
L.instanceKeysTitle = "Wer hat einen Schlüsselstein?"
L.instanceKeysDesc = "Beim Betreten eines mythischen Dungeons werden die Spieler, welche einen Schlüsselstein für diesen Dungeon haben, als Liste angezeigt.\n\n"
L.instanceKeysTest8 = "|cFF00FF98Mönch:|r +8"
L.instanceKeysTest10 = "|cFFFF7C0ADruide:|r +10"
L.instanceKeysDisplay = "|c%s%s:|r +%d" -- "PLAYER_NAME: +DUNGEON_LEVEL"
L.instanceKeysDisplayWithDungeon = "|c%s%s:|r +%d (%s)" -- "PLAYER_NAME: +DUNGEON_LEVEL (DUNGEON_NAME)"
L.instanceKeysShowAll = "Immer alle Spieler anzeigen"
L.instanceKeysShowAllDesc = "Durch Aktivierung dieser Option werden alle Spieler in der Liste angezeigt, auch wenn deren Schlüsselstein nicht zum aktuellen Dungeon passt."
L.instanceKeysOtherDungeonColor = "Farbe anderer Dungeons"
L.instanceKeysOtherDungeonColorDesc = "Schriftfarbe für Spieler wählen, deren Schlüsselstein nicht zum aktuellen Dungeon passt."
L.instanceKeysEndOfRunDesc = "Standardmäßig wird die Liste nur beim Betreten eines mythischen Dungeons angezeigt. Durch Aktivierung dieser Option wird die Liste auch nach Abschluss von Mythisch+ Dungeons angezeigt."

-----------------------------------------------------------------------
-- LFGTimer.lua
--

L.lfgTimerTitle = "Dungeonbrowser Timer"
L.lfgTimerExplainer = "Immer wenn ein Dungeonbrowser Popup für eine Warteschlange erscheint, erstellt BigWigs einen Timer mit der verbleibenden Zeit zum Akzeptieren.\n\n"
L.lfgUseMaster = "Dungeonbrowser Bereitschaftssound auf 'Master' Audiokanal wiedergeben"
L.lfgUseMasterDesc = "Wenn diese Option aktiviert ist, wird der Bereitschaftssound des Dungeonbrowsers auf dem 'Master' Audiokanal wiedergegeben. Wenn diese Option deaktiviert ist, wird dieser stattdessen auf dem '%s' Audiokanal wiedergegeben."

-----------------------------------------------------------------------
-- PLUGINS
-----------------------------------------------------------------------

L.general = "Allgemein"
L.advanced = "Erweitert"
L.comma = ", "
L.reset = "Zurücksetzen"
L.resetDesc = "Die obigen Einstellungen auf Standardwerte zurücksetzen."
L.resetAll = "Alle zurücksetzen"

L.positionX = "X-Position"
L.positionY = "Y-Position"
L.positionExact = "Exakte Positionierung"
L.positionDesc = "Zur exakten Positionierung vom Ankerpunkt einen Wert in der Box eingeben oder den Schieberegler bewegen."
L.width = "Breite"
L.height = "Höhe"
L.size = "Größe"
L.sizeDesc = "Normalerweise wird die Größe festgelegt, indem Du den Anker bewegst. Falls Du eine exakte Größe benötigst, bewege diesen Schieber oder trage den Wert in das Feld ein."
L.fontSizeDesc = "Schriftgröße über den Schieberegler oder durch Eingabe eines Wertes in der Box (maximal 200) festlegen."
L.disabled = "Deaktivieren"
L.disableDesc = "Du bist dabei, das Feature '%s' zu deaktivieren, was |cffff4411nicht empfohlen|r wird.\n\nBist Du sicher, dass Du das tun willst?"
L.keybinding = "Tastenbelegung"
L.dragToResize = "Zum Anpassen ziehen"

-- Anchor Points
L.UP = "Hoch"
L.DOWN = "Runter"
L.TOP = "Oben"
L.RIGHT = "Rechts"
L.BOTTOM = "Unten"
L.LEFT = "Links"
L.TOPRIGHT = "Oben Rechts"
L.TOPLEFT = "Oben Links"
L.BOTTOMRIGHT = "Unten Rechts"
L.BOTTOMLEFT = "Unten Links"
L.CENTER = "Mitte"
L.customAnchorPoint = "Erweitert: Benutzerdefinierter Ankerpunkt"
L.sourcePoint = "Ursprungspunkt"
L.destinationPoint = "Zielpunkt"
L.drawStrata = "Schichten zeichnen"
L.medium = "MITTEL"
L.low = "NIEDRIG"

-----------------------------------------------------------------------
-- AltPower.lua
--

L.altPowerTitle = "Alternative Energien"
L.altPowerDesc = "Die Anzeige alternativer Energien wird nur bei Bossen aktiv, welche Spieler mit alternativen Energien belegen, was selten der Fall ist. Die Anzeige informiert in einer Liste über die 'Alternativen Energien', welche Deine Gruppe und Du habt. Nutze den folgenden Testbutton um die Anzeige zu verschieben."
L.toggleDisplayPrint = "Die Anzeige wird das nächste Mal wieder erscheinen. Um sie für diesen Bosskampf komplett zu deaktivieren, musst Du sie in den Bosskampf-Optionen ausschalten."
L.disabledDisplayDesc = "Deaktiviert die Anzeige für alle Module, die sie benutzen."
L.resetAltPowerDesc = "Setzt alle Optionen im Zusammenhang mit Alternative Energie zurück, inklusive der Position des Ankers für Alternative Energie."
L.test = "Test"
L.altPowerTestDesc = "Zeigt die Anzeige der 'Alternative Energien' und ermöglicht das Verschieben. Gleichzeitig wird eine Vorschau der Energieänderung wie in einem Bosskampf gegeben."
L.yourPowerBar = "Deine Energie Leiste"
L.barColor = "Farbe der Leiste"
L.barTextColor = "Textfarbe der Leiste"
L.additionalWidth = "Zusätzliche Breite"
L.additionalHeight = "Zusätzliche Höhe"
L.additionalSizeDesc = "Vergrößert die Standardanzeige über den Schieberegler oder durch Eingabe eines Wertes in der Box (maximal 100)."
L.yourPowerTest = "Deine Energie: %d" -- Your Power: 42
L.yourAltPower = "Dein(e) %s: %d" -- e.g. Your Corruption: 42
L.player = "Spieler %d" -- Player 7
L.disableAltPowerDesc = "Die Anzeige alternativer Energien komplett deaktivieren, sodass sie bei keiner Bossbegegnung angezeigt wird."

-----------------------------------------------------------------------
-- AutoReply.lua
--

L.autoReply = "Automatisch antworten"
L.autoReplyDesc = "Automatisch auf Flüsternachrichten antworten, wenn ich mich in einem Bosskampf befinde."
L.responseType = "Antwortart"
L.autoReplyFinalReply = "Auch flüstern wenn ich den Kampf verlassen habe"
L.guildAndFriends = "Gilde & Freunde"
L.everyoneElse = "Jeden"

L.autoReplyBasic = "Ich befinde mich in einem Bosskampf."
L.autoReplyNormal = "Ich kämpfe gerade gegen '%s'."
L.autoReplyAdvanced = "Ich kämpfe gerade gegen '%s' (%s) und %d/%d Spieler sind noch am Leben."
L.autoReplyExtreme = "Ich kämpfe gerade gegen '%s' (%s) und %d/%d Spieler sind noch am Leben: %s"

L.autoReplyLeftCombatBasic = "Ich befinde mich nicht mehr im Bosskampf."
L.autoReplyLeftCombatNormalWin = "Ich habe gegen '%s' gewonnen."
L.autoReplyLeftCombatNormalWipe = "Ich habe gegen '%s' verloren."
L.autoReplyLeftCombatAdvancedWin = "Ich habe gegen '%s' gewonnen und %d/%d Spieler waren noch am leben."
L.autoReplyLeftCombatAdvancedWipe = "Ich habe gegen '%s' verloren bei: %s"

-----------------------------------------------------------------------
-- Bars.lua
--

L.bars = "Leisten"
L.style = "Stil"
L.bigWigsBarStyleName_Default = "Standard"
L.resetBarsDesc = "Setzt alle Optionen im Zusammenhang mit Leisten zurück, inklusive der Position der Anker für Leisten."
L.testBarsBtn = "Testleiste erstellen"
L.testBarsBtn_desc = "Erstellt eine Leiste zum Testen der aktuellen Einstellungen an."

L.toggleAnchorsBtnShow = "Anker einblenden"
L.toggleAnchorsBtnHide = "Anker ausblenden"
L.toggleAnchorsBtnHide_desc = "Blendet alle Ankerpunkte aus und fixiert alle Anzeigen."
L.toggleBarsAnchorsBtnShow_desc = "Zeigt alle Bewegungs-Anker zum Bewegen der Leisten."

L.emphasizeAt = "Hervorheben bei... (Sekunden)"
L.growingUpwards = "Nach oben erweitern"
L.growingUpwardsDesc = "Legt fest, ob die Leisten aufwärts oder abwärts vom Ankerpunkt angezeigt werden."
L.texture = "Textur"
L.emphasize = L.EMPHASIZE
L.emphasizeMultiplier = "Größenmultiplikator"
L.emphasizeMultiplierDesc = "Wenn das Bewegen der Leisten zu den hervorgehobenen Leisten deaktiviert ist, entscheidet diese Option welche Größe die hervorgehobenen Leisten multipliziert mit den normalen Leisten haben."

L.enable = "Aktiviert"
L.move = "Bewegen"
L.moveDesc = "Bewegt hervorgehobene Leisten zum hervorgehobenen Anker. Ist diese Option nicht aktiv, werden hervorgehobene Leisten lediglich in Größe und Farbe geändert."
L.emphasizedBars = "Hervorgehobene Leisten"
L.align = "Ausrichtung"
L.alignText = "Textausrichtung"
L.alignTime = "Zeitausrichtung"
L.time = "Zeit"
L.timeDesc = "Bestimmt, ob die verbleibende Zeit auf den Leisten angezeigt wird."
L.textDesc = "Text in den Leisten anzeigen oder verstecken."
L.icon = "Symbol"
L.iconDesc = "Zeigt oder versteckt die Symbole auf den Leisten."
L.iconPosition = "Symbolposition"
L.iconPositionDesc = "Wähle, wo sich das Symbol auf der Leiste befinden soll."
L.font = "Schriftart"
L.restart = "Neu starten"
L.restartDesc = "Startet die hervorgehobenen Leisten neu, sodass diese vom Start anfangen und von 10 herunterzählen."
L.fill = "Füllen"
L.fillDesc = "Füllt die Leisten anstatt sie zu entleeren."
L.spacing = "Abstand"
L.spacingDesc = "Verändert den Abstand zwischen den Leisten."
L.visibleBarLimit = "Maximale Leistenanzahl"
L.visibleBarLimitDesc = "Legt die maximale Anzahl der Leisten fest, welche gleichzeitig angezeigt werden."

L.localTimer = "Lokal"
L.timerFinished = "%s: Timer [%s] beendet."
L.customBarStarted = "Custombar '%s' wurde gestartet von %s Nutzer %s."
L.sendCustomBar = "Sende Custombar '%s' an BigWigs- und DBM-Nutzer."

L.requiresLeadOrAssist = "Diese Funktion benötigt Schlachtzugsleiter oder -assistent."
L.encounterRestricted = "Diese Funktion kann während des Bosskampfes nicht genutzt werden."
L.wrongCustomBarFormat = "Ungültiges Format. Beispiel: /raidbar 20 text"
L.wrongTime = "Ungültige Zeitangabe. <Zeit> kann eine Zahl in Sekunden, eine M:S Paarung, oder Mm sein. Beispiel: 5, 1:20 oder 2m."

L.wrongBreakFormat = "Muss zwischen 1 und 60 Minuten liegen. Beispiel: /break 5"
L.sendBreak = "Sende Pausentimer an BigWigs- und DBM-Nutzer."
L.breakStarted = "Pause wurde von %s-Nutzer %s gestartet."
L.breakStopped = "Pause wurde von %s abgebrochen."
L.breakBar = "Pause"
L.breakMinutes = "Pause endet in %d |4Minute:Minuten;!"
L.breakSeconds = "Pause endet in %d |4Sekunde:Sekunden;!"
L.breakFinished = "Die Pause ist vorbei!"

-----------------------------------------------------------------------
-- BossBlock.lua
--

L.bossBlock = "Boss Block"
L.bossBlockDesc = "Legt fest, was während einer Bossbegegnung blockiert wird.\n\n"
L.bossBlockAudioDesc = "Konfiguriert, welche Sounds während Bossbegegnungen stummgeschaltet werden.\n\nJede hier |cff808080ausgegraute|r Option wurde in den WoW Soundeinstellungen deaktiviert.\n\n"
L.movieBlocked = "Da Du diese Zwischensequenz bereits gesehen hast, wird sie übersprungen."
L.blockEmotes = "Hinweise in der Bildschirmmitte blockieren"
L.blockEmotesDesc = "Einige Bosse zeigen sehr lange und ungenaue Hinweise für spezielle Fähigkeiten an. BigWigs versucht kürzere und passendere Mitteilungen zu erstellen, die den Spielfluss weniger beeinflussen.\n\nHinweis: Bossmitteilungen werden weiterhin im Chat sichtbar sein und können dort gelesen werden."
L.blockMovies = "Wiederholte Filmsequenzen blockieren"
L.blockMoviesDesc = "Filmsequenzen aus Bossbegegnungen werden einmalig wiedergegeben (sodass jede angeschaut werden kann) und danach blockiert."
L.blockFollowerMission = "Popups der Anhänger blockieren"
L.blockFollowerMissionDesc = "Popups der Anhänger zeigen hauptsächlich abgeschlossene Missionen von Anhängern an.\n\nDa diese Popups während des Bosskampfes ablenken und das Interface überdecken können, sollten sie blockiert werden."
L.blockGuildChallenge = "Popups von Gildenherausforderungen blockieren"
L.blockGuildChallengeDesc = "Popups von Gildenherausforderungen zeigen hauptsächlich den Abschluss eines heroischen Dungeons oder des Herausforderungsmodus an.\n\nDa diese Popups während des Bosskampfes ablenken und das Interface überdecken können, sollten sie blockiert werden."
L.blockSpellErrors = "Hinweise zu fehlgeschlagenen Zaubern blockieren"
L.blockSpellErrorsDesc = "Nachrichten wie \"Fähigkeit noch nicht bereit\", welche normalerweise oben auf dem Bildschirm auftauchen, werden blockiert."
L.blockZoneChanges = "Zonenwechsel Nachrichten blockieren"
L.blockZoneChangesDesc = "Die Nachrichten in der oberen Mitte des Bildschirms wenn eine neue Zone betreten wird wie '|cFF33FF99Sturmwind|r' oder '|cFF33FF99Orgrimmar|r' werden blockiert."
L.audio = "Audio"
L.music = "Musik"
L.ambience = "Umgebungsgeräusche"
L.sfx = "Soundeffekte"
L.errorSpeech = "Audiofehlermeldungen"
L.disableMusic = "Musik stummschalten (empfohlen)"
L.disableAmbience = "Umgebungsgeräusche stummschalten (empfohlen)"
L.disableSfx = "Soundeffekte stummschalten (nicht empfohlen)"
L.disableErrorSpeech = "Audiofehlermeldungen stummschalten (empfohlen)"
L.disableAudioDesc = "Die Option '%s' im WoW Soundmenü wird deaktiviert und erst nach dem Bosskampf wieder aktiviert. Dies kann helfen sich auf die BigWigs Sounds zu konzentrieren."
L.blockTooltipQuests = "Questziele im Tooltip blockieren"
L.blockTooltipQuestsDesc = "Wenn zum Abschluss einer Quest ein Boss getötet werden muss, wird der Fortschritt normalerweise im MouseOver-Tooltip mit '0/1 abgeschlossen' angezeigt. Dieser Fortschritt wird im Kampf versteckt, damit der Tooltip nicht zu groß wird."
L.blockObjectiveTracker = "Questverfolgung ausblenden"
L.blockObjectiveTrackerDesc = "Die Liste mit verfolgten Quests wird im Bosskampf ausgeblendet um Anzeigeplatz zu sparen.\n\nDies passiert NICHT in Mythic+ oder beim Verfolgen eines Erfolges."

L.blockTalkingHead = "'Sprechende Dialoge' NPC Popup verstecken"
L.blockTalkingHeadDesc = "Die 'Sprechenden Dialoge' sind Popup Dialogboxen, welche |cffff4411manchmal|r mit dem Kopf des NPCs und einem Chattext in der unteren Mitte des Bildschirms angezeigt werden, während ein NPC spricht.\n\nEs kann festgelegt werden, in welchen Instanztypen diese Dialoge blockiert werden.\n\n|cFF33FF99Bitte beachten:|r\n 1) Diese Funktion behält die NPC Stimme bei, sodass diese gehört werden kann.\n 2) Sicherheitshalber werden nur spezifische Dialoge blockiert. Spezielle oder einmalige Dialoge wie Einmal-Quests werden nicht blockiert."
L.blockTalkingHeadDungeons = "Normale & Heroische Dungeons"
L.blockTalkingHeadMythics = "Mythische & Mythisch+ Dungeons"
L.blockTalkingHeadRaids = "Schlachtzüge"
L.blockTalkingHeadTimewalking = "Zeitwanderung (Dungeons & Schlachtzüge)"
L.blockTalkingHeadScenarios = "Szenarien"

L.redirectPopups = "Popup Banner als BigWigs Nachrichten ausgeben"
L.redirectPopupsDesc = "Popup Banner in der Mitte des Bildschirms wie das '|cFF33FF99Platz für Schatzkammer aufgewertet|r' Banner werden stattdessen als BigWigs Nachrichten angezeigt. Diese Banner können recht groß und lange Zeit angezeigt werden, was die Möglichkeit blockiert durch diese hindurch zu Klicken."
L.redirectPopupsColor = "Farbe der ausgegebenen Nachricht"
L.blockDungeonPopups = "Popup Banner in Instanzen blockieren"
L.blockDungeonPopupsDesc = "Die Popup Banner beim Betreten einer Instanz können sehr lange Texte enthalten. Die Aktivierung dieser Option blockiert diese komplett."
L.itemLevel = "Gegenstandsstufe %d"
L.newRespawnPoint = "Neuer Wiederbelebungspunkt"

L.userNotifySfx = "Soundeffekte wurden von BossBlock deaktiviert, Aktivierung wird erzwungen."
L.userNotifyMusic = "Musik wurde von BossBlock deaktiviert, Aktivierung wird erzwungen."
L.userNotifyAmbience = "Umgebungsgeräusche wurden von BossBlock deaktiviert, Aktivierung wird erzwungen."
L.userNotifyErrorSpeech = "Audiofehlermeldungen wurden von BossBlock deaktiviert, Aktivierung wird erzwungen."

L.subzone_grand_bazaar = "Der Große Basar" -- Battle of Dazar'alor raid (Battle for Azeroth)
L.subzone_port_of_zandalar = "Der Hafen von Zandalar" -- Battle of Dazar'alor raid (Battle for Azeroth)
L.subzone_eastern_transept = "Östliches Transept" -- Auchindoun dungeon (Warlords of Draenor)

-----------------------------------------------------------------------
-- Colors.lua
--

L.colors = "Farben"

L.text = "Text"
L.textShadow = "Textschatten"
L.expiring_normal = "Normal"
L.emphasized = "Hervorgehoben"

L.resetColorsDesc = "Setzt die obenstehenden Farben auf ihre Ausgangswerte zurück."
L.resetAllColorsDesc = "Falls Du veränderte Farbeinstellungen für Bosse benutzt, wird dieser Button ALLE zurücksetzen, sodass erneut die hier festgelegten Farben verwendet werden."

L.red = "Rot"
L.redDesc = "Allgemeine Bosswarnungen."
L.blue = "Blau"
L.blueDesc = "Warnungen für Dinge welche Dich direkt betreffen wie Zauber auf Dir."
L.orange = "Orange"
L.yellow = "Gelb"
L.green = "Grün"
L.greenDesc = "Warnungen für positive Dinge wie ein von Dir entfernter Zauber."
L.cyan = "Cyan"
L.cyanDesc = "Warnungen für Statusänderungen im Bosskampf wie Phasenwechsel."
L.purple = "Violett"
L.purpleDesc = "Warnungen für tankspezifische Fähigkeiten wie ein stapelnder Tankdebuff."

-----------------------------------------------------------------------
-- Countdown.lua
--

L.textCountdown = "Countdown-Text"
L.textCountdownDesc = "Zeige einen sichtbaren Zähler während eines Countdowns."
L.countdownColor = "Countdown-Farbe"
L.countdownVoice = "Countdown-Stimme"
L.countdownTest = "Countdown testen"
L.countdownAt = "Countdown ab... (Sekunden)"
L.countdownAt_desc = "Verbleibende Zeit einer Bossfähigkeit (in Sekunden) wählen, wenn der Countdown beginnt."
L.countdown = "Countdown"
L.countdownDesc = "Die Countdown Funktion besteht aus einem gesprochenen Audio-Countdown sowie einem visuellen Text-Coutdown. Sie ist selten standardmäßig aktiviert, aber kann für jede Bossfähigkeit in den jeweiligen Einstellungen der Bosse aktiviert werden."
L.countdownAudioHeader = "Gesprochener Audio-Countdown"
L.countdownTextHeader = "Visueller Text-Countdown"
L.resetCountdownDesc = "Setzt alle obigen Countdown Einstellungen auf ihre Standardwerte zurück."
L.resetAllCountdownDesc = "Wenn Du veränderte Countdowns für Bossbegegnungen gewählt hast, wird dieser Button ALLE zurücksetzen und die obigen Countdown Einstellungen auf ihre Standardwerte zurücksetzen."

-----------------------------------------------------------------------
-- InfoBox.lua
--

L.infobox_short = "InfoBox"

-----------------------------------------------------------------------
-- Messages.lua
--

L.sinkDescription = "Sendet die BigWigs-Ausgabe durch die normale BigWigs-Nachrichtenanzeige. Diese Anzeige unterstützt Symbole, Farben und kann 4 Nachrichten gleichzeitig anzeigen. Neuere Nachrichten werden größer und schrumpfen dann wieder schnell, um die Aufmerksamkeit dementsprechend zu lenken."
L.emphasizedSinkDescription = "Sendet Ausgaben dieses Addons durch BigWigs’ Anzeige für hervorgehobene Nachrichten. Diese Anzeige unterstützt Text und Farbe und kann nur eine Nachricht gleichzeitig anzeigen."
L.resetMessagesDesc = "Setzt alle Optionen im Zusammenhang mit Nachrichten zurück, inklusive der Position der Anker für Nachrichten."
L.toggleMessagesAnchorsBtnShow_desc = "Zeigt alle Bewegungs-Anker zum Bewegen der Nachrichten."

L.testMessagesBtn = "Testnachricht erstellen"
L.testMessagesBtn_desc = "Erstellt eine Nachricht zum Testen der aktuellen Anzeigeeinstellungen."

L.bwEmphasized = "BigWigs Hervorgehoben"
L.messages = "Nachrichten"
L.emphasizedMessages = "Hervorgehobene Nachrichten"
L.emphasizedDesc = "Hervorgehobene Nachrichten dienen dazu die Aufmerksamkeit zu erregen, indem eine große Nachricht in der Bildschirmmitte angezeigt wird. Diese sind selten standardmäßig aktiviert, aber können für jegliche Bossfähigkeiten in den Einstellungen des jeweiligen Bosses aktiviert werden."
L.uppercase = "GROSSBUCHSTABEN"
L.uppercaseDesc = "Alle hervorgehobenen Nachrichten werden in GROSSBUCHSTABEN konvertiert."

L.useIcons = "Symbole verwenden"
L.useIconsDesc = "Zeigt Symbole neben Nachrichten an."
L.classColors = "Klassenfarben"
L.classColorsDesc = "Teilweise enthalten Nachrichten Spielernamen. Durch Aktivierung dieser Option werden die Namen in Ihrer Klassenfarbe angezeigt."
L.chatFrameMessages = "Chatfenster-Nachrichten"
L.chatFrameMessagesDesc = "Gibt alle BigWigs-Nachrichten im Standard-Chatfenster aus, zusätzlich zu der Einstellung unter 'Ausgabe'."

L.fontSize = "Schriftgröße"
L.none = "Nichts"
L.thin = "Dünn"
L.thick = "Dick"
L.outline = "Kontur"
L.monochrome = "Monochrom"
L.monochromeDesc = "Schaltet den Monochrom-Filter an/aus, der die Schriftenkantenglättung entfernt."
L.fontColor = "Schriftfarbe"

L.displayTime = "Anzeigedauer"
L.displayTimeDesc = "Bestimmt, wie lange (in Sekunden) Nachrichten angezeigt werden."
L.fadeTime = "Ausblendedauer"
L.fadeTimeDesc = "Bestimmt, wie lange (in Sekunden) das Ausblenden der Nachrichten dauert."

L.messagesOptInHeaderOff = "Boss-Mod Nachrichten 'Opt-in' Modus: Durch Aktivierung dieser Option werden die Nachrichten ALLER Bossmodule deaktiviert.\n\nEs ist nötig in jedem Modul händisch die gewünschten Nachrichten zu aktivieren.\n\n"
L.messagesOptInHeaderOn = "Boss-Mod Nachrichten 'Opt-in' Modus ist |cFF33FF99AKTIV|r. Um Boss-Mod Nachrichten zu sehen, muss in den Einstellungen einer spezifischen Bossfähigkeit die '|cFF33FF99Nachrichten|r' Option aktiviert werden.\n\n"
L.messagesOptInTitle = "Boss-Mod Nachrichten 'Opt-in' Modus"
L.messagesOptInWarning = "|cffff4411WARNUNG!|r\n\nDurch Aktivierung des 'Opt-in' Modus werden die Nachrichten ALLER Bossmodule deaktiviert. Zur Aktivierung müssen händisch in jeder gewünschten Bossfähigkeit die Nachrichten aktiviert werden.\n\nDas UI wird jetzt neu geladen, bist Du sicher?"

-----------------------------------------------------------------------
-- Nameplates.lua
--

L.nameplates = "Namensplaketten"
L.testNameplateIconBtn = "Testsymbol anzeigen"
L.testNameplateIconBtn_desc = "Erstellt ein Testsymbol zum Testen der aktuellen Symboleinstellungen an der anvisierten Namensplakette."
L.testNameplateTextBtn = "Testtext anzeigen"
L.testNameplateTextBtn_desc = "Erstellt einen Testtext zum Testen der aktuellen Texteinstellungen an der anvisierten Namensplakette."
L.stopTestNameplateBtn = "Tests stoppen"
L.stopTestNameplateBtn_desc = "Stoppt die Symbol- und Texttests an den Namensplaketten."
L.noNameplateTestTarget = "Es muss ein feindliches angreifbares Ziel zum Testen der Namensplaketten-Funktionen anvisiert werden."
L.anchoring = "Verankerung"
L.growStartPosition = "Startposition der Symbole"
L.growStartPositionDesc = "Die Startposition für das erste Symbol."
L.growDirection = "Richtung der Symbole"
L.growDirectionDesc = "Die Richtung in welche die Symbole von der Startposition wachsen."
L.iconSpacingDesc = "Abstand zwischen den Symbolen ändern."
L.nameplateIconSettings = "Symboleinstellungen"
L.keepAspectRatio = "Seitenverhältnis beibehalten"
L.keepAspectRatioDesc = "Behält das Seitenverhältnis des Symbols 1:1 bei, anstatt es in den Rahmen passend zu Strecken."
L.iconColor = "Symbolfarbe"
L.iconColorDesc = "Ändert die Farbe der Symboltextur."
L.desaturate = "Entsättigen"
L.desaturateDesc = "Entsättigt die Symboltextur."
L.zoom = "Zoom"
L.zoomDesc = "Zoomt die Symboltextur."
L.showBorder = "Rand anzeigen"
L.showBorderDesc = "Zeigt einen Rand um das Symbol."
L.borderColor = "Randfarbe"
L.borderSize = "Randgröße"
L.showNumbers = "Zahlen anzeigen"
L.showNumbersDesc = "Zeigt Zahlen auf dem Symbol an."
L.cooldown = "Abklingzeit"
L.showCooldownSwipe = "Zirkel anzeigen"
L.showCooldownSwipeDesc = "Zeigt einen Zirkel auf der Abklingzeit, wenn diese aktiv ist."
L.showCooldownEdge = "Kante hervorheben"
L.showCooldownEdgeDesc = "Hebt die Kante des Zirkels auf der Abklingzeit hervor, wenn diese aktiv ist."
L.inverse = "Invertieren"
L.inverseSwipeDesc = "Invertiert die Abklingzeit Animationen."
L.glow = "Leuchten"
L.enableExpireGlow = "Aktiviere Leuchten beim Ablaufen"
L.enableExpireGlowDesc = "Zeigt ein Leuchten um das Symbol wenn die Abklingzeit abgelaufen ist."
L.glowColor = "Leuchtfarbe"
L.glowType = "Leuchttyp"
L.glowTypeDesc = "Ändert den Leuchttyp der um das Symbol angezeigt wird."
L.resetNameplateIconsDesc = "Setzt alle Optionen für Namensplaketten-Symbole zurück."
L.nameplateTextSettings = "Texteinstellungen"
L.fixate_test = "Fixierung Test" -- Text that displays to test on the frame
L.resetNameplateTextDesc = "Setzt die Optionen für Namensplaketten-Texte zurück."
L.glowAt = "Leuchten beginnen (Sekunden)"
L.glowAt_desc = "Legt fest, bei welcher verbleibenden Abklingzeit in Sekunden das Leuchten beginnt."
L.headerIconSizeTarget = "Symbolgröße des aktuellen Ziels"
L.headerIconSizeOthers = "Symbolgröße aller anderen Ziele"
L.headerIconPositionTarget = "Symbolposition des aktuellen Ziels"
L.headerIconPositionOthers = "Symbolposition der anderen Ziele"

-- Glow types as part of LibCustomGlow
L.pixelGlow = "Pixel-Leuchten"
L.autocastGlow = "Autozauber-Leuchten"
L.buttonGlow = "Button-Leuchten"
L.procGlow = "Proc-Leuchten"
L.speed = "Geschwindigkeit"
L.animation_speed_desc = "Die Geschwindigkeit der Leuchtanimation."
L.lines = "Linien"
L.lines_glow_desc = "Die Anzahl der Linien in der Leuchtanimation."
L.intensity = "Intensität"
L.intensity_glow_desc = "Die Intensität des Leuchteffektes, höher bedeutet mehr Funken."
L.length = "Länge"
L.length_glow_desc = "Die Länge der Linien in der Leuchtanimation."
L.thickness = "Dicke"
L.thickness_glow_desc = "Die Dicke der Linien in der Leuchtanimation."
L.scale = "Maßstab"
L.scale_glow_desc = "Der Maßstab der Funken in der Animation."
L.startAnimation = "Startanimation"
L.startAnimation_glow_desc = "Dieses Leuchten hat eine Startanimation, dies aktiviert/deaktiviert diese Animation."

L.nameplateOptInHeaderOff = "\n\n\n\nBoss-Mod Namensplaketten 'Opt-in' Modus: Durch Aktivierung dieser Option werden die Namensplaketten ALLER Bossmodule deaktiviert.\n\nEs ist nötig in jedem Modul händisch die gewünschten Namensplaketten zu aktivieren.\n\n"
L.nameplateOptInHeaderOn = "\n\n\n\nBoss-Mod Namensplaketten 'Opt-in' Modus ist |cFF33FF99AKTIV|r. Um Boss-Mod Namensplaketten zu sehen, muss in den Einstellungen einer spezifischen Bossfähigkeit die '|cFF33FF99Namensplaketten|r' Option aktiviert werden.\n\n"
L.nameplateOptInTitle = "Boss-Mod Namensplaketten 'Opt-in' Modus"
L.nameplateOptInWarning = "|cffff4411WARNUNG!|r\n\nDurch Aktivierung des 'Opt-in' Modus werden die Namensplaketten ALLER Bossmodule deaktiviert. Zur Aktivierung müssen händisch in jeder gewünschten Bossfähigkeit die Namensplaketten aktiviert werden.\n\nDas UI wird jetzt neu geladen, bist Du sicher?"

-----------------------------------------------------------------------
-- Proximity.lua
--

L.customRange = "Eigene Näherungsanzeige"
L.proximityTitle = "%d m / %d Spieler"
L.proximity_name = "Nähe"
L.soundDelay = "Soundverzögerung"
L.soundDelayDesc = "Gibt an, wie lange BigWigs zwischen den Soundwiederholungen wartet, wenn jemand zu nahe steht."

L.resetProximityDesc = "Setzt alle Optionen im Zusammenhang mit Nähe zurück, inklusive der Position des Ankers für Nähe."

L.close = "Schließen"
L.closeProximityDesc = "Schließt die Anzeige naher Spieler.\n\nFalls Du die Anzeige für alle Bosse deaktivieren willst, musst Du die Option 'Nähe' seperat in den jeweiligen Bossmodulen ausschalten."
L.lock = "Fixieren"
L.lockDesc = "Fixiert die Anzeige und verhindert weiteres Verschieben und Anpassen der Größe."
L.title = "Titel"
L.titleDesc = "Zeigt oder versteckt den Titel der Anzeige."
L.background = "Hintergrund"
L.backgroundDesc = "Zeigt oder versteckt den Hintergrund der Anzeige."
L.toggleSound = "Sound an/aus"
L.toggleSoundDesc = "Schaltet den Sound ein oder aus, der gespielt wird, wenn Du zu nahe an einem anderen Spieler stehst."
L.soundButton = "Sound-Button"
L.soundButtonDesc = "Zeigt oder versteckt den Sound-Button."
L.closeButton = "Schließen-Button"
L.closeButtonDesc = "Zeigt oder versteckt den Schließen-Button."
L.showHide = "Zeigen/Verstecken"
L.abilityName = "Fähigkeitsname"
L.abilityNameDesc = "Zeigt oder versteckt den Fähigkeitsnamen über dem Fenster."
L.tooltip = "Tooltip"
L.tooltipDesc = "Zeigt oder versteckt den Zaubertooltip, wenn die Näheanzeige direkt an eine Bossfähigkeit gebunden ist."

-----------------------------------------------------------------------
-- Pull.lua
--

L.countdownType = "Countdowntyp"
L.combatLog = "Automatische Kampfaufzeichnung"
L.combatLogDesc = "Startet automatisch die Aufzeichnung des Kampfes, wenn ein Pull-Timer gestartet wurde und beendet die Aufzeichnung, wenn der Bosskampf endet."

L.pull = "Pull"
L.engageSoundTitle = "Spiele  einen Sound ab, sobald ein Bosskampf beginnt"
L.pullStartedSoundTitle = "Spiele einen Sound ab, sobald ein Pull-Timer gestartet wurde"
L.pullFinishedSoundTitle = "Spiele einen Sound ab, sobald ein Pull-Timer abgelaufen ist"
L.pullStartedBy = "Pull-Timer gestartet von %s."
L.pullStopped = "Pull-Timer von %s abgebrochen."
L.pullStoppedCombat = "Pull-Timer wurde abgebrochen, weil Du einen Kampf begonnen hast."
L.pullIn = "Pull in %d Sek."
L.sendPull = "Sendet einen Pull-Timer an die Gruppe."
L.wrongPullFormat = "Ungültiger Pull-Timer. Ein korrektes Beispiel ist: /pull 5"
L.countdownBegins = "Countdown starten"
L.countdownBegins_desc = "Verbleibende Zeit des Pulltimers (in Sekunden) wählen, wenn der Countdown beginnt."
L.pullExplainer = "\n|cFF33FF99/pull|r startet einen normalen Pulltimer.\n|cFF33FF99/pull 7|r startet einen 7-sekündigen Pulltimer, es kann jede Zahl verwendet werden.\nAlternativ kann unten auch eine Tastenbelegung festgelegt werden.\n\n"
L.pullKeybindingDesc = "Tastenbelegung für den Start eines Pulltimers wählen."

-----------------------------------------------------------------------
-- RaidIcon.lua
--

L.icons = "Symbole"
L.raidIconsDescription = "Einige Begegnungen schließen Elemente wie 'Bombenfähigkeiten' ein, die einen bestimmten Spieler zum Ziel haben, ihn verfolgen oder er ist in sonst einer Art und Weise interessant. Hier kannst du bestimmen, welche Schlachtzugs-Symbole benutzt werden sollen, um die Spieler zu markieren.\n\nFalls nur ein Symbol benötigt wird, wird nur das erste benutzt. Ein Symbol wird niemals für zwei verschiedene Fähigkeiten innerhalb einer Begegnung benutzt.\n\n|cffff4411Beachte, dass ein manuell markierter Spieler von BigWigs nicht ummarkiert wird.|r"
L.primary = "Erstes Symbol"
L.primaryDesc = "Das erste Schlachtzugssymbol, das verwendet wird."
L.secondary = "Zweites Symbol"
L.secondaryDesc = "Das zweite Schlachtzugssymbol, das verwendet wird."

-----------------------------------------------------------------------
-- Sound.lua
--

L.Sounds = "Sounds"
L.soundsDesc = "BigWigs nutzt den 'Haupt'-Soundkanal um die Sounds wiederzugeben. Wenn die Sounds zu leise oder zu laut sind, kann dies in den WoW Soundoptionen mit dem Schieberegler 'Gesamtlautstärke' angepasst werden.\n\nFolgend können global die verschiedenen Sounds für spezifische Aktionen konfiguriert, oder zum Deaktivieren auf 'None' gesetzt werden. Wenn der Sound einer spezifischen Bossfähigkeit geändert werden soll, kann dies in den Einstellungen der Bossbegegnung eingestellt werden.\n\n"
L.oldSounds = "Alte Sounds"

L.Alarm = "Alarm"
L.Info = "Info"
L.Alert = "Alarmruf"
L.Long = "Lang"
L.Warning = "Warnung"
L.onyou = "Ein Zauber, Stärkungs- oder Schwächungszauber ist auf Dir"
L.underyou = "Du musst aus einem Zauber unter Dir herauslaufen"
L.privateaura = "Immer wenn eine 'Private Aura' auf Dir ist"

L.customSoundDesc = "Den speziell gewählten Sound anstatt des vom Modul bereitgestellten abspielen."
L.resetSoundDesc = "Setzt die obigen Sounds auf ihren Standard zurück."
L.resetAllCustomSound = "Wenn Du Sounds für Bossbegegnungen geändert hast, werden diese ALLE über diese Schaltfläche zurückgesetzt, sodass stattdessen die hier gewählten genutzt werden."

-----------------------------------------------------------------------
-- Statistics.lua
--

L.bossStatistics = "Boss-Statistiken"
L.bossStatsDescription = "Aufzeichnung verschiedener Boss-bezogener Statistiken wie die Anzahl der Siege, die Anzahl der Niederlagen, das Datum des ersten Sieges und der schnellste Sieg. Diese Statistiken können, falls vorhanden, in der Konfiguration der einzelnen Bosse eingesehen werden. Andernfalls werden diese ausgeblendet."
L.createTimeBar = "Bestzeittimer anzeigen"
L.bestTimeBar = "Bestzeit"
L.healthPrint = "Gesundheit: %s."
L.healthFormat = "%s (%.1f%%)"
L.chatMessages = "Chatnachrichten"
L.newFastestVictoryOption = "Neuer schnellster Sieg"
L.victoryOption = "Du warst erfolgreich"
L.defeatOption = "Du wurdest besiegt"
L.bossHealthOption = "Bossgesundheit"
L.bossVictoryPrint = "Du hast '%s' nach %s besiegt." -- You were victorious against 'BOSS_NAME' after COMBAT_DURATION.
L.bossDefeatPrint = "Du wurdest von '%s' nach %s besiegt." -- You were defeated by 'BOSS_NAME' after COMBAT_DURATION.
L.newFastestVictoryPrint = "Neuer schnellster Sieg: (-%s)" -- New fastest victory: (-COMBAT_DURATION)

-----------------------------------------------------------------------
-- Victory.lua
--

L.Victory = "Sieg"
L.victoryHeader = "Konfiguriert die Aktionen, die nach einem erfolgreichen Bosskampf stattfinden."
L.victorySound = "Spiele einen Sieges-Sound"
L.victoryMessages = "Nachrichten nach Sieg über einen Boss zeigen"
L.victoryMessageBigWigs = "Die Mitteilung von BigWigs anzeigen"
L.victoryMessageBigWigsDesc = "Die Mitteilung von BigWigs ist eine einfache \"Boss wurde besiegt\" Mitteilung."
L.victoryMessageBlizzard = "Die Blizzard-Mitteilung anzeigen"
L.victoryMessageBlizzardDesc = "Die Blizzard-Mitteilung ist eine sehr große \"Boss wurde besiegt\" Animation in der Mitte deines Bildschirms."
L.defeated = "%s wurde besiegt!"

-----------------------------------------------------------------------
-- Wipe.lua
--

L.wipe = "Niederlage"
L.wipeSoundTitle = "Spiele bei einer Niederlage einen Sound ab"
L.respawn = "Erneutes Erscheinen"
L.showRespawnBar = "Erneutes-Erscheinen-Leiste anzeigen"
L.showRespawnBarDesc = "Zeigt nach einer Niederlage eine Leiste mit der Zeit bis zum erneuten Erscheinen des Bosses an."
