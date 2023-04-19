local mRadial = mRadial
local AceGUI = LibStub("AceGUI-3.0")

function mRadial:GetAuraTimeLeft(expirationTime)
    if expirationTime == nil then
        return nil
    end
    local timeLeft = expirationTime - GetTime()
    local minutes = math.floor(timeLeft / 60)
    local seconds = math.floor(timeLeft - minutes * 60)
    return minutes, seconds
end

function mRadial:HasActiveBuff(buffName)
    for i = 1, 40 do
        local name, _, scount, _, _, _, _, _, _, _, _, spellID = UnitBuff("player", i)
        if name and name == buffName then
            return true, scount
        end
    end
    return false, 0
end

function mRadial:IsSpellUnitPowerDependant(spellID)
    local costInfo = GetSpellPowerCost(spellID)
    if costInfo[1] ~= nil then
        if costInfo[1]["name"] ~= "MANA" then
            return costInfo[1]["name"], costInfo[1]["minCost"]
        else
            return false, 0
        end
    end
    return false, 0
end

function mRadial:CheckHasSpell(spellName)
    local name, _, _, _, _, _, _, _ = GetSpellInfo(spellName)
    if name then
        return true
    else
        return false
    end
end

function mRadial:IsWarlock()
    return UnitClass("player") == "Warlock"
end

function mRadial:GetSpecName()
    local currentSpec = GetSpecialization()
    local currentSpecName = currentSpec and select(2, GetSpecializationInfo(currentSpec))
    return currentSpecName
end

function mRadial:TableContains(myTable, value)
    for _, v in ipairs(myTable) do
        if v[1] == value[1] then
            return true
        end
    end

    return false
end

function mRadial:OrderTableContains(myTable, watcher)
    for _, v in ipairs(myTable) do
        if v.spellName == watcher.spellName then
            return true
        end
    end

    return false
end

function mRadial:GetAllSpells(activeTable)
    local spellData = {}
    --- Trawl the entire spell book for spells.
    --- Sick of trying to figure out the most important! Going to leave this up to the user.
    local numTabs = GetNumSpellTabs()
    for i=2,numTabs do
        local name, _, offset, numSpells = GetSpellTabInfo(i)
        -- print("name: %s", name)
        if name == mRadial:GetSpecName() or name == UnitClass("player") then
            for x=offset+1, offset + numSpells do
                local spellName, rank, icon, castingTime, minRange, maxRange, spellID, originalIcon = GetSpellInfo(x, "spell")
                -- SOME WEIRD BUG WITH SHADOWFURY the names don't match??! Yet you print it and it's the same fkin name!
                if spellID == 30283 then
                    spellName = SHADOWFURY_SPELLNAME
                end
                if spellName and spellID then
                    if not mRadial:TableContains(activeTable, {spellName, spellID}) then
                        table.insert(activeTable, {spellName, spellID})
                    end
                end
    end end end
    return spellData
end
 
function mRadial:GetTalentTreeSpellIDList()
    local list = {}

    local configID = C_ClassTalents.GetActiveConfigID()
    if configID == nil then return end

    local configInfo = C_Traits.GetConfigInfo(configID)
    if configInfo == nil then return end

    for _, treeID in ipairs(configInfo.treeIDs) do -- in the context of talent trees, there is only 1 treeID
        local nodes = C_Traits.GetTreeNodes(treeID)
        for i, nodeID in ipairs(nodes) do
            local nodeInfo = C_Traits.GetNodeInfo(configID, nodeID)
            for _, entryID in ipairs(nodeInfo.entryIDs) do -- each node can have multiple entries (e.g. choice nodes have 2)
                local entryInfo = C_Traits.GetEntryInfo(configID, entryID)
                if entryInfo and entryInfo.definitionID then
                    local definitionInfo = C_Traits.GetDefinitionInfo(entryInfo.definitionID)
                    if definitionInfo.spellID then
                        table.insert(list, definitionInfo.spellID)
                    end
                end
            end
        end
    end
    return list
end

