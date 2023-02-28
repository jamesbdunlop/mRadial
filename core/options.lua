local mw_config = LibStub("AceConfig-3.0")
local mw_dialog = LibStub("AceConfigDialog-3.0")


local function createSlider(parent, name, minVal, maxVal, step, variableName, defaultValue, toexec)
    local AceGUI = LibStub("AceGUI-3.0")
    local opt_slider = AceGUI:Create("Slider")
    opt_slider:SetSliderValues(minVal, maxVal, step)
    opt_slider:SetLabel(name)
    
    local function setValue(table, cbName, value)
        MWarlockSavedVariables[variableName] = value
        if toexec ~= nil then
            toexec()
        end
    end

    local function getValue(info)
        local value = MWarlockSavedVariables[variableName] or defaultValue
        return value
    end
    
    opt_slider:SetValue(getValue())
    opt_slider:SetCallback("OnValueChanged", setValue)
    opt_slider.get = getValue
    
    parent:AddChild(opt_slider)
    return opt_slider
end

local function createCheckBox(parent, name, descrip, variableName, defaultValue, toexec, descAsTT)
    local AceGUI = LibStub("AceGUI-3.0")
    local opt_cbox = AceGUI:Create("CheckBox")
    opt_cbox:SetLabel(name)
    
    
    local function setValue(table, cbName, value)
        MWarlockSavedVariables[variableName] = value
        if toexec ~= nil then
            toexec(value)
        end
    end

    local function getValue(info)
        local value = MWarlockSavedVariables[variableName]
        return value
    end
    
    opt_cbox:SetValue(getValue())
    opt_cbox:SetCallback("OnValueChanged", setValue)
    opt_cbox.get = getValue
    
    if descAsTT then
        opt_cbox:SetCallback("OnEnter", function(widget, event)
            GameTooltip:SetOwner(widget.frame, "ANCHOR_BOTTOMRIGHT")
            GameTooltip:SetText(descrip)
            GameTooltip:SetSize(80, 50)
            GameTooltip:SetWidth(80)
            GameTooltip:Show()
        end)
    else
        opt_cbox:SetDescription(descrip)
    end
    parent:AddChild(opt_cbox)
    return opt_cbox
end

