B4i=true
Group=Libraries
ModulesStructureVersion=1
Type=Class
Version=4.3
@EndOfDesignText@
#Event: Click
#Event: OverScrolled(Action As Object, ScrollY As Int)
#Event: Scrolled(FirstVisibleItem As Int,IsAtBottom As Boolean)
#Event: ItemClick(Position As Int,LayoutPanel as B4XView)
#Event: ItemLongClick(Position As Int,LayoutPanel as B4XView)
#Event: ContentFiller(LayoutPanel As B4XView,Position As Int)
#Event: LayoutCreator(LayoutName As String, LayoutPanel As B4XView)
#IgnoreWarnings:29

Private Sub Class_Globals
	Private table1 As CustomListView
	Private module_me As Object
	Private evt As String
	Private CountItem As Int
	Private xui As XUI
	Private offset_scroll As Int
	Private PressColor As Int
	Private refreshStatus As Boolean
	Private RefreshControl2 As Object
	Private mBase As B4XView
	Public SCROLLBAR_INVISIBLE As Int	:	SCROLLBAR_INVISIBLE	=	0
	Private Layouts As Map : Layouts.Initialize
	Private current_layoutname As String
	Private refresh_data As Boolean
	Private disable_refresh_data As Boolean : disable_refresh_data = True
End Sub

Public Sub DesignerCreateView (Base As Object, Lbl As Label, Props As Map)
	
	mBase = Base
	
	Dim Lbl As Label
	Lbl.Initialize("")
	
	Dim f As Map
	f.Initialize
	f.Put("DividerHeight",0)
	f.Put("PressedColor",Colors.Transparent)
	f.Put("InsertAnimationDuration",0)
	f.Put("ShowScrollBar",False)
	table1.DesignerCreateView(mBase,Lbl,f)
	
End Sub

Public Sub CreateView(Base As Panel)
	
	mBase = Base
	
	Dim Lbl As Label
	Lbl.Initialize("")
	
	Dim f As Map
	f.Initialize
	f.Put("DividerHeight",0)
	f.Put("PressedColor",Colors.Transparent)
	f.Put("InsertAnimationDuration",0)
	f.Put("ShowScrollBar",False)
	table1.DesignerCreateView(mBase,Lbl,f)
	
End Sub

Public Sub Initialize (Callback As Object, EventName As String)
	
	module_me	= Callback
	evt			= EventName
	
	table1.Initialize(Me,"table1")
	
End Sub

Public Sub Build(Parent As Panel)
	
	Dim Lbl As Label
	Lbl.Initialize("")
	
	Dim f As Map
	f.Initialize
	f.Put("DividerHeight",0)
	f.Put("PressedColor",Colors.Transparent)
	f.Put("InsertAnimationDuration",0)
	f.Put("ShowScrollBar",False)
	table1.DesignerCreateView(Parent,Lbl,f)
	
End Sub

'layout should contain one label without other view
Public Sub setPullDownRefreshLayout(Layoutname As String)

End Sub

Public Sub setDisableRefreshData(Val As Boolean)
	disable_refresh_data	=	Val
End Sub

Public Sub FastScroller(State As Boolean)
	
End Sub

Public Sub AddPullDownRefresh
	Dim nome As NativeObject=Me
	nome.RunMethod("AddRefresh:",Array(table1.sv))
End Sub

Public Sub getView As View
	Return table1.AsView
End Sub

Public Sub getFirstVisibleIndex As Int
	If getNumberOfItems = 0 Then Return 0
	Return table1.FirstVisibleIndex
End Sub

Public Sub getLastVisibleIndex As Int
	If getNumberOfItems = 0 Then Return 0
	Return table1.LastVisibleIndex
End Sub

Public Sub GetFirstVisiblePosition As Int
	Return getFirstVisibleIndex
End Sub

Public Sub GetLastVisiblePosition As Int
	Return getLastVisibleIndex
End Sub

Public Sub FadingEdges(Value As Boolean)
	
End Sub

Public Sub SetScrollbarStyle(Style As Int)
	
	If Style = SCROLLBAR_INVISIBLE Then
		Dim no As NativeObject = table1.sv
		no.SetField("showsVerticalScrollIndicator", False)
		no.SetField("showsHorizontalScrollIndicator", False)
	End If
	
End Sub

