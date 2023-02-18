mw_config = LibStub("AceConfig-3.0")
mw_dialog = LibStub("AceConfigDialog-3.0")

spec = GetSpecialization()
specName = "Demonology"

if spec == 1 then
    specName = "Affliction"
elseif spec == 2 then
    specName = "Demonology"
end

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

local function createCheckBox(parent, name, descrip, variableName, defaultValue, toexec)
    local AceGUI = LibStub("AceGUI-3.0")
    local opt_cbox = AceGUI:Create("CheckBox")
    opt_cbox:SetLabel(name)
    opt_cbox:SetDescription(descrip)
    
    local function setValue(table, cbName, value)
        print(table, cbName, value)
        MWarlockSavedVariables[variableName] = value
        if toexec ~= nil then
            -- print("calling func : %s", value)
            toexec(value)
        end
    end

    local function getValue(info)
        local value = MWarlockSavedVariables[variableName] or defaultValue
        return value
    end
    
    opt_cbox:SetValue(getValue())
    opt_cbox:SetCallback("OnValueChanged", setValue)
    opt_cbox.get = getValue
    
    parent:AddChild(opt_cbox)
    return opt_cbox
end

-- BUILD PANE
function mWarlock:OptionsPane()
    local AceGUI = LibStub("AceGUI-3.0")
    local optionsf = AceGUI:Create("Frame")
        optionsf:SetWidth(400)
        optionsf:SetHeight(600)
        optionsf:SetPoint("CENTER", UIParent, "CENTER", 0, 150)
        optionsf:SetTitle("MWarlock - Options : " .. specName) 
        optionsf:SetLayout("List")
        optionsf:SetCallback("OnClose", function(widget) AceGUI:Release(widget) end)
        optionsf:SetLayout("Fill")
    
    local scrollcontainer = AceGUI:Create("InlineGroup") -- "InlineGroup" is also good
          scrollcontainer:SetFullWidth(true)
          scrollcontainer:SetFullHeight(true)
          scrollcontainer:SetLayout("Fill")
    optionsf:AddChild(scrollcontainer)

    local scrollFrame  = AceGUI:Create("ScrollFrame")
        scrollFrame:SetLayout("Flow")
    scrollcontainer:AddChild(scrollFrame)

    local descrip = "Allow the ui to move around using shift+lmb."
    createCheckBox(scrollFrame, "Movable: ", descrip, "moveable", false, mWarlock.SetUIMovable)
    
    -- General shit
    createSlider(scrollFrame, "Shards Frame Size: ", 10, 1000, 1, "shardTrackerFrameSize", 12, mWarlock.setShardTrackerFramesSize)
    if specName == "Demonology" then
        createSlider(scrollFrame, "Felguard Frame Size: ", 10, 150, 1, "felguardFrameSize", 12, mWarlock.setFelguardFramePosAndSize)
    end
    
    -- Radial shit
    local radialGroup = AceGUI:Create("InlineGroup")
    radialGroup:SetTitle("Radial Frame / Icons: ")
    createSlider(radialGroup, "Radius: ", 50, 500, 1, "radius", 100, mWarlock.radialButtonLayout)
    createSlider(radialGroup, "Offset: ", 0, 3, .001, "offset", 0, mWarlock.radialButtonLayout)
    createSlider(radialGroup, "Icon Size: ", 10, 1000, 1, "watcherFrameSize", 12, mWarlock.radialButtonLayout)
    createSlider(radialGroup, "Icon Spread: ", 0, 2, .01, "watcherFrameSpread", 0, mWarlock.radialButtonLayout)
    scrollFrame:AddChild(radialGroup)
    
    -- Font shit
    local fontGroup = AceGUI:Create("InlineGroup")
    fontGroup:SetTitle("Fonts: ")
    createSlider(fontGroup, "Count Font Size: ", 2, 55, 1, "countFontSize", 12, mWarlock.radialButtonLayout)
    createSlider(fontGroup, "Ready Font Size: ", 2, 55, 1, "readyFontSize", 12, mWarlock.radialButtonLayout)
    createSlider(fontGroup, "CoolDown Font Size: ", 2, 55, 1, "coolDownFontSize", 12, mWarlock.radialButtonLayout)
    createSlider(fontGroup, "Timer Font Size: ", 2, 55, 1, "timerFontSize", 12, mWarlock.radialButtonLayout)
    scrollFrame:AddChild(fontGroup)
end

