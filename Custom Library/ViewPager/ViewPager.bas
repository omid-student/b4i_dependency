B4i=true
Group=Libraries
ModulesStructureVersion=1
Type=Class
Version=4.3
@EndOfDesignText@
#Event: PageChanged(Position As Int)
#Event: PageSelected(Position As Int)

Private Sub Class_Globals
	Private pnl As Panel
	Private sv As ScrollView
	Private Left As Int
	Private ev As String
	Private ob As Object
	Private pages As List
	Private curr_page_index As Int
	Private change_tab_flag As ViewPagerFixedTabs
End Sub

'Try to initialize this library in Page_Resize
'For more library please visit www.iranapp.org :)
Public Sub Initialize(Module As Object,Event As String,Panel As Panel)
	
	pnl = Panel
	sv.Initialize("sv1",0,0)
	
	ev = Event 
	ob = Module
	
	pnl.AddView(sv,0,0,pnl.Width,pnl.Height)
	
	sv.Color					= Colors.Transparent
	sv.Panel.Color 				= Colors.Transparent
	sv.PagingEnabled 			= True
	sv.ShowsHorizontalIndicator = False
	sv.ShowsVerticalIndicator	= False
	
	sv.ContentHeight 			= pnl.Height
	
	pages.Initialize
	
End Sub

Sub AddPage(View As View,Title As String)
	
	Dim p As Panel
	p.Initialize("")
	p.SetBorder(0,0,0)
	p.Color = Colors.Transparent
	sv.Panel.AddView(p,Left,0,pnl.Width,pnl.Height)
	p.AddView(View,0,0,pnl.Width,pnl.Height)
	
	Left = Left + pnl.Width
	sv.ContentWidth = Left
	
	pages.Add(CreateMap("title":Title,"view":p,"index":pages.Size-1))
	
End Sub

#IgnoreWarnings: 12
Sub LoadLayout(Layoutname As String,Title As String)
	
	Dim p As Panel
	p.Initialize("")
	p.SetBorder(0,0,0)
	p.LoadLayout(Layoutname)
	sv.Panel.AddView(p,Left,0,pnl.Width,pnl.Height)
	
	Left = Left + pnl.Width
	sv.ContentWidth = Left
	
	pages.Add(CreateMap("title":Title,"view":p,"index":pages.Size-1))
	
End Sub

'get pages as l
Public Sub GetPages2 As List
	Return pages
End Sub

Private Sub sv1_ScrollChanged (OffsetX As Int, OffsetY As Int)
	
	Dim ot As String
	ot = OffsetX / sv.Width
	If ot.IndexOf(".") > -1 Then Return
	
	curr_page_index = ot
	
	If SubExists(ob,ev & "_pagechanged",1) Then
		CallSubDelayed2(ob,ev & "_pagechanged",curr_page_index)
	End If
	
	If SubExists(ob,ev & "_pageselected",1) Then
		CallSubDelayed2(ob,ev & "_pageselected",curr_page_index)
	End If
	
	If change_tab_flag.IsInitialized Then
		Sleep(40)
		change_tab_flag.CurrentTab	=	curr_page_index
	End If
	
End Sub

Public Sub DeletePage(Index As Int)
	
	Dim temp As Map
	temp = pages.Get(Index)
	
	Dim p As Panel
	p = temp.Get("view")
	
	p.RemoveViewFromParent
	
	For i = Index + 1 To pages.Size - 1
		
		Dim temp As Map
		temp = pages.Get(i)
	
		Dim p As Panel
		p = temp.Get("view")
		
		p.Left = p.Left - p.Width
		
	Next
	
	pages.RemoveAt(Index)
	
	sv.ContentWidth = sv.ContentWidth - sv.Width
	
End Sub

Public Sub getPageCount As Int
	Return pages.Size
End Sub

Public Sub ClearPages
	Left	=	0
	sv.Panel.RemoveAllViews
	sv.ContentWidth = 0
End Sub

Public Sub IsEndPager As Boolean
	
	If curr_page_index = getCount - 1 Then
		Return True
	Else
		Return False
	End If
	
End Sub

Public Sub setAutoChangeFixedTabs(Value As ViewPagerFixedTabs)
	change_tab_flag	=	Value
End Sub

'Get all pages that added to ViewPager
'Each view added to panel when you AddPage
Public Sub getPages As List
	
	Dim temp As List
	temp.Initialize
	
	For i = 0 To pages.Size - 1
		Dim m As Map
		m = pages.Get(i)
		temp.Add(m.Get("view"))		
	Next
	
	Return temp
	
End Sub

Public Sub GotoPage(Index As Int,WithAnimation As Boolean)
	
	Dim ot As Int
	ot = Index * sv.Width
	sv.ScrollTo(ot,0,WithAnimation)

End Sub

Public Sub setEnable(State As Boolean)
	sv.UserInteractionEnabled = State
End Sub

'Each view added to panel when you AddPage
Public Sub GetPage(Index As Int) As Panel
	If Index > pages.Size - 1 Then Return Null
	Dim t As Map
	t = pages.Get(Index)
	Return t.Get("view")
End Sub

Public Sub getCurrentPageIndex As Int
	Return curr_page_index
End Sub

Public Sub getCurrentPage As View
	Dim t As Map
	t = pages.Get(curr_page_index)
	Return t.Get("view")
End Sub

Public Sub getCount As Int
	Return pages.Size
End Sub

Public Sub getView As ScrollView
	Return sv
End Sub

Public Sub setSlidingTouch(State As Boolean)
	Dim j As NativeObject
	j = sv
	j.SetField("scrollEnabled",State)
End Sub