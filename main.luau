-- CONFIGURATION

local Configuration = {
	-- BASICS
	
	LimbToExpand = "Head", --> What limb should the script expand?
	Size = 10, --> How big will it be, after expanding?
	
	-- CUSTOMIZATION
	
	Color = Color3.new(1, 1, 1),
	Transparency = 0.85,
	Reflectance = 1,
	Material = Enum.Material.ForceField,
	CastShadow = false,
	Shape = Enum.PartType.Block,
	
	-- ADVANCED
	
	DescendantLocation = game, --> Set to "workspace" if only humanoids located in the workspace will get expanded.
	DestroyOnDeath = true, --> Whenever the humanoid dies, destroy the hitbox.
	CentralizePosition = true, --> If true, the hitbox will always be positioned at the rootpart.
	RemoveTags = true, --> If true, remove tags of the humanoids for better visualization.
}

-- VARIABLES

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local Limbs = {}

-- FUNCTIONS

local Lock = function(O: Instance, P: string, G: any)
	O[P] = G
	local LockConnection = O:GetPropertyChangedSignal(P):Connect(function()
		if (O and O ~= nil) then
			O[P] = G
		end
	end)
end

local WipeDescendants = function(O: Instance, DescendantsTable, Continue)
	task.spawn(function()
		local Analyse = function(Object)
			for Index, Type in pairs(DescendantsTable) do
				if (Object:IsA(Type)) then
					task.defer(Object.Destroy, Object)
				end
			end
		end
		for Index, Object in pairs(O:GetDescendants()) do Analyse(Object) end 
		if Continue == true then
			local DescendantAdded = O.DescendantAdded:Connect(Analyse)
		end
	end)
end

-- SCRIPT

local Analyse = function(Object)
	if (Object:IsA("BasePart") and Object.Name == Configuration.LimbToExpand) then
		if not (Object:FindFirstAncestor(Player.Name)) then
			local Character = Object.Parent
			if (Character and Character ~= nil) then
				local Humanoid = Character:FindFirstChildWhichIsA("Humanoid")
				if (Humanoid and Humanoid ~= nil) then
					
					if (Configuration.RemoveTags == true) then
						Lock(Humanoid, "DisplayDistanceType", Enum.HumanoidDisplayDistanceType.None)
						Lock(Humanoid, "DisplayName", "")
						Lock(Humanoid, "HealthDisplayDistance", 0)
						Lock(Humanoid, "HealthDisplayType", Enum.HumanoidHealthDisplayType.AlwaysOff)
						Lock(Humanoid, "NameDisplayDistance", 0)
						Lock(Humanoid, "NameOcclusion", Enum.NameOcclusion.OccludeAll)
					end
					
					Lock(Object, "Size", Vector3.new(Configuration.Size, Configuration.Size, Configuration.Size))
					Lock(Object, "Color", Configuration.Color)
					Lock(Object, "Transparency", Configuration.Transparency)
					Lock(Object, "Reflectance", Configuration.Reflectance)
					Lock(Object, "Material", Configuration.Material)
					Lock(Object, "CastShadow", Configuration.CastShadow)
					if (Object:IsA("Part")) then
						Lock(Object, "Shape", Configuration.Shape)
					end
					Lock(Object, "CanCollide", false)
					Lock(Object, "Locked", true)
					Lock(Object, "CollisionGroup", "nil")
					Lock(Object, "CanQuery", true)
					Lock(Object, "CanTouch", true)
					Lock(Object, "TopSurface", Enum.SurfaceType.SmoothNoOutlines)
					Lock(Object, "BottomSurface", Enum.SurfaceType.SmoothNoOutlines)
					Lock(Object, "FrontSurface", Enum.SurfaceType.SmoothNoOutlines)
					Lock(Object, "BackSurface", Enum.SurfaceType.SmoothNoOutlines)
					Lock(Object, "RightSurface", Enum.SurfaceType.SmoothNoOutlines)
					Lock(Object, "LeftSurface", Enum.SurfaceType.SmoothNoOutlines)
					
					if (Configuration.CentralizePosition == true) then
						local Root = Character:FindFirstChild("HumanoidRootPart")
						if (Root) then
							for Index, Joint in pairs(Object:GetJoints()) do
								task.defer(Joint.Destroy, Joint)
							end
							WipeDescendants(Object, {"Weld", "ManualWeld", "ManualGlue", "Motor6D", "WeldConstraint", "Snap", "Rotate", "RotateV", "RotateP"}, true)
							Object.Anchored = false
							
							local Weld = Instance.new("Weld", Object)
							Weld.Name = "RootJoint"
							Weld.Part0 = Object
							Object.CFrame = Root.CFrame
							Weld.Part1 = Root
						end
					end
					
					WipeDescendants(Object, {"Decal", "Texture", "FileMesh", "BlockMesh", "SpecialMesh", "CylinderMesh", "Fire", "Smoke", "Sparkes", "ParticleEmitter", "Beam", "Trail"}, true)
					
					local DiedConnection = Humanoid.Died:Connect(function()
						task.defer(Object.Destroy, Object)
					end)
					
				end
			end
		end
	end
end

for Index, Object in pairs(Configuration.DescendantLocation:GetDescendants()) do Analyse(Object) end
local DescendantAdded = Configuration.DescendantLocation.DescendantAdded:Connect(Analyse)
