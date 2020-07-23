B4i=true
Group=Libraries
ModulesStructureVersion=1
Type=Class
Version=4.3
@EndOfDesignText@
#Event: Success(Bitmap1 As Bitmap, Tag As Object)
#Event: onGetBitmap(Tag As Object, getBitmap As Bitmap)
#Event: Error(Tag As Object)

#IgnoreWarnings:19,2,12

Private Sub Class_Globals
	Private CenterCrop2 As Boolean
	Private ErrorDrawable2 As Bitmap
	Private PlaceholderDrawable2 As Bitmap
	Private Resize_Width,ResizeHeight As Int
	Private Rotate2 As Float
	Private Factor2 As Float
	Private SkipCache2 As Boolean
	Private Url2 As String
	Type DefaultTarget(EventName As String,Tag As Object)
	Private CurrentImageview1 As ImageView
	Private moduels As Object
	Private FileDir2 As String
	Private cache_folder As String
End Sub

'After apply properties,call IntoImageView or IntroTarget
Public Sub Initialize(Module As Object) As Picasso
	File.MakeDir(File.DirLibrary,"cache")
	moduels = Module
	Return Me
End Sub

Public Sub LoadUrl(Url As String) As Picasso
	Url2		= Url
	Return Me
End Sub

Public Sub LoadFile(Path As String) As Picasso
	FileDir2		= Path
	Return Me
End Sub

Public Sub CenterCrop  As Picasso
	CenterCrop2	=	True
	Return Me
End Sub

Public Sub ErrorDrawable(Bitmap As Bitmap) As Picasso
	ErrorDrawable2	=	Bitmap
	Return Me
End Sub

Public Sub PlaceholderDrawable(Bitmap As Bitmap) As Picasso
	PlaceholderDrawable2	=	Bitmap
	Return Me
End Sub

Public Sub Resize(Width As Int,Height As Int) As Picasso
	Resize_Width = Width
	ResizeHeight = Height
	Return Me
End Sub

Public Sub Rotate(Degress As Float) As Picasso
	Rotate2 = Degress
	Return Me
End Sub

Public Sub Scale(Factor As Float) As Picasso
	Factor2 = Factor
	Return Me
End Sub

Public Sub SkipCache As Picasso
	SkipCache2 = True
	Return Me
End Sub

Public Sub IntoTarget(Target As DefaultTarget)

	Dim img As View
	
	If FileDir2 <> "" Then
		Dim temp As Bitmap
		If Target.Tag Is View Then
			img		=	Target.Tag
			temp	=	ShowBitmap(LoadBitmapResize("",FileDir2,img.Width,img.Height,True))
		Else
			temp	=	ShowBitmap(LoadBitmap("",FileDir2))
		End If
		If SubExists(moduels,Target.EventName.ToLowerCase & "_ongetbitmap",2) Then
			CallSubDelayed3(moduels,Target.EventName.ToLowerCase & "_ongetbitmap",Target.Tag,temp)
		Else
			CallSubDelayed3(moduels,Target.EventName.ToLowerCase & "_success",temp,Target.Tag)
		End If
		Return
	End If
	
	If File.Exists(File.DirLibrary & "/cache",EncodeBase64(Url2)) And SkipCache2 = False Then
		
		Dim temp As Bitmap
		temp	=	ShowBitmap(LoadBitmap(File.DirLibrary & "/cache",EncodeBase64(Url2)))
		
		If SubExists(moduels,Target.EventName.ToLowerCase & "_ongetbitmap",2) Then
			CallSubDelayed3(moduels,Target.EventName.ToLowerCase & "_ongetbitmap",Target.Tag,temp)
		Else
			CallSubDelayed3(moduels,Target.EventName.ToLowerCase & "_success",temp,Target.Tag)
		End If
		
		Return
	End If
	
	Try
		#if debug
			JobRequest2(Target)
		#else
			No(Me).RunMethod("RunThread2:::",Array(Me,"JobRequest2",Target))
		#End If
		
	Catch
	End Try
	
End Sub