-- BUILD PANE
function mWarlock:OptionsPane()
    local AceGUI = LibStub("AceGUI-3.0")
    OptionsPane = AceGUI:Create("Window")
    OptionsPane:SetWidth(800)
    OptionsPane:SetHeight(400)
    OptionsPane:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    OptionsPane:SetTitle("MWarlock - Options : " .. mWarlock:GetSpecName()) 
    OptionsPane:SetLayout("Fill")
    OptionsPane:SetCallback("OnClose", function(widget) AceGUI:Release(widget) end)

    local scrollcontainer = AceGUI:Create("InlineGroup") -- "InlineGroup" is also good
    scrollcontainer:SetLayout("Fill")
    OptionsPane:AddChild(scrollcontainer)
    scrollcontainer:SetFullWidth(true)
    scrollcontainer:SetFullHeight(true)
    
    local scrollFrame  = AceGUI:Create("ScrollFrame")
    scrollFrame:SetLayout("List")
    scrollFrame:SetFullWidth(true)
    scrollFrame:SetFullHeight(true)
    scrollcontainer:AddChild(scrollFrame)
        
    -- General shit
    local generalGroup = AceGUI:Create("InlineGroup")
    generalGroup:SetTitle("General: ")
    generalGroup:SetFullWidth(true)
    generalGroup:SetLayout("Flow")
    local descrip = "Allow the ui to move around using shift+lmb."
    createCheckBox(generalGroup, "Movable: ", descrip, "moveable", false, mWarlock.SetUIMovable)
    createCheckBox(generalGroup, "AsButtons: ", "Allow click to cast from radial buttons.", "asbuttons", false, nil)
    createCheckBox(generalGroup, "Hide Pet Frames", "", "hidePetFrame", false, mWarlock.HidePetFrames)
    createSlider(generalGroup, "Shards Frame Size: ", 10, 1000, 1, "shardTrackerFrameSize", 12, mWarlock.setShardTrackerFramesSize)
    createSlider(generalGroup, "Out Of Shards Frame Size: ", 10, 1000, 1, "shardOutOfFrameSize", 12, mWarlock.setOOSShardFramesSize)
    createSlider(generalGroup, "Pet Icon Size: ", 10, 150, 1, "PetFramesSize", 12, mWarlock.setPetFramePosAndSize)
    
    -- Radial shit
    local radialGroup = AceGUI:Create("InlineGroup")
    radialGroup:SetTitle("Radial Frame / Icons: ")
    radialGroup:SetFullWidth(true)
    radialGroup:SetLayout("Flow")
    createSlider(radialGroup, "Radius: ", 50, 500, 1, "radius", 100, mWarlock.radialButtonLayout)
    createSlider(radialGroup, "Offset: ", 0, 3, .001, "offset", 0, mWarlock.radialButtonLayout)
    createSlider(radialGroup, "Icon Size: ", 10, 1000, 1, "watcherFrameSize", 12, mWarlock.radialButtonLayout)
    createSlider(radialGroup, "Icon Spread: ", 0, 2, .01, "watcherFrameSpread", 0, mWarlock.radialButtonLayout)
    createSlider(radialGroup, "Width Oval: ", .1, 10, .01, "widthDeform", 0, mWarlock.radialButtonLayout)
    createSlider(radialGroup, "Height Oval: ", .1, 10, .01, "heightDeform", 0, mWarlock.radialButtonLayout)
    
    local timerGroup = AceGUI:Create("InlineGroup")
    timerGroup:SetTitle("Timer Text Positions: (set movable on to see)")
    timerGroup:SetFullWidth(true)
    timerGroup:SetLayout("Flow")
    createSlider(timerGroup, "Buff Up/Down:",  -50, 50, 1, "radialUDOffset", 0, mWarlock.radialButtonLayout)
    createSlider(timerGroup, "Buff Left/Right: ", -50, 50, 1, "radialLROffset", -10, mWarlock.radialButtonLayout)
    createSlider(timerGroup, "Cooldown Up/Down: ", -50, 50, 1, "cdUDOffset", -10, mWarlock.radialButtonLayout)
    createSlider(timerGroup, "Cooldown Left/Right: ", -50, 50, 1, "cdLROffset", -10, mWarlock.radialButtonLayout)
    createSlider(timerGroup, "Count Up/Down: ", -50, 50, 1, "countUDOffset", -10, mWarlock.radialButtonLayout)
    createSlider(timerGroup, "Count Left/Right: ", -50, 50, 1, "countLROffset", -10, mWarlock.radialButtonLayout)
    
    -- Font shit
    local fontGroup = AceGUI:Create("InlineGroup")
    fontGroup:SetTitle("Font Sizes: ")
    fontGroup:SetFullWidth(true)
    fontGroup:SetLayout("Flow")
    createSlider(fontGroup, "\"Count\" Font Size: ", 2, 55, 1, "countFontSize", 12, mWarlock.radialButtonLayout)
    createSlider(fontGroup, "\"Ready\" Font Size: ", 2, 55, 1, "readyFontSize", 12, mWarlock.radialButtonLayout)
    createSlider(fontGroup, "\"CoolDown\" Font Size: ", 2, 55, 1, "coolDownFontSize", 12, mWarlock.radialButtonLayout)
    createSlider(fontGroup, "\"Timer\" Font Size: ", 2, 55, 1, "timerFontSize", 12, mWarlock.radialButtonLayout)
    
    local spellsGroup = AceGUI:Create("InlineGroup")
    spellsGroup:SetTitle("Radial Spells: ")
    spellsGroup:SetFullWidth(true)
    spellsGroup:SetLayout("Flow")

    local activeTalentTreeSpells = mWarlock:GetAllActiveTalentTreeSpells()
    -- lower level classes might not have an active talent tree.
    if activeTalentTreeSpells ~= nil then
        for i, spellData in ipairs(mWarlock:GetAllActiveTalentTreeSpells()) do
            -- add a bool flag for each into the saved vars, so we can check against this in the radial menu!
            local spellName = spellData[1]
            desc = GetSpellDescription(spellData[2])
            createCheckBox(spellsGroup, spellName, desc, "isActive"..spellName, true, mWarlock.INITUI, true)
        end
    end

    --- FINAL LAYOUT
    scrollFrame:AddChild(generalGroup)
    scrollFrame:AddChild(radialGroup)
    scrollFrame:AddChild(timerGroup)
    scrollFrame:AddChild(fontGroup)
    scrollFrame:AddChild(spellsGroup)
