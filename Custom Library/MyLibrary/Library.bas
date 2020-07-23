B4i=true
Group=Libraries
ModulesStructureVersion=1
Type=StaticCode
Version=4.3
@EndOfDesignText@
#IgnoreWarnings: 12

Private Sub Process_Globals
	Private module_inputbox As Object
	Private event_inputbox As String
	Private tag_inputbox As Object
End Sub

Public Sub Intent_Call(Number As String)
	If Main.App.CanOpenUrl("telprompt:" & Number) = True Then
		Main.App.OpenURL("telprompt:" & Number)
	End If
End Sub

Public Sub Intent_SendSMS(Page1 As Page,ToNumber As String,Text As String)
	
	Dim sms As MessageComposer
	sms.Initialize("")
	
	If sms.CanSendText Then
		sms.Body	=	Text
		sms.SetRecipients(Array(ToNumber))
		sms.Show(Page1)	
	End If
	
End Sub

Public Sub Intent_SendMail(Page1 As Page,Email As String,Text As String)
	
	Dim sms As MessageComposer
	sms.Initialize("")
	
	If sms.CanSendText Then
		sms.Body	=	Text
		sms.SetRecipients(Array(Email))
		sms.Show(Page1)	
	End If
	
End Sub

Public Sub Intent_OpenUrl(Url As String)
	If Main.App.CanOpenUrl(Url) = True Then
		Main.App.OpenURL(Url)
	End If
End Sub

Public Sub Intent_OpenFile(Page1 As Page,Dir As String,Filename As String) As Boolean
	
	File.Copy(Dir,Filename,File.DirTemp,Filename)

	Dim avc As ActivityViewController
	avc.Initialize("avc", Array(CreateFileUrl(File.DirTemp,Filename)))
	avc.Show(Page1, Page1.RootPanel)
	
	Return True
	
End Sub

Sub Map2Json(Data As Map) As String
	
	If Data = Null Then Return "{}"
	If Data.IsInitialized = False Then Return "{}"
	
	Try
		Dim js As JSONGenerator
		js.Initialize(Data)
		Return js.ToString
	Catch
		Return ""
	End Try
	
End Sub

Sub List2Json(Data As List) As String
	
	If Data = Null Then Return "{}"
	If Data.IsInitialized = False Then Return "{}"
	
	Try
		Dim js As JSONGenerator
		js.Initialize2(Data)
		Return js.ToString
	Catch
		Return ""
	End Try
	
End Sub

Sub Json2Map(Data As String) As Map
	
	Try
		Dim js As JSONParser
		js.Initialize(Data)
		Return js.NextObject
	Catch
		Return Null
	End Try
	
End Sub

Sub Json2List(Data As String) As List
	
	Try
		Dim js As JSONParser
		js.Initialize(Data)
		Return js.NextArray
	Catch
		Return Null
	End Try
	
End Sub

Sub ChangeKeyMap(Maps2 As Map,Key As Object,Value As Object) As Map
	
	Dim m As Map
	m.Initialize
	
	For Each k As String In Maps2.Keys
		m.Put(k,Maps2.Get(k))
	Next
	
	m.Put(Key,Value)
	
	Return m
	
End Sub

Sub AddHideKeyboardToView (TextField1 As Object,Container As Panel)
	Dim no As NativeObject = TextField1
	no.SetField("inputAccessoryView",Container)
End Sub

'query sample : name=omid&id=1
Sub ExecuteDeleteMethodJob(httpJob2 As HttpJob,Url As String,Query As String)
	
	httpJob2.PostBytes(Url, Query.GetBytes("utf8"))
	Dim no As NativeObject = httpJob2.GetRequest
	no.GetField("object").RunMethod("setHTTPMethod:", Array("DELETE"))
	
End Sub

