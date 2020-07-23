B4i=true
Group=Libraries
ModulesStructureVersion=1
Type=StaticCode
Version=5
@EndOfDesignText@
Private Sub Process_Globals
	
	Private DetailsDialog As CustomLayoutDialog
	
	Public POSITIVE,CANCEL As Int
	POSITIVE	= 	-1
	CANCEL		= 	-3
	
	Public STYLE_WARNING,STYLE_ERROR,STYLE_INFO,STYLE_NOTICE,STYLE_QUESTION,STYLE_SUCCESS,STYLE_WAITING,STYLE_WARNING As Int
	
	STYLE_WARNING	=	5
	STYLE_ERROR		=	1
	STYLE_INFO		=	4
	STYLE_NOTICE	=	2
	STYLE_QUESTION	=	7
	STYLE_SUCCESS	=	0
	STYLE_WAITING	=	6
	STYLE_WARNING	=	3
	
	Private DefaultStyle As Int
	DefaultStyle	=	4
	
	Private visible_status As Boolean
	
End Sub

Public Sub SetMsgboxType(MsgboxType As Int)
	DefaultStyle	=	MsgboxType
End Sub

Public Sub iMsgbox(Messsage As String,Title As String) As ResumableSub
	
	Dim p As Panel
	p.Initialize("")
	p.SetLayoutAnimated(0, 1, 0, 0, GetDeviceLayoutValues.Width - 100dip, 100dip)
	
	Dim l As Label
	l.Initialize("")
	l.Text	=	Messsage
	l.Font	=	Font.CreateNew(12)
	l.Multiline	=	True
	l.TextAlignment	=	l.ALIGNMENT_LEFT
	p.AddView(l,0,0,p.Width,p.Height)
	SetLabelProperties(l,3.2,1.5,1.5)
	l.SizeToFit
	
	DetailsDialog.Initialize(p)
	DetailsDialog.Style	=	DefaultStyle

	visible_status	=	True
	Dim sf As Object = DetailsDialog.ShowAsync(Title,"OK","CANCEL","", True)

	Wait For (sf) Dialog_Result (Result As Int)
		visible_status	=	False
		Return Result
		
End Sub

'the dialog is modal dialog
Public Sub iMsgbox2(Messsage As String,Title As String,POSITIVETitle As String,CancelTitle As String,NegativeTitle As String) As ResumableSub
	
	Dim p As Panel
	p.Initialize("")
	p.SetLayoutAnimated(0, 1, 0, 0, GetDeviceLayoutValues.Width - 100dip, 100dip)
	
	Dim l As Label
	l.Initialize("")
	l.Text	=	Messsage
	l.Font	=	Font.CreateNew(12)
	l.Multiline	=	True
	l.TextAlignment	=	l.ALIGNMENT_LEFT
	p.AddView(l,0,0,p.Width,p.Height)
	SetLabelProperties(l,3.2,1.5,1.5)
	l.SizeToFit
	
	DetailsDialog.Initialize(p)
	DetailsDialog.Style	=	DefaultStyle

	visible_status	=	True
	
	Dim sf As Object = DetailsDialog.ShowAsync(Title,POSITIVETitle,CancelTitle,NegativeTitle, True)

	Wait For (sf) Dialog_Result (Result As Int)
		visible_status	=	False
		Return Result
		
End Sub

Public Sub Visible As Boolean
	Return visible_status
End Sub

Private Sub SetLabelProperties(Label1 As Label,LineSpace As Float,MinimumLineHeight As Float, MaximumLineHeight As Float)
	
	Dim A As AttributedString
	A.Initialize(Label1.Text,Label1.Font,Label1.TextColor)
 
	Dim NaObj2 As NativeObject
	NaObj2 = NaObj2.Initialize("NSMutableParagraphStyle").RunMethod("new",Null)
	NaObj2.RunMethod("setLineSpacing:",Array(LineSpace))
	NaObj2.RunMethod("setAlignment:",Array(Label1.TextAlignment))
   
	Dim NaObj As NativeObject
	NaObj = NaObj.Initialize("NSMutableAttributedString").RunMethod("alloc",Null).RunMethod("initWithAttributedString:",Array(A))
	NaObj.RunMethod("addAttribute:value:range:",Array("NSParagraphStyle",NaObj2,NaObj.MakeRange(0,Label1.Text.Length)))
 
	Dim NaObj3 As NativeObject = Label1
	NaObj3.SetField("attributedText",NaObj)
	
End Sub