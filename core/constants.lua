---------------------------------------------------------------------------------------------------
----GENERAL CRAP
---------------------------------------------------------------------------------------------------
ROOTICONPATH ="Interface/ICONS"
MEDIAPATH = "Interface\\AddOns\\mWarlock\\media"
MAINFRAME_ISMOVING = false
READYSTR = "RDY"
NOSSSTR = "N/A"
READYTEXT = "RDY"
GCD = 1 --w as 1.5
DEFAULT_FRAMESIZE = 150
DEFAULT_RADIUS = 150

MAINBG_FRAMENAME = "MWarlockBGFrame"
HANDOFGUL_FRAMENAME = "HandOfGulFrame"

FELLSTORM_SPELLNAME = "Felstorm"
SHARD_FRAMENAME = "MWShardFrame"
---------------------------------------------------------------------------------------------------
----SPELL INFO - HARD CODED FOR NOW CAUSE I DO NOT WANT TO HAVE TO SETUP OPTIONS FOR TRACKING SELECTIONS YET
---------------------------------------------------------------------------------------------------
-- WARLOCK
POWERSIPHON_SPELLNAME = "Power Siphon"
DEMONICCORE_SPELLNAME = "Demonic Core"
INQUISITORSGAZE_SPELLNAME = "Inquisitor's Gaze"
SUMMONSOULKEEPER_SPELLNAME = "Summon Soulkeeper"
DEMONICPOWER_SPELLNAME = "Demonic Power"
SUMMONDT_SPELLNAME = "Summon Demonic Tyrant"
SUMMONVF_SPELLNAME = "Summon VileFiend"
NETHERPORTAL_SPELLNAME = "Nether Portal"
GRIMFELGUARD_SPELLNAME = "Grimoire: Felguard"
CALLDREADSTALKERS_SPELLNAME = "Call Dreadstalkers"
IMPLOSION_SPELLNAME = "Implosion"
SHADOWFURY_SPELLNAME = "ShadowFury"
CORRUPTION_SPELLNAME = "Corruption"
UNSTABLEAFFLICTION_SPELLNAME = "Unstable Affliction"
AGONY_SPELLNAME = "Agony"
DEATHBOLT_SPELLNAME = "Deathbolt"
HANDOFGULDAN_SPELLNAME = "Hand of Gul'dan"
---------------------------------------------------------------------------------------------------
--- SHADOW PRIEST
DARKASCENSION_SPELLNAME = "Dark Ascension"
DISPERSION_SPELLNAME = "Dispersion"
MINDGAMES_SPELLNAME = "Mindgames"
HALO_SPELLNAME = "Halo"
VAMPIRICTOUCH_SPELLNAME = "Vampiric Touch"
DEVOURINGPLAGUE_SPELLNAME = "Devouring Plague"
MINDBLAST_SPELLNAME = "Mind Blast"
SHADOWYINSIGHT_SPELLNAME = "Shadowy Insight"
MINDSPIKE_SPELLNAME = "Mind Spike"
MINDMELT_SPELLNAME = "Mind Melt"
VOIDERUPTION_SPELLNAME = "Void Eruption"
VOIDBOLT_SPELLNAME = "Void Bolt"
MINDDEVOURER_SPELLNAME = "Mind Devourer"
SHADOWWORDDEATH_SPELLNAME = "Shadow Word: Death"
SHADOWWORDPAIN_SPELLNAME = "Shadow Word: Pain"
VOIDFORM_SPELLNAME = "Voidform"
MINDSEAR_SPELLNAME = "Mind Sear"
MINDFLAYINSANITY_SPELLNAME = "Mind Flay: Insanity"
MINDFLAY_SPELLNAME = "Mind Flay"
---------------------------------------------------------------------------------------------------
-- SHAMAN
CAPACITOR_SPELLNAME = "Capacitor Totem"
EARTHBIND_SPELLNAME = "Earthbind Totem"
HEALINGSTREAM_SPELLNAME = "Healing Stream Totem"
HEALINGTIDETOTEM_SPELLNAME = "Healing Tide Totem"
SPIRITLINKTOTEM_SPELLNAME = "Spirit Link Totem"
---------------------------------------------------------------------------------------------------
linkedSpells = {}
linkedSpells[HANDOFGULDAN_SPELLNAME] = {DEMONICCORE_SPELLNAME, 571321}
linkedSpells[MINDBLAST_SPELLNAME] = {SHADOWYINSIGHT_SPELLNAME, 136183}
linkedSpells[MINDSPIKE_SPELLNAME] = {MINDMELT_SPELLNAME, 391092}
linkedSpells[DEVOURINGPLAGUE_SPELLNAME] = {MINDDEVOURER_SPELLNAME, 252996}
linkedSpells[VOIDERUPTION_SPELLNAME] ={VOIDFORM_SPELLNAME, 1386550}
linkedSpells[MINDSEAR_SPELLNAME] = {MINDDEVOURER_SPELLNAME, 135740}
linkedSpells[MINDFLAY_SPELLNAME] = {MINDFLAYINSANITY_SPELLNAME, 391401}