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
    ' Name of this tileset
    Field name:String
    
    ' Parent tilemap
    Field parent:ftTiledMap
    
    ' Tileset image
    Field image:Image
    
    ' Tileset (image) dimensions in pixels
    Field width:Int, height:Int
    
    ' Tileset dimensions in tiles
    Field widthInTiles:Int, heightInTiles:Int
    
    ' Tile dimensions
    Field tileWidth:Int, tileHeight:Int
    
    ' Tile ID range
    Field firstGID:Int = 1, lastGID:Int = 1
    
    ' Settings
    Field margin:Int, spacing:Int
    Field offsetX:Int, offsetY:Int
    
    ' Tileset properties
    Field properties:ftTiledPropertySet
    
    ' Tile specific properties (key: Tile ID, value: Properties)
    Field tileProperties:IntMap<ftTiledPropertySet>
    
    ' Tile images for faster access with ID
    Field tileImages:Image[]
    
    ' Total tile count
    Field totalTiles:Int
    
    #REM
        Constructor
    #END
    Method New(parent:ftTiledMap)
        Self.parent = parent
        
        tileProperties = New IntMap<ftTiledPropertySet>()
        properties = New ftTiledPropertySet
    End
    
    #REM
        Load tile images
    #END
    Method LoadImages:Void()
        If Not image Then Error("Unable to load tileset!~nName: '" + name + "'")
        
        widthInTiles = width / parent.tileWidth
        heightInTiles = height / parent.tileHeight
        
        totalTiles = widthInTiles * heightInTiles
        tileImages = New Image[totalTiles]
        
        Local x:Int, y:Int
        
        For Local i:= 0 Until totalTiles
            ' Calculate coordinates with tile ID
            x = (i Mod width) * parent.tileWidth
            y = i / width * parent.tileHeight
            
            ' Grab the tile image
            tileImages[i] = image.GrabImage(x, y, parent.tileWidth, parent.tileHeight)
        Next
    End
End

