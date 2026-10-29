--!strict

local AtlasConstructor = require(script.Parent.Atlas)

export type FontObject = {Atlas: AtlasConstructor.Atlas}
export type RegisteredFonts = {
	[string]: FontObject,
}

local RegisteredFonts: RegisteredFonts = {
	ChakraPetch = {
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
		}
	}
}

return {
	RegisteredFonts = RegisteredFonts,
	CachedFonts = {}
}