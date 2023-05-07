-- local MR_config = LibStub("AceConfig-3.0")
-- local MR_dialog = LibStub("AceConfigDialog-3.0")
local AceGUI = LibStub("AceGUI-3.0")

local function CreateSlider(parent, name, minVal, maxVal, step, variableName, defaultValue, toexec, tootip)
    local opt_slider = AceGUI:Create("Slider")
    opt_slider:SetSliderValues(minVal, maxVal, step)
    opt_slider:SetLabel(name)
    -- print("Creating slider: %s", name)
    
    local function setValue(table, cbName, value)
        -- print("Setting option %s to value %d", variableName, value)
        MRadialSavedVariables[variableName] = value
        if toexec ~= nil then
            toexec(value)
        end
    end

    local function getValue(info)
        return opt_slider:GetValue()
    end
    
    local currentValue = MRadialSavedVariables[variableName]
    -- print("currentValue: %d", currentValue)
    if currentValue == nil then
        if defaultValue == nil then
            currentValue = 0
        else
            currentValue = defaultValue
        end
    end
    -- print("currentValue: %d", currentValue)
    opt_slider.get = getValue
    opt_slider:SetValue(currentValue)
    opt_slider:SetCallback("OnValueChanged", setValue)
    
    if tootip ~= nil then
        opt_slider:SetCallback("OnEnter", function(widget, event)
            GameTooltip:SetOwner(widget.frame, "ANCHOR_CURSOR")
            GameTooltip:SetText(mRadial:WrapText(tootip))
            GameTooltip:SetSize(80, 50)
            GameTooltip:SetWidth(80)
            GameTooltip:Show()
        end)
        opt_slider:SetCallback("OnLeave", function(self)
            GameTooltip:Hide()
        end)
    end

    parent:AddChild(opt_slider)
    return opt_slider
end

function mRadial:CreateAbilityCheckBox(parent, name, descrip, variableName, defaultValue, toexec, descAsTT, spellID, toggleExec, toggleVar1)
    local opt_cbox = AceGUI:Create("CheckBox")
    opt_cbox:SetLabel(name)
    opt_cbox:SetType("radio")
    opt_cbox:SetWidth(140)
    
    local function setValue(table, cbName, value)
        MRadialSavedVariables[variableName] = value
        if toexec ~= nil then
            -- for some reason this value is not being passed along to the func!!!???
            toexec(toexec, value)
        end
    end

    local function getValue(info)
        return opt_cbox:GetValue()
    end

    local dvalue = MRadialSavedVariables[variableName]
    if dvalue == nil then
        if defaultValue == nil then
            dvalue = false
        else
            dvalue = defaultValue
        end
    end
    opt_cbox.get = getValue
    
    -- set the state to the stored value or default
    opt_cbox:SetValue(dvalue)
    -- opt_cbox:SetCallback("OnValueChanged", setValue)
    opt_cbox:SetCallback("OnValueChanged", function(table, event, value)
        setValue(table, event, value)
        if toggleExec ~= nil and toggleVar1 ~= nil then
            toggleExec(toggleExec, toggleVar1)
        end
        mRadial:UpdateUI(true)
        end)

    if spellID ~= nil then
        if IsPassiveSpell(spellID) then
            -- opt_cbox:SetDisabled(true)
            opt_cbox:SetDescription("PASSIVE ABILITY")
        end
        
        local _, _, iconPath, _, _, _, _, _ = GetSpellInfo(spellID)
        opt_cbox:SetImage(iconPath)
    end

    if descAsTT then
        opt_cbox:SetCallback("OnEnter", function(widget, event)
            GameTooltip:SetOwner(widget.frame, "ANCHOR_CURSOR")
            GameTooltip:SetText(name ..":\n" .. mRadial:WrapText(descrip))
            GameTooltip:SetSize(80, 50)
            GameTooltip:SetWidth(80)
            GameTooltip:Show()
        end)
        opt_cbox:SetCallback("OnLeave", function(self)
            GameTooltip:Hide()
        end)
    else
        opt_cbox:SetDescription(mRadial:WrapText(descrip))
    end
    parent:AddChild(opt_cbox)
    return opt_cbox
end

function mRadial:BuildPrimaryOrderLayout(parent)
    -- First update for active spells for any checkboxes that may have been ticked
    mRadial:UpdateActivePrimarySpells()
    mRadial:BuildOrderLayout(parent, MRadialSavedVariables["primaryWatcherOrder"], ACTIVEPRIMARYWATCHERS, mRadial.BuildPrimaryOrderLayout)
