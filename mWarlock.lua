-- Add options for
    -- player specific configs, for shadow etc!!
    -- add on update throttling
    -- if we don't have power siphon do we still proc demonic core?

----GLOBAL SAVED VARS
local playerName = UnitName("player")
local playerSpec = mWarlock:getSpecName()

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
    MWarlockSavedVariables.PetFramesize = 35
    MWarlockSavedVariables.shardTrackerFrameSize = 128
end



local udOffset = 20
function mWarlock:createWatchers(spellOrder, activeSpellData)
    for spellName, spellInfo in pairs(spellOrder) do
        local skipBuff, buffName, isShardDependant, isDebuff = unpack(spellInfo)
        -- print("Seaching for %s ", spellName)
        local spellData = activeSpellData[spellName]
        -- print("spellData %s ", spellData)
        if spellData ~= nil then
            local spellID = spellData["spellID"]
            local iconPath = spellIcons[buffName]
            local parentSpellName = spellName
            local parentSpellIcon = spellIcons[spellName]
            if skipBuff then
                buffName = parentSpellName
                iconPath = spellIcons[spellName]
            end
            -- print("---")
            -- print("spellName: %s", spellName)
            -- print("spellID: %s", spellID)
            -- print("skipBuff: %s", skipBuff)
            -- print("buffName: %s", buffName)
            -- print("iconPath: %s", iconPath)
            -- print("parentSpellIcon: %s", parentSpellIcon)
            -- print("parentSpellName: %s", parentSpellName)
            -- print("isShardDependant: %s", isShardDependant)
            -- print("---")
            mWarlock:addWatcher(buffName, 
                                iconPath, 
                                parentSpellIcon, 
                                parentSpellName, 
                                skipBuff, 
                                isShardDependant, 
                                spellID,
                                isDebuff or false)
                                udOffset = udOffset + 32
        end
    end
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
                MWarlockSavedVariables = mWarlock:CreatePlayerSavedVars()
                if MWarlockSavedVariables["framePositions"] == nil then
                    MWarlockSavedVariables["framePositions"] = {}
                end

                local spellOrder, activeSpellData = mWarlock:syncSpec()
                ---------------------------------------------------
                -- setup the UI
                mWarlock:CreateMainFrame()
                if mWarlock:IsWarlock() then
                    mWarlock:createShardCountFrame()
                end
                ---------------------------------------------------
                
                mWarlock:createWatchers(spellOrder, activeSpellData)
                mWarlock:radialButtonLayout()
                
                mWarlock:createPetFrames()
                
                self:UnregisterEvent("PLAYER_LOGIN")
                mWarlock:SetUIMovable(false)
                mWarlock:shardtrack()
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
