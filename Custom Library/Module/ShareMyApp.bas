Type=Class
Version=4.01
ModulesStructureVersion=1
B4i=true
@EndOfDesignText@
Private Sub Class_Globals
	
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize

End Sub

Sub startShare(Page1 As Page,Info As String)
	Dim avc As ActivityViewController
	avc.Initialize("avc", Array(Info))
	avc.Show(Page1, Page1.RootPanel)
End Sub

Sub avc_Complete (Success As Boolean, ActivityType As String)
	Log("Success share")
End Sub