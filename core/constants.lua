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

MR_GCD = 1 --w as 1.5
MR_INTERVAL = .01
DEFAULT_FRAMESIZE = 150
DEFAULT_RADIUS = 150

MR_DEFAULT_FONT = "Interface\\AddOns\\mRadial\\fonts\\HARRYP__.ttf"
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


-- Defaults
MR_DEFAULT_AUTOSPREAD = true
MR_DEFAULT_ASBUTTONS = false
MR_DEFAULT_HIDESECONDARY = false
MR_DEFAULT_HIDEOOC = false
MR_DEFAULT_HIDEMINIMAP = false
MR_DEFAULT_RADIUSMULT = 1
MR_DEFAULT_FONTPERCENTAGE = .25
MR_DEFAULT_FONTSIZE = 2
MR_DEFAULT_FONTBIGGERSIZE = 9
MR_DEFAULT_UDOFFSET = 0
MR_DEFAULT_LROFFSET = 10
MR_DEFAULT_CDUDOFFSET = 0
MR_DEFAULT_CDLROFFSET = 0
MR_DEFAULT_READYUDOFFSET = -17
MR_DEFAULT_READYLROFFSET = 0
MR_DEFAULT_COUNTUDOFFSET = 16
MR_DEFAULT_COUNTLROFFSET = -15
MR_DEFAULT_WATCHERFRAMESIZE = 34

MR_DEFAULT_RADIUS = 150
MR_DEFAULT_RADIUS2 = 250
MR_DEFAULT_SPREAD = 0.1
MR_DEFAULT_OFFSET = 1.4
MR_DEFAULT_WIDTH = 1
MR_DEFAULT_HEIGHT = 1

MR_DEFAULT_CENTERBELOW = true

SHADOWFURY_SPELLNAME = L["ShadowFurySpellname"]
SUMMONSOULKEEPER_SPELLNAME = L["SummonSoulKeeperSpellname"]
