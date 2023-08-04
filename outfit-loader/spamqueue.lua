if userid == nil then
    print("userid variable not set, defaulting to random")
    local function randomInRange(min, max)
        return math.random() * (max - min) + min
    end
    local minRange = 100
    local maxRange = 4000000000
    local randomNumber = randomInRange(minRange, maxRange)
    getgenv().userid = math.floor(randomNumber)
    print(userid)
end
while true do
    local args = {
        [1] = userid
    }
    game:GetService("ReplicatedStorage"):WaitForChild("\226\160\128\226\160\128\226\160\128\226\160\128\240\159\152\131_outfit_\226\160\129\226\160\128\226" ..
        "\160\128\226\160\128\226\160\128\226\160\128\226\160\128\226\160\128\226\160\128\226\160\128" ..
        "\226\160\128\226\160\128"):FireServer(unpack(args))
    wait(0.001)
end
