B4i=true
Group=Libraries
ModulesStructureVersion=1
Type=StaticCode
Version=4.3
@EndOfDesignText@
#IgnoreWarnings: 19
#IgnoreWarnings: 25
#IgnoreWarnings: 2
#IgnoreWarnings: 12

Private Sub Process_Globals
	Private Module2 As Object
	Private no2 As NativeObject
	Private nome As NativeObject=Me
	Type Point (X As Float, Y As Float)
	#if tooltip
	Private tipSave As SimpleTooltipBuilder
	#end if
End Sub

'not worked in b4i
Public Sub ForceLTRSupported(View As View,Rtl As Boolean)
	
End Sub

Public Sub SetCSTextField(Cs As CSBuilder,v As View)
		
	If v Is Label Then
		Dim l As Label
		l = v
		l.AttributedText = Cs
	End If
	
End Sub

'not worked in b4i
Public Sub SetElevation(View As View,Val As Float)
	
End Sub

Sub ChangeFont(Panel As Panel,FontName As String)
	
	For Each v1 As View In Panel.GetAllViewsRecursive
		
		If v1 Is Label And v1.Tag = "" Then
			
			Dim lb As Label
			lb	=	v1
				
			If lb.Font.Name.ToLowerCase.IndexOf("fontawesome") = -1 And lb.Font.Name.ToLowerCase.IndexOf("materialicons") = -1 Then
				lb.Font	=	Font.CreateNew2(FontName,lb.Font.Size)
			End If
			
		End If
		
		If v1 Is Button And v1.Tag = "" Then
			
			Dim lb2 As Button
			lb2	=	v1
			
			If lb2.CustomLabel.Font.Name.ToLowerCase.IndexOf("fontawesome") = -1 And lb2.CustomLabel.Font.Name.ToLowerCase.IndexOf("materialicons") = -1 Then
				lb2.CustomLabel.Font	=	Font.CreateNew2(FontName,lb2.CustomLabel.Font.Size)
			End If
				
		End If
		
		If v1 Is TextField Then
			Dim t2 As TextField
			t2 = v1
			t2.Font	=	Font.CreateNew2(FontName,t2.Font.Size)
		End If
		
	Next
	
End Sub

'show progress with title and details
Sub ShowProgress (h As HUD, Title As String, Detail As String)
	h.ProgressDialogShow(Title)
	Dim no As NativeObject = h
	no.GetField("progress").SetField("detailsLabelText",Detail)
End Sub

'use for iphone X size
Sub GetRealPageSize(Page1 As Page) As Rect
	
	Try
		Dim rect2 As Rect
		Dim height,width As Float
		Dim no As NativeObject = Page1.RootPanel
		Dim top = 0, left = 0 As Int
		height = Page1.RootPanel.Height
		width = Page1.RootPanel.Width

		no = no.GetField("safeAreaInsets")
		Dim matcher As Matcher = Regex.Matcher("\{(.*)\}", no.AsString.Replace(" ", ""))
		If matcher.Find Then
			Dim values() As String = Regex.Split(",", matcher.Group(1))
			top = top + values(0)
			left = left + values(1)
			height = height - values(2) - top
			width = width - values(3) - left
		End If
		
		rect2.Initialize(left,top,width,height)
		
		If rect2.Bottom = 0 And rect2.Top = 0 And rect2.Left = 0 And rect2.Right = 0 Then
			rect2.Initialize(0,0,GetDeviceLayoutValues.Width,GetDeviceLayoutValues.Height)
		End If
		
		Return rect2
	Catch
		Dim rect2 As Rect
		rect2.Initialize(0,0,Page1.RootPanel.Width,Page1.RootPanel.Height)
		Return rect2
	End Try
		
End Sub

Sub ApplyBlur(View As View)
	Dim nome As NativeObject=Me
	nome.RunMethod("MakeBlur:",Array(View))
	#If OBJC

	-(void)MakeBlur: (UIView*)view
	{
	if (!UIAccessibilityIsReduceTransparencyEnabled()) {
	    view.backgroundColor = [UIColor clearColor];

	    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
	    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
	    blurEffectView.frame = view.frame;
	    blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

	    [view addSubview:blurEffectView];
	}
	else {
	    view.backgroundColor = [UIColor blackColor];
	}
	}

	#End if
End Sub

Sub SetLines(Label As Label, LineNumber As Int)
	Dim nome As NativeObject = Label
	nome.SetField("numberOfLines",LineNumber)
End Sub

'0 - center, 1 - left, 2 - right
Sub SetButtonAlignment(btn As Button, alignment As Int)
	Dim no As NativeObject = btn
	no.SetField("contentHorizontalAlignment", alignment)
End Sub

