if doscript == nil then
    print("doscript variable not set, auto setting to true")
    getgenv().doscript = true
end
while doscript == true do
    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("BuyDropper"):InvokeServer()
    wait(0.001)
end
