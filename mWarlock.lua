-- Add options for
    -- player specific configs, for shadow etc!!
    -- add on update throttling
    -- if we don't have power siphon do we still proc demonic core?

----GLOBAL SAVED VARS

local udOffset = 20
MW_WatcherFrames = {}
if MWarlockSavedVariables == nil then
    MWarlockSavedVariables = {}
end


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

function mWarlock:createWatchers()
    MW_WatcherFrames = {}
    local activeTalentTreeSpells = mWarlock:GetAllActiveTalentTreeSpells()
    if activeTalentTreeSpells == nil then
        return
    end
    for _, spellInfo in ipairs(activeTalentTreeSpells) do
        local spellId = spellInfo[2]
        local spellName, rank, iconPath, castTime, minRange, maxRange, spellID, originalSpellIcon = GetSpellInfo(spellId)
        local isActive  = false
        if spellName ~= nil then 
            isActive = MWarlockSavedVariables["isActive"..spellName] or false
            
            local isKnown  = IsPlayerSpell(spellId)
            local isPassive = IsPassiveSpell(spellID)
            if isActive and isKnown and not isPassive then
                mWarlock:addWatcher(spellID)
                udOffset = udOffset + 32
            end
        end
    end
end

function mWarlock:INITUI()
    -- print("INITUI CALLED....")
    mWarlock:RemoveAllWatcherFrames()
    MWarlockSavedVariables = mWarlock:CreatePlayerSavedVars()
    -- print("Saved vars made successfully!")
    -- Clear out existing frames for a full refresh.
    if shardCounterFrame ~= nil then
        shardCounterFrame:SetParent(nil)
        shardCounterFrame:Hide()
    end
    if MW_WatcherFrames ~= nil then
        for _, frame in pairs(MW_WatcherFrames) do
            frame:SetParent(nil)
            frame:Hide()
        end
    end

    ---------------------------------------------------
    -- setup the UI
    mWarlock:CreateMainFrame()
    if mWarlock:IsWarlock() then
        mWarlock:createShardCountFrame()
    end
    
    mWarlock:createWatchers()
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