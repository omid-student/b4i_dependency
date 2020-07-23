Type=StaticCode
Version=1.8
ModulesStructureVersion=1
B4i=true
@EndOfDesignText@
'Code module

Sub Process_Globals
	Private cpd As Page
	Private p1 As Panel
	Private b0,b1, b2, b3,b4,b5,b6,b7,b8,b9,b10,b11,b12,b13,b14 As Button
	Private bCurr, bOK, bCancel As Button
	Private arrCol As List
	Public SelectedColor As Int
End Sub


Sub Show(head As String, DefaultColor As Int)
	If arrCol.IsInitialized = False Then
		arrCol.Initialize
	End If
	
	SelectedColor = DefaultColor
	SetupColorPalatte   'set up color palatte
	SetupButtons  'set up the buttons
	bInit(bCurr, "", DefaultColor)
	
	If cpd.IsInitialized = False Then
		cpd.Initialize("cpd")
	End If
	
	If p1.IsInitialized = False Then
		p1.Initialize("")
	End If
	
	If bOK.IsInitialized = False Then
		bOK.Initialize("bOK", bOK.STYLE_SYSTEM)
	End If
	bOK.Text = "Save"
	bOK.Color = Colors.White
	bOK.SetBorder(1, Colors.Black, 5)
	
	
	If bCancel.IsInitialized = False Then
		bCancel.Initialize("bCancel", bCancel.STYLE_SYSTEM)
	End If	
	bCancel.Text = "Cancel"
	bCancel.Color = Colors.White
	bCancel.SetBorder(1, Colors.Black, 5)
	
	
	
	p1.Color = Colors.Gray
	cpd.Title = head
	SetupViews	
		
	Main.NavControl.ShowPage(cpd)	

End Sub



Private Sub cpd_Resize(Width As Int, Height As Int)
	SetupViews
End Sub

Private Sub SetupViews
	cpd.RootPanel.RemoveAllViews
	cpd.RootPanel.AddView(p1, 0%x, 0 ,100%x, 100%y)


	p1.AddView(bCurr, 20%x, 10%y, 60%x, 10%y)
	p1.AddView(b0, 4%x, 25%y, 15%x, 10%y)
	p1.AddView(b1, 23%x, 25%y, 15%x, 10%y)
	p1.AddView(b2, 42%x, 25%y, 15%x, 10%y)
	p1.AddView(b3, 61%x, 25%y, 15%x, 10%y)
	p1.AddView(b4, 80%x, 25%y, 15%x, 10%y)

	p1.AddView(b5, 4%x, 40%y, 15%x, 10%y)
	p1.AddView(b6, 23%x, 40%y, 15%x, 10%y)
	p1.AddView(b7, 42%x, 40%y, 15%x, 10%y)
	p1.AddView(b8, 61%x, 40%y, 15%x, 10%y)
	p1.AddView(b9, 80%x, 40%y, 15%x, 10%y)

	p1.AddView(b10, 4%x, 55%y, 15%x, 10%y)
	p1.AddView(b11, 23%x, 55%y, 15%x, 10%y)
	p1.AddView(b12, 42%x, 55%y, 15%x, 10%y)
	p1.AddView(b13, 61%x, 55%y, 15%x, 10%y)
	p1.AddView(b14, 80%x, 55%y, 15%x, 10%y)
	
	
	p1.AddView(bCancel, 10%x, 75%y, 30%x, 10%y)
	p1.AddView(bOK, 60%x, 75%y, 30%x, 10%y)
	

End Sub


Private Sub bInit (b As Button, be As String, col As Int)
	If b.IsInitialized = False Then
			b.InitializeCustom(be, Colors.Black, Colors.DarkGray)
	End If
	b.color = col	
	b.SetBorder(1, Colors.Black, 5)
	b.Tag = col
End Sub


Private Sub SetupButtons
	'row1
	bInit(b0, "b0", arrCol.Get(0))
	bInit(b1, "b1", arrCol.Get(1))
	bInit(b2, "b2", arrCol.Get(2))
	bInit(b3, "b3", arrCol.Get(3))
	bInit(b4, "b4", arrCol.Get(4))
	'row 2
	bInit(b5, "b5", arrCol.Get(5))
	bInit(b6, "b6", arrCol.Get(6))
	bInit(b7, "b7", arrCol.Get(7))
	bInit(b8, "b8", arrCol.Get(8))
	bInit(b9, "b9", arrCol.Get(9))
	'row 3	
	bInit(b10, "b10", arrCol.Get(10))
	bInit(b11, "b11", arrCol.Get(11))
	bInit(b12, "b12", arrCol.Get(12))
	bInit(b13, "b13", arrCol.Get(13))
	bInit(b14, "b14", arrCol.Get(14))

End Sub

Private Sub SetupColorPalatte
		arrCol.Add(Colors.ARGB(255,255,1,1))
		arrCol.Add(Colors.Argb(255,255,1,255))
		arrCol.Add(Colors.Argb(255,255,140,1))
		arrCol.Add(Colors.Argb(255,153,51,204))
		arrCol.Add(Colors.Argb(255,1,1,1))
		'row2
		arrCol.Add(Colors.Argb(255,1,255,1))
		arrCol.Add(Colors.Argb(255,255,255,1))
		arrCol.Add(Colors.Argb(255,1,255,127))
		arrCol.Add(Colors.Argb(255,1,128,1)) 'darkgreen
		arrCol.Add(Colors.Argb(255,250,128,114)) 'salmon
		
		'row3
		arrCol.Add(Colors.Argb(255,1,1,255)) 'blue
		arrCol.Add(Colors.Argb(255,1,255,255)) 'lblue
		arrCol.Add(Colors.Argb(255,65,105,225)) 'mblue
		arrCol.Add(Colors.Argb(255,1,1,128)) 'dblue
		arrCol.Add(Colors.Argb(255,184,134,11)) 'brown
End Sub



Sub b0_Click
	bCurr.Color = b0.Tag
End Sub

Sub b1_Click
	bCurr.Color = b1.Tag
End Sub


Private Sub b2_Click
	bCurr.Color = b2.Tag
End Sub

Private Sub b3_Click
	bCurr.Color = b3.Tag
End Sub

Private Sub b4_Click
	bCurr.Color = b4.Tag
End Sub

Private Sub b5_Click
	bCurr.Color = b5.Tag
End Sub

Private Sub b6_Click
	bCurr.Color = b6.Tag
End Sub

Private Sub b7_Click
		bCurr.Color = b7.Tag
End Sub

Private Sub b8_Click
		bCurr.Color = b8.Tag
End Sub

Private Sub b9_Click
	bCurr.Color = b9.Tag
End Sub

Private Sub b10_Click
	bCurr.Color = b10.Tag
End Sub

Private Sub b11_Click
	bCurr.Color = b11.Tag
End Sub

Private Sub b12_Click
	bCurr.Color = b12.Tag
End Sub


Private Sub b13_Click
	bCurr.Color = b13.Tag
End Sub


Private Sub b14_Click
	bCurr.Color = b14.Tag
End Sub


Private Sub bCancel_Click
	Main.NavControl.RemoveCurrentPage
End Sub


Private Sub bOK_Click
	SelectedColor = bCurr.Color
	'if writing to file, write val of bCurr.Color
	Main.NavControl.RemoveCurrentPage	
End Sub