Type=Class
Version=1.5
ModulesStructureVersion=1
B4i=true
@EndOfDesignText@
'Version 1.01
Sub Class_Globals
	Private StringUtils1 As StringUtils
	Private SV As ScrollView
	Private Header As Panel
	Private Callback As Object
	Private Event As String
	Private SelectedRow As Int
	Private Data As List
	Private LabelsCache As List
	Private minVisibleRow, maxVisibleRow As Int
	Private visible As Boolean
	Private visibleRows As Map
	Private NumberOfColumns, ColumnWidth As Int
	Public RowHeight, HeaderColor, TableColor, FontColor, HeaderFontColor As Int
	Public Font1 As Font = Font.CreateNew(14)
	Type RowCol (Row As Int, Col As Int)
	Public Alignment As Int
	'Table settings
	HeaderColor = Colors.Gray
	RowHeight = 30dip
	TableColor = Colors.LightGray
	FontColor = Colors.Black
	HeaderFontColor = Colors.White
	Public SelectedRowColor = 0xFF007FFF, OddRowColor = Colors.White, EvenRowColor = 0xFF98F5FF As Int
End Sub

Public Sub Initialize (CallbackModule As Object, EventName As String, vNumberOfColumns As Int)
	Dim lbl As Label 'ignore
	Alignment = lbl.ALIGNMENT_CENTER
	SV.Initialize("SV", 0, 0)
	SV.Panel.Color = TableColor
	Callback = CallbackModule
	Event = EventName
	innerClearAll(vNumberOfColumns)
	
End Sub

'Clears the table
Public Sub ClearAll
	innerClearAll(NumberOfColumns)
End Sub

'Sets the columns widths.
'Example: <code>Table1.SetColumnsWidths(Array As Int(100dip, 30dip, 30dip, 100%x - 160dip))</code>
Public Sub SetColumnsWidths(Widths() As Int)
	Dim v As View
	For i = 0 To Widths.Length - 1
		v = Header.GetView(i)
		v.Width = Widths(i) - 1dip
		If i > 0 Then
			v.Left = Header.GetView(i-1).Left + Widths(i-1) + 1dip
		End If
	Next
	For Each lbls() As Label In visibleRows.Values
		For lbl = 0 To lbls.Length - 1
			lbls(lbl).SetLayoutAnimated(0, 0, Header.GetView(lbl).Left, lbls(lbl).Top, _
				Header.GetView(lbl).Width, RowHeight)
		Next
	Next
End Sub

Private Sub innerClearAll(vNumberOfColumns As Int)
	Log("innerClearAll")
	SV.Panel.RemoveAllViews
	NumberOfColumns = vNumberOfColumns
	SV.ContentHeight = 0
	SelectedRow = -1
	minVisibleRow = -1
	maxVisibleRow = 0
	Data.Initialize
	LabelsCache.Initialize
	visibleRows.Initialize
	SV.ScrollOffsetY = 0
	For i = 1 To 80 'fill the cache to avoid delay on the first touch
		LabelsCache.Add(CreateNewLabels)
	Next
	If visible Then
		SV_ScrollChanged(0, 0)
	End If
End Sub

Private Sub SV_ScrollChanged (OffsetX As Int, OffsetY As Int)
	Dim currentMin, currentMax As Int
	currentMin = Max(0, OffsetY / RowHeight - 30)
	currentMax = Min(Data.Size - 1, (OffsetY + SV.Height) / RowHeight + 30)
	If minVisibleRow > -1 Then
		If minVisibleRow < currentMin Then
			'need to hide the upper rows
			For I = minVisibleRow To Min(currentMin - 1, maxVisibleRow)
				HideRow(I)
			Next
		Else If minVisibleRow > currentMin Then
			'need to show the upper rows
			For I = currentMin To Min(minVisibleRow - 1, currentMax)
				ShowRow(I)
			Next
		End If
		If maxVisibleRow > currentMax Then
			'need to hide the lower rows
			For I = maxVisibleRow To Max(currentMax + 1, minVisibleRow) Step -1
				HideRow(I)
			Next
		Else If maxVisibleRow < currentMax Then
			'need to show the lower rows
			For I = currentMax To Max(maxVisibleRow + 1, currentMin) Step -1
				ShowRow(I)
			Next
		End If
	End If
	minVisibleRow = currentMin
	maxVisibleRow = currentMax
