B4i=true
Group=Libraries
ModulesStructureVersion=1
Type=Class
Version=4.3
@EndOfDesignText@
'Custom View class 
#Event: ItemClick (Position As Int, Value As Object)
#Event: PullDownRefresh
#DesignerProperty: Key: dividcolor, DisplayName: LineColor, FieldType: Color, DefaultValue: #FFCECECE, Description: Change separator line color
#DesignerProperty: Key: refresh, DisplayName: Pull to refresh list, FieldType: Boolean, DefaultValue: False, Description: Enable Pull list for refresh list

#IgnoreWarnings:19,2,12,9

Sub Class_Globals
	Private mEventName As String 'ignore
	Private mCallBack As Object 'ignore
	Private mBase As WeakRef
	Private Const DefaultColorConstant As Int = -984833 'ignore
	Private table1 As TableView
	Private parent As Panel
	Private label As Label
	Private Props2 As Map
	Private count As Int
	Private SingleLineLayout_ As SingleLineLayout2
	Private TwoLinesLayout2_ As TwoLinesLayout2
	Private TwoLinesAndBitmap2_ As TwoLinesAndBitmap2
End Sub

'#MinVersion: 8
Public Sub Initialize (Callback As Object, EventName As String)
	mEventName = EventName
	mCallBack = Callback
End Sub

Public Sub DesignerCreateView (Base As Panel, Lbl As Label, Props As Map)
	
	mBase.Value = Base
	parent = Base
	label = Lbl
	Props2 = Props
	table1.Initialize("table",False)
	table1.SeparatorColor	=	Props.Get("dividcolor")
	table1.Color = Base.Color
	Base.AddView(table1,0,0,Base.Width,Base.Height)
	
	SingleLineLayout_.Initialize(table1)
	TwoLinesLayout2_.Initialize(table1)
	TwoLinesAndBitmap2_.Initialize(table1)
	
	If Props.Get("refresh") = True Then AddRefresh(table1)
	
End Sub

Private Sub Base_Resize (Width As Double, Height As Double)
	
End Sub

Public Sub GetBase As Panel
	Return mBase.Value
End Sub

Public Sub Clear
	table1.Clear
End Sub

Public Sub SingleLineLayout As SingleLineLayout2
	Return SingleLineLayout_
End Sub

Public Sub TwoLinesLayout As TwoLinesLayout2
	Return TwoLinesLayout2_
End Sub

Public Sub TwoLinesAndBitmap As TwoLinesAndBitmap2
	Return TwoLinesAndBitmap2_
End Sub

'support csbuilder
Sub AddSingleLine(Text As Object)
	AddSingleLine2(Text,Text)
End Sub

'support csbuilder
Sub AddSingleLine2(Text As Object,ReturnValue As Object)
	
	Dim cell As TableCell = table1.AddSingleLine("")

	Dim lbl As Label
	lbl.Initialize("")
	lbl.TextAlignment		= 	SingleLineLayout_.Label.TextAlignment
	lbl.TextColor			= 	SingleLineLayout_.Label.TextColor
	lbl.Color				= 	SingleLineLayout_.Label.Color
	lbl.Font				=	SingleLineLayout_.Label.Font
	lbl.Multiline			=	True
	
	If Text Is AttributedString Then
		lbl.AttributedText	=	Text
	Else
		lbl.Text			=	Text
	End If
	
	cell.Tag				= 	Array(ReturnValue,count)
	cell.ShowSelection 		= 	True
	
	Dim p As Panel
	p.Initialize("")
	p.Width 			= 	table1.Width
	p.Color				=	SingleLineLayout_.Background
	p.Height 			= 	SingleLineLayout_.ItemHeight
	cell.CustomView		= 	p
	p.AddView(lbl,5dip,0,p.Width-20dip,SingleLineLayout_.ItemHeight)

	table1.ReloadAll
	
	count = count + 1

End Sub

'support csbuilder
Sub AddTwoLines(Text1 As Object,Text2 As Object)
	AddTwoLines2(Text1,Text2,Text1)
End Sub

'support csbuilder
Sub AddTwoLines2(Text1 As Object,Text2 As Object,ReturnValue As Object)
	
	Dim cell As TableCell = table1.AddSingleLine("")
	
	Dim lblfirst As Label
	lblfirst.Initialize("")
	lblfirst.TextAlignment		= 	TwoLinesLayout2_.Label.TextAlignment
	lblfirst.TextColor			= 	TwoLinesLayout2_.Label.TextColor
	lblfirst.Color				= 	TwoLinesLayout2_.Label.Color
	lblfirst.Font				=	TwoLinesLayout2_.Label.Font
	lblfirst.Multiline			=	True

	If Text1 Is AttributedString Then
		lblfirst.AttributedText	=	Text1
	Else
		lblfirst.Text			=	Text1
	End If
	
	Dim lblsecond As Label
	lblsecond.Initialize("")
	lblsecond.TextAlignment		= 	TwoLinesLayout2_.SecondLabel.TextAlignment
	lblsecond.TextColor			= 	TwoLinesLayout2_.SecondLabel.TextColor
	lblsecond.Color				= 	TwoLinesLayout2_.SecondLabel.Color
	lblsecond.Font				=	TwoLinesLayout2_.SecondLabel.Font
	lblsecond.Multiline			=	True
	
	If Text2 Is AttributedString Then
		lblsecond.AttributedText=	Text2
	Else
		lblsecond.Text			=	Text2
	End If
	
	cell.Tag					= 	Array(ReturnValue,count)
	cell.ShowSelection 			= 	True
	
	Dim p As Panel
	p.Initialize("")
	p.Color 	= TwoLinesLayout2_.Background
	p.Width 	= table1.Width
	p.Height 	= TwoLinesLayout2_.ItemHeight
	
	p.AddView(lblfirst,5dip,0,p.Width-20dip,TwoLinesLayout2_.ItemHeight/2)
	p.AddView(lblsecond,5dip,lblfirst.Height,table1.Width-20dip,lblfirst.Height)
	
	cell.CustomView			= 	p
	
	table1.ReloadAll
	
	count = count + 1
	
