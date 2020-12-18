B4i=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=5.3
@EndOfDesignText@
'Code module

Private Sub Process_Globals
	'These global variables will be declared once when the application starts.
	'Public variables can be accessed from all modules.

End Sub

Sub PackageName As String
	' get your app package name
	Dim no As NativeObject
	no = no.Initialize("NSBundle").RunMethod("mainBundle", Null)
	Dim name As Object = no.RunMethod("objectForInfoDictionaryKey:", Array("CFBundleIdentifier"))
	Return name
End Sub

Sub LabelName As String
	' get app name
	Dim no As NativeObject
	no = no.Initialize("NSBundle").RunMethod("mainBundle", Null)
	Dim name As Object = no.RunMethod("objectForInfoDictionaryKey:", Array("CFBundleDisplayName"))
	Return name
End Sub

Sub VersionCode As String
	Dim no As NativeObject
	no = no.Initialize("NSBundle").RunMethod("mainBundle", Null)
	Dim name As Object = no.RunMethod("objectForInfoDictionaryKey:", Array("CFBundleShortVersionString"))
	Dim temp As String
	temp = name
	temp = temp.Replace(".","")
	Return temp
End Sub

Sub VersionName As String
	Dim no As NativeObject
	no = no.Initialize("NSBundle").RunMethod("mainBundle", Null)
	Dim name As Object = no.RunMethod("objectForInfoDictionaryKey:", Array("CFBundleShortVersionString"))
	Return name
End Sub

Sub DeviceID As String
	
	Dim ph As Phone
	Dim name As String
	
	If ph.KeyChainGet("imei") = "" Then
		' get device unique identifier
		Dim device As NativeObject
		device = device.Initialize("UIDevice").RunMethod("currentDevice", Null)
		name = device.GetField("identifierForVendor").AsString
		ph.KeyChainPut("imei",name)
	Else
		name	=	ph.KeyChainGet("imei")
	End If
	
	Return name
	
End Sub

Sub App As Application
	Return Main.App
End Sub

Sub Sdk
	Dim no As NativeObject
	no.Initialize("GADRequest")
	Log(no.RunMethod("sdkVersion", Null).AsString)
End Sub