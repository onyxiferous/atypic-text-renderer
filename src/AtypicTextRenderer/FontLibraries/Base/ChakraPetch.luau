--!strict

local libraryModule = script.Parent
local root = libraryModule:FindFirstAncestor('AtypicTextRenderer')

local ATFont = require(root.ATFont)
local AtlasConstructor = require(root.Atlas)
local FontObject: ATFont.FontObject = {
	Atlas = {
		Sheets = {
			[AtlasConstructor.DefaultLocale] = {
				Letters = {
					ImageId = 'rbxassetid://124165074303037',
					MappingData = {
						ImageDimensions = Vector2.new(1200, 1800)
					}
				},
				Numbers = {
					ImageId = 'rbxassetid://73446059013754',
					MappingData = {
						ImageDimensions = Vector2.new(1202, 401)
					}
				},
				Symbols = {
					ImageId = 'rbxassetid://104970148843384',
					MappingData = {
						ImageDimensions = Vector2.new(1202, 1001)
					}
				},
				SharedMappingData = {
					CellSize = Vector2.new(180, 180)
				}
			}
		}
	},
	Metadata = {DisplayName = 'Chakra Petch', Publisher = 'Cadson Demak'}
}

return FontObject