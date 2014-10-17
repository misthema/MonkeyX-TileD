Strict

Private
    Import cftTiledPropertySet
    Import cftTiledMap
Public

#REM
    This class will store any layer-specific data,
    like tiles, layer properties, opacity and so on.
#END

Class ftTiledLayer
    'summary: Layer name
    Field name:String
    
    'summary: Parent tilemap
    Field parent:ftTiledMap
    
    'summary: Layer dimensions
    Field width:Int, height:Int
    
    'summary: Layer's alpha and visibility
    Field opacity:Float, visible:Bool
    
    'summary: Layer properties
    Field properties:ftTiledPropertySet
    
    'summary: Tile IDs in this layer
    Field tiles:Int[][]
    
    Method New(name:String, width:Int, height:Int, parent:ftTiledMap)
        Self.name = name
        Self.width = width
        Self.height = height
        Self.parent = parent
        Self.properties = New ftTiledPropertySet
        InitTileArray()
    End
    
    'summary: Layer name
    Method GetName:String()
        Return name
    End
    
    'summary: Layer width
    Method GetWidth:Int()
        Return width
    End
    
    'summary: Layer height
    Method GetHeight:Int()
        Return height
    End
    
    'summary: Layer alpha
    Method GetOpacity:Float()
        Return opacity
    End
    
    'summary: Layer's visibility (True/False)
    Method GetVisible:Bool()
        Return visible
    End
    
    'summary: Layer's properties
    Method GetProperties:ftTiledPropertySet()
        Return properties
    End
    
    'summary: Use this method to modify the tiles in layer
    Method SetTile:Void(x:Int, y:Int, newID:Int)
        tiles[x][y] = newID
    End
    
    'summary: Get tile from X,Y
    Method GetTile:Int(x:Int, y:Int)
        Return tiles[x][y]
    End
    
    'summary: Returns the tile-array.
    Method GetTiles:Int[][] ()
        Return tiles
    End
    
    'summary: Parent TiledMap
    Method GetParent:ftTiledMap()
        Return parent
    End

    Private
        Method InitTileArray:Void()
            tiles = New Int[width][]
            For Local x:= 0 Until width
                tiles[x] = New Int[height]
            Next
        End
End