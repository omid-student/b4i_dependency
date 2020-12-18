B4i=true
Group=Libraries
ModulesStructureVersion=1
Type=Class
Version=6.8
@EndOfDesignText@
Private Sub Class_Globals
	Private lm As LocationManager
	Private mo As Object
	Type LocationSettingsResult(Status As Int)
	Type StatusCodes(SUCCESS As Int)
End Sub

'add below code to Main page project attribute
'<code>
'#PlistExtra:<key>UIBackgroundModes</key><array><string>location</string></array>
'#PlistExtra:<key>NSLocationAlwaysUsageDescription</key><string>Track your location in the background for better ad revenue.</string>
'#PlistExtra:<key>NSLocationUsageDescription</key><string>Used to display the current navigation data.</string>
'#PlistExtra:<key>NSLocationAlwaysAndWhenInUseUsageDescription</key><string>Track your location in the background for better ad revenue.</string>
'#PlistExtra:<key>NSLocationWhenInUseUsageDescription</key><string>Used to display the current navigation data.</string>
'</code>
Public Sub Initialize(Event As String)
	
	mo	=	B4XPages.GetManager.GetTopPage.B4XPage
	
	lm.Initialize("lm")
	
End Sub

Public Sub Connect
	
	If lm.IsAuthorized Or lm.AuthorizationStatus = lm.AUTHORIZATION_NOT_DETERMINED Then
		lm.Start(0)
		CallSubDelayed(mo,"Location_ConnectionSuccess")
	Else
		CallSubDelayed2(mo,"Location_ConnectionFailed",0)
	End If
	
End Sub

Public Sub Disconnect
	lm.Stop
End Sub

Private Sub lm_AuthorizationStatusChanged (Status As Int)
	
	If Status = lm.AUTHORIZATION_RESTRICTED Or Status = lm.AUTHORIZATION_DENIED Then
		Dim r As LocationSettingsResult
		r.Initialize
		r.Status	=	-1
		CallSubDelayed2(mo,"Location_LocationSettingsChecked",r)
	Else
		CallSubDelayed3(mo,"B4XPage_PermissionResult","",True)
	End If
	
End Sub

Private Sub lm_LocationChanged (Location1 As Location)
	CallSubDelayed2(mo,"Location_LocationChanged",Location1)
End Sub

Private Sub lm_LocationError
	CallSubDelayed2(mo,"Location_ConnectionFailed",0)
End Sub

Private Sub StartBackground(MinimumDistance As Double)
	Dim no As NativeObject = lm
	no = no.GetField("manager")
	If Main.App.OSVersion >= 8 Then
		no.RunMethod("requestAlwaysAuthorization", Null)
	End If
	no.SetField("distanceFilter", MinimumDistance)
	no.RunMethod("startUpdatingLocation", Null)
End Sub

'ActivityType:
'1 - Other
'2 - Automotive Navigation
'3 - Fitness
'4 - Other navigation
Sub AllowPauseLocationAutomatically(ActivityType As Int)
	Dim no As NativeObject = lm
	no = no.GetField("manager")
	no.SetField("activityType", ActivityType)
	no.SetField("pausesLocationUpdatesAutomatically", True)
End Sub