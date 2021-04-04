--|| SERVICES ||--
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local RunService = game:GetService("RunService")
--|| MODULES ||--
local BuildManagerComponentModule = require(script:WaitForChild("BuildManagerComponent"))
ContextActionService:BindAction("SwitchBuild", BuildManagerComponentModule.SwitchBuild, true, Enum.KeyCode.C, Enum.KeyCode.Q, Enum.KeyCode.V, Enum.KeyCode.F)
ContextActionService:BindAction("ToggleBuildMode", BuildManagerComponentModule.ToggleBuildMode, true, Enum.KeyCode.H)
RunService.RenderStepped:Connect(function()
	if BuildManagerComponentModule.isBuilding then
		local BuildComponentPosition = BuildManagerComponentModule.GetNextBuildPosition()
		local BuildComponentRotation = BuildManagerComponentModule.GetNextBuildRotation()
		
		--[[if BuildManagerComponentModule.SelectedBuild == "Wall" then
			BuildManagerComponentModule.currentbuild.CFrame = CFrame.new(BuildComponentPosition) * CFrame.Angles(BuildComponentRotation.X,BuildComponentRotation.Y,BuildComponentRotation.Z)
		elseif BuildManagerComponentModule.SelectedBuild == "Floor" then
			BuildManagerComponentModule.currentbuild.CFrame = CFrame.new(BuildComponentPosition) * CFrame.new(0,0,-(BuildManagerComponentModule.GridSize/2))
		elseif BuildManagerComponentModule.SelectedBuild == "Ramp" then
			BuildManagerComponentModule.currentbuild.CFrame = CFrame.new(BuildComponentPosition) * CFrame.Angles(BuildComponentRotation.X, BuildComponentRotation.Y, BuildComponentRotation.Z)
		end
		BuildManagerComponentModule.currentbuild.Parent = workspace:FindFirstChild("Folder "..game.Players.LocalPlayer.Name)]]
	else
		--if BuildManagerComponentModule.currentbuild == nil then return end
		--BuildManagerComponentModule.currentbuild.Parent = game.ReplicatedStorage
	end
end)
