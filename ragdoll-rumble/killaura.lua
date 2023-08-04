local player = game.Players.LocalPlayer
local humanoidRootPart
local remotePath = game:GetService("ReplicatedStorage")._objects.Tools.Hammer
local ignoredRemotes = {"Hit"}
local lastExecutionTime = 0

local function findRemoteInPath(path)
    for _, descendant in ipairs(path:GetDescendants()) do
        if descendant:IsA("RemoteEvent") or descendant:IsA("RemoteFunction") then
            local isIgnored = false
            for _, ignoredName in ipairs(ignoredRemotes) do
                if descendant.Name == ignoredName then
                    isIgnored = true
                    break
                end
            end

            if not isIgnored then
                return descendant
            end
        end
    end
end

local remote = findRemoteInPath(remotePath)
if remote then
    print("Found remote:", remote.Name)
else
    print("No valid remote found in the specified path.")
end

local function distance(pos1, pos2)
    return (pos1 - pos2).magnitude
end

local function hasLineOfSight(origin, destination)
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Blacklist
    rayParams.FilterDescendantsInstances = {player.Character, destination.Parent}

    local raycastResult = game.Workspace:Raycast(origin, destination.Position - origin, rayParams)
    return not raycastResult
end

local function findNearestPlayerWithLineOfSight()
    local players = game.Players:GetPlayers()
    local nearestPlayer, minDistance = nil, math.huge
    
    for _, otherPlayer in ipairs(players) do
        if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local otherHumanoidRootPart = otherPlayer.Character.HumanoidRootPart
            local distanceToPlayer = distance(humanoidRootPart.Position, otherHumanoidRootPart.Position)
            
            if distanceToPlayer < minDistance and hasLineOfSight(humanoidRootPart.Position, otherHumanoidRootPart) then
                nearestPlayer = otherPlayer
                minDistance = distanceToPlayer
            end
        end
    end
    
    return nearestPlayer
end

local function updateNearestPlayer()
    wait(0.00001)
    local currentTime = tick()
    if currentTime - lastExecutionTime >= 0.3 then
        lastExecutionTime = currentTime

        local nearestPlayer = findNearestPlayerWithLineOfSight()
        if nearestPlayer then
            local nearestUsername = nearestPlayer and nearestPlayer.Name
            local nearestDisplayName = nearestPlayer.DisplayName
            print("Nearest player Display Name: " .. nearestDisplayName)
            local args = {
                [1] = game:GetService("Players"):WaitForChild(nearestUsername)
            }
            remote:FireServer(unpack(args))
        else
            print("No player nearby")
        end
    end
end

local function onCharacterAdded(character)
    humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    heartbeatConnection = game:GetService("RunService").Heartbeat:Connect(updateNearestPlayer)
end

local function onCharacterRemoved()
    if heartbeatConnection then
        heartbeatConnection:Disconnect()
    end
    humanoidRootPart = nil
end

player.CharacterAdded:Connect(onCharacterAdded)
player.CharacterRemoving:Connect(onCharacterRemoved)

if player.Character then
    onCharacterAdded(player.Character)
end
