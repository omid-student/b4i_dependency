B4i=true
Group=Libraries
ModulesStructureVersion=1
Type=Class
Version=5
@EndOfDesignText@
#IgnoreWarnings: 9

Private Sub Class_Globals
	Private Text_Color As Int
	Private Line_Color As Int
	Private Line_Color_Selected As Int
	Private Line_Height As Int
	Private Text_Font As Font
	Private sv As ScrollView
	Private pager2 As ViewPager
	Private Left As Int
	Private Line As Label
	Private parent_2 As Panel
	Private all_tab_count As Int
	Private current_lbl As Label
	Private tab_width As Int
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(Parent As Panel,Pager As ViewPager)
	
	parent_2	=	Parent
	Pager.AutoChangeFixedTabs	=	Me
	
	sv.Initialize("sv",0,Parent.Height)
	
	pager2				=	Pager
	Text_Color			=	Colors.Black
	Line_Color			=	Colors.Gray
	Line_Color_Selected	=	Colors.Magenta
	Line_Height			=	2dip
	Text_Font			=	Font.CreateNew(13)
	
	Dim no As NativeObject = sv
	no.SetField("showsVerticalScrollIndicator", False)
	no.SetField("showsHorizontalScrollIndicator", False)
	
	Parent.AddView(sv,0,0,Parent.Width,Parent.Height)
	
	all_tab_count	=	Pager.PageCount
	tab_width		=	Parent.Width / 4
	
End Sub

Public Sub setTabWidth(Val As Int)
	tab_width	=	Val
End Sub

Public Sub setFont(TextFont As Font)
	Text_Font	=	TextFont
End Sub

Public Sub setTextColor(Color As Int)
	Text_Color	=	Color
End Sub

Public Sub setLineColor(Color As Int)
	Line_Color	=	Color
End Sub

Public Sub setLineColorSelected(Color As Int)
	Line_Color_Selected	=	Color
End Sub

Public Sub setLineHeight(Color As Int)
	Line_Height	=	Color
End Sub

Public Sub AddViewToParent
	
	Dim pages As List
	pages	=	pager2.GetPages2
	
	For i = 0 To pages.Size - 1
		
		Dim temp As Map
		temp	=	pages.Get(i)
		
		AddTab(temp.Get("title"),i)
		
	Next
	
	Line.Initialize("")
	Line.Color	=	Line_Color
	parent_2.AddView(Line,0,sv.Height - Line_Height-Line_Height,tab_width,Line_Height)
	
End Sub

Public Sub setCurrentTab(Index As Int)
	
	For Each v1 As Label In sv.Panel.GetAllViewsRecursive
		
		If Index =	v1.Tag Then
			
			current_lbl	=	v1
			
			If v1.Tag + 2 >= all_tab_count Or v1.Tag < 2 Then
				
				If v1.Tag = 0 Then
					sv.ScrollTo(v1.Left,0,True)
					Sleep(300)
				End If
				
			Else
				sv.ScrollTo(v1.Left,0,True)
				Sleep(300)
			End If
	
			Line.SetLayoutAnimated(300,1,v1.Left - sv.ScrollOffsetX,Line.Top,Line.Width,Line.Height)
	
			pager2.GotoPage(v1.Tag,True)
			
			Return
			
		End If
		
	Next
	
End Sub

Public Sub getView As ScrollView
	Return sv
End Sub

Private Sub AddTab(Title As String,Index As Int)
	
	Dim lbl As Label
	lbl.Initialize("tabitem41")
	lbl.TextAlignment	=	lbl.ALIGNMENT_CENTER
	lbl.TextColor		=	Text_Color
	lbl.Font			=	Text_Font
	lbl.Text			=	Title
	lbl.Tag				=	Index
	
	sv.Panel.AddView(lbl,Left,0,tab_width,sv.Height)
	
	Left	=	Left + lbl.Width
	
	sv.ContentWidth	=	Left
	
End Sub

Private Sub tabitem41_Click
	
	Dim lb As Label
	lb	=	Sender
	
	current_lbl	=	lb
	
	If lb.Tag + 2 >= all_tab_count Or lb.Tag < 2 Then
		
		If lb.Tag = 0 Then
			sv.ScrollTo(0,0,True)
			Sleep(300)
		End If
			
	Else
		sv.ScrollTo(lb.Left,0,True)
		Sleep(300)
	End If
	
	Line.SetLayoutAnimated(300,1,lb.Left - sv.ScrollOffsetX,Line.Top,Line.Width,Line.Height)
	
	pager2.GotoPage(lb.Tag,True)
	
End Sub

Private Sub sv_ScrollChanged (OffsetX As Int, OffsetY As Int)
	
	If current_lbl.IsInitialized Then
		Line.SetLayoutAnimated(300,1,current_lbl.Left - sv.ScrollOffsetX,Line.Top,Line.Width,Line.Height)
	End If
	
End Sub