Sub JobRequest2(Target As DefaultTarget)
	
	Try
		Dim Job1 As HttpJob
		Job1.Initialize("download",Me)
		Job1.Tag	= Url2
		Job1.Download(Url2)
	
		Wait For JobDone(Job As HttpJob)
		If Job.Success Then
			
			Dim temp As Bitmap
			temp = ShowBitmap(Job.GetBitmap)
			
			If SkipCache2 = False Then
				SaveBitmap(temp,File.DirLibrary & "/cache",EncodeBase64(Job.Tag),GetExtension(Job.Tag),100)
			End If
			
			Dim ev As String
			ev = Target.EventName
			
			If SubExists(moduels,Target.EventName.ToLowerCase & "_ongetbitmap",2) Then
				CallSubDelayed3(moduels,Target.EventName.ToLowerCase & "_ongetbitmap",Target.Tag,temp)
			Else
				CallSubDelayed3(moduels,ev.ToLowerCase & "_success",temp,Target.Tag)
			End If
			
			If ErrorDrawable2.IsInitialized Then
				CurrentImageview1.Bitmap	=	ErrorDrawable2
			End If
			
		End If
		
		Job.Release
	Catch
		
	End Try
	
End Sub

'Use this methdod after load picture from Local or Network
Public Sub IntoImageView(Imageview1 As ImageView)
	
	CurrentImageview1	=	Imageview1
	
	If PlaceholderDrawable2.IsInitialized Then
		Imageview1.Bitmap = PlaceholderDrawable2
	End If
	
	If FileDir2 <> "" Then
		Dim temp As Bitmap
		temp	=	ShowBitmap(LoadBitmap("",FileDir2))
		Imageview1.Bitmap = temp
		Return
	End If
	
	If File.Exists(File.DirLibrary & "/cache",EncodeBase64(Url2)) And SkipCache2 = False Then
		Imageview1.Bitmap	=	ShowBitmap(LoadBitmap(File.DirLibrary & "/cache",EncodeBase64(Url2)))
		Return
	End If
	
	Try
		#if debug
			JobRequest(Url2)
		#else
			No(Me).RunMethod("RunThread2:::",Array(Me,"JobRequest",Url2))
		#End If
		
	Catch
	End Try
		
End Sub

Private Sub JobRequest(Url As String)
	
	Dim Job1 As HttpJob
	Job1.Initialize("download",Me)
	Job1.Tag	= Url2
	Job1.Download(Url2)
	
	Try
		
		Wait For JobDone(Job As HttpJob)
		
		If Job.Success Then
			
			Dim temp As Bitmap
			temp = ShowBitmap(Job.GetBitmap)
			
			CurrentImageview1.Bitmap = temp
			
			If SkipCache2 = False Then
				SaveBitmap(temp,File.DirLibrary & cache_folder,EncodeBase64(Job.Tag),GetExtension(Job.Tag),100)
			End If
			
		Else
			
			If ErrorDrawable2.IsInitialized Then
				CurrentImageview1.Bitmap	=	ErrorDrawable2
			End If
			
		End If
		
		Job.Release
	
	Catch
	End Try
	
End Sub

Private Sub ShowBitmap(Bitmap1 As Bitmap) As Bitmap
	
	Dim temp As Bitmap
	
	If ResizeHeight > 0 And Resize_Width > 0 Then
		temp = Bitmap1.Resize(Resize_Width,ResizeHeight,True)
	Else
		temp = Bitmap1
	End If
	
	If CenterCrop2 Then
		temp	=	AutoCrop(temp,Resize_Width,ResizeHeight)
	End If
	
	If Rotate2 > 0 Then
		temp = temp.Rotate(Rotate2)
	End If
	
	If Factor2 > 0 Then
		temp = ScaleBitmap(temp,Factor2)
	End If
	
	Return temp	
	
End Sub

Public Sub ScaleBitmap(bmp As Bitmap, Scale3 As Float) As Bitmap
	Dim img As ImageView
	img.Initialize("")
	img.Width = bmp.Width * Scale3
	img.Height = bmp.Height * Scale3
	Dim cvs As Canvas
	cvs.Initialize(img)
	cvs.DrawBitmap(bmp, cvs.TargetRect)
	Dim res As Bitmap = cvs.CreateBitmap
	cvs.Release
	Return res
End Sub

