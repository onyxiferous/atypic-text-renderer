--!strict

-- NOTE: this script acts as a constructor for font rendering.
-- each font will have a font sheet, which comes with glyph mappings.

local DefaultLocale: Locale = 'EN_US'

export type Atlas = {Sheets: FontSheet}
export type FontSheet = {[Locale]: FontSheetStub}
export type MappingData = {ImageDimensions: Vector2?, CellSize: Vector2?}
export type FontSheetStub = {[GlyphType]: GlyphConfiguration, SharedMappingData: MappingData?}
export type GlyphConfiguration = {ImageId: string, MappingData: MappingData}
export type Locale = 'EN_US' -- NOTE: english is the only language available, so I do not plan to add any other languages right now for the sake of maintenance.
export type GlyphType = 'Letters' | 'Numbers' | 'Symbols'

return {
	DefaultLocale = DefaultLocale
}