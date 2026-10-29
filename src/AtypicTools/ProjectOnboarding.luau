--!strict

local StudioSelection = game:GetService('Selection')
local ProjectOnboarding = {}
local PluginInterface = require(script.Parent.PluginInterface)
local FontLibraryInterpreter = require(script.Parent.FontLibraryInterpreter)

function ProjectOnboarding._LoadAnimation(total: number, loaded: number, progress_bar: Frame)
	local size = progress_bar.Size

	local progress = if total > 0
		then math.clamp(loaded / total, 0, 1)
		else 1

	progress_bar.Size = UDim2.new(
		progress, 0,
		size.Y.Scale, size.Y.Offset
	)
end

function ProjectOnboarding.PollLoadingThread(loading_state: FontLibraryInterpreter.LoadingState)
    while not loading_state.StartTime or loading_state.ExpectedFonts == 0 do
		task.wait(loading_state.ThrottleInterval or 0.1)
	end

	while loading_state.LoadedFonts < loading_state.ExpectedFonts do
		task.wait(loading_state.ThrottleInterval or 0.1)
	end

	local startTime: number = loading_state.StartTime :: number
	local elapsed_ms: number = (os.clock() - startTime) * 1000

	local benchmark = string.format(
		'[AtypicTextRenderer]: [%d/%d] fonts loaded. (took %.3f ms)',
		loading_state.LoadedFonts,
		loading_state.ExpectedFonts,
		elapsed_ms
	)
	print(benchmark)
	PluginInterface.GUI.ContentFrame.Onboarding.Visible = true
	PluginInterface.GUI.ContentFrame.Onboarding.Status.Text = "initialized."
end

function ProjectOnboarding.StartProject(check_state: FontLibraryInterpreter.LibraryCheckState, module: ModuleScript, required_module: FontLibraryInterpreter.LibraryModule)
	local loading_bar = PluginInterface.GUI.ContentFrame.Overlays.Loader
	local progress_bar = loading_bar.InnerFrame.ProgressBar

	if check_state ~= "Valid" then return end

	PluginInterface.GUI.ContentFrame.Onboarding.Status.Text = "initializing..."
	loading_bar.Visible = true
	progress_bar.Size = UDim2.new(0, 0, progress_bar.Size.Y.Scale, progress_bar.Size.Y.Offset)

    local loading_state = FontLibraryInterpreter.LoadingState
	local task_thread: thread? = task.spawn(ProjectOnboarding.PollLoadingThread, loading_state)

    FontLibraryInterpreter.ReadFonts(module, function(loaded, total)
		local progressRatio = loaded / total
		progress_bar.Size = UDim2.new(progressRatio, 0, progress_bar.Size.Y.Scale, progress_bar.Size.Y.Offset)
	end)

    if task_thread then
        task.cancel(task_thread)
        task_thread = nil
    end

    loading_bar.Visible = false
end

function ProjectOnboarding.SelectionChanged()
	local selections = StudioSelection:Get()
	local first_selection = selections[1]

	local is_module = if first_selection
		then first_selection:IsA('ModuleScript')
		else false

	local check_state: FontLibraryInterpreter.LibraryCheckState =
		if #selections == 0 then 'None'
		elseif #selections ~= 1 or not is_module then 'Invalid'
		else 'Error'

	if #selections == 1 and is_module then
		local module_script = first_selection :: ModuleScript
		local resolution: FontLibraryInterpreter.CheckResolution =
			FontLibraryInterpreter.GetModuleData(
				module_script,
				FontLibraryInterpreter.FieldSchemas.Root
			)

		check_state = resolution.State

		if check_state == 'Valid' then
			ProjectOnboarding.StartProject(resolution.State, module_script, resolution.Data)
			return
		end
	end

	PluginInterface.GUI.ContentFrame.Onboarding.Status.Text = FontLibraryInterpreter.EXCEPTION_REASONS[check_state]
end


return ProjectOnboarding
