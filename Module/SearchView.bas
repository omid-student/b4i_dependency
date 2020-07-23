Type=Class
Version=2.5
ModulesStructureVersion=1
B4i=true
@EndOfDesignText@
'version 2.01
#Event: ItemClick(Value As String)
Sub Class_Globals
	Private prefixList As Map
	Private substringList As Map
	Private et As TextField
	Private lv As TableView
	Private Const MIN_LIMIT = 2, MAX_LIMIT = 4 As Int
	Private mCallback As Object
	Private mEventName As String
	Private allItems As List
	Private mBase As WeakRef
	Private keyboardHeight As Int
End Sub

'Initializes the object and sets the module and sub that will handle the ItemClick event
Public Sub Initialize (Callback As Object, EventName As String)
	et.Initialize("et")
	et.ShowClearButton = True
	lv.Initialize("lv", False)
	lv.Visible = False
	prefixList.Initialize
	substringList.Initialize
	mCallback = Callback
	mEventName = EventName
End Sub

Public Sub DesignerCreateView (Base As Panel, Lbl As Label, Props As Map)
	mBase.Value = Base
	'In this case the views are added to the parent instead of the base panel.
	'This is required as we don't want the base panel to "steal" touch events when the TableView is hidden.
	'UserInteractionEnabled property affects all child views. So we must move the list and text field.
	Base.UserInteractionEnabled = False
	Dim parent As Panel = Base.Parent
    parent.AddView(et, Base.Left, Base.Top, Base.Width, 60dip)
	parent.AddView(lv, Base.Left, Base.Top + et.Height, Base.Width, Base.Height - et.Height)
	et_TextChanged("", "")
	
End Sub

Public Sub KeyboardState(Height As Int)
	keyboardHeight = Height
	Base_Resize(GetBase.Width, GetBase.Height)
End Sub

Private Sub Base_Resize (Width As Double, Height As Double)
	et.SetLayoutAnimated(0, 1, GetBase.Left, GetBase.Top, Width, 60dip)
	lv.SetLayoutAnimated(0, 1, GetBase.Left, GetBase.Top + et.Height, Width, _ 
		Min(GetBase.CalcRelativeKeyboardHeight(keyboardHeight) - et.Height, GetBase.Height - et.Height))
End Sub

Public Sub GetBase As Panel
	Return mBase.Value
End Sub


Private Sub lv_SelectedChanged (SectionIndex As Int, Cell As TableCell)
	et.Text = Cell.Text.ToString
	lv.SetSelection(0, -1)
	et.ResignFocus
	lv.Visible = False
	CallSub2(mCallback, mEventName & "_ItemClick", et.Text)
End Sub


Private Sub et_TextChanged (Old As String, New As String)
	lv.Clear
	If lv.Visible = False Then lv.Visible = True
	FillList(New)
	
End Sub

Private Sub FillList (new As String)
	If new.Length < MIN_LIMIT Then 
		AddItemsToList(allItems, "")
		Return
	End If
	Dim str1, str2 As String
	str1 = new.ToLowerCase
	If str1.Length > MAX_LIMIT Then
		str2 = str1.SubString2(0, MAX_LIMIT)
	Else
		str2 = str1
	End If
	AddItemsToList(prefixList.Get(str2), str1)
	AddItemsToList(substringList.Get(str2), str1)
End Sub

Private Sub AddItemsToList(li As List, full As String)
	If li.IsInitialized = False Then Return
	Dim rs As RichString
	rs.Initialize("")
	For i = 0 To li.Size - 1
		Dim item As String
		item = li.Get(i)
		item = item.ToLowerCase
		If full.Length > MAX_LIMIT And item.Contains(full) = False Then
			Continue
		End If
		rs.Text = li.Get(i)
		If full.Length > 0 Then
			Dim ii As Int = item.IndexOf(full)
			rs.Color(Colors.Red, ii, ii + full.Length)
		End If
		Dim tc As TableCell = lv.AddSingleLine("")
		tc.Text = rs.AttributedString
	Next
	lv.ReloadAll
End Sub

'Builds the index
Public Sub SetItems(Items As List)
	allItems = Items
	
	AddItemsToList(allItems, "")
	Dim startTime As Long 
	startTime = DateTime.Now
	Dim noDuplicates As Map
	noDuplicates.Initialize
	prefixList.Clear
	substringList.Clear
	Dim m As Map
	Dim li As List
	For i = 0 To Items.Size - 1
		Dim item As String
		item = Items.Get(i)
		item = item.ToLowerCase
		noDuplicates.Clear
		For start = 0 To item.Length
			Dim count As Int
			count = MIN_LIMIT
			Do While count <= MAX_LIMIT And start + count <= item.Length
				Dim str As String
				str = item.SubString2(start, start + count)
				If noDuplicates.ContainsKey(str) = False Then 
					noDuplicates.Put(str, "")
					If start = 0 Then m = prefixList Else m = substringList
					li = m.Get(str)
					If li.IsInitialized = False Then
						li.Initialize
						m.Put(str, li)
					End If
					li.Add(Items.Get(i)) 'Preserve the original case
				End If
				count = count + 1
			Loop
		Next
	Next
	Log("Index time: " & (DateTime.Now - startTime) & " ms (" & Items.Size & " Items)")
End Sub

'Sets the index from the previously stored index.
Public Sub SetIndex(Index As Object)
	Dim obj() As Object
	obj = Index
	prefixList = obj(0)
	substringList = obj(1)
End Sub