function mRadial:GetAllPassiveTalentTreeSpells()
    local activeSpellData = mRadial:GetTalentTreeSpellIDList()
    local active = {}
    for _, spellID in ipairs(activeSpellData) do
        -- local spellName, skipBuff, buffName, isUnitPowerDependant, UnitPowerCount, isDebuff = unpack(spellInfo)
        local buffName, _, iconPath, _, minRange, maxRange, _, parentSpellIcon = GetSpellInfo(spellID)
        local isKnown
        if spellID == nil then
            isKnown = false
        else
            isKnown = IsPlayerSpell(spellID)
        end
        -- print("Creating watcher for %s", spellName)
        local isPassive = IsPassiveSpell(spellID)
        if isKnown and isPassive and not mRadial:TableContains(active, {buffName, spellID}) then
            table.insert(active, {buffName, spellID})
        end
    end
    return active
end

function mRadial:GetAllActiveTalentTreeSpells()
    -- Parse the active talent tree for active spells, note all passive spells get culled here, if you want passive use 
    -- mRadial:GetAllPassiveTalentTreeSpells()
    local activeSpellData = mRadial:GetTalentTreeSpellIDList()
    -- lower level classes might not have an active talent tree.
    if activeSpellData == nil then
        activeSpellData= {}
    end

    local active = {}
    for _, spellID in ipairs(activeSpellData) do
        local spellName, _, _, _, _, _, _, _ = GetSpellInfo(spellID)
        local isKnown
        if spellID == nil then
            isKnown = false
        else
            isKnown = IsPlayerSpell(spellID)
        end
        
        if isKnown and not mRadial:TableContains(active, {spellName, spellID}) then
            table.insert(active, {spellName, spellID})
        end
    end
    mRadial:GetAllSpells(active)
    return active
end

function mRadial:GetShardCount()
    return  UnitPower("player", 7)
end

function mRadial:HasPetSummoned()
    local summonedPet = UnitCreatureFamily("pet")
    if summonedPet then
      return true, summonedPet
    end

    return false, nil
end

function mRadial:IsFelguardSummoned()
    local isSummoned, summonedPet = mRadial:HasPetSummoned()
    if isSummoned and summonedPet == "Felguard" then
      return true
    end

    return false
end

function mRadial:IsSuccubusSummoned()
    local isSummoned, summonedPet = mRadial:HasPetSummoned()
    if isSummoned and summonedPet == "Succubus" or summonedPet == "Incubus" then
      return true
    end
    
    return false
end

function mRadial:IsFelhunterSummoned()
    local isSummoned, summonedPet = mRadial:HasPetSummoned()
    if isSummoned and summonedPet == "Felhunter" then
      return true
    end
    
    return false
end

function mRadial:IsVoidWalkerSummoned()
    local isSummoned, summonedPet = mRadial:HasPetSummoned()
    if isSummoned and summonedPet == "Voidwalker" then
      return true
    end
    
    return false
end

function mRadial:IsFelImpSummoned()
    local isSummoned, summonedPet = mRadial:HasPetSummoned()
    if isSummoned and summonedPet == "Fel Imp" or summonedPet == "Imp"  then
      return true
    end
    
    return false
end

function mRadial:GlobalFontPercentageChanged()
    -- print("Global font percentage changed!")
    mRadial:UpdateUI(false)
    mRadial:SetPetFramePosAndSize()
end

------------------------------------------------------
--- BAG FUN STUFF
function mRadial:AddItemInfoToTable(itemName, itemInfo, data, ignoreSoulBound)
    local url = "https://www.wowhead.com/item="..itemInfo["itemID"]
    local finalurl = "|Hurl:" ..url .. "|h[" .. itemName .. "]|h"
    local isBound = itemInfo['isBound']
    if not ignoreSoulBound and isBound then
        table.insert(data, {itemName, itemInfo["iconFileID"], finalurl, url, itemInfo["hyperlink"]})
    elseif ignoreSoulBound and isBound then
    else
        table.insert(data, {itemName, itemInfo["iconFileID"], finalurl, url, itemInfo["hyperlink"]})
    end
end

