B4i=true
Group=Libraries
ModulesStructureVersion=1
Type=Class
Version=6.8
@EndOfDesignText@
Private Sub Class_Globals
	
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize
	
End Sub

Public Sub OpenBrowser(Url As String)
	
	Try
		Main.App.OpenURL(Url)
	Catch
		
	End Try
	
End Sub