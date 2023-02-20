-- Add options for
    -- add on update throttling
    -- if we don't have power siphon do we still proc demonic core?

----GLOBAL SAVED VARS
if not MWarlockSavedVariables then
    MWarlockSavedVariables = {}
end
MWarlockSavedVariables.framePositions = {}
MWarlockSavedVariables.radius = 100
MWarlockSavedVariables.offset = 0
MWarlockSavedVariables.PetFramesize = 35
MWarlockSavedVariables.shardTrackerFrameSize = 128
----
if MWarlockSavedVariables.framePositions == nil then
    MWarlockSavedVariables.framePositions = {}
end

local udOffset = 20
function mWarlock:createWatchers(specData, spellOrder)
    for spellName, spellID in pairs(spellOrder) do
        local spellData = specData[spellName]
        if spellData["active"] then
            local iconPath = spellData["iconPath"]
            local buffName = spellData["buffName"]
            local parentSpellIcon = spellData["parentSpellIcon"]
            local parentSpellName = spellData["parentSpellName"]
            local skipBuff = spellData["skipBuff"]
            local isShardDependant = spellData["isShardDependant"]
            -- print("spellName: %s", spellName)
            -- print("spellID: %s", spellID)
            -- print("iconPath: %s", iconPath)
            -- print("buffName: %s", buffName)
            -- print("parentSpellIcon: %s", parentSpellIcon)
            -- print("parentSpellName: %s", parentSpellName)
            -- print("skipBuff: %s", skipBuff)
            -- print("isShardDependant: %s", isShardDependant)
            -- print("---")
            mWarlock:addWatcher(buffName, 
                        iconPath, 
                        parentSpellIcon, 
                        parentSpellName, 
                        skipBuff, 
                        isShardDependant, 
                        spellID)
            udOffset = udOffset + 32
        end
    end
end

function mWarlock:OnInitialize()
    -- mWarlock:CreateConfigPanels()
    if(mWarlock:isCorrectClass()) then
        local f = CreateFrame("Frame")
        -- Register the event for when the player logs in
        f:RegisterEvent("PLAYER_LOGIN")
        f:SetScript("OnEvent", function(self, event, ...)
            -- ud stands for UpDown
            -- lr stands for leftRight
            if event == "PLAYER_LOGIN" then
                print("~~~~~~~~~~~~~~~~~~~~")
                print("  !Welcome to MWarlock!")
                print("/mw slash commands are: move, lock, options")
                print("~~~~~~~~~~~~~~~~~~~~")
                ---------------------------------------------------
                -- setup the UI
                mWarlock:CreateMainFrame()
                mWarlock:createShardCountFrame()
                ---------------------------------------------------
                local spellOrder, specData = mWarlock:SyncSpec()
                mWarlock:createWatchers(specData, spellOrder)
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