Sub CreateBadge(Color As Int,Text As String,Radius As Int,FontName As String) As Bitmap
	
	Dim mut As Bitmap
	mut.Initialize(File.DirAssets,"badge.png")
	Dim img As ImageView
	img.Initialize("")
	img.SetLayoutAnimated(1,1,0,0,30dip,30dip)
	img.Bitmap	=	mut
	
	Dim font_size As Int
	font_size	=	40
	
	Dim c As Canvas
	c.Initialize(img)
	c.DrawCircle(50dip,50dip,Radius,Color,True,0)
	
	Dim w,h,left As Int
	w = Text.MeasureWidth(Font.CreateNew2(FontName,font_size))
	h = Text.MeasureHeight(Font.CreateNew2(FontName,font_size))
	left	=	150dip / 2 - w / 2
	
	c.DrawText(Text,left,50dip+h/2,Font.CreateNew2(FontName,font_size),Colors.White,"CENTER")
	
	Return c.CreateBitmap
	
End Sub

'add sound file in Files/Special Folder
'sound file must be wav file
'sample:
'<code>
'Eample:
'Dim ln As Notification
'ln.Initialize(DateTime.Now + 4 * DateTime.TicksPerSecond) '6 seconds from now
'ln.IconBadgeNumber = 1
'ln.AlertBody = "Moo is hungry"
'ln.PlaySound = True
'ChangeNotificationSound("a.wav",ln)
'ln.Register
'</code>
Sub ChangeNotificationSound(Soundname As String,Notification As Notification)
	Dim No As NativeObject = Notification
	No.SetField("soundName", Soundname )
End Sub

Sub SetHUDOffset(App As Application,Offset As Float)
	Dim no1 As NativeObject = App.KeyController
	no1 = no1.GetField("view")
	Dim no2 As NativeObject
	Dim hud As NativeObject = no2.Initialize("MMBProgressHUD").RunMethod("HUDForView:", Array(no1))
	If hud.IsInitialized Then
		hud.SetField("yOffset", Offset)
	End If
End Sub

'example <code>HexToInt("#fffff")</code>
Sub HexToInt(Hex As String) As String
	Dim r,g,b As Int
	r = Bit.ParseInt(Hex.SubString2(1,3), 16)
	g = Bit.ParseInt(Hex.SubString2(3,5), 16)
	b = Bit.ParseInt(Hex.SubString2(5,7), 16)
	Return Colors.RGB(r, g, b)
End Sub

'period is 16 - daily, 32 - every hour, 64 - every minute
Public Sub RepeatNotification(Notification1 As Notification,period As Int)
	Dim no As NativeObject = Notification1
	no.SetField("repeatInterval", period)
End Sub

#Region Generate QR Code
Sub GenerateQR(Text As String,ImageView1 As ImageView)
	Dim NativeMe As NativeObject = Me
	NativeMe.RunMethod("createQRForString::", Array (Text,ImageView1))
End Sub

#If OBJC
- (void)createQRForString:(NSString *)qrString :(UIImageView *)qrImageView
{
  // Need To convert the string To a UTF-8 encoded NSData object
  NSData *stringData = [qrString dataUsingEncoding: NSISOLatin1StringEncoding];

  // Create the filter
  CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
  // Set the message content And error-correction level
  [qrFilter setValue:stringData forKey:@"inputMessage"];
  [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
 
   // Remove blur effect with scaling
   CGAffineTransform transform = CGAffineTransformMakeScale(100.0f,100.0f);
   CIImage *qrOutput = [qrFilter.outputImage imageByApplyingTransform: transform];

   //Convert CIImage to UIImage
   UIImage *qrImage = [[UIImage alloc] initWithCIImage:qrOutput];
 
   //Set Image to ImageView
   [qrImageView setImage:qrImage];
}
#End If
#End Region

'Doesn't work with assets files. You must first copy them.
Sub CreateFileUrl (Dir As String, FileName As String) As Object
	Dim no As NativeObject
	no = no.Initialize("NSURL").RunMethod("fileURLWithPath:", Array(File.Combine(Dir, FileName)))
	Return no
End Sub

#Region Input-Dialog with Objective C code
#If OBJC
- (void)ShowInputDialog:(NSString*)Input :(NSString*)Title :(NSString*)Message :(NSString*)OK :(NSString*)Cancel :(int)KeybardType
{
  UIAlertView * alert = [[UIAlertView alloc] initWithTitle:Title
    message:Message delegate:self cancelButtonTitle:Cancel otherButtonTitles:OK, nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;

    UITextField * alertTextField = [alert textFieldAtIndex:0];
    alertTextField.keyboardType = KeybardType;
   
    alertTextField.text = Input;
    alert.delegate = self;
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self.bi raiseEvent:nil event:@"inputdialog_result:" params:@[[[alertView textFieldAtIndex:0] text]]];
    }
}
#End If

