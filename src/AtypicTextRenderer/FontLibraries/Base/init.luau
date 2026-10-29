--!strict

local root = script:FindFirstAncestor('AtypicTextRenderer')
local ATFont = require(root.ATFont)
local RegisteredFonts: ATFont.RegisteredFonts = {
	ChakraPetch = require(script.ChakraPetch)
}

local Library: ATFont.FontLibrary = {
	RegisteredFonts = RegisteredFonts,
	CachedFonts = {}
}

return Library