End Sub

Sub AddTemplateItem(LayoutName As String,Title As Object,Icon As Object,ReturnValue As Object)
	
	Dim cell As TableCell = table1.AddSingleLine("")
	cell.ShowSelection	=	False
	
	Dim lbltitle,lblicon As Label
	
	Dim p As Panel
	p.Initialize("")
	p.Color = Colors.Transparent
	p.Width = table1.Width
	p.Height = table1.RowHeight
	cell.CustomView		= p
	cell.Tag = Array(ReturnValue,count)
	
	p.LoadLayout(LayoutName)
	
	lblicon		= p.GetView(0)
	lbltitle	= p.GetView(1)
	
	lbltitle.Text = Title
	lblicon.Text  = Icon
	
	count = count + 1
	
End Sub

Sub AddTwoLinesAndBitmap2(Text1 As Object,Text2 As Object,Icon As Bitmap,ReturnValue As Object)
	
	Dim cell As TableCell = table1.AddSingleLine("")
	
	Dim lblfirst As Label
	lblfirst.Initialize("")
	lblfirst.TextAlignment		= 	TwoLinesAndBitmap2_.Label.TextAlignment
	lblfirst.TextColor			= 	TwoLinesAndBitmap2_.Label.TextColor
	lblfirst.Color				= 	TwoLinesAndBitmap2_.Label.Color
	lblfirst.Font				=	TwoLinesAndBitmap2_.Label.Font
	lblfirst.Multiline			=	True

	If Text1 Is AttributedString Then
		lblfirst.AttributedText	=	Text1
	Else
		lblfirst.Text			=	Text1
	End If
	
	Dim lblsecond As Label
	lblsecond.Initialize("")
	lblsecond.TextAlignment		= 	TwoLinesAndBitmap2_.SecondLabel.TextAlignment
	lblsecond.TextColor			= 	TwoLinesAndBitmap2_.SecondLabel.TextColor
	lblsecond.Color				= 	TwoLinesAndBitmap2_.SecondLabel.Color
	lblsecond.Font				=	TwoLinesAndBitmap2_.SecondLabel.Font
	lblsecond.Multiline			=	True
	
	If Text2 Is AttributedString Then
		lblsecond.AttributedText=	Text2
	Else
		lblsecond.Text			=	Text2
	End If
	
	cell.Tag			= Array(ReturnValue,count)
	cell.ShowSelection 	= True
	
	Dim imgicon As ImageView
	imgicon.Initialize("")
	imgicon.ContentMode = imgicon.MODE_FILL
	imgicon.Bitmap = Icon
	
	Dim p As Panel
	p.Initialize("")
	p.Color 	= 	TwoLinesLayout2_.Background
	p.Width 	= 	table1.Width
	p.Height 	= 	TwoLinesLayout2_.ItemHeight
	
	p.AddView(imgicon,table1.Width-TwoLinesAndBitmap2_.ImageView.Width-15dip,9dip,TwoLinesAndBitmap2_.ImageView.Width,TwoLinesAndBitmap2_.ImageView.Height)
	
	p.AddView(lblfirst,5dip,0,p.Width - 35dip - TwoLinesAndBitmap2_.ImageView.Width,TwoLinesLayout2_.ItemHeight/2)
	p.AddView(lblsecond,5dip,lblfirst.Height,lblfirst.Width,lblfirst.Height)
	
	cell.CustomView		= p
	
	imgicon.Top = p.Height / 2 - imgicon.Height / 2
	
	count = count + 1
	
End Sub

Public Sub setDividerColor(Color As Int)
	table1.SeparatorColor	=	Color
End Sub

Sub getTableview As TableView
	Return table1
End Sub

Sub getView As TableView
	Return table1
End Sub

Sub getSize As Int
	Return count
End Sub

Sub setTag(val As Object)
	table1.Tag	=	val
End Sub

Sub getTag As Object
	Return table1.Tag
End Sub

Sub RemoveAt(Index As Int)
	If table1.GetItems(0).Size - 1 < Index Then Return
	table1.BeginUpdates
	table1.RemoveCells(0, Index, 1)
	table1.EndUpdates
End Sub

Private Sub table_SelectedChanged (SectionIndex As Int, Cell As TableCell)
	Dim tag() As String
	tag = Cell.Tag
	Cell.CustomView.Color	=	Colors.ARGB(50,20,20,20)
	Cell.CustomView.SetColorAnimated(400,Colors.Transparent)
	CallSubDelayed3(mCallBack,mEventName & "_itemclick",tag(1),tag(0))
End Sub

Public Sub AddRefresh (TableView As TableView)
	Dim nome As NativeObject=Me
	nome.RunMethod("AddRefresh:",Array(table1))
End Sub

Private Sub refreshing(RefreshControl As Object)
	Dim no As NativeObject=RefreshControl
	no.RunMethod("endRefreshing",Null) ' END REFRESHING
	CallSubDelayed(mCallBack,mEventName & "_pulldownrefresh")
End Sub

#IF OBJC

-(void)AddRefresh: (UITableView*)tbl {
UITableViewController *tableViewController = [[UITableViewController alloc] init];
tableViewController.tableView = tbl;
UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
[refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
tableViewController.refreshControl = refreshControl;
}

- (void)refresh:(id)sender {

UIRefreshControl *refreshControl=sender;
[self.bi raiseEvent:nil event:@"refreshing:" params:@[(refreshControl)]];

}


#END IF