'Input data send to _Result event with paramater input with string type
' InputType:
' 0 = UIKeyboardTypeDefault
' 1 = UIKeyboardTypeASCIICapable
' 2 = UIKeyboardTypeNumbersAndPunctuation
' 3 = UIKeyboardTypeURL
' 4 = UIKeyboardTypeNumberPad
' 5 = UIKeyboardTypePhonePad
' 6 = UIKeyboardTypeNamePhonePad
' 7 = UIKeyboardTypeEmailAddress
' 8 = UIKeyboardTypeDecimalPad
' 9 = UIKeyboardTypeTwitter
'10 = UIKeyboardTypeWebSearch
'11 = UIKeyboardTypeAlphabet
'12 = UIKeyboardTypeASCIICapable
Sub InputDialog(Module As Object,Event As String,Input As String, Title As String, Message As String, Positive As String, Cancel As String, InputType As Int,Tag As Object)
	module_inputbox =	Module
	event_inputbox	=	Event
	tag_inputbox	=	Tag
	Dim no As NativeObject = Me
    no.RunMethod("ShowInputDialog::::::", Array(Input, Title, Message, Positive, Cancel, InputType))
End Sub

private Sub InputDialog_Result(Text As String)
	If SubExists(module_inputbox,event_inputbox & "_result",1) Then
		CallSubDelayed2(module_inputbox,event_inputbox & "_result",Text)
	Else If SubExists(module_inputbox,event_inputbox & "_result",2) Then
		CallSubDelayed3(module_inputbox,event_inputbox & "_result",Text,tag_inputbox)
	End If
End Sub
#End Region

Sub GetStringResourse(StringResourse As String,Key As String) As String
	
	Dim str As String
	
	Dim match,match1 As Matcher
	match = Regex.Matcher($"<string name="${Key}">(\S+)</string>"$,StringResourse)
	
	If match.Find Then
		str = match.Group(1)
		Return str
	Else
		match1 = Regex.Matcher($"<string name="${Key}">([^a-zA-Z0-9]+)</string>"$,StringResourse)
		If match1.Find Then
			str = match1.Group(1)
			Return str
		Else
			match1 = Regex.Matcher($"<string name="${Key}">(.*)</string>"$,StringResourse)
			If match1.Find Then
				str = match1.Group(1)
				Return str
			Else
				Return ""
			End If
		End If
	End If
	
End Sub

Sub GetFilename(fullpath As String) As String
	Return fullpath.SubString(fullpath.LastIndexOf("/") + 1)
End Sub

Sub GetExtension(fullpath As String) As String
	Return fullpath.SubString(fullpath.LastIndexOf(".") + 1)
End Sub

