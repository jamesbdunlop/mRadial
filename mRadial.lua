---------------------------------------------------------------------
--- TO DO -----------------------------------------------------------
-- Update pet frames for other classes?
-- Update pet frames for death of pets!
-- "Import from" feature for the button layouts?
---------------------------------------------------------------------
local MR_configDialog = LibStub("AceConfigDialog-3.0")
local MR_configRegistry = LibStub("AceConfigRegistry-3.0")
local appName = "MRadial"

if MRadialSavedVariables == nil then
    MRadialSavedVariables = {}
end

UdOffset = 0

MR_ALLFRAMES = {}
MR_PARENTFRAMES = {}
MR_WATCHERFRAMES = {}
MR_PETFAMES = {}
ACTIVEPRIMARYWATCHERS = {}
ACTIVESECONDARYWATCHERS = {}

function mRadial:CreatePlayerSavedVars()
    -- print("CreatePlayerSavedVars called!")
    if not PerPlayerPerSpecSavedVars then
        -- print("Creating PerPlayerPerSpecSavedVars table")
        PerPlayerPerSpecSavedVars = {}
    end
    
    local playerName = UnitName("player")
    local playerSpec = GetSpecialization()
    if not PerPlayerPerSpecSavedVars[playerName] then
        -- print("Creating player table.")
        PerPlayerPerSpecSavedVars[playerName] = {}
    end
    if not PerPlayerPerSpecSavedVars[playerName][playerSpec] then
        -- print("Creating player spec table.")
        PerPlayerPerSpecSavedVars[playerName][playerSpec] = {}
        PerPlayerPerSpecSavedVars[playerName][playerSpec]["framePositions"] = {}
    end
    
    return PerPlayerPerSpecSavedVars[playerName][playerSpec]
end

function mRadial:InitUI()
    MRadialSavedVariables = mRadial:CreatePlayerSavedVars()
    if MRadialSavedVariables["primaryWatcherOrder"] == nil then
        MRadialSavedVariables["primaryWatcherOrder"] = {}
    end
    if MRadialSavedVariables["secondaryWatcherOrder"] == nil then
        MRadialSavedVariables["secondaryWatcherOrder"] = {}
    end
    mRadial:CreateMainFrame()
    mRadial:CreateWatcherFrames()

    local hideShardFrame = MRadialSavedVariables["hideShardFrame"] or false
    if mRadial:IsWarlock() and not hideShardFrame then
        mRadial:createShardCountFrame()
        mRadial:shardtrack()
    end
    mRadial:CreatePetFrames()
    mRadial:SetUIMovable(MAINFRAME_ISMOVING)
    mRadial:UpdateUI(false)
end

function mRadial:UpdateUI(create)
    if create == nil then create = false end
    if create then 
        mRadial:CreateWatcherFrames() 
    end
    ---------------------------------
    -- PRIMARY SPELL RADIAL MENU
    local prevOrder = MRadialSavedVariables["primaryWatcherOrder"]
    local currentPrimaryOrder = {}
    local activePrimarySpells = mRadial:UpdateActivePrimarySpells()
    mRadial:BuildPrimarySpellOrder(false)
    if prevOrder ~= nil and #prevOrder > 0 then
        for idx, watcherData in ipairs(prevOrder) do
            currentPrimaryOrder[idx] = mRadial:GetFromTable(watcherData.spellName, activePrimarySpells)
        end
    else
        currentPrimaryOrder = activePrimarySpells
    end

    local radius = MRadialSavedVariables.radius or 100
    local offset = MRadialSavedVariables.offset or .5
    local spread = MRadialSavedVariables.watcherFrameSpread or 0
    local widthDeform = MRadialSavedVariables.widthDeform or 1
    local heightDeform = MRadialSavedVariables.heightDeform or 1
    mRadial:RadialButtonLayout(currentPrimaryOrder, radius, offset, spread, widthDeform, heightDeform)
    ---------------------------------
    -- SECONDARY SPELL RADIAL MENU
    local prevSecondaryOrder = MRadialSavedVariables["secondaryWatcherOrder"]
    local secondaryCurrentOrder = {}
    local activeSecondarySpells = mRadial:UpdateActiveSecondarySpells()
    mRadial:BuildSecondarySpellOrder(false)
    if prevSecondaryOrder ~= nil and #prevSecondaryOrder > 0 then
        for idx, watcherData in ipairs(prevSecondaryOrder) do
            secondaryCurrentOrder[idx] = mRadial:GetFromTable(watcherData.spellName, activeSecondarySpells)
        end
    else
        secondaryCurrentOrder = activeSecondarySpells
    end

    local radius2 = MRadialSavedVariables.radius2 or 100
    local offset2 = MRadialSavedVariables.offset2 or .5
    local spread2 = MRadialSavedVariables.watcherFrameSpread2 or 0
    local widthDeform2 = MRadialSavedVariables.widthDeform2 or 1
    local heightDeform2 = MRadialSavedVariables.heightDeform2 or 1
    mRadial:RadialButtonLayout(secondaryCurrentOrder, radius2, offset2, spread2, widthDeform2, heightDeform2)
end

local db = LibStub("LibDataBroker-1.1"):NewDataObject("mRadialDB", {
    type = "data source",
    text = "mRadialIcon",
    icon = MEDIAPATH.."\\miniMapIcon",
    iconR = .5,
    iconG = .9,
    iconB = .5,
    OnClick = function(self) mRadial:OptionsPane() end,
    OnTooltipShow = function(tooltip) tooltip:AddLine("mRadial - options") end,
    })
local icon = LibStub("LibDBIcon-1.0")

function mRadial:OnInitialize()
    local f = CreateFrame("Frame")
    -- Register the event for when the player logs in
    f:RegisterEvent("PLAYER_ENTERING_WORLD")
    f:SetScript("OnEvent", function(self, event, ...)
        -- ud stands for UpDown
        -- lr stands for leftRight
        if event == "PLAYER_ENTERING_WORLD" then
            mRadial:InitUI()
            self:UnregisterEvent("PLAYER_ENTERING_WORLD")
        end
    end)
    
    MR_configRegistry:RegisterOptionsTable(appName, MROptionsTable, true)
    MR_configDialog:AddToBlizOptions(appName, "mRadial")
end

function mRadial:OnEnable()
    local playerName = UnitName("player")
    print("----------------------")
    print("Welcome " .. playerName .. " -- mRadial")
    print("/mr slash commands are: move, lock, options")
    print("----------------------")
    
    local hideMiniMapIcon = MRadialSavedVariables["hideMiniMapIcon"] or false
    if not hideMiniMapIcon then
        self.icodb = LibStub("AceDB-3.0"):New("mRadialICO", { profile = { minimap = { hide = hideMiniMapIcon, }, }, })
        icon:Register("mRadialIcon", db, mRadialICO)
    end
end

function mRadial:OnDisable()
    -- Called when the addon is disabled
    -- print("mRadial OnDisable called!")
end

function mRadial_OnAddonCompartmentClick(addonName, buttonName)
    mRadial:OptionsPane()
end