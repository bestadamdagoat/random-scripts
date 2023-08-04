if true then
    print("DO NOT USE, CURRENTLY BANS YOU")
    return
end

local player = game.Players.LocalPlayer
local humanoidRootPart

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
    wait(1)
    local nearestPlayer = findNearestPlayerWithLineOfSight()
    if nearestPlayer then
        local nearestUsername = nearestPlayer and nearestPlayer.Name
        local nearestDisplayName = nearestPlayer.DisplayName
        print("Nearest player Display Name: " .. nearestDisplayName)
        local args = {
            [1] = game:GetService("Players"):WaitForChild(nearestUsername)
        }
        game:GetService("ReplicatedStorage"):WaitForChild("_objects"):WaitForChild("Tools"):WaitForChild("Hammer"):WaitForChild("Hit"):FireServer(unpack(args))
    else
        print("No player nearby")
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
