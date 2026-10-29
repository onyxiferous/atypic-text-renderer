--!strict

local TextRenderer = {}
TextRenderer.__index = TextRenderer

-- atypic font renderer
-- used for rendering fonts & glyphs through a special pipeline

local FontLibrary = require(script.FontLibrary)

export type RendererTask = {Threads: {RBXScriptConnection | RBXScriptSignal}}

export type self = {CachedFonts: {FontLibrary.FontObject}, Renderer: RendererTask}
export type TextRenderer = typeof(setmetatable({} :: self, TextRenderer))

function TextRenderer.new()
	local self = setmetatable({} :: self, TextRenderer)
	self.CachedFonts = self:ReloadFontCache()
	return self
end

function TextRenderer.ReloadFontCache(self: TextRenderer, keepCache: boolean?): {FontLibrary.FontObject}
    local fontList = keepCache and self.CachedFonts or {}
	for _, fontEntry in FontLibrary.RegisteredFonts do
        table.insert(fontList, fontEntry)
	end

    return fontList
end

return TextRenderer