Public Sub GetVisiblePanels As Panel()
	
	Dim firstPanelIndex,lastPanelIndex As Int
	firstPanelIndex	=	table1.FirstVisibleIndex
	lastPanelIndex	=	table1.LastVisibleIndex

	Dim pnl(lastPanelIndex - firstPanelIndex) As Panel
	
	For i = firstPanelIndex-1 To lastPanelIndex-1
		pnl(i)	=	table1.GetPanel(i)
	Next
	
	Return pnl
	
End Sub

Public Sub GetPanel(Index As Int) As Panel
	Return table1.GetPanel(Index)
End Sub

Public Sub setDividerHeight(Size As Float)
	table1.setDividerSize(Size)
End Sub

Public Sub setPressedDrawable(Color As Int)
	PressColor	=	Color
End Sub

Public Sub setDividerColor(Color As Int)
	table1.sv.Color	=	Color
End Sub

Public Sub setDividerDrawable(Color As Int)
 
End Sub

Public Sub getOffset As Int
	Return offset_scroll
End Sub

Public Sub setColor(Color As Int)
	table1.AsView.Color = Color
End Sub

Public Sub ClearContent
	CountItem	=	0
	table1.Clear
End Sub

Public Sub ClearAllLayouts
	CountItem = 0
	table1.Clear
End Sub

Public Sub ResizeHeight(Index As Int,Height As Int)
	table1.ResizeItem(Index,Height)
End Sub

Public Sub AddRowLayout(Name As String,LayoutCallback As String,ContentCallback As String,Height As Int,NBCELL As Int,CellsWidth() As Int,DividerWidth As Int,BackgroundColor As Int,Selected As Boolean)
End Sub

Public Sub AddLayout(Name As String,LayoutCallback As String,ContentCallback As String,Height As Int,Selected As Boolean)
	Layouts.Put(Name,CreateMap("name":Name,"layoutcallback":LayoutCallback,"contentcallback":ContentCallback,"height":Height))
End Sub

Public Sub AddItem(LayoutName As String,ID As Int)
	
	current_layoutname	=	LayoutName
	
	Dim info As Map
	info	=	Layouts.Get(LayoutName)
	
	Dim ItemHeight As Int
	ItemHeight	=	info.Get("height")
	
	Dim p As Panel
	p = xui.CreatePanel("")
	p.Color	=	Colors.Transparent
	p.SetLayoutAnimated(0,1,0,0,table1.AsView.Width,ItemHeight)
	p.Tag = ID
	
	table1.Add(p,ID)
	
	CountItem	=	CountItem	+	1
	
End Sub

Public Sub BulkAddItems(Qty As Int,LayoutName As String,FirstID As String)
	
	current_layoutname	=	LayoutName
	
	Dim info As Map
	info	=	Layouts.Get(LayoutName)
	
	Dim ItemHeight As Int
	ItemHeight	=	info.Get("height")
	
	For i = 0 To Qty - 1
			
		Dim p As Panel
		p = xui.CreatePanel("")
		p.Color	=	Colors.Transparent
		p.SetLayoutAnimated(0,1,0,0,table1.AsView.Width,ItemHeight)
		p.Tag = FirstID
		table1.Add(p,FirstID)
		
	Next
	
	CountItem	=	CountItem	+	Qty
	
End Sub

Public Sub setVisible(Value As Boolean)
	table1.AsView.Visible = Value
End Sub

Public Sub RefreshContent
	refresh_data	=	True
	table1.Refresh
End Sub

Public Sub RemoveItemAt(Index As Int)
	table1.RemoveAt(Index)
End Sub

Public Sub JumpTo(Index As Int)
	If Index < 0 Then Return
	table1.JumpToItem(Index)
End Sub

Public Sub ScrollToBottom
	
	Dim p As Panel
	p = table1.GetPanel(getNumberOfItems-1)
	p = p.Parent
		
End Sub

Public Sub ScrollToTop
	
	Dim sv As ScrollView
	sv	=	table1.sv
	sv.ScrollTo(0,0,True)
		
End Sub

Public Sub setTag(Data As Object)
	table1.AsView.Tag	=	Data
End Sub

Public Sub getTag As Object
	Return table1.AsView.Tag
End Sub

Public Sub getTop As Int
	Return table1.AsView.Top
End Sub

Public Sub setTop(Val As Int)
	table1.AsView.Top	=	Val
End Sub

Public Sub StackFromBottom(Val As Boolean)
	
