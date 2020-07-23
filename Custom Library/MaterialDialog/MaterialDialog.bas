B4i=true
Group=Libraries
ModulesStructureVersion=1
Type=Class
Version=5
@EndOfDesignText@
#Event: ItemSelected (Position As Int,Text As String)
#Event: InputChanged (Input As String)
#Event: ButtonPressed (Action As String)
#Event: Result(Action As String)
#Event: CustomViewReady (CustomView As Panel)

#IgnoreWarnings: 9
Private Sub Class_Globals
	Private dialog As CustomLayoutDialog
	Private p1 As Panel
	Private PositiveText2,NegativeText2 As String
	Private module_ As Object
	Private Evt As String
	Private lblContent,lblTitle As TextView
	Private Medium2,Regular2 As Font
	Private PositiveButton,NegativeButton As Button
	Private txtinput As TextField
	Private InputMode,ListMode,ProgressMode As Boolean
	Private Tag2 As Object
	Private svList As ScrollView
	Private checkbox2 As Switch
	Private checkbox2_title As Label
	Private CheckboxMode As Boolean
	Private CustomViewMode As Boolean
	Private svCustomView As ScrollView
	Private CustomViewHeight As Int
	Private AllowEmptyInput2 As Boolean
	Private progress_view As ProgressView
	Private progress_view_title As Label
	Private current_button_status As Int
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(Module As Object,Event As String) As MaterialDialog
	
	module_	=	Module
	Evt		=	Event
	
	PositiveText("OK")
	NegativeText("Cancel")
	
	p1.Initialize("")
'	p1.Color	=	Colors.RGB(244,248,247)
	p1.SetLayoutAnimated(0, 1, 0, 0, GetDeviceLayoutValues.Width - 130dip, 190dip)
	p1.SetBorder(0,0,9dip)
	
	lblTitle.Initialize("")
	lblTitle.TextColor		=	Colors.Black
	lblTitle.Font			=	Font.CreateNewBold(18)
	lblTitle.Editable		=	False
	lblTitle.Text			=	"Title"
	lblTitle.TextAlignment	=	lblTitle.ALIGNMENT_CENTER
	lblTitle.Color			=	Colors.Transparent
	p1.AddView(lblTitle,10dip,0,p1.Width-20dip,50dip)
	
	lblContent.Initialize("")
	lblContent.TextColor	=	Colors.Black
	lblContent.Font			=	Font.CreateNew(14)
	lblContent.Editable		=	False
	lblContent.Color		=	Colors.Transparent
	lblContent.TextAlignment=	lblTitle.ALIGNMENT_CENTER
	p1.AddView(lblContent,10dip,45dip,p1.Width-20dip,70dip)
	
	PositiveButton.Initialize("btnpositive",PositiveButton.STYLE_SYSTEM)
	PositiveButton.CustomLabel.TextColor	=	Colors.Black
	PositiveButton.CustomLabel.Font			=	Font.CreateNew(15)
	PositiveButton.Text						=	PositiveText2
	p1.AddView(PositiveButton,0,0,100dip,30dip)
	
	NegativeButton.Initialize("btnnegative",PositiveButton.STYLE_SYSTEM)
	NegativeButton.CustomLabel.TextColor	=	Colors.Black
	NegativeButton.CustomLabel.Font			=	Font.CreateNewBold(15)
	NegativeButton.Text						=	NegativeText2
	p1.AddView(NegativeButton,p1.Width-100dip,0,100dip,30dip)
	
	Regular2	=	Font.CreateNew(13)
	Medium2		=	Font.CreateNew(15)
	
	Return Me
	
End Sub

#region Properties
Public Sub ALIGNMENT_CENTER As Int
	Return 1
End Sub

Public Sub ALIGNMENT_RIGHT As Int
	Return 2
End Sub

Public Sub ALIGNMENT_LEFT As Int
	Return 0
End Sub

Public Sub PositiveText(Text As String) As MaterialDialog
	PositiveText2		=	Text
	Return Me
End Sub 

Public Sub NegativeText(Text As String) As MaterialDialog
	NegativeText2		=	Text
	Return Me
End Sub

Public Sub BackgroundColor(Color As Int) As MaterialDialog
	p1.Color	=	Color
	Return Me
End Sub

Public Sub Title(Text As String) As MaterialDialog
	lblTitle.Text	=	Text
	Return Me