Sub GetNumberOfLines (TV As View) As Int
	
	Dim No As NativeObject = Me
    #if objc
        -(int)CountLines:(UITextView*)TV{
            return ((TV.contentSize.height / TV.font.lineHeight) -1);
        }
    #End If
	
	If TV Is TextView Then
		Dim t As TextView
		t = TV
		Dim r() As String
		r	=	Regex.Split(CRLF,t.Text)
		If r.Length = 0 Then Return 1
		Return r.Length
	
	Else if TV Is Label Then
		Dim l As Label
		l = TV
		Dim r() As String
		r = Regex.Split(CRLF,l.Text)
		If r.Length = 0 Then Return 1
		Return r.Length
	End If
	
End Sub

Sub PanelIndexOf(p As Panel, v As View) As Int
	For i = 0 To p.NumberOfViews - 1
		If p.GetView(i) = v Then Return i
	Next
	Return -1
End Sub

Sub ToastMessageShow(App As Application,Message As String,LongDuration As Boolean,aFont As Object,TextColor As Int,BackgroundColor As Int,Offset As Int)
		
	Dim hu As HUD
	hu.ToastMessageShow(Message,LongDuration)
	
	Dim no1 As NativeObject = App.KeyController
	no1 = no1.GetField("view")
	Dim no2 As NativeObject
	Dim hud As NativeObject = no2.Initialize("MMBProgressHUD").RunMethod("HUDForView:", Array(no1))
	If hud.IsInitialized Then
		hud.SetField("color",hud.ColorToUIColor(BackgroundColor))
		hud.SetField("labelColor",hud.ColorToUIColor(TextColor))
		hud.SetField("labelFont",aFont)
		
		If Offset > 0 Then
			hud.SetField("yOffset", Offset)
		End If
		
	End If
	
End Sub

Sub ProgressDialogShow(App As Application,iHud As HUD,Message As String,aFont As Object,TextColor As Int,BackgroundColor As Int,Offset As Int)
		
	iHud.ProgressDialogShow(Message)
	
	Dim no1 As NativeObject = App.KeyController
	no1 = no1.GetField("view")
	Dim no2 As NativeObject
	Dim Hud As NativeObject = no2.Initialize("MMBProgressHUD").RunMethod("HUDForView:", Array(no1))
	If Hud.IsInitialized Then
		Hud.SetField("color",Hud.ColorToUIColor(BackgroundColor))
		Hud.SetField("labelColor",Hud.ColorToUIColor(TextColor))
		Hud.SetField("labelFont",aFont)
		
		If Offset > 0 Then
			Hud.SetField("yOffset", Offset)
		End If
		
	End If
	
End Sub

Sub SetVisibleAnimated(View1 As View,Duration As Int,Visible As Boolean)
	
	Dim xui As B4XView
	xui = 	View1
	xui.SetVisibleAnimated(Duration,Visible)
	
End Sub

Sub ShakeView (View As B4XView, Duration As Int)
	Dim Left As Int = View.Left
	Dim Delta As Int = 20dip
	For i = 1 To 4
		View.SetLayoutAnimated(Duration / 5, Left + Delta, View.Top, View.Width, View.Height)
		Delta = -Delta
		Sleep(Duration / 5)
	Next
	View.SetLayoutAnimated(Duration/5, Left, View.Top, View.Width, View.Height)
End Sub

'add #PlistExtra: <key>CFBundleLocalizations</key><array><string>German</string></array> to project settings
Sub LocalizeApp
	
End Sub
'Alignment is : 
'3 : Left
'2 : Right
'0 : Center
Sub Justify (L As Label, FirstLineHeadIndent As Float,Alignment As Int)
	
	L.Multiline = True
   
	Dim ParaStyle As NativeObject
	ParaStyle = ParaStyle.Initialize("NSMutableParagraphStyle").RunMethod("alloc",Null).RunMethod("init",Null)
	ParaStyle.SetField("alignment",Alignment)
	ParaStyle.SetField("firstLineHeadIndent",FirstLineHeadIndent)
   
	Dim Attr As Map = CreateMap("NSParagraphStyle":ParaStyle,"NSColor":ParaStyle.ColorToUIColor(L.TextColor),"NSFont":L.Font)
   
	Dim NaAttr As NativeObject
	NaAttr = NaAttr.Initialize("NSAttributedString").RunMethod("alloc",Null).RunMethod("initWithString:attributes:",Array(L.Text,Attr.ToDictionary))
   
   
	Dim Lbl As NativeObject = L
	Lbl.SetField("attributedText",NaAttr)
	
End Sub

'View1 can be ScrollView or TableView
Sub HideScroll(View1 As View)
	
	Dim no As NativeObject = View1
	no.SetField("showsVerticalScrollIndicator", False)
	no.SetField("showsHorizontalScrollIndicator", False)
	
End Sub

Sub RemoveSlidingMenuFade(smc As Object)
	Dim no As NativeObject = smc
	no.SetField("shouldStretchDrawer", False)
End Sub

