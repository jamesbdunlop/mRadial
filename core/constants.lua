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
----SPELL INFO - HARD CODED FOR NOW CAUSE I DO NOT WANT TO HAVE TO SETUP OPTIONS FOR TRACKING SELECTIONS YET
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

--spellName, skipBuff, buffName, isUnitPowerDependant, UnitPowerCount, isDebuff = demo_spellOrder
demo_spellOrder = {}
demo_spellOrder[1] = {POWERSIPHON_SPELLNAME, false, DEMONICCORE_SPELLNAME, false, 0, false}
demo_spellOrder[2] = {CALLDREADSTALKERS_SPELLNAME, true, nil, true, 2, false}
demo_spellOrder[3] = {INQUISITORSGAZE_SPELLNAME, false, nil, false, 0, false}
demo_spellOrder[4] = {SUMMONSOULKEEPER_SPELLNAME, false, nil, false, 0, false}
demo_spellOrder[5] = {SUMMONDT_SPELLNAME, false, nil, false, 0, false}
demo_spellOrder[6] = {SUMMONVF_SPELLNAME, false, nil, false, 0, false}
demo_spellOrder[7] = {NETHERPORTAL_SPELLNAME, true, nil, true, 1, false}
demo_spellOrder[8] = {GRIMFELGUARD_SPELLNAME, true, nil, true, 1, false}
demo_spellOrder[9] = {IMPLOSION_SPELLNAME, true, nil, false, 0, false}
demo_spellOrder[10] = {SHADOWFURY_SPELLNAME, true, nil, false, 0, false}

---------------------------------------------------------------------------------------------------
-- Affliction Spells of interest
CORRUPTION_SPELLNAME = "Corruption"
UNSTABLEAFFLICTION_SPELLNAME = "Unstable Affliction"
AGONY_SPELLNAME = "Agony"
DEATHBOLT_SPELLNAME = "Deathbolt"

--skipBuff, buffName, isUnitPowerDependant, UnitPowerCount, isDebuff = aff_spellOrder
aff_spellOrder = {}
aff_spellOrder[0] = {CORRUPTION_SPELLNAME, true, nil, false, 0, false}
aff_spellOrder[1] = {UNSTABLEAFFLICTION_SPELLNAME, true, nil, false, 0, false}
aff_spellOrder[2] = {AGONY_SPELLNAME, true, nil, false, 0, false}
aff_spellOrder[3] = {DEATHBOLT_SPELLNAME, true, nil, false, 0, false}

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
-- Mind Devourer
--spellName, skipBuff, buffName, isUnitPowerDependant, UnitPowerCount, isDebuff = shadow_spellOrder
shadow_spellOrder = {}
shadow_spellOrder[1] = {MINDBLAST_SPELLNAME, false, SHADOWYINSIGHT_SPELLNAME, false, 0, false}
shadow_spellOrder[2] = {MINDSPIKE_SPELLNAME, false, MINDMELT_SPELLNAME, false, 0, false}
shadow_spellOrder[3] = {VAMPIRICTOUCH_SPELLNAME, true, nil, false, 0, true}
shadow_spellOrder[4] = {DEVOURINGPLAGUE_SPELLNAME, false, MINDDEVOURER_SPELLNAME, true, 50, true}
shadow_spellOrder[5] = {MINDGAMES_SPELLNAME, true, MINDGAMES_SPELLNAME, false, 0, true}
shadow_spellOrder[6] = {DARKASCENSION_SPELLNAME, true, nil, false, 0, true}
shadow_spellOrder[7] = {DISPERSION_SPELLNAME, true, nil, false, 0, true}
shadow_spellOrder[8] = {HALO_SPELLNAME, true, nil, false, 0, true}
shadow_spellOrder[9] = {VOIDERUPTION_SPELLNAME, false, VOIDFORM_SPELLNAME, false, 0, false}
shadow_spellOrder[10] = {SHADOWWORDPAIN_SPELLNAME, true, nil, false, 0, true}
shadow_spellOrder[11] = {MINDSEAR_SPELLNAME, false, MINDDEVOURER_SPELLNAME, true, 50, false}
shadow_spellOrder[12] = {SHADOWWORDDEATH_SPELLNAME, true, nil, false, 0, false}
-- shadow_spellOrder[10] = {VOIDBOLT_SPELLNAME, true, nil, false, 0, false}
---------------------------------------------------------------------------------------------------
-- SHAMAN
CAPACITOR_SPELLNAME = "Capacitor Totem"
EARTHBIND_SPELLNAME = "Earthbind Totem"
HEALINGSTREAM_SPELLNAME = "Healing Stream Totem"
HEALINGTIDETOTEM_SPELLNAME = "Healing Tide Totem"
SPIRITLINKTOTEM_SPELLNAME = "Spirit Link Totem"
--spellName, skipBuff, buffName, isUnitPowerDependant, UnitPowerCount, isDebuff = shadow_spellOrder
shaman_spellOrder = {}
shaman_spellOrder[1] = {CAPACITOR_SPELLNAME, false, CAPACITOR_SPELLNAME, false, 0, false}
shaman_spellOrder[2] = {EARTHBIND_SPELLNAME, false, EARTHBIND_SPELLNAME, false, 0, false}
shaman_spellOrder[3] = {HEALINGSTREAM_SPELLNAME, false, HEALINGSTREAM_SPELLNAME, false, 0, false}
shaman_spellOrder[4] = {HEALINGTIDETOTEM_SPELLNAME, false, HEALINGTIDETOTEM_SPELLNAME, false, 0, false}
shaman_spellOrder[5] = {SPIRITLINKTOTEM_SPELLNAME, false, SPIRITLINKTOTEM_SPELLNAME, false, 0, false}