End Sub

Public Sub Resize(Width As Int, Height As Int)
	SV.Height = Height - RowHeight
	SV.Width = Width
	SV.ContentWidth = Width
End Sub

'Adds the tablet to the activity.
Public Sub AddToParent(Act As Panel, Left As Int, Top As Int, Width As Int, Height As Int)
	visible = True
	Header.Initialize("")
	Header.Color = TableColor
	Act.AddView(Header, Left, Top , Width, RowHeight)
	Act.AddView(SV, Left, Top + RowHeight, Width, Height - RowHeight)
	ColumnWidth = SV.Width / NumberOfColumns
	SV.ContentWidth = Width
	SV_ScrollChanged(0, 0)

End Sub



'Adds a row to the table
'Example:<code>Table1.AddRow(Array As String("aaa", "ccc", "ddd", "eee"))</code>
Public Sub AddRow(Values() As String)
	If Values.Length <> NumberOfColumns Then
		Log("Wrong number of values.")
		Return
	End If
	Data.Add(Values)
	Dim lastRow As Int
	lastRow = Data.Size - 1
	If lastRow < (SV.ScrollOffsetY + SV.Height) / RowHeight + 1 Then
		ShowRow(lastRow)		
	End If
	SV.ContentHeight = Data.Size * RowHeight
End Sub
Private Sub ShowRow(row As Int)
	If visibleRows.ContainsKey(row) Then Return
	Dim lbls() As Label
	Dim values() As String
	lbls = GetLabels(row)
	values = Data.Get(row)
	visibleRows.Put(row, lbls)
	Dim rowColor As Int
	If row = SelectedRow Then
		rowColor = SelectedRowColor
	Else If row Mod 2 = 0 Then
		rowColor = EvenRowColor
	Else
		rowColor = OddRowColor
	End If
	For I = 0 To lbls.Length - 1
		SV.Panel.AddView(lbls(I), Header.GetView(I).Left, row * RowHeight, Header.GetView(I).Width, _
			RowHeight - 1dip)
		lbls(I).Text = values(I)
		lbls(I).Color = rowColor
	Next
End Sub

Public Sub IsRowVisible(Row As Int) As Boolean
	Return Row < (SV.ScrollOffsetY + SV.Height) / (RowHeight + 1) AND _
		Row > SV.ScrollOffsetY / RowHeight
End Sub

Private Sub HideRow (Row As Int)
	'Log("HideRow: " & row)
	Dim lbls() As Label
	lbls = visibleRows.Get(Row)
	If lbls = Null Then 
		Log("HideRow: (null) " & Row)
		Return
	End If
	For I = 0 To lbls.Length - 1	
		lbls(I).RemoveViewFromParent
	Next
	visibleRows.Remove(Row)
	LabelsCache.Add(lbls)
End Sub

Private Sub GetLabels(Row As Int) As Label()
	Dim lbls() As Label
	If LabelsCache.Size > 0 Then
		'Log("from cache")
		lbls = LabelsCache.Get(LabelsCache.Size - 1)
		LabelsCache.RemoveAt(LabelsCache.Size - 1)
	Else
		lbls = CreateNewLabels		
	End If
	For I = 0 To lbls.Length - 1
		Dim rc As RowCol
		rc = lbls(I).Tag
		rc.Row = Row
	Next
	Return lbls
End Sub

Private Sub CreateNewLabels As Label()

	Dim lbls(NumberOfColumns) As Label
	For I = 0 To NumberOfColumns - 1
		Dim rc As RowCol
		rc.Col = I
		Dim l As Label
		l.Initialize("cell")
		l.TextAlignment = Alignment
		l.Font = Font1
		l.TextColor = FontColor
		l.Tag = rc
		l.Multiline = True
		lbls(I) = l
	Next
	Return lbls
