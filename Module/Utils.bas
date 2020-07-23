Type=StaticCode
Version=1.21
ModulesStructureVersion=1
B4i=true
@EndOfDesignText@
'Code module

Sub Process_Globals
	'These global variables will be declared once when the application starts.
	'Public variables can be accessed from all modules.

End Sub
Sub NSRectToRect(StringFromASString As String) As Rect

	StringFromASString = StringFromASString.Replace("NSRect: ","")
	StringFromASString = StringFromASString.Replace("{","")
	StringFromASString = StringFromASString.Replace("}","")
	Dim R() As String = Regex.Split(",",StringFromASString)
	Dim TRect As Rect
	TRect.Initialize(R(0),R(1),R(0) + R(2),R(1) + R(3))
	Return TRect
End Sub