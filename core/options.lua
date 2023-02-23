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

local function createCheckBox(parent, name, descrip, variableName, defaultValue, toexec)
    local AceGUI = LibStub("AceGUI-3.0")
    local opt_cbox = AceGUI:Create("CheckBox")
    opt_cbox:SetLabel(name)
    opt_cbox:SetDescription(descrip)
    
    local function setValue(table, cbName, value)
        MWarlockSavedVariables[variableName] = value
        if toexec ~= nil then
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
OptionsPane = nil
function mWarlock:OptionsPane()
    local AceGUI = LibStub("AceGUI-3.0")
    if OptionsPane ~= nil then
        OptionsPane:Show()
        return
    end

    OptionsPane = AceGUI:Create("Window")
    OptionsPane:SetWidth(400)
    OptionsPane:SetHeight(600)
    OptionsPane:SetPoint("CENTER", UIParent, "CENTER", 0, 150)
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
    -- generalGroup:SetFullHeight(true)
    local descrip = "Allow the ui to move around using shift+lmb."
    createCheckBox(generalGroup, "Movable: ", descrip, "moveable", false, mWarlock.SetUIMovable)
    createCheckBox(generalGroup, "Hide Pet Frames", "", "hidePetFrame", false, mWarlock.HidePetFrames)
    createSlider(generalGroup, "Shards Frame Size: ", 10, 1000, 1, "shardTrackerFrameSize", 12, mWarlock.setShardTrackerFramesSize)
    createSlider(generalGroup, "Out Of Shards Frame Size: ", 10, 1000, 1, "shardOutOfFrameSize", 12, mWarlock.setOOSShardFramesSize)
    createSlider(generalGroup, "Pet Icon Size: ", 10, 150, 1, "PetFramesSize", 12, mWarlock.sePetFramePosAndSize)
    
    -- Radial shit
    local radialGroup = AceGUI:Create("InlineGroup")
    radialGroup:SetTitle("Radial Frame / Icons: ")
    -- radialGroup:SetFullHeight(true)
    createSlider(radialGroup, "Radius: ", 50, 500, 1, "radius", 100, mWarlock.radialButtonLayout)
    createSlider(radialGroup, "Offset: ", 0, 3, .001, "offset", 0, mWarlock.radialButtonLayout)
    createSlider(radialGroup, "Icon Size: ", 10, 1000, 1, "watcherFrameSize", 12, mWarlock.radialButtonLayout)
    createSlider(radialGroup, "Icon Spread: ", 0, 2, .01, "watcherFrameSpread", 0, mWarlock.radialButtonLayout)
    
    local timerGroup = AceGUI:Create("InlineGroup")
    timerGroup:SetTitle("Timers: (set movable on to see)")
    -- timerGroup:SetFullHeight(true)
    createSlider(timerGroup, "Buff Up/Down:",  -50, 50, 1, "radialUDOffset", 0, mWarlock.radialButtonLayout)
    createSlider(timerGroup, "Buff Left/Right: ", -50, 50, 1, "radialLROffset", -10, mWarlock.radialButtonLayout)
    createSlider(timerGroup, "Cooldown Up/Down: ", -50, 50, 1, "cdUDOffset", -10, mWarlock.radialButtonLayout)
    createSlider(timerGroup, "Cooldown Left/Right: ", -50, 50, 1, "cdLROffset", -10, mWarlock.radialButtonLayout)
    createSlider(timerGroup, "Count Up/Down: ", -50, 50, 1, "countUDOffset", -10, mWarlock.radialButtonLayout)
    createSlider(timerGroup, "Count Left/Right: ", -50, 50, 1, "countLROffset", -10, mWarlock.radialButtonLayout)
    
    -- Font shit
    local fontGroup = AceGUI:Create("InlineGroup")
    fontGroup:SetTitle("Fonts: ")
    -- fontGroup:SetFullHeight(true)
    createSlider(fontGroup, "\"Count\" Font Size: ", 2, 55, 1, "countFontSize", 12, mWarlock.radialButtonLayout)
    createSlider(fontGroup, "\"Ready\" Font Size: ", 2, 55, 1, "readyFontSize", 12, mWarlock.radialButtonLayout)
    createSlider(fontGroup, "\"CoolDown\" Font Size: ", 2, 55, 1, "coolDownFontSize", 12, mWarlock.radialButtonLayout)
    createSlider(fontGroup, "\"Timer\" Font Size: ", 2, 55, 1, "timerFontSize", 12, mWarlock.radialButtonLayout)
    
    scrollFrame:AddChild(generalGroup)
    scrollFrame:AddChild(timerGroup)
    scrollFrame:AddChild(radialGroup)
    scrollFrame:AddChild(fontGroup)
end

