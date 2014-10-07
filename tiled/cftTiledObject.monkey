Strict

Private
    Import cftTiledPropertySet
    Import cftTiledMap
Public

#REM
    This class is kinda self-explanatory...
#END

Class ftTiledObject
    Const RECTANGLE:Int = 0
    Const ELLIPSE:Int = 1
    Const POLYGON:Int = 2
    Const POLYLINE:Int = 3

    ' Object's name
    Field name:String
    
    ' Object's type
    Field type:String
    
    ' Parent tilemap
    Field parent:ftTiledMap
    
    ' Position in the map
    Field x:Float, y:Float
    
    ' Dimensions
    Field width:Int, height:Int
    
    ' Properties
    Field properties:ftTiledPropertySet
    
    ' The type of polygon
    Field objType:Int
    
    ' Polygon/polyline points (n = x, n+1 = y)
    Field points:Float[]
    
    Method New(parent:ftTiledMap)
        Self.parent = parent
    End
    
    Method GetName:String()
        Return name
    End
    
    Method GetType:String()
        Return type
    End
    
    Method GetX:Float()
        Return x
    End
    
    Method GetY:Float()
        Return y
    End
    
    Method GetWidth:Int()
        Return width
    End
    
    Method GetHeight:Int()
        Return height
    End
    
    Method HasPoints:Bool()
        Return (points.Length() > 0)
    End
    
    Method GetPointX:Float(index:Int)
        WrapIndex(index)
        Return points[index]
    End
    
    Method GetPointY:Float(index:Int)
        WrapIndex(index)
        Return points[index + 1]
    End
    
    Method GetPoints:Float[] ()
        Return points
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