Strict

Private
    Import cftTiledPropertySet
    Import cftTiledMap
Public

#REM
    This class is kinda self-explanatory...
#END

Class ftTiledObject
    'summary: Rectangle type object
    Const RECTANGLE:Int = 0
    'summary: Ellipse type object
    Const ELLIPSE:Int = 1
    'summary: Polygon type object
    Const POLYGON:Int = 2
    'summary: Polyline type object
    Const POLYLINE:Int = 3

    'summary:  Object's name
    Field name:String
    
    'summary:  Object's type
    Field type:String
    
    'summary:  Parent tilemap
    Field parent:ftTiledMap
    
    'summary:  Position in the map
    Field x:Float, y:Float
    
    'summary:  Dimensions
    Field width:Int, height:Int
    
    'summary:  Properties
    Field properties:ftTiledPropertySet
    
    'summary:  The type of polygon
    Field objType:Int
    
    'summary:  Polygon/polyline points (n = x, n+1 = y)
    Field points:Float[]
    
    'summary: Creates a new object.
    Method New(parent:ftTiledMap)
        Self.parent = parent
        Self.properties = New ftTiledPropertySet
    End
    
    'summary: Object's name. This is set by map-maker in the editor.
    Method GetName:String()
        Return name
    End
    
    'summary: Object's type. This is set by map-maker in the editor. You can use this to see if the object is for example an enemy, or a player_start_position.
    Method GetType:String()
        Return type
    End
    
    'summary: Object's X-coordinate
    Method GetX:Float()
        Return x
    End
    
    'summary: Object's Y-coordinate
    Method GetY:Float()
        Return y
    End
    
    'summary: Object width
    Method GetWidth:Int()
        Return width
    End
    
    'summary: Object height.
    Method GetHeight:Int()
        Return height
    End
    
    'summary: If object has points, returns True, if not, returns False.
    Method HasPoints:Bool()
        Return (points.Length() > 0)
    End
    
    'summary: Get X value for point by index
    Method GetPointX:Float(index:Int)
        index = WrapIndex(index)
        Return points[index]
    End
    
    'summary: Get Y value for point by index.
    Method GetPointY:Float(index:Int)
        index = WrapIndex(index + 1)
        Return points[index + 1]
    End
    
    'summary: Returns the point array.
    Method GetPoints:Float[] ()
        Return points
    End
    
    'summary: Returns the type constant of object. (RECTANGLE, ELLIPSE, POLYGON or POLYLINE)
    Method GetObjectType:Int()
        Return objType
    End
    
    Method AddPoint:Void(x:Float, y:Float)
        If points.Length() = 0 Then
            points = New Float[2]
        Else
            points = points.Resize(points.Length() +2)
        End
        
        Local index:Int = points.Length() -2
        points[index] = x
        points[index + 1] = y
    End
    
    Private
        ' Just so we don't get any errors
        Method WrapIndex:Int(index:Int)
            While index < 0
                index += points.Length()
            Wend
            
            While index >= points.Length()
                index -= points.Length()
            Wend
            
            Return index
        End
End