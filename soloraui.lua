local Players = game:GetService("Players")

local localPlayer = Players.LocalPlayer

local function CreateBillboard(character, player)
	local rootPart = character:WaitForChild("HumanoidRootPart")

	if rootPart:FindFirstChild("PlayerBillboard") then
		return
	end

	local billboardgui = Instance.new("BillboardGui")
	billboardgui.Name = "PlayerBillboard"
	billboardgui.Size = UDim2.new(2.5, 0, 5, 0)
	billboardgui.AlwaysOnTop = true
	billboardgui.Parent = rootPart

	local frame = Instance.new("Frame")
	frame.Name = "Frame"
	frame.Size = UDim2.new(1, 0, 0.8, 0)
	frame.Position = UDim2.new(0, 0, 0.2, 0)
	frame.BackgroundTransparency = 1
	frame.Parent = billboardgui

	local uistroke = Instance.new("UIStroke")
	uistroke.Name = "UIStroke"
	uistroke.Thickness = 2
	uistroke.Color = Color3.fromRGB(255, 255, 255)
	uistroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	uistroke.Parent = frame
end

local function RemoveBillboards()
	for _, player in ipairs(Players:GetPlayers()) do
		if player.Character then
			local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
			if rootPart then
				local billboard = rootPart:FindFirstChild("PlayerBillboard")
				if billboard then
					billboard:Destroy()
				end
			end
		end
	end
end

local mgui = Instance.new("ScreenGui")
mgui.Name = "mainGui"
mgui.ResetOnSpawn = false
mgui.Parent = localPlayer:WaitForChild("PlayerGui")

local mframe = Instance.new("Frame")
mframe.Size = UDim2.new(0.5, 0, 0.7, 0)
mframe.AnchorPoint = Vector2.new(0.5, 0.5)
mframe.Position = UDim2.new(0.5, 0, 0.5, 0)
mframe.Name = "espframe"
mframe.Parent = mgui

local scrollingframeesp = Instance.new("ScrollingFrame")
scrollingframeesp.Size = UDim2.new(0.8, 0, 0.7, 0)
scrollingframeesp.AnchorPoint = Vector2.new(0.5, 0.5)
scrollingframeesp.Position = UDim2.new(0.6, 0, 0.5, 0)
scrollingframeesp.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollingframeesp.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollingframeesp.ScrollBarThickness = 6
scrollingframeesp.Parent = mframe

local muilist = Instance.new("UIListLayout")
muilist.Name = "mainuilist"
muilist.Padding = UDim.new(0, 5)
muilist.Parent = scrollingframeesp

local enableespb = Instance.new("TextButton")
enableespb.Name = "espbutton"
enableespb.Size = UDim2.new(0.9, 0, 0, 40)
enableespb.Text = "ESP: OFF"
enableespb.Parent = scrollingframeesp

local enabledistanceespb = Instance.new("TextButton")
enabledistanceespb.Name = "espdistancebutton"
enabledistanceespb.Size = UDim2.new(0.9, 0, 0, 40)
enabledistanceespb.Text = "Distance: OFF"
enabledistanceespb.Parent = scrollingframeesp

local enablenameespb = Instance.new("TextButton")
enablenameespb.Name = "espnamebutton"
enablenameespb.Size = UDim2.new(0.9, 0, 0, 40)
enablenameespb.Text = "Name: OFF"
enablenameespb.Parent = scrollingframeesp

local loadedvalue = Instance.new("BoolValue")
loadedvalue.Name = "isloaded"
loadedvalue.Value = false
loadedvalue.Parent = enableespb

local enablevalue = Instance.new("BoolValue")
enablevalue.Name = "isenabled"
enablevalue.Value = false
enablevalue.Parent = enableespb

local distanceEnableValue = Instance.new("BoolValue")
distanceEnableValue.Name = "denabled"
distanceEnableValue.Value = false
distanceEnableValue.Parent = enabledistanceespb

local nameEnableValue = Instance.new("BoolValue")
nameEnableValue.Name = "nenabled"
nameEnableValue.Value = false
nameEnableValue.Parent = enablenameespb

