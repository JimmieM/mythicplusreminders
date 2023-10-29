local frame = CreateFrame("Frame")
local sentMessages = {}  -- Table to track sent messages
local updateInterval = 3.0  -- Interval in seconds
local timeSinceLastUpdate = 0  -- Time tracker

local dungeons = {
    {
        dungeon = "The Underrot", -- TESTING
        say = "Say this",
        enemies = {
            {name = "Elder Leaxa", say = "this is what i need to say for enemy1"},
            {name = "Cragmaw the Infested", say = "this is what i need to say for enemy2"}
        }
    },
    {
        dungeon = "Brackenhide Hollow", -- TESTING
        say = "Use CD's for 2nd Killing Spree on first boss pls",
        enemies = {
            {name = "Hackclaw's War-Band", say = "Personal CD's 2nd Killing Spree!"},
        }
    },
}

local function allGroupMembersInInstance()
    if not IsInGroup() then return true end  -- Player is not in a group, so they can send messages

    local numMembers = GetNumGroupMembers()
    if numMembers <= 1 then return true end  -- Player is alone in the group

    for i = 1, numMembers - 1 do
        local unit = "party" .. i
        local inInstance = UnitInInstance(unit)
        if not inInstance then
            return false  -- At least one other member is not in the instance
        end
    end

    return true
end

local function sendMessage(message, messageType, dungeon)
    if allGroupMembersInInstance() then
        if not sentMessages[dungeon] then
            sentMessages[dungeon] = {}
        end
        if IsInGroup() then
            SendChatMessage(message, "PARTY")
        else
            SendChatMessage(message, "SAY")
        end
        sentMessages[dungeon][messageType] = true
    end
end

local currentDungeon = GetZoneText()  -- Store the initial dungeon

frame:SetScript("OnUpdate", function(self, elapsed)
    if not C_ChallengeMode.IsChallengeModeActive() then return end
    
    timeSinceLastUpdate = timeSinceLastUpdate + elapsed

    if timeSinceLastUpdate >= updateInterval then
        local newDungeon = GetZoneText()

        -- Reset sent messages if dungeon changes
        if currentDungeon ~= newDungeon then
            sentMessages = {}
            currentDungeon = newDungeon
        end

        for _, dungeonData in ipairs(dungeons) do
            if dungeonData.dungeon == currentDungeon then
                -- Send the initial dungeon message if not sent
                if dungeonData.say and (not sentMessages[currentDungeon] or not sentMessages[currentDungeon]["initial"]) then
                    sendMessage(dungeonData.say, "initial", currentDungeon)
                    return  -- Exit after sending to prevent multiple messages in one update
                end

                if CheckInteractDistance("target", 1) then
                    for _, enemyData in ipairs(dungeonData.enemies) do
                        if UnitName("target") == enemyData.name and (not sentMessages[currentDungeon] or not sentMessages[currentDungeon][enemyData.name]) then
                            sendMessage(enemyData.say, enemyData.name, currentDungeon)
                            return  -- Exit after sending to prevent multiple messages in one update
                        end
                    end
                end
            end
        end

        timeSinceLastUpdate = 0  -- Reset the timer
    end
end)