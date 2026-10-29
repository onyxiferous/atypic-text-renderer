--!strict

local ATFont = {}
local AtlasConstructor = require(script.Parent.Atlas)

export type ATFont = typeof(setmetatable({} :: FontObject, ATFont))

export type FontLibrary = {
	RegisteredFonts: RegisteredFonts,
	CachedFonts: {any}
}
export type FontMetadata = {DisplayName: string, Publisher: string?}
export type FontObject = {Atlas: AtlasConstructor.Atlas, Metadata: FontMetadata}
export type RegisteredFonts = {
	[string]: FontObject,
}
export type RegisteredLibraries = {[string]: RegisteredFonts}

ATFont.__index = ATFont
ATFont.CachedFonts = {}

function ATFont.new(fontObject: FontObject): ATFont
	local self = setmetatable(fontObject :: FontObject, ATFont)
	return self
end

return ATFont