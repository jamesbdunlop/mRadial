local AceLocale = LibStub:GetLibrary("AceLocale-3.0");
local L = AceLocale:NewLocale("mRadial", "deDE");
if not L then return end

L["Opt_GenericOptions_name"] = "Allgemeine Optionen"
L["Opt_GenericOptions_desc"] = "Diese gelten für die gesamte Benutzeroberfläche"

L["Opt_ConfigMode_name"] = "Konfigurationsmodus"
L["Opt_ConfigMode_desc"] = "Aktiviert/Deaktiviert den Konfigurationsmodus."

L["Opt_HideOutOfCombat_name"] = "Außerhalb des Kampfes ausblenden"
L["Opt_HideOutOfCombat_desc"] = "Aktiviert/Deaktiviert das Ausblenden der Benutzeroberfläche außerhalb des Kampfes."

L["Opt_HideMiniMapIcon_name"] = "Minikarten-Symbol ausblenden"
L["Opt_HideMiniMapIcon_desc"] = "Aktiviert/Deaktiviert das Minikarten-Symbol zugunsten des neuen Addon-Behälters. Diese Änderung tritt nach dem nächsten Neuladen/Anmelden in Kraft."

L["Opt_ABOUT_name"] = "ÜBER"
L["Opt_ABOUT_desc"] = "Willkommen bei mRadial, einer kleinen Benutzeroberfläche zum Verfolgen von Zauber-Timern usw. \
\nSie haben einen primären und einen sekundären radialen Rahmen, um Zauber zur Beobachtung zuzuweisen. Diese können bei Bedarf auch als anklickbare Schaltflächen festgelegt werden. \
\nWarum habe ich das geschrieben? Nun, ich möchte meinen Fokus so weit wie möglich auf meinen Charakter halten, und dieses Addon hilft dabei, die wichtigsten Zauber, die ich verfolgen möchte, in einem schönen, engen Kreis um den Charakter herum zu behalten (damit ich nicht im Feuer stehe, okay!) \
\nFür weitere Informationen besuchen Sie bitte das Wiki über CurseForge. \
\n \n"

L["Opt_CHANGELOG_name"] = "ÄNDERUNGSPROTOKOLL"

L["Opt_RadialIcons_name"] = "Radiale Symbole"
L["Opt_RadialIcons_desc"] = "Verwenden Sie dies, um die Zauber-Symbole und verschiedene Text-Timer zu ändern."

L["Opt_BaseIconOptions_name"] = "Basis-Symboloptionen"
L["Opt_BaseIconOptions_desc"] = "Verwenden Sie diese Optionen, um die Anzeige der 'Watcher'-Symbole zu beeinflussen."

L["Opt_general_name"] = "Allgemein"

L["Opt_AutoSpread_name"] = "Automatische Verteilung"
L["Opt_AutoSpread_desc"] = "Aktiviert/Deaktiviert eine automatische Verteilung um den radialen Rahmen."

L["Opt_AsButtons_name"] = "Als Schaltflächen"
L["Opt_AsButtons_desc"] = "Aktiviert/Deaktiviert die Symbole als Schaltflächen. \n Erfordert Neuladen. \n STANDARD: Falsch"

L["Opt_Dimensions_name"] = "Abmessungen"

L["Opt_HideSecondary_name"] = "Sekundäre ausblenden"
L["Opt_HideSecondary_desc"] =  "Aktiviert/deaktiviert sekundäre Symbole. STANDARD: Falsch"

L["Opt_RadiusMultiplyer_name"] = "Radius-Multiplikator"
L["Opt_RadiusMultiplyer_desc"] = "Verwenden Sie dies, um eine globale Änderung der Radiusgröße vorzunehmen. STANDARD: %100."

L["Opt_SpellIconSize_name"] = "Zauber-Symbolgröße"
L["Opt_SpellIconSize_desc"] = "Verwenden Sie dies, um die Größe der Zauber-Symbole zu ändern. STANDARD: 40"

L["Opt_Primary_name"] = "Primär"

L["Opt_Radius_name"] = "Radius"
L["Opt_Radius_desc"] = "Verwenden Sie dies, um die Größe (Radius) des Kreises zu ändern. STANDARD: 50"

L["Opt_Spread_name"] = "Verteilung"
L["Opt_Spread_desc"] = "Verwenden Sie dies, um die Verteilung der Zauber-Symbole um den Kreis zu ändern."

L["Opt_Offset_name"] = "Versatz"
L["Opt_Offset_desc"] = "Verwenden Sie dies, um den Startort der Zauber-Symbole um den Kreis herum zu versetzen. STANDARD: .7"

L["Opt_WidthAdjust_name"] = "Breitenanpassung"
L["Opt_WidthAdjust_desc"] = "Verwenden Sie dies, um die Breite des Kreises zu ändern. Dadurch entsteht horizontal eine ovale Form. STANDARD: 1"

L["Opt_HeightAdjust_name"] = "Höhenanpassung"
L["Opt_HeightAdjust_desc"] = "Verwenden Sie dies, um die Höhe des Kreises zu ändern. Dadurch entsteht vertikal eine ovale Form. STANDARD: 1"

L["Opt_Text_name"] = "Text/Schriften"

L["Opt_Font_name"] = "Schriftart"

L["Opt_HeightAdjust_name"] = "Höhenanpassung"
L["Opt_HeightAdjust_desc"] = "Verwenden Sie dies, um die Höhe des Kreises zu ändern. Dadurch entsteht vertikal eine ovale Form. STANDARD: 1"