end

function mRadial:BuildSecondaryOrderLayout(parent)
    -- First update for active spells for any checkboxes that may have been ticked
    mRadial:UpdateActiveSecondarySpells()
    mRadial:BuildOrderLayout(parent, MRadialSavedVariables["secondaryWatcherOrder"], ACTIVESECONDARYWATCHERS, mRadial.BuildSecondaryOrderLayout)
end

-- BUILD PANE STUFF
local function fixScrollBoxHeight(scrollFrame, generalGroup)
    local height = MRADIALOptionsPane.frame:GetHeight()
    local newHeight = height-generalGroup.frame:GetHeight()-150
    scrollFrame:SetHeight(newHeight)
end

local function PopulateDropdown(scrollFrame, idx)   
    scrollFrame:ReleaseChildren()
    if idx == 1 then -- Radial options
        -- Radial shit
        local radialGroup = AceGUI:Create("InlineGroup")
        radialGroup:SetTitle("Primary Radial Frame / Icons: ")
        radialGroup:SetFullWidth(true)
        radialGroup:SetLayout("Flow")
        --parent, name, minVal, maxVal, step, variableName, defaultValue, toexec)
        CreateSlider(radialGroup, "Radius: ", 50, 500, 1, "radius", 100,  mRadial.UpdateUI)
        CreateSlider(radialGroup, "Offset: ", 0, 3, .001, "offset", .70, mRadial.UpdateUI)
        CreateSlider(radialGroup, "Icon Size: ", 1, 200, .1, "watcherFrameSize", 40, mRadial.UpdateUI)
        CreateSlider(radialGroup, "Icon Spread: ", -40, 40, .01, "watcherFrameSpread", 0, mRadial.UpdateUI)
        CreateSlider(radialGroup, "(de)BuffTimerScale: ", 0, 10, .01, "buffTimerScale", 0, mRadial.UpdateUI)

        CreateSlider(radialGroup, "Width Oval (default 1): ", .1, 10, .01, "widthDeform", 1, mRadial.UpdateUI)
        CreateSlider(radialGroup, "Height Oval (default 1): ", .1, 10, .01, "heightDeform", 1, mRadial.UpdateUI)
        scrollFrame:AddChild(radialGroup)

        local secRadialGroup = AceGUI:Create("InlineGroup")
        secRadialGroup:SetTitle("Secondary Radial Frame / Icons: ")
        secRadialGroup:SetFullWidth(true)
        secRadialGroup:SetLayout("Flow")
        --parent, name, minVal, maxVal, step, variableName, defaultValue, toexec)
        CreateSlider(secRadialGroup, "SecRadius: ", 50, 500, 1, "radius2", 100,  mRadial.UpdateUI)
        CreateSlider(secRadialGroup, "SecOffset: ", 0, 3, .001, "offset2", .70, mRadial.UpdateUI)
        -- CreateSlider(secRadialGroup, "SecIcon Size: ", 1, 200, .1, "watcherFrameSize2", 40, mRadial.UpdateUI)
        CreateSlider(secRadialGroup, "SecIcon Spread: ", -40, 40, .01, "watcherFrameSpread2", 0, mRadial.UpdateUI)
        CreateSlider(secRadialGroup, "SecWidth Oval (default 1): ", .1, 10, .01, "widthDeform2", 1, mRadial.UpdateUI)
        CreateSlider(secRadialGroup, "SecHeight Oval (default 1): ", .1, 10, .01, "heightDeform2", 1, mRadial.UpdateUI)
        scrollFrame:AddChild(secRadialGroup)

    elseif idx == 2 then -- Fonts
        local testFontFrame = AceGUI:Create("Label")
        testFontFrame:SetText("AaBbCcDdEeFfGgHh--~~!!,=*12345")
        local fontList = MR_FONTS
        local fontDpDwn = AceGUI:Create("DropdownGroup")
        fontDpDwn:SetTitle("Font:")
        fontDpDwn:SetGroupList(fontList)
        fontDpDwn:SetLayout("List")
        fontDpDwn:SetFullWidth(true)
        fontDpDwn:SetCallback("OnGroupSelected", function(widget, event, groupIndex, groupName)
            local selectedFont = fontList[groupIndex]
            MRadialSavedVariables['Font'] = selectedFont
            local cfontName = MRadialSavedVariables['Font'] or MR_DEFAULT_FONT
            local customFontPath = "Interface\\Addons\\mRadial\\fonts\\" .. cfontName
            testFontFrame:SetFont(customFontPath, 25, "OUTLINE, MONOCHROME")
            mRadial:UpdateUI(false)
            mRadial:SetPetFramePosAndSize()
        end)
        local currentFont = MRadialSavedVariables["Font"] or MR_DEFAULT_FONT
        for x, fontName in ipairs(MR_FONTS) do
            if fontName == currentFont then
                fontDpDwn:SetGroup(x)
            end
        end
        fontDpDwn:AddChild(testFontFrame)
        local glbFntTT = "This controls the overall font size for the UI. A setting of 50% will be 50% of the current icon size."
        CreateSlider(fontDpDwn, "Global Font %", .1, 1, .01, "FontPercentage", .5, mRadial.GlobalFontPercentageChanged, glbFntTT)
        scrollFrame:AddChild(fontDpDwn)
        
        local timerGroup = AceGUI:Create("InlineGroup")
        timerGroup:SetTitle("Timer Text Positions: (!!SET MOVEABLE ON WHILE ADJUSTING!!)")
        timerGroup:SetFullWidth(true)
        timerGroup:SetLayout("Flow")
        CreateSlider(timerGroup, "Buff Up/Down:",  -50, 50, 1, "radialUdOffset", 0, mRadial.UpdateUI)
        CreateSlider(timerGroup, "Buff Left/Right: ", -50, 50, 1, "radialLROffset", -2, mRadial.UpdateUI)

        local cdGroup = AceGUI:Create("SimpleGroup")
        cdGroup:SetFullWidth(true)
        cdGroup:SetLayout("Flow")

        CreateSlider(cdGroup, "Cooldown Up/Down: ", -50, 50, 1, "cdUdOffset", 0, mRadial.UpdateUI)
        CreateSlider(cdGroup, "Cooldown Left/Right: ", -50, 50, 1, "cdLROffset", 0, mRadial.UpdateUI)

        local rdyGroup = AceGUI:Create("SimpleGroup")
        rdyGroup:SetFullWidth(true)
        rdyGroup:SetLayout("Flow")
        CreateSlider(rdyGroup, "Ready Up/Down: ", -50, 50, 1, "readyUDOffset", -18, mRadial.UpdateUI)
        CreateSlider(rdyGroup, "Ready Left/Right: ", -50, 50, 1, "readyLROffset", 0, mRadial.UpdateUI)

        local countGroup = AceGUI:Create("SimpleGroup")
        countGroup:SetFullWidth(true)
        countGroup:SetLayout("Flow")
        CreateSlider(countGroup, "Count Up/Down: ", -50, 50, 1, "countUdOffset", 16, mRadial.UpdateUI)
        CreateSlider(countGroup, "Count Left/Right: ", -50, 50, 1, "countLROffset", -16, mRadial.UpdateUI)
        
        -- Font shit
        local fontGroup = AceGUI:Create("InlineGroup")
        fontGroup:SetTitle("Adjust Font Size:  (note Fonts are 50% of the iconFrame size by default.")
        fontGroup:SetFullWidth(true)
        fontGroup:SetLayout("List")
        CreateSlider(fontGroup, "\"Count\":", 2, 55, 1, "countFontSize", 2, mRadial.UpdateUI)
        CreateSlider(fontGroup, "\"Ready\":", 2, 55, 1, "readyFontSize", 2, mRadial.UpdateUI)
        CreateSlider(fontGroup, "\"CoolDown\":", 2, 55, 1, "coolDownFontSize", 2, mRadial.UpdateUI)
        CreateSlider(fontGroup, "\"Timer\":", 2, 55, 1, "timerFontSize", 2, mRadial.UpdateUI)
        scrollFrame:AddChild(timerGroup)
        timerGroup:AddChild(cdGroup)
        timerGroup:AddChild(rdyGroup)
        timerGroup:AddChild(countGroup)
        scrollFrame:AddChild(fontGroup)
    elseif idx == 3 then -- Primary spell order and picker
        local spellOrderFrame = mRadial:BuildRadialOptionsPane("Primary:", "isActive", mRadial.BuildPrimaryOrderLayout, scrollFrame)
        mRadial:BuildPrimaryOrderLayout(spellOrderFrame)
        scrollFrame:LayoutFinished()
        scrollFrame:FixScroll()
    elseif idx == 4 then -- Secondary spell order and picker
        local spellOrderFrame = mRadial:BuildRadialOptionsPane("Secondary:", "isSecondaryActive", mRadial.BuildSecondaryOrderLayout, scrollFrame)
        mRadial:BuildSecondaryOrderLayout(spellOrderFrame)
        scrollFrame:LayoutFinished()
        scrollFrame:FixScroll()
    elseif idx == 5 then -- Linked spells
        mRadial:linkedSpellPane(scrollFrame)
    end