End Sub

Public Sub Content(Text As String) As MaterialDialog
	lblContent.Text		=	Text
	If Text.Length = 0 Then lblContent.Height	=	0
	Return Me
End Sub

Public Sub ContentColor(Color As Int) As MaterialDialog
	lblContent.TextColor	=	Color
	Return Me
End Sub

Public Sub TitleColor(Color As Int) As MaterialDialog
	lblTitle.TextColor	=	Color
	Return Me
End Sub

Public Sub PositiveColor(Color As Int) As MaterialDialog
	
	Dim No As NativeObject = PositiveButton
	No.RunMethod("setTitleColor:forState:", Array(No.ColorToUIColor(Color), 0))
	No.RunMethod("setTitleColor:forState:", Array(No.ColorToUIColor(Color+10), 1))
	No.RunMethod("setTitleColor:forState:", Array(No.ColorToUIColor(Colors.Gray), 2))
	
	Return Me
	
End Sub

Public Sub NegativeColor(Color As Int) As MaterialDialog
	
	Dim No As NativeObject = NegativeButton
	No.RunMethod("setTitleColor:forState:", Array(No.ColorToUIColor(Color), 0))
	No.RunMethod("setTitleColor:forState:", Array(No.ColorToUIColor(Color+10), 1))
	No.RunMethod("setTitleColor:forState:", Array(No.ColorToUIColor(Colors.Gray), 2))
	
	Return Me
	
End Sub

Public Sub TitleGravity(Gravity As Int) As MaterialDialog
	lblTitle.TextAlignment	=	Gravity
	Return Me
End Sub

Public Sub Typeface(TitleFont As Font,ContentFont As Font) As MaterialDialog
	Medium2			=	TitleFont
	Regular2		=	ContentFont
	lblContent.Font	=	ContentFont
	lblTitle.Font	=	TitleFont
	Return Me
End Sub

Public Sub ContentGravity(Gravity As Int) As MaterialDialog
	lblContent.TextAlignment	=	Gravity
	Return Me
End Sub

Public Sub Tag(TagValue As Object) As MaterialDialog
	Tag2	=	TagValue
	Return Me
End Sub

Public Sub GetTag As Object
	Return Tag2
End Sub

'Get input text data
Public Sub InputText As String
	Return txtinput.Text
End Sub

Public Sub PromptCheckBoxChecked As Boolean
	Return checkbox2.Value
End Sub

Public Sub getProgressView As ProgressView
	Return progress_view
End Sub

Public Sub setProgressValue(Value As Float)
	
	Dim i As Int
	i = Value * 100
	
	progress_view.Progress		=	Value
	progress_view_title.Text	=	i & "%"
	
End Sub

Public Sub getProgressValue As Float
	Return progress_view.Progress
End Sub
#end region

Public Sub Input2(Hint As String,Prefill As String,AllowEmptyInput As Boolean) As MaterialDialog
	
	InputMode			=	True
	AllowEmptyInput2	=	AllowEmptyInput
	
	txtinput.Initialize("txtinput")
	txtinput.HintText		=	Hint
	txtinput.Text			=	Prefill
	txtinput.BorderStyle	=	txtinput.STYLE_ROUNDEDRECT
	txtinput.TextColor		=	Colors.Black
	txtinput.ShowClearButton	=	True
	txtinput.TintColor		=	Colors.Gray
	txtinput.Font			=	Font.CreateNew(13)
	
	Return Me
	
End Sub

'user TextField KeyboardTypes
Public Sub InputType(InputType2 As Int) As MaterialDialog
	
	If txtinput.IsInitialized Then
		txtinput.KeyboardType	=	InputType2
	End If
	
	Return Me
	
End Sub

'You can use csbuilder
Public Sub Items(ItemArray() As Object) As MaterialDialog
	
	svList.Initialize("sv",p1.Width,200dip)
	svList.ContentWidth	=	p1.Width-10dip

	HideScroll(svList,True)
	HideScroll(svList,False)
	
	Dim Top As Int
	
	For i = 0 To ItemArray.Length - 1
		
		Dim lbl As Label
		lbl.Initialize("lblitem")
		lbl.Font		=	Regular2
		lbl.TextColor	=	Colors.Black
		lbl.Text		=	ItemArray(i)
		svList.Panel.AddView(lbl,0,Top,p1.Width,40dip)
		
		lbl.Tag	=	CreateMap("index":i,"text":ItemArray(i))
		
		Top	=	Top	+	lbl.Height
		
	Next
	
	svList.Tag				=	40dip * ItemArray.Length
	svList.ContentHeight	=	Top
	
	ListMode				=	True
	
	Return Me
	
