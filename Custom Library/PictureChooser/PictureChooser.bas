B4i=true
Group=Libraries
ModulesStructureVersion=1
Type=StaticCode
Version=4.3
@EndOfDesignText@
Private Sub Process_Globals
	Private media As Camera
	Private event As String
	Private Module1 As Object
	Private nome As NativeObject
	Private is_crop As Boolean
	Private Nav As NavigationController
	Private p2 As Page
	Private Page1 As Page
	Private current_bitmap As Bitmap
	Private IsScale As Boolean
	Private IsCircular As Boolean
	Private sWidth,sHeight As Int
	Public CropTitle As String = "بریدن تصویر"
	Public ButtonCancelTitle As String = "بیخیال"
	Public ButtonDoneTitle As String = "تایید"
	Private filename_ As String
End Sub

'Initializes the object. You can add parameters to this method if needed.
'Min version is 10
'add below plist
'#PlistExtra:<key>NSPhotoLibraryUsageDescription</key><string>Select a photo.</string>
'#PlistExtra:<key>NSCameraUsageDescription</key><string>Taking a photo.</string>
'#PlistExtra:<key>NSMicrophoneUsageDescription</key><string>Record video.</string>
'
'Events:
'Result(Bitmap As Bitmap)
'Result2(Dir As String,Filename As String)

Public Sub Initialize(Page As Page,Module As Object,EventResult As String,NavigationController1 As NavigationController)
	
	Nav		= NavigationController1
	event	= EventResult
	Module1	= Module
	
	p2 = Page
	nome.Initialize("")
	filename_	=	"temp.jpg"
	
End Sub

Public Sub SetFilename(Filename As String)
	filename_	=	Filename
End Sub

Public Sub ChooseFromGallery
	media.Initialize("camera",p2)
	media.SelectFromPhotoLibrary(p2.RootPanel,media.TYPE_IMAGE)
End Sub

'Output picture is JPG
Public Sub ChooseFromCamera
	media.Initialize("camera",p2)
	media.TakePicture
End Sub

'Crop picture after select from gallery or camera
'please add layout for crop picture
Public Sub setCrop(Value As Boolean)
	is_crop	=	Value
End Sub

Public Sub setResizedOutput(Width As Int,Height As Int)
	sWidth	=	Width
	sHeight	=	Height
End Sub

'if set True,only square mode user can crop
Sub setScaleCrop(Value As Boolean)
	IsScale	=	Value
End Sub

Sub setIsCircular(Value As Boolean)
	IsCircular	=	Value
End Sub

Public Sub ChooseVideo
	media.TakeVideo
End Sub

Public Sub getFilename As String
	
End Sub

Private Sub camera_Complete (Success As Boolean, Image As Bitmap, VideoPath As String)

	If Success Then
		
		If VideoPath = "" Then
			
			If is_crop = True Then
				CropBitmap(Image)
				Return
			End If

			If sWidth > 0 And sHeight > 0 Then
				If Image.Width > sWidth Or Image.Height > sHeight Then
					Image	=	Image.Resize(sWidth,sHeight,True)
				End If
			End If
			
			If SubExists(Module1,event & "_result2",2) Then
				SaveBitmap(Image,File.DirLibrary,filename_)
				CallSubDelayed3(Module1,event & "_Result2",File.DirLibrary,filename_)
			Else
				CallSubDelayed2(Module1,event & "_result",Image)
			End If
		Else
			If SubExists(Module1,event & "_result2",2) Then
				CallSubDelayed3(Module1,event & "_Result2",VideoPath,"")
			End If
		End If
	
	Else
		
	End If
	
End Sub

#region Bitmap feature
Public Sub RotateBitmap(Original As Bitmap, Degree As Float) As Bitmap
	Return RotateImageByDegrees(Original,Degree)
End Sub

Public Sub ResizeBitmap(Original As Bitmap, Width As Int, Height As Int) As Bitmap
	
	Dim scale As Int
	scale	=	Min(Width / Original.Width,Width / Original.Height)
	
	Dim img As ImageView
	img.Initialize("")
	img.Width = Original.Width * scale
	img.Height = Original.Height * scale
	Dim cvs As Canvas
	cvs.Initialize(img)
	cvs.DrawBitmap(Original, cvs.TargetRect)
	Dim res As Bitmap = cvs.CreateBitmap
	cvs.Release
	Return res

End Sub