End Sub
'Set the headers values
'Example:<code>Table1.SetHeader(Array As String("Col1", "Col2", "Col3"))</code>
Public Sub SetHeader(Values() As String)
	For I = Header.NumberOfViews - 1 To 0 Step -1
		Header.RemoveViewAt(I)
	Next
	For I = 0 To NumberOfColumns - 1
		Dim l As Label
		l.Initialize("header")
		l.Font = Font1
		l.Color = HeaderColor
		l.TextColor = HeaderFontColor
		l.TextAlignment = Alignment
		l.Text = Values(I)
		l.Tag = I
		Header.AddView(l, ColumnWidth * I, 0, ColumnWidth - 1dip, RowHeight)
	Next
End Sub

Private Sub Cell_Click
	Dim rc As RowCol
	Dim l As Label
	l = Sender
	rc = l.Tag
	SelectRow(rc.Row)
	If SubExists(Callback, Event & "_CellClick", 2) Then
		CallSub3(Callback, Event & "_CellClick", rc.Col, rc.Row)
	End If
End Sub

Private Sub Header_Click
	Dim l As Label
	Dim col As Int
	l = Sender
	col = l.Tag
	If SubExists(Callback, Event & "_HeaderClick", 2) Then
		CallSub2(Callback, Event & "_HeaderClick", col)
	End If
End Sub

'Gets the value of the given cell.
Public Sub GetValue(Col As Int, Row As Int) As Object
	Dim values() As String
	values = Data.Get(Row)
	Return values(Col)
End Sub
'Sets the value of the given cell.
Public Sub SetValue(Col As Int, Row As Int, Value As String)
	Dim values() As String
	values = Data.Get(Row)
	values(Col) = Value
	If visibleRows.ContainsKey(Row) Then
		Dim lbls() As Label
		lbls = visibleRows.Get(Row)
		lbls(Col).Text = Value
	End If
End Sub

Private Sub SelectRow(Row As Int)
	Dim prev As Int
	prev = SelectedRow
	SelectedRow = Row
	'remove the color of previously selected row
	If prev > -1 Then
		If visibleRows.ContainsKey(prev) Then
			HideRow(prev)
			ShowRow(prev)
		End If
	End If
	SelectedRow = Row
	For col = 0 To NumberOfColumns - 1
		If visibleRows.ContainsKey(SelectedRow) Then
			HideRow(SelectedRow)
			ShowRow(SelectedRow)
		End If
	Next
End Sub

'Makes the given row visible.
Public Sub JumpToRow(Row As Int)
	SV.ScrollOffsetY = Row * RowHeight
End Sub

'Clears the previous table and loads the CSV file to the table.
'You should first add the Table to the activity before calling this method.
Public Sub LoadTableFromCSV(Dir As String, Filename As String, HeadersExist As Boolean)
	
	Dim List1 As List
	Dim h() As String
	If HeadersExist Then
		Dim headers As List
		List1 = StringUtils1.LoadCSV2(Dir, Filename, ",", headers)
		Dim h(headers.Size) As String
		For i = 0 To headers.Size - 1
			h(i) = headers.Get(i)
		Next
	Else
		List1 = StringUtils1.LoadCSV(Dir, Filename, ",")
		Dim firstRow() As String
		firstRow = List1.Get(0)
		Dim h(firstRow.Length) As String
		For i = 0 To firstRow.Length - 1
			h(i) = "Col" & (i + 1)
		Next
	End If
	innerClearAll(h.Length)
	ColumnWidth = SV.Width / NumberOfColumns
	SetHeader(h)
	For i = 0 To List1.Size - 1
		Dim row() As String
		row = List1.Get(i)
		AddRow(row)
	Next
End Sub

'Saves the table to a CSV file.
Public Sub SaveTableToCSV(Dir As String, Filename As String)
	Dim headers(NumberOfColumns) As String
	For i = 0 To headers.Length - 1
		Dim l As Label
		l = Header.GetView(i)
		headers(i) = l.Text
	Next
	StringUtils1.SaveCSV2(Dir, Filename, ",", Data, headers)
End Sub

