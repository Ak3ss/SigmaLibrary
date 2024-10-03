local Config = {
	Box               = false,
	BoxOutline        = false,
	BoxColor          = Color3.fromRGB(255,255,255),
	BoxOutlineColor   = Color3.fromRGB(0,0,0),
	Names             = false,
	NamesOutline      = false,
	NamesColor        = Color3.fromRGB(255,255,255),
	NamesOutlineColor = Color3.fromRGB(0,0,0),
	NamesFont         = 2, -- 0,1,2,3
	NamesSize         = 13
}

function CreateEsp(Player)
	local Box,BoxOutline,Name = Drawing.new("Square"),Drawing.new("Square"),Drawing.new("Text")
	local Updater = game:GetService("RunService").RenderStepped:Connect(function()
		for i,v in pairs(game:GetService("Workspace"):GetChildren()) do
			if v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") then
				local Target2dPosition,IsVisible = workspace.CurrentCamera:WorldToViewportPoint(Player.HumanoidRootPart.Position)
				local scale_factor = 1 / (Target2dPosition.Z * math.tan(math.rad(workspace.CurrentCamera.FieldOfView * 0.5)) * 2) * 100
				local width, height = math.floor(40 * scale_factor), math.floor(60 * scale_factor)
				if Config.Box then
					Box.Visible = IsVisible
					Box.Color = Config.BoxColor
					Box.Size = Vector2.new(width,height)
					Box.Position = Vector2.new(Target2dPosition.X - Box.Size.X / 2,Target2dPosition.Y - Box.Size.Y / 2)
					Box.Thickness = 1
					Box.ZIndex = 69
					if Config.BoxOutline then
						BoxOutline.Visible = IsVisible
						BoxOutline.Color = Config.BoxOutlineColor
						BoxOutline.Size = Vector2.new(width,height)
						BoxOutline.Position = Vector2.new(Target2dPosition.X - Box.Size.X / 2,Target2dPosition.Y - Box.Size.Y / 2)
						BoxOutline.Thickness = 3
						BoxOutline.ZIndex = 1
					else
						BoxOutline.Visible = false
					end
				else
					Box.Visible = false
					BoxOutline.Visible = false
				end
				if Config.Names then
					Name.Visible = IsVisible
					Name.Color = Config.NamesColor
					Name.Text = Player.Name.." "..math.floor((workspace.CurrentCamera.CFrame.p - Player.HumanoidRootPart.Position).magnitude).."m"
					Name.Center = true
					Name.Outline = Config.NamesOutline
					Name.OutlineColor = Config.NamesOutlineColor
					Name.Position = Vector2.new(Target2dPosition.X,Target2dPosition.Y - height * 0.5 + -15)
					Name.Font = Config.NamesFont
					Name.Size = Config.NamesSize
				else
					Name.Visible = false
				end
			else
				Box.Visible = false
				BoxOutline.Visible = false
				Name.Visible = false
				if not Player then
					Box:Remove()
					BoxOutline:Remove()
					Name:Remove()
					Updater:Disconnect()
				end
			end
		end
	end)
end

for _,v in pairs(game:GetService("Workspace"):GetChildren()) do
	if v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") then
		CreateEsp(v)
	end
end

game.Workspace.ChildAdded:Connect(function(v)
	CreateEsp(v)
end)
return Config
