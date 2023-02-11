-- slash commands
SLASH_MW1 = "/mw"
mainFrameIsMoving = false

function MW_slashCommands(msg, editbox)
    local command, rest = msg:match("^(%S*)%s*(.-)$")
	command = string.lower(command)

    if command == "move" then
        mWarlock:setMovable(true)
    end
    
    if command == "lock" then
        mWarlock:setMovable(false)
    end
    
    if command == "radius" then
        MWarlockSavedVariables.radius = tonumber(rest)
        radialButtonLayout()
    end
    
    if command == "offset" then
        MWarlockSavedVariables.offset = tonumber(rest)
        radialButtonLayout()
    end

    if command == "fgfs" then
        MWarlockSavedVariables.felguardFrameSize = tonumber(rest)
        -- ReloadUI()
        mWarlock:setFelguardFramesSize()
    end

    if command == "options" then
        mWarlock:OptionsPane()
    end
end
SlashCmdList["MW"] = MW_slashCommands
