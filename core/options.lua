local appName = "mRadial"
local AceGUI = LibStub("AceGUI-3.0")
local MR_configDialog = LibStub("AceConfigDialog-3.0")
local MR_configRegistry = LibStub("AceConfigRegistry-3.0")
local LSM = LibStub("LibSharedMedia-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale(appName, false) or nil

------------------------------------------------------------------------------------------
-- OPTIONS CONFIG TABLE
MROptionsTable = {
    type = "group",
    childGroups = "tree",
    args = {
      header = {
        name = L["Opt_GenericOptions_name"],
        desc = L["Opt_GenericOptions_desc"],
        type = "header",
        order = 1,
      },
      configMode = {
        name = L["Opt_ConfigMode_name"],
        desc = L["Opt_ConfigMode_desc"],
        type = "toggle",
        set = function(info, val)
          MRadialSavedVariables["moveable"] = val 
          mRadial:SetConfigMode(val)
          mRadial:UpdateUI(true)
        end,
        get = function(info) 
          local current = MRadialSavedVariables["moveable"]
          if current == nil then return false end
          return current end,
        order = 2,
      },
      hideOutOfCombat = {
        name = L["Opt_FadeOutOfCombat_name"],
        desc = L["Opt_FadeOutOfCombat_desc"],
        type = "toggle",
        set = function(info, val) MRadialSavedVariables["fadeooc"] = val end,
        get = function(info) return MRadialSavedVariables["fadeooc"] or MR_DEFAULT_FADEOOC end,
        order = 3,
      }, 
      hideminimap = {
        name = L["Opt_HideMiniMapIcon_name"],
        desc = L["Opt_HideMiniMapIcon_desc"],
        type = "toggle",
        set = function(info, val) MRadialSavedVariables["hideMiniMapIcon"] = val end,
        get = function(info) 
          if MRadialSavedVariables["hideMiniMapIcon"] ~= nil then
            return MRadialSavedVariables["hideMiniMapIcon"] end
          return MR_DEFAULT_HIDEMINIMAP end,
        order = 4,
      }, 

      about={
        name = "About",
        type = "group",
        order=1,
        args={
          faqHdr = {
            name = L["Opt_ABOUT_name"],
            type = "header",
            dialogControl = "SFX-Header-II",
            order = 1
          },
          fagDesc = {
            name = L["Opt_ABOUT_desc"],
            type = "description",
            order = 2
          },
          knownIssuesHdr = {
            name = L["Opt_KNOWNISSUES_name"],
            type = "header",
            dialogControl = "SFX-Header-II",
            order = 3
          },
          knownIssues = {
            name = MRADIAL_KNOWNISSUES,
            type = "description",
            order = 4,
          },
          changeLogHdr = {
            name = L["Opt_CHANGELOG_name"],
            type = "header",
            dialogControl = "SFX-Header-II",
            order = 5
          },
          changeLog = {
            name = MRADIAL_UPDATENOTES,
            type = "description",
            order = 6,
          }
        }
      },

      iconOptions={
        name = L["Opt_RadialIcons_name"],
        type = "group",
        desc = L["Opt_RadialIcons_desc"],
        childGroups = "tab",
        order=2,
        args={
          header = {
            name = L["Opt_BaseIconOptions_name"],
            desc = "",
            type = "header",
            order = 1,
          }, 
          desc = {
            name = L["Opt_BaseIconOptions_desc"],
            type = "description",
            order = 2,
          },
          general_chkboxes = {
            name = L["Opt_general_name"],
            type = "group",
            inline = true,
            args = {
              autospread = {
                name = L["Opt_AutoSpread_name"],
                desc = L["Opt_AutoSpread_desc"],
                type = "toggle",
                default = true,
                set = function(info,val)
                  MRadialSavedVariables["autoSpread"] = val
                  mRadial:UpdateUI(false)
                end,
                get = function(info) 
                  local current = MRadialSavedVariables["autoSpread"]
                  if current == nil then return MR_DEFAULT_AUTOSPREAD end
                  
                  return current
                end,
                order = 1,
              },
              asbuttons = {
                  name = L["Opt_AsButtons_name"],
                  desc = L["Opt_AsButtons_desc"],
                  type = "toggle",
                  set = function(info,val)
                    MRadialSavedVariables["asbuttons"] = val 
                  end,
                  get = function(info)
                    local current = MRadialSavedVariables["asbuttons"]
                    if current == nil then return MR_DEFAULT_ASBUTTONS end
                    return current end,
                  order = 2,
                },
              hideSecondary = {
                  name = L["Opt_HideSecondary_name"],
                  desc = L["Opt_HideSecondary_desc"],
                  type = "toggle",
                  set = function(info,val)
                    MRadialSavedVariables["hideSecondary"] = val 
                    mRadial:UpdateUI(true)
                  end,
                  get = function(info)
                    local current = MRadialSavedVariables["hideSecondary"]
                    if current == nil then return MR_DEFAULT_ASBUTTONS end
                    return current end,
                  order = 3,
                }
            }
          },
          
          DimensionOptions={
            name = L["Opt_Dimensions_name"],
            type = "group",
            childGroups = "tab",
            args={
              radiusMult = {
                name = L["Opt_RadiusMultiplyer_name"],
                desc = L["Opt_RadiusMultiplyer_desc"],
                type = "range",
                min = .1,
                max = 2,
                step = .01,
                isPercent = true,
                default = 1,
                order = 1,
                set = function(self, val)
                  MRadialSavedVariables["radiusMult"] = val
                  mRadial:UpdateUI(false)
                end,
                get = function(self) 
                  local val = MRadialSavedVariables["radiusMult"]
                  if val == nil then val = MR_DEFAULT_RADIUSMULT end
                  return val end,
              },
              iconSize = {
                name = L["Opt_SpellIconSize_name"],
                desc = L["Opt_SpellIconSize_desc"],
                type = "range",
                min = 1,
                max = 200,
                step = .01,
                isPercent = false,
                default = 40,
                order = 2,
                set = function(self, val)
                  MRadialSavedVariables["watcherFrameSize"] = val
                  mRadial:UpdateUI(false)
                end,
                get = function(self)
                  local val = MRadialSavedVariables["watcherFrameSize"]
                  if val == nil then val = MR_DEFAULT_WATCHERFRAMESIZE end
                  return val end,
              },
              centerBelow = {
                  name = L["Opt_Dimensions_CenterBelow_name"],
                  desc = L["Opt_Dimensions_CenterBelow_desc"],
                  type = "toggle",
                  order = 3,
                  set = function(info, val)
                    MRadialSavedVariables["centerBelow"] = val
                    mRadial:UpdateUI(false)
                  end,
                  get = function(info)
                    local val = MRadialSavedVariables["centerBelow"]
                    if val == nil then return MR_DEFAULT_CENTERBELOW end
                    return val end
                },
              Radial01 = {
                name = L["Opt_Primary_name"],
                type = "group",
                args = {
                  radius = {
                    name = L["Opt_Radius_name"],
                    desc = L["Opt_Radius_desc"],
                    type = "range",
                    order = 1,
                    min = 50,
                    max = 500,
                    step = .01,
                    isPercent = false,
                    default = 50,
                    set = function(self, val)
                      MRadialSavedVariables["radius"] = val
                      mRadial:UpdateUI(false)
                    end,
                    get = function(self)
                      local val = MRadialSavedVariables["radius"]
                      if val == nil then val = MR_DEFAULT_RADIUS end
                      return val
                    end,
                  },
                  spread = {
                    name = L["Opt_Spread_name"],
                    desc = L["Opt_Spread_desc"],
                    type = "range",
                    order = 2, 
                    min = -140,
                    max = 140,
                    step = .01,
                    isPercent = false,
                    default = 0,
                    set = function(self, val)
                      MRadialSavedVariables["watcherFrameSpread"] = val
                      mRadial:UpdateUI(false)
                    end,
                    get = function(self) 
                      local val = MRadialSavedVariables["watcherFrameSpread"]
                      if val == nil then val = MR_DEFAULT_SPREAD end
                      return val end
                  },
                  offset = {
                    name = L["Opt_Offset_name"],
                    desc = L["Opt_Offset_desc"],
                    type = "range",
                    order = 3,
                    min = 0.000,
                    max = 3.000,
                    step = .001,
                    isPercent = false,
                    default = 0.700,
                    set = function(self, val)
                      MRadialSavedVariables["offset"] = val
                      mRadial:UpdateUI(false)
                    end,
                    get = function(self)
                      local val = MRadialSavedVariables["offset"]
                      if val == nil then val = MR_DEFAULT_OFFSET end
                      return val end
                  },
                  width = {
                    name = L["Opt_WidthAdjust_name"],
                    desc = L["Opt_WidthAdjust_desc"],
                    type = "range",
                    order = 4, 
                    min = 0.1,
                    max = 10,
                    step = .01,
                    isPercent = false,
                    default = 1,
                    set = function(self, val)
                      MRadialSavedVariables["widthDeform"] = val
                      mRadial:UpdateUI(false)
                    end,
                    get = function(self)
                      local val = MRadialSavedVariables["widthDeform"]
                      if val == nil then val = MR_DEFAULT_WIDTH end
                      return val end
                  },
                  height = {
                    name = L["Opt_HeightAdjust_name"],
                    desc = L["Opt_HeightAdjust_desc"],
                    type = "range",
                    order = 5, 
                    min = 0.1,
                    max = 10,
                    step = .01,
                    isPercent = false,
                    default = 1,
                    set = function(self, val)
                      MRadialSavedVariables["heightDeform"] = val
                      mRadial:UpdateUI(false)
                    end,
                    get = function(self)
                      local val = MRadialSavedVariables["heightDeform"]
                      if val == nil then val = MR_DEFAULT_HEIGHT end
                      return val end
                  },
                },
                order=1
              },
              Radial02 = {
                name = "Secondary",
                type = "group",
                args = {
                  radius = {
                    name = L["Opt_Radius_name"],
                    desc = L["Opt_Radius_desc"],
                    type = "range",
                    order = 1,
                    min = 50,
                    max = 500,
                    step = .01,
                    isPercent = false,
                    default = 100,
                    set = function(self, val)
                      MRadialSavedVariables["radius2"] = val
                      mRadial:UpdateUI(false)
                    end,
                    get = function(self) return MRadialSavedVariables["radius2"] or MR_DEFAULT_RADIUS end,
                  },
                  spread = {
                    name = L["Opt_Spread_name"],
                    desc = L["Opt_Spread_desc"],
                    type = "range",
                    order = 2, 
                    min = -140,
                    max = 140,
                    step = .01,
                    isPercent = false,
                    default = 0,
                    set = function(self, val)
                      MRadialSavedVariables["watcherFrameSpread2"] = val
                      mRadial:UpdateUI(false)
                    end,
                    get = function(self) return MRadialSavedVariables["watcherFrameSpread2"] or MR_DEFAULT_SPREAD end,
                  },
                  offset = {
                    name = L["Opt_Offset_name"],
                    desc = L["Opt_Offset_desc"],
                    type = "range",
                    order = 3, 
                    min = 0,
                    max = 3,
                    step = .01,
                    isPercent = false,
                    default = 0.7,
                    set = function(self, val)
                      MRadialSavedVariables["offset2"] = val
                      mRadial:UpdateUI(false)
                    end,
                    get = function(self) return MRadialSavedVariables["offset2"] or MR_DEFAULT_OFFSET end,
                  },
                  width = {
                    name = L["Opt_WidthAdjust_name"],
                    desc = L["Opt_WidthAdjust_desc"],
                    type = "range",
                    order = 4, 
                    min = 0.1,
                    max = 10,
                    step = .01,
                    isPercent = false,
                    default = 1,
                    set = function(self, val)
                      MRadialSavedVariables["widthDeform2"] = val
                      mRadial:UpdateUI(false)
                    end,
                    get = function(self) return MRadialSavedVariables["widthDeform2"] or MR_DEFAULT_WIDTH end,
                  },
                  height = {
                    name = L["Opt_HeightAdjust_name"],
                    desc = L["Opt_HeightAdjust_desc"],
                    type = "range",
                    order = 5, 
                    min = 0.1,
                    max = 10,
                    step = .01,
                    isPercent = false,
                    default = 1,
                    set = function(self, val)
                      MRadialSavedVariables["heightDeform2"] = val
                      mRadial:UpdateUI(false)
                    end,
                    get = function(self) return MRadialSavedVariables["heightDeform2"] or MR_DEFAULT_HEIGHT end,
                  },
                },
                order=2
              },
            },
            order=5
          },
        
          fontOptions={
            name = L["Opt_Text_name"],
            type = "group",
            args={
              fontSelection = {
                name = L["Opt_Font_name"],
                type = "select",
                style = "dropdown",
                order = 1, 
                values = LSM:HashTable("font"),
                dialogControl = 'LSM30_Font',
                set = function(info, groupIndex)
                    local selectedFont = LSM:HashTable("font")[groupIndex]
                    MRadialSavedVariables['Font'] = selectedFont
                    mRadial:UpdateUI(true)
                    mRadial:SetPetFramePosAndSize()
                    mRadial:GlobalFontPercentageChanged()
                  end,
                get = function(info)
                    local values = LSM:HashTable("font")
                    local font = MRadialSavedVariables['Font'] 
                    if font == nil then font = MR_DEFAULT_FONT end
                    for idx, fontName in pairs(values) do
                      if fontName == font then
                        return idx
                      end
                    end
                  end,
              },
              globalFontSize = {
                name = L["Opt_GlobalFont%_name"],
                desc = L["Opt_GlobalFont%_desc"],
                type = "range",
                order = 2,
                min = .1,
                max = 1,
                step = .01,
                isPercent = false,
                default = .5,
                defaultValue = .5,
                set = function(self, val)
                  MRadialSavedVariables["FontPercentage"] = val
                  mRadial:GlobalFontPercentageChanged()
                end,
                get = function(self) 
                  local current = MRadialSavedVariables["FontPercentage"]
                  if current == nil then current = MR_DEFAULT_FONTPERCENTAGE end
                  return current end,
              },
              fontAdjustWarning = {
                name = L["Opt_fontAdjustWarning_name"],
                desc = "",
                type = "header",
                order = 3,
              },
              buffGrp = {
                name =  L["Opt_linked_name"],
                type = "group",
                inline = true,
                order = 4,
                args = {
                  UpDown = {
                    name = L["Up/Down"],
                    desc = "DEFAULT: 0",
                    type = "range",
                    order = 1,
                    min = -50,
                    max = 50,
                    step = 1,
                    isPercent = false,
                    default = 0,
                    set = function(self, val)
                      MRadialSavedVariables["radialUdOffset"] = val
                      mRadial:UpdateUI(false)
                    end,
                    get = function(self)
                      local current = MRadialSavedVariables["radialUdOffset"]
                      if current == nil then current = MR_DEFAULT_UDOFFSET end
                      return current end,
                  },
                  LeftRight = {
                    name = L["Left/Right"],
                    desc = "DEFAULT: 0",
                    type = "range",
                    order = 2,
                    min = -50,
                    max = 50,
                    step = 1,
                    isPercent = false,
                    default = 0,
                    set = function(self, val)
                      MRadialSavedVariables["radialLROffset"] = val
                      mRadial:UpdateUI(false)
                    end,
                    get = function(self)
                      local current = MRadialSavedVariables["radialLROffset"]
                      if current == nil then current = MR_DEFAULT_LROFFSET end
                      return current end,
                  },
                  BuffColour = {
                    type = "color",
                    name = "Pick Colour",
                    desc = "",
                    order = 3,
                    hasAlpha = false,
                    get = function(info)
                      local color = MRadialSavedVariables["buffColor"]
                      if color == nil then color = {.1, 1, .1, 1} end
                      local r, g, b, a = color[1], color[2], color[3], color[4]
                      return r, g, b, a
                    end,
                    set = function(info, r, g, b, a)
                      MRadialSavedVariables["buffColor"] = {r, g, b, a}
                      mRadial:UpdateUI(false)
                    end,
                  },
                  timerFontSize = {
                    name = L["Opt_Size"],
                    desc = L["Opt_DEFAULT2_desc"],
                    type = "range",
                    order = 4,
                    min = -4,
                    max = 55,
                    step = 1,
                    isPercent = false,
                    default = 2,
                    set = function(self, val)
                      MRadialSavedVariables["timerFontSize"] = val
                      mRadial:UpdateUI(false)
                    end,
                    get = function(self)
                      local current = MRadialSavedVariables["timerFontSize"]
                      if current == nil then current = MR_DEFAULT_FONTSIZE end
                      return current end,
                  },
                }
              },
              cooldownGrp = {
                name = L["Opt_CoolDown_name"],
                type = "group",
                inline = true,
                order = 6,
                args = {
                  UpDown = {
                    name = L["Up/Down"],
                    desc = "DEFAULT: 0",
                    type = "range",
                    order = 1,
                    min = -50,
                    max = 50,
                    step = 1,
                    isPercent = false,
                    default = 0,
                    set = function(self, val)
                      MRadialSavedVariables["cdUdOffset"] = val
                      mRadial:UpdateUI(false)
                    end,
                    get = function(self)
                      local current = MRadialSavedVariables["cdUdOffset"]
                      if current == nil then current = MR_DEFAULT_CDUDOFFSET end
                      return current end,
                  },
                  LeftRight = {
                    name = L["Left/Right"],
                    desc = "DEFAULT: 0",
                    type = "range",
                    order = 2,
                    min = -50,
                    max = 50,
                    step = 1,
                    isPercent = false,
                    default = 0,
                    set = function(self, val)
                      MRadialSavedVariables["cdLROffset"] = val
                      mRadial:UpdateUI(false)
                    end,
                    get = function(self)
                      local current = MRadialSavedVariables["cdLROffset"]
                      if current == nil then current = MR_DEFAULT_CDLROFFSET end
                      return current end,
                  },
                  CDColour = {
                    type = "color",
                    name = "Cooldown Colour",
                    desc = "",
                    order = 3,
                    hasAlpha = false,
                    get = function(info)
                      local color = MRadialSavedVariables["cdColor"]
                      if color == nil then color = {.1, 1, .1, 1} end
                      local r, g, b, a = color[1], color[2], color[3], color[4]
                      return r, g, b, a
                    end,
                    set = function(info, r, g, b, a)
                      MRadialSavedVariables["cdColor"] = {r, g, b, a}
                      mRadial:UpdateUI(false)
                    end,
                  },
                  coolDownFontSize = {
                    name = L["Opt_Size"],
                    desc = L["Opt_DEFAULT2_desc"],
                    type = "range",
                    order = 4,
                    min = -4,
                    max = 55,
                    step = 1,
                    isPercent = false,
                    default = 2,
                    set = function(self, val)
                      MRadialSavedVariables["coolDownFontSize"] = val
                      mRadial:UpdateUI(false)
                    end,
                    get = function(self)
                      local current = MRadialSavedVariables["coolDownFontSize"]
                      if current == nil then current = MR_DEFAULT_FONTBIGGERSIZE end
                      return current end,
                  },
                }
              },
              readyGrp = {
                name = L["Opt_ready_name"],
                type = "group",
                inline = true,
                order = 7,
                args = {
                  UpDown = {
                    name = L["Up/Down"],
                    desc = "DEFAULT: 0",
                    type = "range",
                    order = 1,
                    min = -50,
                    max = 50,
                    step = 1,
                    isPercent = false,
                    default = 0,
                    set = function(self, val)
                      MRadialSavedVariables["readyUDOffset"] = val
                      mRadial:UpdateUI(false)
                    end,
                    get = function(self)
                      local current = MRadialSavedVariables["readyUDOffset"]
                      if current == nil then current = MR_DEFAULT_READYUDOFFSET end
                      return current end,
                  },
                  LeftRight = {
                    name = L["Left/Right"],
                    desc = "DEFAULT: 0",
                    type = "range",
                    order = 2,
                    min = -50,
                    max = 50,
                    step = 1,
                    isPercent = false,
                    default = 0,
                    set = function(self, val)
                      MRadialSavedVariables["readyLROffset"] = val
                      mRadial:UpdateUI(false)
                    end,
                    get = function(self)
                      local current = MRadialSavedVariables["readyLROffset"]
                      if current == nil then current = MR_DEFAULT_READYLROFFSET end
                      return current end,
                  },
                  ReadyColour = {
                    type = "color",
                    name = "Pick Colour",
                    desc = "",
                    order = 3,
                    hasAlpha = false,
                    get = function(info)
                      local color = MRadialSavedVariables["readyColor"]
                      if color == nil then color = {.1, 1, .1, 1} end
                      local r, g, b, a = color[1], color[2], color[3], color[4]
                      return r, g, b, a
                    end,
                    set = function(info, r, g, b, a)
                      MRadialSavedVariables["readyColor"] = {r, g, b, a}
                      mRadial:UpdateUI(false)
                    end,
                  },
                  readyFontSize = {
                    name = L["Opt_Size"],
                    desc = L["Opt_DEFAULT2_desc"],
                    type = "range",
                    order = 4,
                    min = -4,
                    max = 55,
                    step = 1,
                    isPercent = false,
                    default = 2,
                    set = function(self, val)
                      MRadialSavedVariables["readyFontSize"] = val
                      mRadial:UpdateUI(false)
                    end,
                    get = function(self)
                      local current = MRadialSavedVariables["readyFontSize"]
                      if current == nil then current = MR_DEFAULT_FONTBIGGERSIZE end
                      return current end,
                  },
                }
              },
              countGrp = {
                name = L["Opt_count_name"],
                type = "group",
                inline = true,
                order = 8,
                args = {
                  UpDown = {
                    name = L["Up/Down"],
                    desc = "DEFAULT: 0",
                    type = "range",
                    order = 1,
                    min = -50,
                    max = 50,
                    step = 1,
                    isPercent = false,
                    default = 0,
                    set = function(self, val)
                      MRadialSavedVariables["countUdOffset"] = val
                      mRadial:UpdateUI(false)
                    end,
                    get = function(self)
                      local current = MRadialSavedVariables["countUdOffset"]
                      if current == nil then current = MR_DEFAULT_COUNTUDOFFSET end
                      return current end,
                  },
                  LeftRight = {
                    name = L["Left/Right"],
                    desc = "DEFAULT: 0",
                    type = "range",
                    order = 2,
                    min = -50,
                    max = 50,
                    step = 1,
                    isPercent = false,
                    default = 0,
                    set = function(self, val)
                      MRadialSavedVariables["countLROffset"] = val
                      mRadial:UpdateUI(false)
                    end,
                    get = function(self)
                      local current = MRadialSavedVariables["countLROffset"]
                      if current == nil then current = MR_DEFAULT_COUNTLROFFSET end
                      return current end,
                  },
                  CountColour = {
                    type = "color",
                    name = "Count Colour",
                    desc = "",
                    order = 3,
                    hasAlpha = false,
                    get = function(info)
                      local color = MRadialSavedVariables["countColor"]
                      if color == nil then color = {0, 1, 1, 1} end
                      local r, g, b, a = color[1], color[2], color[3], color[4]
                      return r, g, b, a
                    end,
                    set = function(info, r, g, b, a)
                      MRadialSavedVariables["countColor"] = {r, g, b, a}
                      mRadial:UpdateUI(false)
                    end,
                  },
                  countFontSize = {
                    name = L["Opt_Size"],
                    desc = L["Opt_DEFAULT2_desc"],
                    type = "range",
                    order = 4,
                    min = -4,
                    max = 55,
                    step = 1,
                    isPercent = false,
                    default = 2,
                    set = function(self, val)
                      MRadialSavedVariables["countFontSize"] = val
                      mRadial:UpdateUI(false)
                    end,
                    get = function(self)
                      local current = MRadialSavedVariables["countFontSize"]
                      if current == nil then current = MR_DEFAULT_FONTSIZE end
                      return current end,
                  },
                }
              },
              debuffGrp = {
                name = L["Opt_debuff_name"],
                type = "group",
                inline = true,
                order = 8,
                args = {
                  UpDown = {
                    name = L["Up/Down"],
                    desc = "DEFAULT: 0",
                    type = "range",
                    order = 1,
                    min = -50,
                    max = 50,
                    step = 1,
                    isPercent = false,
                    default = 0,
                    set = function(self, val)
                      MRadialSavedVariables["debuffUdOffset"] = val
                      mRadial:UpdateUI(false)
                    end,
                    get = function(self)
                      local current = MRadialSavedVariables["debuffUdOffset"]
                      if current == nil then current = MR_DEFAULT_DEBUFFUDOFFSET end
                      return current end,
                  },
                  LeftRight = {
                    name = L["Left/Right"],
                    desc = "DEFAULT: 0",
                    type = "range",
                    order = 2,
                    min = -50,
                    max = 50,
                    step = 1,
                    isPercent = false,
                    default = 0,
                    set = function(self, val)
                      MRadialSavedVariables["debuffLROffset"] = val
                      mRadial:UpdateUI(false)
                    end,
                    get = function(self)
                      local current = MRadialSavedVariables["debuffLROffset"]
                      if current == nil then current = MR_DEFAULT_DEBUFFLROFFSET end
                      return current end,
                  },
                  debuffColour = {
                    type = "color",
                    name = "debuff Colour",
                    desc = "",
                    order = 3,
                    hasAlpha = false,
                    get = function(info)
                      local color = MRadialSavedVariables["debuffColor"]
                      if color == nil then color = {0, 1, 1, 1} end
                      local r, g, b, a = color[1], color[2], color[3], color[4]
                      return r, g, b, a
                    end,
                    set = function(info, r, g, b, a)
                      MRadialSavedVariables["debuffColor"] = {r, g, b, a}
                      mRadial:UpdateUI(false)
                    end,
                  },
                  debuffFontSize = {
                    name = L["Opt_Size"],
                    desc = L["Opt_DEFAULT2_desc"],
                    type = "range",
                    order = 4,
                    min = -4,
                    max = 55,
                    step = 1,
                    isPercent = false,
                    default = 2,
                    set = function(self, val)
                      MRadialSavedVariables["debuffFontSize"] = val
                      mRadial:UpdateUI(false)
                    end,
                    get = function(self)
                      local current = MRadialSavedVariables["debuffFontSize"]
                      if current == nil then current = MR_DEFAULT_FONTSIZE end
                      return current end,
                  },
                }
              },
              powerGrp = {
                name = L["Opt_power_name"],
                type = "group",
                inline = true,
                order = 8,
                args = {
                  powerEnabled = {
                    name = L["Opt_PowerEnabled_name"],
                    desc = L["Opt_PowerEnabled_desc"],
                    type = "toggle",
                    default = true,
                    set = function(info,val)
                      MRadialSavedVariables["powerTextEnabled"] = val
                      mRadial:UpdateUI(false)
                    end,
                    get = function(info) 
                      local current = MRadialSavedVariables["powerTextEnabled"]
                      if current == nil then return MR_DEFAULT_POWERENABLED end
                      return current
                    end,
                    order = 1,
                  },
                  powerAlways = {
                    name = L["Opt_PowerPersists_name"],
                    desc = L["Opt_PowerPersists_desc"],
                    type = "toggle",
                    default = true,
                    set = function(info,val)
                      MRadialSavedVariables["powerPersistsEnabled"] = val
                      mRadial:UpdateUI(false)
                    end,
                    get = function(info) 
                      local current = MRadialSavedVariables["powerPersistsEnabled"]
                      if current == nil then return MR_DEFAULT_POWERPERSISTS end
                      return current
                    end,
                    order = 1,
                  },
                  powerUpDown = {
                    name = L["Up/Down"],
                    desc = "DEFAULT: 0",
                    type = "range",
                    order = 1,
                    min = -50,
                    max = 50,
                    step = 1,
                    isPercent = false,
                    default = 0,
                    set = function(self, val)
                      MRadialSavedVariables["powerUdOffset"] = val
                      mRadial:UpdateUI(false)
                    end,
                    get = function(self)
                      local current = MRadialSavedVariables["powerUdOffset"]
                      if current == nil then return MR_DEFAULT_POWERUDOFFSET end
                      return current 
                    end,
                  },
                  powerLeftRight = {
                    name = L["Left/Right"],
                    desc = "DEFAULT: 0",
                    type = "range",
                    order = 2,
                    min = -50,
                    max = 50,
                    step = 1,
                    isPercent = false,
                    default = 0,
                    set = function(self, val)
                      MRadialSavedVariables["powerLROffset"] = val
                      mRadial:UpdateUI(false)
                    end,
                    get = function(self)
                      local current = MRadialSavedVariables["powerLROffset"]
                      if current == nil then return MR_DEFAULT_POWERLROFFSET end
                      return current 
                    end,
                  },
                  powerColour = {
                    type = "color",
                    name = L["Power Colour"],
                    desc = "",
                    order = 3,
                    hasAlpha = false,
                    get = function(info)
                      local color = MRadialSavedVariables["powerColor"]
                      if color == nil then color = {.3, .2, .5, 1} end
                      local r, g, b, a = color[1], color[2], color[3], color[4]
                      return r, g, b, a
                    end,
                    set = function(info, r, g, b, a)
                      MRadialSavedVariables["powerColor"] = {r, g, b, a}
                      mRadial:UpdateUI(false)
                    end,
                  },
                  powerFontSize = {
                    name = L["Opt_Size"],
                    desc = L["Opt_DEFAULT2_desc"],
                    type = "range",
                    order = 4,
                    min = -4,
                    max = 55,
                    step = 1,
                    isPercent = false,
                    default = 2,
                    set = function(self, val)
                      MRadialSavedVariables["powerFontSize"] = val
                      mRadial:UpdateUI(false)
                    end,
                    get = function(self)
                      local current = MRadialSavedVariables["powerFontSize"]
                      if current == nil then return MR_DEFAULT_FONTSIZE end
                      return current 
                    end,
                  },
                }
              }
            },
            order=6
          },
          } 
      },

      spellOptions={
        name = L["Opt_radialSpells_desc"],
        desc = "",
        type = "group",
        childGroups = "tab",
        layout = "Flow",
        args = {
          fagDesc = {
            name = L["Opt_fagDesc_desc"],
            type = "description",
            order = 1
          },
          hidePassive = {
            name = L["Opt_hidePassiveSpells_name"],
            type = "toggle",
            order = 2,
            defaultValue = true,
            set = function(info, val) 
              MRadialSavedVariables["HidePassiveSpells"] = val
              MROptionsTable.args.spellOptions.args.primarySpells.args = mRadial:BuildSpellSelectionPane("isActive", val)
              MROptionsTable.args.spellOptions.args.secondarySpells.args = mRadial:BuildSpellSelectionPane("isSecondaryActive", val)
            end,
            get = function()
              local hide = MRadialSavedVariables["HidePassiveSpells"]
              if hide == nil then hide = true end
              return hide end,
          },
          changePrimaryOrder = {
            name = L["Opt_primarySpellOrder_name"],
            type = "execute",
            func = function(info, value)
              mRadial:BuildPrimarySpellOrder(true)
            end,
          },
          changeSecondaryOrder = {
            name = L["Opt_secondarySpellOrder_name"],
            type = "execute",
            func = function(info, value)
              mRadial:BuildSecondarySpellOrder(true)
            end,
          },
          primarySpells = {
            name = L["Opt_primarySpells_name"],
            type = "group",
            order=3,
            layout = "Flow",
            args = {}
          },
          secondarySpells = {
            name = L["Opt_secondarySpells_name"],
            type = "group",
            order=4,
            args = {}
          }
        },
        order=3,
      },

      linkedSpellOptions={
        name = L["Opt_linkedSpells_name"],
        type = "group",
        args={},
        order=4
      },

      warlockSpellOptions={
        name = L["Opt_warlock_name"],
        type = "group",
        args={
          shards ={
            name = L["Opt_ShardFrames_name"],
            type = "group",
            inline = "true",
            order = 2,
            args = {
              outOfShardsFrameSize = {
                name = L["Opt_OutOfShardsFrameSize_name"],
                desc = L["Opt_OutOfShardsFrameSize_desc"],
                type = "range",
                order = 1,
                min = 10,
                max = 500,
                step = .01,
                isPercent = false,
                default = 10,
                set = function(self, val)
                  MRadialSavedVariables["shardOutOfFrameSize"] = val
                  mRadial:setOOSShardFramesSize()
                end,
                get = function(self) 
                  local oosfs = MRadialSavedVariables["shardOutOfFrameSize"]
                  if oosfs == nil then oosfs = MR_DEFAULT_OOS_FS end
                  return  oosfs end,
              },
              shardFrameSize = {
                name = L["Opt_ShardTrackerFrameSize_name"],
                desc = L["Opt_ShardTrackerFrameSize_desc"],
                type = "range",
                order = 2,
                min = 10,
                max = 1000,
                step = 1,
                isPercent = false,
                default = 12,
                set = function(self, val)
                  MRadialSavedVariables["shardTrackerFrameSize"] = val
                  mRadial:setShardTrackerFramesSize()
                end,
                get = function(self) 
                  local sfs = MRadialSavedVariables["shardTrackerFrameSize"]
                  if sfs == nil then sfs = MR_DEFAULT_OOS_FS end
                  return sfs end,
              },
              shardFrameTransparency = {
                name = L["Opt_ShardTrackerTrans_name"],
                desc = L["Opt_ShardTrackerTrans_desc"],
                type = "range",
                order = 3,
                min = 0,
                max = 1,
                step = .01,
                isPercent = true,
                default = 1,
                set = function(self, val)
                  MRadialSavedVariables["shardFrameTransparency"] = val
                  mRadial:CreateShardCountFrame()
                end,
                get = function(self) 
                  local trans = MRadialSavedVariables["shardFrameTransparency"]
                  if trans == nil then trans = MR_DEFAULT_SHARD_TRANS end
                  return trans end,
              },
              hideShardFrame = {
                name = L["Opt_HideShardTracker_name"],
                desc = L["Opt_HideShardTracker_desc"],
                type = "toggle",
                order = 4,
                defaultValue = false,
                set = function(info, val)
                  MRadialSavedVariables["hideShardFrame"] = val
                  mRadial:CreateShardCountFrame()
                  mRadial:shardtrack()
                  mRadial:UpdateUI()
                end,
                get = function(info)
                  local hideShardFrame = MRadialSavedVariables["hideShardFrame"]
                  if hideShardFrame == nil then hideShardFrame = false end
                  return hideShardFrame end,
              },
              hideOOSShardFrame = {
                name = L["Opt_HideOOSShardTracker_name"],
                desc = L["Opt_HideOOSShardTracker_desc"],
                type = "toggle",
                order = 4,
                defaultValue = false,
                set = function(info, val)
                  MRadialSavedVariables["hideOOShardFrame"] = val
                  mRadial:shardtrack()
                end,
                get = function(info)
                  local hideShardFrame = MRadialSavedVariables["hideOOShardFrame"]
                  if hideShardFrame == nil then hideShardFrame = MR_DEFAULT_HIDE_OOSF end
                  return hideShardFrame end,
              },
            },
          },
          impCounterFrame = {
            name = L["Opt_HideImpCountFrame_name"],
            desc = L["Opt_HideImpCountFrame_desc"],
            type = "toggle",
            order = 4,
            defaultValue = false,
            set = function(info, val)
              MRadialSavedVariables["impCounterFrame"] = val
              mRadial:InitUI(false)
            end,
            get = function(info)
              local current = MRadialSavedVariables["impCounterFrame"]
              if current == nil then current = MR_DEFAULT_IMPCOUNTERFRAME end
              return current end,
          },
        },
        order=4
      },

      petOptions={
        name = L["Opt_pet_name"],
        type = "group",
        args={
          pet ={
            name = L["Opt_PetFrames_name"],
            type = "group",
            inline = "true",
            order = 1,
            args = {
              hidePetFrames = {
                name = L["Opt_HidePetFrames_name"],
                desc = L["Opt_HidePetFrames_desc"],
                type = "toggle",
                order = 1,
                defaultValue = false,
                set = function(info, val)
                  MRadialSavedVariables["hidePetFrame"] = val 
                  mRadial:SetPetFramePosAndSize()
                end,
                get = function(info) return MRadialSavedVariables["hidePetFrame"] end,
              },
              iconSize = {
                name = L["Opt_IconSize_name"],
                desc = L["Opt_IconSize_desc"],
                type = "range",
                order = 2,
                min = 1,
                max = 200,
                isPercent = false,
                default = 40,
                set = function(self, val)
                  MRadialSavedVariables["PetFramesSize"] = val
                  mRadial:SetPetFramePosAndSize()
                  mRadial:UpdateUI(false)
                end,
                get = function(self) 
                  local current = MRadialSavedVariables["PetFramesSize"]
                  if current == nil then current = 40 end
                  return current
                 end,
              },
              resetPetPos = {
                name = L["Opt_Reset_PetFrames_name"],
                desc = L["Opt_Reset_PetFrames_desc"],
                type = "execute",
                order = 3,
                func  = function(self, val)
                  local petFrameSize = MRadialSavedVariables.PetFramesSize
                  if petFrameSize == nil then petFrameSize = MR_DEFAULT_PET_FRAMESIZE end
                  local x = -50
                  for _, frame in ipairs(MR_ALLFRAMES) do
                    if frame.isPetFrame then 
                      local frameName = frame:GetName()
                      mRadial:RestoreFrame(frameName, frame, true, x, -150)
                      x = x + (5+petFrameSize)
                    end
                  end
                end,
              },
              petAbilityIgnore ={
                name = "Ignore",
                type = "group",
                inline = "true",
                order = 4,
                args = {
                  ingoreInput = {
                    name = L["Opt_PetIgnoreInput_name"],
                    desc = L["Opt_PetIgnoreInput_desc"],
                    width  = "full",
                    type = "input",
                    multiline = true,
                    order = 1,
                    set = function(info, val)
                      MRadialSavedVariables["hidePetAbilities"] = val
                    end,
                    get = function()
                        return MRadialSavedVariables["hidePetAbilities"] or ""
                    end,
                  },
                },
              },
              pet_cooldownGrp = {
                name = L["Opt_CoolDown_name"],
                type = "group",
                inline = true,
                order = 6,
                args = {
                  pet_cooldownUpDown = {
                    name = L["Up/Down"],
                    desc = "DEFAULT: 0",
                    type = "range",
                    order = 1,
                    min = -50,
                    max = 50,
                    step = 1,
                    isPercent = false,
                    default = 0,
                    set = function(self, val)
                      MRadialSavedVariables["pet_cdUdOffset"] = val
                      mRadial:SetPetFramePosAndSize()
                      mRadial:UpdateUI(false)
                    end,
                    get = function(self) 
                      local cdoffset =  MRadialSavedVariables["pet_cdUdOffset"]
                      if cdoffset == nil then cdoffset = MR_DEFAULT_PET_CDUDOFFSET end
                      return cdoffset end,
                  },
                  pet_cooldown_LeftRight = {
                    name = L["Left/Right"],
                    desc = "DEFAULT: 0",
                    type = "range",
                    order = 2,
                    min = -50,
                    max = 50,
                    step = 1,
                    isPercent = false,
                    default = 0,
                    set = function(self, val)
                      MRadialSavedVariables["pet_cdLROffset"] = val
                      mRadial:SetPetFramePosAndSize()
                      mRadial:UpdateUI(false)
                    end,
                    get = function(self) 
                      local lroffset =  MRadialSavedVariables["pet_cdLROffset"]
                      if lroffset == nil then lroffset = MR_DEFAULT_PET_CDLROFFSET end
                      return lroffset end,
                  },
                  pet_cooldownColour = {
                    type = "color",
                    name = "Cooldown Colour",
                    desc = "",
                    order = 3,
                    hasAlpha = false,
                    get = function(info)
                      local color = MRadialSavedVariables["pet_cdColor"]
                      if color == nil then color = {.1, 1, .1, 1} end
                      local r, g, b, a = color[1], color[2], color[3], color[4]
                      return r, g, b, a
                    end,
                    set = function(info, r, g, b, a)
                      MRadialSavedVariables["pet_cdColor"] = {r, g, b, a}
                      mRadial:SetPetFramePosAndSize()
                      mRadial:UpdateUI(false)
                    end,
                  },
                  pet_coolDownFontSize = {
                    name = L["Opt_Size"],
                    desc = L["Opt_DEFAULT2_desc"],
                    type = "range",
                    order = 4,
                    min = -4,
                    max = 55,
                    step = 1,
                    isPercent = false,
                    default = 2,
                    set = function(self, val)
                      MRadialSavedVariables["pet_coolDownFontSize"] = val
                      mRadial:SetPetFramePosAndSize()
                      mRadial:UpdateUI(false)
                    end,
                    get = function(self) 
                      local cdFontSize = MRadialSavedVariables["pet_coolDownFontSize"]
                      if cdFontSize == nil then cdFontSize = MR_DEFAULT_PET_FONTBIGGERSIZE end
                      return cdFontSize end,
                  },
                }
              },
              pet_readyGrp = {
                name = L["Opt_ready_name"],
                type = "group",
                inline = true,
                order = 7,
                args = {
                  pet_readyUpDown = {
                    name = L["Up/Down"],
                    desc = "DEFAULT: 0",
                    type = "range",
                    order = 1,
                    min = -50,
                    max = 50,
                    step = 1,
                    isPercent = false,
                    default = 0,
                    set = function(self, val)
                      MRadialSavedVariables["pet_readyUDOffset"] = val
                      mRadial:SetPetFramePosAndSize()
                      mRadial:UpdateUI(false)
                    end,
                    get = function(self) 
                      local val = MRadialSavedVariables["pet_readyUDOffset"]
                      if val == nil then val = MR_DEFAULT_PET_READYUDOFFSET end
                      return val end,
                  },
                  pet_readyLeftRight = {
                    name = L["Left/Right"],
                    desc = "DEFAULT: 0",
                    type = "range",
                    order = 2,
                    min = -50,
                    max = 50,
                    step = 1,
                    isPercent = false,
                    default = 0,
                    set = function(self, val)
                      MRadialSavedVariables["pet_readyLROffset"] = val
                      mRadial:SetPetFramePosAndSize()
                      mRadial:UpdateUI(false)
                    end,
                    get = function(self) 
                      local val = MRadialSavedVariables["pet_readyLROffset"]
                      if val == nil then val = MR_DEFAULT_PET_READYLROFFSET end
                      return val end,
                  },
                  pet_ReadyColour = {
                    type = "color",
                    name = "Pick Colour",
                    desc = "",
                    order = 3,
                    hasAlpha = false,
                    get = function(info)
                      local color = MRadialSavedVariables["pet_readyColor"]
                      if color == nil then color = {.1, 1, .1, 1} end
                      local r, g, b, a = color[1], color[2], color[3], color[4]
                      return r, g, b, a
                    end,
                    set = function(info, r, g, b, a)
                      MRadialSavedVariables["pet_readyColor"] = {r, g, b, a}
                      mRadial:UpdateUI(false)
                    end,
                  },
                  pet_readyFontSize = {
                    name = L["Opt_Size"],
                    desc = L["Opt_DEFAULT2_desc"],
                    type = "range",
                    order = 4,
                    min = -4,
                    max = 55,
                    step = 1,
                    isPercent = false,
                    default = 2,
                    set = function(self, val)
                      MRadialSavedVariables["pet_readyFontSize"] = val
                      mRadial:SetPetFramePosAndSize()
                      mRadial:UpdateUI(false)
                    end,
                    get = function(self) 
                      local val = MRadialSavedVariables["pet_readyFontSize"]
                      if val == nil then val = MR_DEFAULT_PET_FONTBIGGERSIZE end
                      return val end,
                  },
                }
              },
              pet_countGrp = {
                name = L["Opt_count_name"],
                type = "group",
                inline = true,
                order = 8,
                args = {
                  pet_countUpDown = {
                    name = L["Up/Down"],
                    desc = "DEFAULT: 0",
                    type = "range",
                    order = 1,
                    min = -50,
                    max = 50,
                    step = 1,
                    isPercent = false,
                    default = 0,
                    set = function(self, val)
                      MRadialSavedVariables["pet_countUdOffset"] = val
                      mRadial:SetPetFramePosAndSize()
                      mRadial:UpdateUI(false)
                    end,
                    get = function(self)
                      local val = MRadialSavedVariables["pet_countUdOffset"]
                      if val == nil then val = MR_DEFAULT_PET_COUNTUDOFFSET end
                      return val end,
                  },
                  pet_countLeftRight = {
                    name = L["Left/Right"],
                    desc = "DEFAULT: 0",
                    type = "range",
                    order = 2,
                    min = -50,
                    max = 50,
                    step = 1,
                    isPercent = false,
                    default = 0,
                    set = function(self, val)
                      MRadialSavedVariables["pet_countLROffset"] = val
                      mRadial:SetPetFramePosAndSize()
                      mRadial:UpdateUI(false)
                    end,
                    get = function(self) 
                      local val = MRadialSavedVariables["pet_countLROffset"]
                      if val == nil then val = MR_DEFAULT_PET_COUNTLROFFSET end
                      return val end,
                  },
                  pet_CountColour = {
                    type = "color",
                    name = "Count Colour",
                    desc = "",
                    order = 3,
                    hasAlpha = false,
                    get = function(info)
                      local color = MRadialSavedVariables["pet_countColor"]
                      if color == nil then color = {0, 1, 1, 1} end
                      local r, g, b, a = color[1], color[2], color[3], color[4]
                      return r, g, b, a
                    end,
                    set = function(info, r, g, b, a)
                      MRadialSavedVariables["pet_countColor"] = {r, g, b, a}
                      mRadial:SetPetFramePosAndSize()
                      mRadial:UpdateUI(false)
                    end,
                  },
                  pet_countFontSize = {
                    name = L["Opt_Size"],
                    desc = L["Opt_DEFAULT2_desc"],
                    type = "range",
                    order = 4,
                    min = -4,
                    max = 55,
                    step = 1,
                    isPercent = false,
                    default = 2,
                    set = function(self, val)
                      MRadialSavedVariables["pet_countFontSize"] = val
                      mRadial:SetPetFramePosAndSize()
                      mRadial:UpdateUI(false)
                    end,
                    get = function(self)
                      local val = MRadialSavedVariables["pet_countFontSize"]
                      if val == nil then val = MR_DEFAULT_PET_FONTSIZE end
                      return val end,
                  },
                }
              },
            }
          },
        },
        order=4
      },

      transferOptions={
        name = L["Opt_Transfer_name"],
        type = "group",
        args={
          specPositions = {
              name = L["Opt_copy_name"],
              desc = L["Opt_copy_desc"],
              type = "select",
              style = "dropdown",
              width = "full",
              values = function()
                local specNames = {}
                local numSpecializations = GetNumSpecializations(false, false)
                for x=1, numSpecializations do
                    local _, name, _, _, _, _ENV = GetSpecializationInfo(x)
                    specNames[#specNames+1] = name
                end
                return specNames
              end,
              order = 1,
              get = function(widget, val) 
                local playerSpec = GetSpecialization()
                return playerSpec
              end,
              set = function(widget, val) 
                local warning = mRadial:PopUpDialog(L["Warning"], L["CopyWarning1"], 400, 120)
                warning:Show()
                warning.acceptButton:SetCallback("OnClick", function()
                  warning:Hide()
                  mRadial:CopyFramesFromSpec(val)
                  mRadial:InitUI(false)
                end) 
                
                warning.cancelButton:SetCallback("OnClick", function() warning:Hide() end)
              end,
          },
          specDimensions = {
            name = L["Opt_copy_dimensions_name"],
            desc = L["Opt_copy_dimensions_desc"],
            type = "select",
            style = "dropdown",
            width = "full",
            values = function()
              local specNames = {}
              local numSpecializations = GetNumSpecializations(false, false)
              for x=1, numSpecializations do
                  local _, name, _, _, _, _ENV = GetSpecializationInfo(x)
                  specNames[#specNames+1] = name
              end
              return specNames
            end,
            order = 2,
            get = function(widget, val) 
              local playerSpec = GetSpecialization()
              return playerSpec
            end,
            set = function(widget, val) 
              local warning = mRadial:PopUpDialog(L["Warning"], L["CopyWarning1"], 400, 120)
              warning:Show()
              warning.acceptButton:SetCallback("OnClick", function()
                warning:Hide()
                mRadial:CopyDimensionsFromSpec(val)
                mRadial:InitUI(false)
              end) 
              
              warning.cancelButton:SetCallback("OnClick", function() warning:Hide() end)
            end,
        },
          specFont = {
            name = L["Opt_copy_font_name"],
            desc = L["Opt_copy_font_desc"],
            type = "select",
            style = "dropdown",
            width = "full",
            values = function()
              local specNames = {}
              local numSpecializations = GetNumSpecializations(false, false)
              for x=1, numSpecializations do
                  local _, name, _, _, _, _ENV = GetSpecializationInfo(x)
                  specNames[#specNames+1] = name
              end
              return specNames
            end,
            order = 3,
            get = function(widget, val) 
              local playerSpec = GetSpecialization()
              return playerSpec
            end,
            set = function(widget, val) 
              local warning = mRadial:PopUpDialog(L["Warning"], L["CopyWarning1"], 400, 120)
              warning:Show()
              warning.acceptButton:SetCallback("OnClick", function()
                warning:Hide()
                mRadial:CopyFontFromSpec(val)
                mRadial:InitUI(false)
              end) 
              
              warning.cancelButton:SetCallback("OnClick", function() warning:Hide() end)
            end,
      },
        }
      },
  }
}

------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- MAIN PANE
function mRadial:OptionsPane()
  MR_configRegistry:RegisterOptionsTable(appName, MROptionsTable, true)
  if UnitAffectingCombat("player") then
    return
  end
  if MRADIALOptionsPane == nil then
    -- Create the frame
    MRADIALOptionsPane = AceGUI:Create("Frame")
    MR_configDialog:SetDefaultSize(appName, 820, 600)
    MR_configDialog:Open(appName, MRADIALOptionsPane)
    MRADIALOptionsPane:SetLayout("Flow")
    MRADIALOptionsPane:SetTitle("---".. appName .. "---")
    MRADIALOptionsPane:SetCallback("OnClose", function(widget)
      MRadialSavedVariables["moveable"] = false
      mRadial:SetConfigMode(false)
      mRadial:UpdateUI(false)
      AceGUI:Release(widget) 
    end)
    MRADIALOptionsPane.frame:EnableMouse(true)
    MRADIALOptionsPane.frame:SetMovable(true)
    MRADIALOptionsPane.frame:SetScript("OnMouseDown", function(self, button)
      if button == "LeftButton" then
        MRADIALOptionsPane.frame:StartMoving()
      end
    end)
    MRADIALOptionsPane.frame:SetScript("OnMouseUp", function(self, button)
      MRADIALOptionsPane.frame:StopMovingOrSizing()
      local self = MRADIALOptionsPane.frame.obj
      local status = self.status or self.localstatus
      status.width = MRADIALOptionsPane.frame:GetWidth()
      status.height = MRADIALOptionsPane.frame:GetHeight()
      status.top = MRADIALOptionsPane.frame:GetTop()
      status.left = MRADIALOptionsPane.frame:GetLeft()
      MRADIALOptionsPane:SetTitle("---".. appName .. "---")
      MRADIALOptionsPane:SetStatusText("Select options")
      AceGUI:ClearFocus()
  end)
    local hidePassive = MRadialSavedVariables["HidePassiveSpells"] or true
    MROptionsTable.args.spellOptions.args.primarySpells.args = mRadial:BuildSpellSelectionPane("isActive", hidePassive)
    MROptionsTable.args.spellOptions.args.secondarySpells.args = mRadial:BuildSpellSelectionPane("isSecondaryActive", hidePassive)
    MROptionsTable.args.linkedSpellOptions.args = mRadial:linkedSpellPane()
  else
    MR_configDialog:Open(appName, MRADIALOptionsPane)
    MRADIALOptionsPane:SetTitle("---".. appName .. "---")
    MRADIALOptionsPane:SetStatusText("Select options")
  end
  MR_configRegistry:NotifyChange(appName)
end

function mRadial:PopUpDialog(title, labelText, w, h)
  local AceGUI = LibStub("AceGUI-3.0")
  local frame = AceGUI:Create("Window")
  frame:SetTitle(title)
  frame:SetWidth(w)
  frame:SetHeight(h)

  local layout = AceGUI:Create("SimpleGroup")
  layout:SetLayout("Flow")
  layout:SetFullWidth(true)
  
  local label = AceGUI:Create("Label")
  label:SetText(labelText)
  label:SetFullWidth(true)

  local acceptButton = AceGUI:Create("Button")
  acceptButton:SetText("Accept")
  acceptButton:SetCallback("OnClick", function() return true end)

  local cancelButton = AceGUI:Create("Button")
  cancelButton:SetText("Cancel")
  cancelButton:SetCallback("OnClick", function() return false end)

  frame:AddChild(label)
  layout:AddChild(acceptButton)
  layout:AddChild(cancelButton)
  frame:Hide()
  frame.acceptButton = acceptButton
  frame.cancelButton = cancelButton

  frame:AddChild(layout)
  return frame
end

function mRadial:WrapText(str)
  if str == nil then
      return ""
  end

  local result = ""
  local line = ""
  for word in str:gmatch("%S+") do
      if #line + #word >= 40 then
          result = result .. line .. "\n"
          line = ""
      end
      if line == "" then
          line = word
      else
          line = line .. " " .. word
      end
  end
  if line ~= "" then
      result = result .. line
  end
  return result
end

------------------------------------------------------------------------------------------
------ UTILS
local function SpellNameInActiveWatchers(spellName)
  for _, watcher in ipairs(ACTIVEPRIMARYWATCHERS) do
      if watcher.spellName == spellName then
          return true
      end
  end
  return false
end

local function SpellNameInActiveSecondaryWatchers(spellName)
  for _, watcher in ipairs(ACTIVESECONDARYWATCHERS) do
      if watcher.spellName == spellName then
          return true
      end
  end
  return false
end
------------------------------------------------------------------------------------------
-- SPELL SELECTION
function mRadial:BuildSpellSelectionPane(isActiveSavedVarStr, hidePassive)
  local widgetArgs = {}
  
  local resetGrp = {
    name = "",
    type = "group",
    inline = true,
    order = 2,
    args = {
      reset = {
        name = "Reset",
        type = "execute",
        order = 1,
        func = function(info, val)
          local warning = mRadial:PopUpDialog(L["Warning"], L["ResetWarning"], 400, 120)
          warning:Show()
          warning.acceptButton:SetCallback("OnClick", function() 
            for x=1, #MR_WATCHERFRAMES do
              local watcher = MR_WATCHERFRAMES[x]
              local isActive = MRadialSavedVariables[isActiveSavedVarStr .. watcher.spellName] or false
              if isActive then
                MRadialSavedVariables[isActiveSavedVarStr .. watcher.spellName] = false
              end
            end
            warning:Hide()
            mRadial:UpdateActivePrimarySpells()
            mRadial:UpdateActiveSecondarySpells()
            mRadial:UpdateUI(true)
            MROptionsTable.args.spellOptions.args.primarySpells.args = mRadial:BuildSpellSelectionPane("isActive", hidePassive)
            MROptionsTable.args.spellOptions.args.secondarySpells.args = mRadial:BuildSpellSelectionPane("isSecondaryActive", hidePassive)
            end)
          
          warning.cancelButton:SetCallback("OnClick", function() warning:Hide() end)
          end,
      }
    }
  }

  table.insert(widgetArgs, resetGrp)

  ----- SPELL LIST
  if hidePassive == nil then hidePassive = false end
  
  local activeTalentTreeSpells = mRadial:GetAllActiveTalentTreeSpells()
  local activeSpells = {}
  local passiveSpells = {}
  
  local asPrimary = isActiveSavedVarStr == "isActive"
  
  -- BUILD SPELL TABLES NOW
  if activeTalentTreeSpells ~= nil then
      for _, spellData in ipairs(activeTalentTreeSpells) do
          -- add a bool flag for each into the saved vars, so we can check against this in the radial menu!
          local spellName = spellData[1]
          -- SECONDARY SPELLS
          local spellID = spellData[2]
          local desc = GetSpellDescription(spellID)
          local isActiveSavedVarStr = isActiveSavedVarStr .. spellName

          if not asPrimary and not SpellNameInActiveWatchers(spellName) then
              if IsPassiveSpell(spellID) then
                  table.insert(passiveSpells, {spellName, desc, isActiveSavedVarStr, false, spellID})
              else
                  table.insert(activeSpells, {spellName, desc, isActiveSavedVarStr, false, spellID})
              end
          -- PRIMARY SPELLS
          elseif asPrimary and not SpellNameInActiveSecondaryWatchers(spellName) then
              if IsPassiveSpell(spellID) then
                  table.insert(passiveSpells, {spellName, desc, isActiveSavedVarStr, false, spellID})
              else
                  table.insert(activeSpells, {spellName, desc, isActiveSavedVarStr, false, spellID})
              end
          end
      end
  end

  -- SPELLS
  local activeIDX = 1
  for idx, activeSpellData in ipairs(activeSpells) do
      local spellName, desc, isactiveSpellName, defaultValue, spellID = unpack(activeSpellData)
      local iconPath
      if spellID ~= nil then
          _, _, iconPath, _, _, _, _, _ = GetSpellInfo(spellID)
      end
      local spellsCbxs = {
          name = spellName,
          desc = desc,
          defaultValue = defaultValue,
          type = "toggle",
          order = idx+1,
          image = iconPath,
          set = function(info, value)
            -- Store the savedVars
            MRadialSavedVariables[isactiveSpellName] = value
            -- Rebuild the UI for the spell changes.
            mRadial:UpdateUI(true)
            -- Sync the checkboxes so we don't have them sharing selected spells.
            if asPrimary then
              MROptionsTable.args.spellOptions.args.secondarySpells.args = mRadial:BuildSpellSelectionPane("isSecondaryActive", hidePassive)
            else
              MROptionsTable.args.spellOptions.args.primarySpells.args = mRadial:BuildSpellSelectionPane("isActive", hidePassive)
            end
          end,
          get = function(info) 
            return MRadialSavedVariables[isactiveSpellName]
          end,
      }
      table.insert(widgetArgs, spellsCbxs)
      activeIDX = activeIDX + idx+1
  end

  -- PASSIVE
  if not hidePassive then
      for idx, passiveSpellData in ipairs(passiveSpells) do
          local spellName, desc, isactiveSpellName, defaultValue, spellID = unpack(passiveSpellData)
          local iconPath
          if spellID ~= nil then
            _, _, iconPath, _, _, _, _, _ = GetSpellInfo(spellID)
          end
          local spellsCbxs = {
              name = spellName .. "-PASSIVE",
              desc = desc,
              defaultValue = defaultValue,
              type = "toggle",
              order = idx+activeIDX,
              image = iconPath,
              set = function(info, value) 
                  MRadialSavedVariables[isactiveSpellName] = value
                  if asPrimary then
                    MROptionsTable.args.spellOptions.args.secondarySpells.args = mRadial:BuildSpellSelectionPane("isSecondaryActive", hidePassive)
                  else
                    MROptionsTable.args.spellOptions.args.primarySpells.args = mRadial:BuildSpellSelectionPane("isActive", hidePassive)
                  end
              end,
              get = function(info) 
                return MRadialSavedVariables[isactiveSpellName]
              end,
          }
          table.insert(widgetArgs, spellsCbxs)
      end
  end

  return widgetArgs
end

-- SPELL ORDER
function mRadial:CreateOrderParentFrame()
  local parentFrame = AceGUI:Create("Window")
        local title = L["Opt_SpellOrderFrame_Name"]
        parentFrame:SetTitle(title)
        parentFrame:SetLayout("List")
        parentFrame:SetWidth(400)
        parentFrame:SetHeight(200)

        local info = AceGUI:Create("Label") 
        local text = L["Opt_SpellOrderFrame_Desc"]
        info:SetText(text)
        info:SetWidth(350)

        local grp = AceGUI:Create("InlineGroup")
        grp:SetLayout("Flow")
        grp:SetFullWidth(true)
        parentFrame.order = grp

        parentFrame:AddChild(info)
        parentFrame:AddChild(grp)
        parentFrame:Hide()
  return parentFrame
end

function mRadial:BuildPrimarySpellOrder(showUI)
  if MRPrimarySpellOrderFrame == nil then
    MRPrimarySpellOrderFrame = mRadial:CreateOrderParentFrame()
  end
  if showUI then
    MRPrimarySpellOrderFrame:Show()
  end
  mRadial:BuildOrderLayout(MRPrimarySpellOrderFrame.order, MRadialSavedVariables["primaryWatcherOrder"], ACTIVEPRIMARYWATCHERS, mRadial.BuildPrimarySpellOrder)
  
end

function mRadial:BuildSecondarySpellOrder(showUI)
  if MRSecondarySpellOrderFrame == nil then
    MRSecondarySpellOrderFrame = mRadial:CreateOrderParentFrame()
  end
  if showUI then
    MRSecondarySpellOrderFrame:Show()
  end
  mRadial:BuildOrderLayout(MRSecondarySpellOrderFrame.order, MRadialSavedVariables["secondaryWatcherOrder"], ACTIVESECONDARYWATCHERS, mRadial.BuildSecondarySpellOrder)
end

local function UpdateTableOrder(orderTable, srcWatcher, destWatcher, srcIDX, destIDX)
  for idx, _ in ipairs(orderTable) do
      if idx == destIDX then
          orderTable[idx] = srcWatcher
      elseif idx == srcIDX then
          orderTable[idx] = destWatcher
      end
  end
end

-- GENERIC Function to create a spellOrder list using the ActionSlot widgets
-- @param: savedVarTable: Table to store for the saveVariables.
-- @param: watcherTable: The table to process the watcher frames from.
-- @param: refreshFunc: The function to call when we're done.
-- @param: widgetArgs: table for Ace3Config to add UI elements to
function mRadial:BuildOrderLayout(parentFrame, savedVarTable, watcherTable, refreshFunc)
  parentFrame:ReleaseChildren()  
  -- GENERIC Function to create a spellOrder list using the ActionSlot widgets 
    local recorded_actionData = nil
    local destIDX = -1
    local srcIDX = -1
    local function recordCurrent(this)
        local self = this.obj
        recorded_actionData = self.actionData
    end

    local function changeOrder(this, button, down)
        local self = this.obj
        if button  == "LeftButton" then
            -- stash existing data.
            recordCurrent(this)
            destIDX = self:GetUserData("index")
            -- Grab info from cursor and set new icon for button
            local _, data1, data2 = GetCursorInfo()
            if data1 == nil then
                -- we didn't drag anything.. so move on..
                return
            end

            local _, spellID = GetSpellLink(data1, data2)
            local spellName, _, iconPath, _, _, _, _, _ = GetSpellInfo(spellID)
            -- update the button data we're "dropping" on
            self.actionType = "spell"
            self.actionData = spellName
            
            self.icon:SetTexture(iconPath)
            self.icon:Show()
            
            -- reorder src dest now
            local srcWatcher = nil
            local destWatcher = nil
            for idx, watcher in ipairs(savedVarTable) do
                if idx == srcIDX then
                    srcWatcher = watcher
                elseif idx == destIDX then
                    destWatcher = watcher
                end
            end
            UpdateTableOrder(savedVarTable, srcWatcher, destWatcher, srcIDX, destIDX)
            -- cleanup current dragged
            ClearCursor()
            refreshFunc(_, parentFrame)
            mRadial:UpdateUI(false)
        end

        if button == "RightButton" then
            srcIDX = self:GetUserData("index")
            if recorded_actionData == nil then
                return
            end
            if not down then
                local _, _, _, _, _, _, spellID, _ = GetSpellInfo(recorded_actionData)
                PickupSpell(spellID)
            end
        end
    end

    -- first we check to see if the table has a new entry compared to the orig
    local currentOrder = savedVarTable
    -- First time load init
    if currentOrder == nil then
        currentOrder = {}
    end

    -- Add NEW spells clicked active
    for _, watcher in ipairs(watcherTable) do
        local found = mRadial:OrderTableContains(currentOrder, watcher)
        if not found then
            currentOrder[#currentOrder+1] = watcher
        end
    end    

      -- Remove spells no longer in watcherTable
      for idx, watcher in ipairs(currentOrder) do
        local found = mRadial:OrderTableContains(watcherTable, watcher)
        if not found then
            table.remove(currentOrder, idx)
        end
    end  
    if savedVarTable == nil then
        savedVarTable = currentOrder
    end
    for idx, watcher in ipairs(currentOrder) do
        if watcher.isWatcher then
            local orderButton = AceGUI:Create("ActionSlot")
            orderButton:SetWidth(45)
            orderButton.icon:SetTexture(watcher.iconPath)
            orderButton.icon:Show()
            orderButton.actionType = "spell"
            orderButton.actionData = watcher.spellName
            orderButton.button:SetScript('OnClick', changeOrder)
            orderButton.button:SetScript("OnEnter", function(widget, _)
                recordCurrent(widget)
                GameTooltip:SetOwner(orderButton.button, "ANCHOR_CURSOR")
                GameTooltip:SetText(mRadial:WrapText(orderButton.actionData))
                GameTooltip:SetSize(80, 50)
                GameTooltip:SetWidth(80)
                GameTooltip:Show()
            end)

            orderButton.button:SetScript("OnLeave", function() 
                GameTooltip:SetOwner(UIParent, "ANCHOR_BOTTOMRIGHT")
                GameTooltip:SetText("")
                GameTooltip:SetSize(80, 50) 
                GameTooltip:SetWidth(80) 
                GameTooltip:Show()
            end)

            orderButton:SetUserData("index", idx)
            orderButton:SetUserData("watcher", watcher)
            orderButton.button:EnableMouse(true)
            parentFrame:AddChild(orderButton)
        end
    end 
end

------------------------------------------------------------------------------------------
-- LINKED SPELLS
-- Action button for dnd for linked spells..
local currentLinked

local function createLinkedInputTable(spellName, srcIcon, srcSpellID, srcLink, destName, destSpellID)
  local linkedLayout = {}
    linkedLayout = {
    name = "",
    type = "group",
    args = {
      linkedInputActionSlot = {
        name = spellName,
        type = "input",
        dialogControl = "Player_EditBox",
        order = 1,
        set = function(info, droppedSpellName)
            local current = MRadialSavedVariables["LINKEDSPELLS"]
            if current == nil then
              MRadialSavedVariables["LINKEDSPELLS"] = {}
              current = MRadialSavedVariables["LINKEDSPELLS"]
            end
            for srcSpellName, _ in pairs(current) do
              if srcSpellName == spellName then
                return
              end
            end
            -- we have a new entry being constructed.
            local entry = {}
            entry[1] = ""
            entry[2] = ""
            current[droppedSpellName] = entry
            MROptionsTable.args.linkedSpellOptions.args = mRadial:linkedSpellPane()
          end,
        get = function()
          local current = MRadialSavedVariables["LINKEDSPELLS"] or LINKEDSPELLS
          for srcSpellName, _ in pairs(current) do
            if srcSpellName == spellName then
              return srcSpellName
            end
          end
        end,
      },
      linkedSpellName ={
        name = L["Opt_LinkedSpellsLinkedTo_name"],
        order = 2,
        type = "input",
        dialogControl = "Player_EditBox",
        defaultValue = destName,
        get = function()
            local current = MRadialSavedVariables["LINKEDSPELLS"] or LINKEDSPELLS
            for srcSpellName, data in pairs(current) do
              if srcSpellName == spellName then
                local destSpellName = data[1]
                return destSpellName
              end
            end
          end,
        set = function(info, text) 
          local current = MRadialSavedVariables["LINKEDSPELLS"] 
          if current == nil then current = LINKEDSPELLS end
          for srcSpellName, data in pairs(current) do
            if srcSpellName == spellName then
              data[1] = text
              _, _, _, _, _, _, spellID, _ = GetSpellInfo(text)
              if spellID == nil then
                local found = false
                local activeTalentTreeSpells = mRadial:GetAllActiveTalentTreeSpells()
                -- lower level classes might not have an active talent tree.
                if activeTalentTreeSpells ~= nil then
                    for _, spellData in ipairs(mRadial:GetAllActiveTalentTreeSpells()) do
                        -- add a bool flag for each into the saved vars, so we can check against this in the radial menu!
                        local spellName = spellData[1]
                        if text == spellName then
                            spellID = spellData[2]  
                            found = true
                        end
                    end
                end
                if not found then
                    if text == L["Demonic Power"] then
                      spellID = "265273"    
                    elseif text == L["Rite of Ruvaraad"] then
                      spellID = "409725"
                    else
                      spellID = ""
                    end
                end
            end
              data[2] = tonumber(spellID)
            end
          end
        end,
      },
      linkedSpellID ={
        name = "",
        order = 3,
        type = "input",
        disabled = true,
        width = "half",
        get = function(info) 
          local current = MRadialSavedVariables["LINKEDSPELLS"] or LINKEDSPELLS
          for srcSpellName, data in pairs(current) do
            if srcSpellName == spellName then
              local destSpellID = data[2]
              return tostring(destSpellID)
            end
          end
        end,
      },
      removeLinkedSpell = {
        name = L["Opt_LinkedSpellsRemove_name"],
        type = "execute",
        order = 4,
        width = "half",
        func = function(info)
          -- There's no warning here, as nesting the refresh into the onclick callback refuses to update the UI as expected.
          local current = MRadialSavedVariables["LINKEDSPELLS"] or LINKEDSPELLS
          local cleaned = {}
          for srcSpellName, spellID in pairs(current) do
              if spellName ~= srcSpellName then
                cleaned[srcSpellName] = spellID
              end
          end
          MRadialSavedVariables["LINKEDSPELLS"] = cleaned
          MROptionsTable.args.linkedSpellOptions.args = mRadial:linkedSpellPane()
        end,
      }
    }
  }
  return linkedLayout
end

function mRadial:linkedSpellPane()
  local widgetArgs = {}
  local linkedStuff = {}
  
  -- Boilerplate for a linked layout
  local linkedParentGroup = {
    name = L["Opt_LinkedSpellsPane_name"],
    type = "group",
    inline = true,
    layout = "List",
    args = {
        info = {
          name = L["Opt_LinkedSpellsInfo_name"],
          type = "description",
          order = 1,
        },
        add = {
          name = L["Opt_LinkedSpellsAdd_name"],
          desc = "Note:",
          type = "execute",
          order = 2,
          func = function()
            local emptyEntry = createLinkedInputTable("", "", "", "", "", "") 
            table.insert(linkedStuff, emptyEntry) 
            MROptionsTable.args.linkedSpellOptions.args = widgetArgs
          end,
        },
        linkedGroup ={
          name = L["Opt_LinkedSpellsGrp_name"],
          type = "group",
          inline = true,
          order = 3,
          args = {
          }
        }
    }
  }
  -- All from saved vars!
  currentLinked = MRadialSavedVariables["LINKEDSPELLS"] or LINKEDSPELLS
  for spellName, linkedSpell in pairs(currentLinked) do
      local srcLink, spellID = GetSpellLink(spellName)
      if srcLink ~= nil then
          _, _, srcIcon, _, _, srcSpellID, originalIcon, _ = GetSpellInfo(spellID)
          local destSpellName = linkedSpell[1]
          local destSpellID = linkedSpell[2]
          if spellName then
            local entry = createLinkedInputTable(spellName, srcIcon, srcSpellID, srcLink, destSpellName, destSpellID)
            table.insert(linkedStuff, entry)
          end
      end
  end
  linkedParentGroup.args.linkedGroup.args = linkedStuff
  table.insert(widgetArgs, linkedParentGroup)
  return widgetArgs
end