if not MWarlockSavedVariables then
    MWarlockSavedVariables = {}
end
MWarlockSavedVariables.radius = 100
MWarlockSavedVariables.framePositions = {}

local function isCorrectClass()
    local playerClass = UnitClass("player")
    -- Check if the player's class is "Warlock"
    if playerClass == "Warlock" then
        print("~~~~~~~~~~~~~~~~~")
        print("Welcome to MWarlock!")
        print("~~~~~~~~~~~~~~~~~")
        return true
    end
    return false
end

local function isCorrectSpec()
    -- Check if player has selected demonology as their spec
    local spec = GetSpecialization()
    if spec ~= 2 then
        return false
    end
    return true
end

-- felguard pet abilities 
felstormSpellName = "Felstorm"

rootIconPath ="Interface/ICONS"
mediaPath = "Interface\\AddOns\\mWarlock\\media\\"

local function checkDemonologyTalentTree()
    for spellName, _ in pairs(dt_specialisationData) do
        local name, _, _, _, _, _, _, _ = GetSpellInfo(spellName)
        if name then
            dt_specialisationData[spellName]["active"] = true
        end
    end
end

-- slash commands
SLASH_MW1 = "/mw"

function MW_slashCommands(msg, editbox)
    local command, rest = msg:match("^(%S*)%s*(.-)$")
	command = string.lower(command)

    if command == "move" then
        MWarlockMainFrame:EnableMouse(true)

        MWarlockMainFrame:SetScript("OnMouseDown", function(self, button)
            if IsShiftKeyDown() and button == "LeftButton" then
                MWarlockMainFrame:SetMovable(true)
                self:StartMoving()
            end
        end)
        
        MWarlockMainFrame:SetScript("OnMouseUp", function(self, button)
            self:StopMovingOrSizing()
        end)
    end
    
    if command == "lock" then
        MWarlockMainFrame:EnableMouse(false)
        MWarlockMainFrame:SetMovable(false)
    end
    
    if command == "radius" then
        print("Changed radius to: %d", tonumber(rest))
        MWarlockSavedVariables.radius = tonumber(rest)
        -- ReloadUI()
        radialButtonLayout()
    end
end
SlashCmdList["MW"] = MW_slashCommands

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

            -- Note this can become spec based atm only supporting DEMO!
            createHandofGuldanFrame()
            createFelguardFrames()
            ---------------------------------------------------
            if(isCorrectSpec)then
                -- SUPPORTING ONLY DEMO ATM.
                checkDemonologyTalentTree()
                spellOrder = dt_spellOrder
                specData = dt_specialisationData
                
                --- ADD ALL THE WATCHER FRAMES NOW
                local lrOffset = 75
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
                                        lrOffset, 
                                        udOffset, 
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
                radialButtonLayout()
            end
        end
    end)     
end
