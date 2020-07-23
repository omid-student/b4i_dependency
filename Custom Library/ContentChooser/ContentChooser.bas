B4i=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=4.01
@EndOfDesignText@
#Event: Result2 (Success As Boolean,Bitmap As Bitmap)
#Event: Result (Dir As String, FileName As String)
Private Sub Class_Globals
	Private ev As String
	Private ob As Object
	Private camera As Camera
	Public MIME_IMAGE As Int : MIME_IMAGE = camera.TYPE_IMAGE
	Public MIME_VIDEO As Int : MIME_IMAGE = camera.TYPE_MOVIE
	Public MIME_ALL As Int : MIME_IMAGE = camera.TYPE_ALL
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(Event As String,Page As Page,Module As Object)

	ev = Event
	ob = Module
	
	camera.Initialize("cc",Page)
	
End Sub

'Select photo from library
'MimeType is :
'MIME_IMAGE
'MIME_VIDEO
'MIME_ALL
'
'Note: if you use MIME_VIDEO so it raise event Result (Dir As String, FileName As String)
'Filename is contain video path
Sub Show(MimeType As Int,Title As String)
	camera.SelectFromSavedPhotos(Null,MimeType)
End Sub

'Select photo from taken with camera
Sub ShowCamera
	camera.TakePicture
End Sub

Private Sub cc_Complete (Success As Boolean, Image As Bitmap, VideoPath As String)
	
	If Success Then
		
		If Image.IsInitialized Then
			SaveBitmap(Image,File.DirTemp,"test.jpg")
			
			If SubExists(ob,ev & "_result",2) Then
				CallSubDelayed3(ob,ev & "_result",File.DirTemp,"test.jpg")
				
			Else if SubExists(ob,ev & "_result2",2) Then
				CallSubDelayed3(ob,ev & "_result2",True,Image)
				
			End If
		
		Else if VideoPath.Length > 0 Then
			If SubExists(ob,ev & "_result",2) Then
				CallSubDelayed3(ob,ev & "_result","",VideoPath)
						
			End If
		End If
		
	Else
		CallSubDelayed3(ob,ev & "_result",False,Null)
	End If
	
End Sub

Public Sub SaveBitmap(Bitmap As Bitmap,Dir As String,Filename As String)
	
	Dim b1 As Bitmap
	Dim out As OutputStream
	b1 = Bitmap
	out = File.OpenOutput(Dir,Filename,False)
	b1.WriteToStream(out,100,"PNG")
	out.Close
	
End Sub

Sub ResizeBitmap(Bitmap1 As Bitmap, Scale As Float) As Bitmap
	Dim img As ImageView
	img.Initialize("")
	img.Width = Bitmap1.Width * Scale
	img.Height = Bitmap1.Height * Scale
	Dim cvs As Canvas
	cvs.Initialize(img)
	cvs.DrawBitmap(Bitmap1, cvs.TargetRect)
	Dim res As Bitmap = cvs.CreateBitmap
	cvs.Release
	Return res
End Sub

Sub RoundBitmap(Page As Page,Bitmap As Bitmap,CornerRaduis As Float) As Bitmap
	
	Dim img As ImageView
	img.Initialize("")
	Page.RootPanel.AddView(img,0,0,Bitmap.Width,Bitmap.Height)
	img.Bitmap = Bitmap
	img.SetBorder(0,Colors.Transparent,CornerRaduis)
	
	Dim img2 As ImageView
	img2.Initialize("")
	Page.RootPanel.AddView(img2,-Bitmap.Width,-Bitmap.Height,Bitmap.Width,Bitmap.Height)
	
	Dim cvs As Canvas
	cvs.Initialize(img)
	Dim dest As Rect
	dest.Initialize(0, 0, img.Width, img.Height)
	cvs.DrawView(img2, dest)
	cvs.Refresh
	
	Dim output As Bitmap
	output = cvs.CreateBitmap
	
	img.RemoveViewFromParent
	img2.RemoveViewFromParent
	
	Return output
	
End Sub