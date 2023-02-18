---------------------------------------------------------------------------------------------------
ROOTICONPATH ="Interface/ICONS"
MEDIAPATH = "Interface\\AddOns\\mWarlock\\media"
MAINFRAME_ISMOVING = false
READYSTR = "RDY"
NOSSSTR = "N0 SS!"

MAINBG_FRAMENAME = "MWarlockBGFrame"
HANDOFGUL_FRAMENAME = "HandOfGulFrame"

FELLSTORM_SPELLNAME = "Felstorm"
SHARD_FRAMENAME = "MWShardFrame"
---------------------------------------------------------------------------------------------------
-- Demo Spells of interest
POWERSIPHON_SPELLNAME = "Power Siphon" --264130
DEMONICCORE_SPELLNAME = "Demonic Core" -- 264173
INQUISITORSGAZE_SPELLNAME = "Inquisitor's Gaze" --386334
SUMMONSOULKEEPER_SPELLNAME = "Summon Soulkeeper"
DEMONICPOWER_SPELLNAME = "Demonic Power"
SUMMONDT_SPELLNAME = "Summon Demonic Tyrant" --265187
SUMMONVF_SPELLNAME = "Summon VileFiend" --264119
NETHERPORTAL_SPELLNAME = "Nether Portal" --26721
GRIMFELGUARD_SPELLNAME = "Grimoire: Felguard" --111898
CALLDREADSTALKERS_SPELLNAME = "Call Dreadstalkers" --104316
IMPLOSION_SPELLNAME = "Implosion" --196277

demo_spellOrder = {}
demo_spellOrder[POWERSIPHON_SPELLNAME] = 264130
demo_spellOrder[CALLDREADSTALKERS_SPELLNAME] = 104316
demo_spellOrder[INQUISITORSGAZE_SPELLNAME] = 386334
demo_spellOrder[SUMMONSOULKEEPER_SPELLNAME] = 386256
demo_spellOrder[SUMMONDT_SPELLNAME] = 265187
demo_spellOrder[SUMMONVF_SPELLNAME] = 264119
demo_spellOrder[NETHERPORTAL_SPELLNAME] = 267217
demo_spellOrder[GRIMFELGUARD_SPELLNAME] = 111898
demo_spellOrder[IMPLOSION_SPELLNAME] = 196277

---------------------------------------------------------------------------------------------------
spellIcons = {}
-- Demo
spellIcons[POWERSIPHON_SPELLNAME] = string.format("%s/Warlock_spelldrain.blp", ROOTICONPATH)
spellIcons[DEMONICCORE_SPELLNAME] = string.format("%s/Ability_warlock_backdraft.blp", ROOTICONPATH)
spellIcons[CALLDREADSTALKERS_SPELLNAME] = string.format("%s/Spell_warlock_calldreadstalkers.blp", ROOTICONPATH)
spellIcons[INQUISITORSGAZE_SPELLNAME] = string.format("%s/Inv_pet_inquisitoreye.blp", ROOTICONPATH)
spellIcons[SUMMONSOULKEEPER_SPELLNAME] = string.format("%s/Spell_fel_elementaldevastation.blp", ROOTICONPATH)
spellIcons[SUMMONDT_SPELLNAME] = string.format("%s/Achievement_boss_argus_maleeredar.blp", ROOTICONPATH)
spellIcons[DEMONICPOWER_SPELLNAME] = string.format("%s/Inv_summondemonictyrant.blp", ROOTICONPATH)
spellIcons[SUMMONVF_SPELLNAME] = string.format("%s/Inv_argusfelstalkermount.blp", ROOTICONPATH)
spellIcons[NETHERPORTAL_SPELLNAME] = string.format("%s/Inv_netherportal.blp", ROOTICONPATH)
spellIcons[GRIMFELGUARD_SPELLNAME] = string.format("%s/Spell_shadow_summonfelguard.blp", ROOTICONPATH)
spellIcons[CALLDREADSTALKERS_SPELLNAME] = string.format("%s/Spell_warlock_calldreadstalkers.blp", ROOTICONPATH)
spellIcons[IMPLOSION_SPELLNAME] = string.format("%s/Inv_implosion.blp", ROOTICONPATH)
-- Destro
-- Affy