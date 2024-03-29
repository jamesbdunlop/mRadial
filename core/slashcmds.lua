-- slash commands
SLASH_MR1 = "/mr"

---------------------------------------------------------------------------------------------------
function MR_slashCommands(msg, editbox)
    local command, rest = msg:match("^(%S*)%s*(.-)$")
	command = string.lower(command)

    if command == "move" then
        mRadial:SetUIMovable(true)
    end
    
    if command == "lock" then
        mRadial:SetUIMovable(false)
    end
    
    if command == "options" then
        mRadial:OptionsPane()
    end

    if command == "disableooc" then
        MRadialSavedVariables["fadeooc"] = false
        mRadial:InitUI(false)
    end

    if command == "enableooc" then
        MRadialSavedVariables["fadeooc"] = true
        mRadial:InitUI(false)
    end
end
SlashCmdList["MR"] = MR_slashCommands
---------------------------------------------------------------------------------------------------
