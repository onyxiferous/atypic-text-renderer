--!strict

local TextRenderer = {}
TextRenderer.__index = TextRenderer

-- atypic font renderer
-- used for rendering fonts & glyphs through a special pipeline

local ATFont = require(script.ATFont)

-- Renderer types

export type RendererTask = {Threads: {RBXScriptConnection | RBXScriptSignal}}

export type self = {CachedFonts: {ATFont.FontObject}, Renderer: RendererTask}
export type TextRenderer = typeof(setmetatable({} :: self, TextRenderer))

function TextRenderer.new()
	local self = setmetatable({} :: self, TextRenderer)
	self.CachedFonts = self:ReloadFontCache()
	return self
end

function TextRenderer.ReloadFontCache(self: TextRenderer, keepCache: boolean?): {ATFont.FontObject} | any
    --[[local fontList = keepCache and self.CachedFonts or {}
	for _, fontEntry in FontLibrary.RegisteredFonts do
        table.insert(fontList, fontEntry)
	end

    return fontList--]]
	return
end

return TextRenderer