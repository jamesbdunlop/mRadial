mw_config = LibStub("AceConfig-3.0")
mw_dialog = LibStub("AceConfigDialog-3.0")

spec = GetSpecialization()
specName = "Demonology"

if spec == 1 then
    specName = "Affliction"
elseif spec == 2 then
    specName = "Demonology"
end

---------------------------------------------------------------------------------------------------
-- Functions for Blizz Options Pane
local function changeRadius(table, value)
    -- print("Radius value: %d", value)
    MWarlockSavedVariables.radius = value
    mWarlock:radialButtonLayout()
end

local function changeOffset(table, value)
    MWarlockSavedVariables.offset = value
    mWarlock:radialButtonLayout()
end

local function changeFgfs(table, value)
    MWarlockSavedVariables.felguardFrameSize = value
    mWarlock:setFelguardFramePosAndSize()
end

local function changeShardTracker(table, value)
    MWarlockSavedVariables.shardTrackerFrameSize = value
    mWarlock:setShardTrackerFramesSize()
end

---------------------------------------------------------------------------------------------------
-- GETTERS
local function getOffset()
    return MWarlockSavedVariables.offset
end

local function getRadius()
    return MWarlockSavedVariables.radius
end

local function getFelguardFrameSize()
    return MWarlockSavedVariables.felguardFrameSize
end

local function getShardTackerFrameSize()
    return MWarlockSavedVariables.shardTrackerFrameSize
end
---------------------------------------------------------------------------------------------------
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

function mWarlock:createconfig()
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
                min  = 0,
                max = 3,
                softMin = 0,
                softMax = 3,
                step = .001,
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
             stkrFsize = {
                order = 3,
                name = "SharTrackerIconSize",
                desc = "Changes the size of the shard tracker icon",
                type = "range",
                min  = 10,
                max = 1000,
                softMin = 10,
                softMax = 1000,
                step = 1,
                set = changeShardTracker,
                get = getShardTackerFrameSize
            }
        }
    }
    return options
end

local options
function mw_createBlizzOptions()
    options = mWarlock:createconfig()

    mw_config:RegisterOptionsTable("mWarlock-General", options.args.general)
    local blizzPanel = mw_dialog:AddToBlizOptions("mWarlock-General", options.args.general.name, "mWarlock")
    return blizzPanel
end

---------------------------------------------------------------------------------------------------
-- STAND ALONE OPTIONS PANE
-- CALL BACKS FOR OPTIONS PANE as this approach sends through widget, cbName, value to the darn functions
function radiusChangedCB(widget, cbName, value)
    changeRadius(nil, value)
end

function offsetChangedCB(widget, cbName, value)
    changeOffset(nil, value)
end

function movableCB(widget, cbName, value)
    mWarlock:setMovable(widget:GetValue())
end

function fgfsChangedCB(widget, cbName, value)
    changeFgfs(nil, value)
end

function shardTrackerChangedCB(widget, cbName, value)
    changeShardTracker(nil, value)
end


-- BUILD PANE
function mWarlock:OptionsPane()
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

    if specName == "Demonology" then
        local opt_felguardFSize = AceGUI:Create("Slider")
        opt_felguardFSize:SetCallback("OnValueChanged", fgfsChangedCB)
        opt_felguardFSize:SetValue(getFelguardFrameSize() or 56)
        opt_felguardFSize:SetSliderValues(10, 150, 1)
        opt_felguardFSize:SetLabel("FelGuard Icon Size: ")
        optionsf:AddChild(opt_felguardFSize)
    end

    local opt_ShardTrackFrameSize = AceGUI:Create("Slider")
    opt_ShardTrackFrameSize:SetCallback("OnValueChanged", shardTrackerChangedCB)
    opt_ShardTrackFrameSize:SetValue(getShardTackerFrameSize() or 128)
    opt_ShardTrackFrameSize:SetSliderValues(10, 1000, 1)
    opt_ShardTrackFrameSize:SetLabel("ShardTracker Icon Size: ")
    optionsf:AddChild(opt_ShardTrackFrameSize)
end