---------------------------------------------------------------------------------------------------
----ICONS
---------------------------------------------------------------------------------------------------
-- Warlock
spellIcons = {}
-- DEMONOLOGY
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
-- AFFFLICTION
spellIcons[CORRUPTION_SPELLNAME] = string.format("%s/Spell_shadow_abominationexplosion.blp", ROOTICONPATH)
spellIcons[UNSTABLEAFFLICTION_SPELLNAME] = string.format("%s/Spell_shadow_unstableaffliction_3.blp", ROOTICONPATH)
spellIcons[AGONY_SPELLNAME] = string.format("%s/Spell_shadow_curseofsargeras.blp", ROOTICONPATH)
spellIcons[DEATHBOLT_SPELLNAME] = string.format("%s/Spell_fire_twilightflamebolt.blp", ROOTICONPATH)
-- DESTRO

---------------------------------------------------------------------------------------------------------
-- Priest
-- SHADOW
spellIcons[MINDBLAST_SPELLNAME] = string.format("%s/Spell_shadow_unholyfrenzy.blp", ROOTICONPATH)
spellIcons[SHADOWYINSIGHT_SPELLNAME] = string.format("%s/Spell_shadow_possession.blp", ROOTICONPATH)
spellIcons[DARKASCENSION_SPELLNAME] = string.format("%s/Ability_priest_darkarchangel.blp", ROOTICONPATH)
spellIcons[DISPERSION_SPELLNAME] = string.format("%s/Spell_shadow_dispersion.blp", ROOTICONPATH)
spellIcons[MINDGAMES_SPELLNAME] = string.format("%s/Ability_revendreth_priest.blp", ROOTICONPATH)
spellIcons[HALO_SPELLNAME] = string.format("%s/Ability_priest_halo_shadow.blp", ROOTICONPATH)
spellIcons[VAMPIRICTOUCH_SPELLNAME] = string.format("%s/Spell_holy_stoicism.blp", ROOTICONPATH)
spellIcons[DEVOURINGPLAGUE_SPELLNAME] = string.format("%s/Spell_shadow_devouringplague.blp", ROOTICONPATH)
spellIcons[MINDSPIKE_SPELLNAME] = string.format("%s/Spell_priest_mindspike.blp", ROOTICONPATH)
spellIcons[MINDMELT_SPELLNAME] = string.format("%s/Spell_shadow_skull.blp", ROOTICONPATH)
spellIcons[VOIDERUPTION_SPELLNAME] = string.format("%s/Spell_shadow_shadowfury.blp", ROOTICONPATH)
spellIcons[VOIDBOLT_SPELLNAME] = string.format("%s/Ability_ironmaidens_convulsiveshadows.blp", ROOTICONPATH)
spellIcons[MINDDEVOURER_SPELLNAME] = string.format("%s/Spell_arcane_mindmastery.blp", ROOTICONPATH)
spellIcons[SHADOWWORDDEATH_SPELLNAME] = string.format("%s/Spell_shadow_demonicfortitude.blp", ROOTICONPATH)
spellIcons[VOIDFORM_SPELLNAME] = string.format("%s/Spell_priest_voidform.blp", ROOTICONPATH)
spellIcons[MINDSEAR_SPELLNAME] = string.format("%s/Spell_shadow_mindshear.blp", ROOTICONPATH)
spellIcons[SHADOWWORDPAIN_SPELLNAME] = string.format("%s/Spell_shadow_shadowwordpain.blp", ROOTICONPATH)

---------------------------------------------------------------------------------------------------------
-- Shaman
-- ELEMENTAL
spellIcons[CAPACITOR_SPELLNAME] = string.format("%s/Spell_nature_brilliance.blp", ROOTICONPATH)
spellIcons[EARTHBIND_SPELLNAME] = string.format("%s/Spell_nature_strengthofearthtotem02.blp", ROOTICONPATH)
spellIcons[HEALINGSTREAM_SPELLNAME] = string.format("%s/Inv_spear_04.blp", ROOTICONPATH)
spellIcons[HEALINGTIDETOTEM_SPELLNAME] = string.format("%s/Ability_shaman_healingtide.blp", ROOTICONPATH)
spellIcons[SPIRITLINKTOTEM_SPELLNAME] = string.format("%s/Spell_shaman_spiritlink.blp", ROOTICONPATH)