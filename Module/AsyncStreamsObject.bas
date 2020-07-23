Type=Class
Version=1.21
ModulesStructureVersion=1
B4i=true
@EndOfDesignText@
#Event: NewObject (Key As String, Value As Object)
#Event: Terminated
#Event: ObjectSent (Key as String)
'Class module
'v1.10
Sub Class_Globals
	Private target As Object
	Private Event As String
	Private astream As AsyncStreams
	Public TempFolder As String
	Private FileToKey As Map
	Private TYPE_OBJECT = 1, TYPE_BITMAP = 2, TYPE_FILE = 3 As Byte
	Private waitingForAnotherStream As Boolean
	Private waitingForKey, waitingForName As String
	Private waitingForType As Byte
	Private connected As Boolean
End Sub

Public Sub Initialize (TargetModule As Object, EventName As String)
	target = TargetModule
	Event = EventName
	TempFolder = File.DirTemp
End Sub
'Tests whether there is an active connection
Public Sub getIsConnected As Boolean
	Return connected
End Sub

'Starts working with the given streams.
Public Sub Start(In As InputStream, Out As OutputStream)
	FileToKey.Initialize
	waitingForAnotherStream = False
	astream.InitializePrefix(In, True, Out, "astream")
	connected = True
End Sub
'Closes the connection
'The Terminated event will be raised.
Public Sub Close
	If astream.IsInitialized Then 
		astream.Close
		astream_Terminated
	End If
End Sub
'Sends an object. The object is written with RandomAccessFile.WriteObject.
'This method is capable of writing the following types of objects: Lists, Arrays, Maps, Strings, primitive types and user defined types.
Public Sub WriteObject (Key As String, Value As Object)
	Dim name(1) As String
	Dim raf As RandomAccessFile = sharedWrite(Key, name)
	raf.WriteByte(TYPE_OBJECT, raf.CurrentPosition)
	raf.WriteB4XObject(Value, raf.CurrentPosition)
	sharedWriteComplete(raf, name(0))
End Sub

'Sends a file. This method doesn't support files from the asset folder.
Public Sub WriteFile (Key As String, Dir As String, FileName As String)
	Dim len As Long = File.Size(Dir, FileName)
	If len = 0 Then
		Log("Error getting file size.")
		Return
	End If
	Dim name(1) As String
	Dim raf As RandomAccessFile = sharedWrite(Key, name)
	raf.WriteByte(TYPE_FILE, raf.CurrentPosition)
	sharedWriteComplete(raf, name(0))
	astream.WriteStream(File.OpenInput(Dir, FileName), len)
End Sub
'Sends a bitmap.
Public Sub WriteBitmap (Key As String, Value As Bitmap)
	Dim name(1) As String
	Dim raf As RandomAccessFile = sharedWrite(Key, name)
	raf.WriteByte(TYPE_BITMAP, raf.CurrentPosition)
	sharedWriteComplete(raf, name(0))
	Dim secondPart As String = "~" & name(0)
	Dim out As OutputStream = File.OpenOutput(TempFolder, secondPart, False)
	Value.WriteToStream(out, 100, "PNG")
	out.Close
	astream.WriteStream(File.OpenInput(TempFolder, secondPart), _
		File.Size(TempFolder, secondPart))
End Sub

Private Sub sharedWrite(Key As String, outName() As String) As RandomAccessFile
	Dim raf As RandomAccessFile
	Dim name As String = GetAvailableFile(Key)
	File.Delete(TempFolder, name)
	File.Delete(TempFolder, "~" & name) 'delete the second part of the message if such exist
	raf.Initialize(TempFolder, name , False)
	raf.WriteB4XObject(Key, raf.CurrentPosition)
	raf.WriteB4XObject(name,raf.CurrentPosition)
	outName(0) = name
	Return raf
End Sub

Private Sub sharedWriteComplete(raf As RandomAccessFile, name As String)
	Dim length As Long = raf.CurrentPosition
	raf.Close
	astream.WriteStream(File.OpenInput(TempFolder, name), length)
End Sub

Private Sub astream_NewStream (Dir As String, FileName As String)
	Dim value As Object
	Dim deleteFile As Boolean = True
	If waitingForAnotherStream Then
		waitingForAnotherStream = False
		'this is the second part of the object
		Select waitingForType
			Case TYPE_BITMAP
				value = LoadBitmap(Dir, FileName)
			Case TYPE_FILE
				value = FileName 'just return the file name
				deleteFile = False
		End Select
	Else
		Dim raf As RandomAccessFile
		raf.Initialize(Dir, FileName, True)
		waitingForKey = raf.ReadB4XObject(raf.CurrentPosition)
		waitingForName = raf.ReadB4XObject(raf.CurrentPosition)
		waitingForType = raf.ReadSignedByte(raf.CurrentPosition)
		Select waitingForType
			Case TYPE_OBJECT
				value = raf.ReadB4XObject(raf.CurrentPosition)
				raf.Close
			Case TYPE_FILE, TYPE_BITMAP
				'wait for the second part of the message
				waitingForAnotherStream = True
				raf.Close
				File.delete(Dir, FileName)
				Return '<--- return!!!
		End Select
	End If
	waitingForAnotherStream = False
	If deleteFile Then File.delete(Dir, FileName)
	CallSub3(target, Event & "_NewObject", waitingForKey, value)
	astream.Write(waitingForName.GetBytes("UTF8"))
End Sub

Private Sub astream_NewData (Buffer() As Byte)
	Dim fileName As String = BytesToString(Buffer, 0, Buffer.Length, "UTF8")
	File.Delete(TempFolder, fileName)
	File.Delete(TempFolder, "~" & fileName) 'delete the second part of the message if such exist
	Dim key As String = FileToKey.Get(fileName)
	FileToKey.Remove(fileName)
	CallSub2(target, Event & "_ObjectSent", key)
End Sub

Private Sub GetAvailableFile (key As String) As String
	Dim i As Int = 1
	Do While FileToKey.ContainsKey("ao" & i)
		i = i + 1
	Loop
	FileToKey.Put("ao" & i, key)
	Return "ao" & i
End Sub

Private Sub astream_Error
	Log("astream_Error: " & LastException)
	astream.Close
	astream_Terminated 'manually call the terminated sub as it will not be called when we close the stream
End Sub

Private Sub astream_Terminated
	Log("astream_Terminated")
	connected = False
	CallSub(target, Event & "_Terminated")
End Sub



