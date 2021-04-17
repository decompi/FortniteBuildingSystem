--|| SERVICES ||--
local ReplicatedStorage = game:GetService("ReplicatedStorage")
--|| FOLDERS ||--
local BuildingEventsFolder = ReplicatedStorage:WaitForChild("BuildingEvents")
--|| REMOTE EVENTS ||--
local PlaceBuildEvent = BuildingEventsFolder:WaitForChild("PlaceBuild")
--|| EVENTS ||--
PlaceBuildEvent.OnServerEvent:Connect(function(Player, BuildName, BuildPosition, BuildRotation)
	local BuildComponent = script:FindFirstChild(BuildName)
	if BuildComponent then
		BuildComponent = BuildComponent:Clone()
		BuildComponent.Parent = workspace:FindFirstChild("Builds") or workspace
		BuildComponent.Position = BuildPosition
		BuildComponent.Orientation = BuildRotation
		BuildComponent.Anchored = true
		BuildComponent.CanCollide = true
	end
end)