'format is JPEG,PNG
'quality is between 0 and 100 , 100 is high quality
Private Sub SaveBitmap(Bitmap1 As Bitmap,Dir As String,Filename As String,Format As String,Quality As Int)
	Dim b1 As Bitmap
	Dim out As OutputStream
	b1 = Bitmap1
	out = File.OpenOutput(Dir,Filename,False)
	b1.WriteToStream(out,Quality,Format)
	out.Close
End Sub

Private Sub EncodeBase64(Data As String) As String
	If Data.Length = 0 Then Return ""
	Dim su As StringUtils
	Return su.EncodeUrl(Data,"UTF8")
End Sub

Private Sub GetFilename(fullpath As String) As String
	If fullpath.LastIndexOf("/") = -1 Then Return ""
	Dim filename As String
	filename = fullpath.SubString(fullpath.LastIndexOf("/") + 1)
	Return "mini_" & filename
End Sub

Private Sub GetExtension(fullpath As String) As String
	Dim ext As String
	ext = fullpath.SubString(fullpath.LastIndexOf(".") + 1)
	If ext.ToLowerCase = "jpg" Then ext = "jpeg"
	Return ext
End Sub

Private Sub No(obj As NativeObject) As NativeObject
	Return obj
End Sub

Private Sub bgDone

End Sub

Private Sub AutoCrop(bmp As Bitmap,MaxWidth As Int,MaxHeight As Int) As Bitmap
	
	Dim bmpRatio As Float = bmp.Width / bmp.Height
	Dim viewRatio As Float = MaxWidth / MaxHeight
	If viewRatio > bmpRatio Then
		Dim NewHeight As Int = bmp.Width / viewRatio
		bmp = bmp.Crop(0, bmp.Height / 2 - NewHeight / 2, bmp.Width, NewHeight)
	Else if viewRatio < bmpRatio Then
		Dim NewWidth As Int = bmp.Height * viewRatio
		bmp = bmp.Crop(bmp.Width / 2 - NewWidth / 2, 0, NewWidth, bmp.Height)
	End If
	
	Return bmp
	
End Sub

Public Sub FillImageToView(bmp As B4XBitmap, ImageView As B4XView)
	Dim bmpRatio As Float = bmp.Width / bmp.Height
	Dim viewRatio As Float = ImageView.Width / ImageView.Height
	If viewRatio > bmpRatio Then
		Dim NewHeight As Int = bmp.Width / viewRatio
		bmp = bmp.Crop(0, bmp.Height / 2 - NewHeight / 2, bmp.Width, NewHeight)
	Else if viewRatio < bmpRatio Then
		Dim NewWidth As Int = bmp.Height * viewRatio
		bmp = bmp.Crop(bmp.Width / 2 - NewWidth / 2, 0, NewWidth, bmp.Height)
	End If
	ImageView.SetBitmap(bmp.Resize(ImageView.Width, ImageView.Height, True))
End Sub

#If OBJC 

-(void)RunThread: (NSObject*)m :(NSString*)sub
{


dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
	[self.__c CallSub:self.bi :m :(sub)];
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [self.__c CallSub:self.bi :self :@"bgdone"];
		
    });
});
}

-(void)RunThread2: (NSObject*)m :(NSString*)sub :(id) param1
{


dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
	[self.__c CallSub2:self.bi :m :(sub) :param1];

    dispatch_async(dispatch_get_main_queue(), ^(void){
        [self.__c CallSub:self.bi :self :@"bgdone" ];
    });
});
}


-(void)RunThread3: (NSObject*)m :(NSString*)sub :(id) param1 :(id)param2
{


dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
	[self.__c CallSub3:self.bi :m :(sub) :param1 :param2];

    dispatch_async(dispatch_get_main_queue(), ^(void){
        [self.__c CallSub:self.bi :self :@"bgdone" ];
    });
});
}

-(void)RunThread4: (NSObject*)m :(NSString*)sub :(NSObject*) param1 :(id)param2 
{


dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){

	B4IStaticModule *objB4I=m;
	[objB4I.bi raiseEvent:nil event:(sub) params:@[(param1),(param2)]];
	
	NSLog(sub);
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [self.__c CallSub:self.bi :self :@"bgdone"];
    });
});
}

#End if