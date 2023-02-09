-----
-- TO DO
-- Get a count on Summon SoulKeeper
-- Dead? No Addon visible!! Create a function to hide all, flying/dead/outOfCombat!
-- BG Frame masking scale with...
-----

----GLOBAL SAVED VARS
if not MWarlockSavedVariables then
    MWarlockSavedVariables = {}
end
MWarlockSavedVariables.radius = 100
MWarlockSavedVariables.framePositions = {}
MWarlockSavedVariables.offset = 0
----

felstormSpellName = "Felstorm"
mw_shardFrameName = "mw_shardFrame"
rootIconPath ="Interface/ICONS"
mediaPath = "Interface\\AddOns\\mWarlock\\media\\"

-- slash commands
SLASH_MW1 = "/mw"
mainFrameIsMoving = false

function MW_slashCommands(msg, editbox)
    local command, rest = msg:match("^(%S*)%s*(.-)$")
	command = string.lower(command)

    if command == "move" then
        MWarlockMainFrame:EnableMouse(true)
        shardCounterFrame:EnableMouse(true)

        MWarlockMainFrame:SetScript("OnMouseDown", function(self, button)
            if IsShiftKeyDown() and button == "LeftButton" then
                MWarlockMainFrame:SetMovable(true)
                self:StartMoving()
            end
        end)
        
        MWarlockMainFrame:SetScript("OnMouseUp", function(self, button)
            self:StopMovingOrSizing()
        end)

        shardCounterFrame:SetScript("OnMouseDown", function(self, button)
            if IsShiftKeyDown() and button == "LeftButton" then
                self:StartMoving()
            end
        end)
        
        shardCounterFrame:SetScript("OnMouseUp", function(self, button)
            self:StopMovingOrSizing()
            local point, relativeTo, relativePoint, offsetX, offsetY = shardCounterFrame:GetPoint()
            if MWarlockSavedVariables.framePositions == nil then
                MWarlockSavedVariables.framePositions = {}
            end
            MWarlockSavedVariables.framePositions[mw_shardFrameName] = {}
            MWarlockSavedVariables.framePositions[mw_shardFrameName]["x"] = offsetX
            MWarlockSavedVariables.framePositions[mw_shardFrameName]["y"] = offsetY
        end)

        mainFrameIsMoving = true
        MWarlockMainFrame.tex:SetColorTexture(0, 0, 1, .5)
    end
    
    if command == "lock" then
        MWarlockMainFrame:EnableMouse(false)
        MWarlockMainFrame:SetMovable(false)
        MWarlockMainFrame.tex:SetColorTexture(0, 0, 0, 0)
        mainFrameIsMoving = false
        
        shardCounterFrame:EnableMouse(false)
        shardCounterFrame:SetMovable(false)
    end
    
    if command == "radius" then
        MWarlockSavedVariables.radius = tonumber(rest)
        radialButtonLayout()
    end
    
    if command == "offset" then
        MWarlockSavedVariables.offset = tonumber(rest)
        radialButtonLayout()
    end
end
SlashCmdList["MW"] = MW_slashCommands

function createWatchers(specData, spellOrder)
--- ADD ALL THE WATCHER FRAMES NOW
    for i, orderName in ipairs(spellOrder) do
        for buffName, data in pairs(specData) do
            if orderName == buffName then
                --buffName, lr, ud, iconPath, parentSpellIcon, parentSpellName, skipBuff, isShardDependant
                local active = data["active"]
                if active then
                    local iconPath = data["iconPath"]
                    local spellname = data["spellName"]
                    if spellname ~= nil then
                        buffName = spellname
                    end
                    
                    local parentSpellIcon = data["parentSpellIcon"]
                    local parentSpellName = data["parentSpellName"]
                    local skipBuff = data["skipBuff"]
                    local isShardDependant = data["isShardDependant"]
                    addWatcher(buffName, 
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
end

local function setMainFrameCombatLog()
    
   --Demo specific check for felguard summon
   MWarlockMainFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
   MWarlockMainFrame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")

   MWarlockMainFrame:SetScript("OnEvent", function(self, event, ...)
        -- SHARD TRACKING
       local soulShards = UnitPower("player", 7)
       shardCounterFrame.shardsTex:SetTexture(string.format("%s\\shards_%d.blp", mediaPath, soulShards))
       sscount = string.format("%d", soulShards)
       if soulShards == 0 and not mainFrameIsMoving then
           MWarlockMainFrame.tex:SetColorTexture(1, 0, 0, 0.07) -- red, 10% opacity
       elseif not mainFrameIsMoving then
           MWarlockMainFrame.tex:SetColorTexture(0, 0, 0, 0)
       end

       if soulShards == 2 then
           handOfGText:SetText("!Dread Only!")
       elseif soulShards > 2 then
           handOfGText:SetText("!Hand or Dread!")
       end

       -- TODO move this to the HOG frame!
       local isInCombat = UnitAffectingCombat("player")
       if soulShards <= 1 then
           handOfGText:Hide()

       elseif (soulShards == 5) then
           if isInCombat then
               handOfGText:Show()
           end
       else
           if isInCombat then
               handOfGText:Show()
           end
       end 
       
       -- SHOW FELGUARD FRAMES ON SUMMONS
       if event == "UNIT_SPELLCAST_SUCCEEDED" then
            unitTarget, castGUID, spellID = ...
            if spellID == 30146 then
                print("HAZZZARRRRGGGHHH")
                createFelguardFrames()
                return
            end
       end
       
       if not IsFelguardSummoned() then
           removeFelguardFrames()
       end

    --    if event == "COMBAT_LOG_EVENT_UNFILTERED" then 
    --         local _, subevent, _, sourceGUID, sourceName, _, _, _, destName, destFlags = CombatLogGetCurrentEventInfo()
    --     end
   end)
end

udOffset = 20
if(isCorrectClass())then
    local f = CreateFrame("Frame")
    -- Register the event for when the player logs in
    f:RegisterEvent("PLAYER_LOGIN")
    f:SetScript("OnEvent", function(self, event, ...)
        -- ud stands for UpDown
        -- lr stands for leftRight
        if event == "PLAYER_LOGIN" then
            ---------------------------------------------------
            -- setup the UI
            createMainFrame()
            createShardCountFrame()
            setMainFrameCombatLog()
            ---------------------------------------------------
            if(isCorrectSpec)then
                -- SUPPORTING ONLY DEMO ATM.
                syncDemonologyTalentTree()
                
                spellOrder = mw_spellOrder
                specData = demTree_specialisationData
                
                createWatchers(specData, spellOrder)
                radialButtonLayout()
            end
            
            -- Note this can become spec based atm only supporting DEMO!
            createHandofGuldanFrame()
            createFelguardFrames()
        end
    end)
end
