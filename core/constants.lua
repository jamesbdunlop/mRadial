---------------------------------------------------------------------------------------------------
----GENERAL CRAP
---------------------------------------------------------------------------------------------------
local appName = "mRadial"
local L = LibStub("AceLocale-3.0"):GetLocale(appName, false) or nil

ROOTICONPATH ="Interface/ICONS"
MEDIAPATH = "Interface\\AddOns\\mRadial\\media"
MAINFRAME_ISMOVING = false
READYSTR = L["Opt_RDY_name"]
NOSSSTR = L["Opt_NOSSSTR_name"]
READYTEXT = L["Opt_RDY_name"]
OORTEXT = L["Opt_OOR_name"]

GCD = 1 --w as 1.5
DEFAULT_FRAMESIZE = 150
DEFAULT_RADIUS = 150

MR_DEFAULT_FONT = "Accidental Presidency.ttf"
MR_FONTS = {}
MR_FONTS[1] = "Accidental Presidency"
MR_FONTS[2] = "HARRYP__"
MR_FONTS[3] = "Nueva Std Cond"
MR_FONTS[4] = "Oswald-Regular"
MR_FONTS[5] = "Mochalatte-JRorB"
MR_FONTS[6] = "HoodBrothers-Yo9y"
MR_FONTS[7] = "DejaVuSansMono"
MR_FONTS[8] = "AnonymousPro-Bold"
MR_FONTS[9] = "MONOFONT"

MAINBG_FRAMENAME = "mRadialOutOfShardsFrame"
PRIMARY_FRAMENAME = "mRadialPrimaryFrame"
SECONDARY_FRAMENAME = "mRadialSecondaryFrame"
SHARD_FRAMENAME = "MWShardFrame"
LINKEDSPELLS = {}
SHADOWFURY_SPELLNAME = "ShadowFury"