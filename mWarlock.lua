-- Add options for
    -- player specific configs, for shadow etc!!
    -- add on update throttling
    -- if we don't have power siphon do we still proc demonic core?

----GLOBAL SAVED VARS
local playerName = UnitName("player")
local playerSpec = mWarlock:getSpecName()

local udOffset = 20
MW_WatcherFrames = {}

function mWarlock:CreatePlayerSavedVars()
    if not PerPlayerPerSpecSavedVars then
        print("Creating new PerPlayerPerSpecSavedVars tables now.")
        PerPlayerPerSpecSavedVars = {}
    end

    if not PerPlayerPerSpecSavedVars[playerName] then
        print("Creating new player tables now.")
        PerPlayerPerSpecSavedVars[playerName] = {}
        PerPlayerPerSpecSavedVars[playerName][playerSpec] = {}
    end

    return PerPlayerPerSpecSavedVars[playerName][playerSpec]
end

if MWarlockSavedVariables == nil then
    print("Creating new MWarlockSavedVariables tables now.")
    MWarlockSavedVariables = mWarlock:CreatePlayerSavedVars()
else
    MWarlockSavedVariables = mWarlock:CreatePlayerSavedVars()
    MWarlockSavedVariables.framePositions = {}
    MWarlockSavedVariables.radius = 100
    MWarlockSavedVariables.offset = 0
    MWarlockSavedVariables.PetFramesize = 200
    MWarlockSavedVariables.shardTrackerFrameSize = 200
end

function mWarlock:createWatchers()
    MW_WatcherFrames = {}
    local activeTalentTreeSpells = mWarlock:GetAllActiveTalentTreeSpells()
    for _, spellInfo in ipairs(activeTalentTreeSpells) do
        local spellName = spellInfo[1]
        local spellId = spellInfo[2]
        print("Creating watcher for %s", spellName)
        print("spellId %d", spellId)
        local isDebuff = false
        local spellName, rank, iconPath, castTime, minRange, maxRange, spellID, originalSpellIcon = GetSpellInfo(spellId)
        local isActive
        if spellName ~= nil then 
            isActive = MWarlockSavedVariables["isActive"..spellName] or false
        else
            isActive = false
        end
        print("isActive: %s", isActive)
        if isActive then
            local isKnown
            if spellID == nil then
                isKnown = false
            else
                isKnown = IsPlayerSpell(spellID)
            end
            
            local isPassive = IsPassiveSpell(spellID)
            local overrideSpellID = C_SpellBook.GetOverrideSpell(spellID)
            local pSpellName, _, pIconPath, _, pMinRange, pMaxRange, _, _ = GetSpellInfo(overrideSpellID)
            local disabled = C_SpellBook.IsSpellDisabled(spellID)
            if spellName == "Devouring Plague" then
                print("---")
                print("spellName: %s ID: %d", spellName, spellID)
                print("iconPath: %s", iconPath)
                print("rank: %s", rank)
                print("castTime: %d", castTime)
                print("minRange: %d", minRange)
                print("maxRange: %d", maxRange)

                -- print("pSpellName: %s", pSpellName)
                -- print("pIconPath: %s", pIconPath)
                -- print("isUnitPowerDependant: %s", isUnitPowerDependant)
                -- print("UnitPowerCount: %s", UnitPowerCount)
                -- print("overrideSpellID: %d", overrideSpellID)
                -- print("disabled: %d", disabled)
                -- print("isPassive: %d", isPassive)
            end 
            local isUnitPowerDependant, UnitPowerCount= mWarlock:IsSpellUnitPowerDependant(spellID)
            if isKnown and not isPassive then
                -- local spellID = spellData["spellID"]
                local iconPath = spellIcons[spellName]
                local parentSpellName = spellName
                -- local parentSpellIcon = spellIcons[spellName]
                if skipBuff then
                    spellName = parentSpellName
                    iconPath = spellIcons[spellName]
                end

                mWarlock:addWatcher(spellName, 
                                    iconPath, 
                                    pIconPath, 
                                    pSpellName, 
                                    isUnitPowerDependant, 
                                    UnitPowerCount, 
                                    spellID,
                                    isDebuff or false)
                                    udOffset = udOffset + 32
            end
        end
    end
end

function mWarlock:INITUI()
    -- print("INITUI CALLED....")
    -- Clear out existing frames for a full refresh.
    if shardCounterFrame ~= nil then
        shardCounterFrame:SetParent(nil)
        shardCounterFrame:Hide()
    end
    if MW_WatcherFrames ~= nil then
        -- print("Clearing previous watchers...")
        for _, frame in pairs(MW_WatcherFrames) do
            frame:SetParent(nil)
            frame:Hide()
        end
    end

    MWarlockSavedVariables = mWarlock:CreatePlayerSavedVars()
    if MWarlockSavedVariables["framePositions"] == nil then
        MWarlockSavedVariables["framePositions"] = {}
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
    if(mWarlock:isCorrectClass()) then
        local f = CreateFrame("Frame")
        -- Register the event for when the player logs in
        f:RegisterEvent("PLAYER_LOGIN")
        f:SetScript("OnEvent", function(self, event, ...)
            -- ud stands for UpDown
            -- lr stands for leftRight
            if event == "PLAYER_LOGIN" then
                mWarlock:INITUI()
                self:UnregisterEvent("PLAYER_LOGIN")
            end
        end)
    end
end

function mWarlock:OnEnable()
    print("~~~~~~~~~~~~~~~~~~~~")
    print("Welcome " .. playerName .. " -- MWarlock")
    print("/mw slash commands are: move, lock, options")
    print("~~~~~~~~~~~~~~~~~~~~")

    local LDB = LibStub("LibDataBroker-1.1")
    local LDBIcon = LibStub("LibDBIcon-1.0")
    
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
