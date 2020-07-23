Type=StaticCode
Version=4.01
ModulesStructureVersion=1
B4i=true
@EndOfDesignText@
'Code module

Sub Process_Globals
	'These global variables will be declared once when the application starts.
	'Public variables can be accessed from all modules.

End Sub

Sub LoadFromAssets(FontName As String,FontSize As Int) As Font
	
	Dim fa As Font

	fa = Font.CreateNew2(FontName.Replace(".ttf",""),FontSize)
	Return fa
	
End Sub