Sub SetTrackImage(ProgressView1 As ProgressView, Image As Bitmap)
	Dim NaObj As NativeObject = ProgressView1
	NaObj.RunMethod("setTrackImage:",Array(Image))
End Sub

Sub SetProgressImage(ProgressView1 As ProgressView, Image As Bitmap)
	Dim NaObj As NativeObject = ProgressView1
	NaObj.RunMethod("setProgressImage:",Array(Image))
End Sub

Sub SetPaddingTextField(TextField1 As TextField, PaddingLeft As Float)
	Dim pnl As Panel
	pnl.Initialize("")
	pnl.SetLayoutAnimated(0, 1, 0, 0, PaddingLeft, TextField1.Height)
	Dim no As NativeObject = TextField1
	no.SetField("leftView", pnl)
	no.SetField("leftViewMode", 3)
End Sub

'set Default font for views that you want change their font
'add font in project main attribute
Sub ChangePanelFont(Panel As Panel,Fontname As String)
	
	For Each Views As View In Panel.GetAllViewsRecursive
		
		If Views Is Button Then
			Dim b1 As Button
			b1 = Views

			If b1.CustomLabel.Font.Name = Font.DEFAULT.Name Or b1.CustomLabel.Font.Name.StartsWith(".SFUI") Then
				b1.CustomLabel.Font = Font.CreateNew2(Fontname,b1.CustomLabel.Font.Size)
			End If
		
		Else if Views Is Label Then
			Dim lb As Label
			lb = Views
		
			If lb.Font.Name = Font.DEFAULT.Name Or lb.Font.Name.StartsWith(".SFUI") Then
				lb.Font = Font.CreateNew2(Fontname,lb.Font.Size)
			End If
	
		Else if Views Is TextField Then
			Dim txt As TextField
			txt = Views
			If txt.Font.Name = Font.DEFAULT.Name Or txt.Font.Name.StartsWith(".SFUI") Then
				txt.Font = Font.CreateNew2(Fontname,txt.Font.Size)
			End If
			
		Else if Views Is TextView Then
			Dim txt2 As TextView
			txt2 = Views
			If txt2.Font.Name = Font.DEFAULT.Name Or txt2.Font.Name.StartsWith(".SFUI") Then
				txt2.Font = Font.CreateNew2(Fontname,txt2.Font.Size)
			End If
			
		End If
		
	Next
	
End Sub

Sub ChangeInputView(TextField2 As TextField,Panel2 As Panel)
	
	Dim no As NativeObject	=	TextField2
	no.SetField("inputView",Panel2)
	
End Sub

Sub GetFont(Fontname As String,Fontsize As Int) As Font
	Return Font.CreateNew2(Fontname,Fontsize)
End Sub

Sub CenterView(v As View, parent As View)
	v.Left = parent.Width / 2 - v.Width / 2
	v.Top = parent.Height / 2 - v.Height / 2
End Sub

Sub CenterViewTop(v As View, parent As View)
	v.Top = parent.Height / 2 - v.Height / 2
End Sub

Sub CenterViewLeft(v As View, parent As View)
	v.Left = parent.Width / 2 - v.Width / 2
End Sub

Sub SetPadding(tf As TextField, Padding As Float)
	Dim pnl As Panel
	pnl.Initialize("")
	pnl.SetLayoutAnimated(0, 1, 0, 0, Padding, tf.Height)
	Dim no As NativeObject = tf
	no.SetField("leftView", pnl)
	no.SetField("leftViewMode", 3)
	no.SetField("rightView", pnl)
	no.SetField("rightViewMode", 3)
End Sub

Sub SetLeftPadding(tf As TextField, Padding As Float)
	Dim pnl As Panel
	pnl.Initialize("")
	pnl.SetLayoutAnimated(0, 1, 0, 0, Padding, tf.Height)
	Dim no As NativeObject = tf
	no.SetField("leftView", pnl)
	no.SetField("leftViewMode", 3)
End Sub

'for disable or enable all view of panel
Sub ChangeStatePanel(Panel As Panel,State As Boolean)
	
	For Each v1 As View In Panel.GetAllViewsRecursive
		v1.UserInteractionEnabled = State
	Next
	
End Sub

Sub SetButtonTextColor(Button1 As Button, NormalColor As Int,PressColor As Int,DisableColor As Int)
	Dim No As NativeObject = Button1
	No.RunMethod("setTitleColor:forState:", Array(No.ColorToUIColor(NormalColor), 0))
	No.RunMethod("setTitleColor:forState:", Array(No.ColorToUIColor(PressColor), 1))
	No.RunMethod("setTitleColor:forState:", Array(No.ColorToUIColor(DisableColor), 2))
End Sub

