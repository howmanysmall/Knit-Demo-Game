local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Knit = require(ReplicatedStorage:WaitForChild("Knit"))

Knit.Modules = ServerStorage:FindFirstChild("Modules")
Knit.Shared = ReplicatedStorage:FindFirstChild("Shared")

Knit.AddServices(ServerStorage:FindFirstChild("Services"))
Knit.Start():ThenCall(print, "Started Knit!"):Catch(warn)