#Region add image to csbuilder
Sub AppendImage(cs As CSBuilder, bmp As Bitmap,Bound As Rect)
	Dim attachment As NativeObject
	attachment = attachment.Initialize("NSTextAttachment").RunMethod("new", Null)
	attachment.SetField("image", bmp)
	Dim nme As NativeObject = Me
	'set bounds
	nme.RunMethod("SetBounds::", Array(attachment, attachment.MakeRect(Bound.Left,Bound.Top,Bound.Width,Bound.Height)))
	Dim attributedString As NativeObject
	attributedString = attributedString.Initialize("NSAttributedString") _
     .RunMethod("attributedStringWithAttachment:", Array(attachment))
	Dim no As NativeObject = cs
	no.RunMethod("appendAttributedString:", Array(attributedString))
End Sub

#if OBJC
-(void)SetBounds:(NSTextAttachment*) attachment :(NSData*)data {
   attachment.bounds = *(CGRect*)data.bytes;
}
#End If
#End Region

#Region Get shot from view
'example: Me
Sub GetScreenshot(Object2 As Object) As Bitmap
	Dim no As NativeObject = Object2
	Dim bmp As Bitmap = no.RunMethod("TakeScreenshot", Null)
	Return bmp
End Sub

#If OBJC
- (UIImage*) TakeScreenshot {
    UIView *view = [[UIApplication sharedApplication] keyWindow];
  float scale = [[UIScreen mainScreen] scale];
  CGRect bounds = [[UIApplication sharedApplication] keyWindow].rootViewController.view.bounds;
  BOOL shouldRotate = ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0f && bounds.size.width >= bounds.size.height);
  CGSize size = shouldRotate ? CGSizeMake(view.bounds.size.height, view.bounds.size.width) : view.bounds.size;

  UIGraphicsBeginImageContextWithOptions(size, YES, scale);
  CGContextRef ref = UIGraphicsGetCurrentContext();
  UIBezierPath *path = [UIBezierPath bezierPathWithRect:bounds];
  [[UIColor whiteColor] setFill];
  [path fillWithBlendMode:kCGBlendModeNormal alpha:1];
  if (shouldRotate) {

  CGContextConcatCTM(ref, CGAffineTransformMakeRotation((CGFloat) -M_PI_2));
  CGContextConcatCTM(ref, CGAffineTransformMakeTranslation(-size.height, 0));
  }
  [view drawViewHierarchyInRect:CGRectMake(0, 0, view.bounds.size.width, view.bounds.size.height) afterScreenUpdates:false];
  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return image;
}
#End If
#End Region

'Filetype supported: https://developer.apple.com/library...fiers.html#//apple_ref/doc/uid/TP40009259-SW1
'<code>
'#PlistExtra:<key>CFBundleDocumentTypes</key>
'#PlistExtra:<array><dict><key>CFBundleTypeIconFiles</key><array/>
'#PlistExtra: <key>CFBundleTypeName</key><string>CSV File</string>
'#PlistExtra:<key>LSItemContentTypes</key><array>
'#PlistExtra:<string>public.comma-separated-values-text</string>
'#PlistExtra:</array></dict></array>
'</code>
'
'For handle opening file with your app
'<code>
'Private Sub Application_OpenUrl (Url As String, Data As Object) As Boolean
'	If Url.StartsWith("file://") Then
'		Dim f As String = Url.SubString(7) 'remove the file:// scheme.
'		Try
'			Msgbox(File.ReadString("", f), "")
'		Catch
'			Msgbox("Error loading file", "")
'		End Try
'	End If
'	Return True
'End Sub
'</code>
Sub OpenAppWithFile(Filename As String)
	
End Sub

Sub GetFilenameWithoutExt(Filename As String) As String
	
	Dim ext As String
	ext = GetExtension(Filename)
	Return Filename.Replace("." & ext,"")
		
End Sub

Sub OpenFile(Page1 As Page,Dir As String,Name As String)
	
	Private di As DocumentInteraction
	di.Initialize("di", Dir, Name)
	di.OpenFile(Page1.RootPanel)
		
End Sub

