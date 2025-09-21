local player = game.Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TeleportGui"
ScreenGui.Parent = PlayerGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local Frame = Instance.new("Frame")
Frame.Name = "MainFrame"
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Frame.Position = UDim2.new(0.3, 0, 0.4, 0)
Frame.Size = UDim2.new(0, 200, 0, 160)
Frame.Active = true
Frame.Draggable = true
Frame.Visible = false -- Disembunyikan dulu

local UICorner = Instance.new("UICorner", Frame)
local UIStroke = Instance.new("UIStroke", Frame)
UIStroke.Thickness = 2
UIStroke.Color = Color3.fromRGB(255, 255, 255)

local minimizeButton = Instance.new("TextButton")
minimizeButton.Name = "MinimizeButton"
minimizeButton.Parent = Frame
minimizeButton.BackgroundTransparency = 1
minimizeButton.Size = UDim2.new(0, 25, 0, 25)
minimizeButton.Position = UDim2.new(1, -30, 0, 5)
minimizeButton.Text = "⤵️"
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.TextScaled = true
minimizeButton.ZIndex = 2

local launcherButton = Instance.new("TextButton")
launcherButton.Name = "LauncherButton"
launcherButton.Parent = ScreenGui
launcherButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
launcherButton.Position = UDim2.new(1, -60, 1, -60)
launcherButton.Size = UDim2.new(0, 50, 0, 50)
launcherButton.Text = "😹"
launcherButton.Font = Enum.Font.GothamBold
launcherButton.TextColor3 = Color3.fromRGB(255, 255, 255)
launcherButton.TextScaled = true

local launcherCorner = Instance.new("UICorner", launcherButton)

local function createButton(name, text, posY)
	local btn = Instance.new("TextButton")
	btn.Name = name
	btn.Parent = Frame
	btn.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
	btn.Position = UDim2.new(0, 10, 0, posY)
	btn.Size = UDim2.new(1, -20, 0, 40)
	btn.Font = Enum.Font.GothamBold
	btn.Text = text
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.TextScaled = true
	Instance.new("UICorner", btn)
	return btn
end

local loopButton = createButton("LoopTeleport", "1. Loop Teleport All", 35)
local backButton = createButton("GoBack", "2. Go Back to Save", 85)
local saveButton = createButton("SavePosition", "3. Save This Position", 135)

local teleporting = false
local savedCFrame = nil

local function startTeleportLoop()
	if teleporting then return end
	teleporting = true

	coroutine.wrap(function()
		while teleporting do
			for _, player in pairs(game.Players:GetPlayers()) do
				if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
					local myChar = game.Players.LocalPlayer.Character
					if myChar and myChar:FindFirstChild("HumanoidRootPart") then
						myChar:SetPrimaryPartCFrame(player.Character.HumanoidRootPart.CFrame)
						wait(0.5)
					end
				end
			end
		end
	end)()
end

local function savePosition()
	local char = game.Players.LocalPlayer.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		savedCFrame = char.HumanoidRootPart.CFrame
		print("Position saved.")
	end
end

local function goBack()
	if savedCFrame then
		teleporting = false
		wait(0.2)
		local char = game.Players.LocalPlayer.Character
		if char and char:FindFirstChild("HumanoidRootPart") then
			char:SetPrimaryPartCFrame(savedCFrame)
			print("Returned to saved position.")
		end
	else
		warn("No position saved yet.")
	end
end

loopButton.MouseButton1Click:Connect(startTeleportLoop)
saveButton.MouseButton1Click:Connect(savePosition)
backButton.MouseButton1Click:Connect(goBack)

minimizeButton.MouseButton1Click:Connect(function()
	Frame.Visible = false
	launcherButton.Visible = true
end)

launcherButton.MouseButton1Click:Connect(function()
	Frame.Visible = true
	launcherButton.Visible = false
end)
