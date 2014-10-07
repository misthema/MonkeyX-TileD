Strict

#TEXT_FILES += "*.tmx|*.tsx"

Import mojo.app
Import skn3.xml
Import os

Import fantomEngine.cftRGBA

Import base64
Import cftTiledTileset
Import cftTiledObject
Import cftTiledObjectGroup
Import cftTiledPropertySet
Import cftTiledLayer
Import cftTiledImageLayer


Alias LoadString = app.LoadString

#REM
    This class will basically work as a loader only,
    so every data will be stored here. Rendering should
    be done separately.
#END

Class ftTiledMap
    Private
        ' For XML
        Field _realPath:String
        Field _doc:XMLDoc, _error:XMLError
    Public
        Const ORTHOGONAL:Int = 0
        Const ISOMETRIC:Int = 1
    
        ' All tilesets for this map
        Field tilesets:StringMap<ftTiledTileset>
        
        ' All layers for this map
        Field layers:StringMap<ftTiledLayer>
        
        ' All object groups for this map
        Field objectGroups:StringMap<ftTiledObjectGroup>
        
        ' All image layers for this map
        Field imgLayers:StringMap<ftTiledImageLayer>
        
        ' Kind of useless, but still stored
        Field version:String
        
        ' Determines how this should be rendered
        Field orientationStr:String
        Field orientationInt:Int
        
        ' Dimensions in tiles
        Field width:Int, height:Int
        
        ' Dimensions in pixels
        Field fullWidth:Int, fullHeight:Int
        
        ' Tile dimensions (for tilemaps grid)
        Field tileWidth:Int, tileHeight:Int
        
        ' Properties for map itself
        Field properties:ftTiledPropertySet
        
    
    Method New(path:String)
        _realPath = ExtractDir(RealPath(path))
        LoadXML(LoadString(path), path)
    End
    
    Method GetTilesetForGID:ftTiledTileset(gid:Int)
        Local tileset:ftTiledTileset
        For tileset = EachIn tilesets.Values()
            If gid >= tileset.firstGID And gid < tileset.lastGID
                Return tileset
            EndIf
        Next
        
        Return Null
    End
    
    Private
        #REM
            Private loading, just because these aren't needed anywhere else.
            Parameter 'fileName' is only provided for better error descriptions.
        #END
        Method LoadXML:Void(rawXML:String, fileName:String)
            If rawXML.Length() = 0 Then
                Error("Could not read XML file: " + fileName + "~nFrom: " + _realPath)
            End
            
            _error = New XMLError()
            _doc = ParseXML(rawXML, _error)
            
            ' Something went wrong
            If _error.error or _doc = Null Then
                Error(_error.ToString())
            End
            
            If _doc.children = Null Then
                Error("XML has no nodes - empty tilemap?")
            End
            
            ' I have no idea how to get first node in better way...
            ' But this will provide us the <map> node.
            Local map:XMLNode = _doc.GetChild().GetParent()
            
            LoadBasicData(map)
            
            tilesets = New StringMap<ftTiledTileset>()
            layers = New StringMap<ftTiledLayer>()
            objectGroups = New StringMap<ftTiledObjectGroup>()
            imgLayers = New StringMap<ftTiledImageLayer>()
            
            Local tileset:ftTiledTileset
            Local layer:ftTiledLayer
            Local objGroup:ftTiledObjectGroup
            Local imageLayer:ftTiledImageLayer
            
            For Local node:XMLNode = EachIn map.children
                Select node.name
                    Case "tileset"
                        tileset = LoadTileset(node)
                        
                        If tileset <> Null Then
                            If tilesets.Contains(tileset.name)
                                Print("ftTiledMap::WARNING: Ignoring tileset '" + tileset.name + "': already exists.")
                            Else
                                tilesets.Set(tileset.name, tileset)
                            End
                        End
                        
                    Case "layer"
                        layer = LoadLayer(node)
                        
                        If layer <> Null Then
                            layers.Set(layer.name, layer)
                        End
                        
                    Case "objectgroup"
                        objGroup = LoadObjectGroup(node)
                        
                        If objGroup <> Null Then
                            objectGroups.Set(objGroup.name, objGroup)
                        End
                    
                    Case "imagelayer"
                        imageLayer = LoadImageLayer(node)
                        
                        If imageLayer <> Null Then
                            imgLayers.Set(imageLayer.name, imageLayer)
                        End
                End
            Next
        End
        
        Method LoadBasicData:Void(node:XMLNode)
            version = node.GetAttribute("version")
            orientationStr = node.GetAttribute("orientation")
                
            Select orientationStr.ToLower()
                Case "orthogonal"
                    orientationInt = ORTHOGONAL
                Case "isometric"
                    orientationInt = ISOMETRIC
            End
            
            width = node.GetAttribute("width", 1)
            height = node.GetAttribute("height", 1)
            
            tileWidth = node.GetAttribute("tilewidth", 1)
            tileHeight = node.GetAttribute("tileheight", 1)
            
            fullWidth = width * tileWidth
            fullHeight = height * tileHeight
            
            properties = New ftTiledPropertySet
            
            ' Load tilemap properties
            Local props:XMLNode = node.GetChild("properties")
            If props <> Null Then
                properties.Extend(props)
            End
        End
        
        '#Region Tileset
        Method LoadTileset:ftTiledTileset(node:XMLNode)
            If node = Null Then Return Null
            
            Local tileset:= New ftTiledTileset(Self)
            
            ' Load tileset
            If node.HasAttribute("name") Then
                LoadTilesetData(node, tileset)
                
            ' Load external tileset
            Else If node.HasAttribute("source") Then
                Local extPath:String = node.GetAttribute("source")
                Local extTileset:XMLDoc = ParseXML(LoadString(extPath), _error)
                
                ' Error
                If _error.error or extTileset = Null Then
                    Error("File '" + node.GetAttribute("source") + "' " + _error.ToString())
                End
                
                Local extParentNode:XMLNode = extTileset.GetChild().GetParent()
                
                LoadTilesetData(extParentNode, tileset)
            End
            
            ' Preload tile images
            tileset.LoadImages()
            
            Return tileset
        End
        
        Method LoadTilesetData:Void(node:XMLNode, tileset:ftTiledTileset)
            If node = Null or tileset = Null Then Return
            
            ' Settings
            tileset.name = node.GetAttribute("name", "")
            tileset.tileWidth = node.GetAttribute("tilewidth", 1)
            tileset.tileHeight = node.GetAttribute("tileheight", 1)
            
            tileset.spacing = node.GetAttribute("spacing", 0)
            tileset.margin = node.GetAttribute("margin", 0)
            
            tileset.firstGID = node.GetAttribute("firstgid", 1)
            
            ' Image node
            Local imageNode:XMLNode = node.GetChild("image")
            If imageNode = Null Then Error("Tileset '" + tileset.name + "' has no image?") ' Error
            
            Local imagePath:String = imageNode.GetAttribute("source")
            
            ' Load tileset image
            tileset.image = LoadImage(imagePath)
            If tileset.image = Null Then Error("Unable to load tileset: " + imagePath)
            
            ' Tileset dimensions
            tileset.width = tileset.image.Width()
            tileset.height = tileset.image.Height()
            tileset.widthInTiles = tileset.width / tileset.tileWidth
            tileset.heightInTiles = tileset.height / tileset.tileHeight
            
            ' Cap the GID range
            tileset.lastGID = tileset.widthInTiles * tileset.heightInTiles + tileset.firstGID
            
            ' Load tileset properties
            Local props:XMLNode = node.GetChild("properties")
            If props <> Null Then
                tileset.properties.Extend(props)
            End
            
            Local tileNode:XMLNode
            Local tileProp:ftTiledPropertySet
            Local tempProps:XMLNode
            Local id:Int
            
            ' Load tile-specific properties
            For tileNode = EachIn node.children
                If tileNode.name <> "tile" Then Continue
                
                tempProps = tileNode.GetChild("properties")
                
                tileProp = New ftTiledPropertySet()
                tileProp.Extend(tempProps)
                
                id = tileNode.GetAttribute("id", 0)
                tileset.tileProperties.Set(id, tileProp)
            Next
        End
        '#End Region
        
        '#Region Layer
        Method LoadLayer:ftTiledLayer(node:XMLNode)
            If node = Null Then Return Null
            
            Local name:String = node.GetAttribute("name")
            Local width:Int = node.GetAttribute("width", 1)
            Local height:Int = node.GetAttribute("height", 1)
            
            Local layer:= New ftTiledLayer(name, width, height, Self)
            
            layer.visible = node.GetAttribute("visible", True)
            layer.opacity = node.GetAttribute("opacity", 1.0)
            
            ' Load layer properties
            Local layerProps:XMLNode = node.GetChild("properties")
            If layerProps <> Null Then
                layer.properties.Extend(layerProps)
            End
            
            LoadLayerData(node, layer)
            
            Return layer
        End
        
        Method LoadLayerData:Void(node:XMLNode, layer:ftTiledLayer)
            Local data:XMLNode = node.GetChild("data")
            If data = Null Then Error("Layer '" + layer.name + "' has no data!")
            
            Local encoding:String = data.GetAttribute("encoding", "raw")
            Local compression:String = data.GetAttribute("compression", "none")
            
            Select encoding
                Case "raw" ' XML
                    LoadTilesXML(data, layer)
                Case "csv"
                    LoadTilesCSV(data, layer)
                Case "base64"
                    LoadTilesBase64(data, layer, compression)
            End
        End
        
        ' Load tiles from XML data
        Method LoadTilesXML:Void(data:XMLNode, layer:ftTiledLayer)
            Local tileNode:XMLNode
            Local x:Int = 0, y:Int = 0
            Local gid:Int
            
            ' Load tiles
            For tileNode = EachIn data.children
                If x >= layer.width Then
                    y += 1
                    x = 0
                End

                gid = tileNode.GetAttribute("gid", 0)
                layer.SetTile(x, y, gid)
                
                x += 1
            Next
        End
        
        ' Load tiles from CSV data
        Method LoadTilesCSV:Void(data:XMLNode, layer:ftTiledLayer)
            Local csv:String[] = data.value.Split(",")
            Local i:Int, gid:Int
            Local x:Int, y:Int
            
            ' Load tiles
            For i = 0 Until csv.Length()
                gid = Int(csv[i].Trim())
                
                x = i Mod width
                y = i / width
                
                layer.SetTile(x, y, gid)
            Next
        End
        
        ' Load tiles from Base64 encoded data
        Method LoadTilesBase64:Void(data:XMLNode, layer:ftTiledLayer, compression:String)
            Local bytes:Int[] = DecodeBase64Bytes(data.value)
            Local i:Int, gid:Int
            Local x:Int, y:Int
            
            Select compression
                Case "zlib"
                    Error("ZLib compression not yet supported!")
                Case "gzip"
                    Error("GZip compression not yet supported!")
            End
            
            ' Load tiles
            For i = 0 Until bytes.Length() Step 4
                x = (i / 4) Mod width
                y = (i / 4) / width
            
                ' Little endian
                gid = bytes[i]
                gid += bytes[i + 1] Shl 8
                gid += bytes[i + 2] Shl 16
                gid += bytes[i + 3] Shl 24
                
                layer.SetTile(x, y, gid)
            Next
        End
        '#End Region
        
        '#Region Objects
        Method LoadObjectGroup:ftTiledObjectGroup(node:XMLNode)
            If node = Null Then Return Null
            
            Local objGroup:= New ftTiledObjectGroup(Self)
            
            objGroup.name = node.GetAttribute("name")
            objGroup.width = node.GetAttribute("width", 1)
            objGroup.height = node.GetAttribute("height", 1)
            objGroup.visible = node.GetAttribute("visible", True)
            objGroup.opacity = node.GetAttribute("opacity", 1.0)
            objGroup.rgba = New ftRGBA(255, 255, 255, 1.0)
            
            If node.HasAttribute("color") Then
                Local color:Int = Int(node.GetAttribute("color").Replace("#", "$"))
                Local r:Int = color Shr 16 & $0000FF
                Local g:Int = color Shr 8 & $0000FF
                Local b:Int = color & $0000FF
                
                objGroup.rgba.Set(r, g, b, 1.0)
            End

            ' Load group properties
            Local groupProps:XMLNode = node.GetChild("properties")
            If groupProps <> Null Then
                objGroup.properties.Extend(groupProps)
            End
            
            ' Load objects
            Local child:XMLNode, obj:ftTiledObject
            For child = EachIn node.children
                If child.name = "object" Then
                    obj = LoadObject(child)
                    objGroup.objects.Set(obj.name, obj)
                End
            Next
            
            Return objGroup
        End
        
        Method LoadObject:ftTiledObject(node:XMLNode)
            If node = Null Then Return Null
            
            Local obj:= New ftTiledObject(Self)
            
            obj.name = node.GetAttribute("name")
            obj.type = node.GetAttribute("type")
            obj.x = node.GetAttribute("x", 0)
            obj.y = node.GetAttribute("y", 0)
            obj.width = node.GetAttribute("width", 1)
            obj.height = node.GetAttribute("height", 1)
            
            
            ' Object settings
            Local objSettings:XMLNode
            For objSettings = EachIn node.children
                Select objSettings.name
                    Case "ellipse"
                        obj.objType = ftTiledObject.ELLIPSE
                        
                    Case "polygon", "polyline"
                        Local points:String[] = objSettings.GetAttribute("points", "").Split(",")
                        
                        obj.points = New Float[points.Length()]
                        
                        Local i:Int
                        If points.Length() > 0 Then
                            For i = 0 Until points.Length()
                                obj.points[i] = Float(points[i].Trim())
                            Next
                        End
                    
                    Case "polygon"
                        obj.objType = ftTiledObject.POLYGON
                        
                    Case "polyline"
                        obj.objType = ftTiledObject.POLYLINE
                        
                    Default
                        obj.objType = ftTiledObject.RECTANGLE
                End
            Next
            
            ' Load object's properties
            Local objProps:XMLNode = node.GetChild("properties")
            If objProps <> Null Then
                obj.properties.Extend(objProps)
            End
            
            Return obj
        End
        '#End Region
        
        '#Region Imagelayer
        Method LoadImageLayer:ftTiledImageLayer(node:XMLNode)
            Local imageLayer:= New ftTiledImageLayer(Self)
            
            LoadImageLayerData(node, imageLayer)
            
            Return imageLayer
        End
        
        Method LoadImageLayerData:Void(node:XMLNode, imageLayer:ftTiledImageLayer)
            imageLayer.name = node.GetAttribute("name")
            imageLayer.width = node.GetAttribute("width", 1)
            imageLayer.height = node.GetAttribute("height", 1)
            imageLayer.rgba = New ftRGBA(255, 255, 255, 1.0)
        
            Local imgNode:XMLNode = node.GetChild("image")
            
            If imgNode <> Null Then
                Local imgPath:String = imgNode.GetAttribute("source")
                imageLayer.image = LoadImage(imgPath)
                
                If imageLayer.image = Null Then
                    Error("Unable to load image '" + imgPath + "' for image-layer '" + imageLayer.name + "'!")
                End
                
                If imgNode.HasAttribute("trans") Then
                    Local color:Int = Int(imgNode.GetAttribute("trans").Replace("#", "$"))
                    Local r:Int = color Shr 16 & $0000FF
                    Local g:Int = color Shr 8 & $0000FF
                    Local b:Int = color & $0000FF
                    
                    imageLayer.rgba.Set(r, g, b, 1.0)
                End
            End

            ' Load image-layer properties
            Local imgProps:XMLNode = node.GetChild("properties")
            If imgProps <> Null Then
                imageLayer.properties.Extend(imgProps)
            End
        End
        '#End Region
End

