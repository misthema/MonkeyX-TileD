Strict

Private
    Import fantomEngine.cftRGBA
    Import cftTiledMap
    Import cftTiledPropertySet
    Import mojo.graphics
Public


Class ftTiledImageLayer

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
    
    ' Layer's image
    Field image:Image
    
    ' Image color transform
    Field rgba:ftRGBA
    
    
    Method New(parent:ftTiledMap)
        Self.parent = parent
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
    
    Method GetImage:Image()
        Return image
    End
    
    Method GetOpacity:Float()
        Return opacity
    End
    
    Method GetVisible:Bool()
        Return visible
    End
    
    Method GetRGBA:ftRGBA()
        Return color
    End
    
    Method GetProperties:ftTiledPropertySet()
        Return properties
    End
    
    Method GetParent:ftTiledMap()
        Return parent
    End
End