function mRadial:listBagItems(ignoreSoulBound)
    BAGDUMPV1 = {}
    for bag = BACKPACK_CONTAINER, NUM_TOTAL_EQUIPPED_BAG_SLOTS do
        for slot = 1, C_Container.GetContainerNumSlots(bag) do
            local itemLink = C_Container.GetContainerItemLink(bag, slot)
            if itemLink then
                local itemName = GetItemInfo(itemLink)
                local itemInfo = C_Container.GetContainerItemInfo(bag, slot)
                if itemName ~= nil and itemInfo ~= nil then
                    mRadial:AddItemInfoToTable(itemName, itemInfo, BAGDUMPV1, ignoreSoulBound)
                end
            end
        end
    end
    SendSystemMessage("Swapped to player inventory!")
    return BAGDUMPV1
end

function mRadial:listBankItems(ignoreSoulBound)
    BANKDUMPV1 = {}
    -- (You need to be at the bank for bank inventory IDs to return valid results) WTF!
    for bag = 6, 14 do
        for slot = 1, C_Container.GetContainerNumSlots(bag) do
            local itemLink = C_Container.GetContainerItemLink(bag, slot)
            if itemLink then
                local itemName = GetItemInfo(itemLink)
                local itemInfo = C_Container.GetContainerItemInfo(bag, slot)
                if itemName ~= nil and itemInfo ~= nil then
                    mRadial:AddItemInfoToTable(itemName, itemInfo, BANKDUMPV1, ignoreSoulBound)
                end
            end
        end
    end
    SendSystemMessage("Swapped to open bank bags!")
    return BANKDUMPV1
end

function mRadial:listBankReagentItems(ignoreSoulBound)
    BANKRDUMPV1 = {}
    -- (You need to be at the bank for bank inventory IDs to return valid results) WTF!
    for slot = 1, C_Container.GetContainerNumSlots(REAGENTBANK_CONTAINER) do
        local itemLink = C_Container.GetContainerItemLink(REAGENTBANK_CONTAINER, slot)
        if itemLink then
            local itemName = GetItemInfo(itemLink)
            local itemInfo = C_Container.GetContainerItemInfo(REAGENTBANK_CONTAINER, slot)
            if itemName ~= nil and itemInfo ~= nil then
                mRadial:AddItemInfoToTable(itemName, itemInfo, BANKRDUMPV1, ignoreSoulBound)
            end
        end
    end
    SendSystemMessage("Swapped to Bank reagent bag!")
    return BANKRDUMPV1
end

function mRadial:GetFromTable(spellName, activespells)
    for idx, watcher in ipairs(activespells) do
        if watcher.spellName == spellName then
            return watcher
        end
    end
end

------------------------------------------------------
--- SPELL ORDER AND OPTIONS PANE STUFF
function mRadial:PopUpDialog(title, labelText, w, h)
    local AceGUI = LibStub("AceGUI-3.0")
    local frame = AceGUI:Create("Window")
    frame:SetTitle(title)
    frame:SetWidth(w)
    frame:SetHeight(h)

    local layout = AceGUI:Create("SimpleGroup")
    layout:SetLayout("Flow")
    layout:SetFullWidth(true)
    
    local label = AceGUI:Create("Label")
    label:SetText(labelText)
    label:SetFullWidth(true)

    local acceptButton = AceGUI:Create("Button")
    acceptButton:SetText("Accept")
    acceptButton:SetCallback("OnClick", function() return true end)

    local cancelButton = AceGUI:Create("Button")
    cancelButton:SetText("Cancel")
    cancelButton:SetCallback("OnClick", function() return false end)

    frame:AddChild(label)
    layout:AddChild(acceptButton)
    layout:AddChild(cancelButton)
    frame:Hide()
    frame.acceptButton = acceptButton
    frame.cancelButton = cancelButton

    frame:AddChild(layout)
    return frame
end

function mRadial:WrapText(str)
    if str == nil then
        return ""
    end

    local result = ""
    local line = ""
    for word in str:gmatch("%S+") do
        if #line + #word >= 40 then
            result = result .. line .. "\n"
            line = ""
        end
        if line == "" then
            line = word
        else
            line = line .. " " .. word
        end
    end
    if line ~= "" then
        result = result .. line
    end
    return result
