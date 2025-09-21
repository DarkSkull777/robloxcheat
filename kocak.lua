while true do
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(player.Character.HumanoidRootPart.CFrame)
            wait(0.5)
        end
    end
end
