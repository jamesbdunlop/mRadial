local addonName, mWarlock = ...
mw_config = LibStub("AceConfig-3.0")
mw_dialog = LibStub("AceConfigDialog-3.0")
---------------------------------
local function changeRadius(value)
    print("Radius value: %d", value)
    MWarlockSavedVariables.radius = value
    radialButtonLayout()
end

local function changeOffset(value)
    print("Offset value: %d", value)
    MWarlockSavedVariables.offset = value
    radialButtonLayout()
end

function changeFgfs(value)
    print("FGIcon value: %d", value)
    MWarlockSavedVariables.felguardFrameSize = value
    mWarlock:setFelguardFramesSize()
end

function getOffset()
    print("getOffset: %d", MWarlockSavedVariables["offset"])
    return MWarlockSavedVariables["offset"]
end

function getRadius()
    print("getRadius: %d", MWarlockSavedVariables["offset"])
    return MWarlockSavedVariables["radius"]
end

function getFelguardFrameSize()
    print("getFelguardFrameSize: %d", MWarlockSavedVariables["offset"])
    return MWarlockSavedVariables["felguardFrameSize"]
end

mw_aboutOptions = {
	type = "group",
	args = {
		version = {
			order = 1,
			type = "description",
			name = function() return "Version: mWarlock- 0.0.1" end,

		}
	},
}

local function mw_createconfig()
	local options = {}
    options.type = "group"
    options.name = "mWarlock"
    options.args = {}

    options.args.general = {
        order = 1, 
        type = "group",
        name = "General Options",
        args = {
            radius = {
                order = 1,
                name = "Radius",
                desc = "Changes the radius of the timers",
                type = "range",
                min  = 65,
                max = 800,
                softMin = 65,
                softMax = 800,
                step = .01,
                set = changeRadius,
                get = getRadius
                },
            offset = {
                order = 2,
                name = "Offset",
                desc = "Changes the position around the circle icons draw",
                type = "range",
                min  = 0.1,
                max = 4,
                softMin = 0.1,
                softMax = 4,
                step = .01,
                set = changeOffset,
                get = getOffset
                },
            fgFsize = {
                    order = 2,
                    name = "FelGuardIconSize",
                    desc = "Changes the size of the felguard pet ability icons",
                    type = "range",
                    min  = 10,
                    max = 150,
                    softMin = 10,
                    softMax = 150,
                    step = 1,
                    set = changeFgfs,
                    get = getFelguardFrameSize
                    },
             }
    }

    return options
end

local options
function mw_createBlizzOptions()
    --print("Creating blizz options for mWarlock now..")
    options = mw_createconfig()

    mw_config:RegisterOptionsTable("mWarlock-General", options.args.general)
    local blizzPanel = mw_dialog:AddToBlizOptions("mWarlock-General", options.args.general.name, "mWarlock")
    return blizzPanel
end


--- STAND ALONE OPTIONS PANE
-- CALL BACKS FOR OPTIONS PANE
function radiusChangedCB(widget, cbName, value)
    changeRadius(value)
end

function offsetChangedCB(widget, cbName, value)
    changeOffset(value)
end

function movableCB(widget, cbName, value)
    mWarlock:setMovable(widget:GetValue())
end

function fgfsChangedCB(widget, cbName, value)
    changeFgfs(value)
end

-- BUILD PANE
function mWarlock:OptionsPane()
    spec = GetSpecialization()
    if spec == 2 then
        specName = "Demonology"
    end

    local AceGUI = LibStub("AceGUI-3.0")
    local optionsf = AceGUI:Create("Frame")
    optionsf:SetWidth(260)
    optionsf:SetHeight(360)
    optionsf:SetPoint("CENTER", UIParent, "CENTER", 0, 150)
    optionsf:SetTitle("MWarlock - Options : " .. specName) 
    optionsf:SetLayout("List")

    local opt_move = AceGUI:Create("CheckBox")
    opt_move:SetValue(false)
    opt_move:SetLabel("Movable")
    opt_move:SetCallback("OnValueChanged", movableCB)
    opt_move:SetDescription("Allow the ui to move around using shift+lmb.")
    optionsf:AddChild(opt_move)

    local opt_radius = AceGUI:Create("Slider")
    opt_radius:SetCallback("OnValueChanged", radiusChangedCB)
    opt_radius:SetValue(getRadius())
    opt_radius:SetSliderValues(50, 500, 1)
    opt_radius:SetLabel("Radius: ")
    optionsf:AddChild(opt_radius)

    local opt_offset = AceGUI:Create("Slider")
    opt_offset:SetCallback("OnValueChanged", offsetChangedCB)
    opt_offset:SetValue(getOffset())
    opt_offset:SetSliderValues(0, 3, .01)
    opt_offset:SetLabel("Offset: ")
    optionsf:AddChild(opt_offset)

    local opt_felguardFSize = AceGUI:Create("Slider")
    opt_felguardFSize:SetCallback("OnValueChanged", fgfsChangedCB)
    opt_felguardFSize:SetValue(getFelguardFrameSize())
    opt_felguardFSize:SetSliderValues(10, 150, 1)
    opt_felguardFSize:SetLabel("FelGuard Icon Size: ")
    optionsf:AddChild(opt_felguardFSize)
end