Sub SetButtonBackgroundColor(Button1 As Button, NormalColor As Int,PressColor As Int,DisableColor As Int)
	
	Dim ca As Canvas
	ca.Initialize(Button1)
	ca.DrawColor(NormalColor)
	
	Dim No As NativeObject = Button1
	No.RunMethod("setBackgroundImage:forState:", Array(ca.CreateBitmap, 0))
	
	ca.DrawColor(PressColor)
	No.RunMethod("setBackgroundImage:forState:", Array(ca.CreateBitmap, 1))
	
	ca.DrawColor(DisableColor)
	No.RunMethod("setBackgroundImage:forState:", Array(ca.CreateBitmap, 2))
	
End Sub

Sub ButtonSetAttributedText(btn As Button, NormalText As AttributedString, HighlightedText As AttributedString, _
     DisabledText As AttributedString)
	Dim no As NativeObject = btn
	no.RunMethod("setAttributedTitle:forState:", Array(NormalText, 0))
	no.RunMethod("setAttributedTitle:forState:", Array(HighlightedText, 1))
	no.RunMethod("setAttributedTitle:forState:", Array(DisabledText, 2))
End Sub

Sub SetButtonBackgroundImage(Button1 As Button, NormalImage As Bitmap,PressImage As Bitmap,DisableImage As Bitmap)
	
	Dim no As NativeObject = Button1
	no.RunMethod("setBackgroundImage:forState:", Array(NormalImage, 0))
	no.RunMethod("setBackgroundImage:forState:", Array(PressImage, 1))
	no.RunMethod("setBackgroundImage:forState:", Array(DisableImage, 2))
	
End Sub

Sub SetViewBackgroundImage(View2 As View,Bitmap As Bitmap)
	
	Dim pn As Panel
	pn	=	View2.Parent
	
	Dim img As ImageView
	img.Initialize("")
	img.Bitmap = Bitmap
	img.ContentMode = img.MODE_FILL
	pn.AddView(img,View2.Left,View2.Top,View2.Width,View2.Height)
	View2.BringToFront
	
End Sub

'example
'<code>
'Views.SetLabelProperties(lblabout,20dip,2,2)
'</code>
Sub SetLabelProperties(Label1 As Label,LineSpace As Float,MinimumLineHeight As Float, MaximumLineHeight As Float,UseAttributedString As Boolean)
	
	Dim A As AttributedString
	If UseAttributedString = False Then
		A.Initialize(Label1.Text,Label1.Font,Label1.TextColor)
 	Else
		A	=	Label1.AttributedText	
	End If
	
	Dim NaObj2 As NativeObject
	NaObj2 = NaObj2.Initialize("NSMutableParagraphStyle").RunMethod("new",Null)
	NaObj2.RunMethod("setLineSpacing:",Array(LineSpace))
	NaObj2.RunMethod("setAlignment:",Array(Label1.TextAlignment))
	NaObj2.RunMethod("setMinimumLineHeight:",Array(MinimumLineHeight))
	NaObj2.RunMethod("setMaximumLineHeight:",Array(MaximumLineHeight))
   
	Dim NaObj As NativeObject
	NaObj = NaObj.Initialize("NSMutableAttributedString").RunMethod("alloc",Null).RunMethod("initWithAttributedString:",Array(A))
	NaObj.RunMethod("addAttribute:value:range:",Array("NSParagraphStyle",NaObj2,NaObj.MakeRange(0,Label1.Text.Length)))
 
	Dim NaObj3 As NativeObject = Label1
	NaObj3.SetField("attributedText",NaObj)
	
End Sub

Sub RotateViewAnimated(View As View, DurationMs As Int, Angle As Double)
	Dim no As NativeObject = Me
	no.RunMethod("rotateView:::", Array(View, DurationMs, Angle * cPI / 180))
End Sub

Sub SetScaleTransformation(v As View, x As Float, y As Float)
	Dim no As NativeObject = Me
	no.RunMethod("SetScaleTransformation:::", Array(v, x, y))
End Sub

'Transition: 
'cameraIris
'cameraIrisHollowOpen
'cameraIrisHollowClose
'cube
'alignedCube
'flip
'alignedFlip
'oglFlip
'rotate
'pageCurl
'pageUnCurl
'rippleEffect
'suckEffect
'fade
'push
'Direction: fromTop,fromBottom,fromLeft,fromRight
Sub AnimateView(View As View,TransitionType As String, FromDirection As String,Duration As Float)
	Dim no As NativeObject=Me
	no.RunMethod("trans::::",Array(View,TransitionType,FromDirection,Duration))
	#IF OBJC
	-(void) trans: (UIView*)nav :(NSString*)tp :(NSString*)from :(float)duration
	{
	CATransition *transition = [CATransition animation];
	transition.duration = duration;
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	transition.type = tp;
	transition.subtype = from;
	[nav.layer addAnimation:transition forKey:nil];
	}

	#END IF
End Sub

