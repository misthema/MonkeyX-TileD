Strict

Private
    Import cftTiledMap
    Import cftTiledPropertySet
    Import cftTiledObject
    Import fantomEngine.cftRGBA
Public

#REM
    This class will act as an object container,
    which's objects can be accessed with their
    specified names.
#END

Class ftTiledObjectGroup
    'summary: ObjectGroup's name
    Field name:String
    
    'summary: Parent tilemap
    Field parent:ftTiledMap
    
    'summary: Dimensions
    Field width:Int, height:Int
    
    'summary: ObjectGroup's properties
    Field properties:ftTiledPropertySet
    
    'summary: Objects
    Field objects:StringMap<ftTiledObject>
    
    'summary: ObjectGroup's color
    Field rgba:ftRGBA
    
    'summary: ObjectGroup's alpha value and boolean for visibility.
    Field opacity:Float, visible:Bool
    
    'summary: Creates a new ObjectGroup
    Method New(parent:ftTiledMap)
        Self.parent = parent
        
        self.objects = New StringMap<ftTiledObject>()
        Self.properties = New ftTiledPropertySet
    End
    
    'summary: Get object by name
    Method GetObject:ftTiledObject(name:String)
        Return objects.Get(name)
    End
    
    'summary: Get all objects.
    Method GetObjects:StringMap<ftTiledObject>()
        Return objects
    End
    
    'summary: Properties for ObjectGroup
    Method GetProperties:ftTiledPropertySet()
        Return properties
    End
    
    'summary: Parent TiledMap
    Method GetParent:ftTiledMap()
        Return parent
    End
    
    'summary: ObjectGroup's name
    Method GetName:String()
        Return name
    End
    
    'summary: Width
    Method GetWidth:Int()
        Return width
    End
    
    'summary: Height
    Method GetHeight:Int()
        Return height
    End
    
    'summary: ObjectGroup's color
    Method GetRGBA:ftRGBA()
        Return rgba
    End
End