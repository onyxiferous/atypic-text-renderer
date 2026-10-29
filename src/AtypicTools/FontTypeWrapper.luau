--!strict
-- v1

-- ISSUE: may have no use for this? will check back later lol
export type Atlas = {}
export type Metadata = {DisplayName: string, Publisher: string?}
export type FontObject = {Atlas: Atlas, Metadata: Metadata}
export type FontBuffer = {[string]: FontObject}

return {}