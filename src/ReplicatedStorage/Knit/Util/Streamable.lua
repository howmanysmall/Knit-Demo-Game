-- Streamable
-- Stephen Leitnick
-- March 03, 2021

--[[

	streamable = Streamable.new(parent: Instance, childName: string)

	streamable:Observe(handler: (child: Instance, janitor: Janitor) -> void): Connection
	streamable:Destroy()

--]]

local Janitor = require(script.Parent.Janitor)
local Signal = require(script.Parent.Signal)
local Thread = require(script.Parent.Thread)

local Streamable = {}
Streamable.ClassName = "Streamable"
Streamable.__index = Streamable

function Streamable.new(parent, childName)
	local self = setmetatable({
		Instance = parent:FindFirstChild(childName);

		_janitor = Janitor.new();
		_shown = nil;
		_shownJanitor = nil;
	}, Streamable)

	self._shown = Signal.new(self._janitor)
	self._shownJanitor = self._janitor:Add(Janitor.new(), "Destroy")

	local function OnInstanceSet()
		local instance = self.Instance
		self._shown:Fire(instance, self._shownJanitor)
		self._shownJanitor:Add(instance:GetPropertyChangedSignal("Parent"):Connect(function()
			if not instance.Parent then
				self._shownJanitor:Cleanup()
			end
		end), "Disconnect")

		self._shownJanitor:Add(function()
			if self.Instance == instance then
				self.Instance = nil
			end
		end, true)
	end

	local function OnChildAdded(child)
		if child.Name == childName and not self.Instance then
			self.Instance = child
			OnInstanceSet()
		end
	end

	self._janitor:Add(parent.ChildAdded:Connect(OnChildAdded), "Disconnect")
	if self.Instance then
		OnInstanceSet()
	end

	return self
end

function Streamable:Observe(handler)
	if self.Instance then
		Thread.SpawnNow(handler, self.Instance, self._shownJanitor)
	end

	return self._shown:Connect(handler)
end

function Streamable:Destroy()
	self._janitor:Destroy()
	setmetatable(self, nil)
end

function Streamable:__tostring()
	return "Streamable"
end

return Streamable