end

local function UpdateTableOrder(orderTable, srcWatcher, destWatcher, srcIDX, destIDX)
    for idx, _ in ipairs(orderTable) do
        if idx == destIDX then
            orderTable[idx] = srcWatcher
        elseif idx == srcIDX then
            orderTable[idx] = destWatcher
        end
    end
end

function mRadial:BuildOrderLayout(parentFrame, savedVarTable, watcherTable, refreshFunc)
    -- GENERIC Function to create a spellOrder list using the ActionSlot widgets 
    
    -- Release all the current buttons from the UI
    parentFrame:ReleaseChildren()
    -- Now go through and proces the order.
    local recorded_actionData = nil
    local destIDX = -1
    local srcIDX = -1
    local function recordCurrent(this)
        local self = this.obj
        recorded_actionData = self.actionData
    end

    local function changeOrder(this, button, down)
        local self = this.obj
        if button  == "LeftButton" then
            -- stash existing data.
            recordCurrent(this)
            destIDX = self:GetUserData("index")
            -- Grab info from cursor and set new icon for button
            local _, data1, data2 = GetCursorInfo()
            if data1 == nil then
                -- we didn't drag anything.. so move on..
                return
            end

            local _, spellID = GetSpellLink(data1, data2)
            local spellName, _, icon, _, _, _, _, _ = GetSpellInfo(spellID)
            -- update the button data we're "dropping" on
            self.actionType = "spell"
            self.actionData = spellName
            
            local iconPath = MWArtTexturePaths[icon]
            self.icon:SetTexture(iconPath)
            self.icon:Show()
            
            -- reorder src dest now
            local srcWatcher = nil
            local destWatcher = nil
            for idx, watcher in ipairs(savedVarTable) do
                if idx == srcIDX then
                    srcWatcher = watcher
                elseif idx == destIDX then
                    destWatcher = watcher
                end
            end
            UpdateTableOrder(savedVarTable, srcWatcher, destWatcher, srcIDX, destIDX)
            -- cleanup current dragged
            ClearCursor()
            refreshFunc(_, parentFrame)
            mRadial:UpdateUI(true)
        end

        if button == "RightButton" then
            srcIDX = self:GetUserData("index")
            if recorded_actionData == nil then
                return
            end
            if not down then
                local _, _, _, _, _, _, spellID, _ = GetSpellInfo(recorded_actionData)
                PickupSpell(spellID)
            end
        end
    end

    -- first we check to see if the table has a new entry compared to the orig
    local currentOrder = savedVarTable
    -- First time load init
    if currentOrder == nil then
        currentOrder = {}
    end

    -- Add NEW spells clicked active
    for _, watcher in ipairs(watcherTable) do
        local found = mRadial:OrderTableContains(currentOrder, watcher)
        if not found then
            currentOrder[#currentOrder+1] = watcher
        end
    end    

      -- Remove spells no longer in watcherTable
      for idx, watcher in ipairs(currentOrder) do
        local found = mRadial:OrderTableContains(watcherTable, watcher)
        if not found then
            table.remove(currentOrder, idx)
        end
    end  
    if savedVarTable == nil then
        savedVarTable = currentOrder
    end
    for idx, watcher in ipairs(currentOrder) do
        if watcher.isWatcher then
            local orderButton = AceGUI:Create("ActionSlot")
            orderButton:SetWidth(45)
            orderButton.icon:SetTexture(watcher.iconPath)
            orderButton.icon:Show()
            orderButton.actionType = "spell"
            orderButton.actionData = watcher.spellName
            orderButton.button:SetScript('OnClick', changeOrder)
            orderButton.button:SetScript("OnEnter", function(widget, _)
                recordCurrent(widget)
                GameTooltip:SetOwner(orderButton.button, "ANCHOR_CURSOR")
                GameTooltip:SetText(mRadial:WrapText(orderButton.actionData))
                GameTooltip:SetSize(80, 50)
                GameTooltip:SetWidth(80)
                GameTooltip:Show()
            end)

            orderButton.button:SetScript("OnLeave", function() 
                GameTooltip:SetOwner(UIParent, "ANCHOR_BOTTOMRIGHT")
                GameTooltip:SetText("")
                GameTooltip:SetSize(80, 50) 
                GameTooltip:SetWidth(80) 
                GameTooltip:Show()
            end)

            orderButton:SetUserData("index", idx)
            orderButton:SetUserData("watcher", watcher)
            orderButton.button:EnableMouse(true)
            parentFrame:AddChild(orderButton)
        end
    end 

end

function mRadial:BuildRadialOptionsPane(title, isActiveSavedVarStr, funcToExec, parentFrame)
    local checkBoxes = {}
    local spellsOrderFrame = AceGUI:Create("InlineGroup")
    spellsOrderFrame:SetTitle(title) --"Order: (rightClick to pickup, leftClick to swap src->dest.")
    spellsOrderFrame:SetFullWidth(true)
    spellsOrderFrame:SetLayout("Flow")

    local spellsGroup = AceGUI:Create("InlineGroup")
    spellsGroup:SetTitle("Assign Spells To Radial: ")
    spellsGroup:SetFullWidth(true)
    spellsGroup:SetLayout("Flow")

    local activeTalentTreeSpells = mRadial:GetAllActiveTalentTreeSpells()
    local activeSpells = {}
    local passiveSpells = {}
    
    if activeTalentTreeSpells ~= nil then
        for _, spellData in ipairs(activeTalentTreeSpells) do
            -- add a bool flag for each into the saved vars, so we can check against this in the radial menu!
            local spellName = spellData[1]
            local spellID = spellData[2]
            local desc = GetSpellDescription(spellID)
            local isActiveSavedVarStr = isActiveSavedVarStr .. spellName
            if IsPassiveSpell(spellID) then
                table.insert(passiveSpells, {spellsGroup, spellName, desc, isActiveSavedVarStr, false, mRadial.UpdateUI, true, spellID})
            else
                table.insert(activeSpells, {spellsGroup, spellName, desc, isActiveSavedVarStr, false, mRadial.UpdateUI, true, spellID})
            end
        end
    end
    
    -- Create checkboxes now.
    for _, activeSpellData in ipairs(activeSpells) do
        local parentWdg, spellName, desc, isactive, defaultValue, updateUI, descAsTT, spellID = unpack(activeSpellData)
        local cbx = mRadial:CreateAbilityCheckBox(parentWdg, spellName, desc, isactive, defaultValue, updateUI, descAsTT, spellID, funcToExec, spellsOrderFrame)
        table.insert(checkBoxes, cbx)
    end
    for _, passiveSpellData in ipairs(passiveSpells) do
        local parentWdg, spellName, desc, isactive, defaultValue, updateUI, descAsTT, spellID = unpack(passiveSpellData)
        local cbx = mRadial:CreateAbilityCheckBox(parentWdg, spellName, desc, isactive, defaultValue, updateUI, descAsTT, spellID, funcToExec, spellsOrderFrame)
        table.insert(checkBoxes, cbx)
    end

    local resetButton = AceGUI:Create("Button")
    resetButton:SetText("RESET")
    local function resetCheckBoxes() 
        local warning = mRadial:PopUpDialog("WARNING!", "This will reset all selected spells! Continue?", 400, 120)
        warning:Show()
        warning.acceptButton:SetCallback("OnClick", function()  
            for _, cbox in ipairs(checkBoxes) do 
                if cbox:GetValue() then
                    cbox:ToggleChecked()
                    cbox:Fire("OnValueChanged", cbox.checked)
                end
            end
            warning:Hide()
        end)
        warning.cancelButton:SetCallback("OnClick", function() warning:Hide() end)
    end
    resetButton:SetCallback("OnClick", resetCheckBoxes)
    
    parentFrame:AddChild(spellsOrderFrame)
    parentFrame:AddChild(resetButton)
    parentFrame:AddChild(spellsGroup)
    return spellsOrderFrame
end