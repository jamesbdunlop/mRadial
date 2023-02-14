----GLOBAL SAVED VARS
if not MWarlockSavedVariables then
    MWarlockSavedVariables = {}
end
MWarlockSavedVariables.framePositions = {}
MWarlockSavedVariables.radius = 100
MWarlockSavedVariables.offset = 0
MWarlockSavedVariables.felguardFrameSize = 35
MWarlockSavedVariables.shardTrackerFrameSize = 128
----
if MWarlockSavedVariables.framePositions == nil then
    MWarlockSavedVariables.framePositions = {}
end

function mWarlock:createWatchers(specData, spellOrder)
--- ADD ALL THE WATCHER FRAMES NOW
    for i, orderName in ipairs(spellOrder) do
        for buffName, data in pairs(specData) do
            if orderName == buffName and data["active"] then
                --buffName, lr, ud, iconPath, parentSpellIcon, parentSpellName, skipBuff, isShardDependant
                local iconPath = data["iconPath"]
                local spellname = data["spellName"]
                if spellname ~= nil then
                    buffName = spellname
                end
                
                local parentSpellIcon = data["parentSpellIcon"]
                local parentSpellName = data["parentSpellName"]
                local skipBuff = data["skipBuff"]
                local isShardDependant = data["isShardDependant"]
                mWarlock:addWatcher(buffName, 
                            iconPath, 
                            parentSpellIcon, 
                            parentSpellName, 
                            skipBuff, 
                            isShardDependant)
                udOffset = udOffset + 32
            end
        end
    end
end

local blizzPanel
local registered = false

function mWarlock:CreateConfigPanels()
	mw_config:RegisterOptionsTable("mWarlock", mw_aboutOptions)
	local aboutFrame = mw_dialog:AddToBlizOptions("mWarlock", "mWarlock")
	if not registered then
        blizzPanel = mw_createBlizzOptions()
		registered = true
	end
end

udOffset = 20
function mWarlock:OnInitialize()
    mWarlock:CreateConfigPanels()

    if(mWarlock:isCorrectClass()) then
        local f = CreateFrame("Frame")
        -- Register the event for when the player logs in
        f:RegisterEvent("PLAYER_LOGIN")
        f:SetScript("OnEvent", function(self, event, ...)
            -- ud stands for UpDown
            -- lr stands for leftRight
            if event == "PLAYER_LOGIN" then
                ---------------------------------------------------
                -- setup the UI
                mWarlock:createMainFrame()
                mWarlock:createShardCountFrame()
                ---------------------------------------------------
                if (mWarlock:isCorrectSpec()) then
                    -- SUPPORTING ONLY DEMO ATM.
                    mWarlock:syncDemonologyTalentTree()
                    
                    spellOrder = demo_spellOrder
                    specData = demTree_specialisationData
                    
                    mWarlock:createWatchers(specData, spellOrder)
                    mWarlock:radialButtonLayout()
                    
                    -- Note this can become spec based atm only supporting DEMO!
                    mWarlock:createHandofGuldanFrame()
                    mWarlock:createFelguardFrames()
                end
                self:UnregisterEvent("PLAYER_LOGIN")
            end
        end)
    end
end

function mWarlock:OnEnable()
    -- Called when the addon is enabled
    print("mWarlock enabled!")
end

function mWarlock:OnDisable()
    -- Called when the addon is disabled
    print("mWarlock disabled!")
end
