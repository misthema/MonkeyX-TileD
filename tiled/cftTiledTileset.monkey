Strict

Private
    Import cftTiledPropertySet
    Import cftTiledMap
    Import mojo.graphics
Public

#REM
    Tileset image and other data will be stored in this class.
#END

Class ftTiledTileset
    'summary: Name of this tileset
    Field name:String
    
    'summary: Parent tilemap
    Field parent:ftTiledMap
    
    'summary: Tileset image (atlas)
    Field image:Image
    
    'summary: Tileset (image) dimensions in pixels
    Field width:Int, height:Int
    
    'summary: Tileset dimensions in tiles
    Field widthInTiles:Int, heightInTiles:Int
    
    'summary: Tile dimensions
    Field tileWidth:Int, tileHeight:Int
    
    'summary: Tile ID range
    Field firstGID:Int = 1, lastGID:Int = 1
    
    'summary: Tileset settings (for rendering)
    Field margin:Int, spacing:Int
    'summary: Tileset settings (for rendering)
    Field offsetX:Int, offsetY:Int
    
    'summary: Tileset properties
    Field properties:ftTiledPropertySet
    
    'summary: Tile specific properties (key: Tile ID, value: Properties)
    Field tileProperties:IntMap<ftTiledPropertySet>
    
    'summary: Tile images for faster access
    Field tileImages:Image[]
    
    'summary: Total tile count
    Field totalTiles:Int
    
    #REM
        Constructor
    #END
    Method New(parent:ftTiledMap)
        Self.parent = parent
        
        tileProperties = New IntMap<ftTiledPropertySet>()
        properties = New ftTiledPropertySet
    End
    
    'summary: Tileset's name
    Method GetName:String()
        Return name
    End
    
    'summary: Tileset width in pixels
    Method GetWidth:Int()
        Return width
    End
    
    'summary: Tileset height in pixels
    Method GetHeight:Int()
        Return height
    End
    
    'summary: Tileset width in tiles
    Method GetWidthInTiles:Int()
        Return widthInTiles
    End
    
    'summary: Tileset height in tiles
    Method GetHeightInTiles:Int()
        Return heightInTiles
    End
    
    'summary: Returns the total tile count
    Method GetTileCount:Int()
        Return totalTiles
    End
    
    'summary: Returns the corresponding image for tile ID
    Method GetTileImage:Image(gid:Int)
        If gid >= tileImages.Length() Then gid -= tileImages.Length()
        If gid < 0 Then gid += tileImages.Length()
        Return tileImages[gid]
    End
    
    'summary: Draws the tile image to coordinates (image handles are in top-left corner)
    Method DrawTileImage:Void(gid:Int, x:Float, y:Float)
        If gid >= tileImages.Length() Then gid -= tileImages.Length()
        If gid < 0 Then gid += tileImages.Length()
        DrawImage(tileImages[gid], x, y)
    End
    
    'summary: Tileset's properties
    Method GetProperties:ftTiledPropertySet()
        Return properties
    End
    
    'summary: Tile specific properties
    Method GetTileProperties:ftTiledPropertySet(gid:Int)
        Local id:Int = gid - firstGID ' It doesn't belong to this tileset, unless we do this.
        If tileProperties.Contains(id) Then
            Return tileProperties.Get(id)
        Else
            ftTiledMap.PrintWarning("ftTiledTileset", "Tile properties for ID '" + id + "' doesn't exist. (Global ID: '" + gid + "')")
            Return Null
        End
    End
    
    #REM
        Load tile images
    #END
    Method LoadImages:Void()
        If Not image Then Error("Unable to load tileset!~nName: '" + name + "'")

        Local x:Int, y:Int
        
        For Local i:= 0 Until totalTiles
            ' Calculate coordinates with tile ID
            x = (i Mod widthInTiles) * tileWidth
            y = i / widthInTiles * tileHeight
            
            ' Grab the tile image
            tileImages[i] = image.GrabImage(x, y, tileWidth, tileHeight)
        Next
    End
End