#Region Play audio in background
'add #PlistExtra: <key>UIBackgroundModes</key><array><string>audio</string></array>
'<code>
'Private NativeMe As NativeObject
'NativeMe	=	Me
'NativeMe.RunMethod("setAudioSession", Null)
'vv.Initialize("vv")
'vv.LoadVideoUrl("url")
'vv.Play
'NativeMe.RunMethod("register", Null)
'</code>
'
'<code>
'Public Sub ControlEvent (Command As String)
'	Select Command
'		Case "play"
'			vv.Play
'		Case "pause"
'			vv.Pause
'	End Select
'End Sub
'</code>
'
'
'add below code in relate module
'<code>
'#If OBJC
'@import MediaPlayer;
'#import <AVFoundation/AVFoundation.h>
'#import <AudioToolbox/AudioToolbox.h>
'- (void)setAudioSession {
'  AVAudioSession *audioSession = [AVAudioSession sharedInstance];
'  NSError *err = nil;
'  BOOL success = [audioSession setCategory:AVAudioSessionCategoryPlayback error:&err];
'  if (success) {
'  success = [audioSession setActive:YES error:&err];
'  }
'  if (!success)
'  [NSException raise:@"" format:@"Error setting audio session: %@", err];
'}
'- (void)register {
'   MPRemoteCommandCenter* center = [MPRemoteCommandCenter sharedCommandCenter];
'   center.playCommand.enabled = true;
'   center.pauseCommand.enabled = true;
'   [center.playCommand addTarget:self action:@selector(play)];
'   [center.pauseCommand addTarget:self action:@selector(pause)];
'}
'- (void) play {
'   NSLog(@"test");
'   [self.bi raiseEvent:nil event:@"controlevent:"  params:@[@"play"]];
'}
'- (void) pause {
'   [self.bi raiseEvent:nil event:@"controlevent:"  params:@[@"pause"]];
'}
'#end if
'</code>
Sub PlaybackgroundAudio
	
End Sub
#End Region

'direction is :
'1 for right to left

Sub ConvertNumber2Currency(Numbers As Long) As String
	Return NumberFormat(Numbers,0,0)
End Sub

Sub ChangeDirectionCSBuilder(Cs As CSBuilder,Direction As Int)
	
	Dim no As NativeObject = Cs
	Dim paragraph As NativeObject
	paragraph = paragraph.Initialize("NSMutableParagraphStyle").RunMethod("new", Null)
	paragraph.SetField("baseWritingDirection", Direction) 'NSWritingDirectionRightToLeft
	no.RunMethod("addAttribute:value:range:", Array("NSParagraphStyle", paragraph, no.MakeRange(0, Cs.Length)))
	
End Sub

Sub ConvertDateTime2Tick(DateTime2 As String) As Long
	
	Dim time() As String
	time	=	Regex.Split(" ",DateTime2)
	
	DateTime.SetTimeZone(DateTime.TimeZoneOffset)
	DateTime.DateFormat	=	"yyyy-MM-dd"
	DateTime.TimeFormat	=	"HH:mm:ss"
	
	Dim tick As Long
	tick	=	DateTime.DateTimeParse(time(0),time(1))
	
	Return tick
	
End Sub

Sub GetTimestamp As Long
	Return DateTime.Now / DateTime.TicksPerSecond
End Sub

Sub ChangeNullValue(Map As Map) As Map
	
	Dim temp As Map
	temp.Initialize
	
	For Each key As String In Map.Keys
		If Map.Get(key) = Null Then
			temp.Put(key,"")
		Else
			temp.Put(key,Map.Get(key))
		End If
	Next
	
	Return temp
	
End Sub

Sub GetMapKeyWithIndex(Map As Map,Index As Int) As Object
	
	Dim ind As Int
	
	For Each key As String In Map.Keys
		If ind = Index Then Return key
		ind = ind + 1	
	Next
	
	Return ""
	
End Sub

