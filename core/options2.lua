local AceGUI = LibStub("AceGUI-3.0")
local MR_configDialog = LibStub("AceConfigDialog-3.0")
local MR_configRegistry = LibStub("AceConfigRegistry-3.0")
local appName = "MRadial"


MROptionsTable = {
    type = "group",
    childGroups = "tree",
    args = {
      header = {
        name = "Generic Options",
        desc = "These apply to the entire UI",
        type = "header",
        order = 1,
      }, 
      configMode = {
        name = "Config Mode",
        desc = "Enables / disables config mode.",
        type = "toggle",
        set = function(info, val)
          MRadialSavedVariables["moveable"] = val 
          mRadial.SetUIMovable(val)
          mRadial:UpdateUI(true)
        end,
        get = function(info) return MRadialSavedVariables["moveable"] end,
        order = 2,
      },
      hideOutOfCombat = {
        name = "Hide Out Of Combat",
        desc = "Enables / disables hiding the UI while out of combat.",
        type = "toggle",
        set = function(info,val) MRadialSavedVariables["hideooc"] = val end,
        get = function(info) return MRadialSavedVariables["hideooc"] end,
        order = 3,
      }, 
      hideminimap = {
        name = "Hide MiniMap Icon",
        desc = "Enables / disables miniMapIcon in fav of the new addon container.",
        type = "toggle",
        set = function(info,val) MRadialSavedVariables["hideMiniMapIcon"] = val end,
        get = function(info) return MRadialSavedVariables["hideMiniMapIcon"] end,
        order = 4,
      }, 

      about={
        name = "About",
        type = "group",
        order=1,
        args={
          faqHdr = {
            name = "----ABOUT----",
            type = "header",
            order=1
          },
          fagDesc = {
            name = "Welcome to mRadial a little UI timer addon. \n \
Q: What is mRadial?\
This addon creates a little radial frame for you to assign spells to to track cooldowns / debuffs. These can be set to be clickable buttons as well if so desired.\
\nIt helps keep these in a nice tight circle around your charcter so you don't stand in fire mkay!\
For more info please visit the wiki from the curseForge addon here: \n \
https://github.com/jamesbdunlop/mRadial/wiki",
            type = "description",
            order = 2
          }
        }
      },
      
      iconOptions={
        name = "Radial Icons",
        type = "group",
        desc = "Use this to change the spell icons and various text timers.", 
        childGroups = "tab",
        order=2,
        args={
          header = {
            name = "Base Icon Options",
            desc = "",
            type = "header",
            order = 1,
          }, 
          desc = {
            name = "Use these options to affect the display of the 'watcher' icons.",
            type = "description",
            order = 2,
          },
          chkboxes = {
            name = "General",
            type = "group",
            inline = true,
            args = {
              autospread = {
                name = "Auto Spread",
                desc = "Enables / disables an auto spread around the radial frame.",
                type = "toggle",
                default = true,
                set = function(info,val)
                  MRadialSavedVariables["autoSpread"] = val
                  mRadial:UpdateUI(false)
                end,
                get = function(info) return MRadialSavedVariables["autoSpread"] end,
                order = 3,
              },
              asbuttons = {
                  name = "AsButtons",
                  desc = "Enables / disables the icons as buttons.",
                  type = "toggle",
                  set = function(info,val)
                    MRadialSavedVariables["asbuttons"] = val 
                  end,
                  get = function(info) return MRadialSavedVariables["asbuttons"] end,
                  order = 4,
                }
            }
          },
          
          DimensionOptions={
            name = "Dimensions",
            type = "group",
            childGroups = "tab",
            args={
              radiusMult = {
                name = "Radius Multiplyer",
                desc = "Use this to apply a global change to the radius size. Default is %100.",
                type = "range",
                min = .1,
                max = 2,
                step = .01,
                isPercent = true,
                default = 1,
                set = function(self, val)
                  MRadialSavedVariables["radiusMult"] = val
                  mRadial:UpdateUI(false)
                end,
                get = function(self) return MRadialSavedVariables["radiusMult"] end,
              },
              iconSize = {
                name = "Spell Icon Size",
                desc = "Use this change the spell icon sizes.",
                type = "range",
                min = 1,
                max = 200,
                step = .01,
                isPercent = false,
                default = 40,
                set = function(self, val)
                  MRadialSavedVariables["watcherFrameSize"] = val
                  mRadial:UpdateUI(false)
                end,
                get = function(self) return MRadialSavedVariables["watcherFrameSize"] end,
              },
              Radial01 = {
                name = "Primary",
                type = "group",
                args = {
                  radius = {
                    name = "Radius",
                    desc = "Use this change the size(radius) of the circle.",
                    type = "range",
                    order = 1,
                    min = 50,
                    max = 500,
                    step = .01,
                    isPercent = false,
                    default = 100,
                    set = function(self, val)
                      MRadialSavedVariables["radius"] = val
                      mRadial:UpdateUI(false)
                    end,
                    get = function(self) return MRadialSavedVariables["radius"] end,
                  },
                  spread = {
                    name = "Spread",
                    desc = "Use this change the spell icon spread around the circle.",
                    type = "range",
                    order = 2, 
                    min = -40,
                    max = 40,
                    step = .01,
                    isPercent = false,
                    default = 0,
                    set = function(self, val)
                      MRadialSavedVariables["watcherFrameSpread"] = val
                      mRadial:UpdateUI(false)
                    end,
                    get = function(self) return MRadialSavedVariables["watcherFrameSpread"] end,
                  },
                  offset = {
                    name = "Offset",
                    desc = "Use this offset the start location of the spell icons around the circle.",
                    type = "range",
                    order = 3, 
                    min = 0,
                    max = 3,
                    step = .01,
                    isPercent = false,
                    default = 0.7,
                    set = function(self, val)
                      MRadialSavedVariables["offset"] = val
                      mRadial:UpdateUI(false)
                    end,
                    get = function(self) return MRadialSavedVariables["offset"] end,
                  },
                  width = {
                    name = "Width Adjust",
                    desc = "Use this offset width of the circle. This will create an oval shape horizontally.",
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
                    get = function(self) return MRadialSavedVariables["widthDeform"] end,
                  },
                  height = {
                    name = "Height Adjust",
                    desc = "Use this offset width of the circle. This will create an oval shape vertically.",
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
                    get = function(self) return MRadialSavedVariables["heightDeform"] end,
                  },
                },
                order=1
              },
              Radial02 = {
                name = "Secondary",
                type = "group",
                args = {
                  radius = {
                    name = "Radius",
                    desc = "Use this change the size(radius) of the circle.",
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
                    get = function(self) return MRadialSavedVariables["radius2"] end,
                  },
                  spread = {
                    name = "Spread",
                    desc = "Use this change the spell icon spread around the circle.",
                    type = "range",
                    order = 2, 
                    min = -40,
                    max = 40,
                    step = .01,
                    isPercent = false,
                    default = 0,
                    set = function(self, val)
                      MRadialSavedVariables["watcherFrameSpread2"] = val
                      mRadial:UpdateUI(false)
                    end,
                    get = function(self) return MRadialSavedVariables["watcherFrameSpread2"] end,
                  },
                  offset = {
                    name = "Offset",
                    desc = "Use this offset the start location of the spell icons around the circle.",
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
                    get = function(self) return MRadialSavedVariables["offset2"] end,
                  },
                  width = {
                    name = "Width Adjust",
                    desc = "Use this offset width of the circle. This will create an oval shape horizontally.",
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
                    get = function(self) return MRadialSavedVariables["widthDeform2"] end,
                  },
                  height = {
                    name = "Height Adjust",
                    desc = "Use this offset width of the circle. This will create an oval shape vertically.",
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
                    get = function(self) return MRadialSavedVariables["heightDeform2"] end,
                  },
                },
                order=2
              },
            },
            order=5
          },
        
          fontOptions={
            name = "Text",
            type = "group",
            args={
              fontSelection = {
                name = "Font:",
                type = "select",
                style = "dropdown",
                order = 1, 
                values = MR_FONTS,
                set = function(info, groupIndex)
                    local selectedFont = MR_FONTS[groupIndex]
                    MRadialSavedVariables['Font'] = selectedFont
                    mRadial:UpdateUI(false)
                    mRadial:SetPetFramePosAndSize()
                    for k, v in pairs(info) do
                      print(k, v)
                    end
                  end,
                get = function(info)
                    local font = MRadialSavedVariables['Font'] or MR_DEFAULT_FONT
                    for idx, fontName in ipairs(MR_FONTS) do
                      if fontName == font then
                        return idx
                      end
                    end
                  end,
              },
              globalFontSize = {
                name = "Global Font %",
                desc = "This controls the overall font size for the UI. A setting of 50% will be 50% of the current icon size.",
                type = "range",
                order = 2,
                min = .1,
                max = 1,
                step = .01,
                isPercent = false,
                default = .5,
                set = function(self, val)
                  MRadialSavedVariables["FontPercentage"] = val
                  mRadial:GlobalFontPercentageChanged()
                end,
                get = function(self) return MRadialSavedVariables["FontPercentage"] end,
              },
              fontSliderGrp = {
                name = "Font Size Overrides",
                type = "group",
                inline = true,
                order = 2.5,
                args = {
                  countFontSize = {
                    name = "countFontSize",
                    desc = "",
                    type = "range",
                    order = 1,
                    min = 2,
                    max = 55,
                    step = 1,
                    isPercent = false,
                    default = 2,
                    set = function(self, val)
                      MRadialSavedVariables["countFontSize"] = val
                      mRadial:UpdateUI(false)
                    end,
                    get = function(self) return MRadialSavedVariables["countFontSize"] end,
                  },
                  readyFontSize = {
                    name = "readyFontSize",
                    desc = "",
                    type = "range",
                    order = 2,
                    min = 2,
                    max = 55,
                    step = 1,
                    isPercent = false,
                    default = 2,
                    set = function(self, val)
                      MRadialSavedVariables["readyFontSize"] = val
                      mRadial:UpdateUI(false)
                    end,
                    get = function(self) return MRadialSavedVariables["readyFontSize"] end,
                  },
                  coolDownFontSize = {
                    name = "coolDownFontSize",
                    desc = "",
                    type = "range",
                    order = 3,
                    min = 2,
                    max = 55,
                    step = 1,
                    isPercent = false,
                    default = 2,
                    set = function(self, val)
                      MRadialSavedVariables["coolDownFontSize"] = val
                      mRadial:UpdateUI(false)
                    end,
                    get = function(self) return MRadialSavedVariables["coolDownFontSize"] end,
                  },
                  timerFontSize = {
                    name = "timerFontSize",
                    desc = "",
                    type = "range",
                    order = 4,
                    min = 2,
                    max = 55,
                    step = 1,
                    isPercent = false,
                    default = 2,
                    set = function(self, val)
                      MRadialSavedVariables["timerFontSize"] = val
                      mRadial:UpdateUI(false)
                    end,
                    get = function(self) return MRadialSavedVariables["timerFontSize"] end,
                  },
                }
              },
              warning = {
                name = "--- Turn on Config Mode While Adjusting The Below Params ---",
                desc = "",
                type = "header",
                order = 3,
              },
              buffGrp = {
                name = "Position Buff",
                type = "group",
                inline = true,
                order = 4,
                args = {
                  UpDown = {
                    name = "Up/Down",
                    desc = "",
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
                    get = function(self) return MRadialSavedVariables["radialUdOffset"] end,
                  },
                  LeftRight = {
                    name = "Left/Right",
                    desc = "",
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
                    get = function(self) return MRadialSavedVariables["radialLROffset"] end,
                  },
                }
              },
              cooldownGrp = {
                name = "Position Cooldown",
                type = "group",
                inline = true,
                order = 4,
                args = {
                  UpDown = {
                    name = "Up/Down",
                    desc = "",
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
                    get = function(self) return MRadialSavedVariables["cdUdOffset"] end,
                  },
                  LeftRight = {
                    name = "Left/Right",
                    desc = "",
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
                    get = function(self) return MRadialSavedVariables["cdLROffset"] end,
                  },
                }
              },
              readyGrp = {
                name = "Position Ready",
                type = "group",
                inline = true,
                order = 4,
                args = {
                  UpDown = {
                    name = "Up/Down",
                    desc = "",
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
                    get = function(self) return MRadialSavedVariables["readyUDOffset"] end,
                  },
                  LeftRight = {
                    name = "Left/Right",
                    desc = "",
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
                    get = function(self) return MRadialSavedVariables["readyLROffset"] end,
                  },
                }
              },
              countGrp = {
                name = "Position Count",
                type = "group",
                inline = true,
                order = 4,
                args = {
                  UpDown = {
                    name = "Up/Down",
                    desc = "",
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
                    get = function(self) return MRadialSavedVariables["countUdOffset"] end,
                  },
                  LeftRight = {
                    name = "Left/Right",
                    desc = "",
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
                    get = function(self) return MRadialSavedVariables["countLROffset"] end,
                  },
                }
              }
            },
            order=6
          },
          } 
      },

      spellOptions={
        name = "Radial Spells",
        desc = "Use this to select the spells to watch in the primary and secondary radial frames.",
        type = "group",
        childGroups = "tab",
        layout = "Flow",
        args = {
          fagDesc = {
            name = "--Use this to select the spells to watch in the primary and secondary radial frames.--",
            type = "description",
            order = 1
          },
          hidePassive = {
            name = "Hide Passive Spells",
            type = "toggle",
            order = 2,
            defaultValue = true,
            set = function(info, val) 
              MRadialSavedVariables["HidePassiveSpells"] = val
              MROptionsTable.args.spellOptions.args.primarySpells.args = mRadial:BuildSpellSelectionPane("isActive", val)
              MROptionsTable.args.spellOptions.args.secondarySpells.args = mRadial:BuildSpellSelectionPane("isSecondaryActive", val)
            end,
            get = function(info) return MRadialSavedVariables["HidePassiveSpells"] end,
          },
          changePrimaryOrder = {
            name = "Primary Spell Order",
            type = "execute",
            func = function(info, value)
              mRadial:BuildPrimarySpellOrder(true)
            end,
          },
          changeSecondaryOrder = {
            name = "Secondary Spell Order",
            type = "execute",
            func = function(info, value)
              mRadial:BuildSecondarySpellOrder(true)
            end,
          },
          primarySpells = {
            name = "primarySpells",
            type = "group",
            order=3,
            layout = "Flow",
            args = {}
          },
          secondarySpells = {
            name = "secondarySpells",
            type = "group",
            order=4,
            args = {}
          }
        },
        order=3,
      },

      linkedSpellOptions={
        name = "LinkedSpells",
        type = "group",
        args={},
        order=4
      },

      warlockSpellOptions={
        name = "Warlock",
        type = "group",
        args={
          pet ={
            name = "Pet Frames",
            type = "group",
            inline = "true",
            order = 1,
            args = {
              hidePetFrames = {
                name = "Hide Pet Frames",
                desc = "Show/Hide the warlock pet frames.",
                type = "toggle",
                order = 1,
                defaultValue = false,
                set = function(info, val)
                  MRadialSavedVariables["hidePetFrame"] = val 
                  mRadial.TogglePetFrameVisibility(val)
                end,
                get = function(info) return MRadialSavedVariables["hidePetFrame"] end,
              },
              iconSize = {
                name = "Icon Size",
                desc = "Use this change the spell icon sizes.",
                type = "range",
                order = 2,
                min = 1,
                max = 200,
                isPercent = false,
                default = 40,
                set = function(self, val)
                  MRadialSavedVariables["PetFramesSize"] = val
                  mRadial:SetPetFramePosAndSize()
                end,
                get = function(self) return MRadialSavedVariables["PetFramesSize"] end,
              },
            }
          },
          shards ={
            name = "Shard Frames",
            type = "group",
            inline = "true",
            order = 2,
            args = {
              outOfShardsFrameSize = {
                name = "Out Of Shards Frame Size",
                desc = "Use this change the frame that shows the out of shards circle. Turn on Config mode for this!",
                type = "range",
                order = 3,
                min = 10,
                max = 500,
                step = .01,
                isPercent = false,
                default = 10,
                set = function(self, val)
                  MRadialSavedVariables["shardOutOfFrameSize"] = val
                  mRadial:setOOSShardFramesSize()
                end,
                get = function(self) return MRadialSavedVariables["shardOutOfFrameSize"] end,
              },
              shardFrameSize = {
                name = "Shards Frame Size",
                desc = "Use this change the frame that shows the custom shard tracker frame.",
                type = "range",
                order = 4,
                min = 10,
                max = 1000,
                step = 1,
                isPercent = false,
                default = 12,
                set = function(self, val)
                  MRadialSavedVariables["shardTrackerFrameSize"] = val
                  mRadial:setShardTrackerFramesSize()
                end,
                get = function(self) return MRadialSavedVariables["shardTrackerFrameSize"] end,
              },
              shardFrameTransparency = {
                name = "Shards Frame Transparency",
                desc = "Use this change alpha of the shard frame. Turn on Config mode for this.",
                type = "range",
                order = 5,
                min = 0,
                max = 1,
                step = .01,
                isPercent = true,
                default = 1,
                set = function(self, val)
                  MRadialSavedVariables["shardFrameTransparency"] = val
                  mRadial:createShardCountFrame()
                end,
                get = function(self) return MRadialSavedVariables["shardFrameTransparency"] end,
              },
            },
          },
        },
        order=4
      }
    }
}

