---------------------------------------------------------------------------------------------------
----GENERAL CRAP
---------------------------------------------------------------------------------------------------
ROOTICONPATH ="Interface/ICONS"
MEDIAPATH = "Interface\\AddOns\\mWarlock\\media"
MAINFRAME_ISMOVING = false
READYSTR = "RDY"
NOSSSTR = "N/A"
READYTEXT = "RDY"
GCD = 1.5
DEFAULT_FRAMESIZE = 150
DEFAULT_RADIUS = 150

MAINBG_FRAMENAME = "MWarlockBGFrame"
HANDOFGUL_FRAMENAME = "HandOfGulFrame"

FELLSTORM_SPELLNAME = "Felstorm"
SHARD_FRAMENAME = "MWShardFrame"
---------------------------------------------------------------------------------------------------
----SPELL INFO - HARD CODED FOR NOW CAUSE I DO NOT WANT TO HAVE TO SETUP OPTIONS FOR TRACKING SELECITONS YET
---------------------------------------------------------------------------------------------------
-- Demo Spells of interest
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

--skipBuff, buffName, isUnitPowerDependant, UnitPowerCount, isDebuff = spellInfo
demo_spellOrder = {}
demo_spellOrder[POWERSIPHON_SPELLNAME] = {false, DEMONICCORE_SPELLNAME, false, 0, false}
demo_spellOrder[CALLDREADSTALKERS_SPELLNAME] = {true, nil, true, 2, false}
demo_spellOrder[INQUISITORSGAZE_SPELLNAME] = {false, nil, false, 0, false}
demo_spellOrder[SUMMONSOULKEEPER_SPELLNAME] = {false, nil, false, 0, false}
demo_spellOrder[SUMMONDT_SPELLNAME] = {false, nil, false, 0, false}
demo_spellOrder[SUMMONVF_SPELLNAME] = {false, nil, false, 0, false}
demo_spellOrder[NETHERPORTAL_SPELLNAME] = {true, nil, true, 1, false}
demo_spellOrder[GRIMFELGUARD_SPELLNAME] = {true, nil, true, 1, false}
demo_spellOrder[IMPLOSION_SPELLNAME] = {true, nil, false, 0, false}
demo_spellOrder[SHADOWFURY_SPELLNAME] = {true, nil, false, 0, false}

---------------------------------------------------------------------------------------------------
-- Affliction Spells of interest
CORRUPTION_SPELLNAME = "Corruption"
UNSTABLEAFFLICTION_SPELLNAME = "Unstable Affliction"
AGONY_SPELLNAME = "Agony"
DEATHBOLT_SPELLNAME = "Deathbolt"

aff_spellOrder = {}
aff_spellOrder[CORRUPTION_SPELLNAME] = {true, nil, false, 0, false}
aff_spellOrder[UNSTABLEAFFLICTION_SPELLNAME] = {true, nil, false, 0, false}
aff_spellOrder[AGONY_SPELLNAME] = {true, nil, false, 0, false}
aff_spellOrder[DEATHBOLT_SPELLNAME] = {true, nil, false, 0, false}

---------------------------------------------------------------------------------------------------
-- Destruction Spells of interest
destro_spellOrder = {}

---------------------------------------------------------------------------------------------------
--- SHADOW PRIEST -- yay for alts!
DARKASCENSION_SPELLNAME = "Dark Ascension"
DISPERSION_SPELLNAME = "Dispersion"
MINDGAMES_SPELLNAME = "Mindgames"
HALO_SPELLNAME = "Halo"
VAMPIRICTOUCH_SPELLNAME = "Vampiric Touch"
DEVOURINGPLAGUE_SPELLNAME = "Devouring Plague"
MINDBLAST_SPELLNAME = "Mind Blast"
SHADOWYINSIGHT_SPELLNAME ="Shadowy Insight"


shadow_spellOrder = {}
shadow_spellOrder[MINDBLAST_SPELLNAME] = {false, SHADOWYINSIGHT_SPELLNAME, false, 0, false}
shadow_spellOrder[VAMPIRICTOUCH_SPELLNAME] = {true, nil, false, 0, true}
shadow_spellOrder[DEVOURINGPLAGUE_SPELLNAME] = {true, nil, true, 50, true}
shadow_spellOrder[MINDGAMES_SPELLNAME] = {true, nil, false, 0, true}
shadow_spellOrder[DARKASCENSION_SPELLNAME] = {true, nil, false, 0, true}
shadow_spellOrder[DISPERSION_SPELLNAME] = {true, nil, false, 0, true}
shadow_spellOrder[HALO_SPELLNAME] = {true, nil, false, 0, true}

