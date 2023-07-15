-- English localization file for enUS and enGB.
local AceLocale = LibStub:GetLibrary("AceLocale-3.0");
local L = AceLocale:NewLocale("mRadial", "enUS");
if not L then return end

L["Opt_GenericOptions_name"] = "Generic Options"
L["Opt_GenericOptions_desc"] = "These apply to the entire UI"

L["Opt_ConfigMode_name"] = "Config Mode"
L["Opt_ConfigMode_desc"] = "Enables / disables config mode."

L["Opt_HideOutOfCombat_name"] = "Hide Out Of Combat"
L["Opt_HideOutOfCombat_desc"] = "Enables / disables hiding the UI while out of combat."

L["Opt_HideMiniMapIcon_name"] = "Hide MiniMap Icon"
L["Opt_HideMiniMapIcon_desc"] = "Enables / disables miniMapIcon in fav of the new addon container. This change will take effect on next reload/login."

L["Opt_ABOUT_name"] = "ABOUT"
L["Opt_ABOUT_desc"] =  "Welcome to mRadial a little UI for tracking spell timers etc.  \
\nYou have a Primary and a Secondary radial frame to assign spells to watch to. These can be set to be clickable buttons as well if so desired. \
\nWhy did I write this? Well I like to keep my focus on my character as much as possible and this addon helps keep the most important spells I want to track in  \
a nice tight circle around the charcter (so I don't stand in fire mkay!)  \
\nFor more info please visit the wiki via curseForge.  \
\n \n"

L["Opt_CHANGELOG_name"] = "CHANGE LOG"
L["Opt_KNOWNISSUES_name"] = "Known Issues"

L["Opt_RadialIcons_name"] = "Radial Icons"
L["Opt_RadialIcons_desc"] = "Use this to change the spell icons and various text timers."

L["Opt_BaseIconOptions_name"] = "Base Icon Options"
L["Opt_BaseIconOptions_desc"] = "Use these options to affect the display of the 'watcher' icons."

L["Opt_general_name"] = "General"

L["Opt_AutoSpread_name"] = "Auto Spread"
L["Opt_AutoSpread_desc"] = "Enables / disables an auto spread around the radial frame."

L["Opt_AsButtons_name"] = "As Buttons"
L["Opt_AsButtons_desc"] =  "Enables / disables the icons as buttons. \n Requires reload. \n DEFAULT: False"

L["Opt_HideSecondary_name"] = "Hide Secondary"
L["Opt_HideSecondary_desc"] =  "Enables / disables secondary icons. DEFAULT: False"

L["Opt_Dimensions_name"] = "Dimensions"

L["Opt_Dimensions_CenterBelow_name"] = "CenterTimerBelow"
L["Opt_Dimensions_CenterBelow_desc"] = "Put the timers directly below or above when the icons are in the center region."

L["Opt_RadiusMultiplyer_name"] = "Radius Multiplyer"
L["Opt_RadiusMultiplyer_desc"] = "Use this to apply a global change to the radius size. DEFAULT: %100."

L["Opt_SpellIconSize_name"] = "Spell Icon Size"
L["Opt_SpellIconSize_desc"] = "Use this change the spell icon sizes.  DEFAULT: 40"

L["Opt_Primary_name"] = "Primary"

L["Opt_Radius_name"] = "Radius"
L["Opt_Radius_desc"] = "Use this change the size(radius) of the circle.  DEFAULT: 50"

L["Opt_Spread_name"] = "Spread"
L["Opt_Spread_desc"] = "Use this change the spell icon spread around the circle."

L["Opt_Offset_name"] = "Offset"
L["Opt_Offset_desc"] = "Use this offset the start location of the spell icons around the circle. DEFAULT: .7"

L["Opt_WidthAdjust_name"] = "Width Adjust"
L["Opt_WidthAdjust_desc"] = "Use this offset width of the circle. This will create an oval shape horizontally. DEFAULT: 1"

L["Opt_HeightAdjust_name"] = "Height Adjust"
L["Opt_HeightAdjust_desc"] = "Use this offset height of the circle. This will create an oval shape vertically. DEFAULT: 1"

L["Opt_Text_name"] = "Text/Fonts"

L["Opt_Font_name"] = "Font"

L["Opt_HeightAdjust_name"] = "Height Adjust"
L["Opt_HeightAdjust_desc"] = "Use this offset height of the circle. This will create an oval shape vertically. DEFAULT: 1"

L["Opt_GlobalFont%_name"] = "Global Font %"
L["Opt_GlobalFont%_desc"] = "This controls the overall font size for the UI. A setting of 50% will be 50% of the current icon size.  DEFAULT: %50"

L["Opt_FontSizeOverrides_name"] = "Font Size Overrides"

L["Opt_count_name"] = "Count"
L["Opt_ready_name"] = "Ready"
L["Opt_CoolDown_name"] = "Cool Down"
L["Opt_timer_name"] = "Timer"
L["Opt_debuff_name"] = "DoT"
L["Opt_linked_name"] = "Linked"
L["Opt_fontAdjustWarning_name"] = "--- Turn on Config Mode While Adjusting The Below Params ---"

