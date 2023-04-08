local LDB = LibStub("LibDataBroker-1.1")
local LDBIcon = LibStub("LibDBIcon-1.0")
if MRadialSavedVariables == nil then
    MRadialSavedVariables = {}
end

local mr_dataBroker;
mr_dataBroker = LDB:NewDataObject ("mRadialICO", {
    type = "data source", 
    text= "0",  
    icon = MEDIAPATH.."\\miniMapIcon",
    iconR = .5,
    iconG = .9,
    iconB = .5,
    OnClick = function(self)
        mRadial:OptionsPane()
    end,
    OnTooltipShow = function(tooltip)
        tooltip:AddLine("mRadial - options")
    end,
})
LDBIcon:Register("mRadialICO", mr_dataBroker, {hide=false, minimapPos=199})
LDBIcon:Show("mRadialICO")

UdOffset = 0

MR_ALLFRAMES = {}
MR_PARENTFRAMES = {}
MR_WATCHERFRAMES = {}
MR_PETFAMES = {}
ACTIVEWATCHERS = {}

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
    mRadial:CreateMainFrame()
    mRadial:createWatcherFrames()

    local hideShardFrame = MRadialSavedVariables["hideShardFrame"] or false
    if mRadial:IsWarlock() and not hideShardFrame then
        mRadial:createShardCountFrame()
        mRadial:shardtrack()
    end
    mRadial:createPetFrames()
    mRadial:SetUIMovable(MAINFRAME_ISMOVING)
    mRadial:UpdateUI()
end

function mRadial:UpdateUI()
    mRadial:createWatcherFrames()
    mRadial:RadialButtonLayout()
end

function mRadial:OnInitialize()
    local f = CreateFrame("Frame")
    -- Register the event for when the player logs in
    f:RegisterEvent("PLAYER_ENTERING_WORLD")
    f:SetScript("OnEvent", function(self, event, ...)
        -- ud stands for UpDown
        -- lr stands for leftRight
        if event == "PLAYER_ENTERING_WORLD" then
            -- print("OnInitialize called! InitUI Fired!")
            mRadial:InitUI()
            self:UnregisterEvent("PLAYER_ENTERING_WORLD")
        end
    end)
    

end

function mRadial:OnEnable()
    local playerName = UnitName("player")
    print("----------------------")
    print("Welcome " .. playerName .. " -- mRadial")
    print("/mr slash commands are: move, lock, options")
    print("----------------------")
end

function mRadial:OnDisable()
    -- Called when the addon is disabled
    -- print("mRadial OnDisable called!")
end