---------------------------------------------------------------------------------------------------
----ICONS
---------------------------------------------------------------------------------------------------
spellIcons = {}
-- Demo
spellIcons[POWERSIPHON_SPELLNAME] = string.format("%s/Ability_warlock_backdraft.blp", ROOTICONPATH)
spellIcons[DEMONICCORE_SPELLNAME] = string.format("%s/Warlock_spelldrain.blp", ROOTICONPATH)
spellIcons[CALLDREADSTALKERS_SPELLNAME] = string.format("%s/Spell_warlock_calldreadstalkers.blp", ROOTICONPATH)
spellIcons[INQUISITORSGAZE_SPELLNAME] = string.format("%s/Inv_pet_inquisitoreye.blp", ROOTICONPATH)
spellIcons[SUMMONSOULKEEPER_SPELLNAME] = string.format("%s/Spell_fel_elementaldevastation.blp", ROOTICONPATH)
spellIcons[SUMMONDT_SPELLNAME] = string.format("%s/Inv_summondemonictyrant.blp", ROOTICONPATH)
spellIcons[DEMONICPOWER_SPELLNAME] = string.format("%s/Inv_summondemonictyrant.blp", ROOTICONPATH)
spellIcons[SUMMONVF_SPELLNAME] = string.format("%s/Inv_argusfelstalkermount.blp", ROOTICONPATH)
spellIcons[NETHERPORTAL_SPELLNAME] = string.format("%s/Inv_netherportal.blp", ROOTICONPATH)
spellIcons[GRIMFELGUARD_SPELLNAME] = string.format("%s/Spell_shadow_summonfelguard.blp", ROOTICONPATH)
spellIcons[IMPLOSION_SPELLNAME] = string.format("%s/Inv_implosion.blp", ROOTICONPATH)
spellIcons[SHADOWFURY_SPELLNAME] = string.format("%s/Ability_warlock_shadowfurytga.blp", ROOTICONPATH)
-- Affliction
spellIcons[CORRUPTION_SPELLNAME] = string.format("%s/Spell_shadow_abominationexplosion.blp", ROOTICONPATH)
spellIcons[UNSTABLEAFFLICTION_SPELLNAME] = string.format("%s/Spell_shadow_unstableaffliction_3.blp", ROOTICONPATH)
spellIcons[AGONY_SPELLNAME] = string.format("%s/Spell_shadow_curseofsargeras.blp", ROOTICONPATH)
spellIcons[DEATHBOLT_SPELLNAME] = string.format("%s/Spell_fire_twilightflamebolt.blp", ROOTICONPATH)

-- Priest
-- Shadow
spellIcons[MINDBLAST_SPELLNAME] = string.format("%s/Spell_shadow_unholyfrenzy.blp", ROOTICONPATH)
spellIcons[SHADOWYINSIGHT_SPELLNAME] = string.format("%s/Spell_shadow_possession.blp", ROOTICONPATH)
---------------------------------------------------------------------------------------------------------
-- DESTRO

---------------------------------------------------------------------------------------------------------
-- AFFFLICTION

---------------------------------------------------------------------------------------------------------
-- SHADOW PRIEST
spellIcons[DARKASCENSION_SPELLNAME] = string.format("%s/Ability_priest_darkarchangel.blp", ROOTICONPATH)
spellIcons[DISPERSION_SPELLNAME] = string.format("%s/Spell_shadow_dispersion.blp", ROOTICONPATH)
spellIcons[MINDGAMES_SPELLNAME] = string.format("%s/Ability_revendreth_priest.blp", ROOTICONPATH)
spellIcons[HALO_SPELLNAME] = string.format("%s/Ability_priest_halo_shadow.blp", ROOTICONPATH)
spellIcons[VAMPIRICTOUCH_SPELLNAME] = string.format("%s/Spell_holy_stoicism.blp", ROOTICONPATH)
spellIcons[DEVOURINGPLAGUE_SPELLNAME] = string.format("%s/Spell_shadow_devouringplague.blp", ROOTICONPATH)