End Sub

Public Sub ItemsCallback As MaterialDialog
	Return Me
End Sub

Public Sub CheckBoxPrompt(Prompt As String,InitiallyCheck As Boolean) As MaterialDialog

	checkbox2.Initialize("checkbox")
	checkbox2.Value					=	InitiallyCheck
	
	checkbox2_title.Initialize("checkbox2_title")
	checkbox2_title.Text			=	Prompt
	checkbox2_title.TextColor		=	Colors.Black
	checkbox2_title.Font			=	Font.CreateNew(13)
	
	CheckboxMode					=	True
	
	Return Me
		
End Sub

Public Sub CustomView(WrapInScrollView As Boolean,Height As Int) As MaterialDialog
	
	svCustomView.Initialize("",p1.Width,Height)
	HideScroll(svCustomView,True)
	
	CustomViewHeight	=	Height
	
	svCustomView.ContentHeight	=	CustomViewHeight
	
	If SubExists(module_,Evt & "_customviewready",1) Then
		CallSub2(module_,Evt & "_customviewready",svCustomView.Panel)
	End If
	
	CustomViewMode	=	True
	
	Return Me
	
End Sub

Public Sub Progress(ProgressColor As Int) As MaterialDialog
	
	progress_view.Initialize
	progress_view.Progress	=	0
	progress_view.TintColor	=	ProgressColor
	
	Dim i As Int
	i	=	0 * 100
	
	progress_view_title.Initialize("checkbox2_title")
	progress_view_title.Text			=	i & "%"
	progress_view_title.TextColor		=	Colors.Black
	progress_view_title.TextAlignment	=	progress_view_title.ALIGNMENT_LEFT
	progress_view_title.Font			=	Font.CreateNew(10)
	
	ProgressMode	=	True
	
	Return Me
	
End Sub

Public Sub Show As ResumableSub
	
	FitSizeContent
	
	Dim sf As Object = dialog.ShowAsync("","","","",True)

	Wait For (sf) Dialog_Result (Result As String)
		If current_button_status = dialog.RESULT_POSITIVE Then
			Return "POSITIVE"
		Else
			Return "NEGATIVE"
		End If
		
End Sub

Public Sub Close
	dialog.CloseDialog(0)
End Sub

