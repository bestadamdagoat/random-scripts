while true do
    local args = {
        [1] = "Extra Hard"
    }
    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("ObbyClaim"):InvokeServer(unpack(args))
    local args = {
        [1] = "Hard"
    }
    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("ObbyClaim"):InvokeServer(unpack(args))
    local args = {
        [1] = "Medium"
    }
    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("ObbyClaim"):InvokeServer(unpack(args))
    local args = {
        [1] = "Easy"
    }
    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("ObbyClaim"):InvokeServer(unpack(args))
    wait(60)
end
