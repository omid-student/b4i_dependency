B4i=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=5.3
@EndOfDesignText@
#Event: PageChanged(Index As Int)

Private Sub Class_Globals
	Private sv As ScrollView
	Private Left As Int
	Private Panels As List
	Private My_Parent As Panel
	Private prev_panel As View
	Private ob As Object
	Private ev As String
	Private With_Animation As Boolean
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(Module As Object,Event As String,Parent As Panel,WithAnimation As Boolean)
	
	My_Parent		=	Parent
	ob				=	Module
	ev				=	Event
	With_Animation	=	WithAnimation
	
	sv.Initialize("sv1",0,0)
	
	Parent.AddView(sv,0,0,Parent.Width,Parent.Height)
	
	sv.Color			=	Colors.Transparent
	sv.PagingEnabled	=	True
	sv.ShowsHorizontalIndicator = False
	sv.ShowsVerticalIndicator	= False
	sv.ContentHeight 			= Parent.Height
	
	Left				=	Left	+	50dip
	
	Panels.Initialize
	
End Sub

Public Sub AddPanel(Panel As View)
	
	sv.Panel.AddView(Panel,Left,50dip,sv.Width - 100dip,sv.Height - 100dip)
	
	Panel.Tag	=	""
	
	CenterTop(Panel,sv)
	
	Left			=	Left	+	Panel.Width + 100dip
	
	sv.ContentWidth	=	Left
	
	Panels.Add(Panel)
	
	If Panels.Size = 1 Then
		sv1_ScrollChanged(0,0)
	End If
	
End Sub

Public Sub GotoPage(Index As Int,WithAnimation As Boolean)
	
	Dim ot As Int
	ot = Index * sv.Width
	sv.ScrollTo(ot,0,WithAnimation)

End Sub

Public Sub getNumberOfItem As Int
	Return Panels.Size	
End Sub

Public Sub getPanels As List
	Return Panels
End Sub

Private Sub sv1_ScrollChanged(OffsetX As Int, OffsetY As Int)
	
	Dim curr_page_index As String
	curr_page_index = (OffsetX + (0.5f * My_Parent.Width)) / My_Parent.Width
 
	If curr_page_index = Panels.Size Then Return
	
	If curr_page_index = Panels.Size Then Return
	
	Dim item As View
	item	=	Panels.Get(curr_page_index)
	
	If prev_panel.IsInitialized Then
		If item = prev_panel Then Return
		Dim tag() As Int
		tag	=	prev_panel.Tag
		prev_panel.Tag	=	""
		prev_panel.SetLayoutAnimated(1,1,tag(0),tag(1),tag(2),tag(3))
	End If

	If GetType(item.Tag) <> "B4IArray" Then
		
		item.Tag = Array As Int(item.Left,item.Top,item.Width,item.Height)
		
		If With_Animation Then
			ScaleView(item)
		End If
		
		prev_panel	=	item
		
		If SubExists(ob,ev & "_pagechanged",1) Then
			CallSub2(ob,ev & "_pagechanged",curr_page_index)
		End If
		
	End If
	
End Sub

Private Sub ScaleView(item As View)
	Sleep(100)
	item.SetLayoutAnimated(800,1,item.Left - 30dip,item.Top - 30dip,item.Width + 60dip,item.Height + 60dip)
End Sub

Private Sub CenterTop(v As View, parent As View)
	v.Top = parent.Height / 2 - v.Height / 2
End Sub