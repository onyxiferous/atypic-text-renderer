
--!strict

export type LoadingState = {
	LoadedFonts: number,
	ExpectedFonts: number,
    ThrottleInterval: number,
	StartTime: number?,
}

local FontLibraryInterpreter = {}
local FontTypeWrapper = require(script.Parent.FontTypeWrapper)
local Maid = require(script.Parent.Maid)

-- NOTE: in the case of it being replicatable, make it a self object
FontLibraryInterpreter.LoadingState = {
	LoadedFonts = 0,
	ExpectedFonts = 0,
    ThrottleInterval = 1 / 10
} :: LoadingState

export type LibraryCheckState =
	'Valid'
| 'Invalid'
| 'MissingFields'
| 'Error'
| 'None'

export type ExceptionResult = LibraryCheckState
export type ExceptionEnums = {[LibraryCheckState]: string}

export type CheckResolution = {
	State: LibraryCheckState,
	Data: any,
}

export type AllowedFieldLiterals = 'RegisteredFonts' | 'CachedFonts'
export type AllowedFontLiterals = 'Atlas' | 'Metadata'
export type ATTypePassthroughBinary = {string | string}
export type ATTypePassthrough = {"CachedFonts" | "RegisteredFonts"} | {"Atlas" | "Metadata"} | {"CachedFonts" | "RegisteredFonts"}
-- change to match if needed later - may be unnecessary typechecking but maybe prevents type bugs? idk

export type LibraryModule = {
	RegisteredFonts: {[string]: any},
	CachedFonts: {any},
}

FontLibraryInterpreter.FieldSchemas = {
	Root = {
		'RegisteredFonts',
		'CachedFonts',
	} :: {AllowedFieldLiterals},

	Fonts = {
		'Atlas',
		'Metadata'
	} :: {AllowedFontLiterals}
}

export type ProgressCallback = (loaded: number, total: number) -> ()

local STRESS_TEST = true
local ITERATIONS_PER_FONT = 500000
-- ISSUE: only for testing use, should probably not be ported to production.
local function simulateFontProcessing(iterations: number): number
	local checksum = 0

	for i = 1, iterations do
		checksum += math.sqrt(i) * math.sin(i)
	end

	return checksum
end

FontLibraryInterpreter.EXCEPTION_REASONS = {
	None = 'nothing is selected',
	Invalid = 'invalid item selected',
	MissingFields = "this doesn't look like a FontLibrary. check that you selected the right item.",
	Error = 'something went wrong while trying to load this module. check that the selected item is a FontLibrary and that it has no errors.',
} :: ExceptionEnums

function FontLibraryInterpreter.CheckTypeFields(
	fields: ATTypePassthrough,
	data: {[string]: any} | FontTypeWrapper.FontObject, LibraryModule
): boolean
	for _, field in fields :: ATTypePassthroughBinary do
		if data[field] == nil then
			return false
		end
	end

	return true
end

function FontLibraryInterpreter.ReadFonts(module: ModuleScript, on_progress: ProgressCallback?): {FontTypeWrapper.FontBuffer}
	local required_module, _ = Maid.RequireFreshLibrary(module)
	local valid_fonts: {FontTypeWrapper.FontBuffer} = FontLibraryInterpreter.FilterFonts(required_module, module)

	local total = #valid_fonts

    FontLibraryInterpreter.LoadingState.StartTime = os.clock()
	FontLibraryInterpreter.LoadingState.ExpectedFonts = total
	FontLibraryInterpreter.LoadingState.LoadedFonts = 0

	for _, font in valid_fonts do
		if STRESS_TEST then
			simulateFontProcessing(ITERATIONS_PER_FONT)
		end

		FontLibraryInterpreter.LoadingState.LoadedFonts += 1

		if on_progress then
			on_progress(FontLibraryInterpreter.LoadingState.LoadedFonts, FontLibraryInterpreter.LoadingState.ExpectedFonts)
		end
	end

	return valid_fonts
end

function FontLibraryInterpreter.FilterFonts(required_module: LibraryModule, module_script: ModuleScript): {FontTypeWrapper.FontBuffer}
	local filtered_fonts: {FontTypeWrapper.FontBuffer} = {}
	for _, font in required_module.RegisteredFonts do
		local metadata: FontTypeWrapper.Metadata? = required_module.RegisteredFonts.Metadata
		local are_fields_valid = FontLibraryInterpreter.CheckTypeFields(FontLibraryInterpreter.FieldSchemas.Fonts, font, module_script)

		if not are_fields_valid then
			warn(`[AtypicFontTool]: Font item {metadata and metadata.DisplayName or font} did not meet FontTypeWrapper[Atlas&Metadata] requirements as directed by T:FontLibraryInterpreter.FieldSchemas[Fonts]. Check for formatting errors within the \{Font}.`)
			continue
		end

		table.insert(filtered_fonts, font)
	end
	return filtered_fonts
end

function FontLibraryInterpreter.ValidateModuleShape(
	module_script: ModuleScript,
	required_module: any,
	schema: {AllowedFieldLiterals} | {AllowedFontLiterals}
): ExceptionResult
	if not module_script:IsA('ModuleScript') then return 'Invalid' end
	if type(required_module) ~= 'table' then return 'Error' end

	local module_data = required_module :: {[string]: any}
	local has_required_fields =
		FontLibraryInterpreter.CheckTypeFields(schema, module_data, module_script)

	if not has_required_fields then return 'MissingFields' end

	return 'Valid'
end

function FontLibraryInterpreter.GetModuleData(
	module_script: ModuleScript,
	schema: {AllowedFieldLiterals} | {AllowedFontLiterals}
): CheckResolution

	if not module_script or not module_script:IsA('ModuleScript') then
		return {State = 'Invalid', Data = nil}
	end

	local success, required_module = pcall(require, module_script)

	if not success then
		return {State = 'Error', Data = nil}
	end

	local check_state = FontLibraryInterpreter.ValidateModuleShape(
		module_script,
		required_module,
		schema
	)

	return {
		State = check_state :: LibraryCheckState, -- NOTE: we have to be aggressive towards the typechecker here
        -- check_state is actually LibraryCheckState but we have to infer
		Data = required_module,
	}
end

return FontLibraryInterpreter