Public Sub ResizePicture(Dir As String, Filename As String, OutputFilename As String,Width As Int,Height As Int)
	
	Dim bt As Bitmap
	bt	=	LoadBitmap(Dir,Filename)
	
	SaveBitmap(ResizeBitmap(bt,Width,Height),Dir,OutputFilename)
	
End Sub

'save picture with jpeg format
Public Sub SaveBitmap(Bitmap As Bitmap,Dir As String,Filename As String)
	Dim b1 As Bitmap
	Dim out As OutputStream
	b1 = Bitmap
	out = File.OpenOutput(Dir,Filename,False)
	b1.WriteToStream(out,100,"JPEG")
	out.Close
End Sub

'save picture with png format
Public Sub SaveBitmap2(Bitmap As Bitmap,Dir As String,Filename As String)
	Dim b1 As Bitmap
	Dim out As OutputStream
	b1 = Bitmap
	out = File.OpenOutput(Dir,Filename,False)
	b1.WriteToStream(out,100,"JPEG")
	out.Close
End Sub

Public Sub RoundBitmap(Bitmap As Bitmap) As Bitmap
	Return RoundBitmap3(Bitmap,Bitmap.Width/2)
End Sub

Public Sub RoundBitmap2(Bitmap As Bitmap,Corner As Int) As Bitmap
	Return RoundBitmap3(Bitmap,Corner)
End Sub

Private Sub RotateImageByDegrees(original As Bitmap, degree As Float) As Bitmap
	original= nome.RunMethod("imageRotatedByDegrees::", Array(original,degree))
	Return original
End Sub

#IgnoreWarnings: 12
Private Sub RotateImageByRadians(original As Bitmap, radians As Float) As Bitmap
	original= nome.RunMethod("imageRotatedByRadians::", Array(original,radians))
	Return original
End Sub

Private Sub RoundBitmap3(Bitmap As Bitmap,Corner As Int) As Bitmap
	
	Dim img As ImageView
	img.Initialize("")
	p2.RootPanel.AddView(img,-Bitmap.Width,0,Bitmap.Width,Bitmap.Height)
	img.Bitmap = Bitmap
	img.SetBorder(0,Colors.Transparent,Corner)
	
	Dim img2 As ImageView
	img2.Initialize("")
	p2.RootPanel.AddView(img2,-Bitmap.Width,-Bitmap.Height,Bitmap.Width,Bitmap.Height)
	
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
#end region

Public Sub CropBitmap(bitmap1 As Bitmap)
	
	Page1.Initialize("page1")
	Page1.Title = "Crop"
	Page1.RootPanel.Color = Colors.White
	Nav.ShowPage(Page1)

	current_bitmap = bitmap1
	
End Sub

Private Sub page1_Resize(Width As Int,Height As Int)

	Dim objImage As Bitmap
	objImage	=	current_bitmap
   
	Dim objCrop As iCropView
	objCrop.DebugMode = True
	objCrop.Initialize("objCrop")
	
	If IsScale Then
		objCrop.HideAspectButton = True
		objCrop.LockAspectRatio = True
		objCrop.IsSquare = True
	Else
		objCrop.IsSquare = False
		objCrop.LockAspectRatio = False
		objCrop.HideAspectButton = False
	End If
	
	If IsCircular Then
		objCrop.IsCircular	=	True
	End If

	objCrop.ButtonCancel = ButtonCancelTitle
	objCrop.ButtonDone = ButtonDoneTitle
	objCrop.Title = CropTitle
	objCrop.ToolbarOnTop = False
	objCrop.Start(Page1, objImage)
	
End Sub

Private Sub objCrop_onDone(ImageCropped As Bitmap)
	
	Nav.RemoveCurrentPage2(False)

	If sWidth > 0 And sHeight > 0 Then
		If ImageCropped.Width > sWidth Or ImageCropped.Height > sHeight Then
			ImageCropped	=	ImageCropped.Resize(sWidth,sHeight,True)
		End If
	End If
	
	If SubExists(Module1,event & "_result2",2) Then
		SaveBitmap(ImageCropped,File.DirLibrary,"temp.jpg")
		CallSubDelayed3(Module1,event & "_Result2",File.DirLibrary,"temp.jpg")
	Else
		CallSubDelayed2(Module1,event & "_result",ImageCropped)
	End If
	
End Sub

Private Sub objCrop_onCancel()
	
	current_bitmap = Null
	File.Delete(File.DirLibrary,"temp.jpg")
	Nav.RemoveCurrentPage2(False)

End Sub