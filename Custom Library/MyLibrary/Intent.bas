B4i=true
Group=Libraries
ModulesStructureVersion=1
Type=Class
Version=6.8
@EndOfDesignText@
Private Sub Class_Globals
	Private da_ As String
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize
	
End Sub

Public Sub GetData As String
	Return da_
End Sub

Public Sub SetData(Val As String)
	da_ = Val
End Sub