end

MRADIALOptionsPane = nil
function mRadial:OptionsPane()
    if MRADIALOptionsPane == nil then
        MRADIALOptionsPane = AceGUI:Create("Window")
    end
    MRADIALOptionsPane:SetWidth(850)
    MRADIALOptionsPane:SetHeight(650)
    MRADIALOptionsPane:SetPoint("CENTER", UIParent, "CENTER", -200, 0)
    MRADIALOptionsPane:SetTitle("mRadial - Options : " .. mRadial:GetSpecName() .. " " ..  UnitClass("player")) 
    MRADIALOptionsPane:SetLayout("Fill")
    MRADIALOptionsPane:SetCallback("OnClose", function(widget) AceGUI:Release(widget) mRadial:SetUIMovable(false) MRADIALOptionsPane = nil end)

    local base = AceGUI:Create("SimpleGroup")
    MRADIALOptionsPane:AddChild(base)

    local scrollcontainer = AceGUI:Create("SimpleGroup") -- "InlineGroup" is also good
    scrollcontainer:SetLayout("Flow")
    scrollcontainer:SetFullWidth(true)
    local generalGroup = AceGUI:Create("InlineGroup")

    local scrollFrame = AceGUI:Create("ScrollFrame")
    scrollFrame:SetLayout("Flow")
    scrollFrame:SetFullWidth(true)
    scrollFrame:SetHeight(450)
    scrollFrame.content:SetScript("OnSizeChanged", function() 
        fixScrollBoxHeight(scrollFrame, generalGroup)
        scrollFrame:FixScroll()
    end)
    scrollcontainer:AddChild(scrollFrame)
        
    -- General shit
    generalGroup:SetTitle("General: ")
    generalGroup:SetFullWidth(true)
    generalGroup:SetLayout("Flow")
    local descrip = "Allow UI frames to be shift+click draggable."
    mRadial:CreateAbilityCheckBox(generalGroup, "Movable", descrip, "moveable", false, mRadial.SetUIMovable, true, nil)
    mRadial:CreateAbilityCheckBox(generalGroup, "AsButtons", "Allow click to cast from radial buttons. \n Toggling this will require a /reloadUI", "asbuttons", false, mRadial.UpdateUI, true, nil)
    mRadial:CreateAbilityCheckBox(generalGroup, "Hide Out Of Combat", "Hide UI while out of combat.", "hideooc", false, mRadial.UpdateUI, true, nil)
    mRadial:CreateAbilityCheckBox(generalGroup, "Hide Pet Frames", "Hide all pet frames from the UI.", "hidePetFrame", false, mRadial.TogglePetFrameVisibility, true, nil)
    CreateSlider(generalGroup, "Radius Multiplyer", .1, 10, .1, "radiusMult", 1, mRadial.UpdateUI)
    
    base:AddChild(generalGroup)
    
    local wlckGroup = AceGUI:Create("SimpleGroup")
    wlckGroup:SetFullWidth(true)
    wlckGroup:SetLayout("Flow")
    mRadial:CreateAbilityCheckBox(wlckGroup, "Hide Wrlk Shard Frames", "This will hide the custom warlock shardCounter frames. NOTE: this will hide the OutOfShards frame too.\nRequires a /reload", "hideShardFrame", false, mRadial.UpdateUI, true, nil)
    mRadial:CreateAbilityCheckBox(wlckGroup, "Hide Wrlk Out Of Shards Frame:", "Hides the red out of shards frame for warlocks.", "hideOOShardFrame", false, mRadial.UpdateUI, true, nil)
    local wlckSliderGroup = AceGUI:Create("SimpleGroup")
    wlckSliderGroup:SetFullWidth(true)
    wlckSliderGroup:SetLayout("Flow")
    CreateSlider(wlckSliderGroup, "Wrlk Shards Frame Size: ", 10, 1000, 1, "shardTrackerFrameSize", 12, mRadial.setShardTrackerFramesSize)
    CreateSlider(wlckSliderGroup, "Shard Frm Transp", 0, 1, .01, "shardFrameTransparency", 1, mRadial.shardtrack)
    CreateSlider(wlckSliderGroup, "Wrlk Out Of Shards Frame Size: ", 10, 1000, 1, "shardOutOfFrameSize", 12, mRadial.setOOSShardFramesSize)
    CreateSlider(wlckSliderGroup, "Pet Icon Size: ", 10, 150, 1, "PetFramesSize", 12, mRadial.SetPetFramePosAndSize)
    generalGroup:AddChild(wlckGroup)
    generalGroup:AddChild(wlckSliderGroup)

    local optDpDwn = AceGUI:Create("DropdownGroup")
    optDpDwn:SetTitle("Options:")
    optDpDwn:SetGroupList({"Radial:Icons", "Radial:Fonts", "Radial:PrimarySpells", "Radial:SecondarySpells", "LinkedSpells"})
    optDpDwn:SetLayout("Flow")
    optDpDwn:SetFullWidth(true)
    optDpDwn:AddChild(scrollcontainer)
    optDpDwn:SetCallback("OnGroupSelected", function(widget, event, groupIndex, groupName)
        PopulateDropdown(scrollFrame, groupIndex)
    end)
    optDpDwn:SetGroup(3)
    base:AddChild(optDpDwn)