Sub GetLabelHeight(Label As Label) As Int
	
	Dim parent As Panel
	parent = Label.Parent
	
	Dim lb As Label
	lb.Initialize("")
	parent.AddView(lb,Label.Left,Label.Top,Label.Width,Label.Height)
	lb.Font = Label.Font
	lb.Text = Label.Text
	lb.SizeToFit
	
	Dim height As Int
	height = lb.Height
	
	lb.RemoveViewFromParent
	
	Return height
	
End Sub

'event: Refresh_Complete
'for stop refresh view,call HideRefresh sub
'add below event
'<code>
'Sub Refresh_Complete
'
'End Sub
'</code>
Public Sub AddRefresh (Module As Object,ScrollView2 As ScrollView)
	Dim no As NativeObject = Me
	Module2 = Module
	no.RunMethod("AddRefresh:",Array(ScrollView2))
End Sub

Public Sub HideRefresh
	Try
		no2.RunMethod("endRefreshing", Null) ' END REFRESHING
	Catch
		Log(LastException)
	End Try
End Sub

'raise event : Refresh_Complete
Private Sub refreshing(RefreshControl As Object)
	no2 = RefreshControl
	no2.RunMethod("endRefreshing", Null) ' END REFRESHING
	CallSubDelayed(Module2,"Refresh_Complete")
End Sub

Sub LoadLayout(LayoutName As String,Panel2 As Panel)
	Panel2.RemoveAllViews
	Panel2.LoadLayout(LayoutName)
End Sub

'add bitmap to Images list
Sub SetImageSegments(sc As SegmentedControl, Images As List)
	Dim no As NativeObject = sc
	no.RunMethod("removeAllSegments", Null)
	For i = 0 To Images.Size - 1
		no.RunMethod("insertSegmentWithImage:atIndex:animated:", Array(Images.Get(i), i, True))
	Next
End Sub

