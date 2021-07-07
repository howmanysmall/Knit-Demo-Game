local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayerScripts = game:GetService("StarterPlayer"):WaitForChild("StarterPlayerScripts")
local Knit = require(ReplicatedStorage:WaitForChild("Knit"))

Knit.Modules = StarterPlayerScripts:WaitForChild("Modules")
Knit.Shared = ReplicatedStorage:FindFirstChild("Shared")

Knit.AddControllers(StarterPlayerScripts:WaitForChild("Controllers"))
Knit.Start():ThenCall(print, "Started Knit!"):Catch(warn)
