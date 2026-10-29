--!strict

local Maid = {}

function Maid.RequireFreshLibrary(baseModule: ModuleScript): (any, Instance)
	local root = baseModule:FindFirstAncestor("AtypicTextRenderer")
	assert(root, "AtypicTextRenderer root not found")

	local path = {}
	local current: Instance? = baseModule

	while current and current ~= root do
		table.insert(path, 1, current.Name)
		current = current.Parent
	end

	assert(current == root, "Base is outside the library root")

	local freshRoot = root:Clone()
	freshRoot.Parent = nil

	local freshModule: Instance = freshRoot

	for _, name in path do
		local child = freshModule:FindFirstChild(name)
		assert(child, "Missing cloned library path: " .. name)
		freshModule = child
	end

	assert(
		freshModule:IsA("ModuleScript"),
		"Cloned library is not a ModuleScript"
	)

	local success, result = pcall(require, freshModule)

	if not success then
		freshRoot:Destroy()
		error("Failed to refresh font library: " .. tostring(result))
	end

	return result, freshRoot
end

return Maid