Private Sub FitSizeContent
	
	Dim Top As Int
	
	PositiveButton.Text	=	PositiveText2
	NegativeButton.Text	=	NegativeText2
	
	If lblTitle.Text.Length = 0 Then
		lblContent.Top	=	lblTitle.Top	
	End If
	
	If lblContent.Text.Length > 0 Then
		lblContent.SizeToFit
	Else
		lblContent.Height = 0
	End If
	
	Top	=	lblContent.Height + lblContent.Top
	
	If InputMode Then
		p1.AddView(txtinput,10dip,lblContent.Top + lblContent.Height + 20dip,p1.Width - 20dip,40dip)
		Top	=	txtinput.Top + txtinput.Height + 55dip
	
	Else if ListMode Then
		If svList.Tag < 150 Then
			p1.AddView(svList,15dip,lblContent.Top + lblContent.Height + 20dip,p1.Width - 25dip,svList.Tag)
		Else
			p1.AddView(svList,15dip,lblContent.Top + lblContent.Height + 20dip,p1.Width - 25dip,150dip)
		End If
		
		Top	=	svList.Top + svList.Height + 55dip
	
	Else if CheckboxMode Then
		p1.AddView(checkbox2,10dip,lblContent.Top + lblContent.Height + 20dip,50dip,50dip)
		p1.AddView(checkbox2_title,70dip,lblContent.Top + lblContent.Height + 40dip,p1.Width - 70dip,35dip)
		Top	=	checkbox2.Top + checkbox2.Height + 35dip
	
	Else if ProgressMode Then
		p1.AddView(progress_view_title,20dip,lblContent.Top + lblContent.Height + 7dip,p1.Width - 40dip,50dip)
		p1.AddView(progress_view,20dip,lblContent.Top + lblContent.Height,p1.Width - 40dip,35dip)
		Top	=	progress_view_title.Top + progress_view_title.Height + 35dip
		
	Else if CustomViewMode Then
		p1.AddView(svCustomView,10dip,lblContent.Top + lblContent.Height + 20dip,p1.Width - 20dip,CustomViewHeight)
		Top	=	svCustomView.Top + svCustomView.Height + 55dip
		
	Else
		Top	=	Top + 40dip
	
	End If
	
	PositiveButton.Top	=	Top
	NegativeButton.Top	=	Top
	
	Dim HaveButton As Boolean
	If PositiveText2.Length = 0 And NegativeText2.Length = 0 Then
		PositiveButton.Top	=	PositiveButton.Top - PositiveButton.Height
	
	Else if PositiveText2.Length <> 0 Or NegativeText2.Length <> 0 Then
		
		HaveButton	=	True
		
		If PositiveText2.Length > 0 And NegativeText2.Length = 0 Then
			NegativeButton.Visible = False
			PositiveButton.Width	=	p1.Width
		
		Else If PositiveText2.Length = 0 And NegativeText2.Length > 0 Then
			PositiveButton.Visible = False
			NegativeButton.Width	=	p1.Width
			NegativeButton.Left		=	PositiveButton.Left
			
		End If
		
	End If
	
	p1.Height			=	PositiveButton.Height + PositiveButton.Top + 10dip
	
	Dim divider As Label
	divider.Initialize("")
	divider.Color	=	Colors.ARGB(8,20,20,20)
	p1.AddView(divider,0,Top - NegativeButton.Height+5dip,p1.Width,1dip)
	
	If HaveButton = False Then
		p1.Height		=	divider.Top + divider.Height + 5dip
	Else
		p1.Height		=	PositiveButton.Top + PositiveButton.Height + 5dip
	End If
	
	dialog.Initialize(p1)
	dialog.Style		=	dialog.STYLE_CUSTOM
	dialog.CustomColor	=	Colors.Red
	
End Sub

Private Sub btnnegative_Click
	
	current_button_status	=	dialog.RESULT_NEGATIVE
	
	If SubExists(module_,Evt & "_buttonpressed",1) Then
		CallSub2(module_,Evt & "_buttonpressed","POSITIVE")
	End If
	
	dialog.CloseDialog(0)
	
End Sub

Private Sub btnpositive_Click
	
	current_button_status	=	dialog.RESULT_POSITIVE
	
	If InputMode Then
		If AllowEmptyInput2 = False Then
			If txtinput.Text.Length = 0 Then
				txtinput.SetBorder(1dip,Colors.RGB(236,31,69),5dip)
				Return		
			End If
		End If
	End If
	
	dialog.CloseDialog(0)
	
	If SubExists(module_,Evt & "_buttonpressed",1) Then
		CallSub2(module_,Evt & "_buttonpressed","POSITIVE")
	End If
	
End Sub

Private Sub lblitem_Click
	
	Dim lb As Label
	lb	=	Sender
	
	Dim data As Map
	data	=	lb.Tag
	
	lb.Visible	=	False
	
	dialog.CloseDialog(0)
	
	Dim tmr As Timer
	tmr.Initialize("tmr",200)
	tmr.Enabled	=	True
	Wait For tmr_Tick
		If True Then
			tmr.Enabled = False
			lb.Visible	=	True
			If SubExists(module_,Evt,1) Then
				CallSub2(module_,Evt,data.Get("text"))
			Else If SubExists(module_,Evt & "_itemselected",2) Then
				CallSub3(module_,Evt & "_itemselected",data.Get("index"),data.Get("text"))
			End If
		End If
	
End Sub

Private Sub txtinput_TextChanged (OldText As String, NewText As String)
	
	If SubExists(module_,Evt & "_inputchanged",1) Then
		CallSub2(module_,Evt & "_inputchanged",txtinput.Text)
	End If
	
End Sub

Private Sub HideScroll(View1 As View,IsVertical As Boolean)
	
	Dim no As NativeObject = View1
	
	If IsVertical Then
		no.SetField("showsVerticalScrollIndicator", False)
	Else
		no.SetField("showsHorizontalScrollIndicator", False)
	End If
	
End Sub