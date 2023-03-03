if MWarlockSavedVariables == nil then
    MWarlockSavedVariables = {}
end

UdOffset = 0

MW_ALLFRAMES = {}
MW_PARENTFRAMES = {}

function mWarlock:CreatePlayerSavedVars()
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

function mWarlock:INITUI()
    print("INITUI CALLED....")
    -- Clear out existing frames for a full refresh.
    mWarlock:RemoveAllParentFrames()
    MW_ALLFRAMES = {}
    MWarlockSavedVariables = mWarlock:CreatePlayerSavedVars()
    mWarlock:CreateMainFrame()
    if mWarlock:IsWarlock() then
        mWarlock:createShardCountFrame()
    end
    
    mWarlock:createWatcherFrames()
    mWarlock:radialButtonLayout()
    mWarlock:createPetFrames()
    mWarlock:SetUIMovable(false)
    mWarlock:shardtrack()
end

function mWarlock:OnInitialize()
    local f = CreateFrame("Frame")
    -- Register the event for when the player logs in
    f:RegisterEvent("PLAYER_ENTERING_WORLD")
    f:SetScript("OnEvent", function(self, event, ...)
        -- ud stands for UpDown
        -- lr stands for leftRight
        if event == "PLAYER_ENTERING_WORLD" then
            mWarlock:INITUI()
            self:UnregisterEvent("PLAYER_ENTERING_WORLD")
        end
    end)
end

function mWarlock:OnEnable()
    local playerName = UnitName("player")
    local LDB = LibStub("LibDataBroker-1.1")
    local LDBIcon = LibStub("LibDBIcon-1.0")
    print("~~~~~~~~~~~~~~~~~~~~")
    print("Welcome " .. playerName .. " -- MWarlock")
    print("/mw slash commands are: move, lock, options")
    print("~~~~~~~~~~~~~~~~~~~~")
    
    local addonName = "mWarlock"
    local addonIcon = MEDIAPATH.."\\miniMapIcon"
    
    local dataBroker = LDB:NewDataObject(addonName, {
        type = "data source",
        icon = addonIcon,
        OnClick = function(self, button)
            mWarlock:OptionsPane()
        end,
        OnTooltipShow = function(tooltip)
            -- Add tooltip text
            tooltip:AddLine("MWarlock - Click to show Options!")
        end,
    })
    
    LDBIcon:Register(addonName, dataBroker, {
        hide = false,
    })
end

function mWarlock:OnDisable()
    -- Called when the addon is disabled
    -- print("mWarlock OnDisable called!")
end

--/run mWarlock:listBagItems(BAGDUMPV1)