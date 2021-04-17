local BuildManagerComponent = {}
--|| MODULE SETTINGS ||--
BuildManagerComponent.GridSize = 16
BuildManagerComponent.BuildDistance = 2
--|| MODULE VARIABLES ||--
BuildManagerComponent.isBuilding = false
BuildManagerComponent.SelectedBuild = "Wall"
--|| TABLES & DICTIONARIES ||--
local BuildingKeybinds = {
	[Enum.KeyCode.Q] = "Wall",
	[Enum.KeyCode.C] = "Floor",
	[Enum.KeyCode.V] = "Ramp"
}
--|| SERVICES ||--
local ReplicatedStorage = game:GetService("ReplicatedStorage")
--|| FOLDERS ||--
local BuildingEventsFolder = ReplicatedStorage:WaitForChild("BuildingEvents")
--|| REMOTE EVENTS ||--
local PlaceBuildEvent = BuildingEventsFolder:WaitForChild("PlaceBuild")
--|| PRIVATE FUNCTIONS ||--
local function GridSnap(Value, Size)
	return (math.floor(Value/Size + 0.5) * Size)
end
local function GetTouchingParts(Part)
	local Connection = Part.Touched:Connect(function() end)
	local Results = Part:GetTouchingParts()
	Connection:Disconnect()
	return Results
end
--|| MODULE FUNCTIONS ||--
function BuildManagerComponent.GetNextBuildPosition(HumanoidRootPartPosition, MouseLookVector3)
	local DirectionVector3 = MouseLookVector3 * BuildManagerComponent.BuildDistance
	DirectionVector3 += HumanoidRootPartPosition
	return Vector3.new(
		GridSnap(DirectionVector3.X, BuildManagerComponent.GridSize),
		GridSnap(DirectionVector3.Y, BuildManagerComponent.GridSize) + BuildManagerComponent.GridSize/2,
		GridSnap(DirectionVector3.Z, BuildManagerComponent.GridSize)
	)
end
function BuildManagerComponent.GetNextBuildRotation(Vector)
	if(typeof(Vector) == "Vector3") then
		local Y = math.atan2(Vector.X, Vector.Z)
		return Vector3.new(0,GridSnap(Y, math.rad(-90)), 0)
	end
end
--|| TOGGLE BUILDING ||--
function BuildManagerComponent.ToggleBuildMode(ActionName, InputState, InputObject)
	if ActionName == "ToggleBuild" then
		if InputState == Enum.UserInputState.Begin then
			BuildManagerComponent.isBuilding = not BuildManagerComponent.isBuilding
			warn("Toggled Build Mode: ", BuildManagerComponent.isBuilding)
		end
	end
end
--|| SWITCH TO A DIFFERENT BUILD( Ramp, Wall, Floor, Etc) ||--
function BuildManagerComponent.SwitchBuild(ActionName, InputState, InputObject)
	if(ActionName == "SwitchBuild") then
		if(InputState == Enum.UserInputState.Begin) then
			BuildManagerComponent.isBuilding = true
			if(BuildManagerComponent.isBuilding and BuildingKeybinds[InputObject.KeyCode]) then
				BuildManagerComponent.SelectedBuild = BuildingKeybinds[InputObject.KeyCode]
			end
		end
	end
end
function BuildManagerComponent.PlaceBuild(BuildMesh, BuildName)
	if(BuildManagerComponent.isBuilding) then
		local Results = GetTouchingParts(BuildMesh)
		local Placeable = true
		for _, Build in pairs(Results) do
			if Build.Name == BuildMesh.Name then
				if Build.Position == BuildMesh.Position then
					Placeable = false
				end
			end
		end
		if(Placeable) then
			PlaceBuildEvent:FireServer(BuildName, BuildMesh.Position, BuildMesh.Orientation)
		end
	end
end
return BuildManagerComponent
