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
    ' Group name
    Field name:String
    
    ' Parent tilemap
    Field parent:ftTiledMap
    
    ' Dimensions
    Field width:Int, height:Int
    
    ' Group's properties
    Field properties:ftTiledPropertySet
    
    ' Objects
    Field objects:StringMap<ftTiledObject>
    
    ' Group's color
    Field rgba:ftRGBA
    Field opacity:Float, visible:Bool
    
    Method New(parent:ftTiledMap)
        Self.parent = parent
        
        self.objects = New StringMap<ftTiledObject>()
        Self.properties = New ftTiledPropertySet
    End
    
    ' Get object by name
    Method GetObject:ftTiledObject(name:String)
        Return objects.Get(name)
    End
    
    Method GetObjects:StringMap<ftTiledObject>()
        Return objects
    End
    
    Method GetProperties:ftTiledPropertySet()
        Return properties
    End
    
    Method GetParent:ftTiledMap()
        Return parent
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
    
    Method GetRGBA:ftRGBA()
        Return rgba
    End
End