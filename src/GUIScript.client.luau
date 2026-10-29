--!strict
local GLYPH_RESOLUTION = Vector2.new(128, 128)
local ALPHA_GRID_DIMENSIONS = Vector2.new(6, 9)
local ALPHA_STRAY_CELLS = 2
local ReplicatedStorage = game:GetService('ReplicatedStorage')

type FontItem = {
	Id: string,
	Image: ImageLabel?
}

type TextCompound = {
	Frame: Frame,
	StoredGlyphs: {[number]: ImageLabel}
}

type AtlasSet = {[string]: FontItem}

local parent = script.Parent :: ScreenGui
local atlases: AtlasSet = {
	ChakraPetch = {Id = 'rbxassetid://124165074303037', Image = nil}
}

function createAtlas(imageId: string)
	local atlasImage = Instance.new('ImageLabel')
	atlasImage.Image = imageId
	atlasImage.Parent = ReplicatedStorage
	return atlasImage
end

function populateAtlasImages()
	for _, fontItem: FontItem in atlases do
		fontItem.Image = createAtlas(fontItem.Id)
	end
end

function createGlyph(atlasImage: ImageLabel?, character: string, positionOrCompound: UDim2 | TextCompound): ImageLabel?
	local tracking = 100
	local characterIndex = 0
	local compoundGlyphs = {}

	if not atlasImage then
		warn('[FontRenderer]: Atlas image was not provided, exiting.')
		return nil
	end

    local glyph = atlasImage:Clone()
	glyph.Size = UDim2.new(0, GLYPH_RESOLUTION.X, 0, GLYPH_RESOLUTION.Y)

	if typeof(positionOrCompound) == 'UDim2' then
		glyph.Position = positionOrCompound
		glyph.Parent = script.Parent
	else
		compoundGlyphs = positionOrCompound.StoredGlyphs
		characterIndex = #compoundGlyphs + 1
		glyph.Position = UDim2.new(0, tracking * #compoundGlyphs, 0, 0)
		glyph.Parent = positionOrCompound.Frame
		positionOrCompound.StoredGlyphs[characterIndex] = glyph
	end

	glyph.Parent = script.Parent
	glyph.Name = `Char_{character}@0`
	return glyph
end

function createTextCompound(parent: Instance)
	local self: TextCompound = {
		StoredGlyphs = {},
		Frame = Instance.new('Frame')
	}

	self.Frame.BackgroundTransparency = 1
	self.Frame.Size = UDim2.new(0, 0, 0, 0)
	self.Frame.AutomaticSize = Enum.AutomaticSize.XY
	self.Frame.Name = 'TextRenderCompound'
	self.Frame.Parent = parent
	return self
end

local textCompound = createTextCompound(parent)

populateAtlasImages()
createGlyph(atlases.ChakraPetch.Image, 'a', textCompound)
createGlyph(atlases.ChakraPetch.Image, 'b', textCompound)
createGlyph(atlases.ChakraPetch.Image, 'c', textCompound)
createGlyph(atlases.ChakraPetch.Image, 'd', textCompound)
createGlyph(atlases.ChakraPetch.Image, 'e', textCompound)