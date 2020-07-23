B4i=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=6
@EndOfDesignText@
'Code module

Private Sub Process_Globals
	Private iCloudKVS As NativeObject
End Sub

'create explicit app it
'add below code to main region
'<code>#Entitlement: <key>com.apple.developer.ubiquity-kvstore-identifier</key><string>2Z8J7LMQ63.YOUR_BUNDLEID</string></code>
Public Sub Initialize
	iCloudKVS = iCloudKVS.Initialize("NSUbiquitousKeyValueStore").GetField("defaultStore")
End Sub

Public Sub PutMap(Key As String, m As Map)
	iCloudKVS.RunMethod("setDictionary:forKey:", Array(m.ToDictionary, Key))
	Log("synchronize result: "  & iCloudKVS.RunMethod("synchronize", Null).AsBoolean)
End Sub

Public Sub GetMap(Key As String) As Map
	Dim dict As Object = iCloudKVS.RunMethod("dictionaryForKey:", Array(Key))
	If dict = Null Then
		Dim res As Map
		Return res 'will be uninitialized
	End If
	Dim B4IMap As NativeObject
	Return B4IMap.Initialize("B4IMap").RunMethod("convertToMap:", Array(dict))
End Sub