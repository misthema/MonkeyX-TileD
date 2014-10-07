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
    ' Layer name
    Field name:String
    
    ' Parent tilemap
    Field parent:ftTiledMap
    
    ' Layer dimensions
    Field width:Int, height:Int
    
    ' Layer's alpha and visibility
    Field opacity:Float, visible:Bool
    
    ' Layer properties
    Field properties:ftTiledPropertySet
    
    ' Tiles in this layer
    Field tiles:Int[][]
    
    Method New(name:String, width:Int, height:Int, parent:ftTiledMap)
        Self.name = name
        Self.width = width
        Self.height = height
        Self.parent = parent
        Self.properties = New ftTiledPropertySet
        InitTileArray()
    End
    
    Method GetName:String()
        Return name
    End
    
    Method GetWidth:Int()
        Return width
    End
    
    Method GetHeight:Int()
        Return height
    End
    
    Method GetOpacity:Float()
        Return opacity
    End
    
    Method GetVisible:Bool()
        Return visible
    End
    
    Method GetProperties:ftTiledPropertySet()
        Return properties
    End
    
    Method SetTile:Void(x:Int, y:Int, newID:Int)
        tiles[x][y] = newID
    End
    
    Method GetTile:Int(x:Int, y:Int)
        Return tiles[x][y]
    End
    
    Method GetTiles:Int[][] ()
        Return tiles
    End
    
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