end

-- Action button for dnd for linked spells..
local newlyLinked = {}
local currentLinked

local function createLinkedInput(asNew, parent, srcName, srcIcon, srcSpellID, srcLink, destName, destSpellID, scrollFrame)
    local function acceptDrop(this)
        local self = this.obj
		local _, data1, data2 = GetCursorInfo()
        local link, spellID = GetSpellLink(data1, data2)
        local spellName, _, icon, _, _, srcSpellID, _, _ = GetSpellInfo(spellID)
        self:SetUserData("hyperlink", link)
        self:SetUserData("srcSpellID", srcSpellID)
        self:SetUserData("baseSpellName", spellName)

        self.icon:SetTexture(icon)
        self.icon:Show()
        ClearCursor()
    end

    local function removeItem(baseSpellIcon)
        local baseSpellName = baseSpellIcon:GetUserData("baseSpellName")
        if newlyLinked[baseSpellName] ~= nil then
            newlyLinked[baseSpellName] = nil
        end
        if currentLinked[baseSpellName] ~= nil then
            currentLinked[baseSpellName] = nil
        end
        -- REMOVE FRAMES
        PopulateDropdown(scrollFrame, 5)
    end

    --- START LAYOUT
    local grp = AceGUI:Create("SimpleGroup")
    grp:SetFullWidth(true)
    grp:SetFullHeight(true)
    grp:SetLayout("Flow")

    local baseSpellIcon = AceGUI:Create("ActionSlot")
          baseSpellIcon.button:SetScript('OnReceiveDrag', acceptDrop)
          baseSpellIcon.icon:SetTexture(srcIcon)
          baseSpellIcon.icon:Show()
          if srcLink ~= nil then
            baseSpellIcon:SetUserData("hyperlink", srcLink)
          end
          
          if srcSpellID ~= nil then
            baseSpellIcon:SetUserData("srcSpellID", srcSpellID)
          end
          if srcName ~= nil then
            baseSpellIcon:SetUserData("baseSpellName", srcName)
          end

          baseSpellIcon:SetCallback("OnEnter", function(widget)
            local hLink = widget:GetUserData("hyperlink")
            if hLink ~= nil then
                GameTooltip:SetOwner(widget.frame, "ANCHOR_BOTTOMRIGHT")
                GameTooltip:SetHyperlink(hLink) 
                GameTooltip:SetSize(80, 50) 
                GameTooltip:SetWidth(80) GameTooltip:Show() 
            end
          end)
          baseSpellIcon:SetCallback("OnLeave", function() 
            GameTooltip:SetOwner(UIParent, "ANCHOR_BOTTOMRIGHT")
            GameTooltip:SetText("")
            GameTooltip:SetSize(80, 50) 
            GameTooltip:SetWidth(80) 
            GameTooltip:Show()
          end)

    local linkedSpellID = AceGUI:Create("EditBox")
          linkedSpellID:SetText(tostring(destSpellID))
          linkedSpellID:SetWidth(100)
          linkedSpellID:SetHeight(25)
          linkedSpellID:SetDisabled(true)

    local linkedSpellInput = AceGUI:Create("EditBox")
          linkedSpellInput:SetText(destName)
          linkedSpellInput:SetWidth(225)
          linkedSpellInput:SetHeight(25)
          linkedSpellInput:SetCallback("OnTextChanged", function(widget, event, text)
            _, _, _, _, _, _, spellID, _ = GetSpellInfo(text)
            local spellNumber = spellID
            
            if spellNumber == nil then
                local found = false
                local activeTalentTreeSpells = mRadial:GetAllActiveTalentTreeSpells()
                -- lower level classes might not have an active talent tree.
                if activeTalentTreeSpells ~= nil then
                    for _, spellData in ipairs(mRadial:GetAllActiveTalentTreeSpells()) do
                        -- add a bool flag for each into the saved vars, so we can check against this in the radial menu!
                        local spellName = spellData[1]
                        local spellID = spellData[2]
                        if text == spellName then
                            spellNumber = spellID
                            found = true
                        end
                    end
                end
                if not found then
                    spellNumber = ""
                end
            end
            linkedSpellID:SetText(tostring(spellNumber))
            table.insert(newlyLinked, {baseSpellIcon, linkedSpellInput, linkedSpellID})
        end)

    local removeButton = AceGUI:Create("Button")
          removeButton:SetText("-")
          removeButton:SetWidth(15)
          removeButton:SetCallback("OnClick", function() removeItem(baseSpellIcon) end)

    grp:AddChild(baseSpellIcon)
    grp:AddChild(linkedSpellInput)
    grp:AddChild(linkedSpellID)
    grp:AddChild(removeButton)
    parent:AddChild(grp)
    
    -- If we have a valid entry, we go ahead and add it to the table now.
    if asNew then
        table.insert(newlyLinked, {baseSpellIcon, linkedSpellInput, linkedSpellID})
    end