Sub GetMapValueWithIndex(Map As Map,Index As Int) As Object
	
	Dim ind As Int
	
	For Each key As String In Map.Keys
		If ind = Index Then Return Map.Get(key)
		ind = ind + 1	
	Next
	
	Return ""
	
End Sub

Sub RandomNumber(Lowest As Double, Highest As Double, DecimalPlaces As Int, PreventZero As Boolean) As Double
	Lowest  = Round(Lowest)
	Highest = Round(Highest)
	Dim Decimal As Double
	If DecimalPlaces > 0 Then Decimal = (Rnd(0, Power(10, DecimalPlaces))) / Power(10, DecimalPlaces)
	If Lowest = Highest Then
		Return Lowest
	Else
		If Lowest > Highest Then
			Dim TempValue = Lowest As Double
			Lowest   = Highest
			Highest  = TempValue
		End If
		Dim ReturnValue = Lowest + Rnd(0, Highest - Lowest) + Decimal As Double
		If ReturnValue = 0 And PreventZero Then
			Return RandomNumber(Lowest, Highest, DecimalPlaces, PreventZero)
		Else
			Return ReturnValue
		End If
	End If
End Sub

Sub ConvertMillisecondsToString(t As Long) As String
	Dim hours, minutes, seconds As Int
	hours = t / DateTime.TicksPerHour
	minutes = (t Mod DateTime.TicksPerHour) / DateTime.TicksPerMinute
	seconds = (t Mod DateTime.TicksPerMinute) / DateTime.TicksPerSecond
	Return $"$2.0{hours}:$2.0{minutes}:$2.0{seconds}"$
End Sub

Sub ConvertSecond2Day(Seconds As Long) As Int
	Return Seconds / 59 / 59 / 24
End Sub

Sub GetDateFromDateTime(DT As String) As String
	
	Dim st() As String
	st = Regex.Split(" ",DT)
	Return st(0)
	
End Sub

Sub GetTimeFromDateTime(DT As String) As String
	
	Dim st() As String
	st = Regex.Split(" ",DT)
	Return st(1)
	
End Sub

Sub GetValueOfIndex(Map As Map,Index As Int) As Object
	
	Dim i As Int
	i	=	0
	
	For Each key As String In Map.Keys
		
		If i = Index Then
			Return Map.Get(key)
		Else
			i = i + 1
		End If
	Next
	
	Return i
	
End Sub

Sub Ping(Url As String, ResultsType As String, Attempts As Int, Timeout As Int) As ResumableSub

	Dim ht As HttpJob
	ht.Initialize("test",Me)
	ht.Download("http://google.com")
	Wait For (ht) JobDone(Job As HttpJob)
		Return Job.Success

End Sub

Sub SetDateTimeLocale (locale As String)
	Dim loc As NativeObject
	loc = loc.Initialize("NSLocale").RunMethod("localeWithLocaleIdentifier:", Array(locale))
	Dim no As NativeObject = DateTime
	no.GetField("dateFormat").SetField("locale", loc)
	no.GetField("timeFormat").SetField("locale", loc)
End Sub

Sub GetMapValue(Map As Map,Key As String) As Object
	
	If Map.IsInitialized Then
		If Map.ContainsKey(Key) Then
			Return Map.Get(Key)
		End If
	End If
	
	Return Null
	
End Sub

Sub CheckConnection As Boolean
	
	Dim NativeMe As NativeObject = Me
	Return NativeMe.RunMethod("isNetworkAvailable", Null).AsBoolean
	
	#if OBJC
	- (BOOL)isNetworkAvailable
	{
		CFNetDiagnosticRef dReference;        
		dReference = CFNetDiagnosticCreateWithURL (NULL, (__bridge CFURLRef)[NSURL URLWithString:@"www.google.com"]);

		CFNetDiagnosticStatus status;
		status = CFNetDiagnosticCopyNetworkStatusPassively (dReference, NULL);        

		CFRelease (dReference);

		if ( status == kCFNetDiagnosticConnectionUp )
		{
			return YES;
		}
		else 
		{
			return NO;
		}
	}
	#end if
	
