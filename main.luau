-- // Configuration

local Settings = {
	HitboxName = "Head", --> Will look for a descendant with this name
	HitboxSize = 10, --> This is the size of the hitbox, afterwards expanding
	
	HitboxColor = Color3.new(1,1,1),
	HitboxTransparency = 0,
	HitboxMaterial = Enum.Material.ForceField,
}


-- // Services & Variables

local RunService = game:GetService("RunService");
local Players = game:GetService("Players");
local LocalPlayer = Players.LocalPlayer;
local Mouse = LocalPlayer:GetMouse();

-- // Portable Functions

local Lock = function(Object: Instance, Property: string, Goal: any)
	Object[Property] = Goal
	local LockConnectionn = Object:GetPropertyChangedSignal(Property):Connect(function()
		Object[Property] = Goal
	end)
	return LockConnectionn
end

local RemoveDescendants = function(Object: Instance, DescendantTable, Callback)
	for Index, Descendant in pairs(Object:GetDescendants()) do
		for Index, ClassName in pairs(DescendantTable) do
			if (Descendant:IsA(ClassName)) then
				Callback(Descendant)
			end
		end
	end
end

-- // Functions

local Analyse = function(Hitbox: BasePart)
	if (Hitbox.Name == Settings.HitboxName) then
		local Character = Hitbox.Parent
		
		local Humanoid = Character:FindFirstChildWhichIsA("Humanoid")
		if not (Humanoid) then return end
		
		if (Character.Name == LocalPlayer.Name) then return end
		
		Lock(Hitbox, "Size", Vector3.new(Settings.HitboxSize, Settings.HitboxSize, Settings.HitboxSize))
		Lock(Hitbox, "Transparency", Settings.HitboxTransparency)
		Lock(Hitbox, "Color", Settings.HitboxColor)
		Lock(Hitbox, "CastShadow", false)
		Lock(Hitbox, "CanCollide", false)
		Lock(Hitbox, "Massless", true)
		Lock(Hitbox, "CustomPhysicalProperties", PhysicalProperties.new(0.001, 0, 0, 0, 0))
		Lock(Hitbox, "Material", Settings.HitboxMaterial)
		
		RemoveDescendants(Hitbox, {"Decal", "Texture"}, function(DecalObject)
			Lock(DecalObject, "Transparency", 1)
		end)
		
		RemoveDescendants(Hitbox, {"FileMesh", "SpecialMesh", "BlockMesh"}, function(MeshObject)
			task.defer(MeshObject.Destroy, MeshObject)
		end)
		
	end
end

-- // Connections & Script

for Index, Hitbox in pairs(workspace:GetDescendants()) do Analyse(Hitbox) end
local Addded = workspace.DescendantAdded:Connect(Analyse)
