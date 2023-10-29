
if not MythicPlusBossWarningsDB then
    MythicPlusBossWarningsDB = {}
end

-- Create the main frame
local UIFrame = CreateFrame("Frame", "UIFrame", UIParent, "BasicFrameTemplate")
-- ... (rest of the UIFrame setup)

UIFrame:Hide()

local SLASH_MPBW1 = "/mpbw"
SlashCmdList["MPBW"] = function(msg)
    print("Slash command triggered!")  -- Debug print
    if UIFrame:IsShown() then
        print("UIFrame is currently shown. Hiding now.")  -- Debug print
        UIFrame:Hide()
    else
        print("UIFrame is currently hidden. Showing now.")  -- Debug print
        UIFrame:Show()
    end
end


UIFrame:SetSize(400, 600)
UIFrame:SetPoint("CENTER")
UIFrame:SetMovable(true)
UIFrame:EnableMouse(true)
UIFrame:RegisterForDrag("LeftButton")
UIFrame:SetScript("OnDragStart", UIFrame.StartMoving)
UIFrame:SetScript("OnDragStop", UIFrame.StopMovingOrSizing)
UIFrame.Title:SetText("Dungeon Reminder Addon")

-- Dungeon name input
local dungeonName = CreateFrame("EditBox", nil, UIFrame, "InputBoxTemplate")
dungeonName:SetSize(250, 30)
dungeonName:SetPoint("TOPLEFT", 50, -50)
dungeonName:SetAutoFocus(false)

local enemyInputs = {}
local messageInputs = {}

local function addEnemyInput()
    local enemyInput = CreateFrame("EditBox", nil, UIFrame, "InputBoxTemplate")
    enemyInput:SetSize(250, 30)
    enemyInput:SetAutoFocus(false)
    if #enemyInputs == 0 then
        enemyInput:SetPoint("TOPLEFT", 50, -90)
    else
        enemyInput:SetPoint("TOP", enemyInputs[#enemyInputs], "BOTTOM", 0, -10)
    end
    table.insert(enemyInputs, enemyInput)

    local messageInput = CreateFrame("EditBox", nil, UIFrame, "InputBoxTemplate")
    messageInput:SetSize(250, 30)
    messageInput:SetAutoFocus(false)
    messageInput:SetPoint("TOP", enemyInput, "BOTTOM", 0, -10)
    table.insert(messageInputs, messageInput)
end

-- Add enemy/message pair button
local addPairButton = CreateFrame("Button", nil, UIFrame, "GameMenuButtonTemplate")
addPairButton:SetPoint("TOPLEFT", 50, -170)
addPairButton:SetSize(180, 30)
addPairButton:SetText("Add Enemy & Message")
addPairButton:SetScript("OnClick", function()
    addEnemyInput()
end)

-- Button to save the data
local saveButton = CreateFrame("Button", nil, UIFrame, "GameMenuButtonTemplate")
saveButton:SetPoint("TOPLEFT", 50, -210)
saveButton:SetSize(140, 40)
saveButton:SetText("Save Reminders")
saveButton:SetScript("OnClick", function()
    local dungeon = dungeonName:GetText()
    local enemies = {}
    for i, enemyInput in ipairs(enemyInputs) do
        table.insert(enemies, {
            name = enemyInput:GetText(),
            message = messageInputs[i]:GetText()
        })
    end
    MythicPlusBossWarningsDB[dungeon] = enemies
end)

UIFrame:Hide()

