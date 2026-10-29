--!strict

local ATFont = {}
local FontLibrary = require(script.Parent.FontLibrary)

export type ATFont = typeof(setmetatable({} :: FontLibrary.FontObject, ATFont))

ATFont.__index = ATFont
ATFont.CachedFonts = {}

function ATFont.new(fontObject: FontLibrary.FontObject): ATFont
	local self = setmetatable(fontObject :: FontLibrary.FontObject, ATFont)
	return self
end

return Font