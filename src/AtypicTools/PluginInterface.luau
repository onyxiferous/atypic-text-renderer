local PluginInterface = {}
local root = script.Parent

type InterfaceObject = {
	Toolbar: PluginToolbar,
	ToggleButton: PluginToolbarButton,
	WidgetInfo: DockWidgetPluginGuiInfo,
	Widget: DockWidgetPluginGui
}

PluginInterface.GUI = {}

PluginInterface.GUI.WidgetFrame = root.WidgetFrame:Clone()
PluginInterface.GUI.ContentFrame = PluginInterface.GUI.WidgetFrame.Window.Content

function PluginInterface.Initialize(plugin_object: Plugin): InterfaceObject
	local toolbar = plugin_object:CreateToolbar("Atypic Font Engine")

	local widget_info = DockWidgetPluginGuiInfo.new(
		Enum.InitialDockState.Float,
		false,
		false,
		400, 500,
		400, 500
	)

	local widget = plugin_object:CreateDockWidgetPluginGuiAsync(
		"atypic_widget_host",
		widget_info
	)

	local widget_frame = root.WidgetFrame:Clone()
	widget_frame.Parent = widget

	return {
		Toolbar = toolbar,
		ToggleButton = toolbar:CreateButton(
			"host",
			"Opens the Atypic Font Editor tool.",
			"rbxassetid://119263948353935",
			"Atypic Editor"
		),
		WidgetInfo = widget_info,
		Widget = widget
	}
end

return PluginInterface