L["Opt_GlobalFont%_name"] = "Globale Schriftgröße %"
L["Opt_GlobalFont%_desc"] = "Dies steuert die Gesamtschriftgröße für die Benutzeroberfläche. Eine Einstellung von 50% entspricht 50% der aktuellen Symbolgröße. STANDARD: %50"

L["Opt_FontSizeOverrides_name"] = "Schriftgrößenüberschreibungen"

L["Opt_count_name"] = "Anzahl"
L["Opt_ready_name"] = "Bereit"
L["Opt_CoolDown_name"] = "Abklingzeit"
L["Opt_timer_name"] = "Timer"
L["Opt_linked_name"] = "Verknüpft"
L["Opt_fontAdjustWarning_name"] = "--- Schalten Sie den Konfigurationsmodus ein, während Sie die untenstehenden Parameter anpassen ---"

L["Opt_DEFAULT2_desc"] = "STANDARD: 2"

L["Opt_radialSpells_desc"] = "Radiale Zauber"

L["Opt_fagDesc_desc"] = "--Verwenden Sie dies, um die Zauber auszuwählen, die im primären und sekundären radialen Rahmen überwacht werden sollen.--"

L["Opt_hidePassiveSpells_name"] = "Passive Zauber ausblenden"

L["Opt_primarySpellOrder_name"] = "Primäre Zauberreihenfolge"
L["Opt_primarySpells_name"] = "Primäre Zauber"
L["Opt_secondarySpellOrder_name"] = "Sekundäre Zauberreihenfolge"
L["Opt_secondarySpells_name"] = "Sekundäre Zauber"

L["Opt_linkedSpells_name"] = "Verknüpfte Zauber"

L["Opt_warlock_name"] = "Hexenmeister"

L["Opt_PetFrames_name"] = "Begleiter-Fenster"
L["Opt_HidePetFrames_name"] = "Begleiter-Fenster ausblenden"
L["Opt_HidePetFrames_desc"] = "Zeige/Verberge die Begleiter-Fenster des Hexenmeisters."

L["Opt_IconSize_name"] = "Symbolgröße"
L["Opt_IconSize_desc"] = "Verwenden Sie dies, um die Größe der Zauber-Symbole zu ändern."

L["Opt_ShardFrames_name"] = "Splitter-Fenster"

L["Opt_OutOfShardsFrameSize_name"] = "Größe des 'Out of Shards'-Fensters"
L["Opt_OutOfShardsFrameSize_desc"] = "Verwenden Sie dies, um das Fenster zu ändern, das den 'Out of Shards'-Kreis anzeigt. Schalten Sie den Konfigurationsmodus für dies ein!"

L["Opt_ShardTrackerFrameSize_name"] = "Größe des Splitter-Tracker-Fensters"
L["Opt_ShardTrackerFrameSize_desc"] = "Verwenden Sie dies, um das Fenster zu ändern, das das benutzerdefinierte Splitter-Tracker-Fenster anzeigt."

L["Opt_ShardTrackerTrans_name"] = "Transparenz des Splitter-Fensters"
L["Opt_ShardTrackerTrans_desc"] = "Verwenden Sie dies, um die Transparenz des Splitter-Fensters zu ändern. Schalten Sie den Konfigurationsmodus dafür ein."

L["Opt_HideShardTracker_name"] = "Splitter-Fenster ausblenden"
L["Opt_HideShardTracker_desc"] = "Zeige/Verberge das Splitter-Tracker-Fenster des Hexenmeisters."

L["Opt_RDY_name"] = "RDY"
L["Opt_NOSSSTR_name"] = "N/A"
L["Opt_OOR_name"] = "OOR"

L["Opt_LinkedSpellsInfo_name"] = "Verknüpfte Zauber sind eine Möglichkeit, einen Buff mit einem Kernzauber zu verknüpfen. \
\n z.B.: Wenn man Demonischer Schlag mit Dämonenkern verknüpft, wird ein Timer neben Demonischer Schlag gestartet, wenn Dämonenkern aktiviert wird, um das Timing der Zauber zu ermöglichen usw. \
\n Anleitung: \
\n Ziehe einen Zauber aus dem Zauberbuch in das linke Eingabefeld. Gib den Namen des Zaubers ein (oder ziehe ihn), um ihn mit dem verknüpften Zauber zu verbinden. Die Zauber-ID sollte automatisch ausgefüllt werden. \
\n Hinweis: Quell-Zaubernamen sind eindeutig und können nur einmal verknüpft werden."

L["Opt_LinkedSpellsLinkedTo_name"] = "verknüpft mit:"

L["Opt_LinkedSpellsRemove_name"] = "Entfernen"

L["Opt_LinkedSpellsPane_name"] = "Verknüpfte Zauber (Buffs):"

L["Opt_LinkedSpellsAdd_name"] = "Hinzufügen"

L["Opt_LinkedSpellsGrp_name"] = "Verknüpfte Zauber"

L["Opt_Felguard"] = "Teufelswache"
L["Opt_Wrathguard"] = "Zornwache"
L["Opt_DemonicStrength"] = "Dämonische Stärke"
L["Opt_FelStorm"] = "Teufelssturm"
L["Opt_AxeToss"] = "Axtwurf"
L["Opt_SoulStrike"] = "Seelenschlag"

L["Opt_Succubus"] = "Sukkubus"
L["Opt_Incubus"] = "Inkubus"