End Sub

Private Sub table1_VisibleRangeChanged (FirstIndex As Int, LastIndex As Int)
	
	Dim ExtraSize As Int = 20
	
	For i = Max(0, FirstIndex - ExtraSize) To Min(LastIndex + ExtraSize, table1.Size - 1)
		
		Dim p As B4XView = table1.GetPanel(i)
		
		Dim info As Map
		info	=	Layouts.Get(current_layoutname)
		
		Dim LayoutCallback1,ContentCallback1 As String
		LayoutCallback1		=	info.Get("layoutcallback")
		ContentCallback1	=	info.Get("contentcallback")
		
		If p.NumberOfViews = 0 Or refresh_data Then
			
			p.RemoveAllViews
			
			If SubExists(module_me,LayoutCallback1,2) Then
				CallSub3(module_me,LayoutCallback1,current_layoutname,p)
			End If
			
			If SubExists(module_me,ContentCallback1,2) Then
				CallSub3(module_me,ContentCallback1,p,i)
			Else If SubExists(module_me,ContentCallback1,4) Then
				CallSubX(module_me,ContentCallback1,Array(0,current_layoutname,p,i))
			End If
			
		End If
		
		If refresh_data And disable_refresh_data <> True Then
			CallSub3(module_me,LayoutCallback1,current_layoutname,p)
			CallSub3(module_me,ContentCallback1,p,i)
		End If
		
	Next
	
	refresh_data	=	False
	
End Sub

Private Sub table1_ItemClick (Index As Int, Value As Object)
	
	Dim p As Panel
	p	=	table1.GetPanel(Index)
	p.SetColorAnimated(200,PressColor)
	p.SetColorAnimated(200,Colors.Transparent)
	
	CallSub3(module_me,evt.ToLowerCase & "_itemclick",Index,table1.GetPanel(Index))
	
End Sub

Private Sub table1_Click
	CallSub(module_me,evt.ToLowerCase & "_click")
End Sub

Private Sub table1_ItemLongClick (Index As Int, Value As Object)
	
	Dim p As Panel
	p	=	table1.GetPanel(Index)
	p.SetColorAnimated(200,PressColor)
	p.SetColorAnimated(200,Colors.Transparent)
	
	CallSub3(module_me,evt.ToLowerCase & "_itemlongclick",Index,table1.GetPanel(Index))
	
End Sub

Private Sub table1_ReachEnd

	If SubExists(module_me,evt.ToLowerCase & "_scrolled",2) Then
		CallSub3(module_me,evt.ToLowerCase & "_scrolled",table1.FirstVisibleIndex,True)
	End If
	
End Sub

Private Sub table1_ScrollChanged (Offset As Int)
	
	offset_scroll	=	Offset
	
	If SubExists(module_me,evt.ToLowerCase & "_scrolled",2) Then
		CallSub3(module_me,evt.ToLowerCase & "_scrolled",table1.FirstVisibleIndex,False)
	End If
	
End Sub

#IgnoreWarnings:12
Private Sub refreshing(RefreshControl As Object)

	refreshStatus	=	True
	RefreshControl2	=	RefreshControl
	
	If SubExists(module_me,evt.ToLowerCase & "_overscrolled",2) Then
		CallSub3(module_me,evt.ToLowerCase & "_overscrolled","REFRESH",offset_scroll)
	End If
	
End Sub

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

Public Sub getRefreshStatus As Boolean
	Return refreshStatus
End Sub

Public Sub StopRefresh
	
	refreshStatus = False
	
	Dim no As NativeObject	=	RefreshControl2
	no.RunMethod("endRefreshing",Null)
	
End Sub

Public Sub getNumberOfItems As Int
	Return CountItem
End Sub

Public Sub getWidth As Int
	Return table1.AsView.Width
End Sub

Public Sub getHeight As Int
	Return table1.AsView.Height
End Sub

Public Sub setHeight(Height As Int)
	table1.AsView.Height	=	Height
End Sub

Private Sub CallSubX (Component As Object,SubName As String,Params() As Object)
	
	Dim no As NativeObject=Component
	Dim name As String=SubName
	Dim ll As List
	ll.Initialize2(Params)
	For i =0 To Params.Length-1
		name=name & ":"
	Next
	no.GetField("bi").RunMethod("raiseUIEvent:event:params:",Array(Null,name,ll))

End Sub