function mRadial:CopyFramesFromSpec(specNum)
    local playerName = UnitName("player")
    local playerSpec = GetSpecialization()
    local srcFramePosData = PerPlayerPerSpecSavedVars[playerName][specNum]["framePositions"]
    local destFramePosData = PerPlayerPerSpecSavedVars[playerName][playerSpec]["framePositions"]

    local srcPetAbilitesToIgnore = PerPlayerPerSpecSavedVars[playerName][specNum]["hidePetAbilities"]
    PerPlayerPerSpecSavedVars[playerName][playerSpec]["hidePetAbilities"] = srcPetAbilitesToIgnore

    for frameName, framePositionData in pairs(srcFramePosData) do
        destFramePosData[frameName] = framePositionData
    end
    mRadial:ForceUpdateAllMoveableFramePositions()
end

function mRadial:CopyDimensionsFromSpec(specNum)
    local playerName = UnitName("player")
    local playerSpec = GetSpecialization()
    -- radiusMult, watcherFrameSize, centerBelow
    -- radial1: radius, spread, offset, widthDeform, heightDeform
    -- radial2: radius2, spread2, offset2, widthDeform2, heightDeform2
    -- fonts: 
    local options = {}
    options[1] = {"radius", DEFAULT_RADIUS}
    options[2] = {"spread", MR_DEFAULT_SPREAD}
    options[3] = {"offset", MR_DEFAULT_OFFSET}
    options[4] = {"widthDeform", MR_DEFAULT_WIDTH}
    options[5] = {"heightDeform", MR_DEFAULT_HEIGHT}
    options[6] = {"radius2", DEFAULT_RADIUS}
    options[7] = {"spread2", MR_DEFAULT_SPREAD}
    options[8] = {"offset2", MR_DEFAULT_OFFSET}
    options[9] = {"widthDeform2", MR_DEFAULT_WIDTH}
    options[10] = {"heightDeform2", MR_DEFAULT_HEIGHT}
    options[11] = {"radiusMult", MR_DEFAULT_RADIUSMULT}
    options[12] = {"watcherFrameSize", MR_DEFAULT_WATCHERFRAMESIZE}
    options[13] = {"centerBelow", MR_DEFAULT_CENTERBELOW}
    options[14] = {"autoSpread", MR_DEFAULT_AUTOSPREAD}
    options[15] = {"asbuttons", MR_DEFAULT_ASBUTTONS}
    options[16] = {"hideSecondary", MR_DEFAULT_HIDESECONDARY}

    for _, optionData in ipairs(options) do
        local optionName = optionData[1]
        local optionDefault = optionData[2]
        local src = PerPlayerPerSpecSavedVars[playerName][specNum][optionName]
        if src == nil then src = optionDefault end
        PerPlayerPerSpecSavedVars[playerName][playerSpec][optionName] = src
        MRadialSavedVariables[optionName] = src
    end
    mRadial:UpdateUI(false)
end

function mRadial:CopyFontFromSpec(specNum)
    local playerName = UnitName("player")
    local playerSpec = GetSpecialization()
    -- radiusMult, watcherFrameSize, centerBelow
    -- radial1: radius, spread, offset, widthDeform, heightDeform
    -- radial2: radius2, spread2, offset2, widthDeform2, heightDeform2
    -- fonts: 
    local options = {}
    options[1] = {"Font", MR_DEFAULT_FONT}
    options[2] = {"FontPercentage", MR_DEFAULT_FONTPERCENTAGE}
    options[3] = {"radialUdOffset", MR_DEFAULT_UDOFFSET}
    options[4] = {"radialLROffset", MR_DEFAULT_LROFFSET}
    options[5] = {"buffColor", {.1, 1, .1, 1}}
    options[6] = {"timerFontSize", MR_DEFAULT_FONTSIZE}
    options[7] = {"cdUdOffset", MR_DEFAULT_CDUDOFFSET}
    options[8] = {"cdLROffset", MR_DEFAULT_CDLROFFSET}
    options[9] = {"cdColor", {.1, 1, .1, 1}}
    options[10] = {"coolDownFontSize", MR_DEFAULT_FONTBIGGERSIZE}
    options[11] = {"readyUDOffset", MR_DEFAULT_READYUDOFFSET}
    options[12] = {"readyLROffset", MR_DEFAULT_READYLROFFSET}
    options[13] = {"readyColor", {.1, 1, .1, 1}}
    options[14] = {"readyFontSize", MR_DEFAULT_FONTBIGGERSIZE}
    options[15] = {"countUdOffset", MR_DEFAULT_COUNTUDOFFSET}
    options[16] = {"countLROffset", MR_DEFAULT_COUNTLROFFSET}
    options[17] = {"countColor", {0, 1, 1, 1}}
    options[18] = {"countFontSize", MR_DEFAULT_FONTSIZE}
    options[19] = {"debuffUdOffset", MR_DEFAULT_DEBUFFUDOFFSET}
    options[20] = {"debuffLROffset", MR_DEFAULT_DEBUFFLROFFSET}
    options[21] = {"debuffColor", {0, 1, 1, 1}}
    options[22] = {"debuffFontSize", MR_DEFAULT_FONTSIZE}
    options[23] = {"powerTextEnabled", MR_DEFAULT_POWERENABLED}
    
    options[24] = {"powerTextEnabled", MR_DEFAULT_POWERENABLED}
    options[25] = {"powerPersistsEnabled", MR_DEFAULT_POWERPERSISTS}
    options[26] = {"powerUdOffset", MR_DEFAULT_POWERUDOFFSET}
    options[27] = {"powerLROffset", MR_DEFAULT_POWERLROFFSET}
    options[28] = {"powerColor", {.3, .2, .5, 1}}
    options[29] = {"powerFontSize", MR_DEFAULT_FONTSIZE}

    for _, optionData in ipairs(options) do
        local optionName = optionData[1]
        local optionDefault = optionData[2]
        local src = PerPlayerPerSpecSavedVars[playerName][specNum][optionName]
        if src == nil then src = optionDefault end
        PerPlayerPerSpecSavedVars[playerName][playerSpec][optionName] = src
        MRadialSavedVariables[optionName] = src
    end
    mRadial:UpdateUI(false)
end