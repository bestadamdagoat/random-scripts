while true do
    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Merge"):InvokeServer()
    wait(0.001)
end
