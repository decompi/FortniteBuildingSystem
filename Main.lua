--|| SERVICES ||--
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
--|| MODULES ||--
local BuildManagerComponentModule = require(script:WaitForChild("BuildManagerComponent"))
--|| VARIABLES ||--
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local CharacterModel = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = CharacterModel:WaitForChild("HumanoidRootPart")
--|| FOLDERS ||--
local BuildMeshesFolder = script:WaitForChild("BuildMeshes")
local PreviewFolder = BuildMeshesFolder:WaitForChild("Preview")
--|| SETTINGS ||--
local BuildingMeshes = {
	["Wall"] = PreviewFolder:WaitForChild("Wall"),
	["Floor"] = PreviewFolder:WaitForChild("Floor"),
	["Ramp"] = PreviewFolder:WaitForChild("Ramp"),
}
local CFrameAddOns = {
	["Wall"] = CFrame.new(0,0,(BuildManagerComponentModule.GridSize/2)),
	["Ramp"] = CFrame.new(0,0,0),
	["Floor"] = CFrame.new(Vector3.new(0,-BuildManagerComponentModule.GridSize/2,0))
}
--|| PRIVATE FUNCTIONS ||--
local function ResetPreviewParents(Mesh)
	for _,BuildMesh in pairs(BuildingMeshes) do
		if BuildMesh ~= Mesh and BuildMesh.Parent ~= PreviewFolder then
			BuildMesh.Parent = PreviewFolder
		end
	end
end
--|| ACTIONS ||--
ContextActionService:BindAction("SwitchBuild", BuildManagerComponentModule.SwitchBuild, true, Enum.KeyCode.Q, Enum.KeyCode.C, Enum.KeyCode.V) -- The KeyCodes for the keybinds
ContextActionService:BindAction("ToggleBuild", BuildManagerComponentModule.ToggleBuildMode, true, Enum.KeyCode.H)
--|| EVENTS ||--
UserInputService.InputBegan:Connect(function(InputObject, GameProcessed)
	if GameProcessed then return end
	if(InputObject.UserInputType == Enum.UserInputType.MouseButton1) then
		BuildManagerComponentModule.PlaceBuild(BuildingMeshes[BuildManagerComponentModule.SelectedBuild], BuildManagerComponentModule.SelectedBuild)
	end
end)
RunService.RenderStepped:Connect(function()
	if(BuildManagerComponentModule.isBuilding) then
		local BuildComponentPosition = BuildManagerComponentModule.GetNextBuildPosition(HumanoidRootPart.Position, Mouse.Hit.LookVector)
		local BuildComponentRotation = BuildManagerComponentModule.GetNextBuildRotation(Mouse.Hit.LookVector)
		
		local BuildComponent = BuildingMeshes[BuildManagerComponentModule.SelectedBuild]
		ResetPreviewParents(BuildComponent)
		BuildComponent.Parent = workspace:FindFirstChild("Builds") or workspace
		BuildComponent.CFrame = CFrame.new(BuildComponentPosition) * CFrame.Angles(BuildComponentRotation.X,BuildComponentRotation.Y,BuildComponentRotation.Z) * CFrameAddOns[BuildManagerComponentModule.SelectedBuild]
		
	else
		ResetPreviewParents()
	end
end)
