local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local originalCFrame
local teleporting = false
local loopConnection

local function ensureCharacter()
    return LocalPlayer and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
end

local function startTeleportLoop()
    if not ensureCharacter() then return end
    originalCFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
    teleporting = true
    loopConnection = RunService.Heartbeat:Connect(function()
        for _, player in pairs(Players:GetPlayers()) do
            if not teleporting then break end
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character:SetPrimaryPartCFrame(player.Character.HumanoidRootPart.CFrame)
                task.wait(0.5)
            end
        end
    end)
end

local function stopTeleportLoop()
    teleporting = false
    if loopConnection then
        loopConnection:Disconnect()
        loopConnection = nil
    end
    if originalCFrame and ensureCharacter() then
        LocalPlayer.Character:SetPrimaryPartCFrame(originalCFrame)
        originalCFrame = nil
    end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.F2 then
        if teleporting then
            stopTeleportLoop()
        else
            startTeleportLoop()
        end
    end
end)

Players.PlayerRemoving:Connect(function(p)
    if teleporting and p == LocalPlayer then
        stopTeleportLoop()
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    if teleporting and originalCFrame then
        task.wait(0.5)
        if ensureCharacter() then
            LocalPlayer.Character:SetPrimaryPartCFrame(originalCFrame)
        end
    end
end)
