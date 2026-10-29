--!strict

local StudioSelection = game:GetService('Selection')
local PluginInterface = require(script.PluginInterface)
local ProjectOnboarding = require(script.ProjectOnboarding)

local interface = PluginInterface.Initialize(plugin)
interface.Widget.Title = 'Atypic Editor'
interface.ToggleButton.ClickableWhenViewportHidden = true
PluginInterface.GUI.WidgetFrame.Parent = interface.Widget

interface.ToggleButton.Click:Connect(function()
	interface.Widget.Enabled = not interface.Widget.Enabled
end)

StudioSelection.SelectionChanged:Connect(ProjectOnboarding.SelectionChanged)