------------------------------------------------------------------------------------------
-- MAIN PANE
function mRadial:OptionsPane()
  MR_configRegistry:RegisterOptionsTable(appName, MROptionsTable, true)
  -- Register options table
  local optionsPane = AceGUI:Create("Frame")
  optionsPane:SetLayout("Flow")
  optionsPane:SetTitle("---mRadial---")
  optionsPane:SetStatusText("Select options")
  optionsPane:SetCallback("OnClose", function(widget) AceGUI:Release(widget) end)
  MR_configDialog:SetDefaultSize(appName, 800, 600)
  MR_configDialog:Open(appName, optionsPane)

  local hidePassive = MRadialSavedVariables["HidePassiveSpells"] or true
  MROptionsTable.args.spellOptions.args.primarySpells.args = mRadial:BuildSpellSelectionPane("isActive", hidePassive)
  MROptionsTable.args.spellOptions.args.secondarySpells.args = mRadial:BuildSpellSelectionPane("isSecondaryActive", hidePassive)
  MROptionsTable.args.linkedSpellOptions.args = mRadial:linkedSpellPane()
  
  MRADIALOptionsPane = optionsPane
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
        local warning = mRadial:PopUpDialog("WARNING!", "This will reset all selected spells! Continue?", 400, 120)
        warning:Show()
        warning.acceptButton:SetCallback("OnClick", function()  
            print("TO DO REMOVE ALL ACTIVE PRIMARY AND SECONDARY WATCHERS HERE")
            warning:Hide()
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
          descp = desc,
          defaultValue = defaultValue,
          type = "toggle",
          order = idx+1,
          image = iconPath,
          set = function(info, value)
            -- Store the savedVars
            MRadialSavedVariables[isactiveSpellName] = value
            mRadial:UpdateUI(true)
            -- Sync the checkboxes so we don't have them sharing selected spells.
            if isActiveSavedVarStr == "isActive" then
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
          local parentWdg, spellName, desc, isactiveSpellName, defaultValue, updateUI, descAsTT, spellID = unpack(passiveSpellData)
          local iconPath
          if spellID ~= nil then
              if IsPassiveSpell(spellID) then
                  desc = "PASSIVE ABILITY"
              end
              
              _, _, iconPath, _, _, _, _, _ = GetSpellInfo(spellID)
          end
          local spellsCbxs = {
              name = spellName .. "-(PASSIVE)",
              descp = desc,
              defaultValue = defaultValue,
              type = "toggle",
              order = idx+activeIDX,
              image = iconPath,
              set = function(info, value) 
                  MRadialSavedVariables[isactiveSpellName] = value
                  mRadial:BuildSpellSelectionPane(isActiveSavedVarStr, hidePassive)
                  mRadial:BuildPrimarySpellOrder(false)
                  mRadial:BuildSecondarySpellOrder(false)
                  mRadial:UpdateUI(true)
              end,
              get = function(info) 
                return MRadialSavedVariables[isactive]
              end,
          }
          table.insert(widgetArgs, spellsCbxs)
      end
  end

  return widgetArgs
end

-- SPELL ORDER
function createOrderParentFrame()
  local parentFrame = AceGUI:Create("Frame")
        parentFrame:SetLayout("List")
        parentFrame:SetWidth(400)
        parentFrame:SetHeight(300)

        local info = AceGUI:Create("Label") 
        info:SetText("This sets the order along the radial frame. To use change the order, right click a spell to pick it up, and drop it onto the spell you want to swap it with.")
        info:SetWidth(350)

        local grp = AceGUI:Create("InlineGroup")
        grp:SetLayout("Flow")
        parentFrame.order = grp

        parentFrame:AddChild(info)
        parentFrame:AddChild(grp)
        parentFrame:Hide()
  return parentFrame
end

function mRadial:BuildPrimarySpellOrder(showUI)
  if MRPrimarySpellOrderFrame == nil then
    MRPrimarySpellOrderFrame = createOrderParentFrame()
  end
  if showUI then
    MRPrimarySpellOrderFrame:Show()
  end
  mRadial:BuildOrderLayout(MRPrimarySpellOrderFrame.order, MRadialSavedVariables["primaryWatcherOrder"], ACTIVEPRIMARYWATCHERS, mRadial.BuildPrimarySpellOrder)
  
end

function mRadial:BuildSecondarySpellOrder(showUI)
  if MRSecondarySpellOrderFrame == nil then
    MRSecondarySpellOrderFrame = createOrderParentFrame()
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
            mRadial:UpdateUI(true)
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
        type = "execute",
        order = 1,
        dialogControl = "ActionSlot",
        image = srcIcon,
        func = function() print("burp") end,
        acceptDrop = function(info)
            print("Drop accepted")
            local self 
            for k, v in pairs(info) do 
              if k == "obj" then
                self = v
              end
            end
            local _, data1, data2 = GetCursorInfo()
            local link, spellID = GetSpellLink(data1, data2)
            local droppedSpellName, _, icon, _, _, _, _, _ = GetSpellInfo(spellID)
            self.icon:SetTexture(icon)
            self.icon:Show()
            ClearCursor()
            
            local current = MRadialSavedVariables["LINKEDSPELLS"]
            local updated = false
            for srcSpellName, data in pairs(current) do
              if srcSpellName == spellName then
                data[1] = droppedSpellName
                updated = true
              end
            end
            if not updated then
              -- we have a new entry being constructed.
              local entry = {}
              entry[1] = ""
              entry[2] = ""
              current[droppedSpellName] = entry
            end
          end,
      },
      linkedSpellName ={
        name = "lnkedSpell",
        order = 2,
        type = "input",
        defaultValue = destName,
        get = function()
            local current = MRadialSavedVariables["LINKEDSPELLS"]
            for srcSpellName, data in pairs(current) do
              if srcSpellName == spellName then
                local destSpellName = data[1]
                return destSpellName
              end
            end
          end,
        set = function(info, text) 
          local current = MRadialSavedVariables["LINKEDSPELLS"]
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
                    if text == "Demonic Power" then
                      spellID = "265273"    
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
          local current = MRadialSavedVariables["LINKEDSPELLS"]
          for srcSpellName, data in pairs(current) do
            if srcSpellName == spellName then
              local destSpellID = data[2]
              return tostring(destSpellID)
            end
          end
        end,
      },
      removeLinkedSpell = {
        name = "-",
        type = "execute",
        order = 4,
        width = "half",
        func = function(info) 
          local current = MRadialSavedVariables["LINKEDSPELLS"]
          local cleaned = {}
          for srcSpellName, spellID in pairs(current) do
              if spellName ~= srcSpellName then
                cleaned[srcSpellName] = spellID
              end
          end
          MRadialSavedVariables["LINKEDSPELLS"] = cleaned
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
  local linkedGroup = {
    name = "Linked Spell (Buffs): ",
    type = "group",
    inline = true,
    layout = "List",
    args = {
        info = {
          name = "Linked spells are a way for you to link a buff to a core spell. \n eg: Linking Hand of Guldan to Demonic Core, will start a timer next to Hand of Guildan when DC procs to allow for timing of casts etc.",
          type = "description",
          order = 1,
        },
        add = {
          name = "Add",
          type = "execute",
          order = 2,
          func = function()
            local emptyEntry = createLinkedInputTable("", "", "", "", "", "") 
            table.insert(linkedStuff, emptyEntry) 
            MROptionsTable.args.linkedSpellOptions.args = widgetArgs
          end,
        },
        linkedGroup ={
          name = "Linked Spells",
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
          _, _, srcIcon, _, _, srcSpellID, _, _ = GetSpellInfo(spellID)
          local destSpellName = linkedSpell[1]
          local destSpellID = linkedSpell[2]
          if spellName then
            local entry = createLinkedInputTable(spellName, srcIcon, srcSpellID, srcLink, destSpellName, destSpellID)
            table.insert(linkedStuff, entry)
          end
      end
  end
  linkedGroup.args.linkedGroup.args = linkedStuff
  table.insert(widgetArgs, linkedGroup)
  return widgetArgs
end