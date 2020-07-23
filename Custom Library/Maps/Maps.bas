B4i=true
Group=Library\Main
ModulesStructureVersion=1
Type=Class
Version=4.81
@EndOfDesignText@
Private Sub Class_Globals
	Private Map2 As Map
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize
	Map2.Initialize
End Sub

Public Sub Put(Key As Object,Value As Object)
	
	Dim m As Map
	m.Initialize
	
	For Each k As String In Map2.Keys
		m.Put(k,Map2.Get(k))
	Next
	
	m.Put(Key,Value)
	
	Map2 = m
	
End Sub

Public Sub GetKeyAt(Index As Int) As Object
	
	Dim offset As Int
	
	For Each k As String In Map2.Keys
		If offset = Index Then Return Map2.Get(k)
		offset = offset + 1
	Next
	
	Return ""
	
End Sub

Public Sub Clear
	Map2.Clear
End Sub

Public Sub ContainsKey(Key As Object) As Boolean
	Return Map2.ContainsKey(Key)
End Sub

Public Sub Get(Key As Object) As Object
	Return Map2.Get(Key)
End Sub

Public Sub GetDefault(Key As Object,Default As Object) As Object
	
	If Map2.ContainsKey(Key) Then
		Return Map2.Get(Key)
	Else
		Return Default
	End If

End Sub

Public Sub IsReadOnly As Boolean
	Return Map2.IsReadOnly
End Sub

Public Sub Keys As Object
	Return Map2.Keys
End Sub

Public Sub Remove(Key As Object)
	Map2.Remove(Key)
End Sub

Public Sub Size As Int
	Return Map2.Size
End Sub

Public Sub Values As Object
	Return Map2.Values
End Sub

Public Sub AsMap As Map
	Return Map2
End Sub