End Sub

Sub FlashLight(Status As Boolean)
	Dim NativeMe As NativeObject = Me
	NativeMe.RunMethod("turnTorchOn:", Array (Status))
	#If ObjC
	#import <AVFoundation/AVFoundation.h>
	- (void) turnTorchOn: (bool) on {

	  // check if flashlight available
	  Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
	  if (captureDeviceClass != nil) {
	  AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
	  if ([device hasTorch] && [device hasFlash]){

	  [device lockForConfiguration:nil];
	  if (on) {
	  [device setTorchMode:AVCaptureTorchModeOn];
	  [device setFlashMode:AVCaptureFlashModeOn];
	  //torchIsOn = YES; //define as a variable/property if you need to know status
	  } else {
	  [device setTorchMode:AVCaptureTorchModeOff];
	  [device setFlashMode:AVCaptureFlashModeOff];
	  //torchIsOn = NO;   
	  }
	  [device unlockForConfiguration];
	  }
	  } }
#end if
End Sub

Sub GetCurrentSSID As String
	
	Dim NativeMe As NativeObject
	NativeMe = Me
	Dim ssid As String = NativeMe.RunMethod("currentWifiSSID", Null).AsString
	Return ssid
	
	#If OBJC

#import <SystemConfiguration/CaptiveNetwork.h>

- (NSString *)currentWifiSSID {
  // Does not work on the simulator.
  NSString *ssid = nil;
  NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
  for (NSString *ifnam in ifs) {
  NSDictionary *info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
  if (info[@"SSID"]) {
  ssid = info[@"SSID"];
  }
  }
  return ssid;
}
#end if
End Sub

Sub GetInputLanguage As String
	Dim NO As NativeObject = Me
	Return NO.RunMethod("getPrimaryLanguage",Null).AsString
	#if objc
	-(NSString *) getPrimaryLanguage {
	return [UITextInputMode currentInputMode].primaryLanguage;
	}
	#end if
End Sub

Sub GetShortDate(Date As String) As String

	DateTime.DateFormat = "yyyy-MM-dd"
	DateTime.TimeFormat = "HH:mm:ss"
	
	Dim tick As Long
	tick	=	DateTime.DateParse(Date)
	
	DateTime.SetTimeZone(DateTime.TimeZoneOffset)
	DateTime.DateFormat = "dd.MMMMMM.yyyy"
	Return	DateTime.Date(tick)
	
End Sub

Sub GetSimulatorID As String
	Dim no As NativeObject = Me
	Return no.RunMethod("simulatorId", Null).AsString
	#if ads
		#if objc
			#import <GoogleMobileAds/GoogleMobileAds.h>
			- (NSObject*)simulatorId {
			   return kGADSimulatorID;
			}
		#end if
	#end if
End Sub

'call subrotine with many argument
Sub CallSubX(Component As Object,SubName As String,Params() As Object)
	
	Dim no As NativeObject=Component
	Dim name As String=SubName
	Dim ll As List
	ll.Initialize2(Params)
	For i =0 To Params.Length-1
		name=name & ":"
	Next
	no.GetField("bi").RunMethod("raiseUIEvent:event:params:",Array(Null,name,ll))
   
End Sub

Sub AddDataToMap(Map As Map,Key As String,Value As Object) As Map
	
	Dim m As Map
	m.Initialize
	
	m.Put(Key,Value)
	
	For Each Key As String In Map.Keys
		m.Put(Key,Map.Get(Key))
	Next
	
	Return m
	
End Sub

Sub RemoveDataFromMap(Map As Map,Key_ As String) As Map
	
	Dim m As Map
	m.Initialize
	
	For Each Key As String In Map.Keys
		If Key <> Key_ Then
			m.Put(Key,Map.Get(Key))
		End If
	Next
	
	Return m
	
End Sub