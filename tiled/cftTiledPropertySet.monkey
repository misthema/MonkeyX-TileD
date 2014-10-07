Strict

Private
    Import skn3.xml
Public


#REM
    Since objects, object groups, tilesets and tilemap itself
    can have properties, we use this class to "handle" and store
    it for them.
#END

Class ftTiledPropertySet
    Private
        Field _keys:StringMap<String>
    Public
    
    Method Get:String(name:String)
        If _keys = Null Then Return ""
        Return _keys.Get(name)
    End
    
    Method Contains:Bool(name:String)
        If _keys = Null Then Return False
        Return _keys.Contains(name)
    End
    
    Method Extend:Void(node:XMLNode)
        If node.name <> "properties" Return
        
        ' Init keymap
        If _keys = Null Then
            _keys = New StringMap<String>
        End
        
        For Local child:XMLNode = EachIn node.children
            Local propName:String = child.GetAttribute("name", "").Trim()
            Local propValue:String = child.GetAttribute("value", "").Trim()

            ' Don't add empty or space-only names
            If propName.Length() = 0 Then Continue
            
            _keys.Set(propName, propValue)
        Next
    End
End