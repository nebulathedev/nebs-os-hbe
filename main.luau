-- // CONFIGURATION
local Configuration = {
	Limb = "Head",
	Size = 10,
	
	Color = Color3.fromRGB(95, 5, 252),
	Transparency = 0.75,
	Reflectance = 1,
	Material = Enum.Material.ForceField,
	CastShadow = false,
	Shape = Enum.PartType.Block,
	
	RemoveJunk = true,
	WeldToRoot = true,
	RemoveHumanoidTags = true,
	RemoveOnDeath = true,
}

-- // SERVICES & VARIABLES
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local workspace = game:GetService("Workspace")

-- // FUNCTIONS
local Lock = function(O: Instance, P, G)
	O[P] = G
	local LockConnection = O:GetPropertyChangedSignal(P):Connect(function()
		O[P] = G
	end)
end

local WipeDescendants = function(O: Instance, DescendantTable, Continuous)
	local _ = function(Object)
		for Index, Type in pairs(DescendantTable) do
			if Object:IsA(Type) then
				task.defer(Object.Destroy, Object)
			end
		end
	end
	
	for Index, Object in pairs(O:GetDescendants()) do _(Object) end
	if Continuous == true then O.DescendantAdded:Connect(_) end
end

local Analyse = function(Object: BasePart)
	if (Object:IsA("BasePart") and Object.Name == Configuration.Limb) then
		local Humanoid = Object.Parent:FindFirstChildWhichIsA("Humanoid")
		if (Humanoid) then
			if not (Object:FindFirstAncestor(Player.Name)) then
				if not Object:HasTag("Nebula's HBE: TAGGED") then
					Object:AddTag("Nebula's HBE: TAGGED")
					
					Lock(Object, "Size", Vector3.new(Configuration.Size, Configuration.Size, Configuration.Size))
					Lock(Object, "Color", Configuration.Color)
					Lock(Object, "Transparency", Configuration.Transparency)
					Lock(Object, "Reflectance", Configuration.Reflectance)
					Lock(Object, "CastShadow", Configuration.CastShadow)
					Lock(Object, "Material", Configuration.Material)
					if (Object:IsA("Part")) then
						Lock(Object, "Shape", Configuration.Shape)
					end
					Lock(Object, "CanCollide", false)
					Lock(Object, "CanQuery", true)
					Lock(Object, "CanTouch", true)
					Lock(Object, "Locked", false)
					Lock(Object, "Archivable", true)
					Lock(Object, "Massless", true)
					Lock(Object, "CustomPhysicalProperties", PhysicalProperties.new(0.001, 0, 0, 0, 0))
					
					if Configuration.RemoveJunk == true then
						WipeDescendants(Object, {"Decal", "Texture", "Beam", "Trail", "ParticleEmitter", "Sparkles", "Smoke", "Fire", "SurfaceAppearance", "SpecialMesh", "FileMesh", "BlockMesh", "CylinderMesh"})
					end
					
					if Configuration.WeldToRoot == true then
						local Root = Object.Parent:FindFirstChild("HumanoidRootPart")
						if Root then
							for Index, Joint in pairs(Object:GetJoints()) do
								task.defer(Joint.Destroy, Joint)
							end
							local Weld = Instance.new("Weld", Object)
							Weld.Name = "RootJoint"
							Weld.Part0 = Object
							Object.CFrame = Root.CFrame
							Weld.Part1 = Root
						end
					end
					
					if Configuration.RemoveHumanoidTags == true then
						Lock(Humanoid, "DisplayDistanceType", Enum.HumanoidDisplayDistanceType.None)
						Lock(Humanoid, "DisplayName", "")
						Lock(Humanoid, "HealthDisplayDistance", 0)
						Lock(Humanoid, "HealthDisplayType", Enum.HumanoidHealthDisplayType.AlwaysOff)
						Lock(Humanoid, "NameDisplayDistance", 0)
						Lock(Humanoid, "NameOcclusion", Enum.NameOcclusion.OccludeAll)
					end
					
					if Configuration.RemoveOnDeath == true then
						local RemoveHitbox = function()
							task.defer(Object.Destroy, Object)
						end
						
						local HumanoidDied = Humanoid.Died:Connect(RemoveHitbox)
						local HumanoidNil = Humanoid.Destroying:Connect(RemoveHitbox)
					end
					
				end
			end
		end
	end
end

-- // CONNECTIONS & SCRIPT
for Index, Object in pairs(workspace:GetDescendants()) do
	Analyse(Object)
end

local DescendantAdded = workspace.DescendantAdded:Connect(Analyse)