local function LoadESP()
	if loadedvalue.Value == true then
		return
	end

	loadedvalue.Value = true

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= localPlayer then
			player.CharacterAdded:Connect(function(character)
				if enablevalue.Value == true then
					CreateBillboard(character, player)
				end
			end)
		end
	end

	Players.PlayerAdded:Connect(function(player)
		if player ~= localPlayer then
			player.CharacterAdded:Connect(function(character)
				if enablevalue.Value == true then
					CreateBillboard(character, player)
				end
			end)
		end
	end)
end

local function ToggleESP()
	LoadESP()

	enablevalue.Value = not enablevalue.Value

	if enablevalue.Value == true then
		enableespb.Text = "ESP: ON"

		for _, player in ipairs(Players:GetPlayers()) do
			if player ~= localPlayer and player.Character then
				CreateBillboard(player.Character, player)
			end
		end
	else
		enableespb.Text = "ESP: OFF"
		RemoveBillboards()
	end
end

local function ToggleDistance()
		distanceEnableValue.Value = not distanceEnableValue.Value

	if distanceEnableValue.Value == true and enablevalue.Value == false then
		ToggleESP()
	end

	if distanceEnableValue.Value == true then
		enabledistanceespb.Text = "Distance: ON"
	else
		enabledistanceespb.Text = "Distance: OFF"
	end

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= localPlayer and player.Character then
			local rootPart = player.Character:FindFirstChild("HumanoidRootPart")

			if rootPart then
				local billboard = rootPart:FindFirstChild("PlayerBillboard")

				if billboard then
					local frame = billboard:FindFirstChild("Frame")

					if frame then
						local oldLabel = frame:FindFirstChild("distancelabel")

						if distanceEnableValue.Value == false then
							if oldLabel then
								oldLabel:Destroy()
							end
						else
							if not oldLabel then
								local distancebox = Instance.new("TextLabel")
								distancebox.Name = "distancelabel"
								distancebox.BackgroundTransparency = 1
								distancebox.TextScaled = true
								distancebox.Size = UDim2.new(1, 0, 0.2, 0)
								distancebox.TextColor3 = Color3.fromRGB(255, 0, 0)
								distancebox.Text = "..."
								distancebox.Parent = frame

								task.spawn(function()
									while distancebox.Parent and distanceEnableValue.Value == true do
										task.wait(0.2)

										local myCharacter = localPlayer.Character
										local targetCharacter = player.Character

										if myCharacter and targetCharacter then
											local myRoot = myCharacter:FindFirstChild("HumanoidRootPart")
											local targetRoot = targetCharacter:FindFirstChild("HumanoidRootPart")

											if myRoot and targetRoot then
												local distance = (myRoot.Position - targetRoot.Position).Magnitude
												distancebox.Text = math.floor(distance) .. " studs"
											end
										end
									end
								end)
							end
						end
					end
				end
			end
		end
	end
end

local function ToggleName()
	nameEnableValue.Value = not nameEnableValue.Value

	if nameEnableValue.Value == true and enablevalue.Value == false then
		ToggleESP()
	end

	if nameEnableValue.Value == true then
		enablenameespb.Text = "Name: ON"
	else
		enablenameespb.Text = "Name: OFF"
	end

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= localPlayer and player.Character then
			local rootPart = player.Character:FindFirstChild("HumanoidRootPart")

			if rootPart then
				local billboard = rootPart:FindFirstChild("PlayerBillboard")

				if billboard then
					local frame = billboard:FindFirstChild("Frame")

					if frame then
						local oldLabel = frame:FindFirstChild("namelabel")

						if nameEnableValue.Value == false then
							if oldLabel then
								oldLabel:Destroy()
							end
						else
							if not oldLabel then
								local namebox = Instance.new("TextLabel")
								namebox.Name = "namelabel"
								namebox.BackgroundTransparency = 1
								namebox.TextScaled = true
								namebox.Size = UDim2.new(1, 0, 0.2, 0)

								-- Offset above the frame
								namebox.Position = UDim2.new(0, 0, -0.25, 0)

								namebox.TextColor3 = Color3.fromRGB(255, 255, 255)
								namebox.TextStrokeTransparency = 0
								namebox.Text = player.Name
								namebox.Parent = frame
							end
						end
					end
				end
			end
		end
	end
end

enableespb.MouseButton1Click:Connect(ToggleESP)
enabledistanceespb.MouseButton1Click:Connect(ToggleDistance)
enablenameespb.MouseButton1Click:Connect(ToggleName)
