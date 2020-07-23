B4i=true
Group=Libraries
ModulesStructureVersion=1
Type=StaticCode
Version=4.3
@EndOfDesignText@
'Code module

Private Sub Process_Globals
	Private su As StringUtils
End Sub

Sub Decrypt(Data As String,Key As String) As String

	Dim c As Cipher
	Dim res() As Byte
	res = c.Decrypt(su.DecodeBase64(Data),Key)
	Return BytesToString(res,0,res.Length,"UTF-8")
	
End Sub

Sub Encrypt(Data As String,Key As String) As String

	Dim c As Cipher
	Return su.EncodeBase64(c.Encrypt(Data.GetBytes("UTF8"),Key))
	
End Sub