Strict

Private
    Import fantomEngine.cftRGBA
    Import cftTiledMap
    Import cftTiledPropertySet
    Import mojo.graphics
Public


Class ftTiledImageLayer

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
    
    'summary: Layer's image
    Field image:Image
    
    'summary: Image's color-transform
    Field rgba:ftRGBA
    
    
    Method New(parent:ftTiledMap)
        Self.parent = parent
        Self.properties = New ftTiledPropertySet()
    End
    
    'summary: Layer's name
    Method GetName:String()
        Return name
    End
    
    'summary: Layer's width
    Method GetWidth:Int()
        Return width
    End
    
    'summary: Layer's height
    Method GetHeight:Int()
        Return height
    End
    
    'summary: Layer's image
    Method GetImage:Image()
        Return image
    End
    
    'summary: Layer's alpha
    Method GetOpacity:Float()
        Return opacity
    End
    
    'summary: Layer's visibility
    Method GetVisible:Bool()
        Return visible
    End
    
    'summary: Color for image tinting
    Method GetRGBA:ftRGBA()
        Return color
    End
    
    'summary: Layer properties
    Method GetProperties:ftTiledPropertySet()
        Return properties
    End
    
    'summary: Parent TiledMap
    Method GetParent:ftTiledMap()
        Return parent
    End
End