end

function mWarlock:BagPane()
    local AceGUI = LibStub("AceGUI-3.0")
    local function updateData(groupIndex, ignoreValue)
        local toShow
        if groupIndex == 1 then
            toShow = mWarlock:listBagItems(ignoreValue)
        elseif groupIndex == 2 then
            toShow = mWarlock:listBankItems(ignoreValue)
            
        else
            toShow = mWarlock:listBankReagentItems(ignoreValue)

        end
        return toShow
    end

    local function refreshWidget(toShow, scrollFrame, editBox)
        scrollFrame:ReleaseChildren()
        for x, itemInfo in ipairs(toShow) do
            local itemName = itemInfo[1]
            local icon = itemInfo[2]
            local clickableUrl = itemInfo[3]
            local url = itemInfo[4]
            local hyperlink = itemInfo[5]
            local interActiveIcon = AceGUI:Create("Icon")
            interActiveIcon:SetLabel(itemName)
            -- Note this doesn't work for all icons interActiveIcon:SetImage(C_Item.GetItemIconByID(icon))
            interActiveIcon:SetImage(MWArtTexturePaths[icon])
            interActiveIcon:SetImageSize(24,24)
            interActiveIcon:SetUserData("hyperlink", hyperlink)
            interActiveIcon:SetUserData("url", url)
            interActiveIcon:SetCallback("OnEnter", function(widget) GameTooltip:SetOwner(widget.frame, "ANCHOR_BOTTOMRIGHT") GameTooltip:SetHyperlink(widget:GetUserData("hyperlink")) GameTooltip:SetSize(80, 50) GameTooltip:SetWidth(80) GameTooltip:Show() end)
            interActiveIcon:SetCallback("OnLeave", function() GameTooltip:SetOwner(UIParent, "ANCHOR_BOTTOMRIGHT") GameTooltip:SetText("") GameTooltip:SetSize(80, 50) GameTooltip:SetWidth(80) GameTooltip:Show() end)
            interActiveIcon:SetCallback("OnClick", function(widget) editBox:SetText(widget:GetUserData("url"))   end)
            scrollFrame:AddChild(interActiveIcon)
        end
    end

    MWBagPane = AceGUI:Create("Window")
    MWBagPane:SetWidth(800)
    MWBagPane:SetHeight(600)
    MWBagPane:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    MWBagPane:SetTitle("Bags: WowHead Url Generator") 
    MWBagPane:SetLayout("Fill")
    MWBagPane:SetCallback("OnClose", function(widget) AceGUI:Release(widget) end)
    
    local base = AceGUI:Create("SimpleGroup")
    MWBagPane:AddChild(base)

    local urlInput = AceGUI:Create("EditBox")
    urlInput:SetFullWidth(true)
    urlInput:SetText("")
    urlInput:SetLabel("WowHeadUrl:")
    -- urlInput:SetCallback("OnTextChanged", function() urlInput:HighlightText() end)
    -- urlInput:SetCallback("OnEnter", function(widget, eventName, text) urlInput:HighlightText() end)
    -- urlInput:SetCallback("OnEnterPressed", function() urlInput:HighlightText() end)

    local testTrp = AceGUI:Create("DropdownGroup")
    testTrp:SetTitle("Select:")
    testTrp:SetGroupList({"Inventory", "Bank", "Bank Reagents"})
    testTrp:SetLayout("Flow")
    testTrp:SetFullWidth(true)
    testTrp:SetHeight(400)

    local scrollcontainer = AceGUI:Create("InlineGroup") -- "InlineGroup" is also good
    scrollcontainer:SetLayout("Flow")
    scrollcontainer:SetFullWidth(true)
    scrollcontainer:SetHeight(400)
    testTrp:AddChild(scrollcontainer)
    
    local scrollFrame  = AceGUI:Create("ScrollFrame")
    scrollFrame:SetLayout("Flow")
    scrollFrame:SetFullWidth(true)
    scrollFrame:SetHeight(400)
    scrollcontainer:AddChild(scrollFrame)

    local ignoreCBx = AceGUI:Create("CheckBox")
    local ignoreValue = true
    local currGroupIndex = 1
    ignoreCBx:SetFullWidth(true)
    ignoreCBx:SetValue(ignoreValue)
    ignoreCBx:SetLabel("Ignore SoulBound Items")
    ignoreCBx:SetCallback("OnValueChanged", function(widget, eventName, value) 
                        ignoreValue= value
                        local bagData = updateData(currGroupIndex, value)
                        refreshWidget(bagData, scrollFrame, urlInput) end)
    
    local items = {BAGDUMPV1, BANKDUMPV1, BANKRDUMPV1}
    testTrp:SetCallback("OnGroupSelected", function(widget, event, groupIndex, groupName)
        
        currGroupIndex = groupIndex
        local bagData = updateData(groupIndex, ignoreValue)
        refreshWidget(bagData, scrollFrame, urlInput)
    end)
    if items[1] ~= nil then
        testTrp:SetGroup(1)
    end

    base:AddChild(urlInput)
    base:AddChild(ignoreCBx)
    base:AddChild(testTrp)


    -- scrollcontainer:AddChild(testTrp)
    
    -- nteractiveLabel
    -- A basic label which reacts to mouse interaction, optionally with an icon in front.

    -- APIs
    -- SetText(text) - Set the text.
    -- SetColor(r, g, b) - Set the color of the text.
    -- SetFont(font, height, flags) - Set the font of the text.
    -- SetFontObject(font) - Set the font using a pre-defined font-object.
    -- SetImage(image, ...) - Set the image to be shown. Additionally to the path, any extra arguments will be directly forwarded to :SetTexCoord.
    -- SetImageSize(width, height) - Set the size of the image.
    -- SetHighlight(...) - Set the highlight texture (either path to a texture, or RGBA values for a solid color)
    -- SetHighlightTexCoord(...) - Set the tex coords for the highlight texture.
    -- Callbacks
    -- OnClick(button) - Fires when the label is clicked.
    -- OnEnter() - Fires when the cursor enters the widget.
    -- OnLeave() - Fires when the cursor leaves the widget.


    -- GetText() - Get the text in the edit box.
    -- SetLabel(text) - Set the text for the label.
    -- SetNumLines(num) - Set the number of lines to be displayed in the editbox.
    -- SetDisabled(flag) - Disable the widget.
    -- SetMaxLetters(num) - Set the maximum number of letters that can be entered (0 for unlimited).
    -- DisableButton(flag) - Disable the "Okay" Button
    -- SetFocus() - Set the focus to the editbox.
    -- HighlightText(start, end) - Highlight the text in the editbox (see Blizzard EditBox Widget documentation for details)
    -- Callbacks
    -- OnTextChanged(text) - Fires on every text change.
    -- OnEnterPressed(text) - Fires when the new text was confirmed and should be saved.
    -- OnEnter() - Fires when the cursor enters the widget.
    -- OnLeave() - Fires when the cursor leaves the widget.
end