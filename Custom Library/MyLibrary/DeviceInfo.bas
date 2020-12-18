B4i=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=4.3
@EndOfDesignText@
#IgnoreWarnings:19,2,12

Private Sub Process_Globals
	'These global variables will be declared once when the application starts.
	'Public variables can be accessed from all modules.

End Sub

Sub GetDeviceID As String
	Dim no As NativeObject
	no = no.Initialize("UIDevice").RunMethod("currentDevice", Null)
	Dim id As Object = no.GetField("identifierForVendor").GetField("UUIDString")
	Return id
End Sub

Sub GetDeviceSystemName As String
	' get the system name of the device
	Dim device As NativeObject
	device = device.Initialize("UIDevice").RunMethod("currentDevice", Null)
	Dim name As Object = device.GetField("systemName").AsString
	Return name
End Sub

Sub GetDeviceModel As String
	' get the device model
	Dim device As NativeObject
	device = device.Initialize("UIDevice").RunMethod("currentDevice", Null)
	Dim name As Object = device.GetField("model").AsString
	Return name
End Sub

Sub GetDeviceName As String
	' get the device name
	Dim device As NativeObject
	device = device.Initialize("UIDevice").RunMethod("currentDevice", Null)
	Dim name As Object = device.GetField("name").AsString
	Return name
End Sub

Sub GetIMEI As String
	' get device unique identifier
	Dim device As NativeObject
	device = device.Initialize("UIDevice").RunMethod("currentDevice", Null)
	Dim name As String = device.GetField("identifierForVendor").AsString
	Return name
End Sub

Sub GetPackageName As String
	' get your app package name
	Dim no As NativeObject
	no = no.Initialize("NSBundle").RunMethod("mainBundle", Null)
	Dim name As Object = no.RunMethod("objectForInfoDictionaryKey:", Array("CFBundleIdentifier"))
	Return name
End Sub

Sub GetAppName As String
	' get app name
	Dim no As NativeObject
	no = no.Initialize("NSBundle").RunMethod("mainBundle", Null)
	Dim name As Object = no.RunMethod("objectForInfoDictionaryKey:", Array("CFBundleDisplayName"))
	Return name
End Sub

Sub GetAppVersionCode As String
	Dim no As NativeObject
	no = no.Initialize("NSBundle").RunMethod("mainBundle", Null)
	Dim name As Object = no.RunMethod("objectForInfoDictionaryKey:", Array("CFBundleShortVersionString"))
	Dim temp As String
	temp = name
	Return temp.SubString2(0,1)
End Sub

Sub GetAppVersionName As String
	Dim no As NativeObject
	no = no.Initialize("NSBundle").RunMethod("mainBundle", Null)
	Dim name As Object = no.RunMethod("objectForInfoDictionaryKey:", Array("CFBundleShortVersionString"))
	Return name
End Sub

Sub GetDevicePhysicalSize As Float
	Dim lv As LayoutValues
	lv = GetDeviceLayoutValues
	Return Sqrt(Power(lv.Height / lv.Scale / 160, 2) + Power(lv.Width / lv.Scale / 160, 2))
End Sub

Sub GetBatteryLevel As Float
	Dim no As NativeObject
	no = no.Initialize("UIDevice").RunMethod("currentDevice", Null)
	If no.GetField("batteryMonitoringEnabled").AsBoolean = False Then
		no.SetField("batteryMonitoringEnabled", True)
	End If
	Return no.GetField("batteryLevel").AsNumber
End Sub

Sub GetDeviceInfo(IsJson As Boolean) As Object
	
	Dim info As Map
	info.Initialize
	info.Put("ID",GetDeviceID)
	info.Put("SystemName",GetDeviceSystemName)
	info.Put("Model",GetDeviceModel)
	info.Put("Name",GetDeviceName)
	info.Put("Size",GetDevicePhysicalSize)
	info.Put("IMEI",GetIMEI)
	info.Put("Packagename",GetPackageName)
	info.Put("AppName",GetAppName)
	info.Put("AppVersion",GetAppVersionCode)
	
	If IsJson = False Then
		Return info
	Else
		Dim js As JSONGenerator
		js.Initialize(info)
		Return js.ToString	
	End If
	
End Sub

Sub OpenSetting
	Dim app As Application
	If app.OSVersion >= 8 Then
		app.OpenURL("app-settings:")
	End If
End Sub