end

function mRadial:linkedSpellPane(parent)
    local function updateLinked(scrollFrame)
        if newlyLinked ~= nil then
            for _, linkedWidgets in pairs(newlyLinked) do
                local baseSpellname = linkedWidgets[1]:GetUserData("baseSpellName")
                local destSpellName = linkedWidgets[2]:GetText()
                local destSpellID = tonumber(linkedWidgets[3]:GetText())
                if destSpellID == 0 then
                    _, _, _, _, _, _, spellID, _ = GetSpellInfo(text)
                    if spellID ~= nil then
                        destSpellID = spellID
                    end
                end
                currentLinked[baseSpellname] = {destSpellName, destSpellID}
            end
        end
        MRadialSavedVariables["LINKEDSPELLS"] = currentLinked
        newlyLinked = {}
        PopulateDropdown(scrollFrame, 5)
    end

    local linkedGroup = AceGUI:Create("InlineGroup")
    linkedGroup:SetTitle("Linked Spell (Buffs): ")
    linkedGroup:SetFullWidth(true)
    linkedGroup:SetLayout("List")

    local updateButton = AceGUI:Create("Button")
          updateButton:SetText("Update SavedVars")
          updateButton:SetWidth(145)
          updateButton:SetCallback("OnClick", function() 
            updateLinked(parent) 
        end)

    local addButton = AceGUI:Create("Button")
          addButton:SetText("Add")
          addButton:SetWidth(145)
          addButton:SetCallback("OnClick", function() 
                createLinkedInput(true, linkedGroup, nil, nil, nil, nil, nil, nil, parent) 
            end)
    linkedGroup:AddChild(addButton)
    linkedGroup:AddChild(updateButton)

    -- All from saved vars!
    local firstTime = false
    if MRadialSavedVariables["LINKEDSPELLS"] == nil then
        -- LINKEDSPELLS[ATTACHTO_SPELLNAME] = {PROC_SPELLNAME, 571321}
        firstTime = true
    end
    currentLinked = MRadialSavedVariables["LINKEDSPELLS"] or LINKEDSPELLS

    for spellName, linkedSpell in pairs(currentLinked) do
        local link, spellID = GetSpellLink(spellName)
        if link ~= nil then
            _, _, srcIcon, _, _, srcSpellID, _, _ = GetSpellInfo(spellID)
            local destSpellName = linkedSpell[1]
            local destSpellID = linkedSpell[2]
            if spellName then
                createLinkedInput(firstTime, linkedGroup, spellName, srcIcon, srcSpellID, link, destSpellName, destSpellID, parent)
            end
        end
    end
    if linkedGroup ~= nil then
        parent:AddChild(linkedGroup)
    end
end
