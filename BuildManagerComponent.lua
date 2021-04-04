local BuildManagerComponent = {}
--|| MODULE SETTINGS ||--
BuildManagerComponent.GridSize = 16
BuildManagerComponent.BuildDistance = 2
--|| MODULE VARIABLES ||--
BuildManagerComponent.isBuilding = false
BuildManagerComponent.SelectedBuild = "Wall"
--|| PRIVATE FUNCTIONS ||--
function GridSnap(value, size)
	return (math.floor(value / size + 0.5) * size)
end
--|| MODULE FUNCTIONS ||--
function BuildManagerComponent.GetNextBuildPosition(HumanoidRootPartPosition, MouseLookVector3)
	local DirectionVector3 = MouseLookVector3 * BuildManagerComponent.BuildDistance
	DirectionVector3 += HumanoidRootPartPosition
	return Vector3.new(
		GridSnap(DirectionVector3.X, BuildManagerComponent.GridSize), 
		GridSnap(DirectionVector3.Y, BuildManagerComponent.GridSize) + BuildManagerComponent.GridSize/2 ,
		GridSnap(DirectionVector3.Z, BuildManagerComponent.GridSize)
	)
end
function BuildManagerComponent.GetNextBuildRotation(Vector)
	if(typeof(Vector) == "Vector3") then
		local y = math.atan2(Vector.X, Vector.Z)
		return Vector3.new(0,GridSnap(y, math.rad(-90)), 0)
	end
end
function BuildManagerComponent.ToggleBuildMode(ActionName, InputState, InputObject)
	if ActionName == "ToggleBuild" then
		if InputState == Enum.UserInputState.Begin then
			BuildManagerComponent.isBuilding = not BuildManagerComponent.isBuilding
			warn("Toggle Build Mode: ", BuildManagerComponent.isBuilding)
		end
	end
end
function BuildManagerComponent.SwitchBuild(ActionName, InputState, InputObject)
	if ActionName == "SwitchBuild" then
		if InputState == Enum.UserInputState.Begin then
			InputObject.isBuilding = true
			if BuildManagerComponent.isBuilding then
				if InputObject.KeyCode == Enum.KeyCode.Q then
					BuildManagerComponent.SelectedBuild = "Wall"
				elseif InputObject.KeyCode == Enum.KeyCode.C then
					BuildManagerComponent.SelectedBuild = "Floor"
				elseif InputObject.KeyCode == Enum.KeyCode.V then
					BuildManagerComponent.SelectedBuild = "Ramp"
				--elseif InputObject.KeyCode == Enum.KeyCode.F then
					--BuildManagerComponent.SelectedBuild = "Cone"
				end
			end
		end
	end
end
return BuildManagerComponent