Sub ChangeSegmentFont(Font2 As Font,Segmentbar As SegmentedControl)
	Dim NaObj As NativeObject = Me
	NaObj.RunMethod("SetFont::",Array(Font2,Segmentbar))
	#If OBJC
	-(void)SetFont:(UIFont *)Font :(UISegmentedControl *)SegmentedControl{
	    NSDictionary *attributes = [NSDictionary dictionaryWithObject:Font forKey:NSFontAttributeName];
	    [SegmentedControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
	}                            
	#End If
End Sub

Public Sub SetMultiline(b As Button)
	Dim no As NativeObject = b
	no.GetField("titleLabel").SetField("numberOfLines", 0)
	no.GetField("titleLabel").SetField("textAlignment", 1)
End Sub

'that is not working in b4i
Public Sub ChangeStatusColor(Color As Int)
	
End Sub

Sub GetParent(View2 As View) As View
	Return View2.Parent
End Sub

'use below code
'<code>B4XPages.GetNativeParent(Me).ResignFocus</code>
Sub HideKeyboard(Page As Object)
	
	If Page Is Page Then
		Dim p As Page
		p = Page
		p.ResignFocus
	Else
		B4XPages.GetNativeParent(Page).ResignFocus
	End If
	
End Sub

Sub HideKeyboard2(Page As Page)
	Sleep(50)
	Page.ResignFocus
End Sub

Sub MeasureTextHeight(Text As String,UseFont As Font,Multiline As Boolean) As Double
	Return MeasureText(Text,UseFont,Multiline)(1)
End Sub

Sub MeasureTextWidth(Text As String,UseFont As Font,Multiline As Boolean) As Double
	Return MeasureText(Text,UseFont,Multiline)(0)
End Sub

Private Sub MeasureText(Text As String,UseFont As Font,Multiline As Boolean) As Double()
	Dim L As Label
	L.Initialize("")
	L.Font = UseFont
	L.Text = Text
	L.Multiline = Multiline
	L.SizeToFit
	Dim Result(2) As Double
	Result(0) = L.Width
	Result(1) = L.Height
	Return Result
End Sub

Sub InputAccessoryView(TextField2 As TextField,Button2 As Button)
	Dim no As NativeObject = TextField2
	no.SetField("inputAccessoryView",Button2)
End Sub

'use after set text to view
Sub Linkify(tv As TextView)
	Dim no As NativeObject = tv
	no.SetField("editable", False)
	no.SetField("Selectable", True)
	no.SetField("dataDetectorTypes", Bit.Or(1,2))
End Sub

Sub MarkPatternCSbuilder(CS As CSBuilder,Input As String, Pattern As String, GroupNumber As Int) As CSBuilder
	Dim lastMatchEnd As Int = 0
	Dim m As Matcher = Regex.Matcher(Pattern, Input)
	Do While m.Find
		Dim currentStart As Int = m.GetStart(GroupNumber)
		CS.Append(Input.SubString2(lastMatchEnd, currentStart))
		lastMatchEnd = m.GetEnd(GroupNumber)
		'apply styling here
		CS.Color(0xFF03FFFF)
		CS.Link(m.Group(GroupNumber))
		CS.Append(m.Group(GroupNumber))
		CS.Pop.Pop 'number should match number of stylings set.
	Loop
	If lastMatchEnd < Input.Length Then CS.Append(Input.SubString(lastMatchEnd))
	Return CS
End Sub

Sub ChangeDirectionRTL(cs As CSBuilder)
	Dim no As NativeObject = cs
	Dim paragraph As NativeObject
	paragraph = paragraph.Initialize("NSMutableParagraphStyle").RunMethod("new", Null)
	paragraph.SetField("baseWritingDirection", 1) 'NSWritingDirectionRightToLeft
	no.RunMethod("addAttribute:value:range:", Array("NSParagraphStyle", paragraph, no.MakeRange(0, cs.Length)))
End Sub

Sub DisableScrollTextview(Textview2 As TextView)
	Dim j As NativeObject
	j = Textview2
	j.SetField("scrollEnabled",False)
End Sub

Sub DisableScrollViewTouch(Scroll As ScrollView)
	Dim j As NativeObject
	j = Scroll
	j.SetField("scrollEnabled",False)
End Sub

Sub AnimateImageViewPictures(ImageView As ImageView,Images As List,Duration As Float)
	
	Dim no As NativeObject = ImageView
	no.SetField("animationImages", Images)
	no.SetField("animationDuration", Duration)
	no.RunMethod("startAnimating", Null)
	
End Sub

Sub SearchableEdittext(TextField As TextField)
	TextField.ReturnKey	=	TextField.RETURN_SEARCH
End Sub

Sub SetCursorDrawableColor(TextField As View,Color As Int)
	TextField.TintColor	=	Color
End Sub

'add pagination bullet into panel
Sub AddPageControl(Panel As Panel,PageCount As Int,IndicatorColor As Int,CurrentIndicatorColor As Int) As NativeObject
	
	Private noPageControl As NativeObject
	Private PageControl As View
	
	noPageControl 	= 	noPageControl.Initialize("UIPageControl").RunMethod("new", Null)
	PageControl 	= 	noPageControl
	Panel.AddView(PageControl, 0,0, Panel.Width, 40dip)
	noPageControl.SetField("numberOfPages", PageCount)
	noPageControl.SetField("enabled", True)
	noPageControl.SetField("pageIndicatorTintColor", noPageControl.ColorToUIColor(IndicatorColor))
	noPageControl.SetField("currentPageIndicatorTintColor", noPageControl.ColorToUIColor(CurrentIndicatorColor))
	
	Return noPageControl
	
End Sub

Sub SetCurrentPageControl(PageControl As NativeObject,PageIndex As Int)
	PageControl.SetField("currentPage", PageIndex)
End Sub

Sub ChangeViewsEnable(Panel As Panel,State As Boolean)
	
	For Each v1 As View In Panel.GetAllViewsRecursive
		v1.UserInteractionEnabled = State
	Next
	
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

Sub InputModeEmail(Textfield As TextField)
	Textfield.KeyboardType	=	Textfield.TYPE_EMAIL_ADDRESS
End Sub

Sub ForceNumberKeyboard(Textfield As TextField)
	Textfield.KeyboardType	=	Textfield.TYPE_NAME_PHONE_PAD
End Sub

Public Sub GetCenter(View As View) As Point
	Dim r As Rect
	r=nome.RunMethod("GetCenter:",Array(View))
	Dim p As Point
	p.X=r.Left
	p.Y=r.Top
	Return p
End Sub

Public Sub SetCenter(View As View, Point As Point)
	nome.RunMethod("SetCenter::",Array(View,nome.MakePoint(Point.X,Point.Y)))
End Sub

Public Sub PointToCGPoint(Point1 As Point) As Object
	Dim p As Object
	p=nome.MakePoint(Point1.X,Point1.Y)
	Return p

End Sub

Public Sub CGPointToPoint(CGPoint As Object) As Point
	Dim r As Rect
	r=nome.RunMethod("ToPoint:",Array(CGPoint))
	Dim p As Point
	p.X=r.Left
	p.Y=r.Top
	Return p
End Sub

Public Sub CGRectToRect(CGRect As Object) As Rect
	Dim r As Rect
	r=nome.RunMethod("ToRect:",Array(CGRect))
	'Dim p As Point
	'p.X=r.Left
	'p.Y=r.Top

	Return r
End Sub

Public Sub GetRelativeLeft(View As View,Parent As View) As Int
	Dim NaObj As NativeObject = Me
	Dim r As Rect	=	NaObj.RunMethod("PositionInView::",Array(View,Parent))
	Return r.Left
End Sub

Public Sub GetRelativeTop(View As View,Parent As View) As Int
	Dim NaObj As NativeObject = Me
	Dim r As Rect=NaObj.RunMethod("PositionInView::",Array(View,Parent))
	Return r.Top
End Sub

Sub PaddingLabel(lbl As Label,Padding As Int)
	Dim p As Panel
	p.Initialize("")
	Dim parent As Panel = lbl.Parent
	p.Color		=	lbl.Color
	lbl.Color	=	Colors.Transparent
	parent.AddView(p, lbl.Left, lbl.Top, lbl.Width, lbl.Height)
	lbl.RemoveViewFromParent
	p.AddView(lbl, Padding, 0, p.Width-Padding-Padding, p.Height)
End Sub

Public Sub AnimateWithCompletion(View As View,Duration As Float,CGRect As Object, Handler As Object)
	nome = Me
	nome.RunMethod("moveTo::::",Array(View,CGRect,Duration,Handler))
End Sub

Public Sub LabelSpace(Label As Label,LineSpace As Float)
	SetLabelProperties(Label,LineSpace * 10,1,1,False)
End Sub

'keep label's attributesString
Public Sub LabelSpace2(Label As Label,LineSpace As Float)
	SetLabelProperties(Label,LineSpace * 10,1,1,True)
End Sub

Sub SetGradient(v As View, color1 As Int, color2 As Int, Replace As Boolean)
	Dim NaObj As NativeObject = Me
	NaObj.RunMethod("SetGradient::::",Array(v,NaObj.ColorToUIColor(color1),NaObj.ColorToUIColor(color2), Replace))
End Sub

Sub SwitchSetOnTintColor(SW As Switch,Color As Int)
	Dim NaObj As NativeObject = SW
	NaObj.RunMethod("setOnTintColor:",Array(NaObj.ColorToUIColor(Color)))
End Sub

#region OBJC Section
#If OBJC
- (void)SetGradient: (UIView*) View :(UIColor*) Color1 :(UIColor*) Color2 :(BOOL)replace{
   CAGradientLayer *gradient = [CAGradientLayer layer];
   gradient.colors = [NSArray arrayWithObjects:(id)Color1.CGColor, (id)Color2.CGColor, nil];
   gradient.frame = View.bounds;
   if (replace)
     [View.layer replaceSublayer:View.layer.sublayers[0] with:gradient];
   else
     [View.layer insertSublayer:gradient atIndex:0];
}
#end if

#If OBJC

-(B4IRect*)GetCenter: (UIView*)view
{
CGPoint cntr=view.center;
B4IRect * r;
	r=[B4IRect new];
	[r Initialize :(float)(cntr.x) :(float)(cntr.y) :(float)(0.0) :(float)(0.0)];
return r;

}

-(B4IRect*)PositionInView: (UIView*)view :(UIView*)parent
{

CGRect rect = [view convertRect:view.frame fromView:parent];

CGPoint point = [view.superview convertPoint:view.center toView:parent];
B4IRect * r;
	r=[B4IRect new];
	[r Initialize :(float)(point.x) :(float)(point.y) :(float)(0.0) :(float)(0.0)];

return r;
}

-(void) SetCenter: (UIView*)view :(CGPoint)point
{
view.center=point;
}

-(B4IRect*)ToPoint: (CGPoint)point
{

B4IRect * r;
	r=[B4IRect new];
	[r Initialize :(float)(point.x) :(float)(point.y) :(float)(0.0) :(float)(0.0)];
return r;

}

-(B4IRect*)ToRect: (CGRect)rect
{

B4IRect * r;
	r=[B4IRect new];
	[r Initialize :(float)(rect.origin.x) :(float)(rect.origin.y) :(float)(rect.size.width+rect.origin.x) :(float)(rect.size.height+rect.origin.y)];
return r;

}

- (void) moveTo: (UIView*)view :(CGRect)destination :(float)secs  :(NSObject*)handler
{
    [UIView animateWithDuration:secs delay:0.0 options:UIViewAnimationOptionCurveLinear
        animations:^{
            view.frame = CGRectMake(destination.origin.x,destination.origin.y, destination.size.width, destination.size.height);
        }
        completion:^(BOOL finished) { 
		[self.__c CallSub:self.bi :handler :@"animation_finish"];
        //[self.bi raiseUIEvent:handler event:@"animation_finish" params:@[]];
    }];
}



- (BOOL)renameFile: (NSString*)source :(NSString*)target {
   return [[NSFileManager defaultManager] moveItemAtPath:source toPath:target error:nil];
}

#End If

#IF OBJC

-(void)AddRefresh: (UIScrollView*)scrollView {
UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
[scrollView addSubview:refreshControl];
[refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];

}

- (void)refresh:(id)sender {
UIRefreshControl *refreshControl=sender;
[self.bi raiseEvent:nil event:@"refreshing:" params:@[(refreshControl)]];

}

#END IF

#If OBJC
- (void) rotateView:(UIView*)view :(int)DurationMs :(double)angle {
[UIView animateWithDuration:DurationMs / 1000.0 delay:0.0f
options:UIViewAnimationOptionCurveEaseOut animations:^{
view.transform = CGAffineTransformMakeRotation(angle);
} completion:^(BOOL finished) {

}];
}
#End If

#if ObjC
- (void) SetScaleTransformation:(UIView*) view :(float)x :(float)y {
   view.transform = CGAffineTransformMakeScale(x, y);
}
#End if

#End Region

Sub SetHintColor(TextField As TextField, Color As Int)
	
	Dim NoTxtField As NativeObject = TextField
	Dim AttrTxt As AttributedString
	AttrTxt.Initialize(TextField.HintText,TextField.Font,Color)
	NoTxtField.SetField("attributedPlaceholder",AttrTxt)
	
End Sub

Sub SetBitmapOnLabel(Label As Label,Bitmap As Bitmap)
	Dim nat As NativeObject
	nat	=	Me
	nat.RunMethod("bgImage::",Array As Object(Label,Bitmap))
	#If objc
	-(void) bgImage: (UILabel*)theLabel :(UIImage *)bitmap {
		theLabel.backgroundColor = [UIColor colorWithPatternImage:bitmap];
	}
	#End If
End Sub

Sub ChangeProgressColor(pb As ActivityIndicator,Color As Int)
	pb.TintColor	=	Color
End Sub

Sub FlashIndicatorsScrollView(sv As ScrollView)
	Dim no As NativeObject = sv
	no.RunMethod("flashScrollIndicators", Null)
End Sub

Sub ShowKeyboard(Vi As TextField)
	Vi.RequestFocus
End Sub

'<code>
'Dim b As Button
'b.Initialize("b", b.STYLE_SYSTEM)
'b.Text = "Hide keyboard"
'b.Width = 100
'b.Height = 50
'AddViewToKeyboard(tf, b)
'</code>
Sub AddViewToKeyboard(TextField1 As TextField, View1 As View)
	Dim no As NativeObject = TextField1
	no.SetField("inputAccessoryView", View1)
End Sub

Sub ChangeSliderThumbIcon(Thumb As Bitmap)
	Dim no As NativeObject
	no.Initialize("UISlider").RunMethod("appearance", Null).RunMethod("setThumbImage:forState:",Array(Thumb,0))
End Sub

'gravity:
'0 for bottom
'1 for end
'2 fir start
'3 for top
Sub ShowTooltip(Panel As Panel,Text As String,View As View,TextColor As Int,BackgroundColor As Int,Gravity As Int)
	#if tooltip
	tipSave.Initialize(Panel,Me,"STT")
	tipSave.arrowHeight(27dip).fontFamily(Font.CreateNew2("iransans",13)).backgroundColor(BackgroundColor).transparentOverlay(True).dismissOnInsideTouch(True).dismissOnOutsideTouch(True).modal(True).text(Text).textColor(TextColor).anchorView(View)
	
	If Gravity = 0 Then
		tipSave.gravityBottom
		
	Else if Gravity = 1 Then
		tipSave.gravityEnd
		
	Else if Gravity = 2 Then
		tipSave.gravityStart
	
	Else if Gravity = 3 Then
		tipSave.gravityTop
		
	End If
	
	tipSave.build.show
	#end if
End Sub

Sub HideTooltip
	#if tooltip
	tipSave.dismiss
	#end if
End Sub

Public Sub SetHTMLOnLabel(l As Label, htmlString As String)
	Dim NaObj As NativeObject = Me
	NaObj.RunMethod("SetHTML::",Array(l,htmlString))
	#if OBJC
- (void)SetHTML: (UILabel*) Label :(NSString *) htmlString{
   htmlString = [htmlString stringByAppendingString:[NSString stringWithFormat:@"<style>*{font-family: '%@'; font-size:%fpx;}</style>",
                                              Label.font.fontName,
                                              Label.font.pointSize]];
                                              
   NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc]
                                           initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding]
                                           options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType}
                                        documentAttributes:nil
                                        error:nil];
    
    if ([attrStr.string hasSuffix:@"\n"]) {
        [attrStr removeAttribute:NSParagraphStyleAttributeName range:NSMakeRange(0, attrStr.length)];
    }
    Label.attributedText = attrStr;
}

#end if
End Sub

Public Sub SetColorTintList(Sw As Switch,Normal As Int,Selected As Int,Disable As Int)
	Sw.TintColor	=	Normal
End Sub

Public Sub MakeCSBuilderText(Text As String,Font_ As Font,Color As Int) As CSBuilder
	
	Dim c As CSBuilder
	c.Initialize
	c.Font(Font_).Color(Color).Append(Text).Pop
	Return c.PopAll
	
End Sub

Public Sub CSBuilderToString(Cs As CSBuilder) As String
	Return Cs.ToString
End Sub

Sub SetAlpha(V As View,Alpha As Float)
	
	If Alpha > 1 Then
		Alpha	=	Alpha / 100
	End If
	
	V.Alpha	=	Alpha
	
End Sub