L["Opt_DEFAULT2_desc"] = "DEFAULT: 2"

L["Opt_radialSpells_desc"] = "Radial Spells"

L["Opt_fagDesc_desc"] = "--Use this to select the spells to watch in the primary and secondary radial frames.--"

L["Opt_hidePassiveSpells_name"] = "Hide Passive Spells"

L["Opt_primarySpellOrder_name"] = "Primary Spell Order"
L["Opt_primarySpells_name"] = "Primary Spells"
L["Opt_secondarySpellOrder_name"] = "Secondary Spell Order"
L["Opt_secondarySpells_name"] = "Secondary Spells"

L["Opt_linkedSpells_name"] = "Linked Spells"

L["Opt_warlock_name"] = "Warlock"

L["Opt_PetFrames_name"] = "Pet Frames"
L["Opt_HidePetFrames_name"] = "Hide Pet Frames"
L["Opt_HidePetFrames_desc"] = "Show/Hide the pet frames."

L["Opt_IconSize_name"] = "Icon Size"
L["Opt_IconSize_desc"] = "Use this change the spell icon sizes."

L["Opt_ShardFrames_name"] = "Shard Frames"

L["Opt_OutOfShardsFrameSize_name"] = "Out Of Shards Frame Size"
L["Opt_OutOfShardsFrameSize_desc"] = "Use this change the frame that shows the out of shards circle. Turn on Config mode for this!"

L["Opt_ShardTrackerFrameSize_name"] = "Shards Frame Size"
L["Opt_ShardTrackerFrameSize_desc"] = "Use this change the frame that shows the custom shard tracker frame."

L["Opt_ShardTrackerTrans_name"] = "Shards Frame Transparency"
L["Opt_ShardTrackerTrans_desc"] = "Use this change alpha of the shard frame. Turn on Config mode for this."

L["Opt_HideShardTracker_name"] = "Hide Shard Frame"
L["Opt_HideShardTracker_desc"] = "Show/Hide the warlock shard tracker frame."

L["Opt_pet_name"] = "Pet Options"

L["Opt_RDY_name"] = "RDY"
L["Opt_NOPOWER_name"] = "X"
L["Opt_OOR_name"] = "OOR"

L["Opt_LinkedSpellsInfo_name"] = "Linked spells are a way for you to link a buff to a core spell. \
\n eg: Linking DemonBolt to Demonic Core, will start a timer next to DemonBolt when DC procs to allow for timing of casts etc. \
\n HowTo: \
\n Drag and drop a spell from the spell book into the left hand input. Type a name of the spell (or drag it) onto the linked spell input. The spellID should populate automatically. \
\n Note: Src spellNames are unique, and can only link once."

L["Opt_LinkedSpellsLinkedTo_name"] = "linked to:"
L["Opt_LinkedSpellsRemove_name"] = "Remove"

L["Opt_LinkedSpellsPane_name"] = "Linked Spell (Buffs): "
L["Opt_LinkedSpellsAdd_name"] = "Add"
L["Opt_LinkedSpellsGrp_name"] = "Linked Spells"

L["Opt_Felguard"] = "Felguard"
L["Opt_Wrathguard"] = "Wrathguard"
L["Opt_DemonicStrength"] = "Demonic Strength"
L["Opt_FelStorm"] = "FelStorm"
L["Opt_AxeToss"] = "Axe Toss"
L["Opt_SoulStrike"] = "Soul Strike"

L["Opt_Succubus"] = "Succubus"
L["Opt_Seduction"] = "Seduction"
L["Opt_LashOfPain"] = "Lash Of Pain"
L["Opt_Whiplash"] = "Whiplash"

L["Opt_Incubus"] = "Incubus"

L["Opt_Felhunter"] = "Felhunter"

L["Opt_Size"] = "Size"

L["SummonSoulKeeperSpellname"] = "Summon Soulkeeper"
L["ShadowFurySpellname"] = "ShadowFury"

L["Opt_PetIgnoreInput_name"] = "Pet Abilities To Ignore"
L["Opt_PetIgnoreInput_desc"] = "Type the name of the pet ability you want to ignore on a newLine. No trailing spaces!"

L["Opt_power_name"] = "Power Text"
L["Power Colour"] = "Power Colour"

L["Opt_PowerEnabled_name"] = "Enable"
L["Opt_PowerEnabled_desc"] = "Counter for abilities dependant on power."

L["Opt_PowerPersists_name"] = "Persist"
L["Opt_PowerPersists_desc"] = "Hide the counter when the minimum amount of power is required to cast, or always show the power count."

L["Up/Down"] = "Up/Down"
L["Left/Right"] = "Left/Right"

L["Opt_SpellOrderFrame_Name"] = "Spell Order"
L["Opt_SpellOrderFrame_Desc"] = "This sets the order along the radial frame. To use change the order, right click a spell to pick it up, and drop it onto the spell you want to swap it with."

