Type=Class
Version=1.5
ModulesStructureVersion=1
B4i=true
@EndOfDesignText@
'Class module
Sub Class_Globals
	Private sv As ScrollView
	Private items As List
	Private Panels As List
	Private dividerHeight As Float
	Private EventName As String
	Private CallBack As Object
	Public DefaultTextFont As Font
	Public DefaultTextColor As Int
	Public DefaultTextBackgroundColor As Int
	Private HighlightColor As Int = Colors.LightGray
	Private PanelsCache() As Panel
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize (vCallback As Object, vEventName As String, Width As Int)
	sv.Initialize("sv", Width, 0)
	items.Initialize
	Panels.Initialize
	dividerHeight = 1dip
	EventName = vEventName
	CallBack = vCallback
	sv.Color = 0xFFF5F5F5 'this sets the dividers color
	DefaultTextColor = Colors.Black
	DefaultTextFont = Font.CreateNew(16)
	DefaultTextBackgroundColor = Colors.White
End Sub
Public Sub SetCache(n As Int)
	Dim PanelsCache(n) As Panel
	For Each pnl As Panel In PanelsCache
		pnl.Initialize("panel")
		Dim lbl As Label
		lbl.Initialize("")
		lbl.TextAlignment = lbl.ALIGNMENT_LEFT
		pnl.AddView(lbl, 5dip, 2dip, sv.Width - 5dip, 20dip)
		lbl.Font = DefaultTextFont
		lbl.TextColor = DefaultTextColor
		pnl.Color = DefaultTextBackgroundColor
		lbl.Height = Max(50dip, lbl.Height)
	Next
End Sub

Public Sub SetSize(width As Int, height As Int)
	If width <> sv.ContentWidth Then
		sv.ContentWidth = width
		For Each p As Panel In Panels
			p.width = width
			p.GetView(0).width = width
		Next
	End If
	Dim c As Int = sv.ScrollOffsetY
	sv.SetLayoutAnimated(0, 0, sv.Left, sv.Top, width, height)
	SetOffset(c)
End Sub 

Public Sub AsView As View
	Return sv
End Sub

'Clears all items.
Public Sub Clear
	items.Clear
	Panels.Clear
	sv.ContentHeight = 0
	sv.Panel.RemoveAllViews
End Sub

'Returns the number of items.
Public Sub GetSize As Int
	Return items.Size
End Sub

'Returns the Panel stored at the specified index.
Public Sub GetPanel(Index As Int) As Panel
	Dim p As Panel
	p = Panels.Get(Index) 'this is the parent panel
	Return p.GetView(0)
End Sub

'Returns the value stored at the specified index.
Public Sub GetValue(Index As Int) As Object
	Return items.Get(Index)
End Sub

'Removes the item at the specified index.
Public Sub RemoveAt(Index As Int)
	Dim removePanel, p As Panel
	removePanel = Panels.Get(Index)
	For i = Index + 1 To items.Size - 1
		p = Panels.Get(i)
		p.Tag = i - 1
		p.Top = p.Top - removePanel.Height - dividerHeight
	Next
	sv.ContentHeight = sv.ContentHeight - removePanel.Height - dividerHeight
	items.RemoveAt(Index)
	Panels.RemoveAt(Index)
	removePanel.RemoveViewFromParent
End Sub

'Adds a custom item at the specified index.
Public Sub InsertAt(Index As Int, Pnl As Panel, ItemHeight As Int, Value As Object)
	'create another panel to handle the click event
	Pnl.SetLayoutAnimated(0, 1, 0, 0, sv.Width, ItemHeight)
	Pnl.Tag = Index
	If Index = items.Size Then
		items.Add(Value)
		Panels.Add(Pnl)
		Dim top As Int
		If Index = 0 Then top = dividerHeight Else top = sv.Panel.Height
		sv.Panel.AddView(Pnl, 0, top, sv.Width, ItemHeight)
	Else
		Dim top As Int
		If Index = 0 Then
			top = dividerHeight
		Else
			Dim previousPanel As Panel
			previousPanel = Panels.Get(Index - 1)
			top = previousPanel.top + previousPanel.Height + dividerHeight
		End If

		Dim p2 As Panel
		For i = Index To Panels.Size - 1
			p2 = Panels.Get(i)
			p2.top = p2.top + ItemHeight + dividerHeight
			p2.Tag = i + 1
		Next
		items.InsertAt(Index, Value)
		Panels.InsertAt(Index, Pnl)
		sv.Panel.AddView(Pnl, 0, top, sv.Width, ItemHeight)
	End If
	sv.ContentHeight = sv.ContentHeight + ItemHeight + dividerHeight
	If items.Size = 1 Then sv.ContentHeight = sv.ContentHeight + dividerHeight
End Sub

Public Sub Add(Pnl As Panel, ItemHeight As Int, Value As Object)
	InsertAt(items.Size, Pnl, ItemHeight, Value)
End Sub

'Adds a text item. The item height will be adjusted based on the text.
Public Sub AddTextItem(rs As RichString, Value As Object)
	If GetSize >= PanelsCache.Length Then Return
	Dim pnl As Panel = PanelsCache(GetSize)
	Dim lbl As Label = pnl.GetView(0)
	rs.SetToLabel(lbl)
	InsertAt(items.Size, pnl, lbl.Height + 2dip, Value)
End Sub


Private Sub Panel_LongClick
   Dim p As Panel = Sender
   p.GetView(0).Color = HighlightColor
   p.GetView(0).SetColorAnimated(700, Colors.Transparent)
   CallSub3(CallBack, EventName & "_ItemLongClick", p.Tag, items.Get(p.Tag))
End Sub

Private Sub Panel_Click
	Dim p As Panel = Sender
	p.GetView(0).Color = HighlightColor
	p.GetView(0).SetColorAnimated(700, Colors.Transparent)
	CallSub3(CallBack, EventName & "_ItemClick", p.Tag, items.Get(p.Tag))
End Sub


'Scrolls the list to the specified item.
Public Sub JumpToItem(Index As Int)
	Dim top As Int
	Dim p As Panel
	For i = 0 To Min(Index - 1, items.Size - 1)
		p = Panels.Get(i)
		top = top + p.Height + dividerHeight
	Next
	SetOffset(top)
End Sub
Private Sub SetOffset(y As Int)
	sv.ScrollOffsetY = Max(0, Min(y, sv.ContentHeight - sv.Height))
End Sub
'Returns the index of the item that holds the given view.
Public Sub GetItemFromView(v As View) As Int
	Dim r As NativeObject
	Dim parent, current As Object
	parent = v
	Do While (parent Is Panel) = False OR sv.Panel <> parent
		current = parent
		r = current
		parent = r.GetField("superview")
	Loop
	v = current
	Return v.Tag
End Sub

Private Sub sv_ScrollChanged (OffsetX As Int, OffsetY As Int)
	If OffsetY > 0 Then CallSub(CallBack, EventName & "_scrollchanged")
End Sub